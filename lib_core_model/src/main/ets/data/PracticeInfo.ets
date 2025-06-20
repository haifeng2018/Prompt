/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PracticeInfo
 * Author: Victor
 * Date: 2023/12/01 15:13
 * Description:
 * -----------------------------------------------------------------
 */
export class PracticeInfo {
  contentName?: string//商品名字
  goodsId?: string//商品id
  coverUrl?: string//封面url
  lecturerName?: string//教师名称
  statusMsg?: string//练习完成状态消息
  subject?: string//商品名字
  title?: string//商品名字
  statusCode?: number//练习完成状态 1,未完成；2，已完成
  onlineFlag?: number//是否线上(0线上，1线下)
  goodsType?: number//0?:图片,1?:音频，2视频,3专栏，4大专栏
  tenantId?: number//机构id
}