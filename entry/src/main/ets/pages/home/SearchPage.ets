import preferences from '@ohos.data.preferences';
import router from '@ohos.router';
import App from 'lib_core_model/src/main/ets/App';
import { SearchTrendInfo } from 'lib_core_model/src/main/ets/data/SearchTrendInfo';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import PreferenceUtil from 'lib_core_model/src/main/ets/util/PreferenceUtil';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import SearchVM from 'lib_core_model/src/main/ets/vm/SearchVM';

@Entry
@Component
struct SearchPage {
  hintSearchKey?: string = (router.getParams() as object)?.[Constants.DATA];
  tenantId?: number = (router.getParams() as object)?.[Constants.TENANT_ID];
  @State searchHistory: Array<string> = []
  @State searchInput: string = ''
  @State searchTrendList: Array<SearchTrendInfo> = []
  @State hotSearchList: Array<SearchTrendInfo> = []

  aboutToAppear() {
    PreferenceUtil.get(Constants.SEARCH_KEY).then((value: preferences.ValueType | null) => {
      if (value) {
        this.searchHistory = JSON.parse(value?.toString() ?? '')
      }
    })
    this.sendSearchTrendRequest()
  }

  sendSearchTrendRequest() {
    SearchVM.sendSearchTrendRequest(this.tenantId ?? 0, this.searchInput).then((value: SearchTrendInfo[]) => {
      if (this.searchInput) {
        this.hotSearchList = value
        this.searchTrendList = []
      } else {
        this.hotSearchList = []
        this.searchTrendList = value
      }
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  build() {
    Column() {
      this.titleBar()
      this.content()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder
  titleBar() {
    Row() {
      Stack() {
        TextInput({
          text: this.searchInput,
          placeholder: this.hintSearchKey || '关键词/课程名称/导师名称',
        })
          .placeholderFont({ size: lpx2fp(24) })
          .width(Constants.FULL_PARENT)
          .height($r('app.string.lpx_68'))
          .fontSize(lpx2fp(24))
          .fontColor($r('app.color.color_333333'))
          .caretColor($r('app.color.color_EB4F3A'))
          .enterKeyType(EnterKeyType.Search)
          .backgroundColor($r('app.color.color_F5F5F5'))
          .borderRadius($r('app.string.lpx_34'))
          .padding({ left: $r('app.string.lpx_66'), right: $r('app.string.lpx_22') })
          .onChange((value: string) => {
            this.searchInput = value
            this.sendSearchTrendRequest()
          })
          .onSubmit((enterKey: EnterKeyType) => {
            App.get().pushUrl({
              url: RouterPath.SEARCH_RESULT_PAGE,
              params: {
                tenantId: this.tenantId,
                data: this.searchInput ? this.searchInput : this.hintSearchKey
              },
            })
            this.searchHistory.push(this.searchInput ? this.searchInput : (this.hintSearchKey ?? ''))
            this.saveSearchKey()
          })

        Image($r('app.media.ic_search'))
          .width($r('app.string.lpx_32'))
          .height($r('app.string.lpx_32'))
          .margin({ left: $r('app.string.lpx_22') })
      }
      .height($r('app.string.lpx_68'))
      .layoutWeight(1)
      .alignContent(Alignment.Start)

      Text('取消')
        .fontSize(lpx2fp(32))
        .fontColor($r('app.color.color_333333'))
        .padding({ left: $r('app.string.lpx_32') })
        .onClick(() => {
          if (this.searchInput) {
            this.searchInput = ''
            this.sendSearchTrendRequest()
            return
          }
          App.get().back()
        })

    }
    .width(Constants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .padding({
      top: $r('app.string.lpx_100'),
      bottom: $r('app.string.lpx_20'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }

  @Builder
  content() {
    List() {
      if (this.searchHistory.length > 0) {
        ListItem() {
          Row() {
            Text('搜索历史')
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(32))
            Blank()
            Image($r('app.media.ic_delete_search_keyword'))
              .width($r('app.string.lpx_48'))
              .height($r('app.string.lpx_48'))
              .onClick(() => {
                this.clearSearchKey()
              })
          }
          .width(Constants.FULL_PARENT)
          .padding({
            top: $r('app.string.lpx_20'),
            bottom: $r('app.string.lpx_20'),
            left: $r('app.string.lpx_32'),
            right: $r('app.string.lpx_32')
          })
        }

        ListItem() {
          Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
            ForEach(this.searchHistory,
              (item: string) => {
                Text(item)
                  .height($r('app.string.lpx_52'))
                  .fontSize(lpx2fp(24))
                  .fontColor($r('app.color.color_777777'))
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                  .backgroundColor($r('app.color.color_EAEAEA'))
                  .borderRadius($r('app.string.lpx_26'))
                  .margin({ top: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })
                  .padding({ left: $r('app.string.lpx_30'), right: $r('app.string.lpx_30') })
                  .onClick(() => {
                    App.get().pushUrl({
                      url: RouterPath.SEARCH_RESULT_PAGE,
                      params: {
                        tenantId: this.tenantId,
                        data: item
                      },
                    })
                  })
              },
              (item: string) => item.toString()
            )
          }
        }
        .padding({ bottom: $r('app.string.lpx_20'), left: $r('app.string.lpx_32'), right: $r('app.string.lpx_4') })
      }

      if (this.searchTrendList.length > 0) {
        ListItem() {
          Text('热搜')
            .width(Constants.FULL_PARENT)
            .fontColor($r('app.color.color_333333'))
            .fontSize(lpx2fp(32))
            .textAlign(TextAlign.Start)
        }
        .width(Constants.FULL_PARENT)
        .padding({
          top: $r('app.string.lpx_20'),
          bottom: $r('app.string.lpx_20'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })

        ForEach(this.searchTrendList, (item: SearchTrendInfo, index) => {
          ListItem() {
            Row() {
              if (index === 0) {
                Image($r('app.media.ic_hot_search1'))
                  .width($r('app.string.lpx_40'))
                  .height($r('app.string.lpx_40'))
                  .objectFit(ImageFit.Contain)
              } else if (index === 1) {
                Image($r('app.media.ic_hot_search2'))
                  .width($r('app.string.lpx_40'))
                  .height($r('app.string.lpx_40'))
                  .objectFit(ImageFit.Contain)
              } else if (index === 2) {
                Image($r('app.media.ic_hot_search3'))
                  .width($r('app.string.lpx_40'))
                  .height($r('app.string.lpx_40'))
                  .objectFit(ImageFit.Contain)
              } else {
                Text(`${index + 1}`)
                  .width($r('app.string.lpx_40'))
                  .height($r('app.string.lpx_40'))
                  .fontColor($r('app.color.color_333333'))
                  .fontSize(lpx2fp(24))
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .maxLines(1)
              }

              Text(item?.searchValue)
                .layoutWeight(1)
                .fontColor($r('app.color.color_333333'))
                .fontSize(lpx2fp(28))
                .textAlign(TextAlign.Start)
                .maxLines(1)
                .margin({ left: $r('app.string.lpx_20') })
            }
          }
          .width(Constants.FULL_PARENT)
          .padding({
            top: $r('app.string.lpx_16'),
            bottom: $r('app.string.lpx_16'),
            left: $r('app.string.lpx_32'),
            right: $r('app.string.lpx_32'),
          })
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.SEARCH_RESULT_PAGE,
              params: {
                data: item.searchValue,
              },
            })
          })
        })
      }
      ForEach(this.hotSearchList, (item: SearchTrendInfo) => {
        ListItem() {
          Text() {
            Span(item.searchValue)
              .fontColor($r('app.color.color_333333'))
              .fontSize(lpx2fp(28))
          }
          .width(Constants.FULL_PARENT)
          .textAlign(TextAlign.Start)
          .onClick(() => {
            App.get().pushUrl({
              url: RouterPath.SEARCH_RESULT_PAGE,
              params: {
                data: item.searchValue,
              },
            })
          })
        }
        .width(Constants.FULL_PARENT)
        .padding({
          top: $r('app.string.lpx_20'),
          bottom: $r('app.string.lpx_20'),
          left: $r('app.string.lpx_32'),
          right: $r('app.string.lpx_32')
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({ top: $r('app.string.lpx_22') })
  }

  saveSearchKey() {
    if (this.searchHistory.length == 0) {
      return
    }
    if (this.searchHistory.length > 10) {
      this.searchHistory = this.searchHistory.slice(this.searchHistory.length - 10, this.searchHistory.length)
    }
    PreferenceUtil.put(Constants.SEARCH_KEY, JSON.stringify(this.searchHistory))
  }

  clearSearchKey() {
    this.searchHistory = []
    PreferenceUtil.put(Constants.SEARCH_KEY, '')
  }
}
