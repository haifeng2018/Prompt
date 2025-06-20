/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: WatchHistoryInfo
 * Author: Victor
 * Date: 2023/11/22 17?:03
 * Description:
 * -----------------------------------------------------------------
 */
import { CourseTenantInfo } from './CourseTenantInfo'
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'
export class WatchHistoryInfo {
  updateTime?: number//上一次播放时间
  contentName?: string//商品标题
  coverUrl?: string//图片路径url
  goodsId?: string//商品编号
  lecturerName?: string//讲师名称
  finishFlag?: number//是否已经完成
  lastPosition?: number//上一次播放时间，单位秒
  onlineFlag?: number//线上线下标志，0线上，1线下
  goodsType?: number//
  coverUrlExtendVo?: CoverUrlExtendInfo
  tenantVO?: CourseTenantInfo
}