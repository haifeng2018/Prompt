/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: RefreshLoading
 * Author: Victor
 * Date: 2024/06/27 11:31
 * Description:
 * -----------------------------------------------------------------
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

import { RefreshLayoutPrams } from './RefreshLayoutPrams';
import { RefreshState } from './RefreshState';

@Component
export default struct RefreshLoading {
  @ObjectLink refreshLayoutPrams: RefreshLayoutPrams;

  build() {
    Row() {
      if (this.refreshLayoutPrams.refreshState === RefreshState.Refreshing) {
        LoadingProgress()
          .width($r('app.string.lpx_60'))
          .height($r('app.string.lpx_60'))
      } else {
        Image(this.refreshLayoutPrams.imageSrc)
          .width($r('app.string.lpx_30'))
          .height($r('app.string.lpx_30'))
      }

      Text(this.refreshLayoutPrams.textValue)
        .margin({ left: $r('app.string.lpx_8'), })
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_666666'))
        .textAlign(TextAlign.Center)
    }
    .clip(true)
    .width(Constants.FULL_PARENT)
    .justifyContent(FlexAlign.Center)
    .height(this.refreshLayoutPrams.heightValue)
  }

/*
  getSize (): string {
    let size = this.getOpacity() * 50
    if (size > 50) {
      size = 50
    }
    return `${size}vp`
  }
*/

/*  getOpacity():number {
    if (this.refreshLayoutClass.offsetY > 2*this.refreshLayoutClass.heightValue) {
      let y = this.refreshLayoutClass.offsetY - 2*this.refreshLayoutClass.heightValue
      let opacity = y / this.refreshLayoutClass.heightValue
      if (opacity > 1) {
        opacity = 1
      }
      return opacity
    }
    return 0
  }*/

}