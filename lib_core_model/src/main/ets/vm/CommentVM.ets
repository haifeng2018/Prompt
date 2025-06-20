/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CommentVM
 * Author: Victor
 * Date: 2024/07/01 11:41
 * Description: 
 * -----------------------------------------------------------------
 */
import { CommentApi } from '../api/CommentApi'
import Request from '../module/Request'
import { http } from '@kit.NetworkKit'
import HttpCore from '../module/HttpCore'
import { Response } from '../module/Response'
import { ListData } from '../data/ListData'
import { CommentInfo } from '../data/CommentInfo'
import { CommentListParm } from '../data/CommentListParm'
import Logger from '../util/Logger'
import { CommentNumData } from '../data/CommentNumData'
import { CourseEvaluateCheckData } from '../data/CourseEvaluateCheckData'
import { CommentParm } from '../data/CommentParm'
import { CommentDetailData } from '../data/CommentDetailData'

export default class CommentVM {

  public static sendCommendNumRequest(tenantId: number,token: string,goodsId: string): Promise<CommentNumData> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CommentApi.COMMENT_NUM
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['goodsId'],[goodsId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: CommentNumData = JSON.parse(json)
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

  public static sendCommentListRequest(tenantId: number,token: string,body: CommentListParm): Promise<Array<CommentInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {

      let request = new Request()
      request.url = CommentApi.COMMENT_LIST
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<CommentInfo> = JSON.parse(json)
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

  public static sendRecommendCommendRequest(tenantId: number,goodsId: string): Promise<CommentInfo> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CommentApi.RECOMMEND_COMMENT
      request.method = http.RequestMethod.GET
      request.setQueryParams(['goodsId'],[goodsId])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: CommentInfo = JSON.parse(json)
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

  public static sendEvaluateLecturerRequest(tenantId: number,token: string,goodsId: string): Promise<Array<string>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CommentApi.EVALUATE_LECTURER
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['goodsId'],[goodsId])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<string> = JSON.parse(json)
            resolve(data)
          } else {
            resolve([])
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      })
    })
  }

  public static sendEvaluateCheckRequest(tenantId: number,token: string,content: string): Promise<CourseEvaluateCheckData> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CommentApi.EVALUATE_CHECK
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['content'],[content])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: CourseEvaluateCheckData = JSON.parse(json)
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

  public static sendAddCommentRequest(tenantId: number,token: string,body: CommentParm): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CommentApi.ADD_COMMENT
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])
      request.setBody(body)

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

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

  public static sendEditCommentRequest(tenantId: number,token: string,body: CommentParm): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CommentApi.EDIT_COMMENT
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])
      request.setBody(body)

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

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

  public static sendCommentDetailRequest(tenantId: number,token: string,id: number): Promise<CommentDetailData> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CommentApi.COMMENT_DETAIL
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['id'],[`${id}`])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: CommentDetailData = JSON.parse(json)
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

}