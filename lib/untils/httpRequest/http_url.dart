
const service3Url = 'https://shop.fdg1868.cn/';//请求头3

//const service4Url = 'http://192.168.1.239:8082/fdg-api/api';//稳定本地接口
const service4Url = 'https://api.lingji168.com/fdg-api/api';//上线用的接口
//const service4Url = 'http://192.168.1.69:8081/fdg-api/api';//本地接口 冠尚
//const service4Url = 'http://172.38.57.163:8081/fdg-api/api';//本地接口 一航
//const service4Url = 'http://192.168.1.145:8081/fdg-api/api';//本地接口 锋哥
//const service4Url = 'http://172.36.183.210:8082/fdg-api/api';//本地接口1

//const service5Url = 'http://192.168.1.239:8082/fdg-api/';//分类图片接口
const service5Url = 'https://api.lingji168.com/fdg-api/';//上线分类图片接口

//const String IdCardApiImg = "http://192.168.1.239:8082/fdg-api/file/get/";//身份证图片頭部
const String IdCardApiImg = "https://api.lingji168.com/fdg-api/file/get/";//上线身份证图片頭部
const String ApiImg = "http://lingji-images.oss-cn-shenzhen.aliyuncs.com";//图片頭部

const servicePath = {
  "imagePath": "http://192.168.1.239:8082/fdg-api/file/get/",

  "checkApkUpgrade":'http://192.168.1.239:8082/fdg-api/file/checkApkUpgrade',//检查安卓版本
//  "apkUrl":"http://192.168.1.180:8081/fdg-api/file/get/pg_56e3",//检查apk版本下载

  "data": service3Url + 'app/index.php?i=1&c=entry&m=ewei_shopv2&do=api&r=index.index.diypages&id=910&access_token=oqbFcn1c4SLuGFb7xD5AN9dSGt10xcGQ',
  //数据结构

  "sendMobileCode": service4Url + '/auth/sendMobileCode', //发送手机验证码
  "register": service4Url + '/auth/register', //立即注册
  "phoneLogin": service4Url + '/auth/login', //手机号登录
  "codeLogin": service4Url + '/auth/mobileLogin', //验证码登录
  "logout": service4Url + '/auth/logout', //退出登录

  "getUserById": service4Url + '/user/getUserById', //查询用户信息
  "sendMailbox": service4Url + '/user/sendMailbox', //发送验证邮件particulars
  "bindMailbox": service4Url + '/user/bindMailbox', //绑定邮箱

  "bindNewMobile": service4Url + '/user/bindNewMobile',
  //绑定新手机号

  "updatePassword": service4Url + '/auth/updatePassword',
  //找回密码
  "updateUnamePassword": service4Url + '/user/updateUnamePassword',
  //修改密码
  "thirdLogin": service4Url + '/auth/thirdLogin',
  //微信授权登录
  "bindThird": service4Url + '/user/bindThird',
  //绑定微信
  "updateUserById": service4Url + '/user/updateUserById',
  //修改用户名
  "getCurrentUserWxQrCode": service4Url + '/user/getCurrentUserWxQrCode', //获取包含当前用户的微信小程序二维码

//消费者
////  "getConsumer":service4Url+'/consumer/getConsumer',//获取消费者信息
//  "insertAddress":service4Url+'/consumer/insertAddress',//新增地址
//  "insertAddressNotPhoto":service4Url+"/consumer/insertAddressNotPhoto",//新增收货地址 ，不加图片
//  "particulars":service4Url+'/consumer/particulars',//个人详情
//  "updateConsumer":service4Url+'/consumer/update',//修改个人中心
//  "updateConsumerPhoto":service4Url+'/consumer/updateConsumerPhoto',//修改个人头像
//  "delAddress":service4Url+'/consumer/delAddress',//删除收货地址
//  "selectAddress":service4Url+'/consumer/selectAddress',//查询收货地址
//  "updateAddressIsdefaultall":service4Url+'/consumer/updateAddressIsdefaultall',//更改默认地址
//  "updateAddress":service4Url+'/consumer/updateAddress',//修改收货地址
////  "updateAddressNotRealToReal":service4Url+'/consumer/updateAddressNotRealToReal',//修改收货地址(原本非实名添加实名时)
////  "updateAddressall":service4Url+'/consumer/updateAddressall',//修改收货地址(带身份图片)
//
//  "insertReal":service4Url+'/consumer/insertReal',//新增实名认证
//  "particularsbd":service4Url+'/consumer/particularsbd',//查询用户绑定的账号的详细
//  "particularsAddress":service4Url+"/consumer/particularsAddress",//查询某个详情收货地址
//  "realList":service4Url+"/consumer/getRealList",//查询实名信息列表
//  "particularsToReal":service4Url+"/consumer/particularsToReal",//查询实名详情
//  "delList":service4Url+"/consumer/delList",//删除实名库
//  "updateReal":service4Url+"/consumer/updateReal",//修改实名库

  ///二代消费者接口

  "getAddressList": service4Url + '/consumer/getAddressList', //获取消费者地址列表
  "getConsumer": service4Url + '/consumer/getConsumer', //获取消费者信息
  "update": service4Url + '/consumer/update', //修改消费者信息
  "createReal": service4Url + '/consumer/createReal', //创建实名信息
  "getRealList": service4Url + '/consumer/getRealList', //获取消费者实名列表
  "getReal": service4Url + '/consumer/getReal', //获取消费者实名信息详情
  "deleteReal": service4Url + '/consumer/deleteReal', //删除实名信息
  "deleteAddress": service4Url + '/consumer/deleteAddress', //删除地址
  "updateAddress": service4Url + '/consumer/updateAddress', //修改/新增地址
  "setDefaultAddress": service4Url + '/consumer/setDefaultAddress', //設置默认地址
  "getAddress": service4Url + '/consumer/getAddress', //获取地址详细信息
  "addCollection": service4Url + '/consumer/addCollection', //关注商品
  "getCollectionPage": service4Url + '/consumer/getCollectionPage', //获取收藏列表
  "removeCollection": service4Url + '/consumer/removeCollection', //取消关注
  "getFootmarkPage": service4Url + '/consumer/getFootmarkPage', //获取足迹列表
  "removeFootmark": service4Url + '/consumer/removeFootmark', //清除足迹
  "IdCarduploadImg": service4Url + '/consumer/uploadImg', //上传身份证图片
  "uploadImg": service4Url + '/aliyunOssImg/uploadImg', //上传图片
  "getDefaultAddress": service4Url + '/consumer/getDefaultAddress', //获取默认地址
  "getLable": service4Url + '/consumer/getLable', //获取标签列表
  "bindLable": service4Url + '/consumer/bindLable', //绑定标签
  "guessWhatYouLike": service4Url + '/consumer/guessWhatYouLike', //猜你喜欢
  "createVipOrder": service4Url + '/consumer/createVipOrder', //购买会员卡下单
  "getVipSettingList": service4Url + '/consumer/getVipSettingList', //获取会员卡列表

  ///商品模块
  "shopDetails": service4Url + "/commodity/get/", //商品详情
  "searchSuggestion": service4Url + "/commodity/searchSuggestion", //搜索建议
  "search": service4Url + "/commodity/search", //搜索商品
  "getHotSearch": service4Url + "/commodity/getHotSearch", //获取搜索热门记录
  "allCommoditySort": service4Url + "/commodityCata/allTree", //全部分类
  "getSearch": service4Url + "/commodity/getSearch", //搜索历史记录
  "clearSearchHistory": service4Url + "/commodity/clearSearchHistory", //清除搜索历史记录
  "getBrandAll": service4Url + "/sku/brand/getBrandAll", // sku品牌
  "getStockBySkus": service4Url + "/commodity/getStockBySkus", //根据SKU数组返回库存
//  "clearSearchOne":"http://192.168.1.117:8081/fdg-api/api/commodity/clearSearchOne", //清除单条搜索历史记录
  "file": service5Url + "file/get/", //以HTTP形式输出文件

  ///订单购物车模块
  "findCartList": service4Url + "/orderCart/findCartList", //获取购物车列表
  "addCartItem": service4Url + "/orderCart/add", //添加购物车
  "updateCheckedCart": service4Url + "/orderCart/updateCheckOrderCartItem", //更新选中的购物车状态
  "findNewCartItemList": service4Url + "/orderCart/viewOrderCartListByChecked", //查询选中购物车预览
  "deleteCartByChecked": service4Url + "/orderCart/deleteCartByChecked", //删除选中购物车
  "checkedAllCart": service4Url + "/orderCart/checkedAllCart", //全选购物车
  "addOrderByOrderCart": service4Url + "/orderCart/addOrderByOrderCart", //选中的购物车立即下单
  "addOrderView": service4Url + "/orderCart/addOrderView", //立即购买查看预览
  "addOrder": service4Url + "/orderCart/addOrder", //立即下单
  "cartToCollectionByChecked": service4Url + "/orderCart/cartToCollectionByChecked", //选中移入收藏

  ///订单模块
  "findAllOrderList": service4Url + "/order/findAllOrderList",
  //查看全部订单列表

  "findWaitingPaymentList": service4Url + "/order/findWaitingPaymentList",
  //(待付款)待付款订单列表
  "findWaitingPaymentById": service4Url + "/order/findWaitingPaymentById",
  //(待付款  详情)根据订单id查询单个待付款订单详情
  "removeWaitingPaymentById": service4Url + "/order/removeWaitingPaymentById",
  //(待付款)根据待付款订单id取消订单
  "updateWaitingPaymentAddressById": service4Url + "/order/updateWaitingPaymentAddressById",
  //(待付款)修改未支付订单地址

  "findWaitShipmentList": service4Url + "/order/findWaitShipmentList",
  //(待发货)查询待发货列表
  "checkShipmentAddress": service4Url + "/order/checkShipmentAddress",
  //(待发货)检查是否能修改待发货地址
  "updateShipmentById": service4Url + "/order/updateShipmentById",
  //(待发货)修改待发货订单地址
  "getWaitShipmentInfo": service4Url + "/order/getWaitShipmentInfo",
  //(待发货)查询某一个主订单下的待发货的订单详情(根据物流拆分)
  "checkReturnWaitShipment": service4Url + "/order/checkReturnWaitShipment",
  //(待发货退款)待发货校验退款
  "applyReturnByWaitShipment": service4Url + "/order/applyReturnByWaitShipment",
  //(待发货退款)发起待发货退款申请


  "findWaitReceiveCommodityList": service4Url + "/order/findWaitReceiveCommodityList", //(待收货)查询待收货列表
  "confirmWaitReceive": service4Url + "/order/confirmWaitReceive", //(待收货)确认收货
  "getWaitReceiveByMisId": service4Url + "/order/getWaitReceiveByMisId", //(待收货 详情)查询某个订单下的待收货详情
  "applyReturnByWaitReceive": service4Url + "/order/applyReturnByWaitReceive", //(待收货退款)发起待收货退款申请

  "commentOrderList": service4Url + "/order/commentOrderList", //(待评价)评论主订单下的多个子订单
  "findFinishOrderList": service4Url + "/order/findFinishOrderList", //(待评价)查询待评价的订单列表
  "getFinishOrderInfo": service4Url + "/order/getFinishOrderInfo", //(待评价)查询某一个主订单下的待评价的订单详情(根据物流拆分)

  "findAllOrderReturnCauseList": service4Url + "/order/findAllOrderReturnCauseList", //退款模板理由列表
  "findOrderReturnList": service4Url + "/order/findOrderReturnList", //(退换)查看退换列表
  "findOrderReturnInfo": service4Url + "/order/findOrderReturnInfo", //(退换)查看退换详情
  "deleteFinishOrder": service4Url + "/order/deleteFinishOrder", //删除已完成订单
  "findMisByOrderInventoryId": service4Url + "/orderMis/findMisByOrderInventoryId", //根据仓库订单id查询物流详情
  //支付成功
  "successOrder": service4Url + "/order/successOrder", //支付成功回调

  "applyForTheInvoice": service4Url + "/invoice/applyForTheInvoice", //申请发票

  ///优惠券
  "getMyCouponList": service4Url + "/coupon/getMyCouponList", //查询我的优惠券
  "getCouponCentre": service4Url + "/coupon/getCouponCentre", //领劵中心优惠券
  "delCoupon": service4Url + "/coupon/delCoupon", //删除优惠券
  "receiveCoupon": service4Url + "/coupon/receiveCoupon", //领取优惠券
  "getCouponOrderList": service4Url + "/coupon/getCouponOrderList", //订单红包领取列表


  //   发现
  'discoverQueryList': service4Url + '/shop/discoverQueryList', //发现页
  'querySeries': service4Url + '/shop/querySeries', //签到
  'MoodqueryList': service4Url + '/shopMood/queryList', //心情卡
  'conSaveMood': service4Url + '/shopMood/conSaveMood',//签到
  'checkSign':service4Url + '/shopMood/checkSign',//检查签到状态

  ///文章模块
  "catagoryQueryList": service4Url + "/shop/catagoryQueryList", //自定义查询列表
  "appArtList": service4Url + "/shop/appArtList", //文章app接口
  'artQueryList':service4Url + "/shop/artQueryList", //文章具体详情接口
  "artCommentSaveOrUpdate": service4Url + "/shop/artCommentSaveOrUpdate", //保存或更新文章评论
  'addCollectionArticle':service4Url + "/consumer/addCollectionArticle", //收藏文章 点爱心
  'removeCollectionArticle':service4Url + "/consumer/removeCollectionArticle", //取消收藏文章点爱心
  'artCommentQueryList':service4Url + '/shop/artCommentQueryList', //评论列表


  ///微信支付模块
  "createOrder": service4Url + "/wxpay/app/createOrder", //普通订单APP调用支付统一下单
  "checkOrderIsPad": service4Url + "/wxpay/app/checkOrderIsPad", //app回调查询支付结果
  "createOrders": service4Url + "/wxpay/app/vip/createOrder", //开通会员APP调用支付统一下单
  "addOrders": service4Url + "/wxpay/notify/addOrder", //支付成功后调用
  // 装修
  'selfDefineQueryList':service4Url + "/shop/selfDefineQueryList",//根据id查装修详情
  "selectList":service4Url+ '/shopMainPage/selectList',//首页导航链接
  "homePageQueryList":service4Url +"/shop/homePageQueryList",//首页装修查询1
  "mainPageQueryList":service4Url +"/shop/mainPageQueryList",//首页装修查询2 新 带头部
  "brandQueryList":service4Url +"/shop/brandQueryList",//品牌页装修

  //积分商城
  "selectCreditsShopTitleById":service4Url +"/creditsShopTitle/selectCreditsShopTitleById",//根据分类id查询可兑换商品
  "selectOwnCreditsShopClassify":service4Url +"/creditsShop/selectOwnCreditsShopClassify",// 根据商品分类id找出所有该商品分类的积分商品
  "selectCreditsShopByid":service4Url +"/creditsShop/selectCreditsShopByid",//积分商城 -根据积分商品id去查找对应详细信息
  "insertCreditsShopRecord":service4Url +"/CreditsShopRecord/insertCreditsShopRecord",//点击兑换 消费者兑换积分商品
};
