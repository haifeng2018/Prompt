import EmptyLayout from 'lib_common/src/main/ets/components/refresh/EmptyLayout';
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import LoadEndLayout from 'lib_common/src/main/ets/components/refresh/LoadEndLayout';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import { CourseCategoryInfo } from 'lib_core_model/src/main/ets/data/CourseCategoryInfo';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { BuySource, OnlineFlag } from 'lib_core_model/src/main/ets/util/Enums';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM';

import CourseDetailActionUtil from '../../../util/action/CourseDetailActionUtil';
import PayOrderActionUtil from '../../../util/action/PayOrderActionUtil';
import PayOrderUtil from '../../../util/PayOrderUtil';
import CourseProductConfigV2Dialog from '../../../view/dialog/CourseProductConfigV2Dialog';
import { CoursePriceLineStyleDisplayComp } from '../../common/CoursePriceDisplayComp';
import { CourseSaleStateDisplayComp } from '../../common/CourseSaleStateDisplayComp';
import { CourseTitleDisplayComp } from '../../common/CourseTitleDisplayComp';
import { TenantDisplayComp } from '../../common/TenantDisplayComp';

@Component
export struct CourseCategoryContentTabComp {
  tag: string = 'AllCourseContentTabComp'
  @State tenantId: number = 0
  @State categoryInfo?: CourseCategoryInfo | null = null
  @State categoryId: string = ""
  @State subCategoryList: Array<CourseCategoryInfo> = []
  @Link subCategoryTabCheckedIndex: number
  @State currentPage: number = 1
  @State sortType: number = 1 //排序类型 1：最热 2：最新 3：综合
  @State refreshConfig: RefreshConfig<GoodsInfo> = new RefreshConfig<GoodsInfo>()
  @State currentSelectGoodsInfo: GoodsInfo | null = null
  subCategoryScroller = new Scroller()
  courseProductConfigDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseProductConfigV2Dialog({
      goodsInfo: this.currentSelectGoodsInfo
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })

  sendCategoryCourseRequest() {
    CourseVM.sendCategoryCourseRequest(this.tenantId, this.categoryId, this.sortType,
      this.refreshConfig.currentPage, this.refreshConfig.PAGE_SIZE).then((data: GoodsInfo[]) => {
      this.refreshConfig.setData(data, true)
      data.map((item) => {
        return item.orderNo
      }).forEach((item) => {
        Logger.info(this.tag, `orderNo = ${item}`)
      })
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([], false)
      ToastUtils.show(err)
    });
  }

  aboutToAppear() {
    this.categoryId = this.categoryInfo?.catalogueId ?? ''
    let subCategoryCount = this.categoryInfo?.catalogueListVos?.length ?? 0
    if (subCategoryCount > 0) {
      const allInfo = new CourseCategoryInfo()
      allInfo.catalogueName = '全部'
      allInfo.catalogueId = this.categoryInfo?.catalogueId
      this.subCategoryList.push(allInfo)
      this.subCategoryList = this.subCategoryList.concat(this.categoryInfo?.catalogueListVos ?? [])
    } else {
      this.subCategoryList = this.categoryInfo?.catalogueListVos ?? []
    }

    this.refreshData()
  }

  aboutToDisappear() {
  }

  refreshData() {
    this.currentPage = 1
    this.sendCategoryCourseRequest()
  }

  loadMoreData() {
    this.currentPage++
    this.sendCategoryCourseRequest()
  }

  handleBuyCourse(item: GoodsInfo) {
    if (item.onlineFlag == OnlineFlag.Online) {
      PayOrderActionUtil.payOrder(PayOrderUtil.getOnlineOrderDetailData(BuySource.CourseList, item))
    } else if (item.onlineFlag == OnlineFlag.Offline) {
      this.courseProductConfigDlgCtl.close()
      this.currentSelectGoodsInfo = item
      this.courseProductConfigDlgCtl.open()
    }
  }

  build() {
    Column() {
      this.subCategoryGroup()
      Row() {
        Text('最热')
          .width($r('app.string.lpx_80'))
          .height($r('app.string.lpx_40'))
          .fontColor(this.sortType === 1 ? $r('app.color.color_FF1F00') : $r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .textAlign(TextAlign.Center)
          .backgroundColor(this.sortType === 1 ? $r('app.color.color_FFECEC') : $r('app.color.color_F5F6FA'))
          .borderRadius($r('app.string.lpx_8'))
          .onClick(() => {
            this.sortType = 1
            this.sendCategoryCourseRequest()
          })
        Text('最新')
          .width($r('app.string.lpx_80'))
          .height($r('app.string.lpx_40'))
          .fontColor(this.sortType === 2 ? $r('app.color.color_FF1F00') : $r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .textAlign(TextAlign.Center)
          .backgroundColor(this.sortType === 2 ? $r('app.color.color_FFECEC') : $r('app.color.color_F5F6FA'))
          .borderRadius($r('app.string.lpx_8'))
          .margin({ left: $r('app.string.lpx_16') })
          .onClick(() => {
            this.sortType = 2
            this.sendCategoryCourseRequest()
          })
      }
      .width(Constants.FULL_PARENT)
      .justifyContent(FlexAlign.Start)
      .zIndex(1)
      .margin({ top: $r('app.string.lpx_20') })

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
        .layoutWeight(1)
        .margin({ top: $r('app.string.lpx_8') })
        .zIndex(0)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
  }

  @Builder
  subCategoryGroup() {
    List({ scroller: this.subCategoryScroller }) {
      ForEach(this.subCategoryList, (item: CourseCategoryInfo, index) => {
        ListItem() {
          this.subCategoryGroupCell(index, item)
        }
        .onClick(() => {
          if (index > 0) {
            this.subCategoryScroller.scrollToIndex(index - 1)
          }
          this.subCategoryTabCheckedIndex = index
          this.categoryId = item.catalogueId ?? ''
          this.sendCategoryCourseRequest()
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_80'))
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
    .margin({ top: $r('app.string.lpx_16') })
    .padding({
      left: $r('app.string.lpx_12'),
      right: $r('app.string.lpx_12')
    })
    .visibility((this.categoryInfo?.catalogueListVos?.length ?? 0) > 0 ? Visibility.Visible : Visibility.None)
  }

  @Builder
  subCategoryGroupCell(index: number, data: CourseCategoryInfo) {
    Column() {
      Text(data.catalogueName)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_777777'))
      Image($r('app.media.ic_tab_indicator'))
        .height($r('app.string.lpx_10'))
        .margin({ top: $r('app.string.lpx_8') })
        .opacity(this.subCategoryTabCheckedIndex === index ? 1 : 0)
    }
    .height(Constants.FULL_PARENT)
    .justifyContent(FlexAlign.Center)
    .padding($r('app.string.lpx_20'))
  }

  @Builder
  itemLayout(item: GoodsInfo) {
    Row() {
      Image(item.coverVerticalUrl || $r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_180'))
        .height($r('app.string.lpx_180'))
        .border({ radius: $r('app.string.lpx_8') })

      Column() {

        CourseTitleDisplayComp({
          title: item.contentName,
          titleFontSize: lpx2fp(28),
          showOfflineCourseIcon: item.onlineFlag == OnlineFlag.Offline ? true : false
        })

        Blank()

        Row() {
          CoursePriceLineStyleDisplayComp({
            goodsInfo: item
          })
          Blank()

          CourseSaleStateDisplayComp({
            goodsInfo: item
          })
        }
        .width(Constants.FULL_PARENT)
        .margin({ bottom: $r('app.string.lpx_20') })

        TenantDisplayComp({ courseTenantInfo: item.tenantVO, visibilityEnterStore: true })
          .width(Constants.FULL_PARENT)
          .alignSelf(ItemAlign.Start)
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .margin({ left: $r('app.string.lpx_24') })
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_12'),
      bottom: $r('app.string.lpx_12'),
    })
    .onClick(() => {
      CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0, item.onlineFlag, item.goodsId, 0)
    })
  }

  @Builder
  loadEndLayout() {
    LoadEndLayout()
  }

  @Builder
  emptyLayout() {
    EmptyLayout()
  }
}
