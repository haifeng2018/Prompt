/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AdActionUtil
 * Author: Victor
 * Date: 2023/12/22 14:32
 * Description: 
 * -----------------------------------------------------------------
 */
import App from 'lib_core_model/src/main/ets/App'
import { AdInfo } from 'lib_core_model/src/main/ets/data/AdInfo'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import WebConfig from 'lib_core_model/src/main/ets/util/WebConfig'
import CourseDetailActionUtil from './CourseDetailActionUtil'

class AdActionUtil {

  /**
   * @param data 跳转类型 1.课程详情 2.课程分类 3.网页 4.微信小程序 5.抖音小程序 6.推广页 7.专题页调课程详情
   */
  toPage(data: AdInfo) {
    Logger.error('AdActionUtil','toPage-data?.adTitle = ' + data?.adTitle)
    Logger.error('AdActionUtil','toPage-data?.skipType = ' + data?.skipType)
    Logger.error('AdActionUtil','toPage-data?.skipText = ' + data?.skipText)
    Logger.error('AdActionUtil','toPage-data?.url = ' + data?.url)
    switch (data?.skipType) {
      case 1: //课程详情
        CourseDetailActionUtil.courseDetail(data?.tenantId ?? 0,data.onlineFlag, data?.skipText,0)
        break
      case 2: //课程分类
      case 8: //课程分类
        App.get().pushUrl({
          url: RouterPath.COURSE_CATEGORY_PAGE,
          params: {
            tenantId: data?.tenantId,
            data: data?.skipText
          }
        })
        break
      case 3: //网页
        App.get().pushUrl({
          url: RouterPath.WEB_PAGE,
          params: {
            title: data?.adTitle,
            url: data?.skipText
          }
        })
        break
      case 4: //微信小程序
        //AppUtil.launchApplet(activity, HashMap())
        break
      case 5: //抖音小程序
        break
      case 6: //推广页
        break
      case 7: //专题页调课程详情
        App.get().pushUrl({
          url: RouterPath.WEB_PAGE,
          params: {
            title: data?.adTitle,
            url: WebConfig.getTopicUrl(data?.skipText)
          }
        })
        break
    }
  }

}

export default new AdActionUtil()