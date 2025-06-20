/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: StudyCenterAvatarUtil
 * Author: Victor
 * Date: 2023/11/20 16:13
 * Description: 
 * -----------------------------------------------------------------
 */
class StudyCenterAvatarUtil {

  getRandomIntInclusive(min: number, max: number): number {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive
  }

  getRandomAvatar(): Resource {
        let avatars = [
        $r('app.media.ic_study_center_avatar1'),
        $r('app.media.ic_study_center_avatar2'),
        $r('app.media.ic_study_center_avatar3'),
        $r('app.media.ic_study_center_avatar4'),
        $r('app.media.ic_study_center_avatar5')
        ]

        let randomIndex = this.getRandomIntInclusive(0,avatars.length - 1)
        return avatars[randomIndex]
    }
}

export default new StudyCenterAvatarUtil()