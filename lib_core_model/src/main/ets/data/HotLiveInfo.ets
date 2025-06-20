/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HotLiveInfo
 * Author: Victor
 * Date: 2024/04/15 15?:25
 * Description:
 * -----------------------------------------------------------------
 */
export class HotLiveInfo {
  imgUrl?: string//直播封面URL
  inviteUrl?: string//邀课链接
  liveRoomId?: string//liveRoomId
  name?: string//直播间名称
  status?: number//直播状态：0-未开始，1-直播中，2-直播中端，9-直播结束
  totalLikes?: number//点赞数
  teacherNames?: Array<string>//讲师
}