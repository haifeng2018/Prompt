import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { CommentInfo } from 'lib_core_model/src/main/ets/data/CommentInfo'
import { CommentNumData } from 'lib_core_model/src/main/ets/data/CommentNumData'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'

/**
 * 商品评价
 */
@Component
export default struct CourseDetailComment {
  @Prop goodsInfo: GoodsInfo | null = null
  @Prop commentNumData: CommentNumData | null = null
  @Prop commentInfo: CommentInfo | null = null

  build() {
    Column() {
      Row() {
        Text(`商品评价(${GoodsShowUtil.getGoodsPopularityTxt(this.commentNumData?.evaluateNum)})`)
          .layoutWeight(1)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.ic_course_detail_right'))
          .width($r('app.string.lpx_20'))
          .height($r('app.string.lpx_20'))
      }
      .width(Constants.FULL_PARENT)
      .padding({
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.COURSE_COMMENT_PAGE,
          params: {
            data: this.goodsInfo?.goodsId,
            tenantId: this.goodsInfo?.tenantVO?.tenantId
          }
        })
      })

      Row() {
        Image(this.commentInfo?.virHeadImg || $r('app.media.ic_avatar_place_holder'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))
          .borderRadius($r('app.string.lpx_20'))
        Text(this.commentInfo?.name)
          .layoutWeight(1)
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_8') })
        Text('好评')
          .height($r('app.string.lpx_38'))
          .fontColor($r('app.color.color_FA543E'))
          .fontSize(lpx2fp(24))
          .textAlign(TextAlign.Center)
          .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
          .backgroundColor($r('app.color.color_FFE6E0'))
          .border({
            width: $r('app.string.lpx_2'),
            radius: $r('app.string.lpx_8'),
            color: $r('app.color.color_FA543E')
          })
      }
      .width(Constants.FULL_PARENT)
      .margin({
        top: $r('app.string.lpx_24')
      })
      .padding({
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })

      if (this.commentInfo?.markContent) {
        Text(this.commentInfo?.markContent)
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({ top: $r('app.string.lpx_20') })
          .padding({
            top: $r('app.string.lpx_28'),
            bottom: $r('app.string.lpx_28'),
            left: $r('app.string.lpx_20'),
            right: $r('app.string.lpx_20')
          })
      }

      List() {
        ForEach(GoodsShowUtil.getCourseEvaluateUrl(this.commentInfo?.imgs), (url: string, index: number) => {
          ListItem() {
            Image(url || $r('app.media.img_placeholder_horizontal'))
              .width($r('app.string.lpx_212'))
              .height($r('app.string.lpx_212'))
              .borderRadius($r('app.string.lpx_8'))
          }
          .padding($r('app.string.lpx_10'))
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.POSTER_PAGE,
              params: {
                data: GoodsShowUtil.getCourseEvaluateUrl(this.commentInfo?.imgs),
                page_position: index
              }
            })
          })
        })
      }
      .width(Constants.FULL_PARENT)
      .lanes(3)
      .margin({ top: $r('app.string.lpx_20') })
      .padding({
        left: $r('app.string.lpx_10'),
        right: $r('app.string.lpx_10')
      })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .padding({
      left: $r('app.string.lpx_16'),
      right: $r('app.string.lpx_16'),
      top: $r('app.string.lpx_28'),
      bottom: $r('app.string.lpx_28'),
    })
    .margin({ top: $r('app.string.lpx_28'), })
    .visibility((this.commentInfo?.contentType ?? 0) == 0 ? Visibility.None : Visibility.Visible)
  }
}
