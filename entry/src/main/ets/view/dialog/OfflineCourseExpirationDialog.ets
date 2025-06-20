/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseStudyDialog
 * Author: Victor
 * Date: 2023/12/28 16:27
 * Description: 
 * -----------------------------------------------------------------
 */
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import { CourseEvaluateCheckData } from 'lib_core_model/src/main/ets/data/CourseEvaluateCheckData';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@CustomDialog
export default struct OfflineCourseExpirationDialog {
  mSubOrderInfo?: SubOrderInfo | null
  controller: CustomDialogController;

  onBuyNow: () => void = () => {
  };

  build() {
    Column() {
      Row(){
        Image($r('app.media.ic_dlg_close'))
          .width($r('app.string.lpx_60'))
          .height($r('app.string.lpx_60'))
          .margin({top: $r('app.string.lpx_20')})
          .padding($r('app.string.lpx_10'))
          .onClick(() => {
            this.controller.close()
          })
      }
      .width(Constants.FULL_PARENT)
      .justifyContent(FlexAlign.End)

      Text('当前课程已过有效期')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(40))
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)

      Text('如需学习请再次购买')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_12')})

      Row() {
        Image(this.mSubOrderInfo?.coverUrlExtendVo?.centre)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .borderRadius($r('app.string.lpx_8'))
        Column(){
          Text(this.mSubOrderInfo?.goodsName ?? '')
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .width(Constants.FULL_PARENT)
          Blank()
          Text(){
            Span('￥')
              .fontColor($r('app.color.color_EB4F3A'))
              .fontSize(lpx2fp(20))
            Span(AmountUtil.getRoundUp((this.mSubOrderInfo?.payerTotal ?? 0) / 100,2))
              .fontColor($r('app.color.color_EB4F3A'))
              .fontSize(lpx2fp(32))
          }
          .width(Constants.FULL_PARENT)
        }
        .layoutWeight(1)
        .height($r('app.string.lpx_180'))
        .padding({ left: $r('app.string.lpx_16') })
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_72')})
      .padding({
        left: $r('app.string.lpx_16'),
        right: $r('app.string.lpx_16')
      })

      Row() {
        Text('立即购买')
          .layoutWeight(1)
          .height($r('app.string.lpx_68'))
          .borderRadius($r('app.string.lpx_32'))
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'), 0.0],
              [$r('app.color.color_F12E29'), 0.7],
              [$r('app.color.color_F12E29'), 1.0]
            ]
          })
          .onClick(() => {
            this.controller.close()
            this.onBuyNow()
          })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_162') })
      .padding({
        bottom: $r('app.string.lpx_40'),
        left: $r('app.string.lpx_40'),
        right: $r('app.string.lpx_40')
      })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor(Color.White)
    .borderRadius({
      topLeft: $r('app.string.lpx_20'),
      topRight: $r('app.string.lpx_20')
    })
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }
}

@Extend(Text)
function fancy() {
  .layoutWeight(1)
  .height(Constants.FULL_PARENT)
  .fontSize(lpx2fp(28))
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .borderRadius($r('app.string.lpx_16'))
}