import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import font from '@ohos.font'
import { HtmlApi } from 'lib_core_model/src/main/ets/api/HtmlApi'
import { router } from '@kit.ArkUI'
import { ToolBar } from '../../view/widget/ToolBar'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import App from 'lib_core_model/src/main/ets/App'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import LoadingDialog from '../../view/dialog/LoadingDialog'
import AppUtil from '../../util/AppUtil'
import UserVM from 'lib_core_model/src/main/ets/vm/UserVM'
import { LatestVersionData } from 'lib_core_model/src/main/ets/data/LatestVersionData'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'

/**
 * 关于我们
 */
@Entry
@Component
struct AboutUsPage {
  @State bundleName?: string = ''
  @State versionName?: string = ''
  @State versionCode?: string = ''
  @State mLatestVersionData: LatestVersionData = new LatestVersionData()
  private loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  handleCenterItemClick(index: number) {
    switch (index) {
      case 1:
        this.jumpWebPage('用户服务协议', HtmlApi.USER_SERVICES_AGREEMENT)
        break
      case 2:
        this.jumpWebPage('关于获课', HtmlApi.ABOUS_HOK)
        break
      case 3:
        this.jumpWebPage('隐私协议', HtmlApi.PRIVACY_POLICY)
        break
      case 4:
        this.sendCheckVersionRequest(true) // 检查版本更新
        break
    }
  }

  aboutToAppear() {
    font.registerFont({
      familyName: 'myfont',
      familySrc: '/fonts/iconfont.ttf'
    })
    AppUtil.getAppBundleInfo((bundleName?: string, versionName?: string, versionCode?: number) => {
      this.bundleName = bundleName
      this.versionName = versionName
      this.versionCode = versionCode?.toString()
      this.sendCheckVersionRequest(false)
    })
  }

  sendCheckVersionRequest(showLoading: boolean) {
    if (showLoading) {
      this.loadingDialogCtrl.open()
    }
    UserVM.sendCheckVersionRequest(this.bundleName ?? '', this.versionName ?? '').then((data: LatestVersionData) => {
      this.loadingDialogCtrl.close()
      this.mLatestVersionData = data
      if (!this.mLatestVersionData && showLoading) {
        ToastUtils.show('当前已是最新版本')
      }
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  build() {
    Column() {
      ToolBar({ title: '关于我们', shadowColor: $r('app.color.transparent') })
      Column() {
        this.head()
        this.centerItem('用户服务协议', false, 1)
        this.centerItem('关于获课', false, 2)
        this.centerItem('隐私协议', false, 3)
        this.centerItem('版本更新', true, 4)
        Blank()
        this.bottom()
      }
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .padding({
        top: $r('app.string.lpx_88')
      })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
  }

  @Builder
  head() {
    Image($r('app.media.ic_about_logo'))
      .width($r('app.string.lpx_128'))
      .height($r('app.string.lpx_128'))
    Text('获课')
      .fontSize(lpx2fp(36))
      .fontColor($r('app.color.color_333333'))
      .margin({ top: $r('app.string.lpx_40') })
    Text(`Version ${this.versionName}`)
      .fontSize(lpx2fp(36))
      .fontColor($r('app.color.color_333333'))
      .margin({ top: $r('app.string.lpx_8'), bottom: $r('app.string.lpx_42') })
  }

  @Builder
  centerItem(title: string, hasBadge: boolean, index: number) {
    Row() {
      Text(title)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .textAlign(TextAlign.Center)
        .height(Constants.FULL_PARENT)

      if (hasBadge) {
        Badge({
          value: '',
          style: { badgeSize: 6, badgeColor: $r('app.color.color_EB4F3A') }
        }) {
          Text('')
            .width($r('app.string.lpx_16'))
            .height($r('app.string.lpx_16'))
        }
        .width($r('app.string.lpx_16'))
        .height($r('app.string.lpx_16'))
        .margin({ top: $r('app.string.lpx_20') })
        .opacity(this.mLatestVersionData ? 1 : 0)
      }

      Blank()

      Text($r('app.string.icon_jinrujiantou'))
        .fontSize(lpx2fp(48))
        .fontColor($r('app.color.color_333333'))
        .fontFamily('myfont')
        .height(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_90'))
    .margin({ top: $r('app.string.lpx_20') })
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
    .alignItems(VerticalAlign.Top)
    .onClick(() => {
      this.handleCenterItemClick(index)
    })
  }

  @Builder
  bottom() {
    Column() {
      Text('Copyright © 2021-2022').textExtend()
      Text('深圳市获客教育科技有限公司 版权所有').textExtend()
      Text('ICP备案号：粤ICP备2021049723号-6A').textExtend()
    }.margin({ bottom: $r('app.string.lpx_40') })
  }

  private jumpWebPage(title: string, url: string) {
    App.get().pushUrl({
      url: RouterPath.WEB_PAGE,
      params: {
        title: title,
        url: url,
      },
    }, router.RouterMode.Single)
  }
}

@Extend(Text)
function textExtend() {
  .fontSize(lpx2fp(20))
  .fontColor($r('app.color.color_999999'))
  .margin({ top: $r('app.string.lpx_12') })
}

