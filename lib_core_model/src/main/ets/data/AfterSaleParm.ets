/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AfterSaleParm
 * Author: Victor
 * Date: 2024/07/05 15:51
 * Description: 
 * -----------------------------------------------------------------
 */

export class AfterSaleParm {
  subOrderId?: number//子订单id
  afterSaleMode?: number//退款方式 1:仅退款
  appliedFee?: number//申请金额【单位：分】
  reason?: string//退款原因
  supplement?: string//补充描述
  voucherUrls?: string//凭证url 多个使用【,】分割
}