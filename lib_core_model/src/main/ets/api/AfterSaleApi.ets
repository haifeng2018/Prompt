/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AuthApi
 * Author: Victor
 * Date: 2023/11/20 18:48
 * Description: 
 * -----------------------------------------------------------------
 */
export class AfterSaleApi {
  static readonly AFTER_SALE_DETAIL = 'cloud/user/goods/after/sale/detail'
  static readonly CANCEL_AFTER_SALE = 'cloud/user/goods/after/sale/undo'
  static readonly MODIFY_AFTER_SALE = 'cloud/user/goods/after/sale/alter'
  static readonly AFTER_SALE_LOG = 'cloud/user/goods/after/sale/afterSale/log'
  static readonly REFUND_REASON = 'cloud/user/goods/after/sale/reason/list'
  static readonly AFTER_SALE = 'cloud/user/goods/after/sale'
  static readonly REFUND_CONDITION = 'cloud/user/goods/order/refund/condition'
}