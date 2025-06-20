/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: BaseReq
 * Author: Victor
 * Date: 2024/05/14 17:14
 * Description: 
 * -----------------------------------------------------------------
 */

export class BaseReq<T> {
 code: number = 0//0 成功，否则失败
 msg?: string//请求失败的错误信息
 message?: string//请求失败的错误信息
 data?: T
}