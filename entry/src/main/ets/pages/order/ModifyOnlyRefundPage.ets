import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { router } from '@kit.ArkUI';
import { AfterSaleDetailData } from 'lib_core_model/src/main/ets/data/AfterSaleDetailData';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { common } from '@kit.AbilityKit';
import UploadVM from 'lib_core_model/src/main/ets/vm/UploadVM';
import { UploadUrlInfo } from 'lib_core_model/src/main/ets/module/UploadUrlInfo';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import AfterSaleVM from 'lib_core_model/src/main/ets/vm/AfterSaleVM';
import { AfterSaleParm } from 'lib_core_model/src/main/ets/data/AfterSaleParm';
import AfterSaleUtil from '../../util/AfterSaleUtil';
import App from 'lib_core_model/src/main/ets/App';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { ToolBar } from '../../view/widget/ToolBar';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import PictureSelectUtil from 'lib_common/src/main/ets/util/PictureSelectUtil';
import { ModifyAfterSaleParm } from 'lib_core_model/src/main/ets/data/ModifyAfterSaleParm';
import PermissionHelper from 'lib_common/src/main/ets/util/PermissionHelper';

@Entry
@Component
struct ModifyOnlyRefundPage {
  data?: AfterSaleDetailData = (router.getParams() as object)?.[Constants.DATA];
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID];

  @State loginData: LoginData | null = null
  @State reasonList: Array<string> = []
  @State selectReason: string = ''
  @State describe: string = ''
  @State imageUrlList: Array<string> = []
  @State uploadPath: string[] = ['']

  @State isExpanded: boolean = false

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sendUploadImgMultiRequest () {
    this.loadingDialogCtrl.open()
    const context = getContext(this) as common.UIAbilityContext;
    UploadVM.sendUploadImgMultiRequest(context,this.loginData?.token ?? '',this.uploadPath).then((value: UploadUrlInfo) => {
      this.loadingDialogCtrl.close()
      this.imageUrlList = this.imageUrlList.concat(value.urls ?? [])
      ToastUtils.show('上传成功')
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendRefundReasonRequest () {
    AfterSaleVM.sendRefundReasonRequest(this.tenantId ?? 0,this.loginData?.token ?? '')
      .then((value: string[]) => {
        this.reasonList = value
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendModifyAfterSaleRequest () {
    if (!this.selectReason) {
      ToastUtils.show("请选择退款原因")
      return
    }

    this.loadingDialogCtrl.open()
    const body = new ModifyAfterSaleParm()
    body.afterSaleMode = 1
    body.afterSaleNo = this.data?.afterSaleNo
    body.appliedFee = this.data?.appliedFee ?? 0
    body.supplement = this.describe
    body.voucherUrls = AfterSaleUtil.getVoucherUrls(this.imageUrlList)
    body.reason = this.selectReason

    AfterSaleVM.sendModifyAfterSaleRequest(this.tenantId ?? 0,this.loginData?.token ?? '',body)
      .then((value: object) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show("退款申请修改成功")
        App.get().back()
      }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  refreshData () {
    this.sendRefundReasonRequest()
  }

  aboutToAppear() {
    this.selectReason = this.data?.reason ?? ''
    this.describe = this.data?.supplement ?? ''
    this.imageUrlList = this.data?.voucherUrls?.split(',') ?? []
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
  }

  build() {
    Column() {
      ToolBar({title: '仅退款'})
      this.content()
      this.bottomAction()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    List() {
      ListItem() {
        this.courseCell()
      }
      ListItem() {
        this.reasonTitleCell()
      }
      ListItem() {
        this.reasonContentCell()
      }
      ListItem() {
        this.amountCell()
      }
      ListItem() {
        this.describeCell()
      }
      ListItem() {
        this.uploadCell()
      }
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({top: $r('app.string.lpx_8')})
    .padding({left: $r('app.string.lpx_32'),right: $r('app.string.lpx_32')})
  }

  @Builder courseCell() {
    Column(){

      Row() {
        Text(this.data?.goodsMode === 1 ? '线下课' : '线上课')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
        Blank()
        Text(AfterSaleUtil.getOrderStatus(this.data?.status))
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)

      Row() {
        Image(this.data?.coverUrlExtendVo?.centre)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_180'))
          .height($r('app.string.lpx_180'))
          .borderRadius($r('app.string.lpx_8'))
          .margin({top: $r('app.string.lpx_16')})

        Column() {
          Text(this.data?.goodsName ?? '')
            .width(Constants.FULL_PARENT)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(28))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .margin({
              top: $r('app.string.lpx_6'),
              left: $r('app.string.lpx_16'),
              right: $r('app.string.lpx_16')
            })
          Blank()
          Row() {
            Blank()
            Text(`共${this.data?.goodsNum ?? 0}件`)
              .fontColor($r('app.color.color_777777'))
              .fontSize(lpx2fp(28))
              .margin({ right: $r('app.string.lpx_16') })
            Text('￥')
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(20))
              .margin({ right: $r('app.string.lpx_5') })
            Text(AmountUtil.getRoundUp((this.data?.goodsPrices ?? 0) / 100,2))
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
          }
          .width(Constants.FULL_PARENT)
        }
        .height($r('app.string.lpx_180'))
        .layoutWeight(1)
        .margin({left: $r('app.string.lpx_16')})
      }
      .width(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder reasonTitleCell() {
    Column(){
      Row() {
        Text('退款原因')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text(this.selectReason || '请选择')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
      }
      .width(Constants.FULL_PARENT)

      Line()
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_1'))
        .backgroundColor($r('app.color.color_EFEFEF'))
        .margin({top: $r('app.string.lpx_20')})
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding({
      top: $r('app.string.lpx_20'),
      left: $r('app.string.lpx_20'),
      right: $r('app.string.lpx_68')
    })
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
    .onClick(() => {
      animateTo({ duration: Constants.DURATION }, () => {
        this.isExpanded = !this.isExpanded;
      })
    })
  }

  @Builder reasonContentCell() {
    Column() {
      ForEach(this.reasonList,(reason: string) => {
        Text() {
          ImageSpan(AfterSaleUtil.getRefundReasonCheckIcon(reason,this.selectReason))
            .width($r('app.string.lpx_30'))
            .height($r('app.string.lpx_30'))
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span(`\t\t${reason}`)
            .fontColor($r('app.color.color_777777'))
            .fontSize(lpx2fp(32))
        }
        .width(Constants.FULL_PARENT)
        .maxLines(1)
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .padding({
          top: $r('app.string.lpx_10'),
          bottom: $r('app.string.lpx_10'),
          left: $r('app.string.lpx_20'),
          right: $r('app.string.lpx_20')
        })
        .onClick(() => {
          this.selectReason = reason
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({ bottom: $r('app.string.lpx_20') })
    .borderRadius({
      bottomLeft: $r('app.string.lpx_12'),
      bottomRight: $r('app.string.lpx_12')
    })
    .visibility(this.isExpanded ? Visibility.Visible : Visibility.None)
  }

  @Builder amountCell() {
    Column() {
      Row() {
        Text('申请金额')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Blank()
        Text('￥')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(20))
          .margin({ right: $r('app.string.lpx_5') })
        Text(AmountUtil.getRoundUp((this.data?.payerTotal ?? 0) / 100,2))
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      Row() {
        Text(AfterSaleUtil.getModifyOnlyRefundTip(this.data))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
        Blank()
        Text('不可修改')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_16')})
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder describeCell() {
    Column() {
      Text(){
        Span('补充描述')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Span('\t选填')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
      }
      .width(Constants.FULL_PARENT)
      .textAlign(TextAlign.Start)

      Stack(){
        TextArea({ text: this.describe,placeholder: '最多可填写200字' })
          .width(Constants.FULL_PARENT)
          .height(Constants.FULL_PARENT)
          .padding({
            top: $r('app.string.lpx_20'),
            bottom: $r('app.string.lpx_60'),
            left: $r('app.string.lpx_20'),
            right: $r('app.string.lpx_20'),
          })
          .backgroundColor($r('app.color.transparent'))
          .placeholderFont({ size: lpx2fp(28) })
          .placeholderColor($r('app.color.color_999999'))
          .maxLength(200)
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .caretColor($r('app.color.color_EB4F3A'))
          .onChange((value: string) => {
            this.describe = value
          })

        Text(`${this.describe?.length || 0}/300`)
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_777777'))
          .margin({
            bottom: $r('app.string.lpx_20'),
            right: $r('app.string.lpx_20')
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_320'))
      .backgroundColor($r('app.color.white'))
      .border({
        width: $r('app.string.lpx_2'),
        radius: $r('app.string.lpx_8'),
        color: $r('app.color.color_EFEFEF')
      })
      .alignContent(Alignment.BottomEnd)
      .margin({ top: $r('app.string.lpx_20') })
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder uploadCell() {
    Column() {
      Row() {
        Text('上传凭证')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(32))
        Text('\t选填')
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(24))
        Blank()
        Text('最多上传7张图片')
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
      }
      .width(Constants.FULL_PARENT)
      .padding($r('app.string.lpx_20'))
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_12'))

      List({space: `${$r('app.string.lpx_20')}}`}){

        ForEach(this.imageUrlList,(item: string,index: number) => {
          ListItem(){
            this.imageCell(item,index)
          }
        })

        if (this.imageUrlList.length < 7) {
          ListItem() {
            this.addCell()
          }
        }
      }
      .width(Constants.FULL_PARENT)
      .lanes(4)
    }
    .width(Constants.FULL_PARENT)
    .margin({top: $r('app.string.lpx_20')})
    .padding($r('app.string.lpx_20'))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_12'))
  }

  @Builder imageCell(imgUrl: string,index: number) {
    Stack(){
      Image(imgUrl)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_140'))
        .height($r('app.string.lpx_140'))
        .borderRadius($r('app.string.lpx_8'))
        .margin({top: $r('app.string.lpx_20'),right: $r('app.string.lpx_20')})
      Image($r('app.media.img_evaluate_image_del'))
        .width($r('app.string.lpx_36'))
        .height($r('app.string.lpx_36'))
        .onClick(() => {
          this.imageUrlList.splice(index, 1)
        })
    }
    .width($r('app.string.lpx_160'))
    .height($r('app.string.lpx_160'))
    .alignContent(Alignment.TopEnd)
  }

  @Builder addCell() {
    Stack(){
      Image($r('app.media.ic_feedback_upload'))
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
    }
    .width($r('app.string.lpx_140'))
    .height($r('app.string.lpx_140'))
    .margin({top: $r('app.string.lpx_20')})
    .onClick(() => {
      let maxCount = 7 - this.imageUrlList.length
      if (maxCount === 0) {
        ToastUtils.show("图片最多上传7个")
        return
      }
      const context = getContext(this) as common.UIAbilityContext;
      PermissionHelper.checkPermissions(context,'ohos.permission.READ_MEDIA').then((grant: boolean) => {
        if (grant) {
          //在添加上传按钮之前上传图片避免重新处理数据
          PictureSelectUtil.fileSelect(maxCount).then((value) => {
            if (value.length > 0) {
              //添加已选择的图片
              this.uploadPath = value
              //在添加上传按钮之前上传图片避免重新处理数据
              this.sendUploadImgMultiRequest()
            }
          })
        } else {
          PermissionHelper.openPermissionsInSystemSettings(context)
        }
      })
    })
  }

  @Builder bottomAction() {
    Text('提交')
      .width('90%')
      .height($r('app.string.lpx_88'))
      .fontSize(lpx2fp(32))
      .fontColor($r('app.color.white'))
      .textAlign(TextAlign.Center)
      .backgroundColor($r('app.color.color_EB4F3A'))
      .borderRadius($r('app.string.lpx_44'))
      .margin({
        top: $r('app.string.lpx_40'),
        bottom: $r('app.string.lpx_40')
      })
      .onClick(() => {
        this.sendModifyAfterSaleRequest()
      })
  }

}