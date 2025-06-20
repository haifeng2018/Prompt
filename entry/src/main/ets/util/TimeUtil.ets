const MILLISECONDS_PER_MINUTE = 60000;
const MILLISECONDS_PER_SECOND = 1000;
const LEADING_ZERO_THRESHOLD = 10;

/**
 * 转换时间所用常量.
 */
const TIME_UNIT: number = 60;
/**
 * 时间片段.
 */
const INITIAL_TIME_UNIT: string = '00';

/**
 * 每个片段所占字符个数.
 */
const PADDING_LENGTH: number = 2;

/**
 * 占位符.
 */
const PADDING_STR: string = '0';

class TimeUtil {
  getHMS(duration: number): string {
    let h = Math.trunc(duration / 60 / 60)
    let m = Math.trunc(duration / 60)
    let s = Math.trunc(duration % 60)
    let hour = h < 10 ? `0${h}` : `${h}`
    let min = m < 10 ? `0${m}` : `${m}`
    let sec = s < 10 ? `0${s}` : `${s}`

    return `${hour}:${min}:${sec}`
  }

  timeConvert(milliseconds: number): string {
    const minutes = Math.floor(milliseconds / MILLISECONDS_PER_MINUTE);
    const seconds = Math.floor((milliseconds % MILLISECONDS_PER_MINUTE) / MILLISECONDS_PER_SECOND);
    return `${minutes}:${seconds < LEADING_ZERO_THRESHOLD ? '0' : ''}${seconds}`;
  }

  secondToTime(seconds: number): string {
    let hourUnit = TIME_UNIT * TIME_UNIT;
    let hour = Math.floor(seconds / hourUnit);
    let minute = Math.floor((seconds - hour * hourUnit) / TIME_UNIT);
    let second = seconds - hour * hourUnit - minute * TIME_UNIT;
    if (hour > 0) {
      return `${this.padding(hour.toString())}${':'}
        ${this.padding(minute.toString())}${':'}${this.padding(second.toString())}`;
    }
    if (minute > 0) {
      return `${this.padding(minute.toString())}${':'}${this.padding(second.toString())}`;
    } else {
      return `${INITIAL_TIME_UNIT}${':'}${this.padding(second.toString())}`;
    }
  }

  /**
   * 增加占位符.
   */
  private padding(num: string): string {
    let length = PADDING_LENGTH;
    for (let len = (num.toString()).length; len < length; len = num.length) {
      num = `${PADDING_STR}${num}`;
    }
    return num;
  }
}

export default new TimeUtil()