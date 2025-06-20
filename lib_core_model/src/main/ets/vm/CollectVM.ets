/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CollectVM
 * Author: Victor
 * Date: 2024/07/01 16:17
 * Description: 
 * -----------------------------------------------------------------
 */
import { CollectApi } from '../api/CollectApi'
import { CollectParm } from '../data/CollectParm'
import Request from '../module/Request'
import Logger from '../util/Logger'
import { http } from '@kit.NetworkKit'
import HttpCore from '../module/HttpCore'
import { Response } from '../module/Response'
import { CollectInfo } from '../data/CollectInfo'
import { ListData } from '../data/ListData'

export default class CollectVM {
  public static sendMyFavoriteRequest(token: string,current: number,size: number): Promise<Array<CollectInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendMyFavoriteRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CollectApi.COLLECTION_PAGE
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['current','size'],[`${current}`,`${size}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<CollectInfo> = JSON.parse(json)
            resolve(data.records)
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

  public static sendCollectRequest(token: string,body: CollectParm): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendCollectRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CollectApi.COLLECT
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])
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
}