import GoodsShowUtil from 'lib_common/src/main/ets/util/GoodsShowUtil';
import App from 'lib_core_model/src/main/ets/App';
import { CourseCategoryInfo } from 'lib_core_model/src/main/ets/data/CourseCategoryInfo';
import { LoginData } from 'lib_core_model/src/main/ets/data/LoginData';
import { SearchTrendInfo } from 'lib_core_model/src/main/ets/data/SearchTrendInfo';
import AppConfig from 'lib_core_model/src/main/ets/util/AppConfig';
import { Constants } from 'lib_core_model/src/main/ets/util/Constants';
import { lpx2fp } from 'lib_core_model/src/main/ets/util/DesignShow';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import ToastUtils from 'lib_core_model/src/main/ets/util/ToastUtils';
import CourseVM from 'lib_core_model/src/main/ets/vm/CourseVM';
import SearchVM from 'lib_core_model/src/main/ets/vm/SearchVM';
import LoadingDialog from '../../../view/dialog/LoadingDialog';
import { CourseCategoryContentTabComp } from './CourseCategoryContentTabComp';

@Component
export struct CourseCategoryContentComp {
  tenantId?: number
  catalogueId?: string
  @State loginData: LoginData | null = null
  @State searchTrendList: Array<SearchTrendInfo> = []
  @State courseCategoryList: Array<CourseCategoryInfo> = []
  @State categoryTabCheckedIndex: number = 0 ////课程分类选中位置
  @State subCategoryList: Array<CourseCategoryInfo> = []
  @State subCategoryTabCheckedIndex: number = 0
  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  sendSearchTrendRequest() {
    SearchVM.sendSearchTrendRequest(this.tenantId ?? 0, '').then((data: SearchTrendInfo[]) => {
      this.searchTrendList = data
    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    });
  }

  sendCourseCategoryRequest() {
    CourseVM.sendCourseCategoryRequest(this.tenantId ?? 0).then((data: CourseCategoryInfo[]) => {
      this.courseCategoryList = data
      if (this.courseCategoryList.length > 0) {
        //处理分类跳转
        let indexs = GoodsShowUtil.getCategoryIndexs(this.courseCategoryList, this.catalogueId)
        this.categoryTabCheckedIndex = indexs[0]
        this.subCategoryTabCheckedIndex = indexs[1]

        let subCategoryCount = this.courseCategoryList[this.categoryTabCheckedIndex].catalogueListVos?.length ?? 0
        if (subCategoryCount === 0) {
          this.subCategoryList = [this.courseCategoryList[this.categoryTabCheckedIndex]]
        } else {
          this.subCategoryList = this.courseCategoryList[this.categoryTabCheckedIndex].catalogueListVos ?? []
        }
      }

    }).catch((err: string | Resource) => {
      ToastUtils.show(err)
    })
  }

  sendAllRequest() {
    this.sendSearchTrendRequest()
    this.sendCourseCategoryRequest()
  }

  aboutToAppear() {
    AppConfig.getLoginData().then((resultData: LoginData) => {
      this.loginData = resultData
      this.sendAllRequest()
    })
  }

  build() {
    Column() {
      this.titleSearchBar()
      this.categoryGroupTab()
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundImage($r('app.media.img_frag_course'))
    .backgroundImageSize(ImageSize.Cover)
  }

  @Builder
  titleSearchBar() {
    Row() {
      Image($r('app.media.ic_back'))
        .width($r('app.string.lpx_48'))
        .height($r('app.string.lpx_48'))
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          App.get().back()
        })
      Stack() {
        Image($r('app.media.ic_home_search'))
          .width($r('app.string.lpx_32'))
          .height($r('app.string.lpx_32'))
          .margin({ left: $r('app.string.lpx_24') })

        Swiper() {
          ForEach(this.searchTrendList, (item: SearchTrendInfo) => {
            Text(item.searchValue)
              .width(Constants.FULL_PARENT)
              .height(Constants.FULL_PARENT)
              .fontSize(lpx2fp(24))
              .fontColor($r('app.color.color_999999'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: $r('app.string.lpx_72'), right: $r('app.string.lpx_28') })
              .onClick(() => {
                App.get().pushUrl({
                  url: RouterPath.SEARCH_PAGE,
                  params: {
                    data: item.searchValue,
                  },
                })
              })
          })
        }
        .vertical(true)
        .autoPlay(true)
        .indicator(false)
        .interval(3000)
        .height($r('app.string.lpx_64'))
        .margin({ left: $r('app.string.lpx_10') })
      }
      .alignContent(Alignment.Start)
      .layoutWeight(1)
      .backgroundColor($r('app.color.color_F5F5F5'))
      .borderRadius($r('app.string.lpx_32'))
      .margin({ left: $r('app.string.lpx_20') })
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top: $r('app.string.lpx_100'),
      left: $r('app.string.lpx_32'),
      right: $r('app.string.lpx_32')
    })
  }

  @Builder
  categoryGroupTab() {
    Tabs({ barPosition: BarPosition.Start, index: this.categoryTabCheckedIndex }) {
      ForEach(this.courseCategoryList, (item: CourseCategoryInfo, index) => {
        TabContent() {
          CourseCategoryContentTabComp({
            tenantId: this.tenantId ?? 0,
            categoryInfo: item,
            subCategoryTabCheckedIndex: $subCategoryTabCheckedIndex
          })
        }
        .tabBar(this.categoryTabBuilder(index, item))
        .align(Alignment.Top)
        .backgroundColor($r('app.color.white'))
        .padding({ left: $r('app.string.lpx_20'), right: $r('app.string.lpx_20') })
      })
    }
    .vertical(false)
    .barMode(BarMode.Scrollable)
    .barHeight($r('app.string.lpx_80'))
    .onChange((index: number) => {
      this.categoryTabCheckedIndex = index
    })
    .width(Constants.FULL_PARENT)
    .layoutWeight(1)
    .margin({ top: $r('app.string.lpx_24') })
    .padding({
      left: $r('app.string.lpx_12'),
      right: $r('app.string.lpx_12')
    })
  }

  @Builder
  categoryTabBuilder(index: number, item: CourseCategoryInfo) {
    Row() {
      Image(item?.catalogueUrl || $r('app.media.img_placeholder_horizontal'))
        .width($r('app.string.lpx_40'))
        .height($r('app.string.lpx_40'))
        .objectFit(ImageFit.Contain)

      Text(item?.catalogueName)
        .layoutWeight(1)
        .fontColor(this.categoryTabCheckedIndex === index ? $r('app.color.color_F12E29') : $r('app.color.color_666666'))
        .fontSize(lpx2fp(28))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: $r('app.string.lpx_16') })
    }
    .width($r('app.string.lpx_232'))
    .height(Constants.FULL_PARENT)
    .backgroundColor(this.categoryTabCheckedIndex === index ? $r('app.color.white') : $r('app.color.color_66FFFFFF'))
    .border({
      radius: {
        topLeft: $r('app.string.lpx_20'),
        topRight: $r('app.string.lpx_20')
      }
    })
    .padding({ left: $r('app.string.lpx_32') })
    .margin({
      left: $r('app.string.lpx_4'),
      right: $r('app.string.lpx_4')
    })
  }
}
