public with Sharing class TestPageRenderingController{

    public string internalAccountReference{get;set;}
    public string internalServiceAgreement{get;set;}
    public string externalAccountReference{get;set;}
    public string provisioningStatus{get;set;}
    public string billingStatus{get;set;}
    public string primaryPhone{get;set;}
    public string email{get;set;}
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string Nickname{get;set;}
    public integer subscriberCount{get;set;}
    public string loginUserName{get;set;}
    public string sfdcLoginUsername{get;set;} 
    public string packageName{get;set;}
    public string status{get;set;}
    public integer sprSubscriberCount{get;set;}
    public boolean securityQuestions{get;set;}
    public string sfdcAccountName{get;set;}
    public string sfdcContactName{get;set;}
    public string sfdcUserName{get;set;}
    public Long subKey{get;set;}
    public string macAddress{get;set;}
    public boolean userNameExist{get;set;}
    public boolean isUserExist{get;set;}
    public boolean isAccExist{get;set;}
    public boolean isContactExist{get;set;}
    public boolean issprstatusactive{get;set;}
    public boolean isProvStatusActive{get;set;}
    public boolean Subscribercountspr{get;set;}
    public boolean SubcountBackOffice{get;set;}
    public boolean SPRSFDCUname{get;set;}
    public boolean Unamematches{get;set;}
    public boolean isEmailNull{get;set;} 
    public boolean isSFDCUnameExists{get;set;}   
    public string errorMessage{get;set;}
    public static Id accountId;
    public boolean isGrey{get;set;}
    public boolean button1{get;set;}
    public boolean button2{get;set;}
    public boolean button3{get;set;}
    public boolean button4{get;set;}
    public string sprmsg1{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_clearSPR1);}set;}
    public string sprmsg2{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_clearSPR2);}set;}
    public string msg2{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_InvalidAcc);}set;}
    public string sfdcmsg1{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_CreateSFDC1);}set;}
    public string sfdcmsg2{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_CreateSFDC2);}set;}
    public string register{get{return AtlasUtility.getMapValue(Atlasconstants.CustomerStatus_ReRigister);}set;}
    public string stripCharacters{get{return AtlasUtility.getMapValue(AtlasConstants.Disallowed_New_User_Special_Characters);}set;}
    public string emailDomain{get{return AtlasUtility.getMapValue(AtlasConstants.New_User_Email_Domain);}set;}
    public static string internacc;
    public List<string> readOnlyList{get;set;}
    public List<string> readEditList{get;set;}
    public string commaSepratedList{get;set;} 
    
    
    public class permissions {
        public boolean edit{get;set;}
        public boolean visible{get;set;}
                  
        public permissions(boolean edit,boolean visible) {
            this.edit = edit;
            this.visible = visible;           
         }    
    }
    public Map<String,permissions> permissionsMap {get;set;}
    // Constructor
    public TestPageRenderingController()
    {
        
        internalAccountReference = '302280722';
        firstName = 'test';
        internalServiceAgreement = '1231231234';
        lastName = 'testLastname';
        externalAccountReference= '123123123';
        email= 'test@test.com';
        subKey= 123123;
        primaryPhone= '123-123-1234';
        packageName= 'Exede Plan';
        macAddress= 'test Mac';
        loginUsername= 'uname';
        sfdcloginusername = 'sfdc uname';
        
        readOnlyList = new List<string>();
        readEditList = new List<string>();
        permissionsMap = new Map<String,permissions>();
        string profileId = Userinfo.getProfileId();      
        List<FieldPermissions> permsnList = [SELECT Id,Parent.Name, Field, SObjectType, PermissionsRead, PermissionsEdit FROM FieldPermissions WHERE parentid in (select id from permissionset where PermissionSet.Profile.Id=:profileId ) AND SObjectType = 'TestPageRenderingObject__c'];
        
        Map<String, Schema.SObjectField> Mapfields = Schema.SObjectType.TestPageRenderingObject__c.fields.getMap();
        for(SObjectField fName : Mapfields.values()) {            
            String name = fName.getDescribe().getName();
            system.debug('---name ---> '+name);
            permissions pr1 = new permissions(false,false);
            permissionsMap.put(name,pr1);            
        }
              
        for(FieldPermissions perm:permsnList ) {
            String strfield = perm.Field;
                String[] myArr12 = strfield.split('\\.');
                String strfieldId;
                if(myArr12.size()>0){ strfieldId= myArr12[1]; }
            permissions pr2 = new permissions(perm.PermissionsEdit,perm.PermissionsRead);
            system.debug('---strfieldId--- ' + strfieldId);
            
            if(permissionsMap.containsKey(strfieldId)) {
                system.debug('---map contains key---'); 
                permissionsMap.remove(strfieldId);
                permissionsMap.put(strfieldId,pr2);  
            }      
            else {
                system.debug('---map doesnt contains key---' + strfieldId);
                permissionsMap.put(strfieldId,pr2);  
            } 
           
        }       
        system.debug('---permissionsMap---> '+permissionsMap.keySet());
    }
    
   
   
    //clear all fields
    public pagereference clearFields()
    {
        internalServiceAgreement='';
        externalAccountReference='';
        //internalAccountReference='';
        provisioningStatus='';
        billingStatus='';
        primaryPhone='';
        email='';
        firstName='';
        lastName='';
        subscriberCount=null;
        macAddress='';
        subKey=null;
        sprSubscriberCount=null;
        packageName='';
        loginUsername='';
        sfdcLoginUsername='';
        userNameExist=false;
        status='';
        Subscribercountspr=false;
        SubcountBackOffice=false;
        issprstatusactive=false;
        isProvStatusActive=false;
        securityQuestions=false;
        isUserExist=false;
        isAccExist=false;
        isContactExist=false;
        SPRSFDCUname=false;
        Unamematches=false;
        isEmailNull=false;
        isSFDCUnameExists=false; 
        return null;
    }   
    public void buttonaction() {

    }
}