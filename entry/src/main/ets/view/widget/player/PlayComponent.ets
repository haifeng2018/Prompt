/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PlayComponent
 * Author: Victor
 * Date: 2024/03/29 10:15
 * Description: 
 * -----------------------------------------------------------------
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import { HokPlayer } from './HokPlayer';
import { PlayPlayerInfo } from './PlayPlayerInfo';

@Component
export struct PlayComponent {

  private xComponentController?: XComponentController;
  private surfaceID?: string;
  private mPlayer?: HokPlayer
  @State showLoading: boolean = false
  @State showBuyPlay: boolean = false
  @Link @Watch("play") url: string

  aboutToAppear() {
    if (this.mPlayer !== null) {
      this.mPlayer?.initPlayerThis(this);
    }
    this.xComponentController = new XComponentController();
  }

  build() {
    Stack() {
      XComponent({
        id: PlayPlayerInfo.ID,
        type: PlayPlayerInfo.TYPE,
        libraryname: PlayPlayerInfo.LIBRARY_NAME,
        controller: this.xComponentController
      })
        .onLoad(async () => {
          this.xComponentController?.setXComponentSurfaceSize({
            surfaceWidth: PlayPlayerInfo.SURFACE_WIDTH,
            surfaceHeight: PlayPlayerInfo.SURFACE_HEIGHT
          });
          this.surfaceID = this.xComponentController?.getXComponentSurfaceId();
          this.mPlayer?.initPlayer(this.surfaceID ?? '',this.url)
        })
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)

      //立即购买
      this.buyPlayContent()

      //loading
      this.loadingContent()

    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
  }

  @Builder buyPlayContent() {
    Column() {
      Text('购买观看完整课程')
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))

      Text('立即购买')
        .height($r('app.string.lpx_72'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'),0.0],
            [$r('app.color.color_F12E29'),0.7],
            [$r('app.color.color_F12E29'),1.0]
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
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_444444'))
    .justifyContent(FlexAlign.Center)
    .visibility(this.showBuyPlay ? Visibility.Visible: Visibility.None)
  }

  @Builder loadingContent() {
    Text('正在缓冲...')
      .fontColor($r('app.color.white'))
      .fontSize(lpx2fp(28))
      .backgroundColor($r('app.color.color_B3000000'))
      .borderRadius($r('app.string.lpx_8'))
      .padding({
        top: $r('app.string.lpx_12'),
        bottom: $r('app.string.lpx_12'),
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })
      .visibility(this.showLoading ? Visibility.Visible: Visibility.None)
  }

  play() {
    this.mPlayer?.play(this.url)
  }
}