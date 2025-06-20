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
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@CustomDialog
export default struct CourseStudyDialog {
  controller: CustomDialogController;
  onStudyNow: () => void = () => {
  };

  build() {
    Column() {
      Stack() {
        Text('提示')
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)

        Image($r('app.media.ic_dlg_close'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .onClick(() => {
            this.controller.close()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_108'))
      .alignContent(Alignment.End)

      Text('你已经购买过该课程，点击立即学习')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))

      Row() {
        Text('立即学习')
          .layoutWeight(1)
          .height($r('app.string.lpx_80'))
          .borderRadius($r('app.string.lpx_40'))
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(32))
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
            this.onStudyNow()
          })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_48') })
      .padding({ left: $r('app.string.lpx_40'), right: $r('app.string.lpx_40') })
    }
    .width('80%')
    .backgroundColor(Color.White)
    .borderRadius($r('app.string.lpx_20'))
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }
}