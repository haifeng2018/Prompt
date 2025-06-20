/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ShoppingCartOffShelevesCell
 * Author: Victor
 * Date: 2023/12/11 11:15
 * Description: 
 * -----------------------------------------------------------------
 */
/*
import { ShoppingCartInfo } from 'lib_core_model/src/main/ets/data/ShoppingCartInfo';
import Constants from 'lib_core_model/src/main/ets/util/Constants';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';

@Component
export default struct ShoppingCartOffShelevesCell {
  private data?: ShoppingCartInfo;
  @Link @Watch('onClickIndexChanged') itemCheckIndex: number;
  public index: number = 0;

  onClickIndexChanged() {
    if (this.itemCheckIndex !== this.index) {
    }
  }

  build() {
    Row() {
      Image(this.data?.coverUrlExtendVo?.centre || $r('app.media.img_placeholder_horizontal'))
        .width($r('app.float.vp_180'))
        .height($r('app.float.vp_180'))
        .border({radius: $r('app.float.vp_8')})
        .margin({ left: $r('app.float.vp_64')})

      Column() {
        Text(this.data?.title)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_999999'))
          .fontSize($r('app.float.fp_28'))
          .maxLines(2)
          .textOverflow({overflow: TextOverflow.Ellipsis})

        Blank()

        Text('该课程已下架')
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_28'))
          .textAlign(TextAlign.End)
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
      ToastUtils.show("该课程已下架")
    })
  }
}
*/