/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: UploadRequest
 * Author: Victor
 * Date: 2023/11/28 16:36
 * Description: 
 * -----------------------------------------------------------------
 */
import http from '@ohos.net.http'
import { request } from '@kit.BasicServicesKit';
import WebConfig from '../util/WebConfig'
import { ContentType } from './ContentType'
import { HashMap } from '@kit.ArkTS'
import { JSONUtils } from '../util/JSONUtils'
import Logger from '../util/Logger'
import { BusinessError } from '@kit.BasicServicesKit'
import { fileIo } from '@kit.CoreFileKit'
import { UploadApi } from '../api/UploadApi';

export default class UploadImgRequest {
  TIME_OUT = 60000

  url: string = ''
  query: string = ''
  fileUri: string = ''
  method: http.RequestMethod = http.RequestMethod.POST
  header: HashMap<string, string> | null = null
  body: HashMap<string, string | number> | null | object = null
  uploadPaths: Array<string> = []

  constructor() {
    this.header = this.getBaseHeader()
    this.body = {}
  }

  getBaseHeader(): HashMap<string, string> {
    const headerMap = new HashMap<string, string>()
    headerMap.set('Content-Type', 'application/json')
    headerMap.set('VersionCode', 'HARMONEY_1.0.0')
    return headerMap
  }

  addHeader(keys: string[], values: string[]) {
    if (!this.header) {
      this.header = this.getBaseHeader()
    }
    for (let i = 0; i <= keys.length - 1; i++) {
      let key = keys[i]
      let value = values[i]
      this.header?.set(key,value)
    }
  }

  /**
   * get 请求参数拼接
   * @param keys
   * @param values
   */
  setQueryParams(keys: string[], values: string[]) {
    let queryUrl: string = '?'
    for (let i = 0; i <= keys.length - 1; i++) {
      let key = keys[i]
      let value = values[i]
      if (key != null && value != null) {
        if (i === keys.length - 1) {
          queryUrl += `${key}=${value}`
        } else {
          queryUrl += `${key}=${value}&`
        }
      }
    }
    this.query += queryUrl
  }

  setPathParams(values: string[]) {
    let queryUrl: string = ''
    for (let i = 0; i <= values.length - 1; i++) {
      let value = values[i]

      if (value != null) {
        if (i === values.length - 1) {
          queryUrl += `${value}`
        } else {
          queryUrl += `${value}/`
        }
      }
    }
    this.query += queryUrl
  }

  /**
   * post 请求 body 参数设置
   * @param keys
   * @param values
   */
  setBodyParams(keys: string[], values: string[]) {
    let result = new HashMap<string, string>()
    for (let i = 0; i <= keys.length - 1; i++) {
      let key = keys[i]
      let value = values[i]
      if (i === keys.length - 1) {
        result[key] = value
      }
    }
    this.body = result
  }

  /**
   * post 请求 body 参数设置
   * @param keys
   * @param values
   */
  setBody(extraData: Object) {
    this.body = extraData
  }

  getRequestUrl(): string {
    if (this.query) {
      return `${WebConfig.getBaseUrl()}${this.url}${this.query}`
    }
    return `${WebConfig.getBaseUrl()}${this.url}`
  }

  buildOptions(): http.HttpRequestOptions {
    let options: http.HttpRequestOptions = {
      readTimeout: this.TIME_OUT,
      connectTimeout: this.TIME_OUT,
      method: this.method,
      header: JSON.parse(JSONUtils.mapToJson(this.header)),
      extraData: JSON.stringify(this.body)
    }
    return options
  }

  buildUploadConfig(context: Context): request.UploadConfig {
    let files: Array<request.File> = []
    let datas: Array<request.RequestData> = []
    const uploadParmKey = this.getUploadParmKey()

    // Obtaining the Application File Path.
    for (let i = 0; i <= this.uploadPaths.length - 1; i++) {
      let path = this.uploadPaths[i]
      const imgName = path.split('/').pop() + '.jpg';
      files.push(this.copyFile2Cache(context,path,uploadParmKey))
      datas.push(this.getUploadRequestData(imgName,uploadParmKey))
    }

    let uploadConfig: request.UploadConfig = {
      url: this.getRequestUrl(),
      header: {
        'Content-Type': ContentType.FORM
      },
      method: http.RequestMethod.POST,
      files: files,
      data: datas
    }

    return uploadConfig
  }

  copyFile2Cache(context: Context,path: string,uploadParmKey: string): request.File {
    const cacheDir = context.cacheDir
    const imgName = path.split('/').pop() + '.jpg';
    const dstPath = cacheDir + '/' + imgName;
    try {
      Logger.error('copyFile2Cache','cacheDir = ' + cacheDir)
      Logger.error('copyFile2Cache','imgName = ' + imgName)
      Logger.error('copyFile2Cache','dstPath = ' + dstPath)
      // Copy the URI to the cacheDir directory and upload the file.
      const srcFile = fileIo.openSync(path);
      const dstFile = fileIo.openSync(dstPath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      fileIo.copyFileSync(srcFile.fd, dstFile.fd);
      fileIo.closeSync(srcFile);
      fileIo.closeSync(dstFile);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`copyFile2Cache-failed, code is ${err.code}, message is ${err.message}`);
    }

    let file: request.File = {
      filename: imgName,
      name: uploadParmKey,
      uri: 'internal://cache/' + imgName,
      type: 'jpg'
    }

    return file
  }

  getUploadRequestData(fileName: string,uploadParmKey: string): request.RequestData {
    let requestData: request.RequestData = {
      name:uploadParmKey,
      value:`${fileName}`
    }
    return requestData
  }

  getUploadParmKey(): string {
    if (this.isMultiUploadImg()) {
      return 'files'
    }
    return 'file'
  }

  isMultiUploadImg(): boolean {
    return this.url == UploadApi.UPLOAD_IMG_MULTI
  }

}
