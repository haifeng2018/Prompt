/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: CollapsingToolbar
 * Author: Victor
 * Date: 2024/02/22 12:15
 * Description: 
 * -----------------------------------------------------------------
 *//*

import Constants from '../../util/Constants';
import Logger from '../../util/Logger';
import ToastUtils from '../../util/ToastUtils';
import ToolBar from './ToolBar';
@Preview
@Component
export struct CollapsingToolbar {

  private headerHeight:number = vp2px(263)//vp_548
  private toolBarHeight:number = vp2px(75)//vp_158
  private lastMoveX = 0;
  private lastMoveY = 0;
  private orientation = 0; //滑动方向1 水平；2，垂直
  // 滑动的y偏移量
  @State headerYOffset: number = this.headerHeight
  @State collapsingStatus: number = 0//0：展开（默认） 1：中间状态；2，收起
  @State collapsingPercent: number = 0//折叠百分比（0-1）
  @State isPullDown: boolean = false

  build() {
    Stack() {
      this.header()
      this.content()
    }
    .alignContent(Alignment.Top)
    .onTouch((event) => {
      this.handleTouchEvent(event)
    })
  }

  @Builder header() {
    Column() {
      ToolBar({
        title: '老师简介',
        titleBackgroundColor: $r('app.color.transparent'),
        titleActionIcon: $r('app.media.ic_black_share'),
        shadowColor: $r('app.color.transparent'),
        titleActionClick:() => {
          ToastUtils.show('you click title action icon')
        }
      })
        .opacity(this.collapsingPercent)
    }
    .width(Constants.FULL_PARENT)
    .height(this.headerHeight)
    .backgroundColor(Color.Brown)
  }

  @Builder content() {
    Column() {
      Text(`isPullDown = ${this.isPullDown}\ncollapsingStatus = ${this.collapsingStatus}\n
    headerYOffset = ${this.headerYOffset}\n
    orientation = ${this.orientation}\n
    collapsingPercent=${this.collapsingPercent}`)
        .backgroundColor(Color.Grey)
        .layoutWeight(1)
        .width(Constants.FULL_PARENT)

      Text('ADFADSFADSFASDFASDFASDFASDFADSFASDFA')
        .width(Constants.FULL_PARENT)
        .fontSize(28)
        .fontColor($r('app.color.color_333333'))
        .backgroundColor($r('app.color.color_EB4F3A'))

    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .offset({ y: `${this.headerYOffset}px`})
    .padding({bottom: `${this.headerYOffset}px`})
  }

  handleTouchEvent(event: TouchEvent) {
    switch (event.type) {
      case TouchType.Down:
        this.lastMoveX = event.touches[0].x
        this.lastMoveY = event.touches[0].y
        break;
      case TouchType.Move:
        let xOffset = event.touches[0].x - this.lastMoveX
        let yOffset = event.touches[0].y - this.lastMoveY

        this.isPullDown = yOffset > 0
        if (this.isPullDown) {
          if (this.collapsingStatus == 0) {
            //下拉时已经是展开状态直接return
            return
          }
        } else {
          if (this.collapsingStatus == 2) {
            //收起时已经是收起状态直接return
            return
          }
        }

        let xDistance = Math.abs(xOffset)
        let yDistance = Math.abs(yOffset)

        if (yDistance > xDistance) {
          this.orientation = 2
        } else {
          this.orientation = 1
          return//水平滑动不处理
        }

        this.headerYOffset += yOffset
        this.lastMoveY = event.touches[0].y
        this.collapsingPercent = 1 - this.headerYOffset / this.headerHeight
        break;
      case TouchType.Cancel:
      case TouchType.Up:
        if (this.orientation != 2) {
          this.headerYOffset = this.headerHeight
          this.collapsingStatus = 0
          this.collapsingPercent = 0
          return
        }
        animateTo({
          duration: 300,
        }, () => {
          if (this.isPullDown) {
            this.headerYOffset = this.headerHeight
            this.collapsingStatus = 0
            this.collapsingPercent = 0
          } else {
            this.headerYOffset = this.toolBarHeight
            this.collapsingStatus = 2
            this.collapsingPercent = 1
          }
        })
        break;
      default:
        break;
    }
  }
}*/
