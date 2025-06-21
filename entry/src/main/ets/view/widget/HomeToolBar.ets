import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'

@Preview
@Component
export struct HomeToolBar {
  @State title?: string = ''
  @State titleFontColor?: Resource = $r('app.color.color_333333')
  @State titleBackgroundColor?: Resource = $r('app.color.white')
  @State titleActionIcon?: Resource = $r('app.color.transparent')
  @State shadowColor?: Resource = $r('app.color.transparent')
  titleActionClick: () => void = () => {
  }

  build() {
    Row() {
      Text(this.title)
        .layoutWeight(1)
        .height($r('app.string.lpx_98'))
        .fontSize(lpx2fp(36))
        .fontColor(this.titleFontColor)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)

      Image(this.titleActionIcon)
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          this.titleActionClick()
        })
    }
    .expandSafeArea([SafeAreaType.KEYBOARD]) // 配置键盘弹出安全区域
    .width(Constants.FULL_PARENT)
    .backgroundColor(this.titleBackgroundColor)
    .padding({
      top: $r('app.string.lpx_60'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32'),
    })
    .shadow({
      radius: 5,
      color: this.shadowColor,
      offsetX: 5,
      offsetY: 5
    })
    .zIndex(1)
  }
}