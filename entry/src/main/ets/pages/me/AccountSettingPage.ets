import router from '@ohos.router'
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
import CancelAccountTipDialog from '../../view/dialog/CancelAccountTipDialog';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import ModifyBindPhoneDialog from '../../view/dialog/ModifyBindPhoneDialog';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct AccountSettingPage {
  userInfo: UserInfo = (router.getParams() as object)?.[Constants.USER_INFO];

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

  modifyBindPhoneDlgController: CustomDialogController = new CustomDialogController({
    builder: ModifyBindPhoneDialog(
      {
        confirm:() => {
          this.sendPhoneModifyCountRequest()
        },
        cancel:() => {
        }
      }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

  cancelAccountTipDlgController: CustomDialogController = new CustomDialogController({
    builder: CancelAccountTipDialog(
      {
        confirm:() => {
          App.get().pushUrl({
            url: RouterPath.CANCEL_ACCOUNT_PAGE
          })
        },
        cancel:() => {
        }
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  sendPhoneModifyCountRequest () {
    this.loadingDialogCtrl.open()
    AuthVM.sendPhoneModifyCountRequest(this.loginData?.token ?? '',this.userInfo.phone ?? '').then((value: object) => {
      this.loadingDialogCtrl.close()
      App.get().pushUrl({
        url: RouterPath.MODIFY_BIND_PHONE_PAGE,
        params: {
          data: value,
          userInfo: this.userInfo
        }
      })
    }).catch((err: string | Resource) => {
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
      ToolBar({title: '账号设置'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    List() {
      ListItem() {
        this.settingCell('修改登录手机号',true)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        this.modifyBindPhoneDlgController.open()
      })

      ListItem() {
        this.settingCell('注销账号',false)
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})
      .onClick(() => {
        this.cancelAccountTipDlgController.open()
      })
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({top: $r('app.string.lpx_32')})
  }

  @Builder settingCell(title: string,modifyPhone: boolean) {
    Row() {
      Text(title)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
      Blank()
      if (modifyPhone) {
        Text(PhoneUtil.blurPhone(this.userInfo?.phone ?? ''))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
          .margin({right: $r('app.string.lpx_20')})
      }
      Image($r('app.media.ic_right'))
        .width($r('app.string.lpx_12'))
        .height($r('app.string.lpx_20'))
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_104'))
    .backgroundColor($r('app.color.white'))
    .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

}
