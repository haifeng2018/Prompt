import { HPRichText } from '@ohasasugar/hp-richtext'
import LMList from 'lib_common/src/main/ets/components/refresh/LMList'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { CommentInfo } from 'lib_core_model/src/main/ets/data/CommentInfo'
import { CommentListParm } from 'lib_core_model/src/main/ets/data/CommentListParm'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import CommentVM from 'lib_core_model/src/main/ets/vm/CommentVM'

@Preview
@Component
export struct CourseCommentTabContent {
  tag: string = 'CourseEvaluationTabContent'
  @State loginData: LoginData | null = null
  @State refreshConfig: RefreshConfig<CommentInfo> = new RefreshConfig<CommentInfo>()
  private tenantId: number = 0
  private goodsId: string = ''
  private level: number | null = null

  sendCommentListRequest() {
    let body = new CommentListParm()
    body.goodsId = this.goodsId
    body.current = this.refreshConfig.currentPage
    body.size = this.refreshConfig.PAGE_SIZE
    if (this.level != 0) {
      body.level = this.level
    }

    CommentVM.sendCommentListRequest(this.tenantId, this.loginData?.token ?? '', body).then((value: CommentInfo[]) => {
      this.refreshConfig.setData(value, true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([], false)
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  refreshData() {
    this.sendCommentListRequest()
  }

  loadMoreData() {
    this.sendCommentListRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: object, index: number): void => this.itemLayout(data),
      onRefresh: () => {
        this.refreshData()
      },
      onLoadMore: () => {
        this.loadMoreData()
      }
    })
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16'), bottom: $r('app.string.lpx_48') })
  }

  @Builder
  itemLayout(item: CommentInfo) {
    Column() {
      Row() {
        Image(item?.virHeadImg || $r('app.media.ic_avatar_place_holder'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))
          .borderRadius($r('app.string.lpx_20'))
        Text(item?.name)
          .layoutWeight(1)
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_8') })
        Text(DateUtil.transNumberDate(item?.createAt ?? 0))
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      .padding({
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })

      if (item?.markContent) {
        Text(item?.markContent)
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({ top: $r('app.string.lpx_20') })
          .padding({
            left: $r('app.string.lpx_20'),
            right: $r('app.string.lpx_20')
          })
      }

      if (GoodsShowUtil.getCourseEvaluateUrl(item?.imgs)?.length > 0) {
        List() {
          ForEach(GoodsShowUtil.getCourseEvaluateUrl(item?.imgs), (url: string, index) => {
            ListItem() {
              Image(url)
                .width($r('app.string.lpx_212'))
                .height($r('app.string.lpx_212'))
                .borderRadius($r('app.string.lpx_8'))
            }
            .padding($r('app.string.lpx_10'))
            .onClick(() => {
              App.get().pushUrl({
                url: RouterPath.POSTER_PAGE,
                params: {
                  data: GoodsShowUtil.getCourseEvaluateUrl(item?.imgs),
                  page_position: index
                }
              })
            })
          })
        }
        .width(Constants.FULL_PARENT)
        .lanes(3)
        .margin({ top: $r('app.string.lpx_20') })
        .padding({
          left: $r('app.string.lpx_10'),
          right: $r('app.string.lpx_10')
        })
      }
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .margin({ top: $r('app.string.lpx_16') })
    .padding({
      top: $r('app.string.lpx_24'),
      bottom: $r('app.string.lpx_24'),
    })
  }

  @Builder
  emptyLayout() {
    Column() {
      Image($r('app.media.img_no_data'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_400'))
        .objectFit(ImageFit.Contain)
      Text('暂无评价')
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_666666'))
    }
    .width($r('app.string.lpx_750'))
    .padding({ top: $r('app.string.lpx_150') })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
