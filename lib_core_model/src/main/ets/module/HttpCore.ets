/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HttpCore
 * Author: Victor
 * Date: 2024/05/13 18:03
 * Description: 
 * -----------------------------------------------------------------
 */
import Request from './Request'
import Logger from '../util/Logger'
import { http } from '@kit.NetworkKit'
import { Response } from './Response'
import { JSONUtils } from '../util/JSONUtils'
import AppConfig from '../util/AppConfig'
import App from '../App'
import RouterPath from '../util/RouterPath'
import { router } from '@kit.ArkUI'
import { request } from '@kit.BasicServicesKit'
import { UploadingState } from './UploadingState'
import { UploadResponse } from './UploadResponse'
import UploadImgRequest from './UploadImgRequest'
import { UploadUrlInfo } from './UploadUrlInfo'

class HttpCore {
  private TAG = 'HttpCore'

  async send(request: Request) {
    Logger.error(this.TAG,'------------------------------ request ------------------------------')
    Logger.error(this.TAG,`request-requestUrl = ${request.getRequestUrl()}`)
    Logger.error(this.TAG,`request-method = ${request.method}`)
    Logger.error(this.TAG,`request-query = ${request.query}`)
    Logger.error(this.TAG,`request-header = ${ JSONUtils.mapToJson(request.header)}`)
    Logger.error(this.TAG,`request-body = ${ JSON.stringify(request.body)}`)

    console.log('HttpRequest-header = ' + JSON.stringify(request.buildOptions().header));
    let httpRequest = http.createHttp()
    let result = httpRequest.request(request.getRequestUrl(), request.buildOptions())
    return result.then((data:http.HttpResponse) =>{
      Logger.error(this.TAG,'------------------------------ response ------------------------------')
      Logger.error(this.TAG,`response-url = ${request.getRequestUrl()}`)
      Logger.error(this.TAG,`response-responseCode = ${data.responseCode}`)
      Logger.error(this.TAG,`response-result = ${JSON.stringify(data.result)}`)

      let reponse = new Response()
      if (data.responseCode === http.ResponseCode.OK) {
        reponse = JSON.parse(data.result.toString())
        if (reponse.code == 1) {
          return reponse
        } else {
          if (reponse.code == 2001 || reponse.code == 2002 || reponse.code == 2003) {
            // 登录失效清除缓存登录数据进入登录页面
            AppConfig.reSetLoginData()
            Logger.error(`handleError-token is null or has expired will to login...`)
            App.get().backOtherThenMainPage()
            App.get().pushUrl({
              url: RouterPath.CODE_LOGIN_PAGE
            }, router.RouterMode.Single)
          }
          reponse.code = data.responseCode
          reponse.message = reponse.msg
        }
        return reponse
      } else {
        reponse.code = data.responseCode
        reponse.message = '服务器开小差了,请稍后重试!'
        return reponse
      }
    })
  }

  async upload(context: Context,uploadRequest: UploadImgRequest): Promise<Response> {
    Logger.error(this.TAG,'------------------------------ request ------------------------------')
    Logger.error(this.TAG,`request-requestUrl = ${uploadRequest.getRequestUrl()}`)
    Logger.error(this.TAG,`request-url = ${uploadRequest.url}`)
    Logger.error(this.TAG,`request-header = ${ JSON.stringify(uploadRequest.header)}`)
    Logger.error(this.TAG,`request-uploadPaths = ${ JSON.stringify(uploadRequest.uploadPaths)}`)
    Logger.error(this.TAG,`request-uploadConfig = ${ JSON.stringify(uploadRequest.buildUploadConfig(context))}`)

    let response = new Response()
    let responseList: Array<Response> = []
    let uploadResponseList: Array<UploadResponse> = []
    return new Promise((resolve: Function, reject: Function) => {
      try {
        // Upload the file.
        request.uploadFile(context, uploadRequest.buildUploadConfig(context)).then((uploadTask: request.UploadTask) => {
          Logger.error(this.TAG,'------------------------------ response ------------------------------')
          uploadTask.on(UploadingState.FAIL, (result: Array<request.TaskState>) => {
            Logger.error('uploadFile failed', JSON.stringify(result));
            if (result && result.length >= 1) {
              response.msg = '上传文件失败，请重试！'
              reject(response);
            }
          })
          uploadTask.on(UploadingState.PROGRESS, (uploadedSize: number, totalSize: number) => {
            Logger.error(this.TAG,`upload-uploadedSize = ${uploadedSize}`)
            Logger.error(this.TAG,`upload-uploadedSize = ${totalSize}`)
            // let progress = AmountUtil.getRoundUp(uploadedSize / totalSize * 100,2)
            // Logger.error(this.TAG,`upload-progress = ${progress}%`)
            // this.handleResponse(2,progress,callback)
          })

          uploadTask.on(UploadingState.HEADER_RECEIVE, (headers) => {
            Logger.error(this.TAG,`upload-headerReceive-headers  = ${JSON.stringify(headers)}`);

            let uploadResponse: UploadResponse = JSON.parse(JSON.stringify(headers))
            response = JSON.parse(uploadResponse.body ?? '')
            if (response.code == 1) {
              //上传成功
              Logger.error(this.TAG,`upload-headerReceive-code  = ${response.code}`);
              Logger.error(this.TAG,`upload-headerReceive-data  = ${JSON.stringify(response.data)}`);
              responseList.push(response)
              uploadResponseList.push(uploadResponse)
            } else {
              if (response.code == 2001 || response.code == 2002 || response.code == 2003) {
                // 登录失效清除缓存登录数据进入登录页面
                AppConfig.reSetLoginData()
                Logger.error(`handleError-token is null or has expired will to login...`)
                App.get().backOtherThenMainPage()
                App.get().pushUrl({
                  url: RouterPath.CODE_LOGIN_PAGE
                }, router.RouterMode.Single)
              }
              response.message = response.msg
            }
          })
          
          uploadTask.on(UploadingState.COMPLETE, (result: Array<request.TaskState>) => {
            Logger.error(this.TAG,`uploadFile completed-result = ${JSON.stringify(result)}`);

            if (uploadResponseList.length == 0) {
              response.message = '上传失败'
              Logger.error(this.TAG,'uploadFile completed-上传失败');
            } else {
              const uploadUrlInfo = new UploadUrlInfo()
              if (uploadRequest.isMultiUploadImg()) {
                Logger.error(this.TAG,'uploadFile completed-isMultiUploadImg');
                let urls: Array<string> = []
                uploadResponseList.forEach((value: UploadResponse) => {
                  const itemResponse: Response = JSON.parse(value.body ?? '')
                  const itemJson = JSON.stringify(itemResponse.data)
                  const data: UploadUrlInfo = JSON.parse(itemJson)
                  urls = urls.concat(data.urls ?? [])
                })

                Logger.error(this.TAG,`uploadFile completed-urls = ${JSON.stringify(urls)}`);

                uploadUrlInfo.urls = urls
                response.data = uploadUrlInfo
                if (responseList.length == uploadResponseList.length) {
                  Logger.error(this.TAG,'uploadFile completed-全部上传成功');
                  response.message = '全部上传成功'
                } else {
                  const errorCount = uploadResponseList.length - responseList.length
                  const errorMsg = `成功上传${responseList.length}个失败${errorCount}个`
                  Logger.error(this.TAG,`uploadFile completed-errorMsg = ${errorMsg}`);
                  response.message = errorMsg
                }
              } else {
                Logger.error(this.TAG,'uploadFile completed-single-success');
                const itemResponse: Response = JSON.parse(uploadResponseList[0].body ?? '')
                const itemJson = JSON.stringify(itemResponse.data)
                const data: UploadUrlInfo = JSON.parse(itemJson)
                response.data = data
              }
            }
            Logger.error(this.TAG,`uploadFile completed-response = ${JSON.stringify(response)}`);
            resolve(response)
          });
        }).catch((err: Error) => {
          Logger.error('uploadFile failed', JSON.stringify(err));
          reject(response);
        });
      } catch (err) {
        Logger.error('uploadFile failed', JSON.stringify(err));
        reject(response);
      }
    })
  }

}

export default new HttpCore()
