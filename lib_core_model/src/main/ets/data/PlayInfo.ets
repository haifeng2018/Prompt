/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: PlayInfo
 * Author: Victor
 * Date: 2024/03/15 18:14
 * Description:
 * -----------------------------------------------------------------
 */
export class PlayInfo {
  definition?: string//视频流清晰度定义FD：流畅,LD：标清,SD：高清,HD：超清OD：原画,2K：2K,4K：4K,SQ：普通音质,HQ：高音质,AUTO：自适应码率
  hdrtype?:string
  narrowBandType?: string//窄带高清类型取值：0：普通,1.0：窄带高清1.0, 2.0：窄带高清2.0
  playURL?: string//视频流的播放地址
  size?: number//媒体流大小。单位：Byte
  status?: number//	媒体流状态Normal：正常 Invisible：不可见
  streamType?: number//	媒体流类型：若媒体流为视频则取值：video，若是纯音频则取值：audio
  width?: number//	媒体流宽度。单位：px
}