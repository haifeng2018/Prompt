/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: OrderDetailCourseCell
 * Author: Victor
 * Date: 2023/12/11 18:32
 * Description: 
 * -----------------------------------------------------------------
 */
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import OrderShowUtil from 'lib_common/src/main/ets/util/OrderShowUtil';
import { CommentBean } from 'lib_core_model/src/main/ets/data/CommentBean';
import CourseDetailActionUtil from '../../../util/action/CourseDetailActionUtil';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import { OrderInfo } from 'lib_core_model/src/main/ets/data/OrderInfo';
import AfterSaleActionUtil from '../../../util/action/AfterSaleActionUtil';

@Component
export default struct OrderDetailCourseCell {
  private data?: SubOrderInfo
  private channelSource?: number//渠道来源：1.抖店，2.快手，3.获客 4:微店
  private paymentType?: number//支付类型 1:微信 2:阿里 3:赠送 4:抖店支付 5:快手支付 6:获客币支付
  private isShowInvoiceButton?: boolean
  private orderNo?: string
  private userPhone?: string

  public index: number = 0;

  private onCellClick?: (data?: SubOrderInfo,index?: number) => void;

  build() {
    Column() {
      Row() {
        Text(this.data?.goodsMode === 0 ? '线上课程' : '线下课程')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text(OrderShowUtil.getOrderStatusName(this.data))
          .fontColor(OrderShowUtil.getOrderStatusColor(this.data))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)

      Row() {
        Image(this.data?.coverUrlExtendVo?.centre)
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .border({radius: $r('app.string.lpx_8')})
        Column() {
          Text(this.data?.goodsName)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
          if (this.data?.goodsMode === 1 && this.data?.specName) {
            Text(this.data?.specName)
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
            Text(`共${this.data?.goodsNum ?? 0}件`)
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
        Text('去评价')
          .height($r('app.string.lpx_52'))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_EB4F3A'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.color_FEFAFA'))
          .border({
            width: $r('app.string.lpx_2'),
            radius: $r('app.string.lpx_26'),
            color: $r('app.color.color_EB4F3A')
          })
          .margin({right: $r('app.string.lpx_20')})
          .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
          .visibility(OrderShowUtil.getEvaluateVisibility(this.data))
          .onClick(() => {
            const bean = new CommentBean()
            bean.tenantId = this.data?.tenantId
            bean.orderNo = this.orderNo
            bean.userPhone = this.userPhone
            bean.goodsId = this.data?.goodsId
            bean.id = this.data?.id
            bean.title = this.data?.goodsName
            bean.cover = this.data?.coverUrlExtendVo?.coverUrl
            App.get().pushUrl({
              url: RouterPath.COURSE_COMMENT_SUBMIT_PAGE,
              params: {
                data: bean
              }
            })
          })

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
          .visibility(OrderShowUtil.getInvoiceVisibility(this.isShowInvoiceButton))
          .onClick(() => {
            this.onCellClick?.(this.data,-3)
          })

        Text('售后服务')
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
          .visibility(OrderShowUtil.getAfterSaleOpacity(this.data))
          .onClick(() => {
            AfterSaleActionUtil.afterSaleAction(this.data,this.data?.tenantId,this.orderNo)
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
          .visibility(OrderShowUtil.getGoStudyVisibility(this.data))
          .onClick(() => {
            this.onCellClick?.(this.data,-1)
          })

      }
      .width(Constants.FULL_PARENT)
      .padding({top: $r('app.string.lpx_20'),bottom: $r('app.string.lpx_20')})
      .justifyContent(FlexAlign.End)

      if (this.data?.changePerssionLogVo?.showChangePerssionLog) {
        this.changePersonLog()
      }

      Row() {
        Text('商品总价')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))

        Blank()

        Text('￥')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(20))
          .margin({right: $r('app.string.lpx_5')})
        Text(AmountUtil.getRoundUp((this.data?.goodsTotalFee ?? 0) / 100,2))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      .alignItems(VerticalAlign.Bottom)
      .margin({top: $r('app.string.lpx_20')})

      if (this.data?.changedDiscountsFee ?? 0 > 0) {
        Row() {
          Text('商品优惠')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))

          Blank()

          Text('￥')
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(20))
            .margin({right: $r('app.string.lpx_5')})
          Text(AmountUtil.getRoundUp((this.data?.changedDiscountsFee ?? 0) / 100,2))
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(28))
        }
        .width(Constants.FULL_PARENT)
        .alignItems(VerticalAlign.Bottom)
        .margin({top: $r('app.string.lpx_32')})
      }

      if (this.data?.couponDiscountsFee ?? 0 > 0) {
        Row() {
          Text('优惠券')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))

          Blank()

          Text('￥')
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(20))
            .margin({right: $r('app.string.lpx_5')})
          Text(AmountUtil.getRoundUp((this.data?.couponDiscountsFee ?? 0) / 100,2))
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(28))
        }
        .width(Constants.FULL_PARENT)
        .alignItems(VerticalAlign.Bottom)
        .margin({top: $r('app.string.lpx_32')})
      }

      Row() {
        Text('实付金额')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))

        Blank()

        Text('￥')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(20))
          .margin({right: $r('app.string.lpx_5')})
        Text(AmountUtil.getRoundUp((this.data?.payerTotal ?? 0) / 100,2))
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(32))
      }
      .width(Constants.FULL_PARENT)
      .alignItems(VerticalAlign.Bottom)
      .margin({top: $r('app.string.lpx_32')})

      Row() {
        Text('有效期')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))

        Blank()

        Text(OrderShowUtil.getValidityPeriodTitle(this.data))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(32))
      }
      .width(Constants.FULL_PARENT)
      .alignItems(VerticalAlign.Bottom)
      .margin({top: $r('app.string.lpx_32')})

      if (OrderShowUtil.getValidityPeriodTipOpacity(this.data)) {
        Text('前课程已过有效期，如需要进行学习请再次购买。')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(28))
          .margin({top: $r('app.string.lpx_24')})
      }
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({top: $r('app.string.lpx_32')})
    .padding($r('app.string.lpx_20'))
  }

  @Builder changePersonLog() {
    Column() {
      Text(`当前课程已换人就读为${this.data?.changePerssionLogVo?.phone ?? ''}账号学习`)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
      Text(`操作时间：${this.data?.changePerssionLogVo?.operateTime ?? ''}`)
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_16')})
      Text(OrderShowUtil.getChangePersonOperateBy(this.data))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_16')})

      Image(this.data?.changePerssionLogVo?.imgUrl?.[0])
        .width($r('app.string.lpx_120'))
        .height($r('app.string.lpx_120'))
        .border({radius: $r('app.string.lpx_8')})
        .objectFit(ImageFit.Contain)
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_FAFAFA'))
    .borderRadius($r('app.string.lpx_8'))
    .padding($r('app.string.lpx_20'))
    .alignItems(HorizontalAlign.Start)
  }


}
