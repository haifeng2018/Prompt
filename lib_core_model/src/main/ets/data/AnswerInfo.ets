/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: AnswerInfo
 * Author: Victor
 * Date: 2024/04/01 19:13
 * Description: 
 * -----------------------------------------------------------------
 */
import { ExerciseInfo } from './ExerciseInfo'
export class AnswerInfo {
  answer?: string//回答
  headImg?: string//投降
  userName?: string//用户名字
  userId?: string//用户id
  recommendFlag?: number//是否推荐
  createTime?: number//创建时间

  mExerciseInfo?: ExerciseInfo
}