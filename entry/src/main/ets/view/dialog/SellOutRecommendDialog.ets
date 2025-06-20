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
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { OrderRecommendInfo } from 'lib_core_model/src/main/ets/data/OrderRecommendInfo';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import OrderVM from 'lib_core_model/src/main/ets/vm/OrderVM';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';

@CustomDialog
export default struct SellOutRecommendDialog {
  @State loginData: LoginData | null = null
  @State datas: Array<OrderRecommendInfo> = []

  mSubOrderInfo?: SubOrderInfo | null
  controller: CustomDialogController;

  sendOrderRecommendRequest () {
    OrderVM.sendOrderRecommendRequest(this.mSubOrderInfo?.tenantId ?? 0,this.loginData?.token ?? '',
      this.mSubOrderInfo?.goodsId ?? '').then((value: OrderRecommendInfo[]) => {
        this.datas = value
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  aboutToAppear(): void {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendOrderRecommendRequest()
    })
  }

  build() {
    Column() {
      Row(){
        Image($r('app.media.ic_dlg_close'))
          .width($r('app.string.lpx_60'))
          .height($r('app.string.lpx_60'))
          .margin({top: $r('app.string.lpx_20')})
          .padding($r('app.string.lpx_10'))
          .onClick(() => {
            this.controller.close()
          })
      }
      .width(Constants.FULL_PARENT)
      .justifyContent(FlexAlign.End)

      Text('当前课程已过有效期且售罄')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(40))
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)

      Text('为您推荐以下相关课程')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_12')})

      List() {
        ForEach(this.datas,(item: OrderRecommendInfo) => {
          this.recommendCell(item)
        })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_750'))
      .margin({ top: $r('app.string.lpx_72') })
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

  @Builder recommendCell(data: OrderRecommendInfo) {
    Column(){
      Row(){
        Image(data.headUrl)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .border({radius: $r('app.string.lpx_8')})

        Column() {

          Text(data.goodsName ?? '')
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})

          Text(GoodsShowUtil.getOrderRecommendFirstLecturerLabel(data.lecturerLabel))
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_999999'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .margin({top: $r('app.string.lpx_16')})

          Blank()

          Row() {
            Image($r('app.media.ic_play_count_grey'))
              .width($r('app.string.lpx_12'))
              .height($r('app.string.lpx_15'))

            Text(GoodsShowUtil.getGoodsPopularityTxt(data.goodsPopularity ?? 0))
              .fontSize(lpx2fp(20))
              .fontColor($r('app.color.color_999999'))
              .margin({left: $r('app.string.lpx_10')})

            Text(GoodsShowUtil.getGoodsScoreTxt(data.goodsScore ?? 0))
              .fontSize(lpx2fp(20))
              .fontColor($r('app.color.color_999999'))
              .margin({left: $r('app.string.lpx_24')})
          }
          .width(Constants.FULL_PARENT)
        }
        .layoutWeight(1)
        .height($r('app.string.lpx_180'))
        .margin({left: $r('app.string.lpx_24')})
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_24')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius({
      topLeft: $r('app.string.lpx_20'),
      topRight: $r('app.string.lpx_20')
    })
    .padding($r('app.string.lpx_24'))
    .margin({top: $r('app.string.lpx_20')})
    .onClick(() => {
      CourseDetailActionUtil.courseDetail(this.mSubOrderInfo?.tenantId ?? 0,this.mSubOrderInfo?.goodsMode,this.mSubOrderInfo?.goodsId,0)
      this.controller.close()
    })
  }
}