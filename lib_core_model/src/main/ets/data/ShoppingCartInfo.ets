/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ShoppingCartInfo
 * Author: Victor
 * Date: 2023/11/24 17:59
 * Description:
 * -----------------------------------------------------------------
 */

import { CartDiscountInfo } from './CartDiscountInfo'
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'

export class ShoppingCartInfo {
  coverUrl?: string//封面存储路径
  currentMarketPrice?: number//商品划线价 单位：分
  currentSalePrice?: number//商品价格 单位：分
  goodsId?: string//商品编号
  goodsType?: number//0?:图片,1?:音频，2视频,3专栏，4大专栏
  lecturerLabel?: string//讲师label
  preMarketPrice?: number//加入购物车时的价格 单位：分
  preSalePrice?: number//加入购物车时的价格 单位：分
  onlineFlag?: number//1线下课程；0，线上课程
  quantity?: number//购物车数量
  goodsNum?: number//库存
  title?: string//标题
  specId?: string//规格id
  specName?: string//规格名称
  shelveFlag?: number//0已上架，1已下架，2待上架
  cartDiscountItem?: CartDiscountInfo
  coverUrlExtendVo?: CoverUrlExtendInfo

  selected?: boolean
}