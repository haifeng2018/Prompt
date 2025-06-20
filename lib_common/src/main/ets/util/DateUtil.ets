/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: DateUtil
 * Author: Victor
 * Date: 2023/3/23 15:59
 * Description: 
 * -----------------------------------------------------------------
 */
import { Constants } from 'lib_core_model/src/main/ets/util/Constants'
import Logger from 'lib_core_model/src/main/ets/util/Logger'

class DateUtil {

 getTimestamp(): number {
   let outDate = new Date()
   return outDate.getTime()
  }

  getLocalDate(inputDate: string): Date {
   Logger.error(`getLocalDate-inputDate =  ${inputDate}`)
   let outDate = new Date(inputDate)
   return outDate
  }

  getToday(): Date {
   let outDate = new Date()
   return outDate
  }

  getDate18YearAgo(): Date {
   let today = this.getToday()
   let year = today.getFullYear() - 18
   let outDate = new Date(`${year}-1-1`)
   return outDate
  }

  getLocalDateByNumber(inputDate: number): Date {
   Logger.error(`getLocalDate-inputDate =  ${inputDate}`)
   let outDate = new Date(inputDate)
   return outDate
  }

 getDiffDay(time1: number,time2: number) {
  let diff = Math.abs(time1 - time2)
  let diffDay = diff / (24 * 60 * 60 * 1000)
  return Math.floor(diffDay)
 }

  transDate(inputDate: string): string {
   Logger.error(`transDate-inputDate =  ${inputDate}`)
   let date = this.getLocalDate(inputDate)

   let year = date.getFullYear().toString()
   let month = date.getMonth() + 1
   let day = date.getDate()

   let monthStr = month.toString()
   if (month < 10) {
    monthStr = "0" + month
   }

   let dayStr = day.toString()
   if (day < 10) {
    dayStr = "0" + day
   }
   let outputDate = `${year}-${monthStr}-${dayStr}`
   Logger.error(`transDate-outputDate =  ${outputDate}`)
   return outputDate
  }

  transNumberDate(inputDate: number): string {
   Logger.error(`transDate-inputDate =  ${inputDate}`)
   let date = this.getLocalDateByNumber(inputDate)

   let year = date.getFullYear().toString()
   let month = date.getMonth() + 1
   let day = date.getDate()

   let monthStr = month.toString()
   if (month < 10) {
    monthStr = "0" + month
   }

   let dayStr = day.toString()
   if (day < 10) {
    dayStr = "0" + day
   }
   let outputDate = `${year}-${monthStr}-${dayStr}`
   Logger.error(`transDate-outputDate =  ${outputDate}`)
   return outputDate
  }

  transBirthdayDate(inputDate: number): string {
   Logger.error(`transDate-inputDate =  ${inputDate}`)
   let date = this.getLocalDateByNumber(inputDate)

   let year = date.getFullYear().toString()
   let month = date.getMonth() + 1
   let day = date.getDate()

   let monthStr = month.toString()
   if (month < 10) {
    monthStr = "0" + month
   }

   let dayStr = day.toString()
   if (day < 10) {
    dayStr = "0" + day
   }
   let outputDate = `${year}.${monthStr}.${dayStr}`
   Logger.error(`transDate-outputDate =  ${outputDate}`)
   return outputDate
  }

  transDateHM(inputDate: string): string {
   Logger.error(`transDateHM-inputDate =  ${inputDate}`)
   let date = this.getLocalDate(inputDate)

   let year = date.getFullYear().toString()
   let month = date.getMonth() + 1
   let day = date.getDate()
   let hours = date.getHours()
   let mins = date.getMinutes()

   let monthStr = month.toString()
   if (month < 10) {
    monthStr = "0" + month
   }

   let dayStr = day.toString()
   if (day < 10) {
    dayStr = "0" + day
   }

   let hoursStr = hours.toString()
   if (hours < 10) {
    hoursStr = "0" + hours
   }

   let minsStr = mins.toString()
   if (mins < 10) {
    minsStr = "0" + mins
   }

   let outputDate = `${year}-${monthStr}-${dayStr} ${hoursStr}:${minsStr}`
   Logger.error(`transDateHM-outputDate =  ${outputDate}`)
   return outputDate
  }

  transNumberDateHM(inputDate: number): string {
   Logger.error(`transDateHM-inputDate =  ${inputDate}`)
   let date = this.getLocalDateByNumber(inputDate)

   let year = date.getFullYear().toString()
   let month = date.getMonth() + 1
   let day = date.getDate()
   let hours = date.getHours()
   let mins = date.getMinutes()

   let monthStr = month.toString()
   if (month < 10) {
    monthStr = "0" + month
   }

   let dayStr = day.toString()
   if (day < 10) {
    dayStr = "0" + day
   }

   let hoursStr = hours.toString()
   if (hours < 10) {
    hoursStr = "0" + hours
   }

   let minsStr = mins.toString()
   if (mins < 10) {
    minsStr = "0" + mins
   }

   let outputDate = `${year}-${monthStr}-${dayStr} ${hoursStr}:${minsStr}`
   Logger.error(`transDateHM-outputDate =  ${outputDate}`)
   return outputDate
  }

  transDateHMS(inputDate: string): string {
   Logger.error(`transDateHM-inputDate =  ${inputDate}`)
   let date = this.getLocalDate(inputDate)

   let year = date.getFullYear().toString()
   let month = date.getMonth() + 1
   let day = date.getDate()
   let hours = date.getHours()
   let mins = date.getMinutes()
   let secs = date.getSeconds()

   let monthStr = month.toString()
   if (month < 10) {
    monthStr = "0" + month
   }

   let dayStr = day.toString()
   if (day < 10) {
    dayStr = "0" + day
   }

   let hoursStr = hours.toString()
   if (hours < 10) {
    hoursStr = "0" + hours
   }

   let minsStr = mins.toString()
   if (mins < 10) {
    minsStr = "0" + mins
   }

   let secsStr = secs.toString()
   if (secs < 10) {
    secsStr = "0" + secs
   }
   let outputDate = `${year}-${monthStr}-${dayStr} ${hoursStr}:${minsStr}:${secsStr}`
   Logger.error(`transDateHM-outputDate =  ${outputDate}`)
   return outputDate
  }

  transNumberDateHMS(inputDate?: number): string {
   Logger.error(`transDateHM-inputDate =  ${inputDate}`)
   let date = this.getLocalDateByNumber(inputDate ?? 0)

   let year = date.getFullYear().toString()
   let month = date.getMonth() + 1
   let day = date.getDate()
   let hours = date.getHours()
   let mins = date.getMinutes()
   let secs = date.getSeconds()

   let monthStr = month.toString()
   if (month < 10) {
    monthStr = "0" + month
   }

   let dayStr = day.toString()
   if (day < 10) {
    dayStr = "0" + day
   }

   let hoursStr = hours.toString()
   if (hours < 10) {
    hoursStr = "0" + hours
   }

   let minsStr = mins.toString()
   if (mins < 10) {
    minsStr = "0" + mins
   }

   let secsStr = secs.toString()
   if (secs < 10) {
    secsStr = "0" + secs
   }
   let outputDate = `${year}-${monthStr}-${dayStr} ${hoursStr}:${minsStr}:${secsStr}`
   Logger.error(`transDateHM-outputDate =  ${outputDate}`)
   return outputDate
 }

  formatDuration(duration: number): string {
   let mins = Math.floor(duration / 60)
   let secs = Math.floor(duration % 60)

   let minsStr = mins.toString()
   if (mins < 10) {
    minsStr = "0" + mins
   }

   let secsStr = secs.toString()
   if (secs < 10) {
    secsStr = "0" + secs
   }

   return `${minsStr}}:${secsStr}`
  }

 /**
  * Seconds converted to HH:mm:ss.
  *
  * @param seconds Maximum video duration (seconds).
  * @return Time after conversion.
  */
 secondToTime(seconds: number) {
  let time = `${Constants.INITIAL_TIME_UNIT}${':'}${Constants.INITIAL_TIME_UNIT}`;
  let hourUnit = Constants.TIME_UNIT * Constants.TIME_UNIT;
  let hour = Math.floor(seconds / hourUnit);
  let minute = Math.floor((seconds - hour * hourUnit) / Constants.TIME_UNIT);
  let second = seconds - hour * hourUnit - minute * Constants.TIME_UNIT;
  if (hour > 0) {
   return `${this.padding(hour.toString())}${':'}
        ${this.padding(minute.toString())}${':'}${this.padding(second.toString())}`;
  }
  if (minute > 0) {
   return `${this.padding(minute.toString())}${':'}${this.padding(second.toString())}`;
  } else {
   return `${Constants.INITIAL_TIME_UNIT}${':'}${this.padding(second.toString())}`;
  }
  return time;
 }

 /**
  * Zero padding, 2 bits.
  *
  * @param num Number to be converted.
  * @return Result after zero padding.
  */
 padding(num: string) {
  let length = Constants.PADDING_LENGTH;
  for (let len = (num.toString()).length; len < length; len = num.length) {
   num = `${Constants.PADDING_STR}${num}`;
  }
  return num;
 }

 }

export default new DateUtil()