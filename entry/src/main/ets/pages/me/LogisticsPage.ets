import OrderVM from 'lib_core_model/src/main/ets/vm/OrderVM'
import { router } from '@kit.ArkUI';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { LogisticsData } from 'lib_core_model/src/main/ets/data/LogisticsData';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { LogisticsInfo } from 'lib_core_model/src/main/ets/data/LogisticsInfo';
import { ToolBar } from '../../view/widget/ToolBar';
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import LogisticsCell from './cell/LogisticsCell';

@Entry
@Component
struct LogisticsPage {
  orderNo: string = (router.getParams() as object)?.[Constants.DATA];
  tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID];

  @State loginData: LoginData | null = null
  @State refreshConfig: RefreshConfig<LogisticsInfo> = new RefreshConfig<LogisticsInfo>()

  @State isUser: number = 0//代表查询缓存 1第3方 请求有数据才替换默认0请求的数据

  @State clickIndex: number = Constants.DEFAULT_CLICK_INDEX;

  sendLogisiticsInfoRequest () {
    OrderVM.sendLogisiticsInfoRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.orderNo ?? '',this.isUser)
      .then((value: LogisticsData) => {
      this.refreshConfig.setData(value.dataList ?? [],true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  refreshData () {
    this.sendLogisiticsInfoRequest()
  }

  loadMoreData () {
    this.sendLogisiticsInfoRequest()
  }

  build() {
    Column() {
      ToolBar({title: '物流信息'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: object,index: number): void => this.itemLayout(data),
      onRefresh: () => {
        this.refreshData()
      },
      onLoadMore: () => {
        this.loadMoreData()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({top: $r('app.string.lpx_8')})
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder itemLayout(item: LogisticsInfo) {
    LogisticsCell({
      data: item,
      index: 0,
      clickIndex: $clickIndex
    })
  }
}