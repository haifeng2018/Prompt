/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: RefreshConstant
 * Author: Victor
 * Date: 2023/3/17 15:27
 * Description: 
 * -----------------------------------------------------------------
 */

import { PageState } from './PageState';

export default class RefreshConfig<T> {

  PAGE_SIZE: number = 20;
  Y_OFF_SET_COEFFICIENT: number = 0.1;
  DELAY_TIME: number = 1000
  DELAY_PULL_DOWN_REFRESH: number = 50
  DELAY_SHRINK_ANIMATION_TIME: number = 500
  CLOSE_PULL_DOWN_REFRESH_TIME: number = 150
  DELAY_ANIMATION_DURATION: number = 300
  ANIMATION_DURATION: number = 2000

  pullDownRefreshText: Resource = $r('app.string.pull_down_refresh_text');
  pullDownRefreshImage: Resource = $r('app.media.ic_pull_down_refresh');
  pullDownRefreshHeight: number = 70
  isVisiblePullDown: boolean = false;
  pullUpLoadText: Resource = $r('app.string.pull_up_load_text');
  pullUpLoadImage: Resource = $r('app.media.ic_pull_up_load');
  pullUpLoadHeight: number = 70
  isVisiblePullUpLoad: boolean = false;
  offsetY: number = 0;
  pageState: number = PageState.Loading;
  refreshState?: number | null;
  otherCount: number = 0;//加载数据之外数据个数
  data:Array<T> = []
  hasMore: boolean = true;
  startIndex = 0;
  endIndex = 0;
  downY = 0;
  lastMoveY = 0;
  isRefreshing: boolean = false;
  isCanRefresh = false;
  isPullRefreshOperation = false;
  isLoading: boolean = false;
  isCanLoadMore: boolean = false;
  currentPage: number = 1;

  setData(data:Array<T>,isSuccess: boolean) {
    if (isSuccess) {
      this.pageState = PageState.Success;

      if (this.currentPage === 1) {
        this.data = data || []
      } else {
        this.data = this.data.concat(data || [])
      }
      this.hasMore = data.length >= this.PAGE_SIZE
    } else {
      this.pageState = PageState.Fail;
    }
  }

  setAllData(data:Array<T>,isSuccess: boolean,otherCount:number) {
    this.otherCount = otherCount
    this.setData(data,isSuccess)
  }

  setRefreshStatus(isSuccess: boolean) {
    this.setData([],isSuccess)
  }
}
