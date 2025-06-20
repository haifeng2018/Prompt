/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ShoppingCartDataUtil
 * Author: Victor
 * Date: 2023/12/11 12:25
 * Description: 
 * -----------------------------------------------------------------
 */
import { ShoppingCartInfo } from 'lib_core_model/src/main/ets/data/ShoppingCartInfo';

export class ShoppingCartDataManager {
  private static shoppingCartDataManager: ShoppingCartDataManager
  private shopCartData: ShoppingCartInfo[] = []

  private constructor() {
  }

  static instance() {
    if (!ShoppingCartDataManager.shoppingCartDataManager) {
      ShoppingCartDataManager.shoppingCartDataManager = new ShoppingCartDataManager()
    }
    return ShoppingCartDataManager.shoppingCartDataManager;
  }

  setShoppingCartData(shoppingCartList: Array<ShoppingCartInfo>) {
    this.shopCartData = [...shoppingCartList]
  }

  queryShopCart() {
    return this.shopCartData;
  }

  deleteShopCart(ids: string[]) {
    ids.forEach((id) => {
      const result = this.shopCartData.filter(item => item.goodsId === id);
      if (result.length > 0) {
        this.shopCartData.splice(this.shopCartData.indexOf(result?.[0]), 1);
      }
    });
    return this.shopCartData;
  }

  updateShopCart(goodsId: string,
                 selected?: boolean) {
    const result: ShoppingCartInfo = this.shopCartData.filter(item => item.goodsId === goodsId)?.[0];
    result.goodsId = goodsId
    result.selected = selected
    this.shopCartData.splice(this.shopCartData.indexOf(result), 1, result);
  }

}