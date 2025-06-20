/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrderVM
 * Author: Victor
 * Date: 2024/07/01 18:36
 * Description: 
 * -----------------------------------------------------------------
 */
import { OrderApi } from '../api/OrderApi'
import Request from '../module/Request'
import Logger from '../util/Logger'
import { http } from '@kit.NetworkKit'
import HttpCore from '../module/HttpCore'
import { Response } from '../module/Response'
import { OrderInfo } from '../data/OrderInfo'
import { ListData } from '../data/ListData'
import { OrderDetailData } from '../data/OrderDetailData'
import { AddGoodOrderParm } from '../data/AddGoodOrderParm'
import { PreOrderParm } from '../data/PreOrderParm'
import { PayInfo } from '../data/PayInfo'
import { ifaa } from '@kit.OnlineAuthenticationKit'
import { LogisticsData } from '../data/LogisticsData'
import { OrderGoodRelatedData } from '../data/OrderGoodRelatedData'
import { GoodsInfo } from '../data/GoodsInfo'
import { OrderRecommendInfo } from '../data/OrderRecommendInfo'
import { RecommendCouponParm } from '../data/RecommendCouponParm'
import { RecommendCouponData } from '../data/RecommendCouponData'

export default class OrderVM {
  public static sendOrderListRequest(token: string,orderStatus: number,
                                     current: number,size: number): Promise<Array<OrderInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendOrderListRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = OrderApi.ORDER_LIST
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      if (orderStatus >= 0) {
        request.setQueryParams(['orderStatus','current','size'],[`${orderStatus}`,`${current}`,`${size}`])
      } else {
        request.setQueryParams(['current','size'],[`${current}`,`${size}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<OrderInfo> = JSON.parse(json)
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

  public static sendUnCommentOrderListRequest(token: string,current: number,size: number): Promise<Array<OrderInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = OrderApi.UN_COMMENT_ORDER_LIST
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['current','size'],[`${current}`,`${size}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<OrderInfo> = JSON.parse(json)
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

  public static sendOrderDetailRequest(tenantId: number,token: string,orderNo: string): Promise<OrderDetailData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = OrderApi.ORDER_DETAIL
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['orderNo'],[orderNo])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: OrderDetailData = JSON.parse(json)
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

  public static sendAddGoodOrderRequest(tenantId: number,token: string,body: AddGoodOrderParm): Promise<OrderDetailData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = OrderApi.ADD_GOOD_ORDER
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
            let data: OrderDetailData = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          if (response.code == 5060) {
            reject(response.code)
          } else {
            reject(response.message)
          }
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  /**
   * @param token
   * @param orderNo
   * @param terminalType //0-其它 1-安卓 2-IOS 3-H5 4-小程序
   * @param callback
   */
  public static sendYeePayRequest(tenantId: number,token: string,
                                  orderNo: string,terminalType: number): Promise<string> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = OrderApi.YEE_PAY
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['orderNo','terminalType'],[orderNo,`${terminalType}`])

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

  public static sendPreOrderRequest(tenantId: number,token: string,body: PreOrderParm): Promise<PayInfo> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = OrderApi.PRE_ORDER
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
            let data: PayInfo = JSON.parse(json)
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

  public static sendOrderResultRequest(tenantId: number,token: string,orderNo: string): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = OrderApi.ORDER_RESULT
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['orderNo'],[orderNo])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: object = JSON.parse(json)
            resolve(data)
          } else {
            resolve(response.code)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendRecommendCouponRequest(tenantId: number,token: string,body: RecommendCouponParm): Promise<RecommendCouponData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = OrderApi.RECOMMEND_COUPON
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
            let data: RecommendCouponData = JSON.parse(json)
            resolve(data)
          } else {
            resolve(response.code)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendLogisiticsInfoRequest(tenantId: number,token: string,
    orderNo: string,isUser: number): Promise<LogisticsData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = OrderApi.LOGISTICS_INFO
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['orderNo','isUser'],[orderNo,`${isUser}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: LogisticsData = JSON.parse(json)
            resolve(data)
          } else {
            resolve(response.code)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendOrderGoodRelatedRequest(tenantId: number,token: string,
    goodsId: string,subOrderNo: number): Promise<OrderGoodRelatedData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = OrderApi.ORDER_GOOD_RELATED
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      if(tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }
      request.setQueryParams(['goodsId','subOrderNo'],[goodsId,`${subOrderNo}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: OrderGoodRelatedData = JSON.parse(json)
            resolve(data)
          } else {
            resolve(response.code)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendOrderRecommendRequest(tenantId: number,token: string,
    goodsId: string): Promise<Array<OrderRecommendInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUnCommentOrderListRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = OrderApi.ORDER_RECOMMEND
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
            let data: Array<OrderRecommendInfo> = JSON.parse(json)
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