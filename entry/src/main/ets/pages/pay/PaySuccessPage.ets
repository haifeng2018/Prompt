import router from '@ohos.router';
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil';
import App from 'lib_core_model/src/main/ets/App';
import { OrderDetailData } from 'lib_core_model/src/main/ets/data/OrderDetailData';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';

@Entry
@Component
struct PaySuccessPage {
  mOrderDetailData: OrderDetailData = (router.getParams() as object)?.[Constants.DATA];

  build() {
    Column() {
      this.titleBarBuilder()
      this.contentBuilder()
      this.bottomBuilder()
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
        this.headerBuilder()
      }
      .margin({
        top: $r('app.string.lpx_16'),
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32'),
      })

      ListItem() {
        this.orderCellBuilder()
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
  headerBuilder() {
    Column() {
      Image($r('app.media.img_pay_success'))
        .width($r('app.string.lpx_120'))
        .height($r('app.string.lpx_120'))
      Text('您已购买成功')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .margin({ top: $r('app.string.lpx_40') })
      Text('您可以马上开始课程学习了！')
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
  orderCellBuilder() {
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

  @Builder
  bottomBuilder() {
    Blank()
    Row() {
      Text('立即学习')
        .height($r('app.string.lpx_80'))
        .layoutWeight(1)
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
        .margin({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32'), bottom: $r('app.string.lpx_40') })
        .onClick(() => {
          let array = this.mOrderDetailData.subOrderVos as Array<SubOrderInfo>
          let subOrderInfo = array[0]
          CourseDetailActionUtil.courseDetail(
            this.mOrderDetailData?.tenantId ?? 0,
            subOrderInfo?.goodsMode ?? 0,
            subOrderInfo?.goodsId ?? '',
            -1,
            true
          )
        })
    }
    .width(Constants.FULL_PARENT)
  }
}
