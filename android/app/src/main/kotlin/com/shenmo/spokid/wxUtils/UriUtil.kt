package com.shenmo.spokid.wxUtils

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import androidx.core.content.FileProvider.getUriForFile
import java.io.File

class UriUtil {

    /**
     * 给文件赋予别的应用访问权限
     *
     * @param context     上下文
     * @param file        文件
     * @param packageName 别的应用包名
     * @return Uri
     */
    companion object {
        fun grantUri(context: Context, file: File?, packageName: String?): Uri? {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val uri: Uri = getUriForFile(
                    context,
                    context.packageName + ".WxFileProvider",
                    file!!
                )
                if (packageName != null) {
                    context.grantUriPermission(
                        packageName, uri,
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION
                    )
                }
                return uri
            }
            return Uri.fromFile(file)
        }
    }

}