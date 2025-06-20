/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: WebConfig
 * Author: Victor
 * Date: 2024/05/13 18:33
 * Description: 
 * -----------------------------------------------------------------
 */

export class WebConfig {
  static readonly DEV_BASE_URL = 'https://dev.cloud.hokkj.cn/' //app开发环境
  static readonly TEST_BASE_URL = 'https://test.cloud.hokkj.cn/' //app测试环境
  static readonly BETA_BASE_URL = 'https://beta.cloud.hokkj.cn/' //app beta环境
  static readonly ONLINE_BASE_URL = 'https://cloud.hokkj.cn/' //app线上环境

  static readonly H5_DEV_BASE_URL = 'https://dev.h5.hokkj.cn/' //app 内使用的 h5 开发环境
  static readonly H5_TEST_BASE_URL = 'https://test.h5.hokkj.cn/' //app 内使用的 h5 测试环境
  static readonly H5_BETA_BASE_URL = 'https://beta.h5.hokkj.cn/' //app 内使用的 h5 beta环境
  static readonly H5_ONLINE_BASE_URL = 'https://h5.hokkj.cn/' //app 内使用的 h5 线上环境

  static readonly MODEL_DEV = 0
  static readonly MODEL_TEST = 1
  static readonly MODEL_BETA = 2
  static readonly MODEL_ONLINE = 3
  static readonly BUILD_MODEL: number = WebConfig.MODEL_ONLINE

  static readonly PAGE_SIZE: number = 20

  getBaseUrl(): string {
    let baseUrl = WebConfig.DEV_BASE_URL
    switch(WebConfig.BUILD_MODEL) {
      case WebConfig.MODEL_TEST: {
        baseUrl = WebConfig.TEST_BASE_URL
        break;
      }
      case WebConfig.MODEL_BETA: {
        baseUrl = WebConfig.BETA_BASE_URL
        break;
      }
      case WebConfig.MODEL_ONLINE: {
        baseUrl = WebConfig.ONLINE_BASE_URL
        break;
      }
      default: {
        baseUrl = WebConfig.DEV_BASE_URL
        break;
      }
    }
    return baseUrl
  }

  getH5BaseUrl(): string {
    let baseUrl = WebConfig.H5_DEV_BASE_URL
    switch(WebConfig.BUILD_MODEL) {
      case WebConfig.MODEL_TEST: {
        baseUrl = WebConfig.H5_TEST_BASE_URL
        break;
      }
      case WebConfig.MODEL_BETA: {
        baseUrl = WebConfig.H5_BETA_BASE_URL
        break;
      }
      case WebConfig.MODEL_ONLINE: {
        baseUrl = WebConfig.H5_ONLINE_BASE_URL
        break;
      }
      default: {
        baseUrl = WebConfig.H5_DEV_BASE_URL
        break;
      }
    }
    return baseUrl
  }

  getTopicUrl(skipText?: string): String {
    let topicUrl = `${this.getH5BaseUrl()}pageGenerator/${skipText}?deviceFrom=1`
    return topicUrl
  }
}

export default new WebConfig()