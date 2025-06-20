/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrganHomeTabContent
 * Author: Victor
 * Date: 2023/11/16 16:23
 * Description: 
 * -----------------------------------------------------------------
 */
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { AdInfo } from 'lib_core_model/src/main/ets/data/AdInfo'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { PopularityGroupInfo } from 'lib_core_model/src/main/ets/data/PopularityGroupInfo'
import { SearchTrendInfo } from 'lib_core_model/src/main/ets/data/SearchTrendInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import HomeVM from 'lib_core_model/src/main/ets/vm/HomeVM'
import OrganHomeVM from 'lib_core_model/src/main/ets/vm/OrganHomeVM'
import AdActionUtil from '../../util/action/AdActionUtil'
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil'
import { router } from '@kit.ArkUI'
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout'
import PayUtil from '../../util/PayUtil'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import { AdData } from 'lib_core_model/src/main/ets/data/AdData'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { HotLiveInfo } from 'lib_core_model/src/main/ets/data/HotLiveInfo'

@Preview
@Component
export struct OrganHomeTabContent {
  private TAG = 'HomeTabContent'
  private tenantId: number = 0
  @State refreshConfig: RefreshConfig<object> = new RefreshConfig<object>()

  @State hotSearchKeys: Array<SearchTrendInfo> = []
  @State adCategoryList: Array<AdInfo> = []
  @State popularityGroupList: Array<PopularityGroupInfo> = []
  @State popularityList: Array<GoodsInfo> = []
  @State youMayLikeList: Array<GoodsInfo> = []
  @State hotLiveList: Array<HotLiveInfo> = []
  @State bannerList: Array<AdInfo> = []

  @Link @Watch('sendAllRequest') loginData: LoginData;

  @State popularityTabCheckedIndex: number = 0

  @State hScrollTotalOffset: number = 0
  cellWidth: number = 160
  @State scaleCellIndex: number = 0
  @State scaleOpacity: number = 1
  @State cellOpacity: number = 1
  @State translateOpacity: number = 0

  @State liveHScrollTotalOffset: number = 0
  liveCellWidth: number = 180
  @State liveScaleCellIndex: number = 0
  @State liveScaleOpacity: number = 1
  @State liveCellOpacity: number = 1
  @State liveTranslateOpacity: number = 0

  private controller: TabsController = new TabsController()

  sendSearchTrendRequest () {
    HomeVM.sendSearchTrendRequest(this.tenantId).then((value: SearchTrendInfo[]) => {
      this.refreshConfig.setRefreshStatus(true)
      const count = value.length
      if (count > 0) {
        this.hotSearchKeys = value
      }
    }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
      ToastUtils.show(err)
    })
  }

  sendCategoryRequest () {
    OrganHomeVM.sendCategoryRequest(this.tenantId).then((data: AdData) => {
      this.adCategoryList = data.adInfoVos || []
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendPopularityGroupRequest () {
    HomeVM.sendPopularityGroupRequest(this.tenantId ?? 0).then((data: PopularityGroupInfo[]) => {
      this.popularityGroupList = data
      const count = this.popularityGroupList.length
      if (count > 0) {
        this.sendPopularityRequest(this.popularityGroupList?.[0].groupingId ?? '')
      }
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendPopularityRequest (groupingId: string) {
    HomeVM.sendPopularityRequest(this.tenantId ?? 0,groupingId,
      1,7).then((value: GoodsInfo[]) => {
      this.popularityList = value
    }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
      ToastUtils.show(err)
    })
  }

  sendTenantAdRequest () {
    OrganHomeVM.sendTenantAdRequest(this.tenantId ?? 0).then((value: AdData) => {
      this.bannerList = value.adInfoVos ?? []
    }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
      ToastUtils.show(err)
    })
  }

  sendFreshnessRequest () {
    HomeVM.sendFreshnessRequest(this.tenantId,1,7).then((value: GoodsInfo[]) => {
      this.youMayLikeList = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendHotLiveRequest () {
    OrganHomeVM.sendHotLiveRequest(this.tenantId).then((value: HotLiveInfo[]) => {
      this.hotLiveList = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendAllRequest() {
    this.sendSearchTrendRequest()
    this.sendCategoryRequest()
    this.sendPopularityGroupRequest()
    this.sendTenantAdRequest()
    this.sendFreshnessRequest()
    // this.sendHotLiveRequest()
  }

  aboutToAppear() {
    this.refreshData()
  }

  refreshData () {
    this.sendAllRequest()
  }

  loadMoreData () {
  }

  build() {
    Column() {
      this.titleBar()
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .linearGradient({
      angle: 180,
      colors: [
        [$r('app.color.color_F7E8EB'),0.0],
        [$r('app.color.color_F8EEF6'),0.26],
        [$r('app.color.color_F8F9FD'),1.0]
      ]
    })
  }

  @Builder
  titleBar() {
    Row(){
      Image($r('app.media.ic_back'))
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
        .objectFit(ImageFit.Contain)
        .margin({left:$r('app.string.lpx_32')})
        .onClick(() =>{
          App.get().back()
        })
      Stack() {
        Image($r('app.media.ic_home_search'))
          .width($r('app.string.lpx_32'))
          .height($r('app.string.lpx_32'))
          .margin({left:$r('app.string.lpx_24')})

        Swiper() {
          ForEach(this.hotSearchKeys, (item: SearchTrendInfo) => {
            Text(item.searchValue)
              .width(Constants.FULL_PARENT)
              .height(Constants.FULL_PARENT)
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_999999'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: $r('app.string.lpx_72'),right:$r('app.string.lpx_28') })
              .onClick(() => {
                App.get().pushUrl({
                  url: RouterPath.SEARCH_PAGE,
                  params: {
                    data: item.searchValue,
                  },
                })
              })
          })
        }
        .vertical(true)
        .autoPlay(true)
        .indicator(false)
        .interval(3000)
        .height($r('app.string.lpx_64'))
        .margin({left:$r('app.string.lpx_10')})
      }
      .alignContent(Alignment.Start)
      .layoutWeight(1)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .borderRadius($r('app.string.lpx_32'))
      .margin({left: $r('app.string.lpx_20'),right:$r('app.string.lpx_32')})
    }
    .width(Constants.FULL_PARENT)
    .padding({top:$r('app.string.lpx_100')})
    .zIndex(1)
  }

  @Builder content() {
    SwipeRefreshLayout({
      refreshConfig: this.refreshConfig,
      itemLayout: (): void => this.itemLayout(),
      onRefresh: () => {
        this.refreshData()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({top: $r('app.string.lpx_10')})
      .padding({bottom: $r('app.string.lpx_20')})
  }

  @Builder itemLayout() {
    List() {
      ListItem() {
        List() {
          ForEach(this.adCategoryList, (item: AdInfo) => {
            ListItem() {
              Column(){
                Image(item.url || $r('app.media.img_placeholder_horizontal'))
                  .width($r('app.string.lpx_64'))
                  .height($r('app.string.lpx_64'))

                Text(item.adTitle)
                  .width(Constants.FULL_PARENT)
                  .textAlign(TextAlign.Center)
                  .fontColor($r('app.color.color_333333'))
                  .fontSize(lpx2fp(24))
                  .maxLines(1)
                  .textOverflow({overflow: TextOverflow.Ellipsis})
                  .margin({top:$r('app.string.lpx_5')})
                  .padding($r('app.string.lpx_5'))
              }
              .width($r('app.string.lpx_136'))
              .height(Constants.FULL_PARENT)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => {
                AdActionUtil.toPage(item)
              })
            }
            .width('20%')
            .height(Constants.FULL_PARENT)
          })
        }
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_136'))
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_20'))
      }
      .margin({top:$r('app.string.lpx_22')})
      .visibility(this.adCategoryList?.length > 0 ? Visibility.Visible: Visibility.None)

      ListItem() {
        this.topCourseAd()
      }
      .margin({top:$r('app.string.lpx_32')})

      ListItem() {
        this.hotLiveTitle()
      }
      .margin({top:$r('app.string.lpx_38')})
      .visibility(this.hotLiveList?.length > 0 ? Visibility.Visible: Visibility.None)

      ListItem() {
        this.hotLiveContent()
      }
      .margin({top:$r('app.string.lpx_32')})
      .visibility(this.hotLiveList?.length > 0 ? Visibility.Visible: Visibility.None)

      ListItem() {
        this.banner()
      }
      .margin({top:$r('app.string.lpx_24')})
      .visibility(this.bannerList?.length > 0 ? Visibility.Visible: Visibility.None)

      ListItem() {
        this.recommendTitle()
      }
      .margin({top:$r('app.string.lpx_38')})
      .visibility(this.popularityGroupList?.length > 0 ? Visibility.Visible: Visibility.None)

      ListItem() {
        this.popularityGroup()
      }
      .margin({top:$r('app.string.lpx_16')})
      .visibility(this.popularityGroupList?.length > 0 ? Visibility.Visible: Visibility.None)

      ForEach(this.popularityList, (item: GoodsInfo) => {
        ListItem() {
          this.popularityCell(item)
        }
        .width(Constants.FULL_PARENT)
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_20'))
        .margin({bottom: $r('app.string.lpx_8')})
        .padding({
          top: $r('app.string.lpx_24'),
          bottom: $r('app.string.lpx_24'),
          left: $r('app.string.lpx_16'),
          right: $r('app.string.lpx_16'),
        })
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.tenantId ?? 0,item.onlineFlag,item.goodsId,0)
        })
      })

      ListItem() {
        this.youManLikeTitle()
      }
      .margin({top:$r('app.string.lpx_38')})
      .visibility(this.youMayLikeList?.length > 0 ? Visibility.Visible: Visibility.None)

      ListItem() {
        this.youManLikeContent()
      }
      .margin({top:$r('app.string.lpx_32')})
      .visibility(this.youMayLikeList?.length > 0 ? Visibility.Visible: Visibility.None)
    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .padding({
      left:$r('app.string.lpx_32'),
      right:$r('app.string.lpx_32')})
    .edgeEffect(EdgeEffect.None)
  }

  @Builder topCourseAd() {
    Column() {
      Text('我的已购')
        .width(Constants.FULL_PARENT)
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)

      Text('从这里进入学习')
        .width(Constants.FULL_PARENT)
        .fontSize(lpx2fp(20))
        .fontColor($r('app.color.color_999999'))
        .textAlign(TextAlign.Start)
        .margin({top:$r('app.string.lpx_10')})
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_144'))
    .justifyContent(FlexAlign.Center)
    .backgroundImage($r('app.media.img_organ_purchased'))
    .backgroundImageSize(ImageSize.Cover)
    .padding({left: $r('app.string.lpx_40')})
    .onClick(() => {
      if (this.loginData) {
        App.get().pushUrl({
          url: RouterPath.PURCHASED_COURSE_PAGE
        })
      } else {
        App.get().pushUrl({
          url: RouterPath.CODE_LOGIN_PAGE
        },router.RouterMode.Single)
      }
    })
  }

  @Builder hotLiveTitle() {
    Row(){
      Text('热门直播')
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))

      Text('查看全部')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))

      Image($r('app.media.ic_home_course_more'))
        .width($r('app.string.lpx_20'))
        .height($r('app.string.lpx_20'))
        .margin({left:$r('app.string.lpx_8')})
    }
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Center)
    .padding({
      top:$r('app.string.lpx_16'),
      bottom:$r('app.string.lpx_16')
    })
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.HOT_LIVE_MORE_PAGE
      })
    })
  }

  @Builder hotLiveContent() {
    List() {
      ForEach(this.hotLiveList, (item: GoodsInfo,index: number) => {
        ListItem() {
          Column(){
            Stack() {
              Image(item.coverVerticalUrl || $r('app.media.img_placeholder_horizontal'))
                .width(Constants.FULL_PARENT)
                .height(Constants.FULL_PARENT)
                .borderRadius({topLeft: $r('app.string.lpx_12'),topRight: $r('app.string.lpx_12')})
            }
            .width(Constants.FULL_PARENT)
            .height($r('app.string.lpx_186'))

            Text(item?.contentName || '')
              .width(Constants.FULL_PARENT)
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
              .fontWeight(FontWeight.Bold)
              .maxLines(2)
              .textOverflow({overflow: TextOverflow.Ellipsis})
              .margin({top: $r('app.string.lpx_16')})
              .padding({left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16')})

            Blank()

            Text(`讲师：${GoodsShowUtil.getFirstLecturerName(item.lecturers)}`)
              .width(Constants.FULL_PARENT)
              .fontColor($r('app.color.color_777777'))
              .fontSize(lpx2fp(24))
              .maxLines(1)
              .textOverflow({overflow: TextOverflow.Ellipsis})
              .padding({left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16')})
          }
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .padding({bottom: $r('app.string.lpx_16')})
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
        }
        .width($r('app.string.lpx_330'))
        .height(Constants.FULL_PARENT)
        .scale({x: index === this.liveScaleCellIndex ? this.liveScaleOpacity : 1,y: index === this.liveScaleCellIndex ? this.liveScaleOpacity : 1})
        .opacity(index === this.liveScaleCellIndex ? this.liveScaleOpacity : 1)
        .translate({x: index === this.liveScaleCellIndex ? this.liveTranslateOpacity * this.liveCellWidth : 0})
        .margin({right: $r('app.string.lpx_20')})
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_12'))
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0,item.onlineFlag,item.goodsId,0)
        })
      })
    }
    .listDirection(Axis.Horizontal)
    .height($r('app.string.lpx_340'))
    .onReachStart(() => {
      Logger.error(this.TAG,'onReachStart()......')
    })
    .onReachEnd(() => {
      Logger.error(this.TAG,'onReachEnd()......')
    })
    .onScrollIndex((start,end) => {
      Logger.error(this.TAG,'onScrollIndex-start = '+ start)
      Logger.error(this.TAG,'onScrollIndex-end = '+ end)
    })
    .onScrollStart(() => {

    })
    .onScrollStop(() => {

    })
    .onScroll((scrollOffset: number, scrollState: ScrollState) => {
      this.liveHScrollTotalOffset += scrollOffset
      this.liveScaleCellIndex = Math.floor(this.liveHScrollTotalOffset / this.liveCellWidth)

      let cellOffset = this.liveHScrollTotalOffset - this.liveScaleCellIndex * this.liveCellWidth
      let rate = cellOffset / this.liveCellWidth
      this.liveScaleOpacity = 1 - rate * rate / 3
      this.liveCellOpacity = 1 - rate * rate
      this.liveTranslateOpacity = rate * 10 / 9
    })
  }

  @Builder banner() {
    Swiper() {
      ForEach(this.bannerList, (item: AdInfo) => {
        Image(item.url || $r('app.media.img_placeholder_horizontal'))
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .borderRadius($r('app.string.lpx_12'))
          .onClick(() => {
            AdActionUtil.toPage(item)
          })
      })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_180'))
    .cachedCount(this.bannerList.length)
    .index(0)
    .autoPlay(this.bannerList.length > 1)
    .interval(5000)
    .indicator(this.bannerList.length > 1)
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

  @Builder recommendTitle() {
    Row(){
      Text('爆款推荐')
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))

      Text('查看全部')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))

      Image($r('app.media.ic_home_course_more'))
        .width($r('app.string.lpx_20'))
        .height($r('app.string.lpx_20'))
        .margin({left:$r('app.string.lpx_8')})
    }
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Center)
    .padding({
      top:$r('app.string.lpx_16'),
      bottom:$r('app.string.lpx_16')
    })
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.HOME_RECOMMEND_MORE_PAGE,
        params: {
          data: this.tenantId
        }
      })
    })
  }

  @Builder popularityGroup() {
    Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
      ForEach(this.popularityGroupList, (item: PopularityGroupInfo,index: number) => {
        TabContent() {
        }
        .height(0)
        .tabBar(this.TabBuilder(index,index === this.popularityGroupList.length - 1, item.groupingName ?? ''))
        .align(Alignment.Top)
        .margin({top: $r('app.string.lpx_16')})
      })
    }
    .vertical(false)
    .barMode(BarMode.Scrollable)
    .barWidth(Constants.FULL_PARENT)
    .barHeight($r('app.string.lpx_74'))
    .onChange((index: number) => {
      let count = this.popularityGroupList.length
      if (count > 0 && index < count) {
        this.sendPopularityRequest(this.popularityGroupList[index].groupingId ?? '')
      }
      this.popularityTabCheckedIndex = index
    })
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_74'))
  }

  @Builder popularityCell(item: GoodsInfo) {
    Row(){
      Image(item?.coverUrlExtendVo?.centre || $r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_180'))
        .height($r('app.string.lpx_180'))
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

        Text(item.columnContent)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .margin({top: $r('app.string.lpx_16')})

        Blank()

        Row() {
          Text(GoodsShowUtil.getCourseType(item.goodsType,item.onlineFlag))
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(20))
            .backgroundColor($r('app.color.color_FFEEED'))
            .border({
              radius: $r('app.string.lpx_8'),
              color: $r('app.color.color_F2382B'),
              width: $r('app.string.lpx_1')
            })
            .padding({
              top: $r('app.string.lpx_4'),
              bottom: $r('app.string.lpx_4'),
              left: $r('app.string.lpx_8'),
              right: $r('app.string.lpx_8'),
            })

          Text(`${item.classHour}节`)
            .fontColor($r('app.color.color_666666'))
            .fontSize(lpx2fp(20))
            .margin({left: $r('app.string.lpx_16')})

          Blank()

          Image($r('app.media.ic_play_count_grey'))
            .width($r('app.string.lpx_12'))
            .height($r('app.string.lpx_15'))

          Text(GoodsShowUtil.getGoodsPopularityTxt(item.goodsPopularity ?? 0))
            .fontSize(lpx2fp(22))
            .fontColor($r('app.color.color_999999'))
            .margin({left: $r('app.string.lpx_10')})

        }
        .width(Constants.FULL_PARENT)
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .margin({left: $r('app.string.lpx_24')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .border({radius: $r('app.string.lpx_20')})
  }

  @Builder TabBuilder(index: number,isLastItem: boolean, name: string) {
    Row(){
      Column() {
        Text(name)
          .layoutWeight(1)
          .fontColor($r('app.color.color_333333'))
          .fontSize(this.popularityTabCheckedIndex === index ? lpx2fp(28) : lpx2fp(26))
          .fontWeight(this.popularityTabCheckedIndex === index ? FontWeight.Bold : FontWeight.Normal)
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})

        Image($r('app.media.ic_tab_indicator'))
          .height($r('app.string.lpx_10'))
          .opacity(this.popularityTabCheckedIndex === index ? 1 : 0)
      }
      .width($r('app.string.lpx_150'))
      .justifyContent(FlexAlign.Center)

      Divider()
        .vertical(true)
        .color($r('app.color.color_D9D9D9'))
        .strokeWidth(`${$r('app.string.lpx_2')}`)
        .height($r('app.string.lpx_30'))
        .margin({bottom: $r('app.string.lpx_10')})
        .opacity(isLastItem ? 0 : 1)
    }
    .height(Constants.FULL_PARENT)
    .padding({
      top:$r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
    })
  }

  @Builder youManLikeTitle() {
    Row(){
      Text('猜你喜欢')
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))

      Text('查看全部')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))

      Image($r('app.media.ic_home_course_more'))
        .width($r('app.string.lpx_20'))
        .height($r('app.string.lpx_20'))
        .margin({left:$r('app.string.lpx_8')})
    }
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Center)
    .padding({
      top:$r('app.string.lpx_16'),
      bottom:$r('app.string.lpx_16')
    })
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.YOU_MAY_LIKE_MORE_PAGE,
        params: {
          tenantId: this.tenantId
        }
      })
    })
  }

  @Builder youManLikeContent() {
    List() {
      ForEach(this.youMayLikeList, (item: GoodsInfo,index: number) => {
        ListItem() {
          Column(){
            Image(item.coverVerticalUrl || $r('app.media.img_placeholder_horizontal'))
              .width(Constants.FULL_PARENT)
              .height($r('app.string.lpx_288'))
              .borderRadius({topLeft: $r('app.string.lpx_12'),topRight: $r('app.string.lpx_12')})

            Row() {
              Text('￥')
                .fontColor($r('app.color.color_EB4F3A'))
                .fontSize(lpx2fp(20))

              Text(AmountUtil.getRoundUp((item.salePrice ?? 0) / 100,2))
                .layoutWeight(1)
                .fontColor($r('app.color.color_EB4F3A'))
                .fontSize(lpx2fp(28))
                .margin({left: $r('app.string.lpx_8')})

              Image($r('app.media.ic_home_course_cell_more'))
                .width($r('app.string.lpx_50'))
                .height($r('app.string.lpx_36'))
            }
            .layoutWeight(1)
            .padding({left: $r('app.string.lpx_24'), right: $r('app.string.lpx_24')})
          }
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
        .width($r('app.string.lpx_288'))
        .height(Constants.FULL_PARENT)
        .scale({x: index === this.scaleCellIndex ? this.scaleOpacity : 1,y: index === this.scaleCellIndex ? this.scaleOpacity : 1})
        .opacity(index === this.scaleCellIndex ? this.scaleOpacity : 1)
        .translate({x: index === this.scaleCellIndex ? this.translateOpacity * this.cellWidth : 0})
        .margin({right: $r('app.string.lpx_32')})
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_12'))
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(this.tenantId ?? 0,item.onlineFlag,item.goodsId,0)
        })
      })
    }
    .listDirection(Axis.Horizontal)
    .height($r('app.string.lpx_368'))
    .onReachStart(() => {
      Logger.error(this.TAG,'onReachStart()......')
    })
    .onReachEnd(() => {
      Logger.error(this.TAG,'onReachEnd()......')
    })
    .onScrollIndex((start,end) => {
      Logger.error(this.TAG,'onScrollIndex-start = '+ start)
      Logger.error(this.TAG,'onScrollIndex-end = '+ end)
    })
    .onScrollStart(() => {

    })
    .onScrollStop(() => {

    })
    .onScroll((scrollOffset: number, scrollState: ScrollState) => {
      this.hScrollTotalOffset += scrollOffset
      this.scaleCellIndex = Math.floor(this.hScrollTotalOffset / this.cellWidth)

      let cellOffset = this.hScrollTotalOffset - this.scaleCellIndex * this.cellWidth
      let rate = cellOffset / this.cellWidth
      this.scaleOpacity = 1 - rate * rate / 3
      this.cellOpacity = 1 - rate * rate
      this.translateOpacity = rate * 10 / 9
    })
  }
}
