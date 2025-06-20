import { BusinessError } from '@kit.BasicServicesKit'
import { media } from '@kit.MediaKit'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'

const CASE_ZERO = 0
const CASE_ONE = 1
const CASE_TWO = 2
const CASE_THREE = 3

/**
 * 播放器管理类
 */
export default class AvPlayManage {
  private tag: string = 'AVPlayManage'
  private avPlayer: media.AVPlayer | null = null
  private surfaceID: string = ''
  private currentTime: number = 0
  private durationTime: number = 0
  private speedSelect: number = 0
  private videoUrl: string = ''
  private onPlayCompleteds: Array<() => void> = []
  private onVideoSizeChanges: Array<(width: number, height: number) => void> = []

  /**
   * 初始化视频
   */
  async initPlayer(surfaceId: string, callback: (avPlayer: media.AVPlayer) => void): Promise<void> {
    this.surfaceID = surfaceId
    Logger.info(this.tag, `initPlayer surfaceId = ${this.surfaceID}`)
    try {
      Logger.info(this.tag, 'initPlayer start')
      this.avPlayer = await media.createAVPlayer()
      await this.setAVPlayerCallback(callback)
      Logger.info(this.tag, 'initPlayer end')
    } catch (e) {
      Logger.error(this.tag, `initPlayer err：${e}`)
    }
  }

  /**
   * 切换视频
   */
  async videoChoose(
    url: string,
    speedSelect?: number,
    callback?: (avPlayer: media.AVPlayer) => void
  ): Promise<void> {
    Logger.info(this.tag, `videoChoose url = ${url}, avPlayerState = ${this.avPlayer?.state}`)
    try {
      if(!url){
        ToastUtils.show('视频地址为空')
        return
      }
      if (speedSelect) {
        this.speedSelect = speedSelect
      }
      // type AVPlayerState = 'idle' | 'initialized' | 'prepared' | 'playing' | 'paused' | 'completed' | 'stopped' | 'released' | 'error'
      if (this.avPlayer) {
        if (this.avPlayer.state == 'idle') {
          this.avPlayer.url = url
        } else {
          this.videoReset().then(() => {
            this.videoUrl = url
          })
        }
      }
    } catch (e) {
      Logger.info(this.tag, `videoChoose err = ${JSON.stringify(e)}`)
    }
  }

  /**
   * 获取总时间
   */
  getDurationTime(): number {
    return this.durationTime == -1 ? 0 : this.durationTime
  }

  /**
   * 获取当前时间
   */
  getCurrentTime(): number {
    return this.currentTime == -1 ? 0 : this.currentTime
  }

  /**
   * 获取播放器状态
   */
  getPlayerState() {
    return this.avPlayer?.state
  }

  /**
   * 视频播放
   */
  videoPlay(): void {
    Logger.info(this.tag, `videoPlay`)
    if (this.avPlayer) {
      try {
        this.avPlayer.play()
      } catch (e) {
        Logger.error(this.tag, `videoPlay = ${JSON.stringify(e)}`)
      }
    }
  }

  /**
   * 视频暂停
   */
  videoPause(): void {
    Logger.info(this.tag, `videoPause`)
    if (this.avPlayer) {
      try {
        this.avPlayer.pause()
      } catch (e) {
        Logger.info(this.tag, `videoPause =  ${JSON.stringify(e)}`)
      }
    }
  }

  /**
   * 调节1.0倍速
   */
  videoSpeedOne(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X)
        Logger.info(this.tag, 'videoSpeed_1')
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_1 =  ${JSON.stringify(e)}`)
      }
    }
  }

  /**
   * 调节1.25倍速
   */
  videoSpeedOnePointTwentyFive(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X)
        Logger.info(this.tag, 'videoSpeed_1_25')
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_1_25 =  ${JSON.stringify(e)}`)
      }
    }
  }

  /**
   * 调节1.75倍速
   */
  videoSpeedOnePointSeventyFive(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X)
        Logger.info(this.tag, 'videoSpeed_1_75')
      } catch (e) {
        Logger.info(this.tag, 'videoSpeed_1_75 = ' + JSON.stringify(e))
      }
    }
  }

  /**
   * 调节2.0倍速
   */
  videoSpeedTwo(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X)
        Logger.info(this.tag, 'videoSpeed_2_0')
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_2_0 = ${JSON.stringify(e)}`)
      }
    }
  }

  /**
   * 视频跳转
   */
  videoSeek(seekTime: number): void {
    Logger.info(this.tag, `videoSeek`)
    if (this.avPlayer) {
      try {
        this.avPlayer.seek(seekTime, media.SeekMode.SEEK_PREV_SYNC)
        Logger.info(this.tag, `videoSeek = ${seekTime}`)
      } catch (e) {
        Logger.info(this.tag, `videoSeek = ${JSON.stringify(e)}`)
      }
    }
  }

  /**
   * 视频重置
   */
  async videoReset(): Promise<void> {
    Logger.info(this.tag, `videoReset`)
    if (this.avPlayer) {
      this.avPlayer.reset((err: BusinessError) => {
        if (err) {
          Logger.info(this.tag, `videoReset err = ${err.message}`)
        } else {
          Logger.info('videoReset success')
        }
      })
    }
  }

  /**
   * 释放视频资源
   */
  async videoRelease(): Promise<void> {
    Logger.info(this.tag, `videoRelease`)
    if (this.avPlayer) {
      this.avPlayer.release((err: BusinessError) => {
        if (err) {
          Logger.error(this.tag, `videoRelease err = ${err.message}`)
        } else {
          Logger.info(this.tag, 'videoRelease success')
        }
      })
    }
  }

  /**
   * 用于网络播放，监听网络播放缓冲信息。
   */
  setPlayCompletedListener(listener: () => void) {
    this.onPlayCompleteds.push(listener)
  }

  /**
   * 监听视频播放宽高变化事件，仅视频播放支持该订阅事件，默认只在prepared状态上报一次，但HLS协议码流会在切换分辨率时上报。
   */
  setVideoSizeChangeListener(listener: (width: number, height: number) => void) {
    this.onVideoSizeChanges.push(listener)
  }

  /**
   * 播放至结尾状态，当媒体资源播放至结尾时，如果用户未设置循环播放（loop = true），AVPlayer会进入completed状态，此时调用play()会进入playing状态和重播，调用stop()会进入stopped状态。
   */
  setBufferingUpdateListener(listener: (infoType: media.BufferingInfoType, value: number) => void) {
    this.onBufferingUpdate = listener
  }

  /**
   * 正在播放状态，在prepared/paused/completed状态调用play()方法，AVPlayer会进入playing状态。
   */
  setPlayingListener(listener: () => void) {
    this.onPlaying = listener
  }

  private async setAVPlayerCallback(callback: (avPlayer: media.AVPlayer) => void): Promise<void> {
    if (this.avPlayer === null) {
      return
    }
    // 监听seek生效的事件。
    this.avPlayer.on(
      'seekDone',
      (seekDoneTime) => {
        Logger.info(this.tag, `setAVPlayerCallback seekDone, seek = ${seekDoneTime}`)
      }
    )
    // 监听资源播放当前时间，单位为毫秒（ms），用于刷新进度条当前位置，默认间隔100ms时间上报，因用户操作(seek)产生的时间变化会立刻上报。
    this.avPlayer.on(
      'timeUpdate',
      (time: number) => {
        this.currentTime = time
        // Logger.info(this.tag, `setAVPlayerCallback timeUpdate success,and new time is = ${this.currentTime}`)
      }
    )
    // 用于网络播放，监听网络播放缓冲信息。
    this.avPlayer.on(
      'bufferingUpdate',
      (infoType: media.BufferingInfoType, value: number) => {
        Logger.info(this.tag,
          'setAVPlayerCallback bufferingUpdate , infoType value is:' + infoType + ', value is :' + value)
        this.onBufferingUpdate(infoType, value)
      }
    )
    // 监听视频播放宽高变化事件，仅视频播放支持该订阅事件，默认只在prepared状态上报一次，但HLS协议码流会在切换分辨率时上报。
    this.avPlayer.on(
      'videoSizeChange',
      (width: number, height: number) => {
        Logger.info(this.tag, 'setAVPlayerCallback videoSizeChange ,width is:' + width + ', height is :' + height)
        this.onVideoSizeChanges.forEach((callback) => {
          callback(width, height)
        })
      }
    )
    // 监听AVPlayer的错误事件，该事件仅用于错误提示，不需要用户停止播控动作。如果此时AVPlayerState也切至error状态，用户需要通过reset()或者release()退出播放操作。
    this.avPlayer.on(
      'error',
      (err) => {
        if (this.avPlayer === null) {
          return
        }
        Logger.error(this.tag, `setAVPlayerCallback error, code is ${err.code}, message is ${err.message}`)
        this.avPlayer.reset()
        ToastUtils.show(`播放异常 code is ${err.code}, message is ${err.message}`)
      }
    )
    // 监听播放状态机AVPlayerState切换的事件
    this.avPlayer.on(
      'stateChange',
      async (state, reason) => {
        Logger.info(this.tag, `setAVPlayerCallback stateChange, state is ${state}`)
        if (this.avPlayer === null) {
          return
        }
        switch (state) {
        // 闲置状态，AVPlayer刚被创建createAVPlayer()或者调用了reset()方法之后，进入Idle状态
          case 'idle':
            Logger.info(this.tag, 'setAVPlayerCallback stateChange, idle')
            if (this.videoUrl) {
              this.avPlayer.url = this.videoUrl
            }
            break
        // 资源初始化，在Idle 状态设置 url9+ 或 fdSrc9+属性，AVPlayer会进入initialized状态，此时可以配置窗口、音频等静态属性
          case 'initialized':
            Logger.info(this.tag, 'setAVPlayerCallback stateChange, initialized')
          // 设置显示的窗口
            this.avPlayer.surfaceId = this.surfaceID
            Logger.info(this.tag, `setAVPlayerCallback stateChange, initialized surfaceId = ${this.surfaceID}`)
            this.avPlayer.prepare()
            break
        // 已准备状态，在initialized状态调用prepare()方法，AVPlayer会进入prepared状态，此时播放引擎的资源已准备就绪
          case 'prepared': // prepare调用成功后上报该状态机
            Logger.info(this.tag, 'setAVPlayerCallback stateChange, prepared')
            this.durationTime = this.avPlayer.duration
            this.currentTime = this.avPlayer.currentTime
          // 调用播放接口开始播放
            this.avPlayer.play()
            Logger.info(this.tag, `setAVPlayerCallback stateChange, prepared speedSelect = ${this.speedSelect}`)
            switch (this.speedSelect) {
              case CASE_ZERO:
                this.videoSpeedOne()
                break
              case CASE_ONE:
                this.videoSpeedOnePointTwentyFive()
                break
              case CASE_TWO:
                this.videoSpeedOnePointSeventyFive()
                break
              case CASE_THREE:
                this.videoSpeedTwo()
                break
            }
          // 返回播放器对象
            callback(this.avPlayer)
            break
        // 正在播放状态，在prepared/paused/completed状态调用play()方法，AVPlayer会进入playing状态。
          case 'playing':
            Logger.info(this.tag, 'setAVPlayerCallback stateChange, playing')
            this.onPlaying()
            break
        // 播放至结尾状态，当媒体资源播放至结尾时，如果用户未设置循环播放（loop = true），AVPlayer会进入completed状态，此时调用play()会进入playing状态和重播，调用stop()会进入stopped状态。
          case 'completed':
            Logger.info(this.tag, 'setAVPlayerCallback stateChange, completed')
          // 执行所有注册的事件
            this.onPlayCompleteds.forEach((callback) => {
              callback()
            })
            break
          default:
            Logger.info(this.tag, `setAVPlayerCallback stateChange, state is ${state} 未处理`)
            break
        }
      }
    )
  }

  private onBufferingUpdate = (infoType: media.BufferingInfoType, value: number) => {
  }
  private onPlaying = () => {
  }
}