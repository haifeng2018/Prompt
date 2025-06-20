/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ModifyAfterSaleParm
 * Author: Victor
 * Date: 2024/07/05 15:43
 * Description: 
 * -----------------------------------------------------------------
 */

export class ModifyAfterSaleParm {
  afterSaleMode?:number//退款方式 1:仅退款
  afterSaleNo?:string//售后单号
  reason?:string//退款原因
  supplement?:string//补充描述
  voucherUrls?:string//凭证url 多个使用【,】分割
  appliedFee?:number//申请金额【单位：分】
}