import App from 'lib_core_model/src/main/ets/App';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { GoodsType, OnlineFlag, SaleType } from 'lib_core_model/src/main/ets/util/Enums';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM';

class CourseDetailActionUtil {
  tag: string = 'CourseDetailActionUtil'
  tenantId: number = 0
  goodsId: string = ''
  subOrderId: number = -1
  onlineFlag: number = 0
  studyNow: boolean = false
  loginData: LoginData | null = null
  goodsInfo: GoodsInfo = new GoodsInfo()

  courseDetail(tenantId: number, onlineFlag?: number, goodsId?: string, subOrderId?: number, studyNow?: boolean) {
    this.tenantId = tenantId
    this.onlineFlag = onlineFlag ?? 0
    this.goodsId = goodsId ?? ''
    this.subOrderId = subOrderId ?? -1
    this.studyNow = studyNow ?? false
    AppConfig.getLoginData()
      .then((value: LoginData) => {
        this.loginData = value
        this.sendAllRequest()
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
        this.sendAllRequest()
      })
  }

  private sendAllRequest() {
    if (this.onlineFlag == OnlineFlag.Online) {
      Logger.info(this.tag, `线上课程`)
      this.sendOnlineCourseDetailRequest()
    } else if (this.onlineFlag == OnlineFlag.Offline) {
      Logger.info(this.tag, `线下课程`)
      this.sendOfflineCourseDetailRequest()
    }
  }

  private sendOnlineCourseDetailRequest() {
    CourseVM.sendOnlineCourseDetailRequest(this.loginData?.token ?? '', this.goodsId)
      .then((value: GoodsInfo) => {
        this.goodsInfo = value
        this.jumpPage()
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
        Logger.error(this.tag, `sendOnlineCourseDetailRequest = ${err.toString()}`)
      })
  }

  private sendOfflineCourseDetailRequest() {
    CourseVM.sendOfflineCourseDetailRequest(this.loginData?.token ?? '', this.goodsId, this.subOrderId)
      .then((value: GoodsInfo) => {
        this.goodsInfo = value
        this.jumpPage()
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
        Logger.error(this.tag, `sendOnlineCourseDetailRequest = ${err.toString()}`)
      })
  }

  private jumpPage() {
    Logger.info(this.tag, `goodsType = ${this.goodsInfo.goodsType}`)
    Logger.info(this.tag, `saleType = ${this.goodsInfo.saleType}`)
    Logger.info(this.tag, `orderNo = ${this.goodsInfo.orderNo}`)
    if (this.goodsInfo.goodsType == GoodsType.Image) { // 0-图片

    } else if (this.goodsInfo.goodsType == GoodsType.OfflineCourse) { // 5-线下课程
      if (this.goodsInfo.saleType == SaleType.Free || (this.goodsInfo.orderNo && this.studyNow)) {
        const count = this.goodsInfo.videoVos?.length ?? 0
        if (count > 0) { // 有视频
          App.get().pushUrl({
            url: RouterPath.OFFLINE_COURSE_STUDY_PLAY_PAGE,
            params: {
              goodsId: this.goodsId,
              tenantId: this.tenantId,
              subOrderId: this.subOrderId
            }
          });
        } else { // 无视频
          App.get().pushUrl({
            url: RouterPath.OFFLINE_COURSE_STUDY_UN_PLAY_PAGE,
            params: {
              goodsId: this.goodsId,
              tenantId: this.tenantId,
              subOrderId: this.subOrderId
            }
          });
        }
      } else {
        App.get().pushUrl({
          url: RouterPath.OFFLINE_COURSE_DETAIL_PAGE,
          params: {
            tenantId: this.tenantId,
            data: this.goodsId,
            subOrderId: this.subOrderId
          }
        });
      }
    } else { // 1-音频 2-视频 3-专栏 4-大专栏
      // 是否已登录
      if (this.loginData) {
        this.isAuthenticated()
      } else {
        this.isUnauthenticated()
      }
    }
  }

  private isAuthenticated() {
    Logger.info(this.tag, `已登录`)
    if (this.goodsInfo.saleType == SaleType.Free || (this.goodsInfo.orderNo && this.studyNow)) {
      App.get().pushUrl({
        url: RouterPath.ONLINE_COURSE_STUDY_PLAY_PAGE,
        params: {
          data: this.goodsId
        }
      });
    } else {
      if (this.onlineFlag == OnlineFlag.Online) {
        App.get().pushUrl({
          url: RouterPath.ONLINE_COURSE_DETAIL_PAGE,
          params: {
            tenantId: this.tenantId,
            data: this.goodsId
          }
        });
      } else {
        App.get().pushUrl({
          url: RouterPath.OFFLINE_COURSE_DETAIL_PAGE,
          params: {
            tenantId: this.tenantId,
            data: this.goodsId,
            subOrderId: this.subOrderId
          }
        });
      }
    }
  }

  private isUnauthenticated() {
    Logger.info(this.tag, `未登录`)
    if (this.goodsInfo.saleType == SaleType.Free) {
      App.get().pushUrl({
        url: RouterPath.ONLINE_COURSE_STUDY_PLAY_PAGE,
        params: {
          data: this.goodsId
        }
      });
    } else {
      if (this.onlineFlag == OnlineFlag.Online) {
        App.get().pushUrl({
          url: RouterPath.ONLINE_COURSE_DETAIL_PAGE,
          params: {
            tenantId: this.tenantId,
            data: this.goodsId
          }
        });
      } else {
        App.get().pushUrl({
          url: RouterPath.OFFLINE_COURSE_DETAIL_PAGE,
          params: {
            tenantId: this.tenantId,
            data: this.goodsId,
            subOrderId: this.subOrderId
          }
        });
      }
    }
  }
}

export default new CourseDetailActionUtil()
