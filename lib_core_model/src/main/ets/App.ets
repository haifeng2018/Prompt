/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: App
 * Author: Victor
 * Date: 2023/12/07 18:22
 * Description: 
 * -----------------------------------------------------------------
 */
import HashMap from '@ohos.util.HashMap';
import router from '@ohos.router';
import Logger from './util/Logger';
import RouterPath from './util/RouterPath';

export class App {
  private TAG = 'App'
  private static instance: App
  private routerLaunchMap = new HashMap<string,string>()

  private constructor() {
    // 私有构造函数，防止外部实例化
  }

  public static get(): App {
    if (!App.instance) {
      App.instance = new App()
    }
    return App.instance
  }

  pushUrl(options: router.RouterOptions, mode?: router.RouterMode) {
    Logger.error(this.TAG,`pushUrl-url = ${options.url}`)
    this.routerLaunchMap.set(options.url,options.url)
    router.pushUrl(options,mode ? mode : router.RouterMode.Standard).catch((error ? : '') => {
      Logger.error(this.TAG, `pushUrl error = ${JSON.stringify(error)}`);
    });

    this.logLaunchRouter()
  }

  replaceUrl(options: router.RouterOptions, mode?: router.RouterMode) {
    Logger.error(this.TAG,`replaceUrl-url = ${options.url}`)

    this.routerLaunchMap.set(options.url,options.url)

    router.replaceUrl(options,mode ? mode : router.RouterMode.Standard).catch((error ? : '') => {
      Logger.error(this.TAG, `replaceUrl error = ${JSON.stringify(error)}`);
    });

    this.logLaunchRouter()
  }

  back() {
    let path = router.getState().path
    let name = router.getState().name
    let url = `${path}${name}`
    this.routerLaunchMap.remove(url)

    router.back()
    Logger.error(this.TAG,`back-url = ${url}`)
    this.logLaunchRouter()
  }

  backUrl(url: string) {
    this.routerLaunchMap.remove(url)
    router.back({
      url: url
    })
    Logger.error(this.TAG,`backRouter-url = ${url}`)
    this.logLaunchRouter()
  }

  backOtherThenMainPage() {
    this.routerLaunchMap.forEach((value, key: string) => {
      Logger.error(this.TAG,`backOtherThenMainPage-key = ${key}`)
      if (key != RouterPath.MAIN_PAGE) {
        this.backUrl(key)
      }
    })
  }

  logLaunchRouter() {
    Logger.error(this.TAG,`logLaunchRouter-length = ${this.routerLaunchMap.length}`)
    this.routerLaunchMap.forEach((value, key) => {
      Logger.error(this.TAG,`logLaunchRouter-key = ${key}`)
      Logger.error(this.TAG,`logLaunchRouter-value = ${value}`)
    });
  }
}

export default App