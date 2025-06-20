/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PaidSingleCell
 * Author: Victor
 * Date: 2023/12/11 18:32
 * Description: 
 * -----------------------------------------------------------------
 */
import App from 'lib_core_model/src/main/ets/App';
import { CommentBean } from 'lib_core_model/src/main/ets/data/CommentBean';
import { OrderInfo } from 'lib_core_model/src/main/ets/data/OrderInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import AfterSaleActionUtil from '../../../util/action/AfterSaleActionUtil';
import ClipboardUtil from 'lib_common/src/main/ets/util/ClipboardUtil';

@Component
export default struct PaidSingleCell {
  private data?: OrderInfo;
  private onCellClick?: (data?: OrderInfo,index?: number) => void;
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
        Text('已完成')
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
          if (this.data?.subOrderVos?.[0]?.goodsMode === 1 && this.data?.subOrderVos?.[0]?.specName) {
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
        Text('应付金额：')
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

      Row() {
        Blank()

        Text('更多')
          .height($r('app.string.lpx_52'))
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Center)
          .border({
            width:$r('app.string.lpx_2'),
            radius: $r('app.string.lpx_26'),
            color: $r('app.color.color_999999')
          })
          .padding({left: $r('app.string.lpx_50'), right: $r('app.string.lpx_50')})
          .margin({right: $r('app.string.lpx_20')})
          .bindMenu(this.moreMenu)
          .visibility(GoodsShowUtil.getMoreVisibility(this.data))

        Text('发票服务')
          .height($r('app.string.lpx_52'))
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Center)
          .border({
            width:$r('app.string.lpx_2'),
            radius: $r('app.string.lpx_26'),
            color: $r('app.color.color_999999')
          })
          .padding({left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20')})
          .margin({right: $r('app.string.lpx_20')})
          .visibility(GoodsShowUtil.getInvoiceVisibility(this.data))
          .onClick(() => {
            this.onCellClick?.(this.data,-3)
          })

        Text('咨询客服')
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
          .margin({right: $r('app.string.lpx_20')})
          .visibility(Visibility.None)
          .onClick(() => {
            this.onCellClick?.(this.data,-2)
          })

        Text('去学习')
          .height($r('app.string.lpx_52'))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.white'))
          .textAlign(TextAlign.Center)
          .borderRadius($r('app.string.lpx_26'))
          .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'),0.0],
              [$r('app.color.color_F12E29'),0.7],
              [$r('app.color.color_F12E29'),1.0]
            ]
          })
          .onClick(() => {
            this.onCellClick?.(this.data,-1)
          })
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_24')})
      .visibility(GoodsShowUtil.getGoStudyVisibility(this.data))
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

  @Builder moreMenu() {
    Menu() {
      if (GoodsShowUtil.getEvaluateVisibility(this.data) === Visibility.Visible) {
        MenuItem({
          content: '评价'
        })
          .onClick(() => {
            const bean = new CommentBean()
            bean.tenantId = this.data?.tenantVO?.tenantId
            bean.orderNo = this.data?.orderNo
            bean.userPhone = this.data?.userPhone
            bean.goodsId = this.data?.subOrderVos?.[0]?.goodsId
            bean.id = this.data?.subOrderVos?.[0]?.id
            bean.title = this.data?.subOrderVos?.[0]?.goodsName
            bean.cover = this.data?.subOrderVos?.[0]?.coverUrlExtendVo?.centre
            App.get().pushUrl({
              url: RouterPath.COURSE_COMMENT_SUBMIT_PAGE,
              params: {
                data: bean
              }
            })
          })
      }
      if (GoodsShowUtil.getAfterSaleVisibility(this.data) === Visibility.Visible) {
        MenuItem({
          content: '售后服务'
        })
          .onClick(() => {
            const subOrderInfo = this.data?.subOrderVos?.[0]
            const tenantId = this.data?.tenantId ?? 0
            AfterSaleActionUtil.afterSaleAction(subOrderInfo,tenantId,this.data?.orderNo)
          })
      }
      if (GoodsShowUtil.getLogisticsVisibility(this.data) === Visibility.Visible) {
        MenuItem({
          content: '查看物流'
        })
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.LOGISTICS_PAGE,
              params: {
                data: this.data?.orderNo,
                tenantId: this.data?.tenantId
              }
            })
          })
      }
    }
  }
}
