/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: SplashVM
 * Author: Victor
 * Date: 2023/11/28 16:27
 * Description: 
 * -----------------------------------------------------------------
 */
import http from '@ohos.net.http'
import { HomeApi } from '../api/HomeApi'
import { AdData } from '../data/AdData'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'

export default class SplashVM {

  public static sendAdRequest(): Promise<AdData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.AD
      request.method = http.RequestMethod.GET

      request.setQueryParams(['id'],['1'])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: AdData = JSON.parse(json)
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