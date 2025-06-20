/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: Request
 * Author: Victor
 * Date: 2024/05/13 18:04
 * Description: 
 * -----------------------------------------------------------------
 */
import { http } from '@kit.NetworkKit'
import { HashMap } from '@kit.ArkTS'
import WebConfig from '../util/WebConfig'
import { JSONUtils } from '../util/JSONUtils'
import Logger from '../util/Logger'

export default class Request {
  TIME_OUT = 60000
  url: string = ''
  query: string = ''
  method: http.RequestMethod = http.RequestMethod.GET
  header: HashMap<string, string> | null = null
  body: HashMap<string, string | number> | null | object = null

  constructor() {
    this.header = this.getBaseHeader()
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
  setBody(extraData: HashMap<string, string | number> | object) {
    this.body = extraData
  }

  getRequestUrl(): string {
    if (this.query) {
      return encodeURI(`${WebConfig.getBaseUrl()}${this.url}${this.query}`)
    }
    return encodeURI(`${WebConfig.getBaseUrl()}${this.url}`)
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
}