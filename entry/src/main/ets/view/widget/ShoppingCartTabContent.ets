/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: ShoppingCartTabContent
 * Author: Victor
 * Date: 2023/11/16 16:23
 * Description: 
 * -----------------------------------------------------------------
 *//*

import { GoodsInfo } from '../../bean/GoodsInfo';
import { RemoveCartGoodsInfo } from '../../bean/RemoveCartGoodsInfo';
import { ShoppingCartInfo } from '../../bean/ShoppingCartInfo';
import CourseVM from '../../http/vm/CourseVM';
import ShoppingCartVM from '../../http/vm/ShoppingCartVM';
import AmountUtil from '../../util/AmountUtil';
import Constants from '../../util/Constants'
import CourseDetailActionUtil from '../../util/CourseDetailActionUtil';
import GoodsShowUtil from '../../util/GoodsShowUtil';
import ToastUtils from '../../util/ToastUtils';
import CommonTipDialog from '../dialog/CommonTipDialog';
import LoadingDialog from '../dialog/LoadingDialog';
import { PageState } from './refresh/PageState';
import RefreshComponent from './refresh/RefreshComponent';
import { RefreshConfig } from './refresh/RefreshConfig';
import ShoppingCartOfflineCouponCell from './ShoppingCartOfflineCouponCell';
import ShoppingCartOfflineNormalCell from './ShoppingCartOfflineNormalCell';
import ShoppingCartOffShelevesCell from './ShoppingCartOffShelevesCell';
import ShoppingCartOnlineCouponCell from './ShoppingCartOnCouponCell';
import ShoppingCartOnlineNormalCell from './ShoppingCartOnlineNormalCell';
import ShoppingCartSoldOutCell from './ShoppingCartSoldOutCell';
@Preview
@Component
export struct ShoppingCartTabContent {
  TAG = 'ShoppingCartTabContent'

  @Provide(RefreshConfig.REFRESH_STATE_TAG) pageState: number = PageState.Loading;
  @Provide(RefreshConfig.REFRESH_LIST_SCROLL_TOP_TAG) listScrollTop : boolean = false;

  @Prop @Watch('sendShoppingCartRequest') token: string;

  @State shoppingCartList: Array<ShoppingCartInfo> = []
  @State onlineRecommendList: Array<GoodsInfo> = []

  @State isEditing: boolean = false
  @State sumCount: number = 0;
  @State sumPrice: number = 0;
  @State isSelectAll: boolean = false;

  @State itemClickIndex: number = Constants.DEFAULT_CLICK_INDEX
  @Provide(Constants.SHOPPING_CART_SELECT_KEY) selectProducts: { [K: string]: boolean } = {}

  loadingDialogCtrl: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog(
      {
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  deleteTipDlgController: CustomDialogController = new CustomDialogController({
    builder: CommonTipDialog(
      {

        title: `确定删除 ${this.sumCount} 件商品？`,
        cancel: () => {

        },
        confirm: () => {
          let body = Array<RemoveCartGoodsInfo>()
          Object.keys(this.selectProducts).forEach((value,index) => {
            const selected = this.selectProducts[value]
            const data = this.shoppingCartList.find(item => item.goodsId === value)
            if (selected) {
              let item = new RemoveCartGoodsInfo()
              item.goodsId = data?.goodsId
              item.specId = data?.specId
              body.push(item)
            }
          })
          this.sendRemoveCartRequest(body)
        }
      }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  sendShoppingCartRequest () {
    ShoppingCartVM.sendShoppingCartRequest(this.token,{
      onSuccess: (value) => {
        this.pageState = PageState.Success
        this.shoppingCartList = value.data

        if (this.shoppingCartList?.length === undefined
        || this.shoppingCartList === null
        || this.shoppingCartList?.length === 0) {
          this.sendOnlineRecommendRequest()
        }

        this.onListChange()
      },
      onFail: (code,msg) => {
        this.pageState = PageState.Fail
        ToastUtils.show(msg)
      }
    })
  }

  sendSetCartRequest (goodsId: string,specId: string,quantity: number) {
    this.loadingDialogCtrl.open()

    ShoppingCartVM.sendSetCartRequest(this.token,goodsId,specId,quantity,{
       onSuccess: (value) => {
         this.loadingDialogCtrl.close()

         this.sendShoppingCartRequest()
       },
      onFail: (code,msg) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show(msg)
      }
    })
  }

  sendRemoveCartRequest (body) {
    this.loadingDialogCtrl.open()

    ShoppingCartVM.sendRemoveCartRequest(this.token,body,{
       onSuccess: (value) => {
         this.loadingDialogCtrl.close()

         this.sendShoppingCartRequest()
       },
      onFail: (code,msg) => {
        this.loadingDialogCtrl.close()
        ToastUtils.show(msg)
      }
    })
  }

  sendOnlineRecommendRequest () {
    CourseVM.sendOnlineRecommendRequest(this.token,1,3,{
      onSuccess: (value) => {
        this.pageState = PageState.Success
        this.onlineRecommendList = value.data.records
      },
      onFail: (code,msg) => {
        this.pageState = PageState.Fail
        ToastUtils.show(msg)
      }
    })
  }

  onListChange() {
    let payload = {};
    this.shoppingCartList.forEach(item => {
      payload[item.goodsId] = !!this.selectProducts[item.goodsId]
    })
    this.selectProducts = payload;
    this.countSumPrice();
  }

  needUpdateShopCart() {
    this.countSumPrice()
  }

  countSumPrice() {
    this.isSelectAll = Object.values(this.selectProducts).every(item => item);
    let selectCount = 0
    let selectSumPrice = 0
    Object.keys(this.selectProducts).forEach((value,index) => {
      const selected = this.selectProducts[value]
      const data = this.shoppingCartList.find(item => item.goodsId === value)
      selectCount += selected ? data.quantity : 0
      const ins = (selected ? data.currentSalePrice * data.quantity : 0)
      selectSumPrice += ins
    })
    this.sumCount = selectCount
    this.sumPrice = selectSumPrice
  }

  selectAllAction() {
    this.isSelectAll = !this.isSelectAll
    this.shoppingCartList.forEach((value) => {
      this.selectProducts[value.goodsId] = this.isSelectAll
    })
    this.needUpdateShopCart()
  }

  getSelectList(): Array<ShoppingCartInfo> {
    let selectList = Array<ShoppingCartInfo>()
    Object.keys(this.selectProducts).forEach((value,index) => {
      const selected = this.selectProducts[value]
      const data = this.shoppingCartList.find(item => item.goodsId === value)
      if (selected) {
        selectList.push(data)
      }
    })
    return selectList
  }

  aboutToAppear() {
    this.sendShoppingCartRequest()
  }

  build() {
    Column() {
      this.titleBar()

      if (this.shoppingCartList?.length > 0) {
        this.shoppingCartContent()
        this.bottomAction()
      } else {
        this.emptyContent()
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .align(Alignment.Top)
    .backgroundColor($r('app.color.color_F9F9F9'))
  }

  @Builder titleBar() {
    Stack(){
      Text('购物车')
        .width(Constants.FULL_PARENT)
        .height($r('app.float.vp_98'))
        .fontSize($r('app.float.fp_36'))
        .fontColor($r('app.color.color_333333'))
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)

      Text(this.isEditing ? '完成' : '编辑')
        .height($r('app.float.vp_98'))
        .fontSize($r('app.float.fp_28'))
        .fontColor($r('app.color.color_777777'))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.isEditing = !this.isEditing
        })
        .opacity(this.shoppingCartList?.length > 0 ? 1 : 0)
    }
    .width(Constants.FULL_PARENT)
    .alignContent(Alignment.End)
    .backgroundColor($r('app.color.white'))
    .padding({
      top:$r('app.float.vp_60'),
      left:$r('app.float.vp_32'),
      right:$r('app.float.vp_32')
    })
    .zIndex(1)
  }

  @Builder
  emptyContent() {
    RefreshComponent({
      itemLayout: () => this.emptyItemLayout(),
      onRefresh: () => {
        this.sendShoppingCartRequest()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({top: $r('app.float.vp_10')})
      .zIndex(0)
  }

  @Builder
  emptyItemLayout () {
    List() {
      ListItem() {
        Column(){
          Image($r('app.media.img_shopping_cart_empty'))
            .width($r('app.float.vp_280'))
            .height($r('app.float.vp_280'))
          Text('购物车空空如也，快去逛逛吧')
            .fontColor($r('app.color.color_999999'))
            .fontSize($r('app.float.fp_28'))
          Text('去逛逛')
            .fontColor($r('app.color.color_EB4F3A'))
            .fontSize($r('app.float.fp_28'))
            .textAlign(TextAlign.Center)
            .height($r('app.float.vp_52'))
            .margin({top: $r('app.float.vp_60')})
            .padding({
              left: $r('app.float.vp_30'),
              right: $r('app.float.vp_30')
            })
            .border({
              width: $r('app.float.vp_2'),
              radius: $r('app.float.vp_26'),
              color: $r('app.color.color_EB4F3A')
            })
        }
        .width(Constants.FULL_PARENT)
      }
      .width(Constants.FULL_PARENT)
      .padding({top: $r('app.float.vp_80')})
      .backgroundColor($r('app.color.white'))

      ListItem() {
        Text('为您推荐')
          .width(Constants.FULL_PARENT)
          .height($r('app.float.vp_104'))
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_36'))
          .fontWeight(FontWeight.Bold)
      }
      .width(Constants.FULL_PARENT)
      .margin({top: $r('app.float.vp_80')})
      .backgroundColor($r('app.color.color_FAFAFA'))
      .borderRadius({
        topLeft: $r('app.float.vp_20'),
        topRight: $r('app.float.vp_20'),
        bottomLeft: 0,
        bottomRight: 0
      })

      ForEach(this.onlineRecommendList, (item,index) => {
        ListItem() {
          Row(){
            Image(item.coverUrlExtendVo?.centre)
              .width($r('app.float.vp_180'))
              .height($r('app.float.vp_180'))
              .border({radius: $r('app.float.vp_8')})

            Column() {

              Text(item.contentName)
                .width(Constants.FULL_PARENT)
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.color_333333'))
                .fontSize($r('app.float.fp_28'))
                .maxLines(2)
                .textOverflow({overflow: TextOverflow.Ellipsis})

              Blank()

              Row() {

                Text('￥')
                  .fontColor($r('app.color.color_EB4F3A'))
                  .fontSize($r('app.float.fp_20'))

                Text(AmountUtil.getRoundUp(item.salePrice / 100, 2))
                  .fontColor($r('app.color.color_EB4F3A'))
                  .fontSize($r('app.float.fp_28'))
                  .margin({left: $r('app.float.vp_8')})

                Blank()

                if (item.orderNo) {
                  if (item.saleType == 0 || item.salePrice == 0) {
                    Text('免费专享')
                      .fontColor($r('app.color.color_EB4F3A'))
                      .fontSize($r('app.float.fp_24'))
                  }
                } else {
                  Image(item.quantity > 0 ? $r('app.media.ic_add_cart_checked') : $r('app.media.ic_add_cart_normal'))
                    .width(item.quantity > 0 ? $r('app.float.vp_56') : $r('app.float.vp_48'))
                    .height(item.quantity > 0 ? $r('app.float.vp_56') : $r('app.float.vp_48'))
                    .objectFit(ImageFit.Contain)
                    .onClick(() => {
                      if (!item?.quantity) {
                        if (item?.quantity < item?.goodsNum || item?.onlineFlag === 0) {
                          this.sendSetCartRequest(item.goodsId,item.specId,1)
                        } else {
                          ToastUtils.show('该课程不能购买更多')
                        }
                      }
                    })
                }
              }
              .width(Constants.FULL_PARENT)
              .margin({top: $r('app.float.vp_10')})
            }
            .layoutWeight(1)
            .height($r('app.float.vp_180'))
            .margin({left: $r('app.float.vp_24')})
          }
          .width(Constants.FULL_PARENT)
          .border({radius: $r('app.float.vp_20')})
        }
        .width(Constants.FULL_PARENT)
        .backgroundColor($r('app.color.color_FAFAFA'))
        .borderRadius({
          topLeft: 0,
          topRight: 0,
          bottomLeft: index == this.onlineRecommendList.length - 1 ? $r('app.float.vp_20') : 0,
          bottomRight: index == this.onlineRecommendList.length - 1 ? $r('app.float.vp_20') : 0
        })
        .padding({
          top: $r('app.float.vp_12'),
          bottom: $r('app.float.vp_12'),
          left: $r('app.float.vp_20'),
          right: $r('app.float.vp_20'),
        })
        .onClick(() => {
          CourseDetailActionUtil.courseDetail(item.onlineFlag, item.goodsId,0)
        })
      })
    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      // 监听当前列表首位索引
      this.listScrollTop = start === 0
    })
    .padding({left:$r('app.float.vp_16'),right:$r('app.float.vp_16')})
    .backgroundColor($r('app.color.white'))
  }

  @Builder
  shoppingCartContent() {
    RefreshComponent({
      itemLayout: () => this.itemLayout(),
      onRefresh: () => {
        this.sendShoppingCartRequest()
      }
    })
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .margin({top: $r('app.float.vp_10')})
      .zIndex(0)
  }

  @Builder itemLayout() {
    List() {
      ForEach(this.shoppingCartList,item => {
        ListItem() {
          if (item?.shelveFlag === 0) {//已上架
            if (item?.onlineFlag === 1) {//线下课程
              if (item?.goodsNum == 0) {//已售馨
                ShoppingCartSoldOutCell({
                  data: item,
                  index: this.shoppingCartList.indexOf(item),
                  itemCheckIndex: $itemClickIndex
                })
              } else {
                if (item?.cartDiscountItem?.couponNo === '' || item?.cartDiscountItem?.couponNo === null) {
                  ShoppingCartOfflineNormalCell({
                    data: item,
                    index: this.shoppingCartList.indexOf(item),
                    itemCheckIndex: $itemClickIndex,
                    onCounterSubAction: (data: ShoppingCartInfo) => {
                      this.onCounterSubAction(data);
                    },
                    onCounterAddAction: (data: ShoppingCartInfo) => {
                      this.onCounterAddAction(data);
                    },
                    onItemCheckAction: () => {
                      this.selectProducts[item.goodsId] = !this.selectProducts[item.goodsId]
                      this.needUpdateShopCart()
                    }
                  })
                } else {
                  ShoppingCartOfflineCouponCell({
                    data: item,
                    index: this.shoppingCartList.indexOf(item),
                    itemCheckIndex: $itemClickIndex,
                    onCounterSubAction: (data: ShoppingCartInfo) => {
                      this.onCounterSubAction(data);
                    },
                    onCounterAddAction: (data: ShoppingCartInfo) => {
                      this.onCounterAddAction(data);
                    },
                    onItemCheckAction: () => {
                      this.selectProducts[item.goodsId] = !this.selectProducts[item.goodsId]
                      this.needUpdateShopCart()
                    }
                  })
                }
              }
            } else {//线上课程
              if (item?.cartDiscountItem?.couponNo === '' || item?.cartDiscountItem?.couponNo === null) {
                ShoppingCartOnlineNormalCell({
                  data: item,
                  index: this.shoppingCartList.indexOf(item),
                  itemClickIndex: $itemClickIndex,
                  onCounterSubAction: (data: ShoppingCartInfo) => {
                    this.onCounterSubAction(data);
                  },
                  onCounterAddAction: (data: ShoppingCartInfo) => {
                    this.onCounterAddAction(data);
                  },
                  onItemCheckAction: () => {
                    this.selectProducts[item.goodsId] = !this.selectProducts[item.goodsId]
                    this.needUpdateShopCart()
                  }
                })
              } else {
                ShoppingCartOnlineCouponCell({
                  data: item,
                  index: this.shoppingCartList.indexOf(item),
                  itemCheckIndex: $itemClickIndex,
                  onCounterSubAction: (data: ShoppingCartInfo) => {
                    this.onCounterSubAction(data);
                  },
                  onCounterAddAction: (data: ShoppingCartInfo) => {
                    this.onCounterAddAction(data);
                  },
                  onItemCheckAction: () => {
                    this.selectProducts[item.goodsId] = !this.selectProducts[item.goodsId]
                    this.needUpdateShopCart()
                  }
                })
              }
            }
          } else if (item.shelveFlag === 1) {//已下架
            ShoppingCartOffShelevesCell({
              data: item,
              index: this.shoppingCartList.indexOf(item),
              itemCheckIndex: $itemClickIndex
            })
          }
        }
      })
    }
    .width(Constants.FULL_PARENT)
    .listDirection(Axis.Vertical)
    .padding({left:$r('app.float.vp_32'),right:$r('app.float.vp_32')})
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      // 监听当前列表首位索引
      this.listScrollTop = start === 0
    })
  }

  onCounterAddAction(data: ShoppingCartInfo) {
    let onlineFlag =  data?.onlineFlag
    let goodsId =  data?.goodsId
    let quantity =  data?.quantity
    let specId = data?.specId
    let goodsNum =  data?.goodsNum
    if (quantity < goodsNum || onlineFlag == 0) {
      quantity++
      this.sendSetCartRequest(goodsId,specId,quantity)
    } else {
      ToastUtils.show('该课程不能购买更多')
    }
    // sendRecommendCoupon()
  }

  onCounterSubAction(data: ShoppingCartInfo) {
    let goodsId =  data?.goodsId
    let quantity =  data?.quantity
    let specId = data?.specId
    if (quantity > 1) {
      quantity--
      this.sendSetCartRequest(goodsId,specId,quantity)
    } else {

      let body = Array<RemoveCartGoodsInfo>()
      let item = new RemoveCartGoodsInfo()
      item.goodsId = data?.goodsId
      item.specId = data?.specId
      body.push(item)

      this.sendRemoveCartRequest(body)
    }
  }

  @Builder
  bottomAction() {
    Row() {
      Image(this.isSelectAll ? $r('app.media.ic_shopping_checked') : $r('app.media.ic_shopping_normal'))
        .width($r('app.float.vp_36'))
        .height($r('app.float.vp_36'))
        .onClick(() => {
          this.selectAllAction()
        })
      Text(this.sumCount === 0 ? '全选' : `已选择 ${this.sumCount} 件`)
        .fontColor($r('app.color.color_808080'))
        .fontSize($r('app.float.fp_24'))
        .margin({left: $r('app.float.vp_10')})
        .onClick(() => {
          this.selectAllAction()
        })
      Blank()
      Text() {
        Span('合计：')
          .fontColor($r('app.color.color_333333'))
          .fontSize($r('app.float.fp_24'))
        Span('¥')
          .fontColor($r('app.color.color_EB4F3A'))
          .fontSize($r('app.float.fp_24'))
      }
      .margin({left: $r('app.float.vp_10')})
      .opacity(this.isEditing ? 0 : 1)

      Text(AmountUtil.getRoundUp(this.sumPrice / 100,2))
        .fontColor($r('app.color.color_DA3732'))
        .fontSize($r('app.float.fp_36'))
        .margin({right: $r('app.float.vp_40')})
        .opacity(this.isEditing ? 0 : 1)

      if (this.isEditing) {
        Text('删除')
          .height($r('app.float.vp_64'))
          .backgroundColor($r('app.color.color_FEFAFA'))
          .border({
            width:$r('app.float.fp_2'),
            radius: $r('app.float.vp_32'),
            color: $r('app.color.color_DA3732')
          })
          .fontColor($r('app.color.color_DA3732'))
          .fontSize($r('app.float.fp_32'))
          .padding({left: $r('app.float.vp_68'), right: $r('app.float.vp_68')})
          .onClick(() => {
            if (this.sumCount === 0) {
              ToastUtils.show("请勾选需要删除的课程")
              return
            }
            this.deleteTipDlgController.open()
          })
      } else {
        Text('结算')
          .height($r('app.float.vp_64'))
          .borderRadius($r('app.float.vp_32'))
          .fontColor($r('app.color.white'))
          .fontSize($r('app.float.fp_32'))
          .padding({left: $r('app.float.vp_68'), right: $r('app.float.vp_68')})
          .linearGradient({
            angle: 90,
            colors: [
              [$r('app.color.color_EF874D'),0.0],
              [$r('app.color.color_DA3732'),0.7],
              [$r('app.color.color_DA3732'),1.0]
            ]
          })
          .onClick(() => {
            if (this.sumCount === 0) {
              ToastUtils.show("请选择结算课程")
              return
            }
          })
      }
    }
    .width(Constants.FULL_PARENT)
    .padding({
      top:$r('app.float.vp_20'),
      bottom:$r('app.float.vp_20'),
      left:$r('app.float.vp_32'),
      right:$r('app.float.vp_32'),
    })
    .zIndex(0)
  }

}*/
