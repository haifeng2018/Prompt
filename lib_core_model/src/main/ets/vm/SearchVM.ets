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
import { SearchApi } from '../api/SearchApi'
import { GoodsInfo } from '../data/GoodsInfo'
import { ListData } from '../data/ListData'
import { SearchParm } from '../data/SearchParm'
import { SearchTenantInfo } from '../data/SearchTenantInfo'
import { SearchTrendInfo } from '../data/SearchTrendInfo'
import { TeacherInfo } from '../data/TeacherInfo'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'

export default  class SearchVM {

  public static sendSearchTrendRequest(tenantId: number,name: string): Promise<Array<SearchTrendInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = SearchApi.SEARCH_TREND
      request.method = http.RequestMethod.GET

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['name'],[name])

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
    })
  }

  public static sendSearchCourseRequest(tenantId: number,keyword: string,
                                        current: number,pageSize: number): Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = SearchApi.SEARCH_COURSE_PAGE
      request.method = http.RequestMethod.POST

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      let body = new SearchParm()
      body.keyword = keyword
      body.current = current
      body.size = pageSize
      request.setBody(body)

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

  public static sendSearchTeacherRequest(tenantId: number,keyword: string,
                                         current: number,pageSize: number): Promise<Array<TeacherInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = SearchApi.SEARCH_TEACHER_PAGE
      request.method = http.RequestMethod.POST

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      let body = new SearchParm()
      body.keyword = keyword
      body.current = current
      body.size = pageSize
      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<TeacherInfo> = JSON.parse(json)
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

  public static sendSearchTenantRequest(tenantId: number,keyword: string,
                                        current: number,pageSize: number): Promise<Array<SearchTenantInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = SearchApi.SEARCH_TENANT_PAGE
      request.method = http.RequestMethod.POST

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      let body = new SearchParm()
      body.keyword = keyword
      body.current = current
      body.size = pageSize
      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<SearchTenantInfo> = JSON.parse(json)
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
}