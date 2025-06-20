/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: FullRefundMultiCell
 * Author: Victor
 * Date: 2023/12/11 18:32
 * Description: 
 * -----------------------------------------------------------------
 */
import App from 'lib_core_model/src/main/ets/App';
import { OrderInfo } from 'lib_core_model/src/main/ets/data/OrderInfo';
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import OrderGoodsDialog from '../../../view/dialog/OrderGoodsDialog';
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil';

@Component
export default struct FullRefundMultiCell {
  private data?: OrderInfo;
  onCellClick?: (data?: OrderInfo,index?: number) => void;
  public index: number = 0;

  orderGoodsDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: OrderGoodsDialog(
      {
        subOrderInfos: this.getSubOrderList(),
      }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

  getSubOrderList(): Array<SubOrderInfo> {
    return this.data?.subOrderVos ?? []
  }

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
        Text('多个课程')
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
        this.courseContent()

        Text(`共${this.data?.subOrderVos?.length ?? 0}件`)
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .margin({right: $r('app.string.lpx_16')})

        Image($r('app.media.ic_right'))
        .width($r('app.string.lpx_12'))
        .height($r('app.string.lpx_20'))

      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_20')})
      .onClick(() => {
        this.orderGoodsDialogCtrl.open()
      })

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

  @Builder courseContent() {
    List() {
      ForEach(GoodsShowUtil.getCourseByCount(this.data?.subOrderVos,3), (item: SubOrderInfo,index) => {
        ListItem() {
          Column(){
            Image(item.coverUrlExtendVo?.centre)
              .width(Constants.FULL_PARENT)
              .height(Constants.FULL_PARENT)
              .borderRadius($r('app.string.lpx_8'))
          }
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
        .width($r('app.string.lpx_100'))
        .height(Constants.FULL_PARENT)
        .margin({right: $r('app.string.lpx_20')})
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.string.lpx_12'))
        .shadow({
          radius: $r('app.string.lpx_5'),
          color: $r('app.color.color_1A000000'),
          offsetY: $r('app.string.lpx_5')
        })
      })
    }
    .listDirection(Axis.Horizontal)
    .layoutWeight(1)
    .height($r('app.string.lpx_100'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_8'))
    .margin({top:$r('app.string.lpx_32')})
  }
}
