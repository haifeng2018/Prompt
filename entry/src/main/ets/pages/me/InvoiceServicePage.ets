import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { ToolBar } from '../../view/widget/ToolBar'
import { AllInvoiceTabContent } from './AllInvoiceTabContent'
import { InvoicedTabContent } from './InvoicedTabContent'
import { InvoicingTabContent } from './InvoicingTabContent'
import { NotInvoicedTabContent } from './NotInvoicedTabContent'

@Entry
@Component
struct InvoiceServicePage {

  @State loginData: LoginData | null = null

  @State tabCheckPosition: number = 0
  private tabTitles = ['全部','未开票','开票中','已开票']

  build() {
    Column() {
      ToolBar({title: '发票服务',shadowColor: $r('app.color.transparent')})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {
        AllInvoiceTabContent()
      }
      .tabBar(this.TabBuilder(0))
      .align(Alignment.Top)

      TabContent() {
        NotInvoicedTabContent()
      }
      .tabBar(this.TabBuilder(1))
      .align(Alignment.Top)

      TabContent() {
        InvoicingTabContent()
      }
      .tabBar(this.TabBuilder(2))
      .align(Alignment.Top)

      TabContent() {
        InvoicedTabContent()
      }
      .tabBar(this.TabBuilder(3))
      .align(Alignment.Top)
    }
    .vertical(false)
    .barMode(BarMode.Fixed)
    .barWidth(Constants.FULL_PARENT)
    .barHeight($r('app.string.lpx_78'))
    .backgroundColor($r('app.color.white'))
    .onChange((index: number) => {
      this.tabCheckPosition = index
    })
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
  }

  @Builder TabBuilder(index: number) {
    Row(){
      Column() {
        Text(this.tabTitles[index])
          .layoutWeight(1)
          .fontColor($r('app.color.color_333333'))
          .fontSize(this.tabCheckPosition === index ? lpx2fp(32) : lpx2fp(30))
          .fontWeight(this.tabCheckPosition === index ? FontWeight.Bold : FontWeight.Normal)

        Image($r('app.media.ic_tab_indicator'))
          .height($r('app.string.lpx_10'))
          .opacity(this.tabCheckPosition === index ? 1 : 0)
      }
      .width($r('app.string.lpx_150'))
      .height(Constants.FULL_PARENT)
      .justifyContent(FlexAlign.Center)
    }
    .height(Constants.FULL_PARENT)
    .padding({
      top:$r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
    })
  }

}
