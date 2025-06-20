/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PreOrderParm
 * Author: Victor
 * Date: 2024/03/29 18:46
 * Description: 
 * -----------------------------------------------------------------
 */
import { Constants } from '../util/Constants'

export class PreOrderParm {
  orderNo?: string//订单号
  payerTotal?: number//支付金额【单位：分】
  paymentType?: number//支付类型 1:微信 2:阿里
  tradeType?: number//交易类型 1:app 2:小程序 3:h5 4:jsapi 12: 易宝支付（微信支付方式） 11：易宝支付（支付宝用户扫码方式）
  // yopPayAppId: string = Constants.YEE_PAY_APP_ID
}