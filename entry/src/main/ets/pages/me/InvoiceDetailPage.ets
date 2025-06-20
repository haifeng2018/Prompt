import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { router } from '@kit.ArkUI';
import { ToolBar } from '../../view/widget/ToolBar';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import InvoiceUtil from '../../util/InvoiceUtil';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { OrderInvoiceData } from 'lib_core_model/src/main/ets/data/OrderInvoiceData';
import InvoiceVM from 'lib_core_model/src/main/ets/vm/InvoiceVM';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';

@Entry
@Component
struct InvoiceDetailPage {
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  orderNo?: string = (router.getParams() as object)?.[Constants.ORDER_NO];

  @State loginData: LoginData | null = null
  @State mOrderInvoiceData?: OrderInvoiceData | null = null

  @State refreshConfig: RefreshConfig<object> = new RefreshConfig<object>()

  sendOrderInvoiceRequest () {
    InvoiceVM.sendOrderInvoiceRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.orderNo ?? '')
      .then((value: OrderInvoiceData) => {
        this.refreshConfig.setRefreshStatus(true)
        this.mOrderInvoiceData = value
      }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
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
    SwipeRefreshLayout({
      refreshConfig: this.refreshConfig,
      itemLayout: (): void => this.itemLayout(),
      onRefresh: () => {
        this.refreshData()
      }
    })
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
  }

  @Builder itemLayout() {
    Column() {
      this.header()
      this.contentCell()
    }
    .width(Constants.FULL_PARENT)
  }

  @Builder header() {
    Column() {
      Text(){
        ImageSpan(InvoiceUtil.getInvoiceStatusIcon(this.mOrderInvoiceData))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))
        Span(`\t${InvoiceUtil.getInvoiceStatus(this.mOrderInvoiceData)}`)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(36))
      }
      Text(InvoiceUtil.getInvoiceAmount(this.mOrderInvoiceData))
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
    .backgroundImage(InvoiceUtil.getInvoiceDetailHeaderImage(this.mOrderInvoiceData))
    .backgroundImageSize(ImageSize.FILL)
  }

  @Builder contentCell() {
    Column(){
      this.stateCell()

      Text('订单信息')
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_64')})

      this.detailCell()

      if (this.mOrderInvoiceData?.invoiceVos?.[0]?.personType == 2) {
        Row() {
          Text('税号')
            .fontColor($r('app.color.color_999999'))
            .fontSize(lpx2fp(24))
          Text(this.mOrderInvoiceData?.invoiceVos?.[0]?.taxId ?? '')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .layoutWeight(1)
            .margin({left: $r('app.string.lpx_64')})
        }
        .margin({top: $r('app.string.lpx_32')})
      }

      Row() {
        Text('接收邮箱')
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
        Text(this.mOrderInvoiceData?.invoiceVos?.[0]?.receivingEmail ?? '')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(24))
          .layoutWeight(1)
          .margin({left: $r('app.string.lpx_16')})
      }
      .margin({top: $r('app.string.lpx_32')})

      Row() {
        Text('备注')
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
        Text(this.mOrderInvoiceData?.invoiceVos?.[0]?.remarks ?? '')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(24))
          .layoutWeight(1)
          .margin({left: $r('app.string.lpx_16')})
      }
      .margin({top: $r('app.string.lpx_32')})

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

  @Builder stateCell() {
    Row() {
      Column() {
        Row() {
          Line()
            .width($r('app.string.lpx_59'))
            .height($r('app.string.lpx_4'))
            .backgroundColor($r('app.color.transparent'))
            .layoutWeight(1)
          Image($r('app.media.ic_invoice_focus'))
            .width($r('app.string.lpx_56'))
            .height($r('app.string.lpx_56'))
          Line()
            .width($r('app.string.lpx_59'))
            .height($r('app.string.lpx_4'))
            .backgroundColor($r('app.color.color_EBEBEB'))
            .layoutWeight(1)
        }
        .width(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)
        Text('开票申请')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({top: $r('app.string.lpx_16')})
      }
      .layoutWeight(1)
      Column() {
        Row() {
          Line()
            .width($r('app.string.lpx_59'))
            .height($r('app.string.lpx_4'))
            .backgroundColor($r('app.color.color_EBEBEB'))
            .layoutWeight(1)
          Image($r('app.media.ic_invoice_focus'))
            .width($r('app.string.lpx_56'))
            .height($r('app.string.lpx_56'))
          Line()
            .width($r('app.string.lpx_59'))
            .height($r('app.string.lpx_4'))
            .backgroundColor($r('app.color.color_EBEBEB'))
            .layoutWeight(1)
        }
        .width(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)
        Text('开票中')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({top: $r('app.string.lpx_16')})
      }
      .layoutWeight(1)
      Column() {
        Row() {
          Line()
            .width($r('app.string.lpx_59'))
            .height($r('app.string.lpx_4'))
            .backgroundColor($r('app.color.color_EBEBEB'))
            .layoutWeight(1)
          Image(InvoiceUtil.getInvoiceDetailEndStatusIcon(this.mOrderInvoiceData))
            .width($r('app.string.lpx_56'))
            .height($r('app.string.lpx_56'))
          Line()
            .width($r('app.string.lpx_59'))
            .height($r('app.string.lpx_4'))
            .backgroundColor($r('app.color.transparent'))
            .layoutWeight(1)
        }
        .width(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)
        Text('开票完成')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({top: $r('app.string.lpx_16')})
      }
      .layoutWeight(1)

    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_32')})
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder detailCell() {
    Row() {
      Column() {
        Row() {
          Text('发票类型')
            .fontColor($r('app.color.color_999999'))
            .fontSize(lpx2fp(24))
          Text(InvoiceUtil.getInvoiceType(this.mOrderInvoiceData))
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .layoutWeight(1)
            .margin({left: $r('app.string.lpx_16')})
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

        Row() {
          Text('抬头类型')
            .fontColor($r('app.color.color_999999'))
            .fontSize(lpx2fp(24))
          Text(InvoiceUtil.getInvoiceHeadType(this.mOrderInvoiceData))
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .layoutWeight(1)
            .margin({left: $r('app.string.lpx_16')})
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

        Row() {
          Text('抬头名称')
            .fontColor($r('app.color.color_999999'))
            .fontSize(lpx2fp(24))
          Text(this.mOrderInvoiceData?.invoiceVos?.[0]?.invoiceTitle ?? '')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .layoutWeight(1)
            .margin({left: $r('app.string.lpx_16')})
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})
      }
      .layoutWeight(1)

      if (InvoiceUtil.getInvoiceImageShow(this.mOrderInvoiceData)) {
        Column() {
          Stack() {
            Image(this.mOrderInvoiceData?.invoiceVos?.[0]?.ossInvoiceImage)
              .alt($r('app.media.img_placeholder_horizontal'))
              .width(Constants.FULL_PARENT)
              .height($r('app.string.lpx_120'))
            Text('共 1 张')
              .fontColor($r('app.color.white'))
              .fontSize(lpx2fp(20))
              .textAlign(TextAlign.Center)
              .width(Constants.FULL_PARENT)
          }
          .alignContent(Alignment.Bottom)
          Text('点击预览发票')
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(24))
            .textAlign(TextAlign.Center)
            .width(Constants.FULL_PARENT)
            .margin({top: $r('app.string.lpx_12')})
        }
        .width($r('app.string.lpx_200'))
      }
    }
    .width(Constants.FULL_PARENT)
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
      Button('发送到邮箱',{ type: ButtonType.Normal, stateEffect: true })
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
        .visibility(InvoiceUtil.getSendEmailBtnVisibility(this.mOrderInvoiceData))
        .onClick(() => {
          App.get().pushUrl({
            url: RouterPath.VIEW_INVOICE_PAGE,
            params: {
              data: this.mOrderInvoiceData?.invoiceVos?.[0]
            }
          })
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