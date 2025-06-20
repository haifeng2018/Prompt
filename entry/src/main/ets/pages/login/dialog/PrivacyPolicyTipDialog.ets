import App from 'lib_core_model/src/main/ets/App';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { HtmlApi } from 'lib_core_model/src/main/ets/api/HtmlApi';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { router } from '@kit.ArkUI';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';

@Preview
@CustomDialog
export default struct PrivacyPolicyTipDialog {
  controller: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Stack() {
        Text('请阅读并同意以下条款')
          .width(Constants.FULL_PARENT)
          .height($r('app.string.lpx_92'))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
        Image($r('app.media.ic_privacy_policy_tip_dlg_close'))
          .width($r('app.string.lpx_32'))
          .height($r('app.string.lpx_32'))
          .onClick(() => {
            this.controller.close();
            this.cancel();
          })
      }
      .width(Constants.FULL_PARENT)
      .alignContent(Alignment.End)
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })

      Text() {
        Span('我已阅读并同意')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
        Span('《获课服务协议》')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
          .decoration({ type: TextDecorationType.Underline, color: $r('app.color.color_EB4F3A') })
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.WEB_PAGE,
              params: {
                title: '《获课服务协议》',
                url: HtmlApi.USER_SERVICES_AGREEMENT,
              },
            }, router.RouterMode.Single)
          })
        Span('、')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
        Span('《获课隐私政策》')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
          .decoration({ type: TextDecorationType.Underline, color: $r('app.color.color_EB4F3A') })
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.WEB_PAGE,
              params: {
                title: '《获课隐私政策》',
                url: HtmlApi.PRIVACY_POLICY,
              },
            }, router.RouterMode.Single)
          })
      }

      Text('同意并继续')
        .height($r('app.string.lpx_64'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_32'))
        .margin({ top: $r('app.string.lpx_40') })
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
        .onClick(() => {
          this.controller.close();
          this.confirm();
        })

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
