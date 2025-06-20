import { HtmlApi } from 'lib_core_model/src/main/ets/api/HtmlApi';
import App from 'lib_core_model/src/main/ets/App';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';

/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PrivacyPolicyDialog
 * Author: Victor
 * Date: 2022/12/8 15:14
 * Description: 
 * -----------------------------------------------------------------
 */

@CustomDialog
export default struct PrivacyPolicyDialog {
  controller: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };
  dismiss: () => void = () => {
  };

  build() {
    Column() {
      Text($r('app.string.kind_tip'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_92'))
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)

      Text($r('app.string.privacy_policy_content'))
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_666666'))
        .width(Constants.FULL_PARENT)

      Text() {
        Span($r('app.string.privacy_tip'))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))

        Span($r('app.string.user_services_agreement'))
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
          .onClick(() => {
            this.controller.close();
            App.get().pushUrl({
              url: RouterPath.WEB_PAGE,
              params: {
                title: $r('app.string.user_services_agreement'),
                url: HtmlApi.USER_SERVICES_AGREEMENT,
              },
            })
          })

        Span($r('app.string.and'))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))

        Span($r('app.string.privacy_policy'))
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
          .onClick(() => {
            this.controller.close();
            App.get().pushUrl({
              url: RouterPath.WEB_PAGE,
              params: {
                title: $r('app.string.privacy_policy'),
                url: HtmlApi.PRIVACY_POLICY,
              },
            })
          })
      }
      .margin({ top: $r('app.string.lpx_20') })

      Row() {
        Text($r('app.string.disagree'))
          .fancy()
          .backgroundColor($r('app.color.color_999999'))
          .onClick(() => {
            this.controller.close();
            this.cancel();
          })

        Text($r('app.string.agree'))
          .fancy()
          .backgroundColor($r('app.color.color_EB4F3A'))
          .margin({ left: $r('app.string.lpx_30') })
          .onClick(() => {
            this.controller.close();
            this.confirm();
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_64'))
      .justifyContent(FlexAlign.Center)
      .margin({ top: $r('app.string.lpx_40') })
    }
    .width('80%')
    .borderRadius($r('app.string.lpx_12'))
    .backgroundColor(Color.White)
    .padding({
      bottom: $r('app.string.lpx_28'),
      left: $r('app.string.lpx_28'),
      right: $r('app.string.lpx_28')
    })
  }
}

// Common text styles.
@Extend(Text)
function fancy() {
  .width($r('app.string.lpx_160'))
  .height(Constants.FULL_PARENT)
  .fontSize(lpx2fp(28))
  .fontColor($r('app.color.white'))
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .borderRadius($r('app.string.lpx_32'))
}