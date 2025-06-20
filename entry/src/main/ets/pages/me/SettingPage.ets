import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import font from '@ohos.font'
import { ToolBar } from '../../view/widget/ToolBar'
import App from 'lib_core_model/src/main/ets/App'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { router } from '@kit.ArkUI'
import CacheCleanUtil from '../../util/CacheCleanUtil'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import LoadingDialog from '../../view/dialog/LoadingDialog'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { AuthVM } from 'lib_core_model/src/main/ets/vm/AuthVM'
import { UserInfo } from 'lib_core_model/src/main/ets/data/UserInfo'

@Entry
@Component
struct SettingPage {
  @State loginData: LoginData = new LoginData()
  @State userInfo: UserInfo = new UserInfo()
  @State appCacheSize: string = ''
  private loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  aboutToAppear() {
    font.registerFont({
      familyName: 'myfont',
      familySrc: '/fonts/iconfont.ttf'
    })
    this.getAppCacheSize()
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
    AppConfig.getUserInfo().then((resultData: UserInfo) => {
      this.userInfo = resultData
    })
  }

  getAppCacheSize() {
    CacheCleanUtil.getAppCacheSize((size: string) => {
      this.appCacheSize = size
    })
  }

  sendLogoutRequest() {
    this.loadingDialogCtrl.open()
    AuthVM.sendLogoutRequest(this.loginData.token ?? '').then((data: object) => {
      this.loadingDialogCtrl.close()
      AppConfig.setLoginData(data).then(() => {
        this.loadingDialogCtrl.close()
        ToastUtils.show("退出登录成功")
        AppConfig.reSetLoginData()
        App.get().backOtherThenMainPage()
        App.get().replaceUrl({
          url: RouterPath.CODE_LOGIN_PAGE
        }, router.RouterMode.Single)
      })
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  build() {
    Column() {
      ToolBar({ title: '设置' })
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  content() {
    List() {
      ListItem() {
        this.settingCell('账号设置', false, true)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.ACCOUNT_SETTING_PAGE,
          params: {
            token: this.loginData.token,
            userInfo: this.userInfo
          }
        })
      })

      ListItem() {
        this.settingCell('个人资料', false, false)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.EDIT_PROFILE_PAGE
        })
      })

      ListItem() {
        this.settingCell('隐私设置', false, true)
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_32') })
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.PRIVACY_SETTING_PAGE
        })
      })

      ListItem() {
        this.settingCell('推送设置', false, true)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.PUSH_SETTING_PAGE
        })
      })

      ListItem() {
        this.settingCell('清除缓存', true, true)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        CacheCleanUtil.cleanCache()
        this.appCacheSize = '0KB'
        ToastUtils.show('缓存已清除')
      })

      ListItem() {
        this.settingCell('关于我们', false, false)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.ABOUT_US_PAGE
        })
      })

      ListItem() {
        Text('退出登录')
          .width(Constants.FULL_PARENT)
          .height($r('app.string.lpx_104'))
          .backgroundColor($r('app.color.white'))
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(32))
          .textAlign(TextAlign.Center)
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_32') })
      .onClick(() => {
        this.sendLogoutRequest()
      })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({ top: $r('app.string.lpx_32') })
  }

  @Builder
  settingCell(title: string, isCleanCell: boolean, hasLine: boolean) {
    Column() {
      Row() {
        Text(title)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        if (isCleanCell) {
          Text(this.appCacheSize)
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(24))
            .margin({ right: $r('app.string.lpx_20') })
        }
        Text('\ue88e')
          .fontSize(lpx2fp(32))
          .fontColor($r('app.color.color_777777'))
          .fontFamily('myfont')
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_104'))
      .backgroundColor($r('app.color.white'))
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })

      if (hasLine) {
        this.lineCell()
      }
    }
  }

  @Builder
  lineCell() {
    Row() {
      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_2'))
        .backgroundColor($r('app.color.color_EFEFEF'))
    }
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
  }
}