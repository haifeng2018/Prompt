import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { AuthVM } from 'lib_core_model/src/main/ets/vm/AuthVM';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct EnterNewPhonePage {
  @State loginData: LoginData | null = null
  @State newPhone: string = ''
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  sendNewPhoneCodeRequest() {
    if (this.newPhone === '') {
      ToastUtils.show('请输入新的手机号码')
      return
    }
    this.loadingDialogCtrl.open()
    AuthVM.sendNewPhoneCodeRequest(this.loginData?.token ?? '', this.newPhone)
      .then((value: object) => {
        this.loadingDialogCtrl.close()
        App.get().replaceUrl({
          url: RouterPath.SMS_VERIFICATION_PAGE,
          params: {
            phone: this.newPhone
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
      Text('请输入新的手机号码')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)

      TextInput({ placeholder: '请输入手机号码' })
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_80'))
        .margin({ top: $r('app.string.lpx_40') })
        .padding({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })
        .backgroundColor($r('app.color.transparent'))
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .maxLength(11)
        .type(InputType.Number)
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_8'),
          color: $r('app.color.color_E6E6E6')
        })
        .onChange((value: string) => {
          this.newPhone = value;
        })

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
          this.sendNewPhoneCodeRequest()
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
