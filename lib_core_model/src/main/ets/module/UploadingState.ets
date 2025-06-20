/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: UploadingState
 * Author: Victor
 * Date: 2023/12/05 10:32
 * Description: 
 * -----------------------------------------------------------------
 */
export const enum UploadingState {
  PROGRESS = 'progress',
  COMPLETE = 'complete',
  HEADER_RECEIVE = 'headerReceive',
  FAIL = 'fail'
}