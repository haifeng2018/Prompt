import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { router } from '@kit.ArkUI';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { HtmlApi } from 'lib_core_model/src/main/ets/api/HtmlApi';
import PrivacyPolicyTipDialog from './dialog/PrivacyPolicyTipDialog';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { AuthVM } from 'lib_core_model/src/main/ets/vm/AuthVM';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import App from 'lib_core_model/src/main/ets/App';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct CodeLoginPage {
  @State mCountDownSeconds: number = 0;
  @State mPhone: string = '';
  @State mCode: string = '';
  @State mAgree: boolean = false;
  private mTimerId: number = 0;
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyPolicyTipDialog(
      {
        cancel: this.onCancel.bind(this),
        confirm: this.onConfirm.bind(this)
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })
  private loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  onCancel() {
  }

  onConfirm() {
    this.mAgree = true
    this.sendCodeLoginRequest()
  }

  aboutToAppear() {
  }

  aboutToDisappear() {
    clearTimeout(this.mTimerId)
  }

  /**
   * 获取验证码
   */
  sendSmsRequest() {
    if (this.mPhone === '') {
      ToastUtils.show('请输入手机号')
      return
    }
    if (!this.mPhone.startsWith("1") || this.mPhone.length < 11) {
      ToastUtils.show('请输入正确的手机号')
      return
    }

    this.loadingDialogCtrl.open()

    AuthVM.sendActivateSmsRequest(this.mPhone).then((data: Object) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show('验证码发送成功')
      this.startTimer(60)
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    });
  }

  /**
   * 语音验证
   */
  sendVoiceSmsRequest() {
    if (this.mPhone === '') {
      ToastUtils.show('请输入手机号')
      return
    }
    if (!this.mPhone.startsWith("1") || this.mPhone.length < 11) {
      ToastUtils.show('请输入正确的手机号')
      return
    }

    this.loadingDialogCtrl.open()

    AuthVM.sendVoiceSmsRequest(this.mPhone).then((data: Object) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show('验证码发送成功')
      this.startTimer(60)
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  /**
   * 登录
   */
  sendCodeLoginRequest() {
    if (this.mPhone === '') {
      ToastUtils.show('请输入手机号')
      return
    }
    if (this.mCode === '') {
      ToastUtils.show('请输入验证码')
      return
    }
    if (!this.mPhone.startsWith('1') || this.mPhone.length < 11) {
      ToastUtils.show('请输入正确的手机号')
      return
    }
    if (!this.mAgree) {
      this.dialogController.open()
      return
    }

    this.loadingDialogCtrl.open()

    AuthVM.sendCodeLoginRequest(this.mPhone, this.mCode).then((data: LoginData) => {
      this.loadingDialogCtrl.close()
      AppConfig.setLoginData(data).then(() => {
        ToastUtils.show('登录成功')
        App.get().back()
      })
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  build() {
    Column() {
      ToolBar({ title: '登录/注册' })
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({bottom: $r('app.string.lpx_40')})
  }

  @Builder
  content() {
    Column() {
      TextInput({ placeholder: '输入手机号（新手机号自动注册）' })
        .inputStyle()
        .width(Constants.FULL_PARENT)
        .maxLength(11)
        .type(InputType.Number)
        .onChange((value: string) => {
          this.mPhone = value;
        })

      Line().lineStyle()

      Row() {
        TextInput({ placeholder: '输入验证码' })
          .inputStyle()
          .layoutWeight(1)
          .maxLength(4)
          .type(InputType.Number)
          .onChange((value: string) => {
            this.mCode = value;
          })

        Button(this.mCountDownSeconds === 0 ? '获取验证码' : `${this.mCountDownSeconds}秒`)
          .height($r('app.string.lpx_64'))
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(28))
          .backgroundColor($r('app.color.color_EB4F3A'))
          .borderRadius($r('app.string.lpx_32'))
          .padding({ left: $r('app.string.lpx_40'), right: $r('app.string.lpx_40') })
          .enabled(this.mCountDownSeconds === 0)
          .opacity(this.mCountDownSeconds === 0 ? 1 : 0.6)
          .onClick(() => {
            this.sendSmsRequest()
          })
      }
      .margin({ top: $r('app.string.lpx_30') })

      Line().lineStyle()

      Text() {
        Span('收不到验证码？试试')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
        Span(' 语音验证')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_10') })
      .padding($r('app.string.lpx_20'))
      .enabled(this.mCountDownSeconds === 0)
      .opacity(this.mCountDownSeconds === 0 ? 1 : 0.6)
      .onClick(() => {
        this.sendVoiceSmsRequest()
      })

      Button('登录')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_44'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .margin({ top: $r('app.string.lpx_52') })
        .onClick(() => {
          this.sendCodeLoginRequest()
        })

      Row() {
        Image(this.mAgree ? $r('app.media.chk_login_user_agreement_checked')
          : $r('app.media.chk_login_user_agreement_normal'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .padding($r('app.string.lpx_10'))
          .onClick(() => {
            this.mAgree = !this.mAgree
          })

        Text() {
          Span('我已认真阅读并同意').fontSize(lpx2fp(24)).fontColor($r('app.color.color_999999'))
          Span('《获课服务协议》')
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_EB4F3A'))
            .decoration({ type: TextDecorationType.Underline, color: $r('app.color.color_EB4F3A') })
            .onClick(() => {
              this.jumpWebPage('获课服务协议', HtmlApi.USER_SERVICES_AGREEMENT)
            })
          Span('、').fontSize(lpx2fp(24)).fontColor($r('app.color.color_999999'))
          Span('《获课隐私政策》')
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_EB4F3A'))
            .decoration({ type: TextDecorationType.Underline, color: $r('app.color.color_EB4F3A') })
            .onClick(() => {
              this.jumpWebPage('获课隐私政策', HtmlApi.PRIVACY_POLICY)
            })
        }

      }
      .margin({ top: $r('app.string.lpx_48') })

      Blank()

      Text('未注册过的用户将直接为您创建获课账户')
        .fontColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(24))
        .margin({ top: $r('app.string.lpx_32') })
    }
    .layoutWeight(1)
    .padding({
      top: $r('app.string.lpx_32'),
      bottom: $r('app.string.lpx_32'),
      left: $r('app.string.lpx_36'),
      right: $r('app.string.lpx_36')
    })
  }

  private startTimer(countDownSeconds: number) {
    clearTimeout(this.mTimerId)
    this.mCountDownSeconds = countDownSeconds
    this.mTimerId = setInterval(() => {
      if (this.mCountDownSeconds === 0) {

      } else {
        this.mCountDownSeconds--;
      }
    }, Constants.AD_INTERVAL_TIME);
  }

  private jumpWebPage = (title: string, url: string) => {
    App.get().pushUrl({
      url: RouterPath.WEB_PAGE,
      params: {
        title: title,
        url: url,
      },
    }, router.RouterMode.Single)
  }
}

@Extend(TextInput)
function inputStyle() {
  .height($r('app.string.lpx_84'))
  .backgroundColor($r('app.color.transparent'))
  .placeholderColor($r('app.color.color_999999'))
  .fontSize(lpx2fp(28))
  .fontColor($r('app.color.color_333333'))
  .caretColor($r('app.color.color_EB4F3A'))
  .padding({ left: $r('app.string.lpx_20') })
}

@Extend(Line)
function lineStyle() {
  .width(Constants.FULL_PARENT)
  .height($r('app.string.lpx_1'))
  .backgroundColor($r('app.color.color_EFEFEF'))
}
