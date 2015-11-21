/*****************************************************************
Name          : CaseStatusTrackingUtility
Created By    : Anand Sanjeev
Company Name  : Slalom
Created Date  : October 2015
Modified Date : Oct 16 2015
Purpose		  : Controller class for the SalesforceRequestForm page
******************************************************************/
public class SalesforceRequestFormController {
        
    public Case cCase{get;set;}
    
    //List of attachments to be shown on the page
    public List<Attachment> listOfAttachments;
    
    //Attachment which needs to be saved
    public Attachment attachmentToInsert{get;set;}
    
    //Boolean set based on the case category value
    //This boolean will decide if the business justification field is required on the page or not.
    public boolean isBusJustRequired{get;set;}
        
    public static String DEFAULT_ORIGIN = 'SF_REQ_FORM_DEF_ORIGIN';    
    public static String CONFIRM_MSG = 'SF_REQ_FORM_CONFIRM_MESSAGE';
    public static String GENERIC_ERROR = 'SF_REQ_FORM_GENERIC_ERROR';    
    public static String SALESFORCE_SUPPORT = 'SALESFORCE_SUPPORT_RT_NAME';    
    public static String ENHANCEMENT ='SF_REQ_FORM_ENHANCEMENT';
    public static String DATA_MANAGEMENT = 'SF_REQ_FORM_DATA_MANAGEMENT';
    
    public static String EMPTY_STRING = '';
    
    //---Initialize the controller    
    public SalesforceRequestFormController(ApexPages.StandardController controller) 
    {
        cCase = (Case)controller.getRecord();
        String rtName =  CaseKeyValueStore__c.getInstance(SALESFORCE_SUPPORT)!= null ? CaseKeyValueStore__c.getInstance(SALESFORCE_SUPPORT).value__c : EMPTY_STRING;
        cCase.RecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(rtName).RecordTypeId;
        attachmentToInsert = new Attachment();
    } 
    
   
    public String getStepTwoMessage()
    {
        String msg =  CaseKeyValueStore__c.getInstance(CONFIRM_MSG)!= null ? CaseKeyValueStore__c.getInstance(CONFIRM_MSG).value__c : EMPTY_STRING;
        return msg;
    }
    
    //This method is called when the category value changes
    //Check if business justification is required for the selected category
    public pageReference handleCategoryChange()
    {
        String enh =  CaseKeyValueStore__c.getInstance(ENHANCEMENT)!= null ? CaseKeyValueStore__c.getInstance(ENHANCEMENT).value__c : EMPTY_STRING;
        String dataMan =  CaseKeyValueStore__c.getInstance(DATA_MANAGEMENT)!= null ? CaseKeyValueStore__c.getInstance(DATA_MANAGEMENT).value__c : EMPTY_STRING ;
      
        if( !String.ISBLANK(cCase.Category__c) 
           && (cCase.Category__c.contains(enh) || cCase.Category__c.contains(dataMan)))              
            
        {
            isBusJustRequired = true;
        }
        else
            isBusJustRequired = false;
        
        return null;
    }
    
    //Create the case record
    public pageReference createCase()
    {       
        try{
            //Query and get the contact which matches the email entered
            //If more than one contact, we get the contact with the last modified date
            List<Contact> con = [select id from Contact where email = :cCase.SuppliedEmail order by lastModifiedDate desc limit 1];
            if(!con.isEmpty())
                cCase.ContactId = con[0].id;
            String defOrigin =  CaseKeyValueStore__c.getInstance(DEFAULT_ORIGIN)!= null ? CaseKeyValueStore__c.getInstance(DEFAULT_ORIGIN).value__c : EMPTY_STRING; 
            //Set the default origin as web
            cCase.Origin = defOrigin;
            //Set the dml options to trigger any emails
            Database.DMLOptions dmo = new Database.DMLOptions(); 
            dmo.EmailHeader.triggerAutoResponseEmail = true;
            cCase.setOptions(dmo);
            insert cCase;   
            //Refresh the case record to get the details (mainly case number)
            cCase = [select id, caseNumber, suppliedName, suppliedEmail, Type, Category__c, Date_Needed_By__c, Priority, subject, description, Business_Justification__c from Case where id=:cCase.id];
        }
        
        catch(Exception e)
        {
			String genErr =  CaseKeyValueStore__c.getInstance(GENERIC_ERROR)!= null ? CaseKeyValueStore__c.getInstance(GENERIC_ERROR).value__c : EMPTY_STRING; 
            addError(genErr + '<br/> Error Details:' + e.getMessage());
        }
        return null; 
    }
    //Show error on the page
    public void addError(String error)
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,error));
    }
    //Return back to the initial home page
    public pageReference redirectHome()
    {       
        PageReference pg = Page.SalesforceRequestForm;
        pg.setRedirect(true);		
        return pg; 
    }
    //Get the list of attachments added to the case and order them in a descending order
    public List<Attachment> getListOfAttachments()
    {
        if(cCase.id!= null)
        {    
            listOfAttachments = [select id, name, BodyLength from Attachment where parentId = :cCase.id order by createdDate desc];
            return listOfAttachments;
        }
        else
            return null;
    }    
    //Create the attachment record with the selected file 
    public pageReference addAttachment()
    {
        if(attachmentToInsert.Body != null)
        {    
            attachmentToInsert.ParentId = cCase.id;
            insert attachmentToInsert;    
            
            attachmentToInsert = new Attachment();
        }
        
        return null;
    }
    
}