/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: MakeOutInvoiceParm
 * Author: Victor
 * Date: 2024/07/11 15:56
 * Description: 
 * -----------------------------------------------------------------
 */

export class MakeOutInvoiceParm {
  accountNumber?: string//开户账号（非必要）
  bankOfDeposit?: string//开户银行（非必要）
  invoiceTitle?: string//发票抬头
  orderNo?: string//订单编号
  receivingEmail?: string//开票人邮箱
  registeredAddress?: string//注册地址（非必要）
  registeredPhone?: string//注册电话（非必要）
  remarks?: string//备注
  taxId?: string//纳税人识别号
  invoiceAmount?: number//开票金额
  orderAmount?: number//订单金额
  invoiceType?: number//1.全电专票 2.全电普票
  personType?: number//1.个人 2.企业
  tenantId?: number//租户id
}