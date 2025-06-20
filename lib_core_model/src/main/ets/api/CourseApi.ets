/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseApi
 * Author: Victor
 * Date: 2023/11/22 18:14
 * Description: 
 * -----------------------------------------------------------------
 */
export class CourseApi {
  static readonly ONLINE_RECOMMEND = 'cloud/user/home/goods/online/recommend/prefecture/list'
  static readonly COURSE_CATEGORY = 'cloud/user/pf/catalogue/platform/list'
  static readonly CATEGORY_COURSE = 'cloud/user/pf/catalogue/goods/list'
  static readonly ONLINE_COURSE_DETAIL = 'cloud/user/home/v3/goods/online/detail'
  static readonly OFFLINE_COURSE_DETAIL = 'cloud/user/v2/home/goods/offline/detail'
  static readonly COURSE_COUPON_TIP = 'cloud/user/coupon/goods/detail/tip/'
  static readonly COURSE_DETAIL_RECOMMEND = "cloud/user/home/goods/recommend/list"
  static readonly COURSE_COUPON = 'cloud/user/coupon/goods/detail/list/'
  static readonly CLAIM_COUPON = 'cloud/user/coupon/claim/coupon'
  static readonly AUTO_CLAIM_COUPON = 'cloud/user/coupon/auto/claim/coupon'
  static readonly PLAY_LIST = 'cloud/user/play/list'
  static readonly TRY_LIST = 'cloud/user/play/list/try/v2'
  static readonly COURSE_PPT = 'cloud/user/user-material/ppt/goods/'
  static readonly COURSE_MATERIAL = 'cloud/goods/'
  // cloud/user/user-progress/v2/last/goods/{goodsId}
  static readonly GET_PLAY_LAST_PROGRESS = 'cloud/user/user-progress/v2/last/goods/'
  static readonly UPDATE_PLAY_PROGRESS = 'cloud/user/user-progress/update'
  static readonly GET_PLAY_TOKEN = 'cloud/user/play/token'
}