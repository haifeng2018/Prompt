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

      Row() {
        Text('删除')
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_ED1B24'))
          .fontSize(lpx2fp(32))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
        Divider()
          .vertical(true)
          .height(Constants.FULL_PARENT)
          .strokeWidth(`${$r('app.string.lpx_1')}`)
          .color($r('app.color.color_EFEFEF'))
        Text('取消')
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_808080'))
          .fontSize(lpx2fp(32))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_94'))
    }
    .width('80%')
    .borderRadius($r('app.string.lpx_8'))
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
