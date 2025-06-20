/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AfterSaleDetailData
 * Author: Victor
 * Date: 2024/07/05 15:14
 * Description: 
 * -----------------------------------------------------------------
 */
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'

export class AfterSaleDetailData {
  subOrderId?: number//子订单id
  goodsMode?: number//0,线上，1，线下
  afterSaleMode?: number//退款方式 1:仅退款
  afterSaleType?: number//售后类型 1:用户主动退款 2:平台仲裁退款
  appliedFree?: number//申请金额【单位：分】
  payerTotal?: number//支付金额【单位：分】
  refundFree?: number//退款金额【单位：分】
  afterSaleNo?: string//售后单号
  createTime?: string//创建时间
  goodsId?: string//商品id
  orderNo?: string//商户订单号
  reason?: string//退款原因
  refundTime?: string//退款时间
  remark?: string//备注
  supplement?: string//补充描述
  updateTime?: string//更新时间
  coverUrl?: string//横版封面存储路径
  goodsName?: string//
  goodsNum?: number//
  goodsPrices?: number//商品价格【单位：分】
  appliedFee?: number//申请金额【单位：分】
  refundFee?: number//退款金额【单位：分】
  discountsFee?: number//优惠金额【单位：分】
  voucherUrls?: string//凭证url 多个使用【,】分割
  status?: number//售后状态 1:可申请 2: 申请中 3: 已完成 4:用户关闭 5:超时关闭 6: 拒绝退款
  coverUrlExtendVo?: CoverUrlExtendInfo
}