import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { router } from '@kit.ArkUI';
import { ToolBar } from '../../view/widget/ToolBar';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import InvoiceVM from 'lib_core_model/src/main/ets/vm/InvoiceVM';
import { OrderInvoiceData } from 'lib_core_model/src/main/ets/data/OrderInvoiceData';
import { OrderDetailData } from 'lib_core_model/src/main/ets/data/OrderDetailData';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import InvoiceUtil from '../../util/InvoiceUtil';
import LoadingDialog from '../../view/dialog/LoadingDialog';

@Entry
@Component
struct NotInvoicedPage {
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  orderNo?: string = (router.getParams() as object)?.[Constants.ORDER_NO];

  @State loginData: LoginData | null = null
  @State mOrderInvoiceData?: OrderInvoiceData | null = null
  @State mOrderDetailData: OrderDetailData = new OrderDetailData()

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sendOrderInvoiceRequest () {
    InvoiceVM.sendOrderInvoiceRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.orderNo ?? '')
      .then((value: OrderInvoiceData) => {
        this.mOrderInvoiceData = value
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendInvoiceOrderDetailRequest () {
    InvoiceVM.sendInvoiceOrderDetailRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.orderNo ?? '')
      .then((value: OrderDetailData) => {
        this.mOrderDetailData = value
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendInvoiceStatusRequest () {
    this.loadingDialogCtrl.open()
    InvoiceVM.sendInvoiceStatusRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.orderNo ?? '')
      .then((value: OrderDetailData) => {
        this.loadingDialogCtrl.close()
        this.mOrderDetailData.invoiceAmount = this.mOrderInvoiceData?.invoiceAmount ?? 0
        App.get().replaceUrl({
          url: RouterPath.INVOICE_PAGE,
          params: {
            tenantId: this.tenantId,
            data: this.mOrderDetailData,
            orderNo: this.orderNo
          }
        })
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
    this.sendOrderInvoiceRequest()
    this.sendInvoiceOrderDetailRequest()
  }

  build() {
    Column() {
      ToolBar({title: '发票服务'})
      this.content()
      this.bottomAction()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
  }

  @Builder content() {
    List() {
      ListItem(){
        this.header()
      }
      ListItem(){
        this.contentCell()
      }
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
  }

  @Builder header() {
    Column() {
      Text(){
        ImageSpan($r('app.media.img_detail_not_invoiced'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))
        Span('\t未开票')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(36))
      }
      Text(`可开票金额：￥${AmountUtil.getRoundUp((this.mOrderInvoiceData?.invoiceAmount ?? 0) / 100,2)}`)
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .margin({top: $r('app.string.lpx_24')})
      Text('* 发票会在7-15工作日内通过邮件发送给您，请填写您的常用邮箱!')
        .fontColor($r('app.color.color_444444'))
        .fontSize(lpx2fp(22))
        .margin({top: $r('app.string.lpx_40')})
        .padding($r('app.string.lpx_20'))
        .borderRadius($r('app.string.lpx_20'))
        .linearGradient({
          direction: GradientDirection.Top,
          colors: [
            [$r('app.color.color_FFB499'), 0.5],
            [$r('app.color.color_FFF5F0'), 1.0]]
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_320'))
    .padding({top: $r('app.string.lpx_48')})
    .backgroundImage($r('app.media.img_not_invoiced_header'))
    .backgroundImageSize(ImageSize.FILL)
  }

  @Builder contentCell() {
    Column(){
      Text('订单信息')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .width(Constants.FULL_PARENT)
        .padding({bottom: $r('app.string.lpx_24')})

      ForEach(this.mOrderDetailData?.subOrderVos,(item: SubOrderInfo) => {
        this.invoiceGoodsCell(item)
      })

      Row() {
        Text('订单状态')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text(InvoiceUtil.getOrderStatus(this.mOrderDetailData?.orderStatus))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(32))
      }
      .width(Constants.FULL_PARENT)

      Row() {
        Text('优惠')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text(`￥${AmountUtil.getRoundUp((this.mOrderDetailData?.discountsFee ?? 0) / 100,2)}`)
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(32))
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})

      if (InvoiceUtil.getPayerTotalShow(this.mOrderDetailData?.payerTotal ?? 0)) {
        Row() {
          Text('实付金额')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))
          Blank()
          Text(`￥${AmountUtil.getRoundUp((this.mOrderDetailData?.payerTotal ?? 0) / 100,2)}`)
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(32))
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})
      }

      if (InvoiceUtil.getTransferFeeShow(this.mOrderDetailData?.transferFee ?? 0)) {
        Row() {
          Text('转课金额')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))
          Blank()
          Text(`￥${AmountUtil.getRoundUp((this.mOrderDetailData?.transferFee ?? 0) / 100,2)}`)
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(32))
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

        Row() {
          Text('订单余额')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))
          Blank()
          Text(`￥${AmountUtil.getRoundUp((this.mOrderDetailData?.balanceFee ?? 0) / 100,2)}`)
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(32))
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})
      }

      if (InvoiceUtil.getRefundedFeeShow(this.mOrderDetailData?.refundedFee ?? 0)) {
        Row() {
          Text('退款金额')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))
          Blank()
          Text(`￥${AmountUtil.getRoundUp((this.mOrderDetailData?.refundedFee ?? 0) / 100,2)}`)
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(32))
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})
      }
    }
    .width(Constants.FULL_PARENT)
    .padding($r('app.string.lpx_32'))
    .backgroundColor($r('app.color.white'))
    .borderRadius({
      topLeft: $r('app.string.lpx_16'),
      topRight: $r('app.string.lpx_16')
    })
    .offset({y: -20})
  }

  @Builder invoiceGoodsCell(data: SubOrderInfo) {
    Row() {
      Image(data.coverUrl ?? '')
        .alt($r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_180'))
        .height($r('app.string.lpx_180'))
        .borderRadius($r('app.string.lpx_8'))
      Column() {
        Text(data.goodsName ?? '')
          .width(Constants.FULL_PARENT)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
        Blank()
        Row() {
          Text(`共${data.goodsNum ?? 0}件`)
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(28))
            .margin({right: $r('app.string.lpx_16')})
          Text('￥')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(20))
            .margin({right: $r('app.string.lpx_5')})
          Text(`${AmountUtil.getRoundUp((data.goodsTotalFee ?? 0) / 100,2)}`)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
        }
        .width(Constants.FULL_PARENT)
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .padding({left: $r('app.string.lpx_20')})
    }
    .width(Constants.FULL_PARENT)
    .margin({bottom: $r('app.string.lpx_32')})
  }

  @Builder bottomAction() {
    Row() {
      Button('联系客服',{ type: ButtonType.Normal, stateEffect: true })
        .layoutWeight(1)
        .height($r('app.string.lpx_88'))
        .margin({right: $r('app.string.lpx_22')})
        .fontColor($r('app.color.color_FF1F00'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .backgroundColor($r('app.color.color_FFEBEB'))
        .borderRadius($r('app.string.lpx_12'))
        .visibility(Visibility.None)
      Button('申请开票',{ type: ButtonType.Normal, stateEffect: true })
        .layoutWeight(1)
        .height($r('app.string.lpx_88'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .borderRadius($r('app.string.lpx_12'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'),0.0],
            [$r('app.color.color_F12E29'),0.7],
            [$r('app.color.color_F12E29'),1.0]
          ]
        })
        .visibility(InvoiceUtil.getInvoiceApplyVisibility(this.mOrderInvoiceData?.showInvoiceButton ?? false))
        .onClick(() => {
          this.sendInvoiceStatusRequest()
        })

    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_20'),
      bottom: $r('app.string.lpx_68'),
      left: $r('app.string.lpx_24'),
      right: $r('app.string.lpx_24')
    })
  }
}