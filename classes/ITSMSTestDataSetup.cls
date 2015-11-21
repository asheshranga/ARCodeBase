@isTest
public class ITSMSTestDataSetup {
    @isTest public static void createNewHirePending() {
        ITSMSTestDataSetup.createTestConstants();
        // create parent case for new hire in pending submission
        string inputCategory = ITSMSConstants.NEWHIRE;
        string srvreqType = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
        Case nhCase = ITSMSUtilityClass.createCase(inputCategory, srvreqType);
        // set basic data for 'Pending Submission' Employee
        nhCase.StartDate__c = date.newInstance(2015,08,20);
        nhCase.Status = ITSMSConstants.NEWHIRE_STATUS_SAVE;
        nhCase.FirstName__c = 'Pending';
        nhCase.LastName__c = 'Employee';
        nhCase.Subject = 'PendingSubmission Status'; 
        nhCase.EmployeeType__c = 'Regular'; 
        nhCase.Citizenship__c = 'US Citizen'; 
        nhCase.PhysicalLocation__c = 'Carlsbad, CA - B1';
        nhCase.OfficeCubeNumber__c = 'Some cube'; 
        nhCase.DepartmentName__c = 'test';
        nhCase.MiddleNameInitial__c = 'M';
        boolean isUpserted = ITSMSUtilityClass.upsertCase(nhCase);
    }  
    @isTest public static void createNewHireToSubmit() {
        ITSMSTestDataSetup.createTestConstants();
        // create parent case for new hire employee as submitted
        string inputCategory = ITSMSConstants.NEWHIRE;
        string srvreqType = ITSMSConstants.NEWHIRE_SRVREQTYPE_PARENT;
        Case nhCase = ITSMSUtilityClass.createCase(inputCategory, srvreqType);
        // set data for 'Submitted' Employee
        nhCase.StartDate__c = date.newInstance(2015,08,20);
        nhCase.Status = ITSMSConstants.NEWHIRE_STATUS_SAVE;
        nhCase.FirstName__c = 'Submitted';
        nhCase.MiddleNameInitial__c ='X';
        nhCase.LastName__c = 'Employee';
        nhCase.Subject = 'Submitted Status Test'; 
        nhCase.EmployeeType__c = 'Regular'; 
        nhCase.Citizenship__c = 'US Citizen'; 
        nhCase.PhysicalLocation__c = 'Carlsbad, CA - B1';
        nhCase.OfficeCubeNumber__c = 'Some cube'; 
        nhCase.DepartmentName__c = 'test';
        nhCase.MiddleNameInitial__c = 'M';
        nhCase.AgileAccessRequired__c = 'No';
        nhCase.DoYouApproveThisForm__c  = 'Yes';
        nhCase.DeskPhone__c = 'Yes';
        nhCase.WirelessHeadset__c = 'No';
        nhCase.PCModelType__c = 'No PC Required';
        nhCase.IsRemoteAccessRequired__c = 'Yes';
        nhCase.WIKIRequired__c = 'No';
        nhCase.IsPerforceAccessRequired__c = 'No';
        nhCase.AgileAccessRequired__c = 'No';
        nhCase.BackofficeSystemDetails__c = 'Exede/Denver';
        nhCase.BackofficeSystemsAccess__c = 'freeform text';
        nhCase.ExedeBackOfficeJumpBox__c = 'freeform text';
        nhCase.NOCAgents__c= True;
        boolean isUpserted = ITSMSUtilityClass.upsertCase(nhCase);
        system.debug('@@ test case:'+isUpserted+'  '+nhCase);
    }  
    @isTest public static void createTestCase() {
        ITSMSTestDataSetup.createTestConstants();
        // create test case in pending submission will default category and reqType to general case
        string inputCategory = ITSMSConstants.GENERAL_CATEGORY;
        string srvreqType = ITSMSConstants.GENERAL_CATEGORY;
        Case testCase = ITSMSUtilityClass.createCase(inputCategory, srvreqType);
        // set basic data for 'Pending Submission'  
        testCase.Subject = 'PendingSubmission Status'; 
        boolean isUpserted = ITSMSUtilityClass.upsertCase(testCase);
    }  
    @isTest public static void createTestContact() {
        //                   create account for test contact 
        Account testAccount = new Account ( Name='testing', BillingStreet = '111 W Main St', BillingCity = 'Nowhere',
                                              BillingPostalCode='11111', BillingState='CA');
        insert testAccount;
        Contact newHire = new Contact (AccountId = testAccount.Id, FirstName='NewHire', LastName='NewHire', NewHireType__c = 'Employee',
                                       Email = 'testContact@testing.com'); 
        insert newHire;
    }  
    @isTest public static void createTestConstants() {
        // first check if needed
        ITSMSKeyValueStore__c[] ITSMSSettingsExist = [Select Id, Name, Value1__c from ITSMSKeyValueStore__c]; 
        if ( ITSMSSettingsExist.size() > 0 )
        {
            system.debug('@@ constants:'+ ITSMSSettingsExist);
        } else {
            // need to run as a system admin user
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            // Initialize ITSMS Constant settings
            ITSMSKeyValueStore__c[] ITSMSSettings = new ITSMSKeyValueStore__c[]{          
                new ITSMSKeyValueStore__c(Code__c='AccessTypeNew',NAME='AccessTypeNew',URL__C='',VALUE1__C='#New#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='AccessTypeOracleAgile',NAME='AccessTypeOracleAgile',URL__C='',VALUE1__C='#Agile#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='AccessTypeOracleASCP',NAME='AccessTypeOracleASCP',URL__C='',VALUE1__C='#Oracle ASCP#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='AccessTypeOracleEBS',NAME='AccessTypeOracleEBS',URL__C='',VALUE1__C='#Oracle EBS#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='AccessTypeOracleOBIEE',NAME='AccessTypeOracleOBIEE',URL__C='',VALUE1__C='#Oracle BI (OBIEE)#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='AccessTypeSecurityGroup',NAME='AccessTypeSecurityGroup',URL__C='',VALUE1__C='Security Group',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ActionCreate',NAME='ActionCreate',URL__C='',VALUE1__C='Create account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ActionDisable',NAME='ActionDisable',URL__C='',VALUE1__C='Disable account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ActionModify',NAME='ActionModify',URL__C='',VALUE1__C='Modify Account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='AgileOptions',NAME='AgileOptions',URL__C='',VALUE1__C='#Modify Access#Remove Access#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleAreaAlerts',NAME='ArticleAreaAlerts',URL__C='',VALUE1__C='LandingPage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleAreaFeaturedLink',NAME='ArticleAreaFeaturedLink',URL__C='',VALUE1__C='LandingPage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleAreaFooter',NAME='ArticleAreaFooter',URL__C='',VALUE1__C='LandingPage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleAreaForms',NAME='ArticleAreaForms',URL__C='',VALUE1__C='LandingPage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleAreaMetrics',NAME='ArticleAreaMetrics',URL__C='',VALUE1__C='Contact Us',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleAreaNewHire',NAME='ArticleAreaNewHire',URL__C='',VALUE1__C='New Hire',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleSectionAgile',NAME='ArticleSectionAgile',URL__C='',VALUE1__C='Agile',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleSectionAlerts',NAME='ArticleSectionAlerts',URL__C='',VALUE1__C='Alerts & Notifications',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleSectionDesktop',NAME='ArticleSectionDesktop',URL__C='',VALUE1__C='Desktop',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleSectionFeaturedLink',NAME='ArticleSectionFeaturedLink',URL__C='',VALUE1__C='Featured Links',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleSectionFooter',NAME='ArticleSectionFooter',URL__C='',VALUE1__C='Footer',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleSectionForms',NAME='ArticleSectionForms',URL__C='',VALUE1__C='Forms',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleSectionMetrics',NAME='ArticleSectionMetrics',URL__C='',VALUE1__C='IT Metrics',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleTypeAlerts',NAME='ArticleTypeAlerts',URL__C='',VALUE1__C='Online',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleTypeFeaturedLink',NAME='ArticleTypeFeaturedLink',URL__C='',VALUE1__C='Online',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleTypeFooter',NAME='ArticleTypeFooter',URL__C='',VALUE1__C='Online',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleTypeForms',NAME='ArticleTypeForms',URL__C='',VALUE1__C='Online',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleTypeNewHire',NAME='ArticleTypeNewHire',URL__C='',VALUE1__C='Online',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ArticleTypeMetrics',NAME='ArticleTypeMetrics',URL__C='',VALUE1__C='Online',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='AttachmentsIncrement',NAME='AttachmentsIncrement',URL__C='',VALUE1__C='3',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseCloseStatus',NAME='CaseCloseStatus',URL__C='',VALUE1__C='Closed',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseStatusAllClosing',NAME='CaseStatusAllClosing',URL__C='',VALUE1__C='#Closed - Cancelled#Closed - Duplicate#Closed - Opened in Error#Closed - Private#Closed#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseComment',NAME='CaseComment',URL__C='',VALUE1__C='<b>Created By: {0}  ({1}) | Last Modified By: {2}  ({3})</b><br>{4}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseInProgressStatus',NAME='CaseInProgressStatus',URL__C='',VALUE1__C='In Progress',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseOrigin',NAME='CaseOrigin',URL__C='',VALUE1__C='Web',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CasePreSubmitStatus',NAME='CasePreSubmitStatus',URL__C='',VALUE1__C='Pending Submission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseRecordType',NAME='CaseRecordType',URL__C='',VALUE1__C='ITSMS - General',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseRecordTypeFeedback',NAME='CaseRecordTypeFeedback',URL__C='',VALUE1__C='ITSMS - Feedback',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseTeamRoleDelegate',NAME='CaseTeamRoleDelegate',URL__C='',VALUE1__C='Delegate',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseTeamRoleRequestedFor',NAME='CaseTeamRoleRequestedFor',URL__C='',VALUE1__C='Requested For',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseTeamRoleRequestor',NAME='CaseTeamRoleRequestor',URL__C='',VALUE1__C='Requestor',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseTypeIssue',NAME='CaseTypeIssue',URL__C='',VALUE1__C='Service Issue',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CaseTypeRequest',NAME='CaseTypeRequest',URL__C='',VALUE1__C='Service Request',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryActiveDirectory',NAME='CategoryActiveDirectory',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryAgile',NAME='CategoryAgile',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryConferencing',NAME='CategoryConferencing',URL__C='',VALUE1__C='Audio Visual',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDesktop',NAME='CategoryDesktop',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetail',NAME='CategoryDetail',URL__C='',VALUE1__C='Server',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailActiveDirectory',NAME='CategoryDetailActiveDirectory',URL__C='',VALUE1__C='New Hire (A&P)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailAgile',NAME='CategoryDetailAgile',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailConferencing',NAME='CategoryDetailConferencing',URL__C='',VALUE1__C='Support (AV)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailDesktop',NAME='CategoryDetailDesktop',URL__C='',VALUE1__C='Workstation (HW)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailEmailSecAccess',NAME='CategoryDetailEmailSecAccess',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailEmailSecDistr',NAME='CategoryDetailEmailSecDistr',URL__C='',VALUE1__C='Exchange (A&P)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailFolderShare',NAME='CategoryDetailFolderShare',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailMobileAgree',NAME='CategoryDetailMobileAgree',URL__C='',VALUE1__C='Telecom(HW)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailMobileLoanEtc',NAME='CategoryDetailMobileLoanEtc',URL__C='',VALUE1__C='Telecom(HW)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailMobileNewUpgrade',NAME='CategoryDetailMobileNewUpgrade',URL__C='',VALUE1__C='Telecom(HW)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailMobileTransfer',NAME='CategoryDetailMobileTransfer',URL__C='',VALUE1__C='Telecom(HW)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailNewHireParent',NAME='CategoryDetailNewHireParent',URL__C='',VALUE1__C='New Hire (A&P)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailOracle',NAME='CategoryDetailOracle',URL__C='',VALUE1__C='New Hire (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailOracleAgile',NAME='CategoryDetailOracleAgile',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailOracleASCP',NAME='CategoryDetailOracleASCP',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailOracleEBS',NAME='CategoryDetailOracleEBS',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailOracleOBIEE',NAME='CategoryDetailOracleOBIEE',URL__C='',VALUE1__C='Support (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailPartPeripheral',NAME='CategoryDetailPartPeripheral',URL__C='',VALUE1__C='Not sure',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailPerforce',NAME='CategoryDetailPerforce',URL__C='',VALUE1__C='Support (Eng)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailPermissions',NAME='CategoryDetailPermissions',URL__C='',VALUE1__C='New Hire (A&P)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailRemoteAccess',NAME='CategoryDetailRemoteAccess',URL__C='',VALUE1__C='New Hire (A&P)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailServer',NAME='CategoryDetailServer',URL__C='',VALUE1__C='Server',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailServiceAccount',NAME='CategoryDetailServiceAccount',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSharedMailbox',NAME='CategoryDetailSharedMailbox',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSharePoint',NAME='CategoryDetailSharePoint',URL__C='',VALUE1__C='Viaext (A&P)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSoftware',NAME='CategoryDetailSoftware',URL__C='',VALUE1__C='Purchase (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSoftwareFisheye',NAME='CategoryDetailSoftwareFisheye',URL__C='',VALUE1__C='Support (Eng)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSoftwareGroup1',NAME='CategoryDetailSoftwareGroup1',URL__C='',VALUE1__C='Purchase (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSoftwareJIRA',NAME='CategoryDetailSoftwareJIRA',URL__C='',VALUE1__C='Support (Eng)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSoftwareOther',NAME='CategoryDetailSoftwareOther',URL__C='',VALUE1__C='Support (Eng)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSoftwareWIKI',NAME='CategoryDetailSoftwareWIKI',URL__C='',VALUE1__C='Support (Eng)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailStorage',NAME='CategoryDetailStorage',URL__C='',VALUE1__C='Storage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailSubscribe',NAME='CategoryDetailSubscribe',URL__C='',VALUE1__C='User Access (App)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailTelecom',NAME='CategoryDetailTelecom',URL__C='',VALUE1__C='Telecom (NW)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailWIKI',NAME='CategoryDetailWIKI',URL__C='',VALUE1__C='New Hire (A&P)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryDetailWorkstation',NAME='CategoryDetailWorkstation',URL__C='',VALUE1__C='Workstation (HW)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryEmailSecurity',NAME='CategoryEmailSecurity',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryFolderShare',NAME='CategoryFolderShare',URL__C='',VALUE1__C='Accounts & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryIssue',NAME='CategoryIssue',URL__C='',VALUE1__C='General',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryMobileAgree',NAME='CategoryMobileAgree',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryMobileLoanEtc',NAME='CategoryMobileLoanEtc',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryMobileNewUpgrade',NAME='CategoryMobileNewUpgrade',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryMobileTransfer',NAME='CategoryMobileTransfer',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryNewHireParent',NAME='CategoryNewHireParent',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryOracle',NAME='CategoryOracle',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryOracleAgile',NAME='CategoryOracleAgile',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryOracleASCP',NAME='CategoryOracleASCP',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryOracleEBS',NAME='CategoryOracleEBS',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryOracleOBIEE',NAME='CategoryOracleOBIEE',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryPartPeripheral',NAME='CategoryPartPeripheral',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryPerforce',NAME='CategoryPerforce',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryPermissions',NAME='CategoryPermissions',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryRemoteAccess',NAME='CategoryRemoteAccess',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryServer',NAME='CategoryServer',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryServiceAccount',NAME='CategoryServiceAccount',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySharedMailbox',NAME='CategorySharedMailbox',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySharePoint',NAME='CategorySharePoint',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySoftware',NAME='CategorySoftware',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySoftwareFisheye',NAME='CategorySoftwareFisheye',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySoftwareGroup1',NAME='CategorySoftwareGroup1',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySoftwareJIRA',NAME='CategorySoftwareJIRA',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySoftwareOther',NAME='CategorySoftwareOther',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySoftwareWIKI',NAME='CategorySoftwareWIKI',URL__C='',VALUE1__C='Application',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryStorage',NAME='CategoryStorage',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategorySubscribe',NAME='CategorySubscribe',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryTelecom',NAME='CategoryTelecom',URL__C='',VALUE1__C='Network',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryWIKI',NAME='CategoryWIKI',URL__C='',VALUE1__C='Account & Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CategoryWorkstation',NAME='CategoryWorkstation',URL__C='',VALUE1__C='Hardware',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CommunityHomePage',NAME='CommunityHomePage',URL__C='/apex/ITSMSSupportCenterHome#/',VALUE1__C='',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='CommunityURL',NAME='CommunityURL',URL__C='https://devsup2-myexede.cs23.force.com/ViaSatSupportCenter',VALUE1__C='',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ContactUsArea',NAME='ContactUsArea',URL__C='Contact Us',VALUE1__C='Contact Us',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ContactUsEmail',NAME='ContactUsEmail',URL__C='Email',VALUE1__C='Email',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ContactUsHours',NAME='ContactUsHours',URL__C='Hours',VALUE1__C='Hours',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ContactUsPhone',NAME='ContactUsPhone',URL__C='Phone Number',VALUE1__C='Phone Number',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ContactUsSupport',NAME='ContactUsSupport',URL__C='IT Support Personnel',VALUE1__C='IT Support Personnel',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ContactUsType',NAME='ContactUsType',URL__C='Online',VALUE1__C='Online',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ContactRecordType',NAME='ContactRecordType',URL__C='',VALUE1__C='ITSMS Contact',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionAdditionalSoftware',NAME='DescriptionAdditionalSoftware',URL__C='',VALUE1__C='<b>Additional Software:  </b>{0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionAgile',NAME='DescriptionAgile',URL__C='',VALUE1__C='<b>Is access to Agile required?  </b>{0}<br><b>Access Level:  </b>{1}<br><b>Are there any additional Agile roles required?   </b>{2}<br><b>Agile Account Model:   </b>{3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionConferencing',NAME='DescriptionConferencing',URL__C='',VALUE1__C='<br><b>Event Title:  </b>{0}<br><b>Description:  </b>{1}<br><b>Meeting Organizer:  </b>{2}<br><b>Conference Room Setup Time:  </b>{3}<br><b>Meeting Start Time:  </b>{4}<br><b>Meeting End Time:  </b>{5}<br><b>How many people?  </b>{6}<br>',VALUE2__C='<b>VTC Room: </b>{0}<br><b>WebEx Required:  </b>{1}<br><b>WebEx Meeting Number:  </b>{2}<br><b>Host Passcode:  </b>{3}<br><b>Webex Information:  </b>{4}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionDesktop',NAME='DescriptionDesktop',URL__C='',VALUE1__C='<b>Desk Phone:  </b>{0}<br><b>Wireless Headset:  </b>{1}<br><b>PC Model Type:  </b>{2}<br><b>PC Model:  </b>{3}<br><b>Other PC Model:  </b>{4}<br><b>Other Hardware:  </b>{5}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionEmailSecurityExisting',NAME='DescriptionEmailSecurityExisting',URL__C='',VALUE1__C='',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionEmailSecurityNew',NAME='DescriptionEmailSecurityNew',URL__C='',VALUE1__C='<b>Request Type: </b>{0}<br><b>Access Type: </b>{1}<br><b>Group Name: </b>{2}<br><b>Email Address: </b>{3}<br><b>Should users outside of ViaSat be able to send to this distribution list? </b>{4}',VALUE2__C='<br><b>Users and Access: </b>{5}<br><b>Justification: </b>{6}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionFolderShare',NAME='DescriptionFolderShare',URL__C='',VALUE1__C='<b>Request Type: </b>{0}<br><b>Access Type: </b>{1}<br><b>Group Name: </b>{2} ',VALUE2__C='<br><b>Users and Access: </b>{3}<br><b>Justification: </b>{4}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionMobileAgree',NAME='DescriptionMobileAgree',URL__C='',VALUE1__C='<br><b>Device Model:  </b>{0}<br><b>Mobile Phone Number:  </b>{1}<br><b>Case ID:  </b>{2}<br><b>MEID/IMEI Number:  </b>{3}<br><b>ICCID/SIM Number:  </b>{4}<br><b>Serial Number:  </b>{5}<br><b>Who owns the device?  </b>{6}<br>',VALUE2__C='<b>ACCEPT: Terms and Conditions:  </b>{7}<br><b>Dept VP:  </b>{8}<br><b>Cost Center:  </b>{9}<br><b>Justification:  </b>{10}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionMobileLoanEtc',NAME='DescriptionMobileLoanEtc',URL__C='',VALUE1__C='<br><b>Type of Request:  </b>{0}<br><b>Existing Mobile Phone Number:  </b>{1}<br><b>Departure Date:  </b>{2}<br><b>Return Date:  </b>{3}<br><b>Destinations:  </b>{4}<br>',VALUE2__C='<b>Dept VP:  </b>{5}<br><b>Cost Center:  </b>{6}<br><b>Justification:  </b>{7}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionMobileNewUpgrade',NAME='DescriptionMobileNewUpgrade',URL__C='',VALUE1__C='<br><b>Action Type:  </b>{0}<br><b>Existing Mobile Phone Number:  </b>{1}<br><b>Select Carrier and Model:  </b>{2}<br><b>Color:  </b>{3}<br><b>Accessories:  </b>{4}<br>',VALUE2__C='<b>Dept VP:  </b>{5}<br><b>Cost Center:  </b>{6}<br><b>Justification:  </b>{7}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionMobileTransfer',NAME='DescriptionMobileTransfer',URL__C='',VALUE1__C='<br><b>Existing Mobile Phone Number:  </b>{0}<br><b>Current Carrier:  </b>{1}<br><b>Current Phone Model:  </b>{2}<br><b>Contract End Date:  </b>{3}<br><b>New Carrier and Phone Model:  </b>{4}<br><b>Color:  </b>{5}<br><b>Accessories:  </b>{6}<br>',VALUE2__C='<b>Dept VP:  </b>{7}<br><b>Cost Center:  </b>{8}<br><b>Justification:  </b>{9}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHireAccessAdmin',NAME='DescriptionNewHireAccessAdmin',URL__C='',VALUE1__C='<br><b>Is Remote Access (SSL VPN) required?:  </b>{0}<br><b>Shared Mailboxes:   </b>{1}<br><b>Security Groups:  </b>{2}<br><b> List Network Directory:   </b>{3}<br><b>Distribution Groups:  </b>{4}',VALUE2__C='<br><b> Oracle Responsibilities:  </b>{5}<br><b>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHireAgile',NAME='DescriptionNewHireAgile',URL__C='',VALUE1__C='<br><b>Is access to Agile required?  </b>{0}<br><b>Access Level:  </b>{1}<br><b>Additional Agile roles required?   </b>{2}<br><b>Agile Account Model:   </b>{3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHireBackOffice',NAME='DescriptionNewHireBackOffice',URL__C='',VALUE1__C='<br><b>Back Office systems needed?  </b>{0}<br><b>BackOffice - Jump Box Production Request:  </b>{1}<br><b>Provide BackOffice System details:   </b>{2}<br><b>NOC Agents?  </b>{3}',VALUE2__C='<br><b>Is there an Agent you would like us to mirror?  </b>{4}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHireContractor',NAME='DescriptionNewHireContractor',URL__C='',VALUE1__C='<b>Company Name: </b>{0}<br><b>Company Email: </b>{1}<br><b>Work End Date: </b>{2}<br><b>Project/Program: </b>{3} <br><b> Is Oracle Access Required? </b>{4} <br><b> Is WIKI Access Required? </b>{5} <br><b> WIKI Justification: </b>{6}',VALUE2__C='<br><b> WIKI Justification: </b>{6}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHireDesktop',NAME='DescriptionNewHireDesktop',URL__C='',VALUE1__C='<br><b>Desk Phone:  </b>{0}<br><b>Wireless Headset: </b>{1}<br><b>PC Model Type:  </b>{2}<br><b>PC Model:  </b>{3}<br><b>Other PC Model:  </b>{4}',VALUE2__C='<br><b>Other Hardware:  </b>{5}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHireHdr',NAME='DescriptionNewHireHdr',URL__C='',VALUE1__C='<b>New Hire Request for: </b> {0} {1} {2} <br><b>Type: </b> {3} <br><b>Employee Type: </b> {4} <br><b>Start: </b> {5} <br><b>Citizenship: </b> {6} <br><b>Dept Name: </b> {7} <br><b>Physical Location: </b> {8} <br><b>Offsite Loc: </b>{9}<br>',VALUE2__C='<b>Office Cube Number: </b> {10}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHireMisc',NAME='DescriptionNewHireMisc',URL__C='',VALUE1__C='<br><b>Additional Comments:  </b>{0}',VALUE2__C='<br><b>Did Requestor Approve this form?</b>{1}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHirePerforce',NAME='DescriptionNewHirePerforce',URL__C='',VALUE1__C='<br><b>Is Perforce Access Required? </b>{0}',VALUE2__C='<br> <b>Perforce Servers:  </b>{1}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionNewHireTelecom',NAME='DescriptionNewHireTelecom',URL__C='',VALUE1__C='<br><b>NOC Agents?  </b>{0}',VALUE2__C='<br><b>Is there an Agent you would like us to mirror?  </b>{1}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionOracle',NAME='DescriptionOracle',URL__C='',VALUE1__C='<b>List Additional Oracle Responsibilities:  </b>{0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionOracleAgile',NAME='DescriptionOracleAgile',URL__C='',VALUE1__C='<b>Access Type:</b>Agile<br><b>Access Level - Agile:</b>{0}<br><b>What Department does this employee work for:</b>{1}<br><b>Are there any additional Agile roles required?</b>{2}<br>',VALUE2__C='<b>What additional privileges are needed for this account?</b>{3}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionOracleNotAgile',NAME='DescriptionOracleNotAgile',URL__C='',VALUE1__C='<b>Access Type:</b>{0}<br>',VALUE2__C='<b>What additional privileges are needed for this account?</b>{3}<br> <b>Do you approve the creation of this account?</b>{4}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionPartPeripheral',NAME='DescriptionPartPeripheral',URL__C='',VALUE1__C='<b>Perforce Servers:  </b>{0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionPerforce',NAME='DescriptionPerforce',URL__C='',VALUE1__C='<b>Perforce Servers:  </b>{0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionPermissions',NAME='DescriptionPermissions',URL__C='',VALUE1__C='<b>Security Groups:  </b>{0}<br><b>Distribution Groups:  </b>{1}<br><b>Shared Mailboxes:  </b>{2}<br><b>Network Directory Access Level:  </b>{3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionRemoteAccess',NAME='DescriptionRemoteAccess',URL__C='',VALUE1__C='<b>Is Remote Access (SSL VPN) required?:  </b>{0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionServer',NAME='DescriptionServer',URL__C='',VALUE1__C='<br><b>Need By: </b>{0}<br><b>Location: </b>{1}<br><b>Cost Center: </b>{2}<br><b>Brief Description: </b>{3}<br><b>Justification: </b>{4}<br><b>Project:</b>{5}<br><b>Server Location:</b>{6}<br><b>Requesting Organization:</b>{6}<br><b>Approving Dir:</b>{7}',VALUE2__C='<br><b>Customer Use: </b>{8}<br><b>Equipment Class: </b>{9}<br><b>Operating System: </b>{10}<br><b>Storage Requirments: </b>{11}<br><b>CPU: </b>{12}<br><b>Memory: </b>{13}<br><b>Part Number: </b>{14}<br><b>Part Quantity: </b>{15}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionServiceAccountExisting',NAME='DescriptionServiceAccountExisting',URL__C='',VALUE1__C='<b>Request Type:</b>Existing<br> <b>Access Type:</b>{0}<br><b>Action Type:</b>{1}<br><b>Owner:</b>{2}<br><b>List additional Owners (if any):</b>{3}<br><b>Account Type:</b>{4}<br>',VALUE2__C='<b>If temporary, specify the expiration date:</b>{5}<br><b>Service Account name:</b>{6}<br> <b>Justification:</b>{7}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionServiceAccountNew',NAME='DescriptionServiceAccountNew',URL__C='',VALUE1__C='<b>Request Type:</b>New<br><b>Access Type:</b>{0}<br> <b>Owner:</b>{1}<br><b>List additional Owners (if any):</b>{2}<br><b>Account Type:</b>{3}<br> <b>If temporary, specify the expiration date:</b>{4}<br><b>Service Account name:</b>{5}<br>',VALUE2__C='<b>Does the account need a mailbox?:</b>{6}<br> <b>Who will have access to this account?:</b>{7}<br><b>What will this account be used for?:</b>{8}<br><b>In which environment will this account be utilized?:</b>{9}<br><b>Justification:</b>10<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionSharedMailbox',NAME='DescriptionSharedMailbox',URL__C='',VALUE1__C='<b>Request Type:</b>Existing<br><b>Shared Mailbox Name:</b>{0}<br> <b>Email Address:</b>{1}<br><b>Action Type:</b>{2}<br><b>Group Owner:</b>{3}<br><b>Additional POCs:</b>{4}<br><b>Mailbox Members:</b>{5}<br><b>Member Access Level:</b>{6}<br>',VALUE2__C='<b>Justification:</b>{7}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionSharePoint',NAME='DescriptionSharePoint',URL__C='',VALUE1__C='<b>Action Type:</b>{0}<br> <b>First Name:</b>{1}<br> <b>Last Name:</b>{2}<br><b>Company Email Address:</b>{3}<br><b>Link to SharePoint Site:</b>{4}<br><b>Project Name:</b>{5}<br>',VALUE2__C='<b>Justification:</b>{6}<br>'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionSoftware',NAME='DescriptionSoftware',URL__C='',VALUE1__C='<br><b>Software Name:  </b>{0}<br><b>Who is the software for?  </b>{1}<br><b>Is this for Group?  </b>{2}<br><b>Computer Names:  </b>{3}<br><b>Justification:  </b>{4}<br>',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionSoftwareFisheye',NAME='DescriptionSoftwareFisheye',URL__C='',VALUE1__C='<br><b>Repo Account Name:  </b>{0}<br><b>Source Code Path:  </b>{1}<br><b>Moderator:  </b>{2}<br><b>Default Reviewers:  </b>{3}<br><b>List Review Participants:  </b>{4}<br>',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionSoftwareJIRA',NAME='DescriptionSoftwareJIRA',URL__C='',VALUE1__C='<br><b>Project Name:  </b>{0}<br><b>Project Key:  </b>{1}<br><b>Project Lead: </b>{2}<br><b>Desired workflow:  </b>{3}<br><b>Do you want a corresponding wiki space?   </b>{4}<br>',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionSoftwareOther',NAME='DescriptionSoftwareOther',URL__C='',VALUE1__C='<br><b>Product:  </b>{0}<br><b>Nature of Request:  </b>{1}<br>',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionSoftwareWIKI',NAME='DescriptionSoftwareWIKI',URL__C='',VALUE1__C='<br><b>Space Name:  </b>{0}<br><b>Space Key:  </b>{1}<br><b>Description of Space:  </b>{2}<br><b>Space Type:  </b>{3}<br><b>Team Members:  </b>{4}<br>',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionStorage1',NAME='DescriptionStorage1',URL__C='',VALUE1__C='<br><b>Need By: </b>{0}<br><b>Location: </b>{1}<br><b>Cost Center: </b>{2}<br><b>Brief Description: </b>{3}<br><b>Justification: </b>{4}<br><b>Storage Request Type :</b>{5}<br><b>Location:</b>{6}<br><b>New Host:</b>{6}<br><b>Hostname:</b>{7}',VALUE2__C='<br><b>Clustered:</b>{8}<br><b>Storage Type::</b>{9}<br><b>Database:</b>{10}<br><b>Disk Name:</b>{11}<br><b>Size:</b>{12}<br><b>Size Type:</b>{13}<br><b>Snapshots or Clone?:</b>{14}<br><b>Source Hostname:</b>{15}<br><b>Target Hostname::</b>{16}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionStorage2',NAME='DescriptionStorage2',URL__C='',VALUE1__C='<br><b>Environment:</b>{17}<br><b>Frequency:</b>{18}<br><b>Start Date/Time:</b>{19}',VALUE2__C='<br><b>End Date/Time:</b>{20}'),
                new ITSMSKeyValueStore__c(Code__c='DescriptionSubscribe',NAME='DescriptionSubscribe',URL__C='',VALUE1__C='<b>What Back Office systems does this employee need access to?  </b>{0}<br><b>BackOffice - Jump Box Production Request:  </b>{1}<br><b>Provide BackOffice System details:   </b>{2}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionTelecom',NAME='DescriptionTelecom',URL__C='',VALUE1__C='<b>NOC Agents?  </b>{0} <br><b>Is there an Agent you would like us to mirror?  </b>{1}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionWIKI',NAME='DescriptionWIKI',URL__C='',VALUE1__C='<b>WIKI Justification and URLs:  </b>{0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DescriptionWorkstation',NAME='DescriptionWorkstation',URL__C='',VALUE1__C='<br><b>Request Type:  </b>{0}<br><b>PC Model Type:  </b>{1}<br><b>Computer Type:  </b>{2}<br><b>Operating System:  </b>{3}<br><b>Asset Tag on Current System:  </b>{4}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='DesktopPCModels',NAME='DesktopPCModels',URL__C='',VALUE1__C='#Desktop#, #Laptop#, #Apple#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='EmailChildCase',NAME='EmailChildCase',URL__C='',VALUE1__C='<td style="text-align: right;"><a href={0}>{1}</a>{2}:{3}<br>',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='EmailNewHire',NAME='EmailNewHire',URL__C='',VALUE1__C='<b>Welcome Aboard  {0} {1} </b>The following cases listed below have been open for you and assigned to the appropriate IT Team.  Please refer to these case numbers when inquiring on the status of your request.',VALUE2__C='You can check the status of your case by using the IT VHelp Portal,  Please use the “start here” section if this is the first time you have entered the site, it will provide you with information on how to use this site.'),
                new ITSMSKeyValueStore__c(Code__c='EmailRequestor',NAME='EmailRequestor',URL__C='',VALUE1__C='<td style="text-align: right;">{0} {1} <br><br><td style="text-align: right;">',VALUE2__C='Thank you for completing the On boarding form. We have successfully received your request and the following cases have been created, and have been routed to the appropriate IT Team member. <br><br>'),
                new ITSMSKeyValueStore__c(Code__c='EmailSubjectNewHire',NAME='EmailSubjectNewHire',URL__C='',VALUE1__C='Cases Created for New Hire: {0} - {1} {2} {3} – {4} – {5}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='EntitlementAD',NAME='EntitlementAD',URL__C='',VALUE1__C='ITSMS - Individual',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='EntitlementNewHireParent ',NAME='EntitlementNewHireParent    ',URL__C='',VALUE1__C='ITSMS -New Hire/Departure',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormCategoryAccess',NAME='FormCategoryAccess',URL__C='',VALUE1__C='Access',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormCategoryConferencing',NAME='FormCategoryConferencing',URL__C='',VALUE1__C='Conferencing',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormCategoryGeneral',NAME='FormCategoryGeneral',URL__C='',VALUE1__C='General',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormCategoryMobility',NAME='FormCategoryMobility',URL__C='',VALUE1__C='Mobility',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormCategoryServer',NAME='FormCategoryServer',URL__C='',VALUE1__C='Server',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormCategorySoftware',NAME='FormCategorySoftware',URL__C='',VALUE1__C='Software',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormCategoryWorkstation',NAME='FormCategoryWorkstation',URL__C='',VALUE1__C='Workstation',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionConferencing',NAME='FormSectionConferencing',URL__C='',VALUE1__C='VTC',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionEmailSecurity',NAME='FormSectionEmailSecurity',URL__C='',VALUE1__C='Email / Security Group - New/ Existing',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionFolderShare',NAME='FormSectionFolderShare',URL__C='',VALUE1__C='Folder/Share - New/Existing',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionMobilityAgreement',NAME='FormSectionMobilityAgreement',URL__C='',VALUE1__C='Corporate Email Agreement',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionMobilityLoan',NAME='FormSectionMobilityLoan',URL__C='',VALUE1__C='Device Loan, International Plan, or USB Tethering',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionMobilityNewUpgrade',NAME='FormSectionMobilityNewUpgrade',URL__C='',VALUE1__C='New or Upgrade Device',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionMobilityTransfer',NAME='FormSectionMobilityTransfer',URL__C='',VALUE1__C='Transfer Service from Personal account',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionOracle',NAME='FormSectionOracle',URL__C='',VALUE1__C='Oracle Access',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionPartPeripheral',NAME='FormSectionPartPeripheral',URL__C='',VALUE1__C='Parts/Peripherals',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionServerVM',NAME='FormSectionServerVM',URL__C='',VALUE1__C='Server/VM',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionServiceAccount',NAME='FormSectionServiceAccount',URL__C='',VALUE1__C='Service Account - New/Existing',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionSharedMailbox',NAME='FormSectionSharedMailbox',URL__C='',VALUE1__C='Shared Mailbox -New/Existing',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionSharepoint',NAME='FormSectionSharepoint',URL__C='',VALUE1__C='SharePoint',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionSoftware',NAME='FormSectionSoftware',URL__C='',VALUE1__C='Software Request',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionSoftwareFisheye',NAME='FormSectionSoftwareFisheye',URL__C='',VALUE1__C='New Fisheye/Crucible Repository',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionSoftwareJenkins',NAME='FormSectionSoftwareJenkins',URL__C='',VALUE1__C='Jenkins',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionSoftwareJIRA',NAME='FormSectionSoftwareJIRA',URL__C='',VALUE1__C='New JIRA Project',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionSoftwareOther',NAME='FormSectionSoftwareOther',URL__C='',VALUE1__C='All Other Products/Changes /Issues',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionSoftwareWIKI',NAME='FormSectionSoftwareWIKI',URL__C='',VALUE1__C='New Wiki Space',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionStorage',NAME='FormSectionStorage',URL__C='',VALUE1__C='Storage',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormSectionWorkstationLaptop',NAME='FormSectionWorkstationLaptop',URL__C='',VALUE1__C='Workstation/Laptop Dynamic Form Content',value2__c=''),
                new ITSMSKeyValueStore__c(Code__c='FormTitleAccess',NAME='FormTitleAccess',URL__C='',VALUE1__C='Access and Permissions',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormTitleConferencing',NAME='FormTitleConferencing',URL__C='',VALUE1__C='Meeting and Conference',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormTitleGeneral',NAME='FormTitleGeneral',URL__C='',VALUE1__C='General Request',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormTitleMobility',NAME='FormTitleMobility',URL__C='',VALUE1__C='Mobile Devices',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormTitleServer',NAME='FormTitleServer',URL__C='',VALUE1__C='Server/Storage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormTitleSoftware',NAME='FormTitleSoftware',URL__C='',VALUE1__C='Software',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='FormTitleWorkstation',NAME='FormTitleWorkstation',URL__C='',VALUE1__C='Client Compute',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ITSMSApplicationName',NAME='ITSMSApplicationName',URL__C='',VALUE1__C='ITSMS Support Center',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkCaseDetail',NAME='LinkCaseDetail',URL__C='',VALUE1__C='/ITSMSCaseDetail',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkMyCases',NAME='LinkMyCases',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterMyCases',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkNewHireCancel',NAME='LinkNewHireCancel',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterHome',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkNewHireRequest',NAME='LinkNewHireRequest',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterNewHireRequest',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkNewHires',NAME='LinkNewHires',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterNewHireRequest',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkNewHireSubmit',NAME='LinkNewHireSubmit',URL__C='',VALUE1__C='/ITSMSSupportCenterMyNewHires',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportCancel',NAME='LinkSupportCancel',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterHome',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportCenterContactUs',NAME='LinkSupportCenterContactUs',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterContactUs',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportCenterHome',NAME='LinkSupportCenterHome',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterHome',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportCenterMyCases',NAME='LinkSupportCenterMyCases',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterMyCases',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportCenterNewHires',NAME='LinkSupportCenterNewHires',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterMyNewHires',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportCenterRequestHelp',NAME='LinkSupportCenterRequestHelp',URL__C='',VALUE1__C='/apex/ITSMSSUpportCenterRequestHelp',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportCenterSelfHelp',NAME='LinkSupportCenterSelfHelp',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterSelfHelp',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportRequest',NAME='LinkSupportRequest',URL__C='',VALUE1__C='/apex/ITSMSSupportRequest',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='LinkSupportSubmit',NAME='LinkSupportSubmit',URL__C='',VALUE1__C='/apex/ITSMSSupportCenterHome',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='MessageCaseAlreadySubmitted',NAME='MessageCaseAlreadySubmitted',URL__C='',VALUE1__C='This case was already submitted.  Case #{0} with status {1}.',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='MessageCaseCreated',NAME='MessageCaseCreated',URL__C='',VALUE1__C='Your case was created with the status of {1}.',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='MessageErrorMissingContact',NAME='MessageErrorMissingContact',URL__C='',VALUE1__C='The requestor/requested for user is missing an associated contact record in Salesforce for ITSMS.  Please notify your Salesforce Administrator.',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='MessageErrorOnParentClose',NAME='MessageErrorOnParentClose',URL__C='',VALUE1__C='You cannot close this case as open child cases exist.',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='MyCasesDefaultFilter',NAME='MyCasesDefaultFilter',URL__C='',VALUE1__C='AND IsClosed = False',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='MyCasesPageSize',NAME='MyCasesPageSize',URL__C='',VALUE1__C='10',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='MyCasesQuery',NAME='MyCasesQuery',URL__C='',VALUE1__C='Select CaseNumber, EntitlementId, ServiceRequestType__c, Priority, Subject, Status, OwnerId, CreatedById, CreatedDate, RequestingForUser__c,',VALUE2__C='Date_Needed_By__c,ClosedDate From Case WHERE RecordTypeId = :caseRTId'),
                new ITSMSKeyValueStore__c(Code__c='MyCasesSortDirection',NAME='MyCasesSortDirection',URL__C='',VALUE1__C='asc',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='MyCasesSortField',NAME='MyCasesSortField',URL__C='',VALUE1__C='caseNumber',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHire',NAME='NewHire',URL__C='',VALUE1__C='New Hire',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHireCasesQuery',NAME='NewHireCasesQuery',URL__C='',VALUE1__C='Select CaseNumber,ServiceRequestType__c,Subject,Status,OwnerId,Requestor__c,RequestingForUser__c,CreatedDate,Id,StartDate__c, FirstName__c, LastName__c, MiddleNameInitial__c,',VALUE2__C='CreatedById, ClosedDate From Case WHERE ServiceRequestType__c =: NewHireParent'),
                new ITSMSKeyValueStore__c(Code__c='NewHireDefaultFilter',NAME='NewHireDefaultFilter',URL__C='',VALUE1__C='AND IsClosed = False',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHireDesc1',NAME='NewHireDesc1',URL__C='',VALUE1__C='',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHirePageSize',NAME='NewHirePageSize',URL__C='',VALUE1__C='10',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHireSortDirection',NAME='NewHireSortDirection',URL__C='',VALUE1__C='asc',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHireSortField',NAME='NewHireSortField',URL__C='',VALUE1__C='caseNumber',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHireTypeContractor',NAME='NewHireTypeContractor',URL__C='',VALUE1__C='#Contractor#Contractor Extension#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHireTypeEmployee',NAME='NewHireTypeEmployee',URL__C='',VALUE1__C='Employee',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='NewHireTypeNeedsAD',NAME='NewHireTypeNeedsAD',URL__C='',VALUE1__C='#Employee#Contractor#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PerforceOptions',NAME='PerforceOptions',URL__C='',VALUE1__C='#Modify Access#Remove Access#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsAgile',NAME='PermissionsAgile',URL__C='',VALUE1__C='Agile:',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsErrorUser',NAME='PermissionsErrorUser',URL__C='',VALUE1__C='This User was already selected.',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsOracleASCP',NAME='PermissionsOracleASCP',URL__C='',VALUE1__C='Oracle ASCP:',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsOracleEBS',NAME='PermissionsOracleEBS',URL__C='',VALUE1__C='Oracle EBS:',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsOracleOBIEE',NAME='PermissionsOracleOBIEE',URL__C='',VALUE1__C='Oracle OBIEE:',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsAddMember',NAME='PermissionsAddMember',URL__C='',VALUE1__C='Add Member',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsAddToGroup',NAME='PermissionsAddToGroup',URL__C='',VALUE1__C='Add to Group',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsFullAccess',NAME='PermissionsFullAccess',URL__C='',VALUE1__C='Full Access',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsManagingMember',NAME='PermissionsManagingMember',URL__C='',VALUE1__C='Managing Member',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsPOCMember',NAME='PermissionsPOCMember',URL__C='',VALUE1__C='POC Member',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsReadOnly',NAME='PermissionsReadOnly',URL__C='',VALUE1__C='Read Only',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsReadWriteModify',NAME='PermissionsReadWriteModify',URL__C='',VALUE1__C='Read-Write-Modify',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRemoveAccess',NAME='PermissionsRemoveAccess',URL__C='',VALUE1__C='Remove Access',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRemoveFromGroup',NAME='PermissionsRemoveFromGroup',URL__C='',VALUE1__C='Remove from Group',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRemoveMember',NAME='PermissionsRemoveMember',URL__C='',VALUE1__C='Remove Member',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRemoveRead',NAME='PermissionsRemoveRead',URL__C='',VALUE1__C='Remove: Read',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRemoveWriteModify',NAME='PermissionsRemoveWriteModify',URL__C='',VALUE1__C='Remove: Write-Modify',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTEmailSecExisting',NAME='PermissionsRTEmailSecExisting',URL__C='',VALUE1__C='EmailSecExisting',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTEmailSecNew',NAME='PermissionsRTEmailSecNew',URL__C='',VALUE1__C='EmailSecNew',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTFolderShareExisting',NAME='PermissionsRTFolderShareExisting',URL__C='',VALUE1__C='FolderShareExisting',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTFolderShareNew',NAME='PermissionsRTFolderShareNew',URL__C='',VALUE1__C='FolderShareNew',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTOracleAgile',NAME='PermissionsRTOracleAgile',URL__C='',VALUE1__C='OracleAgile',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTOracleASCP',NAME='PermissionsRTOracleASCP',URL__C='',VALUE1__C='OracleASCP',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTOracleEBS',NAME='PermissionsRTOracleEBS',URL__C='',VALUE1__C='OracleEBS',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTOracleOBIEE',NAME='PermissionsRTOracleOBIEE',URL__C='',VALUE1__C='OracleOBIEE',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTServiceAcctExisting',NAME='PermissionsRTServiceAcctExisting',URL__C='',VALUE1__C='ServiceAcctExisting',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTServiceAcctNew',NAME='PermissionsRTServiceAcctNew',URL__C='',VALUE1__C='ServiceAcctNew',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTSharedMbxExisting',NAME='PermissionsRTSharedMbxExisting',URL__C='',VALUE1__C='SharedMailboxExisting',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsRTSharedMbxNew',NAME='PermissionsRTSharedMbxNew',URL__C='',VALUE1__C='SharedMailboxNew',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsResetPassword',NAME='PermissionsResetPassword',URL__C='',VALUE1__C='Reset Password',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsSendAs',NAME='PermissionsSendAs',URL__C='',VALUE1__C='Send As',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='PermissionsSendOnBehalf',NAME='PermissionsSendOnBehalf',URL__C='',VALUE1__C='Send on Behalf',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductActiveDirectory',NAME='ProductActiveDirectory',URL__C='',VALUE1__C='Active Directory Account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductAgile',NAME='ProductAgile',URL__C='',VALUE1__C='Agile',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductConferencing',NAME='ProductConferencing',URL__C='',VALUE1__C='VTC',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductEmailSecAccess',NAME='ProductEmailSecAccess',URL__C='',VALUE1__C='Security Group',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductEmailSecDistr',NAME='ProductEmailSecDistr',URL__C='',VALUE1__C='Distribution Group',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductFolderShare',NAME='ProductFolderShare',URL__C='',VALUE1__C='Fileshare',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductMobileAgree',NAME='ProductMobileAgree',URL__C='',VALUE1__C='Corporate Email Agreement',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductMobileLoanEtc',NAME='ProductMobileLoanEtc',URL__C='',VALUE1__C='Device Loan, International Plan, or USB Tethering',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductMobileNewUpgrade',NAME='ProductMobileNewUpgrade',URL__C='',VALUE1__C='New/Upgrade Device',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductMobileTransfer',NAME='ProductMobileTransfer',URL__C='',VALUE1__C='Transfer Service from Personal account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductNewHireParent',NAME='ProductNewHireParent',URL__C='',VALUE1__C='Parent Case',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductOracle',NAME='ProductOracle',URL__C='',VALUE1__C='Oracle Account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductOracleAgile',NAME='ProductOracleAgile',URL__C='',VALUE1__C='Agile',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductOracleOBIEE',NAME='ProductOracleOBIEE',URL__C='',VALUE1__C='OBIEE',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductOracleOther',NAME='ProductOracleOther',URL__C='',VALUE1__C='Oracle Responsibility',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductPartPeripheral',NAME='ProductPartPeripheral',URL__C='',VALUE1__C='Computer Accessory (HW)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductPerforce',NAME='ProductPerforce',URL__C='',VALUE1__C='Perforce',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductPermissions',NAME='ProductPermissions',URL__C='',VALUE1__C='Permissions',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductRemoteAccess',NAME='ProductRemoteAccess',URL__C='',VALUE1__C='Permissions',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductServiceAccount',NAME='ProductServiceAccount',URL__C='',VALUE1__C='Fileshare',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSharedMailbox',NAME='ProductSharedMailbox',URL__C='',VALUE1__C='Fileshare',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSharePointCreate',NAME='ProductSharePointCreate',URL__C='',VALUE1__C='Create account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSharePointDisable',NAME='ProductSharePointDisable',URL__C='',VALUE1__C='Disable Account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSharePointModify',NAME='ProductSharePointModify',URL__C='',VALUE1__C='Modify account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSoftware',NAME='ProductSoftware',URL__C='',VALUE1__C='',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSoftwareBamboo',NAME='ProductSoftwareBamboo',URL__C='',VALUE1__C='Bamboo',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSoftwareFisheye',NAME='ProductSoftwareFisheye',URL__C='',VALUE1__C='Fisheye/Crucible',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSoftwareHipChat',NAME='ProductSoftwareHipChat',URL__C='',VALUE1__C='HipChat',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSoftwareJIRA',NAME='ProductSoftwareJIRA',URL__C='',VALUE1__C='JIRA',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSoftwareOther',NAME='ProductSoftwareOther',URL__C='',VALUE1__C='Other',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSoftwareWIKI',NAME='ProductSoftwareWIKI',URL__C='',VALUE1__C='Confluence (Wiki)',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductStorage',NAME='ProductStorage',URL__C='',VALUE1__C='Storage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductSubscribe',NAME='ProductSubscribe',URL__C='',VALUE1__C='Backoffice Domain',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductTelecom',NAME='ProductTelecom',URL__C='',VALUE1__C='NOC Agent Setup',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ProductWIKI',NAME='ProductWIKI',URL__C='',VALUE1__C='Permissions',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='RemoteOptions',NAME='RemoteOptions',URL__C='',VALUE1__C='#Modify Access#Remove Access#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='RequestSelected',NAME='RequestSelected',URL__C='',VALUE1__C='Request',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SelectArticles',NAME='SelectArticles',URL__C='',VALUE1__C='SELECT Id, ArticleType, KnowledgeArticleId, ActiveDate__c, Additional_Info__c, Area__c, End_Date__c, Section__c, Sort_Order__c, NavigationLink__c, Summary, Title,URL__c FROM ITSMS__kav WHERE Language =:articleLanguage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SelectEntitlement',NAME='SelectEntitlement',URL__C='',VALUE1__C='Select Id, Name, AccountId from Entitlement where Name =:entitlementName',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SelectContactsByEmail',NAME='SelectContactsByEmail',URL__C='',VALUE1__C='Select Id, FirstName, LastName, MiddleNameInitial__c, Email, Citizenship__c, NewHireType__c, EmployeeType__c, Company__c, CompanyEmail__c, ManagerUser__c,',VALUE2__C='NewHireStartDate__c, WorkEndDate__c from Contact where Email in :queryList'),
                new ITSMSKeyValueStore__c(Code__c='SelectNewHireEmailChild',NAME='SelectNewHireEmailChild',URL__C='',VALUE1__C='Select Id, CaseNumber, Category__c, ParentId, Subject,',VALUE2__C='CategoryDetails__c from Case where ParentId = :caseIds  order by CaseNumber'),
                new ITSMSKeyValueStore__c(Code__c='SelectNewHireEmailParent1',NAME='SelectNewHireEmailParent1',URL__C='',VALUE1__C='Select Id, CaseNumber, FirstName__c, LastName__c, MiddleNameInitial__c, StartDate__c, NewHireType__c, PhysicalLocation__c, ManagerUser__r.FirstName, ManagerUser__r.LastName, ManagerUser__r.Email,ManagerUser__c,NewHirePriority__c,',VALUE2__C='ManagerUser__r.Delegate__r.FirstName, ManagerUser__r.Delegate__r.LastName, ManagerUser__r.Delegate__r.Email, NewHireContact__r.FirstName, NewHireContact__r.LastName, NewHireContact__r.Email,NewHireContact__c,'),
                new ITSMSKeyValueStore__c(Code__c='SelectNewHireEmailParent2',NAME='SelectNewHireEmailParent2',URL__C='',VALUE1__C='ManagerUser__r.Delegate__c, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Email, CreatedBy.Delegate__r.FirstName, CreatedBy.Delegate__r.LastName,CreatedBy.Delegate__c,',VALUE2__C='CreatedBy.Delegate__r.Email, ClosedDate,AccountId, ContactId from Case where Id = :caseIds'),
                new ITSMSKeyValueStore__c(Code__c='SelectNewHireParent1',NAME='SelectNewHireParent1',URL__C='',VALUE1__C='select Id, AdditionalAgileRolesRequired__c, AdditionalComments__c, AgileAccessLevel__c, AgileModelUser__c, AgileAccessRequired__c,DescriptionRichText__c,NewHirePriority__c,ClosedDate, AccountId,',VALUE2__C='AgileModelUser__r.FirstName, AgileModelUser__r.LastName,  AgentToMirror__r.FirstName, AgentToMirror__r.LastName, BackofficeSystemDetails__c, BackofficeSystemsAccess__c, CaseNumber, Category__c, CategoryDetails__c, ChildCasesCreated__c,'),
                new ITSMSKeyValueStore__c(Code__c='SelectNewHireParent2',NAME='SelectNewHireParent2',URL__C='',VALUE1__C='Citizenship__c, CompanyEmail__c, CompanyName__c, DepartmentName__c, DeskPhone__c, DistributionGroup__c,ContactId,DoYouApproveThisForm__c, EmployeeType__c, ExedeBackOfficeJumpBox__c, FirstName__c, IsPerforceAccessRequired__c,',VALUE2__C='IsRemoteAccessRequired__c, JustificationWIKIURLs__c, LastName__c, ManagerUser__c, MiddleNameInitial__c,  NewHireContact__c,NewHireType__c,NetworkDirectoryAccessLevel__c,NOCAgents__c, AgentToMirror__c, Origin, OfficeCubeNumber__c, OffsiteLocation__c,'),
                new ITSMSKeyValueStore__c(Code__c='SelectNewHireParent3',NAME='SelectNewHireParent3',URL__C='',VALUE1__C='OracleRequired__c, OracleASCPResponsibilities__c, OracleEBSResponsibilities__c, OracleOBIEEResponsibilities__c, OtherHardware__c, OtherPCModelOS__c, PCModel__c, PCModelType__c, PerforceServerFolders__c,PhysicalLocation__c,Software__c,',VALUE2__C='ProgramProjectName__c, RecordTypeId, RequestingForUser__c, Requestor__c, SecurityGroups__c, ServiceDeskProduct__c, ServiceRequestType__c, SharedMailboxes__c, StartDate__c,Status,Type,WIKIRequired__c, WirelessHeadset__c, WorkEndDate__c,CreatedById'),
                new ITSMSKeyValueStore__c(Code__c='SelectPermissions1',NAME='SelectPermissions1',URL__C='',VALUE1__C='Select Id, Name, AgileAccessLevel__c, OracleASCPResponsibilities__c, OracleEBSResponsibilities__c, OracleOBIEEResponsibilities__c, AddMember__c, AddToGroup__c, Case__c, FullAccess__c, ManagingMember__c, POCMember__c, ReadOnly__c, ReadWriteModify__c,',VALUE2__C='RemoveAccess__c, RemoveFromGroup__c, RemoveMember__c, RemoveRead__c, RemoveWriteModify__c, ResetPassword__c, SendAs__c, SendOnBehalf__c, User__c, User__r.FirstName, User__r.LastName'),
                new ITSMSKeyValueStore__c(Code__c='SelectPermissions2',NAME='SelectPermissions2',URL__C='',VALUE1__C='from ITSMSPermissions__c where Case__c = :caseid',VALUE2__C='AND RecordTypeId = :recordType'),
                new ITSMSKeyValueStore__c(Code__c='SelectPermissionsFields',NAME='SelectPermissionsFields',URL__C='',VALUE1__C='Name, AgileAccessLevel__c, OracleASCPResponsibilities__c, OracleEBSResponsibilities__c, OracleOBIEEResponsibilities__c, AddMember__c, AddToGroup__c, Case__c, FullAccess__c,',VALUE2__C='ManagingMember__c, POCMember__c, ReadOnly__c, ReadWriteModify__c, RemoveAccess__c, RemoveFromGroup__c, RemoveMember__c, RemoveRead__c, RemoveWriteModify__c, ResetPassword__c, SendAs__c, SendOnBehalf__c, User__c,'),
                new ITSMSKeyValueStore__c(Code__c='SelectRelatedCases',NAME='SelectRelatedCases',URL__C='',VALUE1__C='Select Id, CaseNumber, Subject, Category, CategoryDetails__c, Status, OwnerId, CreatedBy, Requestor__c, RequestingForUser__c, DescriptionRichText__c, ServiceRequestType__c, Type,',VALUE2__C='SupportCategory__c,ClosedDate from Case where ParentId = :caseIds'),
                new ITSMSKeyValueStore__c(Code__c='SelectRequestor',NAME='SelectRequestor',URL__C='',VALUE1__C='Select Id, FirstName, LastName, ManagerId, Manager.FirstName, Manager.LastName, Email,',VALUE2__C='Delegate__c from User where Id'),
                new ITSMSKeyValueStore__c(Code__c='SelectRequestorContact',NAME='SelectRequestorContact',URL__C='',VALUE1__C='Select Id, FirstName, LastName, AccountId, RecordTypeId, Account.Name, ManagerUser__r.FirstName, ManagerUser__r.LastName, Site__c, Building__c, Office__c,',VALUE2__C='Email, ContactUser__c from Contact where ContactUser__c = :reqUserId'),
                new ITSMSKeyValueStore__c(Code__c='SelectSupport1',NAME='SelectSupport1',URL__C='',VALUE1__C='Select Id, AccessState__c,AccessType__c,AccountType__c,AcceptMobileTerms__c,Accessories__c, ActionTypeSharePoint__c,AdditionalPOCs__c,AccountId,CustomerPriority__c,ClosedDate,',VALUE2__C='AdditionalAgileRolesRequired__c,ApprovingDirector__c,AssetTag__c,Attendees__c,AvailableToOutsideUsers__c,BriefDescription__c,CaseNumber,Category__c,CategoryDetails__c,Clustered__c,Color__c,ContactId,CompanyEmail__c, ComputerNames__c,'),
                new ITSMSKeyValueStore__c(Code__c='SelectSupport2',NAME='SelectSupport2',URL__C='',VALUE1__C='ComputerType__c,ContractEndDate__c,CostCenterNumber__c,CurrentCarrier__c,CurrentPhoneModel__c,ConferenceRoomSetupTime__c,CreatedById, CustomerUse__c, Database__c,Date_Needed_By__c,DefaultReviewers__c,',VALUE2__C='DeptVP__c,DepartmentName__c,DepartureDate__c,Description,DescriptionRichText__c,DesiredWorkflow__c,Destinations__c,DeviceModel__c,DiskName__c,DoYouApproveThisForm__c,EmailAddress__c,EndDateTime__c,Environments__c,'),
                new ITSMSKeyValueStore__c(Code__c='SelectSupport3',NAME='SelectSupport3',URL__C='',VALUE1__C='EquipmentClass__c,EquipmentLocation__c,EventTitle__c, ExpirationDate__c,ExistingMobilePhoneNumber__c,FirstName__c, GroupMembers__c,GroupName__c, HostPasscode__c,ICCID_SIMNumber__c,InstanceName__c,IssueOrRequest__c,IssueType__c,',VALUE2__C='IsThisForGroup__c,JustificationRequest__c,LastName__c,  LinkToSharePointSite__c,ListNetworkDirectory__c,MailboxNeeded__c,ManagerUser__c,MEID_IMEINumber__c,MobileActionType__c,MobileType__c,'),
                new ITSMSKeyValueStore__c(Code__c='SelectSupport4',NAME='SelectSupport4',URL__C='',VALUE1__C='NewCarrierPhoneModel__c,NewHost__c,OperatingSystem__c,Origin,OtherSoftwareProduct__c,ParentId,PartNumber__c,PartQuantity__c,Priority,PartsRequest__c,PCModelType__c,PrivilegesNeeded__c,ProgramProjectName__c,ProjectKey__c,',VALUE2__C='RepoAccountName__c,RequestingOrg__c,Requestor__c,RequestingForUser__c,ReferenceCaseId__c,ResourceType__c, ReturnDate__c,ReviewParticipants__c,ScreenshotsAttached__c,SelectCarrierModel__c,ServerCPU__c,ServerHostName__c,'),
                new ITSMSKeyValueStore__c(Code__c='SelectSupport5',NAME='SelectSupport5',URL__C='',VALUE1__C='ServerMemory__c, ServerProject__c,ServerOperatingSystem__c,ServiceDeskProduct__c, SerialNumber__c,ServiceAccountName__c,ServiceRequestType__c,SharedMailboxName__c,SoftwareName__c,SourceCodePath__c,',VALUE2__C='SourceHostname__c,StartDateTime__c,Status,StorageEnvironment__c,StorageFrequency__c,StorageLocation__c,StorageRequirements__c,StorageRequestType__c,StorageSize__c,StorageSizeType__c,StorageSnapshotClone__c,Subject,'),
                new ITSMSKeyValueStore__c(Code__c='SelectSupport6',NAME='SelectSupport6',URL__C='',VALUE1__C='SupportCategory__c,SupportRequestType__c,TargetHostname__c,Type,UsedFor__c,VTCRoom__c,WebExRequired__c,WebExMeetingNumber__c,WebExInformation__c,WhoOwnsDevice__c,WhoWillHaveAccess__c,WIKIRequired__c,',VALUE2__C='WIKISpaceName__c,WIKISpaceKey__c,WIKISpaceType__c,WorkstationType__c'),
                new ITSMSKeyValueStore__c(Code__c='SelectSupportChildren',NAME='SelectSupportChildren',URL__C='',VALUE1__C='Select Id, ParentId, Subject,',VALUE2__C='Status,ClosedDate from Case where ParentId = :caseIds'),
                new ITSMSKeyValueStore__c(Code__c='SelectUser',NAME='SelectUser',URL__C='',VALUE1__C='Select Id, FirstName, LastName, Delegate__c from User where Id = :userId limit 1',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='',NAME='SelfHelpArticlesPerPage',URL__C='',VALUE1__C='10', VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeActiveDirectory',NAME='ServReqTypeActiveDirectory',URL__C='',VALUE1__C='AD Account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeAddtlSoftware',NAME='ServReqTypeAddtlSoftware',URL__C='',VALUE1__C='Software',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeAgile',NAME='ServReqTypeAgile',URL__C='',VALUE1__C='Agile',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeConferencing',NAME='ServReqTypeConferencing',URL__C='',VALUE1__C='Conferencing',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeContrExt',NAME='ServReqTypeContrExt',URL__C='',VALUE1__C='Contractor Extension',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeDesktop',NAME='ServReqTypeDesktop',URL__C='',VALUE1__C='Desktop',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeEmailSecurity',NAME='ServReqTypeEmailSecurity',URL__C='',VALUE1__C='Email/Security',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeFolderShare',NAME='ServReqTypeFolderShare',URL__C='',VALUE1__C='Folder Share',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeGeneralCase',NAME='ServReqTypeGeneralCase',URL__C='',VALUE1__C='Issue',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeMobileAgree',NAME='ServReqTypeMobileAgree',URL__C='',VALUE1__C='Mobile Agree',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeMobileLoanEtc',NAME='ServReqTypeMobileLoanEtc',URL__C='',VALUE1__C='Mobile Loan',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeMobileNewUpgrade',NAME='ServReqTypeMobileNewUpgrade',URL__C='',VALUE1__C='Mobile New/Upgrade',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeMobileTransfer',NAME='ServReqTypeMobileTransfer',URL__C='',VALUE1__C='Mobile Transfer',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeNewHireParent',NAME='ServReqTypeNewHireParent',URL__C='',VALUE1__C='New Hire Parent',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeOracle',NAME='ServReqTypeOracle',URL__C='',VALUE1__C='Oracle Access',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypePartPeripheral',NAME='ServReqTypePartPeripheral',URL__C='',VALUE1__C='Part/Peripheral',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypePerforce',NAME='ServReqTypePerforce',URL__C='',VALUE1__C='Perforce',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypePermissions',NAME='ServReqTypePermissions',URL__C='',VALUE1__C='Permissions',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeRemoteAccess',NAME='ServReqTypeRemoteAccess',URL__C='',VALUE1__C='Remote Access',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeServer',NAME='ServReqTypeServer',URL__C='',VALUE1__C='Server',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeServiceAccount',NAME='ServReqTypeServiceAccount',URL__C='',VALUE1__C='Service Account',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSharedMailbox',NAME='ServReqTypeSharedMailbox',URL__C='',VALUE1__C='Shared Mailbox',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSharePoint',NAME='ServReqTypeSharePoint',URL__C='',VALUE1__C='SharePoint',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSoftware',NAME='ServReqTypeSoftware',URL__C='',VALUE1__C='Software',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSoftwareFisheye',NAME='ServReqTypeSoftwareFisheye',URL__C='',VALUE1__C='Software Fisheye/Crucible',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSoftwareJIRA',NAME='ServReqTypeSoftwareJIRA',URL__C='',VALUE1__C='Software JIRA',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSoftwareOther',NAME='ServReqTypeSoftwareOther',URL__C='',VALUE1__C='Software Other',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSoftwareWIKI',NAME='ServReqTypeSoftwareWIKI',URL__C='',VALUE1__C='Software WIKI',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeStorage',NAME='ServReqTypeStorage',URL__C='',VALUE1__C='Storage',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSubscribe',NAME='ServReqTypeSubscribe',URL__C='',VALUE1__C='Subscriber/BackOffice',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeSupportParent',NAME='ServReqTypeSupportParent',URL__C='',VALUE1__C='Support Parent',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeTelecom',NAME='ServReqTypeTelecom',URL__C='',VALUE1__C='Telecom',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeWIKI',NAME='ServReqTypeWIKI',URL__C='',VALUE1__C='WIKI Access',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='ServReqTypeWorkstation',NAME='ServReqTypeWorkstation',URL__C='',VALUE1__C='Workstation/Laptop',VALUE2__C='Workstation/Laptop'),
                new ITSMSKeyValueStore__c(Code__c='SoftwareNameGroup1',NAME='SoftwareNameGroup1',URL__C='',VALUE1__C='#Adobe Acrobat#, #Adobe Creative Cloud#,#AutoCAD#,#Autocad#, #Matlab#, #Microsoft Project#, #Microsoft Visio#,#Visio#,#Microsoft Visual Studio Pro#, #Nuance PDF Converter/PowerPDF#, #OmniGraffle Pro#, #SmartBear SoapUI Pro#, #Solidworks#,',VALUE2__C='#Tableau#, #Techsmith SnagIt#,#VMware Fusion#,#VMware Workstation#'),
                new ITSMSKeyValueStore__c(Code__c='SoftwareNameGroup2',NAME='SoftwareNameGroup2',URL__C='',VALUE1__C='#Cisco Jabber #,#Cisco Softphone #,#Concur #,#IBM DOORS #,#Oracle OBIEE #,#ProPricer #,#VMWare vSphere applications #',VALUE2__C='#Tableau#, #Techsmith SnagIt#,#VMware Fusion#,#VMware Workstation#'),
                new ITSMSKeyValueStore__c(Code__c='SoftwareOtherBamboo',NAME='SoftwareOtherBamboo',URL__C='',VALUE1__C='#bamboo#,#Bamboo#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SoftwareOtherFisheye',NAME='SoftwareOtherFisheye',URL__C='',VALUE1__C='#Fisheye#,#Crucible#,#FishEye#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SoftwareOtherHipChat',NAME='SoftwareOtherHipChat',URL__C='',VALUE1__C='#HipChat#,#hipchat#,#Hipchat#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SoftwareOtherJIRA',NAME='SoftwareOtherJIRA',URL__C='',VALUE1__C='#JIRA#,#Jira#,#jira#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SoftwareOtherWIKI',NAME='SoftwareOtherWIKI',URL__C='',VALUE1__C='#confluence#,#WIKI#,#wiki#,#Confluence#,#Wiki#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='StatusADOpen',NAME='StatusADOpen',URL__C='',VALUE1__C='#New#,#In Progress#,#Assigned#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='StatusesToAllowSubmit',NAME='StatusesToAllowSubmit',URL__C='',VALUE1__C='#Pending Submission#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='StatusNewHireSave',NAME='StatusNewHireSave',URL__C='',VALUE1__C='Pending Submission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='StatusNewHireSubmit',NAME='StatusNewHireSubmit',URL__C='',VALUE1__C='Submitted',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='StatusSupportSave',NAME='StatusSupportSave',URL__C='',VALUE1__C='Pending Submission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='StatusSupportSubmit',NAME='StatusSupportSubmit',URL__C='',VALUE1__C='New',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='StatusValuesNewHire',NAME='StatusValuesNewHire',URL__C='',VALUE1__C='AND IsClosed = False',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectAccessIssue',NAME='SubjectAccessIssue',URL__C='',VALUE1__C='Add Access & Permission Issue',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectActiveDirectory',NAME='SubjectActiveDirectory',URL__C='',VALUE1__C='New Hire {0}: {1} {2} {3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectAddtlSoftware',NAME='SubjectAddtlSoftware',URL__C='',VALUE1__C='New Hire: {0}:  {1} {2} Software',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectAgile',NAME='SubjectAgile',URL__C='',VALUE1__C='New Hire: {0}:  {1} {2} Agile',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectConferencing',NAME='SubjectConferencing',URL__C='',VALUE1__C='{0}: {1} {2}: {3}',VALUE2__C='{0}: {1} {2}: Multiple Rooms'),
                new ITSMSKeyValueStore__c(Code__c='SubjectDesktop',NAME='SubjectDesktop',URL__C='',VALUE1__C='New Hire: {0}:  {1} {2}  {3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectEmailSecurity',NAME='SubjectEmailSecurity',URL__C='',VALUE1__C='{0}: {1}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectFeedback',NAME='SubjectFeedback',URL__C='',VALUE1__C='{0} - ITSMS Feedback',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectFolderShare',NAME='SubjectFolderShare',URL__C='',VALUE1__C='{0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectIssue',NAME='SubjectIssue',URL__C='',VALUE1__C='Issue or Problem for {0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectMobileAgree',NAME='SubjectMobileAgree',URL__C='',VALUE1__C='{0}: {1} {2}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectMobileLoanEtc',NAME='SubjectMobileLoanEtc',URL__C='',VALUE1__C='{0}: {1} {2}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectMobileNewUpgrade',NAME='SubjectMobileNewUpgrade',URL__C='',VALUE1__C='{0}: {1} {2}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectMobileTransfer',NAME='SubjectMobileTransfer',URL__C='',VALUE1__C='{0}: {1} {2}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectNewHireParent',NAME='SubjectNewHireParent',URL__C='',VALUE1__C='New Hire {0}: {1} {2} {3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectNewHireSoftware',NAME='SubjectNewHireSoftware',URL__C='',VALUE1__C='New Hire - {0} (1) - (2) Software: {3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectOracle',NAME='SubjectOracle',URL__C='',VALUE1__C='New Hire: {0}:  {1} {2} Oracle',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectOracleAgile',NAME='SubjectOracleAgile',URL__C='',VALUE1__C='{0}: {1}: {2} {3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectOracleNotAgile',NAME='SubjectOracleNotAgile',URL__C='',VALUE1__C='{0}: {1}: {2} {3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectPartPeripheral',NAME='SubjectPartPeripheral',URL__C='',VALUE1__C='{0}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectPerforce',NAME='SubjectPerforce',URL__C='',VALUE1__C='New Hire: {0}:  {1} {2} Software',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectPermissions',NAME='SubjectPermissions',URL__C='',VALUE1__C='New Hire: {0}: {1} {2} Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectRemoteAccess',NAME='SubjectRemoteAccess',URL__C='',VALUE1__C='New Hire: {0}:  {1} {2} Permission VPN',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectServer',NAME='SubjectServer',URL__C='',VALUE1__C='{0}: {1}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectServiceAccount',NAME='SubjectServiceAccount',URL__C='',VALUE1__C='{0}: {1}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSharedMailbox',NAME='SubjectSharedMailbox',URL__C='',VALUE1__C='{0}: {1}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSharePoint',NAME='SubjectSharePoint',URL__C='',VALUE1__C='{0}: {1} {2}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSoftware',NAME='SubjectSoftware',URL__C='',VALUE1__C='{0}: {1} {2}: {3}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSoftwareFisheye',NAME='SubjectSoftwareFisheye',URL__C='',VALUE1__C='New Fisheye/Crucible Repository',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSoftwareJIRA',NAME='SubjectSoftwareJIRA',URL__C='',VALUE1__C='New JIRA Project',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSoftwareOther',NAME='SubjectSoftwareOther',URL__C='',VALUE1__C='Other Software',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSoftwareWIKI',NAME='SubjectSoftwareWIKI',URL__C='',VALUE1__C='New Wiki Space',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectStorage',NAME='SubjectStorage',URL__C='',VALUE1__C='{0} {1}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSubscribe',NAME='SubjectSubscribe',URL__C='',VALUE1__C='New Hire: {0}:  {1} {2} Backoffice',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectSupportParent',NAME='SubjectSupportParent',URL__C='',VALUE1__C='Support Parent',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectTelecom',NAME='SubjectTelecom',URL__C='',VALUE1__C='New Hire: {0}:  {1} {2} NOC Agent',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectWIKI',NAME='SubjectWIKI',URL__C='',VALUE1__C='New Hire: {0} {1} - {2} Permission',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubjectWorkstation',NAME='SubjectWorkstation',URL__C='',VALUE1__C='{0}: {1}',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SubscribeOptions',NAME='SubscribeOptions',URL__C='',VALUE1__C='#Exede/Denver#Other#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategories',NAME='SupportCategories',URL__C='',VALUE1__C='#Access#,#Conferencing#,#Mobility#,#Software#,#Workstation#,#Server#,#General#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategoryAccess',NAME='SupportCategoryAccess',URL__C='',VALUE1__C='Access',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategoryConferencing',NAME='SupportCategoryConferencing',URL__C='',VALUE1__C='Conferencing',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategoryGeneralCase',NAME='SupportCategoryGeneralCase',URL__C='',VALUE1__C='General',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategoryMobility',NAME='SupportCategoryMobility',URL__C='',VALUE1__C='Mobility',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategoryServer',NAME='SupportCategoryServer',URL__C='',VALUE1__C='Server',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategorySingular',NAME='SupportCategorySingular',URL__C='',VALUE1__C='#Conferencing#',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategorySoftware',NAME='SupportCategorySoftware',URL__C='',VALUE1__C='Software',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='SupportCategoryWorkstation',NAME='SupportCategoryWorkstation',URL__C='',VALUE1__C='Workstation',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='TabMyCases',NAME='TabMyCases',URL__C='',VALUE1__C='My_Cases',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='TabMyNewTeam',NAME='TabMyNewTeam',URL__C='',VALUE1__C='My_New_Team_Members',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='TabRequestHelp',NAME='TabRequestHelp',URL__C='',VALUE1__C='Request_Help',VALUE2__C=''),
                new ITSMSKeyValueStore__c(Code__c='WIKIOptions',NAME='WIKIOptions',URL__C='',VALUE1__C='#Modify Access#Remove Access#',VALUE2__C='')
            };
            system.runAs (sysAdmin) {
                insert ITSMSSettings;
            }
        }
        // need to define some case key values
        CaseKeyValueStore__c[] caseKeyValues = [Select Id, Name, Code__c, Value__c from CaseKeyValueStore__c]; 
        if ( caseKeyValues.size() > 0 )
        {
            system.debug('@@ case key values:'+ caseKeyValues);
        } else {
            String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
            User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
            // Initialize Case Key values
            CaseKeyValueStore__c[] caseKeyValueStore = new CaseKeyValueStore__c[]{          
                new CaseKeyValueStore__c(Name='ITSMS_RT_NAME',Code__c='ITSMS_RT_NAME',Value__c='ITSMS - General')
            };
            system.runAs (sysAdmin) {
                insert caseKeyValueStore;
            }
        }
    }
    @isTest public static void createRequestor() {
        // create test user as delegate1 
        String orgId = UserInfo.getOrganizationId();
        String testingProfileId = [Select Id from Profile WHERE Name = 'ViaSat Support Center'].Id;
        String testingRoleId = [Select Id from UserRole WHERE Name = 'ViaSat Support Center'].Id;
        String groupITSMS = [Select Id from Group where DeveloperName = 'ITSMSCommunity'].Id;
        List<GroupMember> groupUsers = new list<GroupMember> ();
     
        User delegate1 = new User(  firstname = 'Delegate1', lastName = 'ForRequestor',
                              email = 'delegate1' + '@test' + orgId + '.org',
                              Username = 'delegate1' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'dele1',
                              UserPermissionsMarketingUser = false,
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert delegate1;
        delegate1 = [Select Id, FirstName, LastName from User where FirstName = 'Delegate1'];
        
        // create test user as delegate2 
        User delegate2 = new User(  firstname = 'Delegate2', lastName = 'ForRequestor',
                              email = 'delegate2' + '@test' + orgId + '.org',
                              Username = 'delegate2' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'dele2',
                              UserPermissionsMarketingUser = false,
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert delegate2;
        // create test user as delegate3 
        User delegate3 = new User(  firstname = 'Delegate3', lastName = 'ForRequestor',
                              email = 'delegate3' + '@test' + orgId + '.org',
                              Username = 'delegate3' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'dele3',
                              UserPermissionsMarketingUser = false,
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert delegate3;
        // create test user to be 'requested for'/'manager' with delegate1 
        User requestedFor = new User(  firstname = 'Requested', lastName = 'ForUser',
                              email = 'requested' + '@test' + orgId + '.org',
                              Username = 'requestedFor' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'rforu',
                              TimeZoneSidKey = 'America/Los_Angeles',
                              UserPermissionsMarketingUser = false,
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              Delegate__c = delegate1.Id,
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert requestedFor;
        // create test user to be 'requestor'/'creator' with manager and delegate2
        User requestor = new User(  firstname = 'Requestor', lastName = 'Creator',
                              email = 'RequestorCreator' + '@test' + orgId + '.org',
                              Username = 'RequestorCreator' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'rcrea',
                              UserPermissionsMarketingUser = false,
                              ManagerId = requestedFor.Id,
                              Delegate__c = delegate2.Id,
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert requestor;
        // create test community user'requestor'/'creator' with manager and delegate2
        User communityUser = new User(  firstname = 'Community', lastName = 'User',
                              email = 'CommunityUser' + '@test' + orgId + '.org',
                              Username = 'CommunityUser' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'cuser',
                              UserPermissionsMarketingUser = false,
                              ManagerId = requestedFor.Id,
                              Delegate__c = delegate3.Id,
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert communityUser;
        // need to run as a system admin user
        String sysadmProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
        User sysAdmin = [Select Id from User where ProfileId = :sysadmProfileId and IsActive = true limit 1];
        System.runAs(sysAdmin){

            // create corresponding contacts - account name must be 'ViaSat' to satisfy sharing rule
            Account testAccount = new Account ( Name='ViaSat testing', BillingStreet = '111 W Main St', BillingCity = 'Nowhere',
                                                  BillingPostalCode='11111', BillingState='CA', ownerId = communityUser.Id);
            insert testAccount;
            list<Contact> userContacts = new list<Contact> ();
            system.debug('@@ users:'+delegate1.Id+' '+delegate2.Id);
            if (delegate1.Id != null)
            {
                Contact delegate1Contact = new Contact (AccountId = testAccount.Id, FirstName='Delegate1', LastName='User', NewHireType__c = 'Employee',
                                           Email = 'testDelegate1@testing.com', ContactUser__c = delegate1.Id, ownerId = communityUser.Id); 
                userContacts.add(delegate1Contact);
            }
            if (delegate2.Id != null)
            {
                Contact delegate2Contact = new Contact (AccountId = testAccount.Id, FirstName='Delegate2', LastName='User', NewHireType__c = 'Employee',
                                           Email = 'testDelegate2@testing.com', ContactUser__c = delegate2.Id, ownerId = communityUser.Id); 
                userContacts.add(delegate2Contact);
            }
            if (delegate3.Id != null)
            {
                Contact delegate3Contact = new Contact (AccountId = testAccount.Id, FirstName='Delegate3', LastName='User', NewHireType__c = 'Employee',
                                           Email = 'testDelegate3@testing.com', ContactUser__c = delegate3.Id, ownerId = communityUser.Id); 
                userContacts.add(delegate3Contact);
            }
            if (requestedFor.Id != null)
            {
                Contact requestedForContact = new Contact (AccountId = testAccount.Id, FirstName='requestedFor', LastName='User', NewHireType__c = 'Employee',
                                           Email = 'testrequestedFor@testing.com', ContactUser__c = requestedFor.Id, ownerId = communityUser.Id); 
                userContacts.add(requestedForContact);
            }
            if (requestor.Id != null)
            {
                Contact requestorContact = new Contact (AccountId = testAccount.Id, FirstName='requestor', LastName='User', NewHireType__c = 'Employee',
                                           Email = 'testrequestor@testing.com', ContactUser__c = requestor.Id, ownerId = communityUser.Id); 
                userContacts.add(requestorContact);
            }
            if (communityUser.Id != null)
            {
                Contact communityUserContact = new Contact (AccountId = testAccount.Id, FirstName='communityUser', LastName='User', NewHireType__c = 'Employee',
                                           Email = 'testcommunityUser@testing.com', ContactUser__c = communityUser.Id, ownerId = communityUser.Id); 
                userContacts.add(communityUserContact);
            }
            if (userContacts.size() > 0)
                insert userContacts;
        }
    }
    @isTest public static void createAdmins() {
        // create test user as admin 
        String orgId = UserInfo.getOrganizationId();
        String testingProfileId = [Select Id from Profile WHERE Name = 'System Administrator'].Id;
        String testingRoleId = [Select Id from UserRole WHERE Name = 'ViaSat Support Center'].Id;
        User admin = new User(  firstname = 'Admin', lastName = 'User',
                              email = 'adminuser' + '@test' + orgId + '.org',
                              Username = 'adminuser' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'auser',
                              UserPermissionsMarketingUser = false,
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert admin;
        User admin2 = new User(  firstname = 'Admin2', lastName = 'User',
                              email = 'admin2user' + '@test' + orgId + '.org',
                              Username = 'admin2user' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = '2user',
                              UserPermissionsMarketingUser = false,
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert admin2;
        
        User knowledgeAdmin = new User(  firstname = 'knowledgeAdmin', lastName = 'User',
                              email = 'kadminuser' + '@test' + orgId + '.org',
                              Username = 'kadminuser' + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = 'kuser', 
                              UserPermissionsMarketingUser = false,
                              UserPermissionsKnowledgeUser = true,         
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = testingProfileId,
                              UserRoleId = testingRoleId);
        insert knowledgeAdmin;             

    }
    
    // This method creates a user with its ContactId field populated
    @isTest public static void createPortalUser() {       
        User userWithRole;        
        if(UserInfo.getUserRoleId() == null) {

            UserRole testRole = new UserRole(name = 'TEST ROLE'); 
            Database.insert(testRole);
            
            userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = testRole.id,
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
        } else {
            userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
        }
        
        System.assert(userWithRole.userRoleId != null, 
                      'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        Contact testContact;
        System.runAs(userWithRole) {
            
            ITSMSTestDataSetup.createTestContact();
            testContact = [SELECT Id, LastName FROM Contact WHERE LastName =:'NewHire'];
        }
        
        Profile testProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1];               
        System.debug('(ITSMSFeedbackCaseControllerTest) Profile queried: ' + testProfile.Name);

        // 11/4 Updating contactId on User and ContactUser__c on contact as not sure at this time which one will be used 
        String testEmail = 'puser@slalom.com'; 
        User testPortalUser = new User(profileId = testProfile.id, username = testEmail, email = testEmail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', firstname = 'Portal', lastname='User', contactId = testContact.id);
            
        insert testPortalUser;
        testContact.ContactUser__c = testPortalUser.Id;
        update testContact;
    }     
    static User UserRecordHelper(String fName, String lName) {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        Profile p = [select Id,name from Profile where Name = 'ViaSat Support Center' limit 1];
             
        User newUser = new User(
            profileId = p.id,
            username = lName + '@yahoo.com',
            email = 'pb@ff.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='nuser',
            lastname= lName,
            firstname = fName
        );
        insert newUser;  
        return newUser;        
    }
    
    public static void SetupDelegateUsers() {
        User Charles = UserRecordHelper('Charles', 'Frank');
        User Olivia = UserRecordHelper('Olivia', 'Waller');
        Olivia.Delegate__c = Charles.Id;
        update Olivia;
    }
    //------------------------------------------------------------------------------------
    // Insert and publish a knowledge article. Should be used only in test methods that require knowledge article record insertion.
    //------------------------------------------------------------------------------------        
    public static void createPublishedArticle(String area, String section){
        ITSMS__kav newArticle = new ITSMS__kav(Title = 'test article', 
                                                Summary = 'test summary', 
                                                URL__c = 'testURL', 
                                                UrlName = 'testURLName', 
                                                Section__c = section, 
                                                Area__c = area,
                                                Language= 'en_US'
                                               );         
        insert newArticle;  
        ITSMS__kav a = [SELECT KnowledgeArticleId FROM ITSMS__kav WHERE Id = :newArticle.Id LIMIT 1];
        KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);           
    }    
    
    //------------------------------------------------------------------------------------
    // Insert and publish a list of knowledge articles. Should be used only in test methods that require knowledge article record insertion.
    // Should only be run by system administrator users to setup test knowledge articles.
    //------------------------------------------------------------------------------------        
    public static void createPublishedArticleList(String area, String section, Integer count){
        LIST<ITSMS__kav> articlesToInsert = new LIST<ITSMS__kav>();
        LIST<Id> articlesToPublishIds = new LIST<Id>();
        for(Integer i = 0; i < count; i++){
            ITSMS__kav newArticle = new ITSMS__kav(Title = 'test article' + i, 
                                                    Summary = 'test summary' + i, 
                                                    URL__c = 'testURL' + i, 
                                                    UrlName = 'testURLName' + i, 
                                                    Section__c = section, 
                                                    Area__c = area,
                                                    Language= 'en_US'
                                                   );         
            articlesToInsert.add(newArticle);
        }
        insert articlesToInsert;
        for(ITSMS__kav ati : [SELECT Id, KnowledgeArticleId FROM ITSMS__kav WHERE PublishStatus =: 'Draft' AND Language =: 'en_US']){
            articlesToPublishIds.add(ati.KnowledgeArticleId);
        }
        
        for(Id articleToPublishId : articlesToPublishIds){
            KbManagement.PublishingService.publishArticle(articleToPublishId, true);               
        }
        
    }    
    
}