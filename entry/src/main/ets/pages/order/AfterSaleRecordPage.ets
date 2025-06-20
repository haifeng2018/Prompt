import { router } from '@kit.ArkUI';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import DateUtil from 'lib_common/src/main/ets/util/DateUtil';
import { AfterSaleLogInfo } from 'lib_core_model/src/main/ets/data/AfterSaleLogInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import AfterSaleVM from 'lib_core_model/src/main/ets/vm/AfterSaleVM';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct AfterSaleRecordPage {
  subOrderId?: number = (router.getParams() as object)?.[Constants.SUB_ORDER_ID];
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID];

  @State refreshConfig: RefreshConfig<object> = new RefreshConfig<object>()

  @State loginData: LoginData | null = null
  @State datas: Array<AfterSaleLogInfo> = []

  sendAfterSaleDetailRequest () {
    AfterSaleVM.sendAfterSaleLogRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.subOrderId ?? 0)
      .then((value: AfterSaleLogInfo[]) => {
        this.refreshConfig.setRefreshStatus(true)
        this.datas = value
      }).catch((err: string | Resource) => {
      this.refreshConfig.setRefreshStatus(false)
      ToastUtils.show(err)
    })
  }

  refreshData () {
    this.sendAfterSaleDetailRequest()
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  build() {
    Column() {
      ToolBar({title: '售后记录'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    SwipeRefreshLayout({
      refreshConfig: this.refreshConfig,
      itemLayout: (): void => this.itemLayout(),
      onRefresh: () => {
        this.refreshData()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({top: $r('app.string.lpx_8')})
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder itemLayout() {
    Column() {
      ForEach(this.datas,(item: AfterSaleLogInfo) => {
        if (item.approvalStatus === 0) {//APPLYING
          this.applyingCell(item)
        }
        if (item.approvalStatus === 1) {//APPLY_PASS
          this.applyPassCell(item)
        }
        if (item.approvalStatus === 2) {//APPLY_REJECTED
          this.applyRejectedCell(item)
        }
        if (item.approvalStatus === 4) {//APPLY_CANCELED
          this.applyCanceledCell(item)
        }
      })
    }
    .width(Constants.FULL_PARENT)
  }

  @Builder applyingCell(data: AfterSaleLogInfo) {
    Column() {
      Row() {
        Text('用户发起售后申请')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text(DateUtil.transNumberDateHM(data.createTime ?? 0))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      Text(`退款金额：¥${AmountUtil.getRoundUp((data.refundFee ?? 0) / 100,2)}`)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_18')})
        .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_24')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder applyPassCell(data: AfterSaleLogInfo) {
    Column() {
      Row() {
        Image($r('app.media.ic_after_sale_record_pass'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))
        Text('平台审核通过')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .margin({left: $r('app.string.lpx_8')})
        Blank()
        Text(DateUtil.transNumberDateHM(data.createTime ?? 0))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      Text(`实际退款金额：¥${AmountUtil.getRoundUp((data.refundFee ?? 0) / 100,2)}`)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_18')})
        .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_24')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder applyRejectedCell(data: AfterSaleLogInfo) {
    Column() {
      Row() {
        Image($r('app.media.ic_after_sale_record_reject'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))
        Text('平台审核拒绝')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .margin({left: $r('app.string.lpx_8')})
        Blank()
        Text(DateUtil.transNumberDateHM(data.createTime ?? 0))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      Text(`拒绝原因：${data.reason ?? ''}`)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_18')})
        .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_24')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder applyCanceledCell(data: AfterSaleLogInfo) {
    Column() {
      Row() {
        Text('用户取消售后申请')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text(DateUtil.transNumberDateHM(data.createTime ?? 0))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      Text(`退款金额：¥${AmountUtil.getRoundUp((data.refundFee ?? 0) / 100,2)}`)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_18')})
        .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_24')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

}