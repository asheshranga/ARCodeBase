/**
 * This class contains POST REFRESH STEPS for ANONYMOUS EXECUTION
 */
@isTest
public class ViasatPostRefresh 
{    
    //************************************************************************************************************
    // AFTER REFRESH ANONYMOUS EXECUTE: 
    //************************************************************************************************************

    //********************************************************************************************************
    // Step 1. Disable Scheduled Apex Jobs - Anonymous Execution
    //********************************************************************************************************
    public static void disableScheduledApexJobs()
    {
        List<CronTrigger> abort_job = [SELECT Id FROM CronTrigger];
        for (CronTrigger t : abort_job){ 
            System.abortJob(t.Id); 
        }
    }
    
    //********************************************************************************************************
    // Step 2. Update all queues emails with sfdctestnotify@viasat.com - Anonymous Execution
    //********************************************************************************************************
    public static void updateQueuesEmails()
    {
        list<Group> queues = [Select Id, Email From Group where Email != null];
        for (Group g : queues){
            g.Email = 'sfdctestnotify@viasat.com';
        }
        update queues;
    }

    //********************************************************************************************************
    // Step 3. Create/Update Admin and PM/BA Users in the new QA/TEST & UAT Sandbox
    //********************************************************************************************************
    public static void upsertAdmins()
    {
        // Step 3. Create the following Admin Users in the new QA/TEST & UAT Sandbox
        // NOTE: Kelly, Andy, Jennifer, Luciana exist in PROD
    	list<string> adminUsers = new string[]{'luciana.moreira','kelly.wortel','hanumantha.cholleti','Alexandra.Roud','Jennifer.Perez','Alex.Searcy','fnadminTest.lnadminTest'};
                           
		string sandboxName = ViasatUtilityClass.sandboxName();
        Profile prof = [SELECT Id FROM Profile WHERE Name='IT: System Administrator']; 
        UserRole role = [Select Name, Id From UserRole where name = 'VIASAT, Corporate Sales'];

		for (string user : adminUsers)
		{
			string[] names = user.split('\\.');
        	string userFirstName=names[0];
        	string userLastName=names[1];
        	string aliasName = userFirstName.substring(0,1) + userLastName.substring(0,4);
        	string userEmail = user + '@viasat.com';
        	string userName = userEmail + '.' + sandboxName;
        	system.debug('*** ' + aliasName + ',' + userEmail + ',' + userName);

        	list<User> users = [SELECT Id, ProfileId, UserRoleId, email, UserPermissionsLiveAgentUser, UserPermissionsKnowledgeUser, username FROM User WHERE userName =:userName limit 1];
        	User us = new User();
        	if (users == null || users.size() == 0)
        	{
            	us = new User(Alias = aliasName, Email=userEmail, LastName=userLastName, firstname=userFirstName,ProfileId = prof.Id,UserRoleId=role.Id
            	         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , CommunityNickname=user, UserName=userName);
                insert us;
        	}
        	else
        	{
        		us = users[0];        		
           		us.ProfileId = prof.Id;
           		us.UserRoleId=role.Id;
           		update us;
        	}
        }
    }

    public static void upsertPMBA()
    {
    	list<string> pmbaUsers = new string[]{'lakshmy.manoj','daniela.sigaud','rich.walsh','david.rollingson','jennifer.volkman','fnameTest.lnameTest'};

        string sandboxName = ViasatUtilityClass.sandboxName();
        Profile prof = [SELECT Id FROM Profile WHERE Name='IT: PM/BA']; 
        UserRole role = [Select Name, Id From UserRole where name = 'VIASAT, Corporate Sales'];

		for (string user : pmbaUsers)
		{
			string[] names = user.split('\\.');
        	string userFirstName=names[0];
        	string userLastName=names[1];
        	string aliasName = userFirstName.substring(0,1) + userLastName.substring(0,4);
        	string userEmail = user + '@viasat.com';
        	string userName = userEmail + '.' + sandboxName;
        	system.debug('*** ' + aliasName + ',' + userEmail + ',' + userName);
        	
        	list<User> users = [SELECT Id, ProfileId, UserRoleId, email, username FROM User WHERE userName =:userName limit 1];
        	User us = new User();
        	if (users == null || users.size() == 0)
        	{
            	us = new User(Alias = aliasName, Email=userEmail, LastName=userLastName, firstname=userFirstName,ProfileId = prof.Id,UserRoleId=role.Id
            	         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , CommunityNickname=userFirstName + '.' + userLastName, UserName=userName);
                insert us;
        	}
        	else
        	{
        		us = users[0];        		
           		us.ProfileId = prof.Id;
           		us.UserRoleId=role.Id;
           		update us;
        	}
		}
    }
        
    //********************************************************************************************************
    // Step 4. Deactivate all NON-Admin, NOT-API, NOT-Community users
    //********************************************************************************************************
    public static void deactivateUsers()
    {                       
    	// It has a limit, run till 0 records found
        map<Id, Profile> pMap = new map<Id, Profile>([SELECT Id FROM Profile 
                                                      WHERE Name in ('ViaSat Integration','IT: System Administrator','System Administrator'
                                                      ,'IT: PM/BA', 'IT: PM/BA Restricted','ITSMS Manager'
                                                      ,'Carlsbad NOC','Carlsbad NOC Manager'
                                                      ,'ATLAS Community','WISP Admin Community','WISP Subscriber Community')]); 
        list<User> usrsLst = [SELECT Id, ProfileId, email,username FROM User 
                              WHERE isActive=true and ProfileId not in :pMap.keySet() limit 500];
        for (user u : usrsLst){
            u.isActive = false;
        }
        Database.update(usrsLst, false); // leave Users that are used in Alerts
    }

    
    //********************************************************************************************************
    // Step 5. Deactivate Community/Portal users - UAT ONLY
    //     Note: in a new DEV instance there is no Portal nor Community Users
    //********************************************************************************************************
    public static void deactivatePortalUsers()
    {                       
        list<User> usrsLst = [SELECT Id, isActive, username FROM User 
                              WHERE isActive=true and Profile.Name in ('ATLAS Community','WISP Admin Community','WISP Subscriber Community') limit 1000];
        for (user u : usrsLst){
            u.isActive = false;
        }
        Database.update(usrsLst, false);
    }

    public static void refreshUpdate()
    {
        //********************************************************************************************************
        // Step 3. During Deployment of the Change set with Custom labels & Settings, workflow email alert & outbound messages
        //         may have some crecords missing. usually it is Group, Email Templates... Make sure to insert missing records - Anonymous Execution
        //Select Type, RelatedId, OwnerId, Name, Email, DoesSendEmailToMembers, DoesIncludeBosses, DeveloperName From Group where developername in ('Customer_Engineering','SS_T3_ODM_AL1_LSC')
        /*
        Group grp = new Group(Type='Regular', Name='Engineering Support: Customer Eng',DeveloperName='Customer_Engineering');
        insert grp;
        Group grp1 = new Group(Type='Regular', Name='Carlsbad NOC: SS-T3-ODM-AL1-LSC',DeveloperName='SS_T3_ODM_AL1_LSC');
        insert grp1;
        */
    }
        
    //********************************************************************************************************
    // Step 6. Update all the interface users email address to sfdctestnotify@viasat.com or luciana.moreira@viasat.com
    //********************************************************************************************************
    public static void updateInterfaceUsersEmail()
    {                       
        list<User> usrsLst = [SELECT Id, ProfileId, email,username FROM User  WHERE Profile.Name in ('ViaSat Integration')];
        for (user u : usrsLst) {
            u.Email = 'luciana.moreira@viasat.com';
        }
        update usrsLst;
    }

    //********************************************************************************************************
    // Step 7 Reset Passwords for Admins - Users with the profile with SSO OFF Should have Password Reset
    //********************************************************************************************************
    public static void resetPasswordForAdmins()
    {                       
    	list<string> adminUsers = new string[]{'luciana.moreira','kelly.wortel','hanumantha.cholleti','Alexandra.Roud','Jennifer.Perez','Alex.Searcy'};
    	//list<string> pmbaUsers = new string[]{'lakshmy.manoj','daniela.sigaud','rich.walsh','david.rollingson','jennifer.volkman'};

        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail= true;
        list<User> users = [SELECT Id, ProfileId, email,username, CommunityNickname FROM User WHERE CommunityNickname in :adminUsers and Profile.Name = 'IT: System Administrator'];//rob.condy
        for (user u : users){
            u.Email = u.CommunityNickname + '@viasat.com';
            u.UserPermissionsLiveAgentUser = true; 
            u.UserPermissionsKnowledgeUser = true;
            u.setOptions(dlo);
        }
        update users;
        
		// Owner & User should be ACTIVE
        for (user u : users){
            system.resetPassword(u.ID, true);
        }
        
        system.debug('*** ' + users);
    }
        
    //********************************************************************************************************
    // Step 8. Reset Passwords for Super Users - UAT ONLY
    //********************************************************************************************************
    public static void resetPasswordForSuperUsers()
    {                       
        Database.DMLOptions dlo2 = new Database.DMLOptions();
        dlo2.EmailHeader.triggerUserEmail= true;
        list<User> supers = [SELECT Id, ProfileId, email,username, CommunityNickname 
                            FROM User WHERE  isActive=true and 
                            CommunityNickname in ('Gontran.Reboud','Annette.Ticconi','Stacie.Waterman',
                            'Nancy.Kidder','Christine.Ferguson','Liz.Parker','Jayde.Oakley','Bryan.Herman','Narges.Rahnama',
                            'Sue.Gursky','Melanie.Vrettas','Syed.Umar','Suzanne.Marchi','Renee.Houston-Lang','Matthew.Sherry',
                            'Chris.Kohlback','Bob.Buckley','Leilanie.Ramos','Jose.Padilla','Greg.Steckman')];
        for (user u : supers){
            u.Email = u.CommunityNickname + '@viasat.com';
            u.setOptions(dlo2);
        }
        Database.update(supers, dlo2); // Actual DML operation is performed instead of implicit update
    } 

    //****************************************************************************
    // Step 9 Update General Custom Settings 
    //****************************************************************************
    public static void refreshUpdateCustomSettings() 
    {
        string sandboxName = ViasatUtilityClass.sandboxName().toLowerCase();
        string sandboxType = 'test';
        if (sandboxName.contains('dev'))    sandboxType = 'dev';
        
        //******* KeyValueStore *******
        list<KeyValueStore__c> keyValueStore = [SELECT Id, Name, Application__c, TextValue__c, IntegerValue__c, Description__c, DecimalValue__c, DateValue__c, DateTimeValue__c, BooleanValue__c FROM KeyValueStore__c];
        for (KeyValueStore__c o : keyValueStore)
        {
            if (o.Name.equalsIgnoreCase('ContactUsEmailRecipient')) o.TextValue__c = 'sfdctestnotify@viasat.com';
        }
        update keyValueStore;


		//******* Initialize Globals custom setting *******
        list<Account> viasatAccount = [Select Id from account where name ='ViaSat, Inc.-Corporate Headquarters' limit 1];
        if (viasatAccount==null || viasatAccount.size()==0)
        {
         Account a = new Account(Website='www.viasat.com',Type='End-User',Status__c='Prospect',ShippingStreet='6155 El camina Real', ShippingState='CA', ShippingPostalCode='92009', ShippingCountry='Unites States', ShippingCity='Carlsbad'
         //, RecordTypeId, OwnerId, 
         , Rating='Hot',Phone='(760) 476-2200', Labor_Hours_Required__c='Yes', Industry='Government',Fax='(760) 476-2222',Exede_Enterprise_Tracking__c=true,Description='Government Customer'
         , Country__c='Unites States', Classification__c='Commercial', Business_Area__c='SNS', Branch_Division__c='Inside Sales'
         , BillingStreet='6155 El camina Real', BillingState='CA', BillingPostalCode='92009', BillingCountry='Unites States', BillingCity='Carlsbad',name ='ViaSat, Inc.-Corporate Headquarters');
         insert a;
         
         Contact c = new Contact(firstname='Test', lastname='ViaSatContact', AccountId=a.id, email='Test.ViaSatContact@viasat.com');
         insert c;
         viasatAccount = [Select Id from account where name ='ViaSat, Inc.-Corporate Headquarters' limit 1];
        }
        list<Contact> viasatContact = [Select Id from contact where account.name ='ViaSat, Inc.-Corporate Headquarters' limit 1];
        
        list<Globals__c> globalCustomSettings = [Select id, caseContactAccountEnforcement__c,caseContactAccountEnforcementExceptions__c, ViaSatCaseContact__c
        	                                          , ViaSatAccount__c, ViaSatLogLastNDays__c, InternalNotificationEmail__c
                                                 from Globals__c limit 1];
        globalCustomSettings[0].caseContactAccountEnforcement__c=true; 
        globalCustomSettings[0].caseContactAccountEnforcementExceptions__c='Carlsbad NOC,Carlsbad NOC Customer Portal'; 
        globalCustomSettings[0].ViaSatCaseContact__c=viasatContact[0].id; 
        globalCustomSettings[0].ViaSatAccount__c=viasatAccount[0].id;
        globalCustomSettings[0].ViaSatLogLastNDays__c=60.00;
        globalCustomSettings[0].InternalNotificationEmail__c='sfdctestnotify@viasat.com';
        upsert globalCustomSettings[0];


		//******* Initialize CaseKeyValueStore__c custom setting 
        list<CaseKeyValueStore__c> caseCustomSettings = [SELECT Id, Name, Value__c FROM CaseKeyValueStore__c];
        for (CaseKeyValueStore__c o : caseCustomSettings)
        {
            if (o.Name.equalsIgnoreCase('CarlsbadNOCRecordTypes') && o.Value__c == null) o.Value__c='Carlsbad NOC,Carlsbad NOC Customer Portal';
            if (o.Name.equalsIgnoreCase('Profile:ViaSat NOC Customer Portal') && o.Value__c == null) o.Value__c='/apex/viasite';
//(name='FieldID:Site', Value__c='')
        }
        upsert caseCustomSettings;


		//******* Initialize NBNCoKeyvalueStore custom setting 
        list<NBNCoKeyvalueStore__c> nbnCoCustomSettings = [SELECT id, name, Value__c FROM NBNCoKeyvalueStore__c];           
        for (NBNCoKeyvalueStore__c o : nbnCoCustomSettings)
        {
            if (o.Name.equalsIgnoreCase('NBN_SubSystem') && o.Value__c == null) o.Value__c='\'DPC (Data Processing Center)\',\'GW (Gateway)\',\'GSTB\'';
            if (o.Name.equalsIgnoreCase('NBN_AccountName') && o.Value__c == null) o.Value__c='NBN Co.';
            if (o.Name.equalsIgnoreCase('NBNSupportServices') && o.Value__c == null) o.Value__c='Support Services NBN Co';
            if (o.Name.equalsIgnoreCase('NBNCo') && o.Value__c == null) o.Value__c='NBN';
            if (o.Name.equalsIgnoreCase('NBNCoDispatchMailId') && o.Value__c == null) o.Value__c='test@viasat.com';
            if (o.Name.equalsIgnoreCase('ViaSat TEST Dispatch Method') && o.Value__c == null) o.Value__c='ViaSat TEST Dispatch Method description';
            if (o.Name.equalsIgnoreCase('NotSLAReportableReason') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBN_Other') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('OtherReason') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NotEvaluated') && o.Value__c == null) o.Value__c='..';
            if (o.Name.equalsIgnoreCase('NBN_AdvanceReplacementRMA') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBNViaSatTeam') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBNSFcase') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBNRequestRMA') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('Updateshavebeenmadeinthe') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('RequestforanAdvanceReplacement') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBNRequestforRMA') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBNAdvanceReplacementRMA') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBNforSalesForce') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBNNotDefined') && o.Value__c == null) o.Value__c='...';
            if (o.Name.equalsIgnoreCase('NBN_RmaSaved') && o.Value__c == null) o.Value__c='...'; 
        }
        upsert nbnCoCustomSettings;
    }

    //****************************************************************************
    // Step 9.a Update Custom Settings for ATLAS
    //****************************************************************************
    public static void setCustomSettingsAtlas() 
    {
        string sandboxName = ViasatUtilityClass.sandboxName().toLowerCase();
        string sandboxType = 'test';
        if (sandboxName.contains('dev'))    sandboxType = 'dev';
        
if (sandboxName != 'prod')
{
		list<AtlasKeyValueStore__c> atlasKeyValues = [SELECT Id, Name, Code__c, Value__c FROM AtlasKeyValueStore__c];
        for (AtlasKeyValueStore__c o : atlasKeyValues)
        {
            if (sandboxName != 'uat')
            {
                if (o.Name.equalsIgnoreCase('AtlasAPIPassword'))    o.Value__c = 'Atlas2014';
                //if (o.Name.equalsIgnoreCase('AtlasAPIPassword(PROD)'))  o.Value__c = 'Atlas2014';
            }
            if (o.Name.equalsIgnoreCase('New_User_Email_Domain'))   o.Value__c = '@atlasTest.com';
            //if (o.Name.equalsIgnoreCase('AtlasSSOAPIPassword(Prod)'))   o.Value__c = 'sfr0user!';
        }
        update atlasKeyValues;
        
        list<AtlasSSOWebServiceEndPoints__c> atlasSSOKeyValues = [SELECT Id, Name, Host__c FROM AtlasSSOWebServiceEndPoints__c];
        for (AtlasSSOWebServiceEndPoints__c o : atlasSSOKeyValues)
        {
            if (o.Name.equalsIgnoreCase('1'))   o.Host__c = 'https://mysso.test.exede.net/sso';
            if (o.Name.equalsIgnoreCase('2'))   o.Host__c = 'https://mysso.test.exede.net/sso';
            if (o.Name.equalsIgnoreCase('3'))   o.Host__c = 'https://mysso.test.exede.net/sso';
            if (o.Name.equalsIgnoreCase('4'))   o.Host__c = 'https://mysso.test.exede.net/sso';
            if (o.Name.equalsIgnoreCase('5'))   o.Host__c = 'https://mysso.test.exede.net/sso';
        }
        update atlasSSOKeyValues;

        list<AtlasWebServiceEndPoints__c> atlasWebKeyValues = [SELECT Id, Name, Host__c FROM AtlasWebServiceEndPoints__c];
        for (AtlasWebServiceEndPoints__c o : atlasWebKeyValues)
        {
            if (o.Name.equalsIgnoreCase('1'))   o.Host__c = 'https://webservices.test.wildblue.net';
            if (o.Name.equalsIgnoreCase('2'))   o.Host__c = 'https://webservices.test.wildblue.net';
            if (o.Name.equalsIgnoreCase('3'))   o.Host__c = 'https://webservices.test.wildblue.net';
            if (o.Name.equalsIgnoreCase('4'))   o.Host__c = 'https://webservices.test.wildblue.net';
            if (o.Name.equalsIgnoreCase('5'))   o.Host__c = 'https://webservices.test.wildblue.net';
        }
        update atlasWebKeyValues;
}
    }

    //****************************************************************************
    // Step 9.b Update Custom Settings for SNG
    //****************************************************************************
    public static void setCustomSettingsSNG() 
    {
        string sandboxName = ViasatUtilityClass.sandboxName().toLowerCase();
        string sandboxType = 'test';
        if (sandboxName.contains('dev'))    sandboxType = 'dev';
        
        //******* SNG *******
if (sandboxName != 'prod' && sandboxName != 'uat') {
        list<SNGWebService__c> sngKeyValues = [SELECT Id, Name, Authsetcookieheader__c, PASSWORD__C, Username__c, URL__C, AuthCookieCache__c FROM SNGWebService__c];
        for (SNGWebService__c o : sngKeyValues)
        {
            if (o.Name.equalsIgnoreCase('SNG OpenAM Login')){
                o.URL__c = 'https://sso.' + sandboxType + '.exede.net/federation/UI/Login';
                o.PASSWORD__C = 'vg3NecHN3w71';
                o.Username__c = 'eecp';
            }
            if (o.Name.equalsIgnoreCase('SNG OpenAm Login Prod')){
                o.URL__c = 'https://sso.' + sandboxType + '.exede.net/federation';
                o.PASSWORD__C = 'vg3NecHN3w71';
                o.Username__c = 'eecp';
                o.AuthCookieCache__c = '';
            }
            if (o.Name.equalsIgnoreCase('SNG Tomcat Server Prod')){
                o.URL__c = 'https://sngapp.' + sandboxType + '.exede.net';
                o.PASSWORD__C = '';
                o.Username__c = '';
            }                           
        }
        update sngKeyValues;
}
        //----------------------------------------------
        // update SNGKeyValueStore
        //----------------------------------------------
        // value when data is considered stale from current time.
        if (0 == [SELECT COUNT() FROM SNGKeyValueStore__c WHERE Name = :Label.SNGPmdrValidThresholdMinutes])
        {
            SNGKeyValueStore__c staleValueInMinutes = new SNGKeyValueStore__c();
            staleValueInMinutes.name = Label.SNGPmdrValidThresholdMinutes;
            staleValueInMinutes.Code__c = staleValueInMinutes.name;
            staleValueInMinutes.Value__c = String.valueOf(30);
            insert stalevalueInMinutes; 
        }

        // http callout timeout for PMDR service
        if (0 == [SELECT COUNT() FROM SNGKeyValueStore__c WHERE Name = :Label.SNGPmdrHttpCalloutTimeoutSec])
        {
            SNGKeyValueStore__c pmdrHttpCalloutTimeout = new SNGKeyValueStore__c();
            pmdrHttpCalloutTimeout.name = Label.SNGPmdrHttpCalloutTimeoutSec;
            pmdrHttpCalloutTimeout.Code__c = pmdrHttpCalloutTimeout.name;
            pmdrHttpCalloutTimeout.Value__c = String.valueOf(30);
            insert pmdrHttpCalloutTimeout; 
        }

        // http callout timeout for Usage Service.
        if (0 == [SELECT COUNT() FROM SNGKeyValueStore__c WHERE Name = :Label.SNGUsageServiceHttpCalloutTimeoutSec])
        {
            SNGKeyValueStore__c usageServiceHttpCalloutTimeout = new SNGKeyValueStore__c();
            usageServiceHttpCalloutTimeout.name = Label.SNGUsageServiceHttpCalloutTimeoutSec;
            usageServiceHttpCalloutTimeout.Code__c = usageServiceHttpCalloutTimeout.name;
            usageServiceHttpCalloutTimeout.Value__c = String.valueOf(30);
            insert usageServiceHttpCalloutTimeout;            
        }


        //----------------------------------------------
        // update SNGErrorEmailNotification - Hierarchy
        //----------------------------------------------
        SNGErrorEmailNotification__c errEmailNotification = SNGErrorEmailNotification__c.getOrgDefaults();

        if (null == errEmailNotification.Emails__c)
        {
            errEmailNotification.Emails__c = 'rob.condy@viasat.com, young.lee@viasat.com, martin.brown@viasat.com, ryan.tom@viasat.com';
            insert errEmailNotification;
        }

        //-------------------------------------------------
        // update SNGForwardLinkSinrThresholds - Hierarchy
        //-------------------------------------------------
        SNGForwardLinkSinrThresholds__c forwardLinkSinrThresholds = SNGForwardLinkSinrThresholds__c.getOrgDefaults();
        if (null == forwardLinkSinrThresholds.BadMaximum__c || null == forwardLinkSinrThresholds.GoodMinimum__c)
        {
            forwardLinkSinrThresholds.BadMaximum__c = 5.00;
            forwardLinkSinrThresholds.GoodMinimum__c = 7.00;
            insert forwardLinkSinrThresholds;
        }


        //-------------------------------------------------
        // update SNGReturnLinkSymbolRateThresholds - Hierarchy
        //-------------------------------------------------
        SNGReturnLinkSymbolRateThresholds__c returnLinkSymRateThresholds = SNGReturnLinkSymbolRateThresholds__c.getOrgDefaults();
        if (null == returnLinkSymRateThresholds.BadMaximum__c || null == returnLinkSymRateThresholds.GoodMinimum__c)
        {
            returnLinkSymRateThresholds.BadMaximum__c = 1250.00;
            returnLinkSymRateThresholds.GoodMinimum__c = 5000.00;
            insert returnLinkSymRateThresholds;
        }

        //------------------------------------------------------
        // update SNGAdminProfile - List
        //------------------------------------------------------  
        if (0 == [SELECT COUNT() FROM SNGAdminProfile__c])
        {
            List<String> adminProfileNames = new List<String>{ 
                                                               'System Administrator',
                                                               'SNG ViaSat Operations User',
                                                               'Standard/Operations User (Product Sales) + SNG',
                                                               'IT: PM/BA',
                                                               'Standard/Operations User (Product Sales) + SNG Read Only',
                                                               'Standard/Operations User (Bus Dev & Product Sales) + SNG',
                                                               'IT: System Administrator'
                                                             };
            List<Profile> adminProfiles = [SELECT Id FROM Profile WHERE Name IN :adminProfileNames];
            
            List<String> adminProfileIds = new List<String>();
            for (Profile p : adminProfiles)
            {
                adminProfileIds.add(p.Id);
            }
            
            SNGAdminProfile__c adminProfile = new SNGAdminProfile__c();
            adminProfile.Name = 'SystemAdmin';
            adminProfile.ProfileName__c = 'System Administrator';
            adminProfile.ProfileId__c = String.join(adminProfileIds, ',');
            insert adminProfile;
        }

        //------------------------------------------------------
        // update SNGEnvVars__c - List
        //------------------------------------------------------
        final Integer defaultSalesOrderNumericLength = (Integer) SNGEnvVars__c.SalesOrderNumericLength__c.getDescribe().getDefaultValue();
        SNGEnvVars__c envVars = null != SNGEnvVars__c.getOrgDefaults() 
            ? SNGEnvVars__c.getOrgDefaults() 
            : new SNGEnvVars__c(SalesOrderNumericLength__c = defaultSalesOrderNumericLength);
        upsert envVars;
    }
        

    // NEEDED FOR TESTING
    // Note that in DEV env portal Users are not carried over.
    public static void refreshCreatePortalUsers()
    {
        // Step 8. Create Portal Users 
        string sandboxName = ViasatUtilityClass.sandboxName();

        //******* Exede Customer Portal *******
        Account a = [select id from Account where name = 'Red Cross' or name = 'American Red Cross' limit 1]; //'ViaSat, Inc.-Corporate Headquarters'       
        //Contact c = new Contact(CurrencyIsoCode = 'USD', LastName = 'Test',FirstName = 'PortalExede'
        //                , Accountid = a.id, Email = 'rob.condy@viasat.com');
        //insert c;
        Contact c = [SELECT id, LastName,FirstName,Accountid, Email FROM Contact WHERE Accountid = :a.id LIMIT 1];

		UserRole role = [Select Name, Id From UserRole where name = 'ViaSat, Inc.-Corporate Headquarters Customer User' Limit 1];
		
        Profile profPortal = [SELECT Id FROM Profile WHERE Name='SNG Customer User'];
        User existingUser = new User();
        User u = new User();
        if (profPortal != null && profPortal.Id != null && c != null && c.id != null)
        {
        	//existingUser = [SELECT id, UserRoleId, UserRole.name FROM User WHERE ProfileId = :profPortal.Id limit 1];
        	u = new User( Alias = 'sngUser', Email='rob.condy@viasat.com', LastName='Portal', firstname='Exede'
                         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , ProfileId = profPortal.Id, contactId = c.id, UserRoleId=role.Id
                         , CommunityNickname='Exede.Portal', UserName='Exede.Portal@viasat.com.'+sandboxName);
        //u.ExternalAccountReference__c = '11111111'
        //u.FederationIdentifier = 'Fed-Id-111'
        //u.Account_Number__c = 'Test Account 1111'
        	insert u;        
        }

        //******* Carslsbad NOC Customer Portal *******
        // PROFILE: ViaSat NOC Customer Portal
        a = [select id from Account where name = 'KVH Industries' limit 1]; //'ViaSat, Inc.-Corporate Headquarters'         
        //c = new Contact(CurrencyIsoCode = 'USD', LastName = 'KVHTest',FirstName = 'PortalCarlsbadNoc', Accountid = a.id, Email = 'luciana.moreira@viasat.com');
        //insert c;
        c = [SELECT id, LastName,FirstName,Accountid, Email FROM Contact WHERE Accountid = :a.id LIMIT 1];

        profPortal = [SELECT Id FROM Profile WHERE Name='ViaSat NOC Customer Portal']; 
        if (profPortal != null && profPortal.Id != null && c != null && c.id != null)
        {
        	//existingUser = [SELECT id, UserRoleId, UserRole.name FROM User WHERE ProfileId = :profPortal.Id limit 1];
        	u = new User( Alias = 'sngUser', Email='luciana.moreira@viasat.com', LastName='Portal', firstname='CarlsbadNoc'
                         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , ProfileId = profPortal.Id, contactId = c.id, UserRoleId=role.Id
                         , CommunityNickname='CarlsbadNoc.Portal', UserName='CarlsbadNoc.Portal@viasat.com.'+sandboxName);
        	insert u;        
        }
        
        /* PROFILE: ViaSat RMA Customer Portal
        a = [select id from Account where name = 'ViaSat, Inc.-Corporate Headquarters' limit 1]; //'ViaSat, Inc.-Corporate Headquarters'        
        c = new Contact(CurrencyIsoCode = 'USD'
                        , LastName = 'Test',FirstName = 'PortalRMA'
                        , Accountid = a.id
                        , Email = 'lakshmy.manoj@viasat.com');
        insert c;

        profPortal = [SELECT Id FROM Profile WHERE Name='ViaSat RMA Customer Portal']; 
        existingUser = [SELECT id, UserRoleId, UserRole.name FROM User WHERE ProfileId = :profPortal.Id limit 1];
        u = new User( Alias = 'sngUser', Email='lakshmy.manoj@viasat.com', LastName='Portal', firstname='RMA'
                         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , ProfileId = profPortal.Id, contactId = c.id, UserRoleId=existingUser.UserRoleId //role.Id
                         , CommunityNickname='RMA.Portal', UserName='RMA.Portal@viasat.com.'+sandboxName);
        insert u; */       

        // PROFILE: License and Certificate Requests
        a = [select id from Account where name = 'Account with Active License Entitlement' limit 1]; //'ViaSat, Inc.-Corporate Headquarters'        
        //c = new Contact(CurrencyIsoCode = 'USD', LastName = 'Test', FirstName = 'LicenseCertificateRequests', Accountid = a.id, Email = 'lakshmy.manoj@viasat.com');
        //insert c;
        c = [SELECT id, LastName,FirstName,Accountid, Email FROM Contact WHERE Accountid = :a.id LIMIT 1];

        profPortal = [SELECT Id FROM Profile WHERE Name='License and Certificate Requests']; 
        //existingUser = [SELECT id, UserRoleId, UserRole.name FROM User WHERE ProfileId = :profPortal.Id limit 1];
        u = new User( Alias = 'sngUser', Email='lakshmy.manoj@viasat.com', LastName='Portal', firstname='CarlsbadNoc'
                         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , ProfileId = profPortal.Id, contactId = c.id, UserRoleId=role.Id
                         , CommunityNickname='LicCertReq.Portal', UserName='LicCertReq.Portal@viasat.com.'+sandboxName);
        insert u;        
        
        /* PROFILE: ViaSat NOC Customer Portal - Content Only
        a = [select id from Account where name = 'ViaSat, Inc.-Corporate Headquarters' limit 1]; //'ViaSat, Inc.-Corporate Headquarters'        
        c = new Contact(CurrencyIsoCode = 'USD'
                        , LastName = 'Test', FirstName = 'NOCCustomerPortalContent'
                        , Accountid = a.id
                        , Email = 'lakshmy.manoj@viasat.com');
        insert c;

        profPortal = [SELECT Id FROM Profile WHERE Name='ViaSat NOC Customer Portal - Content Only']; 
        existingUser = [SELECT id, UserRoleId, UserRole.name FROM User WHERE ProfileId = :profPortal.Id limit 1];
        u = new User( Alias = 'sngUser', Email='lakshmy.manoj@viasat.com', LastName='Portal', firstname='CarlsbadNoc'
                         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , ProfileId = profPortal.Id, contactId = c.id, UserRoleId=existingUser.UserRoleId //role.Id
                         , CommunityNickname='NOCCustomerPortalContent.Portal', UserName='NOCCustomerPortalContent.Portal@viasat.com.'+sandboxName);
        insert u;*/        


        //******* NBN Co Customer Portal *******
        a = [select id from Account where name = 'NBN Co.' limit 1];
        //c = new Contact(CurrencyIsoCode = 'USD' , LastName = 'Test',FirstName = 'PortalNBNCo' , Accountid = a.id, Email = 'lakshmy.manoj@viasat.com');
        //insert c;
        c = [SELECT id, LastName,FirstName,Accountid, Email FROM Contact WHERE Accountid = :a.id LIMIT 1];

        profPortal = [SELECT Id FROM Profile WHERE Name='NBN Co Customer Portal']; 
        //existingUser = [SELECT id, UserRoleId, UserRole.name FROM User WHERE ProfileId = :profPortal.Id limit 1];
        //UserRole role = [Select Name, Id From UserRole where name = 'VIASAT, Corporate Sales'];
        u = new User( Alias = 'sngUser', Email='lakshmy.manoj@viasat.com', LastName='Portal', firstname='NBNCo'
                         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , ProfileId = profPortal.Id, contactId = c.id, UserRoleId=role.Id
                         , CommunityNickname='NBNCo.Portal', UserName='NBNCo.Portal@viasat.com.'+sandboxName);
        insert u;        


        //******* Order Customer Portal *******
        a = [select id from Account where name = 'Skylogic S.p.A.' limit 1];
        //c = new Contact(CurrencyIsoCode = 'USD', LastName = 'Test',FirstName = 'PortalOrder' , Accountid = a.id, Email = 'lakshmy.manoj@viasat.com');
        //insert c;
        c = [SELECT id, LastName,FirstName,Accountid, Email FROM Contact WHERE Accountid = :a.id LIMIT 1];

        profPortal = [SELECT Id FROM Profile WHERE Name='Order Customer Portal Users']; 
        //existingUser = [SELECT id, UserRoleId, UserRole.name FROM User WHERE ProfileId = :profPortal.Id limit 1];
        //UserRole role = [Select Name, Id From UserRole where name = 'VIASAT, Corporate Sales'];
        u = new User( Alias = 'sngUser', Email='lakshmy.manoj@viasat.com', LastName='Portal', firstname='Order'
                         , LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'
                         , ProfileId = profPortal.Id, contactId = c.id, UserRoleId=role.Id
                         , CommunityNickname='Order.Portal', UserName='Order.Portal@viasat.com.'+sandboxName);
        insert u;        
    }
           
    
    //****************************************************************************
    // AFTER REFRESH ANONYMOUS EXECUTE: INSERT SNG OBJECTS 
    //****************************************************************************
    public static void refreshInsertSNGObjects(Integer numberOfObjs) 
    {
        Integer numOfObjs=10; 

/*  These products should be already in the system: 

        // *** Step 1. Create 20 Products (10  servicePlanTypes & 10 terminalTypes)
        //List<Product2> products = ViasatTestUtility.createProducts(10, 'Exede', SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME, 'terminalType', true);
        //List<Product2> products2 = ViasatTestUtility.createProducts(10, 'Exede', SNG_ServicePlan.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME, 'servicePlanType', true);
        string family='Exede'; 
        String recordTypeName = SNG_ServicePlan.SERVICE_PLAN_TYPE_RECORD_TYPE_NAME;//SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME;
        String namePrefix = 'servicePlanType';//terminalType'; 

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Product2;
        Map<String,Schema.RecordTypeInfo> ProductRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        List<Product2> objList = new List<Product2>();
        for (Integer i=0; i < numOfObjs; i++)
        {
            Product2 o = new Product2(Name=namePrefix + (i==0 ? '' : string.ValueOf(i))
                        , RecordTypeId=ProductRecordTypeInfo.get(recordTypeName).getRecordTypeId()
                        , CurrencyIsoCode = 'USD'
                        , IsActive = true
                        , Business_Area__c = 'TSN'
                        , Family = family
                        );
            objList.add(o);
        }
        insert objList;

        recordTypeName = SNG_Terminal.TERMINAL_TYPE_RECORD_TYPE_NAME;
        namePrefix = 'terminalType'; 
        
        objList = new List<Product2>();
        for (Integer i=0; i < numOfObjs; i++)
        {
            Product2 o = new Product2(Name=namePrefix + (i==0 ? '' : string.ValueOf(i))
                        , RecordTypeId=ProductRecordTypeInfo.get(recordTypeName).getRecordTypeId()
                        , CurrencyIsoCode = 'USD'
                        , IsActive = true
                        , Business_Area__c = 'TSN'
                        , Family = family
                        );
            objList.add(o);
        }
        insert objList;
*/

        // *** Step 2. Create 10 Accounts
/*  These Accounts should be already in the system:
Select name, a.Exede_Enterprise_Tracking__c, Labor_Hours_Required__c, ShippingStreet, Status__c, Type, Industry, Country__c, BillingStreet, BillingCity, BillingState 
From Account a 
where Exede_Enterprise_Tracking__c = true and 
name in ('Stellar Energy','Satcom Resources','Datacom','AvL TECHNOLOGIES','ViaSat, 'Inc.-Corporate Headquarters','American Red Cross', 'ViaSat, Inc.- Exede Enterprise')
*/

        // *** Step 3a. Create 10 servicePlans: 1 for each Accounts
        list<Product2> products = [SELECT Id, Name, RecordTypeId, CurrencyIsoCode, IsActive, Business_Area__c, Family FROM Product2 
                                   WHERE Family = 'Exede' and RecordType.Name = 'Service Plan Types' and isActive = true];
        list<Account> accountList = [SELECT Id, Name FROM Account WHERE Name in ('Stellar Energy','Datacom','Satcom Resources','AvL TECHNOLOGIES','American Red Cross')];
        
        list<ServicePlan__c> servicePlans = new list<ServicePlan__c>();

        final Date TODAY = System.today();
        integer i = 1;
        for (Account a : accountList) 
        {
            ServicePlan__c servicePlan = new ServicePlan__c();
            servicePlan.Account__r = a;
            servicePlan.Account__c = a.Id;
            servicePlan.ServicePlanType__c = products[i].Id;
            servicePlan.ServicePlanType__r = products[i];
            servicePlan.StartDate__c = TODAY;
            servicePlan.EndDate__c = TODAY.addYears(1000);
            servicePlan.SalesOrder__c = 'servicePlan' + i++;
            servicePlans.add(servicePlan);
        }       
        insert servicePlans;

    
        // *** Step 4. Create 20 Terminal: 2 for each Accounts
        list<Product2> terminalTypes = [SELECT Id, Name, RecordTypeId, CurrencyIsoCode, IsActive, Business_Area__c, Family FROM Product2 
                                   WHERE Family = 'Exede' and RecordType.Name = 'Terminal Types' and isActive = true];
         list<Account> accountList2 = [SELECT Id, Name FROM Account WHERE Name in ('Stellar Energy','Datacom','Satcom Resources','AvL TECHNOLOGIES','American Red Cross')];
        integer numOfObjsPerAccounts = 2;
        string termPrefix = 'TestTerminal'; 
        integer j = 0;
        Product2[] termTypes = terminalTypes;

        list<Terminal__c> newobjs = new list<Terminal__c>();
        for (Account a : accountList2)
        {
        string uniqueNumber = 'Test' + j++;

        for (Integer ii=0; ii < numOfObjsPerAccounts; ii++)
        {
            Terminal__c newo = new Terminal__c();
            //newo.IsActive = true;
            newo.Account__c = a.Id;
            newo.SerialNumber__c = 'SN' + string.valueOf(ii) + uniqueNumber;
            newo.TrackingNumber__c = 'TN' + string.valueOf(ii) + uniqueNumber;
            newo.SalesOrder__c = string.valueOf(ii) + uniqueNumber;
            newo.Nickname__c = (ii==0 && termPrefix!='' ? termPrefix : termPrefix + string.valueOf(ii) + uniqueNumber);
            
            if (termTypes.size() > 0)
            {
                Product2 termType = termTypes[0];
                if (termTypes.size() > 1)
                    termType = termTypes[ii];
                
                newo.TerminalType__r = termType;
                newo.TerminalType__c = termType.Id;
            }
            newo.Account__r = a;
            newo.ShipDate__c= DateTime.now().date();
            
            newobjs.add(newo);      
        }
        }
        insert newobjs;     


        // *** Step 5. Create Modems: 2 for each Accounts
       map<Id,Account> accountList3 = new map<Id,Account>([SELECT Id, Name FROM Account WHERE Name in ('Stellar Energy','Datacom','Satcom Resources','AvL TECHNOLOGIES','American Red Cross')]);
        string serialNumberPrefix = 'SN'; 
        integer k = 0;
        string ipPrefix = '00:a0:bc:';

        list<Modem__c> newModems = new list<Modem__c>();
        for (Account a : accountList3.values())
        {
            string uniqueNum = string.valueOf(k);
            list<Terminal__c> terminalList = [SELECT Id, Account__c FROM Terminal__c WHERE Account__c = :a.id];
        Terminal__c[] terminals = terminalList;
        for (Integer l=0; l < terminalList.size(); l++)
        {           
            Modem__c newo = new Modem__c();
            newo.Account__c = a.Id;
            newo.Account__r = a;

            String numInHex = NumberUtils.toHexString(k++);
            //if (6 >= numInHex.length()) {
            while (6 > numInHex.length()) {
                numInHex = String.valueOf(0) + numInHex;
            }
            string ipAddress = ipPrefix + numInHex.substring(0, 2) + ':' + numInHex.substring(2, 4) + ':' + numInHex.substring(4);
 
            newo.SerialNumber__c = serialNumberPrefix + uniqueNum + string.valueOf(l);
            newo.Name = ipAddress;
            newo.MacAddress__c = ipAddress;
            newo.PartNumber__c= ipAddress;
            
            newo.Terminal__c = terminals[l].Id;
            newo.Terminal__r = terminals[l];

            newModems.add(newo);        
        }           
        }
        insert newModems;       

        // *** Step 6b. Create ModemsServicePlans: 2 for each Accounts
        map<Id,Account> accountList4 = new map<Id,Account>([SELECT Id, Name FROM Account WHERE Name in ('Stellar Energy','Datacom','Satcom Resources','AvL TECHNOLOGIES','American Red Cross')]);
        list<Modem__c> modemList = [SELECT Id,Account__c  FROM Modem__c WHERE Account__c in :accountList4.keySet() ORDER BY Account__c]; 
        list<ServicePlan__c> newSPs = [SELECT Id,StartDate__c,EndDate__c,Account__c  FROM ServicePlan__c WHERE Account__c in :accountList4.keySet() ORDER BY Account__c]; 

        //Modem__c[] modems = modemList;                                            
        ServicePlan__c[] sps = newSPs;
                                                                                           
        list<ModemServicePlan__c> newMSPs = new list<ModemServicePlan__c>();
        for (Modem__c mod : modemList)
        {
            for (ServicePlan__c sp : newSPs)
            {
                if (sp.Account__c == mod.Account__c)
                {
                    ModemServicePlan__c newo = new ModemServicePlan__c();
                    newo.Modem__r = mod; //modemMap.get(i);
                    newo.ServicePlan__r = sp;//SPMap.get(i);
                    newo.StartDate__c = sp.StartDate__c;//SPMap.get(i).StartDate__c;
                    newo.EndDate__c = sp.EndDate__c;//SPMap.get(i).EndDate__c;
                    newo.Modem__c=mod.id;//modemMap.get(i).id;
                    newo.ServicePlan__c=sp.id;//SPMap.get(i).id;
            //newo.Status__c = 'Active'; NOT WRITABLE
                    newMSPs.add(newo);
                    break;
                }
            }
        }                   
        insert newMSPs;     

        // *** Step 6b. Create ModemsServicePlans: 2 for each Accounts
        map<Id,Account> accountList4b = new map<Id,Account>([SELECT Id, Name FROM Account WHERE Name in ('AvL TECHNOLOGIES','American Red Cross')]);
        list<Modem__c> modemListb = [SELECT Id,Account__c  FROM Modem__c WHERE Account__c in :accountList4.keySet() ORDER BY Account__c]; 
        list<ServicePlan__c> newSPsb = [SELECT Id,StartDate__c,EndDate__c,Account__c  FROM ServicePlan__c WHERE Account__c in :accountList4.keySet() ORDER BY Account__c]; 

        //Modem__c[] modems = modemList;                                            
        ServicePlan__c[] spsb = newSPsb;
                                                                                           
        list<ModemServicePlan__c> newMSPsb = new list<ModemServicePlan__c>();
        for (Modem__c mod : modemListb)
        {
            for (ServicePlan__c sp : newSPsb)
            {
                if (sp.Account__c == mod.Account__c)
                {
                    ModemServicePlan__c newo = new ModemServicePlan__c();
                    newo.Modem__r = mod; //modemMap.get(i);
                    newo.ServicePlan__r = sp;//SPMap.get(i);
                    newo.StartDate__c = sp.StartDate__c;//SPMap.get(i).StartDate__c;
                    newo.EndDate__c = sp.EndDate__c;//SPMap.get(i).EndDate__c;
                    newo.Modem__c=mod.id;//modemMap.get(i).id;
                    newo.ServicePlan__c=sp.id;//SPMap.get(i).id;
            //newo.Status__c = 'Active'; NOT WRITABLE
                    newMSPs.add(newo);
                    break;
                }
            }
        }                   
        insert newMSPs;     
    }   

    private static void validateSNGObjectsSharing()
    {
    	// Sharing on all SNG Objects is set to 'Controlled by Parent' which means it is controlled by sharing on Account
    	// Check AccountShare table with RowCause=(Manual/Rule) RowCause=(Manual/Rule/ImplicitParent/Owner)
    	// Select g.Type, g.RelatedId, g.Name, g.Id, g.Email, g.DeveloperName From Group g
    	list<AccountShare> aSharings = [Select UserOrGroupId, RowCause, LastModifiedDate, LastModifiedById, AccountId 
    	                                From AccountShare where LastModifiedDate >= LAST_N_DAYS:30 
    	                                 and RowCause in ('Manual','Rule') 
    	                                 and Account.Exede_Enterprise_Tracking__c = true];
/*
        Set<Id> sfIDs = new Set<Id>();
        for (AggregateResult dr : [SELECT Contact.Accountid, ProfileId, UserRoleId, UserRole.ParentRoleID, UserRole.PortalAccountId 
                                   FROM User 
                                   WHERE IsActive=true and Contact.Account.Exede_Enterprise_Tracking__c = true
                                   group by Contact.Accountid, ProfileId, UserRoleId,UserRole.ParentRoleID,UserRole.PortalAccountId limit 1000])
        {
            Id aID = (Id)dr.Get('Contact.Accountid');
            sfIDs.add(aID);
        }
*/
    }
}