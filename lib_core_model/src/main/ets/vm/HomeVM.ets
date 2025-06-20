/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeVM
 * Author: Victor
 * Date: 2023/11/28 16:05
 * Description: 
 * -----------------------------------------------------------------
 */
import http from '@ohos.net.http'
import { HomeApi } from '../api/HomeApi'
import { GoodsInfo } from '../data/GoodsInfo'
import { PopularityGroupInfo } from '../data/PopularityGroupInfo'
import { SearchTrendInfo } from '../data/SearchTrendInfo'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'
import Logger from '../util/Logger'
import { ListData } from '../data/ListData'
import { AdData } from '../data/AdData'
import { HomeLevelInfo } from '../data/HomeLevelInfo'

export default class HomeVM {

  public static sendHomeTopBannerRequest(): Promise<AdData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.AD
      request.method = http.RequestMethod.GET

      request.setQueryParams(['id'],['21'])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: AdData = JSON.parse(json)
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

  public static sendSearchTrendRequest(tenantId: number): Promise<Array<SearchTrendInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request: Request = new Request()
      request.url = HomeApi.SEARCH_TREND
      request.method = http.RequestMethod.GET

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<SearchTrendInfo> = JSON.parse(json)
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
    });
  }

  public static sendCategoryRequest(tenantId: number): Promise<AdData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.AD
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

  public static sendHomeCenterBannerRequest(): Promise<AdData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.AD
      request.method = http.RequestMethod.GET

      request.setQueryParams(['id'],['23'])

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

  public static sendHomeLevelRequest(): Promise<Array<HomeLevelInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.HOME_LEVEL
      request.method = http.RequestMethod.GET

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<HomeLevelInfo> = JSON.parse(json)
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

  public static sendHomeLevelCourseRequest(levelId: string,current: number,size: number): Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.HOME_LEVEL_COURSE
      request.method = http.RequestMethod.GET

      request.setQueryParams(['levelId','current','size'],[levelId,`${current}`,`${size}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<GoodsInfo> = JSON.parse(json)
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

  public static sendYouMayLikeCourseRequest(levelId: string,current: number,size: number): Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.HOME_LEVEL_COURSE
      request.method = http.RequestMethod.GET

      request.setQueryParams(['levelId','current','size'],[levelId,`${current}`,`${size}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<GoodsInfo> = JSON.parse(json)
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

  public static sendPopularityRequest(
    tenantId: number,groupingId: string,current: number,pageSize: number): Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.POPULARITY
      request.method = http.RequestMethod.GET

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['current','size','groupingId'],[`${current}`,`${pageSize}`,groupingId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<GoodsInfo> = JSON.parse(json)
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

  public static sendFreshnessRequest(tenantId: number,current: number,pageSize: number): Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.FRESHNESS
      request.method = http.RequestMethod.GET

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['current','size'],[`${current}`,`${pageSize}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<GoodsInfo> = JSON.parse(json)
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

  public static sendSpikeZoneRequest(tenantId: number,current: number,pageSize: number): Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.SPIKE_ZONE
      request.method = http.RequestMethod.GET

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['current','size'],[`${current}`,`${pageSize}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<GoodsInfo> = JSON.parse(json)
            resolve(data.items)
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

  public static sendSignStatusRequest(token: string): Promise<number> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSignStatusRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = HomeApi.SIGN_STATUS
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'],[token])

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

  public static sendPopularityGroupRequest(tenantId: number): Promise<Array<PopularityGroupInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.POPULARITY_GROUP
      request.method = http.RequestMethod.GET
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<PopularityGroupInfo> = JSON.parse(json)
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
}
