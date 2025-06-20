import router from '@ohos.router';
import display from '@ohos.display';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct PosterPage {
  data: Array<string> = (router.getParams() as object )?.[Constants.DATA]
  selectedIndex: number = (router.getParams() as object)?.[Constants.PAGE_POSITION]

  private deviceWidth: number = 0
  private deviceHeight: number = 0
  private imgWidth: number = 0
  private imgHeight: number = 0
  private displayHeight: number = 0
  private MAX_SCALE: number = 4
  private DEFAULT_WIDTH: number = 360

  @State bgOpacity: number = 0
  @State isGesture: boolean = false
  @State imgScale: number = 1
  @State curScale: number = 1
  @State imgOffsetX: number = 0
  @State imgOffsetY: number = 0
  @State preOffsetX: number = 0
  @State preOffsetY: number = 0

  aboutToAppear() {
    let displayClass: display.Display = display.getDefaultDisplaySync()
    let width = displayClass?.width / displayClass.densityPixels ?? this.DEFAULT_WIDTH
    let height = displayClass?.height / displayClass.densityPixels ?? this.DEFAULT_WIDTH
    this.deviceWidth = width
    this.deviceHeight = height
  }

  /**
   * Detect boundary to keep the image in window.
   */
  detectBoundary(): void {
    let maxOffsetX = this.imgScale * this.deviceWidth / 2 - this.deviceWidth / 2
    if (vp2px(this.imgOffsetX) > (maxOffsetX)) {
      this.imgOffsetX = px2vp(maxOffsetX)
    }
    if (vp2px(this.imgOffsetX) < -(maxOffsetX)) {
      this.imgOffsetX = -px2vp(maxOffsetX)
    }
    let maxOffsetY = this.imgScale * this.displayHeight / 2 - this.deviceHeight / 2
    if (this.imgScale * this.displayHeight >= this.deviceHeight) {
      if (vp2px(this.imgOffsetY) > (maxOffsetY)) {
        this.imgOffsetY = px2vp(maxOffsetY)
      }
      if (vp2px(this.imgOffsetY) < -(maxOffsetY)) {
        this.imgOffsetY = -px2vp(maxOffsetY)
      }
    } else {
      this.imgOffsetY = 0
    }
  }

  /**
   * Limit scale to keep the image clear.
   */
  limitScale(isReset: boolean): void {
    if (this.imgScale < 1) {
      this.imgScale = 1
      this.curScale = 1
      if (isReset) {
        this.imgOffsetX = 0
        this.imgOffsetY = 0
      }
      this.isGesture = false;
    } else if (this.imgScale > this.MAX_SCALE) {
      this.imgScale = this.MAX_SCALE
      this.curScale = this.MAX_SCALE
    } else {
      this.curScale = this.imgScale
    }
  }

  resetImg() {
    this.imgScale = 1
    this.curScale = 1
    this.imgOffsetX = 0
    this.imgOffsetY = 0
    this.isGesture = false
  }

  build() {
    Column() {
      ToolBar({
        title: '',
        titleBackgroundColor: $r('app.color.transparent'),
        titleBackIcon: $r('app.media.ic_white_back'),
        shadowColor: $r('app.color.transparent')})
        .opacity(this.isGesture ? 0 : 1)

      Stack() {
        Swiper() {
          ForEach(this.data, (item: string) => {
            Image(item || $r('app.media.img_placeholder_horizontal'))
              .width(Constants.FULL_PARENT)
              .height(Constants.FULL_PARENT)
              .objectFit(ImageFit.Contain)
              .gesture(
                PinchGesture()
                  .onActionStart(() => {
                    this.isGesture = true
                  })
                  .onActionUpdate((event?: GestureEvent) => {
                    if (!event) {
                      return
                    }
                    this.imgScale = this.curScale * event.scale
                  })
                  .onActionEnd(() => {
                    this.limitScale(false)
                  })
              )
              .gesture(
                TapGesture({ count: 2 })//双击
                  .onAction((event: GestureEvent) => {
                    if (!event) {
                      return
                    }
                    this.imgScale = this.imgScale === 1 ? 2 : 1
                    this.isGesture = true
                  })
              )
          })
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
        .index(this.selectedIndex)
        .autoPlay(false)
        .interval(3000)
        .loop(this.data.length > 1)
        .indicator(this.data.length > 1)
        .indicatorStyle({
          bottom: $r('app.string.lpx_200'),size: $r('app.string.lpx_16'), mask: true,
          color:$r('app.color.color_80FFFFFF'),
          selectedColor:$r('app.color.white')})
        .duration(300)
        .itemSpace(10)
        .curve(Curve.Linear)
        .onChange((index: number) => {
          this.selectedIndex = index
        })
        .visibility(this.isGesture ? Visibility.Hidden : Visibility.Visible)

        Row() {
          Image(this.data[this.selectedIndex])
            .scale({ x: this.imgScale, y: this.imgScale })
            .translate({ x: this.imgOffsetX, y: this.imgOffsetY })
            .objectFit(ImageFit.Contain)
            .onComplete((event) => {
              if (!event) {
                return
              }
              this.imgWidth = event.width
              this.imgHeight = event.height
              this.displayHeight = this.deviceWidth * this.imgHeight / this.imgWidth
            })
            .onClick(() => {
              this.resetImg()
            })
        }
        .gesture(
          PinchGesture()
            .onActionUpdate((event?: GestureEvent) => {
              if (!event) {
                return
              }
              this.imgScale = this.curScale * event.scale
            })
            .onActionEnd(() => {
              this.detectBoundary()
              this.limitScale(true)
            })
        )
        .gesture(
          PanGesture()
            .onActionStart(() => {
              this.preOffsetX = this.imgOffsetX
              this.preOffsetY = this.imgOffsetY
            })
            .onActionUpdate((event?: GestureEvent) => {
              if (!event) {
                return
              }
              this.imgOffsetX = this.preOffsetX + event.offsetX
              this.imgOffsetY = this.preOffsetY + event.offsetY
            })
            .onActionEnd(() => {
              this.detectBoundary()
            })
        )
        .gesture(
          TapGesture({ count: 2 })//双击
            .onAction((event: GestureEvent) => {
              if (!event) {
                return
              }
              this.imgScale = this.imgScale === 1 ? 2 : 1
              this.isGesture = false
            })
        )
        .visibility(this.isGesture ? Visibility.Visible : Visibility.Hidden)
      }
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .zIndex(0)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .linearGradient({
      direction: GradientDirection.Top,
      colors: [[$r('app.color.color_FF515151'), 0.8], [$r('app.color.color_FF222222'), 1.0]]
    })
  }

  onBackPress() {
    if (this.imgScale > 1) {
      this.imgScale = 1
      return true
    }
    return false
  }
}