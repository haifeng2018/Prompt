import router from '@ohos.router';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { ModifyPhoneCodeCheckParm } from 'lib_core_model/src/main/ets/data/ModifyPhoneCodeCheckParm';
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
struct SmsVerificationPage {
  phone: string = (router.getParams() as object)?.[Constants.PHONE];
  @State loginData: LoginData | null = null
  @State countDownSeconds: number = 0;
  @State codeValue: string = '';
  controller: TextInputController = new TextInputController()
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });
  private timerId: number = 0;

  sendModifyPhoneCodeRequest() {
    this.loadingDialogCtrl.open()
    AuthVM.sendModifyPhoneCodeRequest(this.loginData?.token ?? '', this.phone).then((value: object) => {
      this.loadingDialogCtrl.close()
      this.startTimer()
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendModifyPhoneCodeCheckRequest() {
    let body = new ModifyPhoneCodeCheckParm()
    body.phone = this.phone
    body.code = this.codeValue

    this.loadingDialogCtrl.open()

    AuthVM.sendModifyPhoneCodeCheckRequest(this.loginData?.token ?? '', body).then((value: Boolean) => {
      this.loadingDialogCtrl.close()
      if (this.phone === this.loginData?.phone) {
        App.get().replaceUrl({
          url: RouterPath.ENTER_NEW_PHONE_PAGE,
          params: {
            token: this.loginData?.token
          }
        })
      } else {
        App.get().replaceUrl({
          url: RouterPath.CONFIRM_PHONE_PAGE,
          params: {
            phone: this.phone
          }
        })
      }
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  startTimer() {
    this.countDownSeconds = 60
    this.timerId = setInterval(() => {
      if (this.countDownSeconds === 0) {

      } else {
        this.countDownSeconds--;
      }
    }, Constants.AD_INTERVAL_TIME);
  }

  aboutToAppear() {
    this.startTimer()
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
  }

  aboutToDisappear() {
    clearTimeout(this.timerId)
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

      Text('请输入验证码')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))

      Text(`短信已发送至+86 ${PhoneUtil.blurPhone(this.phone)}`)
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({ top: $r('app.string.lpx_48') })

      Stack() {
        Row() {
          Text(this.getCellCodeText(0))
            .textCodeStyle(0, this.codeValue.length - 1)
          Text(this.getCellCodeText(1))
            .textCodeStyle(1, this.codeValue.length - 1)
            .margin({ left: $r('app.string.lpx_38') })
          Text(this.getCellCodeText(2))
            .textCodeStyle(2, this.codeValue.length - 1)
            .margin({ left: $r('app.string.lpx_38') })
          Text(this.getCellCodeText(3))
            .textCodeStyle(3, this.codeValue.length - 1)
            .margin({ left: $r('app.string.lpx_38') })
          Text(this.getCellCodeText(4))
            .textCodeStyle(4, this.codeValue.length - 1)
            .margin({ left: $r('app.string.lpx_38') })
          Text(this.getCellCodeText(5))
            .textCodeStyle(5, this.codeValue.length - 1)
            .margin({ left: $r('app.string.lpx_38') })
        }
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_80'))

        TextInput({ controller: this.controller })
          .height($r('app.string.lpx_80'))
          .backgroundColor($r('app.color.transparent'))
          .fontColor(Color.Brown)
          .textAlign(TextAlign.Center)
          .type(InputType.Number)
          .opacity(0)
          .caretColor($r('app.color.transparent'))
          .maxLength(6)
          .onClick(() => {
            //获得焦点
            this.controller.caretPosition(this.codeValue.length)
          })
          .onFocus(() => {
            //获得焦点
            this.controller.caretPosition(this.codeValue.length)
          })
          .onBlur(() => {
            //失去焦点
          })
          .onChange((value: string) => {
            this.codeValue = value
            if (value.length === 6) {
              this.sendModifyPhoneCodeCheckRequest()
            }
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_80'))
      .margin({ top: $r('app.string.lpx_40') })

      Text(this.countDownSeconds === 0 ? '重新获取短信验证码' : `${this.countDownSeconds}秒后可重新获取`)
        .enabled(this.countDownSeconds === 0)
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({ top: $r('app.string.lpx_40') })
        .backgroundColor(this.countDownSeconds == 0 ? $r('app.color.color_EB4F3A') : $r('app.color.transparent'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor(this.countDownSeconds == 0 ? $r('app.color.white') : $r('app.color.color_777777'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.codeValue = ''
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
      top: $r('app.string.lpx_48'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }

  getCellCodeText(index: number): string {
    if (this.codeValue.length > 0 && index < this.codeValue.length) {
      return this.codeValue[index]
    }
    return ''
  }
}

@Extend(Text)
function textCodeStyle(index: number, codeInputIndex: number) {
  .width($r('app.string.lpx_80'))
  .height($r('app.string.lpx_80'))
  .border({
    width: $r('app.string.lpx_2'),
    radius: $r('app.string.lpx_8'),
    color: hasFocus(index, codeInputIndex) ? $r('app.color.color_EB4F3A') : $r('app.color.color_999999')
  })
  .fontColor($r('app.color.color_333333'))
  .fontSize(lpx2fp(36))
  .textAlign(TextAlign.Center)
}

function hasFocus(index: number, codeInputIndex: number): boolean {
  if (codeInputIndex === -1 && index === 0) {
    return true
  }
  return codeInputIndex === index
}
