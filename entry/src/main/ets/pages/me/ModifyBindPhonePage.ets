import router from '@ohos.router';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { UserInfo } from 'lib_core_model/src/main/ets/data/UserInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { AuthVM } from 'lib_core_model/src/main/ets/vm/AuthVM';
import PhoneUtil from '../../util/PhoneUtil';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct ModifyBindPhonePage {
  data: number = (router.getParams() as object)?.[Constants.DATA];
  userInfo: UserInfo = (router.getParams() as object)?.[Constants.USER_INFO];
  @State loginData: LoginData | null = null
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  sendModifyPhoneCodeRequest() {
    this.loadingDialogCtrl.open()
    AuthVM.sendModifyPhoneCodeRequest(this.loginData?.token ?? '', this.loginData?.phone ?? '')
      .then((value: object) => {
        this.loadingDialogCtrl.close()
        App.get().replaceUrl({
          url: RouterPath.SMS_VERIFICATION_PAGE,
          params: {
            phone: this.loginData?.phone
          }
        })
      })
      .catch((err: string | Resource) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show(err)
      })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
  }

  build() {
    Column() {
      ToolBar({ title: '修改手机号码' })
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  content() {
    Column() {
      Text() {
        Span('修改须知：当前账号今年内还可修改 ')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(28))
        Span(`${this.data}`)
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
        Span(' 次')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_88'))
      .backgroundColor($r('app.color.color_FFF6F5'))
      .borderRadius($r('app.string.lpx_16'))
      .textAlign(TextAlign.Center)

      Text(`当前账号手机号码：${PhoneUtil.blurPhone(this.userInfo.phone)}`)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({ top: $r('app.string.lpx_40') })

      Text('获取短信验证码')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({ top: $r('app.string.lpx_40') })
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.sendModifyPhoneCodeRequest()
        })

      Row() {
        Text('无法正常获取手机验证码？')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(32))
          .margin({ right: $r('app.string.lpx_20') })

        Image($r('app.media.ic_edit_phone_customer_service'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))

        Text('联系客服')
          .fontColor($r('app.color.color_F53F3F'))
          .fontSize(lpx2fp(32))
          .margin({ left: $r('app.string.lpx_8') })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_40') })
      .justifyContent(FlexAlign.Center)
      .visibility(Visibility.None)
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      top: $r('app.string.lpx_32'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
