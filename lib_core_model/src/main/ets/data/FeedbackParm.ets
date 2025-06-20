/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: FeedbackParm
 * Author: Victor
 * Date: 2023/12/06 10:53
 * Description:
 * -----------------------------------------------------------------
 */
export class FeedbackParm {
  messageContent?: string //问题描述
  messageImages?: Array<string> //留言上传的图片，多张以英文逗号分割
  phone?: string //手机号
  code?: string // 验证码
  type?: number //分类：1售前咨询，2售后，3问题反馈,示例值(1)
  userId?: string
  username?: string //姓名
}