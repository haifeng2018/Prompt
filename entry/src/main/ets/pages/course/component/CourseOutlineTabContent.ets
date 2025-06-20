import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import { ColumnInfo } from 'lib_core_model/src/main/ets/data/ColumnInfo'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import Logger from 'lib_core_model/src/main/ets/util/Logger'

@Component
export struct CourseOutlineTabContent {
  @State isInitLoad: boolean = false
  @Prop @Watch('onHistoryPlayIndexUpdate') historyPlayIndex: number = -1
  @Link playIndex: number
  @Prop goodsInfo: GoodsInfo = new GoodsInfo()
  private listScroller: Scroller = new Scroller()
  private tag: string = 'CourseOutlineTabContent'

  onHistoryPlayIndexUpdate() {
    Logger.info(this.tag, `historyPlayIndex = ${this.historyPlayIndex}`)
    if (this.historyPlayIndex != -1) {
      this.listScroller.scrollToIndex(this.historyPlayIndex)
      this.playIndex = this.historyPlayIndex
    }
  }

  checked(index: number) {
    return this.playIndex == index
  }

  build() {
    Column() {
      Text(this.goodsInfo.contentName)
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text('课程大纲')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: $r('app.string.lpx_32') })
      Text(GoodsShowUtil.getCourseDetailLessonUpdate(this.goodsInfo))
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(24))
        .margin({ top: $r('app.string.lpx_28') })

      List({ scroller: this.listScroller }) {
        ForEach(this.goodsInfo.columnParentVos, (item: ColumnInfo, index: number) => {
          ListItem() {
            Row() {
              Text(`${index + 1}`)
                .fontColor(this.checked(index) ? $r('app.color.color_FF1F00') : $r('app.color.color_666565'))
                .fontSize(lpx2fp(28))
              Column() {
                Text(item.contentName)
                  .width(Constants.FULL_PARENT)
                  .fontColor(this.checked(index) ? $r('app.color.color_FF1F00') : $r('app.color.color_333333'))
                  .fontSize(lpx2fp(28))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(GoodsShowUtil.getOutlineTypeDuration(item, this.goodsInfo.onlineFlag))
                  .fontColor(this.checked(index) ? $r('app.color.color_FF1F00') : $r('app.color.color_666666'))
                  .fontSize(lpx2fp(24))
                  .margin({ top: $r('app.string.lpx_20') })
              }
              .layoutWeight(1)
              .margin({ left: $r('app.string.lpx_20') })
              .alignItems(HorizontalAlign.Start)
            }
            .width(Constants.FULL_PARENT)
            .alignItems(VerticalAlign.Top)
            .onClick(() => {
              Logger.info(this.tag, `playIndex = ${index}`)
              this.playIndex = index
            })
          }
          .width(Constants.FULL_PARENT)
          .padding({
            top: $r('app.string.lpx_12'),
            bottom: $r('app.string.lpx_12'),
            left: $r('app.string.lpx_20'),
            right: $r('app.string.lpx_20')
          })
        })
      }
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .backgroundColor($r('app.color.color_FAFAFA'))
      .borderRadius($r('app.string.lpx_16'))
      .margin({ top: $r('app.string.lpx_16') })
    }
    .padding($r('app.string.lpx_32'))
  }
}
