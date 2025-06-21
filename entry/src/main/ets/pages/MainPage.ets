// import { MeTabContent } from '../view/widget/MeTabContent';
import { NavList, TabId } from '../model/HomeTabModel';
// import { HomeTabContent } from '../view/widget/HomeTabContent';
import App from 'lib_core_model/src/main/ets/App';
import router from '@ohos.router';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { HomeTabContent } from './home/HomeTabContent';
import { MeTabContent } from './me/MeTabContent';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import { StudyCenterTabContent } from './studycenter/StudyCenterTabContent';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { TutorialTabContent } from './me/TutorialTabContent';

@Entry
@Component
struct MainPage {
  private TAG = 'MainPage'
  @State bottomTabIndex: number = 0
  private controller: TabsController = new TabsController()

  @State loginData: LoginData | null = null;

  private clickBackTimeRecord: number = 0;

  onBackPress() {
    let currentTime = new Date().getTime()
    let diffTime = currentTime - this.clickBackTimeRecord
    if (diffTime > Constants.APP_EXIT_INTERVAL) {
      ToastUtils.show('再按一次退出程序')
      this.clickBackTimeRecord = new Date().getTime();
      return true;
    }
    return false;
  }

  onPageShow() {
    Logger.error(this.TAG, `loginData = ${JSON.stringify(this.loginData)}`)
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      if (this.bottomTabIndex === 2) {
        if (!this.loginData) {
          this.bottomTabIndex = 0
        }
      }
    });
  }

  @Builder TabBuilder(index: number) {
    Column() {
      Image(this.bottomTabIndex === index ? NavList[index].icon_selected : NavList[index].icon)
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
        .objectFit(ImageFit.Contain)
      Text(NavList[index].text)
        .margin({top:$r('app.string.lpx_6')})
        .fontSize(this.bottomTabIndex === index ? lpx2fp(22) : lpx2fp(20))
        .fontColor(this.bottomTabIndex === index ? $r('app.color.color_333333') : $r('app.color.color_999999'))
    }
    .justifyContent(FlexAlign.Center)
    .padding({bottom: $r('app.string.lpx_40')})
  }

  build() {
    Column() {
      Tabs({index: this.bottomTabIndex, barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          HomeTabContent({
            loginData: $loginData
          })
        }
        .tabBar(this.TabBuilder(TabId.HOME))

        TabContent() {
          TutorialTabContent({
            loginData: $loginData
          })
        }
        .tabBar(this.TabBuilder(TabId.TUTORIAL))

        TabContent() {
          StudyCenterTabContent({
            loginData: $loginData
          })
        }
        .tabBar(this.TabBuilder(TabId.TOOLS))

        TabContent() {
          if (this.loginData?.token != null) {
            MeTabContent({
              loginData: $loginData
            })
          }
        }.tabBar(this.TabBuilder(TabId.ME))
      }
      .vertical(false)
      .scrollable(false)
      .barWidth(Constants.FULL_PARENT)
      .barHeight($r('app.string.lpx_160'))
      .onChange((index: number) => {
        this.bottomTabIndex = index
      })
      .onTabBarClick((index: number) => {
        if (index === 2 && this.loginData?.token == null) {
          App.get().pushUrl({
            url: RouterPath.CODE_LOGIN_PAGE
          }, router.RouterMode.Single)
        }
      })
      .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .justifyContent(FlexAlign.Center)
  }
}