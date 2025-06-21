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

  @Builder
  titleBar() {
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
          List() {
            ForEach(this.adCategoryList, (item: AdInfo) => {
              ListItem() {
                Column() {
                  Image(item.url)
                    .alt($r('app.media.img_placeholder_horizontal'))
                    .width($r('app.string.lpx_64'))
                    .height($r('app.string.lpx_64'))

                  Text(item.adTitle)
                    .width(Constants.FULL_PARENT)
                    .textAlign(TextAlign.Center)
                    .fontColor($r('app.color.color_333333'))
                    .fontSize(lpx2fp(24))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ top: $r('app.string.lpx_5') })
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
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
          .height($r('app.string.lpx_136'))
          .backgroundColor($r('app.color.white'))
          .borderRadius($r('app.string.lpx_20'))
        }
        .margin({
          top: $r('app.string.lpx_32'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })
        .visibility((this.adCategoryList?.length ?? 0) > 0 ? Visibility.Visible : Visibility.None)

        ListItem() {
          this.topCourseAd()
        }
        .margin({
          top:
          $r('app.string.lpx_32'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })

        ListItem() {
          this.recommendTitle()
        }
        .margin({
          top: $r('app.string.lpx_38'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })

        ListItem() {
          this.homeLevel()
        }
        .margin({
          top: $r('app.string.lpx_16'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })

        ListItem() {
          this.homeLevelCourse()
        }
        .margin({
          top: $r('app.string.lpx_16'),
          left: $r('app.string.lpx_22'),
          right: $r('app.string.lpx_22')
        })

        ListItem() {
          this.banner()
        }
        .margin({
          top: $r('app.string.lpx_32'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })

        ListItem() {
          this.youMayLikeTitle()
        }
        .margin({
          top: $r('app.string.lpx_16'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })

        ListItem() {
          this.youMayLikeCourse()
        }
        .margin({
          top: $r('app.string.lpx_16'),
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

  @Builder
  itemLayout() {
    List() {
      ListItem() {
        List() {
          ForEach(this.adCategoryList, (item: AdInfo) => {
            ListItem() {
              Column() {
                Image(item.url)
                  .alt($r('app.media.img_placeholder_horizontal'))
                  .width($r('app.string.lpx_64'))
                  .height($r('app.string.lpx_64'))

                Text(item.adTitle)
                  .width(Constants.FULL_PARENT)
                  .textAlign(TextAlign.Center)
                  .fontColor($r('app.color.color_333333'))
                  .fontSize(lpx2fp(24))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: $r('app.string.lpx_5') })
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
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .height($r('app.string.lpx_136'))
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_20'))
      }
      .margin({
        top: $r('app.string.lpx_32'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')
      })
      .visibility((this.adCategoryList?.length ?? 0) > 0 ? Visibility.Visible : Visibility.None)

      ListItem() {
        this.topCourseAd()
      }
      .margin({
        top: $r('app.string.lpx_32'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')
      })

      ListItem() {
        this.recommendTitle()
      }
      .margin({
        top: $r('app.string.lpx_38'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')
      })

      ListItem() {
        this.homeLevel()
      }
      .margin({
        top: $r('app.string.lpx_16'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')
      })

      ListItem() {
        this.homeLevelCourse()
      }
      .margin({
        top: $r('app.string.lpx_16'),
        left: $r('app.string.lpx_22'),
        right: $r('app.string.lpx_22')
      })

      ListItem() {
        this.banner()
      }
      .margin({
        top: $r('app.string.lpx_32'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')
      })

      ListItem() {
        this.youMayLikeTitle()
      }
      .margin({
        top: $r('app.string.lpx_38'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')
      })

      ListItem() {
        this.youMayLikeCourse()
      }
      .margin({
        top: $r('app.string.lpx_16'),
        left: $r('app.string.lpx_22'),
        right: $r('app.string.lpx_22')
      })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .edgeEffect(EdgeEffect.None)
  }

  @Builder
  topCourseAd() {
    Row() {
      Column() {
        Row() {
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
              .margin({ top: $r('app.string.lpx_10') })
          }
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .padding({ left: $r('app.string.lpx_32') })

          Image($r('app.media.img_my_purchased'))
            .width($r('app.string.lpx_100'))
            .height($r('app.string.lpx_100'))
        }
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_12'))
      .justifyContent(FlexAlign.Center)
      .padding({ right: $r('app.string.lpx_24') })
      .onClick(() => {
        if (this.loginData) {
          App.get().pushUrl({
            url: RouterPath.PURCHASED_COURSE_PAGE
          })
        } else {
          App.get().pushUrl({
            url: RouterPath.CODE_LOGIN_PAGE
          }, router.RouterMode.Single)
        }
      })

      Column() {
        Row() {
          Column() {
            Text('全部课程')
              .width(Constants.FULL_PARENT)
              .fontSize(lpx2fp(32))
              .fontColor($r('app.color.color_333333'))
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)

            Text('选好课 用获课')
              .width(Constants.FULL_PARENT)
              .fontSize(lpx2fp(20))
              .fontColor($r('app.color.color_999999'))
              .textAlign(TextAlign.Start)
              .margin({ top: $r('app.string.lpx_10') })
          }
          .layoutWeight(1)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .padding({ left: $r('app.string.lpx_32') })

          Image($r('app.media.img_all_course'))
            .width($r('app.string.lpx_100'))
            .height($r('app.string.lpx_100'))
        }
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_12'))
      .justifyContent(FlexAlign.Center)
      .margin({ left: $r('app.string.lpx_30') })
      .padding({ right: $r('app.string.lpx_24') })
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.COURSE_CATEGORY_PAGE
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_132'))
  }

  @Builder
  recommendTitle() {
    Row() {
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
        .margin({ left: $r('app.string.lpx_8') })
    }
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Center)
    .padding({
      top: $r('app.string.lpx_16'),
      bottom: $r('app.string.lpx_16')
    })
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.HOME_RECOMMEND_MORE_PAGE,
        params: {
          data: 1000
        }
      })
    })
  }

  @Builder
  homeLevel() {
    List() {
      ForEach(this.homeLevelList?.[0]?.childs, (item: HomeLevelInfo, index: number) => {
        ListItem() {
          this.homeLevelCell(item, index)
        }
        .height(Constants.FULL_PARENT)
      })
    }
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
    .height($r('app.string.lpx_80'))
  }

  @Builder
  homeLevelCell(item: HomeLevelInfo, index: number) {
    Row() {
      Column() {
        Text(item?.levelName ?? '')
          .layoutWeight(1)
          .fontColor($r('app.color.color_333333'))
          .fontSize(this.popularityTabCheckedIndex === index ? lpx2fp(28) : lpx2fp(26))
          .fontWeight(this.popularityTabCheckedIndex === index ? FontWeight.Bold : FontWeight.Normal)

        Image($r('app.media.ic_tab_indicator'))
          .height($r('app.string.lpx_10'))
          .opacity(this.popularityTabCheckedIndex === index ? 1 : 0)
      }
      .justifyContent(FlexAlign.Center)
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })

      Divider()
        .vertical(true)
        .color($r('app.color.color_D9D9D9'))
        .strokeWidth(`${$r('app.string.lpx_2')}`)
        .height($r('app.string.lpx_30'))
        .margin({ bottom: $r('app.string.lpx_10') })
        .opacity(index === (this.homeLevelList?.[0]?.childs?.length ?? 0) - 1 ? 0 : 1)
    }
    .height(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
    })
    .onClick(() => {
      this.popularityTabCheckedIndex = index
      this.sendHomeLevelCourseRequest(item?.id ?? '')
    })
  }

  @Builder
  homeLevelCourse() {
    List() {
      ForEach(this.homeLevelCourseList, (item: GoodsInfo) => {
        ListItem() {
          this.homeLevelCourseCell(item)
        }
        .width(Constants.FULL_PARENT)
        .padding({ left: $r('app.string.lpx_10'), right: $r('app.string.lpx_10') })
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0, item.onlineFlag, item.goodsId)
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .edgeEffect(EdgeEffect.None)
    .lanes(2)
  }

  @Builder
  homeLevelCourseCell(item: GoodsInfo) {
    Column() {
      Image(item?.coverUrlExtendVo?.centre)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_332'))
        .border({ radius: $r('app.string.lpx_12') })

      Text(item.contentName)
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_90'))
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .margin({ top: $r('app.string.lpx_16') })
        .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        CoursePriceLineStyleDisplayComp({
          goodsInfo: item
        })

        Blank()

        Text(GoodsShowUtil.getSaleCountText(item.salesVolume ?? 0))
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })

      TenantDisplayComp({ courseTenantInfo: item.tenantVO })
        .margin($r('app.string.lpx_16'))
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .border({ radius: $r('app.string.lpx_12') })
    .margin({ bottom: $r('app.string.lpx_16') })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  banner() {
    Swiper() {
      ForEach(this.bannerList, (item: AdInfo) => {
        Image(item.url)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .borderRadius($r('app.string.lpx_12'))
          .onClick(() => {
            AdActionUtil.toPage(item)
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

  @Builder
  youMayLikeTitle() {
    Row() {
      Text('猜你喜欢')
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
    }
    .width(Constants.FULL_PARENT)
    .alignItems(VerticalAlign.Center)
    .padding({
      top: $r('app.string.lpx_16'),
      bottom: $r('app.string.lpx_16')
    })
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.HOME_RECOMMEND_MORE_PAGE
      })
    })
  }

  @Builder
  youMayLikeCourse() {
    List() {
      ForEach(this.refreshConfig.data, (item: GoodsInfo) => {
        ListItem() {
          this.youMayLikeCourseCell(item)
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
    .lanes(2)
  }

  @Builder
  youMayLikeCourseCell(item: GoodsInfo) {
    Column() {
      Image(item?.coverVerticalUrl)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_332'))
        .border({ radius: $r('app.string.lpx_12') })

      Row() {
        Text(item.contentName)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(VerticalAlign.Top)
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_90'))
      .margin({ top: $r('app.string.lpx_16') })
      .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })

      Row() {
        CoursePriceLineStyleDisplayComp({
          goodsInfo: item
        })
      }
      .width(Constants.FULL_PARENT)
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
