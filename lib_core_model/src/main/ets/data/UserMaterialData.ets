/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: UserMaterialData
 * Author: Victor
 * Date: 2023/12/01 17:05
 * Description: 
 * -----------------------------------------------------------------
 */
import { MaterialInfo } from './MaterialInfo'
export class UserMaterialData {
  goodsId?: string
  lecturerLabel?: string
  lecturerName?: string
  contentName?: string //名称
  materialInfoVoList?: Array<MaterialInfo>
}