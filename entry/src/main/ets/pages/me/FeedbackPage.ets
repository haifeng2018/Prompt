import { common } from '@kit.AbilityKit'
import font from '@ohos.font'
import PermissionHelper from 'lib_common/src/main/ets/util/PermissionHelper'
import PictureSelectUtil from 'lib_common/src/main/ets/util/PictureSelectUtil'
import App from 'lib_core_model/src/main/ets/App'
import { FeedbackParm } from 'lib_core_model/src/main/ets/data/FeedbackParm'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { UserInfo } from 'lib_core_model/src/main/ets/data/UserInfo'
import { UploadUrlInfo } from 'lib_core_model/src/main/ets/module/UploadUrlInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import MessageVM from 'lib_core_model/src/main/ets/vm/MessageVM'
import UploadVM from 'lib_core_model/src/main/ets/vm/UploadVM'
import LoadingDialog from '../../view/dialog/LoadingDialog'
import { ToolBar } from '../../view/widget/ToolBar'

@Entry
@Component
struct FeedbackPage {
  @State loginData: LoginData = new LoginData()
  @State userInfo: UserInfo = new UserInfo()
  @State feedType: number = -1
  @State feedTypeName: string = ''
  @State name: string = ''
  @State phone: string = ''
  @State describe: string = ''
  @State imageUrlList: Array<string> = []
  @State uploadPath: string[] = ['']
  @State mCountDownSeconds: number = 0
  @State code: string = ''
  mTimerId: number = 0
  select: number = 0
  feedTypes: string[] = ['售前咨询', '售后', '问题反馈']
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  aboutToAppear(): void {
    font.registerFont({
      familyName: 'myfont',
      familySrc: '/fonts/iconfont.ttf'
    })
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })

    AppConfig.getUserInfo().then((resultData: UserInfo) => {
      this.userInfo = resultData
    })
  }

  startTimer(countDownSeconds: number) {
    clearTimeout(this.mTimerId)
    this.mCountDownSeconds = countDownSeconds
    this.mTimerId = setInterval(() => {
      if (this.mCountDownSeconds === 0) {

      } else {
        this.mCountDownSeconds--;
      }
    }, Constants.AD_INTERVAL_TIME);
  }

  handleFeedBackTypeClick() {
    TextPickerDialog.show({
      range: this.feedTypes,
      selected: this.select,
      canLoop: false,
      defaultPickerItemHeight: 40,
      onAccept: (result: TextPickerResult) => {
        this.select = result.index as number
        this.feedTypeName = result.value as string
        this.feedType = result.index as number
      },
      onCancel: () => {
      },
      onChange: (value: TextPickerResult) => {
      }
    })
  }

  sendUploadImgMultiRequest() {
    this.loadingDialogCtrl.open()
    const context = getContext(this) as common.UIAbilityContext;
    UploadVM.sendUploadImgMultiRequest(context, this.loginData?.token ?? '', this.uploadPath)
      .then((value: UploadUrlInfo) => {
        this.loadingDialogCtrl.close()
        this.imageUrlList = this.imageUrlList.concat(value.urls ?? [])
        ToastUtils.show('上传成功')
      }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  sendFeedbackCodeRequest() {
    if (this.phone === '') {
      ToastUtils.show('请输入手机号')
      return
    }
    if (!this.phone.startsWith("1") || this.phone.length < 11) {
      ToastUtils.show('请输入正确的手机号')
      return
    }

    this.loadingDialogCtrl.open()

    MessageVM.sendFeedbackCodeRequest(this.loginData.token ?? '', this.phone).then((data: Object) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show('验证码发送成功')
      this.startTimer(60)
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    });
  }

  sendFeedbackRequest() {
    if (this.feedType === -1) {
      ToastUtils.show('请选择反馈类型')
      return
    }
    if (this.name === '') {
      ToastUtils.show("请输入姓名")
      return
    }
    if (this.phone === '') {
      ToastUtils.show("请输入手机号")
      return
    }
    if (this.code === '') {
      ToastUtils.show("请输入验证码")
      return
    }
    if (this.describe === '') {
      ToastUtils.show("请输入问题描述")
      return
    }

    this.loadingDialogCtrl.open()

    let body = new FeedbackParm()
    body.userId = this.userInfo.uid
    body.username = this.name
    body.type = this.feedType
    body.phone = this.phone
    body.code = this.code
    body.messageContent = this.describe
    body.messageImages = this.imageUrlList
    MessageVM.sendFeedbackRequest(this.loginData.token ?? '', body).then((data: object) => {
      this.loadingDialogCtrl.close()
      App.get().replaceUrl({
        url: RouterPath.FEEDBACK_SUCCESS_PAGE
      })
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  build() {
    Column() {
      ToolBar({ title: '意见反馈' })
      this.content()
      this.submit()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
  }

  @Builder
  content() {
    Scroll() {
      Column() {
        this.selectFeedBackType()
        this.editName()
        this.editPhoneNumber()
        this.getVerificationCode()
        this.editProblemDesc()
        this.uploadImage()
      }
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .scrollable(ScrollDirection.Vertical)
    .margin({ top: $r('app.string.lpx_10') })
    .align(Alignment.Top)
  }

  @Builder
  selectFeedBackType() {
    Column() {
      Row() {
        Text('*')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
        Text('反馈分类')
          .width($r('app.string.lpx_130'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_6') })
        Text(this.feedTypeName || '点击选择反馈类型')
          .fontColor(this.feedType === -1 ? $r('app.color.color_999999') : $r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .padding({ left: $r('app.string.lpx_5') })
        Blank()

        Text('\ue88e')
          .fontSize(lpx2fp(48))
          .fontColor($r('app.color.color_777777'))
          .fontFamily('myfont')
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))
      .onClick(() => {
        this.handleFeedBackTypeClick()
      })

      this.lineCell()
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
  }

  @Builder
  editName() {
    Column() {
      Row() {
        Text('*')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
        Text('姓名')
          .width($r('app.string.lpx_130'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_6') })
        TextInput({ placeholder: '输入姓名' })
          .placeholderFont({ size: lpx2fp(28) })
          .layoutWeight(1)
          .backgroundColor($r('app.color.transparent'))
          .placeholderColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Start)
          .caretColor($r('app.color.color_EB4F3A'))
          .maxLength(16)
          .padding({ left: $r('app.string.lpx_5') })
          .onChange((value: string) => {
            this.name = value
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))
      .backgroundColor($r('app.color.white'))

      this.lineCell()
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
  }

  @Builder
  editPhoneNumber() {
    Column() {
      Row() {
        Text('*')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
        Text('手机号码')
          .width($r('app.string.lpx_130'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_6') })
        TextInput({ placeholder: '输入手机号' })
          .placeholderFont({ size: lpx2fp(28) })
          .layoutWeight(1)
          .backgroundColor($r('app.color.transparent'))
          .placeholderColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Start)
          .caretColor($r('app.color.color_EB4F3A'))
          .maxLength(11)
          .type(InputType.Number)
          .padding({ left: $r('app.string.lpx_5') })
          .onChange((value: string) => {
            this.phone = value
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))
      .backgroundColor($r('app.color.white'))

      this.lineCell()
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
  }

  @Builder
  getVerificationCode() {
    Column() {
      Row() {
        Text('*')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
        Text('验证码')
          .width($r('app.string.lpx_130'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_6') })
        TextInput({ placeholder: '输入验证码' })
          .placeholderFont({ size: lpx2fp(28) })
          .layoutWeight(1)
          .backgroundColor($r('app.color.transparent'))
          .placeholderColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Start)
          .caretColor($r('app.color.color_EB4F3A'))
          .maxLength(11)
          .type(InputType.Number)
          .padding({ left: $r('app.string.lpx_5') })
          .onChange((value: string) => {
            this.code = value
          })

        Button(this.mCountDownSeconds === 0 ? '获取验证码' : `${this.mCountDownSeconds}秒`)
          .height($r('app.string.lpx_64'))
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
          .backgroundColor($r('app.color.transparent'))
          .borderRadius($r('app.string.lpx_32'))
          .borderWidth($r('app.string.lpx_2'))
          .borderColor($r('app.color.color_EB4F3A'))
          .padding({ left: $r('app.string.lpx_40'), right: $r('app.string.lpx_40') })
          .enabled(this.mCountDownSeconds === 0)
          .opacity(this.mCountDownSeconds === 0 ? 1 : 0.6)
          .onClick(() => {
            this.sendFeedbackCodeRequest()
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))
      .backgroundColor($r('app.color.white'))

      this.lineCell()
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32') })
  }

  @Builder
  editProblemDesc() {
    Column() {
      Row() {
        Text('*')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize(lpx2fp(28))
        Text('问题描述')
          .width($r('app.string.lpx_130'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))
          .margin({ left: $r('app.string.lpx_6') })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))
      .width(Constants.FULL_PARENT)
      .backgroundColor($r('app.color.white'))

      TextArea({ placeholder: '请输入问题描述' })
        .placeholderFont({ size: lpx2fp(28) })
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_270'))
        .padding($r('app.string.lpx_20'))
        .border({
          width: $r('app.string.lpx_2'),
          radius: $r('app.string.lpx_8'),
          color: $r('app.color.color_EFEFEF')
        })
        .backgroundColor($r('app.color.transparent'))
        .placeholderFont({ size: lpx2fp(28) })
        .placeholderColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_333333'))
        .caretColor($r('app.color.color_EB4F3A'))
        .onChange((value: string) => {
          this.describe = value
        })
    }
    .width(Constants.FULL_PARENT)
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32'), bottom: $r('app.string.lpx_32') })
    .backgroundColor($r('app.color.white'))
  }

  @Builder
  uploadImage() {
    Column() {
      Text('上传凭证')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .textAlign(TextAlign.Start)
      Text('非必填，最多上传6张jpg或png图片，单张图片不能大于1M')
        .width(Constants.FULL_PARENT)
        .fontColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(24))
        .margin({ top: $r('app.string.lpx_16') })
        .textAlign(TextAlign.Start)
      List({ space: `${$r('app.string.lpx_20')}}` }) {
        ForEach(this.imageUrlList, (uri: string, index: number) => {
          ListItem() {
            this.uploadImageCell(uri, index)
          }
        })
        if (this.imageUrlList.length < 6) {
          ListItem() {
            this.addImageCell()
          }
        }
      }
      .width(Constants.FULL_PARENT)
      .lanes(4)
      .padding({ top: $r('app.string.lpx_10'), bottom: $r('app.string.lpx_10') })
    }
    .width(Constants.FULL_PARENT)
    .padding({ left: $r('app.string.lpx_32'), right: $r('app.string.lpx_32'), bottom: $r('app.string.lpx_32') })
    .backgroundColor($r('app.color.white'))
  }

  @Builder
  lineCell() {
    Line()
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_2'))
      .backgroundColor($r('app.color.color_EFEFEF'))
  }

  @Builder
  uploadImageCell(uri: string, index: number) {
    Stack() {
      Image(uri)
        .objectFit(ImageFit.Cover)
        .width($r('app.string.lpx_140'))
        .height($r('app.string.lpx_140'))
        .margin({ top: $r('app.string.lpx_10'), right: $r('app.string.lpx_10') })
      Image($r('app.media.ic_image_del'))
        .width($r('app.string.lpx_32'))
        .height($r('app.string.lpx_32'))
        .onClick(() => {
          this.imageUrlList.splice(index, 1)
        })
    }
    .width($r('app.string.lpx_160'))
    .height($r('app.string.lpx_160'))
    .alignContent(Alignment.TopEnd)
  }

  @Builder
  addImageCell() {
    Stack() {
      Image($r('app.media.ic_add_img'))
        .objectFit(ImageFit.Contain)
        .width($r('app.string.lpx_140'))
        .height($r('app.string.lpx_140'))
        .margin({ top: $r('app.string.lpx_10'), right: $r('app.string.lpx_10') })
    }
    .width($r('app.string.lpx_160'))
    .height($r('app.string.lpx_160'))
    .alignContent(Alignment.TopEnd)
    .onClick(() => {
      let maxCount = 6 - this.imageUrlList.length
      if (maxCount === 0) {
        ToastUtils.show("图片最多上传6个")
        return
      }
      const context = getContext(this) as common.UIAbilityContext;
      PermissionHelper.checkPermissions(context, 'ohos.permission.READ_MEDIA').then((grant: boolean) => {
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

  @Builder
  submit() {
    Row() {
      Button('提交', { type: ButtonType.Normal, stateEffect: true })
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_44'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .onClick(() => {
          this.sendFeedbackRequest()
        })
    }
    .margin({ top: $r('app.string.lpx_30') })
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}