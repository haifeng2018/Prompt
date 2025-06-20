/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: InvoicePageInfo
 * Author: Victor
 * Date: 2024/07/11 10:30
 * Description: 
 * -----------------------------------------------------------------
 */

export class InvoicePageInfo {
  id?: number
  tenantId?: number
  billingStatus?: number//0.未开票 1.开票中 2.已开票
  orderAmount?: number//可开票金额(订单余额)
  goodsName?: string//商品名称
  orderNo?: string//订单号
  goodsUrlList?: Array<string>//图片地址
}