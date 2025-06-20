/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ModifyBindPhoneDialog
 * Author: Victor
 * Date: 2022/12/8 15:14
 * Description: 
 * -----------------------------------------------------------------
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';

@CustomDialog
export default struct ModifyBindPhoneDialog {
  controller: CustomDialogController;
  scroller: Scroller = new Scroller()
  @State scrollToBottom: boolean = false

  cancel: () => void = () => {
  };

  confirm: () => void = () => {
  };

  build() {
    Column() {
      Text('用户修改手机号服务协议')
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_108'))
        .fontColor($r('app.color.color_333333'))
        .fontSize(lpx2fp(36))
        .textAlign(TextAlign.Center)

      Scroll(this.scroller) {
        Text('1.1  用户注册、登录以及实际使用本网站提供的服务时，应当是具备完全民事权利能力和完全民事行为能力的自然人、法人或其他组织。若用户是未成年人，必须在征得父母或其他监护人同意的前提下使用本网站提供的服务。若用户是未满14周岁的未成年人，必须在取得父母或其他监护人对《儿童个人信息保护政策及监护人须知》的同意后，才可以在监护人的指导下使用本提供的服务。如用户不具备前述主体资格，则用户及用户的监护人应当依照法律规定承担因此而导致的一切后果，我们有权注销或永久冻结用户的账户。\n\n1.2  用户更换手机号码是用户的主动行为，我方已经多次与客户进行了确认通知和确认，且此操作不可逆，用户同意了协议即代表用户已经非常清楚当前操作为用户的主动行为。\n\n1.3  用户使用具体服务时，我们可能会要求用户完成进一步激活或验证流程，用户应当按照相应页面的提示提供身份信息及资料，并应保证提供的身份信息及资料真实、及时、完整和准确。 用户应妥善保管用户手机短信验证码，避免透露给他人使用。用户账号和验证码不得出借、转让、继承或者赠与。因非本网站原因导致用户的账号、验证码遗失、遗忘或被他人窃取的，本网站不承担责任。如果用户发现自己的个人信息泄密，尤其是本网站账户及验证码发生泄露，请立即联络我们。')
          .width(Constants.FULL_PARENT)
          .fontColor($r('app.color.color_333333'))
          .fontSize(lpx2fp(28))
          .lineHeight($r('app.string.lpx_40'))
      }
      .width(Constants.FULL_PARENT)
      .height($r('app.string.lpx_750'))
      .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
      .scrollBar(BarState.On) // 滚动条常驻显示
      .scrollBarColor(`${$r('app.color.color_D8D8D8')}`) // 滚动条颜色
      .scrollBarWidth(`${$r('app.string.lpx_8')}`) // 滚动条宽度
      .edgeEffect(EdgeEffect.None)
      .onScrollEdge((side: Edge) => {
        console.info('To the edge')
        if (side === Edge.Bottom) {
          this.scrollToBottom = true
        }
      })

      Text(this.scrollToBottom ? '我已阅读完毕且同意协议' : '阅读至底部')
        .enabled(this.scrollToBottom)
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({ top: $r('app.string.lpx_40') })
        .backgroundColor($r('app.color.color_EB4F3A'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.white'))
        .fontSize(lpx2fp(28))
        .textAlign(TextAlign.Center)
        .opacity(this.scrollToBottom ? 1 : 0.5)
        .onClick(() => {
          this.controller.close()
          this.confirm()
        })

      Text('我再想想')
        .enabled(this.scrollToBottom)
        .width(Constants.FULL_PARENT)
        .height($r('app.string.lpx_88'))
        .margin({ top: $r('app.string.lpx_40') })
        .backgroundColor($r('app.color.color_EAEAEA'))
        .borderRadius($r('app.string.lpx_16'))
        .fontColor($r('app.color.color_777777'))
        .fontSize(lpx2fp(28))
        .textAlign(TextAlign.Center)
        .opacity(this.scrollToBottom ? 1 : 0.5)
        .onClick(() => {
          this.controller.close()
          this.cancel()
        })
    }
    .width(Constants.FULL_PARENT)
    .borderRadius({
      topLeft: $r('app.string.lpx_20'),
      topRight: $r('app.string.lpx_20')
    })
    .backgroundColor(Color.White)
    .padding({
      bottom: $r('app.string.lpx_40'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }
}
