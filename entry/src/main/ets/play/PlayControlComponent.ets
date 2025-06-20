import App from 'lib_core_model/src/main/ets/App'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import TimeUtil from '../util/TimeUtil'
import AvPlayManage from './AvPlayManage'
import { PlayConstants } from './PlayConstants'

/**
 * 播放器控制组件
 */
@Component
export struct PlayControlComponent {
  @Consume(PlayConstants.PLAY_MANAGE) avPlayManage: AvPlayManage
  @Consume(PlayConstants.PLAY_IS_FULL_SCREEN) isFullScreen: boolean
  @Link currentTime: number
  @Link durationTime: number
  @Link playControlComponentTitle: string
  @Link isPlaying: boolean
  @Link isSwiping: boolean
  @Link isGestureSwiping: boolean
  @State isShowPlayControlComponent: boolean = true
  private timeoutId: number | null = null
  private tag: string = 'PlayControlComponent'

  aboutToAppear() {
    this.setTimer()
  }

  aboutToDisappear(): void {
    this.clearTimer()
  }

  build() {
    Column() {
      Column() {
        this.headBlock()
        Blank()
        this.controlBlock()
      }
      .visibility(this.isShowPlayControlComponent ? Visibility.Visible : Visibility.Hidden)
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .onClick(() => {
      this.handleShowPlayControlClick()
    })
  }

  @Builder
  headBlock() {
    Row() {
      Image($r('app.media.ic_back_white'))
        .width(20)
        .height(20)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          this.handleBackClick()
        })
      Text(this.playControlComponentTitle)
        .layoutWeight(1)
        .height(49)
        .fontSize(15)
        .fontColor($r('app.color.white'))
        .textAlign(TextAlign.Start)
        .margin({ left: $r('app.string.lpx_10') })
    }
    .padding({ left: $r('app.string.lpx_25'), right: $r('app.string.lpx_25') })
    .width(Constants.FULL_PARENT)
  }

  @Builder
  controlBlock() {
    Row() {
      Image(this.isPlaying ? $r('app.media.ic_course_video_play') : $r("app.media.ic_course_video_pause"))
        .id('play')
        .width(20)
        .height(20)
        .onClick(() => {
          this.handlePlayOrPauseClick()
        })
      Slider({
        value: this.currentTime,
        min: 0,
        max: this.durationTime,
        style: SliderStyle.OutSet
      })
        .id('Slider')
        .blockColor($r("app.color.color_EB4F3A"))
        .trackColor($r("app.color.color_CCFFFFFF"))
        .selectedColor($r("app.color.color_EB4F3A"))
        .showTips(false)
        .onChange((value: number, mode: SliderChangeMode) => {
          this.handleSliderChange(value, mode)
        })
        .layoutWeight(1)
      Text(TimeUtil.timeConvert(this.currentTime))
        .fontColor(Color.White)
        .textAlign(TextAlign.End)
        .fontWeight(FontWeight.Regular)
        .fontSize(13)
        .margin({ left: $r('app.string.lpx_10') })
      Text(`/${TimeUtil.timeConvert(this.durationTime)}`)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Regular)
        .fontSize(13)
      Image($r('app.media.ic_course_full_screen'))
        .id('full')
        .width(20)
        .height(20)
        .margin({ left: $r('app.string.lpx_15') })
        .onClick(() => {
          this.handleFullScreenClick()
        })
    }
    .padding({ left: $r('app.string.lpx_25'), right: $r('app.string.lpx_25') })
    .width(Constants.FULL_PARENT)
    .linearGradient({
      angle: 180,
      colors: [
        [$r('app.color.transparent'), 0.0],
        [$r('app.color.color_66000000'), 1.0]
      ]
    })
  }

  private setTimer() {
    this.timeoutId = setTimeout(() => this.isShowPlayControlComponent = false, 8000)
  }

  private clearTimer() {
    clearTimeout(this.timeoutId)
  }

  private handlePlayOrPauseClick() {
    this.isPlaying ? this.avPlayManage.videoPause() : this.avPlayManage.videoPlay()
    this.isPlaying = !this.isPlaying
  }

  private handleSliderChange(value: number, mode: SliderChangeMode) {
    if (!this.isGestureSwiping) {
      // 'idle' | 'initialized' | 'prepared' | 'playing' | 'paused' | 'completed' | 'stopped' | 'released' | 'error'
      let state = this.avPlayManage.getPlayerState()
      Logger.info(this.tag, `value = ${value},mode = ${mode},state = ${state}`)
      if (state == 'playing' || state == 'paused' || state == 'stopped' || state == 'completed') {
        if (mode == SliderChangeMode.Begin) {
          this.isSwiping = true
          this.avPlayManage.videoPause()
        }
        // 避免直接拖动进度条到最后直接播放结束了
        if (value >= (this.durationTime - 500)) {
          this.avPlayManage.videoSeek(value - 3000)
        } else {
          this.avPlayManage.videoSeek(value)
        }
        this.currentTime = value
        if (mode == SliderChangeMode.End) {
          this.isSwiping = false
          this.isPlaying = true
          this.avPlayManage.videoPlay()
        }
      }
    }
  }

  private handleFullScreenClick() {
    this.isFullScreen = !this.isFullScreen
    Logger.info(this.tag, `isFullScreen = ${this.isFullScreen}`)
  }

  private handleBackClick() {
    if (this.isFullScreen) {
      this.isFullScreen = false
    } else {
      App.get().back()
    }
  }

  private handleShowPlayControlClick() {
    this.isShowPlayControlComponent = !this.isShowPlayControlComponent
    if (this.isShowPlayControlComponent) {
      this.setTimer()
    } else {
      this.clearTimer()
    }
  }
}