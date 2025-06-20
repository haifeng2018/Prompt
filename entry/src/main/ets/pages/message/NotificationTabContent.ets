/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: MyPracticeContent
 * Author: Victor
 * Date: 2023/12/01 15:58
 * Description: 
 * -----------------------------------------------------------------
 */
import LMList from 'lib_common/src/main/ets/components/refresh/LMList'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { NotificationInfo } from 'lib_core_model/src/main/ets/data/NotificationInfo'
import { NotificationParm } from 'lib_core_model/src/main/ets/data/NotificationParm'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import MessageVM from 'lib_core_model/src/main/ets/vm/MessageVM'
import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import { SignStatusInfo } from 'lib_core_model/src/main/ets/data/SignStatusInfo'
import { NotificationExtraInfo } from 'lib_core_model/src/main/ets/data/NotificationExtraInfo'
import App from 'lib_core_model/src/main/ets/App'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'

@Preview
@Component
export struct NotificationTabContent {

  @State refreshConfig: RefreshConfig<NotificationInfo> = new RefreshConfig<NotificationInfo>()

  @Link tabNotifications: Array<boolean>

  @State loginData: LoginData | null = null
  @State msgType: number = 0

  sendNotificationsRequest () {
    let body = new NotificationParm()
    body.current = this.refreshConfig.currentPage
    body.size = this.refreshConfig.PAGE_SIZE
    body.msgType = this.msgType
    MessageVM.sendNotificationsRequest(this.loginData?.token ?? '',body).then((value: NotificationInfo[]) => {
      this.refreshConfig.setData(value,true)
      this.sendReadNotificationsRequest(this.refreshConfig.data)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  sendReadNotificationsRequest (readList: Array<NotificationInfo>) {
    let readCount = readList?.length | 0
    if (readCount === 0) {
      return
    }

    let body = Array<number>()
    readList.forEach(value => {
      body.push(value.id ?? 0)
    })

    MessageVM.sendReadNotificationsRequest(this.loginData?.token ?? '',body).then((value: object) => {
      this.sendSignStatusRequest()
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendSignStatusRequest () {
    MessageVM.sendSignStatusRequest(this.loginData?.token ?? '').then((value: SignStatusInfo[]) => {
      this.tabNotifications[0] = GoodsShowUtil.getMsgSignStatusOpacity(value,0)
      this.tabNotifications[1] = GoodsShowUtil.getMsgSignStatusOpacity(value,1)
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  refreshData () {
    this.sendNotificationsRequest()
  }

  loadMoreData () {
    this.sendNotificationsRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: object,index: number): void => this.cellLayout(data),
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
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder cellLayout(item: NotificationInfo) {
    Column() {
      Row() {
        Text(GoodsShowUtil.getMsgType(item))
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(20))
          .border({
            width: $r('app.string.lpx_2'),
            radius: $r('app.string.lpx_4'),
            color: $r('app.color.color_999999')
          })
          .padding({
            top: $r('app.string.lpx_4'),
            bottom: $r('app.string.lpx_4'),
            left: $r('app.string.lpx_12'),
            right: $r('app.string.lpx_12')
          })
        Text('未读')
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(24))
          .margin({ left: $r('app.string.lpx_20') })
          .opacity(item?.signStatus == 2 ? 0: 1)
        Blank()
        Text(GoodsShowUtil.getMsgDetailTitle(item))
          .height($r('app.string.lpx_52'))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_DA3732'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_FEFAFA'))
          .border({
            width: $r('app.string.lpx_2'),
            radius: $r('app.string.lpx_26'),
            color: $r('app.color.color_DA3732')
          })
          .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
          .opacity(item?.msgType === 2 ? 1 : 0)
          .onClick(() => {
            let parseObject: NotificationExtraInfo = JSON.parse(item?.extraParams ?? '')
            if (parseObject?.redirectPage == '3') {
              App.get().pushUrl({
                url: RouterPath.REFUND_PAGE,
                params: {
                  subOrderId: parseObject.subOrderId,
                  tenantId:item?.tenantId
                }
              })
            } else  if (parseObject?.redirectPage == '6') {
              App.get().pushUrl({
                url: RouterPath.ORDER_DETAIL_PAGE,
                params: {
                  data: parseObject?.orderNo
                }
              })
            }
          })
      }
      .width(Constants.FULL_PARENT)

      Text(item?.content)
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Start)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .maxLines(3)
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .margin({top: $r('app.string.lpx_28')})

      Divider().strokeWidth(`${$r('app.string.lpx_2')}`)
        .color($r('app.color.color_EFEFEF'))
        .margin({top: $r('app.string.lpx_20')})

      Stack() {
        Text(DateUtil.transNumberDateHM(item?.sendTime ?? 0))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.End)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))

        Row() {
          Text('展开')
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(24))
          Image($r('app.media.ic_gray_arrow_down'))
            .width($r('app.string.lpx_20'))
            .height($r('app.string.lpx_12'))
            .margin({left: $r('app.string.lpx_8')})
        }
        .opacity(0)
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_74'))
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .margin({top: $r('app.string.lpx_24')})
    .padding($r('app.string.lpx_20'))
  }
}
