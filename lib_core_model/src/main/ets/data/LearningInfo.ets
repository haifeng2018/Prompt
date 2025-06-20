/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LearningInfo
 * Author: Victor
 * Date: 2023/11/30 14:29
 * Description:
 * -----------------------------------------------------------------
 */
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'
import { SubOrderInfo } from './SubOrderInfo'

export class LearningInfo extends SubOrderInfo {
  accumulatedDuration?: number//累计播放时长
  learningType?: number//学习状态?:1未学习，2学习中，3已完成
  lesson?: number//课时
  permissions?: number//课程权限 1?:保留 2?:解除
  shelveFlag?: number//上架设置(0已上架，1已下架，2待上架)
  outOfTime?: boolean//订单是否过期 true-过期 false-不过期
  coverVerticalUrl?: string//竖版封面存储路径
  createTime?: string//创建时间
  orderNo?: string//商户订单号
  payTime?: string//支付时间
  remark?: string//说明
  learningRate?: number//学习进度
  coverUrlExtendVo?: CoverUrlExtendInfo
  goodsName?: string
  specName?: string
  onlineFlag?: number
  goodsMode?: number
  withVideo?: boolean
  coverUrl?: string

  isBottom = false//是否是底部view
}