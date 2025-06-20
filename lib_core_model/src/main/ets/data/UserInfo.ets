/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: UserInfo
 * Author: Victor
 * Date: 2023/11/27 12?:24
 * Description:
 * -----------------------------------------------------------------
 */
@Observed
export class UserInfo {
  address?: string//详细地址
  areaName?: string//地区名称
  birthday?: number//生日
  cityCode?: string//城市编码 6位
  company?: string//公司
  headImg?: string//头像url
  idCard?: string//身份证号
  mailbox?: string//邮箱
  name?: string//用户名称
  introduce?: string//简介
  openId?: string//微信开放平台-open_id
  phone?: string//手机号
  position?: string//职位
  realName?: string//真实姓名
  sex?: number//1为男性，2为女性
  status?: number//用户状态 -1：删除 0：禁用 1：正常
  type?: number//用户类型
  collectionCount?: number//收藏数
  learningTime?: number//学习时长 单位：秒
  uid?: string//用户uid
  unionId?: string//微信开放平台-用户统一标识
  wechatNumber?: string//微信号-用户统一标识

  copy(): UserInfo {
    let data = new UserInfo()
    data.headImg = this.headImg
    data.name = this.name
    data.introduce = this.introduce
    data.sex = this.sex
    data.birthday = this.birthday
    data.areaName = this.areaName
    data.address = this.address
    data.company = this.company
    data.position = this.position
    data.phone = this.phone
    data.wechatNumber = this.wechatNumber
    data.mailbox = this.mailbox
    data.cityCode = this.cityCode
    data.idCard = this.idCard
    data.openId = this.openId
    data.realName = this.realName
    data.status = this.status
    data.type = this.type
    data.collectionCount = this.collectionCount
    data.learningTime = this.learningTime
    data.uid = this.uid
    data.unionId = this.unionId
    return data
  }
}