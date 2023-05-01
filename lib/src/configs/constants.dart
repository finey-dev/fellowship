import 'package:flutter/material.dart';
import 'package:fellowship/src/configs/configs.dart';

const String appName = 'wefellowship';
const String fontFamilyName = 'Muli';

class AppAssetsPath {
  static const String heartSolid = 'assets/icons/heartS.svg';
  static const String heartOutline = 'assets/icons/heartT.svg';
  static const String back = 'assets/icons/back.svg';
  static const String chevronRight = 'assets/icons/right.svg';
  static const String error = 'assets/icons/close.svg';
  static const String logo = 'assets/images/wefellowship.png';
  static const String splash = 'assets/images/splash.jpg';
  static const String icon = 'assets/images/icon.png';
  static const String snackbarIcon = 'lib/assets/icons/snackicon.svg';
  static const String bubbles = 'lib/assets/icons/bubbles.svg';
  static const String help = 'assets/types/help.svg';
  static const String failure = 'assets/types/failure.svg';
  static const String success = 'assets/types/success.svg';
  static const String warning = 'assets/types/warning.svg';
  static const String delete = 'assets/types/trash.svg';
  static const String camera = 'assets/icons/camera.svg';
  static const String search = 'assets/icons/search.svg';
  static const String user = 'assets/icons/user.svg';
  static const String phone = 'assets/icons/phone.svg';
  static const String mail = 'assets/icons/mail.svg';
  static const String lock = 'assets/icons/lock.svg';
  static const String eye = 'assets/icons/eye.svg';
  static const String eyeSlash = 'assets/icons/eyeSlash.svg';
  static const String arrowUp = 'assets/icons/arrowUp.svg';
  static const String arrowDown = 'assets/icons/arrowDown.svg';
  static const String call = 'assets/icons/call.svg';
  static const String calender = 'assets/icons/calender.svg';
  static const String gender = 'assets/icons/gender.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String bio = 'assets/icons/bio.svg';
  static const String close = 'assets/icons/close.svg';
  static const String coinT = 'assets/icons/coin.svg';
  static const String coinS = 'assets/icons/coinB.svg';
  static const String homeS = 'assets/icons/home.svg';
  static const String homeT = 'assets/icons/homeT.svg';
  static const String mediaT = 'assets/icons/mediaT.svg';
  static const String mediaS = 'assets/icons/mediaS.svg';
  static const String profileT = 'assets/icons/profileT.svg';
  static const String profileS = 'assets/icons/profileS.svg';
  static const String gallery = 'assets/icons/gallery.svg';
  static const String messages = 'assets/icons/messages.svg';
  static const String bell = 'assets/icons/bell.svg';
  static const String heartT = 'assets/icons/heartT.svg';
  static const String heartS = 'assets/icons/heartS.svg';
  static const String commentT = 'assets/icons/commentT.svg';
  static const String commentS = 'assets/icons/commentS.svg';
  static const String studyS = 'assets/icons/studyS.svg';
  static const String studyT = 'assets/icons/studyT.svg';
  static const String play = 'assets/icons/play.svg';
  static const String forwardTen = 'assets/icons/forwardTen.svg';
  static const String backwardTen = 'assets/icons/backwardTen.svg';
  static const String volume = 'assets/icons/volume.svg';
  static const String volumeSlash = 'assets/icons/volumeSlash.svg';
  static const String more = 'assets/icons/more.svg';
  static const String videoOn = 'assets/icons/videoOn.svg';
  static const String videoOff = 'assets/icons/videoOff.svg';
  static const String micOn = 'assets/icons/micOn.svg';
  static const String micOff = 'assets/icons/micOff.svg';
  static const String stream = 'assets/icons/stream.svg';
  static const String bookmark = 'assets/icons/bookmark.svg';
  static const String share = 'assets/icons/share.svg';
  static const String settings = 'assets/icons/settings.svg';
  static const String question = 'assets/icons/question.svg';
  static const String poll = 'assets/icons/poll.svg';
  static const String send = 'assets/icons/send.svg';
  static const String relationship = 'assets/icons/relationship.svg';
  static const String helpCentre = 'assets/icons/help.svg';
  static const String logOut = 'assets/icons/logout.svg';
  static const String repeat = 'assets/icons/repeat.svg';
  static const String repeatOnce = 'assets/icons/repeatonce.svg';
  static const String next = 'assets/icons/next.svg';
  static const String previous = 'assets/icons/previous.svg';
  static const String music = 'assets/icons/music.svg';
  static const String podcast = 'assets/icons/podcast.svg';
  static const String download = 'assets/icons/download.svg';
  static const String moreVert = 'assets/icons/moreVert.svg';
  static const String like = 'assets/icons/like.svg';
  static const String dislike = 'assets/icons/dislike.svg';
  static const String save = 'assets/icons/save.svg';
  static const String notification = 'assets/icons/notification.svg';
  static const String expand = 'assets/icons/expand.svg';
  static const String minimize = 'assets/icons/minimize.svg';
  static const String trash = 'assets/icons/trash.svg';
  static const String linespacing = 'assets/icons/linespacing.svg';
}

const natureImages = <String>[
  'assets/images/nature1.jpg',
  'assets/images/nature3.jpg',
  'assets/images/nature4.jpg',
  'assets/images/nature5.jpg',
  'assets/images/nature6.jpg',
];

class FirebaseConstants {
  static const usersCollection = 'users';
  static const communitiesCollection = 'communities';
  static const chatsCollection = 'chats';
  static const postsCollection = 'posts';
  static const commentsCollection = 'comments';
}

const kPrimaryColor = Color(0xFFCBB26A);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kErrorColor = Color(0xFFff3333);

const kAnimationDuration = Duration(milliseconds: 200);
const defaultDuration = Duration(milliseconds: 250);
// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please enter a valid email address";
const String kInvalidEmailError = "Please enter a valid email address";
const String kPassNullError = "Please create a valid password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please enter a valid Name";
const String kPhoneNumberNullError = "Please enter a valid telephone number";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
