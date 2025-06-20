import { JSON } from '@kit.ArkTS'
import { LengthMetrics, mediaquery, window } from '@kit.ArkUI'
import router from '@ohos.router'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { OfflineVideoInfo } from 'lib_core_model/src/main/ets/data/OfflineVideoInfo'
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
import CourseProductConfigDialog from '../../view/dialog/CourseProductConfigDialog'
import { CoursePriceTitleStyleDisplayComp } from '../common/CoursePriceDisplayComp'

// 初始化页面级 UI 状态存储
let onlineCourseStudyPlayPage: Record<string, string> = { 'OnlineCourseStudyPlayPage': '' };
let storage: LocalStorage = new LocalStorage(onlineCourseStudyPlayPage);
storage.setOrCreate(LocalStorageConstants.PLAY_IS_FULL_SCREEN, false);
storage.setOrCreate(LocalStorageConstants.PLAY_TITLE, '');

/**
 * 线下课程学习页（有视频播放）
 */
@Entry(storage)
@Component
struct OfflineCourseStudyPlayPage {
  @State playIndex: number = 0
  @State loginData: LoginData | null = null
  @State isLandscape: boolean = false // 横竖屏切换时当前页面的标识 true-横屏 false-竖屏
  @State playProgressReportIntervalId: number = 0 // 播放进度上报任务 ID
  @State playToken: string = ''
  @State aliPlayerId: number = AliVideoController.createAliPlayer(getContext(), null) // 播放器
  @State playStatus: number = -1 // 播放状态
  @State materialId: string = '' // 视频、音频资源 ID
  @State playGoodsId: string = '' // 当前播放资料 goodsId 提供给获取 PPT 使用
  @State historyPlayPosition: number = 0
  @State historyPlayProgressInfo: VideoProgressInfo | null = null
  @State goodsInfo: GoodsInfo | null = null
  @LocalStorageLink(LocalStorageConstants.PLAY_IS_FULL_SCREEN) @Watch('changeOrientation') isFullScreen: boolean = false
  private tag: string = 'OfflineCourseStudyPlayPage'
  private goodsId: string = (router.getParams() as object)?.[Constants.GOODS_ID]
  private subOrderId: number = (router.getParams() as object)?.[Constants.SUB_ORDER_ID] ?? -1
  private tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID] ?? 0
  private listener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(orientation: landscape)') // 横竖屏切换监听事件
  private courseProductConfigDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseProductConfigDialog({
      goodsInfo: this.goodsInfo
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendAllRequest()
    })
    // 绑定当屏幕发生改变时的回调函数
    this.listener.on('change', (mediaQueryResult: mediaquery.MediaQueryResult) => {
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
    AliVideoController.getPlayer(this.aliPlayerId)?.stop();
    AliVideoController.dispose(this.aliPlayerId);
    // 设置窗口亮度
    window.getLastWindow(getContext(this)).then(wind => {
      wind.setWindowBrightness(-1)
    })
    // 移除播放记录上报任务
    clearTimeout(this.playProgressReportIntervalId)
  }

  onPageShow(): void {
    AliVideoController.getPlayer(this.aliPlayerId)?.start();
  }

  onPageHide() {
    AliVideoController.getPlayer(this.aliPlayerId)?.pause();
  }

  onBackPress(): boolean | void {
    if (this.isFullScreen) {
      this.isFullScreen = false
    } else {
      App.get().back()
    }
    return true
  }

  build() {
    Column() {
      this.toolBarHeader()
      this.content()
      this.bottomActionBar()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
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
    List() {
      ListItem() {
        Text() {
          ImageSpan($r('app.media.ic_offline_course_label'))
            .width($r('app.string.lpx_96'))
            .height($r('app.string.lpx_40'))
            .objectFit(ImageFit.Contain)
          Span('\t')
          Span(this.goodsInfo?.contentName)
            .layoutWeight(1)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))
        }
        .width(Constants.FULL_PARENT)
        .maxLines(2)
        .lineSpacing(LengthMetrics.lpx(10))
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding({
          left: $r('app.string.lpx_20'),
          right: $r('app.string.lpx_20')
        })
      }

      ListItem() {
        this.courseOutline()
      }
    }
    .width(Constants.FULL_PARENT)
    .scrollBar(BarState.Off)
    .layoutWeight(1)
    .padding({
      top: $r('app.string.lpx_32'),
      left: $r('app.string.lpx_12'),
      right: $r('app.string.lpx_12')
    })
    .visibility(this.isLandscape ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  courseOutline() {
    Column() {
      Text('课程大纲')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
      Text(`已更新${this.goodsInfo?.lesson ?? 0}节`)
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(24))
        .margin({ top: $r('app.string.lpx_28') })
      Column() {
        ForEach(this.goodsInfo?.videoVos, (item: OfflineVideoInfo, index: number) => {
          Row() {
            Text(`${index + 1}`)
              .fontColor(this.playIndex === index ? $r('app.color.color_FF1F00') : $r('app.color.color_666565'))
              .fontSize(lpx2fp(28))
            Column() {
              Row() {
                Text(item?.name)
                  .layoutWeight(1)
                  .fontColor(this.playIndex === index ? $r('app.color.color_FF1F00') : $r('app.color.color_333333'))
                  .fontSize(lpx2fp(28))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .width(Constants.FULL_PARENT)
              .justifyContent(FlexAlign.Start)

              Text(GoodsShowUtil.getOfflineVideoTime(item))
                .fontColor(this.playIndex === index ? $r('app.color.color_FF1F00') : $r('app.color.color_666666'))
                .fontSize(lpx2fp(24))
                .margin({ top: $r('app.string.lpx_20') })
            }
            .layoutWeight(1)
            .margin({ left: $r('app.string.lpx_20') })
            .alignItems(HorizontalAlign.Start)
          }
          .padding({
            top: $r('app.string.lpx_12'),
            bottom: $r('app.string.lpx_12'),
            left: $r('app.string.lpx_20'),
            right: $r('app.string.lpx_20')
          })
          .width(Constants.FULL_PARENT)
          .alignItems(VerticalAlign.Top)
          .onClick(() => {
            this.handlePlayListClick(item, index)
          })
        })
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_28') })
      .padding({
        top: $r('app.string.lpx_12'),
        bottom: (this.goodsInfo?.lesson ?? 0) > 3 ? 0 : $r('app.string.lpx_12'),
      })
      .backgroundColor($r('app.color.color_FAFAFA'))
      .borderRadius($r('app.string.lpx_16'))
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_20'))
    .padding({
      top: $r('app.string.lpx_28'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }

  @Builder
  bottomActionBar() {
    Row() {
      Button({ type: ButtonType.Normal, stateEffect: true }) {
        Column() {
          Image($r('app.media.ic_course_customer_service'))
            .width($r('app.string.lpx_40'))
            .height($r('app.string.lpx_40'))

          Text('客服')
            .fontSize(lpx2fp(20))
            .fontColor($r('app.color.color_333333'))
            .margin({ top: $r('app.string.lpx_2') })
        }
      }
      .height(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.transparent'))
      .padding({ left: $r('app.string.lpx_22'), right: $r('app.string.lpx_22') })
      .visibility(Visibility.None)

      CoursePriceTitleStyleDisplayComp({
        goodsInfo: this.goodsInfo
      })

      Text('加购课程')
        .height($r('app.string.lpx_80'))
        .layoutWeight(1)
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
        .margin({ left: $r('app.string.lpx_58') })
        .onClick(() => {
          this.courseProductConfigDlgCtl.open()
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_112'))
    .backgroundColor($r('app.color.white'))
    .padding({
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .shadow({
      radius: $r('app.string.lpx_10'),
      color: $r('app.color.color_1400001E'),
      offsetX: $r('app.string.lpx_10'),
      offsetY: $r('app.string.lpx_10')
    })
    .visibility(this.isLandscape ? Visibility.Hidden : Visibility.Visible)
  }

  sendGetPlayTokenRequest() {
    this.playGoodsId = this.goodsInfo?.videoVos?.[this.playIndex]?.goodsId ?? ''
    this.materialId = this.goodsInfo?.videoVos?.[this.playIndex]?.materialId ?? ''
    CourseVM.sendGetPlayTokenRequest(
      this.loginData?.token ?? '',
      this.tenantId ?? 0,
      this.playGoodsId,
      this.materialId
    )
      .then((value: string) => {
        Logger.info(this.tag, `play token = ${value},play materialId = ${this.materialId}`)
        // 设置播放标题、播放位置、播放历史进度
        this.playToken = value
        let playTitle = this.goodsInfo?.videoVos?.[this.playIndex]?.name ?? ''
        storage.setOrCreate(LocalStorageConstants.PLAY_TITLE, playTitle ?? '');
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  private sendAllRequest() {
    this.sendOfflineCourseDetailRequest()
  }

  private sendOfflineCourseDetailRequest() {
    CourseVM.sendOfflineCourseDetailRequest(this.loginData?.token ?? '', this.goodsId, this.subOrderId)
      .then((value: GoodsInfo) => {
        this.goodsInfo = value
        this.getPlayLastProgressRequest()
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  private getPlayLastProgressRequest() {
    Logger.info(this.tag, `subOrderId = ${this.goodsInfo?.subOrderId}`)
    CourseVM.getPlayLastProgressRequest(
      this.loginData?.token ?? '',
      this.tenantId,
      this.goodsId,
      this.goodsInfo?.subOrderId ?? 0
    )
      .then((value: VideoProgressInfo) => {
        Logger.info(this.tag, `getPlayLastProgressRequest = ${JSON.stringify(value)}`)
        this.historyPlayProgressInfo = value
        if (this.historyPlayProgressInfo) {
          // 历史观看记录
          this.materialId = this.historyPlayProgressInfo.materialId ?? ''
          this.goodsInfo?.videoVos?.forEach((item, index) => {
            if (item.materialId == this.materialId) {
              this.playIndex = index
              this.historyPlayPosition = this.historyPlayProgressInfo?.lastPosition ?? 0
              Logger.info(
                this.tag,
                `setHistoryPlay historyPlayPosition = ${this.historyPlayPosition}, playIndex = ${this.playIndex}`
              )
            }
          })
        }
      })
      .catch((err: string | Resource) => {
        Logger.info(this.tag, `getPlayLastProgressRequest err ${err as string}`)
      })
      .finally(() => {
        this.sendGetPlayTokenRequest()
      })
  }

  private updatePlayProgressRequest(parm: UpdateVideoProgressParm) {
    CourseVM.updatePlayProgressRequest(this.loginData?.token ?? '', this.tenantId, parm)
      .then(() => {
        Logger.info(this.tag, `updatePlayProgressRequest success`)
      })
      .catch((err: string | Resource) => {
        Logger.error(this.tag, `updatePlayProgressRequest err = ${err.toString()}`)
      })
  }

  private handlePlayListClick(item: OfflineVideoInfo, index: number) {
    Logger.info(this.tag, `ColumnInfo = ${JSON.stringify(item)}`)
    this.playIndex = index
    this.sendGetPlayTokenRequest()
  }

  /**
   * 监听横竖屏切换事件
   */
  private onPortrait(mediaQueryResult: mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches as boolean) {
      this.isLandscape = true
    } else {
      this.isLandscape = false
    }
  }

  private onPlayCompleted() {
    let length = this.goodsInfo?.videoVos?.length ?? 0
    Logger.info(this.tag, `length = ${length},playPosition = ${this.playIndex}`)
    if (this.playIndex >= (length - 1)) {
      this.playIndex = 0
    } else {
      this.playIndex += 1
    }
    this.sendGetPlayTokenRequest()
  }

  private changeOrientation() {
    // 调用该接口手动改变设备横竖屏状态
    window.getLastWindow(getContext(this)).then((wind) => {
      wind.setPreferredOrientation(
        this.isFullScreen ? window.Orientation.LANDSCAPE : window.Orientation.PORTRAIT
      )
      wind.setWindowSystemBarEnable(this.isFullScreen ? [] : ['status'])
    })
  }

  private startPlayProgressReportTask() {
    clearTimeout(this.playProgressReportIntervalId)
    this.playProgressReportIntervalId = setInterval(() => {
      if (this.playStatus == AliPlayerState.Playing) {
        let parm = new UpdateVideoProgressParm()
        let getCurrentPosition = AliVideoController.getPlayer(this.aliPlayerId)?.getCurrentPosition() ?? 0
        parm.currentPosition = getCurrentPosition / 1000
        parm.goodsId = this.goodsId ?? ''
        parm.materialId = this.materialId
        parm.subOrderId = this.goodsInfo?.subOrderId ?? 0
        this.updatePlayProgressRequest(parm)
      }
    }, 5000);
  }
}
