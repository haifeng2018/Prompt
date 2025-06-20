/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LastStudyInfo
 * Author: Victor
 * Date: 2023/11/22 15?:16
 * Description:
 * -----------------------------------------------------------------
 */
import { CourseTenantInfo } from './CourseTenantInfo'
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'
export class LastStudyInfo {
  accumulatedDuration?:number//累计播放时长
  finishFlag?:number//是否已经完成
  learningRate?: number//学习进度
  learningType?:number//学习状态?:1未学习，2学习中，3已完成
  goodsType?:number//0?:图片,1?:音频，2视频,3专栏，4大专栏，5线下课程
  lesson?:number//课时
  onlineFlag?:number//线上线下标志，0线上，1线下
  contentName?: string//商品标题
  coverUrl?: string//图片路径url
  goodsId?: string//商品编号
  lastPosition?: string//上一次播放时间，单位秒
  lecturerName?: string//讲师名称
  updateTime?: string//上一次播放时间
  subOrderId?: number//子订单编号
  coverUrlExtendVo?: CoverUrlExtendInfo
  withVideo?: boolean//线下课是否带视频 true-带 false-不带
  specName?: string//商品规格
  tenantVO?: CourseTenantInfo
}