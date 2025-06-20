import Logger from 'lib_core_model/src/main/ets/util/Logger';
import RefreshConfig from './RefreshConfig';
import { ifaa } from '@kit.OnlineAuthenticationKit';

export function touchMoveLoadMore<T>(that: RefreshConfig<T>, event: TouchEvent) {
  let total = that.data.length//处理自定义情况list之外数据个数
  if (that.otherCount > 0) {
    total = that.otherCount + 1
    //list被嵌套到其他list面总个数=外部list其他item 数量 + 1（内部list）
  }
  //9-(8+3 = 11)-8
  Logger.error('touchMoveLoadMore',`touchMoveLoadMore....... = ${that.endIndex}-${total}`)
  if (that.endIndex === total - 1 || that.endIndex === total) {
    that.offsetY = event.touches[0].y - that.downY;
    if (Math.abs(that.offsetY) > vp2px(that.pullUpLoadHeight) / 2) {
      that.isCanLoadMore = true;
      that.isVisiblePullUpLoad = true;
      that.offsetY = -vp2px(that.pullUpLoadHeight) + that.offsetY * that.Y_OFF_SET_COEFFICIENT;
    }
  } else {
    Logger.error('touchMoveLoadMore','touchMoveLoadMore.......false')
  }
}

export function touchUpLoadMore<T>(that: RefreshConfig<T>,onLoadMore:() => void) {
  let self = that;
  animateTo({
    duration: that.ANIMATION_DURATION,
  }, () => {
    self.offsetY = 0;
  })
  if ((self.isCanLoadMore === true) && (self.hasMore === true)) {
    self.isLoading = true;
    self.currentPage++;
    setTimeout(() => {
      closeLoadMore(that);
      onLoadMore()
    }, that.DELAY_TIME);
  } else {
    closeLoadMore(self);
  }
}

export function closeLoadMore<T>(that: RefreshConfig<T>) {
  that.isCanLoadMore = false;
  that.isLoading = false;
  that.isVisiblePullUpLoad = false;
}