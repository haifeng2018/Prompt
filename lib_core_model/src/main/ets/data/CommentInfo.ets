/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CommentInfo
 * Author: Victor
 * Date: 2023/12/27 11?:52
 * Description:
 * -----------------------------------------------------------------
 */
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'
export class CommentInfo {
  auditorState?: number//审核状态 1.未审核 2.审核通过 3.审核未通过
  contentType?: number//评价类型 1.有评论 2.有图片 3.有评价且有图片
  coverUrl?: string//商品主图
  coverUrlExtendVo?: CoverUrlExtendInfo//主图规格扩展
  goodsId?: string//商品ID
  goodsName?: string//商品名称
  imgNum?: number//评论图片数
  isDeleted?: number//删除标识 0.未删除 1.已删除
  isRecommend?: number//	是否推荐 0.未推荐(普通) 1.推荐
  imgs?: string//评论图片集合(JSON)
  markContent?: string//脱敏后的评价内容
  name?: string//用户名称
  orderNo?: string//订单号
  userId?: string//C端用户ID
  virHeadImg?: string//匿名头像url
  order?: number//图片评论顺序
  createAt?: number
}