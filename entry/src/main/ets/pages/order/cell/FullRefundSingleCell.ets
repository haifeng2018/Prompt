/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: FullRefundSingleCell
 * Author: Victor
 * Date: 2023/12/11 18:32
 * Description: 
 * -----------------------------------------------------------------
 */
import App from 'lib_core_model/src/main/ets/App';
import { OrderInfo } from 'lib_core_model/src/main/ets/data/OrderInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil';

@Component
export default struct FullRefundSingleCell {
  private data?: OrderInfo;
  onCellClick?: (data?: OrderInfo,index?: number) => void;
  public index: number = 0;

  build() {
    Column() {
      Row(){
        Image(this.data?.tenantVO?.logoUrl)
          .alt($r('app.media.ic_organ_place_holder'))
          .width($r('app.string.lpx_46'))
          .height($r('app.string.lpx_46'))
          .borderRadius($r('app.string.lpx_23'))
          .objectFit(ImageFit.Contain)

        Text(this.data?.tenantVO?.tenantName ?? '')
          .layoutWeight(1)
          .margin({left: $r('app.string.lpx_10')})
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})

        Image($r('app.media.ic_organ_right'))
          .width($r('app.string.lpx_20'))
          .height($r('app.string.lpx_20'))
          .objectFit(ImageFit.Contain)
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_88'))
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.ORGAN_MAIN_PAGE,
          params: {
            tenantId: this.data?.tenantVO?.tenantId
          }
        })
      })

      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))

      Row() {
        Text(this.data?.subOrderVos?.[0]?.goodsMode === 0 ? '线上课程' : '线下课程')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text('全部退款')
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_20')})

      Row() {
        Image(this.data?.subOrderVos?.[0]?.coverUrlExtendVo?.centre)
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .border({radius: $r('app.string.lpx_8')})
        Column() {
          Text(this.data?.subOrderVos?.[0]?.goodsName)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
          if (this.data?.subOrderVos?.[0]?.goodsMode === 1 && this.data?.subOrderVos[0]?.specName) {
            Text(this.data?.subOrderVos?.[0]?.specName)
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
              .textOverflow({overflow: TextOverflow.Ellipsis})
              .textAlign(TextAlign.Start)
          }
          Blank()
          Row() {
            Blank()
            Text(`共${this.data?.subOrderVos?.length ?? 0}件`)
              .fontColor($r('app.color.color_777777'))
              .fontSize(lpx2fp(28))
              .margin({right: $r('app.string.lpx_16')})
            Text('￥')
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(20))
              .margin({right: $r('app.string.lpx_5')})
            Text(AmountUtil.getRoundUp((this.data?.goodsTotalFee ?? 0) / 100,2))
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
          }
          .width(Constants.FULL_PARENT)
          .alignItems(VerticalAlign.Bottom)
        }
        .layoutWeight(1)
        .height($r('app.string.lpx_180'))
        .padding({left: $r('app.string.lpx_20')})
        .alignItems(HorizontalAlign.Start)
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_20')})

      Row() {
        Blank()
        Text('实付金额：')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .margin({right: $r('app.string.lpx_10')})
        Text('￥')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(20))
          .margin({right: $r('app.string.lpx_5')})
        Text(GoodsShowUtil.getShouldPayAmt(this.data))
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(36))
      }
      .width(Constants.FULL_PARENT)
      .alignItems(VerticalAlign.Bottom)
      .margin({top: $r('app.string.lpx_20')})

      Row() {
        Text('订单编号')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Text(this.data?.orderNo)
          .margin({right: $r('app.string.lpx_10')})
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .textAlign(TextAlign.End)
          .layoutWeight(1)
        Text('｜复制')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      .alignItems(VerticalAlign.Bottom)
      .margin({top: $r('app.string.lpx_32')})
      .onClick(() => {
        ClipboardUtil.copy(this.data?.orderNo ?? '')
      })

    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({top: $r('app.string.lpx_40')})
    .padding({
      bottom: $r('app.string.lpx_20'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
    .onClick(() => this.onCellClick?.(this.data,this.index))
  }
}
