/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseCategoryInfo
 * Author: Victor
 * Date: 2023/11/30 18:06
 * Description:
 * -----------------------------------------------------------------
 */
export class CourseCategoryInfo {
  catalogueId?: string//目录id
  catalogueName?: string//目录名称
  catalogueSort?: number//显示顺序
  catalogueUrl?: string//目录图标存储路径
  id?: number//主键id
  parentId?: number//父id
  catalogueListVos?: Array<CourseCategoryInfo>
}