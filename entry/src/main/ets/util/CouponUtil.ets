/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CouponUtil
 * Author: Victor
 * Date: 2023/12/04 15:11
 * Description: 
 * -----------------------------------------------------------------
 */
import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo'
import { CourseCouponStatus } from 'lib_core_model/src/main/ets/data/CourseCouponStatus'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'

class CouponUtil {
  getCouponTypeTxt(discountMethod?: number): string {
    let couponType = ''
    //1:满减，2:直减，3:折扣
    switch (discountMethod) {
      case 1: {
        couponType = '满减券'
        break
      }
      case 2: {
        couponType = '直减券'
        break
      }
      case 3: {
        couponType = '折扣券'
        break
      }
    }
    return couponType
  }

  getCouponTitle(data?: CouponInfo): string {
    let couponDes = ''
    //1:满减，2:直减，3:折扣
    switch (data?.discountMethod) {
      case 1: {
        let fullAmount = AmountUtil.getRoundUpNoZero((data.fullAmount ?? 0) / 100, 2)
        let fullDiscountAmount = AmountUtil.getRoundUpNoZero((data?.fullDiscountAmount ?? 0) / 100, 2)
        couponDes = `购买满${fullAmount}元减${fullDiscountAmount}元`
        break
      }
      case 2: {
        let directDiscountAmount = AmountUtil.getRoundUpNoZero((data?.directDiscountAmount ?? 0) / 100, 2)
        couponDes = `购买立减${directDiscountAmount}元`
        break
      }
      case 3: {
        couponDes = `购买立享${data?.discountContent}折`
        break
      }
    }
    return couponDes
  }

  getCouponValue(data?: CouponInfo): string {
    let couponTitle = ''
    //1:满减，2:直减，3:折扣
    switch (data?.discountMethod) {
      case 1: {
        let fullDiscountAmount = AmountUtil.getRoundUpNoZero((data?.fullDiscountAmount ?? 0) / 100, 2)
        couponTitle = `${fullDiscountAmount}`
        break
      }
      case 2: {
        let directDiscountAmount = AmountUtil.getRoundUpNoZero((data?.directDiscountAmount ?? 0) / 100, 2)
        couponTitle = `${directDiscountAmount}`
        break
      }
      case 3: {
        couponTitle = `${data?.discountContent}`
        break
      }
    }
    return couponTitle
  }

  getCouponDescribe(data?: CouponInfo): string {

    let useStartTime = `领取时间：${DateUtil.transDateHMS(data?.useStartTime ?? '')}\n`
    let couponNo = `优惠券编码：${data?.couponNo}\n`
    let describe =
      `${useStartTime}${couponNo}1.商品券只能用于特定商品\n2.一个数量的商品只能使用一张单品优惠券，不能叠加使用\n3.改价商品、特价商品不支持使用优惠券`
    return describe
  }

  getCourseCouponType(data: CouponInfo): CourseCouponStatus {
    let viewType = 0
    let claimStatus = data?.claimStatus ?? 0
    let closeExpireStatus = data?.closeExpireStatus ?? 0
    let useEndTime = DateUtil.getLocalDate(data?.useEndTime ?? '').getTime()
    let today = DateUtil.getTimestamp()
    let diffDays = DateUtil.getDiffDay(today, useEndTime)
    if (claimStatus == 1) {
      viewType = CourseCouponStatus.NOT_CLAIMED
    } else if (claimStatus == 2) {
      if (diffDays < 3) {
        if (diffDays < 0) {
          viewType = CourseCouponStatus.EXPIRED
        } else {
          viewType = CourseCouponStatus.ABOUT_TO_EXPIRED
        }
      } else {
        viewType = CourseCouponStatus.RECEIVED
      }
    } else if (closeExpireStatus == 2) {
      viewType = CourseCouponStatus.ABOUT_TO_EXPIRED
    } else {
      viewType = CourseCouponStatus.EXPIRED
    }

    Logger.error('getCourseCouponType', 'getCourseCouponType-viewType = ' + viewType)
    return viewType
  }
}

export default new CouponUtil()