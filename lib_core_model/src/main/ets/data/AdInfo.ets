/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AdInfo
 * Author: Victor
 * Date: 2024/05/14 17:32
 * Description: 
 * -----------------------------------------------------------------
 */

export class AdInfo {
  adTitle?: string//广告标题
  displayTime?: string//显示时间
  fixedTime?: string//固定时间
  thumbnail?: string//视频缩略图首帧
  url?: string//视频缩略图首帧
  skipText?: string//跳转内容
  skipType?: number//跳转类型 1.课程详情 2.课程分类 3.网页 4.微信小程序 5.抖音小程序 6.推广页 7,专题
  fileType?: number//文件类型
  goodsType?: number//课程分类
  id?: number//广告id
  pid?: number//广告管理id
  skip?: number//跳转 0否 1是
  sort?: number//排序值
  longTerm?: number//是否长期有效 0否 1是

  onlineFlag?: number//服务端暂无此字段

  tenantId?: number
}