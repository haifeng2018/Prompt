/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PhoneUtil
 * Author: Victor
 * Date: 2023/11/27 15:43
 * Description: 
 * -----------------------------------------------------------------
 */

import call from '@ohos.telephony.call';

class PhoneUtil {
  /**
 * 手机号脱敏筛选正则
 */
  readonly PHONE_BLUR_REGEX = '(\\d{3})\\d{4}(\\d{4})'

  /**
   * 手机号脱敏替换正则
   */
  readonly PHONE_BLUR_REPLACE_REGEX = "$1****$2"

  /**
   * 手机号脱敏处理
   * @param phone
   * @return
   */
  blurPhone(phone: string): string {
    let regexp = new RegExp(this.PHONE_BLUR_REGEX)
    return phone?.replace(regexp, this.PHONE_BLUR_REPLACE_REGEX)
  }

  toCallPhone (phoneNum: string) {
    // 调用查询能力接口
    let isSupport = call.hasVoiceCapability()
    if (!isSupport) {
      console.info(" support voice capability, return")
      return;
    }
    // 如果设备支持呼叫能力，则继续跳转到拨号界面，并显示拨号的号码
    call.makeCall(phoneNum, (err)=> {
      if (!err) {
        console.info(" make call success.");
      } else {
        console.info("make call fail, err is:" + JSON.stringify(err));
      }
    });
  }

  callPhone (phoneNum: string) {
    call.dial(phoneNum, {
      extras: false
    }, (err, data) => {
      console.log(`callback: err->${JSON.stringify(err)}, data->${JSON.stringify(data)}`);
    });
  }
}

export default new PhoneUtil()