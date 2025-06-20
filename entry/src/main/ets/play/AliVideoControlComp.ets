import App from 'lib_core_model/src/main/ets/App'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { SeekType } from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
// import { AliPlayer } from 'premierlibrary'
import { LocalStorageConstants } from '../data/LocalStorageConstants'
import AliVideoController from '../play/AliVideoController'

/**
 * 播放器控制组件
 */
@Component
export struct AliVideoControlComp {
  @LocalStorageProp(LocalStorageConstants.PLAY_TITLE) playTitle: string = ''
  @LocalStorageLink(LocalStorageConstants.PLAY_IS_FULL_SCREEN) isFullScreen: boolean = false
  @Prop isPlaying: boolean = false
  @Prop videoProgress: number = 0
  @Prop videoDurationStr: string = '00:00/00:00';
  @State isShowPlayControl: boolean = true
  @State aliPlayerId: number = -1
  @State showFinishScene: boolean = false
  // private aliPlayer: AliPlayer | undefined = undefined
  private timeoutId: number | null = null
  private tag: string = 'AliVideoControlComp'

  aboutToAppear() {
    this.setTimer()
    Logger.info(this.tag, `aliPlayerId = ${this.aliPlayerId}`)
    Logger.info(this.tag, `videoProgress = ${this.videoProgress}`)
    Logger.info(this.tag, `videoDurationStr = ${this.videoDurationStr}`)
    // this.aliPlayer = AliVideoController.getPlayer(this.aliPlayerId)
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
      .visibility(this.isShowPlayControl ? Visibility.Visible : Visibility.Hidden)
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
      Text(this.playTitle)
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
      Image(this.isPlaying ? $r("app.media.ic_course_video_pause") : $r('app.media.ic_course_video_play'))
        .width(20)
        .height(20)
        .onClick(() => {
          this.handlePlayOrPauseClick()
        })
      Slider({
        value: this.videoProgress,
        min: 0,
        max: 100,
        style: SliderStyle.OutSet
      })
        .blockColor($r("app.color.color_EB4F3A"))
        .trackColor($r("app.color.color_CCFFFFFF"))
        .selectedColor($r("app.color.color_EB4F3A"))
        .showTips(false)
        .onChange((value: number, mode: SliderChangeMode) => {
          this.handleSliderChange(value, mode)
        })
        .layoutWeight(1)
      Text(this.videoDurationStr)
        .fontColor(Color.White)
        .textAlign(TextAlign.End)
        .fontWeight(FontWeight.Regular)
        .fontSize(13)
        .margin({ left: $r('app.string.lpx_10') })
      Image($r('app.media.ic_course_full_screen'))
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
    this.timeoutId = setTimeout(() => this.isShowPlayControl = false, 8000)
  }

  private clearTimer() {
    clearTimeout(this.timeoutId)
  }

  private handlePlayOrPauseClick() {
    // this.isPlaying ? this.aliPlayer?.pause() : this.aliPlayer?.start()
    this.isPlaying = !this.isPlaying
  }

  private handleSliderChange(value: number, mode: SliderChangeMode) {
    this.videoProgress = value;
    if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
      // let duration = this.aliPlayer?.getDuration() ?? 0
      let duration = 0
      if (duration <= 0) {
        return;
      }
      this.showFinishScene = false;
      Logger.info(this.tag, `this.videoDuration = ${duration}, value = ${value}`)
      let seekValue: number = Math.floor(duration / 100 * value);
      Logger.info(this.tag, `seekto = ${seekValue}`)
      // this.aliPlayer?.seekTo(seekValue, SeekType.ACCURATE);
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
    this.isShowPlayControl = !this.isShowPlayControl
    if (this.isShowPlayControl) {
      this.setTimer()
    } else {
      this.clearTimer()
    }
  }
}