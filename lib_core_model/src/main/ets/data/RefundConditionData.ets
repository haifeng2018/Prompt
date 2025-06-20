/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: RefundConditionData
 * Author: Victor
 * Date: 2024/07/05 15:55
 * Description: 
 * -----------------------------------------------------------------
 */
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'

export class RefundConditionData {
  afterCardId?: number//售后卡id
  afterCardcreateTime?: string//售后卡申请创建时间
  afterCardendTime?: string//售后卡申请截止时间
  createTime?: number//创建时间
  douOrderId?: string//抖音订单编号
  orderNo?: string//商户订单号
  payTime?: number//支付时间
  shopId?: string//店铺id
  transactionId?: string//支付系统交易单号
  updateTime?: string//更新时间
  userId?: string//用户id
  channelSource?: number//渠道来源：1.抖店，2.快手，3.获客 4:微店,5老用户，6销售录入，7小鹅通
  deliveryStatus?: number//交付状态，1.待交付，2.交付中，3.延期交付，4锁定交付，5已交付，6已关闭
  duration?: number//学习时长【单位：秒】
  goodsMode?: number//商品模式 0:线上 1:线下
  goodsNum?: number//商品数量
  goodsTotalFee?: number//商品总价【单位：分】
  goodsType?: number//0:图片,1:音频，2视频,3专栏，4大专栏，5线下课程
  id?: number//订单编号
  coverUrlExtendVo?: CoverUrlExtendInfo//主图规格扩展
  orderStatus?: number//订单状态 1:未支付 2:支付成功 3:超时已关闭 4:用户已取消 5:退款中 6:部分退款 7:全部退款 8:交易结束 9:没有向第三方发起支付请求 10:退款金额异常
  paymentType?: number//支付类型 1:微信 2:阿里 3:赠送 4:抖店支付 5:快手支付 6:获客币支付，7小鹅通支付
  postSaleType?: number//售后服务保障(专栏) 1.未学7天可用 2.不支持退款
}