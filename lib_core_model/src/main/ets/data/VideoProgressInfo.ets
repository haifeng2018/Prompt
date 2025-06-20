export class VideoProgressInfo {
  createTime?: string
  duration?: number // 播放时长
  goodsId?: string // 商品编号
  id?: number
  lastPosition?: number // 上一次播放时间，单位秒
  materialId?: string // 视频编号
  updateTime?: string
  userId?: string // 用户编号
  accumulatedDuration?: number // 累计播放时长
  platformUserId?: number // 平台用户ID
  subOrderId?: number // 子订单编号
}