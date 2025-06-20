/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: RecommendCouponData
 * Author: Victor
 * Date: 2024/03/29 18:37
 * Description: 
 * -----------------------------------------------------------------
 */
import { CouponInfo } from './CouponInfo'
export class RecommendCouponData {
  discountFee?: number
  userCouponNoList?: Array<String>
  userCouponPageVos?: Array<CouponInfo>
}