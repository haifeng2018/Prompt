import router from '@ohos.router';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { CourseCategoryContentComp } from './component/CourseCategoryContentComp';

@Entry
@Component
struct CourseCategoryPage {
  catalogueId?: string = (router.getParams() as object)?.[Constants.DATA];
  tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID];

  build() {
    Column() {
      CourseCategoryContentComp({
        tenantId: this.tenantId,
        catalogueId: this.catalogueId
      })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
  }
}
