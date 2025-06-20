import router from '@ohos.router';
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import { CommentNumData } from 'lib_core_model/src/main/ets/data/CommentNumData';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import CommentVM from 'lib_core_model/src/main/ets/vm/CommentVM';
import { ToolBar } from '../../view/widget/ToolBar';
import { CourseCommentTabContent } from './component/CourseCommentTabContent';

/**
 * 课程评价
 */
@Entry
@Component
struct CourseCommentPage {
  goodsId: string = (router.getParams() as object)?.[Constants.DATA];
  tenantId: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  @State loginData: LoginData | null = null
  @State tabCheckPosition: number = 0
  @State tabTitles: Array<string> = ['全部 ', '好评 ', '中评 ', '差评 ']
  @State commentNumData: CommentNumData | null = null

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendCommendNumRequest()
    })
  }

  sendCommendNumRequest() {
    CommentVM.sendCommendNumRequest(this.tenantId, this.loginData?.token ?? '', this.goodsId)
      .then((value: CommentNumData) => {
        this.commentNumData = value

        let evaluateNum = GoodsShowUtil.getGoodsPopularityTxt(value?.evaluateNum ?? 0)
        let goodEvaluateNum = GoodsShowUtil.getGoodsPopularityTxt(value?.goodEvaluateNum ?? 0)
        let medEvaluateNum = GoodsShowUtil.getGoodsPopularityTxt(value?.medEvaluateNum ?? 0)
        let negEvaluateNum = GoodsShowUtil.getGoodsPopularityTxt(value?.negEvaluateNum ?? 0)
        this.tabTitles[0] = `${this.tabTitles[0]}${evaluateNum}`
        this.tabTitles[1] = `${this.tabTitles[1]}${goodEvaluateNum}`
        this.tabTitles[2] = `${this.tabTitles[2]}${medEvaluateNum}`
        this.tabTitles[3] = `${this.tabTitles[3]}${negEvaluateNum}`
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  build() {
    Column() {
      ToolBar({ title: '课程评价' })
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  content() {
    Tabs({ barPosition: BarPosition.Start }) {
      ForEach(this.tabTitles, (item: string, index: number) => {
        TabContent() {
          CourseCommentTabContent({
            tenantId: this.tenantId,
            goodsId: this.goodsId,
            level: index
          })
        }
        .tabBar(this.TabBuilder(index))
        .align(Alignment.Top)
      }, (item: string) => item)
    }
    .vertical(false)
    .barMode(BarMode.Fixed)
    .barWidth(Constants.FULL_PARENT)
    .barHeight($r('app.string.lpx_78'))
    .backgroundColor($r('app.color.white'))
    .onChange((index: number) => {
      this.tabCheckPosition = index
    })
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
  }

  @Builder
  TabBuilder(index: number) {
    Text(this.tabTitles[index])
      .height(Constants.FULL_PARENT)
      .fontColor(this.tabCheckPosition === index ? $r('app.color.color_EB4F3A') : $r('app.color.color_666666'))
      .fontSize(lpx2fp(28))
      .fontWeight(this.tabCheckPosition === index ? FontWeight.Bold : FontWeight.Normal)
      .textAlign(TextAlign.Center)
      .padding($r('app.string.lpx_10'))
  }
}
