import router from '@ohos.router';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { ModifyPhoneParm } from 'lib_core_model/src/main/ets/data/ModifyPhoneParm';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import { AuthVM } from 'lib_core_model/src/main/ets/vm/AuthVM';
import PhoneUtil from '../../util/PhoneUtil';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct ConfirmPhonePage {
  phone: string = (router.getParams() as object)?.[Constants.PHONE];

  @State loginData: LoginData | null = null

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  sendModifyPhoneRequest() {
    let body = new ModifyPhoneParm()
    body.oldPhone = this.loginData?.phone
    body.newPhone = this.phone

    this.loadingDialogCtrl.open()

    AuthVM.sendCancelAccountCodeRequest(this.loginData?.token ?? '').then((value: object) => {
      this.loadingDialogCtrl.close()
      App.get().replaceUrl({
        url: RouterPath.MODIFY_BIND_PHONE_SUCCESS_PAGE,
        params: {
          phone: this.phone
        }
      })
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      let code = Number.parseInt(err.toString())
      if (code === 900001) {
        App.get().replaceUrl({
          url: RouterPath.MODIFY_BIND_PHONE_EXIST_PAGE,
          params: {
            phone: this.phone
          }
        })
        return
      }
      App.get().pushUrl({
        url: RouterPath.MODIFY_BIND_PHONE_FAILED_PAGE
      })
    })
  }

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

      Row() {
        Text('修改后手机号码：')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(32))
        Blank()
        Text(`${PhoneUtil.blurPhone(this.phone)}`)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})

      Text('确认修改')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({top: $r('app.string.lpx_96')})
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.sendModifyPhoneRequest()
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
