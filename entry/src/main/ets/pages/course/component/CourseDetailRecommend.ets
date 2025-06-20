import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { BuySource } from 'lib_core_model/src/main/ets/util/Enums';
import Logger from 'lib_core_model/src/main/ets/util/Logger';

import CourseDetailActionUtil from '../../../util/action/CourseDetailActionUtil';
import PayOrderActionUtil from '../../../util/action/PayOrderActionUtil';
import PayOrderUtil from '../../../util/PayOrderUtil';
import { CoursePriceLineStyleDisplayComp } from '../../common/CoursePriceDisplayComp';
import { CourseSaleStateDisplayComp } from '../../common/CourseSaleStateDisplayComp';

/**
 * 课程推荐
 */
@Component
export default struct CourseDetailRecommend {
  tag: string = 'CourseDetailRecommend'
  @Prop @Watch('logger') recommendGoodsInfos: Array<GoodsInfo>

  logger() {
    this.recommendGoodsInfos.forEach(it => {
      Logger.info(this.tag, `mRecommendGoodsList = ${JSON.stringify(it)}`)
    })
  }

  onBuyClick(item: GoodsInfo) {
    PayOrderActionUtil.payOrder(PayOrderUtil.getOnlineOrderDetailData(BuySource.CourseList, item))
  }

  onItemClick(item: GoodsInfo) {
    CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0, item.onlineFlag, item.goodsId, 0);
  }

  build() {
    Column() {
      Text('推荐')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .padding({ bottom: $r('app.string.lpx_16'), top: $r('app.string.lpx_16') })

      ForEach(this.recommendGoodsInfos, (item: GoodsInfo, index: number) => {
        Row() {
          Image(item.coverUrlExtendVo?.centre)
            .alt($r('app.media.img_placeholder_vertical'))
            .objectFit(ImageFit.Cover)
            .width($r('app.string.lpx_180'))
            .height($r('app.string.lpx_180'))
            .border({ radius: $r('app.string.lpx_8') })

          Column() {
            Text(item.contentName)
              .width(Constants.FULL_PARENT)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(item.lecturers?.[0]?.lecturerLabel ?? '')
              .width(Constants.FULL_PARENT)
              .fontColor($r('app.color.color_777777'))
              .textAlign(TextAlign.Start)
              .fontSize(lpx2fp(24))
              .maxLines(1)
              .margin({ top: $r('app.string.lpx_8') })
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Blank()

            Row() {
              CoursePriceLineStyleDisplayComp({
                goodsInfo: item
              })
              Blank()
              CourseSaleStateDisplayComp({
                goodsInfo: item
              })
            }
            .width(Constants.FULL_PARENT)
            .margin({ top: $r('app.string.lpx_10') })
          }
          .layoutWeight(1)
          .height($r('app.string.lpx_180'))
          .margin({ left: $r('app.string.lpx_24') })
        }
        .width(Constants.FULL_PARENT)
        .borderRadius({
          topLeft: 0,
          topRight: 0,
          bottomLeft: index == this.recommendGoodsInfos.length - 1 ? $r('app.string.lpx_20') : 0,
          bottomRight: index == this.recommendGoodsInfos.length - 1 ? $r('app.string.lpx_20') : 0
        })
        .padding({
          top: $r('app.string.lpx_12'),
          bottom: $r('app.string.lpx_12')
        })
        .onClick(() => {
          this.onItemClick(item);
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .margin({ top: $r('app.string.lpx_28') })
    .padding({
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
    .visibility(this.recommendGoodsInfos.length > 0 ? Visibility.Visible : Visibility.Hidden)
  }
}
