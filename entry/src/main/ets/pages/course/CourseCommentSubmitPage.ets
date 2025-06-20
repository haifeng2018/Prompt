import { router } from '@kit.ArkUI';
import { CommentBean } from 'lib_core_model/src/main/ets/data/CommentBean';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import CommentVM from 'lib_core_model/src/main/ets/vm/CommentVM';
import UploadVM from 'lib_core_model/src/main/ets/vm/UploadVM';
import PictureSelectUtil from 'lib_common/src/main/ets/util/PictureSelectUtil';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { ToolBar } from '../../view/widget/ToolBar';
import { common } from '@kit.AbilityKit';
import { UploadUrlInfo } from 'lib_core_model/src/main/ets/module/UploadUrlInfo';
import { CourseEvaluateCheckData } from 'lib_core_model/src/main/ets/data/CourseEvaluateCheckData';
import { CommentParm } from 'lib_core_model/src/main/ets/data/CommentParm';
import { UserInfo } from 'lib_core_model/src/main/ets/data/UserInfo';
import { CommentDetailData } from 'lib_core_model/src/main/ets/data/CommentDetailData';
import CourseEvaluateTipDialog from '../../view/dialog/CourseEvaluateTipDialog';
import App from 'lib_core_model/src/main/ets/App';
import PermissionHelper from 'lib_common/src/main/ets/util/PermissionHelper';

@Entry
@Component
struct CourseCommentSubmitPage {
  commentBean: CommentBean = (router.getParams() as object)?.[Constants.DATA];
  @State loginData: LoginData | null = null
  @State userInfo: UserInfo | null = null

  @State level: number = 1//1:好评；2：中评；3，差评
  @State evaluateContent: string = ''//评价内容

  @State teacherStr: string = ''
  @State imageUrlList: Array<string> = []
  @State uploadPath: string[] = ['']

  @State mCommentDetailData?: CommentDetailData | null = null
  @State mCourseEvaluateCheckData?: CourseEvaluateCheckData | null = null

  onCancel() {
  }

  onConfirm() {
    this.sendCommentRequest()
  }

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  courseEvaluateTipDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: CourseEvaluateTipDialog({
      mCourseEvaluateCheckData: this.mCourseEvaluateCheckData,
      cancel: this.onCancel.bind(this),
      confirm: this.onConfirm.bind(this),
    }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: true
  });

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

  sendEvaluateLecturerRequest () {
    CommentVM.sendEvaluateLecturerRequest(this.commentBean?.tenantId ?? 0,this.loginData?.token ?? '',
      this.commentBean?.goodsId ?? '').then((value: string[]) => {
      this.teacherStr = ''
      value.forEach((value: string,index: number) => {
        this.teacherStr += `${value}、`
      })
      if (this.teacherStr.length > 0) {
        this.teacherStr = this.teacherStr.slice(0,this.teacherStr.length - 1)
      }
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendEvaluateCheckRequest () {
    if (!this.evaluateContent) {
      ToastUtils.show("请填写您看课的感受或收获，至少10个字以上")
      return
    }
    if (this.evaluateContent.length < 10) {
      ToastUtils.show("请填写您看课的感受或收获，至少10个字以上")
      return
    }
    this.loadingDialogCtrl.open()
    CommentVM.sendEvaluateCheckRequest(this.commentBean?.tenantId ?? 0,this.loginData?.token ?? '',
      this.evaluateContent).then((value: CourseEvaluateCheckData) => {
      this.loadingDialogCtrl.close()
        this.mCourseEvaluateCheckData = value
        if (value.has) {
          this.courseEvaluateTipDialogCtrl.open()
          return
        }
        this.sendCommentRequest()
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendCommentDetailRequest () {
    CommentVM.sendCommentDetailRequest(this.commentBean?.tenantId ?? 0,this.loginData?.token ?? '',
      this.commentBean?.id ?? 0).then((value: CommentDetailData) => {
      this.mCommentDetailData = value
      this.level = value.level ?? 1
      this.evaluateContent = value.content ?? ''
      this.imageUrlList = value.imgList ?? []
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendCommentRequest () {
    this.loadingDialogCtrl.open()

    const body = new CommentParm()
    body.content = this.evaluateContent
    body.goodsId = this.commentBean?.goodsId
    body.id = this.commentBean?.id
    body.userId = this.userInfo?.uid
    body.orderNo = this.commentBean?.orderNo
    body.phone = this.commentBean?.userPhone
    body.files = this.imageUrlList
    body.level = this.level

    const  lastLevel = this.mCommentDetailData?.level ?? 0
    if (lastLevel > 0) {
      CommentVM.sendEditCommentRequest(this.commentBean?.tenantId ?? 0,this.loginData?.token ?? '',
        body).then((value: CourseEvaluateCheckData) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show("评价修改成功")
        App.get().back()
      }).catch((err: string | Resource) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show(err)
      })
    } else {
      CommentVM.sendAddCommentRequest(this.commentBean?.tenantId ?? 0,this.loginData?.token ?? '',
        body).then((value: CourseEvaluateCheckData) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show("评价成功")
        App.get().back()
      }).catch((err: string | Resource) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show(err)
      })
    }
  }

  refreshData () {
    this.sendEvaluateLecturerRequest()
    this.sendCommentDetailRequest()
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.refreshData()
    })
    AppConfig.getUserInfo().then((resultData: UserInfo) => {
      this.userInfo = resultData
    })
  }

  build() {
    Column() {
      ToolBar({title: '商品评价'})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {
      Row() {
        Image(this.commentBean?.cover)
          .alt($r('app.media.img_placeholder_horizontal'))
          .width($r('app.string.lpx_120'))
          .height($r('app.string.lpx_120'))
          .border({radius: $r('app.string.lpx_8')})

        Column(){
          Text(this.commentBean?.title ?? '')
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})

          Blank()

          Text(this.teacherStr)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.color_666666'))
            .fontSize(lpx2fp(24))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
        }
        .layoutWeight(1)
        .height($r('app.string.lpx_120'))
        .padding({left: $r('app.string.lpx_24')})
      }
      .width(Constants.FULL_PARENT)
      .padding($r('app.string.lpx_32'))

      Row() {
        Text('商品评价')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))

        Text() {
          ImageSpan(this.level === 1 ? $r('app.media.ic_good_review_checked') : $r('app.media.ic_good_review_normal'))
            .width($r('app.string.lpx_56'))
            .height($r('app.string.lpx_56'))
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span('\t好评')
            .fontColor(this.level === 1 ? $r('app.color.color_FA4932') : $r('app.color.color_999999'))
            .fontSize(lpx2fp(32))
        }
        .margin({left: $r('app.string.lpx_32')})
        .onClick(() => {
          this.level = 1
        })

        Text() {
          ImageSpan(this.level === 2 ? $r('app.media.ic_average_review_checked') : $r('app.media.ic_average_review_normal'))
            .width($r('app.string.lpx_56'))
            .height($r('app.string.lpx_56'))
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span('\t中评')
            .fontColor(this.level === 2 ? $r('app.color.color_FA4932') : $r('app.color.color_999999'))
            .fontSize(lpx2fp(32))
        }
        .margin({left: $r('app.string.lpx_40')})
        .onClick(() => {
          this.level = 2
        })

        Text() {
          ImageSpan(this.level === 3 ? $r('app.media.ic_bad_review_checked') : $r('app.media.ic_bad_review_normal'))
            .width($r('app.string.lpx_56'))
            .height($r('app.string.lpx_56'))
            .verticalAlign(ImageSpanAlignment.CENTER)
          Span('\t差评')
            .fontColor(this.level === 3 ? $r('app.color.color_FA4932') : $r('app.color.color_999999'))
            .fontSize(lpx2fp(32))
        }
        .margin({left: $r('app.string.lpx_40')})
        .onClick(() => {
          this.level = 3
        })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_120'))
      .backgroundColor($r('app.color.color_F5F6FA'))
      .padding({left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32')})
      .alignItems(VerticalAlign.Center)

      Stack(){
        TextArea({ text: this.evaluateContent,placeholder: '填写您看课的感受或收获，至少10个字以上' })
          .placeholderFont({ size: lpx2fp(28) })
          .width(Constants.FULL_PARENT)
          .height($r('app.string.lpx_270'))
          .padding({
            top: $r('app.string.lpx_20'),
            bottom: $r('app.string.lpx_60'),
            left: $r('app.string.lpx_20'),
            right: $r('app.string.lpx_20')
          })
          .backgroundColor($r('app.color.color_FAFAFA'))
          .borderRadius($r('app.string.lpx_8'))
          .placeholderFont({ size: lpx2fp(28) })
          .placeholderColor($r('app.color.color_999999'))
          .maxLength(300)
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .caretColor($r('app.color.color_EB4F3A'))
          .onChange((value: string) => {
            this.evaluateContent = value
          })

        Text(`${this.evaluateContent.length ?? 0}/300`)
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_999999'))
          .margin({bottom:  $r('app.string.lpx_20'),right:  $r('app.string.lpx_20')})
      }
      .width(Constants.FULL_PARENT)
      .alignContent(Alignment.BottomEnd)
      .padding({
        top: $r('app.string.lpx_32'),
        left: $r('app.string.lpx_32'),
        right:  $r('app.string.lpx_32')
      })

      List({space: `${$r('app.string.lpx_20')}}`}){

        ForEach(this.imageUrlList,(item: string,index: number) => {
          ListItem(){
            this.imageCell(item,index)
          }
        })

        if (this.imageUrlList.length < 6) {
          ListItem() {
            this.addCell()
          }
        }
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})
      .lanes(3)

      Blank()

      Button('提交评价')
        .width('70%')
        .height($r('app.string.lpx_88'))
        .backgroundColor($r('app.color.color_EB4F3A'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .borderRadius($r('app.string.lpx_44'))
        .onClick(() => {
          this.sendEvaluateCheckRequest()
        })
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .backgroundColor($r('app.color.white'))
    .margin({top: $r('app.string.lpx_8')})
    .padding({bottom: $r('app.string.lpx_60')})
  }

  @Builder imageCell(imgUrl: string,index: number) {
    Stack(){
      Image(imgUrl)
        .alt($r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_202'))
        .height($r('app.string.lpx_202'))
        .borderRadius($r('app.string.lpx_8'))
        .margin({top: $r('app.string.lpx_20'),right: $r('app.string.lpx_20')})
      Image($r('app.media.img_evaluate_image_del'))
        .width($r('app.string.lpx_36'))
        .height($r('app.string.lpx_36'))
        .onClick(() => {
          this.imageUrlList.splice(index, 1)
        })
    }
    .width($r('app.string.lpx_242'))
    .height($r('app.string.lpx_242'))
    .alignContent(Alignment.TopEnd)
  }

  @Builder addCell() {
    Stack(){
      Rect()
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
        .radius(`${lpx2px(8)}px`)
        .fillOpacity(0)
        .strokeDashArray([$r('app.string.lpx_5')])
        .stroke($r('app.color.color_C8C9CC'))
        .strokeWidth($r('app.string.lpx_2'))
        .strokeLineCap(LineCapStyle.Round)

      Column() {
        Image($r('app.media.img_evaluate_upload'))
          .width($r('app.string.lpx_48'))
          .height($r('app.string.lpx_48'))
        Text(`上传图片 ${this.imageUrlList.length ?? 0}/6`)
          .fontColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(24))
          .margin({top: $r('app.string.lpx_20')})
      }
      .justifyContent(FlexAlign.Center)
    }
    .width($r('app.string.lpx_242'))
    .height($r('app.string.lpx_242'))
    .padding($r('app.string.lpx_20'))
    .onClick(() => {
      let maxCount = 6 - this.imageUrlList.length
      if (maxCount === 0) {
        ToastUtils.show("图片最多上传6个")
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
}