package com.shenmo.spokid.wxapi;           // 这里改为你的包名

import android.app.Activity;
import android.media.metrics.Event;
import android.os.Bundle;
import android.widget.Toast;

import com.shenmo.spokid.BuildConfig;
import com.shenmo.spokid.entity.WxPayResultBean;
import com.shenmo.spokid.utils.LogUtil;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import org.greenrobot.eventbus.EventBus;


public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {


    private IWXAPI mWxApi;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mWxApi = WXAPIFactory.createWXAPI(this, BuildConfig.WXID, false);
        mWxApi.handleIntent(getIntent(),this);

    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
//        LogUtil.INSTANCE.d("da");
        EventBus.getDefault().post(new WxPayResultBean(baseResp.errCode));
//        if (baseResp.errCode == BaseResp.ErrCode.ERR_OK) {
//            Toast.makeText(this, "支付成功", Toast.LENGTH_LONG).show();
//        } else {
//            Toast.makeText(this, "支付失败", Toast.LENGTH_LONG).show();
//        }
        finish();

    }
}
