import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { BuySource, SaleType } from 'lib_core_model/src/main/ets/util/Enums'
import PayOrderActionUtil from '../../util/action/PayOrderActionUtil'
import PayOrderUtil from '../../util/PayOrderUtil'

@Component
export struct CourseSaleStateDisplayComp {
  goodsInfo: GoodsInfo = new GoodsInfo()

  build() {
    if (this.goodsInfo.orderNo) {
      Text('已购买')
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(24))
    } else {
      if (this.goodsInfo.saleType == SaleType.Free) {
        Text('免费专享')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(24))
      } else {
        Text('去抢购')
          .width($r('app.string.lpx_106'))
          .height($r('app.string.lpx_48'))
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'), 0.0],
              [$r('app.color.color_F12E29'), 0.7],
              [$r('app.color.color_F12E29'), 1.0]
            ]
          })
          .borderRadius($r('app.string.lpx_12'))
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(24))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            PayOrderActionUtil.payOrder(PayOrderUtil.getOnlineOrderDetailData(BuySource.CourseList, this.goodsInfo))
          })
      }
    }
  }
}