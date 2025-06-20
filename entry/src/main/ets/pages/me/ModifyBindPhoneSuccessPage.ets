import router from '@ohos.router';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import PhoneUtil from '../../util/PhoneUtil';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct ModifyBindPhoneSuccessPage {
  phone: string = (router.getParams() as object)?.[Constants.PHONE];

  @State loginData: LoginData | null = null

  @State countDownSeconds: number = 10;
  private timerId: number = 0;

  startTimer () {
    if (this.countDownSeconds === 0) {
      return
    }
    this.timerId = setInterval(() => {
      if (this.countDownSeconds === 0) {
        AppConfig.reSetLoginData()
        App.get().backOtherThenMainPage()
        App.get().replaceUrl({
          url: RouterPath.CODE_LOGIN_PAGE
        },router.RouterMode.Single)
      } else {
        this.countDownSeconds--;
      }
    }, Constants.AD_INTERVAL_TIME);
  }

  aboutToAppear() {
    this.startTimer()
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    });
  }

  aboutToDisappear() {
    clearTimeout(this.timerId)
  }

  build() {
    Column() {
      ToolBar({title: '修改手机号码'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {

      Image($r('app.media.ic_modify_phone_success'))
      .width($r('app.string.lpx_120'))
      .height($r('app.string.lpx_120'))

      Text('手机号码修改成功！')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .margin({top: $r('app.string.lpx_32')})

      Text(`您的登录手机号码已由${PhoneUtil.blurPhone(this.loginData?.phone)}变更成${PhoneUtil.blurPhone(this.phone)},请使用新手机号码重新登录！`)
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))
        .textAlign(TextAlign.Center)
        .margin({top: $r('app.string.lpx_32')})

      Text(`立即登录(${this.countDownSeconds})`)
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({top: $r('app.string.lpx_72')})
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          AppConfig.reSetLoginData()
          App.get().backOtherThenMainPage()
          App.get().replaceUrl({
            url: RouterPath.CODE_LOGIN_PAGE
          },router.RouterMode.Single)
        })

      Text('10秒后系统将自动跳转到登录页面')
        .fontColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_24')})

    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      top:$r('app.string.lpx_46'),
      left:$r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
