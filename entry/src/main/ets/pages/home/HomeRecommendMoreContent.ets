/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeRecommendMoreContent
 * Author: Victor
 * Date: 2023/12/01 16:31
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
import HomeVM from 'lib_core_model/src/main/ets/vm/HomeVM';

import CourseDetailActionUtil from '../../util/action/CourseDetailActionUtil';

@Preview
@Component
export struct HomeRecommendMoreContent {

  @State refreshConfig: RefreshConfig<GoodsInfo> = new RefreshConfig<GoodsInfo>()

  private tenantId?: number
  @State groupingId: string = ''


  sendPopularityRequest () {
    HomeVM.sendPopularityRequest(this.tenantId ?? 0,this.groupingId,
      this.refreshConfig.currentPage,this.refreshConfig.PAGE_SIZE).then((data: GoodsInfo[]) => {
      this.refreshConfig.setData(data,true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    this.refreshData()
  }

  refreshData() {
    this.sendPopularityRequest()
  }

  loadMoreData() {
    this.sendPopularityRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: object,index: number): void => this.itemLayout(data),
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

  @Builder itemLayout(item: GoodsInfo) {
    Row(){
      Image(item.coverUrlExtendVo?.centre)
        .alt($r('app.media.img_placeholder_horizontal'))
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

        Text(item.columnContent)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .margin({top: $r('app.string.lpx_16')})

        Blank()

        Row() {
          Text(GoodsShowUtil.getCourseType(item.goodsType,item.onlineFlag))
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize(lpx2fp(20))
            .backgroundColor($r('app.color.color_FFEEED'))
            .border({
              radius: $r('app.string.lpx_8'),
              color: $r('app.color.color_F2382B'),
              width: $r('app.string.lpx_1')
            })
            .padding({
              top: $r('app.string.lpx_4'),
              bottom: $r('app.string.lpx_4'),
              left: $r('app.string.lpx_8'),
              right: $r('app.string.lpx_8'),
            })

          Text(`${item.classHour}节`)
            .fontColor($r('app.color.color_666666'))
            .fontSize(lpx2fp(20))
            .margin({left: $r('app.string.lpx_16')})

          Blank()

          Image($r('app.media.ic_play_count_grey'))
            .width($r('app.string.lpx_12'))
            .height($r('app.string.lpx_15'))

          Text(GoodsShowUtil.getGoodsPopularityTxt(item.goodsPopularity ?? 0))
            .fontSize(lpx2fp(22))
            .fontColor($r('app.color.color_999999'))
            .margin({left: $r('app.string.lpx_10')})

        }
        .width(Constants.FULL_PARENT)
      }
      .layoutWeight(1)
      .height($r('app.string.lpx_180'))
      .margin({left: $r('app.string.lpx_24')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .margin({bottom: $r('app.string.lpx_8')})
    .padding({
      top: $r('app.string.lpx_24'),
      bottom: $r('app.string.lpx_24'),
      left: $r('app.string.lpx_16'),
      right: $r('app.string.lpx_16'),
    })
    .onClick(() => {
      CourseDetailActionUtil.courseDetail(item.tenantId ?? 0,item.onlineFlag,item.goodsId,0)
    })
  }


}
