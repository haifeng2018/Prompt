import { display } from '@kit.ArkUI'

let defaultDisplay: display.Display | null = null
let lastTapTime = 0

@Component
export default struct PlayGestureHandlerComponent {
  @BuilderParam customBuilderParam: () => void = this.customBuilder
  @State distance: number = 5
  // 水平左右滑动时回调
  onHorizontalSwipe = (swipeDistance: number, mode: number) => {
  }
  // 左半边上下垂直滑动时回调
  onLeftVerticalSwipe = (swipeDistance: number) => {
  }
  // 右半边上下垂直滑动时回调
  onRightVerticalSwipe = (swipeDistance: number) => {
  }
  // 当双击的时候回调
  onDoubleTap = () => {
  }

  aboutToAppear(): void {
    defaultDisplay = display.getDefaultDisplaySync()
  }

  @Builder
  customBuilder() {
  }

  build() {
    Column() {
      this.customBuilderParam()
    }
    // .onClick(() => {
    //   const currentTime = Date.now()
    //   const tapGap = currentTime - lastTapTime
    //   if (tapGap < 300 && tapGap > 0) {
    //     this.onDoubleTap()
    //   }
    //   lastTapTime = currentTime
    // })
    .gesture(
      PanGesture({ direction: PanDirection.Horizontal, distance: this.distance })
        .onActionStart((event: GestureEvent | undefined) => {
          if (event) {
            this.onHorizontalSwipe(Math.round(event.offsetX), 0)
          }
        })
        .onActionUpdate((event: GestureEvent | undefined) => {
          if (event) {
            this.onHorizontalSwipe(Math.round(event.offsetX), 1)
          }
        })
        .onActionEnd((event: GestureEvent | undefined) => {
          if (event) {
            this.onHorizontalSwipe(Math.round(event.offsetX), 2)
          }
        })
    )
    .gesture(
      PanGesture({ direction: PanDirection.Vertical, distance: this.distance })
        .onActionUpdate((event: GestureEvent | undefined) => {
          if (event) {
            event.fingerList.forEach((fingerInfo: FingerInfo) => {
              console.info(`fingerInfo = ${JSON.stringify(fingerInfo)}}`)
            })
            let displayWidth = px2vp(defaultDisplay?.width)
            let displayHeight = px2vp(defaultDisplay?.height)
            console.info(`displayWidth = ${displayWidth}}`)
            console.info(`displayheight = ${displayHeight}}`)

            let fingerInfo: FingerInfo = event.fingerList[0]
            const isLeftHalf = fingerInfo.globalX < (displayWidth ?? 0) / 2
            if (isLeftHalf) {
              this.onLeftVerticalSwipe(Math.round(event.offsetY))
            } else {
              this.onRightVerticalSwipe(Math.round(event.offsetY))
            }
          }
        })
    )
  }
}


