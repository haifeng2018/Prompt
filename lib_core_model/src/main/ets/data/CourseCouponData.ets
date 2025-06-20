/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseCouponData
 * Author: Victor
 * Date: 2023/12/28 17:15
 * Description: 
 * -----------------------------------------------------------------
 */
import { CouponInfo } from './CouponInfo'

export class CourseCouponData {
  clamiedExpireList?: Array<CouponInfo> //已领取未使用
  notClaimNotUseList?: Array<CouponInfo> //未使用未领取列表
}