/**************************************************************************************************************
Name         : ITSMSUtilityClass 
Created By   : Dianna Guilinger - Slalom 
Description  : Utility class for ITSMS Support Center 
             : Includes common methods for update/insert, select operations.  
***************************************************************************************************************/
public class ITSMSUtilityClass {

    //------------------------------------------------------------------------------------
    // get key values 
    //------------------------------------------------------------------------------------
    public static Map<String, ITSMSKeyValueStore__c> ITSMSSettings = ITSMSKeyValueStore__c.getall();
    
    //------------------------------------------------------------------------------------
    // Get Key Value1 from custom settings
    //------------------------------------------------------------------------------------
    public static string getFieldValue1(String name) { 
        try{
            return ITSMSSettings.get(name).Value1__c;
        }        
        catch(Exception e){ system.debug('@@ error getting ITSMS Key Value1:'+name+' error:'+e.getMessage());
            return null;
        }    
    }
    
    //------------------------------------------------------------------------------------
    // Get Key Value2 from custom settings
    //------------------------------------------------------------------------------------
    public static string getFieldValue2(String name) { 
        try{
            return ITSMSSettings.get(name).Value2__c;
        }        
        catch(Exception e){ system.debug('@@ error getting ITSMS Key Value2:'+name+' error:'+e.getMessage());
            return null;
        }    
    }
    
    //------------------------------------------------------------------------------------
    // Retrieve a map of knowledge articles from a certain area and section
    //------------------------------------------------------------------------------------    
    public static MAP<Id, ITSMS__kav> getITSMSKavs(String areaContext, String sectionContext, String publishStatusContext){
        
        String areaParameter = '';    
        String sectionParameter = '';        
        String publishStatusParameter = '';
        string articleLanguage = 'en_US';
        String queryString = ITSMSConstants.ARTICLE_QUERY;      

        if((areaContext != NULL)&&(areaContext != '')&&(areaContext != 'All')){            
            areaParameter = areaContext;
            queryString += ' AND Area__c =: areaParameter ';
        }
        if((sectionContext != NULL)&&(sectionContext != '')&&(areaContext!='All')){
            sectionParameter = sectionContext;
            queryString += ' AND Section__c =: sectionParameter '; 
        }
        if((publishStatusContext != NULL)||(publishStatusContext != '')){
            publishStatusParameter = publishStatusContext;
            queryString += ' AND PublishStatus =: publishStatusParameter ';
        }

        queryString += 'ORDER BY Sort_Order__c DESC';
             
        try{
            LIST<ITSMS__kav> articlesRetrieved = Database.query(queryString);
            if((articlesRetrieved != NULL)&&(articlesRetrieved.size() > 0)){
                MAP<Id, ITSMS__kav> KnowledgeStructureMap = new MAP<Id, ITSMS__kav>(articlesRetrieved);  
                for(ITSMS__kav a : KnowledgeStructureMap.values()){
                }
                return KnowledgeStructureMap;
            }else{
                MAP<Id, ITSMS__kav> KnowledgeStructureMap = new MAP<Id, ITSMS__kav>();
                return KnowledgeStructureMap;
            }
        }catch(Exception ex){System.debug(ex.getMessage()); return NULL;
        }
    }
    
    //------------------------------------------------------------------------------------
    // Create a list of ITSMS articles from a map of ITSMS articles
    //------------------------------------------------------------------------------------    
    public static LIST<ITSMS__kav> createArticleList(MAP<Id, ITSMS__kav> articleMap){

        LIST<ITSMS__kav> articleList = new LIST<ITSMS__kav>();
        if(articleMap != NULL){
            if(articleMap.values().size() > 0){ 
                articleList = articleMap.values(); 
            }
        }         
        
        return articleList;
    }       
    
    
    //------------------------------------------------------------------------------------
    // recursive check for completing a case
    //------------------------------------------------------------------------------------
    public static boolean hasCompleteAlreadyRun = false;
    public static boolean runCompleteCase(){
        if(!hasCompleteAlreadyRun ){
             hasCompleteAlreadyRun = true;
             return true;
        }else{
            return hasCompleteAlreadyRun;
        }
    }

    //------------------------------------------------------------------------------------
    // recursive check for validating parent case
    //------------------------------------------------------------------------------------
    public static boolean hasParentValidationAlreadyRun = false;
    public static boolean parentValidationRequired(){
        if(!hasParentValidationAlreadyRun ){
             hasParentValidationAlreadyRun = true;
             return true;
        }else{
            return hasParentValidationAlreadyRun;
        }
    }

    //------------------------------------------------------------------------------------
    // recursive check for updating delegate
    //------------------------------------------------------------------------------------
    public static boolean hasDelegateUpdateOccurred = false;
    public static boolean  delegateUpdateRequired(){
        if(!hasDelegateUpdateOccurred ){
             hasDelegateUpdateOccurred = true;
             return true;
        }else{
            return hasDelegateUpdateOccurred ;
        }
    }

    
    //------------------------------------------------------------------------------------
    // recursive check for parent close
    //------------------------------------------------------------------------------------
    public static boolean hasParentCloseCheckOccurred = false;
    public static boolean  parentCloseCheckRequired(){
        if(!hasParentCloseCheckOccurred ){
             hasParentCloseCheckOccurred = true;
             return true;
        }else{
            return hasParentCloseCheckOccurred ;
        }
    }

    //------------------------------------------------------------------------------------
    // recursive check for updating a case team
    //------------------------------------------------------------------------------------
    public static boolean hasTeamUpdateOccurred = false;
    public static boolean teamUpdateRequired(){
        if(!hasTeamUpdateOccurred){
             hasTeamUpdateOccurred = true;
             return true;
        }else{
            return hasTeamUpdateOccurred ;
        }
    }

    //------------------------------------------------------------------------------------
    // get case for specified id
    //------------------------------------------------------------------------------------
    public static Case getExistingCase (String caseQuery, String inputCaseId){
        try {
            list<Case> caseRecs = Database.query(caseQuery);
            return caseRecs[0];
        } catch (Exception e) { 
            system.debug('@@ error in get of existing case:'+e.getMessage()+' id:'+inputCaseId+' query:'+caseQuery);
            return null;}
    }
    
    //------------------------------------------------------------------------------------
    // get list of cases for provided id(s)
    //------------------------------------------------------------------------------------
    public static list<Case> getCases (String caseQuery, set<Id> caseIds){
        try {
            list<Case> caseRecs = Database.query(caseQuery);
            return caseRecs;
        } catch (Exception e) {
            system.debug('@@ error in get of cases:'+e.getMessage());
            return null;
        }
    }

    //------------------------------------------------------------------------------------
    // insert/update single case
    //------------------------------------------------------------------------------------
    public static boolean upsertCase (Case caseRec){
        boolean isUpserted = true;
        try {
            upsert caseRec;
        } catch(exception e) { 
             system.debug('@@ error on upsert of case - upsertCase:'+e.getMessage()); 
             ApexPages.addMessages(e);
             isUpserted = false;}
        return isUpserted;
    }
   
    //------------------------------------------------------------------------------------
    // insert a list of cases
    //------------------------------------------------------------------------------------
    public static void insertCases (list<Case> cases){
        try {
            insert cases;
        } catch(exception e) {system.debug('@@ error in insert of cases:'+e.getMessage()); }
    }
    
    //------------------------------------------------------------------------------------
    // update a list of cases
    //------------------------------------------------------------------------------------
    public static void updateCases (list<Case> cases){
        try {
            update cases;
        } catch(exception e) {system.debug('@@ error in update of cases:'+e.getMessage());}
       
    }

    //------------------------------------------------------------------------------------
    // check if related cases exist for the case
    //------------------------------------------------------------------------------------
    public static boolean relatedCasesExist (Case thisCase){
        boolean relatedCasesExist = false;
        string caseId = thisCase.Id;
        String soql = 'SELECT Id, CaseNumber FROM Case where ParentId = :caseId';
        list<Case> relatedCases = Database.query(soql);
        if (relatedCases.size() > 0)
            relatedCasesExist = true;
        return relatedCasesExist;
    }

    //------------------------------------------------------------------------------------
    // check if email messages exist for the case
    //------------------------------------------------------------------------------------
    public static boolean relatedEmailsExist (Case thisCase){
        boolean relatedEmailsExist = false;
        string caseId = thisCase.Id;
        String soql = 'SELECT Id, ParentId FROM EmailMessage  where ParentId = :caseId';
        list<EmailMessage> relatedEmails = Database.query(soql);
        if (relatedEmails.size() > 0)
            relatedEmailsExist = true;
        return relatedEmailsExist;
    }
        
    //------------------------------------------------------------------------------------
    // get list of contacts
    //------------------------------------------------------------------------------------
    public static list<Contact> getContacts (String contactQuery, set<string> queryList){
        try {
            list<Contact> contactRecs = Database.query(contactQuery);
            return contactRecs;
        } catch (Exception e) {
            return null;
        }
    }

    //------------------------------------------------------------------------------------
    // get requestor User information 
    //------------------------------------------------------------------------------------
    public static User getRequestor (Case thisCase){
        // first time this will default requestor to logged in user
        string requestorId = UserInfo.getUserId();
        // will use requested for user if entered
        if (thisCase != null && thisCase.RequestingForUser__c != null)
            requestorId = thisCase.RequestingForUser__c;        
        User requestUser = Database.query(ITSMSConstants.REQUESTOR_QUERY+' = :requestorId');
        return requestUser;
    }

        
    //------------------------------------------------------------------------------------
    // get requestor Contact information 
    //------------------------------------------------------------------------------------
    public static Contact getRequestorContact (User reqUser){
        if (reqUser.Email != null)
        {
            string reqEmail = reqUser.Email;
            string reqUserId = reqUser.Id;
            string rtITSMS = Schema.SObjectType.Contact.RecordTypeInfosByName.get(ITSMSConstants.CONTACT_RECORDTYPE).RecordTypeId;
            list<Contact> requestContact = Database.query(ITSMSConstants.REQUESTOR_CONTACTQUERY);
            if (requestContact.size() >0)
            {
                return requestContact[0];
            } else
                return null;
        } else 
            return null;
    }
 
    //------------------------------------------------------------------------------------
    // create parent support case to allow cases to be displayed as a group in UI
    //------------------------------------------------------------------------------------
    public static Case createParentCase (String inputSupportCategory){
        Case parentCase = new Case (Origin = ITSMSConstants.CASE_ORIGIN, RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId,
                                    Type = ITSMSConstants.CASE_TYPE_REQUEST, ServiceRequestType__c = ITSMSConstants.SUPPORT_SRVREQTYPE_PARENT,
                                    Status = ITSMSConstants.CASE_STATUS_PRESUBMIT,
                                    SupportCategory__c = inputSupportCategory, Requestor__c = UserInfo.getUserId(), Subject = ITSMSConstants.SUPPORT_SRVREQTYPE_PARENT);
        try {
            
            insert parentCase;
            return parentCase;
        } catch (Exception e) { system.debug('@@ error on insert of case - createParentCase:'+e.getMessage()); return null;}
    }

    //------------------------------------------------------------------------------------
    // initialize base case for Support request
    //------------------------------------------------------------------------------------
    public static Case createCase (String inputCategory, String srvReqType){
        Case newCase = new Case (Origin = ITSMSConstants.CASE_ORIGIN, RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(ITSMSConstants.CASE_RECORDTYPE).RecordTypeId,
                                    Type = ITSMSConstants.CASE_TYPE_REQUEST, ServiceRequestType__c = srvReqType, Status = ITSMSConstants.CASE_STATUS_PRESUBMIT, NewHireType__c = 'None',
                                    SupportCategory__c = inputCategory, Requestor__c = UserInfo.getUserId());
        return newCase;
    }

    //------------------------------------------------------------------------------------
    // presubmitted case is being deleted
    //------------------------------------------------------------------------------------
    public static boolean deleteCase (Case thisCase){
        boolean isDeleted = true;
        try {
            delete thisCase;
        } catch(exception e) { 
             ApexPages.addMessages(e);
             isDeleted = false;}
        return isDeleted;
    }

    //------------------------------------------------------------------------------------
    // create an additional case for the request
    //------------------------------------------------------------------------------------
    public static Case setupNewCaseRec (Case thisCase){
        Case anotherCase = ITSMSUtilityClass.createCase(thisCase.SupportCategory__c, thisCase.ServiceRequestType__c);
        // set selected fields to same as other cases on request    
        anotherCase.RequestingForUser__c = thisCase.RequestingForUser__c; 
        anotherCase.CustomerPriority__c = thisCase.CustomerPriority__c;
        anotherCase.IssueOrRequest__c = thisCase.IssueOrRequest__c; 
        anotherCase.parentId = thisCase.ParentId; 
        // if mobility then set shared fields
        anotherCase.Date_Needed_By__c = thisCase.Date_Needed_By__c;
        anotherCase.DeptVP__c = thisCase.DeptVP__c;
        anotherCase.CostCenterNumber__c = thisCase.CostCenterNumber__c;
        return anotherCase;
    }  
    
    //------------------------------------------------------------------------------------
    // update list of cases capturing validation errors for UI
    //------------------------------------------------------------------------------------
    public static map<Integer, String> validateAndUpdateCases (list<Case> cases){
        map<Integer, String> errorRows = new map<Integer, String> ();
        try {
            update cases;
        } catch (DmlException e) {
            ApexPages.addMessages(e);
            for (integer i = 0; i < e.getNumDML(); i++) 
            {
                errorRows.put(e.getDmlIndex(i), e.getDMLMessage(i));
            }
        }
        return errorRows;
    }
    //------------------------------------------------------------------------------------
    // get case team roles 
    //------------------------------------------------------------------------------------
    static public map<string,CaseTeamRole> getCaseTeamRoles() 
    {      
        map<string, CaseTeamRole> caseTeamRoles = new map<string, CaseTeamRole>();
        String soql = 'SELECT Id, Name FROM CaseTeamRole';
        list<CaseTeamRole> roles = Database.query(soql);
        if (roles != null && roles.size() > 0)
        {       
            for(CaseTeamRole r : roles)
            {
                caseTeamRoles.put(r.Name,r);
            }
        }
        return caseTeamRoles;
    }
    //------------------------------------------------------------------------------------
    // insert a case team
    //------------------------------------------------------------------------------------
    public static void insertCaseTeam (list<CaseTeamMember> caseTeamMembers){
        try {
            upsert caseTeamMembers;
        } catch(exception e) { system.debug('@@ error occurred on insert of case team members:'+e.getMessage());}
    }
    //------------------------------------------------------------------------------------
    // get list of case teams
    //------------------------------------------------------------------------------------
    static public list<CaseTeamMember> getCaseTeam (set<Id> caseIds){

        String soql = 'SELECT Id, ParentId, MemberId, TeamRoleId FROM CaseTeamMember where ParentId = :caseIds';
        list<CaseTeamMember> caseTeams = Database.query(soql);
        return caseTeams;
    }
    //------------------------------------------------------------------------------------
    // get case teams as map
    //------------------------------------------------------------------------------------
    static public map<Id, List<CaseTeamMember>> getCaseTeamMap (set<Id> caseIds){

        list<CaseTeamMember> caseTeams = getCaseTeam(caseIds);
        
        Map<Id, List<CaseTeamMember>> m = new  Map<Id, List<CaseTeamMember>>();
        for (CaseTeamMember c : caseTeams )
        {
            if (m.containsKey(c.ParentId))
            {
                m.get(c.ParentId).add(c);
            } else {
                list <CaseTeamMember> teamList = new list <CaseTeamMember> ();
                teamList.add(c);
                m.put(c.ParentId,teamList);
                
            }
        }

        return m;
    }
    //------------------------------------------------------------------------------------
    // delete case teams
    //------------------------------------------------------------------------------------
    static public void deleteCaseTeam (list<CaseTeamMember> caseTeams){

        try {
            delete caseTeams;
        } catch (DmlException e) {system.debug('@@ error in deleting case teams:'+e.getMessage());}
    }
    //------------------------------------------------------------------------------------
    // check if user is already on case team
    //------------------------------------------------------------------------------------
    static public boolean userOnCaseTeam (Id caseId, Id teamMember, map<Id, list<CaseTeamMember>> currentTeams){
        boolean userIsOnTeam = false;
        if (currentTeams.containsKey(caseId) )
        {
            for (CaseTeamMember ctm: currentTeams.get(caseId))
            {
                if (ctm.MemberId == teamMember)
                    userIsOnTeam = true;
            }
        }
        return userIsOnTeam;
    }
    //------------------------------------------------------------------------------------
    // get entitlement record
    //------------------------------------------------------------------------------------
    public static Entitlement getEntitlement (String entitlementName){
        if (entitlementName != null)
        {
            list<Entitlement> ent = Database.query(ITSMSConstants.ENTITLEMENT_QUERY);
            if (ent.size() >0)
            {
                return ent[0];
            } else
                return null;
        } else 
            return null;
    }
    //------------------------------------------------------------------------------------
    // get user record
    //------------------------------------------------------------------------------------
    public static User getUser (string userId){
        User thisUser = new User ();
        if (userId != null)
            thisUser = Database.query(ITSMSConstants.USER_QUERY);
        return thisUser;
    }
    //------------------------------------------------------------------------------------
    // update delegate for user 
    //------------------------------------------------------------------------------------
    public static boolean updateDelegate (User thisUser){
        boolean isUpdated = true;
        try {
            update thisUser;
        } catch(exception e) { 
            isUpdated = false;
            system.debug('@@ error occurred on update of user:'+e.getMessage());}
        return isUpdated;
    }
    //------------------------------------------------------------------------------------
    // format user matrix data for specified record type 
    //------------------------------------------------------------------------------------
    public static string formatUserAccess (string recordTypeName, Case caseRec){
        string userAccess = '';
        string recordType = Schema.SObjectType.ITSMSPermission__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        string caseId = caseRec.Id;
        string strQuery = ITSMSConstants.PERMISSIONS_QUERY; 
        try {
            list <ITSMSPermission__c> permissions = Database.query(strQuery);
            if (permissions.size() > 0)
            {
                for (ITSMSPermission__c p:permissions)
                {
                    userAccess += p.User__r.FirstName+' '+p.User__r.LastName+' - ';
                    if (p.AddMember__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_ADDMEMBER;
                    if (p.AddToGroup__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_ADDTOGROUP;
                    if (p.AgileAccessLevel__c != null)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_AGILE + ' '+ p.AgileAccessLevel__c;
                    if (p.FullAccess__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_FULLACCESS;
                    if (p.ManagingMember__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_MANAGINGMEMBER;
                    if (p.OracleASCPResponsibilities__c != null)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_ORACLEASCP + ' '+ p.OracleASCPResponsibilities__c;
                    if (p.OracleEBSResponsibilities__c != null)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_ORACLEEBS + ' '+ p.OracleEBSResponsibilities__c;
                    if (p.OracleOBIEEResponsibilities__c != null)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_ORACLEOBIEE + ' '+ p.OracleOBIEEResponsibilities__c;
                    if (p.POCMember__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_POCMEMBER;
                    if (p.ReadOnly__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_READONLY;
                    if (p.ReadWriteModify__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_READWRITEMODIFY;
                    if (p.RemoveAccess__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_REMOVEACCESS;
                    if (p.RemoveFromGroup__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_REMOVEFROMGROUP;
                    if (p.RemoveMember__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_REMOVEMEMBER;
                    if (p.RemoveRead__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_REMOVEREAD;
                    if (p.RemoveWriteModify__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_REMOVEWRITEMODIFY;
                    if (p.ResetPassword__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_RESETPASSWORD;
                    if (p.SendAs__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_SENDAS;
                    if (p.SendOnBehalf__c)
                        userAccess += ITSMSConstants.PERMISSIONS_DESC_SENDONBEHALF;
                    userAccess += '<br>';
                }
            }
        } catch(exception e) { system.debug('@@ error occurred on select of permissions:'+e.getMessage());}
        return userAccess; 
        return null;
    }
    
    //------------------------------------------------------------------------------------
    // get Picklist values for specified object field
    //------------------------------------------------------------------------------------
    /*public static list<SelectOption> getPicklistValues(SObject obj, String field, String defaultValue, String defaultLabel){
      List<SelectOption> options = new List<SelectOption>();      
      Schema.sObjectType objType = obj.getSObjectType(); 
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      
      List<Schema.PicklistEntry> values =
      fieldMap.get(field).getDescribe().getPickListValues();
     
      options.add(new SelectOption(defaultValue,defaultLabel));
      for (Schema.PicklistEntry a : values)
      { 
         options.add(new SelectOption(a.getLabel(), a.getValue())); 
      }
      return options;
   }      
    */
     
    //------------------------------------------------------------------------------------
    // Insert Access & Permission record for Case
    //------------------------------------------------------------------------------------        
    public static boolean insertPermission (list<ITSMSPermission__c> lstPermissionsToInsert){
        boolean isInserted = true;
        try{
            insert lstPermissionsToInsert;
        } catch (Exception e){ system.debug('@@ error in insert:'+e.getMessage()); isInserted = false;}
        return isInserted;
    }    

    //------------------------------------------------------------------------------------
    // Retrieve picklist values from an object
    //------------------------------------------------------------------------------------        
    
	public static list<SelectOption> getPicklistValues(SObject obj, String field){
      List<SelectOption> options = new List<SelectOption>();      
      Schema.sObjectType objType = obj.getSObjectType(); 
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      
      List<Schema.PicklistEntry> values = fieldMap.get(field).getDescribe().getPickListValues();
     
      for (Schema.PicklistEntry a : values){ 
         options.add(new SelectOption(a.getLabel(), a.getValue())); 
      }
      return options;
   	}      

    //------------------------------------------------------------------------------------
    // Retrieve record types
    //------------------------------------------------------------------------------------        
    
	public static string getObjectRecordTypeId(SObjectType sObjectType, String asRecordTypeName){
        try {
            //Generate a map of tokens for all the Record Types for the desired object
            Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();
            //Retrieve the record type id by name
            return recordTypeInfo.get(asRecordTypeName).getRecordTypeId();
        } catch (Exception e) {
            return null;
        }
    }  
}