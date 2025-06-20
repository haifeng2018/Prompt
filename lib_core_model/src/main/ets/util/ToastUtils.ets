/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ToastUtils
 * Author: Victor
 * Date: 2023/12/06 10:57
 * Description: 
 * -----------------------------------------------------------------
 */
import promptAction from '@ohos.promptAction'
export class ToastUtils {
  show(message: string | Resource,duration?: number) {
    promptAction.showToast({message: message,duration: duration ? duration : 1500})
  }
}

export default new ToastUtils()