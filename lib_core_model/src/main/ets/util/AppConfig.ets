/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AppConfig
 * Author: Victor
 * Date: 2023/11/20 16:51
 * Description: 
 * -----------------------------------------------------------------
 */
import { LoginData } from '../data/LoginData'
import { UserInfo } from '../data/UserInfo'
import { Constants } from './Constants'
import PreferenceUtil from './PreferenceUtil'


class AppConfig {

  async reSetLoginData() {
    let value = await PreferenceUtil.put(Constants.LOGIN_DATA_KEY,'')
    return value
  }

  async reSetUserInfoData() {
    let value = await PreferenceUtil.put(Constants.USER_INFO_DATA_KEY,'')
    return value
  }

  async setLoginData(data: LoginData) {
    let value = await PreferenceUtil.put(Constants.LOGIN_DATA_KEY,JSON.stringify(data))
    return value
  }

  async setUserInfo(data: UserInfo) {
    let value = await PreferenceUtil.put(Constants.USER_INFO_DATA_KEY,JSON.stringify(data))
    return value
  }

  async getLoginData() {
    let value = await PreferenceUtil.getString(Constants.LOGIN_DATA_KEY)
    if (value) {
      return JSON.parse(value);
    }
    return null
  }

  async getUserInfo() {
    let value = await PreferenceUtil.getString(Constants.USER_INFO_DATA_KEY)
    if (!value) {
      return new UserInfo()
    }
    return JSON.parse(value);
  }

  example() {
    let data = new LoginData();
    data.id = 423099
    data.type = 6
    data.name = 'cherry'
    data.phone = '18813938924'
    data.token = 'token_66455'
    this.setLoginData(data)


    this.getLoginData().then((resultData: LoginData) => {
      // ToastUtils.show(`loginData = ${JSON.stringify(resultData)}`)
    });
  }
}

export default new AppConfig()