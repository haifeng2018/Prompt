/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CourseBoughtRecommendTabContent
 * Author: Victor
 * Date: 2024/04/01 16:19
 * Description: 
 * -----------------------------------------------------------------
 */
import EmptyLayout from 'lib_common/src/main/ets/components/refresh/EmptyLayout'
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM'
import CourseDetailActionUtil from '../../../util/action/CourseDetailActionUtil'
import { CoursePriceLineStyleDisplayComp } from '../../common/CoursePriceDisplayComp'
import { CourseSaleStateDisplayComp } from '../../common/CourseSaleStateDisplayComp'

@Preview
@Component
export struct OnlineCourseStudyPlayRecommend {

  private tenantId: number = 0
  private goodsId: string = ''
  @State loginData: LoginData | null = null
  @State recommendList: Array<GoodsInfo> = []

  sendCourseDetailRecommendRequest() {
    CourseVM.sendCourseDetailRecommendRequest(this.tenantId,this.goodsId).then((value: GoodsInfo[]) => {
      this.recommendList = value
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendCourseDetailRecommendRequest()
    })
  }

  build() {
    Column() {
      if (this.recommendList?.length === 0) {
        this.emptyContent()
      } else {
        List() {
          ForEach(this.recommendList,(item: GoodsInfo,index) => {
            ListItem(){
              this.recommendCell(item,index)
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
    .padding({bottom: $r('app.string.lpx_20')})
  }

  @Builder recommendCell(item: GoodsInfo,index: number) {
    Row(){
      Image(item.coverUrlExtendVo?.centre)
        .width($r('app.string.lpx_180'))
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
        .margin({top: $r('app.string.lpx_10')})
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .margin({left: $r('app.string.lpx_24')})
    }
    .width(Constants.FULL_PARENT)
    .borderRadius({
      topLeft: 0,
      topRight: 0,
      bottomLeft: index == this.recommendList.length - 1 ? $r('app.string.lpx_20') : 0,
      bottomRight: index == this.recommendList.length - 1 ? $r('app.string.lpx_20') : 0
    })
    .padding({
      top: $r('app.string.lpx_12'),
      bottom: $r('app.string.lpx_12')
    })
    .onClick(() => {
      CourseDetailActionUtil.courseDetail(item.tenantVO?.tenantId ?? 0,item.onlineFlag,item.goodsId,0)
    })
  }

  @Builder emptyContent() {
    Stack() {
      EmptyLayout()
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_100')
    })
  }
}
