/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeTabContent
 * Author: Victor
 * Date: 2023/11/16 16:23
 * Description: 
 * -----------------------------------------------------------------
 */
/*

import Constants from '../../util/Constants'
import { SearchTrendInfo } from '../../bean/SearchTrendInfo'
import RefreshComponent from './refresh/RefreshComponent'
import { AdInfo } from '../../bean/AdInfo'
import { RefreshConfig } from './refresh/RefreshConfig'
import { PageState } from './refresh/PageState'
import { PopularityGroupInfo } from '../../bean/PopularityGroupInfo'
import { GoodsInfo } from '../../bean/GoodsInfo'
import GoodsShowUtil from '../../util/GoodsShowUtil'
import HomeVM from '../../http/vm/HomeVM'
import router from '@ohos.router'
import RouterPath from '../../util/RouterPath'
import ToastUtils from '../../util/ToastUtils'
import App from '../../App'
import AdActionUtil from '../../util/AdActionUtil'
import { TenantInfo } from '../../bean/TenantInfo'
import { LoginData } from '../../bean/LoginData'
import OrganHomeVM from '../../http/vm/OrganHomeVM'
@Preview
@Component
export struct HomeTabContent {
  private TAG = 'HomeTabContent'
  @State hotSearchKeys: Array<SearchTrendInfo> = []
  @State adCategoryList: Array<AdInfo> = []
  @State centerBannerList: Array<AdInfo> = []
  @State tenantHomeList: Array<TenantInfo> = []

  @Link @Watch('refreshData') loginData: LoginData;

  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;
  @Provide(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) listScrollTop : boolean = true;

  @State popularityTabCheckedIndex: number = 0

  @State hScrollTotalOffset: number = 0
  cellWidth: number = 150
  @State scaleCellIndex: number = 0
  @State scaleOpacity: number = 1
  @State cellOpacity: number = 1
  @State translateOpacity: number = 0

  sendSearchTrendRequest () {
    HomeVM.sendSearchTrendRequest(null,{
      onSuccess: (value) => {
        this.pageState = PageState.Success
        var count = value.data.length
        if (count > 0) {
          this.hotSearchKeys = value.data
        }
      },
      onFail: (code,msg) => {
        this.pageState = PageState.Fail
        ToastUtils.show(msg)
      }
    })
  }

  sendCategoryRequest () {
    HomeVM.sendCategoryRequest(null,{
      onSuccess: (value) => {
        this.pageState = PageState.Success
        this.adCategoryList = value.data.adInfoVos
      },
      onFail: (code,msg) => {
        this.pageState = PageState.Fail
        ToastUtils.show(msg)
      }
    })
  }

  sendHomeCenterBannerRequest () {
    HomeVM.sendHomeCenterBannerRequest({
      onSuccess: (value) => {
        this.pageState = PageState.Success
        this.centerBannerList = value.data.adInfoVos
      },
      onFail: (code,msg) => {
        this.pageState = PageState.Fail
        ToastUtils.show(msg)
      }
    })
  }

  sendTenantHomeRequest () {
    OrganHomeVM.sendTenantHomeRequest({
      onSuccess: (value) => {
        this.pageState = PageState.Success
        this.tenantHomeList = value.data
      },
      onFail: (code,msg) => {
        this.pageState = PageState.Fail
        ToastUtils.show(msg)
      }
    })
  }

  sendAllRequest() {
    this.sendSearchTrendRequest()

    this.sendCategoryRequest()
    this.sendHomeCenterBannerRequest()
    this.sendTenantHomeRequest()
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
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  titleBar() {
    Row(){
      Stack() {
        Image($r('app.media.ic_home_search'))
          .width($r('app.float.vp_32'))
          .height($r('app.float.vp_32'))
          .margin({left:$r('app.float.vp_24')})

        Swiper() {
          ForEach(this.hotSearchKeys, item => {
            Text(item.searchValue)
              .width(Constants.FULL_PARENT)
              .height(Constants.FULL_PARENT)
              .fontSize($r('app.float.fp_24'))
              .fontColor($r('app.color.color_999999'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: $r('app.float.vp_72'),right:$r('app.float.vp_28') })
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
        .height($r('app.float.vp_64'))
        .margin({left:$r('app.float.vp_10')})
      }
      .alignContent(Alignment.Start)
      .layoutWeight(1)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .borderRadius($r('app.float.vp_32'))
      .margin({left: $r('app.float.vp_32'),right:$r('app.float.vp_30')})
    }
    .width(Constants.FULL_PARENT)
    .padding({top:$r('app.float.vp_100')})
    .zIndex(1)
  }

  @Builder content() {
    RefreshComponent({
      itemLayout: () => this.itemLayout(),
      onRefresh: () => {
        this.refreshData()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({top: $r('app.float.vp_10')})
      .zIndex(0)
  }

  @Builder itemLayout() {
    List() {
      ListItem() {
        List() {
          ForEach(this.adCategoryList, (item) => {
            ListItem() {
              Column(){
                Image(item.url || $r('app.media.img_placeholder_horizontal'))
                  .width($r('app.float.vp_64'))
                  .height($r('app.float.vp_64'))

                Text(item.adTitle)
                  .width(Constants.FULL_PARENT)
                  .textAlign(TextAlign.Center)
                  .fontColor($r('app.color.color_333333'))
                  .fontSize($r('app.float.fp_24'))
                  .maxLines(1)
                  .textOverflow({overflow: TextOverflow.Ellipsis})
                  .margin({top:$r('app.float.vp_5')})
                  .padding($r('app.float.vp_5'))
              }
              .width($r('app.float.vp_136'))
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
        .listDirection(Axis.Horizontal)
        .height($r('app.float.vp_136'))
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.float.vp_20'))
      }
      .margin({top:$r('app.float.vp_32')})
      .visibility(this.adCategoryList?.length > 0 ? Visibility.Visible: Visibility.None)

      ListItem() {
        this.topCourseAd()
      }
      .margin({top:$r('app.float.vp_32')})

      ListItem() {
        this.centerBanner()
      }
      .margin({top:$r('app.float.vp_32')})
      .visibility(this.centerBannerList?.length > 0 ? Visibility.Visible: Visibility.None)

      ListItem() {
        this.organRecommendTitle()
      }
      .margin({top:$r('app.float.vp_18')})

      ListItem() {
        this.organRecommendContent()
      }
      .margin({top:$r('app.float.vp_24')})

    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .padding({left:$r('app.float.vp_32'),right:$r('app.float.vp_32')})
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      // 监听当前列表首位索引
      this.listScrollTop = start === 0
    })
  }

  @Builder topCourseAd() {
    Row() {
      Column(){
        Row() {
          Column() {
            Text('我的已购')
              .width(Constants.FULL_PARENT)
              .fontSize($r('app.float.fp_32'))
              .fontColor($r('app.color.color_333333'))
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)

            Text('从这里进入学习')
              .width(Constants.FULL_PARENT)
              .fontSize($r('app.float.fp_20'))
              .fontColor($r('app.color.color_999999'))
              .textAlign(TextAlign.Start)
              .margin({top:$r('app.float.vp_10')})
          }
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .padding({left:$r('app.float.vp_32')})

          Image($r('app.media.img_my_purchased'))
            .width($r('app.float.vp_100'))
            .height($r('app.float.vp_100'))
        }
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.float.vp_12'))
      .justifyContent(FlexAlign.Center)
      .padding({right:$r('app.float.vp_24')})
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

      Column(){
        Row() {
          Column() {
            Text('全部课程')
              .width(Constants.FULL_PARENT)
              .fontSize($r('app.float.fp_32'))
              .fontColor($r('app.color.color_333333'))
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)

            Text('选好课 用获课')
              .width(Constants.FULL_PARENT)
              .fontSize($r('app.float.fp_20'))
              .fontColor($r('app.color.color_999999'))
              .textAlign(TextAlign.Start)
              .margin({top:$r('app.float.vp_10')})
          }
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .padding({left:$r('app.float.vp_32')})

          Image($r('app.media.img_all_course'))
            .width($r('app.float.vp_100'))
            .height($r('app.float.vp_100'))
        }
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
      .justifyContent(FlexAlign.Center)
      .borderRadius($r('app.float.vp_12'))
      .margin({left:$r('app.float.vp_30')})
      .padding({right:$r('app.float.vp_24')})
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.COURSE_PAGE
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.float.vp_132'))
  }

  @Builder centerBanner() {
    Swiper() {
      ForEach(this.centerBannerList, item => {
        Image(item.url || $r('app.media.img_placeholder_horizontal'))
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .borderRadius($r('app.float.vp_12'))
          .onClick(() => {
            AdActionUtil.toPage(item)
          })
      })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.float.vp_136'))
    .cachedCount(this.centerBannerList.length)
    .index(0)
    .autoPlay(this.centerBannerList.length > 1)
    .interval(5000)
    .indicator(this.centerBannerList.length > 1)
    .indicatorStyle({
      bottom:0,size: $r('app.float.vp_10'), mask: true,
      color:$r('app.color.color_80FFFFFF'),
      selectedColor:$r('app.color.white')})
    .loop(true)
    .duration(1000)
    .itemSpace(0)
    .curve(Curve.Linear)
  }

  @Builder organRecommendTitle() {
    Row(){
      Text('推荐机构')
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize($r('app.float.fp_36'))
    }
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Center)
    .padding({
      top:$r('app.float.vp_16'),
      bottom:$r('app.float.vp_16')
    })
  }

  @Builder organRecommendContent() {
    List() {
      ForEach(this.tenantHomeList, (item) => {
        ListItem() {
          Row(){
            Image(item.logoUrl || $r('app.media.img_placeholder_horizontal'))
              .width($r('app.float.vp_80'))
              .height($r('app.float.vp_80'))
              .border({radius: $r('app.float.vp_12')})

            Column() {
              Text(item.tenantName || '')
                .width(Constants.FULL_PARENT)
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.color_333333'))
                .fontSize($r('app.float.fp_24'))
                .maxLines(1)
                .textOverflow({overflow: TextOverflow.Ellipsis})

              Blank()

              Text(item.tenantDesc || '')
                .width(Constants.FULL_PARENT)
                .textAlign(TextAlign.Start)
                .fontColor($r('app.color.color_777777'))
                .fontSize($r('app.float.fp_20'))
                .maxLines(1)
                .textOverflow({overflow: TextOverflow.Ellipsis})
                .margin({top: $r('app.float.vp_16')})
            }
            .layoutWeight(1)
            .height($r('app.float.vp_80'))
            .margin({left: $r('app.float.vp_10')})
            .padding({
              top: $r('app.float.vp_8'),
              bottom: $r('app.float.vp_8')
            })
          }
          .width(Constants.FULL_PARENT)
          .backgroundColor($r('app.color.white'))
          .border({radius: $r('app.float.vp_20')})
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.float.vp_32')})
        .padding({
          left: $r('app.float.vp_16'),
          right: $r('app.float.vp_16')
        })
        .onClick(() => {
          App.get().pushUrl({
            url: RouterPath.ORGAN_MAIN_PAGE,
            params: {
              data: item.tenantId
            }
          })
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .lanes(2)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.float.vp_12'))
    .padding({
      bottom:$r('app.float.vp_32'),
      left:$r('app.float.vp_16'),
      right:$r('app.float.vp_16')
    })
  }
}*/
