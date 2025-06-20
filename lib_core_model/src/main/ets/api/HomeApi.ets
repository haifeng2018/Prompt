/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeApi
 * Author: Victor
 * Date: 2023/3/1 16:36
 * Description: 
 * -----------------------------------------------------------------
 */

export class HomeApi {
  static readonly AD = 'cloud/user/platform/ad/list'
  static readonly SEARCH_TREND = 'cloud/user/search/trend'
  static readonly POPULARITY_GROUP = 'cloud/user/grouping/popularity/list'
  static readonly POPULARITY = 'cloud/user/home/goods/v1/popularity'
  static readonly FRESHNESS = 'cloud/user/home/goods/v1/freshness'
  static readonly SPIKE_ZONE = 'cloud/user/home/goods/hotsele/list'
  static readonly NOT_LOGGED_RECOMMEND = 'cloud/user/learning/pf/NotLogged/Recommend'
  static readonly SIGN_STATUS = 'cloud/msg/internal-msg/signStatus/user'
  static readonly HOME_LEVEL = 'cloud/user/pf-home-page-level-do/all'
  static readonly HOME_LEVEL_COURSE = 'cloud/user/pf-home-page-level-do/goods/page'
}
