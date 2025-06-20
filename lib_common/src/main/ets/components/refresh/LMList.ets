import LoadMoreLayout from './LoadMoreLayout';
import RefreshHeader from './RefreshHeader';
import { PageState } from './PageState';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import LoadEndLayout from './LoadEndLayout';
import RefreshLoading from './RefreshLoading';
import { RefreshLayoutPrams } from './RefreshLayoutPrams';
import RefreshConfig from './RefreshConfig';
import { listTouchEvent } from './PullDownRefresh';
import EmptyLayout from './EmptyLayout';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { RefreshState } from './RefreshState';
import LoadFailedLayout from './LoadFailedLayout';

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
export default struct LMList {
  private TAG = 'LMList'
  private showScrollBar: boolean = false
  @Link refreshConfig: RefreshConfig<object>

  @BuilderParam itemLayout: (data:object,index: number) => void;
  @BuilderParam emptyLayout: () => void;
  @BuilderParam loadEndLayout: () => void;

  private onRefresh: () => void = () =>{};
  private onLoadMore: () => void = () =>{};

  build() {
    Column() {
      if (this.refreshConfig.pageState === PageState.Success) {
        this.ListLayout()
      } else if (this.refreshConfig.pageState === PageState.Loading) {
        this.LoadingLayout()
      } else {
        LoadFailedLayout({
          onRetry: () => {
            this.refreshConfig.pageState === PageState.Loading
            this.onRefresh()
          }
        })
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
              this.onLoadMore()
            },
          );
        }
      }
    })
  }

  @Builder ListLayout() {
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

      ForEach(this.refreshConfig.data, (item: object, index: number) => {
        ListItem() {
          this.itemLayout(item, index)
        }
      }, (item: string, index?: number) => JSON.stringify(item) + index)

      if (this.refreshConfig.data.length > 0) {
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
            if (this.loadEndLayout != null) {
              this.loadEndLayout()
            } else {
              LoadEndLayout()
            }
          }
        }
      } else {
        if (this.emptyLayout != null) {
          this.emptyLayout()
        } else {
          EmptyLayout()
        }
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .cachedCount(Constants.PAGE_SIZE)
    .scrollBar(this.showScrollBar ? BarState.Auto : BarState.Off)
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
}