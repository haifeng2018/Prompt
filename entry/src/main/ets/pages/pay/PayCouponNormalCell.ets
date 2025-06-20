/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PayCouponNormalCell
 * Author: Victor
 * Date: 2024/07/11 09:07
 * Description: 
 * -----------------------------------------------------------------
 */
import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import CouponUtil from '../../util/CouponUtil'

@Component
export default struct PayCouponNormalCell {
  private data?: CouponInfo

  build() {
    Row() {
      Column() {
        Text('已领取')
          .fontSize(lpx2fp(18))
          .fontColor($r('app.color.color_04B800'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_E3FAE1'))
          .borderRadius({topLeft: $r('app.string.lpx_16'),bottomRight: $r('app.string.lpx_16')})
          .padding({
            top:$r('app.string.lpx_4'),
            bottom:$r('app.string.lpx_4'),
            left:$r('app.string.lpx_8'),
            right:$r('app.string.lpx_8')
          })
          .opacity(this.data?.couponType === 3 ? 1: 0)

        Text() {
          if (this.data?.discountMethod != 3) {
            Span('¥')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_FF1F00'))
              .opacity(this.data?.discountMethod === 3 ? 0 : 1)
          }
          Span(CouponUtil.getCouponValue(this.data))
            .fontSize(lpx2fp(48))
            .fontColor($r('app.color.color_FF1F00'))
            .fontWeight(FontWeight.Bold)
          if (this.data?.discountMethod === 3) {
            Span('折')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_FF1F00'))
          }
        }
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .margin({top: $r('app.string.lpx_10')})
        Text(CouponUtil.getCouponTypeTxt(this.data?.discountMethod))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_FF1F00'))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Center)
          .margin({top: $r('app.string.lpx_10')})
      }
      .width($r('app.string.lpx_158'))
      .height(Constants.FULL_PARENT)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(CouponUtil.getCouponTitle(this.data))
          .width(Constants.FULL_PARENT)
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_444444'))
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
        Text(`有效期至${DateUtil.transDate(this.data?.useEndTime)}`)
          .width(Constants.FULL_PARENT)
          .fontSize(lpx2fp(20))
          .fontColor($r('app.color.color_444444'))
          .textAlign(TextAlign.Start)
          .margin({top: $r('app.string.lpx_8')})
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({left: $r('app.string.lpx_30')})
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_160'))
    .backgroundImage($r('app.media.img_coupon_normal_cell'))
    .backgroundImageSize(ImageSize.FILL)
    .margin({bottom: $r('app.string.lpx_32')})
  }
}
