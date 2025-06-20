import { mediaquery, window } from '@kit.ArkUI'
import router from '@ohos.router'
import App from 'lib_core_model/src/main/ets/App'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { UpdateVideoProgressParm } from 'lib_core_model/src/main/ets/data/UpdateVideoProgressParm'
import { VideoProgressInfo } from 'lib_core_model/src/main/ets/data/VideoProgressInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import { AliPlayerState } from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM'
import { LocalStorageConstants } from '../../data/LocalStorageConstants'
import { AliVideoComp } from '../../play/AliVideoComp'
import AliVideoController from '../../play/AliVideoController'
import { CourseMaterialTabContent } from './component/CourseMaterialTabContent'
import { CourseOutlineTabContent } from './component/CourseOutlineTabContent'
import { CoursePptTabContent } from './component/CoursePptTabContent'
import { CoursePractiseTabContent } from './component/CoursePractiseTabContent'
import { OnlineCourseStudyPlayRecommend } from './component/OnlineCourseStudyPlayRecommend'

// 初始化页面级 UI 状态存储
let onlineCourseStudyPlayPage: Record<string, string> = { 'OnlineCourseStudyPlayPage': '' };
let storage: LocalStorage = new LocalStorage(onlineCourseStudyPlayPage);
storage.setOrCreate(LocalStorageConstants.PLAY_IS_FULL_SCREEN, false);
storage.setOrCreate(LocalStorageConstants.PLAY_TITLE, '');

/**
 * 线上课程学习页（有视频播放）
 */
@Entry(storage)
@Component
struct OnlineCourseStudyPlayPage {
  @State tenantId: number = 0
  @State tabCheckPosition: number = 0
  @State playGoodsId: string = '' // 当前播放资料 goodsId 提供给获取 PPT 使用
  @State materialId: string = '' // 视频、音频资源 ID
  @State playToken: string = ''
  @State aliPlayerId: number = AliVideoController.createAliPlayer(getContext(), null) // 播放器
  @State isLandscape: boolean = false // 横竖屏切换时当前页面的标识 true-横屏 false-竖屏
  @State playProgressReportIntervalId: number = 0 // 播放进度上报任务 ID
  @State playStatus: number = -1 // 播放状态
  @State historyPlayProgressInfo: VideoProgressInfo | null = null // 历史播放记录
  @State historyPlayPosition: number = 0 // 历史播放位置
  @State loginData: LoginData | null = null
  @State historyPlayIndex: number = -1 // 历史播放剧集
  @State @Watch('onPlayPositionChanged') playIndex: number = -1
  @LocalStorageLink(LocalStorageConstants.PLAY_IS_FULL_SCREEN) @Watch('changeOrientation') isFullScreen: boolean = false
  @State goodsInfo: GoodsInfo = new GoodsInfo()
  private tag: string = 'OnlineCourseStudyPlayPage'
  private goodsId: string = (router.getParams() as object)?.[Constants.DATA]
  private tabTitles = ['目录', 'PPT', '资料', '练习', '推荐']
  private screenListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(orientation: landscape)')

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendOnlineCourseDetailRequest()
    })
    // 绑定当屏幕发生改变时的回调函数
    this.screenListener.on('change', (mediaQueryResult: mediaquery.MediaQueryResult) => {
      this.onPortrait(mediaQueryResult)
    })
    // 开启播放记录上报任务
    this.startPlayProgressReportTask()
    // 设置屏幕方向
    window.getLastWindow(getContext(this)).then(wind => {
      wind.setPreferredOrientation(window.Orientation.PORTRAIT, () => {
      })
    });
  }

  aboutToDisappear() {
    // 关闭播放器
    // AliVideoController.getPlayer(this.aliPlayerId)?.stop();
    // AliVideoController.dispose(this.aliPlayerId);
    // 设置窗口亮度
    window.getLastWindow(getContext(this)).then(wind => {
      wind.setWindowBrightness(-1)
    })
    // 移除播放记录上报任务
    clearTimeout(this.playProgressReportIntervalId)
  }

  onPageShow(): void {
    // AliVideoController.getPlayer(this.aliPlayerId)?.start();
  }

  onPageHide() {
    // AliVideoController.getPlayer(this.aliPlayerId)?.pause();
  }

  onBackPress(): boolean | void {
    if (this.isFullScreen) {
      this.isFullScreen = false
    } else {
      App.get().back()
    }
    return true
  }

  sendOnlineCourseDetailRequest() {
    CourseVM.sendOnlineCourseDetailRequest(this.loginData?.token ?? '', this.goodsId).then((value: GoodsInfo) => {
      this.goodsInfo = value
      this.tenantId = this.goodsInfo.tenantVO?.tenantId ?? 0
      if (this.loginData?.token != null) {
        this.sendGetPlayLastProgressRequest()
      }
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendGetPlayLastProgressRequest() {
    Logger.info(this.tag, `subOrderId = ${this.goodsInfo?.subOrderId}`)
    CourseVM.getPlayLastProgressRequest(
      this.loginData?.token ?? '',
      this.tenantId, this.goodsId,
      this.goodsInfo?.subOrderId ?? 0
    )
      .then((value: VideoProgressInfo) => {
        Logger.info(this.tag, `getPlayLastProgressRequest = ${JSON.stringify(value)}`)
        this.historyPlayProgressInfo = value
      })
      .catch((err: string | Resource) => {
        Logger.info(this.tag, `getPlayLastProgressRequest err ${err as string}`)
      })
      .finally(() => {
        if (this.historyPlayProgressInfo) {
          this.playGoodsId = this.historyPlayProgressInfo.goodsId ?? ''
          this.materialId = this.historyPlayProgressInfo.materialId ?? ''
        } else {
          this.playGoodsId = this.goodsInfo?.columnParentVos?.[0]?.goodsId ?? ''
          this.materialId = this.goodsInfo?.columnParentVos?.[0]?.materialId ?? ''
        }
        this.sendGetPlayTokenRequest(this.playGoodsId, this.materialId, true)
      })
  }

  sendGetPlayTokenRequest(goodsId: string, materialId: string, updatePlayPosition: boolean = false) {
    CourseVM.sendGetPlayTokenRequest(
      this.loginData?.token ?? '',
      this.tenantId ?? 0,
      goodsId,
      materialId
    )
      .then((value: string) => {
        this.playToken = value
        Logger.info(this.tag, `play token = ${value},play materialId = ${materialId}`)
        // 设置播放标题、播放位置、播放历史进度
        this.goodsInfo?.columnParentVos?.forEach((item, index) => {
          if (item.materialId == this.materialId) {
            storage.setOrCreate(LocalStorageConstants.PLAY_TITLE, item.contentName ?? '');
            if (updatePlayPosition) {
              this.historyPlayIndex = index
              this.historyPlayPosition = this.historyPlayProgressInfo?.lastPosition ?? 0
              Logger.info(this.tag, `playLastIndex = ${this.historyPlayIndex}`)
              Logger.info(this.tag, `playLastPosition = ${this.historyPlayPosition}`)
            }
          }
        })
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  sendUpdatePlayProgressRequest(parm: UpdateVideoProgressParm) {
    CourseVM.updatePlayProgressRequest(this.loginData?.token ?? '', this.tenantId, parm)
      .then(() => {
        Logger.info(this.tag, `updatePlayProgressRequest success`)
      })
      .catch((err: string | Resource) => {
        Logger.error(this.tag, `updatePlayProgressRequest err = ${err.toString()}`)
      })
  }

  /**
   * 监听横竖屏切换事件
   */
  onPortrait(mediaQueryResult: mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches as boolean) {
      this.isLandscape = true
    } else {
      this.isLandscape = false
    }
  }

  onPlayPositionChanged() {
    this.playGoodsId = this.goodsInfo?.columnParentVos?.[this.playIndex]?.goodsId ?? ''
    this.materialId = this.goodsInfo?.columnParentVos?.[this.playIndex]?.materialId ?? ''
    this.sendGetPlayTokenRequest(this.playGoodsId, this.materialId, false)
  }

  onPlayCompleted() {
    let length = this.goodsInfo?.columnParentVos?.length ?? 0
    Logger.info(this.tag, `length = ${length},playIndex = ${this.playIndex}`)
    if (this.playIndex >= (length - 1)) {
      this.playIndex = 0
    } else {
      this.playIndex = this.playIndex + 1
    }
  }

  changeOrientation() {
    // 调用该接口手动改变设备横竖屏状态
    window.getLastWindow(getContext(this)).then((wind) => {
      wind.setPreferredOrientation(
        this.isFullScreen ? window.Orientation.LANDSCAPE : window.Orientation.PORTRAIT
      )
      wind.setWindowSystemBarEnable(this.isFullScreen ? [] : ['status'])
    })
  }

  startPlayProgressReportTask() {
    clearTimeout(this.playProgressReportIntervalId)
    this.playProgressReportIntervalId = setInterval(() => {
      if (this.playStatus == AliPlayerState.Playing) {
        /*let parm = new UpdateVideoProgressParm()
        let getCurrentPosition = AliVideoController.getPlayer(this.aliPlayerId)?.getCurrentPosition() ?? 0
        parm.currentPosition = getCurrentPosition / 1000
        parm.goodsId = this.goodsId ?? ''
        parm.materialId = this.materialId ?? ''
        parm.subOrderId = this.goodsInfo?.subOrderId ?? 0
        this.sendUpdatePlayProgressRequest(parm)*/
      }
    }, 5000);
  }

  build() {
    Column() {
      this.toolBarHeader()
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  toolBarHeader() {
    Stack() {
      AliVideoComp({
        aliPlayerId: this.aliPlayerId,
        playToken: this.playToken,
        materialId: this.materialId,
        historyPlayPosition: this.historyPlayPosition,
        onStateChangedListener: (status: number) => {
          this.playStatus = status
          if (status == AliPlayerState.Completed) {
            Logger.info(this.tag, 'PlayCompleted')
            this.onPlayCompleted()
          }
        }
      })
    }
    .width(Constants.FULL_PARENT)
    .height(this.isLandscape ? Constants.FULL_PARENT : $r('app.string.lpx_520'))
  }

  @Builder
  content() {
    Column() {
      this.tabContent()
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .visibility(this.isLandscape ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  tabContent() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {
        CourseOutlineTabContent({
          historyPlayIndex: this.historyPlayIndex,
          playIndex: this.playIndex,
          goodsInfo: this.goodsInfo
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[0], 0))
      .align(Alignment.Top)

      TabContent() {
        CoursePptTabContent({
          playGoodsId: this.playGoodsId,
          tenantId: this.tenantId
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[1], 1))
      .align(Alignment.Top)

      TabContent() {
        CourseMaterialTabContent({
          goodsId: this.goodsId,
          tenantId: this.tenantId
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[2], 2))
      .align(Alignment.Top)

      TabContent() {
        CoursePractiseTabContent({
          goodsId: this.goodsId
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[3], 3))
      .align(Alignment.Top)

      TabContent() {
        OnlineCourseStudyPlayRecommend({
          tenantId: this.tenantId,
          goodsId: this.goodsId
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[4], 4))
      .align(Alignment.Top)

    }
    .layoutWeight(1)
    .vertical(false)
    .barMode(BarMode.Fixed)
    .barWidth(Constants.FULL_PARENT)
    .barHeight($r('app.string.lpx_84'))
    .onChange((index: number) => {
      this.tabCheckPosition = index
    })
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
  }

  @Builder
  TabBuilder(title: string, index: number) {
    Row() {
      Column() {
        Text(title)
          .layoutWeight(1)
          .fontColor($r('app.color.color_333333'))
          .fontSize(this.tabCheckPosition === index ? lpx2fp(32) : lpx2fp(30))
          .fontWeight(this.tabCheckPosition === index ? FontWeight.Bold : FontWeight.Normal)
        Image($r('app.media.ic_tab_indicator'))
          .height($r('app.string.lpx_10'))
          .opacity(this.tabCheckPosition === index ? 1 : 0)
      }
      .width($r('app.string.lpx_150'))
      .height(Constants.FULL_PARENT)
      .justifyContent(FlexAlign.Center)
    }
    .height(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
    })
  }
}
