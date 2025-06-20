/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ClipboardUtil
 * Author: Victor
 * Date: 2024/07/08 14:59
 * Description: 
 * -----------------------------------------------------------------
 */
import { pasteboard } from '@kit.BasicServicesKit';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';

export class ClipboardUtil {
  TAG = 'ClipboardUtil'
  copy(copyValue: pasteboard.ValueType) {
    try {
      let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, copyValue);
      let systemPasteboard = pasteboard.getSystemPasteboard()
      systemPasteboard.setDataSync(pasteData)
      ToastUtils.show('已复制到剪贴板')
    } catch (err) {
      Logger.error(this.TAG,`Failed to copy value, Cause: ${err}`);
    }
  }
}
export default new ClipboardUtil()
