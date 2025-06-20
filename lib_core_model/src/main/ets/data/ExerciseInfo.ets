/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ExerciseInfo
 * Author: Victor
 * Date: 2024/04/01 15:19
 * Description:
 * -----------------------------------------------------------------
 */
export class ExerciseInfo {
  createBy?: string//创建者
  createTime?: string//创建时间
  delFlag?: number//是否删除(1已删除，0未删除)
  goodsId?: string
  id?: number
  remark?: string//备注
  subject?: string//练习题目
  title?: string//练习标题
  updateBy?: string//更新者
  updateTime?: number//更新时间
}