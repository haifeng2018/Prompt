/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PayInfo
 * Author: Victor
 * Date: 2024/03/29 19:00
 * Description:
 * -----------------------------------------------------------------
 */
export class PayInfo {
  appId?: string//小程序appId
  nonceStr?: string
  packageStr?: string
  partnerId?: string
  prepayId?: string
  sign?: string
  timeStamp?: string
  orderInfo?: string

  url?: string

  miniProgramOrgId?: string//小程序原始id
  miniProgramPath?: string//跳转小程序的路径
  orderId?: string
  prePayTn?: string
  uniqueOrderNo?: string
  message?: string
}