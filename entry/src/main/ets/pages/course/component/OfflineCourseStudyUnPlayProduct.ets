import { LengthMetrics } from '@kit.ArkUI'
import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil'
import App from 'lib_core_model/src/main/ets/App'
import { CouponInfo } from 'lib_core_model/src/main/ets/data/CouponInfo'
import { CourseCouponData } from 'lib_core_model/src/main/ets/data/CourseCouponData'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { GoodsSpecData } from 'lib_core_model/src/main/ets/data/GoodsSpecData'
import { LecturerInfo } from 'lib_core_model/src/main/ets/data/LecturerInfo'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import Logger from 'lib_core_model/src/main/ets/util/Logger'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import CourseAssureDialog from '../../../view/dialog/CourseAssureDialog'
import CourseCouponSelectDialog from '../../../view/dialog/CourseCouponSelectDialog'
import CourseProductConfigDialog from '../../../view/dialog/CourseProductConfigDialog'

@Component
export default struct OfflineCourseStudyUnPlayProduct {
  tag: string = 'OfflineCourseStudyUnPlayProduct'
  @Prop @Watch('logger') goodsInfo: GoodsInfo | null = null
  @Consume(Constants.GOODS_DETAIL_COUPON_TIP_DATA_KEY) couponInfoList: Array<CouponInfo>
  @Consume(Constants.GOODS_DETAIL_COUPON_DATA_KEY) courseCouponData: CourseCouponData
  @Consume(Constants.GOODS_SPEC_DATA_KEY) goodsSpecData: GoodsSpecData
  courseAssureDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseAssureDialog({
      onlineFlag: this.getOnlineFlag(),
      postSaleType: this.gePostSaleType()
    }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })
  courseCouponSelectDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseCouponSelectDialog({
      coupons: this.getCouponList()
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })
  courseProductConfigDlgCtl: CustomDialogController = new CustomDialogController({
    builder: CourseProductConfigDialog({
      goodsInfo: this.goodsInfo
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  })

  logger() {
    Logger.info(this.tag, `goodsInfo = ${JSON.stringify(this.goodsInfo)}`)
  }

  getOnlineFlag(): number {
    return this.goodsInfo?.onlineFlag ?? 0
  }

  gePostSaleType(): number {
    return this.goodsInfo?.postSaleType ?? 0
  }

  getCouponList(): Array<CouponInfo> {
    return this.courseCouponData.notClaimNotUseList ?? []
  }

  getGoodsSpecData() {
    return this.goodsSpecData
  }

  getGoodsContent() {
    return this.goodsInfo?.content ?? ''
  }

  build() {
    Column() {
      this.title()
      this.tip()
      this.teacher()
      this.productConfig()
      this.loadHtml()
    }
    .width(Constants.FULL_PARENT)
  }

  @Builder
  title() {
    Row() {
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
      .layoutWeight(1)
      .maxLines(2)
      .lineSpacing(LengthMetrics.lpx(10))
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .margin({
        left: $r('app.string.lpx_32'),
        right: $r('app.string.lpx_70')
      })

      Column() {
        Image($r('app.media.ic_course_customer_service'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))
          .objectFit(ImageFit.Contain)
        Text('客服')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(20))
          .margin({ top: $r('app.string.lpx_5') })
      }
      .margin({
        right: $r('app.string.lpx_32')
      })
      .visibility(Visibility.None)
    }
    .width(Constants.FULL_PARENT)
  }

  @Builder
  tip() {
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
      bottomLeft: this.couponInfoList?.length > 0 ? 0 : $r('app.string.lpx_20'),
      bottomRight: this.couponInfoList?.length > 0 ? 0 : $r('app.string.lpx_20')
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
      .visibility(this.couponInfoList?.length > 0 ? Visibility.Visible : Visibility.None)

    Row() {
      Text('优惠')
        .fontColor($r('app.color.color_666666'))
        .fontSize(lpx2fp(28))
        .margin({ left: $r('app.string.lpx_10') })

      List() {
        ForEach(this.couponInfoList, (item: CouponInfo) => {
          ListItem() {
            Text() {
              Span(GoodsShowUtil.getCouponStart(item))
                .fontColor($r('app.color.color_FF1F00'))
                .fontSize(lpx2fp(24))
              Span(GoodsShowUtil.getCouponValue(item))
                .fontColor($r('app.color.color_FF1F00'))
                .fontSize(lpx2fp(28))
                .fontWeight(FontWeight.Bold)
              Span(GoodsShowUtil.getCouponUnit(item))
                .fontColor($r('app.color.color_FF1F00'))
                .fontSize(lpx2fp(24))
              Span(GoodsShowUtil.getCouponEnd(item))
                .fontColor($r('app.color.color_FF1F00'))
                .fontSize(lpx2fp(28))
                .fontWeight(FontWeight.Bold)
                .visibility(GoodsShowUtil.getCouponEnd(item) ? Visibility.Visible : Visibility.None)
            }
            .padding({
              top: $r('app.string.lpx_4'),
              bottom: $r('app.string.lpx_4'),
              left: $r('app.string.lpx_8'),
              right: $r('app.string.lpx_8'),
            })
            .borderRadius($r('app.string.lpx_8'))
            .linearGradient({
              angle: 90,
              colors: [
                [$r('app.color.color_FFF5E6'), 0.0],
                [$r('app.color.color_FFE1DB'), 0.7],
                [$r('app.color.color_FFE1DB'), 1.0]
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
    .visibility(this.couponInfoList?.length > 0 ? Visibility.Visible : Visibility.None)
    .onClick(() => {
      this.courseCouponSelectDlgCtl.open()
    })
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
  productConfig() {
    Row() {
      Text('选择规格')
        .layoutWeight(1)
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)

      Text(`共${this.goodsInfo?.specVos?.length ?? 0}种规格可选`)
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({ right: $r('app.string.lpx_10') })

      Image($r('app.media.ic_course_detail_right'))
        .width($r('app.string.lpx_20'))
        .height($r('app.string.lpx_20'))
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
    .onClick(() => {
      this.courseProductConfigDlgCtl.open()
    })
  }

  @Builder
  loadHtml() {
    Text(this.getGoodsContent())
      .margin({ bottom: $r('app.string.lpx_40'), top: $r('app.string.lpx_40') })
  }
}
