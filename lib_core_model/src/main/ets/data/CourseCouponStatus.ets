/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseCouponStatus
 * Author: Victor
 * Date: 2023/12/28 17:31
 * Description: 
 * -----------------------------------------------------------------
 */
export enum CourseCouponStatus {
  NOT_CLAIMED = 1, // 未领取
  EXPIRED = 2, // 已过期
  ABOUT_TO_EXPIRED = 3, // 即将过期
  RECEIVED = 4, // 已领取
}