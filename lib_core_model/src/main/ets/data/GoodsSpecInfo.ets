/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: GoodsSpecInfo
 * Author: Victor
 * Date: 2023/11/17 18?:36
 * Description:
 * -----------------------------------------------------------------
 */
export class GoodsSpecInfo {
  id?: string//
  createBy?: string//创建者
  updateBy?: string//更新者
  delFlag?: number//是否删除(1已删除，0未删除)
  createTime?: string//创建时间
  updateTime?: string//更新时间
  goodsId?: string//商品信息关联id
  remark?: string//备注
  specId?: string//商品规格id
  specName?: string//规格名称
  goodsNum?: number//库存数量
  peopleNum?: number//人数
  salePrice?: number//商品价格 单位：分
  availableNum?: number//可用库存
}