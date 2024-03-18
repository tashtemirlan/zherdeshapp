library zherdesh.globals;

bool isUserRegistered = false;
String userLanguage = "ru";
String accessToken = "";
String refreshToken = "";
//filter of search
List<String> chosenValue = [];
List<int> chosenValueIndex = [];
String chosenMetro = "";
int chosenMetroIndex = -1;

//global value of number advertises given : =>
int countNumberOfAdvertises = 50;

//todo: => here is all endpoints for project
String mainPath = "https://servicebackend.zherdesh.ru";
//todo => login and sign up
String endpointLogin = "$mainPath/api/v1/authentication/token/";
String endpointCheckEmailSignUp = "$mainPath/api/v1/authentication/users/check-email/";
String endpointNewPasswordCreation = "$mainPath/api/v1/authentication/users/check-passwords/";
String endpointNewUserTelephoneAndNameCreation = "$mainPath/api/v1/authentication/users/register/";
String endpointResetPassword = "$mainPath/api/v1/authentication/users/reset/password/";
String endpointResetPasswordConfirm = "$mainPath/api/v1/authentication/users/reset/password/confirm/";
String endpointCodeReset= "$mainPath/api/v1/authentication/users/reset/code/confirm/";
String endpointGetNewCode = "$mainPath/api/v1/authentication/users/register/send-sms-again/?email=";
String endpointRegisterGoogle = "$mainPath/api/v1/social_auth/google/";
String endpointRegisterVK= "$mainPath/api/v1/social_auth/vkontakte/";


//todo => user data :
String endpointGetUserData = "$mainPath/api/v1/authentication/users/me/";
String endpointGetTransactionList = "$mainPath/api/v1/cabinet/transactions/list?format=json";
String endpointGetAnnouncementList = "$mainPath/api/v1/account/bulletin/list/";
String endpointGetCategories = "$mainPath/api/v1/categories/category/list/";
String endpointGetMetros = "$mainPath/api/v1/categories/metro/list/";
String endpointGetVipLists = "$mainPath/api/v1/cabinet/user-status/list";
String endpointAddMoney = "$mainPath/api/v1/cabinet/payment/?money=";
String endpointGetUserAdvertiseList = "$mainPath/api/v1/announcement/user/list";
String endpointSaveUserData = "$mainPath/api/v1/account/user/update/";
String endpointBuyVipStatus = "$mainPath/api/v1/cabinet/buy-user-status?status=";

// todo :=> confirm email :
String endpointConfirmEmailToConfirmUser = "$mainPath/api/v1/account/confirm/email/";
String endpointSendCodeToConfirmUser = "$mainPath/api/v1/account/activate/email/";
String endpointChangePasswordUser = "$mainPath/api/v1/account/change-password/";
String endpointSendCodeAgainToConfirmUser = "$mainPath/api/v1/account/send/code/again/";

//todo :=> send promo code :
String endpointSendPromoCode = "$mainPath/api/v1/cabinet/promocode/activate";

//todo:=> Advertise :
String endpointPublishAdvertise = "$mainPath/api/v1/announcement/create";
String endpointGetInformationAdvertiseUser = "$mainPath/api/v1/announcement/update/retrieve/destroy/";
String endpointBuyVipToAdvertise = "$mainPath/api/v1/cabinet/buy/vip?announce=";
String endpointBuyTopToAdvertise = "$mainPath/api/v1/cabinet/buy/top?announce=";
String endpointBuyColoredToAdvertise = "$mainPath/api/v1/cabinet/buy/color?announce=";
String endpointEditAdvertise = "$mainPath/api/v1/announcement/update/retrieve/destroy/";
String endpointDeleteAdvertise = "$mainPath/api/v1/announcement/update/retrieve/destroy/";
String endpointGetRecomended = "$mainPath/api/v1/announcement/recommendations/";

//todo:=> home page :
String endpointGetHomeCategories = "$mainPath/api/v1/categories/category/list/home";
String endpointGetHomeStories = "$mainPath/api/v1/announcement/list/stories";
String endpointGetHomeBanners = "$mainPath/api/v1/announcement/list/banner";
String endpointGetHomeAdvertises = "$mainPath/api/v1/announcement/list/home";
String endpointGetAnotherUserAdvertises = "$mainPath/api/v1/announcement/detail/";
String endpointGetComplainList = "$mainPath/api/v1/announcement/complaint/list";
String endpointPostComplain = "$mainPath/api/v1/announcement/make/complaint";

//todo => search :
String endpointGetCategoriesAdvertises = "$mainPath/api/v1/announcement/list";
String endpointGetCategoriesAdvertisesSettings = "$mainPath/api/v1/categories/category/list/";

//todo :=> refresh tokens :
String endpointRefreshTokens = "$mainPath/api/v1/authentication/token/refresh/";