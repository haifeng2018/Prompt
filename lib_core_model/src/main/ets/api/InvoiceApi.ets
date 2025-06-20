/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: UserApi
 * Author: Victor
 * Date: 2023/11/27 14:05
 * Description: 
 * -----------------------------------------------------------------
 */
export class InvoiceApi {
  static readonly INVOICE_PAGE = 'cloud/user/invoice/pf/page'
  static readonly SYNC_SIGN_INVOICE = 'cloud/user/invoice/syncSignInvoice'
  static readonly ORDER_INVOICE = 'cloud/user/invoice/getOrderInvoice'
  static readonly INVOICE_STATUS = 'cloud/user/invoice/getInvoiceStatus'
  static readonly INVOICE_COMPANY = 'cloud/user/invoice/get/company/info'
  static readonly MAKE_OUT_INVOICE = 'cloud/user/invoice/makeOutInvoice'
  static readonly SEND_INVOICE = 'cloud/user/invoice/reSendInvoice'
  static readonly INVOICE_ORDER_DETAIL = 'cloud/user/goods/order/detail/v4'
}