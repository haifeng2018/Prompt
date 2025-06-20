/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrganHomeVM
 * Author: Victor
 * Date: 2024/07/02 12:05
 * Description: 
 * -----------------------------------------------------------------
 */
import { OrganHomeApi } from '../api/OrganHomeApi'
import { http } from '@kit.NetworkKit'
import Request from '../module/Request'
import HttpCore from '../module/HttpCore'
import { HotLiveInfo } from '../data/HotLiveInfo'
import { Response } from '../module/Response'
import { AdData } from '../data/AdData'

export default class OrganHomeVM {

  public static sendHotLiveRequest(tenantId: number): Promise<Array<HotLiveInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = OrganHomeApi.HOT_LIVE
      request.method = http.RequestMethod.GET

      if (tenantId) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<HotLiveInfo> = JSON.parse(json)
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

  public static sendCategoryRequest(tenantId: number): Promise<AdData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = OrganHomeApi.TENANT_AD
      request.method = http.RequestMethod.GET

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['id'],['22'])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: AdData = JSON.parse(json)
            resolve(data);
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

  public static sendTenantAdRequest (tenantId: number): Promise<AdData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = OrganHomeApi.TENANT_AD
      request.method = http.RequestMethod.GET

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['id'],['21'])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: AdData = JSON.parse(json)
            resolve(data);
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