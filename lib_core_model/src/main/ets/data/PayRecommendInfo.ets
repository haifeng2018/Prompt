/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PayRecommendInfo
 * Author: Victor
 * Date: 2024/04/01 11:54
 * Description:
 * -----------------------------------------------------------------
 */
import { LecturerInfo } from './LecturerInfo'
export class PayRecommendInfo {
  contentName?: string//名称
  coverUrl?: string//封面存储路径
  goodsId?: string//视频音频图文id
  goodsPopularity?: number//人气
  goodsScore?: number//评分
  goodsType?: number//0?:图片,1?:音频，2视频,3专栏，4大专栏
  lecturers?:Array<LecturerInfo>//讲师列表
  onlineFlag?: number//是否线上(0线上，1线下)
}