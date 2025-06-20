import { GoodsSpecInfo } from './GoodsSpecInfo'

export class GoodsSpecData {
  chosenSpecId?: string // 已经选中的规格（购物车）
  contentName?: string // 商品标题
  coverUrl?: string //图片路径url
  goodsId?: string //商品编号
  goodsNum?: number //商品数量
  peopleNum?: number //可参与人数
  lecturerLabel?: string //教师标签
  lecturerName?: string //教师名字
  marketPrice?: number //划线价格
  salePrice?: number //售卖价格
  onlineFlag?: number //线上线下标志
  specList?: Array<GoodsSpecInfo>
}