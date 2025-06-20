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
import { CourseApi } from '../api/CourseApi'
import { HomeApi } from '../api/HomeApi'
import { AdData } from '../data/AdData'
import { AutoClaimCouponParm } from '../data/AutoClaimCouponParm'
import { ClaimCouponParm } from '../data/ClaimCouponParm'
import { CommentInfo } from '../data/CommentInfo'
import { CouponInfo } from '../data/CouponInfo'
import { CourseCategoryInfo } from '../data/CourseCategoryInfo'
import { CourseCouponData } from '../data/CourseCouponData'
import { GoodsInfo } from '../data/GoodsInfo'
import { ListData } from '../data/ListData'
import { MaterialData } from '../data/MaterialData'
import { MaterialInfo } from '../data/MaterialInfo'
import { PlayInfo } from '../data/PlayInfo'
import { UpdateVideoProgressParm } from '../data/UpdateVideoProgressParm'
import { VideoProgressInfo } from '../data/VideoProgressInfo'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'
import Logger from '../util/Logger'

export default class CourseVM {

  public static sendOnlineRecommendRequest(token: string,current: number,size: number):Promise<Array<GoodsInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOnlineRecommendRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.ONLINE_RECOMMEND
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['current','size'],[`${current}`,`${size}`])

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

  public static sendCourseCategoryRequest(tenantId: number): Promise<Array<CourseCategoryInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CourseApi.COURSE_CATEGORY
      request.method = http.RequestMethod.GET
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<CourseCategoryInfo> = JSON.parse(json)
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

  public static sendCategoryCourseRequest(tenantId: number,catalogueId: string,sortType: number,
                                          current: number,size: number): Promise<Array<GoodsInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CourseApi.CATEGORY_COURSE
      request.method = http.RequestMethod.GET
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['catalogueId','sortType','current','size'],
        [catalogueId,`${sortType}`,`${current}`,`${size}`])

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

  public static sendCategoryAdRequest(bannerType: string): Promise<AdData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = HomeApi.AD
      request.method = http.RequestMethod.GET
      request.setQueryParams(['bannerType'],[bannerType])

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

  public static sendOnlineCourseDetailRequest(token: string,goodsId: string): Promise<GoodsInfo> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CourseApi.ONLINE_COURSE_DETAIL
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['goodsId'],[goodsId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: GoodsInfo = JSON.parse(json)
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

  public static sendOfflineCourseDetailRequest(token: string,goodsId: string,subOrderId: number): Promise<GoodsInfo> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CourseApi.OFFLINE_COURSE_DETAIL
      request.method = http.RequestMethod.POST

      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['goodsId','subOrderId'],[goodsId,`${subOrderId}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: GoodsInfo = JSON.parse(json)
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

  public static sendCourseCouponTipRequest(token: string,goodsId: string): Promise<Array<CouponInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOnlineCourseDetailRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.COURSE_COUPON_TIP
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'],[token])
      request.setPathParams([goodsId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<CouponInfo> = JSON.parse(json)
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

  public static sendCourseCouponRequest(token: string,goodsId: string): Promise<CourseCouponData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOnlineCourseDetailRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.COURSE_COUPON
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'],[token])
      request.setPathParams([goodsId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: CourseCouponData = JSON.parse(json)
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

  public static sendClaimCouponRequest(tenantId: number,token: string,body: ClaimCouponParm): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendClaimCouponRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.CLAIM_COUPON
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

  public static sendAutoClaimCouponRequest(tenantId: number,token: string,body: AutoClaimCouponParm): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendAutoClaimCouponRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.AUTO_CLAIM_COUPON
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

  public static sendPlayListRequest(token: string,goodsId: string,materialId: string): Promise<Array<PlayInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOnlineCourseDetailRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.PLAY_LIST
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['goodsId','materialId'],[goodsId,materialId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<PlayInfo> = JSON.parse(json)
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

  public static sendPlayTryListRequest(
    token: string,
    tenantId:string,
    cGoodsId: string,
    goodsId: string,
    materialId: string
  ): Promise<Array<PlayInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {

      let request = new Request()
      request.url = CourseApi.TRY_LIST
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['goodsId','materialId','tenantId','cGoodsId'],[goodsId,materialId,tenantId,cGoodsId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<PlayInfo> = JSON.parse(json)
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

  public static sendCoursePptRequest(token: string, goodsId: string, tenantId: number): Promise<Array<MaterialInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOnlineCourseDetailRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.COURSE_PPT
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'], [token])
      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'], [tenantId.toString()])
      }
      request.setPathParams([goodsId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<MaterialInfo> = JSON.parse(json)
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

  public static sendCourseMaterialRequest(token: string,goodsId: string): Promise<MaterialData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOnlineCourseDetailRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.COURSE_MATERIAL
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'],[token])
      request.setPathParams([goodsId])

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
      })
    })
  }

  public static sendCourseDetailRecommendRequest(tenantId: number,goodsId: string): Promise<Array<GoodsInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CourseApi.COURSE_DETAIL_RECOMMEND
      request.method = http.RequestMethod.GET
      request.setQueryParams(['goodsId'],[goodsId])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

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
      })
    })
  }

  /**
   * 获取商品最近的一次播放进度
   * @param tenantId
   * @param goodsId 商品编号
   * @param subOrderId 子订单id(没有则传0)
   * @returns 播放进度
   */
  public static getPlayLastProgressRequest(
    token: string,
    tenantId: number,
    goodsId: string,
    subOrderId: number
  ): Promise<VideoProgressInfo> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOnlineCourseDetailRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = CourseApi.GET_PLAY_LAST_PROGRESS
      request.method = http.RequestMethod.GET
      request.setPathParams([goodsId])
      request.setQueryParams(['subOrderId'], [subOrderId.toString() ?? '0'])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'], [`${tenantId}`])
      }
      request.addHeader(['AccessToken'], [token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: VideoProgressInfo = JSON.parse(json)
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

  /**
   * 更新商品播放进度
   * @param tenantId
   * @param parm
   * @returns
   */
  public static updatePlayProgressRequest(token: string,tenantId: number, parm: UpdateVideoProgressParm): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOnlineCourseDetailRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = CourseApi.UPDATE_PLAY_PROGRESS
      request.method = http.RequestMethod.POST
      request.setBody(parm)

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'], [`${tenantId}`])
      }
      request.addHeader(['AccessToken'], [token])

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

  /**
   * 获取播放 Token
   * @param token
   * @param tenantId
   * @param goodsId
   * @param materialId
   * @returns token
   */
  public static sendGetPlayTokenRequest(
    token: string,
    tenantId: number,
    goodsId: string,
    materialId: string
  ): Promise<string> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let request = new Request()
      request.url = CourseApi.GET_PLAY_TOKEN
      request.method = http.RequestMethod.GET

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'], [`${tenantId}`])
      }
      request.addHeader(['AccessToken'], [token])
      request.setQueryParams(['goodsId', 'materialId'], [goodsId, materialId])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: string = JSON.parse(json)
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