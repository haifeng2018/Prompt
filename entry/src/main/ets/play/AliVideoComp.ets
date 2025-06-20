import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { AliPlayerState, SeekType } from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import { InfoBean, InfoCode, UrlSource, VidAuth } from 'premierlibrary'
import {
  OnInfoListener,
  OnLoadingStatusListener,
  OnPreparedListener,
  OnStateChangedListener
} from 'premierlibrary/src/main/ets/com/aliyun/player/IPlayer'
import { AppStorageConstants } from '../data/AppStorageConstants'
import { LocalStorageConstants } from '../data/LocalStorageConstants'
import TimeUtil from '../util/TimeUtil'
import { AliVideoControlComp } from './AliVideoControlComp'
import AliVideoController from './AliVideoController'

/**
 * 阿里云播放器组件
 */
@Component
export struct AliVideoComp {
  tag: string = 'AliVideoComp'
  @LocalStorageLink(LocalStorageConstants.PLAY_IS_FULL_SCREEN) isFullScreen: boolean = false
  @LocalStorageLink(LocalStorageConstants.PLAY_IS_TRY_END) playIsTryEnd: boolean = false
  @Prop @Watch('onPlayTokenUpdated') playToken: string // 点播VidAuth播放（推荐）
  @Prop @Watch('onPlayUrlUpdated') playUrl: string // 点播UrlSource播放
  @Prop @Watch('onShowBuyPlayUpdated') showBuyPlay: boolean
  @Prop historyPlayPosition: number = 0 // 历史播放位置
  @Prop materialId: string
  @State videoProgress: number = 0
  @State videoDuration: number = 0
  @State videoDurationStr: string = '00:00/00:00'
  @State aliPlayerId: number = -1
  @State videoWidth: number = 0
  @State videoHeight: number = 0
  @State isPlaying: boolean = false
  @State showLoading: boolean = false
  @State loadingProgress: number = 0 // 缓冲进度
  @State loadingSpeed: number = 0 // 缓冲速度
  @State playStatus: number = -1 // 播放状态
  @State loginData: LoginData | null = null
  private xComponentController = new XComponentController()
  private navigationIndicatorHeight: number | undefined

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
    this.navigationIndicatorHeight = px2vp(AppStorage.get(AppStorageConstants.NAVIGATION_INDICATOR_HEIGHT_KEY)) + 10
  }

  aboutToDisappear() {

  }

  onBuyPlayClick = () => {
  }
  onStateChangedListener = (status: number) => {
  }

  onPlayTokenUpdated() {
    Logger.info(this.tag, `play token = ${this.playToken},play materialId = ${this.materialId}`)
    let player = AliVideoController.getPlayer(this.aliPlayerId)
    if (player) {
      const vidAuthSource: VidAuth = new VidAuth()
      vidAuthSource.setVid(this.materialId)
      vidAuthSource.setPlayAuth(this.playToken)
      player.setVidAuthDataSource(vidAuthSource)
      player.prepare()
    } else {
      Logger.info(this.tag, `XC get player failed. playerId = ${this.aliPlayerId}`)
    }
  }

  onPlayUrlUpdated() {
    this.playIsTryEnd = false
    Logger.info(this.tag, `playUrl = ${this.playUrl}`)
    let player = AliVideoController.getPlayer(this.aliPlayerId)
    if (player) {
      let urlSource: UrlSource = new UrlSource()
      urlSource.setUri(this.playUrl) // 必选参数，播放地址，可以是第三方点播地址，或阿里云视频点播服务中的播放地址，也可以是本地视频地址。
      player.setUrlDataSource(urlSource)
      player.prepare()
    }
  }

  onShowBuyPlayUpdated() {
    AliVideoController.getPlayer(this.aliPlayerId)?.stop()
  }

  onHistoryPlayPositionUpdated() {
    Logger.info(this.tag, `onHistoryPlayPositionUpdated = ${this.historyPlayPosition}`)
    if (this.historyPlayPosition > 0) {
      AliVideoController.getPlayer(this.aliPlayerId)?.seekTo(this.historyPlayPosition * 1000, SeekType.ACCURATE)
      this.historyPlayPosition = 0
    }
  }

  onPreparedListener: OnPreparedListener = {
    onPrepared: () => {
      Logger.info(this.tag, 'onPrepared')
      this.videoDuration = AliVideoController.getPlayer(this.aliPlayerId)?.getDuration() ?? 0
      AliVideoController.getPlayer(this.aliPlayerId)?.start()
    }
  }
  onInfoListener: OnInfoListener = {
    onInfo: (bean: InfoBean) => {
      if (bean.getCode() === InfoCode.CurrentPosition) {
        this.videoProgress = bean.getExtraValue() / this.videoDuration * 100
        this.videoDurationStr = this.getDurationString(this.videoDuration, bean.getExtraValue())
        // Logger.info(this.tag, `this.videoProgress = ${this.videoProgress}, this.videoDurationStr = ${this.videoDurationStr}`)
      } else if (bean.getCode() === InfoCode.BufferedPosition) {

      } else if (bean.getCode() === InfoCode.SwitchToSoftwareVideoDecoder) {

      }
    }
  }
  mOnStateChangedListener: OnStateChangedListener = {
    onStateChanged: (status: number) => {
      this.onStateChangedListener(status)
      let toastStatus: string = ""
      switch (status) {
        case AliPlayerState.Unknown:
          toastStatus = "未知"
          break
        case AliPlayerState.Empty:
          toastStatus = "空状态"
          break
        case AliPlayerState.Initializing:
          toastStatus = "初始化"
          break
        case AliPlayerState.ReadySuccess:
          toastStatus = "准备成功"
          break
        case AliPlayerState.Playing:
          toastStatus = "正在播放"
          this.isPlaying = true
          this.onHistoryPlayPositionUpdated()
          break
        case AliPlayerState.Paused:
          toastStatus = "已暂停"
          break
        case AliPlayerState.Stopped:
          toastStatus = "已停止"
          break
        case AliPlayerState.Completed:
          toastStatus = "播放完成"
          break
        case AliPlayerState.Error:
          toastStatus = "播放出错"
          break
        default:
          toastStatus = "未知"
          break
      }
      Logger.info(this.tag, `Status Changed: statusId = ${status}, status = ${toastStatus}`)
    }
  }
  onLoadingStatusListener: OnLoadingStatusListener = {
    onLoadingBegin: () => {
      Logger.info(this.tag, '正在缓冲...')
      this.showLoading = true
    },
    onLoadingProgress: (percent: number, netSpeed: number) => {
      this.loadingProgress = percent
      this.loadingSpeed = netSpeed
    },
    onLoadingEnd: () => {
      Logger.info(this.tag, '缓冲结束...')
      this.showLoading = false
      this.loadingProgress = 0
      this.loadingSpeed = 0
    }
  }

  getDurationString(duration: number, currentDuration: number) {
    let durationString: string = TimeUtil.secondToTime(Math.floor(duration / 1000))
    let currentDurationString: string = TimeUtil.secondToTime(Math.floor(currentDuration / 1000))
    return `${currentDurationString}/${durationString}`
  }

  build() {
    Stack() {
      this.videoDisplayBuilder()
      this.playControlBuilder()
      this.buyPlayBuilder()
      this.tryPlayEndBuilder()
      this.loadingBuilder()
    }
    .padding({ top: this.isFullScreen ? 0 : this.navigationIndicatorHeight })
    .height(Constants.FULL_PARENT)
    .width(Constants.FULL_PARENT)
  }

  @Builder
  videoDisplayBuilder() {
    Column() {
      XComponent({
        id: this.aliPlayerId.toString(),
        type: XComponentType.SURFACE,
        libraryname: 'premierlibrary',
        controller: this.xComponentController
      })
        .onLoad(() => {
          let player = AliVideoController.getPlayer(this.aliPlayerId)
          if (player) {
            player.setOnPreparedListener(this.onPreparedListener)
            player.setOnInfoListener(this.onInfoListener)
            player.setOnStateChangedListener(this.mOnStateChangedListener)
            player.setOnLoadingStatusListener(this.onLoadingStatusListener)
            player.setSurfaceId(this.aliPlayerId.toString())
          } else {
            Logger.info(this.tag, `XC get player failed. playerId = ${this.aliPlayerId}`)
          }
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
  playControlBuilder() {
    AliVideoControlComp({
      videoProgress: this.videoProgress,
      videoDurationStr: this.videoDurationStr,
      aliPlayerId: this.aliPlayerId,
      isPlaying: this.isPlaying
    })
  }

  @Builder
  loadingBuilder() {
    Text(`正在缓冲... ${this.loadingSpeed}Kb/s`)
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
  buyPlayBuilder() {
    Column() {
      Text('购买观看完整课程')
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))

      Text(this.loginData ? '立即购买' : '立即登录')
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
          this.onBuyPlayClick()
        })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_444444'))
    .justifyContent(FlexAlign.Center)
    .visibility(this.showBuyPlay ? Visibility.Visible : Visibility.None)
  }

  @Builder
  tryPlayEndBuilder() {
    Column() {
      Text('试看结束购买观看完整课程')
        .fontColor($r('app.color.white'))
        .fontSize(14)

      Row({ space: 5 }) {
        Text('点击重播')
          .height(36)
          .backgroundColor($r('app.color.color_33FFFFFF'))
          .border({
            width: $r('app.string.lpx_2'),
            radius: $r('app.string.lpx_16'),
            color: $r('app.color.color_33000000')
          })
          .fontColor($r('app.color.white'))
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.string.lpx_24') })
          .padding({
            left: $r('app.string.lpx_98'),
            right: $r('app.string.lpx_98')
          })
          .onClick(() => {
            this.playIsTryEnd = false
            this.onPlayUrlUpdated()
          })

        Text(this.loginData ? '立即购买' : '立即登录')
          .height(36)
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
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .margin({ top: $r('app.string.lpx_24') })
          .padding({
            left: $r('app.string.lpx_98'),
            right: $r('app.string.lpx_98')
          })
          .onClick(() => {
            if (this.isFullScreen) {
              this.isFullScreen = false
              setTimeout(() => {
                this.onBuyPlayClick()
              }, 1000);
            } else {
              this.onBuyPlayClick()
            }
          })
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_444444'))
    .justifyContent(FlexAlign.Center)
    .visibility(this.playIsTryEnd ? Visibility.Visible : Visibility.None)
  }
}