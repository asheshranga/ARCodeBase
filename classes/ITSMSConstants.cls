/*********************************************************************************
Name         : ITSMSConstants 
Created By   : Dianna Guilinger - Slalom 
Usages       : Contains all constant custom setting values used by ITSMS Support Center
*********************************************************************************/
global with sharing class ITSMSConstants{    
    //--- 
    public static string ACCESSTYPE_AGILE = ITSMSUtilityClass.getFieldValue1('AccessTypeOracleAgile');
    public static string ACCESSTYPE_ASCP = ITSMSUtilityClass.getFieldValue1('AccessTypeOracleASCP');
    public static string ACCESSTYPE_EBS = ITSMSUtilityClass.getFieldValue1('AccessTypeOracleEBS');
    public static string ACCESSTYPE_OBIEE = ITSMSUtilityClass.getFieldValue1('AccessTypeOracleOBIEE');
    public static string ACCESSTYPE_NEW = ITSMSUtilityClass.getFieldValue1('AccessTypeNew');

    public static string ACTIVE_DIRECTORY_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryActiveDirectory');

    public static string ACTION_CREATE = ITSMSUtilityClass.getFieldValue1('ActionCreate');
    public static string ACTION_DISABLE = ITSMSUtilityClass.getFieldValue1('ActionDisable');
    public static string ACTION_MODIFY = ITSMSUtilityClass.getFieldValue1('ActionModify');

    public static string ACTIVE_DIRECTORY_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailActiveDirectory');
    public static string ACTIVE_DIRECTORY_SRVREQTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeActiveDirectory');
    public static string ACTIVE_DIRECTORY_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectActiveDirectory');
    public static string ACTIVE_DIRECTORY_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductActiveDirectory');

    public static string AGILE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryAgile');
    public static string AGILE_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailAgile');
    public static string AGILE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionAgile');
    public static string AGILE_OPTIONS = ITSMSUtilityClass.getFieldValue1('AgileOptions');
    public static string AGILE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductAgile');
    public static string AGILE_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeAgile');
    public static string AGILE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectAgile');

    public static string ALERTS_AREA = ITSMSUtilityClass.getFieldValue1('ArticleAreaAlerts');
    public static string ALERTS_SECTION = ITSMSUtilityClass.getFieldValue1('ArticleSectionAlerts');
    public static string ALERTS_TYPE = ITSMSUtilityClass.getFieldValue1('ArticleTypeAlerts');

    public static string ARTICLE_QUERY = ITSMSUtilityClass.getFieldValue1('SelectArticles');

    public static string ATTACHMENTS_INCREMENT = ITSMSUtilityClass.getFieldValue1('AttachmentsIncrement');

    public static string CASE_COMMENT = ITSMSUtilityClass.getFieldValue1('CaseComment');
    public static string CASE_ERROR_ONPARENTCLOSE = ITSMSUtilityClass.getFieldValue1('MessageErrorOnParentClose');
    public static string CASE_ERROR_MISSINGCONTACT = ITSMSUtilityClass.getFieldValue1('MessageErrorMissingContact');
    public static string CASE_ORIGIN = ITSMSUtilityClass.getFieldValue1('CaseOrigin');
    public static string CASE_RECORDTYPE = ITSMSUtilityClass.getFieldValue1('CaseRecordType');
    public static string CASE_RECORDTYPE_FEEDBACK = ITSMSUtilityClass.getFieldValue1('CaseRecordTypeFeedback');
    public static string CASE_STATUS_CLOSE = ITSMSUtilityClass.getFieldValue1('CaseCloseStatus'); 
    public static string CASE_STATUS_CLOSE_ALL = ITSMSUtilityClass.getFieldValue1('CaseStatusAllClosing'); 
    public static string CASE_STATUS_CLOSE_CANCEL = ITSMSUtilityClass.getFieldValue1('CaseStatusCloseCancel'); 
    public static string CASE_STATUS_INPROGRESS = ITSMSUtilityClass.getFieldValue1('CaseInProgressStatus');
    public static string CASE_STATUS_PRESUBMIT = ITSMSUtilityClass.getFieldValue1('CasePreSubmitStatus');
    public static string CASE_TEAM_DELEGATE = ITSMSUtilityClass.getFieldValue1('CaseTeamRoleDelegate');
    public static string CASE_TEAM_REQUESTEDFOR = ITSMSUtilityClass.getFieldValue1('CaseTeamRoleRequestedFor');
    public static string CASE_TEAM_REQUESTOR = ITSMSUtilityClass.getFieldValue1('CaseTeamRoleRequestor');
    public static string CASE_TYPE_REQUEST = ITSMSUtilityClass.getFieldValue1('CaseTypeRequest');
    public static string CASE_TYPE_ISSUE = ITSMSUtilityClass.getFieldValue1('CaseTypeIssue');
    

    public static string CONF_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryConferencing');
    public static string CONF_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailConferencing');
    public static string CONF_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductConferencing');
    public static string CONF_SRVREQTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeConferencing');
    public static string CONF_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionConferencing')+ ITSMSUtilityClass.getFieldValue2('DescriptionConferencing');
    public static string CONF_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectConferencing');

    public static string CONTACT_RECORDTYPE = ITSMSUtilityClass.getFieldValue1('ContactRecordType');
    public static string CONTACTS_QUERY_BY_EMAIL = ITSMSUtilityClass.getFieldValue1('SelectContactsByEmail')+ ITSMSUtilityClass.getFieldValue2('SelectContactsByEmail');

    public static string CONTACT_US_AREA = ITSMSUtilityClass.getFieldValue1('ContactUsArea');
    public static string CONTACT_US_EMAIL = ITSMSUtilityClass.getFieldValue1('ContactUsEmail');
    public static string CONTACT_US_HOURS = ITSMSUtilityClass.getFieldValue1('ContactUsHours');
    public static string CONTACT_US_PHONE = ITSMSUtilityClass.getFieldValue1('ContactUsPhone');
    public static string CONTACT_US_SUPPORT = ITSMSUtilityClass.getFieldValue1('ContactUsSupport');
    public static string CONTACT_US_TYPE = ITSMSUtilityClass.getFieldValue1('ContactUsType');

    public static string DESKTOP_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryDesktop');
    public static string DESKTOP_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailDesktop');
    public static string DESKTOP_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionDesktop');
    public static string DESKTOP_PCMODELS = ITSMSUtilityClass.getFieldValue1('DesktopPCModels');
    public static string DESKTOP_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeDesktop');
    public static string DESKTOP_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectDesktop');

    public static string EMAIL_BODY_NEWHIRE = ITSMSUtilityClass.getFieldValue1('EmailNewHire')+' '+ ITSMSUtilityClass.getFieldValue2('EmailNewHire');
    public static string EMAIL_BODY_REQUESTOR = ITSMSUtilityClass.getFieldValue1('EmailRequestor')+' '+ ITSMSUtilityClass.getFieldValue2('EmailRequestor');
    public static string EMAIL_BODY_CHILDCASES = ITSMSUtilityClass.getFieldValue1('EmailChildCase');
    public static string EMAIL_SUBJECT_NEWHIRE = ITSMSUtilityClass.getFieldValue1('EmailSubjectNewHire');

    public static string EMAILSEC_ACCESS_SECURITY = ITSMSUtilityClass.getFieldValue1('AccessTypeSecurityGroup');
    public static string EMAILSEC_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryEmailSecurity');
    public static string EMAILSEC_CATEGORYDETAILS_SECURE = ITSMSUtilityClass.getFieldValue1('CategoryDetailEmailSecAccess');
    public static string EMAILSEC_CATEGORYDETAILS_DISTRIB = ITSMSUtilityClass.getFieldValue1('CategoryDetailEmailSecDistr');
    public static string EMAILSEC_PRODUCT_SECURE = ITSMSUtilityClass.getFieldValue1('ProductEmailSecAccess');
    public static string EMAILSEC_PRODUCT_DISTRIB = ITSMSUtilityClass.getFieldValue1('ProductEmailSecDistr');
    public static string EMAILSEC_SRVREQTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeEmailSecurity');
    public static string EMAILSEC_DESCRIPTION_NEW = ITSMSUtilityClass.getFieldValue1('DescriptionEmailSecurityNew')+ITSMSUtilityClass.getFieldValue2('DescriptionEmailSecurityNew');
    public static string EMAILSEC_DESCRIPTION_EXISTING = ITSMSUtilityClass.getFieldValue1('DescriptionEmailSecurityExisting')+ITSMSUtilityClass.getFieldValue2('DescriptionEmailSecurityExisting');
    public static string EMAILSEC_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectEmailSecurity');

    public static string ENTITLEMENT_QUERY = ITSMSUtilityClass.getFieldValue1('SelectEntitlement');
    public static string ENTITLEMENT_ACTIVEDIRECTORY = ITSMSUtilityClass.getFieldValue1('EntitlementAD');
    public static string ENTITLEMENT_NEWHIREPARENT = ITSMSUtilityClass.getFieldValue1('EntitlementNewHireParent');

    public static string FEATUREDLINK_AREA = ITSMSUtilityClass.getFieldValue1('ArticleAreaFeaturedLink');
    public static string FEATUREDLINK_SECTION = ITSMSUtilityClass.getFieldValue1('ArticleSectionFeaturedLink');
    public static string FEATUREDLINK_TYPE = ITSMSUtilityClass.getFieldValue1('ArticleTypeFeaturedLink');

    public static string FEEDBACK_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectFeedback');

    public static string FOLDERSHARE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryFolderShare');
    public static string FOLDERSHARE_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailFolderShare');
    public static string FOLDERSHARE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductFolderShare');
    public static string FOLDERSHARE_SRVREQTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeFolderShare');
    public static string FOLDERSHARE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionFolderShare');
    public static string FOLDERSHARE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectFolderShare');

    public static string FOOTER_AREA = ITSMSUtilityClass.getFieldValue1('ArticleAreaFooter');
    public static string FOOTER_SECTION = ITSMSUtilityClass.getFieldValue1('ArticleSectionFooter');
    public static string FOOTER_TYPE = ITSMSUtilityClass.getFieldValue1('ArticleTypeFooter');

    public static string FORM_CATEGORY_ACCESS = ITSMSUtilityClass.getFieldValue1('FormCategoryAccess');
    public static string FORM_CATEGORY_CONFERENCING = ITSMSUtilityClass.getFieldValue1('FormCategoryConferencing');
    public static string FORM_CATEGORY_GENERAL = ITSMSUtilityClass.getFieldValue1('FormCategoryGeneral');
    public static string FORM_CATEGORY_MOBILITY = ITSMSUtilityClass.getFieldValue1('FormCategoryMobility');
    public static string FORM_CATEGORY_SERVER = ITSMSUtilityClass.getFieldValue1('FormCategoryServer');
    public static string FORM_CATEGORY_SOFTWARE = ITSMSUtilityClass.getFieldValue1('FormCategorySoftware');
    public static string FORM_CATEGORY_WORKSTATION = ITSMSUtilityClass.getFieldValue1('FormCategoryWorkstation');

    public static string FORM_SECTION_CONFERENCING = ITSMSUtilityClass.getFieldValue1('FormSectionConferencing');
    public static string FORM_SECTION_EMAILSECURITY = ITSMSUtilityClass.getFieldValue1('FormSectionEmailSecurity');
    public static string FORM_SECTION_FOLDERSHARE = ITSMSUtilityClass.getFieldValue1('FormSectionFolderShare');
    public static string FORM_SECTION_MOBILITYAGREEMENT = ITSMSUtilityClass.getFieldValue1('FormSectionMobilityAgreement');
    public static string FORM_SECTION_MOBILITYLOAN = ITSMSUtilityClass.getFieldValue1('FormSectionMobilityLoan');
    public static string FORM_SECTION_MOBILITYNEWUPGRADE = ITSMSUtilityClass.getFieldValue1('FormSectionMobilityNewUpgrade');
    public static string FORM_SECTION_MOBILITYTRANSFER = ITSMSUtilityClass.getFieldValue1('FormSectionMobilityTransfer');
    public static string FORM_SECTION_ORACLE = ITSMSUtilityClass.getFieldValue1('FormSectionOracle');
    public static string FORM_SECTION_PARTPERIPHERAL = ITSMSUtilityClass.getFieldValue1('FormSectionPartPeripheral');
    public static string FORM_SECTION_SERVERVM = ITSMSUtilityClass.getFieldValue1('FormSectionServerVM');
    public static string FORM_SECTION_SERVICEACCOUNT = ITSMSUtilityClass.getFieldValue1('FormSectionServiceAccount');
    public static string FORM_SECTION_SHAREDMAILBOX = ITSMSUtilityClass.getFieldValue1('FormSectionSharedMailbox');
    public static string FORM_SECTION_SHAREPOINT = ITSMSUtilityClass.getFieldValue1('FormSectionSharepoint');
    public static string FORM_SECTION_SOFTWARE = ITSMSUtilityClass.getFieldValue1('FormSectionSoftware');
    public static string FORM_SECTION_SOFTWAREFISHEYE = ITSMSUtilityClass.getFieldValue1('FormSectionSoftwareFisheye');
    public static string FORM_SECTION_SOFTWAREJENKINS = ITSMSUtilityClass.getFieldValue1('FormSectionSoftwareJenkins');
    public static string FORM_SECTION_SOFTWAREJIRA = ITSMSUtilityClass.getFieldValue1('FormSectionSoftwareJIRA');
    public static string FORM_SECTION_SOFTWAREOTHER = ITSMSUtilityClass.getFieldValue1('FormSectionSoftwareOther');
    public static string FORM_SECTION_SOFTWAREWIKI = ITSMSUtilityClass.getFieldValue1('FormSectionSoftwareWIKI');
    public static string FORM_SECTION_STORAGE = ITSMSUtilityClass.getFieldValue1('FormSectionStorage');
    public static string FORM_SECTION_WORKSTATION = ITSMSUtilityClass.getFieldValue1('FormSectionWorkstationLaptop');

    public static string FORM_TITLE_ACCESS = ITSMSUtilityClass.getFieldValue1('FormTitleAccess');
    public static string FORM_TITLE_CONFERENCING = ITSMSUtilityClass.getFieldValue1('FormTitleConferencing');
    public static string FORM_TITLE_GENERAL = ITSMSUtilityClass.getFieldValue1('FormTitleGeneral');
    public static string FORM_TITLE_MOBILITY = ITSMSUtilityClass.getFieldValue1('FormTitleMobility');
    public static string FORM_TITLE_SERVER = ITSMSUtilityClass.getFieldValue1('FormTitleServer');
    public static string FORM_TITLE_SOFTWARE = ITSMSUtilityClass.getFieldValue1('FormTitleSoftware');
    public static string FORM_TITLE_WORKSTATION = ITSMSUtilityClass.getFieldValue1('FormTitleWorkstation');

    public static string FORMS_AREA = ITSMSUtilityClass.getFieldValue1('ArticleAreaForms');
    public static string FORMS_SECTION = ITSMSUtilityClass.getFieldValue1('ArticleSectionForms');
    public static string FORMS_TYPE = ITSMSUtilityClass.getFieldValue1('ArticleTypeForms');

    public static string GENERAL_CATEGORY = ITSMSUtilityClass.getFieldValue1('SupportCategoryGeneralCase');

    public static string INFOTEXT_AREA_NEWHIRE = ITSMSUtilityClass.getFieldValue1('ArticleAreaNewHire');
    public static string INFOTEXT_SECTION_AGILE = ITSMSUtilityClass.getFieldValue1('ArticleSectionAgile');
    public static string INFOTEXT_SECTION_DESKTOP = ITSMSUtilityClass.getFieldValue1('ArticleSectionDesktop');
    public static string INFOTEXT_TYPE_NEWHIRE = ITSMSUtilityClass.getFieldValue1('ArticleTypeNewHire');

    public static string ITSMS_APPNAME = ITSMSUtilityClass.getFieldValue1('ITSMSApplicationName');

    public static string METRICS_AREA = ITSMSUtilityClass.getFieldValue1('ArticleAreaMetrics');
    public static string METRICS_SECTION = ITSMSUtilityClass.getFieldValue1('ArticleSectionMetrics');
    public static string METRICS_TYPE = ITSMSUtilityClass.getFieldValue1('ArticleTypeMetrics');
    
    public static string MOBILITYAGREE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryMobileAgree');
    public static string MOBILITYAGREE_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailMobileAgree');
    public static string MOBILITYAGREE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductMobileAgree');
    public static string MOBILITYAGREE_SRVREQTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeMobileAgree');
    public static string MOBILITYAGREE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionMobileAgree')+ ITSMSUtilityClass.getFieldValue2('DescriptionMobileAgree');
    public static string MOBILITYAGREE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectMobileAgree');

    public static string MOBILITYLOAN_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryMobileLoanEtc');
    public static string MOBILITYLOAN_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailMobileLoanEtc');
    public static string MOBILITYLOAN_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductMobileLoanEtc');
    public static string MOBILITYLOAN_SRVREQTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeMobileLoanEtc');
    public static string MOBILITYLOAN_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionMobileLoanEtc')+ ITSMSUtilityClass.getFieldValue2('DescriptionMobileLoanEtc');
    public static string MOBILITYLOAN_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectMobileLoanEtc');

    public static string MOBILITYNEW_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryMobileNewUpgrade');
    public static string MOBILITYNEW_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailMobileNewUpgrade');
    public static string MOBILITYNEW_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductMobileNewUpgrade');
    public static string MOBILITYNEW_SRVREQTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeMobileNewUpgrade');
    public static string MOBILITYNEW_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionMobileNewUpgrade')+ ITSMSUtilityClass.getFieldValue2('DescriptionMobileNewUpgrade');
    public static string MOBILITYNEW_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectMobileNewUpgrade');


    public static string MOBILITYTRANSFER_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryMobileTransfer');
    public static string MOBILITYTRANSFER_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailMobileTransfer');
    public static string MOBILITYTRANSFER_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductMobileTransfer');
    public static string MOBILITYTRANSFER_SRVREQTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeMobileTransfer');
    public static string MOBILITYTRANSFER_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionMobileTransfer')+ ITSMSUtilityClass.getFieldValue2('DescriptionMobileTransfer');
    public static string MOBILITYTRANSFER_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectMobileTransfer');

    public static string MYCASES_DEFAULT_FILTER = ITSMSUtilityClass.getFieldValue1('MyCasesDefaultFilter');
    public static string MYCASES_QUERY = ITSMSUtilityClass.getFieldValue1('MyCasesQuery')+' '+ ITSMSUtilityClass.getFieldValue2('MyCasesQuery');
    public static string MYCASES_PAGESIZE = ITSMSUtilityClass.getFieldValue1('MyCasesPageSize');
    public static string MYCASES_SORTDIRECTION = ITSMSUtilityClass.getFieldValue1('MyCasesSortDirection');
    public static string MYCASES_SORTFIELD = ITSMSUtilityClass.getFieldValue1('MyCasesSortField');

    public static string NAVIGATE_CASEDETAIL = ITSMSUtilityClass.getFieldValue1('LinkCaseDetail'); 
    public static string NAVIGATE_NEWHIRE = ITSMSUtilityClass.getFieldValue1('LinkNewHireRequest'); 
    public static string NAVIGATE_ON_CANCELNEWHIRE = ITSMSUtilityClass.getFieldValue1('LinkNewHireCancel'); 
    public static string NAVIGATE_ON_CANCELSUPPORT = ITSMSUtilityClass.getFieldValue1('LinkSupportCancel'); 
    public static string NAVIGATE_ON_SUBMITNEWHIRE = ITSMSUtilityClass.getFieldValue1('LinkNewHireSubmit'); 
    public static string NAVIGATE_ON_SUBMITSUPPORT = ITSMSUtilityClass.getFieldValue1('LinkSupportSubmit');
    public static string NAVIGATE_MYCASES = ITSMSUtilityClass.getFieldValue1('LinkMyCases');
    public static string NAVIGATE_SUPPORT_REQUEST = ITSMSUtilityClass.getFieldValue1('LinkSupportRequest');
    
    public static string NAVIGATE_HOME_PAGE = ITSMSUtilityClass.getFieldValue1('LinkSupportCenterHome');
    public static string NAVIGATE_REQUEST_HELP_PAGE = ITSMSUtilityClass.getFieldValue1('LinkSupportCenterRequestHelp');
    public static string NAVIGATE_MY_CASES_PAGE = ITSMSUtilityClass.getFieldValue1('LinkSupportCenterMyCases');
    public static string NAVIGATE_NEW_HIRES_PAGE = ITSMSUtilityClass.getFieldValue1('LinkSupportCenterNewHires');
    public static string NAVIGATE_SELF_HELP_PAGE = ITSMSUtilityClass.getFieldValue1('LinkSupportCenterSelfHelp');
    public static string NAVIGATE_CONTACT_US_PAGE = ITSMSUtilityClass.getFieldValue1('LinkSupportCenterContactUs');
   
    public static string NEWHIRE = ITSMSUtilityClass.getFieldValue1('NewHire'); 
    public static string NEWHIRE_CASESQUERY = ITSMSUtilityClass.getFieldValue1('NewHireCasesQuery')+' '+ ITSMSUtilityClass.getFieldValue2('NewHireCasesQuery');
    public static string NEWHIRE_CASE_ALREADY_SUBMITTED = ITSMSUtilityClass.getFieldValue1('MessageCaseAlreadySubmitted'); 
    public static string NEWHIRE_CASE_IS_CREATED = ITSMSUtilityClass.getFieldValue1('MessageCaseCreated'); 
    public static string NEWHIRE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryNewHireParent');
    public static string NEWHIRE_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailNewHireParent');
    public static string NEWHIRE_CONTRACTOR = ITSMSUtilityClass.getFieldValue1('NewHireTypeContractor');
    public static string NEWHIRE_DEFAULT_FILTER = ITSMSUtilityClass.getFieldValue1('NewHireDefaultFilter');
    public static string NEWHIRE_DESCRIPTION_HEADER = ITSMSUtilityClass.getFieldValue1('DescriptionNewHireHdr')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHireHdr'); 
    public static string NEWHIRE_DESCRIPTION_DESKTOP = ITSMSUtilityClass.getFieldValue1('DescriptionNewHireDesktop')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHireDesktop'); 
    public static string NEWHIRE_DESCRIPTION_ACCESSADMIN = ITSMSUtilityClass.getFieldValue1('DescriptionNewHireAccessAdmin')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHireAccessAdmin'); 
    public static string NEWHIRE_DESCRIPTION_CONTRACTOR = ITSMSUtilityClass.getFieldValue1('DescriptionNewHireContractor')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHireContractor'); 
    public static string NEWHIRE_DESCRIPTION_PERFORCE = ITSMSUtilityClass.getFieldValue1('DescriptionNewHirePerforce')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHirePerforce'); 
    public static string NEWHIRE_DESCRIPTION_SOFTWARE = ITSMSUtilityClass.getFieldValue1('DescriptionAdditionalSoftware'); 
    public static string NEWHIRE_DESCRIPTION_AGILE = ITSMSUtilityClass.getFieldValue1('DescriptionNewHireAgile')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHireAgile'); 
    public static string NEWHIRE_DESCRIPTION_BACKOFFICE = ITSMSUtilityClass.getFieldValue1('DescriptionNewHireBackOffice')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHireBackOffice'); 
    public static string NEWHIRE_DESCRIPTION_TELECOM = ITSMSUtilityClass.getFieldValue1('DescriptionNewHireTelecom')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHireTelecom'); 
    public static string NEWHIRE_DESCRIPTION_MISC = ITSMSUtilityClass.getFieldValue1('DescriptionNewHireMisc')+' '+ ITSMSUtilityClass.getFieldValue2('DescriptionNewHireMisc'); 
    public static string NEWHIRE_EMAIL_CHILDQUERY = ITSMSUtilityClass.getFieldValue1('SelectNewHireEmailChild')+' '+ ITSMSUtilityClass.getFieldValue2('SelectNewHireEmailChild');
    public static string NEWHIRE_EMAIL_PARENTQUERY = ITSMSUtilityClass.getFieldValue1('SelectNewHireEmailParent1')+' '+ ITSMSUtilityClass.getFieldValue2('SelectNewHireEmailParent1')+' '+ ITSMSUtilityClass.getFieldValue1('SelectNewHireEmailParent2')+' '+ ITSMSUtilityClass.getFieldValue2('SelectNewHireEmailParent2');
    public static string NEWHIRE_EMPLOYEE = ITSMSUtilityClass.getFieldValue1('NewHireTypeEmployee');
    public static string NEWHIRE_PAGESIZE = ITSMSUtilityClass.getFieldValue1('NewHirePageSize');
    public static string NEWHIRE_QUERY = ITSMSUtilityClass.getFieldValue1('SelectNewHireParent1')+' '+ ITSMSUtilityClass.getFieldValue2('SelectNewHireParent1')+' '+ ITSMSUtilityClass.getFieldValue1('SelectNewHireParent2')+' '+ ITSMSUtilityClass.getFieldValue2('SelectNewHireParent2')+' '+ ITSMSUtilityClass.getFieldValue1('SelectNewHireParent3')+' '+ ITSMSUtilityClass.getFieldValue2('SelectNewHireParent3') ;
    public static string NEWHIRE_SORTDIRECTION = ITSMSUtilityClass.getFieldValue1('NewHireSortDirection');
    public static string NEWHIRE_SORTFIELD = ITSMSUtilityClass.getFieldValue1('NewHireSortField');
    public static string NEWHIRE_SRVREQTYPE_PARENT = ITSMSUtilityClass.getFieldValue1('ServReqTypeNewHireParent');
    public static string NEWHIRE_SRVREQTYPE_ACTIVEDIRECTORY = ITSMSUtilityClass.getFieldValue1('ServReqTypeActiveDirectory'); 
    public static string NEWHIRE_SRVREQTYPE_CONTREXT = ITSMSUtilityClass.getFieldValue1('ServReqTypeContrExt'); 
    public static string NEWHIRE_SRVREQPRODUCT = ITSMSUtilityClass.getFieldValue1('ProductNewHireParent');
    public static string NEWHIRE_STATUS_AD_OPEN = ITSMSUtilityClass.getFieldValue1('StatusADOpen'); 
    public static string NEWHIRE_STATUS_CAN_SUBMIT = ITSMSUtilityClass.getFieldValue1('StatusesToAllowSubmit'); 
    public static string NEWHIRE_STATUS_SAVE = ITSMSUtilityClass.getFieldValue1('StatusNewHireSave'); 
    public static string NEWHIRE_STATUS_SUBMIT = ITSMSUtilityClass.getFieldValue1('StatusNewHireSubmit'); 
    public static string NEWHIRE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectNewHireParent'); 
    public static string NEWHIRE_SUBJECT_SOFTWARE = ITSMSUtilityClass.getFieldValue1('SubjectNewHireSoftware'); 
    public static string NEWHIRE_TYPE_AD = ITSMSUtilityClass.getFieldValue1('NewHireTypeNeedsAD'); 

    public static string ORACLE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryOracle');
    public static string ORACLE_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailOracle');
    public static string ORACLE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionOracle');
    public static string ORACLE_DESCRIPTION_AGILE = ITSMSUtilityClass.getFieldValue1('DescriptionOracleAgile')+ITSMSUtilityClass.getFieldValue2('DescriptionOracleAgile');
    public static string ORACLE_DESCRIPTION_NOTAGILE = ITSMSUtilityClass.getFieldValue1('DescriptionOracleNotAgile')+ITSMSUtilityClass.getFieldValue2('DescriptionOracleNotAgile');
    public static string ORACLE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductOracle');
    public static string ORACLE_PRODUCT_AGILE = ITSMSUtilityClass.getFieldValue1('ProductOracleAgile');
    public static string ORACLE_PRODUCT_OBIEE = ITSMSUtilityClass.getFieldValue1('ProductOracleOBIEE');
    public static string ORACLE_PRODUCT_OTHER = ITSMSUtilityClass.getFieldValue1('ProductOracleOther');
    public static string ORACLE_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeOracle');
    public static string ORACLE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectOracle');
    public static string ORACLE_SUBJECT_AGILE = ITSMSUtilityClass.getFieldValue1('SubjectOracleAgile');
    public static string ORACLE_SUBJECT_NOTAGILE = ITSMSUtilityClass.getFieldValue1('SubjectOracleNotAgile');

    public static string PERFORCE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryPerforce');
    public static string PERFORCE_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailPerforce');
    public static string PERFORCE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionPerforce');
    public static string PERFORCE_OPTIONS = ITSMSUtilityClass.getFieldValue1('PerforceOptions');
    public static string PERFORCE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductPerforce');
    public static string PERFORCE_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypePerforce');
    public static string PERFORCE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectPerforce');

    public static string PERMISSION_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryPermissions');
    public static string PERMISSION_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailPermissions');
    public static string PERMISSION_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionPermissions');
    public static string PERMISSION_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductPermissions');
    public static string PERMISSION_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypePermissions');
    public static string PERMISSION_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectPermissions');

    public static string PERMISSIONS_DESC_AGILE = ITSMSUtilityClass.getFieldValue1('PermissionsAgile');
    public static string PERMISSIONS_DESC_ORACLEASCP = ITSMSUtilityClass.getFieldValue1('PermissionsOracleASCP');
    public static string PERMISSIONS_DESC_ORACLEEBS = ITSMSUtilityClass.getFieldValue1('PermissionsOracleEBS');
    public static string PERMISSIONS_DESC_ORACLEOBIEE = ITSMSUtilityClass.getFieldValue1('PermissionsOracleOBIEE');
    public static string PERMISSIONS_DESC_ADDMEMBER = ITSMSUtilityClass.getFieldValue1('PermissionsAddMember');
    public static string PERMISSIONS_DESC_ADDTOGROUP = ITSMSUtilityClass.getFieldValue1('PermissionsAddToGroup');
    public static string PERMISSIONS_DESC_FULLACCESS = ITSMSUtilityClass.getFieldValue1('PermissionsFullAccess');
    public static string PERMISSIONS_DESC_MANAGINGMEMBER = ITSMSUtilityClass.getFieldValue1('PermissionsManagingMember');
    public static string PERMISSIONS_DESC_POCMEMBER = ITSMSUtilityClass.getFieldValue1('PermissionsPOCMember');
    public static string PERMISSIONS_DESC_READONLY = ITSMSUtilityClass.getFieldValue1('PermissionsReadOnly');
    public static string PERMISSIONS_DESC_READWRITEMODIFY = ITSMSUtilityClass.getFieldValue1('PermissionsReadWriteModify');
    public static string PERMISSIONS_DESC_REMOVEACCESS = ITSMSUtilityClass.getFieldValue1('PermissionsRemoveAccess');
    public static string PERMISSIONS_DESC_REMOVEFROMGROUP = ITSMSUtilityClass.getFieldValue1('PermissionsRemoveFromGroup');
    public static string PERMISSIONS_DESC_REMOVEMEMBER = ITSMSUtilityClass.getFieldValue1('PermissionsRemoveMember');
    public static string PERMISSIONS_DESC_REMOVEREAD = ITSMSUtilityClass.getFieldValue1('PermissionsRemoveRead');
    public static string PERMISSIONS_DESC_REMOVEWRITEMODIFY = ITSMSUtilityClass.getFieldValue1('PermissionsRemoveWriteModify');
    public static string PERMISSIONS_DESC_RESETPASSWORD = ITSMSUtilityClass.getFieldValue1('PermissionsResetPassword');
    public static string PERMISSIONS_DESC_SENDAS = ITSMSUtilityClass.getFieldValue1('PermissionsSendAs');
    public static string PERMISSIONS_DESC_SENDONBEHALF = ITSMSUtilityClass.getFieldValue1('PermissionsSendOnBehalf');
    public static string PERMISSIONS_ERROR_USER = ITSMSUtilityClass.getFieldValue1('PermissionsErrorUser');
    public static string PERMISSIONS_FIELDS = ITSMSUtilityClass.getFieldValue1('SelectPermissionsFields') +  ITSMSUtilityClass.getFieldValue2('SelectPermissionsFields');
    public static string PERMISSIONS_QUERY = ITSMSUtilityClass.getFieldValue1('SelectPermissions1') +  ' ' + ITSMSUtilityClass.getFieldValue2('SelectPermissions1')+ ' ' + ITSMSUtilityClass.getFieldValue1('SelectPermissions2') + ' ' + ITSMSUtilityClass.getFieldValue2('SelectPermissions2');
    public static string PERMISSIONS_RECTYPE_FOLDERSHARE_EXISTING = ITSMSUtilityClass.getFieldValue1('PermissionsRTFolderShareExisting');
    public static string PERMISSIONS_RECTYPE_FOLDERSHARE_NEW = ITSMSUtilityClass.getFieldValue1('PermissionsRTFolderShareNew');
    public static string PERMISSIONS_RECTYPE_EMAILSECURITY_EXISTING = ITSMSUtilityClass.getFieldValue1('PermissionsRTEmailSecExisting');
    public static string PERMISSIONS_RECTYPE_EMAILSECURITY_NEW = ITSMSUtilityClass.getFieldValue1('PermissionsRTEmailSecNew');
    public static string PERMISSIONS_RECTYPE_ORACLE_AGILE = ITSMSUtilityClass.getFieldValue1('PermissionsRTOracleAgile');
    public static string PERMISSIONS_RECTYPE_ORACLE_ASCP = ITSMSUtilityClass.getFieldValue1('PermissionsRTOracleASCP');
    public static string PERMISSIONS_RECTYPE_ORACLE_EBS = ITSMSUtilityClass.getFieldValue1('PermissionsRTOracleEBS');
    public static string PERMISSIONS_RECTYPE_ORACLE_OBIEE = ITSMSUtilityClass.getFieldValue1('PermissionsRTOracleOBIEE');
    public static string PERMISSIONS_RECTYPE_SERVICEACCT_EXISTING = ITSMSUtilityClass.getFieldValue1('PermissionsRTServiceAcctExisting');
    public static string PERMISSIONS_RECTYPE_SERVICEACCT_NEW = ITSMSUtilityClass.getFieldValue1('PermissionsRTServiceAcctNew');
    public static string PERMISSIONS_RECTYPE_SHAREDMAILBOX_EXISTING = ITSMSUtilityClass.getFieldValue1('PermissionsRTSharedMbxExisting');
    public static string PERMISSIONS_RECTYPE_SHAREDMAILBOX_NEW = ITSMSUtilityClass.getFieldValue1('PermissionsRTSharedMbxNew');

    public static string RELATED_CASES = ITSMSUtilityClass.getFieldValue1('SelectRelatedCases')+' '+ITSMSUtilityClass.getFieldValue2('SelectRelatedCases');

    public static string REMOTE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryRemoteAccess');
    public static string REMOTE_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailRemoteAccess');
    public static string REMOTE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionRemoteAccess');
    public static string REMOTE_OPTIONS = ITSMSUtilityClass.getFieldValue1('RemoteOptions');
    public static string REMOTE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductRemoteAccess');
    public static string REMOTE_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeRemoteAccess');
    public static string REMOTE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectRemoteAccess');

    public static string REQUESTOR_QUERY = ITSMSUtilityClass.getFieldValue1('SelectRequestor') + ' ' +ITSMSUtilityClass.getFieldValue2('SelectRequestor');
    public static string REQUESTOR_CONTACTQUERY = ITSMSUtilityClass.getFieldValue1('SelectRequestorContact') + ' ' +ITSMSUtilityClass.getFieldValue2('SelectRequestorContact');
    public static string REQUEST_SELECTED = ITSMSUtilityClass.getFieldValue1('RequestSelected');
    
    public static string SELF_HELP_ARTICLES_PER_PAGE = ITSMSUtilityClass.getFieldValue1('SelfHelpArticlesPerPage');

    public static string SERVACCT_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryServiceAccount');
    public static string SERVACCT_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailServiceAccount');
    public static string SERVACCT_DESCRIPTION_EXIST = ITSMSUtilityClass.getFieldValue1('DescriptionServiceAccountExisting');
    public static string SERVACCT_DESCRIPTION_NEW = ITSMSUtilityClass.getFieldValue1('DescriptionServiceAccountNew');
    public static string SERVACCT_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductServiceAccount');
    public static string SERVACCT_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeServiceAccount');
    public static string SERVACCT_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSharedMailbox');

    public static string SERVER_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryServer');
    public static string SERVER_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailServer');
    public static string SERVER_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionServer')+ ITSMSUtilityClass.getFieldValue2('DescriptionServer');
    public static string SERVER_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeServer');
    public static string SERVER_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectServer');

    public static string SERVER_STORAGE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryStorage');
    public static string SERVER_STORAGE_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailStorage');
    public static string SERVER_STORAGE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionStorage1')+ITSMSUtilityClass.getFieldValue2('DescriptionStorage1')+ITSMSUtilityClass.getFieldValue1('DescriptionStorage2')+ITSMSUtilityClass.getFieldValue2('DescriptionStorage2');
    public static string SERVER_STORAGE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductStorage');
    public static string SERVER_STORAGE_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeStorage');
    public static string SERVER_STORAGE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectStorage');   

    public static string SHAREDMBX_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySharedMailbox');
    public static string SHAREDMBX_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailSharedMailbox');
    public static string SHAREDMBX_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionSharedMailbox')+ITSMSUtilityClass.getFieldValue2('DescriptionSharedMailbox');
    public static string SHAREDMBX_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductSharedMailbox');
    public static string SHAREDMBX_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeSharedMailbox');
    public static string SHAREDMBX_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSharedMailbox');

    public static string SHAREPOINT_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySharePoint');
    public static string SHAREPOINT_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailSharePoint');
    public static string SHAREPOINT_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionSharePoint');
    public static string SHAREPOINT_PRODUCTCREATE = ITSMSUtilityClass.getFieldValue1('ProductSharePointCreate');
    public static string SHAREPOINT_PRODUCTMODIFY = ITSMSUtilityClass.getFieldValue1('ProductSharePointModify');
    public static string SHAREPOINT_PRODUCTDISABLE = ITSMSUtilityClass.getFieldValue1('ProductSharePointDisable');
    public static string SHAREPOINT_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeSharePoint');
    public static string SHAREPOINT_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSharePoint');

    public static string SOFTWARE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySoftware');
    public static string SOFTWARE_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailSoftware');
    public static string SOFTWARE_GROUP1_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySoftwareGroup1');
    public static string SOFTWARE_GROUP1_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailSoftwareGroup1');
    public static string SOFTWARE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionSoftware');
    public static string SOFTWARE_NAME_GROUP1 = ITSMSUtilityClass.getFieldValue1('SoftwareNameGroup1');
    public static string SOFTWARE_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeSoftware');
    public static string SOFTWARE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSoftware');

    public static string SOFTWARE_FISHEYE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySoftwareFisheye');
    public static string SOFTWARE_FISHEYE_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailSoftwareFisheye');
    public static string SOFTWARE_FISHEYE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionSoftwareFisheye');
    public static string SOFTWARE_FISHEYE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductSoftwareFisheye');
    public static string SOFTWARE_FISHEYE_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeSoftwareFisheye');
    public static string SOFTWARE_FISHEYE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSoftwareFisheye');

    public static string SOFTWARE_JIRA_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySoftwareJIRA');
    public static string SOFTWARE_JIRA_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailSoftwareJIRA');
    public static string SOFTWARE_JIRA_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionSoftwareJIRA');
    public static string SOFTWARE_JIRA_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductSoftwareJIRA');
    public static string SOFTWARE_JIRA_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeSoftwareJIRA');
    public static string SOFTWARE_JIRA_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSoftwareJIRA');

    public static string SOFTWARE_OTHER_BAMBOO = ITSMSUtilityClass.getFieldValue1('SoftwareOtherBamboo');
    public static string SOFTWARE_OTHER_FISHEYE = ITSMSUtilityClass.getFieldValue1('SoftwareOtherFisheye');
    public static string SOFTWARE_OTHER_HIPCHAT = ITSMSUtilityClass.getFieldValue1('SoftwareOtherHipChat');
    public static string SOFTWARE_OTHER_JIRA = ITSMSUtilityClass.getFieldValue1('SoftwareOtherJIRA');
    public static string SOFTWARE_OTHER_WIKI = ITSMSUtilityClass.getFieldValue1('SoftwareOtherWIKI');

    public static string SOFTWARE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductSoftware');
    public static string SOFTWARE_PRODUCT_BAMBOO = ITSMSUtilityClass.getFieldValue1('ProductSoftwareBamboo');
    public static string SOFTWARE_PRODUCT_FISHEYE = ITSMSUtilityClass.getFieldValue1('ProductSoftwareFisheye');
    public static string SOFTWARE_PRODUCT_HIPCHAT = ITSMSUtilityClass.getFieldValue1('ProductSoftwareHipChat');
    public static string SOFTWARE_PRODUCT_JIRA = ITSMSUtilityClass.getFieldValue1('ProductSoftwareJIRA');
    public static string SOFTWARE_PRODUCT_WIKI = ITSMSUtilityClass.getFieldValue1('ProductSoftwareWIKI');

    public static string SOFTWARE_WIKI_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySoftwareWIKI');
    public static string SOFTWARE_WIKI_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailSoftwareWIKI');
    public static string SOFTWARE_WIKI_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionSoftwareWIKI');
    public static string SOFTWARE_WIKI_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductSoftwareWIKI');
    public static string SOFTWARE_WIKI_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeSoftwareWIKI');
    public static string SOFTWARE_WIKI_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSoftwareWIKI');
    
    public static string SOFTWARE_OTHER_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySoftwareOther');
    public static string SOFTWARE_OTHER_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailSoftwareOther');
    public static string SOFTWARE_OTHER_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionSoftwareOther');
    public static string SOFTWARE_OTHER_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductSoftwareOther');
    public static string SOFTWARE_OTHER_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeSoftwareOther');
    public static string SOFTWARE_OTHER_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSoftwareOther');
 
    public static string SUBSCRIBE_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategorySubscribe');
    public static string SUBSCRIBE_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailSubscribe');
    public static string SUBSCRIBE_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionSubscribe');
    public static string SUBSCRIBE_OPTIONS = ITSMSUtilityClass.getFieldValue1('SubscribeOptions');
    public static string SUBSCRIBE_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductSubscribe');
    public static string SUBSCRIBE_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeSubscribe');
    public static string SUBSCRIBE_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectSubscribe');

    public static string SUPPORT_CATEGORY = ITSMSUtilityClass.getFieldValue1('SupportCategories');
    public static string SUPPORT_CATEGORY_ACCESS = ITSMSUtilityClass.getFieldValue1('SupportCategoryAccess');
    public static string SUPPORT_CATEGORY_CONFERENCING = ITSMSUtilityClass.getFieldValue1('SupportCategoryConferencing');
    public static string SUPPORT_CATEGORY_IS_SINGULAR = ITSMSUtilityClass.getFieldValue1('SupportCategorySingular'); 
    public static string SUPPORT_CATEGORY_MOBILITY = ITSMSUtilityClass.getFieldValue1('SupportCategoryMobility');
    public static string SUPPORT_CATEGORY_SOFTWARE = ITSMSUtilityClass.getFieldValue1('SupportCategorySoftware');
    public static string SUPPORT_CATEGORY_WORKSTATION = ITSMSUtilityClass.getFieldValue1('SupportCategoryWorkstation');
    public static string SUPPORT_CATEGORY_SERVER = ITSMSUtilityClass.getFieldValue1('SupportCategoryServer');
    public static string SUPPORT_CHILDQUERY = ITSMSUtilityClass.getFieldValue1('SelectSupportChildren')+' '+ITSMSUtilityClass.getFieldValue2('SelectSupportChildren');
    public static string SUPPORT_QUERY = ITSMSUtilityClass.getFieldValue1('SelectSupport1')+' '+ITSMSUtilityClass.getFieldValue2('SelectSupport1')+' '+ITSMSUtilityClass.getFieldValue1('SelectSupport2')+' '+ITSMSUtilityClass.getFieldValue2('SelectSupport2')+' '+ITSMSUtilityClass.getFieldValue1('SelectSupport3')+' '+ITSMSUtilityClass.getFieldValue2('SelectSupport3')+' '+ITSMSUtilityClass.getFieldValue1('SelectSupport4')+' '+ITSMSUtilityClass.getFieldValue2('SelectSupport4')+' '+ITSMSUtilityClass.getFieldValue1('SelectSupport5')+' '+ITSMSUtilityClass.getFieldValue2('SelectSupport5')+' '+ITSMSUtilityClass.getFieldValue1('SelectSupport6')+' '+ITSMSUtilityClass.getFieldValue2('SelectSupport6');
    public static string SUPPORT_SRVREQTYPE_GENERAL = ITSMSUtilityClass.getFieldValue1('ServReqTypeGeneralCase');
    public static string SUPPORT_SRVREQTYPE_PARENT = ITSMSUtilityClass.getFieldValue1('ServReqTypeSupportParent');
    public static string SUPPORT_SUBJECT_PARENT = ITSMSUtilityClass.getFieldValue1('SubjectSupportParent');
    public static string SUPPORT_SUBJECT_ISSUE = ITSMSUtilityClass.getFieldValue1('SubjectIssue');
    public static string SUPPORT_STATUS_SAVE = ITSMSUtilityClass.getFieldValue1('StatusSupportSave'); 
    public static string SUPPORT_STATUS_SUBMIT = ITSMSUtilityClass.getFieldValue1('StatusSupportSubmit'); 
    public static string SUPPORT_STATUS_CAN_SUBMIT = ITSMSUtilityClass.getFieldValue1('StatusesToAllowSubmit'); 

    public static string TAB_MYCASES = ITSMSUtilityClass.getFieldValue1('TabMyCases'); 
    public static string TAB_MYNEWTEAM = ITSMSUtilityClass.getFieldValue1('TabMyNewTeam'); 
    public static string TAB_REQUESTHELP = ITSMSUtilityClass.getFieldValue1('TabRequestHelp'); 

    public static string TELECOM_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryTelecom');
    public static string TELECOM_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailTelecom');
    public static string TELECOM_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionTelecom');
    public static string TELECOM_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductTelecom');
    public static string TELECOM_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeTelecom');
    public static string TELECOM_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectTelecom');

    public static string USER_QUERY = ITSMSUtilityClass.getFieldValue1('SelectUser');

    public static string WIKI_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryWIKI');
    public static string WIKI_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailWIKI');
    public static string WIKI_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionWIKI');
    public static string WIKI_OPTIONS = ITSMSUtilityClass.getFieldValue1('WIKIOptions');
    public static string WIKI_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductWIKI');
    public static string WIKI_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeWIKI');
    public static string WIKI_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectWIKI');

    public static string WORKSTATION_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryWorkstation');
    public static string WORKSTATION_CATEGORYDETAILS = ITSMSUtilityClass.getFieldValue1('CategoryDetailWorkstation');
    public static string WORKSTATION_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionWorkstation');
    public static string WORKSTATION_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypeWorkstation');
    public static string WORKSTATION_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectWorkstation');

    public static string WORKSTATION_PARTS_CATEGORY = ITSMSUtilityClass.getFieldValue1('CategoryPartPeripheral');
    public static string WORKSTATION_PARTS_CATEGORYDETAIL = ITSMSUtilityClass.getFieldValue1('CategoryDetailPartPeripheral');
    public static string WORKSTATION_PARTS_DESCRIPTION = ITSMSUtilityClass.getFieldValue1('DescriptionPartPeripheral');
    public static string WORKSTATION_PARTS_PRODUCT = ITSMSUtilityClass.getFieldValue1('ProductPartPeripheral');
    public static string WORKSTATION_PARTS_SERVICEREQUESTTYPE = ITSMSUtilityClass.getFieldValue1('ServReqTypePartPeripheral');
    public static string WORKSTATION_PARTS_SUBJECT = ITSMSUtilityClass.getFieldValue1('SubjectPartPeripheral');

}