class HttpApi {
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

  static const String collectInformation = 'evaluation';

  //获取版本号
  static const String updateApp = "version";

  //微信支付获取商户信息
  static const String wxOrder = "order";

  //购买记录
  static const String orderRecords = "order_list";

  //查询订单支付状态
  static const String queryOrderStatus = "query_order";

  //ApplePay验单
  static const String applePayValidate = "applepay_validate";

  //获取商品列表
  static const String goodList = "goods_list";

  //获取评分报告
  static const String coinReport = "score_detail";

  //添加评分
  static const String addScore = "add_score";

  //绑定微信
  static const String bindWX = "edit_user_wx";

  //解绑微信
  static const String unbindWX = "unbind_wx";

  //会话时常
  static const String studyInfo = "conversation_record";

  //用户信息
  static const String userInfo = "user_info";

  //获取基础配置
  static const String baseConfig = "variable_list";

  //一键登录
  static const String keyLogin = "jg_login";

  //学习报告的集合
  static const String studyReportList = "app/conversations";

  //口语报告详情-综合评价
  static const String scoreAllRound = "score_allround";

  //口语报告详情-地道表达
  static const String scoreSuggestion = "score_suggestion";

  //口语报告详情-细节解析
  static const String scoreAnalysis = "score_analysis";

  //意见反馈
  static const String suggestion = "reviews";

  //新增会话时长
  static const String addConversationRecord = 'add_conversation_record';

  //获取会话时长
  static const String permission = 'permission';

  //获取对话音频
  static const String speechList = 'speech_list';

  //上传图片
  static const String upload = 'uploadfile';

  static const String topicOrScene = 'scene_list';

  //获取oss上传
  static const String getOssSts = "oss_sts";

  //获取oss上传
  static const String suggestAnswer = "suggest_answer";

  //获取模考剩余使用次数
  static const String examPermission = "exam_permission";

  //获取模考次数商品
  static const String goodsList = "goods_list";

  //获取模考流程
  static const String examStep = "exam_step";

  //模考进度更新
  static const String examUpdata = "exam_update";

  //模考进度更新
  static const String examDetail = "exam_detail";
}
