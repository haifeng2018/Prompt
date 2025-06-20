import { JSON } from '@kit.ArkTS'
import { mediaquery, router, window } from '@kit.ArkUI'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { ColumnInfo } from 'lib_core_model/src/main/ets/data/ColumnInfo'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { LecturerInfo } from 'lib_core_model/src/main/ets/data/LecturerInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { PlayInfo } from 'lib_core_model/src/main/ets/data/PlayInfo'
import { UpdateVideoProgressParm } from 'lib_core_model/src/main/ets/data/UpdateVideoProgressParm'
import { VideoProgressInfo } from 'lib_core_model/src/main/ets/data/VideoProgressInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import {
  AliPlayerState,
  BuySource,
  CommonNumbers,
  GoodsType,
  VideoTrialStatus
} from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM'
import { LocalStorageConstants } from '../../data/LocalStorageConstants'
import { AliVideoComp } from '../../play/AliVideoComp'
import AliVideoController from '../../play/AliVideoController'
import PayOrderActionUtil from '../../util/action/PayOrderActionUtil'
import CourseTryPlayUtil from '../../util/CourseTryPlayUtil'
import PayOrderUtil from '../../util/PayOrderUtil'
import CourseDetailRecommend from './component/CourseDetailRecommend'
import { CourseTryPlayOutlineComponent } from './component/CourseTryPlayOutlineComponent'

// 初始化页面级 UI 状态存储
let onlineCourseStudyPlayPage: Record<string, string> = { 'OnlineCourseStudyPlayPage': '' };
let storage: LocalStorage = new LocalStorage(onlineCourseStudyPlayPage);
storage.setOrCreate(LocalStorageConstants.PLAY_IS_FULL_SCREEN, false);
storage.setOrCreate(LocalStorageConstants.PLAY_TITLE, '');
storage.setOrCreate(LocalStorageConstants.PLAY_IS_TRY_END, false);

/**
 * 课程试看
 */
@Entry(storage)
@Component
struct CourseTryPlayPage {
  @State tenantId: number = 0
  @State loginData: LoginData | null = null
  @State playInfoList: Array<PlayInfo> = []
  @State isLandscape: boolean = false // 横竖屏切换时当前页面的标识 true-横屏 false-竖屏
  @State playProgressReportIntervalId: number = 0 // 播放进度上报任务 ID
  @State listener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(orientation: landscape)') // 横竖屏切换监听事件
  @State tryPlayResourceList: Array<ColumnInfo> = [] // 试看资源列表
  @State goodsInfo: GoodsInfo | null = null
  @State aliPlayerId: number = AliVideoController.createAliPlayer(getContext(), null) // 播放器
  @State playUrl: string = ''
  @State playStatus: number = -1 // 播放状态
  @State currentPlayResource: ColumnInfo | null = null // 当前播放资源
  @State historyPlayProgressInfo: VideoProgressInfo | null = null
  @State historyPlayPosition: number = 0
  @State showBuyPlay: boolean = false
  @State recommendGoodsInfos: Array<GoodsInfo> = []
  @LocalStorageLink(LocalStorageConstants.PLAY_IS_FULL_SCREEN) @Watch('changeOrientation') isFullScreen: boolean = false
  private goodsId: string = (router.getParams() as object)?.[Constants.DATA] ?? ''
  private materialId: string = (router.getParams() as object)?.[Constants.MATERIAL_ID] ?? ''
  private cGoodsId: string = (router.getParams() as object)?.[Constants.C_GOODS_ID] ?? ''
  private tag: string = 'CourseTryPlayPage'

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
    this.startTaskPlayProgressReport()
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

  build() {
    Column() {
      this.toolBarHeader()
      this.content()
      this.bottomActionBar()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({bottom: $r('app.string.lpx_40')})
  }

  @Builder
  toolBarHeader() {
    Stack() {
      AliVideoComp({
        aliPlayerId: this.aliPlayerId,
        playUrl: this.playUrl,
        historyPlayPosition: this.historyPlayPosition,
        showBuyPlay: this.showBuyPlay,
        onStateChangedListener: (status: number) => {
          this.playStatus = status
          if (status == AliPlayerState.Completed) {
            Logger.info(this.tag, 'PlayCompleted')
            this.onPlayCompleted()
          }
        },
        onBuyPlayClick: () => {
          this.handleBuyPlayClick()
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
        Row() {
          Text(this.goodsInfo?.contentName)
            .width(Constants.FULL_PARENT)
            .layoutWeight(1)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))
            .fontWeight(FontWeight.Bold)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Image($r('app.media.ic_course_customer_service'))
            .width($r('app.string.lpx_40'))
            .height($r('app.string.lpx_40'))
            .visibility(Visibility.None)
        }
        .width(Constants.FULL_PARENT)
        .padding({
          left: $r('app.string.lpx_20'),
          right: $r('app.string.lpx_20')
        })
      }

      ListItem() {
        this.teacher()
      }

      ListItem() {
        CourseTryPlayOutlineComponent({
          onItemClick: (item: ColumnInfo, index: number) => {
            this.handlePlayListClick(item, index)
          },
          goodsInfo: this.goodsInfo,
          currentPlayResource: this.currentPlayResource
        })
      }

      ListItem() {
        CourseDetailRecommend({
          recommendGoodsInfos: this.recommendGoodsInfos
        })
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
  teacher() {
    Column() {
      Text('授课老师')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
      if (this.goodsInfo?.lecturers?.length === 1) {
        Row() {
          Image(this.goodsInfo?.lecturers[0]?.headUrl || $r('app.media.ic_avatar_place_holder'))
            .width($r('app.string.lpx_80'))
            .height($r('app.string.lpx_80'))
            .border({
              radius: $r('app.string.lpx_40'),
              width: $r('app.string.lpx_2'),
              color: $r('app.color.white')
            })
          Column() {
            Row() {
              Text(this.goodsInfo?.lecturers[0]?.lecturerName)
                .width(Constants.FULL_PARENT)
                .layoutWeight(1)
                .fontColor($r('app.color.color_333333'))
                .fontSize(lpx2fp(28))
                .fontWeight(FontWeight.Bold)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Image($r('app.media.ic_course_detail_right'))
                .width($r('app.string.lpx_20'))
                .height($r('app.string.lpx_20'))
            }
            .width(Constants.FULL_PARENT)

            Blank()

            Text(GoodsShowUtil.getFirstLecturerLabel(this.goodsInfo.lecturers))
              .width(Constants.FULL_PARENT)
              .fontColor($r('app.color.color_666666'))
              .fontSize(lpx2fp(24))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .height($r('app.string.lpx_80'))
          .layoutWeight(1)
          .margin({ left: $r('app.string.lpx_20') })
        }
        .width(Constants.FULL_PARENT)
        .margin({ top: $r('app.string.lpx_24') })
        .onClick(() => {
          App.get().pushUrl({
            url: RouterPath.TEACHER_DETAIL_PAGE,
            params: {
              data: this.goodsInfo?.lecturers?.[0]?.lecturerId
            }
          })
        })
      } else {
        List() {
          ForEach(this.goodsInfo?.lecturers, (item: LecturerInfo) => {
            ListItem() {
              Row() {
                Image(item?.headUrl || $r('app.media.ic_avatar_place_holder'))
                  .width($r('app.string.lpx_80'))
                  .height($r('app.string.lpx_80'))
                  .borderRadius($r('app.string.lpx_40'))
                Column() {
                  Row() {
                    Text(item?.lecturerName)
                      .width(Constants.FULL_PARENT)
                      .layoutWeight(1)
                      .fontColor($r('app.color.color_333333'))
                      .fontSize(lpx2fp(32))
                      .fontWeight(FontWeight.Bold)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Image($r('app.media.ic_course_detail_right'))
                      .width($r('app.string.lpx_20'))
                      .height($r('app.string.lpx_20'))
                  }

                  Blank()

                  Text(item.lecturerLabel)
                    .width(Constants.FULL_PARENT)
                    .fontColor($r('app.color.color_999999'))
                    .fontSize(lpx2fp(24))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .height($r('app.string.lpx_80'))
                .layoutWeight(1)
                .margin({ left: $r('app.string.lpx_16') })
              }
              .border({
                width: $r('app.string.lpx_2'),
                radius: $r('app.string.lpx_8'),
                color: $r('app.color.color_F5F5F5')
              })
              .padding($r('app.string.lpx_16'))
            }
            .width($r('app.string.lpx_320'))
            .margin({ right: $r('app.string.lpx_16') })
            .onClick(() => {
              App.get().pushUrl({
                url: RouterPath.TEACHER_DETAIL_PAGE,
                params: {
                  data: item?.lecturerId
                }
              })
            })
          })
        }
        .width(Constants.FULL_PARENT)
        .scrollBar(BarState.Off)
        .margin({ top: $r('app.string.lpx_24') })
        .listDirection(Axis.Horizontal)
      }
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
      .padding({ left: $r('app.string.lpx_10'), right: $r('app.string.lpx_10') })
      .margin({ left: $r('app.string.lpx_22') })
      .visibility(Visibility.None)

      Text('立即抢购')
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
        .onClick(() => {
          this.handleBuyPlayClick()
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

  private sendAllRequest() {
    this.sendOnlineCourseDetailRequest()
  }

  private sendOnlineCourseDetailRequest() {
    CourseVM.sendOnlineCourseDetailRequest(this.loginData?.token ?? '', this.goodsId)
      .then((value: GoodsInfo) => {
        // 初始化数据
        this.goodsInfo = value
        this.tenantId = this.goodsInfo.tenantVO?.tenantId ?? 0
        this.tryPlayResourceList.push(...CourseTryPlayUtil.getQualifiedVideoResources(this.goodsInfo))
        this.sendPlayLastProgressRequest()
        this.sendCourseDetailRecommendRequest()
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  private sendPlayLastProgressRequest() {
    if (!this.loginData) {
      this.initPlayResource()
    } else {
      CourseVM.getPlayLastProgressRequest(
        this.loginData?.token ?? '',
        this.tenantId,
        this.goodsId,
        this.goodsInfo?.subOrderId ?? 0
      )
        .then((value: VideoProgressInfo) => {
          this.historyPlayProgressInfo = value
        })
        .catch((err: string | Resource) => {
          Logger.info(this.tag, `getPlayLastProgressRequest err ${err as string}`)
        })
        .finally(() => {
          this.initPlayResource()
        })
    }
  }

  private sendPlayTryListRequest() {
    let cGoodsId = ''
    let goodsId = ''
    // 4-大专栏
    if (this.goodsInfo?.goodsType == GoodsType.SpecialColumn && this.goodsInfo.columnParentVos) {
      for (let item of this.goodsInfo.columnParentVos) {
        item.columnVos?.forEach((obj) => {
          if (
            obj.materialId == this.currentPlayResource?.materialId && obj.goodsId == this.currentPlayResource?.goodsId
          ) {
            cGoodsId = item.goodsId ?? ''
            goodsId = obj.goodsId ?? ''
          }
        })
      }
    } else {
      cGoodsId = this.goodsInfo?.goodsId ?? ''
      goodsId = this.currentPlayResource?.goodsId ?? ''
    }
    let materialId = this.currentPlayResource?.materialId ?? ''
    Logger.info(this.tag, `currentPlayResource = ${JSON.stringify(this.currentPlayResource)}`)
    Logger.info(this.tag, `token = ${this.loginData?.token}`)
    Logger.info(this.tag, `tenantId = ${this.tenantId}`)
    Logger.info(this.tag, `cGoodsId = ${cGoodsId}`)
    Logger.info(this.tag, `goodsId = ${goodsId}`)
    Logger.info(this.tag, `materialId = ${materialId}`)
    CourseVM.sendPlayTryListRequest(
      this.loginData?.token ?? '',
      this.tenantId.toString(),
      cGoodsId,
      goodsId,
      materialId
    )
      .then((value: PlayInfo[]) => {
        this.playInfoList = value
        let playTitle = this.currentPlayResource?.contentName ?? ''
        storage.setOrCreate(LocalStorageConstants.PLAY_TITLE, playTitle ?? '');
        this.playUrl = this.playInfoList?.[CommonNumbers.Zero]?.playURL ?? ''
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  private sendCourseDetailRecommendRequest() {
    CourseVM.sendCourseDetailRecommendRequest(this.tenantId, this.goodsId)
      .then((value: GoodsInfo[]) => {
        this.recommendGoodsInfos = value
      })
      .catch((err: string | Resource) => {
        ToastUtils.show(err)
      })
  }

  private sendUpdatePlayProgressRequest(parm: UpdateVideoProgressParm) {
    CourseVM.updatePlayProgressRequest(this.loginData?.token ?? '', this.tenantId, parm)
      .then(() => {
        Logger.info(this.tag, `updatePlayProgressRequest success`)
      })
      .catch((err: string | Resource) => {
        Logger.error(this.tag, `updatePlayProgressRequest err = ${err.toString()}`)
      })
  }

  private handlePlayListClick(item: ColumnInfo, index: number) {
    Logger.info(this.tag, `ColumnInfo = ${JSON.stringify(item)}`)
    if (item.fragmentTrialFlag == VideoTrialStatus.TrialEnabled) {
      this.currentPlayResource = item
      this.showBuyPlay = false
      this.sendPlayTryListRequest()
    } else {
      this.showBuyPlay = true
      this.playUrl = ''
    }
  }

  private handleBuyPlayClick() {
    PayOrderActionUtil.payOrder(PayOrderUtil.getOnlineOrderDetailData(BuySource.CourseDetail, this.goodsInfo))
  }

  private initPlayResource() {
    Logger.info(this.tag, `materialId = ${this.materialId}, cGoodsId = ${this.cGoodsId}`)
    // 指定播放资源 > 历史观看记录 > 默认播放
    if (this.materialId && this.cGoodsId) {
      // 根据传入的 materialId、cGoodsId 获取视频资源
      let columnInfo = CourseTryPlayUtil.getPlayResource(this.goodsInfo, this.materialId, this.cGoodsId)
      // 判断是否可以免费观看
      if (columnInfo?.fragmentTrialFlag != VideoTrialStatus.TrialEnabled) {
        // 设置为默认播放资源
        this.currentPlayResource = CourseTryPlayUtil.getDefaultPlayResource(this.goodsInfo)
      } else {
        // 设置为指定资源播放
        this.currentPlayResource = columnInfo
      }
    } else {
      // 历史观看记录
      if (this.historyPlayProgressInfo) {
        let columnInfo =
          CourseTryPlayUtil.getHistoryPlayResource(this.goodsInfo, this.historyPlayProgressInfo.materialId)
        if (columnInfo) {
          // 设置为历史播放资源
          this.currentPlayResource = columnInfo
          // 设置历史播放位置
          this.historyPlayPosition = this.historyPlayProgressInfo?.lastPosition ?? 0
        } else {
          // 设置为默认播放资源
          this.currentPlayResource = CourseTryPlayUtil.getDefaultPlayResource(this.goodsInfo)
        }
      } else {
        // 设置为默认播放资源
        this.currentPlayResource = CourseTryPlayUtil.getDefaultPlayResource(this.goodsInfo)
      }
    }
    this.sendPlayTryListRequest()
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
    if (this.currentPlayResource) {
      let index = CourseTryPlayUtil.getVideoResourcesIndex(this.tryPlayResourceList, this.currentPlayResource) ?? 0
      let count = this.tryPlayResourceList?.length ?? 0
      Logger.info(this.tag, `index = ${index}, count = ${count}`)
      if (index >= (count - 1)) {
        storage.setOrCreate(LocalStorageConstants.PLAY_IS_TRY_END, true);
      } else if (this.tryPlayResourceList) {
        this.currentPlayResource = this.tryPlayResourceList[(index + 1)]
        this.sendPlayTryListRequest()
      }
    }
  }

  private startTaskPlayProgressReport() {
    clearTimeout(this.playProgressReportIntervalId)
    this.playProgressReportIntervalId = setInterval(() => {
      if (this.playStatus == AliPlayerState.Playing) {
        /*let parm = new UpdateVideoProgressParm()
        let getCurrentPosition = AliVideoController.getPlayer(this.aliPlayerId)?.getCurrentPosition() ?? 0
        parm.currentPosition = getCurrentPosition / 1000
        parm.goodsId = this.goodsId ?? ''
        parm.materialId = this.currentPlayResource?.materialId ?? ''
        parm.subOrderId = this.goodsInfo?.subOrderId ?? 0
        this.sendUpdatePlayProgressRequest(parm)*/
      }
    }, 5000)
  }

  private changeOrientation() {
    window.getLastWindow(getContext(this)).then((wind) => {
      wind.setPreferredOrientation(
        this.isFullScreen ? window.Orientation.LANDSCAPE : window.Orientation.PORTRAIT
      )
      wind.setWindowSystemBarEnable(this.isFullScreen ? [] : ['status'])
    })
  }
}
