/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LoginData
 * Author: Victor
 * Date: 2023/11/20 16:43
 * Description:
 * -----------------------------------------------------------------
 */
export class LoginData {
  id?: number
  name?: string//用户名称
  phone?: string//手机号 【如果是微信授权登录，当返回手机号为空时，请让用户绑定手机号再重新请求】
  token?: string//用户token
  type?: number//用户类型
}