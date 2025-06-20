/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: NotificationInfo
 * Author: Victor
 * Date: 2023/12/21 16:09
 * Description:
 * -----------------------------------------------------------------
 */
export class NotificationInfo {
  appId?: string
  content?: string
  extraParams?: string
  id?: number
  msgType?: number
  tenantId?: number
  signStatus?: number // 签收状态,1未签收，2已签收
  sendTime?: number
  userId?: string
}