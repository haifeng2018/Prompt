/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: TeacherVM
 * Author: Victor
 * Date: 2024/07/01 10:31
 * Description: 
 * -----------------------------------------------------------------
 */
import { TeacherApi } from '../api/TeacherApi'
import { TeacherDetailData } from '../data/TeacherDetailData'
import Request from '../module/Request'
import { http } from '@kit.NetworkKit'
import HttpCore from '../module/HttpCore'
import { Response } from '../module/Response'
import { GoodsInfo } from '../data/GoodsInfo'
import { ListData } from '../data/ListData'

export default class TeacherVM {

  public static sendTeacherDetailRequest(tenantId: number,lecturerId: string): Promise<TeacherDetailData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = TeacherApi.TEACHER_DETAIL
      request.method = http.RequestMethod.GET

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['lecturerId'],[lecturerId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: TeacherDetailData = JSON.parse(json)
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

  public static sendTeacherOnlineRequest(tenantId: number,lecturerId: string,
                                         current: number,size: number): Promise<Array<GoodsInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = TeacherApi.TEACHER_ONLINE
      request.method = http.RequestMethod.GET

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['lecturerId','current','size'],[lecturerId,`${current}`,`${size}`])

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

  public static sendTeacherOfflineRequest(tenantId: number,lecturerId: string,
                            current: number,size: number): Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = TeacherApi.TEACHER_OFFLINE
      request.method = http.RequestMethod.GET

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['lecturerId','current','size'],[lecturerId,`${current}`,`${size}`])

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

}