import { http } from '@kit.NetworkKit'
import { MessageApi } from '../api/MessageApi'
import { FeedbackCodeParm } from '../data/FeedbackCodeParm'
import { FeedbackParm } from '../data/FeedbackParm'
import { ListData } from '../data/ListData'
import { NotificationInfo } from '../data/NotificationInfo'
import { NotificationParm } from '../data/NotificationParm'
import { SignStatusInfo } from '../data/SignStatusInfo'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'
import Logger from '../util/Logger'

export default class MessageVM {
  /**
   * 提交反馈意见
   * @param token
   * @param feedbackParm
   * @returns object
   */
  public static sendFeedbackRequest(token: string, feedbackParm: FeedbackParm): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = MessageApi.FEED_BACK
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'], [token])
      request.setBody(feedbackParm)

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

  public static sendFeedbackCodeRequest(token: string, phone: string): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = MessageApi.FEED_BACK_CODE
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'], [token])
      let feedbackCodeParm = new FeedbackCodeParm()
      feedbackCodeParm.phone = phone
      request.setBody(feedbackCodeParm)

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

  public static sendNotificationsRequest(token: string, body: NotificationParm): Promise<Array<NotificationInfo>> {
    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendNotificationsRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = MessageApi.GET_NOTIFICATION
      request.method = http.RequestMethod.POST

      request.addHeader(['AccessToken'], [token])
      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<NotificationInfo> = JSON.parse(json)
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

  public static sendReadNotificationsRequest(token: string, body: Array<number>): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendReadNotificationsRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = MessageApi.READ_NOTIFICATIONS
      request.method = http.RequestMethod.PUT

      request.addHeader(['AccessToken'], [token])
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

  public static sendSignStatusRequest(token: string): Promise<Array<SignStatusInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSignStatusRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = MessageApi.SIGN_STATUS
      request.method = http.RequestMethod.GET

      request.addHeader(['AccessToken'], [token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<SignStatusInfo> = JSON.parse(json)
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