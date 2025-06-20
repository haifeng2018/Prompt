import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import PhoneUtil from '../../util/PhoneUtil';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct CancelAccountPage {

  @State loginData: LoginData | null = null

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
  }

  build() {
    Column() {
      ToolBar({title: '账号注销'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {

      Image($r('app.media.ic_cancel_account_tip'))
        .width($r('app.string.lpx_120'))
        .height($r('app.string.lpx_120'))

      Text(`您将要注销的账号为${PhoneUtil.blurPhone(this.loginData?.phone)}`)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .margin({top: $r('app.string.lpx_20')})

      Column() {
        Text('注销账号之后无法恢复，请谨慎操作：')
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_F53F3F'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Text('1、无法再使用账号')
          .width(Constants.FULL_PARENT)
          .margin({top: $r('app.string.lpx_20')})
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Text('如果您确认注销,后续您将无法继续使用此账号在获课APP、H5等各终端继续观看视频、直播等内容。您之前在平台发布的内容都将做匿名处理。')
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .textAlign(TextAlign.Start)
          .margin({top: $r('app.string.lpx_20')})
          .padding({left: $r('app.string.lpx_40'), right: $r('app.string.lpx_40')})
        Text('2、以下信息将被删除')
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({top: $r('app.string.lpx_60')})
        Text('账号信息、第三方授权、认证身份、消息记录、会员及权益信息,已购买课程、账户余额、订单记录、收藏等信息。')
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .textAlign(TextAlign.Start)
          .margin({top: $r('app.string.lpx_20')})
          .padding({left: $r('app.string.lpx_40'), right: $r('app.string.lpx_40')})
        Text('3、点击“确认注销”将视为您授权并认可系统清空以上信息。')
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({top: $r('app.string.lpx_60')})
      }
      .width(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_24'))
      .margin({
        top: $r('app.string.lpx_48')
      })
      .padding({
        top: $r('app.string.lpx_32'),
        bottom: $r('app.string.lpx_40'),
        left: $r('app.string.lpx_24'),
        right: $r('app.string.lpx_24'),
      })

      Text('我再想想')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({top: $r('app.string.lpx_64')})
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          App.get().back()
        })

      Text('确认注销')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({top: $r('app.string.lpx_40')})
        .backgroundColor($r('app.color.color_EAEAEA'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          App.get().replaceUrl({
            url: RouterPath.ACCOUNT_CANCEL_VERIFICATION_PAGE
          })
        })

    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      top:$r('app.string.lpx_48'),
      left:$r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
