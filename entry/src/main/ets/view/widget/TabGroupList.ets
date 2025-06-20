/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: TabGroupList
 * Author: Victor
 * Date: 2023/12/27 17:26
 * Description: 
 * -----------------------------------------------------------------
 *//*

import Constants from '../../util/Constants'
@Entry
@Component
export default struct TabGroupList {
  private outline = ['物理', '化学', '生物','地理','英语','阿道夫','阿的说法','的双方各']
  private scroller: Scroller = new Scroller();
  @State startIndex: number = 1

  build() {
    Stack() {
      List({ space: 20 ,scroller: this.scroller}) {
        ListItemGroup() {
            ListItem() {
              Text('Header image')
                .width(Constants.FULL_PARENT)
                .height($r('app.float.vp_750'))
                .fontSize(20)
                .textAlign(TextAlign.Center)
                .backgroundColor(Color.Pink)
            }
        }
        .borderRadius(20)
        .divider({ strokeWidth: 1, color: Color.Orange }) // 每行之间的分界线

        ListItemGroup() {
          ListItem() {
            Text('Course Detail Product')
              .width(Constants.FULL_PARENT)
              .height($r('app.float.vp_750'))
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .backgroundColor(Color.Blue)
          }
        }
        .borderRadius(20)
        .divider({ strokeWidth: 1, color: Color.Pink }) // 每行之间的分界线

        ListItemGroup() {
          ForEach(this.outline, (project) => {
            ListItem() {
              Text(project)
                .width("100%")
                .height($r('app.float.vp_200'))
                .fontSize(20)
                .textAlign(TextAlign.Center).backgroundColor(Color.Gray)
            }
          }, item => item)
        }
        .borderRadius(20)
        .divider({ strokeWidth: 1, color: Color.Brown }) // 每行之间的分界线

        ListItemGroup() {
          ListItem() {
            Text('Evaluate')
              .width(Constants.FULL_PARENT)
              .height($r('app.float.vp_750'))
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .backgroundColor(Color.Green)
          }
        }
        .borderRadius(20)
        .divider({ strokeWidth: 1, color: Color.Grey }) // 每行之间的分界线

        ListItemGroup() {
          ListItem() {
            Text('Content title..........')
              .width(Constants.FULL_PARENT)
              .height($r('app.float.vp_100'))
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .backgroundColor(Color.Blue)
          }
        }
        .borderRadius(20)
        .divider({ strokeWidth: 1, color: Color.Grey }) // 每行之间的分界线

        ListItemGroup() {
          ForEach(this.outline, (project) => {
            ListItem() {
              Text('Content....web' + project)
                .width(Constants.FULL_PARENT)
                .height($r('app.float.vp_750'))
                .fontSize(20)
                .textAlign(TextAlign.Center)
                .backgroundColor(Color.Green)
            }
          }, item => item)

        }
        .borderRadius(20)
        .divider({ strokeWidth: 1, color: Color.Grey }) // 每行之间的分界线

        ListItemGroup() {
          ListItem() {
            Text('recommend title..........')
              .width(Constants.FULL_PARENT)
              .height($r('app.float.vp_100'))
              .fontSize(20)
              .textAlign(TextAlign.Center)
              .backgroundColor(Color.Blue)
          }
        }
        .borderRadius(20)
        .divider({ strokeWidth: 1, color: Color.Grey }) // 每行之间的分界线

        ListItemGroup() {
          ForEach(this.outline, (project) => {
            ListItem() {
              Text('Content....web' + project)
                .width(Constants.FULL_PARENT)
                .height($r('app.float.vp_750'))
                .fontSize(20)
                .textAlign(TextAlign.Center)
                .backgroundColor(Color.Gray)
            }
          }, item => item)

        }
        .borderRadius(20)
        .divider({ strokeWidth: 1, color: Color.Grey }) // 每行之间的分界线
      }
      .width(Constants.FULL_PARENT)
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        if (firstIndex === 1 || firstIndex === 3 || firstIndex === 4 || firstIndex === 6) {
          this.startIndex = firstIndex
        }
        console.info('first' + firstIndex)
        console.info('last' + lastIndex)
      })

      Row() {
        Text('商品')
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .fontSize(20)
          .fontColor(this.startIndex === 1 ? Color.Black : Color.Yellow)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.scroller.scrollToIndex(1)
          })
        Text('评价')
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .fontSize(20)
          .fontColor(this.startIndex === 3 ? Color.Black : Color.Yellow)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.scroller.scrollToIndex(3)
          })
        Text('详情')
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .fontSize(20)
          .fontColor(this.startIndex === 4 ? Color.Black : Color.Yellow)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.scroller.scrollToIndex(4)
          })
        Text('推荐')
          .height(Constants.FULL_PARENT)
          .layoutWeight(1)
          .fontSize(20)
          .fontColor(this.startIndex === 6 ? Color.Black : Color.Yellow)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.scroller.scrollToIndex(6)
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.float.vp_160'))
      .margin({top: $r('app.float.vp_160')})
      .backgroundColor('#42309900')
    }
    .width('100%').height('100%').backgroundColor(0xDCDCDC).padding({ top: 5 })
    .alignContent(Alignment.Top)

  }
}*/
