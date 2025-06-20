import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'

@CustomDialog
export default struct LoadingDialog {
  controller: CustomDialogController
  @State angle: number = 0
  private hint = $r('app.string.loading')

  build() {
    Column() {
      LoadingProgress()
        .width($r('app.string.lpx_160'))
        .height($r('app.string.lpx_160'))
        .color($r('app.color.white'))

      Text(this.hint)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.white'))
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.color_B3000000'))
    .borderRadius($r('app.string.lpx_20'))
    .padding({
      top: $r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_30'),
      left: $r('app.string.lpx_30'),
      right: $r('app.string.lpx_30'),
    })
  }
}