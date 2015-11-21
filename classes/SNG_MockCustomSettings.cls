/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class SNG_MockCustomSettings {
	
	public static final transient String MOCK_OPENAM_URL      = 'https://MOCK_OPENAM_URL/';
    public static final transient String MOCK_OPENAM_USERNAME = 'MOCK_OPENAM_USERNAME';
    public static final transient String MOCK_OPENAM_PASSWORD = 'MOCK_OPENAM_PASSWORD';
    public static final transient String MOCK_OPENAM_COOKIE   = 'MOCK_OPENAM_COOKIE';
    
    public static final transient String MOCK_TOMCAT_SERVER_URL      = 'https://MOCK_TOMCAT_SERVER_URL/';

    public static void initialize() {
    	initSNGWebServiceLogin();
        initSNGKeyValueStore();
    	initTerminalStatusLightThresholds();
    	initSNGErrorEmailNotification();
        initSNGEnvVars();
    }
    
    public static void initializeMultipleCookies()
    {
    	initSNGWebServiceLogin_MultipleCookies();
    	initTerminalStatusLightThresholds();
        initSNGErrorEmailNotification();
    }
    
    private static void initSNGWebServiceLogin() {
    	SNGWebService__c openAmLogin = new SNGWebService__c();
    	openAmLogin.Name = Label.SNGOpenAMLogin;
    	openAmLogin.URL__c = MOCK_OPENAM_URL;
    	openAmLogin.Username__c = MOCK_OPENAM_USERNAME;
    	openAmLogin.Password__c = MOCK_OPENAM_PASSWORD;
    	openAmLogin.AuthCookieCache__c = 'iPlanetDirectoryPro = AQIC5wM2LY4Sfcy954IRN6Ixz7Z';
    	openAmLogin.AuthSetCookieHeader__c = 'SET-COOKIE';
    	insert openAmLogin;
    	
    	SNGWebService__c tomcatService = new SNGWebService__c();
        tomcatService.Name = Label.SNGTomcatServer;
        tomcatService.URL__c = MOCK_TOMCAT_SERVER_URL;
        tomcatService.Username__c = '';
        tomcatService.Password__c = '';
        insert tomcatService;
    }

    private static void initSNGKeyValueStore()
    {
        insertSNGKeyValueStore(Label.SNGPmdrValidThresholdMinutes, String.valueOf(30));
        insertSNGKeyValueStore(Label.SNGPmdrHttpCalloutTimeoutSec, String.valueOf(30));
        insertSNGKeyValueStore(Label.SNGUsageServiceHttpCalloutTimeoutSec, String.valueOf(30));
    }


    private static void insertSNGKeyValueStore(String name, String value)
    {
        SNGKeyValueStore__c keyValueStore = new SNGKeyValueStore__c();
        keyValueStore.name = name;
        keyValueStore.Code__c = keyValueStore.name;
        keyValueStore.Value__c = value;
        insert keyValueStore;         
    }
    
    private static void initSNGWebServiceLogin_MultipleCookies() {
        SNGWebService__c openAmLogin = new SNGWebService__c();
        openAmLogin.Name = Label.SNGOpenAMLogin;
        openAmLogin.URL__c = MOCK_OPENAM_URL;
        openAmLogin.Username__c = MOCK_OPENAM_USERNAME;
        openAmLogin.Password__c = MOCK_OPENAM_PASSWORD;
        openAmLogin.AuthCookieCache__c = 'iPlanetDirectoryPro=AQIC5wM2LY4Sfcy954IRN6Ixz7Z;amlbcookie=BQIC5wM2LY4Sfcy954IRN6Ixz7Z';
        openAmLogin.AuthSetCookieHeader__c = 'SET-COOKIE';
        insert openAmLogin;
        
        SNGWebService__c tomcatService = new SNGWebService__c();
        tomcatService.Name = Label.SNGTomcatServer;
        tomcatService.URL__c = MOCK_TOMCAT_SERVER_URL;
        tomcatService.Username__c = '';
        tomcatService.Password__c = '';
        insert tomcatService;
    }
    
    private static void initTerminalStatusLightThresholds() {
    	initRlSymRateThresholds();
		initFlSinrThresholds();
    }
    
    private static void initRlSymRateThresholds() {
    	try {
    		SNGReturnLinkSymbolRateThresholds__c rlSymRateThresholds = SNGReturnLinkSymbolRateThresholds__c.getOrgDefaults();
	    	
	    	if (null == rlSymRateThresholds) {
	    		rlSymRateThresholds = new SNGReturnLinkSymbolRateThresholds__c();
	    	}
	    	
	    	rlSymRateThresholds.GoodMinimum__c = 5000.00;
	    	rlSymRateThresholds.BadMaximum__c = 1250.00;
	    	upsert rlSymRateThresholds;
    	} catch (System.DmlException e) {
    		// Most likely UNABLE_TO_LOCK_ROW, unable to obtain exclusive access to this record.
    		// This can happen if the same thing is being done on another thread.
    		for (Integer i = 0; i < e.getNumDml(); i++) {
				// Process exception here
				System.debug(e.getDmlMessage(i)); 
			}
    	}
    }
    
    private static void initFlSinrThresholds() {
    	try {
    		SNGForwardLinkSinrThresholds__c flSinrThresholds = SNGForwardLinkSinrThresholds__c.getOrgDefaults();
	    	
	    	if (null == flSinrThresholds) {
	    		flSinrThresholds = new SNGForwardLinkSinrThresholds__c();
	    	}
	    	
	    	flSinrThresholds.GoodMinimum__c = 7.00;
	    	flSinrThresholds.BadMaximum__c = 5.00;
	    	upsert flSinrThresholds;
    	} catch (System.DmlException e) {
    		// Most likely UNABLE_TO_LOCK_ROW, unable to obtain exclusive access to this record.
    		// This can happen if the same thing is being done on another thread.
    		for (Integer i = 0; i < e.getNumDml(); i++) {
				// Process exception here
				System.debug(e.getDmlMessage(i)); 
			}
    	}
    }
    
    private static void initSNGErrorEmailNotification() {
    	try {
            SNGErrorEmailNotification__c customSetting = SNGErrorEmailNotification__c.getOrgDefaults();
            
            if (null == customSetting) {
                customSetting = new SNGErrorEmailNotification__c();
            }
            
            customSetting.Emails__c = 'a@b.com, c@d.net, e@f.org';
            upsert customSetting;
        } catch (System.DmlException e) {
            // Most likely UNABLE_TO_LOCK_ROW, unable to obtain exclusive access to this record.
            // This can happen if the same thing is being done on another thread.
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                System.debug(e.getDmlMessage(i)); 
            }
        }
    }

    private static void initSNGEnvVars() {
        try {
            SNGEnvVars__c customSetting = SNGEnvVars__c.getOrgDefaults();
            
            if (null == customSetting) {
                customSetting = new SNGEnvVars__c();
            }
            
            customSetting.SalesOrderNumericLength__c = 7;
            upsert customSetting;
        } catch (System.DmlException e) {
            // Most likely UNABLE_TO_LOCK_ROW, unable to obtain exclusive access to this record.
            // This can happen if the same thing is being done on another thread.
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                System.debug(e.getDmlMessage(i)); 
            }
        }
    }
}