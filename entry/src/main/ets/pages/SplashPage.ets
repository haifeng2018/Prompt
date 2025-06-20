import router from '@ohos.router';
import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { SplashInfo } from '../data/SplashInfo';
import SplashVM from 'lib_core_model/src/main/ets/vm/SplashVM'
import { AdData } from 'lib_core_model/src/main/ets/data/AdData';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import PrivacyPolicyDialog from '../view/dialog/PrivacyPolicyDialog';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import App from 'lib_core_model/src/main/ets/App';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import PreferenceUtil from 'lib_core_model/src/main/ets/util/PreferenceUtil';

@Entry
@Component
struct SplashPage {
  private TAG = 'SplashPage'
  private context?: common.UIAbilityContext;
  private swiperController: SwiperController = new SwiperController()
  @State hasShowGuide: boolean = false//是否显示过引导页
  @State enterAppBtnVisible: boolean = false//进入app按钮是否可见
  @State enterAppBtnOpacity: number = 0//进入app按钮透明度
  @State countDownSeconds: number = 3;
  private timerId: number = 0;
  @State mAdUrl: string = '';

  splashImageArray: Array<SplashInfo> = [
    new SplashInfo('1', '第一张图片标题', $r('app.media.img_splash1')),
    new SplashInfo('2', '第二张图片标题', $r('app.media.img_splash2')),
    new SplashInfo('3', '第三张图片标题', $r('app.media.img_splash3'))
 ]

  sendAdRequest () {
    SplashVM.sendAdRequest().then((data: AdData) => {
      let count = data.adInfoVos?.length ?? 0
      if (count > 0) {
        this.mAdUrl = data.adInfoVos?.[0].url ?? ''
      } else {
        this.jumpToAppHomePage()
      }

    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyPolicyDialog(
      {
        cancel: this.onCancel.bind(this),
        confirm: this.onConfirm.bind(this),
        dismiss: this.onDismiss.bind(this)
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  onCancel() {
    // Exit the application.
    this.context?.terminateSelf();
  }

  onConfirm() {
    // Save privacy agreement status.
    this.saveIsPrivacy()
  }

  onDismiss() {
    // Exit the application.
    PreferenceUtil.get(Constants.HAS_SHOW_PRIVACY_KEY).then((value: preferences.ValueType | null) => {
      Logger.info(this.TAG, 'AboutToAppear value: ' + value);
      if (value) {
        this.context?.terminateSelf();
      }
    });
  }

  aboutToAppear(): void {
    this.context = getContext(this) as common.UIAbilityContext;
    // Get the operation class for saving data.
    PreferenceUtil.get(Constants.HAS_SHOW_GUIDE_KEY).then((value: preferences.ValueType | null) => {
      Logger.info(this.TAG, 'AboutToAppear value: ' + value);
      if (value) {
        this.hasShowGuide = true
        this.sendAdRequest()
      } else {
        this.hasShowGuide = false
      }
    });
  }

  onPageShow() {
    PreferenceUtil.get(Constants.HAS_SHOW_GUIDE_KEY).then((value: preferences.ValueType | null) => {
      Logger.info(this.TAG, 'HAS_SHOW_GUIDE_KEY-value: ' + value);
      if (value) {
        this.timerId = setInterval(() => {
          if (this.countDownSeconds == 0) {
            this.jumpToAppHomePage();
          } else {
            this.countDownSeconds--;
          }
        }, Constants.AD_INTERVAL_TIME);
      }
    });

    PreferenceUtil.get(Constants.HAS_SHOW_PRIVACY_KEY).then((value: preferences.ValueType | null) => {
      Logger.info(this.TAG, 'HAS_SHOW_PRIVACY_KEY-value: ' + value);
      if (!value) {
        this.dialogController.open();
      }
    });
  }

  onPageHide() {
    clearTimeout(this.timerId)
  }

  jumpToAppHomePage() {
    App.get().replaceUrl({
      url: RouterPath.MAIN_PAGE
    })
  }

  saveHasShowGuide() {
    PreferenceUtil.put(Constants.HAS_SHOW_GUIDE_KEY, true)
  }

  saveIsPrivacy() {
    PreferenceUtil.put(Constants.HAS_SHOW_PRIVACY_KEY, true)
  }

  build() {
    if (this.hasShowGuide) {
      this.adContent()
    } else {
      this.splashGuideContent()
    }
  }

  @Builder adContent() {
    Stack({ alignContent: Alignment.TopEnd }) {

      Image($r('app.media.img_splash'))
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)

      Column() {

        Image(this.mAdUrl)
          .width(Constants.FULL_PARENT)
          .layoutWeight(1)

        Row() {
          Image($r('app.media.ic_splash_logo'))
            .width($r('app.string.lpx_120'))
            .height($r('app.string.lpx_120'))

          Column() {
            Text('选好课 上获课')
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(40))
              .textAlign(TextAlign.Start)

            Text('中国知识付费交易市场')
              .fontColor($r('app.color.color_777777'))
              .fontSize(lpx2fp(32))
              .textAlign(TextAlign.Start)
              .margin({top:$r('app.string.lpx_5')})
          }
          .margin({left:$r('app.string.lpx_24')})
          .alignItems(HorizontalAlign.Start)

        }
        .width(Constants.FULL_PARENT)
        .height('20%')
        .backgroundColor($r('app.color.white'))
        .justifyContent(FlexAlign.Center)
      }
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)

      Text($r('app.string.advertising_text_title', this.countDownSeconds))
        .fontColor(Color.White)
        .fontSize(lpx2fp(24))
        .backgroundColor($r('app.color.color_33000000'))
        .border({
          radius: $r('app.string.lpx_8')
        })
        .margin({
          top: $r('app.string.lpx_128'),
          right: $r('app.string.lpx_32')
        })
        .padding({
          left: $r('app.string.lpx_12'),
          top: $r('app.string.lpx_8'),
          right: $r('app.string.lpx_12'),
          bottom: $r('app.string.lpx_8')
        })
        .onClick(() => {
          this.jumpToAppHomePage();
        })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
  }

  @Builder splashGuideContent() {
    Stack({ alignContent: Alignment.Bottom }) {
      Swiper(this.swiperController) {
        ForEach(this.splashImageArray, (item: SplashInfo) => { // ForEach循环渲染 item即是imageArray数组的每一项
          Image(item.image)
            .objectFit(ImageFit.Fill) // 图片铺满
            .width(Constants.FULL_PARENT)
            .height(Constants.FULL_PARENT) // 固定高度
        })
      }
      .cachedCount(3)
      .index(0)
      .autoPlay(false)
      .interval(1000)
      .indicator( // 设置圆点导航点样式
        new DotIndicator()
          .itemWidth($r('app.string.lpx_20'))
          .itemHeight($r('app.string.lpx_20'))
          .selectedItemWidth($r('app.string.lpx_20'))
          .selectedItemHeight($r('app.string.lpx_20'))
          .color($r('app.color.color_1400001E'))
          .selectedColor($r('app.color.color_ED1B24'))
          .bottom($r('app.string.lpx_60'))
      )
      .loop(false)
      .duration(300)
      .itemSpace(0)
      .effectMode(EdgeEffect.None)
      .curve(Curve.Linear)
      .displayMode(SwiperDisplayMode.Stretch)
      .onChange((index: number) => {
        this.enterAppBtnVisible = index == 2
        if (this.enterAppBtnVisible) {
          this.enterAppBtnOpacity = 1
        } else {
          this.enterAppBtnOpacity = 0
        }
      })
      Button($r('app.string.start_study'))
        .width('70%')
        .height($r('app.string.lpx_88'))
        .backgroundColor($r('app.color.color_EB4F3A'))
        .fontWeight(FontWeight.Bold)
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.white'))
        .visibility(this.enterAppBtnVisible ? Visibility.Visible : Visibility.Hidden)
        .align(Alignment.Center)
        .margin({bottom:$r('app.string.lpx_150')})
        .opacity(this.enterAppBtnOpacity)
        .animation({
          duration: 1000, // 动画时长
          curve: Curve.FastOutSlowIn, // 动画曲线
          delay: 0, // 动画延迟
          iterations: 1, // 播放次数
          playMode: PlayMode.Normal // 动画模式
        }) // 对Button组件的宽高属性进行动画配置
        .onClick(() => {
          this.jumpToAppHomePage()
          this.saveHasShowGuide()
        })
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
  }

}

