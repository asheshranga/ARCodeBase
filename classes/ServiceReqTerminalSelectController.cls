/*********************************************************************************
Name         : ServiceReqTerminalSelectController
Created By   : Anand Sanjeev
Company Name : Slalom Consulting
Created Date : 09/2/2015
Modified Date: 09/22/2015 - Changes to handle more than one site record type
11/03/2015 - Changes for case 582979	
Usages       : Handle class for ServiveReqTerminalSelect page

This class would contain the logic to search and return sites and also creation of
junction records between service request and sites.
*********************************************************************************/
public with sharing class ServiceReqTerminalSelectController{
    
    public Site__c sSite {get;set;}
    public String typeOfSite{get;set;}
    public static final String SUCCESS = 'SUCCESS';    
    public static final String AVIATION_GOV_RT = 'Aviation_GOV';
    public static final String TERMINAL_RT = 'Terminal';
    public static final String SR_OBJ = 'ServiceRequestSite__c';
    
    public List<String> listOfFieldsToDisplay{get;set;}
    public Map<String,String> mapOfFieldNameToLabel{get;set;}
    public Map<String,Schema.DisplayType> mapOfFieldNameToType{get;set;}
    public String mapOfFieldNameToLabelJSON {get{return JSON.serialize(mapOfFieldNameToLabel);}}
    public String listOfFieldsToDisplayJSON {get{return JSON.serialize(listOfFieldsToDisplay);}}
    
    public String siteRecTypes{get;set;}
    public String avlStatus{get;set;}
    
    public ServiceReqTerminalSelectController(ApexPages.StandardController stdController)
    {   
        listOfFieldsToDisplay = new List<String>();
        mapOfFieldNameToLabel = new Map<String,String>();
        mapOfFieldNameToType = new Map<String,Schema.DisplayType>();    
        Service_Request__c sr = (Service_Request__c)stdController.getRecord();
        
        typeOfSite = Apexpages.currentpage().getparameters().get('type');
        
        
        RecordType srRt = [select id, developerName from RecordType where id = : sr.recordTypeId];
        
        //11/3 : Change for case 582979
        String csKey = '';
        if(typeOfSite == null)
            csKey = TERMINAL_RT;
        else
            csKey = typeOfSite;
        
        //Get the corresponding mapping record for the service request record type from the custom setting
        ServReqRTToSiteRTMap__c csMap= ServReqRTToSiteRTMap__c.getInstance(csKey);
        
        String siteRecTypesNames;        
        //Check if the mapping for this record type is defined
        if(csMap !=null )
        {
            siteRecTypesNames = csMap.Site_Record_Types_Avl__c;
            avlStatus = csMap.AllowedStatus__c;
            getFieldsToDisplay(csMap.FieldSetToDisplay__c);            
        }
        
        System.debug('****************** listOfFieldsToDisplay : ' + listOfFieldsToDisplay);         
        
        //Incase the custom setting is not setup correctly, use avaition-gov as default
        if(siteRecTypesNames == null)
            siteRecTypesNames = AVIATION_GOV_RT;
        
        
        List<String> recTypeList = siteRecTypesNames.split(';');
        
        //Since the sforce describe call in the page does not return the developer names, we need the ids.
        for(RecordType r :  [select id from RecordType where developerName IN: recTypeList])
        {
            if(siteRecTypes == null)
                siteRecTypes = r.id;
            else
                siteRecTypes = siteRecTypes + ';' + r.id;   
        }
    }
    
    //This method will create the juntion object records between the
    //service request and the selected sites.
    @RemoteAction 
    public static String addSitesToSR(String srId, String rtName, List<String> siteIdList)
    {
        List<ServiceRequestSite__c> listToInsert  = new List<ServiceRequestSite__c>();
        
        RecordType rt = [Select id from RecordType where developerName = :rtName and sobjecttype = :SR_OBJ limit 1];
        
        Schema.DescribeSObjectResult dsr = ServiceRequestSite__c.getSObjectType().getDescribe();
        for(String siteId : siteIdList)
        {
            ServiceRequestSite__c srs = new ServiceRequestSite__c();
            srs.ServiceSite__c =  siteId;
            srs.ServiceRequest__c = srId;
            srs.recordTypeId = rt.id;
            listToInsert.add(srs);
        }
        
        try{
            insert listToInsert;
        }
        catch(System.DmlException e) {            	
            return e.getDmlMessage(0);
        }
        
        catch(exception e)
        {
            ViasatLogHandler.Log(AtlasConstants.SF_ORG_NAME, ViasatLogHandler.SeverityTypeEXCEPTION,'ServiceReqTerminalSelectController: addSitesToSR',e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));	
            return e.getMessage();
        }
        
        return SUCCESS;
    }
    
    //This method is to just initialise the datatable on the page
    @RemoteAction 
    public static List<Site__c> InitList()
    {
        List<Site__c> siteList = new List<Site__c>();
        return siteList;
    }
    
    //This method will search for the terminals based on the search inputs passed
    //and return the result set to the page.
    @RemoteAction 
    public static List<Map<String,String>> searchForTerminals(List<String> listOfFieldsToDisplay,
                                                   String srId, 
                                                   String siteRecTypesAvl,                                                   
                                                   String allowedStatuses,     
                                                   String pSiteName,
                                                   String pAltSiteName,
                                                   String pIpAdd,
                                                   String pPgm )
    {
        List<Map<String,String>> sites = new List<Map<String,String>>();
        Map<String, Schema.SObjectField> mapOfFields = Schema.SObjectType.Site__c.fields.getMap();
        
        List<ServiceRequestSite__c> sitesAdded = [select id, ServiceSite__c from ServiceRequestSite__c where ServiceRequest__c =: srId];
    
        List<Id> listOfSelectedSiteIds = new List<Id>();
        for(ServiceRequestSite__c srs : sitesAdded)
        {
            listOfSelectedSiteIds.add(srs.ServiceSite__c);
        }
        
        String programs='';
        for(String p : pPgm.split(';'))
        {
            if(programs == '')               
                programs = '\'' +  p + '\'';               
            else
                programs = programs + ', \'' +  p + '\''; 
        }
        
        List<String> listOfRecTypes = siteRecTypesAvl.split(';'); 
        
        List<String> listOfAllowedStatus = new List<String>();
        
        if(!String.isBlank(allowedStatuses))
        listOfAllowedStatus = allowedStatuses.split(';');
        
        Set<String> setOfStatusToAvoid = ServiceRequestHelper.getSiteStatusesToAvoid();
        
        String fieldsToQuery = '';
        for(String fName : listOfFieldsToDisplay)
        {
            fieldsToQuery = fieldsToQuery + ',' + fName;
            //If this is a reference field, we need to query the name of the related record 
            if(mapOfFields.get(fName).getDescribe().getType() == Schema.DisplayType.Reference)
            {
                String refFName = fName.subString(0, fName.indexOf('__c')) + '__r.Name';
                fieldsToQuery = fieldsToQuery + ',' + refFName;
            }
        }
        
        String soql = 'select id'+fieldsToQuery+',LastModifiedDate from Site__c where Id NOT IN :listOfSelectedSiteIds and recordTypeId IN:listOfRecTypes' ; 
        
        if (listOfAllowedStatus != null && !listOfAllowedStatus.isEmpty())
            soql += ' and Status__c IN :listOfAllowedStatus';
        
        if (setOfStatusToAvoid != null && !setOfStatusToAvoid.isEmpty())
            soql += ' and Status__c NOT IN :setOfStatusToAvoid';
        
        if (!String.isBlank(pSiteName))
            soql += ' and siteName__c like \'%'+String.escapeSingleQuotes(pSiteName.trim().replace('*', ''))+'%\'';        
        if (!String.isBlank(pAltSiteName))
            soql += ' and AlternateSiteNames__c like \'%'+String.escapeSingleQuotes(pAltSiteName.trim().replace('*', ''))+'%\'';
        if (!String.isBlank(pIpAdd))
            soql += ' and SatelliteIP__c like \'%'+String.escapeSingleQuotes(pIpAdd.trim().replace('*', ''))+'%\'';    
        if (!String.isBlank(pPgm))
            soql += ' and Program__c Includes ('+programs.trim()+')'; 
        
        soql += ' order by name desc limit 1000';
        
        List<Site__c> results = Database.query(soql);
        
        
        for(Site__c site : results)
        {
            Map<String, String> mapOfFieldsToValues = new Map<String, String>();
            for(String fName : listOfFieldsToDisplay)
            {   
                String fValue = '';
                
                if(mapOfFields.get(fName).getDescribe().getType() == Schema.DisplayType.Reference)
                {  
                     String referenceName = fName.subString(0, fName.indexOf('__c')) + '__r';
                     if(site.getSobject(referenceName) != null)
                         fValue = (String)site.getSobject(referenceName).get('Name');
                     else
                        fValue = ''; 
                }               
                else
                {
                    if(site.get(fName) != null)
                    fValue = (String)site.get(fName); 
                    else
                    fValue = '';    
                }
                
                mapOfFieldsToValues.put(fName, fValue);
            }
            mapOfFieldsToValues.put('Id', (String)site.get('Id'));
			sites.add(mapOfFieldsToValues);            
            
        }
        
        return sites;
    }
    
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();        
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields(); 
    }  
    
    public void getFieldsToDisplay(String fieldSetName)
    {
        List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet(fieldSetName,'Site__c');
        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
        { 
         listOfFieldsToDisplay.add(fieldSetMemberObj.getFieldPath());
         mapOfFieldNameToLabel.put(fieldSetMemberObj.getFieldPath(), fieldSetMemberObj.getLabel());
         mapOfFieldNameToType.put(fieldSetMemberObj.getFieldPath(), fieldSetMemberObj.getType());         
        }
    }
    
  
}