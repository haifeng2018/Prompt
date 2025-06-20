/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ShoppingCartOfflineNormalCell
 * Author: Victor
 * Date: 2023/12/11 11:15
 * Description: 
 * -----------------------------------------------------------------
 *//*

import { ShoppingCartInfo } from '../../bean/ShoppingCartInfo';
import AmountUtil from '../../util/AmountUtil';
import Constants from '../../util/Constants';
import CourseDetailActionUtil from '../../util/CourseDetailActionUtil';
import GoodsShowUtil from '../../util/GoodsShowUtil';
@Component
export default struct ShoppingCartOfflineNormalCell {
  private data?: ShoppingCartInfo;
  @Link @Watch('onClickIndexChanged') itemCheckIndex: number;
  public index: number = 0;

  @Consume(Constants.SHOPPING_CART_SELECT_KEY) selectProducts: { [K: string]: boolean }

  private onCounterSubAction: (data: ShoppingCartInfo) => void = () => {};
  private onCounterAddAction: (data: ShoppingCartInfo) => void = () => {};
  private onItemCheckAction: () => void = () => {};

  onClickIndexChanged() {
    if (this.itemCheckIndex !== this.index) {
    }
  }

  build() {
    Row() {
      Image(!!this.selectProducts[this.data.goodsId] ? $r('app.media.ic_shopping_checked') : $r('app.media.ic_shopping_normal'))
        .width($r('app.float.vp_32'))
        .height($r('app.float.vp_32'))
        .onClick(() => {
          this.onItemCheckAction()
        })

      Image(this.data?.coverUrlExtendVo?.centre)
        .width($r('app.float.vp_180'))
        .height($r('app.float.vp_180'))
        .border({radius: $r('app.float.vp_8')})
        .margin({ left: $r('app.float.vp_16')})

      Column() {
        Text(this.data?.title)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_28'))
          .maxLines(2)
          .textOverflow({overflow: TextOverflow.Ellipsis})

        Row() {
          Text(this.data?.specName)
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_24'))

          Image($r('app.media.ic_shopping_cart_spec'))
            .width($r('app.float.vp_18'))
            .height($r('app.float.vp_12'))
            .margin({ left: $r('app.float.vp_10')})
          Blank()
        }
        .backgroundColor($r('app.color.color_EDEDED'))
        .borderRadius($r('app.float.vp_4'))
        .margin({
          top: $r('app.float.fp_20')
        })
        .padding({
          top: $r('app.float.fp_4'),
          bottom: $r('app.float.fp_4'),
          left: $r('app.float.fp_20'),
          right: $r('app.float.fp_20')
        })

        Blank()

        Row() {
          Text('￥')
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize($r('app.float.fp_20'))
          Text(AmountUtil.getRoundUp(this.data?.currentSalePrice/ 100,2))
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize($r('app.float.fp_28'))
            .margin({left: $r('app.float.vp_8')})
          Blank()

          Image($r('app.media.ic_count_sub'))
            .width($r('app.float.vp_48'))
            .height($r('app.float.vp_48'))
            .border({
              radius: {
                topLeft: $r('app.float.vp_4'),
                bottomLeft: $r('app.float.vp_4')
              },
              color: $r('app.color.color_E6E6E6'),
              width:$r('app.float.vp_2')
            })
            .onClick(() => {
              this.onCounterSubAction(this.data)
            })

          Text(`${this.data?.quantity}`)
            .height($r('app.float.vp_48'))
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_28'))
            .textAlign(TextAlign.Center)
            .padding({left: $r('app.float.vp_30'),right: $r('app.float.vp_30')})
            .border({
              color: $r('app.color.color_E6E6E6'),
              width:$r('app.float.vp_2')
            })

          Image($r('app.media.ic_count_add'))
            .width($r('app.float.vp_48'))
            .height($r('app.float.vp_48'))
            .border({
              radius: {
                topLeft: $r('app.float.vp_4'),
                bottomLeft: $r('app.float.vp_4')
              },
              color: $r('app.color.color_E6E6E6'),
              width:$r('app.float.vp_2')
            })
            .onClick(() => {
              this.onCounterAddAction(this.data)
            })
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.float.vp_10')})
      }
      .height($r('app.float.vp_180'))
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({left: $r('app.float.vp_24')})
    }
    .width(Constants.FULL_PARENT)
    .margin({ top: $r('app.float.vp_20')})
    .padding($r('app.float.vp_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.float.vp_12'))
    .onClick(() => {
      CourseDetailActionUtil.courseDetail(this.data?.onlineFlag, this.data?.goodsId,0)
    })
  }
}*/
