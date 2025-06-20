import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { AuthApi } from '../api/AuthApi'
import http from '@ohos.net.http'
import { Response } from '../module/Response'
import CryptoJS from '@ohos/crypto-js'
import { LoginData } from '../data/LoginData'
import { SmsParm } from '../data/SmsParm'
import Logger from '../util/Logger'
import { ModifyPhoneCodeCheckParm } from '../data/ModifyPhoneCodeCheckParm'
import { ModifyPhoneParm } from '../data/ModifyPhoneParm'

interface CodeLoginParm {
  phone: string,
  code: string
}

interface ActivateSmsParm {
  phone: string
  sign: string
  timeStamp: number
}

export class AuthVM {

  public static sendSmsRequest(phone: string): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = AuthApi.SEND_SMS
      request.method = http.RequestMethod.POST

      let body = new SmsParm()
      body.phone = phone
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

  public static sendActivateSmsRequest(phone: string): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = AuthApi.ACTIVATE_SMS
      request.method = http.RequestMethod.POST
      const currentTimestamp = new Date().getTime()
      const signStr = `phone=${phone}&timeStamp=${currentTimestamp}&key=fad5f43075a752ae3280a3f702c321f7`
      const sign = (CryptoJS.MD5(signStr).toString() as string).toUpperCase()
      const smsParm: ActivateSmsParm = {
        phone: phone,
        sign: sign,
        timeStamp: currentTimestamp
      }
      request.setBody(smsParm)

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

  public static sendVoiceSmsRequest(phone: string): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = AuthApi.VOICE_CODE
      request.method = http.RequestMethod.POST
      const currentTimestamp = new Date().getTime()
      const signStr = `phone=${phone}&timeStamp=${currentTimestamp}&key=fad5f43075a752ae3280a3f702c321f7`
      const sign = (CryptoJS.MD5(signStr).toString() as string).toUpperCase()
      const smsParm: ActivateSmsParm = {
        phone: phone,
        sign: sign,
        timeStamp: currentTimestamp
      }
      request.setBody(smsParm)

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

  public static sendCodeLoginRequest(phone: string, code: string): Promise<LoginData> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = AuthApi.CODE_LOGIN
      request.method = http.RequestMethod.POST
      const smsParm: CodeLoginParm = {
        phone: phone,
        code: code
      }
      request.setBody(smsParm)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          let json = JSON.stringify(response.data)
          let data: LoginData = JSON.parse(json)
          resolve(data)
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendPhoneModifyCountRequest(token: string,phone: string): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {

      if (!token) {
        Logger.error('sendPhoneModifyCountRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AuthApi.PHONE_MODIFY_COUNT
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['phone'],[phone])

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

  public static sendModifyPhoneCodeRequest(token: string,phone: string): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendPhoneModifyCountRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AuthApi.MODIFY_PHONE_CODE
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])

      let body = new SmsParm()
      body.phone = phone
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

  public static sendModifyPhoneCodeCheckRequest(token: string,body: ModifyPhoneCodeCheckParm): Promise<Boolean> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendModifyPhoneCodeRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AuthApi.MODIFY_PHONE_CODE_CHECK
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])

      request.setBody(body)

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          let json = JSON.stringify(response.data)
          let data: Boolean = JSON.parse(json)
          resolve(data)
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendNewPhoneCodeRequest(token: string,phone: string): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendNewPhoneCodeRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AuthApi.NEW_PHONE_CODE
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])

      let body = new SmsParm()
      body.phone = phone
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

  public static sendModifyPhoneRequest(token: string,body: ModifyPhoneParm): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendNewPhoneCodeRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AuthApi.MODIFY_PHONE
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])

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

  public static sendCancelAccountCodeRequest(token: string): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendCancelAccountCodeRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AuthApi.CANCEL_ACCOUNT_CODE
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'],[token])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          let json = JSON.stringify(response.data)
          let data: object = JSON.parse(json)
          resolve(data)
        } else {
          reject(response.code)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendCancelAccountRequest(token: string,code: string): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendCancelAccountRequest-token is empty')
        return
      }

      let request = new Request()
      request.url = AuthApi.CANCEL_ACCOUNT
      request.method = http.RequestMethod.PUT
      request.addHeader(['AccessToken'],[token])
      request.setQueryParams(['code'],[code])

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

  public static sendLogoutRequest(token: string): Promise<object> {
    return new Promise(async (resolve: Function, reject: Function) => {
      const request = new Request()
      request.url = AuthApi.LOGOUT
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'],[token])

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