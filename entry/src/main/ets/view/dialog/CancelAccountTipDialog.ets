/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CancelAccountTipDialog
 * Author: Victor
 * Date: 2022/12/8 15:14
 * Description: 
 * -----------------------------------------------------------------
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@CustomDialog
export default struct CancelAccountTipDialog {
  controller: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_modify_phone_exist'))
          .width($r('app.string.lpx_32'))
          .height($r('app.string.lpx_32'))

        Text('注销账号')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .margin({ left: $r('app.string.lpx_16') })

      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_116'))
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      Text('注销账号后将不可再观看已购买课程，请谨慎操作！确定注销账号吗？')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({ top: $r('app.string.lpx_40') })

      Row() {
        Text('确定')
          .layoutWeight(1)
          .height($r('app.string.lpx_80'))
          .backgroundColor($r('app.color.color_F5F5F5'))
          .borderRadius($r('app.string.lpx_16'))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
        Text('取消')
          .layoutWeight(1)
          .height($r('app.string.lpx_80'))
          .margin({ left: $r('app.string.lpx_26') })
          .backgroundColor($r('app.color.color_EB4F3A'))
          .borderRadius($r('app.string.lpx_16'))
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(28))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_40') })

    }
    .width('90%')
    .borderRadius($r('app.string.lpx_16'))
    .backgroundColor(Color.White)
    .padding({
      bottom: $r('app.string.lpx_32'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }
}
