/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CompletedOrderTabContent
 * Author: Victor
 * Date: 2023/12/01 15:58
 * Description: 
 * -----------------------------------------------------------------
 */
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { OrderGoodRelatedData } from 'lib_core_model/src/main/ets/data/OrderGoodRelatedData';
import { OrderInfo } from 'lib_core_model/src/main/ets/data/OrderInfo';
import { OrderInvoiceData } from 'lib_core_model/src/main/ets/data/OrderInvoiceData';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import InvoiceVM from 'lib_core_model/src/main/ets/vm/InvoiceVM';
import OrderVM from 'lib_core_model/src/main/ets/vm/OrderVM';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import OfflineCourseExpirationDialog from '../../view/dialog/OfflineCourseExpirationDialog';
import OnlineCourseExpirationDialog from '../../view/dialog/OnlineCourseExpirationDialog';
import SellOutRecommendDialog from '../../view/dialog/SellOutRecommendDialog';
import PaidMultiCell from './cell/PaidMultiCell';
import PaidSingleCell from './cell/PaidSingleCell';

@Preview
@Component
export struct CompletedOrderTabContent {

  @State loginData: LoginData | null = null
  @State mSubOrderInfo?: SubOrderInfo | null = null

  @State refreshConfig: RefreshConfig<OrderInfo> = new RefreshConfig<OrderInfo>()

  onBuyNow() {
    CourseDetailActionUtil.courseDetail(
      this.mSubOrderInfo?.tenantId ?? 0,
      this.mSubOrderInfo?.goodsMode,
      this.mSubOrderInfo?.goodsId,
      this.mSubOrderInfo?.id)
  }

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  onlineCourseExpirationDlgCtrl: CustomDialogController = new CustomDialogController({
    builder: OnlineCourseExpirationDialog({
      mSubOrderInfo: this.mSubOrderInfo,
      onBuyNow: this.onBuyNow.bind(this)
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  offlineCourseExpirationDlgCtrl: CustomDialogController = new CustomDialogController({
    builder: OfflineCourseExpirationDialog({
      mSubOrderInfo: this.mSubOrderInfo,
      onBuyNow: this.onBuyNow.bind(this)
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sellOutRecommendDlgCtrl: CustomDialogController = new CustomDialogController({
    builder: SellOutRecommendDialog({
      mSubOrderInfo: this.mSubOrderInfo
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sendOrderListRequest () {
    OrderVM.sendOrderListRequest(this.loginData?.token ?? '',2,this.refreshConfig.currentPage,
      this.refreshConfig.PAGE_SIZE).then((value: OrderInfo[]) => {
      this.refreshConfig.setData(value,true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  sendSyncSignInvoiceRequest (item?: OrderInfo) {
    this.loadingDialogCtrl.open()
    InvoiceVM.sendSyncSignInvoiceRequest(item?.tenantVO?.tenantId ?? 0,this.loginData?.token ?? '',item?.orderNo ?? '')
      .then((value: object) => {
        this.loadingDialogCtrl.close()
        this.sendOrderInvoiceRequest(item)
      }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendOrderInvoiceRequest (item?: OrderInfo) {
    InvoiceVM.sendOrderInvoiceRequest(item?.tenantVO?.tenantId ?? 0,this.loginData?.token ?? '',item?.orderNo ?? '')
      .then((value: OrderInvoiceData) => {
        const count = value.invoiceVos?.length ?? 0
        if (count > 0) {
          App.get().pushUrl({
            url: RouterPath.INVOICE_DETAIL_PAGE,
            params: {
              tenantId: item?.tenantId,
              orderNo: item?.orderNo
            }
          })
        } else {
          App.get().pushUrl({
            url: RouterPath.NOT_INVOICED_PAGE,
            params: {
              tenantId: item?.tenantId,
              orderNo: item?.orderNo
            }
          })
        }
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendOrderGoodRelatedRequest (data?: OrderInfo) {
    this.loadingDialogCtrl.open()
    const subOrderInfo = data?.subOrderVos?.[0]
    this.mSubOrderInfo = subOrderInfo

    OrderVM.sendOrderGoodRelatedRequest(subOrderInfo?.tenantId ?? 0,this.loginData?.token ?? '',
      subOrderInfo?.goodsId ?? '',subOrderInfo?.id ?? 0).then((value: OrderGoodRelatedData) => {
      this.loadingDialogCtrl.close()

      if (value.outOfTime) {
        if (value.goodsNum == 0) {//售馨
          if (subOrderInfo?.goodsMode === 0) {
            //线上课程过期未下架
            this.onlineCourseExpirationDlgCtrl.open()
          } else {
            //售馨弹窗
            this.sellOutRecommendDlgCtrl.open()
          }
        } else {
          if (value.shelveFlag === 1) {//下架
            //售馨弹窗
            this.sellOutRecommendDlgCtrl.open()
          } else {
            if (subOrderInfo?.goodsMode === 0) {
              //线上课程过期未下架
              this.onlineCourseExpirationDlgCtrl.open()
            } else {
              //线下课程过期未下架
              this.offlineCourseExpirationDlgCtrl.open()
            }
          }
        }
      } else {
        CourseDetailActionUtil.courseDetail(
          data?.tenantVO?.tenantId ?? 0,
          data?.subOrderVos?.[0]?.goodsMode,
          data?.subOrderVos?.[0]?.goodsId,
          data?.subOrderVos?.[0]?.id)
      }
      }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
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
    this.sendOrderListRequest()
  }

  loadMoreData () {
    this.sendOrderListRequest()
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
      //PAID_MULTI
      PaidMultiCell({
        data: item,
        index: index,
        onCellClick: (data?: OrderInfo,index?: number): void => this.onCellClick(data,index)
      })
    } else {
      //PAID_SINGLE
      PaidSingleCell({
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
    if (index === -1) {//去学习
      this.sendOrderGoodRelatedRequest(data)
    } else if (index === -3) {//发票服务
      this.sendSyncSignInvoiceRequest(data)
    } else {
      App.get().pushUrl({
        url: RouterPath.ORDER_DETAIL_PAGE,
        params: {
          data: data?.orderNo,
          phone: data?.userPhone
        }
      })
    }
  }
}
