
class HttpApi{
  //手机号登录
  static const String phoneLogin = 'mobile_login';

  //发送验证码
  static const String smsLogin = "send_sms_code";

  //老师集合(人物列表)
  static const String teacherList = "app/characters";

  //获取微信信息
  static const String wechatInfo = "wxinfo";
  //微信登录
  static const String wechatLogin = "wx_login?type=1";

  //获取版本号
  static const String updateApp = "version";

  //微信支付获取商户信息
  static const String wxOrder = "order";

  //购买记录
  static const String orderRecords = "order_list";

  //查询订单支付状态
  static const String queryOrderStatus = "query_order";

  //获取商品列表
  static const String goodList = "goods_list";

  //获取评分报告
  static const String coinReport = "score_detail";

  //绑定微信
  static const String bindWX = "edit_user_wx";

  //解绑微信
  static const String unbindWX = "unbind_wx";

  //会话时常
  static const String studyInfo = "conversation_record";

  //学习报告的集合
  static const String studyReportList = "app/conversations";

  //意见反馈
  static const String suggestion = "reviews";

  //新增会话时长
  static const String addConversationRecord = 'add_conversation_record';

  //获取会话时长
  static const String permission = 'permission';

  static const String upload = 'uuc/upload-inco';
}
