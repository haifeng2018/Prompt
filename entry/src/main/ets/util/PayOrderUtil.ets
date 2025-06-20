import AmountUtil from 'lib_common/src/main/ets/util/AmountUtil'
import { CoverUrlExtendInfo } from 'lib_core_model/src/main/ets/data/CoverUrlExtendInfo'
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo'
import { GoodsSpecData } from 'lib_core_model/src/main/ets/data/GoodsSpecData'
import { OrderDetailData } from 'lib_core_model/src/main/ets/data/OrderDetailData'
import { RecommendCouponData } from 'lib_core_model/src/main/ets/data/RecommendCouponData'
import { SubOrderInfo } from 'lib_core_model/src/main/ets/data/SubOrderInfo'
import { BuySource, CommonNumbers } from 'lib_core_model/src/main/ets/util/Enums'
import Logger from 'lib_core_model/src/main/ets/util/Logger'

class PayOrderUtil {
  tag: string = 'PayOrderUtil'

  getOnlineOrderDetailData(
    paymentSource: BuySource,
    goodsInfo: GoodsInfo | null
  ) {
    Logger.info(this.tag, `goodsInfo = ${JSON.stringify(goodsInfo)}`)
    // 创建订单数据
    let data = new OrderDetailData()
    data.goodsTotalFee = goodsInfo?.salePrice ?? 0
    data.payerTotal = goodsInfo?.salePrice ?? 0
    data.goodsNum = CommonNumbers.One
    // 初始换子订单
    let subOrderVos = Array<SubOrderInfo>()
    let item = new SubOrderInfo()
    // 初始化封面图
    if (paymentSource == BuySource.CourseDetail) {
      if ((goodsInfo?.coverUrlExtendVos?.length ?? 0) > 0) {
        item.coverUrlExtendVo = goodsInfo?.coverUrlExtendVos![0]
      }
    } else if (paymentSource == BuySource.CourseList) {
      let coverUrlExtendVo = new CoverUrlExtendInfo()
      coverUrlExtendVo.centre = goodsInfo?.coverVerticalUrl
      item.coverUrlExtendVo = coverUrlExtendVo
    }
    item.couponDiscountsFee = 0
    item.goodsName = goodsInfo?.contentName
    item.goodsId = goodsInfo?.goodsId
    item.goodsPrices = goodsInfo?.salePrice || 0
    item.goodsNum = CommonNumbers.One
    item.goodsMode = goodsInfo?.onlineFlag || 0
    item.tenantId = goodsInfo?.tenantVO?.tenantId
    subOrderVos.push(item)
    data.subOrderVos = subOrderVos
    return data
  }

  getOfflineOrderDetailData(
    paymentSource: BuySource,
    goodsInfo?: GoodsInfo | null,
    goodsSpecData?: GoodsSpecData | null,
    specName?: string,
    specId?: string,
    inputCount: number = 1
  ): OrderDetailData {
    Logger.info(this.tag, `goodsInfo = ${JSON.stringify(goodsInfo)}`)
    // 创建订单数据
    let data = new OrderDetailData()
    let specSalePrice = this.getSalePrice(specId, goodsSpecData)
    data.goodsTotalFee = specSalePrice * inputCount // 商品总价(单位：分)
    data.payerTotal = specSalePrice * inputCount // 支付金额(单位：分)
    data.goodsNum = goodsSpecData?.goodsNum ?? 0 // 购买商品数量
    // 初始换子订单
    let subOrderVos = Array<SubOrderInfo>()
    let item = new SubOrderInfo()
    // 初始化封面图
    let coverUrlExtendVo = new CoverUrlExtendInfo()
    if (paymentSource == BuySource.CourseDetail) {
      let contentUrl: string = goodsInfo?.contentUrl ?? ''
      if (contentUrl.includes(",")) {
        let urls = contentUrl?.split(",")
        contentUrl = urls[0]
      }
      if (contentUrl) {
        coverUrlExtendVo.centre = contentUrl ?? ''
      } else {
        // 线下课选择规格购买时
        coverUrlExtendVo.centre = goodsSpecData?.coverUrl
      }

    } else if (paymentSource == BuySource.CourseList) {
      coverUrlExtendVo.centre = goodsInfo?.coverVerticalUrl
    }
    item.coverUrlExtendVo = coverUrlExtendVo
    item.couponDiscountsFee = 0
    item.goodsName = goodsInfo?.contentName
    item.goodsId = goodsInfo?.goodsId
    item.goodsPrices = specSalePrice
    item.goodsNum = inputCount
    item.goodsMode = goodsSpecData?.onlineFlag ?? 0
    item.specName = specName
    item.specId = specId
    item.tenantId = goodsInfo?.tenantVO?.tenantId ? goodsInfo?.tenantVO?.tenantId : goodsInfo?.tenantId
    subOrderVos.push(item)
    data.subOrderVos = subOrderVos
    return data
  }

  getSalePrice(specId?: string, goodsSpecData?: GoodsSpecData | null) {
    let salePrice = goodsSpecData?.salePrice ?? 0
    let result = goodsSpecData?.specList?.find((item) => {
      item.specId == specId
    })
    if (result) {
      salePrice = result.salePrice ?? 0
    }
    return salePrice
  }

  getCouponTip(data?: RecommendCouponData | null): string {
    const count = data?.userCouponPageVos?.length ?? 0
    const discountFeeStr = AmountUtil.getRoundUp((data?.discountFee ?? 0) / 100, 2)
    return `已选中推荐优惠，使用优惠券 ${count} 张，共抵`
  }

  getCouponSpanTip(data?: RecommendCouponData | null): string {
    const discountFeeStr = AmountUtil.getRoundUp((data?.discountFee ?? 0) / 100, 2)
    return `¥${discountFeeStr}`
  }
}

export default new PayOrderUtil()