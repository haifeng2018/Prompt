import router from '@ohos.router';
import web_webview from '@ohos.web.webview';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import { HomeToolBar } from '../../view/widget/HomeToolBar';

@Preview
@Component
export struct TutorialTabContent {
  @State mUrl: string | Resource = 'https://www.baidu.com/'
  @State mProgress: number = 0;
  mController: web_webview.WebviewController = new web_webview.WebviewController()
  private TAG = 'WebPage'

  aboutToAppear(): void {
    Logger.error(this.TAG, `url = ${this.mUrl}`)
  }

  build() {
    Column() {
      HomeToolBar({
        title: '教程',
        titleActionIcon: $r('app.media.ic_home_course_cell_more')
      })
      Progress({ value: this.mProgress, total: 100 })
        .width(Constants.FULL_PARENT)
        .height('2lpx')
        .color($r('app.color.color_accent'))
        .visibility(this.mProgress === 100 ? Visibility.None : Visibility.Visible)
      Web({
        src: `${this.mUrl}#toolbar=0`,
        controller: this.mController,
      })
        .width(Constants.FULL_PARENT)
        .layoutWeight(1)
        .domStorageAccess(true)
        .onProgressChange(() => {
          this.mProgress
        })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  onBackPress() {
    if (this.mController.accessBackward()) {
      this.mController.backward()
      return true
    }
    return false
  }
}

