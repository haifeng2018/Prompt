import router from '@ohos.router';
import App from 'lib_core_model/src/main/ets/App';
import { AutoClaimCouponParm } from 'lib_core_model/src/main/ets/data/AutoClaimCouponParm';
import { CollectParm } from 'lib_core_model/src/main/ets/data/CollectParm';
import { CommentInfo } from 'lib_core_model/src/main/ets/data/CommentInfo';
import { CommentNumData } from 'lib_core_model/src/main/ets/data/CommentNumData';
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo';
import { CourseCouponData } from 'lib_core_model/src/main/ets/data/CourseCouponData';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { BuySource } from 'lib_core_model/src/main/ets/util/Enums';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import CollectVM from 'lib_core_model/src/main/ets/vm/CollectVM';
import CommentVM from 'lib_core_model/src/main/ets/vm/CommentVM';
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM';
import ShoppingCartVM from 'lib_core_model/src/main/ets/vm/ShoppingCartVM';
import PayOrderActionUtil from '../../util/action/PayOrderActionUtil';
import PayOrderUtil from '../../util/PayOrderUtil';
import CourseStudyDialog from '../../view/dialog/CourseStudyDialog';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { ToolBar } from '../../view/widget/ToolBar';
import CourseDetailComment from './component/CourseDetailComment';
import CourseDetailContent from './component/CourseDetailContent';
import CourseDetailHeader from './component/CourseDetailHeader';
import CourseDetailOrganCell from './component/CourseDetailOrganCell';
import CourseDetailProduct from './component/CourseDetailProduct';
import CourseDetailRecommend from './component/CourseDetailRecommend';

/**
 * 线上课程详情页
 */
@Entry
@Component
struct OnlineCourseDetailPage {
  tag: string = 'OnlineCourseDetailPage'
  goodsId: string = (router.getParams() as object)?.[Constants.DATA];
  tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  @State loginData: LoginData | null = null
  @State goodsInfo: GoodsInfo | null = null
  @State recommendGoodsInfos: Array<GoodsInfo> = []
  @State commentNumData: CommentNumData | null = null
  @State commentInfo: CommentInfo | null = null
  @State titleBarOpacity: number = 0 // 标题栏透明度
  @State tabCheckIndex: number = 1
  @State setCartIndex: number = 0
  @Provide(Constants.GOODS_DETAIL_COUPON_TIP_DATA_KEY) couponList: Array<CouponInfo> = []
  @Provide(Constants.GOODS_DETAIL_COUPON_DATA_KEY) courseCouponData: CourseCouponData | null = null
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });
  courseStudyDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseStudyDialog({ onStudyNow: this.onStudyNow.bind(this) }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });
  private scroller: Scroller = new Scroller();
  // 滑动的y偏移量
  private yTotalOffset = 0

  onStudyNow() {
    App.get().pushUrl({
      url: RouterPath.ONLINE_COURSE_STUDY_PLAY_PAGE,
      params: {
        data: this.goodsInfo?.goodsId
      }
    })
  }

  sendOnlineCourseDetailRequest() {
    CourseVM.sendOnlineCourseDetailRequest(this.loginData?.token ?? '', this.goodsId).then((value: GoodsInfo) => {
      this.goodsInfo = value
      if (value.orderNo) {
        this.courseStudyDlgCtl.open()
      }
      this.sendAutoClaimCouponRequest()
    }).catch((err: string | Resource) => {
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
    CourseVM.sendCourseCouponTipRequest(this.loginData?.token ?? '', this.goodsId).then((value: CouponInfo[]) => {
      this.couponList = value
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

  sendAllRequest() {
    this.sendOnlineCourseDetailRequest()
    this.sendCourseCouponTipRequest()
    this.sendCourseCouponRequest()
    this.sendCommendNumRequest()
    this.sendRecommendCommendRequest()
    this.sendCourseDetailRecommendRequest()
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendAllRequest()
    })
  }

  build() {
    Column() {
      ToolBar({ title: '课程详情', shadowColor: $r('app.color.transparent') })
      this.groupContent()
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

        ListItem() {
          CourseDetailProduct({
            tenantId: this.tenantId,
            loginData: this.loginData,
            goodsInfo: this.goodsInfo
          })
        }
        .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
        .borderRadius({ topLeft: $r('app.string.lpx_20'), topRight: $r('app.string.lpx_20') })

        ListItem() {
          CourseDetailComment({
            commentNumData: this.commentNumData,
            commentInfo: this.commentInfo,
            goodsInfo: this.goodsInfo
          })
        }

        ListItem() {
          CourseDetailOrganCell({
            goodsInfo: this.goodsInfo
          })
        }
        .margin({ top: $r('app.string.lpx_28'), })
        .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })

        ListItem() {
          CourseDetailContent({
            goodsInfo: this.goodsInfo
          })
        }
        .margin({ top: $r('app.string.lpx_8'), })
        .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })

        ListItem() {
          CourseDetailRecommend({
            recommendGoodsInfos: this.recommendGoodsInfos
          })
        }
        .margin({ top: $r('app.string.lpx_8'), })
        .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
      }
      .width(Constants.FULL_PARENT)
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .cachedCount(3)
      .onScrollIndex(
        (firstIndex: number, lastIndex: number) => {
          Logger.info(this.tag, `firstIndex = ${firstIndex}, lastIndex = ${lastIndex}`)
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
  bottomActionBar() {
    Row() {
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
          PayOrderActionUtil.payOrder(PayOrderUtil.getOnlineOrderDetailData(BuySource.CourseDetail, this.goodsInfo))
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
}
