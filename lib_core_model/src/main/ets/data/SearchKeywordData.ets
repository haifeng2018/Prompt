/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: SearchKeywordData
 * Author: Victor
 * Date: 2023/11/29 17:10
 * Description: 
 * -----------------------------------------------------------------
 */
import { GoodsInfo } from './GoodsInfo'
import { LecturerInfo } from './LecturerInfo'
import { ListData } from './ListData'

export class SearchKeywordData {
  goodsInfoVoPageVo?: ListData<GoodsInfo>
  lecturerVoPageVo?: ListData<LecturerInfo>
}