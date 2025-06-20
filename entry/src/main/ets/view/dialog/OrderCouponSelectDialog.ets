/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseStudyDialog
 * Author: Victor
 * Date: 2023/12/28 16:27
 * Description: 
 * -----------------------------------------------------------------
 */
import { ClaimCouponParm } from 'lib_core_model/src/main/ets/data/ClaimCouponParm';
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { RecommendCouponData } from 'lib_core_model/src/main/ets/data/RecommendCouponData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM';
import PayCouponNormalCell from '../../pages/pay/PayCouponNormalCell';
import PayCouponUnAvaialableCell from '../../pages/pay/PayCouponUnAvaialableCell';
import PayOrderUtil from '../../util/PayOrderUtil';

@CustomDialog
export default struct OrderCouponSelectDialog {
  @State loginData: LoginData | null = null
  @State mRecommendCouponData?: RecommendCouponData | null = null
  @State datas: Array<CouponInfo> = []
  @State tenantId: number = 0
  @State clickIndex: number = Constants.DEFAULT_CLICK_INDEX;
  controller: CustomDialogController;

  sendOrderRecommendRequest (couponNo: string) {
    const body = new ClaimCouponParm()
    body.couponNo = couponNo
    CourseVM.sendClaimCouponRequest(this.tenantId,this.loginData?.token ?? '', body)
      .then((value: object) => {
        this.datas[this.clickIndex].claimStatus = 2
        ToastUtils.show("恭喜您，领券成功！")
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  aboutToAppear(): void {
    this.datas = this.mRecommendCouponData?.userCouponPageVos ?? []
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
  }

  build() {
    Column() {
      Stack() {
        Text('优惠')
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(36))
          .textAlign(TextAlign.Center)

        Image($r('app.media.ic_dlg_feedback_type_close'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .onClick(() => {
            this.controller.close()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_128'))
      .alignContent(Alignment.End)

      Text() {
        Span(PayOrderUtil.getCouponTip(this.mRecommendCouponData))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Span(PayOrderUtil.getCouponSpanTip(this.mRecommendCouponData))
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
      }

      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({top: $r('app.string.lpx_32')})

      List() {
        ForEach(this.datas,(item: CouponInfo,index: number) => {
          if (item.enabledStatus == 1) {
            PayCouponUnAvaialableCell({
              data: item,
              index: index,
              clickIndex: $clickIndex
            })
          } else {
            PayCouponNormalCell({
              data: item
            })
          }
        })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_750'))
      .margin({ top: $r('app.string.lpx_32') })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor(Color.White)
    .borderRadius($r('app.string.lpx_20'))
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }
}