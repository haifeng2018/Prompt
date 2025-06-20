import { router } from '@kit.ArkUI';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import { OrganNavList, OrganTabId } from '../../model/HomeTabModel';
import { CourseCategoryContentComp } from '../course/component/CourseCategoryContentComp';
import { StudyCenterTabContent } from '../studycenter/StudyCenterTabContent';
import { OrganHomeTabContent } from './OrganHomeTabContent';

@Entry
@Component
struct OrganMainPage {
  tag: string = 'OrganMainPage'
  @State tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  @State bottomTabIndex: number = 0
  @State loginData: LoginData | null = null
  @State subCategoryTabCheckedIndex: number = 0
  private controller: TabsController = new TabsController()

  aboutToAppear() {
    AppConfig.getLoginData()
      .then((resultData: LoginData) => {
        this.loginData = resultData
        if (this.bottomTabIndex === 2) {
          if (!this.loginData) {
            this.bottomTabIndex = 0
          }
        }
      })
    Logger.info(this.tag, `tenantId = ${this.tenantId}`);
  }

  build() {
    Column() {
      Tabs({ index: this.bottomTabIndex, barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          OrganHomeTabContent({ loginData: $loginData, tenantId: this.tenantId })
        }
        .tabBar(this.TabBuilder(OrganTabId.HOME))

        TabContent() {
          CourseCategoryContentComp({
            tenantId: this.tenantId
          })
        }
        .tabBar(this.TabBuilder(OrganTabId.CATEGORY))

        TabContent() {
          StudyCenterTabContent({
            loginData: $loginData,
            showBack: true
          })
        }
        .tabBar(this.TabBuilder(OrganTabId.STUDY_CENTER))
      }
      .vertical(false)
      .scrollable(false)
      .barWidth(Constants.FULL_PARENT)
      .barHeight($r('app.string.lpx_160'))
      .onChange((index: number) => {
        this.bottomTabIndex = index
      })
      .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  TabBuilder(index: number) {
    Column() {
      Image(this.bottomTabIndex === index ? OrganNavList[index].icon_selected : OrganNavList[index].icon)
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
        .objectFit(ImageFit.Contain)
      Text(OrganNavList[index].text)
        .margin({ top: $r('app.string.lpx_6') })
        .fontSize(this.bottomTabIndex === index ? lpx2fp(22) : lpx2fp(20))
        .fontColor(this.bottomTabIndex === index ? $r('app.color.color_333333') : $r('app.color.color_999999'))
    }
    .justifyContent(FlexAlign.Center)
    .padding({ bottom: $r('app.string.lpx_40') })
  }
}
