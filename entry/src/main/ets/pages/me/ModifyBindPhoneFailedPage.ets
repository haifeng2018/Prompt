import App from 'lib_core_model/src/main/ets/App'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { ToolBar } from '../../view/widget/ToolBar'

@Entry
@Component
struct ModifyBindPhoneFailedPage {

  build() {
    Column() {
      ToolBar({title: '修改手机号码'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {

      Image($r('app.media.ic_modify_phone_failed'))
        .width($r('app.string.lpx_120'))
        .height($r('app.string.lpx_120'))

      Text('手机号码修改失败！')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .margin({top: $r('app.string.lpx_32')})

      Text('因网络等问题手机号码修改失败，请重试！')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_32')})

      Text('重新提交')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({top: $r('app.string.lpx_72')})
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          App.get().back()
        })
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      top:$r('app.string.lpx_32'),
      left:$r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
