/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AuthApi
 * Author: Victor
 * Date: 2023/11/20 18:48
 * Description: 
 * -----------------------------------------------------------------
 */
export class AuthApi {
  static readonly ACTIVATE_SMS = 'cloud/edata-customer/user/user/activate/sms/send/code'
  static readonly VOICE_CODE = 'cloud/edata-customer/user/user/activate/voice/send/code'
  static readonly CODE_LOGIN = 'cloud/edata-customer/user/login/byCode'
  static readonly LOGOUT = 'cloud/edata-customer/user/pf/logout'

  static readonly SEND_SMS = 'cloud/edata-customer/user/login/verification/code'
  static readonly PHONE_MODIFY_COUNT = 'cloud/edata-cms/app/phone/h5/get/modify/num'
  static readonly MODIFY_PHONE_CODE = 'cloud/edata-cms/app/phone/h5/send/code'
  static readonly MODIFY_PHONE_CODE_CHECK = 'cloud/edata-cms/app/phone/h5/check/code'
  static readonly NEW_PHONE_CODE = 'cloud/edata-cms/app/phone/h5/send/newPhone/code'
  static readonly MODIFY_PHONE = 'cloud/edata-cms/app/phone/h5/modify'
  static readonly CANCEL_ACCOUNT_CODE = 'cloud/user/pf/logoff/code'
  static readonly CANCEL_ACCOUNT = 'cloud/user/pf/logoff'
}