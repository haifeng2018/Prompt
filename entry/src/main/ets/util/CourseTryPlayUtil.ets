import { ColumnInfo } from 'lib_core_model/src/main/ets/data/ColumnInfo';
import { GoodsInfo } from 'lib_core_model/src/main/ets/data/GoodsInfo';
import { GoodsType, VideoTrialStatus } from 'lib_core_model/src/main/ets/util/Enums';

class CourseTryPlayUtil {
  tag: string = 'CourseTryPlayUtil'

  /**
   * 获取播放资源
   */
  getPlayResource(goodsInfo: GoodsInfo | null, materialId?: string, cGoodsId?: string): ColumnInfo | null {
    let result: ColumnInfo | null = null
    if (goodsInfo?.goodsType == GoodsType.SpecialColumn) {
      goodsInfo?.columnParentVos?.forEach((item) => {
        item.columnVos?.forEach((_item) => {
          if (_item.materialId == materialId && _item.goodsId == cGoodsId) {
            result = _item
          }
        })
      })
    } else {
      goodsInfo?.columnParentVos?.forEach((item) => {
        if (item.materialId == materialId && item.goodsId == cGoodsId) {
          result = item
        }
      })
    }
    return result
  }

  /**
   * 获取默认的播放资源
   */
  getDefaultPlayResource(goodsInfo: GoodsInfo | null): ColumnInfo | null {
    let result: ColumnInfo | null = null
    if (goodsInfo?.goodsType == GoodsType.SpecialColumn && goodsInfo.columnParentVos) {
      for (let item of goodsInfo.columnParentVos) {
        item.columnVos?.forEach(() => {
          if (item.fragmentTrialFlag == VideoTrialStatus.TrialEnabled) {
            result = item
          }
        })
      }
    } else {
      goodsInfo?.columnParentVos?.forEach((item) => {
        if (item.fragmentTrialFlag == VideoTrialStatus.TrialEnabled) {
          result = item
        }
      })
    }
    return result
  }

  /**
   * 获取历史播放资源
   */
  getHistoryPlayResource(goodsInfo: GoodsInfo | null, materialId?: string): ColumnInfo | null {
    let result: ColumnInfo | null = null
    if (goodsInfo?.goodsType == GoodsType.SpecialColumn) {
      goodsInfo?.columnParentVos?.forEach((item) => {
        item.columnVos?.forEach((_item) => {
          if (_item.materialId == materialId && result == null) {
            result = _item
          }
        })
      })
    } else {
      goodsInfo?.columnParentVos?.forEach((item) => {
        if (item.materialId == materialId && result == null) {
          result = item
        }
      })
    }
    return result
  }

  isLastResource() {

  }

  /**
   * 获取可以免费观看的视频资源列表
   */
  getQualifiedVideoResources(goodsInfo: GoodsInfo | null): Array<ColumnInfo> {
    let result: Array<ColumnInfo> = []
    if (goodsInfo?.goodsType == GoodsType.SpecialColumn) {
      goodsInfo?.columnParentVos?.forEach((item) => {
        item.columnVos?.forEach((_item) => {
          if (_item.fragmentTrialFlag == VideoTrialStatus.TrialEnabled) {
            result?.push(_item)
          }
        })
      })
    } else {
      goodsInfo?.columnParentVos?.forEach((item) => {
        if (item.fragmentTrialFlag == VideoTrialStatus.TrialEnabled) {
          result?.push(item)
        }
      })
    }
    return result
  }

  /**
   * 根据播放资源获取对应的位置
   */
  getVideoResourcesIndex(list: Array<ColumnInfo>, video: ColumnInfo) {
    let position: number | null = null
    list.forEach((item, index) => {
      if (item.materialId == video.materialId) {
        if (index != null) {
          position = index
        }
      }
    })
    return position
  }
}

export default new CourseTryPlayUtil()