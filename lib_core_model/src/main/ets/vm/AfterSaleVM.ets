/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: StudyCenterVM
 * Author: Victor
 * Date: 2023/11/28 15:47
 * Description: 
 * -----------------------------------------------------------------
 */
import http from '@ohos.net.http'
import { AfterSaleApi } from '../api/AfterSaleApi'
import { HomeApi } from '../api/HomeApi'
import { StudyCenterApi } from '../api/StudyCenterApi'
import { AfterSaleDetailData } from '../data/AfterSaleDetailData'
import { AfterSaleLogInfo } from '../data/AfterSaleLogInfo'
import { AfterSaleParm } from '../data/AfterSaleParm'
import { AnswerListData } from '../data/AnswerListData'
import { AnswerParm } from '../data/AnswerParm'
import { CoursePractisePageParm } from '../data/CoursePractisePageParm'
import { ExerciseInfo } from '../data/ExerciseInfo'
import { GoodsInfo } from '../data/GoodsInfo'
import { LastStudyInfo } from '../data/LastStudyInfo'
import { LearningInfo } from '../data/LearningInfo'
import { ListData } from '../data/ListData'
import { MaterialData } from '../data/MaterialData'
import { ModifyAfterSaleParm } from '../data/ModifyAfterSaleParm'
import { PracticeInfo } from '../data/PracticeInfo'
import { RefundConditionData } from '../data/RefundConditionData'
import { SummaryStudyData } from '../data/SummaryStudyData'
import { UserMaterialData } from '../data/UserMaterialData'
import { WatchHistoryInfo } from '../data/WatchHistoryInfo'
import { WatchHistoryParm } from '../data/WatchHistoryParm'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'
import Logger from '../util/Logger'

export default class AfterSaleVM {

  public static sendAfterSaleDetailRequest(tenantId: number,token: string,subOrderId: number): Promise<AfterSaleDetailData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = AfterSaleApi.AFTER_SALE_DETAIL
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['subOrderId'],[`${subOrderId}`])

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: AfterSaleDetailData = JSON.parse(json)
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

  public static sendCancelAfterSaleRequest(tenantId: number,token: string,afterSaleNo: string): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSummaryStudyRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AfterSaleApi.CANCEL_AFTER_SALE
      request.method = http.RequestMethod.PUT
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['afterSaleNo'],[afterSaleNo])

      if(tenantId > 0) {
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
      });
    })
  }

  public static sendAfterSaleRequest(tenantId: number,token: string,body: AfterSaleParm): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendLastStudyRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AfterSaleApi.AFTER_SALE
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])
      request.setBody(body)

      if(tenantId > 0) {
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
      });
    })
  }

  public static sendModifyAfterSaleRequest(tenantId: number,token: string,body: ModifyAfterSaleParm): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendLastStudyRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AfterSaleApi.MODIFY_AFTER_SALE
      request.method = http.RequestMethod.PUT
      request.addHeader(['AccessToken'],[token])
      request.setBody(body)

      if(tenantId > 0) {
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
      });
    })
  }

  public static sendAfterSaleLogRequest(tenantId: number,token: string,subOrderId: number): Promise<Array<AfterSaleLogInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendLearningRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AfterSaleApi.AFTER_SALE_LOG
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['subOrderId'],[`${subOrderId}`])

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<AfterSaleLogInfo> = JSON.parse(json)
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

  public static sendRefundReasonRequest(tenantId: number,token: string): Promise<Array<string>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendLearningRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AfterSaleApi.REFUND_REASON
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])

      if(tenantId > 0) {
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
      });
    })
  }

  public static sendRefundConditionRequest(tenantId: number,token: string,
    orderNo: string,subOrderId: number): Promise<RefundConditionData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendLearningRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AfterSaleApi.REFUND_CONDITION
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['orderNo','goodsSubOrderId'],[orderNo,`${subOrderId}`])

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: RefundConditionData = JSON.parse(json)
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