import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import { ClaimCouponParm } from 'lib_core_model/src/main/ets/data/ClaimCouponParm'
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo'
import { CourseCouponStatus } from 'lib_core_model/src/main/ets/data/CourseCouponStatus'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM'
import CouponUtil from '../../util/CouponUtil'

@CustomDialog
export default struct CourseCouponSelectDialog {
  @State coupons: Array<CouponInfo> | null = null
  tenantId: number | null = null
  loginData: LoginData | null = null
  tag: string = 'CourseCouponSelectDialog'
  controller: CustomDialogController

  sendOrderRecommendRequest(item: CouponInfo) {
    const body = new ClaimCouponParm()
    body.couponNo = item.couponNo
    CourseVM.sendClaimCouponRequest(this.tenantId ?? 0, this.loginData?.token ?? '', body)
      .then((value: object) => {
        item.claimStatus = 2
        this.coupons = this.coupons?.slice() ?? []
        ToastUtils.show("恭喜您，领券成功！")
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  build() {
    Column() {
      Stack() {
        Text('优惠')
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(36))
          .textAlign(TextAlign.Center)

        Image($r('app.media.ic_dlg_feedback_type_close'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .onClick(() => {
            this.controller.close()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_112'))
      .alignContent(Alignment.End)

      List() {
        ForEach(this.coupons, (item: CouponInfo) => {
          ListItem() {
            this.cellLayout(item, CouponUtil.getCourseCouponType(item))
          }
          .width(Constants.FULL_PARENT)
        })
      }
      .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor(Color.White)
    .borderRadius({
      topLeft: $r('app.string.lpx_20'),
      topRight: $r('app.string.lpx_20')
    })
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }

  @Builder
  cellLayout(item: CouponInfo, viewType: number) {
    if (viewType === CourseCouponStatus.NOT_CLAIMED) {
      this.notClaimedCell(item)
    } else if (viewType === CourseCouponStatus.EXPIRED) {
      this.expiredCell(item)
    } else if (viewType === CourseCouponStatus.ABOUT_TO_EXPIRED) {
      this.aboutExpiredCell(item)
    } else if (viewType === CourseCouponStatus.RECEIVED) {
      this.received(item)
    }
  }

  @Builder
  notClaimedCell(item: CouponInfo) {
    Row() {
      Column() {
        Text('直播专享')
          .fontSize(lpx2fp(18))
          .fontColor($r('app.color.color_FF1F00'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_EBEBEB'))
          .borderRadius({ topLeft: $r('app.string.lpx_16'), bottomRight: $r('app.string.lpx_16') })
          .padding({
            top: $r('app.string.lpx_4'),
            bottom: $r('app.string.lpx_4'),
            left: $r('app.string.lpx_8'),
            right: $r('app.string.lpx_8')
          })
          .opacity(item?.couponType === 3 ? 1 : 0)

        Text() {
          if (item?.discountMethod != 3) {
            Span('¥')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_FF1F00'))
              .opacity(item?.discountMethod === 3 ? 0 : 1)
          }
          Span(CouponUtil.getCouponValue(item))
            .fontSize(lpx2fp(48))
            .fontColor($r('app.color.color_FF1F00'))
            .fontWeight(FontWeight.Bold)
          if (item?.discountMethod === 3) {
            Span('折')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_FF1F00'))
          }
        }
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .margin({ top: $r('app.string.lpx_10') })

        Text(CouponUtil.getCouponTypeTxt(item?.discountMethod))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_FF1F00'))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.string.lpx_10') })
      }
      .width($r('app.string.lpx_158'))
      .height(Constants.FULL_PARENT)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(CouponUtil.getCouponTitle(item))
          .width(Constants.FULL_PARENT)
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(`有效期:领取后${item?.expireDays ?? 0}天有效`)
          .width(Constants.FULL_PARENT)
          .fontSize(lpx2fp(20))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Start)
          .margin({ top: $r('app.string.lpx_8') })
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .padding({
        top: $r('app.string.lpx_32'),
        bottom: $r('app.string.lpx_32'),
        left: $r('app.string.lpx_30')
      })

      Text('立即领取')
        .height($r('app.string.lpx_48'))
        .padding({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_24'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FFA400'), 0.0],
            [$r('app.color.color_F53F3F'), 0.7],
            [$r('app.color.color_F53F3F'), 1.0]
          ]
        })
        .onClick(() => {
          this.sendOrderRecommendRequest(item)
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_160'))
    .backgroundImage($r('app.media.img_coupon_normal_cell'))
    .backgroundImageSize(ImageSize.Cover)
    .margin({ bottom: $r('app.string.lpx_32') })
    .padding({ right: $r('app.string.lpx_30') })
  }

  @Builder
  expiredCell(item: CouponInfo) {
    Row() {
      Column() {
        Text('直播专享')
          .fontSize(lpx2fp(18))
          .fontColor($r('app.color.color_8D8D8D'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_EBEBEB'))
          .borderRadius({ topLeft: $r('app.string.lpx_16'), bottomRight: $r('app.string.lpx_16') })
          .padding({
            top: $r('app.string.lpx_4'),
            bottom: $r('app.string.lpx_4'),
            left: $r('app.string.lpx_8'),
            right: $r('app.string.lpx_8')
          })
          .opacity(item?.couponType === 3 ? 1 : 0)

        Text() {
          if (item?.discountMethod != 3) {
            Span('¥')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_444444'))
              .opacity(item?.discountMethod === 3 ? 0 : 1)
          }
          Span(CouponUtil.getCouponValue(item))
            .fontSize(lpx2fp(48))
            .fontColor($r('app.color.color_444444'))
            .fontWeight(FontWeight.Bold)
          if (item?.discountMethod === 3) {
            Span('折')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_444444'))
          }
        }
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .margin({ top: $r('app.string.lpx_10') })

        Text(CouponUtil.getCouponTypeTxt(item?.discountMethod))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_444444'))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.string.lpx_10') })
      }
      .width($r('app.string.lpx_158'))
      .height(Constants.FULL_PARENT)
      .alignItems(HorizontalAlign.Start)

      Stack() {
        Column() {
          Text(CouponUtil.getCouponTitle(item))
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.color_444444'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
          Text(item.couponNo)
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_777777'))
            .textAlign(TextAlign.Start)
            .margin({ top: $r('app.string.lpx_8') })
          Text(`有效期:${DateUtil.transDate(item?.useStartTime)}～${DateUtil.transDate(item?.useEndTime)}`)
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(20))
            .fontColor($r('app.color.color_444444'))
            .textAlign(TextAlign.Start)
            .margin({ top: $r('app.string.lpx_8') })
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)

        Image($r('app.media.img_coupon_expired'))
          .width($r('app.string.lpx_64'))
          .height($r('app.string.lpx_64'))
          .margin({ top: $r('app.string.lpx_8'), right: $r('app.string.lpx_8') })
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .padding({ left: $r('app.string.lpx_30') })
      .alignContent(Alignment.TopEnd)
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_160'))
    .backgroundImage($r('app.media.img_coupon_expired_cell'))
    .backgroundImageSize(ImageSize.Cover)
    .margin({ bottom: $r('app.string.lpx_32') })
  }

  @Builder
  aboutExpiredCell(item: CouponInfo) {
    Row() {
      Column() {
        Text('直播专享')
          .fontSize(lpx2fp(18))
          .fontColor($r('app.color.color_8D8D8D'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_EBEBEB'))
          .borderRadius({ topLeft: $r('app.string.lpx_16'), bottomRight: $r('app.string.lpx_16') })
          .padding({
            top: $r('app.string.lpx_4'),
            bottom: $r('app.string.lpx_4'),
            left: $r('app.string.lpx_8'),
            right: $r('app.string.lpx_8')
          })
          .opacity(item?.couponType === 3 ? 1 : 0)

        Text() {
          if (item?.discountMethod != 3) {
            Span('¥')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_444444'))
              .opacity(item?.discountMethod === 3 ? 0 : 1)
          }
          Span(CouponUtil.getCouponValue(item))
            .fontSize(lpx2fp(48))
            .fontColor($r('app.color.color_444444'))
            .fontWeight(FontWeight.Bold)
          if (item?.discountMethod === 3) {
            Span('折')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_444444'))
          }
        }
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .margin({ top: $r('app.string.lpx_10') })

        Text(CouponUtil.getCouponTypeTxt(item?.discountMethod))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_444444'))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.string.lpx_10') })
      }
      .width($r('app.string.lpx_158'))
      .height(Constants.FULL_PARENT)
      .alignItems(HorizontalAlign.Start)

      Stack() {
        Row() {
          Column() {
            Text(CouponUtil.getCouponTitle(item))
              .width(Constants.FULL_PARENT)
              .fontSize(lpx2fp(28))
              .fontColor($r('app.color.color_444444'))
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bold)
            Blank()
            Text(`有效期至${DateUtil.transDateHM(item?.useEndTime)}`)
              .width(Constants.FULL_PARENT)
              .fontSize(lpx2fp(20))
              .fontColor($r('app.color.color_444444'))
              .textAlign(TextAlign.Start)
              .margin({ top: $r('app.string.lpx_8') })
          }
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .padding({
            top: $r('app.string.lpx_32'),
            bottom: $r('app.string.lpx_32'),
          })

          Text('立即使用')
            .height($r('app.string.lpx_48'))
            .margin({ right: $r('app.string.lpx_30') })
            .padding({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_FF1F00'))
            .border({
              width: $r('app.string.lpx_2'),
              radius: $r('app.string.lpx_24'),
              color: $r('app.color.color_FF1F00')
            })
            .onClick(() => {
              this.controller.close()
            })
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)

        Image($r('app.media.img_about_to_expire'))
          .width($r('app.string.lpx_90'))
          .height($r('app.string.lpx_90'))
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .padding({ left: $r('app.string.lpx_30') })
      .alignContent(Alignment.TopEnd)
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_160'))
    .backgroundImage($r('app.media.img_coupon_normal_cell'))
    .backgroundImageSize(ImageSize.Cover)
    .margin({ bottom: $r('app.string.lpx_32') })
  }

  @Builder
  received(item: CouponInfo) {
    Row() {
      Column() {
        Text('已领取')
          .fontSize(lpx2fp(18))
          .fontColor($r('app.color.color_04B800'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_E3FAE1'))
          .borderRadius({ topLeft: $r('app.string.lpx_16'), bottomRight: $r('app.string.lpx_16') })
          .padding({
            top: $r('app.string.lpx_4'),
            bottom: $r('app.string.lpx_4'),
            left: $r('app.string.lpx_8'),
            right: $r('app.string.lpx_8')
          })

        Text() {
          if (item?.discountMethod != 3) {
            Span('¥')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_FF1F00'))
              .opacity(item?.discountMethod === 3 ? 0 : 1)
          }
          Span(CouponUtil.getCouponValue(item))
            .fontSize(lpx2fp(48))
            .fontColor($r('app.color.color_FF1F00'))
            .fontWeight(FontWeight.Bold)
          if (item?.discountMethod === 3) {
            Span('折')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_FF1F00'))
          }
        }
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .margin({ top: $r('app.string.lpx_10') })

        Text(CouponUtil.getCouponTypeTxt(item?.discountMethod))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_FF1F00'))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.string.lpx_10') })
      }
      .width($r('app.string.lpx_158'))
      .height(Constants.FULL_PARENT)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(CouponUtil.getCouponTitle(item))
          .width(Constants.FULL_PARENT)
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(`有效期至${DateUtil.transDateHM(item?.useEndTime)}`)
          .width(Constants.FULL_PARENT)
          .fontSize(lpx2fp(20))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Start)
          .margin({ top: $r('app.string.lpx_8') })
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .padding({
        top: $r('app.string.lpx_32'),
        bottom: $r('app.string.lpx_32'),
        left: $r('app.string.lpx_30')
      })

      Text('立即使用')
        .height($r('app.string.lpx_48'))
        .padding({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.color_FF1F00'))
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_24'),
          color: $r('app.color.color_FF1F00')
        })
        .onClick(() => {
          this.controller.close()
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_160'))
    .backgroundImage($r('app.media.img_coupon_normal_cell'))
    .backgroundImageSize(ImageSize.Cover)
    .margin({ bottom: $r('app.string.lpx_32') })
    .padding({ right: $r('app.string.lpx_30') })
  }
}