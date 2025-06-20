/*
import App from '../../App';
import { LoginData } from '../../bean/LoginData';
import { UserInfo } from '../../bean/UserInfo';
import HomeVM from '../../http/vm/HomeVM';
import UserVM from '../../http/vm/UserVM';
import AppConfig from '../../util/AppConfig';
import Constants from '../../util/Constants';
import PhoneUtil from '../../util/PhoneUtil';
import RouterPath from '../../util/RouterPath';
import ToastUtils from '../../util/ToastUtils';
import { PageState } from './refresh/PageState';
import RefreshComponent from './refresh/RefreshComponent';
import { RefreshConfig } from './refresh/RefreshConfig';
*/
/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: MeTabContent
 * Author: Victor
 * Date: 2023/2/27 15:10
 * Description: 首页-我的
 * -----------------------------------------------------------------
 *//*


@Preview
@Component
export struct MeTabContent {

  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;
  @Provide(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) listScrollTop : boolean = true;

  @State mUserInfo: UserInfo = null
  @State signStatusCount: number = 0

  @Link @Watch('sendUserInfoRequest') loginData: LoginData;

  sendUserInfoRequest () {
    UserVM.sendUserInfoRequest(this.loginData?.token,{
      onSuccess: (value) => {
        this.pageState = PageState.Success
        this.mUserInfo = value.data
        AppConfig.setUserInfo(this.mUserInfo)
      },
      onFail: (code,msg) => {
        this.pageState = PageState.Fail
        ToastUtils.show(msg)
      }
    })
  }

  sendSignStatusRequest () {
    HomeVM.sendSignStatusRequest(this.loginData?.token,{
      onSuccess: (value) => {
        this.signStatusCount = value.data
      },
      onFail: (code,msg) => {
        ToastUtils.show(msg)
      }
    })
  }

  sendAllRequest() {
    if (this.loginData) {
      this.sendUserInfoRequest()
      this.sendSignStatusRequest()
    }
  }

  aboutToAppear() {
    this.sendAllRequest()
  }

  onPageShow() {
    this.sendSignStatusRequest()
  }

  build() {
    Column() {
      this.titleBar()
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .linearGradient({
      angle: 180,
      colors: [
        [$r('app.color.color_F7E8EB'),0.0],
        [$r('app.color.color_F8EEF6'),0.26],
        [$r('app.color.color_F8F9FD'),1.0]
      ]
    })
  }

  @Builder titleBar() {
    Stack(){
      Column() {

        Badge({
          value: '',
          style: {
            badgeSize: 6,
            badgeColor: this.signStatusCount === 1 ? $r('app.color.color_EB4F3A'): $r('app.color.transparent')
          }
        }) {
          Image($r('app.media.ic_home_notity'))
            .width($r('app.float.vp_40'))
            .height($r('app.float.vp_40'))
        }
        .width($r('app.float.vp_40'))
        .height($r('app.float.vp_40'))
        .margin({top: $r('app.float.vp_20')})

        Text('消息')
          .fontSize($r('app.float.fp_24'))
          .fontColor($r('app.color.color_333333'))
          .margin({top: $r('app.float.fp_4')})
      }
    }
    .width(Constants.FULL_PARENT)
    .alignContent(Alignment.TopEnd)
    .padding({
      top:$r('app.float.vp_100'),
      right:$r('app.float.vp_32')
    })
    .zIndex(1)
    .onClick(() => {
      App.get().pushUrl({
        url: RouterPath.NOTIFICATION_PAGE
      })
    })
  }

  @Builder content() {
    RefreshComponent({
      itemLayout: () => this.itemLayout(),
      onRefresh: () => {
        this.sendAllRequest()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({top: $r('app.float.vp_10')})
      .zIndex(0)
  }

  @Builder itemLayout() {
    List() {
      ListItem() {
        Row() {
          Image(this.mUserInfo?.headImg || $r('app.media.ic_avatar_place_holder'))
            .width($r('app.float.vp_140'))
            .height($r('app.float.vp_140'))
            .border({
              radius: $r('app.float.vp_70'),
              width: $r('app.float.vp_2'),
              color: $r('app.color.white')
            })

          Column() {
            Text(this.mUserInfo?.name)
              .fontColor($r('app.color.color_333333'))
              .fontSize($r('app.float.fp_36'))
              .fontWeight(FontWeight.Bold)
              .maxLines(1)
              .textOverflow({overflow: TextOverflow.Ellipsis})

            Text(PhoneUtil.blurPhone(this.mUserInfo?.phone))
              .fontColor($r('app.color.color_333333'))
              .fontSize($r('app.float.fp_28'))
              .maxLines(1)
              .textOverflow({overflow: TextOverflow.Ellipsis})
              .margin({top: $r('app.float.vp_20')})
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .padding({left: $r('app.float.vp_20')})

          Image($r('app.media.ic_edit_user_info'))
            .width($r('app.float.vp_32'))
            .height($r('app.float.vp_32'))
            .objectFit(ImageFit.Contain)
        }
        .width(Constants.FULL_PARENT)
      }
      .width(Constants.FULL_PARENT)
      .margin({top:$r('app.float.vp_32')})
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.EDIT_PROFILE_PAGE
        })
      })

      ListItem(){
        Column() {
          Text('我的订单')
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_32'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .margin({top:$r('app.float.vp_20'),left: $r('app.float.vp_20')})

          Row() {
            Column() {
              Image($r('app.media.ic_unpaid'))
                .width($r('app.float.vp_48'))
                .height($r('app.float.vp_48'))
              Text('未支付')
                .fontColor($r('app.color.color_777777'))
                .fontSize($r('app.float.fp_28'))
                .margin({top: $r('app.float.vp_8')})
            }
            .height(Constants.FULL_PARENT)
            .layoutWeight(1)
            .padding({top: $r('app.float.vp_16'),bottom: $r('app.float.vp_16')})
            .onClick(() => {
              App.get().pushUrl({
                url: RouterPath.MY_ORDER_PAGE,
                params: {
                  page_position: 1
                }
              })
            })

            Column() {
              Image($r('app.media.ic_be_evaluated'))
                .width($r('app.float.vp_48'))
                .height($r('app.float.vp_48'))
              Text('待评价')
                .fontColor($r('app.color.color_777777'))
                .fontSize($r('app.float.fp_28'))
                .margin({top: $r('app.float.vp_8')})
            }
            .height(Constants.FULL_PARENT)
            .layoutWeight(1)
            .padding({top: $r('app.float.vp_16'),bottom: $r('app.float.vp_16')})
            .onClick(() => {
              App.get().pushUrl({
                url: RouterPath.MY_ORDER_PAGE,
                params: {
                  page_position: 4
                }
              })
            })

            Column() {
              Image($r('app.media.ic_complete'))
                .width($r('app.float.vp_48'))
                .height($r('app.float.vp_48'))
              Text('已完成')
                .fontColor($r('app.color.color_777777'))
                .fontSize($r('app.float.fp_28'))
                .margin({top: $r('app.float.vp_8')})
            }
            .height(Constants.FULL_PARENT)
            .layoutWeight(1)
            .padding({top: $r('app.float.vp_16'),bottom: $r('app.float.vp_16')})
            .onClick(() => {
              App.get().pushUrl({
                url: RouterPath.MY_ORDER_PAGE,
                params: {
                  page_position: 2
                }
              })
            })

            Column() {
              Image($r('app.media.ic_all_order'))
                .width($r('app.float.vp_48'))
                .height($r('app.float.vp_48'))
              Text('全部订单')
                .fontColor($r('app.color.color_777777'))
                .fontSize($r('app.float.fp_28'))
                .margin({top: $r('app.float.vp_8')})
            }
            .height(Constants.FULL_PARENT)
            .layoutWeight(1)
            .padding({top: $r('app.float.vp_16'),bottom: $r('app.float.vp_16')})
            .onClick(() => {
              App.get().pushUrl({
                url: RouterPath.MY_ORDER_PAGE,
                params: {
                  page_position: 0
                }
              })
            })
          }
          .width(Constants.FULL_PARENT)
          .height($r('app.float.vp_128'))
          .margin({top: $r('app.float.vp_20')})
          .alignItems(VerticalAlign.Center)
        }
        .width(Constants.FULL_PARENT)
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.float.vp_12'))
        .alignItems(HorizontalAlign.Start)

      }
      .width(Constants.FULL_PARENT)
      .margin({top:$r('app.float.vp_48')})

      ListItem(){
        Row(){
          Image($r('app.media.ic_me_coupon'))
            .width($r('app.float.vp_48'))
            .height($r('app.float.vp_48'))
          Text('我的优惠券')
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_28'))
            .layoutWeight(1)
            .margin({left:$r('app.float.vp_20')})
          Image($r('app.media.ic_me_right'))
            .width($r('app.float.vp_13'))
            .height($r('app.float.vp_26'))
            .objectFit(ImageFit.Contain)
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.float.vp_104'))
      .margin({top:$r('app.float.vp_24')})
      .padding({left:$r('app.float.vp_20'),right: $r('app.float.vp_20')})
      .backgroundColor($r('app.color.white'))
      .border({
        radius: {
          topLeft: $r('app.float.vp_12'),
          topRight: $r('app.float.vp_12'),
        }
      })
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.MY_COUPON_PAGE
        })
      })

      ListItem(){
        Row(){
          Image($r('app.media.ic_me_fav'))
            .width($r('app.float.vp_48'))
            .height($r('app.float.vp_48'))
          Text('我的收藏')
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_28'))
            .layoutWeight(1)
            .margin({left:$r('app.float.vp_20')})
          Image($r('app.media.ic_me_right'))
            .width($r('app.float.vp_13'))
            .height($r('app.float.vp_26'))
            .objectFit(ImageFit.Contain)
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.float.vp_104'))
      .padding({left:$r('app.float.vp_20'),right: $r('app.float.vp_20')})
      .backgroundColor($r('app.color.white'))
      .border({
        radius: {
          topLeft: $r('app.float.vp_12'),
          topRight: $r('app.float.vp_12'),
        }
      })
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.MY_FAVORITE_PAGE
        })
      })

      ListItem(){
        Row(){
          Image($r('app.media.ic_me_feedback'))
            .width($r('app.float.vp_48'))
            .height($r('app.float.vp_48'))
          Text('意见反馈')
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_28'))
            .layoutWeight(1)
            .margin({left:$r('app.float.vp_20')})
          Image($r('app.media.ic_me_right'))
            .width($r('app.float.vp_13'))
            .height($r('app.float.vp_26'))
            .objectFit(ImageFit.Contain)
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.float.vp_104'))
      .padding({left:$r('app.float.vp_20'),right: $r('app.float.vp_20')})
      .backgroundColor($r('app.color.white'))
      .border({
        radius: {
          topLeft: $r('app.float.vp_12'),
          topRight: $r('app.float.vp_12'),
        }
      })
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.FEEDBACK_PAGE,
          params: {
            userId: this.mUserInfo.uid
          }
        })
      })

      ListItem(){
        Row(){
          Image($r('app.media.ic_me_setting'))
            .width($r('app.float.vp_48'))
            .height($r('app.float.vp_48'))
          Text('设置')
            .fontColor($r('app.color.color_333333'))
            .fontSize($r('app.float.fp_28'))
            .layoutWeight(1)
            .margin({left:$r('app.float.vp_20')})
          Image($r('app.media.ic_me_right'))
            .width($r('app.float.vp_13'))
            .height($r('app.float.vp_26'))
            .objectFit(ImageFit.Contain)
        }
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.float.vp_104'))
      .padding({left:$r('app.float.vp_20'),right: $r('app.float.vp_20')})
      .backgroundColor($r('app.color.white'))
      .border({
        radius: {
          topLeft: $r('app.float.vp_12'),
          topRight: $r('app.float.vp_12'),
        }
      })
      .onClick(() => {
        App.get().pushUrl({
          url: RouterPath.SETTING_PAGE,
          params: {
            userInfo: this.mUserInfo
          }
        })
      })

    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .padding({left:$r('app.float.vp_32'),right:$r('app.float.vp_32')})
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      // 监听当前列表首位索引
      this.listScrollTop = start === 0
    })
  }
}*/
