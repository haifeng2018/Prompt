/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AppUtil
 * Author: Victor
 * Date: 2023/12/06 19:56
 * Description: 
 * -----------------------------------------------------------------
 */

import bundleManager from '@ohos.bundle.bundleManager';

class AppUtil {

  async getAppBundleInfo(callback:(bundleName?: string,versionName?: string,versionCode?: number) => void) {
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).then((bundleInfo)=>{
      let bundleName = bundleInfo?.appInfo?.name
      let versionName = bundleInfo?.versionName?.toString()
      let versionCode = bundleInfo?.versionCode
      callback(bundleName,versionName,versionCode)
    }).catch((error: string)=>{
      console.error("get bundleInfo failed,error is " + error)
    })
  }
}

export default new AppUtil()