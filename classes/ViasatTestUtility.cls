/***********************************************************************************************************
Name          : ViasatTestUtility
Created By    : Marina Basovich
Company Name  : ViaSat
Project       : 
Created Date  : 28 August, 2014
Modified Date : 
Description   : - Provides generic sObjects to be used in all test cases;
              : - Provides APEX code for AFTER REFRESH update (ANONYMOUSLY EXECUTED)
************************************************************************************************************/
@IsTest
public class ViasatTestUtility 
{
    public static Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

    public static Case generalCaseFromEmail = new Case(
        Origin = 'Email',
        VisibleToCustomer__c = 'Yes',
        Type = 'Change Request',
        Status = 'Working',
        Subject = 'My Test',
        Priority = 'Medium',
        Description = 'This is Test'
        );
    
    //************************************************************************************************************
    // Get ALL settings (Value & metadata) for the Project from TestKeyValueStore__c TABLE
    //************************************************************************************************************
    private static map<string,TestKeyValueStore__c> getProjectSettings(string project) 
    {
        list<TestKeyValueStore__c> objs = [SELECT Code__c, Value__c, Metadata__c FROM TestKeyValueStore__c WHERE Project__c =: project];
        
        map<string,TestKeyValueStore__c> testSettings = new map<string,TestKeyValueStore__c>();
        for (TestKeyValueStore__c o : objs)
        {
            testSettings.put(o.code__c, o);
        }        
        return testSettings;
    }

    //*************************************************************************************
    // INIT Custom Settings
    //*************************************************************************************
    // Initialize CaseKeyValueStore__c custom setting 
    public static void setCaseKeyValueStore() 
    {  
        CaseKeyValueStore__c[] customSettings = new CaseKeyValueStore__c[]{         
     new CaseKeyValueStore__c(name='CarlsbadNOCRecordTypes', Value__c='Carlsbad NOC,Carlsbad NOC Customer Portal')
    ,new CaseKeyValueStore__c(name='FieldID:Site', Value__c='')
    ,new CaseKeyValueStore__c(name='Profile:ViaSat NOC Customer Portal', Value__c='/apex/viasite')  
        };
        insert customSettings;
    }

    // Initialize NBNCoKeyvalueStore custom setting 
    public static void setNBNCoKeyvalueStore() 
    {  
        NBNCoKeyvalueStore__c[] customSettings = new NBNCoKeyvalueStore__c[]{           
     new NBNCoKeyvalueStore__c(name='NBNSupportServices', Value__c='Support Services NBN Co')
    ,new NBNCoKeyvalueStore__c(name='NBNCo', Value__c='NBN')
    ,new NBNCoKeyvalueStore__c(name='NotSLAReportableReason', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBN_Other', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='OtherReason', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NotEvaluated', Value__c='..')
    ,new NBNCoKeyvalueStore__c(name='NBN_AdvanceReplacementRMA', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBNViaSatTeam', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBNSFcase', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBNRequestRMA', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='Updateshavebeenmadeinthe', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='RequestforanAdvanceReplacement', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBNRequestforRMA', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBNAdvanceReplacementRMA', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBNCoDispatchMailId', Value__c='test@viasat.com')
    ,new NBNCoKeyvalueStore__c(name='ViaSat TEST Dispatch Method', Value__c='ViaSat TEST Dispatch Method description')
    ,new NBNCoKeyvalueStore__c(name='NBNforSalesForce', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBNNotDefined', Value__c='...')
    ,new NBNCoKeyvalueStore__c(name='NBN_RmaSaved', Value__c='...') 
    ,new NBNCoKeyvalueStore__c(name='NBN_AccountName', Value__c='NBN Co.')  
    ,new NBNCoKeyvalueStore__c(name='NBN_SubSystem', Value__c='\'DPC (Data Processing Center)\',\'GW (Gateway)\',\'GSTB\'') 
        };
        insert customSettings;

       customSettings = new NBNCoKeyvalueStore__c[]{           
     new NBNCoKeyvalueStore__c(name='Callout_Open', Value__c='Open')
    ,new NBNCoKeyvalueStore__c(name='Callout_Closed', Value__c='Closed') 
    ,new NBNCoKeyvalueStore__c(name='NBNDispatchOnViewPageHelp', Value__c='This Section will be activated after RMA Requested') 
        };
        insert customSettings;
    }
    
    // Initialize Globals custom setting 
    public static void setGlobals() 
    {
        List<Account> viasatAccount = ViasatTestUtility.createAccounts(1, 'ViaSat, Inc.-Corporate Headquarters');
        insert viasatAccount;
        List<Contact> viasatContact = ViasatTestUtility.createContacts(viasatAccount,1);
        insert viasatContact;
        
        Globals__c customSettings = new Globals__c(
        caseContactAccountEnforcement__c=true, 
        caseContactAccountEnforcementExceptions__c='Carlsbad NOC,Carlsbad NOC Customer Portal', 
        ViaSatCaseContact__c=viasatContact[0].id, 
        ViaSatLogLastNDays__c=0,
        ViaSatAccount__c=viasatAccount[0].id);
        insert customSettings;
    }

    //************************************************************************************************************
    // USER & Queue sObjects (sObjects can be owned by Users or Queues)
    //************************************************************************************************************
    // This method dynamically creates a username prefix that will make ensure username uniqueness.
    public static String getNamePrefix()
    {
        return UserInfo.getOrganizationId() + Math.roundToLong(Math.random()*10000) + System.now().millisecond();
    }

    // input: Map Map<string userProfileName, List<Contact>>
    //Map<string, list<Contact>> profileContactsMap = new Map<string, list<Contact>>();
    //profileContactsMap.put('System Administrator', contacts);        
    //List<User> users = ViasatTestUtility.createUsers(profileContactsMap);
    //insert users;
    public static List<User> createUsers(Map<string, list<Contact>> profileContactsMap)
    {
        List<User> users = new List<User>();
        
        for (string profileName : profileContactsMap.keySet())
        {
            list<Contact> contacts = profileContactsMap.get(profileName);
            for(Contact c : contacts)
            {
                User u = ViasatTestUtility.createUser(c, profileName);
                users.add(u);
            }   
        }
        return users;
    }

    // NOTE: only portal users can be associated to a contact:
    public static User createInsertUser(Contact c, string profileName)
    {
        User u = createUser(c, profileName);
        insert u;
        return u;
    }

    public static User createUser(Contact c, string profileName)
    {
        if (String.isEmpty(profileName))
            profileName = 'System Administrator';
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName];
        string namePref = getNamePrefix();
        User u = new User( Alias = 'uTest'
                         , Email='uTest@testorg.com'
                         , EmailEncodingKey='UTF-8'
                         , Firstname='Bruce'
                         , LastName = namePref
                         , LanguageLocaleKey='en_US'
                         , LocaleSidKey='en_US'
                         , ProfileId = p.Id
                         , TimeZoneSidKey='America/Los_Angeles'
                         , UserName=namePref + '@username-test.com');                         
        if (c != null)
            u.ContactId = c.Id;

        return u;
    }

    public static User createUser(Contact c, string profileName, string roleName)
    {
        User u = createUser(c, profileName);
        
        UserRole uRole; // = new UserRole();
        if (String.isEmpty(roleName))
            uRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        else
        {
        	roleName = '%' + roleName + '%';
        	uRole = [Select Id From UserRole Where Name LIKE :roleName Limit 1]; // and PortalType <> 'None'
        }
        u.UserRoleId = uRole.Id;
        return u;
    }

    // Create Queue, return Group.
    // To get around MIXED_DML_EXCEPTION you need to execute the DML on setup objects in a different context, 
    // this can be done using System.runAs(...)
    public static Group createInsertQueue(string queueName, string sObjectName)
    {
        Group testGroup = new Group(Name = queueName, Type = 'Queue', DeveloperName='Test'+queueName);
        insert testGroup;
       
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = sObjectName);
            insert testQueue;
        }
        return testGroup;
    }
    
    //************************************************************************************************************
    // Account & Contact sObjects
    //************************************************************************************************************
    public static List<Account> createAccounts(Integer numOfObjs, string namePrefix)
    {
        List<Account> objList = new List<Account>();
        for (Integer i=0; i < numOfObjs; i++)
        {
            string si = string.ValueOf(i);
            Account o = new Account(Name=(numOfObjs == 1 ? namePrefix : namePrefix + si)
                        //, RecordTypeId=''
                        , OwnerId = UserInfo.getUserId()
                        , CurrencyIsoCode = 'USD'
                        , Labor_Hours_Required__c = 'Yes'
                        , ShippingStreet = 'test street' + si
                        , Status__c = 'Customer'
                        , Type = 'Other'
                        , Industry = 'Other'
                        , Country__c = 'United States'
                        , BillingStreet='street' + si
                        , BillingCity='city' + si
                        , BillingState='CA');
            objList.add(o);
        }
        return objList;
    }

    public static List<Contact> createContacts(List<Account> accounts, Integer numOfObjsPerAccounts)
    {
        List<Contact> objList = new List<Contact>();
        for (Account a : accounts)
        {
            for (Integer i=0; i < numOfObjsPerAccounts; i++)
            {
            string si = string.ValueOf(i);
            Contact o = new Contact(CurrencyIsoCode = 'USD'
                        , LastName = 'ln' + si
                        , FirstName = 'fn' + si
                        , Accountid = a.id
                        , Email = 'name' + si + '@gmail.com');
            objList.add(o);
            }
        }
        return objList;
    }

    public static List<SLA__c> createSLAObjs(List<Account> accounts, Integer numOfObjsPerAccounts)
    {
        List<SLA__c> objList = new List<SLA__c>();          
        for (Account a : accounts)
        {
            for (Integer i=0; i < numOfObjsPerAccounts; i++)
            {
            string si = string.ValueOf(i);
            SLA__C o = new SLA__C(CurrencyIsoCode = 'USD'
                        , CasePriority__C='1 - Critical'
                        , Account__c=a.Id
                        , CaseType__c = 'Incident/Problem'
                        , SLAinitialResponseTime__c='20 Minutes'
                        , SLAresolutiontime__c='3 Days'
                        , SLAWorkaroundtime__c='12 Hours');
            objList.add(o);
            }
        }
        return objList;
    }   

    //************************************************************************************************************
    // CASE RELATED sObjects: Case, Incident__c, networkContext__c. contacts & caseRecordTypeName are optional
    //************************************************************************************************************
    public static List<Case> createCases(List<Account> accounts, List<Contact> contacts, string caseRecordTypeName)
    {
        string recTypeId = null;
        if (!string.isEmpty(caseRecordTypeName))
        {
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case;
            Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
            recTypeId=CaseRecordTypeInfo.get(caseRecordTypeName).getRecordTypeId();
        }
             
        List<Case> objList = new List<Case>();          
        for (Account a : accounts)
        {
            Case o = new Case(CurrencyIsoCode = 'USD'
                        , accountid=a.Id
                        , Status = 'New'
                        , Type = 'Problem'
                        , NetworkPicklist__c = 'NBNCo'
                        , PrioritybasedonType__c='1 - Critical'
                        , Origin = 'Email'
                        , VisibleToCustomer__c = 'Yes'
                        , Subject = 'Testing Data'
                        , Description = 'Testing Data123'                      
                        , subSystem__c='test'
                        );
            if (recTypeId != null)
                o.recordTypeId=recTypeId;                             

            if (contacts != null && contacts.size() > 0)
            {
	            List<Contact> co = new List<Contact>();
            	for (Contact c : contacts)
            	{
                	if (c.AccountId == a.Id)
                    	co.add(c);
            	}
            	o.ContactId = (co.size() > 0 ? co[0].id : null);
            	
            	for (Integer i=1; i < co.size(); i++)
            	{
            		Case c = new Case(CurrencyIsoCode = 'USD'
                        , accountid=a.Id
                        , ContactId = co[i].id
                        , Status = 'New'
                        , Type = 'Problem'
                        , NetworkPicklist__c = 'NBNCo'
                        , PrioritybasedonType__c='1 - Critical'
                        , Origin = 'Email'
                        , VisibleToCustomer__c = 'Yes'
                        , Subject = 'Testing Data'
                        , Description = 'Testing Data123'                      
                        , subSystem__c='test'
                        );
            		if (recTypeId != null)
                		c.recordTypeId=recTypeId;                             
            		objList.add(c);
            	}
        	}
        	objList.add(o);
        }
        return objList;
    }

    // TEST method to put Case to QUEUE (Cases can be owned by Users or Queues):
    // Rather than setting the Case.OwnerId to the Queue ID you need to set it to the Group ID. 
    // As OwnerId is a lookup to User and Group rather than User and Queue as displayed in the UI.
    public static List<Case> assignCasesToQueue(string queueName, List<Case> sObjs)
    {
        // Check if Queue already exists
        Id groupID;
        list<Group> testGroups = [SELECT Id FROM Group WHERE Name =:queueName and Type = 'Queue'];
        if (testGroups == null || testGroups.size() == 0) 
        {       
            Group testGroup = createInsertQueue(queueName, 'Case');//sObjs[0].getSObjectType().getDescribe().getName());
            groupID = testGroup.Id;
        }
        else
            groupID = testGroups[0].Id;
        
        system.assert(groupID != null);
            
        for (Case c : sObjs)
        {
            c.OwnerID = groupID;
        }
        return sObjs;
    }

    // Business Hour Data is available in Test Code Context. Holidays, however are not
    
/*
    public static List<Incident__c> createIncidents(Integer numOfObjs)
    {
        List<Incident__c> objList = new List<Incident__c>();
        for (Integer i=0; i < numOfObjs; i++)
        {
            Incident__c o = new Incident__c(//Name='i' + string.ValueOf(i)
                          CurrencyIsoCode = 'USD'
                        , Status__c = 'New'
                        , Summary__c = 'summary'+string.ValueOf(i)
                        //, CreatedByEmail__c = 'testInc'+string.ValueOf(i)+'@viasat.com'
                        );
            objList.add(o);
        }
        return objList;
    }
*/    
    //************************************************************************************************************
    // Product2 sObjects
    //************************************************************************************************************
    public static List<Product2> createProducts(Integer numOfObjs, string family, String recordTypeName)
    {
        return createProducts(numOfObjs, family, recordTypeName, 'TestProd', true);
    }
    
    public static List<Product2> createProducts(Integer numOfObjs, string family, String recordTypeName, String namePrefix, boolean isActive)
    {
        if (string.isEmpty(recordTypeName))
            recordTypeName = 'Main';
        if (string.isEmpty(family))
            family = 'Other';
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Product2;
        Map<String,Schema.RecordTypeInfo> ProductRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        List<Product2> objList = new List<Product2>();
        for (Integer i=0; i < numOfObjs; i++)
        {
            Product2 o = new Product2(Name=namePrefix + (i==0 ? '' : string.ValueOf(i))
                        , RecordTypeId=ProductRecordTypeInfo.get(recordTypeName).getRecordTypeId()
                        , CurrencyIsoCode = 'USD'
                        , IsActive = isActive
                        , Business_Area__c = 'TSN'
                        , Family = family
                        );
            objList.add(o);
        }
        return objList;
    }
    

    // ****************************************************************************
    // *** TEST ViasatUtilityClass.cls
    public static testMethod void utilityTest() 
    {
        map<string, id> availableRecordTypes = ViasatUtilityClass.getAvailableRecordTypes(Site__c.SObjectType);
        Time t = ViasatUtilityClass.GetElapsedTime(Time.newInstance(1,10,20,30), Time.newInstance(1,20,30,40));
        
        Integer i = ViasatUtilityClass.GetSecondsElapsed(DateTime.newinstance(2014, 1, 1, 1, 1, 1), system.now());
        i = ViasatUtilityClass.GetMinutesElapsed(DateTime.newinstance(2014, 1, 1, 1, 1, 1), system.now());
        i = ViasatUtilityClass.GetHoursElapsed(DateTime.newinstance(2014, 1, 1, 1, 1, 1), system.now());
        
        // Test ViasatUtilityClass
        DateTime dt = DateTime.newinstance(2014, 1, 1, 1, 1, 1);
        List<Holiday> holidays = [SELECT Id, Name, ActivityDate FROM Holiday];  
        i = ViasatUtilityClass.getNumOfDaysToNextWorkDay(dt, holidays);
        
        DateTime dt2 = ViasatUtilityClass.getWorkDay(dt, holidays);
        
        dt = DateTime.newinstance(2014, 12, 25, 1, 1, 1);
        dt2 = ViasatUtilityClass.getWorkDay(dt, holidays);
        boolean b = ViasatUtilityClass.isWorkDay(Date.today(), holidays);
        String s = ViasatUtilityClass.validateId('123456789012345678') ;
        
        String[] toAddresse = new String[]{'me@gmail.com'}; 
        String[] bccAdd = new String[]{'me2@gmail.com'};
        String subject = 'some sub';
        String body = '<span style="color:#0000FF;font-size: 20px;"><b>Task</b></span>'+'<br/><br/>';
        Messaging.SingleEmailMessage m = ViasatUtilityClass.buildEmail(subject,toAddresse,bccAdd,'me',body);  
        string ss = ViasatUtilityClass.sandboxName();  
        
        ss = ViasatUtilityClass.TimeTextFormattingForMinus(3242344242.00);  
        ss = ViasatUtilityClass.durationBetweenTwoDateTimes_PL(dt, dt2);
    }

    // *** TEST DateUtils
    public static testmethod void testDateUtils()
    {
		string temp = DateUtils.getYesterdayAsDDMMYYYY();
        temp = DateUtils.getDateTimeAsMMDDYYYY(System.now());
        DateTime dt = DateUtils.convertDateTimeToDate(DateTime.now());
    }

    // *** TEST KeyValueStoreHelper
    public static testmethod void testKeyValueStoreHelper()
    {
		Boolean bRet = KeyValueStoreHelper.getBooleanValue('some key');
		Decimal dRet = KeyValueStoreHelper.getDecimalValue('some key');
		Date dtRet = KeyValueStoreHelper.getDateValue('some key');
		DateTime dttRet = KeyValueStoreHelper.getDateTimeValue('some key'); 
    }
        
    // *** TEST ArrayUtils
    public static testmethod void testArrayUtils()
    {
        String[] aNull = null;
        System.assertEquals(true,    ArrayUtils.isEmpty(aNull)); 
        System.assertEquals(true,    ArrayUtils.isEmpty(new String[]{})); 
        System.assertEquals(false,    ArrayUtils.isEmpty(new String[]{'a'})); 
        System.assertEquals(false,    ArrayUtils.isEmpty(new String[]{'a','b'})); 
        System.assertEquals(true,    ArrayUtils.isEmpty(new Integer[]{})); 
        System.assertEquals(false,    ArrayUtils.isEmpty(new Integer[]{1})); 
        System.assertEquals(false,    ArrayUtils.isEmpty(new Integer[]{1,2})); 

        List<Object> aList = null;
        ArrayUtils.toString(aList);
        aList = new Integer[]{};        // edited to integer from DecimalRange
        ArrayUtils.toString(aList);
        aList = new Integer[]{1, 2, 3}; // edited to integer from DecimalRange
        ArrayUtils.toString(aList);
    }
    
    // *** TEST IntegerUtilUnitTest
    public static testMethod void testConvertToHex() 
    {
        // TO DO: implement unit test
        
        System.assertEquals('0f', IntegerUtil.convertToHex(15, 1));
        System.assertEquals('000f', IntegerUtil.convertToHex(15, 2));
        
        System.assertEquals('04d2', IntegerUtil.convertToHex(1234, 2));
        System.assertEquals('4d', IntegerUtil.convertToHex(1234, 1));
    }
    
    // *** TEST StringUtils
    public static testmethod void testStringUtils()
    {
		String sRet = StringUtils.charAt(null, 0);
		
		sRet = StringUtils.charAt('', 0);
		
		boolean bRet = StringUtils.containsOnly(null,'');
		bRet = StringUtils.containsOnly('','..');
		bRet = StringUtils.containsOnly('..','');
		
		bRet = StringUtils.equalsIgnoreCase('str1', 'str2');
		bRet = StringUtils.regionMatches('str1', 1, 'str2', 1, 2);
		
		String[] ss = StringUtils.splitPreserveAllTokens('str1', ',');
		ss = StringUtils.splitPreserveAllTokens('str1', ',', 1);

        Boolean bactual = StringUtils.startsWith('str1','st');
        String sactual = StringUtils.reverse('str');
        bactual = StringUtils.regionMatchesIgnoreCase('str1',1,'str2',1,1);
        bactual = StringUtils.regionMatches('STR1',1,'str2',1,1);
        sactual = StringUtils.removeStart('STR1','1');
        sactual = StringUtils.substring('str1',1, 2);
        sactual = StringUtils.replaceChars('str1','1','2');

        bactual = StringUtils.containsOnly('str1','1');
        bactual = StringUtils.equals('str1','1'); 
        bactual = StringUtils.equalsIgnoreCase('str1','str2');

        Integer iactual = StringUtils.indexOfAnyBut('str1','st');
        iactual = StringUtils.indexOf(null,'st');
        iactual = StringUtils.indexOfAnyBut('str1',null);
        sactual = StringUtils.upperCase('str1');
        bactual = StringUtils.IsEmpty('str1');
        iactual = StringUtils.length('str1');

    	StringUtils.isBlank('theString');
		sactual = StringUtils.trim('str   ');

        String[] actual1 = StringUtils.split('s t r   ');
		sactual = StringUtils.joinStrings(actual1,' ');
		//StringUtils.charAt('str   ','r');
		String[] actual3 = StringUtils.split('str','t');
		String[] actual4 = StringUtils.split(' s t r',' ',2);
        String[] actual5 = StringUtils.splitPreserveAllTokens(' s t r',' ');
        sactual = StringUtils.removeStart('STR1','');
        sactual = StringUtils.removeStart('STR1','sssssssss');
        sactual = StringUtils.reverse(null);
        bactual = StringUtils.startsWith(null,'st');
        bactual = StringUtils.startsWith('s','st');
        
        String s2 = StringUtils.rightPad('str', 2,'padStr');
        s2 = StringUtils.rightPad('str', 2,'padStr');
        s2 = StringUtils.rightPad('str', 2,'');
    }
    
    //private static Blob generateRandomBlob(){
    //    return EncodingUtil.base64Decode(''+System.currentTimeMillis()+Math.roundToLong(Math.random()*10000));    
    //}
}