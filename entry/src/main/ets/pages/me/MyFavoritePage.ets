import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { CollectInfo } from 'lib_core_model/src/main/ets/data/CollectInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import CollectVM from 'lib_core_model/src/main/ets/vm/CollectVM';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';
import { ToolBar } from '../../view/widget/ToolBar';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@Entry
@Component
struct MyFavoritePage {

  @State loginData: LoginData | null = null

  @State refreshConfig: RefreshConfig<CollectInfo> = new RefreshConfig<CollectInfo>()

  sendMyFavoriteRequest () {
    CollectVM.sendMyFavoriteRequest(this.loginData?.token ?? '',this.refreshConfig.currentPage,
      this.refreshConfig.PAGE_SIZE).then((value: CollectInfo[]) => {
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
    this.sendMyFavoriteRequest()
  }

  loadMoreData () {
    this.sendMyFavoriteRequest()
  }

  build() {
    Column() {
      ToolBar({title: '我的收藏'})
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

  @Builder itemLayout(item: CollectInfo) {
    Row(){
      Image(item.coverUrlExtendVo?.centre)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_192'))
        .height($r('app.string.lpx_192'))
        .border({radius: $r('app.string.lpx_8')})

      Column() {

        Text(item.contentName)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(2)
          .textOverflow({overflow: TextOverflow.Ellipsis})

        Text(GoodsShowUtil.getFirstLecturerLabel(item.lecturers))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .margin({top: $r('app.string.lpx_16')})

        Blank()

        Row() {
          Image($r('app.media.ic_play_count_grey'))
            .width($r('app.string.lpx_12'))
            .height($r('app.string.lpx_15'))
            .margin({left: $r('app.string.lpx_16')})

          Text(GoodsShowUtil.getGoodsPopularityTxt(item.goodsPopularity ?? 0))
            .fontSize(lpx2fp(22))
            .fontColor($r('app.color.color_999999'))
            .margin({left: $r('app.string.lpx_10')})

          Blank()

          Text('已下架')
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(28))
            .opacity(item.shelveFlag === 0 ? 0 : 1)
        }
        .width(Constants.FULL_PARENT)
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .margin({left: $r('app.string.lpx_24')})
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_20'),
      bottom: $r('app.string.lpx_20')
    })
    .onClick(() => {
      CourseDetailActionUtil.courseDetail(item.tenantId ?? 0,item.onlineFlag,item.goodsId,0)
    })
  }
}
