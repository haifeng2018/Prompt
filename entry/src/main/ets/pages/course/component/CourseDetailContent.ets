import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'

@Component
export default struct CourseDetailContent {
  tag = 'CourseDetailContent'
  @Prop @Watch('onGoodsInfoUpdate') goodsInfo: GoodsInfo | null = null
  @State richTextOption: RichTextOption = {
    content: this.goodsInfo?.content ?? ''
  }

  onGoodsInfoUpdate() {
    this.richTextOption = { content: this.goodsInfo?.content ?? '' }
  }

  build() {
    Column() {
      Row() {
        Line()
          .width($r('app.string.lpx_80'))
          .height($r('app.string.lpx_4'))
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FAF8F8'), 0.0],
              [$r('app.color.color_D9D7D7'), 0.7],
              [$r('app.color.color_D9D7D7'), 1.0]
            ]
          })

        Text('详情内容')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(32))
          .margin({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })

        Line()
          .width($r('app.string.lpx_80'))
          .height($r('app.string.lpx_4'))
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_D9D7D7'), 0.0],
              [$r('app.color.color_FAF8F8'), 0.7],
              [$r('app.color.color_FAF8F8'), 1.0]
            ]
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_88'))
      .justifyContent(FlexAlign.Center)

      HPRichText({
        richTextOption: this.richTextOption
      })

    }
    .width(Constants.FULL_PARENT)
  }
}