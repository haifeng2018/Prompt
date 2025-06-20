import router from '@ohos.router';
import web_webview from '@ohos.web.webview';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
export struct WebPage {
  @State mTitle: string = ''
  @State mUrl: string | Resource = ''
  @State mProgress: number = 0;
  mController: web_webview.WebviewController = new web_webview.WebviewController()
  private TAG = 'WebPage'

  aboutToAppear(): void {
    this.mTitle = (router.getParams() as object)?.[Constants.TITLE]
    this.mUrl = (router.getParams() as object)?.[Constants.URL]
    Logger.error(this.TAG, `title = ${this.mTitle}`)
    Logger.error(this.TAG, `url = ${this.mUrl}`)
  }

  build() {
    Column() {
      ToolBar({ title: this.mTitle })
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
