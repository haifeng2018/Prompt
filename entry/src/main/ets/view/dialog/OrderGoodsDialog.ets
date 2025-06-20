import display from '@ohos.display';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';

/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrderGoodsDialog
 * Author: Victor
 * Date: 2022/12/8 15:14
 * Description: 
 * -----------------------------------------------------------------
 */

@CustomDialog
export default struct OrderGoodsDialog {
  controller: CustomDialogController;
  private subOrderInfos: Array<SubOrderInfo> | null = null

  build() {
    Column() {
      Stack() {
        Text('订单商品')
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(36))
          .textAlign(TextAlign.Center)

        Image($r('app.media.ic_dlg_feedback_type_close'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .onClick(() => {
            this.controller.close()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_88'))
      .alignContent(Alignment.End)

      List() {
        ForEach(this.subOrderInfos, (item: SubOrderInfo) => {
          ListItem() {
            Row() {
              Image(item?.coverUrlExtendVo?.centre || $r('app.media.img_placeholder_horizontal'))
                .width($r('app.string.lpx_180'))
                .height($r('app.string.lpx_180'))
                .border({ radius: $r('app.string.lpx_8') })

              Column() {

                Text(item.goodsName)
                  .width(Constants.FULL_PARENT)
                  .textAlign(TextAlign.Start)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.color_333333'))
                  .fontSize(lpx2fp(28))
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Blank()

                Row() {
                  Text('￥')
                    .fontColor($r('app.color.color_EB4F3A'))
                    .fontSize(lpx2fp(20))

                  Text(GoodsShowUtil.getOrderGoodsAmt(item))
                    .fontColor($r('app.color.color_EB4F3A'))
                    .fontSize(lpx2fp(28))
                    .margin({ left: $r('app.string.lpx_8') })

                  Blank()

                  Text(`共${item?.goodsNum ?? 0}件`)
                    .fontColor($r('app.color.color_333333'))
                    .fontSize(lpx2fp(24))
                    .padding({
                      top: $r('app.string.lpx_5'),
                      bottom: $r('app.string.lpx_5'),
                      left: $r('app.string.lpx_10'),
                      right: $r('app.string.lpx_10')
                    })
                    .border({
                      color: $r('app.color.color_999999'),
                      width: $r('app.string.lpx_2'),
                      radius: $r('app.string.lpx_8'),
                    })

                }
                .width(Constants.FULL_PARENT)
                .margin({ top: $r('app.string.lpx_10') })
              }
              .layoutWeight(1)
              .height($r('app.string.lpx_180'))
              .margin({ left: $r('app.string.lpx_24') })
            }
            .width(Constants.FULL_PARENT)
          }
          .width(Constants.FULL_PARENT)
          .margin({ bottom: $r('app.string.lpx_32') })
        })
      }
      .width(Constants.FULL_PARENT)

    }
    .width(Constants.FULL_PARENT)
    .height(px2vp(display.getDefaultDisplaySync().height * 7 / 10))
    .borderRadius({
      topLeft: $r('app.string.lpx_20'),
      topRight: $r('app.string.lpx_20')
    })
    .backgroundColor(Color.White)
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
