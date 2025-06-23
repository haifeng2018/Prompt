/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeTabModel
 * Author: Victor
 * Date: 2023/2/27 14:53
 * Description: 
 * -----------------------------------------------------------------
 */

export interface MemberPackageItem {
  type: string;
  amount: number;
  unit: string;
}

export interface PrivilegeItem {
  icon: Resource,
  title: string;
  describe: string;
}

export const MemberPackageList: MemberPackageItem[] = [
  {
    type: '月卡',
    amount: 30,
    unit: '1.00元/天',
  },
  {
    type: '年卡',
    amount: 168,
    unit: '0.47元/天',
  },
  {
    type: '终生卡',
    amount: 268,
    unit: '0.01元/天',
  }
]

export const PrivilegeList: PrivilegeItem[] = [
  {
    icon: $r('app.media.ic_complete'),
    title: '录制模式',
    describe: '边看边录，视频拍摄神器'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: '图片转台词',
    describe: '图片智能识别转台词'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: 'AI跟读',
    describe: '台词跟着语速走，随机应变'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: '宫格切图',
    describe: '宫格切图 随心所选'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: '视频转台词',
    describe: '视频直接转台词，告别手打'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: '视频滤镜',
    describe: '视频镜像显示'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: '语音转台词',
    describe: '语音直接转台词，告别手打'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: '修改封面',
    describe: '你的封面你做主'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: '语音输入台词',
    describe: '语音输入自动转成台词'
  },
  {
    icon: $r('app.media.ic_complete'),
    title: '持续更新',
    describe: '敬请期待~'
  }

]