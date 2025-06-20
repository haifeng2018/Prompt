/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: InvoiceUtil
 * Author: Victor
 * Date: 2024/07/11 17:50
 * Description: 
 * -----------------------------------------------------------------
 */
import { OrderInvoiceData } from 'lib_core_model/src/main/ets/data/OrderInvoiceData'
import { browser } from '@kit.MDMKit'
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'

class InvoiceUtil {

  getPayerTotalShow(payerTotal: number): boolean {
    return payerTotal > 0
  }

  getTransferFeeShow(transferFee: number): boolean {
    return transferFee > 0
  }

  getRefundedFeeShow(refundedFee: number): boolean {
    return refundedFee > 0
  }

  getInvoiceApplyVisibility(showInvoiceButton: boolean): Visibility {
    let visibility = Visibility.None
    if (showInvoiceButton) {
      visibility = Visibility.Visible
    }
    return visibility
  }

  getInvoiceDetailEndStatusIcon(data?: OrderInvoiceData | null): Resource {
    const billingStatus = data?.invoiceVos?.[0]?.billingStatus ?? 0
    let endStatusIcon = $r('app.media.ic_invoice_focus')
    if (billingStatus == 1) {
      endStatusIcon = $r('app.media.ic_invoice_normal')
    }
    return endStatusIcon
  }

  getInvoiceDetailHeaderImage(data?: OrderInvoiceData | null): Resource {
    const billingStatus = data?.invoiceVos?.[0]?.billingStatus ?? 0
    let endStatusIcon = $r('app.media.img_not_invoiced_header')
    switch (billingStatus) {
      case 1:
        endStatusIcon = $r('app.media.img_invoicing_header')
        break
      case 2:
        endStatusIcon = $r('app.media.img_invoiced_header')
        break
    }
    return endStatusIcon
  }

  getInvoiceStatusIcon(data?: OrderInvoiceData | null): Resource {
    const billingStatus = data?.invoiceVos?.[0]?.billingStatus ?? 0
    let statusIcon = $r('app.media.img_detail_invoicing')
    switch (billingStatus) {
      case 1:
        statusIcon = $r('app.media.img_detail_invoicing')
        break
      case 2:
        statusIcon = $r('app.media.img_detail_invoiced')
        break
    }
    return statusIcon
  }

  getInvoiceStatus(data?: OrderInvoiceData | null): string {
    const billingStatus = data?.invoiceVos?.[0]?.billingStatus ?? 0
    let status = ''
    switch (billingStatus) {
      case 1:
        status = '开票中'
        break
      case 2:
        status = '开票完成'
        break
    }
    return status
  }

  getInvoiceAmount(data?: OrderInvoiceData | null): string {
    const info = data?.invoiceVos?.[0]
    const billingStatus = info?.billingStatus ?? 0
    const amount = `${AmountUtil.getRoundUp((info?.invoiceAmount ?? 0) / 100,2)}`
    let invoiceAmount = `可开票金额：￥${amount}`
    switch (billingStatus) {
      case 1:
        invoiceAmount = `申请开票金额：￥${amount}`
        break
      case 2:
        invoiceAmount = `已开票金额：￥${amount}`
        break
    }
    return invoiceAmount
  }

  getInvoiceType(data?: OrderInvoiceData | null): string {
    const info = data?.invoiceVos?.[0]
    let headType = ''
    switch (info?.invoiceType) {
      case 1:
        headType = '电子专票'
        break
      case 2:
        headType = '电子普票'
        break
    }
    return headType
  }

  getInvoiceHeadType(data?: OrderInvoiceData | null): string {
    const info = data?.invoiceVos?.[0]
    let headType = ''
    switch (info?.personType) {
      case 1:
        headType = '个人'
        break
      case 2:
        headType = '单位'
        break
    }
    return headType
  }

  getInvoiceImageShow(data?: OrderInvoiceData | null): boolean {
    const info = data?.invoiceVos?.[0]
    const billingStatus = info?.billingStatus ?? 0
    if (billingStatus == 2 && info?.ossInvoiceImage) {
      return true
    }
    return false
  }

  getSendEmailBtnVisibility(data?: OrderInvoiceData | null): Visibility {
    const info = data?.invoiceVos?.[0]
    const billingStatus = info?.billingStatus ?? 0
    if (billingStatus == 2 && info?.ossInvoiceImage) {
      return Visibility.Visible
    }
    return Visibility.None
  }

  getOrderStatus(orderStatus?: number): string {
    let status = ''
    switch (orderStatus) {
      case 0:
      case 2:
        status = '已支付'
        break
      case 1:
      case 9:
        status = '未支付'
        break
      case 3:
        status = '超时已关闭'
        break
      case 4:
        status = '用户已取消'
        break
      case 5:
        status = '退款中'
        break
      case 6:
        status = '部分退款'
        break
      case 7:
        status = '已退款'
        break
      case 8:
        status = '退款异常'
        break
      case 11:
        status = '部分付款'
        break
      default :
        status = '已支付'
        break
    }
    return status
  }
}

export default new InvoiceUtil()
