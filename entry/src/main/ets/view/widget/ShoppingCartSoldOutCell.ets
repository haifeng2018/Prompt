/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ShoppingCartSoldOutCell
 * Author: Victor
 * Date: 2023/12/11 11:15
 * Description: 
 * -----------------------------------------------------------------
 *//*

import { ShoppingCartInfo } from '../../bean/ShoppingCartInfo';
import Constants from '../../util/Constants';
import CourseDetailActionUtil from '../../util/CourseDetailActionUtil';
@Component
export default struct ShoppingCartSoldOutCell {
  private data?: ShoppingCartInfo;
  @Link @Watch('onClickIndexChanged') itemCheckIndex: number;
  public index: number = 0;

  onClickIndexChanged() {
    if (this.itemCheckIndex !== this.index) {
    }
  }

  build() {
    Row() {
      Image(this.data?.coverUrlExtendVo?.centre)
        .width($r('app.float.vp_180'))
        .height($r('app.float.vp_180'))
        .border({radius: $r('app.float.vp_8')})
        .margin({ left: $r('app.float.vp_64')})

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
          .padding({
            top: $r('app.float.fp_4'),
            bottom: $r('app.float.fp_4'),
            left: $r('app.float.fp_20'),
            right: $r('app.float.fp_20')
          })
          Blank()
          Text('当前规格已售罄')
            .fontColor($r('app.color.color_D95A44'))
            .fontSize($r('app.float.fp_24'))
        }
        .width(Constants.FULL_PARENT)
        .margin({
          top: $r('app.float.fp_20')
        })

        Row() {
          Text('请重新选择课程规格')
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_24'))

          Blank()

          Text('重选')
            .height($r('app.float.vp_48'))
            .fontColor($r('app.color.color_DA3732'))
            .fontSize($r('app.float.fp_24'))
            .textAlign(TextAlign.Center)
            .padding({left: $r('app.float.vp_30'),right: $r('app.float.vp_30')})
            .border({
              radius: $r('app.float.vp_24'),
              color: $r('app.color.color_D95A44'),
              width:$r('app.float.vp_2')
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
