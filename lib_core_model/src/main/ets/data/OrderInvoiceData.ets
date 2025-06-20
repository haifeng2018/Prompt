/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrderInvoiceData
 * Author: Victor
 * Date: 2024/07/11 15:47
 * Description: 
 * -----------------------------------------------------------------
 */
import { InvoiceInfo } from './InvoiceInfo'

export class OrderInvoiceData {
  showInvoiceButton?: boolean
  invoiceVos?: Array<InvoiceInfo>
  invoiceAmount?: number
}