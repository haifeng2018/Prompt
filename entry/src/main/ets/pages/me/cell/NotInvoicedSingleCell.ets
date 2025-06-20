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

@Component
export default struct NotInvoicedSingleCell {
  private data?: InvoicePageInfo
  private onCellClick: () => void = () => {}

  build() {
   this.content()
  }

  @Builder content() {
    Column() {
      Row() {
        Text() {
          ImageSpan($r('app.media.ic_not_invoiced'))
            .width($r('app.string.lpx_24'))
            .height($r('app.string.lpx_24'))
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span('\t未开票')
            .fontSize(lpx2fp(28))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_ED1B24'))
        }
        Blank()
        Text('申请开票')
          .height($r('app.string.lpx_52'))
          .borderRadius($r('app.string.lpx_26'))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.white'))
          .padding({left: $r('app.string.lpx_30'),right: $r('app.string.lpx_30')})
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'),0.0],
              [$r('app.color.color_F12E29'),0.7],
              [$r('app.color.color_F12E29'),1.0]
            ]
          })
          .onClick(() => this.onCellClick())
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_92'))
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor($r('app.color.color_FFF7F5'))
      .borderRadius({
        topLeft: $r('app.string.lpx_16'),
        topRight: $r('app.string.lpx_16')
      })
      .padding({left: $r('app.string.lpx_20'),right: $r('app.string.lpx_20')})

      Row() {
        Image(this.data?.goodsUrlList?.[0] ?? '')
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .borderRadius($r('app.string.lpx_8'))
        Column(){
          Text(this.data?.goodsName ?? '')
            .width(Constants.FULL_PARENT)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
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
        }
        .layoutWeight(1)
        .height($r('app.string.lpx_180'))
        .padding({left: $r('app.string.lpx_20')})
        .justifyContent(FlexAlign.SpaceBetween)
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
  }

  @Builder content2() {
    Column() {
      RelativeContainer() {
        Text() {
          ImageSpan($r('app.media.ic_not_invoiced'))
            .width($r('app.string.lpx_24'))
            .height($r('app.string.lpx_24'))
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span('\t未开票')
            .fontSize(lpx2fp(28))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_ED1B24'))
        }
        .id('tv_status')
        .alignRules({
          top: {anchor: "__container__", align: VerticalAlign.Top},
          left: {anchor: "__container__", align: HorizontalAlign.Start}
        })
        .height($r('app.string.lpx_92'))
        .backgroundColor($r('app.color.color_FFF7F5'))
        .borderRadius({
          topLeft: $r('app.string.lpx_16'),
          topRight: $r('app.string.lpx_16')
        })
        .padding({left: $r('app.string.lpx_20'),right: $r('app.string.lpx_20')})

        Text('申请开票')
          .height($r('app.string.lpx_52'))
          .borderRadius($r('app.string.lpx_26'))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.white'))
          .padding({left: $r('app.string.lpx_30'),right: $r('app.string.lpx_30')})
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'),0.0],
              [$r('app.color.color_F12E29'),0.7],
              [$r('app.color.color_F12E29'),1.0]
            ]
          })
          .id('tv_apply_invoice')
          .alignRules({
            top: {anchor: "tv_status", align: VerticalAlign.Top},
            bottom: {anchor: "tv_status", align: VerticalAlign.Bottom},
            right: {anchor: "__container__", align: HorizontalAlign.End},
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_92'))
      .backgroundColor($r('app.color.color_FFF7F5'))
      .borderRadius({
        topLeft: $r('app.string.lpx_16'),
        topRight: $r('app.string.lpx_16')
      })
      .padding({left: $r('app.string.lpx_20'),right: $r('app.string.lpx_20')})

      RelativeContainer() {
        Image(this.data?.goodsUrlList?.[0] ?? '')
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .borderRadius($r('app.string.lpx_8'))
          .id('iv_post')
          .alignRules({
            left: {anchor: "__container__", align: HorizontalAlign.Start}
          })
        Text(this.data?.goodsName ?? '')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .id('tv_goods_name')
          .alignRules({
            top: {anchor: "iv_post", align: VerticalAlign.Top},
            left: {anchor: "iv_post", align: HorizontalAlign.End},
            right: {anchor: "__container__", align: HorizontalAlign.End}
          })
          .margin({left: $r('app.string.lpx_20')})
      }
      .width('auto')
      .height('auto')
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
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_16'))
    .margin({top: $r('app.string.lpx_32')})
  }
}