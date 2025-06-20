/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: FileUtil
 * Author: Victor
 * Date: 2024/04/01 17:23
 * Description: 
 * -----------------------------------------------------------------
 */
class FileUtil {
  static readonly TXT = 1;
  static readonly IMAGE = 2;
  static readonly PDF = 3;
  static readonly DOC = 4;
  static readonly EXCEL = 5;
  static readonly PPT = 6;
  static readonly OTHER = 7;

  static readonly txtRe = 'txt$'
  static readonly imageRe = '(?:jpg|gif|png|jpeg|webp)$'
  static readonly pdfRe = 'pdf$'
  static readonly docRe = '(?:docx|doc|csv)$'
  static readonly excelRe = '(?:xls|xlsx|xlsm)\$'
  static readonly pptRe = '(?:pptx|ppt)$'

  getFileTypeForUrl(url: string): number {
    let fileType = FileUtil.OTHER
    let inputUrl = url.toLowerCase()
    if (inputUrl.match(FileUtil.txtRe)) {
      fileType = FileUtil.TXT
    } else if (inputUrl.match(FileUtil.imageRe)) {
      fileType = FileUtil.IMAGE
    } else if (inputUrl.match(FileUtil.pdfRe)) {
      fileType = FileUtil.PDF
    } else if (inputUrl.match(FileUtil.docRe)) {
      fileType = FileUtil.DOC
    } else if (inputUrl.match(FileUtil.excelRe)) {
      fileType = FileUtil.EXCEL
    } else if (inputUrl.match(FileUtil.pptRe)) {
      fileType = FileUtil.PPT
    }
    return fileType
  }

  getCourseMaterialIconByUrl(url?: string): Resource {
    let materialIconRes = $r('app.media.icon_other_file')
    let inputUrl = url?.toLowerCase()
    if (inputUrl?.match(FileUtil.txtRe)) {
      materialIconRes = $r('app.media.icon_txt')
    } else if (inputUrl?.match(FileUtil.imageRe)) {
      materialIconRes = $r('app.media.icon_image')
    } else if (inputUrl?.match(FileUtil.pdfRe)) {
      materialIconRes = $r('app.media.icon_pdf')
    } else if (inputUrl?.match(FileUtil.docRe)) {
      materialIconRes = $r('app.media.icon_word')
    } else if (inputUrl?.match(FileUtil.excelRe)) {
      materialIconRes = $r('app.media.icon_excel')
    } else if (inputUrl?.match(FileUtil.pptRe)) {
      materialIconRes = $r('app.media.icon_ppt')
    }
    return materialIconRes
  }

}

export default new FileUtil()