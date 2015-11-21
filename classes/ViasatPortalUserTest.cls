/***********************************************************************************************************
Name          : ViasatPortalUserTest
Created By    : Marina Basovich
Company Name  : ViaSat
Project       : 
Created Date  : March, 2015
Modified Date : 
Description   : - Provides generic sObjects and methods for PORTAL USER Accessibility testing
************************************************************************************************************/
@IsTest(SeeAllData=true)
public class ViasatPortalUserTest 
{   
    public static UserRole portalRole = [Select Id, name From UserRole Where PortalType = 'None' Limit 1];
   
    public static Profile portalProfile = [SELECT Id, name FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];

    // *** Create Customer portal user without having any role in test class          
    // Identify which profile is assigned to the portal user. 
    // Identify which role is assigned to the portal user. 
    // The portal roles are unique for each account and include the account’s name—or example, “Account A Customer User.” 
    // This account-specific hierarchy is directly below the account owner.
    // To assign role to customer portal user in apex we need to query the UserRole where PortalType equals to 'CustomerPortal' .
    public static User createPortalUser(String portalUserName, String portalProfileName, String portalRoleName, string portalAccountName) 
    {
        User portalAccountOwner;        
        list<Account> portalAccounts;
        
        if (portalAccountName != null)
        {
            portalAccounts = [SELECT Id, OwnerID FROM Account WHERE IsCustomerPortal = true and Name = :portalAccountName];//ViasatTestUtility.createAccounts(1, 'portalAcc');

            portalAccountOwner = [SELECT id, isActive FROM User WHERE id =:portalAccounts[0].OwnerID limit 1];
            if (!portalAccountOwner.IsActive)
            {
                portalAccountOwner.IsActive = true;
                update portalAccountOwner;
            }           
        }
        else
        {
            //Create account using portal account owner
            portalAccountOwner = ViasatTestUtility.createUser(null, 'System Administrator');
            portalAccountOwner.UserRoleId = ViasatPortalUserTest.portalRole.Id;
            Database.upsert(portalAccountOwner);            
        }
        
        User portalUser;

    System.runAs(portalAccountOwner) 
    {
      if (portalAccounts != null)
      {
        Database.upsert(portalAccounts);
   
        //Create contact using portal account
        list<Contact> portalContacts = ViasatTestUtility.createContacts(portalAccounts, 1);
        Database.insert(portalContacts);        

        //Create portal user using portalUserContact and portalProfile
        portalUser = ViasatTestUtility.createUser(portalContacts[0], portalProfileName, portalRoleName);        
      }
      else
      {
        //create non-portal user, e.g. API user or admin
        //TODO: rename portalUser variable to make more generic
        portalUser = ViasatTestUtility.createUser(null, portalProfileName, portalRoleName);        
      }
         
        portalUser.CommunityNickname = portalUserName;
        Database.insert(portalUser);
    }     
        return portalUser;
    }

    static testMethod void exedePortalUserAccessibilityTest() {
       
        SNGUser [] sngUsers = new SNGUser[] {

           //------------------------------------------------------------------------------------------------------------------------------------------------------
           //           user name                   profile name                       role name                               account name           isPortalUser
           //------------------------------------------------------------------------------------------------------------------------------------------------------
           new SNGUser('RedCrossCustomerUser',      'SNG Customer User',              'American Red Cross Customer User',     'American Red Cross',    true   ),
           new SNGUser('VerizonCustomerUser',       'SNG Customer User',              'Verizon Wireless Customer User',       'Verizon Wireless',      true   ),
           new SNGUser('SatcomResourcesUser',       'SNG Customer User',              'Satcom Resources Customer User',       'Satcom Resources',      true   ),
           //new SNGUser('ExedeEnterpriseUser',       'ExedeEnterpriseAPIUser',         'Exede Enterprise – DTS',                null,                   false  ),             
           new SNGUser('ViasatOpsUser',             'SNG ViaSat Operations User',     null,                                    null,                   false  ),
           new SNGUser('SystemAdministrator',       'System Administrator',           null,                                    null,                   false  )

        };


        //-------------------------------------------------------------------------------------------------------------------------------------------------------
        // This table captures the permissions of a user with a specific role and profile on the record. 
        // The table has the following fields:
        //
        // role name:       role name of the user (Must match SNGUser table)
        // profile name:    the profile name for the user (Must match SNGUser table)
        // sObject:         The specific SObject the permission is being tested for.
        // matches account or owns end user: 
        //                  Whether the record matches the same account as the user. 
        //                  This is important because the user should not have access to records that do not belong to their account.
        //                  For customer users, the customer user should only have access when the matches account = true, otherwise should have no access for 
        //                  matches account = false
        //                   - or -
        //                  The record account is a descendant of the VAR account (i.e. it is an end user account which is owned by the account)
        //                  Requires TWO entries for each role/profile/sobject, where matches account = true and matches account = false.
        // read accesss:    True if the user with role/profile can read the specified sObject; false otherwise.
        // edit access:     True if the user with role/profile can edit the specified sObject; false otherwise.
        // delete access:   True if the user with role/profile can delete the specified sObject; false otherwise.
        // transfer access: True if the user with role/profile can transfer the record to another user for the specified sObject; false otherwise.
        // all access:      True if the user with role/profile has complete access the specified sObject; false otherwise.
        //-------------------------------------------------------------------------------------------------------------------------------------------------------
        SNGRecordAccess[] recordAccesses = new SNGRecordAccess[] {
           //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
           //                  role name                              profile name                     sObject                  matches    read     edit       delete      transfer      all
           //                                                                                                                   account    access   access     access      access        access
           //                                                                                                                    - or -
           //                                                                                                                   owns end
           //                                                                                                                     user
           //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
           
           // SNG Customer Portal - There seems to be a bug in Salesforce where if the Edit Access is set to TRUE, the Delete Access is set to TRUE as well. 
           // Seems the UserAccessRecord has a bug, even though the attempting to delete the object will fail from REST.
           new SNGRecordAccess('Red Cross Customer User',             'SNG Customer User',             'Terminal__c',            true,      true,    true,      true,       false,        false),
           new SNGRecordAccess('Red Cross Customer User',             'SNG Customer User',             'Terminal__c',            false,     false,   false,     false,      false,        false),
           new SNGRecordAccess('Red Cross Customer User',             'SNG Customer User',             'Modem__c',               true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Red Cross Customer User',             'SNG Customer User',             'Modem__c',               false,     false,   false,     false,      false,        false),
           new SNGRecordAccess('Red Cross Customer User',             'SNG Customer User',             'ServicePlan__c',         true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Red Cross Customer User',             'SNG Customer User',             'ServicePlan__c',         false,     false,   false,     false,      false,        false),
           new SNGRecordAccess('Red Cross Customer User',             'SNG Customer User',             'ModemServicePlan__c',    true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Red Cross Customer User',             'SNG Customer User',             'ModemServicePlan__c',    false,     false,   false,     false,      false,        false),


           new SNGRecordAccess('Verizon Wireless Customer User',      'SNG Customer User',             'Terminal__c',            true,      true,    true,      true,       false,        false),
           new SNGRecordAccess('Verizon Wireless Customer User',      'SNG Customer User',             'Terminal__c',            false,     false,   false,     false,      false,        false),
           new SNGRecordAccess('Verizon Wireless Customer User',      'SNG Customer User',             'Modem__c',               true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Verizon Wireless Customer User',      'SNG Customer User',             'Modem__c',               false,     false,   false,     false,      false,        false),   
           new SNGRecordAccess('Verizon Wireless Customer User',      'SNG Customer User',             'ServicePlan__c',         true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Verizon Wireless Customer User',      'SNG Customer User',             'ServicePlan__c',         false,     false,   false,     false,      false,        false),
           new SNGRecordAccess('Verizon Wireless Customer User',      'SNG Customer User',             'ModemServicePlan__c',    true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Verizon Wireless Customer User',      'SNG Customer User',             'ModemServicePlan__c',    false,     false,   false,     false,      false,        false),

           new SNGRecordAccess('Satcom Resources Customer User',      'SNG Customer User',             'Terminal__c',            true,      true,    true,      true,       false,        false),
           new SNGRecordAccess('Satcom Resources Customer User',      'SNG Customer User',             'Terminal__c',            false,     false,   false,     false,      false,        false),
           new SNGRecordAccess('Satcom Resources Customer User',      'SNG Customer User',             'Modem__c',               true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Satcom Resources Customer User',      'SNG Customer User',             'Modem__c',               false,     false,   false,     false,      false,        false),   
           new SNGRecordAccess('Satcom Resources Customer User',      'SNG Customer User',             'ServicePlan__c',         true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Satcom Resources Customer User',      'SNG Customer User',             'ServicePlan__c',         false,     false,   false,     false,      false,        false),
           new SNGRecordAccess('Satcom Resources Customer User',      'SNG Customer User',             'ModemServicePlan__c',    true,      true,    false,     false,      false,        false),
           new SNGRecordAccess('Satcom Resources Customer User',      'SNG Customer User',             'ModemServicePlan__c',    false,     false,   false,     false,      false,        false),

           new SNGRecordAccess('Exede Enterprise – DTS',              'ExedeEnterpriseAPIUser',        'Terminal__c',            true,      true,    true,      true,       false,        false),
           new SNGRecordAccess('Exede Enterprise – DTS',              'ExedeEnterpriseAPIUser',        'Terminal__c',            false,     true,    true,      true,       false,        false),
           new SNGRecordAccess('Exede Enterprise – DTS',              'ExedeEnterpriseAPIUser',        'Modem__c',               true,      true,    true,      true,       false,        false),
           new SNGRecordAccess('Exede Enterprise – DTS',              'ExedeEnterpriseAPIUser',        'Modem__c',               false,     true,    false,     false,      false,        false),
           new SNGRecordAccess('Exede Enterprise – DTS',              'ExedeEnterpriseAPIUser',        'ServicePlan__c',         true,      true,    true,      true,       false,        false),
           new SNGRecordAccess('Exede Enterprise – DTS',              'ExedeEnterpriseAPIUser',        'ServicePlan__c',         false,     true,    false,     false,      false,        false),
           new SNGRecordAccess('Exede Enterprise – DTS',              'ExedeEnterpriseAPIUser',        'ModemServicePlan__c',    true,      true,    true,      true,       false,        false),
           new SNGRecordAccess('Exede Enterprise – DTS',              'ExedeEnterpriseAPIUser',        'ModemServicePlan__c',    false,     true,    false,     false,      false,        false),

           new SNGRecordAccess(null,                                  'SNG ViaSat Operations User',    'Terminal__c',            true,      true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'SNG ViaSat Operations User',    'Terminal__c',            false,     true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'SNG ViaSat Operations User',    'Modem__c',               true,      true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'SNG ViaSat Operations User',    'Modem__c',               false,     true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'SNG ViaSat Operations User',    'ServicePlan__c',         true,      true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'SNG ViaSat Operations User',    'ServicePlan__c',         false,     true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'SNG ViaSat Operations User',    'ModemServicePlan__c',    true,      true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'SNG ViaSat Operations User',    'ModemServicePlan__c',    false,     true,    true,      true,       false,        false),
        

           new SNGRecordAccess(null,                                  'System Administrator',          'Terminal__c',            true,      true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'System Administrator',          'Terminal__c',            false,     true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'System Administrator',          'Modem__c',               true,      true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'System Administrator',          'Modem__c',               false,     true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'System Administrator',          'ServicePlan__c',         true,      true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'System Administrator',          'ServicePlan__c',         false,     true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'System Administrator',          'ModemServicePlan__c',    true,      true,    true,      true,       false,        false),
           new SNGRecordAccess(null,                                  'System Administrator',          'ModemServicePlan__c',    false,     true,    true,      true,       false,        false)

        };

        Map<String, SNGUser> sngUserMap = new Map<String, SNGUser>();
        for (SNGUser user : sngUsers) {
            sngUserMap.put(user.userName, user);
        }

        FieldPermissions[] fieldPermissionsList = new FieldPermissions[] {
            //--------------------------------------------------------------------------------------------------------------------------------------------------------------
            //                    SObjectField                                   SNGUser                                      isAccessible    isCreateable    isUpdateable
            //--------------------------------------------------------------------------------------------------------------------------------------------------------------

            // Permissions for user 'RedCrossCustomerUser':
            
            //                   Modem__c.*                                      'RedCrossCustomerUser'
            //new FieldPermissions(Modem__c.CurrencyIsoCode,                       sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Modem__c.Name,                                  sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Modem__c.External_ID_Field__c,                  sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            //new FieldPermissions(Modem__c.Account__c,                            sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Modem__c.MacAddress__c,                         sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Modem__c.PartNumber__c,                         sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Modem__c.SerialNumber__c,                       sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Modem__c.SoftwareVersion__c,                    sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Modem__c.Terminal__c,                           sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
              
            //                   ServicePlan__c.*                                'RedCrossCustomerUser'   
            //new FieldPermissions(ServicePlan__c.CurrencyIsoCode,                 sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.Name,                            sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.External_ID_Field__c,            sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            //new FieldPermissions(ServicePlan__c.Account__c,                      sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.StartDate__c,                    sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.EndDate__c,                      sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.Industry__c,                     sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.ProjectNumber__c,                sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.SalesOrder__c,                   sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.ServicePlanStatus__c,            sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.ServicePlanType__c,              sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.Status__c,                       sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.TaskNumber__c,                   sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
              
            //                   ModemServicePlan__c.*                           'RedCrossCustomerUser' 
            //new FieldPermissions(ModemServicePlan__c.CurrencyIsoCode,            sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Name,                       sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Modem__c,                   sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlan__c,             sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            //new FieldPermissions(ModemServicePlan__c.Account__c,                 sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.DataDuration__c,            sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.DownloadPrice__c,           sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.EndDate__c,                 sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Fee__c,                     sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.FeeDurationMonths__c,       sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.FeeType__c,                 sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.IncludedUsage__c,           sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Industry__c,                sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.OverageAllowed__c,          sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.PartNumber__c,              sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Prepaid__c,                 sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.SalesOrderNumber__c,        sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.SerialNumber__c,            sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanEndDate__c,      sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanStartDate__c,    sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanStatus__c,       sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanType__c,         sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.StartDate__c,               sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Status__c,                  sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Terminal__c,                sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.UploadPrice__c,             sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.UsageIncludedInFee__c,      sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),

            //                   Terminal__c.*                                   'RedCrossCustomerUser'
            //new FieldPermissions(Terminal__c.CurrencyIsoCode,                    sngUserMap.get('RedCrossCustomerUser'),       null,           false,          null /*should be false*/),
            new FieldPermissions(Terminal__c.Name,                               sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            //new FieldPermissions(Terminal__c.Account__c,                         sngUserMap.get('RedCrossCustomerUser'),       null,           false,          null /*should be false*/),
            new FieldPermissions(Terminal__c.AssetTag__c,                        sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.DownloadSinrBackEnd__c,             sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.External_ID_Field__c,               sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.GbDownloaded__c,                    sngUserMap.get('RedCrossCustomerUser'),       true,           false,          true                    ),
            new FieldPermissions(Terminal__c.GbTotal__c,                         sngUserMap.get('RedCrossCustomerUser'),       true,           false,          true                    ),
            new FieldPermissions(Terminal__c.GbUploaded__c,                      sngUserMap.get('RedCrossCustomerUser'),       true,           false,          true                    ),
            new FieldPermissions(Terminal__c.IpAddress__c,                       sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.MacAddress__c,                      sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Terminal__c.Network__c,                         sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Terminal__c.Nickname__c,                        sngUserMap.get('RedCrossCustomerUser'),       true,           false,          true                    ),
            new FieldPermissions(Terminal__c.Notes__c,                           sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.OnlineTime__c,                      sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.PeersAvgUploadSymbolRateBackEnd__c, sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.PeersOnlineBackEnd__c,              sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Performance__c,                     sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Terminal__c.Pointing__c,                        sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.SalesOrder__c,                      sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.SerialNumber__c,                    sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Terminal__c.ShipDate__c,                        sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.ShippingCarrier__c,                 sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Status__c,                          sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.StatusBackEnd__c,                   sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.TerminalType__c,                    sngUserMap.get('RedCrossCustomerUser'),       true,           false,          false                   ),
            new FieldPermissions(Terminal__c.TrackingNumber__c,                  sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.UploadSymbolRate__c,                sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.UploadSymbolRateBackEnd__c,         sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),
            new FieldPermissions(Terminal__c.WeatherBackEnd__c,                  sngUserMap.get('RedCrossCustomerUser'),       false,          false,          false                   ),


            // Permissions for user 'VerizonCustomerUser':

            //                   Modem__c.*                                      'VerizonCustomerUser'
            //new FieldPermissions(Modem__c.CurrencyIsoCode,                       sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Modem__c.Name,                                  sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Modem__c.External_ID_Field__c,                  sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            //new FieldPermissions(Modem__c.Account__c,                            sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Modem__c.MacAddress__c,                         sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Modem__c.PartNumber__c,                         sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Modem__c.SerialNumber__c,                       sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Modem__c.SoftwareVersion__c,                    sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Modem__c.Terminal__c,                           sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),

            //                   ServicePlan__c.*                                'VerizonCustomerUser'
            //new FieldPermissions(ServicePlan__c.CurrencyIsoCode,                 sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.Name,                            sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.External_ID_Field__c,            sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            //new FieldPermissions(ServicePlan__c.Account__c,                      sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.StartDate__c,                    sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.EndDate__c,                      sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.Industry__c,                     sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.ProjectNumber__c,                sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.SalesOrder__c,                   sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.ServicePlanStatus__c,            sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.ServicePlanType__c,              sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.Status__c,                       sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.TaskNumber__c,                   sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),

            //                   ModemServicePlan__c.*                           'VerizonCustomerUser'
            //new FieldPermissions(ModemServicePlan__c.CurrencyIsoCode,            sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Name,                       sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Modem__c,                   sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlan__c,             sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            //new FieldPermissions(ModemServicePlan__c.Account__c,                 sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.DataDuration__c,            sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.DownloadPrice__c,           sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.EndDate__c,                 sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Fee__c,                     sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.FeeDurationMonths__c,       sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.FeeType__c,                 sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.IncludedUsage__c,           sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Industry__c,                sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.OverageAllowed__c,          sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.PartNumber__c,              sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Prepaid__c,                 sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.SalesOrderNumber__c,        sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.SerialNumber__c,            sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanEndDate__c,      sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanStartDate__c,    sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanStatus__c,       sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanType__c,         sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.StartDate__c,               sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Status__c,                  sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Terminal__c,                sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.UploadPrice__c,             sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.UsageIncludedInFee__c,      sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),

            //                   Terminal__c.*                                   'VerizonCustomerUser'
            //new FieldPermissions(Terminal__c.CurrencyIsoCode,                    sngUserMap.get('VerizonCustomerUser'),        null,           false,          null /*should be false*/),
            new FieldPermissions(Terminal__c.Name,                               sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            //new FieldPermissions(Terminal__c.Account__c,                         sngUserMap.get('VerizonCustomerUser'),        null,           false,          null /*should be false*/),
            new FieldPermissions(Terminal__c.AssetTag__c,                        sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.DownloadSinrBackEnd__c,             sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.External_ID_Field__c,               sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.GbDownloaded__c,                    sngUserMap.get('VerizonCustomerUser'),        true,           false,          true                    ),
            new FieldPermissions(Terminal__c.GbTotal__c,                         sngUserMap.get('VerizonCustomerUser'),        true,           false,          true                    ),
            new FieldPermissions(Terminal__c.GbUploaded__c,                      sngUserMap.get('VerizonCustomerUser'),        true,           false,          true                    ),
            new FieldPermissions(Terminal__c.IpAddress__c,                       sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.MacAddress__c,                      sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Terminal__c.Network__c,                         sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Terminal__c.Nickname__c,                        sngUserMap.get('VerizonCustomerUser'),        true,           false,          true                    ),
            new FieldPermissions(Terminal__c.Notes__c,                           sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.OnlineTime__c,                      sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.PeersAvgUploadSymbolRateBackEnd__c, sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.PeersOnlineBackEnd__c,              sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Performance__c,                     sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Terminal__c.Pointing__c,                        sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.SalesOrder__c,                      sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.SerialNumber__c,                    sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Terminal__c.ShipDate__c,                        sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.ShippingCarrier__c,                 sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Status__c,                          sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.StatusBackEnd__c,                   sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.TerminalType__c,                    sngUserMap.get('VerizonCustomerUser'),        true,           false,          false                   ),
            new FieldPermissions(Terminal__c.TrackingNumber__c,                  sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.UploadSymbolRate__c,                sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.UploadSymbolRateBackEnd__c,         sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.WeatherBackEnd__c,                  sngUserMap.get('VerizonCustomerUser'),        false,          false,          false                   ),


            // Permissions for user 'ViasatOpsUser':

            //                   Modem__c.*                                      'ViasatOpsUser'
            //new FieldPermissions(Modem__c.CurrencyIsoCode,                       sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Modem__c.Name,                                  sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Modem__c.External_ID_Field__c,                  sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            //new FieldPermissions(Modem__c.Account__c,                            sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Modem__c.MacAddress__c,                         sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Modem__c.PartNumber__c,                         sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Modem__c.SerialNumber__c,                       sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Modem__c.SoftwareVersion__c,                    sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Modem__c.Terminal__c,                           sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),

            //                   ServicePlan__c.*                                'ViasatOpsUser'
            //new FieldPermissions(ServicePlan__c.CurrencyIsoCode,                 sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.Name,                            sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.External_ID_Field__c,            sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            //new FieldPermissions(ServicePlan__c.Account__c,                      sngUserMap.get('ViasatOpsUser'),              true,           true,           false                   ),
            new FieldPermissions(ServicePlan__c.StartDate__c,                    sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.EndDate__c,                      sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.Industry__c,                     sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.ProjectNumber__c,                sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.SalesOrder__c,                   sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.ServicePlanStatus__c,            sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.ServicePlanType__c,              sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.Status__c,                       sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.TaskNumber__c,                   sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),

            //                   ModemServicePlan__c.*                           'ViasatOpsUser'
            //new FieldPermissions(ModemServicePlan__c.CurrencyIsoCode,            sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ModemServicePlan__c.Name,                       sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Modem__c,                   sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ModemServicePlan__c.ServicePlan__c,             sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            //new FieldPermissions(ModemServicePlan__c.Account__c,                 sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.DataDuration__c,            sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.DownloadPrice__c,           sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.EndDate__c,                 sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ModemServicePlan__c.Fee__c,                     sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.FeeDurationMonths__c,       sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.FeeType__c,                 sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.IncludedUsage__c,           sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Industry__c,                sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.OverageAllowed__c,          sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.PartNumber__c,              sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Prepaid__c,                 sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.SalesOrderNumber__c,        sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.SerialNumber__c,            sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanEndDate__c,      sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanStartDate__c,    sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanStatus__c,       sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanType__c,         sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.StartDate__c,               sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(ModemServicePlan__c.Status__c,                  sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Terminal__c,                sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.UploadPrice__c,             sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.UsageIncludedInFee__c,      sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),

            //                   Terminal__c.*                                   'ViasatOpsUser'
            //new FieldPermissions(Terminal__c.CurrencyIsoCode,                    sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.Name,                               sngUserMap.get('ViasatOpsUser'),              true,           false,          false                   ),
            //new FieldPermissions(Terminal__c.Account__c,                         sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.AssetTag__c,                        sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.DownloadSinrBackEnd__c,             sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.External_ID_Field__c,               sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.GbDownloaded__c,                    sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.GbTotal__c,                         sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.GbUploaded__c,                      sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.IpAddress__c,                       sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.MacAddress__c,                      sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Network__c,                         sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Nickname__c,                        sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.Notes__c,                           sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.OnlineTime__c,                      sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.PeersAvgUploadSymbolRateBackEnd__c, sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.PeersOnlineBackEnd__c,              sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Performance__c,                     sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Pointing__c,                        sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.SalesOrder__c,                      sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.SerialNumber__c,                    sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.ShipDate__c,                        sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.ShippingCarrier__c,                 sngUserMap.get('ViasatOpsUser'),              true,           true ,          true                    ),
            new FieldPermissions(Terminal__c.Status__c,                          sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.StatusBackEnd__c,                   sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.TerminalType__c,                    sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.TrackingNumber__c,                  sngUserMap.get('ViasatOpsUser'),              true,           true,           true                    ),
            new FieldPermissions(Terminal__c.UploadSymbolRate__c,                sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.UploadSymbolRateBackEnd__c,         sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),
            new FieldPermissions(Terminal__c.WeatherBackEnd__c,                  sngUserMap.get('ViasatOpsUser'),              false,          false,          false                   ),


            // Permissions for user 'SystemAdministrator':

            //                   Modem__c.*                                      'SystemAdministrator'
            //new FieldPermissions(Modem__c.CurrencyIsoCode,                       sngUserMap.get('SystemAdministrator'),        true,           false,          false                  ),
            new FieldPermissions(Modem__c.Name,                                  sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Modem__c.External_ID_Field__c,                  sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            //new FieldPermissions(Modem__c.Account__c,                            sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Modem__c.MacAddress__c,                         sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Modem__c.PartNumber__c,                         sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Modem__c.SerialNumber__c,                       sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Modem__c.SoftwareVersion__c,                    sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Modem__c.Terminal__c,                           sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),

            //                   ServicePlan__c.*                                'SystemAdministrator'
            //new FieldPermissions(ServicePlan__c.CurrencyIsoCode,                 sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.Name,                            sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.External_ID_Field__c,            sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.Account__c,                      sngUserMap.get('SystemAdministrator'),        true,           true,           false                   ),
            new FieldPermissions(ServicePlan__c.StartDate__c,                    sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.EndDate__c,                      sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.Industry__c,                     sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.ProjectNumber__c,                sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(ServicePlan__c.SalesOrder__c,                   sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.ServicePlanStatus__c,            sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.ServicePlanType__c,              sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ServicePlan__c.Status__c,                       sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ServicePlan__c.TaskNumber__c,                   sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),

            //                   ModemServicePlan__c.*                           'SystemAdministrator'
            //new FieldPermissions(ModemServicePlan__c.CurrencyIsoCode,            sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ModemServicePlan__c.Name,                       sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Modem__c,                   sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ModemServicePlan__c.ServicePlan__c,             sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            //new FieldPermissions(ModemServicePlan__c.Account__c,                 sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.DataDuration__c,            sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.DownloadPrice__c,           sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.EndDate__c,                 sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ModemServicePlan__c.Fee__c,                     sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.FeeDurationMonths__c,       sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.FeeType__c,                 sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.IncludedUsage__c,           sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Industry__c,                sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.OverageAllowed__c,          sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.PartNumber__c,              sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Prepaid__c,                 sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.SalesOrderNumber__c,        sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.SerialNumber__c,            sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanEndDate__c,      sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanStartDate__c,    sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanStatus__c,       sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.ServicePlanType__c,         sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.StartDate__c,               sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(ModemServicePlan__c.Status__c,                  sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.Terminal__c,                sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.UploadPrice__c,             sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            new FieldPermissions(ModemServicePlan__c.UsageIncludedInFee__c,      sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),

            //                   Terminal__c.*                                   'SystemAdministrator'
            //new FieldPermissions(Terminal__c.CurrencyIsoCode,                    sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.Name,                               sngUserMap.get('SystemAdministrator'),        true,           false,          false                   ),
            //new FieldPermissions(Terminal__c.Account__c,                         sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.AssetTag__c,                        sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.DownloadSinrBackEnd__c,             sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.External_ID_Field__c,               sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.GbDownloaded__c,                    sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.GbTotal__c,                         sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.GbUploaded__c,                      sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.IpAddress__c,                       sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.MacAddress__c,                      sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Network__c,                         sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Nickname__c,                        sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.Notes__c,                           sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.OnlineTime__c,                      sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.PeersAvgUploadSymbolRateBackEnd__c, sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.PeersOnlineBackEnd__c,              sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Performance__c,                     sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.Pointing__c,                        sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.SalesOrder__c,                      sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.SerialNumber__c,                    sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.ShipDate__c,                        sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.ShippingCarrier__c,                 sngUserMap.get('SystemAdministrator'),        true,           true ,          true                    ),
            new FieldPermissions(Terminal__c.Status__c,                          sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.StatusBackEnd__c,                   sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.TerminalType__c,                    sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.TrackingNumber__c,                  sngUserMap.get('SystemAdministrator'),        true,           true,           true                    ),
            new FieldPermissions(Terminal__c.UploadSymbolRate__c,                sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.UploadSymbolRateBackEnd__c,         sngUserMap.get('SystemAdministrator'),        false,          false,          false                   ),
            new FieldPermissions(Terminal__c.WeatherBackEnd__c,                  sngUserMap.get('SystemAdministrator'),        false,          false,          false                   )
        };

        Set<String> sObjectNames = new Set<String>();
        Map<RoleSObject, SNGRecordAccess> roleAccessMap = new Map<RoleSObject, SNGRecordAccess>();

        for (SNGRecordAccess ra : recordAccesses)
        {
            RoleSObject rso = new RoleSObject(ra.roleName, ra.profileName, ra.sObjectName, ra.matchesAccount);
            System.assertEquals(null, roleAccessMap.get(rso));
            roleAccessMap.put(rso, ra);
            sObjectNames.add(ra.sObjectName); // being a set, an entry will not be added to the collection if it already exists.
        }
    

        sObjectNames.clear();
        sObjectNames.add('Terminal__c');

        ExedePortalUserAccess userAccess = new ExedePortalUserAccess();

        for (SNGUser user : sngUsers)
        {
            //TODO: Funnel all user creation through createPortalUser
            //User u = ViasatPortalUserTest.createPortalUser(user.userName, user.profileName, user.roleName, user.accountName);          
            User u = (user.roleName != null) ?  ViasatPortalUserTest.createPortalUser(user.userName, user.profileName, 
                                                                                  user.roleName, user.accountName) :
                                            ViasatTestUtility.createUser(null, user.profileName);
            Database.upsert(u);

            userAccess.validateUser(user, u);
            //userAccess.testUserRecordAccess(u, user, roleAccessMap, sObjectNames);
            userAccess.testUserFieldSecurityLevel(u, user, fieldPermissionsList);
        }
    }
    
    // Carslsbad NOC Customer Portal
    static testMethod void carlsbadNOCPortalUserAccessibilityTest() 
    {
        // Create Portal User 
        string sandboxName = ViasatUtilityClass.sandboxName();

        User portalUser = createPortalUser('ViaSatNOCCustomer', 'ViaSat NOC Customer Portal', 'KVH Industries Customer Executive','KVH Industries');
        
        test.startTest();
        System.runAs(new User(Id=UserInfo.getUserId())) 
        {
            system.debug('*** user:' + portalUser);
            User u1 = [SELECT Profile.Name, UserRole.Name, IsPortalEnabled FROM User WHERE Id = :portalUser.id limit 1];
            system.assertEquals(u1.Profile.Name, 'ViaSat NOC Customer Portal');
            system.assertEquals(u1.IsPortalEnabled, true);
            system.assertEquals(u1.UserRole.Name, 'KVH Industries Customer Executive');
        }
        test.stopTest();
    }

    // PROFILE: License and Certificate Requests
    static testMethod void licenseCertPortalUserAccessibilityTest() 
    {
        User portalUser = createPortalUser('licenseCertCustomer', 'License and Certificate Requests', 'ViaSat, Inc.-Corporate Headquarters Customer User','ViaSat, Inc.-Corporate Headquarters');
        
        test.startTest();
        System.runAs(new User(Id=UserInfo.getUserId())) 
        {
        User u1 = [SELECT Profile.Name, UserRole.Name, IsPortalEnabled FROM User WHERE Id = :portalUser.id limit 1];
        system.assertEquals(u1.Profile.Name, 'License and Certificate Requests');
        system.assertEquals(u1.UserRole.Name, 'ViaSat, Inc.-Corporate Headquarters Customer User');
        system.assertEquals(u1.IsPortalEnabled, true);
        }
        test.stopTest();
    }       

    // NBN Co Customer Portal 
    //static testMethod void nbncoPortalUserAccessibilityTest() 
    //{
    //    User portalUser = createPortalUser('nbncoCustomer', 'NBN Co Customer Portal', 'NBN Co. Customer User','NBN Co.');
    //}       

    //// Order Customer Portal 
    //static testMethod void orderPortalUserAccessibilityTest() 
    //{
    //    User portalUser = createPortalUser('orderCustomer', 'Order Customer Portal Users', 'Skylogic S.p.A. Customer User','Skylogic S.p.A.');

    //    //AccountShare AccShare = new AccountShare(AccountId = accounts[0].Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Read', UserOrGroupId = portalUser.Id);
    //    //insert AccShare;
    //}       
    
    /* PROFILE: ViaSat RMA Customer Portal
        User portalUser = createPortalUser('rmaCustomer', 'ViaSat RMA Customer Portal', 'userRoleName');
    */
               
    /* PROFILE: ViaSat NOC Customer Portal - Content Only
        User portalUser = createPortalUser('nocCustomer', 'ViaSat NOC Customer Portal - Content Only', 'userRoleName');
    */    

//-----------------------------------------------------------------------------------------------------------------
// End testing here.
//-----------------------------------------------------------------------------------------------------------------


    //--------------------------------------------------------
    // SNG inner classes - start helper classes
    //--------------------------------------------------------
    public class SNGUser
    {
        public String username, profileName, roleName, accountName;
        public boolean isPortalUser;

        public SNGUser(String userName, String profileName, String roleName, String accountName, boolean isPortalUser)
        {
            this.userName = userName;
            this.profileName = profileName;
            this.roleName = roleName;
            this.accountName = accountName;
            this.isPortalUser = isPortalUser;
        }
    }

    public class SNGRecordAccess
    {
        public String rolename, profileName, sObjectName;
        public boolean matchesAccount, ownsEndUser, readAccess, editAccess, deleteAccess, transferAccess, allAccess;

        public SNGRecordAccess(String rolename, String profileName, String sObjectName, boolean matchesAccount, boolean readAccess, boolean editAccess, 
                               boolean deleteAccess, boolean transferAccess, boolean allAccess)
        {
            this.roleName = roleName;
            this.profileName = profileName;
            this.sObjectName = sObjectName;
            this.readAccess = readAccess;
            this.matchesAccount = matchesAccount;
            this.editAccess = editAccess;
            this.deleteAccess = deleteAccess;
            this.transferAccess = transferAccess;
            this.allAccess = allAccess;
        }
    }

    public class FieldPermissions
    {
        public Schema.sObjectField field { public get; private set; }
        public SNGUser user { public get; private set; }
        public boolean isAccessible { public get; private set; }
        public boolean isCreateable { public get; private set; }
        public boolean isUpdateable { public get; private set; }

        public FieldPermissions(Schema.sObjectField field, SNGUser user, boolean isAccessible, boolean isCreateable, boolean isUpdateable)
        {
            this.field = field;
            this.user = user;
            this.isAccessible = isAccessible;
            this.isCreateable = isCreateable;
            this.isUpdateable = isUpdateable;
        }

        public void testPermissionsAsUser()
        {
            String[] failures = new List<String>();

            Schema.DescribeFieldResult dfr = field.getDescribe();

            if (isAccessible != null && isAccessible != dfr.isAccessible())
            {
                failures.add('isAccessible: expected ' + isAccessible + ' ; actual ' + dfr.isAccessible());
            }

            if (isCreateable != null && isCreateable != dfr.isCreateable())
            {
                failures.add('isCreateable: expected ' + isCreateable + ' ; actual ' + dfr.isCreateable());
            }

            if (isUpdateable != null && isUpdateable != dfr.isUpdateable())
            {
                failures.add('isUpdateable: expected ' + isUpdateable + ' ; actual ' + dfr.isUpdateable());
            }

            String failMsg = null;
            if (!failures.isEmpty())
            {
                failMsg = 'Assertion(s) failed in FieldPermissions with field=' + dfr.getName() + ' and username=' + user.userName + ':';
                for (String failure : failures)
                {
                    failMsg += '\n\t' + failure;
                }
            }
            //System.assertEquals(null, failMsg);
        }
    }

    public class RoleSObject
    {
        public String roleName;
        public String profileName;
        public String sObjectName;
        public boolean matchesAccount;

        public RoleSObject(String roleName, String profileName, String sObjectName, boolean matchesAccount)
        {
            this.roleName = roleName;
            this.profileName = profileName;
            this.sObjectName = sObjectName; 
            this.matchesAccount = matchesAccount;
        }


        public virtual integer hashCode() {
            final integer prime = 31;
            integer result = prime * ((null != roleName) ? roleName.hashCode() : 0); 
            result ^= ((null != sObjectName) ? sObjectName.hashCode() : 0);
            result ^=  (null != matchesAccount) ? ((matchesAccount) ? 1237 : 1231) : 0;
            return result;
        }

        public virtual boolean equals(final Object obj) { 
            
            if (this === obj) return true;
            if (obj == null || !(obj instanceof RoleSObject)) return false;

            RoleSObject other = (RoleSObject) obj; 
            return ( (this.roleName == other.roleName) && 
                     (this.profileName == other.profileName) &&
                     (this.sObjectName == other.sObjectName) &&
                     (this.matchesAccount == other.matchesAccount) );
        }
    }

    public class ExedePortalUserAccess
    {
        Map<Id, Account> accountsFromId;
        Map<String, Account> accountsFromName;
        Map<Id, ModemServicePlan__c> modemServicePlanRecords;
        Map<Id, Set<Id>> accountToDescendants; 

        public ExedePortalUserAccess()
        {
            accountsFromId = new Map<Id, Account>([SELECT Id, Name FROM Account limit 20]);
            accountsFromName = new Map<String, Account>();
            for (Account a : accountsFromId.values())
            {
                accountsFromName.put(a.Name, a);
            } 

            modemServicePlanRecords = new Map<Id, ModemServicePlan__c> ([SELECT Modem__r.Account__r.Name, ServicePlan__r.Account__r.Name FROM ModemServicePlan__c]);
            accountToDescendants = createMappingFromAccountToAllChildren();     
        }


        public void validateUser(SNGUser sngUser, User u)
        {
            User u1 = [SELECT Profile.Name, UserRole.Name, IsPortalEnabled FROM User WHERE Id = :u.id limit 1];
            system.assertEquals(sngUser.profileName, u1.Profile.Name);
            system.assertEquals(sngUser.roleName, u1.UserRole.Name);
            system.assertEquals(sngUser.isPortalUser, u1.isPortalEnabled);
        }

        public void testUserRecordAccess(User u, SNGUser sngUser, Map<RoleSObject, SNGRecordAccess> roleAccessMap, Set<String> sObjectNames)
        {
            for (String sObjectName : sObjectNames)
            {
                Map<Id, sObject> records = new Map<Id, sObject>(Database.query('SELECT Id, Account__c FROM ' + sObjectName));
                Set<Id> recordIds = records.keySet();

                String query = ' SELECT RecordId, HasReadAccess, ' +
                               ' HasEditAccess, HasDeleteAccess, ' +
                               ' HasTransferAccess, HasAllAccess FROM UserRecordAccess ' +
                               ' WHERE UserID = \'' + u.id + '\' AND RecordId = :recordIds';

                List<SObject> queryResult = Database.query(query);

                SNGRecordAccess accountMatchAccess = roleAccessMap.get(new RoleSObject(sngUser.roleName, sngUser.profileName, sObjectName, true));
                SNGRecordAccess accountMismatchAccess = roleAccessMap.get(new RoleSObject(sngUser.roleName, sngUser.profileName, sObjectName, false));
                
                System.assertNotEquals(null, accountMatchAccess);
                System.assertNotEquals(null, accountMismatchAccess);

                System.debug('YL SNGUser: ' + sngUser);
                System.debug('YL sObjectName: ' + sObjectName);

                for (SObject s : queryResult)
                {
                    SObject recordObject = records.get((Id)s.get('RecordId'));
                    
                    System.debug('YL recordId: ' + recordObject.Id);
                    System.debug('YL access: ' + s.get('HasReadAccess') + ' ' + s.get('HasEditAccess') + ' ' + s.get('HasDeleteAccess'));

                    //Object accountObject = recordObject.get('Account__c');
                    //Account account = (accountObject instanceof Id) ? accountsFromId.get((Id)recordObject.get('Account__c')) :
                    //                                                  accountsFromName.get((String)recordObject.get('Account__c'));

                    if (doesAccountMatch(recordObject, accountsFromId, accountsFromName, sngUser.accountName) || 
                        isAccountDescendantOfUserAccount(recordObject, accountsFromId, accountsFromName, sngUser.accountName, accountToDescendants) )
                    {         
                        System.assertEquals(accountMatchAccess.readAccess, (boolean)s.get('HasReadAccess'));
                        System.assertEquals(accountMatchAccess.editAccess, (boolean)s.get('HasEditAccess'));
                        System.assertEquals(accountMatchAccess.deleteAccess, (boolean)s.get('HasDeleteAccess'));
                        System.assertEquals(accountMatchAccess.transferAccess, (boolean)s.get('HasTransferAccess'));
                        System.assertEquals(accountMatchAccess.allAccess, (boolean)s.get('HasAllAccess'));
                    }
                    else
                    {
                        System.assertEquals(accountMismatchAccess.readAccess, (boolean)s.get('HasReadAccess'));
                        System.assertEquals(accountMismatchAccess.editAccess, (boolean)s.get('HasEditAccess'));
                        System.assertEquals(accountMismatchAccess.deleteAccess, (boolean)s.get('HasDeleteAccess'));
                        System.assertEquals(accountMismatchAccess.transferAccess, (boolean)s.get('HasTransferAccess'));
                        System.assertEquals(accountMismatchAccess.allAccess, (boolean)s.get('HasAllAccess'));                       
                    }
                }
            }
        }

        private Map<Id, Set<Id>> createMappingFromAccountToAllChildren()
        {
            Map<Id, Set<Id>> accountToAllChildren = new Map<Id, Set<Id>>();   
            Map<Id, Set<Id>> accountToChild = createAccountToDirectChildMapping();

            for (Id accountId : accountToChild.keySet())
            {
                Set<Id> accountChildren = findAllChildren(accountToChild, accountToChild.get(accountId));  
                accountToAllChildren.put(accountId, accountChildren);
            }

            return accountToAllChildren;
        }

        private Set<Id> findAllChildren(Map<Id, Set<Id>> accountToChild, Set<Id> accountIds)
        {
            Set<Id> endUserAccounts = accountIds;

            for (Id accountId : accountIds)
            {
                Set<Id> directChildAccounts = (accountToChild.containsKey(accountId)) ? accountToChild.get(accountId) : new Set<Id>();
                directChildAccounts = findAllChildren(accountToChild, directChildAccounts);
                endUserAccounts.addAll(directChildAccounts);
            }

            return endUserAccounts;
        }

        private Map<Id, Set<Id>> createAccountToDirectChildMapping()
        {
            Map<Id, Set<Id>> accountToChild = new Map<Id, Set<Id>>();
            Map<Id, Account> accounts =  new Map<Id, Account> ([SELECT Id, ParentId FROM Account Limit 20]);
            for (Account a : accounts.values())
            {
                if (null != a.ParentId)
                {
                     Set<Id> childAccounts = accountToChild.containsKey(a.ParentId) ? accountToChild.get(a.parentId) :
                                                                                      new Set<Id>();
                     childAccounts.add(a.Id);
                     accountToChild.put(a.parentId, childAccounts);
                }
            }

            return accountToChild;

        }

        private boolean isAccountDescendantOfUserAccount(SObject recordObject, 
                                                         Map<Id, Account> accountsFromId,  
                                                         Map<String, Account> accountsFromName, 
                                                         String userAccountName,
                                                         Map<Id, Set<Id>> accountToDescendant)
        {

            boolean retValue = false;

            if (accountsFromName.containsKey(userAccountName))
            {
                Account accountFromUserName = accountsFromName.get(userAccountName);
                Set<Id> descendantAccountIds = accountToDescendant.get(accountFromUserName.Id);

                if (null != descendantAccountIds)
                {
                    Account recordAccount = getAccountFromRecord(recordObject, accountsFromId, accountsFromName);
                    System.assert(null != recordAccount);
                    Id recordAccountId = recordAccount.Id;
                    retValue = descendantAccountIds.contains(recordAccountId);

                    System.debug('record account ID: ' + recordAccountId + '  accountToDescendant: ' + accountToDescendant);
                    System.debug('Account descendent of user account: ' + userAccountName + ' record account: ' + recordAccount.Name + ' retValue: ' + retValue);
                }
            }

            return retValue;
        }

        private boolean doesAccountMatch (SObject recordObject, Map<Id, Account> accountsFromId,  Map<String, Account> accountsFromName, String userAccountName)
        {
            /*
            Object accountObject = recordObject.get('Account__c');

            // account__c for an SObject is either a string (Modem/Service Plan) or a Id (Terminal, Modem, Service Plan). 
            // Based on what it is, use the proper extraction to match to the account object.
            Account account = (accountObject instanceof Id) ? accountsFromId.get((Id)recordObject.get('Account__c')) :
                                                              accountsFromName.get((String)recordObject.get('Account__c'));
            */

            Account account = getAccountFromRecord(recordObject, accountsFromId, accountsFromName);

            boolean retValue = account.Name == userAccountName;

            if (retValue)
            {
                if (recordObject instanceof ModemServicePlan__c)
                {
                    Id recordObjectId = (Id)recordObject.get('Id');
                    ModemServicePlan__c msp  = modemServicePlanRecords.get(recordObjectId);
                    System.assert(null != msp);
                    retValue = (userAccountName == msp.Modem__r.Account__r.Name && msp.ServicePlan__r.Account__r.Name == userAccountName);
                }
            }

            return retValue;
        }

        private Account getAccountFromRecord(SObject recordObject, Map<Id, Account> accountsFromId,  Map<String, Account> accountsFromName)
        {

            Object accountObject = recordObject.get('Account__c');

            // account__c for an SObject is either a string (Modem/Service Plan) or a Id (Terminal, Modem, Service Plan). 
            // Based on what it is, use the proper extraction to match to the account object.
            Account account = (accountObject instanceof Id) ? accountsFromId.get((Id)recordObject.get('Account__c')) :
                                                              accountsFromName.get((String)recordObject.get('Account__c'));

            return account;
        }

        public void testUserFieldSecurityLevel(User u, SNGUser user, List<FieldPermissions> fieldPermissionsList)
        {
            System.runAs(u)
            {
                for (FieldPermissions fp : fieldPermissionsList)
                {
                    // === Exact equality operator (references the exact same location in memory)
                    if (user === fp.user)
                    {
                        fp.testPermissionsAsUser();
                    }
                }
            }
        }
    }
    //--------------------------------------------------------
    // SNG inner classes - end helper classes
    //--------------------------------------------------------

}