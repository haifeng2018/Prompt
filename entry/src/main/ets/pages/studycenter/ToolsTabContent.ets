/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: StudyCenterTabContent
 * Author: Victor
 * Date: 2023/11/16 16:23
 * Description: 
 * -----------------------------------------------------------------
 */

import router from '@ohos.router'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout'
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { LastStudyInfo } from 'lib_core_model/src/main/ets/data/LastStudyInfo'
import { LearningInfo } from 'lib_core_model/src/main/ets/data/LearningInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { OrderGoodRelatedData } from 'lib_core_model/src/main/ets/data/OrderGoodRelatedData'
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo'
import { SummaryStudyData } from 'lib_core_model/src/main/ets/data/SummaryStudyData'
import { WatchHistoryInfo } from 'lib_core_model/src/main/ets/data/WatchHistoryInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import OrderVM from 'lib_core_model/src/main/ets/vm/OrderVM'
import StudyCenterVM from 'lib_core_model/src/main/ets/vm/StudyCenterVM'
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil'
import StudyCenterAvatarUtil from '../../util/StudyCenterAvatarUtil'
import LoadingDialog from '../../view/dialog/LoadingDialog'
import OfflineCourseExpirationDialog from '../../view/dialog/OfflineCourseExpirationDialog'
import OnlineCourseExpirationDialog from '../../view/dialog/OnlineCourseExpirationDialog'
import SellOutRecommendDialog from '../../view/dialog/SellOutRecommendDialog'
import { HomeToolBar } from '../../view/widget/HomeToolBar'
import { ToolBar } from '../../view/widget/ToolBar'
import { CoursePriceLineStyleDisplayComp } from '../common/CoursePriceDisplayComp'
import { CourseSaleStateDisplayComp } from '../common/CourseSaleStateDisplayComp'

@Preview
@Component
export struct ToolsTabContent {
  @State refreshConfig: RefreshConfig<object> = new RefreshConfig<object>()
  @Link @Watch('sendAllRequest') loginData: LoginData;
  @State notLoggedRecommendList: Array<GoodsInfo> = []
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })


  sendNotLoggedRecommendRequest() {
    StudyCenterVM.sendNotLoggedRecommendRequest(10).then((value: GoodsInfo[]) => {
      this.refreshConfig.setRefreshStatus(true)
      this.notLoggedRecommendList = value
    }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
      ToastUtils.show(err)
    })
  }


  sendAllRequest() {
    this.sendNotLoggedRecommendRequest()
  }

  aboutToAppear() {
    this.sendAllRequest()
  }

  build() {
    Column() {
      HomeToolBar({ title: '工具' })
      this.hasLoginContent()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .align(Alignment.Top)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  hasLoginContent() {
    SwipeRefreshLayout({
      refreshConfig: this.refreshConfig,
      itemLayout: (): void => this.itemLayout(),
      onRefresh: () => {
        this.sendAllRequest()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({ top: $r('app.string.lpx_10') })
      .zIndex(0)
  }

  @Builder
  itemLayout() {
    Column() {
      this.createAction()
      this.categoryTitle('转换工具')
      this.homeLevelCourse()
    }
    .width(Constants.FULL_PARENT)
    .padding({
      bottom: $r('app.string.lpx_20'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }

  @Builder createAction() {
    Column() {
      this.categoryTitle('创建')
      this.createActionContent()
    }
    .margin({ top: $r('app.string.lpx_24') })
  }

  @Builder createActionContent() {
    Row() {
      Column() {
        Row() {
          Column() {
            Text('创建文稿')
              .width(Constants.FULL_PARENT)
              .fontSize(lpx2fp(32))
              .fontColor($r('app.color.color_333333'))
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)

            Text('告别记词 此刻开始')
              .width(Constants.FULL_PARENT)
              .fontSize(lpx2fp(20))
              .fontColor($r('app.color.color_999999'))
              .textAlign(TextAlign.Start)
              .margin({ top: $r('app.string.lpx_10') })
          }
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .padding({ left: $r('app.string.lpx_32') })

          Image($r('app.media.img_my_purchased'))
            .width($r('app.string.lpx_100'))
            .height($r('app.string.lpx_100'))
        }
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_12'))
      .justifyContent(FlexAlign.Center)
      .padding({ right: $r('app.string.lpx_24') })
      .onClick(() => {
        if (this.loginData) {
          App.get().pushUrl({
            url: RouterPath.PURCHASED_COURSE_PAGE
          })
        } else {
          App.get().pushUrl({
            url: RouterPath.CODE_LOGIN_PAGE
          }, router.RouterMode.Single)
        }
      })

      Column() {
        Row() {
          Column() {
            Text('创建文件夹')
              .width(Constants.FULL_PARENT)
              .fontSize(lpx2fp(32))
              .fontColor($r('app.color.color_333333'))
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)

            Text('台词归类 方便快捷')
              .width(Constants.FULL_PARENT)
              .fontSize(lpx2fp(20))
              .fontColor($r('app.color.color_999999'))
              .textAlign(TextAlign.Start)
              .margin({ top: $r('app.string.lpx_10') })
          }
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .padding({ left: $r('app.string.lpx_32') })

          Image($r('app.media.img_all_course'))
            .width($r('app.string.lpx_100'))
            .height($r('app.string.lpx_100'))
        }
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_12'))
      .justifyContent(FlexAlign.Center)
      .margin({ left: $r('app.string.lpx_20') })
      .padding({ right: $r('app.string.lpx_24') })
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.COURSE_CATEGORY_PAGE
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_132'))
    .margin({
      top: $r('app.string.lpx_24')
    })
  }

  @Builder categoryTitle(name: string) {
    Text(name)
      .width(Constants.FULL_PARENT)
      .fontColor($r('app.color.color_333333'))
      .fontSize(lpx2fp(36))
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Start)
      .margin({ top: $r('app.string.lpx_24') })
  }


  @Builder homeLevelCourse() {
    List() {
      ForEach(this.notLoggedRecommendList, (item: GoodsInfo) => {
        ListItem() {
          this.homeLevelCourseCell(item)
        }
        .width(Constants.FULL_PARENT)
        .padding({ left: $r('app.string.lpx_10'), right: $r('app.string.lpx_10') })
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0, item.onlineFlag, item.goodsId)
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .margin({ top: $r('app.string.lpx_24') })
    .listDirection(Axis.Vertical)
    .edgeEffect(EdgeEffect.None)
    .lanes(6)
  }

  @Builder
  homeLevelCourseCell(item: GoodsInfo) {
    Column() {
      Image(item?.coverUrlExtendVo?.centre)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_100'))
        .border({ radius: $r('app.string.lpx_12') })

      Text(item.contentName)
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Start)
        .margin({ top: $r('app.string.lpx_16') })
        .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width(Constants.FULL_PARENT)
    .margin({ bottom: $r('app.string.lpx_16') })
    .alignItems(HorizontalAlign.Start)
  }
}
