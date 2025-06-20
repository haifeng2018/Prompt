/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LogisticsCell
 * Author: Victor
 * Date: 2024/07/04 11:08
 * Description: 
 * -----------------------------------------------------------------
 */
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil'
import { LogisticsInfo } from 'lib_core_model/src/main/ets/data/LogisticsInfo'
import { SubLogisticsInfo } from 'lib_core_model/src/main/ets/data/SubLogisticsInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'

@Component
export default struct LogisticsCell {
  private data?: LogisticsInfo
  @Link @Watch('onClickIndexChanged') clickIndex: number
  @State isExpanded: boolean = false
  public index: number = 0

  onClickIndexChanged() {
    if (this.clickIndex !== this.index) {
      this.isExpanded = false
    }
  }

  build() {
    Column() {
      Row(){
        Image($r('app.media.ic_jd_logistics'))
          .width($r('app.string.lpx_30'))
          .height($r('app.string.lpx_30'))
        Text(this.data?.logisticName ?? '')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({left: $r('app.string.lpx_16')})
        Text(this.data?.expressCode ?? '')
          .layoutWeight(1)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({left: $r('app.string.lpx_8')})
        Text('复制')
          .height($r('app.string.lpx_40'))
          .backgroundColor($r('app.color.color_F5F5F5'))
          .borderRadius($r('app.string.lpx_20'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .padding({left: $r('app.string.lpx_16'),right: $r('app.string.lpx_16')})
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        ClipboardUtil.copy(this.data?.expressCode ?? '')
      })

      List() {
        ForEach(this.isExpanded ? this.data?.dataList :this.data?.dataList?.slice(0,1),
          (item: SubLogisticsInfo,index: number) => {
          this.logisticsCell(item,index)
        })
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_24')})

      if ((this.data?.dataList?.length ?? 0) > 1) {
        this.expandMore()
      }
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({top: $r('app.string.lpx_32')})
    .padding({
      top: $r('app.string.lpx_24'),
      bottom: $r('app.string.lpx_24'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')})
  }

  @Builder logisticsCell(data: SubLogisticsInfo,index: number) {
    Column() {
      Row(){
        Column(){
          if (index === 0) {
            Circle()
              .width($r('app.string.lpx_28'))
              .height($r('app.string.lpx_28'))
              .fill($r('app.color.color_FC6D38'))
              .strokeWidth($r('app.string.lpx_4'))
              .stroke($r('app.color.color_FFC1AD'))
          }
          Line()
            .width($r('app.string.lpx_2'))
            .height($r('app.string.lpx_80'))
            .backgroundColor($r('app.color.color_D8D8D8'))
          Circle()
            .width($r('app.string.lpx_20'))
            .height($r('app.string.lpx_20'))
            .fill($r('app.color.color_D8D8D8'))
            .strokeWidth($r('app.string.lpx_4'))
            .stroke($r('app.color.color_D8D8D8'))
        }
        .width($r('app.string.lpx_28'))

        Column() {
          Text(data?.acceptStation ?? '')
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.color_777777'))
          Text(data?.acceptTime ?? '')
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_777777'))
            .margin({top: $r('app.string.lpx_4')})
        }
        .layoutWeight(1)
        .padding({left: $r('app.string.lpx_20')})
      }
      .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .alignItems(HorizontalAlign.Start)
  }

  @Builder expandMore() {
    Text() {
      Span(this.isExpanded ? '收起' : '展开')
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.color_777777'))
      ImageSpan($r('app.media.ic_order_down'))
        .width($r('app.string.lpx_30'))
        .height($r('app.string.lpx_30'))
        .margin({ left: $r('app.string.lpx_8') })
        .rotate({
          angle: this.isExpanded ? 180 : 0
        })
    }
    .onClick(() => {
      animateTo({ duration: Constants.DURATION }, () => {
        this.isExpanded = !this.isExpanded;
      })
      this.clickIndex = this.index;
    })
  }
}