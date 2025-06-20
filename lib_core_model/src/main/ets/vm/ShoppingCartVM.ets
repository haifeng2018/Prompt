/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ShoppingCartVM
 * Author: Victor
 * Date: 2024/07/02 10:40
 * Description: 
 * -----------------------------------------------------------------
 */
import { http } from '@kit.NetworkKit'
import { ShoppingCartApi } from '../api/ShoppingCartApi'
import { GoodsSpecData } from '../data/GoodsSpecData'
import { RemoveCartGoodsInfo } from '../data/RemoveCartGoodsInfo'
import { SetCartParm } from '../data/SetCartParm'
import { ShoppingCartInfo } from '../data/ShoppingCartInfo'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'
import Logger from '../util/Logger'

export default class ShoppingCartVM {
  public static sendShoppingCartRequest(token: string): Promise<Array<ShoppingCartInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendShoppingCartRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = ShoppingCartApi.SHOPPING_CART
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<ShoppingCartInfo> = JSON.parse(json)
            resolve(data)
          } else {
            resolve([])
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendSetCartRequest(token: string, goodsId: string, specId: string, quantity: number): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSetCartRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = ShoppingCartApi.SET_CART
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'], [token])

      let body = new SetCartParm()
      body.goodsId = goodsId
      if (specId) {
        body.specId = specId
      }
      body.quantity = quantity

      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: object = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      })
    })
  }

  public static sendRemoveCartRequest(token: string, body: Array<RemoveCartGoodsInfo>): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendRemoveCartRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = ShoppingCartApi.REMOVE_CART
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'], [token])

      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: object = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendCartTotalRequest(token: string): Promise<number> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendRemoveCartRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = ShoppingCartApi.CART_TOTAL
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: number = JSON.parse(json)
            resolve(data)
          } else {
            resolve(0)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendGoodsSpecRequest(tenantId: number, goodsId: string): Promise<GoodsSpecData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = ShoppingCartApi.GOODS_SPEC
      request.method = http.RequestMethod.GET
      request.addHeader(['Tenant-Id'], [tenantId.toString()])
      request.setPathParams([goodsId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: GoodsSpecData = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }
}