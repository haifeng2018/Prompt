/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ChangePerssionLogInfo
 * Author: Victor
 * Date: 2024/07/03 15:57
 * Description: 
 * -----------------------------------------------------------------
 */

export class ChangePerssionLogInfo {
  subOrderId?: number//子订单id
  showChangePerssionLog?: boolean//是否显示换人就读日志
  phone?: string//换人就读后手机号码
  operateTime?: string//操作时间
  operateBy?: number//操作人类型 1 当前账号; 2,客服
  imgUrl?: Array<string>//图片地址
}