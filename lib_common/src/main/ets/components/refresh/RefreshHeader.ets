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

import RefreshLoading from './RefreshLoading';
import { RefreshLayoutPrams } from './RefreshLayoutPrams';

@Component
export default struct RefreshHeader {
  @ObjectLink refreshLayoutPrams: RefreshLayoutPrams;

  build() {
    Column() {
      if (this.refreshLayoutPrams.isVisible) {
        RefreshLoading({ refreshLayoutPrams: new RefreshLayoutPrams
        (this.refreshLayoutPrams.isVisible, this.refreshLayoutPrams.imageSrc, this.refreshLayoutPrams.textValue,
          this.refreshLayoutPrams.heightValue,this.refreshLayoutPrams.refreshState) })
      }
    }
  }
}