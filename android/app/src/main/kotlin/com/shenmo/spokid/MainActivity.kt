package com.shenmo.spokid

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.text.TextUtils
import android.util.Log
import android.view.ViewGroup
import android.widget.*
import androidx.annotation.NonNull
import cn.jiguang.verifysdk.api.JVerificationInterface
import cn.jiguang.verifysdk.api.JVerifyUIConfig
import com.alipay.sdk.app.PayTask
import com.shenmo.spokid.entity.*
import com.shenmo.spokid.utils.JsonUtils
import com.shenmo.spokid.utils.OrderInfoUtil2_0
import com.tencent.mm.opensdk.modelmsg.SendAuth
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode


class MainActivity: FlutterActivity() , MethodChannel.MethodCallHandler{

    private val batteryChannelName = "flutter.jumpto.android"
    private lateinit var mResult: MethodChannel.Result

    private val SDK_PAY_FLAG = 1
    private val SDK_AUTH_FLAG = 2

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        EventBus.getDefault().register(this)
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, batteryChannelName)
        channel.setMethodCallHandler(this)

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        mResult = result
        if (call.method == "jumpToAndroidPage") {


            result.success("跳转")
        } else if (call.method == "jumpToWechatLogin") {

            val sWxApi = WXAPIFactory.createWXAPI(this, BuildConfig.WXID, false)
            sWxApi.registerApp(BuildConfig.WXID)
//            Toast.makeText(context,BuildConfig.WXID,Toast.LENGTH_SHORT).show()
            val req = SendAuth.Req()
            req.scope = "snsapi_userinfo"
            req.state = "wx_login"
            sWxApi.sendReq(req)
        }else if(call.method == "jumpToWechatPay"){

            /**
             * 微信支付
             *
             * @param partnerId               商户号
             * @param prepayId                预支付交易会话ID
             * @param nonceStr                随机字符串
             * @param timeStamp               时间戳
             * @param sign                    签名
             */
            call.arguments?.apply {
                val partnerId: String
                val prepayId: String
                val nonceStr: String
                val timeStamp: String
                val sign: String

                if (this is String && this.isNotEmpty()){
                     JsonUtils.fromJson<WxPayBean>(this.toString())?.apply {

//                    if (this is Map<*,*>&&this.isNotEmpty()){
                         partnerId = this.partnerid// this["partnerId"]?.toString()?:""
                         prepayId = this.prepay_id// this["prepayId"]?.toString()?:""
                         nonceStr = this.noncestr// this["nonceStr"]?.toString()?:""
                         timeStamp = this.timestamp// this["timeStamp"]?.toString()?:""
                         sign =this.sign//  this["sign"]?.toString()?:""

                         val sWxApi = WXAPIFactory.createWXAPI(this@MainActivity, BuildConfig.WXID, false)
                         sWxApi.registerApp(BuildConfig.WXID)
                         val req = PayReq()
                         req.appId = BuildConfig.WXID
                         req.partnerId = partnerId
                         req.prepayId = prepayId
                         req.nonceStr = nonceStr
                         req.timeStamp = timeStamp
                         req.packageValue = "Sign=WXPay"
                         req.sign = sign
                         sWxApi.sendReq(req) //发起调用微信支付了

//                    }
                     }


                }


            }

        }else if(call.method == "jumpToALiPay"){

            call.arguments?.apply {
                if (this is String && this.isNotEmpty()){
                    JsonUtils.fromJson<ALiPayBean>(this.toString())?.apply {

                        val payRunnable = Runnable {
                            val alipay = PayTask(this@MainActivity)
                            val result = alipay.payV2(prepay_url, true)
//                            Log.i("msp", result.toString())
                            val msg = Message()
                            msg.what = SDK_PAY_FLAG
                            msg.obj = result
                            mHandler.sendMessage(msg)
                        }


                        val payThread = Thread(payRunnable)
                        payThread.start()
                    }
                }
            }
        }

        else if(call.method == "keyLogin"){
            JVerificationInterface.setCustomUIWithConfig(
                getDialogPortraitConfig(),
            )
            JVerificationInterface.loginAuth(
                this
            ) { code, token, operator ->
//                Log.e(
//                    "MainActivity.TAG",
//                    "onResult: code=$code,token=$token,operator=$operator"
//                )
                val errorMsg = "operator=$operator,code=$code\ncontent=$token"
                runOnUiThread {
//                    mProgressbar.setVisibility(View.GONE)
//                    btnLoginDialog.setEnabled(true)
//                    btnLogin.setEnabled(true)
//                    if (code == Constants.CODE_LOGIN_SUCCESS) {
//                        toSuccessActivity(Constants.ACTION_LOGIN_SUCCESS, token)
//                        Log.e(MainActivity.TAG, "onResult: loginSuccess")
//                    } else if (code != Constants.CODE_LOGIN_CANCELD) {
//                        Log.e(MainActivity.TAG, "onResult: loginError")
//                        toFailedActivigy(code, token)
//                    }
                }
            }
        }
        else {
            result.notImplemented()
        }
    }


    @Subscribe(threadMode = ThreadMode.MAIN)
    fun wechatResult(bean : WechatBean){
        mResult.success(bean.resultCode)
    }


    // int ERR_OK = 0;
    //        int ERR_COMM = -1;
    //        int ERR_USER_CANCEL = -2;
    //        int ERR_SENT_FAILED = -3;
    //        int ERR_AUTH_DENIED = -4;
    //        int ERR_UNSUPPORT = -5;
    //        int ERR_BAN = -6;
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun  wechatPayResult(bean: WxPayResultBean){
//        when(bean){
//            0->{
                mResult.success(bean.code)
//            }
//        }
    }

    override fun onDestroy() {
        super.onDestroy()
        EventBus.getDefault().unregister(this)
    }

    private fun getDialogPortraitConfig(): JVerifyUIConfig? {
//        val widthDp: Int = px2dip(this, winWidth)
        val widthDp: Int = 300
        val uiConfigBuilder =
            JVerifyUIConfig.Builder().setDialogTheme(widthDp - 60, 300, 0, 0, false)
        //        uiConfigBuilder.setLogoHeight(30);
//        uiConfigBuilder.setLogoWidth(30);
//        uiConfigBuilder.setLogoOffsetY(-15);
//        uiConfigBuilder.setLogoOffsetX((widthDp-40)/2-15-20);
//        uiConfigBuilder.setLogoImgPath("logo_login_land");
        uiConfigBuilder.setLogoHidden(true)
        uiConfigBuilder.setNumFieldOffsetY(104).setNumberColor(Color.BLACK)
        uiConfigBuilder.setSloganOffsetY(135)
        uiConfigBuilder.setSloganTextColor(-0x2f2f27)
        uiConfigBuilder.setLogBtnOffsetY(161)
        uiConfigBuilder.setPrivacyOffsetY(15)
        uiConfigBuilder.setCheckedImgPath("cb_chosen")
        uiConfigBuilder.setUncheckedImgPath("cb_unchosen")
        uiConfigBuilder.setNumberColor(-0xdddcd8)
        uiConfigBuilder.setLogBtnImgPath("selector_btn_normal")
        uiConfigBuilder.setPrivacyState(true)
        uiConfigBuilder.setLogBtnText("一键登录")
        uiConfigBuilder.setLogBtnHeight(44)
        uiConfigBuilder.setLogBtnWidth(250)
        uiConfigBuilder.setAppPrivacyColor(-0x44433b, -0x766701)
        uiConfigBuilder.setPrivacyText("登录即同意《","》并授权Spokid获取本机号码")
        uiConfigBuilder.setPrivacyCheckboxHidden(true)
        uiConfigBuilder.setPrivacyTextCenterGravity(true)
        //        uiConfigBuilder.setPrivacyOffsetX(52-15);
        uiConfigBuilder.setPrivacyTextSize(10)


        // 图标和标题
        val layoutTitle = LinearLayout(this)
        val layoutTitleParam = RelativeLayout.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        layoutTitleParam.setMargins(0,  50, 0, 0)
        layoutTitleParam.addRule(RelativeLayout.ALIGN_PARENT_TOP, RelativeLayout.TRUE)
        layoutTitleParam.addRule(RelativeLayout.CENTER_HORIZONTAL, RelativeLayout.TRUE)
        layoutTitleParam.layoutDirection = LinearLayout.HORIZONTAL
        layoutTitle.layoutParams = layoutTitleParam
        val img = ImageView(this)
        img.setImageResource(R.drawable.logo_login_land)
        val tvTitle = TextView(this)
        tvTitle.text = "Spokid"
        tvTitle.textSize = 19f
        tvTitle.setTextColor(Color.BLACK)
        tvTitle.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD))
        val imgParam = LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
//        imgParam.setMargins(0, 0, dp2Pix(this, 6f), 0)
        imgParam.setMargins(0, 0, 6, 0)
        val titleParam = LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        imgParam.setMargins(0, 0,  4, 0)
        layoutTitle.addView(img, imgParam)
        layoutTitle.addView(tvTitle, titleParam)
        uiConfigBuilder.addCustomView(layoutTitle, false, null)

        // 关闭按钮
        val closeButton = ImageView(this)
        val mLayoutParams1 = RelativeLayout.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        mLayoutParams1.setMargins(0, 10,  10, 0)
        mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT, RelativeLayout.TRUE)
        mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_TOP, RelativeLayout.TRUE)
        closeButton.layoutParams = mLayoutParams1
        closeButton.setImageResource(R.drawable.btn_close)
        uiConfigBuilder.addCustomView(closeButton, true, null)
        return uiConfigBuilder.build()
    }


    @SuppressLint("HandlerLeak")
    private val mHandler: Handler = object : Handler() {
        override fun handleMessage(msg: Message) {
            when (msg.what) {
                SDK_PAY_FLAG -> {
                    val payResult = PayResult(msg.obj as Map<String?, String?>)

                    /**
                     * 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                     */
                    val resultInfo: String = payResult.result // 同步返回需要验证的信息
                    val resultStatus: String = payResult.resultStatus
                    // 判断resultStatus 为9000则代表支付成功
                    if (TextUtils.equals(resultStatus, "9000")) {
                        // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
//                        showAlert(
//                            this@MainActivity,
//                            "支付成功:$payResult"
//                        )
//                        mResult.success(resultStatus.code)
                        mResult.success(0)
//                        Toast.makeText(this@MainActivity,"支付成功",Toast.LENGTH_SHORT).show()
                    } else {
                        // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
//                        Toast.makeText(
//                            this@MainActivity,
//                            "支付失败$payResult", Toast.LENGTH_SHORT
//                        ).show()
                        mResult.success(1)
                    }
                }
                SDK_AUTH_FLAG -> {
//                    val authResult = AuthResult(msg.obj as Map<String?, String?>, true)
//                    val resultStatus: String = authResult.getResultStatus()
//
//                    // 判断resultStatus 为“9000”且result_code
//                    // 为“200”则代表授权成功，具体状态码代表含义可参考授权接口文档
//                    if (TextUtils.equals(
//                            resultStatus,
//                            "9000"
//                        ) && TextUtils.equals(authResult.getResultCode(), "200")
//                    ) {
//                        // 获取alipay_open_id，调支付时作为参数extern_token 的value
//                        // 传入，则支付账户为该授权账户
//                        com.alipay.sdk.pay.demo.PayDemoActivity.showAlert(
//                            this@PayDemoActivity,
//                            getString(R.string.auth_success) + authResult
//                        )
//                    } else {
//                        // 其他状态值则为授权失败
//                        com.alipay.sdk.pay.demo.PayDemoActivity.showAlert(
//                            this@PayDemoActivity,
//                            getString(R.string.auth_failed) + authResult
//                        )
//                    }
                }
                else -> {}
            }
        }
    }

}
