/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrderInfo
 * Author: Victor
 * Date: 2023/12/11 18:26
 * Description:
 * -----------------------------------------------------------------
 */
import { CourseTenantInfo } from './CourseTenantInfo'
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'
import { SubOrderInfo } from './SubOrderInfo'
export class OrderInfo {
  /**
   * 订单列表状态
   */

  commentFlag?: boolean
  discountsFee?: number//优惠金额【单位：分】
  coverUrl?: string//商品图片
  goodsName?: string//商品名称
  goodsNum?: number//购买商品数量
  goodsPrices?: number//商品价格【单位：分】
  goodsTotalFee?: number//商品总价【单位：分】
  goodsType?: number//商品类型
  orderNo?: string//订单号
  orderStatus?: number//订单状态 1?:未支付 2?:支付成功 3?:超时已关闭 4?:用户已取消 5?:退款中 6?:部分退款 7?:全部退款 8?:退款异常,
  //     9?:没有向第三方发起支付请求 => 未支付
  //    10?:退款金额异常 => 已完成
  //    11?:部分付款  => 部分付款
  //    12?:转课关闭 => 已完成
  orderTimeout?: number//订单超时剩余时间【单位：毫秒】
  payerTotal?: number//支付金额【单位：分】
  updatePeriod?: number//更新课时
  subOrderVos?: Array<SubOrderInfo>//横版封面存储路径
  /**
   *根据服务器返回的countdown换算成手机对应的开奖时间 (毫秒)
   *[正常情况最好由服务器返回countdown字段，然后客户端再校对成该手机对应的时间，不然误差很大]
   */
  endTime?: number

  goodsMode?: number//商品模式 0?:线上 1?:线下  只有待评价列表才有
  id?: string//订单id 只有待评价列表才有
  specName?: string//商品规格  只有待评价列表才有
  goodsId?: string//商品id  只有待评价列表才有
  ///////////////////////////////
  balanceFee?: number//订单余额【单位：分】
  paymentType?: number//支付类型 1:微信 2:阿里 3:赠送 4:抖店支付 5:快手支付 6:获客币支付
  channelSource?: number//渠道来源：1.抖店，2.快手，3.获客 4?:微店,5老用户，6销售录入，7小鹅通
  createTime?: string//创建时间
  payTime?: string//订单支付时间
  userPhone?: string//用户手机号

  coverUrlExtendVo?: CoverUrlExtendInfo
  tenantVO?: CourseTenantInfo
  tenantId?: number
  transferParentOrderNo?: string//转课订单号
  isShowInvoiceButton?: boolean//发票服务是否显示
  isShowLogistics?: boolean//物流服务是否显示
}