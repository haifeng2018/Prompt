/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrderApi
 * Author: Victor
 * Date: 2023/12/11 18:16
 * Description: 
 * -----------------------------------------------------------------
 */
export class OrderApi {
  static readonly ORDER_LIST = 'cloud/user/goods/order/pf/list'
  static readonly UN_COMMENT_ORDER_LIST = 'cloud/user/goods/order/pf/toComment'
  static readonly ORDER_DETAIL = 'cloud/user/pf/order/detail'
  static readonly ADD_GOOD_ORDER = 'cloud/user/goods/order/submit'
  static readonly YEE_PAY = 'cloud/user/goods/order/getYeePayFlag'
  static readonly PRE_ORDER = 'cloud/user/goods/order/preOrder'
  static readonly ORDER_RESULT = 'cloud/user/goods/order/result'
  static readonly PAY_RECOMMEND = 'cloud/user/home/goods/order/recommend/list'
  static readonly LOGISTICS_INFO = 'cloud/user/logistics/info'
  static readonly ORDER_GOOD_RELATED = 'cloud/user/goods/order/goods/related/info'
  static readonly ORDER_RECOMMEND = 'cloud/user/goods/order/recommendList'
  static readonly RECOMMEND_COUPON = 'cloud/user/coupon/recommend/coupon'
}