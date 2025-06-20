/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: LatestVersionData
 * Author: Victor
 * Date: 2023/12/06 19?:54
 * Description:
 * -----------------------------------------------------------------
 */
export class LatestVersionData {
  content?: string//更新内容
  downloadUrl?: string//下载链接
  title?: string//更新标题
  updateSetting?: number//更新场景 1：强制更新 2：可选更新 3：不更新
  version?: string//版本号
}