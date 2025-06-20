/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AliPayUtil
 * Author: Victor
 * Date: 2024/03/27 17:14
 * Description: 
 * -----------------------------------------------------------------
 */

import { paymentService } from '@kit.PaymentKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

class PayUtil {

  /**
   * 该方法提供单次支付、支付并签约等功能，调用方法前请确保网络已连接，
   * 调用该方法后会拉起Payment Kit收银台，支付完成后使用Promise异步返回。
   * @param context
   * @param orderStr
   * @returns
   */
  requestPayment(context: common.UIAbilityContext,orderStr: string): Promise<void> {
    // const orderStr = '{"app_id":"***","merc_no":"***","prepay_id":"xxx","timestamp":"1680259863114","noncestr":"1487b8a60ed9f9ecc0ba759fbec23f4f","sign":"****","auth_id":"***"}';
    return paymentService.requestPayment(context, orderStr)
  }

  /**
   * 该方法提供签约功能，调用方法前请确保网络已连接，
   * 调用该方法后会拉起Payment Kit签约收银台，签约完成后使用Promise异步返回。
   * @param context
   * @param contractStr
   * @returns
   */
  requestContract (context: common.UIAbilityContext,contractStr: string): Promise<void> {
    return paymentService.requestContract(context, contractStr)
  }

}

export default new PayUtil()