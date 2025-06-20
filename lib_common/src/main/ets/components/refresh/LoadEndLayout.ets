import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'

/**
 * The load end layout component.
 */
@Component
export default struct LoadEndLayout {
  build() {
    Row() {
      Line()
        .layoutWeight(1)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_CCCCCC'))
      Text('到底啦')
        .fontColor($r('app.color.color_CCCCCC'))
        .fontSize(lpx2fp(28))
        .margin({ left: $r('app.string.lpx_10'), right: $r('app.string.lpx_10') })
      Line()
        .layoutWeight(1)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_CCCCCC'))
    }
    .width(Constants.FULL_PARENT)
    .padding({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })
    .height($r('app.string.lpx_100'))
  }
}