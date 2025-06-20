/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: GoodsShowUtil
 * Author: Victor
 * Date: 2023/11/17 19:15
 * Description: 
 * -----------------------------------------------------------------
 */
import fs from '@ohos.file.fs'
import { CartDiscountInfo } from 'lib_core_model/src/main/ets/data/CartDiscountInfo'
import { ColumnInfo } from 'lib_core_model/src/main/ets/data/ColumnInfo'
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo'
import { CourseAssureInfo } from 'lib_core_model/src/main/ets/data/CourseAssureInfo'
import { CourseCategoryInfo } from 'lib_core_model/src/main/ets/data/CourseCategoryInfo'
import { CoverUrlExtendInfo } from 'lib_core_model/src/main/ets/data/CoverUrlExtendInfo'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { GoodsSpecInfo } from 'lib_core_model/src/main/ets/data/GoodsSpecInfo'
import { LearningInfo } from 'lib_core_model/src/main/ets/data/LearningInfo'
import { LecturerInfo } from 'lib_core_model/src/main/ets/data/LecturerInfo'
import { NotificationExtraInfo } from 'lib_core_model/src/main/ets/data/NotificationExtraInfo'
import { NotificationInfo } from 'lib_core_model/src/main/ets/data/NotificationInfo'
import { OfflineVideoInfo } from 'lib_core_model/src/main/ets/data/OfflineVideoInfo'
import { OrderInfo } from 'lib_core_model/src/main/ets/data/OrderInfo'
import { SignStatusInfo } from 'lib_core_model/src/main/ets/data/SignStatusInfo'
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo'
import { SummaryStudyData } from 'lib_core_model/src/main/ets/data/SummaryStudyData'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import AmountUtil from './AmountUtil'

class GoodsShowUtil {
  TAG = 'GoodsShowUtil'

  //0:图片,1:音频，2视频,3专栏，4大专栏,5线下课程
  getCourseType(goodsType?: number, onlineFlag?: number): string {
    let type = ''
    if (onlineFlag == 1) {
      type = '线下'
      return type
    }
    switch (goodsType) {
      case 0: {
        type = '图文'
        break
      }
      case 1: {
        type = '音频'
        break
      }
      case 2: {
        type = '视频'
        break
      }
      case 3: {
        type = '专栏'
        break
      }
      case 4: {
        type = '大专栏'
        break
      }
      case 5: {
        type = '线下'
        break
      }
      default: {
        type = '视频'
        break
      }
    }
    return type
  }

  getOutlineMin(sec: number): string {
    if (sec > 60) {
      let mins = sec / 60
      return `${Math.trunc(mins)}分钟`
    }
    return '1分钟'
  }

  getOutlineTypeDuration(data?: ColumnInfo, onlineFlag?: number): string {
    let type = this.getCourseType(data?.goodsType, onlineFlag)

    let duration = this.getOutlineMin(data?.materialDes ?? 0)

    return `${type} 时长 ${duration}`
  }

  /**
   * 获取显示评分
   */
  getGoodsScoreTxt(goodsScore: number): string {
    const score = goodsScore ?? 0
    if (score === 0) {
      return "0分"
    }
    return `${score / 10}分`
  }

  /**
   * 获取显示人气
   */
  getGoodsPopularityTxt(goodsPopularity: number): string {

    if (goodsPopularity == 0) {
      return `0`
    }
    if (goodsPopularity <= 10000) { //小于1万
      return `${goodsPopularity}`
    }
    if (goodsPopularity <= 1000000) { //大于1万，小于100万
      return `${AmountUtil.getRoundUp(goodsPopularity / 10000, 2)}w`
    }
    if (goodsPopularity <= 1000000000) { //大于100万，小于10亿
      return `${AmountUtil.getRoundUp(goodsPopularity / 10000, 2)}w`
    }

    return "10亿"
  }

  getSaleCountText(salesVolume: number): string {
    let salesCount = ""
    if (salesVolume == 0) {
      return salesCount
    }
    if (salesVolume >= 1 && salesVolume < 9999) {
      return `销量${salesVolume}`
    }
    if (salesVolume >= 10000 && salesVolume < 9999999) {
      return `销量${(salesVolume / 10000).toFixed()}万+`
    }
    if (salesVolume > 10000000) {
      return `销量${(salesVolume / 10000000).toFixed()}千万+`
    }
    return salesCount
  }

  getStudyProgress(learningType: number, learningRate: number): string {
    let studyProgress = ''
    switch (learningType) {
      case 1: {
        studyProgress = '还未开始学习'
        break
      }
      case 2: {
        studyProgress = `已学${learningRate}%`
        break
      }
      case 3: {
        studyProgress = '已学完'
        break
      }
    }
    return studyProgress
  }

  getLessonLabel(data: LearningInfo): string {
    let lesson = 0
    if (data.goodsMode === 0 || data.withVideo) {
      lesson = data?.lesson ?? 0
      return `共${lesson}节`
    }
    if (data.goodsMode === 1 && !data.withVideo) {
      return data.specName || ''
    }
    return ''
  }

  getStudyOpacity(data: LearningInfo): number {
    if (data.goodsMode === 0) {
      return 1
    }
    if (data.goodsMode === 1 && data.withVideo) {
      return 1
    }
    return 0
  }

  getCouponType(discountMethod: number): string {
    let couponType = ''
    switch (discountMethod) {
      case 1: {
        couponType = '满减'
        break
      }
      case 2: {
        couponType = '直减'
        break
      }
      case 3: {
        couponType = '折扣'
        break
      }
    }
    return couponType
  }

  getFirstLecturerName(lecturers: Array<LecturerInfo>): string {
    let lecturerName = ''
    if (lecturers) {
      if (lecturers.length > 0) {
        lecturerName = lecturers?.[0].lecturerName ?? ''
      }
    }
    return lecturerName
  }

  getFirstLecturerLabel(lecturers?: Array<LecturerInfo>): string {
    let lecturerLabel = ''
    if (lecturers) {
      if (lecturers.length > 0) {
        lecturerLabel = lecturers?.[0].lecturerLabel ?? ''
      }
    }
    return lecturerLabel
  }

  getOrderRecommendFirstLecturerLabel(lecturers?: string): string {
    let lecturerLabel = lecturers ?? ''
    if (lecturers?.includes(';')) {
      lecturerLabel = lecturers?.split(';')?.[0]
    }
    return lecturerLabel
  }

  getCouponTitle(data: CartDiscountInfo): string {
    let couponTitle = ''
    switch (data?.discountMethod) {
      case 1: {
        let fullAmount = data?.fullAmount ?? 0
        let fullAmountStr = (fullAmount / 100.0).toFixed(2)

        let fullDiscountAmount = data?.fullDiscountAmount ?? 0
        let fullDiscountAmountStr = (fullDiscountAmount / 100.0).toFixed(2)

        couponTitle = `满${fullAmountStr}元减${fullDiscountAmountStr}元`
        break
      }
      case 2: {
        let directDiscountAmount = data?.directDiscountAmount ?? 0
        let directDiscountAmountStr = (directDiscountAmount / 100.0).toFixed(2)

        couponTitle = `购买立减${directDiscountAmountStr}元`
        break
      }
      case 3: {
        couponTitle = `购买立享${data?.discountContent}折`
        break
      }
    }
    return couponTitle
  }

  getTodayStudyTime(data: SummaryStudyData): string {
    if (data == null) {
      return '0分钟'
    }
    return `${this.getStudyHour(data?.todayAccumulated ?? 0)}${this.getStudyMin(data?.todayAccumulated ?? 0)}`
  }

  getTotalStudyTime(data: SummaryStudyData): string {
    if (data == null) {
      return '0分钟'
    }
    return `${this.getStudyHour(data.totalAccumulated ?? 0)}${this.getStudyMin(data.totalAccumulated ?? 0)}`
  }

  /**
   * 学习时间 小时
   * @param learningTime 单位：秒
   */
  getStudyHour(learningTime: number): string {

    let hours = learningTime / 60 / 60
    if (hours > 0) {
      return `${Math.trunc(hours)}小时`
    }
    return ""
  }

  /**
   * 学习时间 分钟
   * @param learningTime 单位：秒
   */
  getStudyMin(learningTime: number): string {
    let hours = Math.trunc(learningTime / 60 / 60)
    let mins = (learningTime - hours * 60 * 60) / 60
    if (mins > 0) {
      return `${Math.trunc(mins)}分钟`
    } else {
      if (hours < 1) {
        return "0分钟"
      }
    }
    return ''
  }

  getLecturerLabelList(lecturerLabel: string): Array<string> {
    Logger.error('getLecturerLabelList-lecturerLabel = ' + lecturerLabel)
    let labels = Array<string>()
    if (lecturerLabel) {
      let searchCount = lecturerLabel.search(';')
      Logger.error('getLecturerLabelList-searchCount = ' + searchCount)
      if (searchCount > 0) {
        let labs = lecturerLabel.split(';')
        for (let i = 0; i < labs.length; i++) {
          labels.push(labs[i])
        }
      } else {
        labels.push(lecturerLabel)
      }
    }
    Logger.error('getLecturerLabelList-length = ' + labels.length)
    return labels
  }

  getShouldPayAmt(data?: OrderInfo): string {
    let price = data?.payerTotal ?? 0
    if (price === 0) {
      price = data?.goodsTotalFee ?? 0
    }
    return AmountUtil.getRoundUp(price / 100, 2)
  }

  getOrderGoodsAmt(data: SubOrderInfo): string {
    let price = data?.payerTotal ?? 0
    if (price === 0) {
      price = data?.goodsTotalFee ?? 0
    }
    return AmountUtil.getRoundUp(price / 100, 2)
  }

  /**
   * 我的订单-去学习 是否显示
   * @param data
   * @returns
   */
  getGoStudyVisibility(data?: OrderInfo): Visibility {
    const goodsMode = data?.subOrderVos?.[0]?.goodsMode
    const withVideo = data?.subOrderVos?.[0]?.withVideo
    const hasChangePermission = data?.subOrderVos?.[0]?.hasChangePermission ?? false
    const balanceFee = data?.subOrderVos?.[0]?.balanceFee ?? 0

    if (goodsMode === 0 && data?.orderStatus != 12 && !hasChangePermission && balanceFee != 0) {
      return Visibility.Visible
    }
    if (goodsMode === 1 && withVideo && data?.orderStatus != 12 && !hasChangePermission && balanceFee != 0) {
      return Visibility.Visible
    }
    return Visibility.None
  }

  /**
   * 我的订单-发票服务 是否显示
   * @param data
   * @returns
   */
  getInvoiceVisibility(data?: OrderInfo): Visibility {
    const isShowInvoiceButton = data?.isShowInvoiceButton ?? false
    if (isShowInvoiceButton) {
      return Visibility.Visible
    }
    return Visibility.None
  }

  getMoreVisibility(data?: OrderInfo): Visibility {
    if (this.getEvaluateVisibility(data) === Visibility.Visible
      || this.getAfterSaleVisibility(data) === Visibility.Visible) {
      return Visibility.Visible
    }
    return Visibility.None
  }

  /**
   * 我的订单-物流服务 是否显示
   * @param data
   * @returns
   */
  getLogisticsVisibility(data?: OrderInfo): Visibility {
    const isShowLogistics = data?.isShowLogistics ?? false
    if (isShowLogistics) {
      return Visibility.Visible
    }
    return Visibility.None
  }

  /**
   * 我的订单-评价 是否显示
   * @param data
   * @returns
   */
  getEvaluateVisibility(data?: OrderInfo): Visibility {
    let evaluateVisibility = Visibility.None
    switch (data?.orderStatus) {
      case 1:
      case 3:
      case 4:
      case 7:
      case 8:
      case 9:
        evaluateVisibility = Visibility.None
        break
      case 2:
      case 5:
      case 6:
      case 10:
      case 11:
      case 12:
      case 13:
        const subOrderInfo = data?.subOrderVos?.[0]
        const commentFlag = subOrderInfo?.commentFlag ?? false
        if (commentFlag) {
          evaluateVisibility = Visibility.None
        } else {
          evaluateVisibility = Visibility.Visible
        }
        break
      default:
        evaluateVisibility = Visibility.None
        break
    }
    return evaluateVisibility
  }

  /**
   * 我的订单-售后服务 是否显示
   * @param data
   * @returns
   */
  getAfterSaleVisibility(data?: OrderInfo): Visibility {
    let afterSaleVisibility = Visibility.None
    switch (data?.orderStatus) {
      case 1:
      case 3:
      case 4:
      case 9:
        afterSaleVisibility = Visibility.None
        break
      case 2:
      case 5:
      case 6:
      case 7:
      case 8:
      case 10:
      case 11:
      case 12:
      case 13:
        const channelSource = data?.channelSource ?? 0
        const paymentType = data?.paymentType ?? 0
        const transferParentOrderNo = data?.transferParentOrderNo
        const subOrderInfo = data?.subOrderVos?.[0]
        const payerTotal = subOrderInfo?.payerTotal ?? 0
        const balanceFee = subOrderInfo?.balanceFee ?? 0

        if (channelSource === 3 && payerTotal > 0 && paymentType != 6
          && !transferParentOrderNo && balanceFee > 0) {
          afterSaleVisibility = Visibility.Visible
        } else {
          afterSaleVisibility = Visibility.None
        }
        break
      default:
        afterSaleVisibility = Visibility.None
        break
    }
    return afterSaleVisibility
  }

  getCourseByCount(subOrderVos?: Array<SubOrderInfo>, count?: number): Array<SubOrderInfo> {
    let courseList = Array<SubOrderInfo>()
    let total = subOrderVos?.length ?? 0
    if (total === 0) {
      return courseList
    }
    let realCount = Math.min(total, count ?? 0)
    courseList = subOrderVos?.slice(0, realCount) ?? new Array<SubOrderInfo>()
    return courseList
  }

  getInvoiceImageByCount(images?: Array<string>, count?: number): Array<string> {
    let imgList = Array<string>()
    let total = images?.length ?? 0
    if (total === 0) {
      return imgList
    }
    let realCount = Math.min(total, count ?? 0)
    imgList = images?.slice(0, realCount) ?? new Array<string>()
    return imgList
  }

  getOutlineByCount(data?: GoodsInfo | null | undefined, count?: number): Array<ColumnInfo> {
    let outlineList = Array<ColumnInfo>()
    let total = data?.columnParentVos?.length ?? 0
    if (total === 0) {
      return outlineList
    }
    if (data?.goodsType === 4) {
      let list = Array<ColumnInfo>()
      data.columnParentVos?.forEach(value => {
        list = [...list, ...value.columnVos || []]
      })
      let realCount = Math.min(list.length, count ?? 0)
      outlineList = list.slice(0, realCount) ?? []
    } else {
      let realCount = Math.min(total, count ?? 0)
      outlineList = data?.columnParentVos?.slice(0, realCount) ?? []
    }

    return outlineList
  }

  getMsgType(data: NotificationInfo): string {
    let msgType = ''
    switch (data?.msgType) {
      case 1: {
        msgType = '通知'
        break
      }
      case 2: {
        msgType = '交易'
        break
      }
      case 3: {
        msgType = '优惠'
        break
      }
    }
    return msgType
  }

  getMsgDetailTitle(data: NotificationInfo): string {
    let title = ''
    let parseObject: NotificationExtraInfo = JSON.parse(data?.extraParams ?? '')
    switch (parseObject?.redirectPage) {
      case '3': {
        title = '查看售后'
        break
      }
      case '6': {
        title = '查看订单'
        break
      }
    }
    return title
  }

  getMsgSignStatusOpacity(signStatusList: Array<SignStatusInfo>, pagePosition: number): boolean {
    let listCount = signStatusList?.length | 0
    if (listCount === 0) {
      return false
    }
    let msgType = 0
    switch (pagePosition) {
      case 0: {
        msgType = 0
        break
      }
      case 1: {
        msgType = 2
        break
      }
      case 2: {
        msgType = 3
        break
      }
      case 3: {
        msgType = 1
        break
      }
    }

    let signStatus: number = 0
    signStatusList.forEach((value, index) => {
      if (value?.msgType === msgType) {
        signStatus = value.signStatus ?? 0
      }
    })
    return signStatus == 1
  }

  getCategoryIndex(courseCategoryList: Array<CourseCategoryInfo>, catalogueId: string): number {
    Logger.error(this.TAG, "getCourseCategoryIndex()")
    let count = courseCategoryList?.length | 0
    Logger.error(this.TAG, "getCourseCategoryIndex()-count = " + count)
    let index = 0
    if (count === 0) {
      return index
    }
    index = courseCategoryList.findIndex(item => item.catalogueId === catalogueId)
    Logger.error(this.TAG, "getCourseCategoryIndex()-index = " + index)
    return index
  }

  getCategoryIndexs(courseCategoryList: Array<CourseCategoryInfo>, catalogueId?: string): Array<number> {
    Logger.error(this.TAG, "getCourseCategoryIndex()")
    let count = courseCategoryList?.length | 0
    Logger.error(this.TAG, "getCourseCategoryIndex()-count = " + count)

    let categoryIndex = 0
    let subCategoryIndex = 0
    let indexs = [0, 0]
    if (count === 0) {
      return indexs
    }
    categoryIndex = courseCategoryList.findIndex(item => item.catalogueId === catalogueId)

    if (categoryIndex >= 0) {
      let subList = courseCategoryList[categoryIndex].catalogueListVos
      subCategoryIndex = subList?.findIndex(item => item.catalogueId === catalogueId) ?? 0
      if (subCategoryIndex >= 0) {
        indexs = [categoryIndex, subCategoryIndex]
      } else {
        indexs = [categoryIndex, 0]
      }
    } else {
      courseCategoryList.forEach((data, index) => {
        let subIndex = data.catalogueListVos?.findIndex(item => item.catalogueId === catalogueId) ?? 0
        if (subIndex >= 0) {
          categoryIndex = index
          subCategoryIndex = subIndex
          indexs = [categoryIndex, subCategoryIndex]
        }
      })
    }
    Logger.error(this.TAG, "getCourseCategoryIndex()-categoryIndex = " + categoryIndex)
    Logger.error(this.TAG, "getCourseCategoryIndex()-subCategoryIndex = " + subCategoryIndex)
    Logger.error(this.TAG, "getCourseCategoryIndex()-indexs = " + indexs)
    return indexs
  }

  getGoodsAssureTxt(onlineFlag: number, postSaleType: number): string {
    return `${postSaleType === 1 ? '购买7天内未学满30分钟可退' : '不支持退款'}${onlineFlag === 0 ? '· 高清视频' : ''}`
  }

  getCouponStart(data: CouponInfo): string {
    let start = ''
    //1:满减，2:直减，3:折扣
    switch (data?.discountMethod) {
      case 1:
        start = '领券满'
        break
      case 2:
        start = '领券立减'
        break
      case 3:
        start = '领券立享'
        break
    }
    return start
  }

  getCouponValue(data: CouponInfo): string {
    let value = ''
    //1:满减，2:直减，3:折扣
    switch (data?.discountMethod) {
      case 1:
        value = AmountUtil.getRoundUpNoZero((data?.fullAmount ?? 0) / 100, 2)
        break
      case 2:
        value = AmountUtil.getRoundUpNoZero((data?.directDiscountAmount ?? 0) / 100, 2)
        break
      case 3:
        value = data?.discountContent ?? ''
        break
    }
    return value
  }

  getCouponUnit(data: CouponInfo): string {
    let value = ''
    //1:满减，2:直减，3:折扣
    switch (data?.discountMethod) {
      case 1:
        value = '元减'
        break
      case 2:
        value = '元'
        break
      case 3:
        value = '折'
        break
    }
    return value
  }

  getCouponEnd(data: CouponInfo): string {
    let value = ''
    //1:满减，2:直减，3:折扣
    switch (data?.discountMethod) {
      case 1:
        value = `${AmountUtil.getRoundUpNoZero((data?.fullDiscountAmount ?? 0) / 100, 2)}元`
        break
      case 2:
        value = ''
        break
      case 3:
        value = ''
        break
    }
    return value
  }

  getCourseEvaluateUrl(data?: string): Array<string> {
    if (data === undefined) {
      return []
    }
    let urls: Array<string> = JSON.parse(data)
    return urls
  }

  getPostUrl(data?: Array<CoverUrlExtendInfo>): Array<string> {
    if (data?.length === 0) {
      return []
    }
    const urls = Array<string>()
    data?.forEach(value => {
      urls.push(value.big ?? '')
    })
    return urls
  }

  getGoodsAssureTipList(onlineFlag: number, postSaleType: number): Array<CourseAssureInfo> {
    let assureList = Array<CourseAssureInfo>()

    let item1 = new CourseAssureInfo()
    if (postSaleType == 1) {
      item1.assureIconResId = $r('app.media.ic_refund_7days')
      item1.assureTitle = "购买7天内未学可退"
      item1.assureContent = "购买后7天内并且课程内容播放不满30分钟的情况支持全额退款，购买无忧"
    } else {
      item1.assureIconResId = $r('app.media.ic_refund_not_support')
      item1.assureTitle = "不支持退款"
      item1.assureContent = "支付成功后不支持退款"
    }
    assureList.push(item1)

    if (onlineFlag == 0) {
      let item2 = new CourseAssureInfo()
      item2.assureIconResId = $r('app.media.ic_hd_video')
      item2.assureTitle = "高清视频"
      item2.assureContent = "学习截止日期前无限次观看高清视频"
      assureList.push(item2)
    }

    let item3 = new CourseAssureInfo()
    item3.assureIconResId = $r('app.media.ic_consumer_protection_services')
    item3.assureTitle = "消费者保障服务"
    item3.assureContent = "如商品有质量问题、描述不符等情况，您有权申请退货退款"
    assureList.push(item3)

    return assureList
  }

  getCurriculumType(curriculumType: number): string {
    let couponType = ''
    switch (curriculumType) {
      case 1: {
        couponType = '基础课'
        break
      }
      case 2: {
        couponType = '进阶课'
        break
      }
      case 3: {
        couponType = '长期班'
        break
      }
      case 4: {
        couponType = '讲座'
        break
      }
    }
    return couponType
  }

  getLecturerNames(data: Array<LecturerInfo>): string {
    if (data?.length === 0) {
      return ''
    }
    let names = ''
    data.forEach((value, index) => {
      if (index == data?.length - 1) {
        names += value.lecturerName
      } else {
        names += value.lecturerName + '、'
      }
    })
    return names
  }

  /**
   * 将富文本保存到本地沙箱html文件中，提供沙箱URL给webview使用
   * @param content
   * @returns
   */
  getCourseDetailHtmlUrl(content?: string): string {
    let html = `<!-- index.html -->\n<!DOCTYPE html>\n<html>\n<body>\n${content}\n</body>\n</html>`

    let path = getContext(this).filesDir + "/index.html"
    let write = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    let ret = fs.writeSync(write.fd, html)

    return 'file://' + path
  }

  getCourseDetailAmount(data?: GoodsInfo): string {
    let salePrice = data?.salePrice ?? 0
    return (salePrice / 100).toFixed(2)
  }

  getCourseDetailMarketPriceToFixed(data?: GoodsInfo): string {
    let marketPrice = data?.marketPrice ?? 0
    return (marketPrice / 100).toFixed(2)
  }

  getCourseDetailMarketPrice(data?: GoodsInfo): number {
    let marketPrice = data?.marketPrice ?? 0
    Logger.info(this.TAG, `marketPrice = ${marketPrice}`)
    return marketPrice
  }

  getCourseDetailLessonUpdate(data?: GoodsInfo): string {
    let lesson = data?.lesson ?? 0
    let classHour = data?.classHour ?? 0
    let validityDays = data?.validityDays ?? 0

    return `购买后${validityDays}天内有效，已更新${lesson}/${classHour}课时`
  }

  /**
   * 线下课程学习页（有视频播放）时长
   */
  getOfflineVideoTime(data: OfflineVideoInfo) {
    let sec = data.duration ?? 0
    let durationStr = `${(sec / 60).toFixed()}分钟`
    if (sec < 60) {
      durationStr = '1分钟'
    }
    return `${this.getCourseType(data.goodsType)} 时长 ${durationStr}`
  }

  getOfflineCoursePrice(mGoodsInfo: GoodsInfo) {
    let length = mGoodsInfo?.specVos?.length ?? 0
    let list = mGoodsInfo?.specVos?.sort(
      (a: GoodsSpecInfo, b: GoodsSpecInfo) => (a.salePrice ?? 0) - (b.salePrice ?? 0)
    )
    if (list) {
      let salePrice = list[0].salePrice ?? 0
      if (length == 1) {
        return (salePrice / 100).toFixed(2)
      } else {
        return `${(salePrice / 100).toFixed(2)}起`
      }
    }
    return ''
  }

  formatPriceToYuan(price: number | null): string {
    let _price = price ?? 0
    return (_price / 100).toFixed(2)
  }
}

export default new GoodsShowUtil()