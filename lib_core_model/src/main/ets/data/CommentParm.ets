/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CommentParm
 * Author: Victor
 * Date: 2024/07/05 10:29
 * Description: 
 * -----------------------------------------------------------------
 */

export class CommentParm {
  content?: string//评论
  goodsId?: string//子订单号对应的商品ID
  userId?: string//
  id?: number//子订单id
  tenantId?: number
  level?: number//评论级别 1.好 2.中 3.差
  orderNo?: string//子订单号
  phone?: string//子订单号对应的手机号
  files?: Array<string>//评论图片地址
}