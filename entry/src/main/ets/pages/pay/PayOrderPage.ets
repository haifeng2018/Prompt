import { Pay } from '@cashier_alipay/cashiersdk'
import { JSON } from '@kit.ArkTS'
import { BusinessError } from '@kit.BasicServicesKit'
import common from '@ohos.app.ability.common'
import router from '@ohos.router'
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'
import App from 'lib_core_model/src/main/ets/App'
import { AddGoodOrderInfo } from 'lib_core_model/src/main/ets/data/AddGoodOrderInfo'
import { AddGoodOrderParm } from 'lib_core_model/src/main/ets/data/AddGoodOrderParm'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { OrderDetailData } from 'lib_core_model/src/main/ets/data/OrderDetailData'
import { PayInfo } from 'lib_core_model/src/main/ets/data/PayInfo'
import { PreOrderParm } from 'lib_core_model/src/main/ets/data/PreOrderParm'
import { RecommendCouponBean } from 'lib_core_model/src/main/ets/data/RecommendCouponBean'
import { RecommendCouponData } from 'lib_core_model/src/main/ets/data/RecommendCouponData'
import { RecommendCouponParm } from 'lib_core_model/src/main/ets/data/RecommendCouponParm'
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { PaymentMethod } from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import OrderVM from 'lib_core_model/src/main/ets/vm/OrderVM'
import PayUtil from '../../util/PayUtil'
import LoadingDialog from '../../view/dialog/LoadingDialog'
import OrderCouponSelectDialog from '../../view/dialog/OrderCouponSelectDialog'
import { ToolBar } from '../../view/widget/ToolBar'

@Entry
@Component
struct PayOrderPage {
  tag: string = 'PayOrderPage'
  orderNo: string = (router.getParams() as object)?.[Constants.ORDER_NO]
  @State orderDetailData: OrderDetailData = (router.getParams() as object)?.[Constants.DATA]
  @State loginData: LoginData | null = null
  @State payWay: number = PaymentMethod.ALIPAY
  @State recommendCouponData: RecommendCouponData | null = null
  @State queryPayResultTimes: number = 0
  @State updatePayResult: boolean = false // 是否刷新支付状态
  @State couponVisibility: boolean = false
  private PAY_RESULT_INTERVAL_TIME: number = 5000 // 5s查询一次
  private loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })
  private orderCouponSelectDlgCtrl: CustomDialogController = new CustomDialogController({
    builder: OrderCouponSelectDialog({ mRecommendCouponData: this.recommendCouponData }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })
  private timeoutID: number = 0

  aboutToAppear() {
    Logger.info(this.tag, `aboutToAppear`)
    Logger.info(this.tag, `mOrderDetailData = ${JSON.stringify(this.orderDetailData)}`)

    const discountFee = this.orderDetailData?.discountsFee ?? 0
    if (discountFee == 0 || this.orderDetailData?.changedPrice) {
      this.couponVisibility = false
    } else {
      this.couponVisibility = true
    }

    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      if (this.orderNo) {
        this.sendOrderDetailRequest()
      } else {
        this.sendRecommendCouponRequest()
      }
    })
  }

  onPageShow() {
    Logger.info(this.tag, `onPageShow`)
  }

  onPageHide() {
    Logger.info(this.tag, `onPageHide`)
    this.updatePayResult = false
  }

  aboutToDisappear() {
    Logger.info(this.tag, `aboutToDisappear`)
    clearTimeout(this.timeoutID)
  }

  sendOrderDetailRequest() {
    let tenantId = this.orderDetailData?.subOrderVos?.[0]?.tenantId ?? 0
    OrderVM.sendOrderDetailRequest(tenantId, this.loginData?.token ?? '', this.orderNo)
      .then((value: OrderDetailData) => {
        this.orderDetailData = value
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  sendRecommendCouponRequest() {
    let tenantId = this.orderDetailData?.subOrderVos?.[0]?.tenantId ?? 0
    const body = new RecommendCouponParm()
    const items = Array<RecommendCouponBean>()
    this.orderDetailData?.subOrderVos?.forEach((value: SubOrderInfo) => {
      const bean = new RecommendCouponBean()
      bean.goodsId = value.goodsId
      bean.salePrice = value.goodsPrices
      bean.specId = value.specId
      items.push(bean)
    })
    body.reqList = items
    OrderVM.sendRecommendCouponRequest(tenantId, this.loginData?.token ?? '', body)
      .then((value: RecommendCouponData) => {
        this.recommendCouponData = value

        // 如果之前没有领券，这里获取优惠券，支付金额会发生变化，所以要刷新
        let goodsTotalFee = this.orderDetailData.goodsTotalFee ?? 0
        let payerTotal = goodsTotalFee - (this.recommendCouponData?.discountFee ?? 0)
        this.orderDetailData.payerTotal = payerTotal

        const discountFee = value?.discountFee ?? 0
        if (discountFee == 0 || this.orderDetailData?.changedPrice) {
          this.couponVisibility = false
        } else {
          this.couponVisibility = true
        }
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  sendAddGoodOrderRequest() {
    this.loadingDialogCtrl.open()

    let goodOrderInfos = Array<AddGoodOrderInfo>()
    this.orderDetailData?.subOrderVos?.forEach(it => {
      let item = new AddGoodOrderInfo()
      item.goodsId = it.goodsId
      item.goodsNum = it.goodsNum
      item.specId = it.specId
      goodOrderInfos.push(item)
    })

    let tenantId = this.orderDetailData?.subOrderVos?.[0]?.tenantId ?? 0

    let body = new AddGoodOrderParm()
    body.goodsOrders = goodOrderInfos
    body.userCouponNoList = this.recommendCouponData?.userCouponNoList

    OrderVM.sendAddGoodOrderRequest(tenantId, this.loginData?.token ?? '', body).then((value: OrderDetailData) => {
      this.loadingDialogCtrl.close()
      this.orderDetailData.orderNo = value.orderNo
      this.sendPreOrderRequest()
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      if (err == '5060') {
        this.sendRecommendCouponRequest()
      }
      ToastUtils.show(err)
    })
  }

  sendPreOrderRequest() {
    this.loadingDialogCtrl.open()

    let tenantId = this.orderDetailData?.subOrderVos?.[0]?.tenantId ?? 0

    let body = new PreOrderParm()
    body.orderNo = this.orderDetailData?.orderNo
    body.payerTotal = this.orderDetailData?.payerTotal || 0
    body.paymentType = this.payWay
    body.tradeType = 1

    OrderVM.sendPreOrderRequest(tenantId, this.loginData?.token ?? '', body).then((value: PayInfo) => {
      this.updatePayResult = false
      this.loadingDialogCtrl.close()
      this.payAction(value)
    }).catch((err: string | Resource) => {
      this.updatePayResult = false
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendOrderResultRequest() {
    let tenantId = this.orderDetailData?.subOrderVos?.[0]?.tenantId ?? 0
    OrderVM.sendOrderResultRequest(tenantId, this.loginData?.token ?? '', this.orderDetailData?.orderNo ?? '')
      .then((value: object) => {
        this.loadingDialogCtrl.close()
        this.updatePayResult = false
        App.get().replaceUrl({
          url: RouterPath.PAY_SUCCESS_PAGE,
          params: {
            data: this.orderDetailData
          }
        })
      })
      .catch((err: string | Resource) => {
        this.loadingDialogCtrl.close()
        let code: number = Number.parseInt(err.toString())
        if (code == 100401) { //未支付
          this.updatePayResult = true
          return
        }
        this.updatePayResult = false
        App.get().replaceUrl({
          url: RouterPath.PAY_FAILED_PAGE,
          params: {
            data: this.orderDetailData,
            error: err
          }
        })
      })
  }

  payAction(data: PayInfo) {
    Logger.info(this.tag, `payInfo = ${JSON.stringify(data)}`)
    if (this.payWay === 1) {
      //微信支付
      this.startTimer()
    } else if (this.payWay === 2) {
      this.aliPay(data?.orderInfo)
      //支付宝支付
      this.startTimer()
    } else if (this.payWay === 3) {
      //华为支付
      let context = getContext(this) as common.UIAbilityContext
      PayUtil.requestPayment(context, data.prePayTn ?? '')
        .then(() => {
          // succeeded in paying
          console.info('succeeded in paying')
        })
        .catch((error: BusinessError) => {
          // failed to pay
          ToastUtils.show(`failed to pay, error.code: ${error.code}, error.message: ${error.message}`)
        })
      this.startTimer()
    }
  }

  aliPay(orderInfo?: string) {
    Logger.info(this.tag, `orderInfo = ${orderInfo}`)
    // orderInfo 由服务端生成 第二个参数 控制是否展示支付宝loading
    new Pay().pay(orderInfo, true)
      .then((result) => {
        this.sendOrderResultRequest()
        Logger.info(
          this.tag,
          `resultStatus: ${result.get('resultStatus')}, memo: ${result.get('memo')}, result: ${result.get('result')}`
        )
      })
      .catch((error: BusinessError) => {
        Logger.error(this.tag, `result = ${error.message}`)
        this.sendOrderResultRequest()
      })
  }

  startTimer() {
    clearTimeout(this.timeoutID)
    this.queryPayResultTimes = 1000 * 60 * 30 //半小时后未支付则取消
    this.timeoutID = setInterval(() => {
      if (this.queryPayResultTimes === 0) {
        //半小时后未支付系统将取消订单
      } else {
        this.queryPayResultTimes -= this.PAY_RESULT_INTERVAL_TIME
        if (this.updatePayResult) {
          this.sendOrderResultRequest()
        }
      }
    }, this.PAY_RESULT_INTERVAL_TIME)
  }

  build() {
    Column() {
      ToolBar({ title: '支付订单' })
      this.contentBuilder()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  contentBuilder() {
    List() {
      ListItem() {
        if ((this.orderDetailData?.subOrderVos?.length ?? 0) > 1) {
          this.multiGoodsBuilder()
        } else {
          this.singleGoodsBuilder()
        }
      }

      ListItem() {
        this.priceDetailBuilder()
      }

      ListItem() {
        this.payWayBuilder()
      }

      ListItem() {
        this.describeBuilder()
      }
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      top: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .zIndex(0)

    this.bottomBuilder()
  }

  @Builder
  singleGoodsBuilder() {
    Row() {
      Image(this.orderDetailData?.subOrderVos?.[0]?.coverUrlExtendVo?.centre)
        .width($r('app.string.lpx_180'))
        .height($r('app.string.lpx_180'))
        .border({ radius: $r('app.string.lpx_8') })
      Column() {
        Text(this.orderDetailData?.subOrderVos?.[0]?.goodsName)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        if (this.orderDetailData?.subOrderVos?.[0]?.goodsMode === 1 &&
          this.orderDetailData?.subOrderVos[0]?.specName) {
          Text(this.orderDetailData?.subOrderVos?.[0]?.specName)
            .margin({
              top: $r('app.string.lpx_8')
            })
            .padding({
              top: $r('app.string.lpx_4'),
              bottom: $r('app.string.lpx_4'),
              left: $r('app.string.lpx_20'),
              right: $r('app.string.lpx_20')
            })
            .backgroundColor($r('app.color.color_F5F5F5'))
            .borderRadius($r('app.string.lpx_4'))
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
        }
        Blank()
        Row() {
          Text('￥')
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(24))
            .margin({ right: $r('app.string.lpx_5') })
          Text(AmountUtil.getRoundUp((this.orderDetailData?.subOrderVos?.[0]?.goodsPrices ?? 0) / 100, 2))
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(28))
          Blank()
          Text(`共${this.orderDetailData?.subOrderVos?.[0]?.goodsNum ?? 0}件`)
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(28))
            .margin({ right: $r('app.string.lpx_16') })
        }
        .width(Constants.FULL_PARENT)
        .alignItems(VerticalAlign.Bottom)
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .padding({ left: $r('app.string.lpx_20') })
      .alignItems(HorizontalAlign.Start)
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .padding($r('app.string.lpx_20'))
  }

  @Builder
  multiGoodsBuilder() {
    Column() {
      Text('订单商品')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .padding($r('app.string.lpx_20'))

    Row() {
      List() {
        ForEach(this.orderDetailData?.subOrderVos, (item: SubOrderInfo) => {
          ListItem() {
            Image(item?.coverUrlExtendVo?.centre)
              .width(Constants.FULL_PARENT)
              .height(Constants.FULL_PARENT)
              .objectFit(ImageFit.Cover)
          }
          .width($r('app.string.lpx_100'))
          .height($r('app.string.lpx_100'))
        })
      }
      .layoutWeight(1)
      .margin({ top: $r('app.string.lpx_34') })

      Text(`共${this.orderDetailData?.subOrderVos?.length ?? 0}件`)
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))

      Image($r('app.media.ic_right'))
        .width($r('app.string.lpx_34'))
        .height($r('app.string.lpx_34'))
        .objectFit(ImageFit.Contain)
    }
    .margin({ top: $r('app.string.lpx_20') })
  }

  @Builder
  priceDetailBuilder() {
    Column() {
      Text('价格明细')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({ top: $r('app.string.lpx_20') })

      Row() {
        Text('商品总价')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text(`￥${AmountUtil.getRoundUp((this.orderDetailData?.goodsTotalFee ?? 0) / 100, 2)}`)
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .margin({ right: $r('app.string.lpx_28') })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_18') })

      if (this.orderDetailData?.changedPrice) {
        Row() {
          Text('商品优惠')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
          Blank()
          Text(`-￥${AmountUtil.getRoundUp((this.orderDetailData.discountsFee ?? 0) / 100, 2)}`)
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(28))
            .margin({ right: $r('app.string.lpx_28') })
        }
        .width(Constants.FULL_PARENT)
        .margin({ top: $r('app.string.lpx_32') })
      }

      if (this.couponVisibility) {
        Row() {
          Text('优惠券')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
          Text('已选推荐优惠')
            .fontColor($r('app.color.color_FF1F00'))
            .fontSize(lpx2fp(20))
            .margin({ left: $r('app.string.lpx_8') })
            .border({
              width: $r('app.string.lpx_2'),
              color: $r('app.color.color_FF1F00'),
              radius: $r('app.string.lpx_4')
            })
            .padding({
              top: $r('app.string.lpx_2'),
              bottom: $r('app.string.lpx_2'),
              left: $r('app.string.lpx_8'),
              right: $r('app.string.lpx_8'),
            })
          Blank()
          Text(`-￥${AmountUtil.getRoundUp((this.recommendCouponData?.discountFee ?? 0) / 100, 2)}`)
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(28))
            .margin({ right: $r('app.string.lpx_8') })
          Image($r('app.media.ic_right'))
            .width($r('app.string.lpx_20'))
            .height($r('app.string.lpx_20'))
            .objectFit(ImageFit.Contain)
        }
        .width(Constants.FULL_PARENT)
        .margin({ top: $r('app.string.lpx_32') })
        .onClick(() => {
          this.orderCouponSelectDlgCtrl.open()
        })
      }

      Row() {
        Text('应付金额')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text(`￥${AmountUtil.getRoundUp((this.orderDetailData.payerTotal ?? 0) / 100, 2)}`)
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
          .margin({ right: $r('app.string.lpx_28') })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_32') })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({ top: $r('app.string.lpx_32') })
    .padding($r('app.string.lpx_20'))
  }

  @Builder
  payWayBuilder() {
    Column() {
      Row() {
        Image($r('app.media.ic_pay_way'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))

        Text('支付方式')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
          .margin({ left: $r('app.string.lpx_12') })
      }
      .width(Constants.FULL_PARENT)

      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({
          top: $r('app.string.lpx_20'),
          left: $r('app.string.lpx_20'),
          right: $r('app.string.lpx_20'),
        })

      // Row() {
      //   Image($r('app.media.ic_huawei_pay'))
      //     .width($r('app.string.lpx_60'))
      //     .height($r('app.string.lpx_60'))
      //
      //   Text('华为支付')
      //     .fontColor($r('app.color.color_333333'))
      //     .fontSize(lpx2fp(32))
      //     .fontWeight(FontWeight.Bold)
      //     .margin({ left: $r('app.string.lpx_12') })
      //
      //   Blank()
      //
      //   Image(this.payWay === 3 ? $r('app.media.ic_pay_way_checked') : $r('app.media.ic_pay_way_normal'))
      //     .width($r('app.string.lpx_28'))
      //     .height($r('app.string.lpx_28'))
      // }
      // .width(Constants.FULL_PARENT)
      // .margin({ top: $r('app.string.lpx_20') })
      // .padding({
      //   top: $r('app.string.lpx_12'),
      //   bottom: $r('app.string.lpx_12')
      // })
      // .onClick(() => {
      //   this.payWay = 3
      // })

      Row() {
        Image($r('app.media.ic_ali_pay'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))

        Text('支付宝支付')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
          .margin({ left: $r('app.string.lpx_12') })

        Blank()

        Image(this.payWay === 2 ? $r('app.media.ic_pay_way_checked') : $r('app.media.ic_pay_way_normal'))
          .width($r('app.string.lpx_28'))
          .height($r('app.string.lpx_28'))
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_20') })
      .padding({
        top: $r('app.string.lpx_12'),
        bottom: $r('app.string.lpx_12')
      })
      .onClick(() => {
        this.payWay = 2
      })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({ top: $r('app.string.lpx_32') })
    .padding($r('app.string.lpx_20'))
  }

  @Builder
  describeBuilder() {
    Column() {
      Row() {
        Text()
          .width($r('app.string.lpx_8'))
          .height($r('app.string.lpx_8'))
          .backgroundColor($r('app.color.color_999999'))
          .borderRadius($r('app.string.lpx_4'))

        Text('内含学习资料、PPT')
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .margin({ left: $r('app.string.lpx_12') })
      }
      .width(Constants.FULL_PARENT)
      .padding({
        top: $r('app.string.lpx_6'),
        bottom: $r('app.string.lpx_6')
      })

      Row() {
        Text()
          .width($r('app.string.lpx_8'))
          .height($r('app.string.lpx_8'))
          .backgroundColor($r('app.color.color_999999'))
          .borderRadius($r('app.string.lpx_4'))

        Text('购买后可在「我的-订单」中查看订单详情')
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .margin({ left: $r('app.string.lpx_12') })
      }
      .width(Constants.FULL_PARENT)
      .padding({
        top: $r('app.string.lpx_6'),
        bottom: $r('app.string.lpx_6')
      })
    }
    .width(Constants.FULL_PARENT)
    .margin({ top: $r('app.string.lpx_32') })
  }

  @Builder
  bottomBuilder() {
    Row() {
      Text('总计：')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))

      Text(`¥${AmountUtil.getRoundUp((this.orderDetailData?.payerTotal ?? 0) / 100, 2)}`)
        .fontColor($r('app.color.color_EB4F3A'))
        .fontSize(lpx2fp(40))
        .layoutWeight(1)
        .margin({ left: $r('app.string.lpx_15') })

      Button('确认支付', { type: ButtonType.Normal, stateEffect: true })
        .height($r('app.string.lpx_88'))
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_44'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))
        .padding({
          left: $r('app.string.lpx_120'),
          right: $r('app.string.lpx_120')
        })
        .onClick(() => {
          this.sendAddGoodOrderRequest()
        })
    }
    .backgroundColor($r('app.color.white'))
    .padding({
      top: $r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_60'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
