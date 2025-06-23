import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { ToolBar } from '../../view/widget/ToolBar';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import SwipeRefreshLayout from 'lib_common/src/main/ets/components/refresh/SwipeRefreshLayout';
import UserVM from 'lib_core_model/src/main/ets/vm/UserVM';
import { UserInfo } from 'lib_core_model/src/main/ets/data/UserInfo';
import { MemberPackageItem, MemberPackageList, PrivilegeItem, PrivilegeList } from '../../model/MeTabModel';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import { router } from '@kit.ArkUI';
import { HtmlApi } from 'lib_core_model/src/main/ets/api/HtmlApi';

@Entry
@Component
struct MemberCenterPage {

  @State loginData: LoginData | null = null

  @State mRefreshConfig: RefreshConfig<object> = new RefreshConfig<object>()
  @State mUserInfo: UserInfo = new UserInfo()
  @State mAgree: boolean = false;

  sendUserInfoRequest() {
    UserVM.sendUserInfoRequest(this.loginData?.token ?? '').then((data: UserInfo) => {
      this.mUserInfo = data
      AppConfig.setUserInfo(this.mUserInfo)
      this.mRefreshConfig.setAllData(Array.of(data), true, 1)
    }).catch((err: string | Resource) => {
      this.mRefreshConfig.setData([], false)
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  refreshData () {
    this.sendUserInfoRequest()
  }

  build() {
    Column() {
      ToolBar({title: '会员中心'})
      SwipeRefreshLayout({
        refreshConfig: this.mRefreshConfig,
        itemLayout: (): void => this.content(),
        onRefresh: () => {
          this.sendUserInfoRequest()
        }
      })
        .width(Constants.FULL_PARENT)
        .layoutWeight(1)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {
      this.topHeader()
      this.bottomContent()
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({ bottom: $r('app.string.lpx_20') })
  }

  @Builder topHeader() {
    Stack(){
      Row() {
        Image(this.mUserInfo?.headImg || $r('app.media.ic_avatar_place_holder'))
          .width($r('app.string.lpx_140'))
          .height($r('app.string.lpx_140'))
          .border({
            radius: $r('app.string.lpx_70'),
            width: $r('app.string.lpx_2'),
            color: $r('app.color.white')
          })
        Column(){
          Text(this.mUserInfo?.name)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(36))
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('暂未开通·超级会员尊享更多特权')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: $r('app.string.lpx_10') })
          Text('尊享VIP特权 工作娱乐样样行')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: $r('app.string.lpx_20') })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: $r('app.string.lpx_20') })
      }
      .backgroundImage($r('app.media.img_member_center_header'))
      .backgroundImageSize(ImageSize.Cover)
      .margin({
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_32')
      })
      .padding({
        top: $r('app.string.lpx_30'),
        bottom: $r('app.string.lpx_20'),
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })
    }
    .backgroundImage($r('app.media.img_member_center_header_bg'))
    .backgroundImageSize(ImageSize.Cover)
    .padding({
      top: $r('app.string.lpx_100')
    })
  }

  @Builder bottomContent() {
    Column() {

      Text('会员套餐')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .fontWeight(FontWeight.Bold)

      List({ space: 16 }) {
        ForEach(MemberPackageList, (item: MemberPackageItem) => {
          this.memberPackageCell(item)
        })
      }
      .listDirection(Axis.Horizontal)
      .margin({ top: $r('app.string.lpx_40') })

      Text('支付方式')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .fontWeight(FontWeight.Bold)
        .margin({ top: $r('app.string.lpx_20') })

      this.payWay()

      Text('立即购买')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_80'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'), 0.0],
            [$r('app.color.color_F12E29'), 0.7],
            [$r('app.color.color_F12E29'), 1.0]
          ]
        })
        .borderRadius($r('app.string.lpx_40'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({ top: $r('app.string.lpx_20') })

      Row() {
        Image(this.mAgree ? $r('app.media.chk_login_user_agreement_checked')
          : $r('app.media.chk_login_user_agreement_normal'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
          .padding($r('app.string.lpx_10'))
          .onClick(() => {
            this.mAgree = !this.mAgree
          })

        Text() {
          Span('购买会员套餐即代表您同意我们的').fontSize(lpx2fp(24)).fontColor($r('app.color.color_999999'))
          Span('《充值协议》 ')
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_EB4F3A'))
            .onClick(() => {
              this.jumpWebPage('充值协议', HtmlApi.USER_SERVICES_AGREEMENT)
            })
          Span('《用户协议》 ')
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_EB4F3A'))
            .onClick(() => {
              this.jumpWebPage('用户协议', HtmlApi.USER_SERVICES_AGREEMENT)
            })
          Span('《隐私政策》')
            .fontSize(lpx2fp(24))
            .fontColor($r('app.color.color_EB4F3A'))
            .onClick(() => {
              this.jumpWebPage('隐私政策', HtmlApi.PRIVACY_POLICY)
            })
        }
      }
      .margin({ top: $r('app.string.lpx_20') })

      Text('尊享特权')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .fontWeight(FontWeight.Bold)
        .margin({ top: $r('app.string.lpx_20') })

      this.privilegeList()
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({
      top: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .borderRadius({
      topLeft: $r('app.string.lpx_40'),
      topRight: $r('app.string.lpx_40')
    })
  }

  @Builder memberPackageCell(item: MemberPackageItem) {
    Column() {
      Text(item.type)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .fontWeight(FontWeight.Bold)
      Text(`￥${item.amount}.00`)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({ top: $r('app.string.lpx_10') })
      Text(item.unit)
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(24))
        .margin({ top: $r('app.string.lpx_20') })
    }
    .width($r('app.string.lpx_200'))
    .height($r('app.string.lpx_268'))
    .justifyContent(FlexAlign.Center)
    .border({
      width: $r('app.string.lpx_2'),
      radius: $r('app.string.lpx_16'),
      color: $r('app.color.color_666666')
    })
    .padding({
      left:$r('app.string.lpx_20'),
      right:$r('app.string.lpx_20')
    })
  }

  @Builder payWay() {
    Row(){
      Image($r('app.media.ic_wx_pay'))
        .width($r('app.string.lpx_40'))
        .height($r('app.string.lpx_40'))
      Text('微信支付')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .margin({ left: $r('app.string.lpx_20') })
    }
    .padding({
      top: $r('app.string.lpx_20'),
      bottom: $r('app.string.lpx_20'),
      left: $r('app.string.lpx_30'),
      right: $r('app.string.lpx_30')
    })
    .backgroundColor($r('app.color.color_80DDDDDD'))
    .borderRadius($r('app.string.lpx_16'))
  }

  @Builder privilegeList() {
    List() {
      ForEach(PrivilegeList, (item: PrivilegeItem) => {
        ListItem() {
          this.privilegeCell(item)
        }
        .onClick(() => {
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .margin({ top: $r('app.string.lpx_20') })
    .padding($r('app.string.lpx_10'))
    .backgroundColor($r('app.color.color_FF7D00'))
    .listDirection(Axis.Vertical)
    .edgeEffect(EdgeEffect.None)
    .lanes(2)
  }

  @Builder privilegeCell(item: PrivilegeItem) {
    Column() {
      Row(){
        Image(item?.icon)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_30'))
          .height($r('app.string.lpx_30'))
        Text(item.title)
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .margin({ left: $r('app.string.lpx_16') })
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(Constants.FULL_PARENT)

      Text(item.describe)
        .width(Constants.FULL_PARENT)
        .textAlign(TextAlign.Start)
        .margin({ top: $r('app.string.lpx_16') })
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(28))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_128'))
    .padding($r('app.string.lpx_10'))
    .backgroundColor($r('app.color.white'))
  }

  private jumpWebPage = (title: string, url: string) => {
    App.get().pushUrl({
      url: RouterPath.WEB_PAGE,
      params: {
        title: title,
        url: url,
      },
    }, router.RouterMode.Single)
  }
}
