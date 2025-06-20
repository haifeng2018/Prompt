import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { router } from '@kit.ArkUI';
import { ToolBar } from '../../view/widget/ToolBar';
import { OrderDetailData } from 'lib_core_model/src/main/ets/data/OrderDetailData';
import LoadingDialog from '../../view/dialog/LoadingDialog';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import InvoiceVM from 'lib_core_model/src/main/ets/vm/InvoiceVM';
import { InvoiceCompanyInfo } from 'lib_core_model/src/main/ets/data/InvoiceCompanyInfo';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import { MakeOutInvoiceParm } from 'lib_core_model/src/main/ets/data/MakeOutInvoiceParm';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil';
import App from 'lib_core_model/src/main/ets/App';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import EmailUtil from '../../util/EmailUtil';

@Entry
@Component
struct InvoicePage {
  data?: OrderDetailData = (router.getParams() as object)?.[Constants.DATA];
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  orderNo?: string = (router.getParams() as object)?.[Constants.ORDER_NO];

  @State loginData: LoginData | null = null
  @State keyword: string = ''
  @State companyList: Array<InvoiceCompanyInfo> = []
  @State showCompanyList: boolean = false//显示公司列表菜单
  @State invoiceType: number = 2//1.全电专票 2.全电普票
  @State personType: number = 1//1.个人 2.企业
  @State head: string = ''//发票抬头
  @State taxId: string = ''//税号
  @State addr: string = ''//注册地址
  @State phone: string = ''//注册电话
  @State bank: string = ''//开户银行
  @State cardNo: string = ''//银行账号
  @State email: string = ''//接收邮箱
  @State remark: string = ''//备注

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  })

  sendInvoiceCompanyRequest () {
    InvoiceVM.sendInvoiceCompanyRequest(this.tenantId ?? 0,this.loginData?.token ?? '',this.keyword)
      .then((value: InvoiceCompanyInfo[]) => {
        this.companyList = value
      }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendMakeOutInvoiceRequest () {
    if (!this.head) {
      ToastUtils.show("请填写发票抬头")
      return
    }
    if (!this.email) {
      ToastUtils.show("请填写接收邮箱")
      return
    }
    if (!EmailUtil.isValidEmail(this.email)) {
      ToastUtils.show("请填写正确的邮箱")
      return
    }
    if (!this.taxId && this.personType == 2) {
      ToastUtils.show("请填写税号")
      return
    }
    if (!this.addr && this.invoiceType == 1) {
      ToastUtils.show("请填写注册地址")
      return
    }
    if (!this.phone && this.invoiceType == 1) {
      ToastUtils.show("请填写注册电话")
      return
    }
    if (!this.bank && this.invoiceType == 1) {
      ToastUtils.show("请填写开户银行")
      return
    }
    if (!this.cardNo && this.invoiceType == 1) {
      ToastUtils.show("请填写银行账号")
      return
    }

    this.loadingDialogCtrl.open()

    const body = new MakeOutInvoiceParm()
    body.orderNo = this.data?.orderNo
    body.invoiceAmount = this.data?.invoiceAmount ?? 0
    body.orderAmount = this.data?.invoiceAmount ?? 0
    body.invoiceType = this.invoiceType
    body.personType = this.personType
    body.invoiceTitle = this.head
    body.receivingEmail = this.email
    body.taxId = this.taxId
    body.registeredAddress = this.addr
    body.registeredPhone = this.phone
    body.bankOfDeposit = this.bank
    body.accountNumber = this.cardNo
    body.remarks = this.remark

    InvoiceVM.sendMakeOutInvoiceRequest(this.tenantId ?? 0,this.loginData?.token ?? '',body)
      .then((value: object) => {
        this.loadingDialogCtrl.close()
        App.get().replaceUrl({
          url: RouterPath.INVOICE_DETAIL_PAGE,
          params: {
            tenantId: this.tenantId,
            orderNo: this.orderNo
          }
        })
      }).catch((err: string | Resource) => {
      this.loadingDialogCtrl.close()
      ToastUtils.show(err)
    })
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
    })
  }

  build() {
    Column() {
      ToolBar({title: '开票申请'})
      this.content()
      this.bottomAction()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
  }

  @Builder content() {
    List(){
      ListItem(){
        Text('共计开票金额：')
          .fontColor($r('app.color.white'))
          .fontSize(lpx2fp(28))
          .margin({left: $r('app.string.lpx_24')})
      }

      ListItem(){
        Text(){
          Span('￥')
            .fontColor($r('app.color.white'))
            .fontSize(lpx2fp(28))
          Span(AmountUtil.getRoundUp((this.data?.invoiceAmount ?? 0) / 100,2))
            .fontColor($r('app.color.white'))
            .fontSize(lpx2fp(64))
        }
        .margin({left: $r('app.string.lpx_24')})
      }

      ListItem(){
        this.invoiceTypeCell()
      }

      ListItem(){
        this.invoiceInfoCell()
      }

      ListItem(){
        this.ohterInfoCell()
      }

      ListItem(){
        Line().height($r('app.string.lpx_40'))
      }
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .backgroundImage($r('app.media.img_invoice_bg'))
    .backgroundImageSize(ImageSize.FILL)
    .padding({
      top: $r('app.string.lpx_56'),
      left: $r('app.string.lpx_24'),
      right: $r('app.string.lpx_24')
    })
  }

  @Builder invoiceTypeCell() {
    Column(){
      Text('发票类型')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .width(Constants.FULL_PARENT)
      Row() {
        Stack(){
          Text('电子普票')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .textAlign(TextAlign.Center)
            .width(Constants.FULL_PARENT)
            .height(Constants.FULL_PARENT)
            .backgroundColor(this.invoiceType == 2 ? $r('app.color.transparent') : $r('app.color.color_F7F8FC'))
            .border({
              width: $r('app.string.lpx_2'),
              color: this.invoiceType == 2 ? $r('app.color.transparent') : $r('app.color.color_EEEEEE'),
              radius: $r('app.string.lpx_12')
            })
        }
        .height(Constants.FULL_PARENT)
        .layoutWeight(1)
        .backgroundImage(this.invoiceType == 2 ? $r('app.media.img_invoice_label_checked') : null)
        .backgroundImageSize(ImageSize.FILL)
        .onClick(() => {
          this.invoiceType = 2
        })

        Stack(){
          Text('电子专票')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .textAlign(TextAlign.Center)
            .width(Constants.FULL_PARENT)
            .height(Constants.FULL_PARENT)
            .backgroundColor(this.invoiceType == 1 ? $r('app.color.transparent') : $r('app.color.color_F7F8FC'))
            .border({
              width: $r('app.string.lpx_2'),
              color: this.invoiceType == 1 ? $r('app.color.transparent') : $r('app.color.color_EEEEEE'),
              radius: $r('app.string.lpx_12')
            })
        }
        .height(Constants.FULL_PARENT)
        .layoutWeight(1)
        .margin({left: $r('app.string.lpx_22')})
        .backgroundImage(this.invoiceType == 1 ? $r('app.media.img_invoice_label_checked') : null)
        .backgroundImageSize(ImageSize.FILL)
        .onClick(() => {
          this.invoiceType = 1
          this.personType = 2
        })
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_80'))
      .margin({top: $r('app.string.lpx_24')})
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_16'))
    .margin({top: $r('app.string.lpx_40')})
    .padding({
      top: $r('app.string.lpx_28'),
      bottom: $r('app.string.lpx_28'),
      left: $r('app.string.lpx_24'),
      right: $r('app.string.lpx_24')
    })
  }

  @Builder invoiceInfoCell() {
    Column() {
      Text('发票信息')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .width(Constants.FULL_PARENT)

      Row() {
        Stack(){
          Text('个人')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .textAlign(TextAlign.Center)
            .width(Constants.FULL_PARENT)
            .height(Constants.FULL_PARENT)
            .backgroundColor(this.personType == 1 ? $r('app.color.transparent') : $r('app.color.color_F7F8FC'))
            .border({
              width: $r('app.string.lpx_2'),
              color: this.personType == 1 ? $r('app.color.transparent') : $r('app.color.color_EEEEEE'),
              radius: $r('app.string.lpx_12')
            })
        }
        .height(Constants.FULL_PARENT)
        .layoutWeight(1)
        .backgroundImage(this.personType == 1 ? $r('app.media.img_invoice_label_checked') : null)
        .backgroundImageSize(ImageSize.FILL)
        .visibility(this.invoiceType == 1 ? Visibility.None : Visibility.Visible)
        .onClick(() => {
          this.personType = 1
        })

        Stack(){
          Text('单位')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .textAlign(TextAlign.Center)
            .width(Constants.FULL_PARENT)
            .height(Constants.FULL_PARENT)
            .backgroundColor(this.personType == 2 ? $r('app.color.transparent') : $r('app.color.color_F7F8FC'))
            .border({
              width: $r('app.string.lpx_2'),
              color: this.personType == 2 ? $r('app.color.transparent') : $r('app.color.color_EEEEEE'),
              radius: $r('app.string.lpx_12')
            })
        }
        .height(Constants.FULL_PARENT)
        .layoutWeight(1)
        .margin({left: this.invoiceType == 2 ? $r('app.string.lpx_22') : 0})
        .backgroundImage(this.personType == 2 ? $r('app.media.img_invoice_label_checked') : null)
        .backgroundImageSize(ImageSize.FILL)
        .onClick(() => {
          this.personType = 2
        })

        Line()
          .layoutWeight(1)
          .visibility(this.invoiceType == 2 ? Visibility.None : Visibility.Visible)
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_80'))
      .margin({top: $r('app.string.lpx_24')})

      Text(){
        Span('发票抬头')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(24))
          .fontWeight(FontWeight.Bold)
        Span('*')
          .fontColor($r('app.color.color_ED1B24'))
          .fontSize(lpx2fp(24))
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})

      TextInput({ placeholder: '请填写发票抬头' })
        .inputFancy()
        .maxLength(30)
        .enterKeyType(EnterKeyType.Search)
        .bindMenu(this.showCompanyList,this.companyMenu())
        .onChange((value: string) => {
          this.head = value
        })
        .onSubmit((enterKey: EnterKeyType) => {
          this.keyword = this.head
          this.sendInvoiceCompanyRequest()
        })

      if (this.personType == 2) {
        Text(){
          Span('税号')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
          Span('*')
            .fontColor($r('app.color.color_ED1B24'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

        TextInput({ placeholder: '请填写税号' })
          .inputFancy()
          .maxLength(20)
          .onChange((value: string) => {
            this.taxId = value
          })
      }

      if (this.invoiceType == 1 && this.personType == 2) {
        Text(){
          Span('注册地址')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
          Span('*')
            .fontColor($r('app.color.color_ED1B24'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

        TextInput({ placeholder: '请填写注册地址' })
          .inputFancy()
          .maxLength(20)
          .onChange((value: string) => {
            this.addr = value
          })

        Text(){
          Span('注册电话')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
          Span('*')
            .fontColor($r('app.color.color_ED1B24'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

        TextInput({ placeholder: '请填写注册电话' })
          .inputFancy()
          .type(InputType.Number)
          .maxLength(20)
          .onChange((value: string) => {
            this.phone = value
          })

        Text(){
          Span('开户银行')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
          Span('*')
            .fontColor($r('app.color.color_ED1B24'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

        TextInput({ placeholder: '请填写开户银行' })
          .inputFancy()
          .maxLength(20)
          .onChange((value: string) => {
            this.bank = value
          })

        Text(){
          Span('银行账号')
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
          Span('*')
            .fontColor($r('app.color.color_ED1B24'))
            .fontSize(lpx2fp(24))
            .fontWeight(FontWeight.Bold)
        }
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

        TextInput({ placeholder: '请填写银行账号' })
          .inputFancy()
          .maxLength(20)
          .onChange((value: string) => {
            this.cardNo = value
          })
      }

      Text(){
        Span('接收邮箱')
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(24))
          .fontWeight(FontWeight.Bold)
        Span('*')
          .fontColor($r('app.color.color_ED1B24'))
          .fontSize(lpx2fp(24))
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.string.lpx_32')})

      TextInput({ placeholder: '请填写接收邮箱' })
        .inputFancy()
        .type(InputType.Email)
        .maxLength(80)
        .onChange((value: string) => {
          this.email = value
        })

    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_16'))
    .margin({top: $r('app.string.lpx_20')})
    .padding({
      top: $r('app.string.lpx_28'),
      bottom: $r('app.string.lpx_28'),
      left: $r('app.string.lpx_24'),
      right: $r('app.string.lpx_24')
    })
  }

  @Builder ohterInfoCell() {
    Column() {

      Text('其他信息（非必填）')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .width(Constants.FULL_PARENT)

      Text('备注')
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(24))
        .fontWeight(FontWeight.Bold)
        .width(Constants.FULL_PARENT)
        .margin({top: $r('app.string.lpx_32')})

      TextInput({ placeholder: '请填写备注' })
        .inputFancy()
        .maxLength(30)
        .onChange((value: string) => {
          this.remark = value
        })
    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.string.lpx_16'))
    .margin({top: $r('app.string.lpx_20')})
    .padding({
      top: $r('app.string.lpx_28'),
      bottom: $r('app.string.lpx_28'),
      left: $r('app.string.lpx_24'),
      right: $r('app.string.lpx_24')
    })
  }

  @Builder bottomAction() {
    Row() {
      Button('申请开票',{ type: ButtonType.Normal, stateEffect: true })
        .layoutWeight(1)
        .height($r('app.string.lpx_88'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(32))
        .fontWeight(FontWeight.Bold)
        .borderRadius($r('app.string.lpx_12'))
        .linearGradient({
          angle: 90,
          colors: [
            [$r('app.color.color_FC6D38'),0.0],
            [$r('app.color.color_F12E29'),0.7],
            [$r('app.color.color_F12E29'),1.0]
          ]
        })
        .onClick(() => {
          this.sendMakeOutInvoiceRequest()
        })

    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_20'),
      bottom: $r('app.string.lpx_68'),
      left: $r('app.string.lpx_24'),
      right: $r('app.string.lpx_24')
    })
  }

  @Builder companyMenu() {
    Menu() {
      ForEach(this.companyList,(item: InvoiceCompanyInfo) => {
        MenuItem({
          content: item.name
        })
          .onClick(() => {
            this.head = item.name ?? ''
            this.taxId = item.creditNo ?? ''
            this.companyList = []
          })
      })
    }
  }
}

@Extend(TextInput)
function inputFancy() {
  .width(Constants.FULL_PARENT)
  .height($r('app.string.lpx_80'))
  .margin({top: $r('app.string.lpx_24')})
  .placeholderFont({ size: lpx2fp(24)})
  .placeholderColor($r('app.color.color_999999'))
  .fontSize(lpx2fp(24))
  .fontColor($r('app.color.color_333333'))
  .caretColor($r('app.color.color_EB4F3A'))
  .backgroundColor($r('app.color.color_F7F8FC'))
  .borderRadius($r('app.string.lpx_12'))
  .padding({left:$r('app.string.lpx_20'),right: $r('app.string.lpx_20')})
}