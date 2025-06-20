import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { ToolBar } from '../../view/widget/ToolBar'

@Entry
@Component
struct FeedbackSuccessPage {
  build() {
    Column() {
      ToolBar({ title: '留言反馈' })
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  content() {
    Column() {
      Image($r('app.media.img_pay_success'))
        .width($r('app.string.lpx_120'))
        .height($r('app.string.lpx_120'))
      Text('提交成功')
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(FontWeight.Bold)
        .margin({ top: $r('app.string.lpx_40') })
      Text('我们会尽快解决处理您反馈到问题')
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_777777'))
        .margin({ top: $r('app.string.lpx_20') })
    }
    .width('90%')
    .margin({
      top: $r('app.string.lpx_32')
    })
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .zIndex(0)
  }
}
