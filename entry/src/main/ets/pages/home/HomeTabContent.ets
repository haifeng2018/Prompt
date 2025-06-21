/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeTabContent
 * Author: Victor
 * Date: 2024/06/24 15:37
 * Description: 
 * -----------------------------------------------------------------
 */

import { router } from '@kit.ArkUI';
import { it } from '@ohos/hypium';
import LoadEndLayout from 'lib_common/src/main/ets/components/refresh/LoadEndLayout';
import LoadMoreLayout from 'lib_common/src/main/ets/components/refresh/LoadMoreLayout';
import { PageState } from 'lib_common/src/main/ets/components/refresh/PageState';
import { listTouchEvent } from 'lib_common/src/main/ets/components/refresh/PullDownRefresh';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import RefreshHeader from 'lib_common/src/main/ets/components/refresh/RefreshHeader';
import { RefreshLayoutPrams } from 'lib_common/src/main/ets/components/refresh/RefreshLayoutPrams';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import App from 'lib_core_model/src/main/ets/App';
import { AdData } from 'lib_core_model/src/main/ets/data/AdData';
import { AdInfo } from 'lib_core_model/src/main/ets/data/AdInfo';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { HomeLevelInfo } from 'lib_core_model/src/main/ets/data/HomeLevelInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { SearchTrendInfo } from 'lib_core_model/src/main/ets/data/SearchTrendInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import HomeVM from 'lib_core_model/src/main/ets/vm/HomeVM';
import AdActionUtil from '../../util/action/AdActionUtil';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';
import { HomeToolBar } from '../../view/widget/HomeToolBar';
import { CoursePriceLineStyleDisplayComp } from '../common/CoursePriceDisplayComp';
import { TenantDisplayComp } from '../common/TenantDisplayComp';

@Preview
@Component
export struct HomeTabContent {
  @State hotSearchKeys: Array<SearchTrendInfo> = []
  @State adCategoryList: Array<AdInfo> = []
  @State bannerList: Array<AdInfo> = []
  @State homeLevelList: Array<HomeLevelInfo> = []
  @State homeLevelCourseList: Array<GoodsInfo> = []
  @Link @Watch('refreshData') loginData: LoginData;
  @State refreshConfig: RefreshConfig<GoodsInfo> = new RefreshConfig<GoodsInfo>()
  @State popularityTabCheckedIndex: number = 0
  @State youMayLikeLevelId: string = ''

  sendSearchTrendRequest() {
    HomeVM.sendSearchTrendRequest(0).then((data: SearchTrendInfo[]) => {
      this.hotSearchKeys = data
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendCategoryRequest() {
    HomeVM.sendCategoryRequest(0).then((data: AdData) => {
      this.adCategoryList = data.adInfoVos || []
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendHomeCenterBannerRequest() {
    HomeVM.sendHomeCenterBannerRequest().then((data: AdData) => {
      this.bannerList = data.adInfoVos || []
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    });
  }

  sendHomeLevelRequest() {
    HomeVM.sendHomeLevelRequest().then((data: HomeLevelInfo[]) => {
      this.homeLevelList = data
      if (data.length >= 1) {
        let recommendInfo = data[0]

        let childCount = recommendInfo.childs?.length ?? 0
        if (childCount >= 1) {
          let subCategoryInfo = recommendInfo.childs?.[0]
          let id = subCategoryInfo?.id ?? ''
          if (id) {
            this.sendHomeLevelCourseRequest(id)
          }
        }
      }
      if (data.length >= 2) {
        let youMayLikeInfo = data[1]
        let id = youMayLikeInfo?.id ?? ''
        if (id) {
          this.youMayLikeLevelId = id
          this.sendYouMayLikeCourseRequest()
        }
      }
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    });
  }

  sendHomeLevelCourseRequest(levelId: string) {
    HomeVM.sendHomeLevelCourseRequest(levelId, 1, 4).then((data: GoodsInfo[]) => {
      this.homeLevelCourseList = data
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    });
  }

  sendYouMayLikeCourseRequest() {
    HomeVM.sendYouMayLikeCourseRequest(this.youMayLikeLevelId, this.refreshConfig.currentPage,
      this.refreshConfig.PAGE_SIZE).then((data: GoodsInfo[]) => {
      this.refreshConfig.setAllData(data, true, 8)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([], false)
      ToastUtils.show(err)
    });
  }

  sendAllRequest() {
    this.sendSearchTrendRequest()
    this.sendCategoryRequest()
    this.sendHomeLevelRequest()
    this.sendHomeCenterBannerRequest()
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    });
    this.refreshData()
  }

  refreshData() {
    this.sendAllRequest()
  }

  loadMoreData() {
    this.sendYouMayLikeCourseRequest()
  }

  build() {
    Column() {
      HomeToolBar({
        title: '录制提词器',
        titleActionIcon: $r('app.media.ic_home_course_cell_more')
      })
      this.titleBar()
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
    .justifyContent(FlexAlign.Start)
  }

  @Builder titleBar() {
    Stack() {
      Text('输入关键字')
        .height($r('app.string.lpx_80'))
        .width(Constants.FULL_PARENT)
        .padding({ left: $r('app.string.lpx_20') })
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_16'))
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.color_999999'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .onClick(() => {
          App.get().pushUrl({
            url: RouterPath.SEARCH_PAGE,
            params: {
            },
          })
        })

      Image($r('app.media.ic_home_search'))
        .width($r('app.string.lpx_32'))
        .height($r('app.string.lpx_32'))
        .margin({ right: $r('app.string.lpx_20') })
    }
    .width(Constants.FULL_PARENT)
    .alignContent(Alignment.End)
    .padding({
      top: $r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .margin({ top: $r('app.string.lpx_10') })
    .zIndex(1)
  }

  @Builder
  content() {
    Column() {
      List() {
        ListItem() {
          RefreshHeader({
            refreshLayoutPrams: new RefreshLayoutPrams(
              this.refreshConfig.isVisiblePullDown,
              this.refreshConfig.pullDownRefreshImage,
              this.refreshConfig.pullDownRefreshText,
              this.refreshConfig.pullDownRefreshHeight,
              this.refreshConfig.refreshState)
          })
        }

        ListItem() {
          this.banner()
        }
        .margin({
          top: $r('app.string.lpx_32'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })

        ListItem() {
          this.youMayLikeCourse()
        }
        .margin({
          top: $r('app.string.lpx_32'),
          left: $r('app.string.lpx_22'),
          right: $r('app.string.lpx_22')
        })

        ListItem() {
          if (this.refreshConfig.hasMore) {
            LoadMoreLayout({
              refreshLayoutPrams: new RefreshLayoutPrams(
                this.refreshConfig.isVisiblePullUpLoad,
                this.refreshConfig.pullUpLoadImage,
                this.refreshConfig.pullUpLoadText,
                this.refreshConfig.pullUpLoadHeight)
            })
          } else {
            LoadEndLayout()
          }
        }
      }
      .scrollBar(BarState.Off)
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .edgeEffect(EdgeEffect.None)
      .offset({ x: 0, y: `${this.refreshConfig.offsetY < 0 ? 0 : this.refreshConfig.offsetY}px` })
      .onScrollIndex((start: number, end: number) => {
        // Listen to the first index of the current list.
        this.refreshConfig.startIndex = start;
        this.refreshConfig.endIndex = end;
      })
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({ top: $r('app.string.lpx_10') })
    .padding({ bottom: $r('app.string.lpx_20') })
    .onTouch((event: TouchEvent | undefined) => {
      if (event) {
        if (this.refreshConfig.pageState === PageState.Success) {
          listTouchEvent(this.refreshConfig, event,
            () => {
              this.refreshData()
            },
            () => {
              this.loadMoreData()
            },
          );
        }
      }
    })
  }

  @Builder banner() {
    Swiper() {
      ForEach(this.refreshConfig.data, (item: GoodsInfo) => {
        Image(item?.coverUrl)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .borderRadius($r('app.string.lpx_12'))
          .onClick(() => {
            // AdActionUtil.toPage(item)
          })
      })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_192'))
    .cachedCount(this.bannerList.length)
    .index(0)
    .autoPlay(this.bannerList.length > 1)
    .interval(3000)
    .indicator( // 设置圆点导航点样式
      new DotIndicator()
        .itemWidth($r('app.string.lpx_10'))
        .itemHeight($r('app.string.lpx_10'))
        .selectedItemWidth($r('app.string.lpx_10'))
        .selectedItemHeight($r('app.string.lpx_10'))
        .color($r('app.color.color_80FFFFFF'))
        .selectedColor($r('app.color.white'))
        .mask(false)
    )
    .loop(true)
    .duration(1000)
    .itemSpace(10)
    .curve(Curve.Linear)
  }

  @Builder youMayLikeCourse() {
    List() {
      ForEach(this.refreshConfig.data, (item: GoodsInfo) => {
        ListItem() {
          this.promptCell(item)
        }
        .width(Constants.FULL_PARENT)
        .padding({ left: $r('app.string.lpx_10'), right: $r('app.string.lpx_10') })
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0, item.onlineFlag, item.goodsId,
            item.subOrderId)
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .padding({ bottom: $r('app.string.lpx_20') })
    .scrollBar(BarState.Off)
    .listDirection(Axis.Vertical)
    .edgeEffect(EdgeEffect.None)
    .nestedScroll({ scrollForward: NestedScrollMode.PARALLEL, scrollBackward: NestedScrollMode.PARALLEL })
  }

  @Builder promptCell(item: GoodsInfo) {
    Column() {
      Row() {
        Text(item.contentName)
          .layoutWeight(1)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Image($r('app.media.ic_home_course_cell_more'))
          .width($r('app.string.lpx_50'))
          .height($r('app.string.lpx_50'))
          .borderRadius($r('app.string.lpx_12'))
          .onClick(() => {
            // AdActionUtil.toPage(item)
          })
      }
      .alignItems(VerticalAlign.Center)
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_68'))
      .margin({ top: $r('app.string.lpx_16') })
      .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })

      Text("“万物得其本者生，百事得其道者成。”从一场对话，到一个机制，再到一种精神，中国中亚关系在短短几年间大踏步前行，用这句古语探寻它的历程颇为贴切。\n" +
        "一场对话，举行于2022年1月，中国同中亚五国建交30周年之际。习近平主席在视频峰会上提到要办好中国同中亚五国之间的一系列对话合作机制，新的探索掀开历史一页。\n" +
        "一个机制，建立于2023年5月的西安，首届中国—中亚峰会上，习近平主席同中亚五国元首宣布，正式成立中国—中亚元首会晤机制。\n" +
        "一种精神，就诞生于当下，仲夏时节的哈萨克斯坦阿斯塔纳。今年6月17日，第二届中国—中亚峰会如期举行。")
        .width(Constants.FULL_PARENT)
        .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
        .textAlign(TextAlign.Start)
        .fontColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(24))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Text('2025-06-21 16:45# 99个字/录00:25')
          .layoutWeight(1)
          .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Row() {
            Image($r('app.media.ic_course_try_play'))
              .width($r('app.string.lpx_30'))
              .height($r('app.string.lpx_30'))
              .margin({ left: $r('app.string.lpx_10') })
            Text('开始提词')
              .fontColor($r('app.color.color_0091FF'))
              .fontSize(lpx2fp(24))
              .margin({ left: $r('app.string.lpx_10') })
          }.alignItems(VerticalAlign.Center)
        }
        .backgroundColor($r('app.color.white'))
        .border({
          color: $r('app.color.color_0091FF'),
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_8')
        })
        .padding($r('app.string.lpx_10'))
      }
      .height($r('app.string.lpx_68'))
      .margin({ top: $r('app.string.lpx_16') })
      .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .border({ radius: $r('app.string.lpx_12') })
    .margin({ bottom: $r('app.string.lpx_20') })
    .padding({ bottom: $r('app.string.lpx_16') })
    .alignItems(HorizontalAlign.Start)
  }
}
