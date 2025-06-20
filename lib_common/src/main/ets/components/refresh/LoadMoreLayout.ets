/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LoadMoreLayout
 * Author: Victor
 * Date: 2023/3/17 15:27
 * Description:
 * -----------------------------------------------------------------
 */
import RefreshHeader from './RefreshHeader'
import { RefreshLayoutPrams } from './RefreshLayoutPrams';
import { RefreshState } from './RefreshState';

@Component
export default struct LoadMoreLayout {
  @ObjectLink refreshLayoutPrams: RefreshLayoutPrams;

  build() {
    Column() {
      RefreshHeader({
        refreshLayoutPrams: new RefreshLayoutPrams(
          this.refreshLayoutPrams.isVisible,
          this.refreshLayoutPrams.imageSrc,
          this.refreshLayoutPrams.textValue,
          this.refreshLayoutPrams.isVisible ? this.refreshLayoutPrams.heightValue : 0,
          RefreshState.Refreshing)
      })
    }
  }
}