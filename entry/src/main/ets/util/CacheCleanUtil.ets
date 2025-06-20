/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CacheCleanUtil
 * Author: Victor
 * Date: 2023/12/01 17:27
 * Description: 
 * -----------------------------------------------------------------
 */

import storageStatistics from "@ohos.file.storageStatistics";
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import PreferenceUtil from 'lib_core_model/src/main/ets/util/PreferenceUtil';

class CacheCleanUtil {

  cleanCache() {
    PreferenceUtil.deletePreferences()
  }

  getAppCacheSize(onCacheSize: (size: string) => void) {
    storageStatistics.getCurrentBundleStats((err, bundleStats) => {
      if (err) {
        onCacheSize('')
        Logger.error('getAppCacheSize-err.code = ' + err.code)
        Logger.error('getAppCacheSize-err.message = ' + err.message)
      } else {
        onCacheSize(this.getFormatSize(bundleStats.cacheSize))
        Logger.error('getAppCacheSize-bundleStats.appSize = ' + bundleStats.appSize)
        Logger.error('getAppCacheSize-bundleStats.cacheSize = ' + bundleStats.cacheSize)
        Logger.error('getAppCacheSize-bundleStats.dataSize = ' + bundleStats.dataSize)
      }
    });
  }

  getFormatSize(size: number): string {

    let kiloByte = parseFloat(`${(size / 1024).toFixed(2)}`)
    if (kiloByte < 1) {
      return `${size}B`
    }

    let megaByte = parseFloat(`${(kiloByte / 1024).toFixed(2)}`)
    if (megaByte < 1) {
      return `${kiloByte}KB`
    }

    let gigaByte = parseFloat(`${(megaByte / 1024).toFixed(2)}`)
    if (gigaByte < 1) {
      return `${megaByte}MB`
    }

    let teraBytes = parseFloat(`${(gigaByte / 1024).toFixed(2)}`)
    if (teraBytes < 1) {
      return `${gigaByte}GB`
    }

    return `${teraBytes}TB`
  }
}

export default new CacheCleanUtil()