/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ListData
 * Author: Victor
 * Date: 2023/11/29 17:11
 * Description:
 * -----------------------------------------------------------------
 */
export class ListData <T> {
  total?: number//总记录数
  pageNum?: number//当前页号
  pageSize?: number//每页的数量
  size?: number//当前页的记录数量
  pages?: number//总页数
  current?: number
  hitCount?: Boolean = false
  searchCount?: Boolean = false
  records?: Array<T>
  items?: Array<T>
}