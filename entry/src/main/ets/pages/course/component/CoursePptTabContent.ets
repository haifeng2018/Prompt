/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CoursePptTabContent
 * Author: Victor
 * Date: 2024/04/01 16:19
 * Description: 
 * -----------------------------------------------------------------
 */
import EmptyLayout from 'lib_common/src/main/ets/components/refresh/EmptyLayout'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { MaterialInfo } from 'lib_core_model/src/main/ets/data/MaterialInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM'

@Preview
@Component
export struct CoursePptTabContent {
  tag: string = 'CoursePptTabContent'
  @Prop @Watch("sendCoursePptRequest") playGoodsId: string
  @Prop tenantId: number
  @State loginData: LoginData | null = null
  @State materialInfos: Array<MaterialInfo> = []

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendCoursePptRequest()
    })
  }

  sendCoursePptRequest() {
    Logger.info(this.tag, `tenantId = ${this.tenantId}`)
    CourseVM.sendCoursePptRequest(this.loginData?.token ?? '', this.playGoodsId, this.tenantId)
      .then((value: MaterialInfo[]) => {
        this.materialInfos = value
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  build() {
    Column() {
      if (this.materialInfos?.length === 0) {
        this.emptyContent()
      } else {
        List() {
          ForEach(this.materialInfos, (item: MaterialInfo) => {
            ListItem() {
              this.pptCell(item)
            }
            .height($r('app.string.lpx_380'))
            .margin({
              top: $r('app.string.lpx_20'),
              left: $r('app.string.lpx_32'),
              right: $r('app.string.lpx_32'),
            })
          })
        }
        .scrollBar(BarState.Off)
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .padding({ bottom: $r('app.string.lpx_20') })
  }

  @Builder
  pptCell(item: MaterialInfo) {
    Image(item.materialUrl)
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .borderRadius($r('app.string.lpx_8'))
  }

  @Builder
  emptyContent() {
    Stack() {
      EmptyLayout()
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_100')
    })
  }
}
