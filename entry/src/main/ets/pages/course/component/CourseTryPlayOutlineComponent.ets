import { JSON } from '@kit.ArkTS'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import { ColumnInfo } from 'lib_core_model/src/main/ets/data/ColumnInfo'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { CommonNumbers, GoodsType, VideoTrialStatus } from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'

@Component
export struct CourseTryPlayOutlineComponent {
  tag: string = 'CourseTryPlayOutlineComponent'
  @ObjectLink @Watch('logger') goodsInfo: GoodsInfo | null
  @Prop currentPlayResource: ColumnInfo | null = null // 当前播放资源

  onItemClick = (item: ColumnInfo, index: number) => {
  }

  logger() {
    Logger.info(this.tag, `goodsInfo = ${JSON.stringify(this.goodsInfo)}`)
  }

  getExpandStateByIndex(index: number) {
    Logger.info(this.tag, `index = ${index}`)
    let expandState: boolean = true
    if (this.goodsInfo?.columnParentVos) {
      expandState = this.goodsInfo.columnParentVos[index].isExpand ?? true
    }
    return expandState
  }

  setExpandStateByIndex(index: number) {
    if (this.goodsInfo?.columnParentVos) {
      this.goodsInfo.columnParentVos[index].isExpand = !this.goodsInfo.columnParentVos[index].isExpand
    }
  }

  build() {
    Column() {
      Text('课程大纲')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
      Text(`购买后365天内有效，已更新${this.goodsInfo?.lesson ?? 0}/${this.goodsInfo?.classHour ?? 0}课时`)
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))
        .margin({ top: $r('app.string.lpx_28') })
      Column() {
        if (this.goodsInfo?.goodsType == GoodsType.SpecialColumn) {
          // 大专栏
          ForEach(this.goodsInfo?.columnParentVos, (item: ColumnInfo, index: number) => {
            Row() {
              Text(item?.contentName)
                .fontSize(lpx2fp(28))
                .fontColor($r('app.color.color_333333'))
                .fontWeight(FontWeight.Bold)
                .maxLines(1)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .layoutWeight(1)
              Image($r('app.media.ic_course_column_down'))
                .width($r('app.string.lpx_36'))
                .height($r('app.string.lpx_36'))
                .padding($r('app.string.lpx_7'))
                .rotate({
                  angle: item.isExpand ? 180 : 0
                })
            }
            .padding($r('app.string.lpx_20'))
            .borderRadius($r('app.string.lpx_8'))
            .backgroundColor($r('app.color.color_F6F6F6'))
            .margin({ top: $r('app.string.lpx_12'), bottom: $r('app.string.lpx_8') })
            .onClick(() => {
              animateTo({ duration: Constants.DURATION }, () => {
                this.setExpandStateByIndex(index)
                Logger.info(this.tag, `animateTo: isExpand = ${item.isExpand}, index = ${index}`)
              })
            })

            Column() {
              ForEach(item.columnVos, (data: ColumnInfo, position: number) => {
                this.line(position, data)
              })
            }
            .width(Constants.FULL_PARENT)
            .height(item.isExpand ? 0 : undefined)
          })
        } else {
          // 专栏
          ForEach(this.goodsInfo?.columnParentVos, (item: ColumnInfo, index: number) => {
            this.line(index, item)
          })
        }
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_28') })
      .padding({
        top: $r('app.string.lpx_12'),
        bottom: (this.goodsInfo?.lesson ?? 0) > CommonNumbers.Three ? 0 : $r('app.string.lpx_12'),
      })
      .backgroundColor(this.goodsInfo?.goodsType == GoodsType.SpecialColumn ? $r('app.color.transparent') :
      $r('app.color.color_FAFAFA'))
      .borderRadius($r('app.string.lpx_16'))
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .padding({
      top: $r('app.string.lpx_28'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }

  @Builder
  line(index: number, item: ColumnInfo) {
    Row() {
      Text(`${index + 1}`)
        .fontColor(
          this.currentPlayResource?.materialId == item.materialId ?
          $r('app.color.color_FF1F00') : $r('app.color.color_666565')
        )
        .fontSize(lpx2fp(28))
      Column() {
        Row() {
          Text(item?.contentName)
            .layoutWeight(1)
            .fontColor(
              this.currentPlayResource?.materialId == item.materialId ?
              $r('app.color.color_FF1F00') : $r('app.color.color_333333')
            )
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          if (item?.fragmentTrialFlag === VideoTrialStatus.TrialEnabled && item?.goodsType === GoodsType.Video) {
            Text('可试看')
              .fontColor(
                this.currentPlayResource?.materialId == item.materialId ?
                $r('app.color.color_FF1F00') : $r('app.color.color_666666')
              )
              .fontSize(lpx2fp(20))
              .backgroundColor(
                this.currentPlayResource?.materialId == item.materialId ?
                $r('app.color.color_FFE0E0') : $r('app.color.color_E6E6E6')
              )
              .borderRadius($r('app.string.lpx_4'))
              .padding({
                left: $r('app.string.lpx_6'),
                right: $r('app.string.lpx_6'),
                top: $r('app.string.lpx_2'),
                bottom: $r('app.string.lpx_2')
              })
          }
        }
        .width(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Start)

        Text(GoodsShowUtil.getOutlineTypeDuration(item, this.goodsInfo?.onlineFlag))
          .fontColor(
            this.currentPlayResource?.materialId === item.materialId ?
            $r('app.color.color_FF1F00') : $r('app.color.color_666666')
          )
          .fontSize(lpx2fp(24))
          .margin({ top: $r('app.string.lpx_20') })
      }
      .layoutWeight(1)
      .margin({ left: $r('app.string.lpx_20') })
      .alignItems(HorizontalAlign.Start)
    }
    .padding({
      top: $r('app.string.lpx_12'),
      bottom: $r('app.string.lpx_12'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Top)
    .onClick(() => {
      this.onItemClick(item, index)
    })
  }
}