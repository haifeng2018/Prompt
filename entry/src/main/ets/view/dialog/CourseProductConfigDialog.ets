import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { GoodsSpecData } from 'lib_core_model/src/main/ets/data/GoodsSpecData'
import { GoodsSpecInfo } from 'lib_core_model/src/main/ets/data/GoodsSpecInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { BuySource } from 'lib_core_model/src/main/ets/util/Enums'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import ShoppingCartVM from 'lib_core_model/src/main/ets/vm/ShoppingCartVM'
import PayOrderActionUtil from '../../util/action/PayOrderActionUtil'
import PayOrderUtil from '../../util/PayOrderUtil'

@CustomDialog
export default struct CourseProductConfigDialog {
  tag: string = 'CourseProductConfigDialog'
  controller: CustomDialogController
  @Prop goodsInfo: GoodsInfo | null = null
  @State goodsSpecData: GoodsSpecData | null = null
  @State goodsSpecInfo: GoodsSpecInfo | null = null
  @State index: number = -1
  @State buyCount: number = 1

  aboutToAppear(): void {
    this.sendGoodsSpecRequest()
  }

  sendGoodsSpecRequest() {
    ShoppingCartVM.sendGoodsSpecRequest(this.goodsInfo?.tenantVO?.tenantId ?? 0, this.goodsInfo?.goodsId ?? '')
      .then((value: GoodsSpecData) => {
        this.goodsSpecData = value
        let specList = this.goodsSpecData?.specList as Array<GoodsSpecInfo>
        if (specList.length > 0 && (specList[0]?.goodsNum ?? 0 > 0)) {
          this.goodsSpecInfo = specList[0]
        }
      })
      .catch((err: string) => {
        ToastUtils.show(err)
      })
  }

  toBuy() {
    if (this.goodsSpecInfo) {
      let orderDetailData = PayOrderUtil.getOfflineOrderDetailData(
        BuySource.CourseDetail,
        this.goodsInfo,
        this.goodsSpecData,
        this.goodsSpecInfo?.specName,
        this.goodsSpecInfo?.specId,
        this.buyCount
      )
      PayOrderActionUtil.payOrder(orderDetailData)
      this.controller.close()
    } else {
      ToastUtils.show('请选择规格')
    }
  }

  buySub() {
    let count = this.buyCount - 1
    if (count < 0) {
      this.buyCount = 0
    } else {
      this.buyCount = count
    }
  }

  buyAdd() {
    let count = this.buyCount + 1
    let goodsNum = this.goodsSpecData?.goodsNum ?? 0
    if (count > goodsNum) {
      ToastUtils.show('该课程不能购买更多')
    } else {
      this.buyCount = count
    }
  }

  build() {
    Column() {
      this.titleLine()
      this.buyContentLine()
      this.buyProductConfigLine()
      this.buyCountLine()
      this.buyLine()
    }
    .height('60%')
    .width(Constants.FULL_PARENT)
    .backgroundColor(Color.White)
    .borderRadius({
      topLeft: $r('app.string.lpx_20'),
      topRight: $r('app.string.lpx_20')
    })
    .padding({
      bottom: $r('app.string.lpx_100'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }

  @Builder
  buyContentLine() {
    Row() {
      Image(this.goodsSpecData?.coverUrl)
        .alt($r('app.media.img_placeholder_horizontal'))
        .objectFit(ImageFit.Cover)
        .width($r('app.string.lpx_240'))
        .height($r('app.string.lpx_180'))
        .borderRadius($r('app.string.lpx_8'))

      Column() {
        Text() {
          Span('￥')
            .fontSize(lpx2fp(28))
          Span(GoodsShowUtil.formatPriceToYuan(this.goodsSpecData?.salePrice ?? 0))
            .fontSize(lpx2fp(52))
          Span('\t')
          Span(`剩余${this.goodsSpecData?.goodsNum ?? 0}份`)
            .fontSize(lpx2fp(24))
        }
        .fontColor($r('app.color.color_DA3732'))
        .textAlign(TextAlign.End)

        Text(`可参与${this.goodsSpecData?.peopleNum ?? 0}人`)
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_999999'))
          .margin({
            top: $r('app.string.lpx_20')
          })

        Text(`已选${this.goodsSpecInfo?.specName}`)
          .fontSize(lpx2fp(32))
          .fontColor($r('app.color.color_666666'))
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .visibility(this.goodsSpecInfo?.specName ? Visibility.Visible : Visibility.Hidden)
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({
        left: $r('app.string.lpx_16')
      })
    }
    .alignItems(VerticalAlign.Top)
  }

  @Builder
  titleLine() {
    Stack() {
      Text('规格选择')
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .textAlign(TextAlign.Center)

      Image($r('app.media.ic_dlg_feedback_type_close'))
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
        .onClick(() => {
          this.controller.close()
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_112'))
    .alignContent(Alignment.End)
  }

  @Builder
  buyProductConfigLine() {
    Text('规格')
      .width(Constants.FULL_PARENT)
      .fontSize(lpx2fp(32))
      .fontColor($r('app.color.color_333333'))
      .margin({
        top: $r('app.string.lpx_40'),
        bottom: $r('app.string.lpx_40')
      })
      .textAlign(TextAlign.Start)

    List({ space: 10 }) {
      ForEach(this.goodsSpecData?.specList, (item: GoodsSpecInfo, index: number) => {
        ListItem() {
          Text(item.specName)
            .fontSize(lpx2fp(24))
            .fontColor(this.index == index ? $r('app.color.color_DA3732') : $r('app.color.color_777777'))
            .border({
              width: $r('app.string.lpx_2'),
              radius: $r('app.string.lpx_26'),
              color: this.index == index ? $r('app.color.color_DA3732') : $r('app.color.color_777777')
            })
            .padding({
              left: $r('app.string.lpx_30'),
              right: $r('app.string.lpx_30'),
              top: $r('app.string.lpx_10'),
              bottom: $r('app.string.lpx_10')
            })
            .onClick(() => {
              if ((item.goodsNum ?? 0) > 0) {
                this.index = index
                this.goodsSpecInfo = item
              }
            })
        }
      })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_50'))
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
  }

  @Builder
  buyCountLine() {
    Row() {
      Text('数量')
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
        .layoutWeight(1)
        .textAlign(TextAlign.Start)

      Row() {
        Image($r('app.media.ic_count_sub'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .padding($r('app.string.lpx_10'))
          .onClick(() => {
            this.buySub()
          })
        Text(this.buyCount.toString())
          .height($r('app.string.lpx_48'))
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
          .border({
            width: { left: $r('app.string.lpx_2'), right: $r('app.string.lpx_2') },
            color: $r('app.color.color_E6E6E6'),
          })
        Image($r('app.media.ic_count_add'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .padding($r('app.string.lpx_10'))
          .onClick(() => {
            this.buyAdd()
          })
      }
      .border({
        width: $r('app.string.lpx_2'),
        color: $r('app.color.color_E6E6E6'),
      })
    }
    .width(Constants.FULL_PARENT)
    .margin({
      top: $r('app.string.lpx_40'),
      bottom: $r('app.string.lpx_40')
    })
  }

  @Builder
  buyLine() {
    Blank()
    Text('立即支付')
      .height($r('app.string.lpx_80'))
      .width(Constants.FULL_PARENT)
      .linearGradient({
        angle: 90,
        colors: [
          [$r('app.color.color_FC6D38'), 0.0],
          [$r('app.color.color_F12E29'), 0.7],
          [$r('app.color.color_F12E29'), 1.0]
        ]
      })
      .borderRadius($r('app.string.lpx_16'))
      .fontColor($r('app.color.white'))
      .fontSize(lpx2fp(28))
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Center)
      .margin({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32'), bottom: $r('app.string.lpx_42') })
      .onClick(() => {
        this.toBuy()
      })
  }
}