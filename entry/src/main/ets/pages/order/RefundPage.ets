import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { router } from '@kit.ArkUI';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { ToolBar } from '../../view/widget/ToolBar';
import App from 'lib_core_model/src/main/ets/App';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import AfterSaleVM from 'lib_core_model/src/main/ets/vm/AfterSaleVM';
import { AfterSaleDetailData } from 'lib_core_model/src/main/ets/data/AfterSaleDetailData';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import AfterSaleUtil from '../../util/AfterSaleUtil';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';

@Entry
@Component
struct RefundPage {
  subOrderId?: number = (router.getParams() as object)?.[Constants.SUB_ORDER_ID];
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID];

  @State refreshConfig: RefreshConfig<object> = new RefreshConfig<object>()

  @State loginData: LoginData | null = null
  @State mAfterSaleDetailData: AfterSaleDetailData | null = null

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sendAfterSaleDetailRequest () {
    AfterSaleVM.sendAfterSaleDetailRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.subOrderId ?? 0)
      .then((value: AfterSaleDetailData) => {
        this.refreshConfig.setRefreshStatus(true)
        this.mAfterSaleDetailData = value
      }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
      ToastUtils.show(err)
    })
  }

  sendCancelAfterSaleRequest () {
    this.loadingDialogCtrl.open()
    AfterSaleVM.sendCancelAfterSaleRequest(this.tenantId ?? 0,this.loginData?.token ?? '',
      this.mAfterSaleDetailData?.afterSaleNo ?? '').then((value: object) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show("撤销成功")
        App.get().back()
      }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  refreshData () {
    this.sendAfterSaleDetailRequest()
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  build() {
    Column() {
      this.titleBar()
      this.content()
      if (AfterSaleUtil.getRefundBottomActivityVisibility(this.mAfterSaleDetailData?.status)) {
        this.bottomAction()
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder titleBar() {
    Row() {
      Image($r('app.media.ic_back'))
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
        .objectFit(ImageFit.Contain)
        .margin({ left: $r('app.string.lpx_32') })
        .onClick(() => {
            App.get().back()
        })

      Text('退款详情')
        .layoutWeight(1)
        .height($r('app.string.lpx_98'))
        .fontSize(lpx2fp(36))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({ left: $r('app.string.lpx_80') })

      Text('我的订单')
        .width($r('app.string.lpx_128'))
        .height($r('app.string.lpx_48'))
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_777777'))
        .margin({ right: $r('app.string.lpx_32') })
        .onClick(() => {
        })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({ top: $r('app.string.lpx_60') })
    .shadow({
      radius: 5,
      color: $r('app.color.color_1400001E'),
      offsetX: 5,
      offsetY: 5
    })
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
    .margin({top: $r('app.string.lpx_8')})
    .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder itemLayout() {
    Column() {
      this.stateCell()
      this.courseCell()
      this.amountCell()
      this.typeReasonCell()
      this.afterSaleLog()
      this.orderCell()
    }
    .width(Constants.FULL_PARENT)
  }

  @Builder stateCell() {
    Row() {
      Column() {
        Row() {
          Line()
            .width($r('app.string.lpx_150'))
            .height($r('app.string.lpx_8'))
            .backgroundColor($r('app.color.transparent'))
            .layoutWeight(1)
          Image($r('app.media.ic_refund_flow_focus'))
            .width($r('app.string.lpx_40'))
            .height($r('app.string.lpx_40'))
          Line()
            .width($r('app.string.lpx_150'))
            .height($r('app.string.lpx_8'))
            .backgroundColor($r('app.color.color_E1F4EC'))
            .layoutWeight(1)
        }
        .width(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)
        Text('提交申请')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({top: $r('app.string.lpx_20')})
      }
      .layoutWeight(1)
      Column() {
        Row() {
          Line()
            .width($r('app.string.lpx_150'))
            .height($r('app.string.lpx_8'))
            .backgroundColor($r('app.color.color_E1F4EC'))
            .layoutWeight(1)
          Image($r('app.media.ic_refund_flow_focus'))
            .width($r('app.string.lpx_40'))
            .height($r('app.string.lpx_40'))
          Line()
            .width($r('app.string.lpx_150'))
            .height($r('app.string.lpx_8'))
            .backgroundColor($r('app.color.color_EDEDED'))
            .layoutWeight(1)
        }
        .width(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)
        Text('商家审核')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({top: $r('app.string.lpx_20')})
      }
      .layoutWeight(1)
      Column() {
        Row() {
          Line()
            .width($r('app.string.lpx_150'))
            .height($r('app.string.lpx_8'))
            .backgroundColor(AfterSaleUtil.getRefundEndLineColor(this.mAfterSaleDetailData?.status))
            .layoutWeight(1)
          Image(AfterSaleUtil.getRefundEndStatusIcon(this.mAfterSaleDetailData?.status))
            .width($r('app.string.lpx_40'))
            .height($r('app.string.lpx_40'))
          Line()
            .width($r('app.string.lpx_150'))
            .height($r('app.string.lpx_8'))
            .backgroundColor($r('app.color.transparent'))
            .layoutWeight(1)
        }
        .width(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.Center)
        Text('退款成功')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({top: $r('app.string.lpx_20')})
      }
      .layoutWeight(1)

    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_24')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder courseCell() {
    Column(){

      Row() {
        Text(this.mAfterSaleDetailData?.goodsMode === 1 ? '线下课' : '线上课')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text(AfterSaleUtil.getOrderStatus(this.mAfterSaleDetailData?.status))
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)

      Row() {
        Image(this.mAfterSaleDetailData?.coverUrlExtendVo?.centre)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .borderRadius($r('app.string.lpx_8'))
          .margin({top: $r('app.string.lpx_16')})

        Column() {
          Text(this.mAfterSaleDetailData?.goodsName ?? '')
            .width(Constants.FULL_PARENT)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .margin({
              top: $r('app.string.lpx_6'),
              left: $r('app.string.lpx_16'),
              right: $r('app.string.lpx_16')
            })
          Blank()
          Row() {
            Blank()
            Text(`共${this.mAfterSaleDetailData?.goodsNum ?? 0}件`)
              .fontColor($r('app.color.color_777777'))
              .fontSize(lpx2fp(28))
              .margin({ right: $r('app.string.lpx_16') })
            Text('￥')
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(20))
              .margin({ right: $r('app.string.lpx_5') })
            Text(AmountUtil.getRoundUp((this.mAfterSaleDetailData?.goodsPrices ?? 0) / 100,2))
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
          }
          .width(Constants.FULL_PARENT)
        }
        .height($r('app.string.lpx_180'))
        .layoutWeight(1)
        .margin({left: $r('app.string.lpx_16')})
      }
      .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder amountCell() {
    Column() {
      Row() {
        Text('申请金额')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text('￥')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(20))
          .margin({ right: $r('app.string.lpx_5') })
        Text(AmountUtil.getRoundUp((this.mAfterSaleDetailData?.appliedFee ?? 0) / 100,2))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      Row() {
        Text('合计退款')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text('￥')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(20))
          .margin({ right: $r('app.string.lpx_5') })
        Text(AmountUtil.getRoundUp((this.mAfterSaleDetailData?.refundFee ?? 0) / 100,2))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder typeReasonCell() {
    Column() {
      Row() {
        Text('售后类型')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Text('仅退款')
          .layoutWeight(1)
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(20))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .margin({left: $r('app.string.lpx_20')})
      }
      .width(Constants.FULL_PARENT)
      Row() {
        Text('退款原因')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Text(this.mAfterSaleDetailData?.reason ?? '')
          .layoutWeight(1)
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(20))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .margin({left: $r('app.string.lpx_20')})
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder afterSaleLog() {
    Row() {
      Text('售后记录')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))

      Blank()

      Image($r('app.media.ic_right'))
        .width($r('app.string.lpx_30'))
        .height($r('app.string.lpx_30'))
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.AFTER_SALE_RECORD_PAGE,
        params: {
          subOrderId: this.subOrderId,
          tenantId: this.tenantId
        }
      })
    })
  }

  @Builder orderCell() {
    Row() {
      Text('订单编号')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))

      Blank()

      Text(this.mAfterSaleDetailData?.orderNo ?? '')
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({right: $r('app.string.lpx_20')})

      Text('｜复制')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .onClick(() => {
      ClipboardUtil.copy(this.mAfterSaleDetailData?.orderNo ?? '')
    })
  }

  @Builder bottomAction() {
    Row() {
      Text('撤销申请')
        .height($r('app.string.lpx_64'))
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_EB4F3A'))
        .textAlign(TextAlign.Center)
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_32'),
          color: $r('app.color.color_EB4F3A')
        })
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
        .margin({ right: $r('app.string.lpx_20') })
        .onClick(() => {
          this.sendCancelAfterSaleRequest()
        })

      Text('修改申请')
        .height($r('app.string.lpx_64'))
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_777777'))
        .textAlign(TextAlign.Center)
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_32'),
          color: $r('app.color.color_777777')
        })
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
        .onClick(() => {
          App.get().pushUrl({
            url: RouterPath.MODIFY_ONLY_REFUND_PAGE,
            params: {
              data: this.mAfterSaleDetailData,
              tenantId: this.tenantId
            }
          })
        })
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_12'),
      bottom: $r('app.string.lpx_60'),
      right: $r('app.string.lpx_32')
    })
    .justifyContent(FlexAlign.End)
    .backgroundColor($r('app.color.white'))
  }
}