/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PurchasedCourseContent
 * Author: Victor
 * Date: 2023/12/01 16:31
 * Description: 
 * -----------------------------------------------------------------
 */
import { LengthMetrics } from '@ohos.arkui.node'
import LMList from 'lib_common/src/main/ets/components/refresh/LMList'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import { LearningInfo } from 'lib_core_model/src/main/ets/data/LearningInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { OrderGoodRelatedData } from 'lib_core_model/src/main/ets/data/OrderGoodRelatedData'
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import OrderVM from 'lib_core_model/src/main/ets/vm/OrderVM'
import StudyCenterVM from 'lib_core_model/src/main/ets/vm/StudyCenterVM'
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil'
import LoadingDialog from '../../view/dialog/LoadingDialog'
import OfflineCourseExpirationDialog from '../../view/dialog/OfflineCourseExpirationDialog'
import OnlineCourseExpirationDialog from '../../view/dialog/OnlineCourseExpirationDialog'
import SellOutRecommendDialog from '../../view/dialog/SellOutRecommendDialog'

@Preview
@Component
export struct PurchasedCourseContent {
  tag: string = 'PurchasedCourseContent'
  @State loginData: LoginData | null = null
  @State refreshConfig: RefreshConfig<LearningInfo> = new RefreshConfig<LearningInfo>()
  @State goodsMode: number = 0
  @State currentPage: number = 1

  @State mSubOrderInfo?: SubOrderInfo | null = null

  onBuyNow() {
    CourseDetailActionUtil.courseDetail(
      this.mSubOrderInfo?.tenantId ?? 0,
      this.mSubOrderInfo?.goodsMode,
      this.mSubOrderInfo?.goodsId,
      this.mSubOrderInfo?.id)
  }

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  onlineCourseExpirationDlgCtrl: CustomDialogController = new CustomDialogController({
    builder: OnlineCourseExpirationDialog({
      mSubOrderInfo: this.mSubOrderInfo,
      onBuyNow: this.onBuyNow.bind(this)
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  offlineCourseExpirationDlgCtrl: CustomDialogController = new CustomDialogController({
    builder: OfflineCourseExpirationDialog({
      mSubOrderInfo: this.mSubOrderInfo,
      onBuyNow: this.onBuyNow.bind(this)
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sellOutRecommendDlgCtrl: CustomDialogController = new CustomDialogController({
    builder: SellOutRecommendDialog({
      mSubOrderInfo: this.mSubOrderInfo
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sendOrderGoodRelatedRequest () {
    this.loadingDialogCtrl.open()

    OrderVM.sendOrderGoodRelatedRequest(this.mSubOrderInfo?.tenantId ?? 0,this.loginData?.token ?? '',
      this.mSubOrderInfo?.goodsId ?? '',this.mSubOrderInfo?.id ?? 0).then((value: OrderGoodRelatedData) => {
      this.loadingDialogCtrl.close()

      if (value.outOfTime) {
        if (value.goodsNum == 0) {//售馨
          if (this.mSubOrderInfo?.goodsMode === 0) {
            //线上课程过期未下架
            this.onlineCourseExpirationDlgCtrl.open()
          } else {
            //售馨弹窗
            this.sellOutRecommendDlgCtrl.open()
          }
        } else {
          if (value.shelveFlag === 1) {//下架
            //售馨弹窗
            this.sellOutRecommendDlgCtrl.open()
          } else {
            if (this.mSubOrderInfo?.goodsMode === 0) {
              //线上课程过期未下架
              this.onlineCourseExpirationDlgCtrl.open()
            } else {
              //线下课程过期未下架
              this.offlineCourseExpirationDlgCtrl.open()
            }
          }
        }
      } else {
        CourseDetailActionUtil.courseDetail(
          this.mSubOrderInfo?.tenantId ?? 0,
          this.mSubOrderInfo?.goodsMode,
          this.mSubOrderInfo?.goodsId,
          this.mSubOrderInfo?.id,
          true)
      }
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendLearningPageRequest() {
    StudyCenterVM.sendLearningPageRequest(0, this.loginData?.token ?? '', this.goodsMode,
      this.refreshConfig.currentPage, this.refreshConfig.PAGE_SIZE).then((data: LearningInfo[]) => {
      this.refreshConfig.setData(data, true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([], false)
      ToastUtils.show(err)
    });
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    });
  }

  refreshData() {
    this.currentPage = 1
    this.sendLearningPageRequest()
  }

  loadMoreData() {
    this.currentPage++
    this.sendLearningPageRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: object, index: number): void => this.itemLayout(JSON.parse(JSON.stringify(data))),
      onRefresh: () => {
        this.refreshData()
      },
      onLoadMore: () => {
        this.loadMoreData()
      }
    })
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
  }

  @Builder
  itemLayout(item: LearningInfo) {
    Row() {
      Image(item.coverUrl)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_240'))
        .height($r('app.string.lpx_180'))
        .border({ radius: $r('app.string.lpx_8') })

      Column() {

        Text() {
          if (item.goodsMode === 1) {
            ImageSpan($r('app.media.ic_offline_course_label'))
              .width($r('app.string.lpx_96'))
              .height($r('app.string.lpx_40'))
              .objectFit(ImageFit.Contain)
            Span('\t')
          }
          Span(item.goodsName)
            .layoutWeight(1)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
        }
        .width(Constants.FULL_PARENT)
        .maxLines(2)
        .lineSpacing(LengthMetrics.lpx(10))
        .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(GoodsShowUtil.getLessonLabel(item))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: $r('app.string.lpx_16') })

        Blank()

        Row() {
          Text(GoodsShowUtil.getStudyProgress(item.learningType ?? 0, item.learningRate ?? 0))
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_666666'))
            .fontSize(lpx2fp(28))

          Blank()

          Text('去学习')
            .height($r('app.string.lpx_48'))
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.color_DA3732'))
            .textAlign(TextAlign.Center)
            .backgroundColor($r('app.color.color_FEFAFA'))
            .border({
              width: $r('app.string.lpx_2'),
              radius: $r('app.string.lpx_24'),
              color: $r('app.color.color_DA3732')
            })
            .padding({ left: $r('app.string.lpx_24'), right: $r('app.string.lpx_24') })
            .opacity(GoodsShowUtil.getStudyOpacity(item))
        }
        .width(Constants.FULL_PARENT)
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .margin({ left: $r('app.string.lpx_24') })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .margin({ top: $r('app.string.lpx_24') })
    .padding($r('app.string.lpx_20'))
    .onClick(() => {
      // CourseDetailActionUtil.courseDetail(item.tenantId ?? 0, item.goodsMode, item.goodsId, item.id, item.orderNo)
      this.mSubOrderInfo = item
      this.sendOrderGoodRelatedRequest()
    })
  }

  @Builder
  loadEndLayout() {
    Row() {
      Text('找不到已经购买过的课程？')
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(32))
      Image($r('app.media.ic_study_center_customer_service'))
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
        .margin({ left: $r('app.string.lpx_20') })
      Text('联系客服')
        .fontColor($r('app.color.color_DA3732'))
        .fontSize(lpx2fp(32))
        .margin({ left: $r('app.string.lpx_8') })
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_36'),
      bottom: $r('app.string.lpx_36'),
      left: $r('app.string.lpx_40'),
      right: $r('app.string.lpx_40')
    })
  }
}
