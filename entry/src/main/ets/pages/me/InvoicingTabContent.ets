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
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import InvoiceVM from 'lib_core_model/src/main/ets/vm/InvoiceVM';
import { InvoicePageInfo } from 'lib_core_model/src/main/ets/data/InvoicePageInfo';
import InvoicingSingleCell from './cell/InvoicingSingleCell';
import InvoicingMultiCell from './cell/InvoicingMultiCell';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import App from 'lib_core_model/src/main/ets/App';

@Preview
@Component
export struct InvoicingTabContent {

  @State refreshConfig: RefreshConfig<InvoicePageInfo> = new RefreshConfig<InvoicePageInfo>()
  @State loginData: LoginData | null = null

  sendInvoicePageRequest () {
    InvoiceVM.sendInvoicePageRequest(this.loginData?.token ?? '',this.refreshConfig.currentPage,
      this.refreshConfig.PAGE_SIZE, 1).then((value: InvoicePageInfo[]) => {
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
    this.sendInvoicePageRequest()
  }

  loadMoreData () {
    this.sendInvoicePageRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: InvoicePageInfo,index: number): void => this.itemLayout(data,index),
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

  @Builder itemLayout(item: InvoicePageInfo,index: number) {
    if ((item.goodsUrlList?.length ?? 0) > 1) {
      InvoicingMultiCell({
        data: item,
        onCellClick:(): void => this.onCellClick(item,index)
      })
    } else {
      InvoicingSingleCell({
        data: item,
        onCellClick:(): void => this.onCellClick(item,index)
      })
    }
  }

  onCellClick(item: InvoicePageInfo,index: number) {
    App.get().pushUrl({
      url: RouterPath.INVOICE_DETAIL_PAGE,
      params: {
        tenantId: item.tenantId,
        orderNo: item.orderNo
      }
    })
  }

}
