import router from '@ohos.router'
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { OrderDetailData } from 'lib_core_model/src/main/ets/data/OrderDetailData';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import OrderVM from 'lib_core_model/src/main/ets/vm/OrderVM';
import DateUtil from 'lib_common/src/main/ets/util/DateUtil';
import OrderShowUtil from 'lib_common/src/main/ets/util/OrderShowUtil';
import { ToolBar } from '../../view/widget/ToolBar';
import OrderDetailCourseCell from './cell/OrderDetailCourseCell';
import { LogisticsData } from 'lib_core_model/src/main/ets/data/LogisticsData';
import { SubLogisticsInfo } from 'lib_core_model/src/main/ets/data/SubLogisticsInfo';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import OnlineCourseExpirationDialog from '../../view/dialog/OnlineCourseExpirationDialog';
import OfflineCourseExpirationDialog from '../../view/dialog/OfflineCourseExpirationDialog';
import SellOutRecommendDialog from '../../view/dialog/SellOutRecommendDialog';
import { OrderGoodRelatedData } from 'lib_core_model/src/main/ets/data/OrderGoodRelatedData';
import InvoiceVM from 'lib_core_model/src/main/ets/vm/InvoiceVM';
import { OrderInvoiceData } from 'lib_core_model/src/main/ets/data/OrderInvoiceData';

@Entry
@Component
struct OrderDetailPage {
  orderNo: string = (router.getParams() as object)?.[Constants.DATA];
  userPhone: string = (router.getParams() as object)?.[Constants.PHONE];

  @State loginData: LoginData | null = null

  @State refreshConfig: RefreshConfig<SubOrderInfo> = new RefreshConfig<SubOrderInfo>()

  @State mOrderDetailData: OrderDetailData | null = null
  @State mSubLogisticsInfo?: SubLogisticsInfo | null = null
  @State orderTimeout: number = 10 * 1000

  @State isUser: number = 0//代表查询缓存 1第3方 请求有数据才替换默认0请求的数据

  @State mSubOrderInfo?: SubOrderInfo | null = null

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

  sendSyncSignInvoiceRequest (item?: SubOrderInfo) {
    this.loadingDialogCtrl.open()
    InvoiceVM.sendSyncSignInvoiceRequest(item?.tenantId ?? 0,this.loginData?.token ?? '',this?.orderNo ?? '')
      .then((value: object) => {
        this.loadingDialogCtrl.close()
        this.sendOrderInvoiceRequest(item)
      }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendOrderInvoiceRequest (item?: SubOrderInfo) {
    InvoiceVM.sendOrderInvoiceRequest(item?.tenantId ?? 0,this.loginData?.token ?? '',this?.orderNo ?? '')
      .then((value: OrderInvoiceData) => {
        const count = value.invoiceVos?.length ?? 0
        if (count > 0) {
          App.get().pushUrl({
            url: RouterPath.INVOICE_DETAIL_PAGE,
            params: {
              tenantId: item?.tenantId,
              orderNo: this?.orderNo
            }
          })
        } else {
          App.get().pushUrl({
            url: RouterPath.NOT_INVOICED_PAGE,
            params: {
              tenantId: item?.tenantId,
              orderNo: this?.orderNo
            }
          })
        }
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendOrderGoodRelatedRequest () {
    this.loadingDialogCtrl.open()

    OrderVM.sendOrderGoodRelatedRequest(this.mSubOrderInfo?.tenantId ?? 0,this.loginData?.token ?? '',
      this.mSubOrderInfo?.goodsId ?? '',this.mSubOrderInfo?.id ?? 0).then((value: OrderGoodRelatedData) => {
      this.loadingDialogCtrl.close()

      if (value.outOfTime) {
        if (value.goodsNum == 0) {//售馨
          if (this.mSubOrderInfo?.goodsMode === 0) {
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
            if (this.mSubOrderInfo?.goodsMode === 0) {
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
          this.mSubOrderInfo?.tenantId ?? 0,
          this.mSubOrderInfo?.goodsMode,
          this.mSubOrderInfo?.goodsId,
          this.mSubOrderInfo?.id)
      }
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendOrderDetailRequest () {
    OrderVM.sendOrderDetailRequest(0,this.loginData?.token ?? '',this.orderNo).then((value: OrderDetailData) => {
      this.refreshConfig.setData(value.subOrderVos ?? [],true)
      this.mOrderDetailData = value
      this.orderTimeout = (this.mOrderDetailData?.orderTimeout ?? 0) * 1000

      if (this.mOrderDetailData?.isShowLogistics) {
        this.sendLogisiticsInfoRequest()
      }
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  sendLogisiticsInfoRequest () {
    OrderVM.sendLogisiticsInfoRequest(this.mOrderDetailData?.tenantId ?? 0,this.loginData?.token ?? '',this.orderNo,this.isUser)
      .then((value: LogisticsData) => {
      this.mSubLogisticsInfo = value.dataList?.[0]?.dataList?.[0]
    }).catch((err: string | Resource) => {
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
    this.sendOrderDetailRequest()
  }

  build() {
    Column() {
      ToolBar({title: '订单详情'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: SubOrderInfo,index: number): void => this.itemLayout(data,index),
      loadEndLayout:(): void => this.loadEndLayout(),
      onRefresh: () => {
        this.isUser = 1
        this.refreshData()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({top: $r('app.string.lpx_8')})
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
      .zIndex(0)
  }

  @Builder itemLayout(item: SubOrderInfo,index: number) {
    OrderDetailCourseCell({
      data: item,
      channelSource: this.mOrderDetailData?.channelSource,
      paymentType: this.mOrderDetailData?.paymentType,
      isShowInvoiceButton: this.mOrderDetailData?.isShowInvoiceButton,
      orderNo: this.orderNo,
      userPhone: this.userPhone,
      index: index,
      onCellClick: (data?: SubOrderInfo,index?: number): void => this.onCellClick(data,index)
    })
  }

  @Builder loadEndLayout() {
    Column() {
      if (this.mOrderDetailData?.orderStatus === 1) {
        Row() {
          Text('00:00:00')
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(28))
            .margin({right: $r('app.string.lpx_10')})
            .visibility(Visibility.Hidden)

          Text('后取消订单')
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .textAlign(TextAlign.Start)
            .layoutWeight(1)
          Text('去支付')
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
            .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })

        }
        .width(Constants.FULL_PARENT)
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_12'))
        .margin({top: $r('app.string.lpx_32')})
        .padding($r('app.string.lpx_20'))
      }

      Column() {
        Row() {
          Text('订单编号')
            .fontSize(lpx2fp(32))
            .fontColor($r('app.color.color_333333'))
          Text(this.mOrderDetailData?.orderNo)
            .margin({right: $r('app.string.lpx_10')})
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .textAlign(TextAlign.End)
            .layoutWeight(1)
          Text('｜复制')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
        }
        .width(Constants.FULL_PARENT)
        .onClick(() => {
          ClipboardUtil.copy(this.mOrderDetailData?.orderNo ?? '')
        })

        if (OrderShowUtil.getPayWayShow(this.mOrderDetailData?.orderStatus)) {
          Row() {
            Text('支付方式')
              .fontSize(lpx2fp(32))
              .fontColor($r('app.color.color_333333'))
            Blank()
            Text(OrderShowUtil.getPaywayTitle(this.mOrderDetailData?.paymentType))
              .fontColor($r('app.color.color_777777'))
              .fontSize(lpx2fp(28))
          }
          .width(Constants.FULL_PARENT)
          .margin({top: $r('app.string.lpx_32')})
        }

        if (OrderShowUtil.getPayTimeShow(this.mOrderDetailData?.orderStatus)) {
          Row() {
            Text('支付时间')
              .fontSize(lpx2fp(32))
              .fontColor($r('app.color.color_333333'))
            Blank()
            Text(DateUtil.transNumberDateHMS(this.mOrderDetailData?.updateTime))
              .fontColor($r('app.color.color_777777'))
              .fontSize(lpx2fp(28))
          }
          .width(Constants.FULL_PARENT)
          .margin({top: $r('app.string.lpx_32')})
        }

      }
      .width(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_12'))
      .margin({top: $r('app.string.lpx_32')})
      .padding($r('app.string.lpx_20'))

      if (this.mSubLogisticsInfo) {
        this.logisticsLayout()
      }
    }
    .width(Constants.FULL_PARENT)
    .padding({bottom: $r('app.string.lpx_92')})
  }

  @Builder logisticsLayout() {
    Column() {
      Text('物流信息')
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
      Row(){
        Column(){
          Circle()
            .width($r('app.string.lpx_28'))
            .height($r('app.string.lpx_28'))
            .fill($r('app.color.color_FC6D38'))
            .strokeWidth($r('app.string.lpx_4'))
            .stroke($r('app.color.color_FFC1AD'))
          Line()
            .width($r('app.string.lpx_2'))
            .height($r('app.string.lpx_80'))
            .backgroundColor($r('app.color.color_D8D8D8'))
          Circle()
            .width($r('app.string.lpx_20'))
            .height($r('app.string.lpx_20'))
            .fill($r('app.color.color_D8D8D8'))
            .strokeWidth($r('app.string.lpx_4'))
            .stroke($r('app.color.color_D8D8D8'))
        }

        Column() {
          Text(this.mSubLogisticsInfo?.acceptStation ?? '')
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(28))
            .fontColor($r('app.color.color_777777'))
          Text(this.mSubLogisticsInfo?.acceptTime ?? '')
            .width(Constants.FULL_PARENT)
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_777777'))
            .margin({top: $r('app.string.lpx_4')})
          Text(){
            Span('查看全部')
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_777777'))
            ImageSpan($r('app.media.ic_order_down'))
              .width($r('app.string.lpx_30'))
              .height($r('app.string.lpx_30'))
              .margin({left: $r('app.string.lpx_8')})
          }
          .margin({top: $r('app.string.lpx_40')})
        }
        .layoutWeight(1)
        .padding({left: $r('app.string.lpx_20')})
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.LOGISTICS_PAGE,
        params: {
          data: this.orderNo,
          tenantId: this.mOrderDetailData?.tenantId
        }
      })
    })
  }

  onCellClick(data?: SubOrderInfo,index?: number) {
    this.mSubOrderInfo = data
    if (index === -1) {//去学习
      this.sendOrderGoodRelatedRequest()
    } else if (index === -3) {//发票服务
      this.sendSyncSignInvoiceRequest(data)
    }
  }

}
