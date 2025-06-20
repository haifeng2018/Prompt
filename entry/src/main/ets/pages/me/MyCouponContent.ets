/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: MyCouponContent
 * Author: Victor
 * Date: 2023/12/01 15:58
 * Description: 
 * -----------------------------------------------------------------
 */
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import UserVM from 'lib_core_model/src/main/ets/vm/UserVM';
import CouponUtil from '../../util/CouponUtil';
import DateUtil from 'lib_common/src/main/ets/util/DateUtil';
import UnUsedCouponCell from './cell/UnUsedCouponCell';

@Preview
@Component
export struct MyCouponContent {

  @State pagerPosition: number = 0
  @State refreshConfig: RefreshConfig<CouponInfo> = new RefreshConfig<CouponInfo>()

  @State loginData: LoginData | null = null

  @State clickIndex: number = Constants.DEFAULT_CLICK_INDEX;

  sendCouponPageRequest () {
    UserVM.sendCouponPageRequest(this.loginData?.token ?? '',this.refreshConfig.currentPage,this.refreshConfig.PAGE_SIZE,
      this.pagerPosition).then((value: CouponInfo[]) => {
      this.refreshConfig.setData(value,true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  refreshData () {
    this.sendCouponPageRequest()
  }

  loadMoreData () {
    this.sendCouponPageRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: object,index: number): void => this.itemLayout(data,index),
      onRefresh: () => {
        this.refreshData()
      },
      onLoadMore: () => {
        this.loadMoreData()
      }
    })
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder itemLayout(item: CouponInfo,index: number) {
    if (this.pagerPosition === 0) {
      UnUsedCouponCell({
        data: item,
        index: index,
        clickIndex: $clickIndex
      })
    } else if (this.pagerPosition === 1) {
      this.usedCell(item)
    } else if (this.pagerPosition === 2) {
      this.expiredCell(item)
    }
  }

  @Builder usedCell(item: CouponInfo) {
    Row() {
      Column() {
        Text('直播专享')
          .fontSize(lpx2fp(18))
          .fontColor($r('app.color.color_8D8D8D'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_EBEBEB'))
          .borderRadius({topLeft: $r('app.string.lpx_16'),bottomRight: $r('app.string.lpx_16')})
          .padding({
            top:$r('app.string.lpx_4'),
            bottom:$r('app.string.lpx_4'),
            left:$r('app.string.lpx_8'),
            right:$r('app.string.lpx_8')
          })
          .opacity(item?.couponType === 3 ? 1: 0)

        Text() {
          if (item?.discountMethod != 3) {
            Span('¥')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_444444'))
              .opacity(item?.discountMethod === 3 ? 0 : 1)
          }
          Span(CouponUtil.getCouponValue(item))
            .fontSize(lpx2fp(48))
            .fontColor($r('app.color.color_444444'))
            .fontWeight(FontWeight.Bold)
          if (item?.discountMethod === 3) {
            Span('折')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_444444'))
          }
        }
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .margin({top: $r('app.string.lpx_10')})
        Text(CouponUtil.getCouponTypeTxt(item?.discountMethod))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_444444'))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Center)
          .margin({top: $r('app.string.lpx_10')})
      }
      .width($r('app.string.lpx_158'))
      .height(Constants.FULL_PARENT)
      .alignItems(HorizontalAlign.Start)

      Stack() {
        Column() {
          Text(CouponUtil.getCouponTitle(item))
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.color_444444'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
          Text(item.couponNo)
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_777777'))
            .textAlign(TextAlign.Start)
            .margin({top: $r('app.string.lpx_8') })
          Text(`有效期:${DateUtil.transDate(item?.couponUseStartTime)}～${DateUtil.transDate(item?.couponUseEndTime)}`)
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(20))
            .fontColor($r('app.color.color_444444'))
            .textAlign(TextAlign.Start)
            .margin({top: $r('app.string.lpx_8')})
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)

        Image($r('app.media.img_coupon_used'))
          .width($r('app.string.lpx_64'))
          .height($r('app.string.lpx_64'))
          .margin({top: $r('app.string.lpx_8'), right: $r('app.string.lpx_8')})
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .padding({left: $r('app.string.lpx_30')})
      .alignContent(Alignment.TopEnd)
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_160'))
    .backgroundImage($r('app.media.img_coupon_expired_cell'))
    .backgroundImageSize(ImageSize.Contain)
    .margin({top: $r('app.string.lpx_32')})
  }

  @Builder expiredCell(item: CouponInfo) {
    Row() {
      Column() {
        Text('直播专享')
          .fontSize(lpx2fp(18))
          .fontColor($r('app.color.color_8D8D8D'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_EBEBEB'))
          .borderRadius({topLeft: $r('app.string.lpx_16'),bottomRight: $r('app.string.lpx_16')})
          .padding({
            top:$r('app.string.lpx_4'),
            bottom:$r('app.string.lpx_4'),
            left:$r('app.string.lpx_8'),
            right:$r('app.string.lpx_8')
          })
          .opacity(item?.couponType === 3 ? 1: 0)

        Text() {
          if (item?.discountMethod != 3) {
            Span('¥')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_444444'))
              .opacity(item?.discountMethod === 3 ? 0 : 1)
          }
          Span(CouponUtil.getCouponValue(item))
            .fontSize(lpx2fp(48))
            .fontColor($r('app.color.color_444444'))
            .fontWeight(FontWeight.Bold)
          if (item?.discountMethod === 3) {
            Span('折')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_444444'))
          }
        }
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .margin({top: $r('app.string.lpx_10')})
        Text(CouponUtil.getCouponTypeTxt(item?.discountMethod))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_444444'))
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Center)
          .margin({top: $r('app.string.lpx_10')})
      }
      .width($r('app.string.lpx_158'))
      .height(Constants.FULL_PARENT)
      .alignItems(HorizontalAlign.Start)

      Stack() {
        Column() {
          Text(CouponUtil.getCouponTitle(item))
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.color_444444'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
          Text(item.couponNo)
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_777777'))
            .textAlign(TextAlign.Start)
            .margin({top: $r('app.string.lpx_8') })
          Text(`有效期:${DateUtil.transDate(item?.couponUseStartTime)}～${DateUtil.transDate(item?.couponUseEndTime)}`)
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(20))
            .fontColor($r('app.color.color_444444'))
            .textAlign(TextAlign.Start)
            .margin({top: $r('app.string.lpx_8')})
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)

        Image($r('app.media.img_coupon_expired'))
          .width($r('app.string.lpx_64'))
          .height($r('app.string.lpx_64'))
          .margin({top: $r('app.string.lpx_8'), right: $r('app.string.lpx_8')})
      }
      .height(Constants.FULL_PARENT)
      .layoutWeight(1)
      .padding({left: $r('app.string.lpx_30')})
      .alignContent(Alignment.TopEnd)
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_160'))
    .backgroundImage($r('app.media.img_coupon_expired_cell'))
    .backgroundImageSize(ImageSize.Contain)
    .margin({top: $r('app.string.lpx_32')})
  }

}
