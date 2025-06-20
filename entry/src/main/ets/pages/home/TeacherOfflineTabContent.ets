/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: TeacherOnlineTabContent
 * Author: Victor
 * Date: 2023/12/01 15:58
 * Description: 
 * -----------------------------------------------------------------
 */
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import TeacherVM from 'lib_core_model/src/main/ets/vm/TeacherVM';
import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';
import CourseProductConfigDialog from '../../view/dialog/CourseProductConfigDialog';
import { CoursePriceLineStyleDisplayComp } from '../common/CoursePriceDisplayComp';

@Preview
@Component
export struct TeacherOfflineTabContent {
  @State refreshConfig: RefreshConfig<GoodsInfo> = new RefreshConfig<GoodsInfo>()
  @State goodsInfo: GoodsInfo | null = null
  private tenantId: number = 0
  private lecturerId: string | null = null
  private courseProductConfigDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseProductConfigDialog({
      goodsInfo: this.goodsInfo
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })

  sendTeacherOfflineRequest() {
    TeacherVM.sendTeacherOfflineRequest(this.tenantId, this.lecturerId ?? '',
      this.refreshConfig.currentPage, this.refreshConfig.PAGE_SIZE).then((data: GoodsInfo[]) => {
      this.refreshConfig.setData(data, true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([], false)
      ToastUtils.show(err)
    });
  }

  aboutToAppear() {
    this.refreshData()
  }

  refreshData() {
    this.sendTeacherOfflineRequest()
  }

  loadMoreData() {
    this.sendTeacherOfflineRequest()
  }

  handleBuy(item: GoodsInfo) {
    this.goodsInfo = item
    this.courseProductConfigDlgCtl.open()
  }

  build() {
    LMList({
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
      .height(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.color_F9F9F9'))
      .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
  }

  @Builder
  itemLayout(item: GoodsInfo) {
    Column() {
      Stack() {
        Image(item.coverUrl)
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .border({ radius: $r('app.string.lpx_12') })
          .onClick(() => {
            CourseDetailActionUtil.courseDetail(item.tenantId ?? 0, 1, item.goodsId, 0)
          })

        Text(GoodsShowUtil.getCurriculumType(item.curriculumType ?? 0))
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(20))
          .backgroundColor($r('app.color.color_FDEDEB'))
          .borderRadius($r('app.string.lpx_4'))
          .margin({
            right: $r('app.string.lpx_20')
          })
          .padding({
            top: $r('app.string.lpx_4'),
            bottom: $r('app.string.lpx_4'),
            left: $r('app.string.lpx_12'),
            right: $r('app.string.lpx_12'),
          })
          .opacity(GoodsShowUtil.getCurriculumType(item.curriculumType) ? 1 : 0)
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_486'))
      .alignContent(Alignment.TopEnd)

      Text(item.contentName)
        .width(Constants.FULL_PARENT)
        .margin({ top: $r('app.string.lpx_16') })
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Image($r('app.media.ic_find_teach_addr'))
          .width($r('app.string.lpx_28'))
          .height($r('app.string.lpx_28'))

        Text(`授课地点：${item?.cityNames || ''}`)
          .width(Constants.FULL_PARENT)
          .margin({ left: $r('app.string.lpx_6') })
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_20') })

      Row() {
        Image($r('app.media.ic_find_teacher'))
          .width($r('app.string.lpx_28'))
          .height($r('app.string.lpx_28'))

        Text(`授课老师：${GoodsShowUtil.getLecturerNames(item.lecturers)}`)
          .width(Constants.FULL_PARENT)
          .margin({ left: $r('app.string.lpx_6') })
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_8') })

      Row() {
        CoursePriceLineStyleDisplayComp({
          goodsInfo: item,
          pricesFontSize: lpx2fp(36)
        })

        Blank()

        Text('立即报名')
          .height($r('app.string.lpx_52'))
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(24))
          .backgroundColor($r('app.color.color_EB4F3A'))
          .borderRadius($r('app.string.lpx_26'))
          .margin({
            left: $r('app.string.lpx_20')
          })
          .padding({
            top: $r('app.string.lpx_6'),
            bottom: $r('app.string.lpx_6'),
            left: $r('app.string.lpx_30'),
            right: $r('app.string.lpx_30'),
          })
          .onClick(() => {
            this.handleBuy(item)
          })
      }
      .width(Constants.FULL_PARENT)
      .alignItems(VerticalAlign.Center)
      .margin({ top: $r('app.string.lpx_20') })
    }
    .width(Constants.FULL_PARENT)
    .margin({ top: $r('app.string.lpx_32'), bottom: $r('app.string.lpx_32') })
    .padding({
      left: $r('app.string.lpx_16'),
      right: $r('app.string.lpx_16'),
    })
  }
}
