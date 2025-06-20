import router from '@ohos.router'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { ToolBar } from '../../view/widget/ToolBar';
import { AllOrderTabContent } from './AllOrderTabContent';
import { CancelOrderTabContent } from './CancelOrderTabContent';
import { CompletedOrderTabContent } from './CompletedOrderTabContent';
import { UnCommentOrderTabContent } from './UnCommentOrderTabContent';
import { UnPaidOrderTabContent } from './UnPaidOrderTabContent';

@Entry
@Component
struct MyOrderPage {

  @State tabCheckPosition: number = (router.getParams() as object)?.[Constants.PAGE_POSITION];
  @State loginData: LoginData | null = null

  private tabTitles = ['全部','未支付','已完成','已取消','待评价']


  build() {
    Column() {
      ToolBar({title: '我的订单',shadowColor: $r('app.color.transparent')})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Tabs({ index: this.tabCheckPosition, barPosition: BarPosition.Start }) {
      TabContent() {
        AllOrderTabContent()
      }
      .tabBar(this.TabBuilder(0))
      .align(Alignment.Top)

      TabContent() {
        UnPaidOrderTabContent()
      }
      .tabBar(this.TabBuilder(1))
      .align(Alignment.Top)

      TabContent() {
        CompletedOrderTabContent()
      }
      .tabBar(this.TabBuilder(2))
      .align(Alignment.Top)

      TabContent() {
        CancelOrderTabContent()
      }
      .tabBar(this.TabBuilder(3))
      .align(Alignment.Top)

      TabContent() {
        UnCommentOrderTabContent({
          pagerPosition: 4
        })
      }
      .tabBar(this.TabBuilder(4))
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
      Text(this.tabTitles[index])
        .height(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(this.tabCheckPosition === index ? lpx2fp(32) :lpx2fp(30))
        .fontWeight(this.tabCheckPosition === index ? FontWeight.Bold : FontWeight.Normal)
    }
    .height(Constants.FULL_PARENT)
    .padding({
      top:$r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
    })
  }

}
