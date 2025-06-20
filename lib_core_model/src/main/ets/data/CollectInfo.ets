/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CollectInfo
 * Author: Victor
 * Date: 2023/12/04 19:58
 * Description:
 * -----------------------------------------------------------------
 */
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'
import { LecturerInfo } from './LecturerInfo'
export class CollectInfo {
  businessId?: string //商家id
  categoryId?: string //分类id
  columnContent?: string //专栏简介
  content?: string //详情
  contentName?: string //名称
  contentUrl?: string //详情图存储路径(用‘,’隔开)，online_flag==1生效，必须保存一张
  coverUrl?: string //横版封面存储路径
  coverVerticalUrl?: string //竖版封面存储路径
  createBy?: string //创建者
  createTime?: string //创建时间
  goodsId?: string //视频音频图文id
  specId?: string //规格id
  contentSettingFlag?: number //详情设置(0购买前查看完整商品详情，1购买前仅查看介绍内容)goods_type=1生效
  curriculumType?: number //选择类别(1基础课，2进阶课,3长期班，4讲座)
  delFlag?: number //是否删除(1已删除，0未删除)
  forwardFlag?: number //倍速播放/快进(0允许，1禁止)，goods_type=2生效
  fragmentTrialFlag?: number //片段试看(0开启，1关闭)，goods_type=2生效
  goodsPopularity?: number //人气
  goodsScore?: number //评分
  goodsTop?: number //小专栏是否被关联(0:未关联，1:已关联)
  goodsType?: number //0:图片,1:音频，2视频,3专栏，4大专栏，5公开课，6一对一，7落地班
  id?: number //id
  lampFlag?: number //防录屏跑马灯(0关闭，1开启)，goods_type=2生效
  learnExplain?: string //学习说明
  lecturerId?: string //讲师id
  lecturerName?: string //讲师名称
  marketPrice?: number //商品划线价 单位：分【online_flag==1生效】
  salePrice?: number //销售价格单位：分
  onlineFlag?: number //是否线上(0线上，1线下)
  preventionFlag?: number //文字防复制(0允许复制，1禁止复制)
  relationSaleFlag?: number //支持单独售卖((0开启，1关闭))
  saleFlag?: number //支持关联售卖((0开启，1关闭))
  shelveFlag?: number //0已上架，1已下架，2待上架
  shelveHaltFlag?: number //上架更多设置是否停售(0不停售，1停售)
  shelveHideFlag?: number //上架更多设置是否隐藏(0不隐藏，1隐藏)
  sortFlag?: number //内容更新顺序(0最新添加在前，1最新添加在后)
  materialId?: string //素材id(视频，音频)
  patchUrl?: string //视频贴片存储路径，goods_type=2生效
  remark?: string //备注
  shelveTime?: string //上架时间
  shelveTimingTime?: string //定时上架时间shelveFlag==2是生效
  shopId?: string //店铺id
  trialContent?: string //试看片段，goods_type=0生效
  updateBy?: string //更新者
  updateTime?: string //更新时间
  lecturers?: Array<LecturerInfo>
  coverUrlExtendVo?: CoverUrlExtendInfo
  tenantId?: number //机构id
}