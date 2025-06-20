/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseMaterialTabContent
 * Author: Victor
 * Date: 2024/04/01 16:19
 * Description: 
 * -----------------------------------------------------------------
 */
import EmptyLayout from 'lib_common/src/main/ets/components/refresh/EmptyLayout'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { MaterialData } from 'lib_core_model/src/main/ets/data/MaterialData'
import { MaterialInfo } from 'lib_core_model/src/main/ets/data/MaterialInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import StudyCenterVM from 'lib_core_model/src/main/ets/vm/StudyCenterVM'
import CacheCleanUtil from '../../../util/CacheCleanUtil'
import FileUtil from '../../../util/FileUtil'

@Preview
@Component
export struct CourseMaterialTabContent {
  tag: string = 'CourseMaterialTabContent'
  @Prop tenantId: number
  @Prop @Watch('sendCoursePptRequest') goodsId: string = ''
  @State @Watch('sendCoursePptRequest') loginData: LoginData | null = null
  @State data: MaterialData | null = null

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
  }

  sendCoursePptRequest() {
    if (this.loginData && this.goodsId) {
      StudyCenterVM.sendMaterialDetailRequest(this.tenantId, this.loginData?.token ?? '', this.goodsId)
        .then((value: MaterialData) => {
          this.data = value
        })
        .catch((err: string | Resource) => {
          ToastUtils.show(err)
        })
    }
  }

  build() {
    Column() {
      if (this.data?.materialInfoVoList?.length === 0) {
        this.emptyContent()
      } else {
        List() {
          ForEach(this.data?.materialInfoVoList, (item: MaterialInfo) => {
            ListItem() {
              this.materialCell(item)
            }
            .margin({
              left: $r('app.string.lpx_32'),
              right: $r('app.string.lpx_32'),
            })
            .padding({
              top: $r('app.string.lpx_10'),
              bottom: $r('app.string.lpx_10'),
            })
          })
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .padding({ bottom: $r('app.string.lpx_20') })
  }

  @Builder
  materialCell(item: MaterialInfo) {
    Row() {
      Image(FileUtil.getCourseMaterialIconByUrl(item.materialUrl))
        .width($r('app.string.lpx_64'))
        .height($r('app.string.lpx_64'))

      Column() {
        Text(item.materialName)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Blank()
        Text(CacheCleanUtil.getFormatSize(item.materialSize ?? 0))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .height($r('app.string.lpx_75'))
      .layoutWeight(1)
      .margin({ left: $r('app.string.lpx_20') })
      .alignItems(HorizontalAlign.Start)
    }
    .width(Constants.FULL_PARENT)
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
