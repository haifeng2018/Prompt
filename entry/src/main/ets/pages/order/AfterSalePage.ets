import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { router } from '@kit.ArkUI';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import AfterSaleVM from 'lib_core_model/src/main/ets/vm/AfterSaleVM';
import { ToolBar } from '../../view/widget/ToolBar';
import { RefundConditionData } from 'lib_core_model/src/main/ets/data/RefundConditionData';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import AfterSaleUtil from '../../util/AfterSaleUtil';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';

@Entry
@Component
struct AfterSalePage {
  subOrderInfo?: SubOrderInfo = (router.getParams() as object)?.[Constants.DATA];
  orderNo?: string = (router.getParams() as object)?.[Constants.ORDER_NO];

  @State loginData: LoginData | null = null
  @State mRefundConditionData: RefundConditionData | null = null

  sendRefundConditionRequest () {
    AfterSaleVM.sendRefundConditionRequest(this.subOrderInfo?.tenantId ?? 0,this.loginData?.token ?? '',
      this.orderNo ?? '',this.subOrderInfo?.id ?? 0)
      .then((value: RefundConditionData) => {
        this.mRefundConditionData = value
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  refreshData () {
    this.sendRefundConditionRequest()
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  build() {
    Column() {
      ToolBar({title: '申请售后'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {
      this.courseCell()
      if (AfterSaleUtil.getRefundEnable(this.mRefundConditionData)) {
        this.onlyRefundCell()
      }
      if (AfterSaleUtil.getTimeOutCellVisibility(this.mRefundConditionData)) {
        this.timeoutCell()
      }
      if (AfterSaleUtil.getStudy30MinsCellVisibility(this.mRefundConditionData)) {
        this.study30MinsCell()
      }
      if (AfterSaleUtil.getExtendServicesCellVisibility(this.mRefundConditionData)) {
        this.extendServicesCell()
      }
      if (AfterSaleUtil.getExtendConsultCellVisibility(this.mRefundConditionData)) {
        this.extendConsultCell()
      }
      if (AfterSaleUtil.getNotSupportCellVisibility(this.mRefundConditionData)) {
        this.notSupportCell()
      }
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({top: $r('app.string.lpx_8')})
    .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder courseCell() {
    Column(){
      Row() {
        Text(this.subOrderInfo?.goodsMode === 1 ? '线下课' : '线上课')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text(AfterSaleUtil.getOrderStatus(this.subOrderInfo?.orderStatus))
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)

      Row() {
        Image(this.mRefundConditionData?.coverUrlExtendVo?.centre)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .borderRadius($r('app.string.lpx_8'))
          .margin({top: $r('app.string.lpx_16')})

        Column() {
          Text(this.subOrderInfo?.goodsName ?? '')
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
            Text(`共${this.subOrderInfo?.goodsNum ?? 0}件`)
              .fontColor($r('app.color.color_777777'))
              .fontSize(lpx2fp(28))
              .margin({ right: $r('app.string.lpx_16') })
            Text('￥')
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(20))
              .margin({ right: $r('app.string.lpx_5') })
            Text(AmountUtil.getRoundUp((this.subOrderInfo?.goodsPrices ?? 0) / 100,2))
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

  @Builder onlyRefundCell() {
    Row() {
      Text('仅退款')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .margin({left: $r('app.string.lpx_12')})

      Blank()

      Text(AfterSaleUtil.getAfterSaleTime(this.subOrderInfo?.afterSaleTime ?? 0))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({right: $r('app.string.lpx_8')})

      Image($r('app.media.ic_right'))
        .width($r('app.string.lpx_20'))
        .height($r('app.string.lpx_20'))
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .onClick(() => {
      App.get().replaceUrl({
        url: RouterPath.ONLY_REFUND_PAGE,
        params: {
          data: this.subOrderInfo,
          orderNo: this.orderNo
        }
      })
    })
  }

  @Builder timeoutCell() {
    Column() {
      Text('您已超过售后时间，如有疑问，请联系客服。')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .width(Constants.FULL_PARENT)
      Text('当前课程是7天未学可退')
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_20')})
        .width(Constants.FULL_PARENT)

      Text('联系客服')
        .height($r('app.string.lpx_52'))
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_EB4F3A'))
        .textAlign(TextAlign.Center)
        .border({
          width:$r('app.string.lpx_2'),
          radius: $r('app.string.lpx_26'),
          color: $r('app.color.color_DA3732')
        })
        .padding({left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20')})
        .margin({top: $r('app.string.lpx_100')})
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .alignItems(HorizontalAlign.End)
  }

  @Builder study30MinsCell() {
    Column() {
      Text() {
        ImageSpan($r('app.media.ic_after_sale_tip'))
          .width($r('app.string.lpx_30'))
          .height($r('app.string.lpx_30'))
          .verticalAlign(ImageSpanAlignment.CENTER)
        Span('\t\t不可申请退款')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
      }

      Text(AfterSaleUtil.getStudyTime(this.mRefundConditionData?.duration ?? 0))
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

      Text('当前课程您已学习超过30分钟总时长，不支持退款！')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_20')})

    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder extendServicesCell() {
    Column() {
      Text() {
        ImageSpan($r('app.media.ic_after_sale_tip'))
          .width($r('app.string.lpx_30'))
          .height($r('app.string.lpx_30'))
          .verticalAlign(ImageSpanAlignment.CENTER)
        Span('\t\t不可申请退款')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
      }

      Text('请联系客服申请开通延长售后卡！')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_32')})

    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder extendConsultCell() {
    Column() {
      Text() {
        ImageSpan($r('app.media.ic_after_sale_tip'))
          .width($r('app.string.lpx_30'))
          .height($r('app.string.lpx_30'))
          .verticalAlign(ImageSpanAlignment.CENTER)
        Span('\t\t不可申请退款')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
      }

      Text('当前订单售后需与您服务的助教进行协商沟通，沟通确认后客服开通售后卡进行售后处理！')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .textAlign(TextAlign.Center)
        .margin({top: $r('app.string.lpx_32')})
        .width(Constants.FULL_PARENT)

    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder notSupportCell() {
    Column() {
      Text() {
        ImageSpan($r('app.media.ic_after_sale_tip'))
          .width($r('app.string.lpx_30'))
          .height($r('app.string.lpx_30'))
          .verticalAlign(ImageSpanAlignment.CENTER)
        Span('\t\t不可申请退款')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
      }

      Text('当前课程在课程详细页面已明确标明不支持退款！')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_32')})

    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

}