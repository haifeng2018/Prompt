/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HokPlayer
 * Author: Victor
 * Date: 2024/03/29 10:34
 * Description: 
 * -----------------------------------------------------------------
 */
import media from '@ohos.multimedia.media';
import { AvplayerStatus } from 'lib_core_model/src/main/ets/data/AvplayerStatus';
import { PlayEvents } from 'lib_core_model/src/main/ets/data/PlayEvents';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { PlayerThis } from './PlayerThis';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { PlayPageThis } from './PlayPageThis';
import { PlayPageInfo } from './PlayPageInfo';
import { PlayPlayerInfo } from './PlayPlayerInfo';

@Observed
export class HokPlayer {
  TAG = 'HokPlayer'
  private avPlayer?: media.AVPlayer;
  private surfaceId?: string;
  private playSpeed: number = PlayPageInfo.PLAY_SPEED;
  private duration: number = 0;
  private state?: string;
  private url?: string;
  private playerThis?: PlayerThis;
  private playPageThis?: PlayPageThis;

  constructor() {
    this.createAVPlayer();
  }

  initPlayer(surfaceId: string, url: string) {
    this.surfaceId = surfaceId
    this.url = url
    this.avPlayer!.url = this.url;
  }

  initPlayerThis(playerThis?: PlayerThis) {
    this.playerThis = playerThis;
  }

  initPlayPageThis(playPageThis?: PlayPageThis) {
    this.playPageThis = playPageThis;
  }

  createAVPlayer() {
    media.createAVPlayer().then((avPlayer) => {
      if (avPlayer) {
        this.avPlayer = avPlayer;
        this.bindPlayerState();
      } else {
        Logger.error('[PlayVideoModel] createAvPlayer fail!');
      }
    });
  }

  bindPlayerState() {
    this.avPlayer!.on(PlayEvents.STATE_CHANGE, async (state) => {
      Logger.error(this.TAG, "avPlayer()......state = " + state)
      this.state = state
      switch (state) {
        case AvplayerStatus.IDLE:
          this.playerThis!.showLoading = true
          this.avPlayer!.url = this.url;
          break;
        case AvplayerStatus.INITIALIZED:
          this.playerThis!.showLoading = true
          this.avPlayer!.surfaceId = this.surfaceId;
          this.avPlayer?.prepare();
          break;
        case AvplayerStatus.PREPARED:
          this.playerThis!.showLoading = false
          this.avPlayer!.videoScaleType = 0;
          this.setVideoSize();
          this.avPlayer?.play();
          this.duration = this.avPlayer?.duration ?? 0;
          break;
        case AvplayerStatus.PLAYING:
          this.playerThis!.showLoading = false
          this.watchStatus();
          break;
        case AvplayerStatus.PAUSED:
          this.watchStatus();
          break;
        case AvplayerStatus.COMPLETED:
          this.duration = PlayPlayerInfo.DURATION;
          this.avPlayer?.reset();
          break;
        case AvplayerStatus.RELEASED:
          this.avPlayer?.release();
          this.watchStatus();
          Logger.info('[PlayVideoModel] state released called')
          break;
        default:
          Logger.info('[PlayVideoModel] unKnown state: ' + state);
          break;
      }
    });
    this.avPlayer?.on(PlayEvents.TIME_UPDATE, (time: number) => {
    });
    this.avPlayer?.on(PlayEvents.ERROR, (error) => {
      this.showPlayError(error);
    })
  }

  watchStatus() {
    if (this.state === AvplayerStatus.PREPARED) {
      globalThis.windowClass.setWindowKeepScreenOn(true);
    } else {
      globalThis.windowClass.setWindowKeepScreenOn(false);
    }
  }

  setVideoSize() {
    if (this.avPlayer!.height > this.avPlayer!.width) {
      this.playPageThis!.videoWidth = PlayPageInfo.PLAY_PLAYER_HEIGHT_FULL;
      this.playPageThis!.videoHeight = PlayPageInfo.PLAY_PLAYER_HEIGHT_FULL;
      this.playPageThis!.videoPosition = FlexAlign.Start;
      this.playPageThis!.videoMargin = PlayPageInfo.HEIGHT;
    } else {
      this.playPageThis!.videoWidth = Constants.FULL_PARENT;
      this.playPageThis!.videoHeight = PlayPageInfo.PLAY_PLAYER_HEIGHT;
      this.playPageThis!.videoPosition = FlexAlign.Center;
      this.playPageThis!.videoMargin = PlayPageInfo.MARGIN_ZERO;
    }
  }

  showPlayError(error: BusinessError) {
    ToastUtils.show(JSON.stringify(error))
  }

  play(url: string) {
    this.playerThis!!.showBuyPlay = false
    this.playerThis!!.showLoading = true
    this.url = url
    this.avPlayer?.reset()
  }

  pause() {
    this.avPlayer?.pause();
  }

  release() {
    this.avPlayer?.release();
  }

  setSpeed(playSpeed: number) {
    if (Constants.OPERATE_STATE.indexOf(this.avPlayer!.state) === -1) {
      return;
    }
    this.playSpeed = playSpeed;
    this.avPlayer?.setSpeed(this.playSpeed);
  }

  showBuyPlay() {
    this.playerThis!!.showBuyPlay = true
    this.pause()
  }
}