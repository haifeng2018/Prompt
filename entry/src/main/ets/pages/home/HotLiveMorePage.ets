import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import HomeVM from 'lib_core_model/src/main/ets/vm/HomeVM';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct HotLiveMorePage {

  @State refreshConfig: RefreshConfig<GoodsInfo> = new RefreshConfig<GoodsInfo>()

  sendFreshnessRequest () {
    HomeVM.sendFreshnessRequest(0,this.refreshConfig.currentPage,this.refreshConfig.PAGE_SIZE).then((value: GoodsInfo[]) => {
      this.refreshConfig.setData(value,true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    this.sendFreshnessRequest()
  }

  refreshData () {
    this.sendFreshnessRequest()
  }

  loadMoreData () {
    this.sendFreshnessRequest()
  }

  build() {
    Column() {
      ToolBar({title: '热门直播'})
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
      .padding({
        top: $r('app.string.lpx_16'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')})
      .zIndex(0)
  }

  @Builder itemLayout(item: GoodsInfo) {
    Row(){
      Image(item.coverUrlExtendVo?.centre)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_224'))
        .height($r('app.string.lpx_126'))
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

        Blank()

        Text(`讲师：${GoodsShowUtil.getFirstLecturerName(item.lecturers)}`)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .margin({top: $r('app.string.lpx_16')})
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_126'))
      .margin({left: $r('app.string.lpx_20')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .margin({bottom: $r('app.string.lpx_16')})
    .padding({
      top: $r('app.string.lpx_24'),
      bottom: $r('app.string.lpx_24'),
      left: $r('app.string.lpx_16'),
      right: $r('app.string.lpx_16'),
    })
    .onClick(() => {
      CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0,item.onlineFlag,item.goodsId,0)
    })
  }
}
