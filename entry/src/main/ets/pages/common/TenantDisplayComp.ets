import App from 'lib_core_model/src/main/ets/App'
import { CourseTenantInfo } from 'lib_core_model/src/main/ets/data/CourseTenantInfo'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'

/**
 * 机构展示
 */
@Component
export struct TenantDisplayComp {
  courseTenantInfo?: CourseTenantInfo
  visibilityEnterStore: boolean = false

  build() {
    Row() {
      Image(this.courseTenantInfo?.logoUrl)
        .alt($r('app.media.ic_organ_place_holder'))
        .width($r('app.string.lpx_28'))
        .height($r('app.string.lpx_28'))
        .objectFit(ImageFit.Cover)
        .borderRadius($r('app.string.lpx_14'))

      Text(this.courseTenantInfo?.tenantName ?? '')
        .textAlign(TextAlign.Start)
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(20))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding({ left: $r('app.string.lpx_8'), right: $r('app.string.lpx_4') })

      if (this.visibilityEnterStore) {
        Text('进店')
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(20))
          .padding({ left: $r('app.string.lpx_4'), right: $r('app.string.lpx_4') })
      }
      Image($r('app.media.ic_course_organ_right'))
        .width($r('app.string.lpx_20'))
        .height($r('app.string.lpx_20'))
    }
    .height($r('app.string.lpx_40'))
    .padding({ left: $r('app.string.lpx_8'), right: $r('app.string.lpx_8') })
    .backgroundColor($r('app.color.color_F7F7F7'))
    .borderRadius($r('app.string.lpx_20'))
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.ORGAN_MAIN_PAGE,
        params: { tenantId: this.courseTenantInfo?.tenantId }
      })
    })
  }
}