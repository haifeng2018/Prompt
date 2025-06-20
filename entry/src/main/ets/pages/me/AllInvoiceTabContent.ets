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
import NotInvoicedSingleCell from './cell/NotInvoicedSingleCell';
import NotInvoicedMultiCell from './cell/NotInvoicedMultiCell';
import InvoicingSingleCell from './cell/InvoicingSingleCell';
import InvoicingMultiCell from './cell/InvoicingMultiCell';
import InvoicedMultiCell from './cell/InvoicedMultiCell';
import InvoicedSingleCell from './cell/InvoicedSingleCell';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import LoadingDialog from '../../view/dialog/LoadingDialog';

@Preview
@Component
export struct AllInvoiceTabContent {
  @State refreshConfig: RefreshConfig<InvoicePageInfo> = new RefreshConfig<InvoicePageInfo>()
  @State loginData: LoginData | null = null

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sendSyncSignInvoiceRequest (item: InvoicePageInfo) {
    this.loadingDialogCtrl.open()
    InvoiceVM.sendSyncSignInvoiceRequest(item.tenantId ?? 0,this.loginData?.token ?? '',item.orderNo ?? '')
      .then((value: object) => {
        this.loadingDialogCtrl.close()
        App.get().pushUrl({
          url: RouterPath.NOT_INVOICED_PAGE,
          params: {
            tenantId: item.tenantId,
            orderNo: item.orderNo
          }
        })
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendInvoicePageRequest () {
    InvoiceVM.sendInvoicePageRequest(this.loginData?.token ?? '',this.refreshConfig.currentPage,
      this.refreshConfig.PAGE_SIZE, -1).then((value: InvoicePageInfo[]) => {
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
    if (item.billingStatus == 0) {
      this.notInvoicedCell(item,index)
    } else  if (item.billingStatus == 1) {
      this.invoicingCell(item,index)
    } else  if (item.billingStatus == 2) {
      this.invoicedCell(item,index)
    }
  }

  @Builder notInvoicedCell (item: InvoicePageInfo,index: number) {
    if ((item.goodsUrlList?.length ?? 0) > 1) {
      NotInvoicedMultiCell({
        data: item,
        onCellClick:(): void => this.onCellClick(item,index)
      })
    } else {
      NotInvoicedSingleCell({
        data: item,
        onCellClick:(): void => this.onCellClick(item,index)
      })
    }
  }

  @Builder invoicingCell (item: InvoicePageInfo,index: number) {
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

  @Builder invoicedCell (item: InvoicePageInfo,index: number) {
    if ((item.goodsUrlList?.length ?? 0) > 1) {
      InvoicedMultiCell({
        data: item,
        onCellClick:(): void => this.onCellClick(item,index)
      })
    } else {
      InvoicedSingleCell({
        data: item,
        onCellClick:(): void => this.onCellClick(item,index)
      })
    }
  }

  onCellClick(item: InvoicePageInfo,index: number) {
    if (item.billingStatus == 0) {
      this.sendSyncSignInvoiceRequest(item)
    } else  if (item.billingStatus == 1) {
      App.get().pushUrl({
        url: RouterPath.INVOICE_DETAIL_PAGE,
        params: {
          tenantId: item.tenantId,
          orderNo: item.orderNo
        }
      })
    } else  if (item.billingStatus == 2) {
      App.get().pushUrl({
        url: RouterPath.INVOICE_DETAIL_PAGE,
        params: {
          tenantId: item.tenantId,
          orderNo: item.orderNo
        }
      })
    }
  }
}
