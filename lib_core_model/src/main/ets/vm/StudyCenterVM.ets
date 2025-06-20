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
import { HomeApi } from '../api/HomeApi'
import { StudyCenterApi } from '../api/StudyCenterApi'
import { AnswerListData } from '../data/AnswerListData'
import { AnswerParm } from '../data/AnswerParm'
import { CoursePractisePageParm } from '../data/CoursePractisePageParm'
import { ExerciseInfo } from '../data/ExerciseInfo'
import { GoodsInfo } from '../data/GoodsInfo'
import { LastStudyInfo } from '../data/LastStudyInfo'
import { LearningInfo } from '../data/LearningInfo'
import { ListData } from '../data/ListData'
import { MaterialData } from '../data/MaterialData'
import { PracticeInfo } from '../data/PracticeInfo'
import { SummaryStudyData } from '../data/SummaryStudyData'
import { UserMaterialData } from '../data/UserMaterialData'
import { WatchHistoryInfo } from '../data/WatchHistoryInfo'
import { WatchHistoryParm } from '../data/WatchHistoryParm'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'
import Logger from '../util/Logger'

export default class StudyCenterVM {

  public static sendNotLoggedRecommendRequest(size: number): Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.NOT_LOGGED_RECOMMEND
      request.method = http.RequestMethod.GET

      request.setQueryParams(['size'],[`${size}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<GoodsInfo> = JSON.parse(json)
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

  public static sendSummaryStudyRequest(token: string): Promise<SummaryStudyData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSummaryStudyRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.SUMMARY_STUDY
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: SummaryStudyData = JSON.parse(json)
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

  public static sendLastStudyRequest(token: string): Promise<LastStudyInfo> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendLastStudyRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.LAST_STUDY
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: LastStudyInfo = JSON.parse(json)
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

  public static sendLearningRequest(token: string): Promise<Array<LearningInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendLearningRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.LEARNING
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<LearningInfo> = JSON.parse(json)
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

  public static sendWatchHistoryRequest(token: string,current: number,size: number): Promise<Array<WatchHistoryInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendWatchHistoryRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.WATCH_HISTORY
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])

      let body = new WatchHistoryParm()
      body.current = current
      body.size = size
      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<WatchHistoryInfo> = JSON.parse(json)
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

  public static sendLearningPageRequest(tenantId: number,token: string,goodsMode: number,
                          current: number,pageSize: number): Promise<Array<LearningInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendLearningPageRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.LEARNING_PAGE
      request.method = http.RequestMethod.GET
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['goodsMode','current','size'],[`${goodsMode}`,`${current}`,`${pageSize}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<LearningInfo> = JSON.parse(json)
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

  public static sendPracticeRequest(tenantId: number,token: string,statusCode: number): Promise<Array<PracticeInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendPracticeRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.PRACTICE
      request.method = http.RequestMethod.GET
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.addHeader(['AccessToken'],[token])
      request.setPathParams([`${statusCode}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<PracticeInfo> = JSON.parse(json)
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

  public static sendCoursePracticeRequest(tenantId: number,token: string,goodsId: string): Promise<ExerciseInfo> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendCoursePracticeRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.COURSE_PRACTICE
      request.method = http.RequestMethod.GET

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.addHeader(['AccessToken'],[token])
      request.setPathParams([goodsId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ExerciseInfo = JSON.parse(json)
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

  public static sendExerciseAnswerRequest(tenantId: number,token: string,body: AnswerParm): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendExerciseAnswerRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.EXERCISE_ANSWER
      request.method = http.RequestMethod.POST

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
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

  public static sendExerciseAnswerPageRequest(tenantId: number,token: string,
                                              body: CoursePractisePageParm): Promise<AnswerListData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendExerciseAnswerPageRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.ANSWER_PAGE
      request.method = http.RequestMethod.POST

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.addHeader(['AccessToken'],[token])
      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: AnswerListData = JSON.parse(json)
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

  public static sendUserMaterialRequest(tenantId: number,token: string): Promise<Array<UserMaterialData>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUserMaterialRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.USER_MATERIAL
      request.method = http.RequestMethod.GET

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.addHeader(['AccessToken'],[token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<UserMaterialData> = JSON.parse(json)
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

  public static sendMaterialDetailRequest(tenantId: number,token: string,goodsId:string): Promise<MaterialData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendMaterialDetailRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = StudyCenterApi.MATERIAL_DETAIL
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setPathParams([goodsId])

      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: MaterialData = JSON.parse(json)
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