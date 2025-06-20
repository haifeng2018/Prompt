/**
 * The load end layout component.
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'

@Component
export default struct LoadFailedLayout {
  private onRetry: () => void = () =>{};

  build() {
    Column() {
      Image($r('app.media.img_network_error'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_400'))
        .objectFit(ImageFit.Contain)
      Text($r('app.string.server_error'))
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_666666'))
        .opacity(0.6)
      Button('点击重试',{ type: ButtonType.Normal, stateEffect: true })
        .height($r('app.string.lpx_52'))
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.color_EB4F3A'))
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_26'),
          color: $r('app.color.color_EB4F3A')
        })
        .margin({top: $r('app.string.lpx_60')})
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
    }
    .width(Constants.FULL_PARENT)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.onRetry()
    })
  }
}