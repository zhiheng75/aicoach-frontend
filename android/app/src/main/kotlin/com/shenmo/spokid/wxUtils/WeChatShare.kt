package com.shenmo.spokid.wxUtils

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import com.shenmo.spokid.BuildConfig
import com.shenmo.spokid.utils.LogUtil
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelmsg.*
import com.tencent.mm.opensdk.openapi.IWXAPI
import java.io.*
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Executors


class WeChatShare {

    companion object {
        /**
         * 缩略图尺寸
         */
        private val THUMB_SIZE = 100

        var sWeChatShareResultListener: WeChatShareResultListener? = null

        private val executor = Executors.newSingleThreadExecutor()

        /**
         * 分享到微信
         */
        fun shareToWechat(
            api: IWXAPI,
            title: String,
            description: String,
            contentUrl: String,
            imageUrl: String,
            weChatShareResultListener: WeChatShareResultListener?
        ) {
            sWeChatShareResultListener = weChatShareResultListener
            share(api, title, description, contentUrl, imageUrl, SendMessageToWX.Req.WXSceneSession)
        }

        /**
         * 分享到朋友圈
         */
        fun shareToMoment(
            api: IWXAPI,
            title: String,
            description: String,
            contentUrl: String,
            imageUrl: String,
            weChatShareResultListener: WeChatShareResultListener?
        ) {
            sWeChatShareResultListener = weChatShareResultListener
            share(
                api,
                title,
                description,
                contentUrl,
                imageUrl,
                SendMessageToWX.Req.WXSceneTimeline
            )
        }

        /**
         * 分享到微信小程序
         */
        fun shareToMiniProgram(
            api: IWXAPI,
            title: String?,
            description: String?,
            path: String?,
            username: String?,
            contentUrl: String?,
            imageUrl: String,
            weChatShareResultListener: WeChatShareResultListener?
        ) {
            sWeChatShareResultListener = weChatShareResultListener
            val wxMiniProgramObject = WXMiniProgramObject()
            wxMiniProgramObject.userName = username
            wxMiniProgramObject.path = path
            if (BuildConfig.DEBUG) {
                wxMiniProgramObject.miniprogramType = WXMiniProgramObject.MINIPROGRAM_TYPE_PREVIEW
            } else {
                wxMiniProgramObject.miniprogramType = WXMiniProgramObject.MINIPTOGRAM_TYPE_RELEASE
            }
            wxMiniProgramObject.webpageUrl = contentUrl //网页链接
            val wxMediaMessage = WXMediaMessage(wxMiniProgramObject)
            wxMediaMessage.title = title
            wxMediaMessage.description = description
            if (imageUrl.startsWith("http")) {
                executor.execute { shareNetImage(wxMediaMessage, imageUrl) }
            }
            startShare(api, wxMediaMessage, SendMessageToWX.Req.WXSceneSession)
        }

        private fun share(
            api: IWXAPI,
            title: String,
            description: String,
            contentUrl: String,
            imageUrl: String,
            shareScene: Int
        ) {
            val wxMediaMessage = WXMediaMessage()
            wxMediaMessage.title = title
            wxMediaMessage.description = description
            // 区分本地图片和网络图片
            if (!imageUrl.startsWith("http") && (imageUrl.endsWith(".png") || imageUrl.endsWith(".jpg"))) {
                //本地图片分享
                executor.execute { shareLocalImage(wxMediaMessage, imageUrl,api, shareScene) }
            } else {
                val mediaObject = WXWebpageObject()
                mediaObject.webpageUrl = contentUrl
                wxMediaMessage.mediaObject = mediaObject
                //网络图片分享
                if (imageUrl.startsWith("http")) {
                    executor.execute { shareNetImage(wxMediaMessage, imageUrl) }
                }
            }
//            startShare(api, wxMediaMessage, shareScene)
        }

        private fun shareLocalImage(
            wxMediaMessage: WXMediaMessage,
            imagePath: String,
            api: IWXAPI,
            shareScene: Int
        ) {
            val imageFile = File(imagePath)
            var fis: FileInputStream? = null
            try {
                fis = FileInputStream(imageFile)
                val bitmap = BitmapFactory.decodeStream(fis)
                if (Build.VERSION.SDK_INT >= 21) {
                    //android 11 适配
                    val uri: Uri? = UriUtil.grantUri(
                        WeChatSdk.sContext!!,
                        imageFile, "com.tencent.mm"
                    )
                    val contentPath = uri.toString()
                    val wxObj = WXImageObject()
                    wxObj.setImagePath(contentPath)
                    wxMediaMessage.mediaObject = wxObj
                } else {
                    wxMediaMessage.mediaObject = WXImageObject(bitmap)
                }
                val thumbBmp = Bitmap.createScaledBitmap(bitmap, THUMB_SIZE, THUMB_SIZE, true)
                wxMediaMessage.thumbData = bmpToByteArray(thumbBmp, 95)
                bitmap.recycle()
                thumbBmp.recycle()
                startShare(api, wxMediaMessage, shareScene)
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                if (fis != null) {
                    try {
                        fis.close()
                    } catch (e: IOException) {
                        e.printStackTrace()
                    }
                }
            }
        }

        private fun shareNetImage(wxMediaMessage: WXMediaMessage, imageUrl: String) {
            val imageStream = getImageStream(imageUrl)
            if (imageStream != null) {
                val bitmap = BitmapFactory.decodeStream(imageStream)
                val scaledBitmap = Bitmap.createScaledBitmap(bitmap, THUMB_SIZE, THUMB_SIZE, true)
                wxMediaMessage.thumbData = bmpToByteArray(scaledBitmap, 95)
                bitmap.recycle()
                scaledBitmap.recycle()
            } else {
                LogUtil.d("WechatShare", "分享失败：图片路径无法解析")
            }
        }

        private fun startShare(api: IWXAPI, mediaMessage: WXMediaMessage, shareScene: Int) {
            val req = SendMessageToWX.Req()
            req.transaction = "webpage_" + System.currentTimeMillis()
            req.message = mediaMessage
            req.scene = shareScene
            api.sendReq(req)
        }

        private fun bmpToByteArray(bitmap: Bitmap, quality: Int): ByteArray? {
            val output = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, output)
            return output.toByteArray()
        }

        private fun getImageStream(imageUrl: String): InputStream? {
            try {
                val url = URL(imageUrl)
                val conn = url.openConnection() as HttpURLConnection
                conn.connectTimeout = 10 * 1000
                conn.requestMethod = "GET"
                if (conn.responseCode == HttpURLConnection.HTTP_OK) {
                    return conn.inputStream
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return null
        }
        fun saveBitmap(bitmap: Bitmap?, file: File?): Boolean {
            if (bitmap == null) return false
            var fos: FileOutputStream? = null
            try {
                fos = FileOutputStream(file)
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos)
                fos.flush()
                return true
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            } finally {
                if (fos != null) {
                    try {
                        fos.close()
                    } catch (e: IOException) {
                        e.printStackTrace()
                    }
                }
            }
            return false
        }

        fun saveBitmap1(bitmap: Bitmap?, absPath: String?): Boolean {
            return saveBitmap(bitmap, File(absPath))
        }

        /**
         * 处理微信分享结果
         */
        fun executeShareResp(baseResp: BaseResp) {
            if (sWeChatShareResultListener == null) return
            when (baseResp.errCode) {
                BaseResp.ErrCode.ERR_OK -> sWeChatShareResultListener!!.onSuccess()
                BaseResp.ErrCode.ERR_USER_CANCEL -> sWeChatShareResultListener!!.onCancel()
                else -> sWeChatShareResultListener!!.onError(baseResp.errStr)
            }
            sWeChatShareResultListener = null
        }
    }
}