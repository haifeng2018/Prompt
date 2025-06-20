import router from '@ohos.router'
import { PopularityGroupInfo } from 'lib_core_model/src/main/ets/data/PopularityGroupInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import HomeVM from 'lib_core_model/src/main/ets/vm/HomeVM';
import { HomeRecommendMoreContent } from './HomeRecommendMoreContent';
import { ToolBar } from '../../view/widget/ToolBar';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@Entry
@Component
struct HomeRecommendMorePage {
  tenantId?: number = (router.getParams() as object)?.[Constants.DATA];

  @State popularityGroupList: Array<PopularityGroupInfo> = []
  @State popularityTabCheckedIndex: number = 0

  sendPopularityGroupRequest () {
    HomeVM.sendPopularityGroupRequest(this.tenantId ?? 0).then((data: PopularityGroupInfo[]) => {
      this.popularityGroupList = data
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    this.sendPopularityGroupRequest()
  }

  build() {
    Column() {
      ToolBar({title: '爆款推荐'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Tabs({ barPosition: BarPosition.Start }) {
      ForEach(this.popularityGroupList, (item: PopularityGroupInfo,index) => {
        TabContent() {
          HomeRecommendMoreContent({ tenantId: this.tenantId,groupingId: item.groupingId })
        }
        .tabBar(this.TabBuilder(index,index === this.popularityGroupList.length - 1, item.groupingName))
        .align(Alignment.Top)
        .margin({top: $r('app.string.lpx_16')})
      })
    }
    .vertical(false)
    .barMode(BarMode.Scrollable)
    .barWidth(Constants.FULL_PARENT)
    .barHeight($r('app.string.lpx_74'))
    .onChange((index: number) => {
      this.popularityTabCheckedIndex = index
    })
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({top: $r('app.string.lpx_16')})
  }

  @Builder TabBuilder(index: number,isLastItem: boolean, name?: string) {
    Row(){
      Column() {
        Text(name)
          .layoutWeight(1)
          .fontColor($r('app.color.color_333333'))
          .fontSize(this.popularityTabCheckedIndex === index ? lpx2fp(28) : lpx2fp(26))
          .fontWeight(this.popularityTabCheckedIndex === index ? FontWeight.Bold : FontWeight.Normal)

        Image($r('app.media.ic_tab_indicator'))
          .height($r('app.string.lpx_10'))
          .opacity(this.popularityTabCheckedIndex === index ? 1 : 0)
      }
      .justifyContent(FlexAlign.Center)
      .padding({left: $r('app.string.lpx_20'),right: $r('app.string.lpx_20')})

      Divider()
        .vertical(true)
        .color($r('app.color.color_D9D9D9'))
        .strokeWidth(`${$r('app.string.lpx_2')}`)
        .height($r('app.string.lpx_30'))
        .margin({bottom: $r('app.string.lpx_10')})
        .opacity(isLastItem ? 0 : 1)
    }
    .height(Constants.FULL_PARENT)
    .padding({
      top:$r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
    })
  }

}
