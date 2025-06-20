/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: RecommendCloseTipDialog
 * Author: Victor
 * Date: 2022/12/8 15:14
 * Description: 
 * -----------------------------------------------------------------
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@CustomDialog
export default struct RecommendCloseTipDialog {
  controller: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Stack() {
        Text('关闭个性化推荐')
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
            this.cancel()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_128'))
      .alignContent(Alignment.End)

      Text('关闭后，将无法看到个性化推荐内容，可能会影响您的阅读体验。')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))

      Row() {
        Text('确认关闭')
          .layoutWeight(1)
          .height($r('app.string.lpx_80'))
          .backgroundColor($r('app.color.color_F5F5F5'))
          .borderRadius($r('app.string.lpx_16'))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
        Text('我再想想')
          .layoutWeight(1)
          .height($r('app.string.lpx_80'))
          .margin({ left: $r('app.string.lpx_26') })
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'), 0.0],
              [$r('app.color.color_F12E29'), 0.7],
              [$r('app.color.color_F12E29'), 1.0]
            ]
          })
          .borderRadius($r('app.string.lpx_16'))
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_176') })

    }
    .width(Constants.FULL_PARENT)
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
