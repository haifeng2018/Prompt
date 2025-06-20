import { touchMoveLoadMore, touchUpLoadMore } from './PullUpLoadMore';
import RefreshConfig from './RefreshConfig';
import { RefreshState } from './RefreshState';

export function listTouchEvent<T>(that: RefreshConfig<T>, event: TouchEvent,onRefresh:() => void,onLoadMore:() => void) {
  switch (event.type) {
    case TouchType.Down:
      that.downY = event.touches[0].y;
      that.lastMoveY = event.touches[0].y;
      break;
    case TouchType.Move:
      if ((that.isRefreshing === true) || (that.isLoading === true)) {
        return;
      }
      let isDownPull = event.touches[0].y - that.lastMoveY > 0;
      if (((isDownPull === true) || (that.isPullRefreshOperation === true)) && (that.isCanLoadMore === false)) {
        // Finger movement, processing pull-down refresh.
        touchMovePullRefresh(that, event);
      } else {
        // Finger movement, processing load more.
        touchMoveLoadMore(that, event);
      }
      that.lastMoveY = event.touches[0].y;
      break;
    case TouchType.Cancel:
      break;
    case TouchType.Up:
      if ((that.isRefreshing === true) || (that.isLoading === true)) {
        return;
      }
      if ((that.isPullRefreshOperation === true)) {
        // Lift your finger and pull down to refresh.
        touchUpPullRefresh(that,onRefresh);
      } else {
        // Fingers up, handle loading more.
        touchUpLoadMore(that,onLoadMore);
      }
      break;
    default:
      break;
  }
}

export function touchMovePullRefresh<T>(that: RefreshConfig<T>, event: TouchEvent) {
  if (that.startIndex === 0) {
    that.isPullRefreshOperation = true;
    let height = vp2px(that.pullDownRefreshHeight);
    that.offsetY = event.touches[0].y - that.downY;
    // The sliding offset is greater than the pull-down refresh layout height, and the refresh condition is met.
    if (that.offsetY >= height) {
      pullRefreshState(that, RefreshState.Release);
      that.offsetY = height + that.offsetY * that.Y_OFF_SET_COEFFICIENT;
    } else {
      pullRefreshState(that, RefreshState.DropDown);
    }
    if (that.offsetY < 0) {
      that.offsetY = 0;
      that.isPullRefreshOperation = false;
    }
  }
}

export function touchUpPullRefresh<T>(that: RefreshConfig<T>,onRefresh:() => void) {
  if (that.isCanRefresh === true) {
    that.offsetY = vp2px(that.pullDownRefreshHeight);
    pullRefreshState(that, RefreshState.Refreshing);
    that.currentPage = 1;
    setTimeout(() => {
      onRefresh()
      closeRefresh(that, true)
    }, that.DELAY_TIME);
  } else {
    closeRefresh(that, false);
  }
}

export function pullRefreshState<T>(that: RefreshConfig<T>, state: number) {
  that.refreshState = state
  switch (state) {
    case RefreshState.DropDown:
      that.pullDownRefreshText = $r('app.string.pull_down_refresh_text');
      that.pullDownRefreshImage = $r("app.media.ic_pull_down_refresh");
      that.isCanRefresh = false;
      that.isRefreshing = false;
      that.isVisiblePullDown = true;
      break;
    case RefreshState.Release:
      that.pullDownRefreshText = $r('app.string.release_refresh_text');
      that.pullDownRefreshImage = $r("app.media.ic_pull_up_refresh");
      that.isCanRefresh = true;
      that.isRefreshing = false;
      break;
    case RefreshState.Refreshing:
      that.offsetY = vp2px(that.pullDownRefreshHeight);
      that.pullDownRefreshText = $r('app.string.refreshing_text');
      that.pullDownRefreshImage = $r("app.media.ic_pull_up_load");
      that.isCanRefresh = true;
      that.isRefreshing = true;
      break;
    case RefreshState.Success:
      that.pullDownRefreshText = $r('app.string.refresh_success_text');
      that.pullDownRefreshImage = $r("app.media.ic_succeed_refresh");
      that.isCanRefresh = true;
      that.isRefreshing = true;
      break;
    case RefreshState.Fail:
      that.pullDownRefreshText = $r('app.string.refresh_fail_text');
      that.pullDownRefreshImage = $r("app.media.ic_fail_refresh");
      that.isCanRefresh = true;
      that.isRefreshing = true;
      break;
    default:
      break;
  }
}

export function closeRefresh<T>(that: RefreshConfig<T>, isRefreshSuccess: boolean) {
  let self = that;
  setTimeout(() => {
    let delay = that.DELAY_PULL_DOWN_REFRESH;
    if (self.isCanRefresh === true) {
      pullRefreshState(that, isRefreshSuccess ? RefreshState.Success : RefreshState.Fail);
      delay = that.DELAY_SHRINK_ANIMATION_TIME;
    }
    animateTo({
      duration: that.CLOSE_PULL_DOWN_REFRESH_TIME,
      delay: delay,
      onFinish: () => {
        pullRefreshState(that, RefreshState.DropDown);
        self.isVisiblePullDown = false;
        self.isPullRefreshOperation = false;
      }
    }, () => {
      self.offsetY = 0;
    })
  }, self.isCanRefresh ? that.DELAY_ANIMATION_DURATION : 0);
}