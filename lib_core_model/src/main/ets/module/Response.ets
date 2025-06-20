/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: Response
 * Author: Victor
 * Date: 2024/06/25 14:12
 * Description: 
 * -----------------------------------------------------------------
 */

export class Response {
  code: number = 0//0 成功，否则失败
  msg?: string | Resource//请求失败的错误信息
  message?: string | Resource//请求失败的错误信息
  data?:  string | Object | ArrayBuffer
}