import router from '@ohos.router';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { SearchKeywordData } from 'lib_core_model/src/main/ets/data/SearchKeywordData';
import App from 'lib_core_model/src/main/ets/App';
import { SearchCourseTabContent } from './SearchCourseTabContent';
import { SearchOrganTabContent } from './SearchOrganTabContent';
import { SearchTutorTabContent } from './SearchTutorTabContent';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@Entry
@Component
struct SearchResultPage {
  searchKey: string = (router.getParams() as object)?.[Constants.DATA];
  tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  @State searchInput: string = this.searchKey
  @State searchKeywordData: SearchKeywordData | null = null

  @State tabTitles: Array<string> = ['课程','讲师','机构']
  @State popularityTabCheckedIndex: number = 0

  build() {
    Column() {
      this.titleBar()
      this.searchContent()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder titleBar() {
    Row(){
      Stack() {
        TextInput({
          text: this.searchKey,
          placeholder: this.searchKey || '关键词/课程名称/导师名称',
        })
          .placeholderFont({ size: lpx2fp(24)})
          .width(Constants.FULL_PARENT)
          .height($r('app.string.lpx_68'))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_333333'))
          .caretColor($r('app.color.color_EB4F3A'))
          .enterKeyType(EnterKeyType.Search)
          .backgroundColor($r('app.color.color_F5F5F5'))
          .borderRadius($r('app.string.lpx_34'))
          .padding({left:$r('app.string.lpx_66'),right: $r('app.string.lpx_22')})
          .onChange((value: string) => {
            this.searchKey = value
          })
          .onSubmit((enterKey: EnterKeyType) => {
            this.searchInput = this.searchKey
          })

        Image($r('app.media.ic_search'))
          .width($r('app.string.lpx_32'))
          .height($r('app.string.lpx_32'))
          .margin({left: $r('app.string.lpx_22')})
      }
      .height($r('app.string.lpx_68'))
      .layoutWeight(1)
      .alignContent(Alignment.Start)

      Text('取消')
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
        .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
        .onClick(()=> {
          App.get().back()
        })

    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({
      top:$r('app.string.lpx_100'),
      bottom: $r('app.string.lpx_20'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }

  @Builder searchContent() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {
        SearchCourseTabContent({
          tenantId: this.tenantId,
          searchInput: $searchInput
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[0],0))

      TabContent() {
        SearchTutorTabContent({
          tenantId: this.tenantId,
          searchInput: $searchInput
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[1],1))

      TabContent() {
        SearchOrganTabContent({
          tenantId: this.tenantId,
          searchInput: $searchInput
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[2],2))
    }
    .vertical(false)
    .barMode(BarMode.Scrollable)
    .barWidth(Constants.FULL_PARENT)
    .barHeight($r('app.string.lpx_80'))
    .onChange((index: number) => {
      this.popularityTabCheckedIndex = index
    })
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .backgroundColor($r('app.color.white'))
  }

  @Builder TabBuilder(title: string,index: number) {
    Row(){
      Column() {
        Text(title)
          .layoutWeight(1)
          .fontColor($r('app.color.color_333333'))
          .fontSize(this.popularityTabCheckedIndex === index ? lpx2fp(28) : lpx2fp(26))
          .fontWeight(this.popularityTabCheckedIndex === index ? FontWeight.Bold : FontWeight.Normal)

        Image($r('app.media.ic_tab_indicator'))
          .height($r('app.string.lpx_10'))
          .opacity(this.popularityTabCheckedIndex === index ? 1 : 0)
      }
      .justifyContent(FlexAlign.Center)
      .padding({left: $r('app.string.lpx_24'),right: $r('app.string.lpx_24')})
    }
    .height(Constants.FULL_PARENT)
    .margin({
      right: index == this.tabTitles.length - 1 ? $r('app.string.lpx_400') : 0
    })
    .padding({
      top:$r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10')
    })
  }

}
