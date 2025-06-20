import router from '@ohos.router'
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
struct ModifyBindPhoneExistPage {
  phone: string = (router.getParams() as object)?.[Constants.PHONE];

  @State loginData: LoginData | null = null

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
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

      Image($r('app.media.ic_modify_phone_exist'))
        .width($r('app.string.lpx_120'))
        .height($r('app.string.lpx_120'))

      Text('新手机号码已有账号，修改失败！')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .margin({top: $r('app.string.lpx_32')})

      Text(`请先使用修改后的手机号码(${PhoneUtil.blurPhone(this.phone)})登录系统自行注销账号，再使用修改前手机号码(${PhoneUtil.blurPhone(this.loginData?.phone)})进行登录进行修改号码！`)
        .fontColor($r('app.color.color_EB4F3A'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_40')})

      Row() {
        Text('修改前手机号码：')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(32))
        Blank()
        Text(`${PhoneUtil.blurPhone(this.loginData?.phone)}`)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_40')})

      Row() {
        Text('修改后手机号码：')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(32))
        Blank()
        Image($r('app.media.ic_modify_phone_exist'))
          .width($r('app.string.lpx_28'))
          .height($r('app.string.lpx_28'))
          .margin({right: $r('app.string.lpx_8')})
        Text(`${PhoneUtil.blurPhone(this.phone)}`)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})

      Text(`去注销${PhoneUtil.blurPhone(this.phone)}`)
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
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      top:$r('app.string.lpx_32'),
      left:$r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
