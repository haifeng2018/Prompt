import App from 'lib_core_model/src/main/ets/App';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';

@Component
export default struct CourseDetailOrganCell {
  @Prop goodsInfo: GoodsInfo | null = null

  build() {
    Row() {
      Image(this.goodsInfo?.tenantVO?.logoUrl)
        .alt($r('app.media.ic_organ_place_holder'))
        .width($r('app.string.lpx_80'))
        .height($r('app.string.lpx_80'))
        .borderRadius($r('app.string.lpx_40'))
      Text(this.goodsInfo?.tenantVO?.tenantName)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
        .margin({ left: $r('app.string.lpx_18') })
      Text('进店')
        .width($r('app.string.lpx_106'))
        .height($r('app.string.lpx_56'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'), 0.0],
            [$r('app.color.color_F12E29'), 0.7],
            [$r('app.color.color_F12E29'), 1.0]
          ]
        })
        .borderRadius($r('app.string.lpx_12'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(24))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .padding({
      top: $r('app.string.lpx_32'),
      bottom: $r('app.string.lpx_32'),
      left: $r('app.string.lpx_16'),
      right: $r('app.string.lpx_16')
    })
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.ORGAN_MAIN_PAGE,
        params: {
          tenantId: this.goodsInfo?.tenantVO?.tenantId
        }
      })
    })
  }
}