//
//  DBConstantString.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/22.
//

#import "DBConstantString.h"
#import "GTMBase64.h"
static const DBConstantString *_constantModel;

@implementation DBConstantString

+ (void)initialize {
    _constantModel = [self parseModuleMappingJSON:@"constantString"];
}

+ (DBConstantString *)parseModuleMappingJSON:(NSString *)resource {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    jsonString = [GTMBase64 decodeBase64String:jsonString];
    DBConstantString *model = [DBConstantString yy_modelWithJSON:jsonString];
    if (!model){
        NSLog(@"异常!!!!!!异常!!!!!!!! %@",jsonString);
    }
    return model;
}

+ (NSString *)ks_back {
    return DBSafeString(_constantModel.ks_back);
}

+ (NSString *)ks_under10kWords {
    return DBSafeString(_constantModel.ks_under10kWords);
}

+ (NSString *)ks_popular {
    return DBSafeString(_constantModel.ks_popular);
}

+ (NSString *)ks_disclaimer {
    return DBSafeString(_constantModel.ks_disclaimer);
}

+ (NSString *)ks_reading {
    return DBSafeString(_constantModel.ks_reading);
}

+ (NSString *)ks_uniqueNicknameRequired {
    return DBSafeString(_constantModel.ks_uniqueNicknameRequired);
}

+ (NSString *)ks_urlProtagonistFormat {
    return DBSafeString(_constantModel.ks_urlProtagonistFormat);
}

+ (NSString *)ks_settings {
    return DBSafeString(_constantModel.ks_settings);
}

+ (NSString *)ks_noSearchHistory {
    return DBSafeString(_constantModel.ks_noSearchHistory);
}

+ (NSString *)ks_reviews {
    return DBSafeString(_constantModel.ks_reviews);
}

+ (NSString *)ks_netCacheCleared {
    return DBSafeString(_constantModel.ks_netCacheCleared);
}

+ (NSString *)ks_enterTitleOrAuthor {
    return DBSafeString(_constantModel.ks_enterTitleOrAuthor);
}

+ (NSString *)ks_clearCache {
    return DBSafeString(_constantModel.ks_clearCache);
}

+ (NSString *)ks_pointsSuffix {
    return DBSafeString(_constantModel.ks_pointsSuffix);
}

+ (NSString *)ks_selectedCount {
    return DBSafeString(_constantModel.ks_selectedCount);
}

+ (NSString *)ks_fiveStar {
    return DBSafeString(_constantModel.ks_fiveStar);
}

+ (NSString *)ks_home {
    return DBSafeString(_constantModel.ks_home);
}

+ (NSString *)ks_read {
    return DBSafeString(_constantModel.ks_read);
}

+ (NSString *)ks_unavailable {
    return DBSafeString(_constantModel.ks_unavailable);
}

+ (NSString *)ks_unfold {
    return DBSafeString(_constantModel.ks_unfold);
}

+ (NSString *)ks_general {
    return DBSafeString(_constantModel.ks_general);
}

+ (NSString *)ks_enterPhoneNumber {
    return DBSafeString(_constantModel.ks_enterPhoneNumber);
}

+ (NSString *)ks_sortBy {
    return DBSafeString(_constantModel.ks_sortBy);
}

+ (NSString *)ks_clear {
    return DBSafeString(_constantModel.ks_clear);
}

+ (NSString *)ks_categories {
    return DBSafeString(_constantModel.ks_categories);
}

+ (NSString *)ks_noResults {
    return DBSafeString(_constantModel.ks_noResults);
}

+ (NSString *)ks_guidelines {
    return DBSafeString(_constantModel.ks_guidelines);
}

+ (NSString *)ks_agreementHint {
    return DBSafeString(_constantModel.ks_agreementHint);
}

+ (NSString *)ks_enterNewPassword {
    return DBSafeString(_constantModel.ks_enterNewPassword);
}

+ (NSString *)ks_maxScoreError {
    return DBSafeString(_constantModel.ks_maxScoreError);
}

+ (NSString *)ks_gotIt {
    return DBSafeString(_constantModel.ks_gotIt);
}

+ (NSString *)ks_violationProcessTime {
    return DBSafeString(_constantModel.ks_violationProcessTime);
}

+ (NSString *)ks_flip {
    return DBSafeString(_constantModel.ks_flip);
}

+ (NSString *)ks_readsFormat {
    return DBSafeString(_constantModel.ks_readsFormat);
}

+ (NSString *)ks_signUp {
    return DBSafeString(_constantModel.ks_signUp);
}

+ (NSString *)ks_pending {
    return DBSafeString(_constantModel.ks_pending);
}

+ (NSString *)ks_poor {
    return DBSafeString(_constantModel.ks_poor);
}

+ (NSString *)ks_cellularDownloadWarning {
    return DBSafeString(_constantModel.ks_cellularDownloadWarning);
}

+ (NSString *)ks_awesome {
    return DBSafeString(_constantModel.ks_awesome);
}

+ (NSString *)ks_active {
    return DBSafeString(_constantModel.ks_active);
}

+ (NSString *)ks_clearBookCacheConfirm {
    return DBSafeString(_constantModel.ks_clearBookCacheConfirm);
}

+ (NSString *)ks_yesterdayTimeFormat {
    return DBSafeString(_constantModel.ks_yesterdayTimeFormat);
}

+ (NSString *)ks_searchBooksHint {
    return DBSafeString(_constantModel.ks_searchBooksHint);
}

+ (NSString *)ks_rateUsPrompt {
    return DBSafeString(_constantModel.ks_rateUsPrompt);
}

+ (NSString *)ks_clearAllChaptersWarning {
    return DBSafeString(_constantModel.ks_clearAllChaptersWarning);
}

+ (NSString *)ks_uploadSuccess {
    return DBSafeString(_constantModel.ks_uploadSuccess);
}

+ (NSString *)ks_feedbackOpinion {
    return DBSafeString(_constantModel.ks_feedbackOpinion);
}

+ (NSString *)ks_chapterListError {
    return DBSafeString(_constantModel.ks_chapterListError);
}

+ (NSString *)ks_updateNow {
    return DBSafeString(_constantModel.ks_updateNow);
}

+ (NSString *)ks_requestFulfilledStatus {
    return DBSafeString(_constantModel.ks_requestFulfilledStatus);
}

+ (NSString *)ks_readingPreferenceHint {
    return DBSafeString(_constantModel.ks_readingPreferenceHint);
}

+ (NSString *)ks_replySuffix {
    return DBSafeString(_constantModel.ks_replySuffix);
}

+ (NSString *)ks_block {
    return DBSafeString(_constantModel.ks_block);
}

+ (NSString *)ks_later {
    return DBSafeString(_constantModel.ks_later);
}

+ (NSString *)ks_rateUs {
    return DBSafeString(_constantModel.ks_rateUs);
}

+ (NSString *)ks_searchResults {
    return DBSafeString(_constantModel.ks_searchResults);
}

+ (NSString *)ks_blueLightFilter {
    return DBSafeString(_constantModel.ks_blueLightFilter);
}

+ (NSString *)ks_eyeCareMode {
    return DBSafeString(_constantModel.ks_eyeCareMode);
}

+ (NSString *)ks_yes {
    return DBSafeString(_constantModel.ks_yes);
}

+ (NSString *)ks_ok {
    return DBSafeString(_constantModel.ks_ok);
}

+ (NSString *)ks_belowMinScore {
    return DBSafeString(_constantModel.ks_belowMinScore);
}

+ (NSString *)ks_changeCoverConfirm {
    return DBSafeString(_constantModel.ks_changeCoverConfirm);
}

+ (NSString *)ks_noCachedBooks {
    return DBSafeString(_constantModel.ks_noCachedBooks);
}

+ (NSString *)ks_me {
    return DBSafeString(_constantModel.ks_me);
}

+ (NSString *)ks_verificationCodeSent {
    return DBSafeString(_constantModel.ks_verificationCodeSent);
}

+ (NSString *)ks_notDownloaded {
    return DBSafeString(_constantModel.ks_notDownloaded);
}

+ (NSString *)ks_noReadingHistory {
    return DBSafeString(_constantModel.ks_noReadingHistory);
}

+ (NSString *)ks_readingModesHint {
    return DBSafeString(_constantModel.ks_readingModesHint);
}

+ (NSString *)ks_rateFirst {
    return DBSafeString(_constantModel.ks_rateFirst);
}

+ (NSString *)ks_feedback {
    return DBSafeString(_constantModel.ks_feedback);
}

+ (NSString *)ks_noBooks {
    return DBSafeString(_constantModel.ks_noBooks);
}

+ (NSString *)ks_requiredAuthorField {
    return DBSafeString(_constantModel.ks_requiredAuthorField);
}

+ (NSString *)ks_thirtyMinutes {
    return DBSafeString(_constantModel.ks_thirtyMinutes);
}

+ (NSString *)ks_blockSuccess {
    return DBSafeString(_constantModel.ks_blockSuccess);
}

+ (NSString *)ks_wordCountFormat {
    return DBSafeString(_constantModel.ks_wordCountFormat);
}

+ (NSString *)ks_share {
    return DBSafeString(_constantModel.ks_share);
}

+ (NSString *)ks_peopleSuffix {
    return DBSafeString(_constantModel.ks_peopleSuffix);
}

+ (NSString *)ks_tenThousandSuffix {
    return DBSafeString(_constantModel.ks_tenThousandSuffix);
}

+ (NSString *)ks_tenThousand {
    return DBSafeString(_constantModel.ks_tenThousand);
}

+ (NSString *)ks_phone {
    return DBSafeString(_constantModel.ks_phone);
}

+ (NSString *)ks_clearBookCache {
    return DBSafeString(_constantModel.ks_clearBookCache);
}

+ (NSString *)ks_totalCount {
    return DBSafeString(_constantModel.ks_totalCount);
}

+ (NSString *)ks_timer {
    return DBSafeString(_constantModel.ks_timer);
}

+ (NSString *)ks_deleteAccount {
    return DBSafeString(_constantModel.ks_deleteAccount);
}

+ (NSString *)ks_qrCodeScanHint {
    return DBSafeString(_constantModel.ks_qrCodeScanHint);
}

+ (NSString *)ks_readingMinutes {
    return DBSafeString(_constantModel.ks_readingMinutes);
}

+ (NSString *)ks_noRequests {
    return DBSafeString(_constantModel.ks_noRequests);
}

+ (NSString *)ks_emptyChapter {
    return DBSafeString(_constantModel.ks_emptyChapter);
}

+ (NSString *)ks_invalidPassword {
    return DBSafeString(_constantModel.ks_invalidPassword);
}

+ (NSString *)ks_empty {
    return DBSafeString(_constantModel.ks_empty);
}

+ (NSString *)ks_skip {
    return DBSafeString(_constantModel.ks_skip);
}

+ (NSString *)ks_passwordChanged {
    return DBSafeString(_constantModel.ks_passwordChanged);
}

+ (NSString *)ks_unread {
    return DBSafeString(_constantModel.ks_unread);
}

+ (NSString *)ks_syncShelf {
    return DBSafeString(_constantModel.ks_syncShelf);
}

+ (NSString *)ks_searchAll {
    return DBSafeString(_constantModel.ks_searchAll);
}

+ (NSString *)ks_minMaxScoreError {
    return DBSafeString(_constantModel.ks_minMaxScoreError);
}

+ (NSString *)ks_details {
    return DBSafeString(_constantModel.ks_details);
}

+ (NSString *)ks_writeReview {
    return DBSafeString(_constantModel.ks_writeReview);
}

+ (NSString *)ks_contact {
    return DBSafeString(_constantModel.ks_contact);
}

+ (NSString *)ks_sixtyMinutes {
    return DBSafeString(_constantModel.ks_sixtyMinutes);
}

+ (NSString *)ks_completed {
    return DBSafeString(_constantModel.ks_completed);
}

+ (NSString *)ks_reply {
    return DBSafeString(_constantModel.ks_reply);
}

+ (NSString *)ks_about {
    return DBSafeString(_constantModel.ks_about);
}

+ (NSString *)ks_removedFromShelf {
    return DBSafeString(_constantModel.ks_removedFromShelf);
}

+ (NSString *)ks_chapterFormat {
    return DBSafeString(_constantModel.ks_chapterFormat);
}

+ (NSString *)ks_enterSearchText {
    return DBSafeString(_constantModel.ks_enterSearchText);
}

+ (NSString *)ks_saveForLater {
    return DBSafeString(_constantModel.ks_saveForLater);
}

+ (NSString *)ks_viewAllReplies {
    return DBSafeString(_constantModel.ks_viewAllReplies);
}

+ (NSString *)ks_chapters {
    return DBSafeString(_constantModel.ks_chapters);
}

+ (NSString *)ks_bookmarks {
    return DBSafeString(_constantModel.ks_bookmarks);
}

+ (NSString *)ks_passwordNewMismatch {
    return DBSafeString(_constantModel.ks_passwordNewMismatch);
}

+ (NSString *)ks_noneSelected {
    return DBSafeString(_constantModel.ks_noneSelected);
}

+ (NSString *)ks_heitiFont {
    return DBSafeString(_constantModel.ks_heitiFont);
}

+ (NSString *)ks_history {
    return DBSafeString(_constantModel.ks_history);
}

+ (NSString *)ks_book {
    return DBSafeString(_constantModel.ks_book);
}

+ (NSString *)ks_addToShelfFailed {
    return DBSafeString(_constantModel.ks_addToShelfFailed);
}

+ (NSString *)ks_registrationAgreement {
    return DBSafeString(_constantModel.ks_registrationAgreement);
}

+ (NSString *)ks_speed {
    return DBSafeString(_constantModel.ks_speed);
}

+ (NSString *)ks_standard {
    return DBSafeString(_constantModel.ks_standard);
}

+ (NSString *)ks_nickname {
    return DBSafeString(_constantModel.ks_nickname);
}

+ (NSString *)ks_byAuthorFormat {
    return DBSafeString(_constantModel.ks_byAuthorFormat);
}

+ (NSString *)ks_quickRate {
    return DBSafeString(_constantModel.ks_quickRate);
}

+ (NSString *)ks_viewBookstore {
    return DBSafeString(_constantModel.ks_viewBookstore);
}

+ (NSString *)ks_fontError {
    return DBSafeString(_constantModel.ks_fontError);
}

+ (NSString *)ks_terms {
    return DBSafeString(_constantModel.ks_terms);
}

+ (NSString *)ks_confirm {
    return DBSafeString(_constantModel.ks_confirm);
}

+ (NSString *)ks_lastChapterReached {
    return DBSafeString(_constantModel.ks_lastChapterReached);
}

+ (NSString *)ks_enterOriginalUrl {
    return DBSafeString(_constantModel.ks_enterOriginalUrl);
}

+ (NSString *)ks_commentGuidelines {
    return DBSafeString(_constantModel.ks_commentGuidelines);
}

+ (NSString *)ks_enterVerificationCode {
    return DBSafeString(_constantModel.ks_enterVerificationCode);
}

+ (NSString *)ks_noUpdates {
    return DBSafeString(_constantModel.ks_noUpdates);
}

+ (NSString *)ks_systemFont {
    return DBSafeString(_constantModel.ks_systemFont);
}

+ (NSString *)ks_disgusting {
    return DBSafeString(_constantModel.ks_disgusting);
}

+ (NSString *)ks_yesterday {
    return DBSafeString(_constantModel.ks_yesterday);
}

+ (NSString *)ks_ongoing {
    return DBSafeString(_constantModel.ks_ongoing);
}

+ (NSString *)ks_cached {
    return DBSafeString(_constantModel.ks_cached);
}

+ (NSString *)ks_viewReviews {
    return DBSafeString(_constantModel.ks_viewReviews);
}

+ (NSString *)ks_xingkaiBold {
    return DBSafeString(_constantModel.ks_xingkaiBold);
}

+ (NSString *)ks_accountRecoveryNotice {
    return DBSafeString(_constantModel.ks_accountRecoveryNotice);
}

+ (NSString *)ks_qrCodeSaveFailed {
    return DBSafeString(_constantModel.ks_qrCodeSaveFailed);
}

+ (NSString *)ks_ascending {
    return DBSafeString(_constantModel.ks_ascending);
}

+ (NSString *)ks_store {
    return DBSafeString(_constantModel.ks_store);
}

+ (NSString *)ks_describeIssuePrompt {
    return DBSafeString(_constantModel.ks_describeIssuePrompt);
}

+ (NSString *)ks_readPercentage {
    return DBSafeString(_constantModel.ks_readPercentage);
}

+ (NSString *)ks_changePassword {
    return DBSafeString(_constantModel.ks_changePassword);
}

+ (NSString *)ks_delete {
    return DBSafeString(_constantModel.ks_delete);
}

+ (NSString *)ks_selectAll {
    return DBSafeString(_constantModel.ks_selectAll);
}

+ (NSString *)ks_bookTitleFormat {
    return DBSafeString(_constantModel.ks_bookTitleFormat);
}

+ (NSString *)ks_save {
    return DBSafeString(_constantModel.ks_save);
}

+ (NSString *)ks_report {
    return DBSafeString(_constantModel.ks_report);
}

+ (NSString *)ks_thirdPartyData {
    return DBSafeString(_constantModel.ks_thirdPartyData);
}

+ (NSString *)ks_savedBooksCount {
    return DBSafeString(_constantModel.ks_savedBooksCount);
}

+ (NSString *)ks_font {
    return DBSafeString(_constantModel.ks_font);
}

+ (NSString *)ks_accountRecoveryEmail {
    return DBSafeString(_constantModel.ks_accountRecoveryEmail);
}

+ (NSString *)ks_bookManagementHint {
    return DBSafeString(_constantModel.ks_bookManagementHint);
}

+ (NSString *)ks_all {
    return DBSafeString(_constantModel.ks_all);
}

+ (NSString *)ks_enterProtagonist {
    return DBSafeString(_constantModel.ks_enterProtagonist);
}

+ (NSString *)ks_privacyPolicy {
    return DBSafeString(_constantModel.ks_privacyPolicy);
}

+ (NSString *)ks_aboveMaxScore {
    return DBSafeString(_constantModel.ks_aboveMaxScore);
}

+ (NSString *)ks_hot {
    return DBSafeString(_constantModel.ks_hot);
}

+ (NSString *)ks_topReads {
    return DBSafeString(_constantModel.ks_topReads);
}

+ (NSString *)ks_ad {
    return DBSafeString(_constantModel.ks_ad);
}

+ (NSString *)ks_noCollections {
    return DBSafeString(_constantModel.ks_noCollections);
}

+ (NSString *)ks_uploadFeaturesHint {
    return DBSafeString(_constantModel.ks_uploadFeaturesHint);
}

+ (NSString *)ks_feedbackTime {
    return DBSafeString(_constantModel.ks_feedbackTime);
}

+ (NSString *)ks_noCacheToClear {
    return DBSafeString(_constantModel.ks_noCacheToClear);
}

+ (NSString *)ks_bookCountFormat {
    return DBSafeString(_constantModel.ks_bookCountFormat);
}

+ (NSString *)ks_narrationVoice {
    return DBSafeString(_constantModel.ks_narrationVoice);
}

+ (NSString *)ks_booklistDescription {
    return DBSafeString(_constantModel.ks_booklistDescription);
}

+ (NSString *)ks_enterText {
    return DBSafeString(_constantModel.ks_enterText);
}

+ (NSString *)ks_fair {
    return DBSafeString(_constantModel.ks_fair);
}

+ (NSString *)ks_realistic {
    return DBSafeString(_constantModel.ks_realistic);
}

+ (NSString *)ks_cacheCleared {
    return DBSafeString(_constantModel.ks_cacheCleared);
}

+ (NSString *)ks_shareVia {
    return DBSafeString(_constantModel.ks_shareVia);
}

+ (NSString *)ks_addToShelfConfirm {
    return DBSafeString(_constantModel.ks_addToShelfConfirm);
}

+ (NSString *)ks_newest {
    return DBSafeString(_constantModel.ks_newest);
}

+ (NSString *)ks_notice {
    return DBSafeString(_constantModel.ks_notice);
}

+ (NSString *)ks_saving {
    return DBSafeString(_constantModel.ks_saving);
}

+ (NSString *)ks_serializing {
    return DBSafeString(_constantModel.ks_serializing);
}

+ (NSString *)ks_bookCache {
    return DBSafeString(_constantModel.ks_bookCache);
}

+ (NSString *)ks_overLimit {
    return DBSafeString(_constantModel.ks_overLimit);
}

+ (NSString *)ks_otherError {
    return DBSafeString(_constantModel.ks_otherError);
}

+ (NSString *)ks_unfavorited {
    return DBSafeString(_constantModel.ks_unfavorited);
}

+ (NSString *)ks_booksCount {
    return DBSafeString(_constantModel.ks_booksCount);
}

+ (NSString *)ks_selectRequestType {
    return DBSafeString(_constantModel.ks_selectRequestType);
}

+ (NSString *)ks_alreadyInShelf {
    return DBSafeString(_constantModel.ks_alreadyInShelf);
}

+ (NSString *)ks_male {
    return DBSafeString(_constantModel.ks_male);
}

+ (NSString *)ks_passwordRecovered {
    return DBSafeString(_constantModel.ks_passwordRecovered);
}

+ (NSString *)ks_reload {
    return DBSafeString(_constantModel.ks_reload);
}

+ (NSString *)ks_noBooklists {
    return DBSafeString(_constantModel.ks_noBooklists);
}

+ (NSString *)ks_minutesAgo {
    return DBSafeString(_constantModel.ks_minutesAgo);
}

+ (NSString *)ks_myBooks {
    return DBSafeString(_constantModel.ks_myBooks);
}

+ (NSString *)ks_flipSpeed {
    return DBSafeString(_constantModel.ks_flipSpeed);
}

+ (NSString *)ks_noSynopsis {
    return DBSafeString(_constantModel.ks_noSynopsis);
}

+ (NSString *)ks_avatar {
    return DBSafeString(_constantModel.ks_avatar);
}

+ (NSString *)ks_enterAuthorName {
    return DBSafeString(_constantModel.ks_enterAuthorName);
}

+ (NSString *)ks_statusFormat {
    return DBSafeString(_constantModel.ks_statusFormat);
}

+ (NSString *)ks_aboutVersion {
    return DBSafeString(_constantModel.ks_aboutVersion);
}

+ (NSString *)ks_ranking {
    return DBSafeString(_constantModel.ks_ranking);
}

+ (NSString *)ks_titleFormat {
    return DBSafeString(_constantModel.ks_titleFormat);
}

+ (NSString *)ks_downloaded {
    return DBSafeString(_constantModel.ks_downloaded);
}

+ (NSString *)ks_reset {
    return DBSafeString(_constantModel.ks_reset);
}

+ (NSString *)ks_setSpacingHint {
    return DBSafeString(_constantModel.ks_setSpacingHint);
}

+ (NSString *)ks_selectTypeFirst {
    return DBSafeString(_constantModel.ks_selectTypeFirst);
}

+ (NSString *)ks_requiredField {
    return DBSafeString(_constantModel.ks_requiredField);
}

+ (NSString *)ks_communityRules {
    return DBSafeString(_constantModel.ks_communityRules);
}

+ (NSString *)ks_moreByAuthor {
    return DBSafeString(_constantModel.ks_moreByAuthor);
}

+ (NSString *)ks_night {
    return DBSafeString(_constantModel.ks_night);
}

+ (NSString *)ks_notNow {
    return DBSafeString(_constantModel.ks_notNow);
}

+ (NSString *)ks_terrible {
    return DBSafeString(_constantModel.ks_terrible);
}

+ (NSString *)ks_minutes {
    return DBSafeString(_constantModel.ks_minutes);
}

+ (NSString *)ks_requiredBookField {
    return DBSafeString(_constantModel.ks_requiredBookField);
}

+ (NSString *)ks_pinned {
    return DBSafeString(_constantModel.ks_pinned);
}

+ (NSString *)ks_hours {
    return DBSafeString(_constantModel.ks_hours);
}

+ (NSString *)ks_note {
    return DBSafeString(_constantModel.ks_note);
}

+ (NSString *)ks_oneMinute {
    return DBSafeString(_constantModel.ks_oneMinute);
}

+ (NSString *)ks_xingkai {
    return DBSafeString(_constantModel.ks_xingkai);
}

+ (NSString *)ks_userAgreement {
    return DBSafeString(_constantModel.ks_userAgreement);
}

+ (NSString *)ks_searchSource {
    return DBSafeString(_constantModel.ks_searchSource);
}

+ (NSString *)ks_accountRecoveryPhone {
    return DBSafeString(_constantModel.ks_accountRecoveryPhone);
}

+ (NSString *)ks_requiredSourceUrl {
    return DBSafeString(_constantModel.ks_requiredSourceUrl);
}

+ (NSString *)ks_accountCancel {
    return DBSafeString(_constantModel.ks_accountCancel);
}

+ (NSString *)ks_bookDiscoverySource {
    return DBSafeString(_constantModel.ks_bookDiscoverySource);
}

+ (NSString *)ks_retry {
    return DBSafeString(_constantModel.ks_retry);
}

+ (NSString *)ks_transcodingSource {
    return DBSafeString(_constantModel.ks_transcodingSource);
}

+ (NSString *)ks_average {
    return DBSafeString(_constantModel.ks_average);
}

+ (NSString *)ks_favoriteLists {
    return DBSafeString(_constantModel.ks_favoriteLists);
}

+ (NSString *)ks_newNickname {
    return DBSafeString(_constantModel.ks_newNickname);
}

+ (NSString *)ks_replyComment {
    return DBSafeString(_constantModel.ks_replyComment);
}

+ (NSString *)ks_enterPhoneOrQQ {
    return DBSafeString(_constantModel.ks_enterPhoneOrQQ);
}

+ (NSString *)ks_searchHistoryCleared {
    return DBSafeString(_constantModel.ks_searchHistoryCleared);
}

+ (NSString *)ks_slower {
    return DBSafeString(_constantModel.ks_slower);
}

+ (NSString *)ks_faster {
    return DBSafeString(_constantModel.ks_faster);
}

+ (NSString *)ks_viewAllReviews {
    return DBSafeString(_constantModel.ks_viewAllReviews);
}

+ (NSString *)ks_verificationCode {
    return DBSafeString(_constantModel.ks_verificationCode);
}

+ (NSString *)ks_readProgress {
    return DBSafeString(_constantModel.ks_readProgress);
}

+ (NSString *)ks_exitReading {
    return DBSafeString(_constantModel.ks_exitReading);
}

+ (NSString *)ks_feedbackStatus {
    return DBSafeString(_constantModel.ks_feedbackStatus);
}

+ (NSString *)ks_enterCurrentPassword {
    return DBSafeString(_constantModel.ks_enterCurrentPassword);
}

+ (NSString *)ks_shelf {
    return DBSafeString(_constantModel.ks_shelf);
}

+ (NSString *)ks_logoutWarning {
    return DBSafeString(_constantModel.ks_logoutWarning);
}

+ (NSString *)ks_rate5Stars {
    return DBSafeString(_constantModel.ks_rate5Stars);
}

+ (NSString *)ks_currentPassword {
    return DBSafeString(_constantModel.ks_currentPassword);
}

+ (NSString *)ks_listDescription {
    return DBSafeString(_constantModel.ks_listDescription);
}

+ (NSString *)ks_scrollMode {
    return DBSafeString(_constantModel.ks_scrollMode);
}

+ (NSString *)ks_searchHistory {
    return DBSafeString(_constantModel.ks_searchHistory);
}

+ (NSString *)ks_readHistory {
    return DBSafeString(_constantModel.ks_readHistory);
}

+ (NSString *)ks_enableNotifications {
    return DBSafeString(_constantModel.ks_enableNotifications);
}

+ (NSString *)ks_comment {
    return DBSafeString(_constantModel.ks_comment);
}

+ (NSString *)ks_writeComment {
    return DBSafeString(_constantModel.ks_writeComment);
}

+ (NSString *)ks_choicePercentage {
    return DBSafeString(_constantModel.ks_choicePercentage);
}

+ (NSString *)ks_requestInfo {
    return DBSafeString(_constantModel.ks_requestInfo);
}

+ (NSString *)ks_profile {
    return DBSafeString(_constantModel.ks_profile);
}

+ (NSString *)ks_enterComment {
    return DBSafeString(_constantModel.ks_enterComment);
}

+ (NSString *)ks_noBookstoreData {
    return DBSafeString(_constantModel.ks_noBookstoreData);
}

+ (NSString *)ks_autoReadEnded {
    return DBSafeString(_constantModel.ks_autoReadEnded);
}

+ (NSString *)ks_copiedToShare {
    return DBSafeString(_constantModel.ks_copiedToShare);
}

+ (NSString *)ks_sensitiveContent {
    return DBSafeString(_constantModel.ks_sensitiveContent);
}

+ (NSString *)ks_enterContactInfo {
    return DBSafeString(_constantModel.ks_enterContactInfo);
}

+ (NSString *)ks_submit {
    return DBSafeString(_constantModel.ks_submit);
}

+ (NSString *)ks_linghuiFont {
    return DBSafeString(_constantModel.ks_linghuiFont);
}

+ (NSString *)ks_copyLinkHint {
    return DBSafeString(_constantModel.ks_copyLinkHint);
}

+ (NSString *)ks_removeFailed {
    return DBSafeString(_constantModel.ks_removeFailed);
}

+ (NSString *)ks_trending {
    return DBSafeString(_constantModel.ks_trending);
}

+ (NSString *)ks_qrInstall {
    return DBSafeString(_constantModel.ks_qrInstall);
}

+ (NSString *)ks_management {
    return DBSafeString(_constantModel.ks_management);
}

+ (NSString *)ks_clearHistoryWarning {
    return DBSafeString(_constantModel.ks_clearHistoryWarning);
}

+ (NSString *)ks_confirmBlockUser {
    return DBSafeString(_constantModel.ks_confirmBlockUser);
}

+ (NSString *)ks_requestHistory {
    return DBSafeString(_constantModel.ks_requestHistory);
}

+ (NSString *)ks_invalidFormat {
    return DBSafeString(_constantModel.ks_invalidFormat);
}

+ (NSString *)ks_originalPoster {
    return DBSafeString(_constantModel.ks_originalPoster);
}

+ (NSString *)ks_userComment {
    return DBSafeString(_constantModel.ks_userComment);
}

+ (NSString *)ks_source {
    return DBSafeString(_constantModel.ks_source);
}

+ (NSString *)ks_complain {
    return DBSafeString(_constantModel.ks_complain);
}

+ (NSString *)ks_sourcesCount {
    return DBSafeString(_constantModel.ks_sourcesCount);
}

+ (NSString *)ks_lantingHei {
    return DBSafeString(_constantModel.ks_lantingHei);
}

+ (NSString *)ks_notes {
    return DBSafeString(_constantModel.ks_notes);
}

+ (NSString *)ks_privacyTerms {
    return DBSafeString(_constantModel.ks_privacyTerms);
}

+ (NSString *)ks_noCategories {
    return DBSafeString(_constantModel.ks_noCategories);
}

+ (NSString *)ks_coverMode {
    return DBSafeString(_constantModel.ks_coverMode);
}

+ (NSString *)ks_rating {
    return DBSafeString(_constantModel.ks_rating);
}

+ (NSString *)ks_replySuccess {
    return DBSafeString(_constantModel.ks_replySuccess);
}

+ (NSString *)ks_changeNickname {
    return DBSafeString(_constantModel.ks_changeNickname);
}

+ (NSString *)ks_recommendations {
    return DBSafeString(_constantModel.ks_recommendations);
}

+ (NSString *)ks_send {
    return DBSafeString(_constantModel.ks_send);
}

+ (NSString *)ks_open {
    return DBSafeString(_constantModel.ks_open);
}

+ (NSString *)ks_currentlyReading {
    return DBSafeString(_constantModel.ks_currentlyReading);
}

+ (NSString *)ks_nightCare {
    return DBSafeString(_constantModel.ks_nightCare);
}

+ (NSString *)ks_feedbackContent {
    return DBSafeString(_constantModel.ks_feedbackContent);
}

+ (NSString *)ks_female {
    return DBSafeString(_constantModel.ks_female);
}

+ (NSString *)ks_descending {
    return DBSafeString(_constantModel.ks_descending);
}

+ (NSString *)ks_versionInfo {
    return DBSafeString(_constantModel.ks_versionInfo);
}

+ (NSString *)ks_preferredGenres {
    return DBSafeString(_constantModel.ks_preferredGenres);
}

+ (NSString *)ks_updateAlerts {
    return DBSafeString(_constantModel.ks_updateAlerts);
}

+ (NSString *)ks_deletedSuccess {
    return DBSafeString(_constantModel.ks_deletedSuccess);
}

+ (NSString *)ks_notificationSettings {
    return DBSafeString(_constantModel.ks_notificationSettings);
}

+ (NSString *)ks_noReadHistory {
    return DBSafeString(_constantModel.ks_noReadHistory);
}

+ (NSString *)ks_giveFeedback {
    return DBSafeString(_constantModel.ks_giveFeedback);
}

+ (NSString *)ks_edit {
    return DBSafeString(_constantModel.ks_edit);
}

+ (NSString *)ks_continue {
    return DBSafeString(_constantModel.ks_continue);
}

+ (NSString *)ks_savedBooks {
    return DBSafeString(_constantModel.ks_savedBooks);
}

+ (NSString *)ks_pauseReading {
    return DBSafeString(_constantModel.ks_pauseReading);
}

+ (NSString *)ks_chaptersCount {
    return DBSafeString(_constantModel.ks_chaptersCount);
}

+ (NSString *)ks_validEmail {
    return DBSafeString(_constantModel.ks_validEmail);
}

+ (NSString *)ks_newVersion {
    return DBSafeString(_constantModel.ks_newVersion);
}

+ (NSString *)ks_trendingSearches {
    return DBSafeString(_constantModel.ks_trendingSearches);
}

+ (NSString *)ks_post {
    return DBSafeString(_constantModel.ks_post);
}

+ (NSString *)ks_changeLoginPassword {
    return DBSafeString(_constantModel.ks_changeLoginPassword);
}

+ (NSString *)ks_sourceFormat {
    return DBSafeString(_constantModel.ks_sourceFormat);
}

+ (NSString *)ks_contents {
    return DBSafeString(_constantModel.ks_contents);
}

+ (NSString *)ks_booksAndFavs {
    return DBSafeString(_constantModel.ks_booksAndFavs);
}

+ (NSString *)ks_exitAutoTurn {
    return DBSafeString(_constantModel.ks_exitAutoTurn);
}

+ (NSString *)ks_validPhone {
    return DBSafeString(_constantModel.ks_validPhone);
}

+ (NSString *)ks_accountDeleted {
    return DBSafeString(_constantModel.ks_accountDeleted);
}

+ (NSString *)ks_enterEmail {
    return DBSafeString(_constantModel.ks_enterEmail);
}

+ (NSString *)ks_noContents {
    return DBSafeString(_constantModel.ks_noContents);
}

+ (NSString *)ks_submitted {
    return DBSafeString(_constantModel.ks_submitted);
}

+ (NSString *)ks_countryCode {
    return DBSafeString(_constantModel.ks_countryCode);
}

+ (NSString *)ks_qrCodeSaved {
    return DBSafeString(_constantModel.ks_qrCodeSaved);
}

+ (NSString *)ks_adjustFilter {
    return DBSafeString(_constantModel.ks_adjustFilter);
}

+ (NSString *)ks_skipInSeconds {
    return DBSafeString(_constantModel.ks_skipInSeconds);
}

+ (NSString *)ks_guide {
    return DBSafeString(_constantModel.ks_guide);
}

+ (NSString *)ks_validNewPassword {
    return DBSafeString(_constantModel.ks_validNewPassword);
}

+ (NSString *)ks_sourceUrl {
    return DBSafeString(_constantModel.ks_sourceUrl);
}

+ (NSString *)ks_minScoreError {
    return DBSafeString(_constantModel.ks_minScoreError);
}

+ (NSString *)ks_tip {
    return DBSafeString(_constantModel.ks_tip);
}

+ (NSString *)ks_deleteBook {
    return DBSafeString(_constantModel.ks_deleteBook);
}

+ (NSString *)ks_think {
    return DBSafeString(_constantModel.ks_think);
}

+ (NSString *)ks_recoverPassword {
    return DBSafeString(_constantModel.ks_recoverPassword);
}

+ (NSString *)ks_newPasswordDifferent {
    return DBSafeString(_constantModel.ks_newPasswordDifferent);
}

+ (NSString *)ks_eyeProtection {
    return DBSafeString(_constantModel.ks_eyeProtection);
}

+ (NSString *)ks_feedbackHistory {
    return DBSafeString(_constantModel.ks_feedbackHistory);
}

+ (NSString *)ks_recentReads {
    return DBSafeString(_constantModel.ks_recentReads);
}

+ (NSString *)ks_login {
    return DBSafeString(_constantModel.ks_login);
}

+ (NSString *)ks_ratingFormat {
    return DBSafeString(_constantModel.ks_ratingFormat);
}

+ (NSString *)ks_lishuFont {
    return DBSafeString(_constantModel.ks_lishuFont);
}

+ (NSString *)ks_myRequests {
    return DBSafeString(_constantModel.ks_myRequests);
}

+ (NSString *)ks_favorite {
    return DBSafeString(_constantModel.ks_favorite);
}

+ (NSString *)ks_requiredProtagonist {
    return DBSafeString(_constantModel.ks_requiredProtagonist);
}

+ (NSString *)ks_chapterError {
    return DBSafeString(_constantModel.ks_chapterError);
}

+ (NSString *)ks_nextChapters {
    return DBSafeString(_constantModel.ks_nextChapters);
}

+ (NSString *)ks_deselect {
    return DBSafeString(_constantModel.ks_deselect);
}

+ (NSString *)ks_removeFromShelf {
    return DBSafeString(_constantModel.ks_removeFromShelf);
}

+ (NSString *)ks_selectSource {
    return DBSafeString(_constantModel.ks_selectSource);
}

+ (NSString *)ks_mySettings {
    return DBSafeString(_constantModel.ks_mySettings);
}

+ (NSString *)ks_unfavorite {
    return DBSafeString(_constantModel.ks_unfavorite);
}

+ (NSString *)ks_networkError {
    return DBSafeString(_constantModel.ks_networkError);
}

+ (NSString *)ks_addToShelf {
    return DBSafeString(_constantModel.ks_addToShelf);
}

+ (NSString *)ks_freeReading {
    return DBSafeString(_constantModel.ks_freeReading);
}

+ (NSString *)ks_lastChapterPrompt {
    return DBSafeString(_constantModel.ks_lastChapterPrompt);
}

+ (NSString *)ks_emptyFontName {
    return DBSafeString(_constantModel.ks_emptyFontName);
}

+ (NSString *)ks_less {
    return DBSafeString(_constantModel.ks_less);
}

+ (NSString *)ks_username {
    return DBSafeString(_constantModel.ks_username);
}

+ (NSString *)ks_reenterPassword {
    return DBSafeString(_constantModel.ks_reenterPassword);
}

+ (NSString *)ks_justNow {
    return DBSafeString(_constantModel.ks_justNow);
}

+ (NSString *)ks_cachedStatus {
    return DBSafeString(_constantModel.ks_cachedStatus);
}

+ (NSString *)ks_remove {
    return DBSafeString(_constantModel.ks_remove);
}

+ (NSString *)ks_guideWelcome {
    return DBSafeString(_constantModel.ks_guideWelcome);
}

+ (NSString *)ks_loginNow {
    return DBSafeString(_constantModel.ks_loginNow);
}

+ (NSString *)ks_voice {
    return DBSafeString(_constantModel.ks_voice);
}

+ (NSString *)ks_clearNetworkCache {
    return DBSafeString(_constantModel.ks_clearNetworkCache);
}

+ (NSString *)ks_termsOfService {
    return DBSafeString(_constantModel.ks_termsOfService);
}

+ (NSString *)ks_weibeiFont {
    return DBSafeString(_constantModel.ks_weibeiFont);
}

+ (NSString *)ks_noFeedbackHistory {
    return DBSafeString(_constantModel.ks_noFeedbackHistory);
}

+ (NSString *)ks_logout {
    return DBSafeString(_constantModel.ks_logout);
}

+ (NSString *)ks_more {
    return DBSafeString(_constantModel.ks_more);
}

+ (NSString *)ks_noBookData {
    return DBSafeString(_constantModel.ks_noBookData);
}

+ (NSString *)ks_button {
    return DBSafeString(_constantModel.ks_button);
}

+ (NSString *)ks_download {
    return DBSafeString(_constantModel.ks_download);
}

+ (NSString *)ks_listMode {
    return DBSafeString(_constantModel.ks_listMode);
}

+ (NSString *)ks_bookstore {
    return DBSafeString(_constantModel.ks_bookstore);
}

+ (NSString *)ks_requestBook {
    return DBSafeString(_constantModel.ks_requestBook);
}

+ (NSString *)ks_historyFeature {
    return DBSafeString(_constantModel.ks_historyFeature);
}

+ (NSString *)ks_updatedFormat {
    return DBSafeString(_constantModel.ks_updatedFormat);
}

+ (NSString *)ks_rateThisBook {
    return DBSafeString(_constantModel.ks_rateThisBook);
}

+ (NSString *)ks_viewOtherSources {
    return DBSafeString(_constantModel.ks_viewOtherSources);
}

+ (NSString *)ks_myBooklists {
    return DBSafeString(_constantModel.ks_myBooklists);
}

+ (NSString *)ks_updatedTime {
    return DBSafeString(_constantModel.ks_updatedTime);
}

+ (NSString *)ks_hoursAgo {
    return DBSafeString(_constantModel.ks_hoursAgo);
}

+ (NSString *)ks_email {
    return DBSafeString(_constantModel.ks_email);
}

+ (NSString *)ks_dayMode {
    return DBSafeString(_constantModel.ks_dayMode);
}

+ (NSString *)ks_go {
    return DBSafeString(_constantModel.ks_go);
}

+ (NSString *)ks_view {
    return DBSafeString(_constantModel.ks_view);
}

+ (NSString *)ks_avatarUploadSuccess {
    return DBSafeString(_constantModel.ks_avatarUploadSuccess);
}

+ (NSString *)ks_required {
    return DBSafeString(_constantModel.ks_required);
}

+ (NSString *)ks_qualityReviews {
    return DBSafeString(_constantModel.ks_qualityReviews);
}

+ (NSString *)ks_deleteFailed {
    return DBSafeString(_constantModel.ks_deleteFailed);
}

+ (NSString *)ks_migrationNotice {
    return DBSafeString(_constantModel.ks_migrationNotice);
}

+ (NSString *)ks_userSettings {
    return DBSafeString(_constantModel.ks_userSettings);
}

+ (NSString *)ks_processingStatus {
    return DBSafeString(_constantModel.ks_processingStatus);
}

+ (NSString *)ks_likesCount {
    return DBSafeString(_constantModel.ks_likesCount);
}

+ (NSString *)ks_shareWithFriends {
    return DBSafeString(_constantModel.ks_shareWithFriends);
}

+ (NSString *)ks_allDownloaded {
    return DBSafeString(_constantModel.ks_allDownloaded);
}

+ (NSString *)ks_booksAndFavorites {
    return DBSafeString(_constantModel.ks_booksAndFavorites);
}

+ (NSString *)ks_savedToAlbum {
    return DBSafeString(_constantModel.ks_savedToAlbum);
}

+ (NSString *)ks_startReading {
    return DBSafeString(_constantModel.ks_startReading);
}

+ (NSString *)ks_nightMode {
    return DBSafeString(_constantModel.ks_nightMode);
}

+ (NSString *)ks_selectType {
    return DBSafeString(_constantModel.ks_selectType);
}

+ (NSString *)ks_enterBookTitle {
    return DBSafeString(_constantModel.ks_enterBookTitle);
}

+ (NSString *)ks_ended {
    return DBSafeString(_constantModel.ks_ended);
}

+ (NSString *)ks_synced {
    return DBSafeString(_constantModel.ks_synced);
}

+ (NSString *)ks_authorLists {
    return DBSafeString(_constantModel.ks_authorLists);
}

+ (NSString *)ks_addedToShelf {
    return DBSafeString(_constantModel.ks_addedToShelf);
}

+ (NSString *)ks_favoriteSuccess {
    return DBSafeString(_constantModel.ks_favoriteSuccess);
}

+ (NSString *)ks_getVerificationCode {
    return DBSafeString(_constantModel.ks_getVerificationCode);
}

+ (NSString *)ks_unreadStatus {
    return DBSafeString(_constantModel.ks_unreadStatus);
}

+ (NSString *)ks_violation {
    return DBSafeString(_constantModel.ks_violation);
}

+ (NSString *)ks_qrInstallStep {
    return DBSafeString(_constantModel.ks_qrInstallStep);
}

+ (NSString *)ks_viewMyShelf {
    return DBSafeString(_constantModel.ks_viewMyShelf);
}

+ (NSString *)ks_spacingTooLong {
    return DBSafeString(_constantModel.ks_spacingTooLong);
}

+ (NSString *)ks_communityGuidelines {
    return DBSafeString(_constantModel.ks_communityGuidelines);
}

+ (NSString *)ks_repliedStatus {
    return DBSafeString(_constantModel.ks_repliedStatus);
}

+ (NSString *)ks_selectBook {
    return DBSafeString(_constantModel.ks_selectBook);
}

+ (NSString *)ks_confirmCacheClear {
    return DBSafeString(_constantModel.ks_confirmCacheClear);
}

+ (NSString *)ks_fifteenMinutes {
    return DBSafeString(_constantModel.ks_fifteenMinutes);
}

+ (NSString *)ks_shelfSorting {
    return DBSafeString(_constantModel.ks_shelfSorting);
}

+ (NSString *)ks_enterPassword {
    return DBSafeString(_constantModel.ks_enterPassword);
}

+ (NSString *)ks_nicknameTooLong {
    return DBSafeString(_constantModel.ks_nicknameTooLong);
}

+ (NSString *)ks_noRankings {
    return DBSafeString(_constantModel.ks_noRankings);
}

+ (NSString *)ks_pageNumber {
    return DBSafeString(_constantModel.ks_pageNumber);
}

+ (NSString *)ks_cancel {
    return DBSafeString(_constantModel.ks_cancel);
}

+ (NSString *)ks_reject {
    return DBSafeString(_constantModel.ks_reject);
}

+ (NSString *)ks_yuppieFont {
    return DBSafeString(_constantModel.ks_yuppieFont);
}

+ (NSString *)ks_pornographic {
    return DBSafeString(_constantModel.ks_pornographic);
}

+ (NSString *)ks_loadFailedPrompt {
    return DBSafeString(_constantModel.ks_loadFailedPrompt);
}

+ (NSString *)ks_audiobook {
    return DBSafeString(_constantModel.ks_audiobook);
}

+ (NSString *)ks_savingStatus {
    return DBSafeString(_constantModel.ks_savingStatus);
}

+ (NSString *)ks_enterRequiredInfo {
    return DBSafeString(_constantModel.ks_enterRequiredInfo);
}

+ (NSString *)ks_termsAndPrivacy {
    return DBSafeString(_constantModel.ks_termsAndPrivacy);
}

+ (NSString *)ks_enterNickname {
    return DBSafeString(_constantModel.ks_enterNickname);
}

+ (NSString *)ks_auto {
    return DBSafeString(_constantModel.ks_auto);
}

+ (NSString *)ks_latestUpdate {
    return DBSafeString(_constantModel.ks_latestUpdate);
}

+ (NSString *)ks_bindInviteCode {
    return DBSafeString(_constantModel.ks_bindInviteCode);
}

+ (NSString *)ks_inviteCodeBound {
    return DBSafeString(_constantModel.ks_inviteCodeBound);
}

+ (NSString *)ks_enterInviteCode {
    return DBSafeString(_constantModel.ks_enterInviteCode);
}

+ (NSString *)ks_language {
    return DBSafeString(_constantModel.ks_language);
}

+ (NSString *)ks_confirmDeleteBooks {
    return DBSafeString(_constantModel.ks_confirmDeleteBooks);
}

+ (NSString *)ks_firstPageReached {
    return DBSafeString(_constantModel.ks_firstPageReached);
}

+ (NSString *)ks_autoReadNotice {
    return DBSafeString(_constantModel.ks_autoReadNotice);
}

+ (NSString *)ks_gotitLa {
    return DBSafeString(_constantModel.ks_gotitLa);
}

+ (NSString *)ks_bookNotFound {
    return DBSafeString(_constantModel.ks_bookNotFound);
}

+ (NSString *)ks_registrationSuccess {
    return DBSafeString(_constantModel.ks_registrationSuccess);
}

+ (NSString *)ks_contactSupport {
    return DBSafeString(_constantModel.ks_contactSupport);
}

+ (NSString *)ks_userName {
    return DBSafeString(_constantModel.ks_userName);
}

+ (NSString *)ks_expiryDate {
    return DBSafeString(_constantModel.ks_expiryDate);
}

+ (NSString *)ks_paymentHistory {
    return DBSafeString(_constantModel.ks_paymentHistory);
}

+ (NSString *)ks_submitOrder {
    return DBSafeString(_constantModel.ks_submitOrder);
}

+ (NSString *)ks_subscribeRenew {
    return DBSafeString(_constantModel.ks_subscribeRenew);
}

+ (NSString *)ks_buyCoins {
    return DBSafeString(_constantModel.ks_buyCoins);
}

+ (NSString *)ks_coinHistory {
    return DBSafeString(_constantModel.ks_coinHistory);
}

+ (NSString *)ks_topBooks {
    return DBSafeString(_constantModel.ks_topBooks);
}

+ (NSString *)ks_bestsellers {
    return DBSafeString(_constantModel.ks_bestsellers);
}

+ (NSString *)ks_allRankings {
    return DBSafeString(_constantModel.ks_allRankings);
}

+ (NSString *)ks_addFavorites {
    return DBSafeString(_constantModel.ks_addFavorites);
}

+ (NSString *)ks_goToBookstore {
    return DBSafeString(_constantModel.ks_goToBookstore);
}

+ (NSString *)ks_chapterLoadFailed {
    return DBSafeString(_constantModel.ks_chapterLoadFailed);
}

+ (NSString *)ks_startCache {
    return DBSafeString(_constantModel.ks_startCache);
}

+ (NSString *)ks_cachePrompt {
    return DBSafeString(_constantModel.ks_cachePrompt);
}

+ (NSString *)ks_cachingProgress {
    return DBSafeString(_constantModel.ks_cachingProgress);
}

+ (NSString *)ks_confirmDeleteBook {
    return DBSafeString(_constantModel.ks_confirmDeleteBook);
}

+ (NSString *)ks_nextTime {
    return DBSafeString(_constantModel.ks_nextTime);
}

+ (NSString *)ks_chapterChangeError {
    return DBSafeString(_constantModel.ks_chapterChangeError);
}

+ (NSString *)ks_privacyPrivacy {
    return DBSafeString(_constantModel.ks_privacyPrivacy);
}

@end
