/**
 * 线下课程学习页（无视频播放）
 */
import { router } from '@kit.ArkUI'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout'
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo'
import { CourseCouponData } from 'lib_core_model/src/main/ets/data/CourseCouponData'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { GoodsSpecData } from 'lib_core_model/src/main/ets/data/GoodsSpecData'
import { GoodsSpecInfo } from 'lib_core_model/src/main/ets/data/GoodsSpecInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { BuySource } from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM'
import PayOrderActionUtil from '../../util/action/PayOrderActionUtil'
import PayOrderUtil from '../../util/PayOrderUtil'
import { ToolBar } from '../../view/widget/ToolBar'
import { CoursePriceTitleStyleDisplayComp } from '../common/CoursePriceDisplayComp'
import CourseDetailHeader from './component/CourseDetailHeader'
import OfflineCourseStudyUnPlayProduct from './component/OfflineCourseStudyUnPlayProduct'

@Entry
@Component
struct OfflineCourseStudyUnPlayPage {
  @State loginData: LoginData | null = null
  @State isShowCouponTip: boolean = false
  @State coupon: CouponInfo | null = null
  @State mRefreshConfig: RefreshConfig<object> = new RefreshConfig<object>()
  @State goodsInfo: GoodsInfo | null = null
  @Provide(Constants.GOODS_DETAIL_COUPON_TIP_DATA_KEY) couponList: Array<CouponInfo> = []
  @Provide(Constants.GOODS_DETAIL_COUPON_DATA_KEY) courseCouponData: CourseCouponData | null = null
  @Provide(Constants.GOODS_SPEC_DATA_KEY) goodsSpecData: GoodsSpecData | null = null
  private tag: string = 'OfflineCourseStudyUnPlayPage'
  private goodsId: string = (router.getParams() as object)?.[Constants.GOODS_ID]
  private subOrderId: number = (router.getParams() as object)?.[Constants.SUB_ORDER_ID] ?? -1
  private tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID] ?? 0

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendAllRequest()
    })
  }

  build() {
    Column() {
      ToolBar({ title: '课程详情', shadowColor: $r('app.color.transparent') })

      SwipeRefreshLayout({
        refreshConfig: this.mRefreshConfig,
        itemLayout: (): void => this.groupContent(),
        onRefresh: () => {
          this.sendAllRequest()
        }
      })
        .width(Constants.FULL_PARENT)
        .layoutWeight(1)
        .margin({ top: $r('app.string.lpx_10') })
        .zIndex(0)

      this.couponTip()
      this.bottomActionBar()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  groupContent() {
    Stack() {
      List() {
        ListItemGroup() {
          ListItem() {
            CourseDetailHeader({
              goodsInfo: this.goodsInfo
            })
          }
          .width(Constants.FULL_PARENT)
        }

        ListItemGroup() {
          ListItem() {
            OfflineCourseStudyUnPlayProduct({
              goodsInfo: this.goodsInfo
            })
          }
          .width(Constants.FULL_PARENT)
          .padding({
            left: $r('app.string.lpx_16'),
            right: $r('app.string.lpx_16')
          })
          .borderRadius({
            topLeft: $r('app.string.lpx_20'),
            topRight: $r('app.string.lpx_20')
          })
        }
      }
      .width(Constants.FULL_PARENT)
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .cachedCount(3)
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .alignContent(Alignment.Top)
  }

  @Builder
  bottomActionBar() {
    Row() {
      CoursePriceTitleStyleDisplayComp({
        goodsInfo: this.goodsInfo
      })

      Text('加购课程')
        .height($r('app.string.lpx_80'))
        .layoutWeight(1)
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'), 0.0],
            [$r('app.color.color_F12E29'), 0.7],
            [$r('app.color.color_F12E29'), 1.0]
          ]
        })
        .borderRadius($r('app.string.lpx_36'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({ left: $r('app.string.lpx_22') })
        .onClick(() => {
          this.handleToBuyClick()
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_112'))
    .backgroundColor($r('app.color.white'))
    .padding({
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .shadow({
      radius: $r('app.string.lpx_10'),
      color: $r('app.color.color_1400001E'),
      offsetX: $r('app.string.lpx_10'),
      offsetY: $r('app.string.lpx_10')
    })
  }

  @Builder
  couponTip() {
    Stack() {
      Image($r('app.media.img_course_detail_coupon_tip'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_76'))
        .objectFit(ImageFit.Cover)
      Row() {
        Image($r('app.media.ic_course_detail_coupon_tip'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
        Text() {
          if (this.coupon?.discountMethod == 1) {
            Span('优惠提醒：商品限时优惠，')
            Span('点击领券').fontColor($r('app.color.color_FF1F00')).fontSize(lpx2fp(24))
            Span(`满${AmountUtil.getRoundUpNoZero(this.coupon?.fullAmount ?? 0 / 100, 2)}元减`)
            Span(`${AmountUtil.getRoundUpNoZero(this.coupon?.fullDiscountAmount ?? 0 / 100, 2)}元`)
              .fontColor($r('app.color.color_FF1F00'))
              .fontSize(lpx2fp(24))
          } else if (this.coupon?.discountMethod == 2) {
            Span('优惠提醒：商品限时优惠，')
            Span('点击领券').fontColor($r('app.color.color_FF1F00')).fontSize(lpx2fp(24))
            Span(`立省`)
            Span(`${AmountUtil.getRoundUpNoZero(this.coupon?.directDiscountAmount ?? 0 / 100, 2)}元`)
              .fontColor($r('app.color.color_FF1F00'))
              .fontSize(lpx2fp(24))
          } else if (this.coupon?.discountMethod == 3) {
            Span('优惠提醒：商品限时优惠，')
            Span('点击领券').fontColor($r('app.color.color_FF1F00')).fontSize(lpx2fp(24))
            Span(`立享`)
            Span(`${this.coupon?.discountContent}折`)
              .fontColor($r('app.color.color_FF1F00'))
              .fontSize(lpx2fp(24))
          }
        }
        .fontSize(lpx2fp(20))
        .fontColor($r('app.color.color_333333'))
        .layoutWeight(1)
        .margin({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })

        Image($r('app.media.ic_couse_detail_coupon_tip_close'))
          .width($r('app.string.lpx_36'))
          .height($r('app.string.lpx_36'))
          .padding($r('app.string.lpx_10'))
          .objectFit(ImageFit.Cover)
          .onClick(() => {
            this.isShowCouponTip = false
          })
      }
      .padding({ bottom: $r('app.string.lpx_14'), left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
    }
    .visibility(this.isShowCouponTip ? Visibility.Visible : Visibility.None)
    .height($r('app.string.lpx_76'))
    .width(Constants.FULL_PARENT)
  }

  private sendAllRequest() {
    this.sendOfflineCourseDetailRequest()
    this.sendCourseCouponTipRequest()
    this.sendCourseCouponRequest()
  }

  private sendOfflineCourseDetailRequest() {
    CourseVM.sendOfflineCourseDetailRequest(this.loginData?.token ?? '', this.goodsId, this.subOrderId)
      .then((value: GoodsInfo) => {
        this.goodsInfo = value
        this.mRefreshConfig.setAllData(Array.of(value), true, 1)
        this.showCourseCouponTip() // 是否显示优惠券提醒
      })
      .catch((err: string | Resource) => {
        this.mRefreshConfig.setData([], false)
        ToastUtils.show(err)
      })
  }

  private sendCourseCouponTipRequest() {
    CourseVM.sendCourseCouponTipRequest(this.loginData?.token ?? '', this.goodsId)
      .then((value: CouponInfo[]) => {
        this.couponList = value
        this.coupon = this.couponList[0]
        // TODO 测试数据
        // this.coupon = new CouponInfo()
        // this.coupon.fullAmount = 500
        // this.coupon.fullDiscountAmount = 200
        // this.coupon.directDiscountAmount = 200
        // this.coupon.discountContent = '七'
        // this.coupon.discountMethod = 3
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  private sendCourseCouponRequest() {
    CourseVM.sendCourseCouponRequest(this.loginData?.token ?? '', this.goodsId)
      .then((value: CourseCouponData) => {
        this.courseCouponData = value
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  private handleToBuyClick() {
    PayOrderActionUtil.payOrder(PayOrderUtil.getOnlineOrderDetailData(BuySource.CourseDetail, this.goodsInfo))
  }

  private showCourseCouponTip() {
    if (!this.isSellOut()) {
      this.isShowCouponTip = false
    } else {
      this.isShowCouponTip = true
    }
    Logger.info(this.tag, `showCourseCouponTip: isShowCouponTip = ${this.isShowCouponTip}`)
    // TODO 测试数据
    // this.isShowCouponTip = true
  }

  private isSellOut() {
    let isSellOut = true
    this.goodsInfo?.specVos?.forEach((item: GoodsSpecInfo) => {
      let availableNum = item.availableNum ?? 0
      if (availableNum > 0) {
        isSellOut = false
      }
    })
    return isSellOut
  }
}