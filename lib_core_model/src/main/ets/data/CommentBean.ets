/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CommentBean
 * Author: Victor
 * Date: 2024/07/03 18:07
 * Description: 
 * -----------------------------------------------------------------
 */

export class CommentBean {
  tenantId?:number
  goodsId?: string//商品id
  id?: number//子订单id
  title?: string//标题
  cover?: string//商品封面
  orderNo?: string//订单号
  userPhone?: string//手机号
}