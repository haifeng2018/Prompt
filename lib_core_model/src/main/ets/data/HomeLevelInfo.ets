/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeLevelInfo
 * Author: Victor
 * Date: 2024/06/26 09:25
 * Description: 
 * -----------------------------------------------------------------
 */

export class HomeLevelInfo {
  levelName?: string//级别名称
  id?: string//主键
  parentId: number = 0//父类ID
  isViewAll: number = 0//是否展示全部 0 展示 1 不展示
  isViewShop: number = 0//是否展示店铺 0 展示 1 不展示
  sort: number = 0//排序
  childs?: Array<HomeLevelInfo>
}