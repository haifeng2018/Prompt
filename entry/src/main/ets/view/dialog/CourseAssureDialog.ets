/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseAssureDialog
 * Author: Victor
 * Date: 2023/12/28 16:27
 * Description: 
 * -----------------------------------------------------------------
 */
import { CourseAssureInfo } from 'lib_core_model/src/main/ets/data/CourseAssureInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'

@CustomDialog
export default struct CourseAssureDialog {
  controller: CustomDialogController
  private onlineFlag: number = 0
  private postSaleType: number = 0

  build() {
    Column() {
      Text('保障说明')
        .height($r('app.string.lpx_108'))
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)

      List() {
        ForEach(GoodsShowUtil.getGoodsAssureTipList(this.onlineFlag, this.postSaleType),
          (item: CourseAssureInfo) => {
            ListItem() {
              Row() {
                Image(item.assureIconResId)
                  .width($r('app.string.lpx_64'))
                  .height($r('app.string.lpx_64'))

                Column() {
                  Text(item.assureTitle)
                    .fontColor($r('app.color.color_333333'))
                    .fontSize(lpx2fp(28))
                    .fontWeight(FontWeight.Bold)

                  Text(item.assureContent)
                    .fontColor($r('app.color.color_666666'))
                    .fontSize(lpx2fp(28))
                    .margin({ top: $r('app.string.lpx_16') })
                }
                .layoutWeight(1)
                .margin({ left: $r('app.string.lpx_16') })
                .alignItems(HorizontalAlign.Start)
              }
              .width(Constants.FULL_PARENT)
              .margin({ bottom: $r('app.string.lpx_32') })
              .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
              .alignItems(VerticalAlign.Top)
            }
            .width(Constants.FULL_PARENT)
          })
      }
      .width(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .borderRadius($r('app.string.lpx_12'))
      .padding({ top: $r('app.string.lpx_32') })

      Row() {
        Text('好的')
          .layoutWeight(1)
          .height($r('app.string.lpx_80'))
          .borderRadius($r('app.string.lpx_40'))
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(32))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'), 0.0],
              [$r('app.color.color_F12E29'), 0.7],
              [$r('app.color.color_F12E29'), 1.0]
            ]
          })
          .onClick(() => {
            this.controller.close()
          })
      }
      .width(Constants.FULL_PARENT)
      .margin({
        top: $r('app.string.lpx_40')
      })
      .padding({
        left: $r('app.string.lpx_40'),
        right: $r('app.string.lpx_40')
      })

    }
    .width('80%')
    .backgroundColor(Color.White)
    .borderRadius($r('app.string.lpx_20'))
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })

  }
}