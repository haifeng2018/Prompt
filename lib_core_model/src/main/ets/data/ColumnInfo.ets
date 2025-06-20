/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ColumnInfo
 * Author: Victor
 * Date: 2023/11/17 18:38
 * Description:
 * -----------------------------------------------------------------
 */
@Observed
export class ColumnInfo {
  columnVos?: Array<ColumnInfo>//课程列表
  contentName?: string//名称
  contentSettingFlag?: number//详情设置(0购买前查看完整商品详情，1购买前仅查看介绍内容)goods_type=1生效
  coverUrl?: string//横版封面存储路径
  coverVerticalUrl?: string//竖版封面存储路径
  forwardFlag?: number//倍速播放/快进(0允许，1禁止)，goods_type=2生效
  fragmentTrialFlag?: number//片段试看(0开启，1关闭)，goods_type=2生效
  goodsId?: string//视频音频图文id
  goodsType?: number//0?:图片,1?:音频，2视频,3专栏，4大专栏
  lampFlag?: number//防录屏跑马灯(0关闭，1开启)，goods_type=2生效
  materialDes?: number//文件描述 如视频音频描述时长【00?:00?:19】 图片描述大小【1240*480】
  materialId?: string//素材id(视频，音频)
  materialSize?: number//素材文件大小
  materialUrl?: string//素材文件存储路径
  preventionFlag?: number//文字防复制(0允许复制，1禁止复制)
  trialContent?: string//试看片段，goods_type=0生效

  lesson?: number//课时
  isExpand?: boolean = true

  cGoodsId?: string//大专栏分组goodsId 本地试看使用
}