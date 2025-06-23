import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { AuthVM } from 'lib_core_model/src/main/ets/vm/AuthVM';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct BindPhonePage {
  @State loginData: LoginData | null = null
  @State mPhone: string = '';
  @State mCode: string = '';
  @State mCountDownSeconds: number = 0;
  private mTimerId: number = 0;

  private loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

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

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
  }

  build() {
    Column() {
      ToolBar({ title: '绑定手机号' })
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  content() {
    Column() {
      Text('手机区号：中国（+86）')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))

      TextInput({ placeholder: '输入手机号（新手机号自动注册）' })
        .inputStyle()
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_20')})
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
          .maxLength(6)
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
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_8') })

      Line().lineStyle()

      Button('绑定')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_44'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .margin({ top: $r('app.string.lpx_52') })
        .onClick(() => {
        })
    }
    .width(Constants.FULL_PARENT)
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
