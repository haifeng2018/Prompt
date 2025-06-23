/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CommonTipDialog
 * Author: Victor
 * Date: 2022/12/8 15:14
 * Description: 
 * -----------------------------------------------------------------
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@CustomDialog
export default struct CommonTipDialog {
  @State title: string = ''
  @State content: string = ''
  @State confirmText: string = '确定'
  @State cancelText: string = '取消'
  controller: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Text(this.title)
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_128'))
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)

      Divider().height($r('app.string.lpx_1')).strokeWidth(`${$r('app.string.lpx_1')}`).color($r('app.color.color_EFEFEF'))

      Text(this.content)
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .textAlign(TextAlign.Center)
        .margin({top : $r('app.string.lpx_20')})
        .visibility(this.content == '' ? Visibility.None : Visibility.Visible)

      Row() {
        Text(this.cancelText)
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_808080'))
          .fontSize(lpx2fp(32))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
        Divider()
          .vertical(true)
          .height(Constants.FULL_PARENT)
          .strokeWidth(`${$r('app.string.lpx_1')}`)
          .color($r('app.color.color_EFEFEF'))
        Text(this.confirmText)
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_ED1B24'))
          .fontSize(lpx2fp(32))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_94'))
      .margin({top : $r('app.string.lpx_20')})
    }
    .width('80%')
    .borderRadius($r('app.string.lpx_16'))
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
