import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { ColumnInfo } from 'lib_core_model/src/main/ets/data/ColumnInfo'
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo'
import { CourseCouponData } from 'lib_core_model/src/main/ets/data/CourseCouponData'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { LecturerInfo } from 'lib_core_model/src/main/ets/data/LecturerInfo'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import CourseAssureDialog from '../../../view/dialog/CourseAssureDialog'
import CourseCouponSelectDialog from '../../../view/dialog/CourseCouponSelectDialog'
import { CoursePriceTitleStyleDisplayComp } from '../../common/CoursePriceDisplayComp'

@Component
export default struct CourseDetailProduct {
  tag: string = 'CourseDetailProduct'
  @Prop tenantId: number | null = null
  @Prop loginData: LoginData | null = null
  @Prop @Watch('logger') goodsInfo: GoodsInfo | null = null
  @Consume(Constants.GOODS_DETAIL_COUPON_TIP_DATA_KEY) couponList: Array<CouponInfo>
  @Consume(Constants.GOODS_DETAIL_COUPON_DATA_KEY) courseCouponData: CourseCouponData
  courseAssureDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseAssureDialog({ onlineFlag: this.getOnlineFlag(), postSaleType: this.gePostSaleType() }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })
  courseCouponSelectDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseCouponSelectDialog({
      coupons: this.getCouponList(),
      tenantId: this.tenantId,
      loginData: this.loginData
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })

  logger() {
    Logger.info(this.tag, `GoodsInfo = ${JSON.stringify(this.goodsInfo)}`)
  }

  getOnlineFlag(): number {
    return this.goodsInfo?.onlineFlag ?? 0
  }

  gePostSaleType(): number {
    return this.goodsInfo?.postSaleType ?? 0
  }

  getCouponList(): Array<CouponInfo> {
    Logger.info(this.tag, `getCouponList = ${JSON.stringify(this.courseCouponData.notClaimNotUseList)}`)
    return this.courseCouponData.notClaimNotUseList ?? []
  }

  build() {
    Column() {
      Row() {
        CoursePriceTitleStyleDisplayComp({
          goodsInfo: this.goodsInfo
        })
      }
      .width(Constants.FULL_PARENT)
      .justifyContent(FlexAlign.Start)
      .padding({
        left: $r('app.string.lpx_16'),
        right: $r('app.string.lpx_16')
      })

      Text(this.goodsInfo?.contentName)
        .width(Constants.FULL_PARENT)
        .margin({ top: $r('app.string.lpx_24') })
        .padding({ left: $r('app.string.lpx_16'), right: $r('app.string.lpx_16') })
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Text('保障')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_10') })
        Text(GoodsShowUtil.getGoodsAssureTxt(this.goodsInfo?.onlineFlag ?? 0, this.goodsInfo?.postSaleType ?? 0))
          .layoutWeight(1)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ left: $r('app.string.lpx_20') })

        Image($r('app.media.ic_course_detail_right'))
          .width($r('app.string.lpx_20'))
          .height($r('app.string.lpx_20'))
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_100'))
      .backgroundColor($r('app.color.white'))
      .borderRadius({
        topLeft: $r('app.string.lpx_20'),
        topRight: $r('app.string.lpx_20'),
        bottomLeft: this.couponList?.length > 0 ? 0 : $r('app.string.lpx_20'),
        bottomRight: this.couponList?.length > 0 ? 0 : $r('app.string.lpx_20')
      })
      .margin({ top: $r('app.string.lpx_28') })
      .padding({
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })
      .onClick(() => {
        this.courseAssureDlgCtl.open()
      })

      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_2'))
        .backgroundColor($r('app.color.color_FAF5F5'))
        .visibility(this.couponList?.length > 0 ? Visibility.Visible : Visibility.None)

      Row() {
        Text('优惠')
          .fontColor($r('app.color.color_666666'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_10') })

        List() {
          ForEach(this.couponList, (item: CouponInfo) => {
            ListItem() {
              Text() {
                Span(GoodsShowUtil.getCouponStart(item))
                  .fontColor($r('app.color.color_FEFAFA'))
                  .fontSize(lpx2fp(20))
                Span(GoodsShowUtil.getCouponValue(item))
                  .fontColor($r('app.color.color_FEFAFA'))
                  .fontSize(lpx2fp(24))
                  .fontWeight(FontWeight.Bold)
                Span(GoodsShowUtil.getCouponUnit(item))
                  .fontColor($r('app.color.color_FEFAFA'))
                  .fontSize(lpx2fp(20))
                Span(GoodsShowUtil.getCouponEnd(item))
                  .fontColor($r('app.color.color_FEFAFA'))
                  .fontSize(lpx2fp(24))
                  .fontWeight(FontWeight.Bold)
                  .visibility(GoodsShowUtil.getCouponEnd(item) ? Visibility.Visible : Visibility.None)
              }
              .padding({
                top: $r('app.string.lpx_6'),
                bottom: $r('app.string.lpx_6'),
                left: $r('app.string.lpx_8'),
                right: $r('app.string.lpx_8'),
              })
              .borderRadius($r('app.string.lpx_8'))
              .linearGradient({
                angle: 90,
                colors: [
                  [$r('app.color.color_FC6D38'), 0.0],
                  [$r('app.color.color_F12E29'), 1.0]
                ]
              })
            }
            .height(Constants.FULL_PARENT)
            .margin({ right: $r('app.string.lpx_16') })
          })
        }
        .layoutWeight(1)
        .height($r('app.string.lpx_100'))
        .listDirection(Axis.Horizontal)
        .margin({ left: $r('app.string.lpx_20') })

        Image($r('app.media.ic_course_detail_right'))
          .width($r('app.string.lpx_20'))
          .height($r('app.string.lpx_20'))
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_100'))
      .backgroundColor($r('app.color.white'))
      .borderRadius({
        topLeft: 0,
        topRight: 0,
        bottomLeft: $r('app.string.lpx_20'),
        bottomRight: $r('app.string.lpx_20')
      })
      .padding({
        left: $r('app.string.lpx_20'),
        right: $r('app.string.lpx_20')
      })
      .visibility(this.couponList?.length > 0 ? Visibility.Visible : Visibility.None)
      .onClick(() => {
        this.courseCouponSelectDlgCtl.open()
      })

      this.teacher()
      this.courseOutline()
    }
    .width(Constants.FULL_PARENT)
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
          Image(this.goodsInfo?.lecturers?.[0]?.headUrl || $r('app.media.ic_avatar_place_holder'))
            .width($r('app.string.lpx_80'))
            .height($r('app.string.lpx_80'))
            .border({
              radius: $r('app.string.lpx_40'),
              width: $r('app.string.lpx_2'),
              color: $r('app.color.white')
            })
          Column() {
            Row() {
              Text(this.goodsInfo?.lecturers?.[0]?.lecturerName)
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
    .margin({ top: $r('app.string.lpx_28'), })
    .padding({
      top: $r('app.string.lpx_28'),
      bottom: $r('app.string.lpx_28'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }

  @Builder
  courseOutline() {
    Column() {
      Text('课程大纲')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
      Text(`购买后365天内有效，已更新${this.goodsInfo?.lesson ?? 0}/${this.goodsInfo?.classHour ?? 0}课时`)
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))
        .margin({ top: $r('app.string.lpx_28') })
      Column() {
        ForEach(GoodsShowUtil.getOutlineByCount(this.goodsInfo, 3), (item: ColumnInfo, index: number) => {
          Row() {
            Text(`${index + 1}`)
              .fontColor($r('app.color.color_666565'))
              .fontSize(lpx2fp(28))
            Column() {
              Row() {
                Text(item?.contentName)
                  .layoutWeight(1)
                  .fontColor($r('app.color.color_333333'))
                  .fontSize(lpx2fp(28))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                if (item?.fragmentTrialFlag === 0 && item?.goodsType === 2) {
                  Image($r('app.media.ic_course_try_play'))
                    .width($r('app.string.lpx_24'))
                    .height($r('app.string.lpx_24'))
                    .margin({ left: $r('app.string.lpx_14'), right: $r('app.string.lpx_4') })
                  Text('免费试看')
                    .fontColor($r('app.color.color_FF1F00'))
                    .fontSize(lpx2fp(24))
                }
              }
              .width(Constants.FULL_PARENT)
              .justifyContent(FlexAlign.Start)

              Text(GoodsShowUtil.getOutlineTypeDuration(item, this.goodsInfo?.onlineFlag ?? 0))
                .fontColor($r('app.color.color_666666'))
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
            // 已购买直接进入学习
            if (this.goodsInfo?.orderNo) {
              App.get().pushUrl({
                url: RouterPath.ONLINE_COURSE_STUDY_PLAY_PAGE,
                params: {
                  data: this.goodsInfo?.goodsId
                }
              })
              return
            }
            // 片段试看(0开启，1关闭)，goods_type=2生效
            let fragmentTrialFlag = item.fragmentTrialFlag ?? 0
            let goodsType = item.goodsType ?? 0
            if (fragmentTrialFlag == 0 && goodsType == 2) {
              App.get().pushUrl({
                url: RouterPath.TRY_PLAY_PAGE,
                params: {
                  data: this.goodsInfo?.goodsId,
                  materialId: item.materialId,
                  cGoodsId: item.goodsId
                }
              })
            } else {
              ToastUtils.show('购买后观看完整课程')
            }
          })
        })
        if ((this.goodsInfo?.lesson ?? 0) > 3) {
          Row() {
            Text(`查看全部${this.goodsInfo?.classHour ?? 0}课时`)
              .fontColor($r('app.color.color_666666'))
              .fontSize(lpx2fp(28))
            Image($r('app.media.ic_course_detail_right'))
              .width($r('app.string.lpx_20'))
              .height($r('app.string.lpx_20'))
              .margin($r('app.string.lpx_12'))
          }
          .width(Constants.FULL_PARENT)
          .height($r('app.string.lpx_92'))
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.TRY_PLAY_PAGE,
              params: {
                data: this.goodsInfo?.goodsId
              }
            })
          })
        }
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
    .margin({ top: $r('app.string.lpx_28') })
    .padding({
      top: $r('app.string.lpx_28'),
      bottom: $r('app.string.lpx_28'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_20')
    })
  }
}
