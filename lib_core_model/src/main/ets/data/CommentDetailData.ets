/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CommentDetailData
 * Author: Victor
 * Date: 2024/07/05 10:38
 * Description: 
 * -----------------------------------------------------------------
 */

export class CommentDetailData {
  content?: string//评论内容
  goodsName?: string//商品名称
  lecturerName?: string//讲师名称
  imgList?: Array<string>//商品评价图
  level?: number//评论等级 1.好 2.中 3.差
}