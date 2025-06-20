import router from '@ohos.router'
import App from 'lib_core_model/src/main/ets/App';
import { AnswerParm } from 'lib_core_model/src/main/ets/data/AnswerParm';
import { ExerciseInfo } from 'lib_core_model/src/main/ets/data/ExerciseInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import StudyCenterVM from 'lib_core_model/src/main/ets/vm/StudyCenterVM';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import { ToolBar } from '../../view/widget/ToolBar';

@Entry
@Component
struct CoursePracticePage {
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID]
  data: ExerciseInfo = (router.getParams() as object)?.[Constants.DATA]

  @State loginData: LoginData | null = null
  @State describe: string = ''

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
  }

  sendExerciseAnswerRequest () {
    if (!this.describe) {
      ToastUtils.show("请输入学习感受")
      return
    }
    if (this.describe.length > 300) {
      ToastUtils.show("请输入学习感受300字内！")
      return
    }

    this.loadingDialogCtrl.open()

    let body = new AnswerParm()
    body.practiceId = this.data?.id
    body.answer = this.describe

    StudyCenterVM.sendExerciseAnswerRequest(this.tenantId ?? 0,this.loginData?.token ?? '',body).then((value: object) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show("练习提交成功")
      App.get().back()
    }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  build() {
    Column() {
      ToolBar({title: '填写练习感受',shadowColor: $r('app.color.transparent')})
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder content() {
    Column() {
      Text(this.data?.title || '')
        .width(Constants.FULL_PARENT)
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(FontWeight.Bold)
        .maxLines(2)
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .margin({top: $r('app.string.lpx_32')})
        .width(Constants.FULL_PARENT)
      Text(this.data?.subject || '')
        .width(Constants.FULL_PARENT)
        .fontSize(lpx2fp(28))
        .fontColor($r('app.color.color_999999'))
        .margin({top: $r('app.string.lpx_20')})
      Text('学员课程练习内容感受')
        .width(Constants.FULL_PARENT)
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(FontWeight.Bold)
        .margin({top: $r('app.string.lpx_80')})

      Stack() {
        TextArea({ placeholder: '点击填写学习感受'})
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
          .fontSize(lpx2fp(28))
          .fontColor($r('app.color.color_333333'))
          .caretColor($r('app.color.color_EB4F3A'))
          .onChange((value: string) => {
            this.describe = value
          })

        Text(`${this.describe?.length || 0}/300`)
          .fontSize(lpx2fp(20))
          .fontColor($r('app.color.color_777777'))
          .margin({
            bottom: $r('app.string.lpx_20'),
            right: $r('app.string.lpx_14')
          })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_320'))
      .backgroundColor($r('app.color.white'))
      .borderRadius($r('app.string.lpx_4'))
      .alignContent(Alignment.BottomEnd)
      .margin({ top: $r('app.string.lpx_20') })

      Blank()

      Text('提交练习')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.white'))
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_44'))
        .margin({top: $r('app.string.lpx_80')})
        .onClick(() => {
          this.sendExerciseAnswerRequest()
        })
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
