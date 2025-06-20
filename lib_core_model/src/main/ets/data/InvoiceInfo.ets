/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: InvoiceInfo
 * Author: Victor
 * Date: 2024/07/11 15:48
 * Description: 
 * -----------------------------------------------------------------
 */

export class InvoiceInfo {
  id?: number
  tenantId?: number
  invoiceType?: number
  personType?: number
  orderAmount?: number
  invoiceAmount?: number
  billingStatus?: number
  invoiceId?: string
  userId?: string
  name?: string
  invoiceTitle?: string
  taxId?: string
  registeredAddress?: string
  registeredPhone?: string
  bankOfDeposit?: string
  accountNumber?: string
  orderNo?: string
  collectingCompany?: string
  companyAccount?: string
  receivingEmail?: string
  timeOfBilling?: string
  ossInvoiceUrl?: string
  ossInvoiceImage?: string
  invoiceNumber?: string
  remarks?: string
}