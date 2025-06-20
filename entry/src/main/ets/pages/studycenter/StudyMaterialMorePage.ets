import router from '@ohos.router';
import LMList from 'lib_common/src/main/ets/components/refresh/LMList';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import App from 'lib_core_model/src/main/ets/App';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { MaterialData } from 'lib_core_model/src/main/ets/data/MaterialData';
import { MaterialInfo } from 'lib_core_model/src/main/ets/data/MaterialInfo';
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
struct StudyMaterialMorePage {
  title: string = (router.getParams() as object)?.[Constants.TITLE];
  goodsId: string = (router.getParams() as object)?.[Constants.GOODS_ID];

  @State loginData: LoginData | null = null

  @State refreshConfig: RefreshConfig<MaterialInfo> = new RefreshConfig<MaterialInfo>()

  sendMaterialDetailRequest () {
    StudyCenterVM.sendMaterialDetailRequest(0,this.loginData?.token ?? '',this.goodsId)
      .then((value: MaterialData) => {
      this.refreshConfig.setData(value.materialInfoVoList ?? [],true)
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
    this.sendMaterialDetailRequest()
  }

  build() {
    Column() {
      ToolBar({title: this.title})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {
      LMList({
        refreshConfig: this.refreshConfig,
        itemLayout: (data: object,index: number): void => this.itemLayout(data,index),
        onRefresh: () => {
          this.refreshData()
        },
        onLoadMore: () => {
        }
      })
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      top: $r('app.string.lpx_32'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .zIndex(0)
  }

  @Builder itemLayout(data: MaterialInfo,index: number) {
    Column() {
      Row() {
        Image($r('app.media.ic_pdf'))
          .width($r('app.string.lpx_64'))
          .height($r('app.string.lpx_64'))
        Column() {
          Text(data.materialName)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Blank()
          Text(CacheCleanUtil.getFormatSize(data.materialSize ?? 0))
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .height($r('app.string.lpx_92'))
        .margin({left: $r('app.string.lpx_16')})
      }
      .width(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_12'))
      .padding($r('app.string.lpx_20'))
      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius({
      topLeft: index === 0 ? $r('app.string.lpx_8') : 0,
      topRight: index === 0 ? $r('app.string.lpx_8') : 0,
      bottomLeft: index === this.refreshConfig.data.length - 1 ? $r('app.string.lpx_8') : 0,
      bottomRight:index === this.refreshConfig.data.length - 1 ? $r('app.string.lpx_8') : 0
    })
    .onClick(() => {
      this.viewMaterial(data)
    })
  }

  viewMaterial(data:MaterialInfo) {
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
