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
import { CourseEvaluateCheckData } from 'lib_core_model/src/main/ets/data/CourseEvaluateCheckData';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@CustomDialog
export default struct CourseEvaluateTipDialog {
  mCourseEvaluateCheckData?: CourseEvaluateCheckData | null
  controller: CustomDialogController;

  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Stack() {
        Text('当前课程已过有效期')
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

      Text(this.mCourseEvaluateCheckData?.markContent)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))

      Row() {
        Text('取消')
          .fancy()
          .fontColor($r('app.color.color_333333'))
          .backgroundColor($r('app.color.color_F5F5F5'))
          .onClick(() => {
            this.controller.close();
            this.cancel();
          })

        Text('确认')
          .fancy()
          .fontColor($r('app.color.white'))
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'),0.0],
              [$r('app.color.color_F12E29'),0.7],
              [$r('app.color.color_F12E29'),1.0]
            ]
          })
          .margin({ left: $r('app.string.lpx_30') })
          .onClick(() => {
            this.controller.close();
            this.confirm();
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_80'))
      .justifyContent(FlexAlign.Center)
      .margin({ top: $r('app.string.lpx_40') })
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

@Extend(Text)
function fancy() {
  .layoutWeight(1)
  .height(Constants.FULL_PARENT)
  .fontSize(lpx2fp(28))
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .borderRadius($r('app.string.lpx_16'))
}