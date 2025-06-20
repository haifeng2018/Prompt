/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AfterSaleLogInfo
 * Author: Victor
 * Date: 2024/07/05 15:47
 * Description: 
 * -----------------------------------------------------------------
 */

export class AfterSaleLogInfo {
  createTime?:number//创建时间
  goodsId?:string//商品id
  operate?:string//操作
  operatorId?:string//操作人id
  orderNo?:string//订单号
  operateObject?:boolean//操作对象 1：用户 2：客服
  refundFee?:number//退款金额【单位：分】
  afterSaleNo?:string//
  reason?:string//
  subOrderId?:string//
  approvalStatus?:number//审批结果 0:申请 1:同意 2:拒绝  4:取消申请
}