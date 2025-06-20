/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PayCouponUnAvaialableCell
 * Author: Victor
 * Date: 2024/07/11 09:08
 * Description: 
 * -----------------------------------------------------------------
 */
import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import CouponUtil from '../../util/CouponUtil'

@Component
export default struct PayCouponUnAvaialableCell {
  private data?: CouponInfo
  @Link @Watch('onClickIndexChanged') clickIndex: number
  @State isExpanded: boolean = false
  public index: number = 0

  onClickIndexChanged() {
    if (this.clickIndex !== this.index) {
      this.isExpanded = false
    }
  }

  build() {
    Stack() {
      Text(CouponUtil.getCouponDescribe(this.data))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(24))
        .width(Constants.FULL_PARENT)
        .height(this.isExpanded ? $r('app.string.lpx_220') : 0)
        .lineHeight($r('app.string.lpx_36'))
        .backgroundColor($r('app.color.white'))
        .borderRadius({
          bottomLeft: $r('app.string.lpx_16'),
          bottomRight: $r('app.string.lpx_16')
        })
        .margin({top: $r('app.string.lpx_160')})
        .padding({
          left: $r('app.string.lpx_24'),
          right: $r('app.string.lpx_24')
        })
        .shadow({
          radius: $r('app.string.lpx_5'),
          color: $r('app.color.color_1400001E'),
          offsetX: $r('app.string.lpx_5'),
          offsetY: $r('app.string.lpx_5')
        })

      Row() {
        Column() {
          Text('直播专享')
            .fontSize(lpx2fp(18))
            .fontColor($r('app.color.color_FF1F00'))
            .textAlign(TextAlign.Center)
            .backgroundColor($r('app.color.color_FFD6D6'))
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
            .fontColor($r('app.color.color_333333'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
          Row() {
            Text(`有效期至${DateUtil.transDate(this.data?.useEndTime)}`)
              .fontSize(lpx2fp(20))
              .fontColor($r('app.color.color_333333'))
              .textAlign(TextAlign.Start)
              .margin({top: $r('app.string.lpx_8')})

            Blank()

            Text(){
              Span('使用规则\t')
                .fontSize(lpx2fp(20))
                .fontColor($r('app.color.color_777777'))
              ImageSpan($r('app.media.ic_coupon_use_rules_down'))
                .width($r('app.string.lpx_24'))
                .height($r('app.string.lpx_24'))
                .margin({left: $r('app.string.lpx_8')})
                .rotate({
                  angle: this.isExpanded ? 180 : 0
                })
            }
            .padding($r('app.string.lpx_24'))
            .onClick(() => {
              animateTo({ duration: Constants.DURATION }, () => {
                this.isExpanded = !this.isExpanded;
              })
              this.clickIndex = this.index;
            })
          }
          .width(Constants.FULL_PARENT)
        }
        .layoutWeight(1)
        .height(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.SpaceEvenly)
        .padding({left: $r('app.string.lpx_30')})
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_160'))
      .backgroundImage($r('app.media.img_coupon_normal_cell'))
      .backgroundImageSize(ImageSize.FILL)
    }
    .width(Constants.FULL_PARENT)
    .alignContent(Alignment.Top)
    .margin({bottom: $r('app.string.lpx_32')})
  }
}
