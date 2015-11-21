public class NBNDispatchonTime
{ 
  Public Case caseInput {get;set;} 
  Public Id CaseId {get;set;}   
  public  boolean setvalue{get;set;} 
  private String queryString; 
  public boolean isRedundant{get;set;}
  public boolean isAvailable{get;set;}
 
  public string comment_SubmitRMA {get;set;}
  // the collection of custom setting "NBNCo KeyvalueStore"
  public static Map<String,NBNCoKeyvalueStore__c> MapKeyValue= NBNCoKeyvalueStore__c.getAll(); 
  public String NBN_AdvanceReplacementRMA{get;set;}  
  public string NBNDispatchOnViewPageHelp {get{ return MapKeyValue.get('NBNDispatchOnViewPageHelp').Value__c;}}
    
  private ApexPages.StandardController sController=null; 
    
  Public NBNDispatchonTime(ApexPages.StandardController controller) 
  {     
     sController=controller;     
     CaseId=controller.getID();  
     caseInput =[select id,NBNSpareComments__c,RMADisposition__c,CaseNumber,NetworkPicklist__c,SoftwareVersion__c,SubSystem__c,EstimatedInitialResponseTime__c,Steps_to_Follow__c,FirmwareVersion__c,ResolutionDescription__c,Priority,Type,AccountId,Status,ContactId,OwnerId,PrioritybasedonType__c,CustomerTicket__c,Origin,Subject,Description,recordtypeId,StatusDetails__c,AccountName__c,Location__c,ProductType__c,Redundant__c,SentEmail__c,AvailableonSite__c,DeliveryDateTime__c,DispatchTime__c,DispatchMethod__c,DispatchMethodDetails__c,RequestRMARequired__c,RMARequest__c,Comment__c,InitialResponseProvidedAt__c,ElapsedTimeToInitialResponse__c,CalloutStatus__c,CalloutStartTime__c,CalloutEndTime__c,
                Date_Needed_By__c,Date_Time_Occurred__c,VisibleToCustomer__c,DeliveryDateTimeNotAvaiable__c,EstimatedWorkaroundTime__c,WorkaroundDescription__c,WorkaroundProvidedAt__c,EntitlementId,ElapsedTimeToWorkaround__c,EstimatedResolutionTime__c,ResolutionProvidedAt__c,ElapsedTimeToResolution__c,Calculated_RMARequestDateTime__c
                from Case where id=:CaseId];            
     
		if(caseInput.RMADisposition__c==Null)
			caseInput.RMADisposition__c=MapKeyValue.get('NotEvaluated').Value__c;
		NBN_AdvanceReplacementRMA=MapKeyValue.get('NBN_AdvanceReplacementRMA').Value__c;
        
		if (!RMASubmitted)              
            initOnRMARequest();                    
    }
  
    public void DispatchMethod()
    {         
		if(caseInput.AvailableonSite__c == 'No' && caseInput.DispatchTime__c=='0.0 Days' && caseInput.DeliveryDateTimeNotAvaiable__c!=Null)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+'Dispatch Time must be greater than 0. Delivery Date/Time shall be greater than RMA Request Date/Time.'));                       
		if(caseInput.AvailableonSite__c =='No' && caseInput.status=='Resolved'  && caseInput.DeliveryDateTimeNotAvaiable__c==Null)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +'Please Select Delivery Date Time.'));                       
              
		// Set DispatchMethodDetails__c max name len = 38
		caseInput.DispatchMethodDetails__c='';
		if (!String.isEmpty(caseInput.DispatchMethod__c))
		{ 
			string sMethodName = (caseInput.DispatchMethod__c.length() > 38 ? caseInput.DispatchMethod__c.substring(0,38) : caseInput.DispatchMethod__c); 
			if (MapKeyValue.get(sMethodName) != null)
				caseInput.DispatchMethodDetails__c=MapKeyValue.get(sMethodName).value__c;
		}
    }      
      
    // ACTION on the caseInput.AvailableonSite__c change
    public void AvailableOnSite()
    { 
        caseInput.DispatchTime__c = '0 Days 0 Hours 0 Minutes';
        
        if(caseInput.AvailableonSite__c =='Yes' && caseInput.RMARequest__c != Null)
        {                                
            caseInput.DeliveryDateTime__c=caseInput.RMARequest__c;                                                                    
            caseInput.DispatchTime__c = getDispatchTime(caseInput.DeliveryDateTime__c);
                
            if(caseInput.DispatchMethod__c!=Null)
                caseInput.DispatchMethod__c=''; 

            if(caseInput.DispatchMethodDetails__c!=Null)
                caseInput.DispatchMethodDetails__c='';

            if(caseInput.DeliveryDateTimeNotAvaiable__c!=Null)
                caseInput.DeliveryDateTimeNotAvaiable__c=Null;
        }
         
        if (caseInput.AvailableonSite__c == 'No' && caseInput.RMARequest__c != Null &&
            caseInput.DeliveryDateTimeNotAvaiable__c != Null &&
            caseInput.DeliveryDateTimeNotAvaiable__c > caseInput.RMARequest__c)
        {                                                 
            //Double DispatchTime = Math.Floor((Double.valueOf(caseInput.DeliveryDateTime__c.getTime()) - Double.valueOf(caseInput.RMARequest__c.getTime())) / (1000.0*60.0*60.0));
            caseInput.DispatchTime__c = getDispatchTime(caseInput.DeliveryDateTimeNotAvaiable__c);              
            caseInput.DeliveryDateTime__c=Null;
        }                       
    }   

    private string getDispatchTime(DateTime deliveryTime)
    { 
        integer dispatchTimeInSecs = Integer.valueOf( (deliveryTime.getTime() - caseInput.RMARequest__c.getTime() )/1000);             
        integer days = Integer.valueOf(dispatchTimeInSecs/(60*60*24));             
        integer hours = Integer.valueOf((dispatchTimeInSecs - days*24*60*60)/(60*60));
        integer mins = Integer.valueOf((dispatchTimeInSecs - days*24*60*60 - hours*60*60)/60);
        //integer secs = Integer.valueOf(dispatchTimeInSecs - days*24*60*60 - hours*60*60 - mins*60);
        
        return days + ' Days ' + hours + ' Hours ' + mins + ' Minutes ';// + secs +' Seconds';
    }

    public void doSendEmail() 
    { 
        Integer year= system.now().year();
        Integer month= system.now().month();
        Integer days= system.now().day();                                   
          
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
        String[] toAddresses = new String[] {+MapKeyValue.get('NBNCoDispatchMailId').Value__c};   
        mail.setToAddresses(toAddresses);         
        mail.setSenderDisplayName(MapKeyValue.get('NBNViaSatTeam').Value__c);
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap();       

        string SubSystemandLocation = '';               
        if(caseInput.SubSystem__c!=Null)
            SubSystemandLocation='--'+caseInput.SubSystem__c;

        if(caseInput.Location__c!=Null && SubSystemandLocation!='')
            SubSystemandLocation=SubSystemandLocation+'--'+caseInput.Location__c;

        mail.setSubject(MapKeyValue.get('NBNSFcase').Value__c+':'+caseInput.CaseNumber+'–-' + caseInput.AccountName__c + SubSystemandLocation + '–-' +caseInput.Subject);
        
        mail.setBccSender(false);
        mail.setUseSignature(false);           
        mail.setSaveAsActivity(false);
        String body = MapKeyValue.get('NBNRequestRMA').Value__c+'<br/><br/><br/>';
        if (caseInput.SentEmail__c)
            body += MapKeyValue.get('Updateshavebeenmadeinthe').Value__c+' '; 
        body += MapKeyValue.get('RequestforanAdvanceReplacement').Value__c+' '+month+'/'+days+'/'+year+' '+MapKeyValue.get('NBNforSalesForce').Value__c+'<br/><br/>'+'Case Details: '+'<br/><br/>';
        body += fieldMap.get('CaseNumber').getDescribe().getLabel() +': '+caseInput.CaseNumber+'<br/>';                     
        body += fieldMap.get('AccountName__c').getDescribe().getLabel() +': '+caseInput.AccountName__c+'<br/>';                     
        
        body += fieldMap.get('SubSystem__c').getDescribe().getLabel()+': ';
        if(caseInput.SubSystem__c!=Null)
            body += caseInput.SubSystem__c+'<br/>';
        else
            body += MapKeyValue.get('NBNNotDefined').Value__c+'<br/>';

        body += fieldMap.get('Location__c').getDescribe().getLabel()+': ';
        if(caseInput.Location__c!=Null)
            body += caseInput.Location__c+'<br/>';  
        else
            body += MapKeyValue.get('NBNNotDefined').Value__c+'<br/>';  
        
        body += fieldMap.get('Subject').getDescribe().getLabel()+': '+caseInput.Subject+'<br/>';
        body += fieldMap.get('AvailableonSite__c').getDescribe().getLabel()+': '+caseInput.AvailableonSite__c+'<br/>';
        body += fieldMap.get('Redundant__c').getDescribe().getLabel()+': '+caseInput.Redundant__c+'<br/>';
        if (caseInput.AvailableonSite__c == 'No')
        {
            body += fieldMap.get('DispatchMethod__c').getDescribe().getLabel()+': '+caseInput.DispatchMethod__c+'<br/>';
            body += fieldMap.get('DispatchMethodDetails__c').getDescribe().getLabel()+': '+caseInput.DispatchMethodDetails__c+'<br/>';

            if (caseInput.DeliveryDateTimeNotAvaiable__c != null)
                body += fieldMap.get('DeliveryDateTimeNotAvaiable__c').getDescribe().getLabel()+': '+caseInput.DeliveryDateTimeNotAvaiable__c+'<br/>';
        }
        else
            body += fieldMap.get('DeliveryDateTime__c').getDescribe().getLabel()+': '+caseInput.DeliveryDateTime__c+'<br/>';
        if(caseInput.NBNSpareComments__c==Null)
			body += fieldMap.get('NBNSpareComments__c').getDescribe().getLabel()+': None<br/>';  
        else             
			body += fieldMap.get('NBNSpareComments__c').getDescribe().getLabel()+': '+caseInput.NBNSpareComments__c+'<br/>'; 

        if(caseInput.RMADisposition__c!=Null)
            body += fieldMap.get('RMADisposition__c').getDescribe().getLabel()+': '+caseInput.RMADisposition__c+'<br/>';
        if(caseInput.Calculated_RMARequestDateTime__c!=Null)
            body += fieldMap.get('Calculated_RMARequestDateTime__c').getDescribe().getLabel()+': '+caseInput.Calculated_RMARequestDateTime__c+'<br/>';

        body += '<br/><br/>' +'Thanks,'+'<br/>'+'ViaSat Support Services'+'<br/>';       
        mail.setHtmlBody(body); 
        
        if ( !Test.isRunningTest() )                       
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                
    }
     
    public PageReference saveCaseRMA() 
    {               
        try        
        {        
            // VALIDATE that Spare details is correct 
            string errMessage = validateForRMARequest();
            if (errMessage != '')
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessage)); 
                return null; 
            }            
            // Set some RMA data & send an email                            
                
                // Final settings & updates
                caseInput.StatusDetails__c = MapKeyValue.get('NbnAdvanceReplacement').Value__c;         
                caseInput.Status = 'In Progress'; 
                
                update caseInput;         

                // indicates that RMA requested
                caseInput.RequestRMARequired__c = true;        
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, +MapKeyValue.get('NBN_RmaSaved').Value__c)); 
                doSendEmail();      
                caseInput.SentEmail__c = true;   
                update caseInput;         

                return null;//close(); 
        }
      
        catch (DMLException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, + e.getDMLMessage(0)));                
            return null;                                  
        } 
        catch (exception e1) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, + e1.getMessage()));                
           return null;                                  
        }   
    }  
    
    public PageReference close() 
    {                       
        PageReference newPage = new PageReference('/' + caseInput.Id);   // = new ApexPages.StandardController(caseInput).view();              
        return newPage.setRedirect(true);            
    }    
    
    // Is RMA already requested? Checked on the Init of the controller to set Case data for RMA.
    public boolean RMASubmitted
    {
        get
        {
            return (caseInput.RequestRMARequired__c && caseInput.RMARequest__c != null);
        }
    } 

    public boolean AllowRMARequest
    {
        get
        {
            return (caseInput.status != 'Resolved' && caseInput.status != 'Closed');
        }
    }  
       
    private void initOnRMARequest()
    {   
        caseInput.RMARequest__c=system.now();//Datetime.valueOf(string.ValueOf(system.now()));       
       // Datetime Testingdate= datetime.newInstance(2014,10,17,17,0,0);
       // caseInput.RMARequest__c=Datetime.valueOf(string.ValueOf(Testingdate));         
        Integer year = caseInput.RMARequest__c.year();
        Integer month = caseInput.RMARequest__c.month();
        Integer days = caseInput.RMARequest__c.day();                                                       
        caseInput.Comment__c = MapKeyValue.get('NBNRequestforRMA').Value__c+' '+month+'/'+days+'/'+year+' '+MapKeyValue.get('NBNAdvanceReplacementRMA').Value__c;
        comment_SubmitRMA= MapKeyValue.get('NBNRequestforRMA').Value__c+' '+month+'/'+days+'/'+year+' '+MapKeyValue.get('NBNAdvanceReplacementRMA').Value__c;                     
      
//// just for testing
//if(caseInput.Date_Time_Occurred__c != Null)
//	caseInput.Calculated_RMARequestDateTime__c = setCalculated_RMARequestDateTime(caseInput.Date_Time_Occurred__c);
//else
		caseInput.Calculated_RMARequestDateTime__c = setCalculated_RMARequestDateTime(caseInput.RMARequest__c);

        system.debug('caseInput.Calculated_RMARequestDateTime__c@@@   '+caseInput.Calculated_RMARequestDateTime__c);
    } 

	// If Case Record Type = ‘Support Services NBN Co’ AND RMARequest__c is set then
	// Calcualte Calculated_RMARequestDateTime__c field based on business rule and business day:
	// Convert RMARequest__c in Australia Time Zone (GMT+11:00) regardless the timezone the user has,
	// if it is in Australia Timezone >= 12pm then Calculated RMA Request Date\Time in Australia Timezone = 
	// ‘RMA Request Date\Time’ In Australia Timezone + 1 Business Day at 8am
	// Store it in GMT else	Calculated RMA Request Date\Time = RMA Request Date\Time        
    private DateTime setCalculated_RMARequestDateTime(DateTime RMARequest)
    {
		BusinessHours nbnBH = [select Id, TimeZoneSidKey,FridayStartTime,MondayStartTime,SaturdayStartTime,SundayStartTime,ThursdayStartTime,TuesdayStartTime,WednesdayStartTime from BusinessHours where Name = 'NBNCo - Australlia'];
		DateTime converteddate = Datetime.valueof(RMARequest.format('yyyy-MM-dd HH:mm:ss', nbnBH.TimeZoneSidKey));
		integer hours = integer.valueof(RMARequest.format('HH', nbnBH.TimeZoneSidKey));
		integer mins = integer.valueof(RMARequest.format('mm', nbnBH.TimeZoneSidKey));
		
		DateTime newdate = RMARequest;
		if (hours >= 12)
		{
			converteddate = converteddate.addHours(24 - hours + 8).addMinutes(-mins);
			newdate = newdate.addHours(24 - hours + 8).addMinutes(-mins);
		}
		
		List<Holiday> holidays = [SELECT Id, Name, ActivityDate FROM Holiday];	
		integer i = ViasatUtilityClass.getNumOfDaysToNextWorkDay(converteddate, holidays);
		newdate = newdate.addDays(i);

		system.debug('*** converteddate: '+i +'; ' + converteddate +'/' + converteddate.format('yyyy-MM-dd HH:mm:ss', nbnBH.TimeZoneSidKey) +', '+ newdate + ', '+ hours);
		return newdate;
    }
    
    private string validateForRMARequest()
    {
        string errMsg = '';
        if (caseInput.AvailableonSite__c == 'No')
        {
            if (caseInput.DispatchMethod__c == Null)
                errMsg = 'Please Select Dispatch Method.';    
            else if (caseInput.DispatchMethodDetails__c == Null)  
                errMsg = 'Please Select "Dispatch Method" ,"Dispatch Method Detail" will be automatically populated.'; 
            else if (caseInput.status == 'Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c == Null)
                errMsg = 'Please Select Delivery Date Time.'; 
            else if (caseInput.DeliveryDateTimeNotAvaiable__c != Null && caseInput.DispatchTime__c == '0.0 Days')
                errMsg = 'Dispatch Time must be greater than 0. Delivery Date/Time shall be greater than RMA Request Date/Time.';                                             
        }
        return errMsg;
    }    
}