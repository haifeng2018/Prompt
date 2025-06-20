import { common } from '@kit.AbilityKit'
import DateUtil from 'lib_common/src/main/ets/util/DateUtil'
import PictureSelectUtil from 'lib_common/src/main/ets/util/PictureSelectUtil'
import App from 'lib_core_model/src/main/ets/App'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { UserInfo } from 'lib_core_model/src/main/ets/data/UserInfo'
import { UploadUrlInfo } from 'lib_core_model/src/main/ets/module/UploadUrlInfo'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow'
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils'
import UploadVM from 'lib_core_model/src/main/ets/vm/UploadVM'
import UserVM from 'lib_core_model/src/main/ets/vm/UserVM'
import PhoneUtil from '../../util/PhoneUtil'
import LoadingDialog from '../../view/dialog/LoadingDialog'
import { ToolBar } from '../../view/widget/ToolBar'

@Entry
@Component
struct EditProfilePage {
  @State loginData: LoginData | null = null
  @State userInfo: UserInfo | null = null
  @State uploadUrl: string[] = ['']
  @State headImg?: string = ''
  @State name?: string = ''
  @State introduction?: string = ''
  @State sex?: number = 0
  @State birthday?: number = 0
  @State areaName?: string = ''
  @State address?: string = ''
  @State company?: string = ''
  @State job?: string = ''
  @State phone?: string = ''
  @State weChat?: string = ''
  @State email?: string = ''
  @State selectedDate: Date = new Date("1970-1-1")
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {}),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  sendUploadImgRequest() {
    this.loadingDialogCtrl.open()

    UploadVM.sendUploadImgRequest(getContext(this), this.loginData?.token ?? '', this.uploadUrl)
      .then((value: UploadUrlInfo) => {
        this.loadingDialogCtrl.close()
        this.headImg = value.url
        ToastUtils.show('上传成功')

      })
      .catch((err: string | Resource) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show(err)
      })
  }

  sendUpdateUserInfoRequest() {
    this.loadingDialogCtrl.open()

    let body = new UserInfo()
    if (this.userInfo) {
      body = JSON.parse(JSON.stringify(this.userInfo))
    }

    body.headImg = this.headImg
    body.name = this.name
    body.introduce = this.introduction
    body.sex = this.sex
    body.birthday = this.birthday
    body.areaName = this.areaName
    body.address = this.address
    body.company = this.company
    body.position = this.job
    body.phone = this.phone
    body.wechatNumber = this.weChat
    body.mailbox = this.email

    UserVM.sendUpdateUserInfoRequest(this.loginData?.token ?? '', body).then((value: object) => {
      this.loadingDialogCtrl.close()
      AppConfig.setUserInfo(body)
      ToastUtils.show('保存成功')
      App.get().back()
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((data: LoginData) => {
      this.loginData = data
    })
    AppConfig.getUserInfo().then((data: UserInfo) => {
      this.userInfo = data
      this.headImg = data.headImg
      this.name = data.name
      this.introduction = data.introduce
      this.sex = data.sex
      this.birthday = data.birthday
      this.areaName = data.areaName
      this.address = data.address
      this.company = data.company
      this.job = data.position
      this.phone = data.phone
      this.weChat = data.wechatNumber
      this.email = data.mailbox

      this.selectedDate = new Date(DateUtil.transBirthdayDate(this.birthday ?? 0))
    });
  }

  build() {
    Column() {
      ToolBar({ title: '个人资料' })
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
    .padding({ bottom: $r('app.string.lpx_40') })
  }

  @Builder
  content() {
    List() {
      ListItem() {
        this.baseInfoCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.nickNameCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.lineCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.introductionCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.lineCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.sexCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.lineCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.birthdayCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.lineCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.addressCell()
      }
      .width(Constants.FULL_PARENT)

      ListItem() {
        this.companyCell()
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_20') })

      ListItem() {
        this.contactCell()
      }
      .width(Constants.FULL_PARENT)
      .margin({ top: $r('app.string.lpx_20') })

    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      top: $r('app.string.lpx_20'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .zIndex(0)

    Row() {
      Text('保存')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_44'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.sendUpdateUserInfoRequest()
        })
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
    .zIndex(0)
  }

  @Builder
  baseInfoCell() {
    Column() {
      Stack() {
        Image(this.headImg)
          .alt($r('app.media.ic_avatar_place_holder'))
          .width($r('app.string.lpx_140'))
          .height($r('app.string.lpx_140'))
          .objectFit(ImageFit.Cover)
          .border({
            radius: $r('app.string.lpx_70'),
            width: $r('app.string.lpx_2'),
            color: $r('app.color.white')
          })
        Image($r('app.media.ic_avatar_camera'))
          .width($r('app.string.lpx_40'))
          .height($r('app.string.lpx_40'))
      }
      .alignContent(Alignment.BottomEnd)
      .onClick(() => {
        const context = getContext(this) as common.UIAbilityContext;
        // PermissionHelper.checkPermissions(context, 'ohos.permission.READ_MEDIA').then((grant: boolean) => {
        //   if (grant) {
        //     PictureSelectUtil.fileSelect(1).then((value) => {
        //       if (value.length > 0) {
        //         //添加已选择的图片
        //         this.uploadUrl = value
        //         //在添加上传按钮之前上传图片避免重新处理数据
        //         this.sendUploadImgRequest()
        //       }
        //     })
        //   } else {
        //     PermissionHelper.openPermissionsInSystemSettings(context)
        //   }
        // })
        PictureSelectUtil.fileSelect(1).then((value) => {
          if (value.length > 0) {
            //添加已选择的图片
            this.uploadUrl = value
            //在添加上传按钮之前上传图片避免重新处理数据
            this.sendUploadImgRequest()
          }
        })
      })

      Text('基础资料')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .fontWeight(FontWeight.Bold)
        .margin({ top: $r('app.string.lpx_40') })
    }
    .width(Constants.FULL_PARENT)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  nickNameCell() {
    Row() {
      Text('昵称')
        .width($r('app.string.lpx_136'))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))

      TextInput({ text: this.userInfo?.name || '', placeholder: '请输入' })
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
  }

  @Builder
  introductionCell() {
    Row() {
      Text('简介')
        .width($r('app.string.lpx_136'))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))

      TextInput({ text: this.userInfo?.introduce || '', placeholder: '介绍下自己' })
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
          this.introduction = value
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_102'))
  }

  @Builder
  sexCell() {
    Row() {
      Text('性别')
        .width($r('app.string.lpx_136'))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .margin({ right: $r('app.string.lpx_5') })

      Image(this.sex === 1 ? $r('app.media.ic_shopping_checked') : $r('app.media.ic_shopping_normal'))
        .width($r('app.string.lpx_28'))
        .height($r('app.string.lpx_28'))
        .onClick(() => {
          this.sex = 1
        })

      Text('男')
        .fontColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(28))
        .margin({ left: $r('app.string.lpx_16') })
        .onClick(() => {
          this.sex = 1
        })

      Image(this.sex === 2 ? $r('app.media.ic_shopping_checked') : $r('app.media.ic_shopping_normal'))
        .width($r('app.string.lpx_28'))
        .height($r('app.string.lpx_28'))
        .margin({ left: $r('app.string.lpx_40') })
        .onClick(() => {
          this.sex = 2
        })

      Text('女')
        .fontColor($r('app.color.color_999999'))
        .fontSize(lpx2fp(28))
        .margin({ left: $r('app.string.lpx_16') })
        .onClick(() => {
          this.sex = 2
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_102'))
  }

  @Builder
  birthdayCell() {
    Row() {
      Text('生日')
        .width($r('app.string.lpx_136'))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
      Text(DateUtil.transBirthdayDate(this.birthday) || '选择你的生日')
        .fontColor((this.birthday ?? 0) > 0 ? $r('app.color.color_333333') : $r('app.color.color_999999'))
        .fontSize(lpx2fp(28))
      Blank()
      Image($r('app.media.ic_right'))
        .width($r('app.string.lpx_12'))
        .height($r('app.string.lpx_20'))
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_102'))
    .onClick(() => {
      this.showDatePickerDlg()
    })
  }

  @Builder
  areaCell() {
    Row() {
      Text('地区')
        .width($r('app.string.lpx_136'))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
      Text(this.userInfo?.areaName || '选择所在地区')
        .fontColor(this.userInfo?.areaName ? $r('app.color.color_333333') : $r('app.color.color_999999'))
        .fontSize(lpx2fp(28))
      Blank()
      Image($r('app.media.ic_edit_profile_locate'))
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_102'))
  }

  @Builder
  addressCell() {
    Row() {
      Text('详细地址')
        .width($r('app.string.lpx_136'))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))

      TextInput({ text: this.userInfo?.address || '', placeholder: '请填写详细地址' })
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
          this.address = value
        })
    }
    .width(Constants.FULL_PARENT)
    .height($r('app.string.lpx_102'))
  }

  @Builder
  companyCell() {
    Column() {
      Text('基础资料')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .fontWeight(FontWeight.Bold)
      Row() {
        Text('公司')
          .width($r('app.string.lpx_136'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))

        TextInput({ text: this.userInfo?.company || '', placeholder: '请输入' })
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
            this.company = value
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))

      this.lineCell()

      Row() {
        Text('职位')
          .width($r('app.string.lpx_136'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))

        TextInput({ text: this.userInfo?.position || '', placeholder: '请输入' })
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
            this.job = value
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))
    }
    .width(Constants.FULL_PARENT)
    .alignItems(HorizontalAlign.Start)
    .padding({ top: $r('app.string.lpx_40') })
  }

  @Builder
  contactCell() {
    Column() {
      Text('联系方式')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .fontWeight(FontWeight.Bold)
      Row() {
        Text('手机号')
          .width($r('app.string.lpx_136'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))

        Text(PhoneUtil.blurPhone(this.userInfo?.phone ?? ''))
          .layoutWeight(1)
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .padding({ left: $r('app.string.lpx_5') })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))

      this.lineCell()

      Row() {
        Text('微信号')
          .width($r('app.string.lpx_136'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))

        TextInput({ text: this.userInfo?.wechatNumber || '', placeholder: '请输入' })
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
            this.weChat = value
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))

      this.lineCell()

      Row() {
        Text('邮箱')
          .width($r('app.string.lpx_136'))
          .fontColor($r('app.color.color_777777'))
          .fontSize(lpx2fp(28))

        TextInput({ text: this.userInfo?.mailbox || '', placeholder: '请输入你的邮箱' })
          .placeholderFont({ size: lpx2fp(28) })
          .layoutWeight(1)
          .backgroundColor($r('app.color.transparent'))
          .placeholderColor($r('app.color.color_999999'))
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .textAlign(TextAlign.Start)
          .caretColor($r('app.color.color_EB4F3A'))
          .padding({ left: $r('app.string.lpx_5') })
          .onChange((value: string) => {
            this.email = value
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_102'))
    }
    .width(Constants.FULL_PARENT)
    .alignItems(HorizontalAlign.Start)
    .padding({ top: $r('app.string.lpx_40') })
  }

  @Builder
  lineCell() {
    Line()
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_2'))
      .backgroundColor($r('app.color.color_EFEFEF'))
  }

  showDatePickerDlg() {
    DatePickerDialog.show({
      start: new Date("1950-1-1"),
      end: DateUtil.getDate18YearAgo(),
      selected: this.selectedDate,
      showTime: false,
      useMilitaryTime: false,
      disappearTextStyle: { color: $r('app.color.color_999999'), font: { size: lpx2fp(40), weight: FontWeight.Bold } },
      textStyle: { color: $r('app.color.color_999999'), font: { size: lpx2fp(40), weight: FontWeight.Normal } },
      selectedTextStyle: {
        color: $r('app.color.color_333333'),
        font: { size: lpx2fp(48), weight: FontWeight.Regular }
      },
      onDateAccept: (value: Date) => {
        // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
        this.selectedDate = value
        this.birthday = value.getTime()
      }
    })
  }
}
