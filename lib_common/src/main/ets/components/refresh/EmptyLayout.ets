/**
 * The load end layout component.
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'

@Component
export default struct EmptyLayout {

  build() {
    Column() {
      Image($r('app.media.img_no_data'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_400'))
        .objectFit(ImageFit.Contain)
      Text($r('app.string.no_data_error'))
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_666666'))
        .opacity(0.6)
    }
    .width(Constants.FULL_PARENT)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({top: $r('app.string.lpx_100')})
  }
}