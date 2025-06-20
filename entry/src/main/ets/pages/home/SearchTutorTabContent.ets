/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: SearchTutorTabContent
 * Author: Victor
 * Date: 2024/03/28 15:43
 * Description: 
 * -----------------------------------------------------------------
 */
import LMList from 'lib_common/src/main/ets/components/refresh/LMList'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import App from 'lib_core_model/src/main/ets/App'
import { TeacherInfo } from 'lib_core_model/src/main/ets/data/TeacherInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import SearchVM from 'lib_core_model/src/main/ets/vm/SearchVM'

@Preview
@Component
export struct SearchTutorTabContent {
  private tenantId: number = 0
  @State refreshConfig: RefreshConfig<TeacherInfo> = new RefreshConfig<TeacherInfo>()

  //searchInput发生变更时调用 refreshData 方法
  @Link @Watch('refreshData') searchInput: string

  sendTeachersRequest() {
    SearchVM.sendSearchTeacherRequest(this.tenantId,this.searchInput, this.refreshConfig.currentPage,
      this.refreshConfig.PAGE_SIZE).then((data: TeacherInfo[]) => {
      this.refreshConfig.setData(data,true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    });
  }

  aboutToAppear() {
    this.refreshData()
  }

  refreshData() {
    this.sendTeachersRequest()
  }

  loadMoreData() {
    this.sendTeachersRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: TeacherInfo,index): void => this.itemLayout(data),
      onRefresh: () => {
        this.refreshData()
      },
      onLoadMore: () => {
        this.loadMoreData()
      }
    })
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .padding({
        left: $r('app.string.lpx_16'),
        right: $r('app.string.lpx_16')
      })
  }

  @Builder itemLayout(item: TeacherInfo) {
    Row() {
      Image(item.coverUrl || $r('app.media.ic_avatar_place_holder'))
        .width($r('app.string.lpx_80'))
        .height($r('app.string.lpx_80'))
        .border({
          radius: $r('app.string.lpx_70'),
          width: $r('app.string.lpx_2'),
          color: $r('app.color.white')
        })

      Column() {
        Text(item.lecturerName)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .maxLines(2)
          .textOverflow({overflow: TextOverflow.Ellipsis})

        Blank()

        Text(item.lecturerLabel)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .margin({top: $r('app.string.lpx_8')})
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_80'))
      .margin({left: $r('app.string.lpx_20')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .padding($r('app.string.lpx_24'))
    .margin({top: $r('app.string.lpx_20')})
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.TEACHER_DETAIL_PAGE,
        params: {
          data: item?.lecturerId
        }
      })
    })
  }
}
