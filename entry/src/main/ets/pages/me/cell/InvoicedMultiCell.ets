/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: UnUsedCouponCell
 * Author: Victor
 * Date: 2023/12/04 14:38
 * Description: 
 * -----------------------------------------------------------------
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { InvoicePageInfo } from 'lib_core_model/src/main/ets/data/InvoicePageInfo';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';

@Component
export default struct InvoicedMultiCell {
  private data?: InvoicePageInfo
  private onCellClick: () => void = () => {}

  build() {
    Column() {
      Row() {
        Text() {
          ImageSpan($r('app.media.ic_invoiced'))
            .width($r('app.string.lpx_24'))
            .height($r('app.string.lpx_24'))
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span('\t已开票')
            .fontSize(lpx2fp(28))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_777777'))
        }
        Blank()
        Text('查看详情')
          .height($r('app.string.lpx_52'))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_333333'))
          .border({
            width: $r('app.string.lpx_2'),
            radius: $r('app.string.lpx_26'),
            color: $r('app.color.color_777777')
          })
          .padding({left: $r('app.string.lpx_30'),right: $r('app.string.lpx_30')})
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_92'))
      .backgroundColor($r('app.color.color_F0F3F5'))
      .borderRadius({
        topLeft: $r('app.string.lpx_16'),
        topRight: $r('app.string.lpx_16')
      })
      .padding({left: $r('app.string.lpx_20'),right: $r('app.string.lpx_20')})

      Row(){
        List(){
          ForEach(GoodsShowUtil.getInvoiceImageByCount(this.data?.goodsUrlList,4),(item: string) => {
            ListItem() {
              Image(item)
                .alt($r('app.media.img_placeholder_horizontal'))
                .width(Constants.FULL_PARENT)
                .height(Constants.FULL_PARENT)
                .borderRadius($r('app.string.lpx_8'))
            }
            .width($r('app.string.lpx_100'))
            .height($r('app.string.lpx_100'))
            .margin({right: $r('app.string.lpx_20')})
          })
        }
        .layoutWeight(1)
        .height(Constants.FULL_PARENT)
        .listDirection(Axis.Horizontal)

        Text(){
          Span(`共${this.data?.goodsUrlList?.length ?? 0}件\t`)
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.color_777777'))
          ImageSpan($r('app.media.ic_right'))
            .width($r('app.string.lpx_20'))
            .height($r('app.string.lpx_20'))
            .verticalAlign(ImageSpanAlignment.CENTER)
        }
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_120'))
      .padding({
        top: $r('app.string.lpx_20'),
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })

      Row() {
        Blank()
        Text('可开票金额：')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
        Text('￥')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Text(AmountUtil.getRoundUp((this.data?.orderAmount ?? 0) / 100,2))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(40))
      }
      .width(Constants.FULL_PARENT)
      .padding({
        top: $r('app.string.lpx_20'),
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })

      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({ top: $r('app.string.lpx_20') })
      Row() {
        Text('订单编号：')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
        Text(this.data?.orderNo ?? '')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_78'))
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left: $r('app.string.lpx_20'),right: $r('app.string.lpx_20')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_16'))
    .margin({top: $r('app.string.lpx_32')})
    .onClick(() => this.onCellClick())
  }
}