import font from '@ohos.font'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout'
import App from 'lib_core_model/src/main/ets/App'
import { AdInfo } from 'lib_core_model/src/main/ets/data/AdInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { SignStatusInfo } from 'lib_core_model/src/main/ets/data/SignStatusInfo'
import { UserInfo } from 'lib_core_model/src/main/ets/data/UserInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import MessageVM from 'lib_core_model/src/main/ets/vm/MessageVM'
import UserVM from 'lib_core_model/src/main/ets/vm/UserVM'
import PhoneUtil from '../../util/PhoneUtil'

@Preview
@Component
export struct TutorialTabContent {
  @State mRefreshConfig: RefreshConfig<object> = new RefreshConfig<object>()
  @Link @Watch('sendUserInfoRequest') loginData: LoginData;
  @State mUserInfo: UserInfo = new UserInfo()
  @State mAdInfo: AdInfo = new AdInfo()
  @State mSignStatusCount: number = 0

  aboutToAppear(): void {
    font.registerFont({
      familyName: 'myfont',
      familySrc: '/fonts/iconfont.ttf'
    })
    this.sendAllRequest()
  }

  sendAllRequest() {
    if (this.loginData) {
      this.sendUserInfoRequest()
      this.sendSignStatusRequest()
    }
  }

  sendSignStatusRequest () {
    MessageVM.sendSignStatusRequest(this.loginData?.token ?? '').then((value: SignStatusInfo[]) => {
      this.mSignStatusCount = value.length
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendUserInfoRequest() {
    UserVM.sendUserInfoRequest(this.loginData?.token ?? '').then((data: UserInfo) => {
      this.mUserInfo = data
      AppConfig.setUserInfo(this.mUserInfo)
      this.mRefreshConfig.setAllData(Array.of(data), true, 1)
    }).catch((err: string | Resource) => {
      this.mRefreshConfig.setData([], false)
      ToastUtils.show(err)
    })
  }

  handleHeadClick() {
    App.get().pushUrl({
      url: RouterPath.EDIT_PROFILE_PAGE
    })
  }

  handleOrderClick(index: number) {
    switch (index) {
      case 1: // 未支付
        App.get().pushUrl({
          url: RouterPath.MY_ORDER_PAGE,
          params: {
            page_position: 1
          }
        })
        break
      case 2: // 待评价
        App.get().pushUrl({
          url: RouterPath.MY_ORDER_PAGE,
          params: {
            page_position: 4
          }
        })
        break
      case 3: // 已完成
        App.get().pushUrl({
          url: RouterPath.MY_ORDER_PAGE,
          params: {
            page_position: 2
          }
        })
        break
      case 4: // 全部订单
        App.get().pushUrl({
          url: RouterPath.MY_ORDER_PAGE,
          params: {
            page_position: 0
          }
        })
        break
    }
  }

  handleBottomClick(index: number) {
    switch (index) {
      case 1: // 我的优惠券
        App.get().pushUrl({
          url: RouterPath.MY_COUPON_PAGE
        })
        break
      case 2: // 我的收藏
        App.get().pushUrl({
          url: RouterPath.MY_FAVORITE_PAGE
        })
        break
      case 3: // 发票服务
        App.get().pushUrl({
          url: RouterPath.INVOICE_SERVICE_PAGE
        })
        break
      case 4: // 意见反馈
        App.get().pushUrl({
          url: RouterPath.FEEDBACK_PAGE
        })
        break
      case 5: // 设置
        App.get().pushUrl({
          url: RouterPath.SETTING_PAGE
        })
        break
    }
  }

  build() {
    Column() {
      this.titleBar()
      SwipeRefreshLayout({
        refreshConfig: this.mRefreshConfig,
        itemLayout: (): void => this.content(),
        onRefresh: () => {
          this.sendUserInfoRequest()
        }
      })
        .width(Constants.FULL_PARENT)
        .layoutWeight(1)
        .margin({ top: $r('app.string.lpx_10') })
        .zIndex(0)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .linearGradient({
      angle: 180,
      colors: [
        [$r('app.color.color_F7E8EB'), 0.0],
        [$r('app.color.color_F8EEF6'), 0.26],
        [$r('app.color.color_F8F9FD'), 1.0]
      ]
    })
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  titleBar() {
    Stack() {
      Column() {
        Badge({
          value: '',
          style: {
            badgeSize: 6,
            badgeColor: this.mSignStatusCount === 1 ? $r('app.color.color_EB4F3A') : $r('app.color.transparent'),
            borderColor: this.mSignStatusCount === 1 ? $r('app.color.color_EB4F3A') : $r('app.color.transparent')
          }
        }) {
          Image($r('app.media.ic_home_notity'))
            .width($r('app.string.lpx_40'))
            .height($r('app.string.lpx_40'))
        }
        .width($r('app.string.lpx_40'))
        .height($r('app.string.lpx_40'))
        .margin({ top: $r('app.string.lpx_20') })

        Text('消息')
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_333333'))
          .margin({ top: $r('app.string.lpx_4') })
      }
    }
    .width(Constants.FULL_PARENT)
    .alignContent(Alignment.TopEnd)
    .padding({
      top: $r('app.string.lpx_100'),
      right: $r('app.string.lpx_32')
    })
    .zIndex(1)
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.NOTIFICATION_PAGE,
        params: {}
      })
    })
  }

  @Builder
  content() {
    Column() {
      List() {
        ListItem() {
          this.head()
        }
        .margin({ top: $r('app.string.lpx_32') })
      }
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
      .edgeEffect(EdgeEffect.None)
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({ top: $r('app.string.lpx_10') })
    .padding({ bottom: $r('app.string.lpx_20') })
  }

  @Builder head() {
    Row() {
      Image(this.mUserInfo?.headImg || $r('app.media.ic_avatar_place_holder'))
        .width($r('app.string.lpx_140'))
        .height($r('app.string.lpx_140'))
        .border({
          radius: $r('app.string.lpx_70'),
          width: $r('app.string.lpx_2'),
          color: $r('app.color.white')
        })

      Column() {
        Text(this.mUserInfo?.name)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(36))
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(PhoneUtil.blurPhone(this.mUserInfo.phone ?? 'undefined'))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: $r('app.string.lpx_20') })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: $r('app.string.lpx_20') })

      Text('\ue88e')
        .fontSize(lpx2fp(64))
        .fontColor($r('app.color.color_999999'))
        .fontFamily('myfont')
    }
    .width(Constants.FULL_PARENT)
    .onClick(() => {
      this.handleHeadClick()
    })
  }

}

