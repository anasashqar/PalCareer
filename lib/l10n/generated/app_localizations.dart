import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PalCareer'**
  String get appTitle;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splashLoading;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Customize your career path'**
  String get onboardingWelcome;

  /// No description provided for @onboardingAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic Level'**
  String get onboardingAcademic;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @freshGraduate.
  ///
  /// In en, this message translates to:
  /// **'Fresh Graduate'**
  String get freshGraduate;

  /// No description provided for @onboardingField.
  ///
  /// In en, this message translates to:
  /// **'What is your field of study?'**
  String get onboardingField;

  /// No description provided for @fieldIt.
  ///
  /// In en, this message translates to:
  /// **'Information Technology'**
  String get fieldIt;

  /// No description provided for @fieldEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get fieldEngineering;

  /// No description provided for @fieldBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get fieldBusiness;

  /// No description provided for @fieldAccounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get fieldAccounting;

  /// No description provided for @fieldEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get fieldEducation;

  /// No description provided for @fieldMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get fieldMarketing;

  /// No description provided for @fieldHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get fieldHealthcare;

  /// No description provided for @fieldLaw.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get fieldLaw;

  /// No description provided for @fieldOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get fieldOther;

  /// No description provided for @onboardingWorkType.
  ///
  /// In en, this message translates to:
  /// **'Preferred Work Type'**
  String get onboardingWorkType;

  /// No description provided for @fullTime.
  ///
  /// In en, this message translates to:
  /// **'Full-time'**
  String get fullTime;

  /// No description provided for @partTime.
  ///
  /// In en, this message translates to:
  /// **'Part-time'**
  String get partTime;

  /// No description provided for @remote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remote;

  /// No description provided for @nextBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get nextBtn;

  /// No description provided for @saveFinishBtn.
  ///
  /// In en, this message translates to:
  /// **'Save & Finish'**
  String get saveFinishBtn;

  /// No description provided for @jobsHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover your opportunities'**
  String get jobsHomeTitle;

  /// No description provided for @availableJobs.
  ///
  /// In en, this message translates to:
  /// **'Available Jobs'**
  String get availableJobs;

  /// No description provided for @perfectMatchBadge.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get perfectMatchBadge;

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newBadge;

  /// No description provided for @noJobs.
  ///
  /// In en, this message translates to:
  /// **'No matching jobs at the moment'**
  String get noJobs;

  /// No description provided for @jobDetails.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get jobDetails;

  /// No description provided for @jobRequirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get jobRequirements;

  /// No description provided for @jobResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'Responsibilities'**
  String get jobResponsibilities;

  /// No description provided for @applyNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNowBtn;

  /// No description provided for @notificationCenter.
  ///
  /// In en, this message translates to:
  /// **'Notification Center'**
  String get notificationCenter;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest Alerts'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We found new jobs matching your career plan.'**
  String get notificationsSubtitle;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get yourProfile;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @pushNotificationsToggle.
  ///
  /// In en, this message translates to:
  /// **'Enable Push Notifications'**
  String get pushNotificationsToggle;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @logoutBtn.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutBtn;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @bookmarksTab.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get bookmarksTab;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
