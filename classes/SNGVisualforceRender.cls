public with sharing class SNGVisualforceRender 
{
    public static boolean userAdmin { get { return isUserSystemAdmin(); } }
    
    public static boolean userNotAdmin { get { return !isUserSystemAdmin(); } }
    
    public static SNGAdminProfile__c ADMIN_INFO = SNGAdminProfile__c.getValues('SystemAdmin');
     
    ApexPages.StandardController m_sc = null; 
    
    public SNGVisualforceRender(ApexPages.StandardController controller)
    {
        m_sc = controller;
    }
     
    public Pagereference doSaveAndNew()
    {
        SObject so = m_sc.getRecord();
        upsert so;

        string s = '/' + ('' + so.get('Id')).subString(0, 3) + '/e?';
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, s));
        return new Pagereference(s);
    }
     
    public static boolean isUserSystemAdmin()
    {
        boolean retValue = false;
        try
        {
			// Check if Custom Setting SNGAdminProfile__c has been initialized
            if (ADMIN_INFO.ProfileId__c == null || ADMIN_INFO.ProfileName__c == null ||
                ADMIN_INFO.ProfileId__c == '' || ADMIN_INFO.ProfileName__c == '') 
                updateCustomSettings(); 
            
            // return true if user's profile Id is one from the Admin's profile Ids
            return ADMIN_INFO.ProfileId__c.contains(UserInfo.getProfileId());
        }
        catch (Exception e)
        {
            System.debug(LoggingLevel.ERROR, e.getMessage()); 
        }
        
        return retValue;
    }
    
     /**
      * Update SNGAdminProfile custom setting with this org's System Administrator info
      */ 
     private static void updateCustomSettings() 
     {  
        list<Profile> admins = [SELECT Id, Name FROM Profile WHERE Name in ('System Administrator'
        ,'SNG ViaSat Operations User','IT: PM/BA','IT: System Administrator'
        ,'Standard/Operations User (Bus Dev & Product Sales) + SNG'
        ,'Standard/Operations User (Product Sales) + SNG'
        ,'Standard/Operations User (Product Sales) + SNG Read Only')];
        ADMIN_INFO.ProfileId__c = '';
        ADMIN_INFO.ProfileName__c = 'System Administrator';
        for (Profile p : admins)
        {
        	ADMIN_INFO.ProfileId__c += (p.Id + ','); 
        } 
        update ADMIN_INFO;
     } 
}