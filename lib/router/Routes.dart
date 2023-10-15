import 'package:flutter/material.dart';
import 'package:flutter_widget_one/ui/home/article/article_page.dart';
import 'package:flutter_widget_one/ui/open/open_page.dart';
//导入路由文件
import '../ui/indexPage.dart';
import '../ui/open/open_page1.dart';
import '../ui/custom/testDemo.dart';
import '../ui/custom/custom_page.dart';
import '../ui/custom/preview_page.dart';
import '../ui/custom/details_page.dart';
import '../ui/custom/home_data.dart';
import '../ui/custom/test_page.dart';
import '../ui/custom/myTemplate_page.dart';
import '../ui/myCenter/register/my_page.dart';
import '../ui/myCenter/register/addAddess_page.dart';
import '../ui/myCenter/password/forget_password_page.dart';
import '../ui/myCenter/password/login_page.dart';
import '../ui/myCenter/register/setting_page.dart';
import '../ui/myCenter/register/account_page.dart';
import '../ui/myCenter/register/change_the_binding_page.dart';
import '../ui/myCenter/register/change_password.dart';
import '../ui/myCenter/password/slip_page.dart';
import '../ui/myCenter/register/personal_details_page.dart';
import '../ui/myCenter/register/uploading_image_page.dart';
import '../ui/myCenter/register/certification_page.dart';
import '../ui/myCenter/register/shipping_address_page.dart';
import '../ui/myCenter/register/bind_email_page.dart';
import '../ui/myCenter/register/changePhone_page.dart';
import '../ui/myCenter/register/amendAddres_page.dart';
import '../ui/myCenter/register/interest_page.dart';
import '../ui/myCenter/password/wx_login.dart';
import '../ui/myCenter/shop/share_txt.dart';
import '../ui/myCenter/shop/share_h5.dart';
import '../ui/myCenter/register/particularsToReal.dart';
import '../ui/myCenter/register/about_page.dart';
import '../ui/myCenter/commodity/commodity_details.dart';
import '../ui/myCenter/commodity/collect_page.dart';
import '../ui/myCenter/commodity/footprint_page.dart';
import '../untils/listBox/color_cards.dart';
import '../ui/myCenter/register/realName.dart';
import '../ui/myCenter/commodity/comment.dart';
import '../ui/shopCart/closeAccount.dart';
import '../ui/shopCart/discount_page.dart';
import '../ui/shop/classify/second_classifyPage.dart';
import '../ui/shop/classify/search_page.dart';
import '../ui/shop/classify/scan_view.dart';
import '../ui/shop/classify/all_brandPage.dart';
import '../ui/myCenter/order/order_page.dart';
import '../ui/myCenter/order/evaluate_page.dart';
import '../ui/myCenter/order/invoice_page.dart';
import '../ui/myCenter/order/payment_page.dart';
import '../ui/myCenter/order/cancel_page.dart';
import '../ui/myCenter/order/consignment_page.dart';
import '../ui/myCenter/order/refund_page.dart';
import '../ui/myCenter/order/harvest_page.dart';
import '../ui/myCenter/order/logistics_page.dart';
import '../ui/myCenter/order/protocol_page.dart';
import '../ui/myCenter/order/return_applyPage.dart';
import '../ui/myCenter/order/want_returnPage.dart';
import '../ui/myCenter/order/swap_page.dart';
import '../ui/myCenter/personal/personal_center.dart';
import '../ui/myCenter/order/comment_page.dart';
import '../ui/myCenter/order/after_page.dart';
import '../ui/myCenter/order/schedule_page.dart';
import '../ui/myCenter/order/sales_page.dart';
import '../ui/myCenter/order/barter_page.dart';
import '../ui/myCenter/order/stocks_page.dart';
import '../ui/myCenter/integral/detail_page.dart';
import '../ui/myCenter/commodity/myFavorite_page.dart';
import '../ui/myCenter/integral/integral_shopPage.dart';
import '../ui/myCenter/integral/rule_page.dart';
import '../ui/shop/classify/classify_page.dart';
import '../untils/element/tests.dart';
import '../ui/home/sign/sign_page.dart';
import '../ui/shopCart/coupon.dart';
import '../ui/myCenter/vipCenter/vip_center.dart';
import '../ui/myCenter/vipCenter/dredge_vip.dart';
import '../ui/myCenter/vipCenter/renew_vip.dart';
import '../ui/myCenter/vipCenter/vipRule.dart';
import '../ui/myCenter/vipCenter/privilege_vip.dart';
import '../ui/myCenter/vipCenter/rule.dart';
import '../ui/shopCart/redPackages.dart';
import '../ui/myCenter/integral/exchange.dart';
import '../ui/myCenter/integral/products_page.dart';
import '../ui/myCenter/register/message_page.dart';

final routes = {
  '/':(context) => OpenPage(),//根路由（开启动画）
  '/indexPage':(context) => indexPage(),
  '/tests':(context) => tests(),//测试
  '/CompilePage':(context) => OpenPages(),//编辑开启页
  '/testDemo':(context) => testDemo(),//自定义测试页面
  '/CustomPage':(context) => CustomPage(),//自定义
  '/HomeData':(context) => HomeData(),//首页数据预览
  '/MyTeplate':(context) => MyTeplate(),//我的模板
  "/PreviewPage":(context) => PreviewPage(),//自定义预览
  '/Colors1':(context) =>Colors1(),//颜色面板
  "/TestPage":(context)=>TestPage(),//测试页
  "/CustomDetailesPages":(context) => CustomDetailesPages(), // 自定义详情

  "/AddAddess":(context)=>AddAddess(),//新增收货地址

  '/LoginPage':(context,{arguments})=> LoginPage(arguments:arguments),//密码登录
  '/forgetPassword':(context,{arguments})=> ForgetPassword(),//个人中心忘记密码
  '/slipPage':(context,{arguments})=> SlipPage(),//登录忘记密码
  '/setting':(context,{arguments})=> Setting(),//个人中心设置页面
  '/aboutPage':(context,{arguments})=> AboutPage(),//关于珑梨派
  '/myPage':(context,{arguments})=> MyPages(),//个人中心
  '/account':(context,{arguments})=> Account(),//账户页面
  '/changeTheBinding':(context)=> ChangeTheBinding(),//更改绑定
  '/changePassword':(context,{arguments})=> ChangePassword(),//修改密码
  '/personalDetails':(context,{arguments})=> PersonalDetails(),//个人信息
  '/uploadingImage':(context,{arguments})=> UploadingImage(arguments:arguments),//上传头像
  '/certification':(context,{arguments})=> Certification(),//实名认证
  '/messagePage':(context,{arguments})=> MessagePage(),//实名认证
  '/shippingAddress':(context,{arguments})=> ShippingAddress(arguments:arguments),//收货地址
  '/vipCenterPage':(context,{arguments})=> VipCenterPage(arguments:arguments),//会员中心
  '/derdgeVipPage':(context,{arguments})=> DerdgeVipPage(arguments:arguments),//开通会员
  '/renewPage':(context,{arguments})=> RenewPage(arguments:arguments),//续费会员
  '/vipRulePage':(context)=> VipRulePage(),//会员服务协议
  '/privilegePage':(context,{arguments})=> PrivilegePage(arguments:arguments),//珑卡专享特权
  '/rulePage':(context)=> RulePage(),//会员规则

  '/protocol':(context,{arguments})=> Protocol(),//收货地址返回的是id
  '/couponPage':(context,{arguments})=> couponPage(),//领券中心

  '/addAddess':(context,{arguments})=> AddAddess(),//新增收货地址
  '/bindEmail':(context,{arguments})=> BindEmail(),//绑定邮箱
  "/changPhone":(context,{arguments})=> ChangPhone(),//绑定新手机号
  "/AmendAddAddes":(context,{arguments})=> AmendAddAddes(arguments:arguments),//修改已有的收货地址
  "/wxLongin":(context,{arguments})=> WxLongin(arguments:arguments),//微信登录
  "/realName":(context)=> RealName(),//实名认证库
  "/particularsToReal":(context,{arguments})=> ParticularsToReal(arguments:arguments),//实名认证详情
  "/interestPage":(context,{arguments})=> InterestPage(arguments:arguments),//感兴趣的标签
  "/classifyPage":(context)=> ClassifyPage(),//分类页面

  "/commodityDetails":(context)=> CommodityDetails(),//商品详情
  "/comment":(context)=> Comment(),//评论页
  "/ShareTextPage":(context)=>ShareTextPage(),//分享文字
  "/ShareWebPagePage":(context)=>ShareWebPagePage(),//分享h5

//  "/collect":(context)=>Collect(),//收藏页面
  "/MyFavoritePage":(context)=>MyFavoritePage(),//收藏页面
  "/footprint":(context)=>Footprint(),//足迹页面
  "/discount":(context)=>Discount(),//优惠券
  "/redPackages":(context)=>redPackages(),//红包
  "/detailPage":(context)=>DetailPage(),//积分明细
  "/integralShopPage":(context)=>IntegralShopPage(),//积分商城
  "/rulePae":(context)=>RulePae(),//积分规则
  "/exchangPage":(context)=>ExchangPage(),//积分兑优惠券
  "/productsPage":(context,{arguments})=>ProductsPage(arguments:arguments),//积分兑换商品详情
  "/order":(context,{arguments})=>Order(arguments:arguments),//优惠券
  "/ecaluatePage":(context,{arguments})=>EcaluatePage(arguments:arguments),//待评价订单详情
  "/consignmentPage":(context,{arguments})=>ConsignmentPage(arguments:arguments),//待发货订单详情
  "/harvestPage":(context,{arguments})=>HarvestPage(arguments:arguments),//待收货订单详情
  "/logisticsPage":(context,{arguments})=>LogisticsPage(arguments:arguments),//待收货物流
  "/invoice":(context,{arguments})=>Invoice(arguments:arguments),//发票
  "/paymentPage":(context,{arguments})=>PaymentPage(arguments:arguments),//代付款订单详情
  "/returnApply":(context,{arguments})=>ReturnApply(arguments:arguments),//退换申请页面 退款退货
  "/cancelPage":(context)=>CancelPage(),//待付款取消订单的弹窗
  "/refundPage":(context,{arguments})=>RefundPage(arguments:arguments),//待发货退款

  "/wantPage":(context,{arguments})=>WantPage(arguments:arguments),//我要退款无需退货

//  "/swapPage":(context,{arguments})=>SwapPage(),//换货申请

  "/stocksPage":(context,{arguments})=>StocksPage(),//订单交易完成详情

  "/commentPage":(context,{arguments})=>CommentPage(arguments:arguments),//订单发表评论页

  "/afterPage":(context,)=>AfterPage(),//订单售后

  "/schedulePage":(context,)=>SchedulePage(),//仅退款商品退换进度

  "/salesPage":(context,)=>SalesPage(),//退款退货 商品退换进度

  "/barterPage":(context,)=>BarterPage(),//换货详情 商品退换的进度

  "/closeAccount":(context,{arguments})=>CloseAccount(arguments:arguments),//结算页面

  "/secondClassifyPage":(context,{arguments})=>SecondClassifyPage(arguments:arguments),//搜索二级页面
  "/search":(context,{arguments})=>Search(),//搜索
  "/scanView":(context,)=>ScanView(),//扫描二维码
  "/allBrand":(context,)=>AllBrand(),//查看全部品牌

  "/personalCenterPage":(context,)=>PersonalCenterPage(),//我的
  "/signPage":(context,)=>signPage(),//我的
  '/ArticlePage':(context,{arguments})=>ArticlePage(arguments:arguments),
//  '/details':(context,{arguments}) => details(arguments:arguments),//视频详情
};

var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context,
                  arguments: settings.arguments));
      return route;
    } else {
      final Route route = MaterialPageRoute(
          builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};