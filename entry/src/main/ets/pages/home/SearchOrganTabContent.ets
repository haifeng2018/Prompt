/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: SearchOrganTabContent
 * Author: Victor
 * Date: 2024/03/28 15:43
 * Description: 
 * -----------------------------------------------------------------
 */
import LMList from 'lib_common/src/main/ets/components/refresh/LMList'
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig'
import App from 'lib_core_model/src/main/ets/App'
import { SearchTenantInfo } from 'lib_core_model/src/main/ets/data/SearchTenantInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import SearchVM from 'lib_core_model/src/main/ets/vm/SearchVM'

@Preview
@Component
export struct SearchOrganTabContent {
  private tenantId: number = 0
  @State refreshConfig: RefreshConfig<SearchTenantInfo> = new RefreshConfig<SearchTenantInfo>()
  //searchInput发生变更时调用 refreshData 方法
  @Link @Watch('refreshData') searchInput: string

  sendSearchTenantRequest() {
    SearchVM.sendSearchTenantRequest(this.tenantId, this.searchInput, this.refreshConfig.currentPage,
      this.refreshConfig.PAGE_SIZE).then((data: SearchTenantInfo[]) => {
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
    this.sendSearchTenantRequest()
  }

  loadMoreData() {
    this.sendSearchTenantRequest()
  }

  build() {
    LMList({
      refreshConfig: this.refreshConfig,
      itemLayout: (data: SearchTenantInfo, index: number): void => this.itemLayout(data),
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

  @Builder
  itemLayout(item: SearchTenantInfo) {
    Row() {
      Image(item?.smallLogo || $r('app.media.ic_organ_place_holder'))
        .width($r('app.string.lpx_80'))
        .height($r('app.string.lpx_80'))
        .border({
          radius: $r('app.string.lpx_70'),
          width: $r('app.string.lpx_2'),
          color: $r('app.color.white')
        })

      Text(item.name ?? '')
        .height($r('app.string.lpx_80'))
        .margin({ left: $r('app.string.lpx_20'),right: $r('app.string.lpx_10') })
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Image($r('app.media.ic_right'))
        .width($r('app.string.lpx_30'))
        .height($r('app.string.lpx_30'))
        .objectFit(ImageFit.Contain)
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .padding($r('app.string.lpx_24'))
    .margin({ top: $r('app.string.lpx_20') })
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.ORGAN_MAIN_PAGE,
        params: {
          tenantId: item.organizationId
        }
      })
    })
  }
}
