import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import { HtmlApi } from 'lib_core_model/src/main/ets/api/HtmlApi';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { MaterialInfo } from 'lib_core_model/src/main/ets/data/MaterialInfo';
import { UserMaterialData } from 'lib_core_model/src/main/ets/data/UserMaterialData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import StudyCenterVM from 'lib_core_model/src/main/ets/vm/StudyCenterVM';
import CacheCleanUtil from '../../util/CacheCleanUtil';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct StudyMaterialPage {

  @State loginData: LoginData | null = null

  @State refreshConfig: RefreshConfig<UserMaterialData> = new RefreshConfig<UserMaterialData>()

  sendUserMaterialRequest () {
    StudyCenterVM.sendUserMaterialRequest(0,this.loginData?.token ?? '').then((value: UserMaterialData[]) => {
      this.refreshConfig.setData(value,true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    });
  }

  refreshData () {
    this.sendUserMaterialRequest()
  }

  build() {
    Column() {
      ToolBar({title: '资料下载'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
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
      .layoutWeight(1)
      .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
      .zIndex(0)
  }

  @Builder itemLayout(data: UserMaterialData) {
    if (data.materialInfoVoList) {
      if (data?.materialInfoVoList?.length === 0) {
        this.emptyCell(data)
      } else if (data?.materialInfoVoList?.length === 1) {
        this.singleMaterialCell(data)
      } else {
        this.moreMaterialCell(data)
      }
    }
  }

  @Builder emptyCell(data: UserMaterialData) {
    Column() {
      Text(data.contentName)
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .maxLines(2)
        .textOverflow({overflow: TextOverflow.Ellipsis})
      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({top: $r('app.string.lpx_20')})
      Text(data.contentName)
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Center)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({top: $r('app.string.lpx_20')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({top:$r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
  }

  @Builder singleMaterialCell(data: UserMaterialData) {
    Column() {
      Text(data.contentName)
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .maxLines(2)
        .textOverflow({overflow: TextOverflow.Ellipsis})
      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({top: $r('app.string.lpx_20')})
      Row() {
        Image($r('app.media.ic_pdf'))
          .width($r('app.string.lpx_64'))
          .height($r('app.string.lpx_64'))
        Column() {
          Text(data.materialInfoVoList?.[0]?.materialName)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
          Blank()
          Text(CacheCleanUtil.getFormatSize(data.materialInfoVoList?.[0].materialSize ?? 0))
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
        }
        .height($r('app.string.lpx_92'))
      }
      .margin({top: $r('app.string.lpx_20')})
      .onClick(() => {
        this.viewMaterial(data?.materialInfoVoList?.[0])
      })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({top:$r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
  }

  @Builder moreMaterialCell(data: UserMaterialData) {
    Column() {
      Text(data.contentName)
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .maxLines(2)
        .textOverflow({overflow: TextOverflow.Ellipsis})
      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({top: $r('app.string.lpx_20')})
      Row() {
        Image($r('app.media.ic_pdf'))
          .width($r('app.string.lpx_64'))
          .height($r('app.string.lpx_64'))
        Column() {
          Text(data.materialInfoVoList?.[0]?.materialName)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
          Blank()
          Text(CacheCleanUtil.getFormatSize(data.materialInfoVoList?.[0].materialSize ?? 0))
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
        }
        .height($r('app.string.lpx_92'))
      }
      .margin({top: $r('app.string.lpx_20')})
      .onClick(() => {
        this.viewMaterial(data.materialInfoVoList?.[0])
      })
      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({top: $r('app.string.lpx_20')})
      Row() {
        Image($r('app.media.ic_pdf'))
          .width($r('app.string.lpx_64'))
          .height($r('app.string.lpx_64'))
        Column() {
          Text(data.materialInfoVoList?.[1]?.materialName)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
          Blank()
          Text(CacheCleanUtil.getFormatSize(data.materialInfoVoList?.[1].materialSize ?? 0))
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
        }
        .height($r('app.string.lpx_92'))
      }
      .margin({top: $r('app.string.lpx_20')})
      .onClick(() => {
        this.viewMaterial(data?.materialInfoVoList?.[1])
      })

      Text('查看更多')
        .height($r('app.string.lpx_52'))
        .fontSize(lpx2fp(24))
        .fontColor($r('app.color.color_EB4F3A'))
        .textAlign(TextAlign.Center)
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_26'),
          color: $r('app.color.color_EB4F3A')
        })
        .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
        .onClick(() => {
          App.get().pushUrl({
            url: RouterPath.STUDY_MATERIAL_MORE_PAGE,
            params: {
              title: data.contentName,
              goodsId: data.goodsId
            }
          })
        })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .margin({top:$r('app.string.lpx_40')})
    .padding($r('app.string.lpx_20'))
  }

  viewMaterial(data?: MaterialInfo) {
    App.get().pushUrl({
      url: RouterPath.WEB_PAGE,
      params: {
        title: data?.materialName,
        // url: `${HtmlApi.PDF_JS}${data?.materialUrl}`
        url: `${data?.materialUrl}`
      }
    })
  }

}
