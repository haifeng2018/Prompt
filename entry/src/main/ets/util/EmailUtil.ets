/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: EmailUtil
 * Author: Victor
 * Date: 2024/07/12 14:36
 * Description: 
 * -----------------------------------------------------------------
 */
import { BusinessError } from '@kit.BasicServicesKit'

class EmailUtil {
  isValidEmail(email: string): Boolean {
    let isValidEmail = false
    const emailRegex = RegExp('[a-zA-Z0-9+._%/-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}'    )
    isValidEmail = emailRegex.test(email)
    return isValidEmail
  }
}

export default new EmailUtil()