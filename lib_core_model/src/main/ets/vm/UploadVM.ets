import { UploadApi } from '../api/UploadApi'
import Logger from '../util/Logger'
import { http } from '@kit.NetworkKit'
import HttpCore from '../module/HttpCore'
import { Response } from '../module/Response'
import { UploadUrlInfo } from '../module/UploadUrlInfo'
import UploadImgRequest from '../module/UploadImgRequest'

export default class UploadVM {

  public static sendUploadImgRequest(context: Context,token: string,uploadPaths: Array<string>): Promise<UploadUrlInfo> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUploadImgMultiRequest-token is empty')
        return
      }

      let request = new UploadImgRequest()
      request.url = UploadApi.UPLOAD_IMG
      request.method = http.RequestMethod.POST

      request.addHeader(['AccessToken'],[token])
      request.uploadPaths = uploadPaths

      HttpCore.upload(context,request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: UploadUrlInfo = JSON.parse(json)
            resolve(data)
          } else {
            resolve('')
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendUploadImgMultiRequest(context: Context,token: string,uploadPaths: Array<string>): Promise<UploadUrlInfo> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendUploadImgMultiRequest-token is empty')
        return
      }

      let request = new UploadImgRequest()
      request.url = UploadApi.UPLOAD_IMG_MULTI
      request.method = http.RequestMethod.POST

      request.addHeader(['AccessToken'],[token])
      request.uploadPaths = uploadPaths

      HttpCore.upload(context,request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: UploadUrlInfo = JSON.parse(json)
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