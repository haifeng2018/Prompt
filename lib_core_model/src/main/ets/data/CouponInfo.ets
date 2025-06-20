@Observed
export class CouponInfo {
  claimStatus?: number //1.未领取;2已经领取;
  auditStatus?: number //审核状态(1?:待初审，2?:初审驳回，3?:待复审，4?:复审驳回，5?:已通过)
  claimCount?: number //每人限领数量
  closeExpireStatus?: number //1.否.2是即将过期
  couponStatus?: number //当前状态(1?:待核销，2?:已锁定，3?:已核销，4?:已作废)
  couponType?: number //优惠券种类(1?:商品券，2?:店铺券，3?:直播券)
  claimAppId?: string //领取应用
  claimStartTime?: string //领取开始时间
  claimEndTime?: string //领取截止时间
  claimTime?: string //领券时间
  couponContent?: string //优惠券内容
  couponName?: string //优惠券名称
  couponNo?: string //优惠券编码
  couponUseStartTime?: string //优惠券使用开始时间
  couponUseEndTime?: string //优惠券使用截止时间
  createdAt?: string //优惠券使用截止时间
  directDiscountAmount?: number //直减,discountMethod为2使用
  discountMethod?: number //优惠方式(1?:满减，2?:直减，3?:折扣)
  expireDays?: number //领取过有效天数
  fullAmount?: number //满多少的值,discountMethod为1使用
  fullDiscountAmount?: number //满多少的值,discountMethod为1使用
  issueCount?: number //发放数量
  useStatus?: number //使用状态(1?:待开始，2?:生效中，3?:已过期，4?:已作废)
  discount?: number //折扣,discountMethod为3使用
  discountContent?: string //优惠信息
  nickName?: string //用户昵称
  useStartTime?: string //使用开始时间
  useEndTime?: string //使用截止时间
  userCouponNo?: string //用户优惠券编码
  userId?: string //用户ID
  writeOffTime?: string //核销时间
  //调用选择优惠券接口才有返回
  enabledStatus?: number //能否使用，1否，2是
}