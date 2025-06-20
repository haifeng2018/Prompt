/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: UnCommentOrderTabContent
 * Author: Victor
 * Date: 2023/12/01 15:58
 * Description: 
 * -----------------------------------------------------------------
 */
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { OrderInfo } from 'lib_core_model/src/main/ets/data/OrderInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import OrderVM from 'lib_core_model/src/main/ets/vm/OrderVM';
import UnCommentMultiCell from './cell/UnCommentMultiCell';
import UnCommentSingleCell from './cell/UnCommentSingleCell';

@Preview
@Component
export struct UnCommentOrderTabContent {

  @State loginData: LoginData | null = null

  @State refreshConfig: RefreshConfig<OrderInfo> = new RefreshConfig<OrderInfo>()

  @State pagerPosition: number = 0


  sendUnCommentOrderListRequest () {
    OrderVM.sendUnCommentOrderListRequest(this.loginData?.token ?? '',this.refreshConfig.currentPage,
      this.refreshConfig.PAGE_SIZE).then((value: OrderInfo[]) => {
      this.refreshConfig.setData(value,true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  refreshData () {
    this.sendUnCommentOrderListRequest()
  }

  loadMoreData () {
    this.sendUnCommentOrderListRequest()
  }

  build() {
    LMList({
      showScrollBar: false,
      refreshConfig: this.refreshConfig,
      itemLayout: (data: OrderInfo,index: number): void => this.itemLayout(data,index),
      emptyLayout:(): void => this.emptyLayout(),
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

  @Builder itemLayout(item: OrderInfo,index: number) {
    if ((item?.subOrderVos?.length ?? 0) > 1) {
      //UN_COMMENT_MULTI
      UnCommentMultiCell({
        data: item,
        index: index,
        onCellClick: (data?: OrderInfo,index?: number): void => this.onCellClick(data,index)
      })
    } else {
      //UN_COMMENT_SINGLE
      UnCommentSingleCell({
        data: item,
        index: index,
        onCellClick: (data?: OrderInfo,index?: number): void => this.onCellClick(data,index)
      })
    }
  }

  @Builder emptyLayout() {
    Column() {
      Image($r('app.media.img_no_practice'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_400'))
        .objectFit(ImageFit.Contain)
      Text('您还没有订单，需要去逛逛嘛')
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_666666'))

      Text('去逛逛')
        .height($r('app.string.lpx_52'))
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.color_DA3732'))
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.color_FEFAFA'))
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_26'),
          color: $r('app.color.color_DA3732')
        })
        .margin({top: $r('app.string.lpx_60')})
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
        .onClick(() => {
          App.get().replaceUrl({
            url: RouterPath.MAIN_PAGE
          })
        })
    }
    .width($r('app.string.lpx_750'))
    .padding({top: $r('app.string.lpx_150')})
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  onCellClick(data?: OrderInfo,index?: number) {
    App.get().pushUrl({
      url: RouterPath.ORDER_DETAIL_PAGE,
      params: {
        data: data?.orderNo,
        phone: data?.userPhone
      }
    })
  }
}
