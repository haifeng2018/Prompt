/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AdData
 * Author: Victor
 * Date: 2024/05/14 17:32
 * Description: 
 * -----------------------------------------------------------------
 */
import { AdInfo } from './AdInfo'

export class AdData {
  adInfoVos?: Array<AdInfo>//广告集合
  createAt?: number//创建时间戳
  createTime?: string//创建时间
  name?: string//广告名称
  id?: number//广告管理id
  num?: number//现有广告数量
  maxNum?: number//允许最大广告数量
  type?: number//广告类型 1.Banner(横幅) 2.弹窗 3.开屏 4.瓷片区 5.金刚区
}