import { router } from '@kit.ArkUI'
import App from 'lib_core_model/src/main/ets/App'
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData'
import { OrderDetailData } from 'lib_core_model/src/main/ets/data/OrderDetailData'
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig'
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath'

class PayOrderActionUtil {
  tag: string = 'PayOrderActionUtil'

  /**
   * 跳转到支付页面
   * @param orderDetailData 订单数据
   */
  payOrder(orderDetailData: OrderDetailData) {
    AppConfig.getLoginData()
      .then((data: LoginData) => {
        if (data.token == null) {
          App.get().pushUrl({ url: RouterPath.CODE_LOGIN_PAGE }, router.RouterMode.Single)
        } else {
          App.get().pushUrl({ url: RouterPath.PAY_ORDER_PAGE, params: { data: orderDetailData } })
        }
      })
      .catch(() => {
        App.get().pushUrl({ url: RouterPath.CODE_LOGIN_PAGE }, router.RouterMode.Single)
      })
  }
}

export default new PayOrderActionUtil()