import { ChangePerssionLogInfo } from './ChangePerssionLogInfo'
import { CoverUrlExtendInfo } from './CoverUrlExtendInfo'

export class SubOrderInfo {
  id?: number // 子订单id
  afterSaleStatus?: number // 售后状态 1?:可申请 2?: 申请中 3?: 已完成 4?:用户关闭 5?:超时关闭 6?: 拒绝退款
  discountsFee?: number // 优惠金额【单位：分】
  changedDiscountsFee ?: number // 改价金额【单位：分】
  commentFlag?: Boolean = false // 是否评论 0?:未评论 1?:已评论
  coverUrl?: string // 横版封面存储路径
  effectiveTime?: number // 生效时间
  failureTime?: number // 失效时间
  updateTime?: number // 更新时间（支付时间）
  afterSaleTime?: number // 申请售后截止时间
  specId?: string // 规格id
  goodsId?: string // 商品id
  specName?: string // 商品规格（暂未提供）
  goodsMode?: number // 商品模式 0?:线上 1?:线下
  goodsNum?: number // 购买商品数量
  goodsPrices?: number // 商品价格【单位：分】
  goodsTotalFee?: number // 商品总价【单位：分】
  couponDiscountsFee?: number // 优惠金额【单位：分】
  goodsType?: number // 商品类型
  payerTotal?: number // 支付金额【单位：分】
  goodsName?: string // 商品名称
  // 订单状态
  // 1?:未支付 2?:支付成功 3?:超时已关闭 4?:用户已取消 5?:退款中 6?:部分退款
  // 7?:全部退款 8?:退款异常 9?:没有向第三方发起支付请求 => 未支付 10?:退款金额异常 => 已完成 11?:部分付款  => 部分付款 12?:转课关闭 => 已完成
  orderStatus?: number
  withVideo?: boolean // 线下课是否带视频 true-带 false-不带
  hasChangePermission?: boolean
  coverUrlExtendVo?: CoverUrlExtendInfo
  balanceFee?: number //订单余额【单位：分】
  quantity?: number
  changePerssionLogVo?: ChangePerssionLogInfo
  tenantId?: number
}