import router from '@ohos.router';
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil';
import App from 'lib_core_model/src/main/ets/App';
import { OrderDetailData } from 'lib_core_model/src/main/ets/data/OrderDetailData';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';

@Entry
@Component
struct PayFailedPage {
  mOrderDetailData: OrderDetailData = (router.getParams() as object)?.[Constants.DATA];
  error: string = (router.getParams() as object)?.[Constants.ERROR];

  build() {
    Column() {
      this.titleBarBuilder()
      this.contentBuilder()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  titleBarBuilder() {
    Row() {
      Text() {
        ImageSpan($r('app.media.ic_back'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .objectFit(ImageFit.Contain)
      }
      .textAlign(TextAlign.Start)
      .layoutWeight(1)
      .margin({ left: $r('app.string.lpx_32') })
      .onClick(() => {
        App.get().back()
      })

      Text('支付订单')
        .height($r('app.string.lpx_98'))
        .fontSize(lpx2fp(36))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(FontWeight.Bold)

      Text('订单详情')
        .layoutWeight(1)
        .width($r('app.string.lpx_200'))
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_777777'))
        .textAlign(TextAlign.End)
        .margin({ right: $r('app.string.lpx_32') })
        .padding({
          top: $r('app.string.lpx_20'),
          bottom: $r('app.string.lpx_20')
        })
        .onClick(() => {
          App.get().pushUrl({
            url: RouterPath.ORDER_DETAIL_PAGE,
            params: {
              data: this.mOrderDetailData?.orderNo
            }
          })
        })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({ top: $r('app.string.lpx_60') })
  }

  @Builder
  contentBuilder() {
    List() {
      ListItem() {
        this.header()
      }
      .margin({
        top: $r('app.string.lpx_16'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32'),
      })

      ListItem() {
        this.orderCell()
      }
      .margin({
        top: $r('app.string.lpx_20'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')
      })
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
  }

  @Builder
  header() {
    Column() {
      Image($r('app.media.img_pay_failed'))
        .width($r('app.string.lpx_120'))
        .height($r('app.string.lpx_120'))
      Text('支付失败')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .margin({ top: $r('app.string.lpx_40') })
      Text(`失败原因：${this.error || ''}`)
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({ top: $r('app.string.lpx_20') })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .padding($r('app.string.lpx_20'))
  }

  @Builder
  orderCell() {
    Row() {
      Text('订单编号')
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
        .margin({ left: $r('app.string.lpx_20') })
      Text(this.mOrderDetailData?.orderNo)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_777777'))
        .layoutWeight(1)
        .textAlign(TextAlign.End)
      Text('｜复制')
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_333333'))
        .padding($r('app.string.lpx_20'))
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .onClick(() => {
      ClipboardUtil.copy(this.mOrderDetailData?.orderNo ?? '')
    })
  }
}
