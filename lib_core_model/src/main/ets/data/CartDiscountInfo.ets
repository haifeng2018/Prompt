/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CartDiscountInfo
 * Author: Victor
 * Date: 2023/11/24 18:00
 * Description: 
 * -----------------------------------------------------------------
 */
export class CartDiscountInfo {
  couponName?: string//优惠券名称
  couponNo?: string//优惠券编码
  discountContent?: string//优惠券编码
  userCouponNo?: string
  couponType?: number//优惠券种类(1:商品券，2:店铺券，3:直播券)
  discountFee?: number//优惠金额
  discountMethod?: number//优惠方式(1:满减，2:直减，3:折扣)
  directDiscountAmount?: number//直减,discountMethod为2使用
  fullAmount?: number//满多少的值,discountMethod为1使用
  fullDiscountAmount?: number//满多少的值,discountMethod为1使用
  discount?: number//折扣,discountMethod为3使用
}