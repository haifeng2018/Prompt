import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { SignStatusInfo } from 'lib_core_model/src/main/ets/data/SignStatusInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import MessageVM from 'lib_core_model/src/main/ets/vm/MessageVM'
import { ToolBar } from '../../view/widget/ToolBar'
import { NotificationTabContent } from './NotificationTabContent'

@Entry
@Component
struct NotificationPage {

  @State loginData: LoginData | null = null

  @State tabCheckPosition: number = 0
  private tabTitles = ['全部','交易']

  @State tabNotifications: Array<boolean> = [false,false]

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
      this.sendSignStatusRequest()
    })
  }

  build() {
    Column() {
      ToolBar({title: '消息',shadowColor: $r('app.color.transparent')})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {
        NotificationTabContent({
          msgType: 0,
          tabNotifications: $tabNotifications
        })
      }
      .tabBar(this.TabBuilder(0))
      .align(Alignment.Top)

      TabContent() {
        NotificationTabContent({
          msgType: 2,
          tabNotifications: $tabNotifications
        })
      }
      .tabBar(this.TabBuilder(1))
      .align(Alignment.Top)
    }
    .vertical(false)
    .barMode(BarMode.Fixed)
    .barWidth(Constants.FULL_PARENT)
    .barHeight($r('app.string.lpx_78'))
    .backgroundColor($r('app.color.white'))
    .onChange((index: number) => {
      this.tabCheckPosition = index
    })
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
  }

  @Builder TabBuilder(index: number) {
    Row(){
      Badge({
        value: '',
        style: {
          badgeSize: 6,
          badgeColor: this.tabNotifications[index] ? $r('app.color.color_EB4F3A') : $r('app.color.transparent'),
          borderColor: this.tabNotifications[index] ? $r('app.color.color_EB4F3A') : $r('app.color.transparent')
        }
      }) {
        Text(this.tabTitles[index])
          .fontColor($r('app.color.color_333333'))
          .fontSize(this.tabCheckPosition === index ? lpx2fp(32) : lpx2fp(30))
          .fontWeight(this.tabCheckPosition === index ? FontWeight.Bold : FontWeight.Normal)
          .padding({left: $r('app.string.lpx_5'), right: $r('app.string.lpx_5')})
      }

    }
    .height(Constants.FULL_PARENT)
    .padding({
      top:$r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
    })
  }
}
