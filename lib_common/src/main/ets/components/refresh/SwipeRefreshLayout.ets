import RefreshHeader from './RefreshHeader';
import { PageState } from './PageState';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import RefreshLoading from './RefreshLoading';
import { RefreshLayoutPrams } from './RefreshLayoutPrams';
import RefreshConfig from './RefreshConfig';
import { listTouchEvent } from './PullDownRefresh';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { RefreshState } from './RefreshState';

/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LMList
 * Author: Victor
 * Date: 2023/3/17 12:00
 * Description: 
 * -----------------------------------------------------------------
 */

@Component
export default struct SwipeRefreshLayout {
  private TAG = 'SwipeRefreshLayout'
  @Link refreshConfig: RefreshConfig<object>

  @BuilderParam itemLayout: () => void;

  private onRefresh: () => void = () =>{};

  build() {
    Column() {
      if (this.refreshConfig.pageState === PageState.Success) {
        this.contentLayout()
      } else if (this.refreshConfig.pageState === PageState.Loading) {
        this.LoadingLayout()
      } else {
        this.FailLayout()
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .justifyContent(FlexAlign.Center)
    .onTouch((event: TouchEvent | undefined) => {
      if (event) {
        if (this.refreshConfig.pageState === PageState.Success) {
          listTouchEvent(this.refreshConfig, event,
            () => {
              this.onRefresh()
            },
            () => {
            },
          );
        }
      }
    })
  }

  @Builder contentLayout() {
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
        this.itemLayout()
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .cachedCount(Constants.PAGE_SIZE)
    // 去掉回弹效果
    .edgeEffect(EdgeEffect.None)
    .offset({ x: 0, y: `${this.refreshConfig.offsetY < 0 ? 0 : this.refreshConfig.offsetY}px` })
    .onScrollIndex((start: number, end: number) => {
      // Listen to the first index of the current list.
      this.refreshConfig.startIndex = start;
      this.refreshConfig.endIndex = end;
    })
  }

  @Builder LoadingLayout() {
    RefreshLoading({
      refreshLayoutPrams: new RefreshLayoutPrams(
        true,
        $r('app.media.ic_pull_up_load'),
        $r('app.string.pull_up_load_text'),
        this.refreshConfig.pullDownRefreshHeight,
        RefreshState.Refreshing)
    })
  }

  @Builder FailLayout() {
    Image($r('app.media.none'))
      .height($r('app.string.lpx_120'))
      .width($r('app.string.lpx_120'))
      .onClick(() => {
        this.onRefresh()
      })
    Text($r('app.string.page_none_msg'))
      .opacity(0.6)
      .fontSize(lpx2fp(28))
      .fontColor($r('app.color.color_666666'))
      .margin({top: $r('app.string.lpx_20')})
      .onClick(() => {
        this.onRefresh()
      })
  }
}