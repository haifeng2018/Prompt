import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { WatchHistoryInfo } from 'lib_core_model/src/main/ets/data/WatchHistoryInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import StudyCenterVM from 'lib_core_model/src/main/ets/vm/StudyCenterVM';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';
import DateUtil from 'lib_common/src/main/ets/util/DateUtil';
import TimeUtil from '../../util/TimeUtil';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct WatchHistoryPage {

  @State loginData: LoginData | null = null

  @State refreshConfig: RefreshConfig<WatchHistoryInfo> = new RefreshConfig<WatchHistoryInfo>()

  sendWatchHistoryRequest () {
    StudyCenterVM.sendWatchHistoryRequest(this.loginData?.token ?? '',
      this.refreshConfig.currentPage,this.refreshConfig.PAGE_SIZE)
      .then((value: WatchHistoryInfo[]) => {
        this.refreshConfig.setData(value,true)
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
    this.sendWatchHistoryRequest()
  }

  loadMoreData () {
    this.sendWatchHistoryRequest()
  }

  build() {
    Column() {
      ToolBar({title: '观看历史'})
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
      .zIndex(0)
  }

  @Builder itemLayout(item: WatchHistoryInfo) {
    Column() {
      Text(DateUtil.transNumberDateHM(item.updateTime ?? 0))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Start)

      Row() {
        Stack() {
          Image(item.coverUrlExtendVo?.centre)
            .width(Constants.FULL_PARENT)
            .height(Constants.FULL_PARENT)
            .border({radius: $r('app.string.lpx_8')})
          Image($r('app.media.ic_watch_history_play'))
            .width($r('app.string.lpx_64'))
            .height($r('app.string.lpx_64'))
        }
        .width($r('app.string.lpx_180'))
        .height($r('app.string.lpx_180'))

        Column() {
          Text(item.contentName)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
          Blank()
          Row() {
            Image($r('app.media.ic_watch_history'))
              .width($r('app.string.lpx_36'))
              .height($r('app.string.lpx_36'))
            Text(`观看至 ${TimeUtil.getHMS(item.lastPosition)}`)
              .layoutWeight(1)
              .textAlign(TextAlign.Start)
              .fontColor($r('app.color.color_999999'))
              .fontSize(lpx2fp(28))
              .maxLines(1)
              .textOverflow({overflow: TextOverflow.Ellipsis})
              .margin({left: $r('app.string.lpx_8')})
          }
          .width(Constants.FULL_PARENT)
        }
        .height($r('app.string.lpx_180'))
        .layoutWeight(1)
        .margin({left: $r('app.string.lpx_16')})
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_20')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .onClick(() => {
      CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0,item.onlineFlag, item.goodsId)
    })
  }

  @Builder emptyLayout() {
    Column() {
      Image($r('app.media.img_no_practice'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_400'))
        .objectFit(ImageFit.Contain)
      Text('暂无观看历史')
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_666666'))

      Text('点击重试')
        .height($r('app.string.lpx_52'))
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.color_DA3732'))
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.color_FEFAFA'))
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_26'),
          color: $r('app.color.color_DA3732')
        })
        .margin({top: $r('app.string.lpx_60')})
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
    }
    .width($r('app.string.lpx_750'))
    .padding({top: $r('app.string.lpx_150')})
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

}
