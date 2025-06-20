/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CoursePractiseTabContent
 * Author: Victor
 * Date: 2024/04/01 16:19
 * Description: 
 * -----------------------------------------------------------------
 */
import EmptyLayout from 'lib_common/src/main/ets/components/refresh/EmptyLayout'
import LMList from 'lib_common/src/main/ets/components/refresh/LMList'
import LoadEndLayout from 'lib_common/src/main/ets/components/refresh/LoadEndLayout'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import App from 'lib_core_model/src/main/ets/App'
import { AnswerInfo } from 'lib_core_model/src/main/ets/data/AnswerInfo'
import { AnswerListData } from 'lib_core_model/src/main/ets/data/AnswerListData'
import { CoursePractisePageParm } from 'lib_core_model/src/main/ets/data/CoursePractisePageParm'
import { ExerciseInfo } from 'lib_core_model/src/main/ets/data/ExerciseInfo'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import StudyCenterVM from 'lib_core_model/src/main/ets/vm/StudyCenterVM'

@Preview
@Component
export struct CoursePractiseTabContent {
  @Prop data: GoodsInfo
  @State refreshConfig: RefreshConfig<AnswerInfo> = new RefreshConfig<AnswerInfo>()
  @State loginData: LoginData | null = null
  @State mExerciseInfo: ExerciseInfo | null = null
  private goodsId: string = ''

  sendCoursePracticeRequest() {
    StudyCenterVM.sendCoursePracticeRequest(this.data?.tenantVO?.tenantId ?? 0,
      this.loginData?.token ?? '', this.goodsId).then((value: ExerciseInfo) => {
      this.mExerciseInfo = value
      if (this.mExerciseInfo) {
        let headInfo = new AnswerInfo()
        headInfo.mExerciseInfo = value
        this.sendExerciseAnswerPageRequest()
      }
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendExerciseAnswerPageRequest() {
    let body = new CoursePractisePageParm()
    body.current = this.refreshConfig.currentPage
    body.practiceId = this.mExerciseInfo?.id

    StudyCenterVM.sendExerciseAnswerPageRequest(this.data?.tenantVO?.tenantId ?? 0, this.loginData?.token ?? '', body)
      .then((value: AnswerListData) => {
        let datas: Array<AnswerInfo> = []
        if (this.mExerciseInfo) {
          let headInfo = new AnswerInfo()
          headInfo.mExerciseInfo = this.mExerciseInfo
          datas.push(headInfo)
        }
        datas = datas.concat(value.records ?? [])
        this.refreshConfig.setData(datas, true)
      }).catch((err: string | Resource) => {
      this.refreshConfig.setData([], false)
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendCoursePracticeRequest()
    })
  }

  refreshData() {
    this.sendCoursePracticeRequest()
  }

  loadMoreData() {
    this.sendExerciseAnswerPageRequest()
  }

  build() {
    Column() {
      if (!this.mExerciseInfo) {
        this.emptyLayout()
      } else {
        this.content()
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .padding({ bottom: $r('app.string.lpx_20') })
  }

  @Builder
  content() {
    Column() {
      LMList({
        showScrollBar: false,
        refreshConfig: this.refreshConfig,
        itemLayout: (data: object, index: number): void => this.itemLayout(data),
        onRefresh: () => {
          this.refreshData()
        },
        onLoadMore: () => {
          this.loadMoreData()
        }
      })
        .width(Constants.FULL_PARENT)
        .layoutWeight(1)
        .padding({ bottom: $r('app.string.lpx_20') })

      Text('做练习')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_72'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'), 0.0],
            [$r('app.color.color_F12E29'), 0.7],
            [$r('app.color.color_F12E29'), 1.0]
          ]
        })
        .borderRadius($r('app.string.lpx_36'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .opacity(this.data?.practiceFlag ? 0 : 1)
        .onClick(() => {
          App.get().pushUrl({
            url: RouterPath.COURSE_PRACTICE_PAGE,
            params: {
              data: this.mExerciseInfo,
              tenantId: this.data?.tenantVO?.tenantId ?? 0
            }
          })
        })
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      bottom: $r('app.string.lpx_32'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }

  @Builder
  itemLayout(item: AnswerInfo) {
    if (item.mExerciseInfo) {
      this.answerHeaderCell(item)
    } else {
      this.answerCell(item)
    }
  }

  @Builder
  answerHeaderCell(item: AnswerInfo) {
    Column() {
      Text(item.mExerciseInfo?.title || '')
        .width(Constants.FULL_PARENT)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(item.mExerciseInfo?.subject ?? '')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(28))
        .margin({ top: $r('app.string.lpx_20') })
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
    .borderRadius($r('app.string.lpx_12'))
    .padding($r('app.string.lpx_20'))
    .margin({
      top: $r('app.string.lpx_20'),
      bottom: $r('app.string.lpx_20')
    })
  }

  @Builder
  answerCell(item: AnswerInfo) {
    Column() {
      Row() {
        Image(item.headImg || $r('app.media.ic_avatar_place_holder'))
          .width($r('app.string.lpx_72'))
          .height($r('app.string.lpx_72'))
          .borderRadius($r('app.string.lpx_36'))

        Text(item.userName || '')
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .layoutWeight(1)
          .margin({ left: $r('app.string.lpx_24') })
      }

      Text(item.answer || '')
        .width(Constants.FULL_PARENT)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_777777'))
        .margin({ top: $r('app.string.lpx_20') })

      Text(DateUtil.transNumberDateHM(item.createTime ?? 0))
        .width(Constants.FULL_PARENT)
        .fontSize(lpx2fp(20))
        .fontColor($r('app.color.color_999999'))
        .textAlign(TextAlign.End)
        .margin({ top: $r('app.string.lpx_20') })

    }
    .width(Constants.FULL_PARENT)
    .margin({ top: $r('app.string.lpx_20') })
  }

  @Builder
  loadEndLayout() {
    LoadEndLayout()
  }

  @Builder
  emptyLayout() {
    Stack() {
      EmptyLayout()
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_100')
    })
  }
}
