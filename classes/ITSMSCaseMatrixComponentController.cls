/*
 * Class ITSMSCaseMatrixComponentController
 * 
 * @version 0.1
 * @author  Dianna Guilinger - Slalom 
 * 
 *  Controller for the Matrix custom component 
 */
public with sharing class ITSMSCaseMatrixComponentController extends ITSMSComponentControllerBase {
    public String recordTypeName {get; set;}
    public String theFieldSetName {get; set;}
    public Integer intNumberOfRows {get; set;}
    private String strQuery;
    
    private list<ITSMSPermission__c> lstPs {get;set;}
    public list<ITSMSPermission__c> lstPermissions {
        get{
            if (lstPs == null)
            {
                lstPs = new list<ITSMSPermission__c>();
                for (Integer i=0; i < intNumberOfRows; i++){
                    lstPs.add(new ITSMSPermission__c());
                }
            }
            return lstPs;
        } 
        set;
    }
    
    private list<permissionWrapper> lstPWs {get;set;}
    public list<permissionWrapper> lstSavedPermissions {
        get{
        	lstPWs = new list<permissionWrapper>();
            createDynamicQuery(theFieldSetName); 
            system.debug('@@ permissions query:'+strQuery);
            for (ITSMSPermission__c p: Database.query(strQuery)){
            	lstPWs.add(new permissionWrapper(p));
            }
            return lstPWs;     
        } 
        set;
    }
    
   
    // This method creates a dynamic SOQL query based on the field set name
    private void createDynamicQuery(String strFieldSetName){
        Schema.SObjectType targetObjectType = Schema.getGlobalDescribe().get('ITSMSPermission__c');
        strQuery = 'SELECT ';
        if (!Test.isRunningTest() && strFieldSetName != null){
            for(Schema.FieldSetMember f : SObjectType.ITSMSPermission__c.FieldSets.getMap().get(strFieldSetName).getFields() ) {
                strQuery += f.getFieldPath() + ', ';
            }
        } else{
            // Running unit test, therefore the field set may not be available in a new org
            // Add the user and readonly field for testing
            strQuery += ITSMSConstants.PERMISSIONS_FIELDS;
        }
        strQuery += ' Id FROM ITSMSPermission__c ';
        if (caseRec != null && caseRec.Id != null)
        {
        	strQuery += ' WHERE Case__c = \'' +  + caseRec.id + '\'';
    		if (recordTypeName != null)
        		strQuery += ' AND RecordTypeId = \'' + ITSMSUtilityClass.getObjectRecordTypeId(targetObjectType, recordTypeName) + '\'';    
        }
    }
    
    // This method checks if access for user was previously saved
    private boolean checkIfSelected(string userSelected){
        boolean userWasSelected = false;
        for (permissionWrapper p:lstSavedPermissions)
        {
            if (p.permission.User__c == userSelected)
                userWasSelected = true;
        }
        return userWasSelected;
    }
    
    // Save action
    public PageReference savePermission() {  
        
        list<ITSMSPermission__c> lstPermissionsToInsert = new list<ITSMSPermission__c>();
        boolean errorFound = false;
        for ( ITSMSPermission__c p : lstPermissions){
            if (p.User__c != null && caseRec.id != null) {
                boolean userWasSelected = checkIfSelected(p.User__c);
                if (userWasSelected)
                {
                    //  error message
                    errorFound = true;
                    p.User__c.addError(ITSMSConstants.PERMISSIONS_ERROR_USER);
                } else {
                    // set the case id
                    p.Case__c = caseRec.id;
                    // set the record type
                    p.recordtypeId = Schema.SObjectType.ITSMSPermission__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
                    lstPermissionsToInsert.add(p);          
                }
            }       
        }
        
        if ( !(lstPermissionsToInsert.isEmpty()) && !errorFound){
            boolean isInserted = ITSMSUtilityClass.insertPermission(lstPermissionsToInsert);
           
			if (isInserted)			
            {
                // Clear the list of permission to refresh
            	lstPs = null; 
            	// Also, clear the list of saved permissions to refresh
            	lstPWs = null;
            }
        }
        
        // Remain on the same page
        return null;
    }
    
    // DeleteSelected method deletes the user selected saved permissions    
    public PageReference DeleteSelectedPermission() {  
        
        list<ITSMSPermission__c> lstPermissionsToDelete = new list<ITSMSPermission__c>();
        
        for ( permissionWrapper pw : lstSavedPermissions){
            if (pw.selected == true) {
                lstPermissionsToDelete.add(pw.permission);          
            }   
        }
    
        if ( !(lstPermissionsToDelete.isEmpty()) ){
            try{
                delete lstPermissionsToDelete;
            } catch (Exception e){system.debug('@@ error in insert:'+e.getMessage()); return null;
            }
            // Clear the lstPWs to get a new list from the database after delete
            lstPWs = null; 
        }
        
        // Remain on the same page after delete
        return null;
    }
    
    // This wrapper inner class is used for displaying and deleting saved permissions 
    public class permissionWrapper {
        public ITSMSPermission__c permission {get; set;}
        public Boolean selected {get; set;}

        // Constructor
        public permissionWrapper(ITSMSPermission__c p) {
            permission = p;
            selected = false;
        }
    } 
        
}