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
import { HomeToolBar } from '../../view/widget/HomeToolBar'

@Preview
@Component
export struct MeTabContent {
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
      case 1: // 提词器会员
        App.get().pushUrl({
          url: RouterPath.MY_COUPON_PAGE
        })
        break
      case 2: // 网页编辑台词
        App.get().pushUrl({
          url: RouterPath.MY_FAVORITE_PAGE
        })
        break
      case 3: // 专属蓝牙遥控器
        App.get().pushUrl({
          url: RouterPath.INVOICE_SERVICE_PAGE
        })
        break
      case 4: // 激活码
        App.get().pushUrl({
          url: RouterPath.FEEDBACK_PAGE
        })
        break
      case 5: // 关于我们
        App.get().pushUrl({
          url: RouterPath.SETTING_PAGE
        })
        break
      case 6: // 我的客服
        App.get().pushUrl({
          url: RouterPath.SETTING_PAGE
        })
        break
      case 7: // 微信公众号
        App.get().pushUrl({
          url: RouterPath.SETTING_PAGE
        })
        break
      case 8: // 分享好友
        App.get().pushUrl({
          url: RouterPath.SETTING_PAGE
        })
        break
      case 9: // 设置
        App.get().pushUrl({
          url: RouterPath.SETTING_PAGE
        })
        break
    }
  }

  build() {
    Column() {
      HomeToolBar({ title: '我的' })
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
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  content() {
    Column() {
      List() {
        ListItem() {
          this.head()
        }
        .margin({ top: $r('app.string.lpx_32') })

        ListItem() {
          this.bottom()
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
    Column() {
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
          Text(`用户 ID:${this.mUserInfo?.openId ?? ''}`)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: $r('app.string.lpx_20') })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({ left: $r('app.string.lpx_20') })

        Text('开通会员')
          .height($r('app.string.lpx_68'))
          .fontSize(lpx2fp(32))
          .fontColor($r('app.color.white'))
          .backgroundColor($r('app.color.color_accent'))
          .borderRadius($r('app.string.lpx_34'))
          .padding({
            left: $r('app.string.lpx_16'),
            right: $r('app.string.lpx_16')
          })
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        this.handleHeadClick()
      })
      Line().lineStyle()
        .margin({ top : $r('app.string.lpx_40') })

      Text('VIP 开通会员享受更多特权/专属服务')
        .width(Constants.FULL_PARENT)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_333333'))
        .margin({ top : $r('app.string.lpx_20') })
    }
    .backgroundColor($r('app.color.color_80DDDDDD'))
    .borderRadius($r('app.string.lpx_10'))
    .padding($r('app.string.lpx_20'))
  }

  @Builder bottom() {
    Column() {
      this.bottomItem($r('app.media.ic_me_coupon'), '提词器会员', 1, true)
      this.bottomItem($r('app.media.ic_me_fav'), '网页编辑台词', 2, true)
      this.bottomItem($r('app.media.ic_me_invoice_service'), '专属蓝牙遥控器', 3, true)
      this.bottomItem($r('app.media.ic_me_feedback'), '激活码', 4, true)
      this.bottomItem($r('app.media.ic_me_setting'), '关于我们', 5, true)
      this.bottomItem($r('app.media.ic_me_setting'), '我的客服', 6, true)
      this.bottomItem($r('app.media.ic_me_setting'), '微信公众号', 7, true)
      this.bottomItem($r('app.media.ic_me_setting'), '分享好友', 8, true)
      this.bottomItem($r('app.media.ic_me_setting'), '设置', 9, false)
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .alignItems(HorizontalAlign.Start)
  }

  @Builder bottomItem(image: Resource, title: string, index: number, hasLine: boolean) {
    Row() {
      Image(image)
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
      Text(title)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .layoutWeight(1)
        .margin({ left: $r('app.string.lpx_20') })
      Image($r('app.media.ic_right'))
        .width($r('app.string.lpx_20'))
        .height($r('app.string.lpx_20'))
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_104'))
    .padding({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })
    .onClick(() => {
      this.handleBottomClick(index)
    })

    if (hasLine) {
      Line().lineStyle()
    }
  }
}

@Extend(Line)
function lineStyle() {
  .width(Constants.FULL_PARENT)
  .height($r('app.string.lpx_1'))
  .backgroundColor($r('app.color.color_EFEFEF'))
  .padding({ left: $r('app.string.lpx_1'), right: $r('app.string.lpx_1') })
}

