import AfterSaleVM from 'lib_core_model/src/main/ets/vm/AfterSaleVM';
import { router } from '@kit.ArkUI';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { ToolBar } from '../../view/widget/ToolBar';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import AfterSaleUtil from '../../util/AfterSaleUtil';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import { AfterSaleDetailData } from 'lib_core_model/src/main/ets/data/AfterSaleDetailData';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import App from 'lib_core_model/src/main/ets/App';

@Entry
@Component
struct AfterSaleOrderClosePage {
  subOrderId?: number = (router.getParams() as object)?.[Constants.SUB_ORDER_ID];
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID];

  @State loginData: LoginData | null = null
  @State mAfterSaleDetailData: AfterSaleDetailData | null = null

  sendAfterSaleDetailRequest () {
    AfterSaleVM.sendAfterSaleDetailRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.subOrderId ?? 0)
      .then((value: AfterSaleDetailData) => {
        this.mAfterSaleDetailData = value
      }).catch((err: string | Resource) => {
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
      ToolBar({title: '退款详情'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {
      Text('售后订单已关闭')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_140'))
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_12'))
        .textAlign(TextAlign.Center)

      this.courseCell()
      this.amountCell()
      this.typeReasonCell()
      this.afterSaleLog()
      this.orderCell()
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({top: $r('app.string.lpx_8')})
    .padding({
      top: $r('app.string.lpx_24'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
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
}