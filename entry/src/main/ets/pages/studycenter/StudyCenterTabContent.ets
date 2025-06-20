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
import { ToolBar } from '../../view/widget/ToolBar'
import { CoursePriceLineStyleDisplayComp } from '../common/CoursePriceDisplayComp'
import { CourseSaleStateDisplayComp } from '../common/CourseSaleStateDisplayComp'

@Preview
@Component
export struct StudyCenterTabContent {
  @State refreshConfig: RefreshConfig<object> = new RefreshConfig<object>()
  @Link @Watch('sendAllRequest') loginData: LoginData;
  @State notLoggedRecommendList: Array<GoodsInfo> = []
  @State onlineRecommendList: Array<GoodsInfo> = []
  @State learningList: Array<LearningInfo> = []
  @State watchHistoryList: Array<WatchHistoryInfo> = []
  @State summaryStudyData: SummaryStudyData = new SummaryStudyData()
  @State lastStudyInfo: LastStudyInfo = new LastStudyInfo()
  @State mSubOrderInfo?: SubOrderInfo | null = null
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
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
  private showBack = false

  onBuyNow() {
    CourseDetailActionUtil.courseDetail(
      this.mSubOrderInfo?.tenantId ?? 0,
      this.mSubOrderInfo?.goodsMode,
      this.mSubOrderInfo?.goodsId,
      this.mSubOrderInfo?.id)
  }

  sendOrderGoodRelatedRequest() {
    this.loadingDialogCtrl.open()

    OrderVM.sendOrderGoodRelatedRequest(this.mSubOrderInfo?.tenantId ?? 0, this.loginData?.token ?? '',
      this.mSubOrderInfo?.goodsId ?? '', this.mSubOrderInfo?.id ?? 0).then((value: OrderGoodRelatedData) => {
      this.loadingDialogCtrl.close()

      if (value.outOfTime) {
        if (value.goodsNum == 0) { //售馨
          if (this.mSubOrderInfo?.goodsMode === 0) {
            //线上课程过期未下架
            this.onlineCourseExpirationDlgCtrl.open()
          } else {
            //售馨弹窗
            this.sellOutRecommendDlgCtrl.open()
          }
        } else {
          if (value.shelveFlag === 1) { //下架
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
          this.mSubOrderInfo?.id)
      }
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendNotLoggedRecommendRequest() {
    StudyCenterVM.sendNotLoggedRecommendRequest(10).then((value: GoodsInfo[]) => {
      this.refreshConfig.setRefreshStatus(true)
      this.notLoggedRecommendList = value
    }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
      ToastUtils.show(err)
    })
  }

  sendSummaryStudyRequest() {
    StudyCenterVM.sendSummaryStudyRequest(this.loginData?.token ?? '').then((value: SummaryStudyData) => {
      this.refreshConfig.setRefreshStatus(true)
      this.summaryStudyData = value
    }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
      ToastUtils.show(err)
    })
  }

  sendLastStudyRequest() {
    StudyCenterVM.sendLastStudyRequest(this.loginData?.token ?? '').then((value: LastStudyInfo) => {
      this.lastStudyInfo = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendLearningRequest() {
    StudyCenterVM.sendLearningRequest(this.loginData?.token ?? '').then((value: LearningInfo[]) => {
      this.learningList = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendWatchHistoryRequest() {
    StudyCenterVM.sendWatchHistoryRequest(this.loginData?.token ?? '', 1, 3).then((value: WatchHistoryInfo[]) => {
      this.watchHistoryList = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendOnlineRecommendRequest() {
    StudyCenterVM.sendNotLoggedRecommendRequest(3).then((value: GoodsInfo[]) => {
      this.notLoggedRecommendList = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendAllRequest() {
    if (this.loginData) {
      this.sendSummaryStudyRequest()
      this.sendLastStudyRequest()
      this.sendLearningRequest()
      this.sendWatchHistoryRequest()
      this.sendOnlineRecommendRequest()
    } else {
      this.sendNotLoggedRecommendRequest()
    }
  }

  aboutToAppear() {
    this.sendAllRequest()
  }

  build() {
    Column() {
      ToolBar({
        title: '学习中心',
        titleBackgroundColor: $r('app.color.transparent'),
        titleBackIcon: this.showBack ? $r('app.media.ic_back') : null,
        titleBackEnable: this.showBack,
        shadowColor: $r('app.color.transparent')
      })

      if (this.loginData) {
        this.hasLoginContent()
      } else {
        this.notLoginContent()
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .align(Alignment.Top)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  notLoginContent() {
    List() {
      ListItem() {
        Column() {
          Image(StudyCenterAvatarUtil.getRandomAvatar())
            .width($r('app.string.lpx_160'))
            .height($r('app.string.lpx_160'))
            .margin({ top: $r('app.string.lpx_24') })
          Text('游客')
            .margin({ top: $r('app.string.lpx_16') })
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.color_333333'))
          Text('立即登录')
            .width($r('app.string.lpx_240'))
            .height($r('app.string.lpx_72'))
            .margin({ top: $r('app.string.lpx_24') })
            .textAlign(TextAlign.Center)
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.white'))
            .fontWeight(FontWeight.Bold)
            .borderRadius($r('app.string.lpx_12'))
            .linearGradient({
              angle: 90,
              colors: [
                [$r('app.color.color_FC6D38'), 0.0],
                [$r('app.color.color_F12E29'), 0.7],
                [$r('app.color.color_F12E29'), 1.0]
              ]
            })
            .onClick(() => {
              App.get().pushUrl({
                url: RouterPath.CODE_LOGIN_PAGE
              }, router.RouterMode.Single)
            })
        }
      }
      .width(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.white'))

      ListItem() {
        Text('大家都喜欢这些课程，来试试看吧～')
          .width(Constants.FULL_PARENT)
          .height($r('app.string.lpx_104'))
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_80') })
      .backgroundColor($r('app.color.color_FAFAFA'))
      .borderRadius({
        topLeft: $r('app.string.lpx_20'),
        topRight: $r('app.string.lpx_20'),
        bottomLeft: 0,
        bottomRight: 0
      })

      ForEach(this.notLoggedRecommendList, (item: GoodsInfo, index) => {
        ListItem() {
          Row() {
            Image(item.coverUrlExtendVo?.centre)
              .alt($r('app.media.img_placeholder_horizontal'))
              .width($r('app.string.lpx_180'))
              .height($r('app.string.lpx_180'))
              .border({ radius: $r('app.string.lpx_8') })

            Column() {

              Text(item.contentName)
                .width(Constants.FULL_PARENT)
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.color_333333'))
                .fontSize(lpx2fp(28))
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Blank()

              Row() {
                CoursePriceLineStyleDisplayComp({
                  goodsInfo: item
                })
                Blank()

                CourseSaleStateDisplayComp({
                  goodsInfo: item
                })
              }
              .width(Constants.FULL_PARENT)
              .margin({ top: $r('app.string.lpx_10') })
            }
            .layoutWeight(1)
            .height($r('app.string.lpx_180'))
            .margin({ left: $r('app.string.lpx_24') })
          }
          .width(Constants.FULL_PARENT)
          .border({ radius: $r('app.string.lpx_20') })
        }
        .width(Constants.FULL_PARENT)
        .backgroundColor($r('app.color.color_FAFAFA'))
        .borderRadius({
          topLeft: 0,
          topRight: 0,
          bottomLeft: index == this.notLoggedRecommendList.length - 1 ? $r('app.string.lpx_20') : 0,
          bottomRight: index == this.notLoggedRecommendList.length - 1 ? $r('app.string.lpx_20') : 0
        })
        .padding({
          top: $r('app.string.lpx_12'),
          bottom: $r('app.string.lpx_12'),
          left: $r('app.string.lpx_20'),
          right: $r('app.string.lpx_20'),
        })

        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0,item.onlineFlag,item.goodsId,0)
        })
      })
    }
    .scrollBar(BarState.Off)
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .listDirection(Axis.Vertical)
    .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
    .backgroundColor($r('app.color.white'))
    .zIndex(0)

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
    List() {
      ListItem() {
        Row() {
          Column() {
            Text('今日学习')
              .fontColor($r('app.color.color_2F2F2F'))
              .fontSize(lpx2fp(24))
            Text(GoodsShowUtil.getTodayStudyTime(this.summaryStudyData))
              .fontColor($r('app.color.color_2F2F2F'))
              .fontSize(lpx2fp(40))
              .fontWeight(FontWeight.Bold)
              .margin({ top: $r('app.string.lpx_6') })
          }
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

          Column() {
            Text('累计学习')
              .fontColor($r('app.color.color_2F2F2F'))
              .fontSize(lpx2fp(24))
            Text(GoodsShowUtil.getTotalStudyTime(this.summaryStudyData))
              .fontColor($r('app.color.color_2F2F2F'))
              .fontSize(lpx2fp(40))
              .fontWeight(FontWeight.Bold)
              .margin({ top: $r('app.string.lpx_6') })
          }
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      }
      .height($r('app.string.lpx_180'))
      .backgroundImage($r('app.media.img_study_center_header'))
      .backgroundImageSize(ImageSize.Cover)
      .borderRadius($r('app.string.lpx_16'))

      ListItem() {
        Row() {
          Column() {
            Image($r('app.media.ic_study_material'))
              .width($r('app.string.lpx_64'))
              .height($r('app.string.lpx_64'))
            Text('学习资料')
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
              .margin({ top: $r('app.string.lpx_4') })
          }
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('app.color.white'))
          .borderRadius($r('app.string.lpx_8'))
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.STUDY_MATERIAL_PAGE
            })
          })

          Column() {
            Image($r('app.media.ic_my_practice'))
              .width($r('app.string.lpx_64'))
              .height($r('app.string.lpx_64'))
            Text('我的练习')
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
              .margin({ top: $r('app.string.lpx_4') })
          }
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('app.color.white'))
          .borderRadius($r('app.string.lpx_8'))
          .margin({ left: $r('app.string.lpx_22') })
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.MY_PRACTICE_PAGE
            })
          })
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      }
      .height($r('app.string.lpx_128'))
      .margin({ top: $r('app.string.lpx_24') })

      if (this.lastStudyInfo != null) {
        ListItem() {
          this.lastStudy()
        }
        .margin({ top: $r('app.string.lpx_24') })
      }

      if (this.learningList.length > 0) {
        ListItem() {
          this.boughtCourseTitle()
        }
        .margin({ top: $r('app.string.lpx_24') })

        ForEach(this.learningList, (item: LearningInfo, index: number) => {
          ListItem() {
            this.boughtCourseCell(item, index)
          }
        })
      } else {
        ListItem() {
          this.boughtCourseEmpty()
        }
        .margin({ top: $r('app.string.lpx_24') })
      }

      if (this.watchHistoryList?.length > 0) {
        ListItem() {
          this.watchHistoryTitle()
        }
        .margin({ top: $r('app.string.lpx_24') })

        ListItem() {
          this.watchHistoryContent()
        }
        .margin({ top: $r('app.string.lpx_24') })
      }

      ListItem() {
        this.recommendTitle()
      }
      .margin({ top: $r('app.string.lpx_24') })
      .visibility(this.onlineRecommendList?.length > 0 ? Visibility.Visible : Visibility.None
      )

      ForEach(this.onlineRecommendList, (item: GoodsInfo, index: number) => {
        ListItem() {
          this.recommendCell(item)
        }
        .width(Constants.FULL_PARENT)
        .backgroundColor($r('app.color.white'))
        .borderRadius({
          topLeft: index == 0 ? $r('app.string.lpx_16') : 0,
          topRight: index == 0 ? $r('app.string.lpx_16') : 0,
          bottomLeft: index == this.onlineRecommendList.length - 1 ? $r('app.string.lpx_16') : 0,
          bottomRight: index == this.onlineRecommendList.length - 1 ? $r('app.string.lpx_16') : 0,
        })
        .margin({ top: index == 0 ? $r('app.string.lpx_20') : 0 })
        .padding({
          top: index == 0 ? $r('app.string.lpx_24') : $r('app.string.lpx_12'),
          bottom: index == this.onlineRecommendList.length - 1 ? $r('app.string.lpx_24') : $r('app.string.lpx_12'),
          left: $r('app.string.lpx_20'),
          right: $r('app.string.lpx_20')
        })
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0, item.onlineFlag, item.goodsId, 0)
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .padding({
      bottom: $r('app.string.lpx_20'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
    })
  }

  @Builder
  lastStudy() {
    Column() {
      Text('上次学习')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)

      Row() {
        Image(this.lastStudyInfo?.coverUrlExtendVo?.centre)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .border({ radius: $r('app.string.lpx_8') })

        Column() {

          Row() {
            if (this.lastStudyInfo?.onlineFlag === 1) {
              Text('线下课')
                .fontColor($r('app.color.color_EE8432'))
                .fontSize(lpx2fp(20))
                .backgroundColor($r('app.color.color_FDF2E7'))
                .border({
                  width: $r('app.string.lpx_1'),
                  radius: $r('app.string.lpx_4'),
                  color: $r('app.color.color_EE8432')
                })
                .margin({ right: $r('app.string.lpx_8') })
                .padding({
                  top: $r('app.string.lpx_2'),
                  bottom: $r('app.string.lpx_2'),
                  left: $r('app.string.lpx_8'),
                  right: $r('app.string.lpx_8')
                })
            }

            Text(this.lastStudyInfo?.contentName)
              .layoutWeight(1)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }

          Text(`共${this.lastStudyInfo?.lesson || 0}节`)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_999999'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: $r('app.string.lpx_16') })

          Blank()

          Row() {
            Text(GoodsShowUtil.getStudyProgress(this.lastStudyInfo?.learningType ?? 0,
              this.lastStudyInfo?.learningRate ?? 0))
              .fontColor($r('app.color.color_666666'))
              .fontSize(lpx2fp(28))

            Blank()

            Text('继续学习')
              .height($r('app.string.lpx_48'))
              .fontSize(lpx2fp(28))
              .fontColor($r('app.color.white'))
              .textAlign(TextAlign.Center)
              .borderRadius($r('app.string.lpx_24'))
              .linearGradient({
                angle: 90,
                colors: [
                  [$r('app.color.color_FC6D38'), 0.0],
                  [$r('app.color.color_F12E29'), 0.7],
                  [$r('app.color.color_F12E29'), 1.0]
                ]
              })
              .padding({ left: $r('app.string.lpx_44'), right: $r('app.string.lpx_44') })

          }
          .width(Constants.FULL_PARENT)
          .margin({ top: $r('app.string.lpx_10') })
        }
        .layoutWeight(1)
        .height($r('app.string.lpx_180'))
        .margin({ left: $r('app.string.lpx_24') })
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_8'))
      .margin({ top: $r('app.string.lpx_24') })
      .padding($r('app.string.lpx_20'))
      .onClick(() => {
        CourseDetailActionUtil.courseDetail(this.lastStudyInfo?.tenantVO?.tenantId ?? 0, this.lastStudyInfo.onlineFlag,
          this.lastStudyInfo.goodsId, this.lastStudyInfo.subOrderId)
      })
    }
  }

  @Builder
  boughtCourseTitle() {
    Row() {
      Text('已购课程')
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))

      Text('查看全部')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))

      Image($r('app.media.ic_study_center_right'))
        .width($r('app.string.lpx_32'))
        .height($r('app.string.lpx_32'))
        .margin({ left: $r('app.string.lpx_12') })
    }
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Center)
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
  }

  @Builder
  boughtCourseEmpty() {
    Column() {
      Image($r('app.media.img_no_watch_history'))
        .width($r('app.string.lpx_375'))
        .height($r('app.string.lpx_375'))
      Text('暂无课程')
        .fontColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(28))
        .margin({ top: $r('app.string.lpx_20') })
    }
    .width(Constants.FULL_PARENT)
    .padding({ top: $r('app.string.lpx_48'), bottom: $r('app.string.lpx_52') })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  boughtCourseCell(item: LearningInfo, index: number) {
    Row() {
      Image(item.coverUrlExtendVo?.centre)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_180'))
        .height($r('app.string.lpx_180'))
        .border({ radius: $r('app.string.lpx_8') })

      Column() {

        Row() {
          if (item.goodsMode === 1) {
            Text('线下课')
              .fontColor($r('app.color.color_EE8432'))
              .fontSize(lpx2fp(20))
              .backgroundColor($r('app.color.color_FDF2E7'))
              .border({
                width: $r('app.string.lpx_1'),
                radius: $r('app.string.lpx_4'),
                color: $r('app.color.color_EE8432')
              })
              .margin({ right: $r('app.string.lpx_8') })
              .padding({
                top: $r('app.string.lpx_2'),
                bottom: $r('app.string.lpx_2'),
                left: $r('app.string.lpx_8'),
                right: $r('app.string.lpx_8')
              })
          }

          Text(this.lastStudyInfo?.contentName)
            .width(Constants.FULL_PARENT)
            .layoutWeight(1)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }

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
        .margin({ top: $r('app.string.lpx_10') })
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .margin({ left: $r('app.string.lpx_24') })
    }
    .backgroundColor($r('app.color.white'))
    .borderRadius({
      topLeft: index == 0 ? $r('app.string.lpx_8') : 0,
      topRight: index == 0 ? $r('app.string.lpx_8') : 0,
      bottomLeft: index == this.learningList.length - 1 ? $r('app.string.lpx_8') : 0,
      bottomRight: index == this.learningList.length - 1 ? $r('app.string.lpx_20') : 0
    })
    .margin({ top: index == 0 ? $r('app.string.lpx_24') : 0 })
    .padding({
      top: $r('app.string.lpx_12'),
      bottom: $r('app.string.lpx_12'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
    .onClick(() => {
      this.mSubOrderInfo = item
      this.sendOrderGoodRelatedRequest()
    })
  }

  @Builder
  watchHistoryTitle() {
    Row() {
      Text('观看历史')
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))

      Text('查看全部')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))

      Image($r('app.media.ic_study_center_right'))
        .width($r('app.string.lpx_32'))
        .height($r('app.string.lpx_32'))
        .margin({ left: $r('app.string.lpx_12') })
    }
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      if (this.loginData) {
        App.get().pushUrl({
          url: RouterPath.WATCH_HISTORY_PAGE
        })
      } else {
        App.get().pushUrl({
          url: RouterPath.CODE_LOGIN_PAGE
        }, router.RouterMode.Single)
      }
    })
  }

  @Builder
  watchHistoryContent() {
    List() {
      ForEach(this.watchHistoryList, (item: WatchHistoryInfo) => {
        ListItem() {
          Column() {
            Stack() {
              Image(item.coverUrlExtendVo?.centre)
                .alt($r('app.media.img_placeholder_horizontal'))
                .width(Constants.FULL_PARENT)
                .height(Constants.FULL_PARENT)
                .borderRadius({ topLeft: $r('app.string.lpx_12'), topRight: $r('app.string.lpx_12') })

              Image($r('app.media.ic_study_center_play'))
                .width($r('app.string.lpx_48'))
                .height($r('app.string.lpx_48'))

            }
            .width(Constants.FULL_PARENT)
            .height($r('app.string.lpx_180'))

            Text(item.contentName)
              .width(Constants.FULL_PARENT)
              .textAlign(TextAlign.Start)
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: $r('app.string.lpx_8') })
          }
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
        .width($r('app.string.lpx_180'))
        .height($r('app.string.lpx_268'))
        .margin({
          left: $r('app.string.lpx_10'),
          right: $r('app.string.lpx_10')
        })
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0, item.onlineFlag, item.goodsId)
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Horizontal)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_8'))
    .margin({ top: $r('app.string.lpx_32') })
    .padding({
      left: $r('app.string.lpx_10'),
      right: $r('app.string.lpx_10')
    })
  }

  @Builder
  recommendTitle() {
    Text('课程推荐')
      .width(Constants.FULL_PARENT)
      .fontWeight(FontWeight.Bold)
      .fontColor($r('app.color.color_333333'))
      .fontSize(lpx2fp(36))
  }

  @Builder
  recommendCell(item: GoodsInfo) {
    Row() {
      Image(item.coverUrlExtendVo?.centre)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_180'))
        .height($r('app.string.lpx_180'))
        .border({ radius: $r('app.string.lpx_8') })

      Column() {

        Text(item.contentName)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Blank()

        Row() {
          CoursePriceLineStyleDisplayComp({
            goodsInfo: item
          })
          Blank()

          CourseSaleStateDisplayComp({
            goodsInfo: item
          })
        }
        .width(Constants.FULL_PARENT)
        .margin({ top: $r('app.string.lpx_10') })
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .margin({ left: $r('app.string.lpx_24') })
    }
    .width(Constants.FULL_PARENT)
  }
}
