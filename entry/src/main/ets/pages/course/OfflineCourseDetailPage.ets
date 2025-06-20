import router from '@ohos.router';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import { AutoClaimCouponParm } from 'lib_core_model/src/main/ets/data/AutoClaimCouponParm';
import { CollectParm } from 'lib_core_model/src/main/ets/data/CollectParm';
import { CommentInfo } from 'lib_core_model/src/main/ets/data/CommentInfo';
import { CommentNumData } from 'lib_core_model/src/main/ets/data/CommentNumData';
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo';
import { CourseCouponData } from 'lib_core_model/src/main/ets/data/CourseCouponData';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { GoodsSpecInfo } from 'lib_core_model/src/main/ets/data/GoodsSpecInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import CollectVM from 'lib_core_model/src/main/ets/vm/CollectVM';
import CommentVM from 'lib_core_model/src/main/ets/vm/CommentVM';
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM';
import ShoppingCartVM from 'lib_core_model/src/main/ets/vm/ShoppingCartVM';
import CourseProductConfigDialog from '../../view/dialog/CourseProductConfigDialog';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { ToolBar } from '../../view/widget/ToolBar';
import CourseDetailComment from './component/CourseDetailComment';
import CourseDetailContent from './component/CourseDetailContent';
import CourseDetailHeader from './component/CourseDetailHeader';
import CourseDetailOrganCell from './component/CourseDetailOrganCell';
import CourseDetailRecommend from './component/CourseDetailRecommend';
import OfflineCourseDetailProduct from './component/OfflineCourseDetailProduct';

@Entry
@Component
struct OfflineCourseDetailPage {
  tag: string = 'OfflineCourseDetailPage'
  tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  goodsId: string = (router.getParams() as object)?.[Constants.DATA];
  subOrderId: number = (router.getParams() as object)?.[Constants.SUB_ORDER_ID];
  @State loginData: LoginData | null = null
  @State goodsInfo: GoodsInfo | null = null
  @Provide(Constants.GOODS_DETAIL_COUPON_TIP_DATA_KEY) couponList: Array<CouponInfo> = []
  @Provide(Constants.GOODS_DETAIL_COUPON_DATA_KEY) courseCouponData: CourseCouponData | null = null
  @State recommendGoodsInfos: Array<GoodsInfo> = []
  // 标题栏透明度
  @State commentNumData: CommentNumData | null = null
  @State commentInfo: CommentInfo | null = null
  @State titleBarOpacity: number = 0
  @State tabCheckIndex: number = 1
  @State setCartIndex: number = 0
  @State coupon: CouponInfo | null = null
  @State isShowCouponTip: boolean = false
  @State mRefreshConfig: RefreshConfig<object> = new RefreshConfig<object>()
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });
  courseProductConfigDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseProductConfigDialog({
      goodsInfo: this.goodsInfo
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })
  private scroller: Scroller = new Scroller();
  // 滑动的y偏移量
  private yTotalOffset = 0

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendAllRequest()
    })
  }

  sendAllRequest() {
    this.sendOfflineCourseDetailRequest()
    this.sendCourseCouponTipRequest()
    this.sendCourseCouponRequest()
    this.sendCommendNumRequest()
    this.sendRecommendCommendRequest()
    this.sendCourseDetailRecommendRequest()
  }

  sendOfflineCourseDetailRequest() {
    CourseVM.sendOfflineCourseDetailRequest(this.loginData?.token ?? '', this.goodsId, this.subOrderId)
      .then((value: GoodsInfo) => {
        this.goodsInfo = value
        this.mRefreshConfig.setAllData(Array.of(value), true, 1)
        this.showCourseCouponTip() // 是否显示优惠券提醒
        this.sendAutoClaimCouponRequest()
      })
      .catch((err: string | Resource) => {
        this.mRefreshConfig.setData([], false)
        ToastUtils.show(err)
      })
  }

  sendAutoClaimCouponRequest() {
    const tenantId = this.goodsInfo?.tenantVO?.tenantId ?? 0
    const body = new AutoClaimCouponParm()
    body.tenantId = tenantId
    body.goodsId = this.goodsInfo?.goodsId
    CourseVM.sendAutoClaimCouponRequest(tenantId, this.loginData?.token ?? '', body)
      .then((value: object) => {

      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendCourseCouponTipRequest() {
    CourseVM.sendCourseCouponTipRequest(this.loginData?.token ?? '', this.goodsId)
      .then((value: CouponInfo[]) => {
        this.couponList = value
        this.coupon = this.couponList[0]
        Logger.info(this.tag, `this.coupon = ${JSON.stringify(this.coupon)}`)
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendCourseCouponRequest() {
    CourseVM.sendCourseCouponRequest(this.loginData?.token ?? '', this.goodsId).then((value: CourseCouponData) => {
      this.courseCouponData = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendCommendNumRequest() {
    CommentVM.sendCommendNumRequest(this.tenantId, this.loginData?.token ?? '', this.goodsId)
      .then((value: CommentNumData) => {
        this.commentNumData = value
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendRecommendCommendRequest() {
    CommentVM.sendRecommendCommendRequest(this.tenantId, this.goodsId).then((value: CommentInfo) => {
      this.commentInfo = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendCourseDetailRecommendRequest() {
    CourseVM.sendCourseDetailRecommendRequest(this.tenantId, this.goodsId).then((value: GoodsInfo[]) => {
      this.recommendGoodsInfos = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendCollectRequest() {
    this.loadingDialogCtrl.open()

    let body = new CollectParm()
    body.goodsId = this.goodsId
    body.collectFlag = !(this.goodsInfo?.collectionFlag ?? false)

    CollectVM.sendCollectRequest(this.loginData?.token ?? '', body).then((value: object) => {
      this.loadingDialogCtrl.close()
      if (this.goodsInfo) {
        let collectionFlag = this.goodsInfo?.collectionFlag ?? false
        this.goodsInfo.collectionFlag = !collectionFlag
        if (collectionFlag) {
          ToastUtils.show("已取消收藏")
        } else {
          ToastUtils.show("收藏成功")
        }
      }

    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendSetCartRequest(goodsId: string, specId: string, quantity: number) {
    this.loadingDialogCtrl.open()

    ShoppingCartVM.sendSetCartRequest(this.loginData?.token ?? '', goodsId, specId, quantity).then((value: object) => {
      this.loadingDialogCtrl.close()
      let info = this.recommendGoodsInfos?.[this.setCartIndex]
      if (info) {
        info.quantity = 1
        this.recommendGoodsInfos[this.setCartIndex] = info
      }
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
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
    .padding({bottom: $r('app.string.lpx_40')})
  }

  @Builder
  groupContent() {
    Stack() {
      List({ scroller: this.scroller }) {
        ListItem() {
          CourseDetailHeader({
            goodsInfo: this.goodsInfo
          })
        }
        .width(Constants.FULL_PARENT)

        ListItem() {
          OfflineCourseDetailProduct({
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

        ListItem() {
          CourseDetailComment({
            commentNumData: this.commentNumData,
            commentInfo: this.commentInfo,
            goodsInfo: this.goodsInfo
          })
        }
        .width(Constants.FULL_PARENT)

        ListItem() {
          CourseDetailOrganCell({
            goodsInfo: this.goodsInfo
          })
        }
        .width(Constants.FULL_PARENT)
        .margin({
          top: $r('app.string.lpx_28'),
        })
        .padding({
          left: $r('app.string.lpx_16'),
          right: $r('app.string.lpx_16')
        })

        ListItem() {
          CourseDetailContent({
            goodsInfo: this.goodsInfo
          })
        }
        .width(Constants.FULL_PARENT)
        .margin({
          top: $r('app.string.lpx_8'),
        })
        .padding({
          left: $r('app.string.lpx_16'),
          right: $r('app.string.lpx_16')
        })

        ListItem() {
          CourseDetailRecommend({
            recommendGoodsInfos: this.recommendGoodsInfos
          })
        }
        .width(Constants.FULL_PARENT)
        .margin({
          top: $r('app.string.lpx_8'),
        })
        .padding({
          left: $r('app.string.lpx_16'),
          right: $r('app.string.lpx_16')
        })
      }
      .width(Constants.FULL_PARENT)
      .edgeEffect(EdgeEffect.None)
      .cachedCount(3)
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        if (firstIndex === 1 || firstIndex === 2 || firstIndex === 3 || firstIndex === 4) {
          this.tabCheckIndex = firstIndex
        }
      })
      .onScroll((scrollOffset, scrollState) => {
        Logger.error('onScroll', 'onScroll-scrollOffset = ' + scrollOffset)
        Logger.error('onScroll', 'onScroll-scrollState = ' + scrollState)

        this.yTotalOffset += scrollOffset
        Logger.error('onScroll', 'onScroll-yTotalOffset = ' + this.yTotalOffset)

        const offsetY = Math.abs(this.yTotalOffset)
        let scale = offsetY / 100

        if (scale < 0.5) {
          this.titleBarOpacity = 0
          return
        }
        if (scale > 1) {
          this.titleBarOpacity = 1
          return
        }
        this.titleBarOpacity = scale
      })

      Row() {
        Text('商品')
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .fontColor(this.tabCheckIndex === 1 ? $r('app.color.color_333333') : $r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.scroller.scrollTo({ xOffset: 0, yOffset: 0 })
            this.titleBarOpacity = 0
          })
        Text('评价')
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .fontColor(this.tabCheckIndex === 2 ? $r('app.color.color_333333') : $r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.scroller.scrollToIndex(2)
          })
        Text('详情')
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .fontColor(this.tabCheckIndex === 3 ? $r('app.color.color_333333') : $r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.scroller.scrollToIndex(3)
          })
        Text('推荐')
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .fontColor(this.tabCheckIndex === 4 ? $r('app.color.color_333333') : $r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.scroller.scrollToIndex(4)
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_88'))
      .backgroundColor($r('app.color.white'))
      .opacity(this.titleBarOpacity)
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .alignContent(Alignment.Top)
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

  @Builder
  bottomActionBar() {
    Row() {
      // Button({ type: ButtonType.Normal, stateEffect: true }) {
      //   Column() {
      //     Image(this.data?.collectionFlag ? $r('app.media.ic_course_fav_focus') : $r('app.media.ic_course_fav_normal'))
      //       .width($r('app.string.lpx_40'))
      //       .height($r('app.string.lpx_40'))
      //
      //     Text(this.data?.collectionFlag ? '已收藏' : '收藏')
      //       .fontSize(lpx2fp(20))
      //       .fontColor($r('app.color.color_333333'))
      //       .margin({ top: $r('app.string.lpx_2') })
      //   }
      // }
      // .height(Constants.FULL_PARENT)
      // .backgroundColor($r('app.color.transparent'))
      // .padding({ right: $r('app.string.lpx_10') })
      // .onClick(() => {
      //   this.sendCollectRequest()
      // })

      Button({ type: ButtonType.Normal, stateEffect: true }) {
        Column() {
          Image($r('app.media.ic_course_customer_service'))
            .width($r('app.string.lpx_40'))
            .height($r('app.string.lpx_40'))

          Text('客服')
            .fontSize(lpx2fp(20))
            .fontColor($r('app.color.color_333333'))
            .margin({ top: $r('app.string.lpx_2') })
        }
      }
      .height(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.transparent'))
      .padding({ left: $r('app.string.lpx_10'), right: $r('app.string.lpx_10') })
      .margin({ right: $r('app.string.lpx_22') })
      .visibility(Visibility.None)

      Text('立即抢购')
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
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)

        .onClick(() => {
          this.courseProductConfigDlgCtl.open()
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
