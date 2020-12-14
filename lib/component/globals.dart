library yamisok.globals;

String token = 'null';
final urlAPI = 'https://api.yamisok.com';
final baseUrlApi = 'https://api-mobile.yamisok.com';
final urlApiPro = 'https://api-v2.yamisok.com';
final statusApi = false;

var majorAndroid = 2;
var minorAndroid = 0;
var patchAndroid = 0;
var incrementAndroid = "0014";
var buildAndroid="beta";

var majorIOS = 2;
var minorIOS = 0;
var patchIOS = 0;
var incrementIOS = "0014";
var buildIOS="beta";




final urlImgLogoYams =
    'https://yamisok.com/assets/images/static/logo-yamisok.png';
var varMediaQuery;

final CLOUDINARY_API_KEY = '225954785957718';
final CLOUDINARY_API_SECRET = 'pUuZ2cNr9TeM8Mxm5vITExe9r6E';
final CLOUDINARY_CLOUD_NAME = 'yamisok';

final int DEFAULT_TIMEOUT = 10;

// Forgot Password
final URL_FORGOT_PASSWORD_VALIDATE_EMAIL =
    baseUrlApi + '/v1/users/forgot-password';
final URL_RESEND_EMAIL_VALIDATION =
    baseUrlApi + '/v1/users/forgot-password/resend-email';
final URL_RESET_PASSWORD = baseUrlApi + '/v1/users/reset-password';

// Verification Email
final URL_SEND_VERIFICATION_EMAIL =
    baseUrlApi + '/v1/users/registration/resend-email';
final URL_CHECK_VERIFICATION_EMAIL =
    baseUrlApi + '/v1/users/registration/check-verified-email';

// Term & Condition
final URL_TERM_CONDITION = baseUrlApi + '/v1/term-condition';

// Privacy Policy
final URL_PRIVACY_POLICY = baseUrlApi + '/v1/home/privacy';

// Firebase
final URL_SAVE_TOKEN_FIREBASE = baseUrlApi + '/v1/fcm/token/add';

// Update About Me
final URL_UPDATE_ABOUT_ME = baseUrlApi + '/v1/profile_aboutme/';

// update profile picture
final urlUpdateProfilePicture = baseUrlApi + '/v1/profile/upload/mobile';

// update status || short bio
final urlUpdateStatus = baseUrlApi + '/v1/profile_player';

// Edit Profile
final URL_UPDATE_PROFILE = baseUrlApi + '/v1/profile_playerinfo/';

// Notification Update
final URL_LIST_NOTIFICATION = baseUrlApi + '/v1/notification/all';
final URL_SEND_NOTIFICATION = baseUrlApi + '/v1/notification/push';
final URL_LIST_UPDATE = baseUrlApi + '/v1/announcement/get';

// Chat metrix
final URL_CHAT_METRICS = baseUrlApi + '/v1/announcement/get';
