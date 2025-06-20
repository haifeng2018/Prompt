/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CommentListParm
 * Author: Victor
 * Date: 2023/12/29 10?:19
 * Description:
 * -----------------------------------------------------------------
 */
export class CommentListParm {
  asc?: Array<string>
  ascs?: Array<string>
  desc?: Array<string>
  descs?: Array<string>
  goodsId?: string//商品ID
  hitCount?: boolean
  optimizeCountSql?: boolean = false//
  level?: number | null//评论等级 1.好 2.中 3.差
  pages?: number
  current?: number//当前页
  size?: number//
}