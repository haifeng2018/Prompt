import { LengthMetrics } from '@kit.ArkUI'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'

@Component
export struct CourseTitleDisplayComp {
  title: string = ''
  titleFontSize: number = lpx2fp(32)
  titleFontColor: Resource = $r('app.color.color_333333')
  showOfflineCourseIcon: boolean = false

  build() {
    Text() {
      if (this.showOfflineCourseIcon) {
        ImageSpan($r('app.media.ic_offline_course_label'))
          .width($r('app.string.lpx_96'))
          .height($r('app.string.lpx_40'))
          .objectFit(ImageFit.Contain)
        Span('\t')
      }
      Span(this.title)
        .layoutWeight(1)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.titleFontColor)
        .fontSize(this.titleFontSize)
    }
    .textAlign(TextAlign.Start)
    .width(Constants.FULL_PARENT)
    .maxLines(2)
    .lineSpacing(LengthMetrics.lpx(10))
    .textOverflow({ overflow: TextOverflow.Ellipsis })
  }
}