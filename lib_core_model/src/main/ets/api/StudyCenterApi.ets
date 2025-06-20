/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: StudyCenterApi
 * Author: Victor
 * Date: 2023/11/22 15:15
 * Description: 
 * -----------------------------------------------------------------
 */
export class StudyCenterApi {
  static readonly SUMMARY_STUDY = 'cloud/user/learning/today/summary/study'
  static readonly LAST_STUDY = 'cloud/user/learning/last/study'
  static readonly LEARNING = 'cloud/user/learning/list'
  static readonly WATCH_HISTORY = 'cloud/user/user-progress/page'
  static readonly LEARNING_PAGE = 'cloud/user/learning/online/page'
  static readonly PRACTICE = 'cloud/user/user-practice/status/'
  static readonly USER_MATERIAL = 'cloud/user/user-material/list'
  static readonly MATERIAL_DETAIL = 'cloud/user/user-material/goods/'
  static readonly COURSE_PRACTICE = 'cloud/user/user-practice/goods/'
  static readonly EXERCISE_ANSWER = 'cloud/user/user-practice/answer'
  static readonly ANSWER_PAGE = 'cloud/user/user-practice/user-answer/page'
}