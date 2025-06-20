/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrderShowUtil
 * Author: Victor
 * Date: 2023/12/23 10:36
 * Description: 
 * -----------------------------------------------------------------
 */
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo'
import DateUtil from './DateUtil'
class OrderShowUtil {

  getOrderStatusName(data?: SubOrderInfo): string {
    let statusName = ''
    switch (data?.orderStatus) {
      case 1:
      case 9:
        statusName = '未支付'
        break
      case 2:
      case 10:
      case 12:
        statusName = '已完成'
        break
      case 3:
        statusName = '超时已关闭'
        break
      case 4:
        statusName = '用户已取消'
        break
      case 5:
        statusName = '退款中'
        break
      case 6:
        statusName = '部分退款'
        break
      case 7:
        statusName = '全部退款'
        break
      case 8:
        statusName = '退款异常'
        break
      case 11:
        statusName = '部分付款'
        break
    }

    return statusName
  }

  getOrderStatusColor(data?: SubOrderInfo): Resource {
    let statusColor: Resource = $r('app.color.color_999999')
    switch (data?.orderStatus) {
      case 1:
      case 3:
      case 5:
      case 9:
        statusColor = $r('app.color.color_F2B13F')
        break
      case 8:
        statusColor = $r('app.color.color_F53F3F')
        break
      default :
        statusColor = $r('app.color.color_999999')
        break
    }

    return statusColor
  }

  getAfterSaleOpacity(data?: SubOrderInfo,channelSource?: number,paymentType?: number): number {
    let opacity = 0
    switch (data?.orderStatus) {
      case 2:
      case 5:
      case 6:
      case 7:
      case 8:
      case 10:
      case 11:
      case 12:
        if (channelSource === 3 && (data?.payerTotal ?? 0) > 0 && paymentType != 6) {
          opacity = 1
        }
        break
      default :
        opacity = 0
        break
    }
    return opacity
  }

  getEvaluateVisibility(data?: SubOrderInfo): Visibility {
    let evaluateVisibility = Visibility.None
    switch (data?.orderStatus) {
      case 1:
      case 3:
      case 4:
      case 7:
      case 8:
      case 9:
        evaluateVisibility = Visibility.None
        break
      case 2:
      case 5:
      case 6:
      case 10:
      case 11:
      case 12:
      case 13:
        if (!data?.commentFlag) {
          evaluateVisibility = Visibility.Visible
        }
        break
      default :
        evaluateVisibility = Visibility.None
        break
    }
    return evaluateVisibility
  }

  getGoStudyVisibility(data?: SubOrderInfo): Visibility {
    let goStudyVisibility = Visibility.None
    switch (data?.orderStatus) {
      case 2:
      case 10:
      case 13:
        const showChangePerssionLog = data?.changePerssionLogVo?.showChangePerssionLog ?? false
        if (showChangePerssionLog) {
          goStudyVisibility = Visibility.None
        } else {
          if (data?.goodsMode === 1) {
            if (data?.withVideo) {
              goStudyVisibility = Visibility.Visible
            } else {
              goStudyVisibility = Visibility.None
            }
          } else {
            goStudyVisibility = Visibility.Visible
          }
        }
        break
      default :
        goStudyVisibility = Visibility.None
        break
    }
    return goStudyVisibility
  }

  /**
   * 我的订单-发票服务 是否显示
   * @param data
   * @returns
   */
  getInvoiceVisibility(isShowInvoiceButton?: boolean): Visibility {
    const isShowInvoice = isShowInvoiceButton ?? false
    if (isShowInvoice) {
      return Visibility.Visible
    }
    return Visibility.None
  }

  getChangePersonOperateBy(data?: SubOrderInfo): string {
    let operateBy = ''
    if (data?.changePerssionLogVo?.operateBy === 1) {
      operateBy = "操作人员：用户"
    } else if (data?.changePerssionLogVo?.operateBy === 2) {
      operateBy = "操作人员：客服"
    }
    return operateBy
  }

  getValidityPeriodTitle(data?: SubOrderInfo): string {
    let title = ''
    if ((data?.effectiveTime ?? 0) > 0 && (data?.failureTime ?? 0) > 0) {
      let effectiveTimeTxt = DateUtil.transNumberDate(data?.effectiveTime ?? 0)
      let failureTimeTxt = DateUtil.transNumberDate(data?.failureTime ?? 0)
      let today = DateUtil.getTimestamp()
      let isBeforeTodayDate = (data?.failureTime ?? 0) < today
      if (isBeforeTodayDate) {
        title = '已失效'
      } else {
        title = `${effectiveTimeTxt}至${failureTimeTxt}`
      }
    } else {
      title = '长期有效'
    }
    return title
  }

  getValidityPeriodTipOpacity(data?: SubOrderInfo): boolean {
    let opacity = false
    if ((data?.effectiveTime ?? 0) > 0 && (data?.failureTime ?? 0) > 0) {
      let today = DateUtil.getTimestamp()
      let isBeforeTodayDate = (data?.failureTime ?? 0) < today
      if (isBeforeTodayDate) {
        opacity = true
      }
    }
    return opacity
  }

  getPaywayTitle(paymentType?: number): string {
    let title = ''
    switch (paymentType) {
      case 1:
        title = '微信'
        break
      case 2:
        title = '支付宝'
        break
    }
    return title
  }

  getPayWayShow(orderStatus?: number): boolean {
    let show = false
    switch (orderStatus) {
      case 2:
      case 5:
      case 6:
      case 7:
        show = true
        break
      default :
        show = false
        break
    }
    return show
  }

  getPayTimeShow(orderStatus?: number): boolean {
    let show = false
    switch (orderStatus) {
      case 2:
      case 5:
      case 6:
      case 7:
        show = true
        break
      default :
        show = false
        break
    }
    return show
  }
}

export default new OrderShowUtil()