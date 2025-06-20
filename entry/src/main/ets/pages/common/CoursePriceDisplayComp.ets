import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { OnlineFlag } from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'

/**
 * 课程价格展示，用于行
 */
@Component
export struct CoursePriceLineStyleDisplayComp {
  tag: string = 'PriceLineDisplayComp'
  goodsInfo: GoodsInfo = new GoodsInfo()
  pricesFontSize: number = lpx2fp(28)
  @State marketPrice: number = 0
  @State isShowMarketPrice: boolean = false
  @State prices: string[] = []

  aboutToAppear(): void {
    let price = GoodsShowUtil.getCourseDetailAmount(this.goodsInfo)
    this.prices = price.split('.')
    this.marketPrice = GoodsShowUtil.getCourseDetailMarketPrice(this.goodsInfo)
  }

  build() {
    Text() {
      Span('￥')
        .fontColor($r('app.color.color_FF1F00'))
        .fontSize(lpx2fp(20))
      Span(this.prices[0] ?? '')
        .fontColor($r('app.color.color_FF1F00'))
        .fontSize(this.pricesFontSize)
      Span(`.${this.prices[1] ?? ''}`)
        .fontColor($r('app.color.color_FF1F00'))
        .fontSize(lpx2fp(20))
      Span('\t')
      if (this.marketPrice > 0 && this.isShowMarketPrice) {
        Span((this.marketPrice / 100).toFixed(2) ?? '')
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(20))
          .margin({ left: $r('app.string.lpx_8') })
          .decoration({
            type: TextDecorationType.LineThrough,
            color: $r('app.color.color_999999'),
            style: TextDecorationStyle.SOLID
          })
      }
    }
    .visibility(this.goodsInfo ? Visibility.Visible : Visibility.Hidden)
  }
}


/**
 * 课程价格展示，用于标题
 */
@Component
export struct CoursePriceTitleStyleDisplayComp {
  tag: string = 'PriceDisplayComp'
  @Prop @Watch('onGoodsInfoChange') goodsInfo: GoodsInfo | null = null
  @State marketPrice: number = 0
  @State prices: string[] = []

  aboutToAppear(): void {
    this.onGoodsInfoChange()
  }

  onGoodsInfoChange() {
    Logger.info(this.tag, `goodsInfo = ${JSON.stringify(this.goodsInfo)}`)
    if (this.goodsInfo?.onlineFlag == OnlineFlag.Online) {
      let price = GoodsShowUtil.getCourseDetailAmount(this.goodsInfo)
      this.prices = price.split('.')
      this.marketPrice = GoodsShowUtil.getCourseDetailMarketPrice(this.goodsInfo)
    } else if (this.goodsInfo?.onlineFlag == OnlineFlag.Offline) {
      let price = GoodsShowUtil.getOfflineCoursePrice(this.goodsInfo)
      this.prices = price.split('.')
      this.marketPrice = GoodsShowUtil.getCourseDetailMarketPrice(this.goodsInfo)
    }
    Logger.info(this.tag, `prices = ${this.prices},marketPrice = ${this.marketPrice}`)
  }

  build() {
    Text() {
      Span('￥')
        .fontColor($r('app.color.color_FF1F00'))
        .fontSize(lpx2fp(28))
      Span(this.prices[0] ?? '')
        .fontColor($r('app.color.color_FF1F00'))
        .fontSize(lpx2fp(48))
      Span(`.${this.prices[1] ?? ''}`)
        .fontColor($r('app.color.color_FF1F00'))
        .fontSize(lpx2fp(20))
      Span('\t')
      if (this.marketPrice > 0) {
        Span((this.marketPrice / 100).toFixed(2) ?? '')
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_8') })
          .decoration({
            type: TextDecorationType.LineThrough,
            color: $r('app.color.color_999999'),
            style: TextDecorationStyle.SOLID
          })
      }
    }
    .visibility(this.goodsInfo ? Visibility.Visible : Visibility.Hidden)
  }
}