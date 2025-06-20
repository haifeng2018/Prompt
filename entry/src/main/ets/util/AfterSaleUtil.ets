/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AfterSaleUtil
 * Author: Victor
 * Date: 2024/07/05 14:38
 * Description: 
 * -----------------------------------------------------------------
 */
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'
import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import { AfterSaleDetailData } from 'lib_core_model/src/main/ets/data/AfterSaleDetailData'
import { RefundConditionData } from 'lib_core_model/src/main/ets/data/RefundConditionData'
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo'
import Logger from 'lib_core_model/src/main/ets/util/Logger'

class AfterSaleUtil {
  TAG = 'AfterSaleUtil'

  getTimeOutCellVisibility(data: RefundConditionData | null): boolean {
    if (this.getRefundEnable(data)) {
      //是否可退款
      return false
    }
    if (data?.goodsMode == 0 && !this.studyLess30Min(data) && this.payWithin7Days(data)) {
      //1、7天内学习总时长超过30分钟
      //2、支付成功7天内
      return false
    }

    if (data?.postSaleType === 5) {
      return true
    }

    return false
  }

  getStudy30MinsCellVisibility(data: RefundConditionData | null): boolean {
    if (this.getRefundEnable(data)) {
      //是否可退款
      return false
    }
    if (data?.goodsMode == 0 && !this.studyLess30Min(data) && this.payWithin7Days(data)) {
      //1、7天内学习总时长超过30分钟
      //2、支付成功7天内
      return true
    }

    return false
  }

  getExtendServicesCellVisibility(data: RefundConditionData | null): boolean {
    let show = false
    if (this.getRefundEnable(data)) {
      //是否可退款
      return false
    }
    if (data?.goodsMode == 0 && !this.studyLess30Min(data) && this.payWithin7Days(data)) {
      //1、7天内学习总时长超过30分钟
      //2、支付成功7天内
      return false
    }
    if (data?.postSaleType === 1) {
      if (this.payWithin7Days(data)) {
        if (data?.goodsMode == 1) {
          if (data?.deliveryStatus == 4) {
            show = false
          } else if (data?.deliveryStatus == 5) {
            show = false
          } else {
            show = true
          }
        } else {
          show = true
        }
      } else {
        if (data?.goodsMode == 1) {
          if (data?.deliveryStatus == 4) {
            show = false
          } else if (data?.deliveryStatus == 5) {
            show = false
          } else {
            show = true
          }
        } else {
          show = true
        }
      }
    } else {
      show = false
    }
    return show
  }

  getExtendConsultCellVisibility(data: RefundConditionData | null): boolean {
    let show = false
    if (this.getRefundEnable(data)) {
      //是否可退款
      return false
    }
    if (data?.goodsMode == 0 && !this.studyLess30Min(data) && this.payWithin7Days(data)) {
      //1、7天内学习总时长超过30分钟
      //2、支付成功7天内
      return false
    }

    if (data?.postSaleType === 1) {
      if (this.payWithin7Days(data)) {
        if (data?.goodsMode == 1) {
          if (data?.deliveryStatus == 4) {
            show = true
          } else if (data?.deliveryStatus == 5) {
            show = true
          } else {
            show = false
          }
        } else {
          show = false
        }
      } else {
        if (data?.goodsMode == 1) {
          if (data?.deliveryStatus == 4) {
            show = true
          } else if (data?.deliveryStatus == 5) {
            show = true
          } else {
            show = false
          }
        } else {
          show = false
        }
      }
    } else {
      show = false
    }
    return show
  }

  getNotSupportCellVisibility(data: RefundConditionData | null): boolean {
    if (this.getRefundEnable(data)) {
      //是否可退款
      Logger.error(this.TAG,'getNotSupportCellVisibility()......refundEnable = false')
      return false
    }
    if (data?.goodsMode == 0 && !this.studyLess30Min(data) && this.payWithin7Days(data)) {
      //1、7天内学习总时长超过30分钟
      //2、支付成功7天内
      Logger.error(this.TAG,'getNotSupportCellVisibility()......2')
      return false
    }

    if (data?.postSaleType === 2) {
      Logger.error(this.TAG,'getNotSupportCellVisibility()......3')
      return true
    }
    Logger.error(this.TAG,'getNotSupportCellVisibility()......4')
    return false
  }

  payWithin7Days(data: RefundConditionData | null): boolean {
    const payTime: number = data?.payTime ?? 0
    const currentTime = DateUtil.getTimestamp()
    const diffTime = currentTime - payTime
    //支付成功7天内
    const payWithin7Days = diffTime <= 7 * 24 * 60 * 60 * 1000
    return payWithin7Days
  }

  studyLess30Min(data: RefundConditionData | null): boolean {
    const duration: number = data?.duration ?? 0
    //学习时长不超过30分钟
    return duration <= 30 * 60
  }

  notDelivered(data: RefundConditionData | null): boolean {
    const deliveryStatus: number = data?.deliveryStatus ?? 0
    //待交付、延期交付
    return deliveryStatus == 1 || deliveryStatus == 3 || deliveryStatus == 0
  }

  hasAfterCard(data: RefundConditionData | null): boolean {
    const afterCardId: number = data?.afterCardId ?? 0
    //是否有售后卡
    return afterCardId > 0
  }

  getRefundEnable(data: RefundConditionData | null): boolean {
    Logger.error(this.TAG,'getRefundEnable()......')
    //有售后卡可以退款(线上课、线下课)
    if (this.hasAfterCard(data)) {
      Logger.error(this.TAG,'getRefundEnable()......hasAfterCard')
      return true
    }
    if (data?.postSaleType == 2) {
      Logger.error(this.TAG,'getRefundEnable()......postSaleType == 2')
      return false
    }
    //线上课
    //1、7天内学习总时长不超过30分钟
    //2、支付成功7天内
    if (data?.goodsMode == 0 && this.studyLess30Min(data) && this.payWithin7Days(data)) {
      Logger.error(this.TAG,'getRefundEnable()......线上课')
      return true
    }
    //线下课
    //1、7天内交付状态待交付，延期交付、未进交付的
    //2、支付成功7天内
    if (data?.goodsMode == 1 && this.payWithin7Days(data) && this.notDelivered(data)) {
      Logger.error(this.TAG,'getRefundEnable()......线下课')
      return true
    }
    Logger.error(this.TAG,'getRefundEnable()......5')
    return false
  }

  getAfterSaleTime(afterSaleTime: number): string {
    let time = ''
    if (afterSaleTime > 0) {
      const date = DateUtil.transNumberDateHMS(afterSaleTime)
      time = `${date} 前可退款`
    }
    return time
  }

  getStudyTime(duration: number): string {
    let time = ''
    if (duration > 0) {
      const mins = AmountUtil.getRoundUpNoZero(duration / 60,2)
      time = `当前学习时间：${mins}分钟`
    }
    return time
  }

  getOnlyRefundTip(data?: SubOrderInfo | null): string {
    const goodsPrices = AmountUtil.getRoundUp((data?.goodsPrices ?? 0) / 100,2)
    const discountsFee = AmountUtil.getRoundUp((data?.discountsFee ?? 0) / 100,2)
    return `商品金额¥${goodsPrices}，优惠金额${discountsFee}元`
  }

  getModifyOnlyRefundTip(data?: AfterSaleDetailData | null): string {
    const goodsPrices = AmountUtil.getRoundUp((data?.goodsPrices ?? 0) / 100,2)
    const discountsFee = AmountUtil.getRoundUp((data?.discountsFee ?? 0) / 100,2)
    return `商品金额¥${goodsPrices}，优惠金额${discountsFee}元`
  }

  getRefundReasonCheckIcon(reason?: string,selectReason?: string): Resource {
    if (reason === selectReason) {
      return $r('app.media.ic_pay_way_checked')
    }
    return $r('app.media.ic_pay_way_normal')
  }

  getOrderStatus(orderStatus?: number): string {
    let status = ''
    switch (orderStatus) {
      case 1: {
        status = '未支付'
        break
      }
      case 2: {
        status = '已完成'
        break
      }
      case 3: {
        status = '超时已关闭'
        break
      }
      case 4: {
        status = '用户已取消'
        break
      }
      case 5: {
        status = '退款中'
        break
      }
      case 6: {
        status = '已退款'
        break
      }
      case 7: {
        status = '退款异常'
        break
      }
    }
    return status
  }

  getRefundEndLineColor(orderStatus?: number): Resource {
    let endLineColor = $r('app.color.color_EDEDED')
    switch (orderStatus) {
      case 2:
      case 3:
      case 6:
        endLineColor = $r('app.color.color_E1F4EC')
        break
      default :
        endLineColor = $r('app.color.color_EDEDED')
        break
    }
    return endLineColor
  }

  getRefundEndStatusIcon(orderStatus?: number): Resource {
    let endStatusIcon = $r('app.media.ic_refund_flow_normal')
    switch (orderStatus) {
      case 2:
      case 3:
        endStatusIcon = $r('app.media.ic_refund_flow_focus')
        break
      case 6:
        endStatusIcon = $r('app.media.ic_reject_refund')
        break
      default :
        endStatusIcon = $r('app.media.ic_refund_flow_normal')
        break
    }
    return endStatusIcon
  }

  getRefundBottomActivityVisibility(orderStatus?: number): boolean {
    let visibility = true
    switch (orderStatus) {
      case 2:
      case 3:
      case 6:
        visibility = false
        break
      default :
        visibility = true
        break
    }
    return visibility
  }

  getVoucherUrls(imageUrls: Array<string>): string {
    let voucherUrls = ''
    imageUrls.forEach((value: string) => {

    })
    imageUrls.forEach((value: string,index: number) => {
      voucherUrls += `${value},`
    })
    if (voucherUrls.length > 0) {
      voucherUrls = voucherUrls.slice(0,voucherUrls.length - 1)
    }
    return voucherUrls
  }
}

export default new AfterSaleUtil()