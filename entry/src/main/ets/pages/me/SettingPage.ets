import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
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
import PreferenceUtil from 'lib_core_model/src/main/ets/util/PreferenceUtil'
import LanguageSelectDialog from '../../view/dialog/LanguageSelectDialog'

@Entry
@Component
struct SettingPage {
  @State loginData: LoginData = new LoginData()
  @State userInfo: UserInfo = new UserInfo()
  @State appCacheSize: string = ''
  @State bluetoothRemoteCtrlToggle: boolean = true
  select: number = 0
  feedTypes: string[] = ['中文', '英文']
  @State feedType: number = -1
  @State feedTypeName: string = '中文'

  saveBluetoothRemoteCtrlToggle() {
    PreferenceUtil.put(Constants.BLUETOOTH_REMOTE_CTL_TOGGLE_KEY,this.bluetoothRemoteCtrlToggle)
  }

  private loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  modifyBindPhoneDlgController: CustomDialogController = new CustomDialogController({
    builder: LanguageSelectDialog(
      {
        confirm:() => {
        },
        cancel:() => {
        }
      }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

  aboutToAppear() {
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
        this.languageSettingCell()
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        // this.modifyBindPhoneDlgController.open()
        TextPickerDialog.show({
          range: this.feedTypes,
          selected: this.select,
          alignment: DialogAlignment.Bottom,
          canLoop: false,
          defaultPickerItemHeight: 40,
          onAccept: (result: TextPickerResult) => {
            this.select = result.index as number
            this.feedTypeName = result.value as string
            this.feedType = result.index as number
          },
          onCancel: () => {
          },
          onChange: (value: TextPickerResult) => {
          }
        })
      })

      ListItem() {
        this.bindPhoneCell()
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.BIND_PHONE_PAGE
        })
      })

      ListItem() {
        this.settingCell('用户协议', false, true)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.PRIVACY_SETTING_PAGE
        })
      })

      ListItem() {
        this.settingCell('隐私政策', false, true)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.PUSH_SETTING_PAGE
        })
      })

      ListItem() {
        this.settingCell('权限设置', false, true)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {

      })

      ListItem() {
        this.settingCell('用户注销', false, false)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.ABOUT_US_PAGE
        })
      })

      ListItem() {
        this.settingCell('清除缓存', true, false)
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        CacheCleanUtil.cleanCache()
        this.appCacheSize = '0KB'
        ToastUtils.show('缓存已清除')
      })

      ListItem() {
        this.bluetoothRemoteControlCell()
      }
      .width(Constants.FULL_PARENT)
      .onClick(() => {
        this.bluetoothRemoteCtrlToggle = !this.bluetoothRemoteCtrlToggle
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

  @Builder languageSettingCell() {
    Column() {
      Row() {
        Text('语言设置')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text(this.feedTypeName)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(24))
          .margin({ right: $r('app.string.lpx_20') })
        Image($r('app.media.ic_right'))
          .width($r('app.string.lpx_20'))
          .height($r('app.string.lpx_20'))
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_104'))
      .backgroundColor($r('app.color.white'))
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })

      this.lineCell()
    }
  }

  @Builder bindPhoneCell() {
    Column() {
      Row() {
        Text('绑定手机号')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text('未绑定')
          .fontColor($r('app.color.color_0091FF'))
          .fontSize(lpx2fp(24))
          .margin({ right: $r('app.string.lpx_20') })
        Image($r('app.media.ic_right'))
          .width($r('app.string.lpx_20'))
          .height($r('app.string.lpx_20'))
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_104'))
      .backgroundColor($r('app.color.white'))
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })

      this.lineCell()
    }
  }

  @Builder settingCell(title: string, isCleanCell: boolean, hasLine: boolean) {
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
        Image($r('app.media.ic_right'))
          .width($r('app.string.lpx_20'))
          .height($r('app.string.lpx_20'))
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

  @Builder bluetoothRemoteControlCell() {
    Column() {
      Row() {
        Text('专属蓝牙遥控器')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.bluetoothRemoteCtrlToggle })
          .selectedColor($r('app.color.color_E94E39'))
          .switchPointColor($r('app.color.white'))
          .onChange((isOn: boolean) => {
            this.bluetoothRemoteCtrlToggle = isOn
            this.saveBluetoothRemoteCtrlToggle()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_104'))
      .backgroundColor($r('app.color.white'))
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })

      this.lineCell()
    }
  }

  @Builder lineCell() {
    Row() {
      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_2'))
        .backgroundColor($r('app.color.color_EFEFEF'))
    }
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
  }
}