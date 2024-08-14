import 'package:Bubble/person/invitation_code_page.dart';
import 'package:Bubble/person/page/cancel_account_page.dart';
import 'package:Bubble/person/page/course_speaking_purchase_page.dart';
import 'package:Bubble/person/page/error_correction_detail_page.dart';
import 'package:Bubble/person/page/error_correction_page.dart';
import 'package:Bubble/person/page/join_community_page.dart';
import 'package:Bubble/person/page/user_membership_upgrade_page.dart';
import 'package:Bubble/person/page/xueersi_purchase_page.dart';
import 'package:Bubble/person/page/xueersi_purchase_success_page.dart';
import 'package:fluro/fluro.dart';

import '../routers/i_router.dart';
import 'about.dart';
import 'order.dart';
import 'person.dart';
import 'purchase.dart';
import 'setting.dart';
import 'suggestion_page.dart';

class PersonalRouter implements IRouterProvider {
  static String purchase = '/purchase';
  static String setting = '/setting';
  static String personalSuggestion = '/personal/Suggestion';
  static String personalInvitationcCode = '/personal/InvitationcCode';

  static String person = '/person';
  static String order = '/order';
  static String about = '/about';
  static String cancelAccountPage = '/CancelAccountPage';

  static String joinCommunityPage = '/JoinCommunityPage';

  static String errorCorrectionPage = '/ErrorCorrectionPage';
  static String errorCorrectionDetailPage = '/ErrorCorrectionDetailPage';
  // static String userMembershipUpgradePage = '/UserMembershipUpgradePage';

  static String courseSpeakingPurchasePage = '/CourseSpeakingPurchasePage';

  static String xueersiPurchasePage = '/XueersiPurchasePage';
  static String xueersiPurchaseSuccessPage = '/XueersiPurchaseSuccessPage';

  @override
  void initRouter(FluroRouter router) {
    router.define(xueersiPurchaseSuccessPage,
        handler: Handler(
            handlerFunc: (_, __) => const XueersiPurchaseSuccessPage()));

    router.define(xueersiPurchasePage,
        handler: Handler(handlerFunc: (context, params) {
      String goodPrice = params['goodPrice']!.first;
      String goodsId = params['goodsId']!.first;
      String type = params['type']!.first;

      return XueersiPurchasePage(
          goodPrice: goodPrice, goodsId: goodsId, type: type);
    }));

    router.define(person,
        handler: Handler(handlerFunc: (_, __) => const PersonPage()));
    router.define(setting,
        handler: Handler(handlerFunc: (_, __) => const SettingPage()));
    router.define(purchase,
        handler: Handler(handlerFunc: (_, __) => const PurchasePage()));
    router.define(order,
        handler: Handler(handlerFunc: (_, __) => const OrderPage()));
    router.define(personalSuggestion,
        handler: Handler(handlerFunc: (_, __) => const SuggestionPage()));
    router.define(personalInvitationcCode,
        handler: Handler(handlerFunc: (_, __) => const InvitationCodePage()));
    router.define(about,
        handler: Handler(handlerFunc: (_, __) => const AboutPage()));
    router.define(cancelAccountPage,
        handler: Handler(handlerFunc: (_, __) => const CancelAccountPage()));
    router.define(joinCommunityPage,
        handler: Handler(handlerFunc: (_, __) => const JoinCommunityPage()));
    router.define(errorCorrectionPage,
        handler: Handler(handlerFunc: (_, __) => const ErrorCorrectionPage()));

    router.define(errorCorrectionDetailPage,
        handler: Handler(handlerFunc: (context, params) {
      String lessonId = params['lessonId']!.first;
      return ErrorCorrectionDetailPage(
        lessonId: lessonId,
      );
    }));

    // router.define(courseSpeakingPurchasePage,
    //     handler: Handler(
    //         handlerFunc: (_, __) => const CourseSpeakingPurchasePage()));

    router.define(courseSpeakingPurchasePage,
        handler: Handler(handlerFunc: (context, params) {
      String levelId = params['levelId']!.first;
      String goodsLabel = params['goodsLabel']!.first;

      return CourseSpeakingPurchasePage(
        levelId: levelId,
        goodsLabel: goodsLabel,
      );
    }));

    // router.define(userMembershipUpgradePage,
    //     handler: Handler(handlerFunc: (context, params) {
    //   String levelId = params['levelId']!.first;
    //   String goodsLabel = params['goodsLabel']!.first;

    //   return UserMembershipUpgradePage(
    //     levelId: levelId,
    //     goodsLabel: goodsLabel,
    //   );
    // }));

    router.define(person,
        handler: Handler(handlerFunc: (_, __) => const PersonPage()));
  }
}
