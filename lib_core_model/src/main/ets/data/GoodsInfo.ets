/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: GoodsInfo
 * Author: Victor
 * Date: 2023/11/17 18:25
 * Description:
 * -----------------------------------------------------------------
 */
import { ColumnInfo } from './ColumnInfo'
import { CourseTenantInfo } from './CourseTenantInfo'
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'
import { GoodsSpecInfo } from './GoodsSpecInfo'
import { LecturerInfo } from './LecturerInfo'
import { OfflineVideoInfo } from './OfflineVideoInfo'

@Observed
export class GoodsInfo {
  collectionFlag?: boolean
  cityNames?: string //城市名称
  content?: string //详情
  contentName?: string//名称
  contentUrl?: string//详情图存储路径(用‘,’隔开)，online_flag==1生效，必须保存一张
  coverUrl?: string//横版封面存储路径
  videoCoverUrl?: string//最新视频封面图（不区分线上、线下）
  coverVerticalUrl?: string//竖版封面存储路径
  columnContent?: string//课程简介名称
  patchUrl?: string//横版封面存储路径
  goodsId?: string//视频音频图文id
  specId?: string//商品规格
  goodsPopularity?: number//人气
  goodsScore?: number//评分
  goodsType?: number//0?:图片,1?:音频，2视频,3专栏，4大专栏,5线下课程
  learnExplain?: string//学习说明
  commentFlag?: boolean//是否已评论
  practiceFlag?: boolean//是否已提交练习
  fragmentTrialFlag?: number//片段试看(0开启，1关闭)
  salesVolume?: number//销量

  lecturers?: Array<LecturerInfo>
  specVos?: Array<GoodsSpecInfo>
  videoVos?: Array<OfflineVideoInfo>
  marketPrice?: number//商品划线价 单位：分
  salePrice?: number//商品价格 单位：分
  quantity?: number//添加到购物车数量
  orderNo?: string//订单号 有则是已购买 无则是未购买
  goldenSentence?: string//金句(多条用#号隔开)
  saleType?: number//类型 0免费,1,付费 2,加密 3,指定学员
  onlineFlag?: number//是否线上(0线上，1线下)
  columnParentVos?: Array<ColumnInfo>//专栏列表（即目录 goodsType=0，1，2时 columnListVos.size只会等于1）
  curriculumType?: number//选择类别(1基础课，2进阶课,3长期班，4讲座)
  subOrderId?: number
  lesson?: number//课时
  classHour?: number//课时
  validityDays?: number//购买后多少天有效
  postSaleType?: number//售后服务保障(专栏) 1.未学7天可用 2.不支持退款
  coverUrlExtendVos?: Array<CoverUrlExtendInfo>
  coverUrlExtendVo?: CoverUrlExtendInfo
  tenantVO?: CourseTenantInfo
  tenantId?: number
}