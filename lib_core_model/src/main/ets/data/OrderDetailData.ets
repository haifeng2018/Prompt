import { SubOrderInfo } from './SubOrderInfo'

export class OrderDetailData {
  channelSource?: number // 渠道来源：1.抖店，2.快手，3.获客 4:微店 12:抖音小程序
  createTime?: string // 创建时间
  discountsFee?: number // 优惠金额【单位：分】
  transferFee?: number // 转课金额【单位：分】
  balanceFee?: number // 订单金额【单位：分】
  refundedFee?: number // 退款金额【单位：分】
  goodsNum?: number // 购买商品数量
  goodsTotalFee?: number // 商品总价【单位：分】
  orderNo?: string // 订单号
  orderStatus?: number //	订单状态 1?:未支付 2?:支付成功 3?:超时已关闭 4?:用户已取消 5?:退款中 6?:部分退款 7?:全部退款 8?:交易结束 9?:没有向第三方发起支付请求 10?:退款金额异常
  payerTotal?: number // 支付金额【单位：分】
  paymentType?: number // 支付类型 1?:微信 2?:阿里 3?:赠送 4?:抖店支付 5?:快手支付 6?:获客币支付
  tradeType?: number // 交易类型 1?:app 2?:小程序 3?:H5
  transactionId?: string // 支付系统交易单号
  orderTimeout?: number // 支付剩余时间 毫秒
  updateTime?: number // 更新时间
  payTime?: number // 支付时间
  changedPrice?: Boolean = false // 是否改价
  subOrderVos?: Array<SubOrderInfo>
  tenantId?: number
  isShowInvoiceButton?: boolean // 发票服务是否显示
  isShowLogistics?: boolean // 物流服务是否显示
  invoiceAmount?: number // 订单金额【单位：分】
}