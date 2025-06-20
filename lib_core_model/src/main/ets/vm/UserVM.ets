import http from '@ohos.net.http'
import { UserApi } from '../api/UserApi'
import { CouponInfo } from '../data/CouponInfo'
import { LatestVersionData } from '../data/LatestVersionData'
import { ListData } from '../data/ListData'
import { ServiceInfo } from '../data/ServiceInfo'
import { UserInfo } from '../data/UserInfo'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'
import Logger from '../util/Logger'

export default class UserVM {
  /**
   * 获取用户信息
   * @param token
   * @returns UserInfo
   */
  public static sendUserInfoRequest(token: string): Promise<UserInfo> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = UserApi.USER_INFO
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: UserInfo = JSON.parse(json)
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

  /**
   * 获取版本更新信息
   * @param appId
   * @param version
   * @returns LatestVersionData
   */
  public static sendCheckVersionRequest(appId: string, version: string): Promise<LatestVersionData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = UserApi.CHECK_VERSION
      request.method = http.RequestMethod.GET
      request.setQueryParams(['appId', 'version', 'terminal'], [appId, version, 'HARMONEY'])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          let json = JSON.stringify(response.data)
          let data: LatestVersionData = JSON.parse(json)
          resolve(data)
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendCouponPageRequest(token: string, pageIndex: number, pageSize: number,
                                      couponStatus: number): Promise<Array<CouponInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendCouponPageRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = UserApi.COUPON_PAGE
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])
      request.setQueryParams(['pageIndex', 'pageSize', 'couponStatus'], [`${pageIndex}`, `${pageSize}`, `${couponStatus}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<CouponInfo> = JSON.parse(json)
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

  public static sendServiceInfoRequest(token: string): Promise<ServiceInfo> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendServiceInfoRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = UserApi.SERVICE_INFO
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'], [token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ServiceInfo = JSON.parse(json)
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

  public static sendUpdateUserInfoRequest(token: string, body: UserInfo): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUpdateUserInfoRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = UserApi.USER_INFO
      request.method = http.RequestMethod.PUT
      request.addHeader(['AccessToken'], [token])
      request.setBody(body)


      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          let json = JSON.stringify(response.data)
          let data: object = JSON.parse(json)
          resolve(data)
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }
}