import { InvoiceInfo } from 'lib_core_model/src/main/ets/data/InvoiceInfo';
import { router } from '@kit.ArkUI';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { ToolBar } from '../../view/widget/ToolBar';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@Entry
@Component
struct ViewInvoicePage {
  data?: InvoiceInfo = (router.getParams() as object)?.[Constants.DATA];

  build() {
    Column() {
      ToolBar({title: '发票服务'})
      Image(this.data?.ossInvoiceImage)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_478'))
      Blank()
      this.bottomAction()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
  }

  @Builder bottomAction() {
    Row() {
      Button('联系客服',{ type: ButtonType.Normal, stateEffect: true })
        .layoutWeight(1)
        .height($r('app.string.lpx_88'))
        .margin({right: $r('app.string.lpx_22')})
        .fontColor($r('app.color.color_FF1F00'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .backgroundColor($r('app.color.color_FFEBEB'))
        .borderRadius($r('app.string.lpx_12'))
        .visibility(Visibility.None)
      Button('发送到邮箱',{ type: ButtonType.Normal, stateEffect: true })
        .layoutWeight(1)
        .height($r('app.string.lpx_88'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .borderRadius($r('app.string.lpx_12'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'),0.0],
            [$r('app.color.color_F12E29'),0.7],
            [$r('app.color.color_F12E29'),1.0]
          ]
        })
        .onClick(() => {
        })

    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_20'),
      bottom: $r('app.string.lpx_68'),
      left: $r('app.string.lpx_24'),
      right: $r('app.string.lpx_24')
    })
  }
}