import router from '@ohos.router';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { TeacherDetailData } from 'lib_core_model/src/main/ets/data/TeacherDetailData';
import { ToolBar } from '../../view/widget/ToolBar';
import { TeacherOnlineTabContent } from './TeacherOnlineTabContent';
import { TeacherOfflineTabContent } from './TeacherOfflineTabContent';
import RefreshConfig from 'lib_common/src/main/ets/components/refresh/RefreshConfig';
import TeacherVM from 'lib_core_model/src/main/ets/vm/TeacherVM';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@Entry
@Component
struct TeacherDetailPage {
  lecturerId: string = (router.getParams() as object)?.[Constants.DATA];
  tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID];

  @State refreshConfig: RefreshConfig<object> = new RefreshConfig<object>()

  @State data: TeacherDetailData | null = null

  @State tabCheckPosition: number = 0
  private tabTitles = ['线上课程','线下课程','个人简介']

  private headerHeight:number = vp2px(215)//548 - 100 = vp_448
  private toolBarHeight:number = vp2px(48)//vp_100
  private lastMoveX = 0;
  private lastMoveY = 0;
  private orientation = 0; //滑动方向1 水平；2，垂直
  // 滑动的y偏移量
  @State headerYOffset: number = this.headerHeight
  @State collapsingStatus: number = 0//0：展开（默认） 1：中间状态；2，收起
  @State collapsingPercent: number = 0//折叠百分比（0-1）
  @State isPullDown: boolean = false

  sendTeacherDetailRequest () {
    TeacherVM.sendTeacherDetailRequest(this.tenantId,this.lecturerId ?? '').then((data: TeacherDetailData) => {
      this.data = data
      this.refreshConfig.setData([],true)
    }).catch((err: string | Resource) => {
      this.refreshConfig.setData([],false)
      ToastUtils.show(err)
    });
  }

  aboutToAppear() {
    this.sendTeacherDetailRequest()
  }

  build() {
    Stack() {
      this.toolBarHeader()
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
    .alignContent(Alignment.Top)
    .onTouch((event) => {
      this.handleTouchEvent(event)
    })
  }

  @Builder toolBarHeader() {
    Stack() {
      Image($r('app.media.img_teacher_detail_header'))
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
      Column() {
        ToolBar({
          title: '老师简介',
          titleBackgroundColor: $r('app.color.transparent'),
          // titleActionIcon: $r('app.media.ic_black_share'),
          shadowColor: $r('app.color.transparent'),
          // titleActionClick:() => {
          //   ToastUtils.show('you click title action icon')
          // }
        })
        this.contentHeader()
      }
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .height(this.headerHeight)
    .alignContent(Alignment.Top)
  }

  @Builder content() {
    Column() {
        this.tabContent()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .offset({ y: `${this.headerYOffset}px`})
    .padding({bottom: `${this.headerYOffset}px`})
  }

  @Builder contentHeader() {
    Row(){
      Column(){
        Text(this.data?.lecturerName ?? '')
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(68))
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Line()
          .width($r('app.string.lpx_68'))
          .height($r('app.string.lpx_8'))
          .margin({ top: $r('app.string.lpx_12'),left: $r('app.string.lpx_10') })
          .backgroundColor($r('app.color.color_333333'))
          .borderRadius($r('app.string.lpx_4'))
        Text(this.data?.lecturerLabel || '')
          .width(Constants.FULL_PARENT)
          .margin({ top: $r('app.string.lpx_28'),left: $r('app.string.lpx_10') })
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.data?.briefIntroduction || '')
          .width(Constants.FULL_PARENT)
          .margin({ top: $r('app.string.lpx_20'),left: $r('app.string.lpx_10') })
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .textAlign(TextAlign.Start)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Image(this.data?.headUrl || $r('app.media.ic_avatar_place_holder'))
        .width($r('app.string.lpx_300'))
        .height($r('app.string.lpx_300'))
        .border({
          radius: $r('app.string.lpx_150'),
          color: $r('app.color.white')
        })
    }
    .width(Constants.FULL_PARENT)
    .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder tabContent() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {
        TeacherOnlineTabContent({
          tenantId: this.tenantId,
          lecturerId: this.lecturerId
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[0],0))
      .align(Alignment.Top)

      TabContent() {
        TeacherOfflineTabContent({
          tenantId: this.tenantId,
          lecturerId: this.lecturerId
        })
      }
      .tabBar(this.TabBuilder(this.tabTitles[1],1))
      .align(Alignment.Top)

      TabContent() {
        RichText(String(this.data?.content))
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .backgroundColor($r('app.color.color_F9F9F9'))
      }
      .tabBar(this.TabBuilder(this.tabTitles[2],2))
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
    .margin({top: $r('app.string.lpx_56')})
    .padding({top: $r('app.string.lpx_10')})
    .backgroundColor($r('app.color.white'))
    .borderRadius({
      topLeft: $r('app.string.lpx_60'),
      topRight: $r('app.string.lpx_60')
    })
  }

  @Builder TabBuilder(title: string, index: number) {
    Row(){
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
      top:$r('app.string.lpx_10'),
      bottom: $r('app.string.lpx_10'),
    })
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
}
