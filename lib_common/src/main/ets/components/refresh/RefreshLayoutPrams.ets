/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: RefreshLayoutPrams
 * Author: Victor
 * Date: 2024/06/27 11:31
 * Description: 
 * -----------------------------------------------------------------
 */
import { PageState } from './PageState';

@Observed
export class RefreshLayoutPrams {
  /**
   * Custom refresh load layout isVisible.
   */
  isVisible: boolean;

  /**
   * Custom refresh load layout imageSrc.
   */
  imageSrc: Resource;

  /**
   * Custom refresh load layout textValue.
   */
  textValue: Resource;

  /**
   * Custom refresh load layout heightValue.
   */
  heightValue: number;

  refreshState?: number | null;

  constructor(isVisible: boolean, imageSrc: Resource, textValue: Resource, heightValue: number,state?: number | null) {
    this.isVisible = isVisible;
    this.imageSrc = imageSrc;
    this.textValue = textValue;
    this.heightValue = heightValue;
    this.refreshState = state;
  }
}