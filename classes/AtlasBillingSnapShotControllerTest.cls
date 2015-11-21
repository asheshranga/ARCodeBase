@isTest
public class AtlasBillingSnapShotControllerTest
{
    static void createCommunityUser(){
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        Account acc = new Account ( Name = 'dummtyTestAcc');  
        insert acc;
        System.assert(acc.Name=='dummtyTestAcc');
        Contact con = new Contact ( AccountId = acc.id, LastName = 'portalTestUser' );
        insert con;
        System.assert(con.LastName=='portalTestUser'); 
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.assertEquals(UserInfo.getUserId(),thisUser.id);
        System.runAs ( thisUser ) {
                UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
                Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
                User newUser = new User(
                    UserRoleId = ur.Id,
                    profileId = p.id,
                    username = 'dummtyTestUser@visasat.com',
                    email = 'dummtyTestUser@visasat.com',
                    emailencodingkey = 'UTF-8',
                    localesidkey = 'en_US',
                    languagelocalekey = 'en_US',
                    timezonesidkey = 'America/Los_Angeles',
                    alias='nuser',
                    lastname='lastname',
                    contactId = con.id
                 );
                insert newUser;  
                System.assertEquals(newUser.username,'dummtyTestUser@visasat.com');
            }
    }
    
    static void createDataForEachTest()
    {
		AtlasTestMainClass.setTestKeyValueStoreForAtlas();
        //createCommunityUser();
        List<AtlasWebserviceSetting__c>webList=(List<AtlasWebserviceSetting__c>)JSON.deserialize(AtlasTestConstants.getMetadata('ATLAS_WEBSERVICE_SETTINGS'),List<AtlasWebserviceSetting__c>.class);
        for(AtlasWebserviceSetting__c wTemp:webList)
        wTemp.Id=null;
        insert webList;
        
        List<AtlasVfPageLinks__c>vfLinkList=(List<AtlasVfPageLinks__c>)JSON.deserialize(AtlasTestConstants.getMetadata('VF_PAGE_LINK'),List<AtlasVfPageLinks__c>.class);
        for(AtlasVfPageLinks__c vTemp:vfLinkList)
        vTemp.Id=null;
        insert vfLinkList;
        
        List<AtlasBillingStatesList__c>billList=(List<AtlasBillingStatesList__c>)JSON.deserialize(AtlasTestConstants.getMetadata('BILLING_STATE_LIST'),List<AtlasBillingStatesList__c>.class);
        for(AtlasBillingStatesList__c vTemp:billList)
        vTemp.Id=null;
        insert billList;
        
        List<AtlasKeyValueStore__c>keyList=(List<AtlasKeyValueStore__c>)JSON.deserialize(AtlasTestConstants.getMetadata('KEY_VAL_STORE'),List<AtlasKeyValueStore__c>.class);
        for(AtlasKeyValueStore__c vTemp:keyList)
        vTemp.Id=null;
        insert keyList;
        
        List<AtlasSSOWebserviceSetting__c>webList1=(List<AtlasSSOWebserviceSetting__c>)JSON.deserialize(AtlasTestConstants.getMetadata('ATLAS_SSO_WEBSERVICE_SETTINGS'),List<AtlasSSOWebserviceSetting__c>.class);
        for(AtlasSSOWebserviceSetting__c wTemp:webList1)
        wTemp.Id=null;
        insert webList1;
    }
    @isTest
    static void testBilling()
    {
        createDataForEachTest();
        AtlasBillingSnapShotDTO snap = new AtlasBillingSnapShotDTO(); 
        //AtlasBillingSnapShotDTO bssDTOObj=snap.bssDTO;
        snap.paymentDate=system.now();
        snap.strPaidDateString = string.valueof(system.now());
        string header = snap.strPaidDateString;
        snap.paymentDate=null;
        snap.strPaidDateString = string.valueof(system.now());
        header = snap.strPaidDateString;
        snap.nextBillDate=null;
        snap.strDueDate = string.valueof(system.now());
        header = snap.strDueDate;
        snap.nextBillDate=system.now();
        snap.strDueDate = string.valueof(system.now());
        header = snap.strDueDate;
        //isPymentFailed
        snap.isPymentFailed=true;
        snap.strColor='red';
        header=snap.strColor;
        snap.isPymentFailed=false;
        snap.strColor='red';
        header=snap.strColor;
    }
}