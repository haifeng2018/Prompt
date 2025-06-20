/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: TeacherInfo
 * Author: Victor
 * Date: 2023/11/30 11?:42
 * Description:
 * -----------------------------------------------------------------
 */
export class TeacherInfo {
  backgroundUrl?: string//背景图存储路径
  briefIntroduction?: string//说明
  content?: string//详情
  coverUrl?: string//封面存储路径
  createBy?: string//创建者
  createTime?: number//创建时间
  lecturerId?: string//讲师id
  lecturerLabel?: string//老师标签
  lecturerName?: string//讲师名称
  remark?: string//备注
  updateBy?: string//更新者
  updateTime?: number//更新时间
  delFlag?: Boolean = false//是否删除(1已删除，0未删除)
  id?: number//id
  lecturerState?: Boolean = false//状态,0?:显示,1?:隐藏
  sort?: number//排序
}