/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: MyPracticeContent
 * Author: Victor
 * Date: 2023/12/01 15:58
 * Description: 
 * -----------------------------------------------------------------
 */
import StudyCenterVM from 'lib_core_model/src/main/ets/vm/StudyCenterVM';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { PracticeInfo } from 'lib_core_model/src/main/ets/data/PracticeInfo';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { ExerciseInfo } from 'lib_core_model/src/main/ets/data/ExerciseInfo';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import LoadingDialog from '../../view/dialog/LoadingDialog';

@Preview
@Component
export struct MyPracticeContent {

  @State loginData: LoginData | null = null

  @State statusCode: number = 0

  @State refreshConfig: RefreshConfig<PracticeInfo> = new RefreshConfig<PracticeInfo>()

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  sendPracticeRequest () {
    StudyCenterVM.sendPracticeRequest(0,this.loginData?.token ?? '',this.statusCode)
      .then((value: PracticeInfo[]) => {
        this.refreshConfig.setData(value,true)
      }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  sendCoursePracticeRequest (tenantId: number,goodsId: string) {
    this.loadingDialogCtrl.open()

    StudyCenterVM.sendCoursePracticeRequest(0,this.loginData?.token ?? '',goodsId)
      .then((value: ExerciseInfo) => {
        this.loadingDialogCtrl.close()
        App.get().pushUrl({
          url: RouterPath.COURSE_PRACTICE_PAGE,
          params: {
            tenantId: tenantId,
            data: value
          }
        })
      }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  refreshData () {
    this.sendPracticeRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: object,index: number): void => this.itemLayout(data),
      onRefresh: () => {
        this.refreshData()
      },
      onLoadMore: () => {
      }
    })
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder itemLayout(item: PracticeInfo) {
    Column() {
      Row(){
        Image(item.coverUrl || $r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_240'))
          .height($r('app.string.lpx_180'))
          .border({radius: $r('app.string.lpx_8')})

        Column() {
          Text(item.contentName)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})

          Blank()

          Row() {
            Image(item?.statusCode === 1 ? $r('app.media.ic_practice_uncompleted') : $r('app.media.ic_practice_completed'))
              .width($r('app.string.lpx_24'))
              .height($r('app.string.lpx_24'))
            Text(item?.statusMsg)
              .fontColor(item?.statusCode === 1 ?  $r('app.color.color_DA3732') : $r('app.color.color_999999'))
              .fontSize(lpx2fp(24))
              .margin({left: $r('app.string.lpx_8')})

            Blank()

            Text('做练习')
              .height($r('app.string.lpx_52'))
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.white'))
              .textAlign(TextAlign.Center)
              .borderRadius(lpx2fp(26))
              .linearGradient({
                angle: 90,
                colors: [
                  [$r('app.color.color_EF874D'),0.0],
                  [$r('app.color.color_DA3732'),0.7],
                  [$r('app.color.color_DA3732'),1.0]
                ]
              })
              .padding({left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30')})
              .opacity(item?.statusCode === 1 ? 1: 0)
              .onClick(() => {
                this.sendCoursePracticeRequest(item.tenantId ?? 0,item.goodsId ?? '')
              })
          }
          .width(Constants.FULL_PARENT)
        }
        .layoutWeight(1)
        .height($r('app.string.lpx_180'))
        .margin({left: $r('app.string.lpx_20')})
      }
      .width(Constants.FULL_PARENT)

      Text(item.title)
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Start)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .maxLines(1)
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .margin({top: $r('app.string.lpx_20')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .margin({top: $r('app.string.lpx_24')})
    .padding($r('app.string.lpx_20'))
  }

  @Builder emptyLayout() {
    Column() {
      Image($r('app.media.img_no_practice'))
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_400'))
        .objectFit(ImageFit.Contain)
      Text('暂无练习')
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_666666'))

      Text('点击重试')
        .height($r('app.string.lpx_52'))
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.color_DA3732'))
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.color_FEFAFA'))
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_26'),
          color: $r('app.color.color_DA3732')
        })
        .margin({top: $r('app.string.lpx_60')})
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
    }
    .width($r('app.string.lpx_750'))
    .padding({top: $r('app.string.lpx_150')})
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
