import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import PreferenceUtil from 'lib_core_model/src/main/ets/util/PreferenceUtil';
import RecommendCloseTipDialog from '../../view/dialog/RecommendCloseTipDialog';
import { preferences } from '@kit.ArkData';
import { ToolBar } from '../../view/widget/ToolBar';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@Entry
@Component
struct PrivacySettingPage {
  @State recommendOpen: boolean = true

  recommendCloseTipDlgController: CustomDialogController = new CustomDialogController({
    builder: RecommendCloseTipDialog(
      {
        confirm:() => {
          this.recommendOpen = false
          this.saveRecommendToggle()
        },
        cancel:() => {
          this.recommendOpen = true
          this.saveRecommendToggle()
        }
      }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  saveRecommendToggle() {
    PreferenceUtil.put(Constants.RECOMMEND_TOGGLE_KEY,this.recommendOpen)
  }

  aboutToAppear() {
    PreferenceUtil.get(Constants.RECOMMEND_TOGGLE_KEY).then((value: preferences.ValueType | null) => {
      if (value) {
        this.recommendOpen = true
      } else {
        this.recommendOpen = false
      }
    })
  }

  build() {
    Column() {
      ToolBar({title: '隐私设置'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Row() {
     Column() {
       Text('个性化推荐')
         .width(Constants.FULL_PARENT)
         .fontSize(lpx2fp(28))
         .fontColor($r('app.color.color_333333'))
         .textAlign(TextAlign.Start)
       Text('向我推荐适合我的个性化内容')
         .width(Constants.FULL_PARENT)
         .fontSize(lpx2fp(24))
         .fontColor($r('app.color.color_777777'))
         .textAlign(TextAlign.Start)
         .margin({top: $r('app.string.lpx_16')})
     }
      .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: this.recommendOpen })
        .selectedColor($r('app.color.color_E94E39'))
        .switchPointColor($r('app.color.white'))
        .onChange((isOn: boolean) => {
          this.recommendOpen = isOn
          if (isOn) {
            this.saveRecommendToggle()
          } else {
            this.recommendCloseTipDlgController.open()
          }
        })
    }
    .width('90%')
    .margin({
      top: $r('app.string.lpx_32')
    })
    .padding({
      top: $r('app.string.lpx_32'),
      bottom: $r('app.string.lpx_32'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_16'))
    .zIndex(0)
  }
}
