import { media } from '@kit.MediaKit'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import { AppStorageConstants } from '../data/AppStorageConstants'
import AvPlayManage from './AvPlayManage'
import { PlayConstants } from './PlayConstants'
import { PlayControlComponent } from './PlayControlComponent'
import PlayGestureHandlerComponent from './PlayGestureHandlerComponent'

/**
 * 播放器组件
 */
@Component
export struct PlayComponent {
  @Consume(PlayConstants.PLAY_MANAGE) avPlayManage: AvPlayManage
  @Consume(PlayConstants.PLAY_IS_FULL_SCREEN) isFullScreen: boolean
  @Consume(PlayConstants.PLAY_URL) @Watch('onPlayUrlChanged') url: string
  @Consume(PlayConstants.PLAY_IS_SHOW_BUY) @Watch('onBuyPlayChanged') showBuyPlay: boolean
  @Consume(PlayConstants.PLAY_TITLE) playTitle: string
  @Consume(PlayConstants.PLAY_LAST_POSITION) playLastPosition: number
  @Consume(PlayConstants.PLAY_IS_TRY_END) playIsTryEnd: boolean
  @State isPlaying: boolean = true // 是否正在播放
  @State durationTime: number = 0 // 总时长
  @State currentTime: number = 0 // 当前播放位置
  @State isSwiping: boolean = false // 是否正在滑动中
  @State isGestureHandler: boolean = false // 是否正在滑动中
  @State XComponentFlag: boolean = true // 是否显示播放区域
  @State showLoading: boolean = false // 是否正在缓冲
  @State intervalId: number = 0
  @State videoWidth: number = 0
  @State videoHeight: number = 0
  private tag: string = 'PlayComponent'
  private surfaceId: string = ''
  private xComponentController: XComponentController = new XComponentController()
  private navigationIndicatorHeight: number | undefined

  aboutToAppear() {
    this.navigationIndicatorHeight = px2vp(AppStorage.get(AppStorageConstants.NAVIGATION_INDICATOR_HEIGHT_KEY)) + 10
    this.avPlayManage.setBufferingUpdateListener((infoType: media.BufferingInfoType, value: number) => {
      this.onBufferingUpdate(infoType, value)
    })
    this.avPlayManage.setPlayingListener(() => {
      this.onPlaying()
    })

    this.avPlayManage.setPlayCompletedListener(() => {
      this.onPlayCompleted()
    })

    this.avPlayManage.setVideoSizeChangeListener((width: number, height: number) => {
      this.onVideoSizeChange(width, height)
    })
  }

  aboutToDisappear() {
    this.avPlayManage?.videoRelease()
    clearTimeout(this.intervalId)
  }

  build() {
    Stack() {
      this.videoDisplayBlock()
      this.playControlBlock()
      this.buyPlayBlock()
      this.tryPlayEndBlock()
      this.loadingBlock()
    }
    .padding({ top: this.isFullScreen ? 0 : this.navigationIndicatorHeight })
    .height(Constants.FULL_PARENT)
    .width(Constants.FULL_PARENT)
  }

  @Builder
  videoDisplayBlock() {
    Column() {
      XComponent({
        id: 'xComponent',
        type: 'surface',
        controller: this.xComponentController
      })
        .visibility(this.XComponentFlag ? Visibility.Visible : Visibility.Hidden)
        .onLoad(() => {
          this.handleXComponentLoad()
        })
        .aspectRatio(
          (this.videoWidth == 0 ? 16 : this.videoWidth) / (this.videoHeight == 0 ? 9 : this.videoHeight)
        )
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Black)
  }

  @Builder
  playControlBlock() {
    PlayControlComponent({
      currentTime: this.currentTime,
      durationTime: this.durationTime,
      playControlComponentTitle: this.playTitle,
      isPlaying: this.isPlaying,
      isSwiping: this.isSwiping,
      isGestureSwiping: this.isGestureHandler
    })
  }

  @Builder
  buyPlayBlock() {
    Column() {
      Text('购买观看完整课程')
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))

      Text('立即购买')
        .height($r('app.string.lpx_72'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'), 0.0],
            [$r('app.color.color_F12E29'), 0.7],
            [$r('app.color.color_F12E29'), 1.0]
          ]
        })
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({ top: $r('app.string.lpx_24') })
        .padding({
          left: $r('app.string.lpx_98'),
          right: $r('app.string.lpx_98')
        })
        .onClick(() => {
          this.handleBuyPlayClick()
        })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_444444'))
    .justifyContent(FlexAlign.Center)
    .visibility(this.showBuyPlay ? Visibility.Visible : Visibility.None)
  }

  @Builder
  tryPlayEndBlock() {
    Column() {
      Text('试看结束购买观看完整课程')
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))

      Row({ space: 5 }) {
        Text('点击重播')
          .height($r('app.string.lpx_72'))
          .backgroundColor($r('app.color.color_33FFFFFF'))
          .border({
            width: $r('app.string.lpx_2'),
            radius: $r('app.string.lpx_16'),
            color: $r('app.color.color_33000000')
          })
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.string.lpx_24') })
          .padding({
            left: $r('app.string.lpx_98'),
            right: $r('app.string.lpx_98')
          })
          .onClick(() => {
            this.playIsTryEnd = false
            this.avPlayManage?.videoReset()
          })

        Text('立即购买')
          .height($r('app.string.lpx_72'))
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_FC6D38'), 0.0],
              [$r('app.color.color_F12E29'), 0.7],
              [$r('app.color.color_F12E29'), 1.0]
            ]
          })
          .borderRadius($r('app.string.lpx_16'))
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(28))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.string.lpx_24') })
          .padding({
            left: $r('app.string.lpx_98'),
            right: $r('app.string.lpx_98')
          })
          .onClick(() => {
            this.handleBuyPlayClick()
          })
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_444444'))
    .justifyContent(FlexAlign.Center)
    .visibility(this.playIsTryEnd ? Visibility.Visible : Visibility.None)
  }

  @Builder
  loadingBlock() {
    Text('正在缓冲...')
      .fontColor($r('app.color.white'))
      .fontSize(14)
      .backgroundColor($r('app.color.color_B3000000'))
      .borderRadius($r('app.string.lpx_8'))
      .padding({
        top: $r('app.string.lpx_12'),
        bottom: $r('app.string.lpx_12'),
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })
      .visibility(this.showLoading ? Visibility.Visible : Visibility.None)
  }

  @Builder
  playGestureHandlerBlock() {
    PlayGestureHandlerComponent({
      customBuilderParam: this.playControlBlock,
      onHorizontalSwipe: (swipeDistance: number, mode: number) => {
        Logger.info(this.tag, `durationTime = ${this.durationTime}`)
        Logger.info(this.tag, `currentTime = ${this.currentTime}`)
        Logger.info(this.tag, `onHorizontalSwipe = ${swipeDistance}`)
        // start
        // if (mode == 0) {
        //   this.isGestureHandler = true
        //   this.isSwiping = true
        //   this.avPlayManage?.videoPause()
        // }
        // let targetLocation = this.currentTime + (swipeDistance * 15)
        // Logger.info(this.tag, `targetLocation = ${targetLocation}`)
        //
        // if (targetLocation <= 0) {
        //   this.avPlayManage?.videoSeek(0)
        //   this.currentTime = 0
        // } else if (targetLocation > this.durationTime) {
        //   this.avPlayManage?.videoSeek(this.durationTime)
        //   this.currentTime = this.durationTime
        // } else {
        //   this.avPlayManage?.videoSeek(targetLocation)
        //   this.currentTime = targetLocation
        // }
        // // end
        // if (mode == 2) {
        //   this.isGestureHandler = false
        //   this.isSwiping = false
        //   this.isPlaying = true
        //   this.avPlayManage?.videoPlay()
        // }
      },
      onLeftVerticalSwipe: (swipeDistance: number) => {
        console.error(`onLeftVerticalSwipe = ${swipeDistance}`)
      },
      onRightVerticalSwipe: (swipeDistance: number) => {
        console.error(`onRightVerticalSwipe = ${swipeDistance}`)
      },
      onDoubleTap: () => {
        console.error(`onDoubleTap`)
      }
    })
  }

  private startTask() {
    clearTimeout(this.intervalId)
    this.intervalId = setInterval(() => {
      if (!this.isSwiping) {
        this.currentTime = this.avPlayManage.getCurrentTime() ?? 0
        // Logger.info(this.tag, `currentTime = ${this.currentTime}`)
      }
    }, 100);
  }

  private onPlayUrlChanged() {
    Logger.info(this.tag, `onPlayUrlChanged url = ${this.url}`)
    this.avPlayManage.videoChoose(this.url)
  }

  private onBuyPlayChanged() {
    Logger.info(this.tag, `onBuyPlayChanged video release`)
    this.avPlayManage?.videoReset()
  }

  private onBufferingUpdate(infoType: media.BufferingInfoType, value: number) {
    Logger.info(
      this.tag, 'setAVPlayerCallback bufferingUpdate , infoType value is:' + infoType + ', value is :' + value
    )
    if (infoType == media.BufferingInfoType.BUFFERING_START) {
      this.showLoading = true
    } else if (infoType == media.BufferingInfoType.BUFFERING_END) {
      this.showLoading = false
    }
  }

  private onPlaying() {
    if (this.playLastPosition != 0) {
      Logger.info(this.tag, `this.playLastPosition = ${this.playLastPosition}`)
      // 设置上次播放位置
      if (this.playLastPosition) {
        Logger.info(this.tag, `this.playLastPosition = ${this.playLastPosition}`)
        this.avPlayManage?.videoSeek(this.playLastPosition * 1000)
      }
    }
    // 避免每次播放都会 seek
    this.playLastPosition = 0
    this.startTask()
  }

  private onPlayCompleted() {
    clearTimeout(this.intervalId)
  }

  private onVideoSizeChange(width: number, height: number) {
    Logger.info(this.tag, `onVideoSizeChange: width = ${width}, height = ${height}`)
    this.videoWidth = width
    this.videoHeight = height
  }

  private handleBuyPlayClick = () => {
  }

  private handleXComponentLoad() {
    this.surfaceId = this.xComponentController.getXComponentSurfaceId()
    this.avPlayManage?.initPlayer(this.surfaceId,
      (avPlayer: media.AVPlayer) => {
        // 设置视频总时长
        this.durationTime = this.avPlayManage?.getDurationTime() ?? 0
        // 更新当前时间
        this.startTask()
      })
  }
}