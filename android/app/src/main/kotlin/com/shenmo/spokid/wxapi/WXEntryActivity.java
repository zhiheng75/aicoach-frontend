package com.shenmo.spokid.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.shenmo.spokid.BuildConfig;
import com.shenmo.spokid.entity.WechatBean;
import com.shenmo.spokid.utils.LogUtil;
import com.shenmo.spokid.wxUtils.WeChatLogin;
import com.shenmo.spokid.wxUtils.WeChatLoginResultListener;
import com.shenmo.spokid.wxUtils.WeChatPay;
import com.shenmo.spokid.wxUtils.WeChatSdk;
import com.shenmo.spokid.wxUtils.WeChatShare;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.modelmsg.ShowMessageFromWX;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import org.greenrobot.eventbus.EventBus;


public class WXEntryActivity extends Activity implements IWXAPIEventHandler {


//    private IWXAPI mWxApi  = WeChatSdk.Companion.getWechatSdk().getWxApi();

    private IWXAPI mWxApi;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
         mWxApi = WXAPIFactory.createWXAPI(this, BuildConfig.WXID, false);
        mWxApi.handleIntent(getIntent(),this);

    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        mWxApi.handleIntent(intent,this);
    }

    @Override
    public void onReq(BaseReq baseReq) {
        if(baseReq.getType() == ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX && baseReq instanceof ShowMessageFromWX.Req) {
            ShowMessageFromWX.Req showReq = (ShowMessageFromWX.Req) baseReq;
            WXMediaMessage mediaMsg = showReq.message;
            String extInfo = mediaMsg.messageExt;


        }
    }

    @Override
    public void onResp(BaseResp baseResp) {
        //结果
        if (baseResp == null) {
            finish();
            return;
        }
        LogUtil.INSTANCE.d("WechatEntryActivity ", "onResp baseResp.type = " + baseResp.getType());
        switch (baseResp.getType()){
            case ConstantsAPI.COMMAND_SENDAUTH:if (baseResp instanceof SendAuth.Resp) {
                WeChatLogin.Companion.executeLoginResp((SendAuth.Resp) baseResp,
                        new WeChatLoginResultListener() {
                            @Override
                            public void onSuccess(@Nullable String code) {
                                Toast.makeText(WXEntryActivity.this,"成功的值=="+code,
                                        Toast.LENGTH_SHORT).show();
                                if (code!=null&&!code.isEmpty()){
                                    EventBus.getDefault().post(new WechatBean(code));
                                }else {
                                    Toast.makeText(WXEntryActivity.this,"登录失败=code 为空",
                                            Toast.LENGTH_SHORT).show();
                                }

                            }

                            @Override
                            public void onCancel() {
                                Toast.makeText(WXEntryActivity.this,"取消登录",
                                        Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onError(@Nullable String error) {
                                Toast.makeText(WXEntryActivity.this,"登录失败="+error,
                                        Toast.LENGTH_SHORT).show();
                            }
                        });
            }
            case ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX:
                WeChatShare.Companion.executeShareResp(baseResp);
            case ConstantsAPI.COMMAND_PAY_BY_WX:
                WeChatPay.Companion.executePayResp(baseResp);
        }
        finish();
    }
}
