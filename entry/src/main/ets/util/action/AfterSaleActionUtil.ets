/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AfterSaleActionUtil
 * Author: Victor
 * Date: 2024/07/05 14:06
 * Description: 
 * -----------------------------------------------------------------
 */
import App from 'lib_core_model/src/main/ets/App';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';

class AfterSaleActionUtil {

  afterSaleAction(subOrderInfo?: SubOrderInfo,tenantId?: number,orderNo?: string) {
    const id = subOrderInfo?.id ?? 0

    if (subOrderInfo?.afterSaleStatus === 1) {//可申请
      App.get().pushUrl({
        url: RouterPath.AFTER_SALE_PAGE,
        params: {
          data: subOrderInfo,
          orderNo: orderNo
        }
      })
    } else if (subOrderInfo?.afterSaleStatus === 2) {//申请中
      App.get().pushUrl({
        url: RouterPath.REFUND_PAGE,
        params: {
          subOrderId: id,
          tenantId:tenantId
        }
      })
    } else if (subOrderInfo?.afterSaleStatus === 3) {//已完成
      App.get().pushUrl({
        url: RouterPath.REFUND_PAGE,
        params: {
          subOrderId: id,
          tenantId:tenantId
        }
      })

    } else if (subOrderInfo?.afterSaleStatus === 4) {//用户关闭
      App.get().pushUrl({
        url: RouterPath.AFTER_SALE_ORDER_CLOSE_PAGE,
        params: {
        }
      })
    } else if (subOrderInfo?.afterSaleStatus === 5) {//超时关闭
      App.get().pushUrl({
        url: RouterPath.AFTER_SALE_PAGE,
        params: {
          data: subOrderInfo,
          orderNo: orderNo
        }
      })
    } else if (subOrderInfo?.afterSaleStatus === 6) {//拒绝退款
      App.get().pushUrl({
        url: RouterPath.REFUND_PAGE,
        params: {
          subOrderId: id,
          tenantId:tenantId
        }
      })
    }
  }
}

export default new AfterSaleActionUtil()