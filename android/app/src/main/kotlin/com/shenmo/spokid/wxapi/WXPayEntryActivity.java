package com.shenmo.spokid.wxapi;           // 这里改为你的包名

import android.app.Activity;
import android.os.Bundle;

import com.shenmo.spokid.BuildConfig;
import com.shenmo.spokid.utils.LogUtil;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;


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
        LogUtil.INSTANCE.d("das");
    }

    @Override
    public void onResp(BaseResp baseResp) {
        LogUtil.INSTANCE.d("da");
    }
}
