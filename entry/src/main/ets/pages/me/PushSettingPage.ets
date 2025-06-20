import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import PreferenceUtil from 'lib_core_model/src/main/ets/util/PreferenceUtil'
import { ToolBar } from '../../view/widget/ToolBar'

@Entry
@Component
struct PushSettingPage {
  @State noticeToggle: boolean = true

  @State pushSoundToggle: boolean = true
  @State pushVibrateToggle: boolean = true

  savePushSoundToggle() {
    PreferenceUtil.put(Constants.PUSH_SOUND_TOGGLE_KEY,this.pushSoundToggle)
  }

  savePushVibrateToggle() {
    PreferenceUtil.put(Constants.PUSH_VIBRATE_TOGGLE_KEY,this.pushVibrateToggle)
  }

  aboutToAppear() {
    PreferenceUtil.get(Constants.PUSH_SOUND_TOGGLE_KEY).then((value) => {
      if (value) {
        this.pushSoundToggle = true
      } else {
        this.pushSoundToggle = false
      }
    })
    PreferenceUtil.get(Constants.PUSH_VIBRATE_TOGGLE_KEY).then((value) => {
      if (value) {
        this.pushVibrateToggle = true
      } else {
        this.pushVibrateToggle = false
      }
    })
  }

  build() {
    Column() {
      ToolBar({title: '推送设置'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {
      Row() {
        Text('消息通知')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text(this.noticeToggle ? '已开启' : '未开启')
          .fontColor(this.noticeToggle ? $r('app.color.color_999999') :$r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_104'))
      .backgroundColor($r('app.color.white'))
      .margin({ top: $r('app.string.lpx_32') })
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})

      Row() {
        Text('声音')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.pushSoundToggle })
          .selectedColor($r('app.color.color_E94E39'))
          .switchPointColor($r('app.color.white'))
          .onChange((isOn: boolean) => {
            this.pushSoundToggle = isOn
            this.savePushSoundToggle()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_104'))
      .backgroundColor($r('app.color.white'))
      .margin({ top: $r('app.string.lpx_32') })
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})

      Row() {
        Line()
          .width(Constants.FULL_PARENT)
          .height($r('app.string.lpx_1'))
          .backgroundColor($r('app.color.color_EFEFEF'))
      }
      .width(Constants.FULL_PARENT)
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})

      Row() {
        Text('震动')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.pushVibrateToggle })
          .selectedColor($r('app.color.color_E94E39'))
          .switchPointColor($r('app.color.white'))
          .onChange((isOn: boolean) => {
            this.pushVibrateToggle = isOn
            this.savePushVibrateToggle()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_104'))
      .backgroundColor($r('app.color.white'))
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
    }
    .width(Constants.FULL_PARENT)
    .zIndex(0)
  }
}
