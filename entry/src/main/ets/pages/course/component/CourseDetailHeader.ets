import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { CoverUrlExtendInfo } from 'lib_core_model/src/main/ets/data/CoverUrlExtendInfo'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'

@Component
export default struct CourseDetailHeader {
  @Prop goodsInfo: GoodsInfo | null = null
  @State selectedIndex: number = 0

  build() {
    Stack() {
      Swiper() {
        ForEach(this.goodsInfo?.coverUrlExtendVos, (item: CoverUrlExtendInfo, index: number) => {
          Image(item?.big || $r('app.media.img_placeholder_horizontal'))
            .width(Constants.FULL_PARENT)
            .height(Constants.FULL_PARENT)
            .objectFit(ImageFit.Cover)
            .onClick(() => {
              App.get().pushUrl({
                url: RouterPath.POSTER_PAGE,
                params: {
                  data: GoodsShowUtil.getPostUrl(this.goodsInfo?.coverUrlExtendVos),
                  page_position: this.selectedIndex
                }
              })
            })
        })
      }
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .cachedCount(this.goodsInfo?.coverUrlExtendVos?.length ?? 0)
      .index(0)
      .autoPlay(false)
      .indicator(false)
      .loop((this.goodsInfo?.coverUrlExtendVos?.length ?? 0) > 1)
      .duration(300)
      .curve(Curve.Linear)
      .onChange((index: number) => {
        this.selectedIndex = index
      })

      Text(`${this.selectedIndex + 1}/${this.goodsInfo?.coverUrlExtendVos?.length}`)
        .height($r('app.string.lpx_48'))
        .backgroundColor($r('app.color.color_66000000'))
        .borderRadius($r('app.string.lpx_24'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(24))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({ bottom: $r('app.string.lpx_44'), right: $r('app.string.lpx_28') })
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
        .visibility((this.goodsInfo?.coverUrlExtendVos?.length ?? 0) > 1 ? Visibility.Visible : Visibility.None)

      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_40'))
        .backgroundColor($r('app.color.color_F9F9F9'))
        .offset({ y: $r('app.string.lpx_20') })
        .borderRadius({
          topLeft: $r('app.string.lpx_20'),
          topRight: $r('app.string.lpx_20')
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_750'))
    .alignContent(Alignment.BottomEnd)
  }
}
