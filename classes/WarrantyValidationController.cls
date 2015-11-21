/*********************************************************************************
Name         : WarrantyValidationController
Created By   : Tejesh Kumar
Company Name : CMC Americas    
Project      : RMA Warranty Check
Created Date : 21 January, 2015
Usages       : Controller for VisualForce Page: WarrantyValidationPage
*********************************************************************************/

public with sharing class WarrantyValidationController {
    ApexPages.StandardController controller;
    public static Map<String,RMAKeyValueStore__c> MapKeyValue=RMAKeyValueStore__c.getAll();
       
    //--- Conrtroller objects
    public Order__c o {get;set;}    
    public List<OrderLine__c> orderlines{get;set;}
    public Map<Id,List<String>> validLoResponseLines = new Map<Id, List<String>>();
    public Map<Id,List<String>> inValidLoResponseLines = new Map<Id, List<String>>();
    public List<OrderLine__c> validOrderlines{get;set;}
    public List<OrderLine__c> invalidOrderlines{get;set;}
        
    //--- Get the line Ids and Info from response object
    public Set<Id> validLineIds = new Set<Id>();  
    public Set<Id> invalidLineIds = new Set<Id>();            
         
    // Static variable that assumes a test is not running
    public static boolean isApexTest = false;
    public static String apexTestResponse = '';
    
    private String errorMessage;   
    public List<OrderLine__c> orderlinesdelete = new List<OrderLine__c>();   
    public String accountName {get {return (accountName == null) ? o.account__r.name:accountName;} set;}
    public String accountId {get {return (accountId == null) ? o.account__c:accountId;} set;}
    
    public String sortField{get;set;}    
    public PageReference toggleSort () {return null;}
    public String priorPage {get; set;}
    public boolean test {get; set;}   

    //--- For checkbox selection and remove lines    
    public Boolean lineUnchecked {get {return false;} set;}    
    public String linesSelected {get;set;}
    public string linesUnSelected{get;set;}
    
    public String selectedOrderTypeId {get;set;}
    public String selectedServiceTypeId {get;set;}
    public Boolean resultsPanel{get;set;}
    public Boolean emailSent{get;set;}
    public Boolean hideSubmitRMA{get;set;}
    public Boolean linesNotSelected1{get;set;}
    public Boolean linesNotSelected2{get;set;}
    
    // --------- Added for Nbnco users creating RMA record through portal
    public Id NbnuserprofileId;
    public Id NbncontactId;
    public string profilename;
    public boolean NbnCoCreateRMA{get;set;}
    public List<Profile> Profilelist = new List<Profile>();
    
    //Custom Settings
    public string emailSentText{get{return getValue('QuoteEmailSentText');}set;}
    public string noLinesSelected1{get{return getValue('NoInWarrantyLinesSelected');}set;}
    public string noLinesSelected2{get{return getValue('NoOutofWarrantyLinesSelected');}set;}
    
    //Methods to return Value and URL from RMAKeyValueStore
    public static String getValue(String name) { 
        try{ return MapKeyValue.get(name).Value__c; }       
        catch(Exception e){ return null; }         
    }
    
   public static string getURL(String name){ 
        try{ return MapKeyValue.get(name).URL__c; }        
        catch(Exception e){ return null; }         
    } 
    
    // ---end of------ Added for Nbnco users creating RMA record through portal
    
    private Order__c getOrder(String asId)  {
        return [select Id, name, account__c, account__r.name, Requestor__c,
                ShipToAddress__c,ShipToAddress__r.EBSAddressID__c, BillToAddress__c, BillToAddress__r.EBSAddressID__c,
                partialshipment__c, PreferredCarrier__c, CarrierAccount__c, Status__c, OracleOrder__c, CustomerPO__c,
                Drop_Shipment__c,FAA81303Required__c, AgreetoRMAReturnConditions__c, AgreetoTermsConditions__c, NotesComments__c, ComSecDoDAACRequirement__c, ComSecDoDAACRequirementReviewed__c, BypassWarrantyCheck__c, OrderTypeId__c, ServiceTypeId__c,Advance_Replacement_Required__c 
                from order__c
                where Id = :asId]; 
    }
    
    private List<OrderLine__c> getOrderLines(String asId) {
    //------- Added for unchecking checked order line item for deletion
        list<OrderLine__c> delunchecklist= new list<OrderLine__c>();
        list<OrderLine__c> Temp= new list<OrderLine__c>();
        delunchecklist = [Select Id, name, PartNumber__c, Part_Number_2__c, SerialNo__c, ErrorCode__c, ErrorDescription__c,Marked_For_Deletion__c , 
                        ShipToAddress__c,ShipToAddress__r.EBSAddressID__c, Product_Description__c, ReturnReasonDescription__c, Item_Description__c
                        from OrderLine__c 
                        where order__c = :asId order by CreatedDate];
        for(OrderLine__c ordl : delunchecklist){
            if(ordl.Marked_For_Deletion__c == true)
                ordl.Marked_For_Deletion__c = false; 
            Temp.add(ordl);      
        }
        return Temp;
    }
    
    //-------------------------------------------------------------------------
    //---Initialize the controller    
    //-------------------------------------------------------------------------
    public WarrantyValidationController(ApexPages.StandardController stdController) {
        controller = stdController;        
        priorPage = ApexPages.currentPage().getHeaders().get('Referer');       
        resultsPanel=false;
        emailSent=false;
        hideSubmitRMA=false;
        linesNotSelected1=false;
        linesNotSelected2=false;
        
        // Load in and check if the Profile have access to the Submit RMA button
		String noAccessProfiles = getValue('ProfilesToAccessSubmitRMA');
		if(!AtlasUtility.isEmpty(noAccessProfiles) && noAccessProfiles.contains(UserInfo.getProfileId().left(15))) 
			hideSubmitRMA=true;	
		
        //--- Get the Order based on page reference and include all custom fields
        o = (Order__c)controller.getRecord();  

        try{
            if (controller.getRecord().id != null)
            o = getOrder(controller.getRecord().id);    
        }catch(exception e){
            o = null;
        }
        if (o==null){
            o = new Order__c();
            o.recordtype =  [select Id from RecordType where Name = :System.Label.RMARecordType and SobjectType = 'Order__c'];
        }   
        
        //--- Set default values.
        
        //--- d. Default contact
        if (o.requestor__c == null) {
            for (user u : [select contactid from user where id = :UserInfo.getUserId()]) {
                o.requestor__c = u.contactid;
                NbncontactId = u.contactid;
            }   
        }
        
               
                  
        //--- a. Default Account ..
        if (o.account__c == null) {
            //--- default the account if user has access to only one account
            //--- if rows returned is 1 means user has access to only one account
            //--- we are limiting the rows to 2 for performance (2 or more we can't default the address)
            String excludeList = System.Label.RMAExcludedAccountList;
            String [] excludeListArr = excludeList.split(';');
            List<Account> aa = [select id, name from account where  Name NOT IN :excludeListArr LIMIT 2];
           
            if (aa.size() == 1) {
                o.account__c = aa[0].id;
                accountId    = aa[0].id;
                accountName  = aa[0].name;
            } 
            else if (!UserInfo.getUserType().equalsIgnoreCase('Standard'))
            {
            	// portal user with more than one accessible accounts
            	// Use the account of the contact associated with the user = o.requestor__c
            	Contact myContact = [select id, accountid, account.name from Contact where id = :o.requestor__c];
            	
            	o.account__c = myContact.accountid;
                accountId    = myContact.accountid;
                accountName  = myContact.account.name;
            }
            
              
        }
            
        
        
        // --------- Added for Nbnco users creating RMA record through portal      
        NbnuserprofileId = UserInfo.getProfileId();
        Profilelist = [Select Id, Name from Profile where Id =: NbnuserprofileId];        
        for(profile prof: Profilelist)
            profilename = prof.Name;           
        if( System.Label.RMA_Nbnco_User_profile.contains(profilename)) {
            NbnCoCreateRMA = true;
            for( Contact cont : [Select Id, AccountID from Contact where Id =:NbncontactId])
                o.account__c = cont.AccountID;
        }
        else
            NbnCoCreateRMA = false;
        
        //------- default values when Nbnco profile creates RMA request 
        if(NbnCoCreateRMA == true) {
            o.AgreetoRMAReturnConditions__c = true;
            o.AgreetoTermsConditions__c = true;
            o.ComSecDoDAACRequirementReviewed__c = false;
            o.ComSecDoDAACRequirement__c = 'No';
            o.FAA81303Required__c = 'No';
        }
        
        // -----end of---- Added for Nbnco users creating RMA record through portal      
        if(o.OrderTypeId__c != null && o.OrderTypeId__c != '')
            selectedOrderTypeId = o.OrderTypeId__c;
        else
            selectedOrderTypeId = '';       

        if(o.ServiceTypeId__c != null && o.ServiceTypeId__c != '')
            selectedServiceTypeId = o.ServiceTypeId__c;
        else
            selectedServiceTypeId = '';       
            
        //--- Add additional lines for user to enter
        getLines(false);   

    }
        
    //-------------------------------------------------------------------------
    //--- Get order lines and add more lines
    //-------------------------------------------------------------------------
    public void getLines() {
        getLines(true);
    }
    public void getLines(Boolean abSave) {
        if (abSave) {
            saveRMA();
            if (errorMessage != null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
                return;
            }   
        }
      
        //--- Get the order lines...
        orderlines = getOrderLines(o.id); 
        system.debug('---orderlines--->'+ orderlines);                                                      

        //--- Now add additional empty lines...
        for (integer j=1;j<=5;j++) {
            OrderLine__c ol = new OrderLine__c();
            ol.recordtype =  [select Id from RecordType where Name = :System.Label.RMALineRecordType and SobjectType = 'OrderLine__c'];                  
            ol.order__c = o.id;
            orderlines.add(ol);             
        }
        system.debug('---orderlines 2--->'+ orderlines);    
    }
    
    //-------------------------------------------------------------------------
    //---- Remove selected lines
    //-------------------------------------------------------------------------
   public  PageReference removeLines() {
        try {
            saveRMA();
            list<OrderLine__c> deletelist= new list<OrderLine__c>();
            deletelist=[select id from OrderLine__c where Order__c=: o.id and Marked_For_Deletion__c=:true];
            system.debug('---deletelist --->'+ deletelist);
            if(deletelist.size()>0)
                delete deletelist;
        }
        catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));      
        }
        //return null;
        PageReference loReadPage = new PageReference('/apex/WarrantyValidationPage?'+'id='+o.id);
            return loReadPage.setRedirect(true);
    }
    
    //-------------------------------------------------------------------------
    //--- Upload lines from a file
    //-------------------------------------------------------------------------
    public PageReference uploadLines() {
        //--- Save the RMA before uploading the lines
        saveRMA();
         
        if (errorMessage != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }
        else {
            PageReference loUploadPage = new PageReference('/apex/RMAWarrantyLinesUpload');
            loUploadPage.getParameters().put('rmaid',o.id);
            return loUploadPage.setRedirect(true); 
        }      
    }

    //-------------------------------------------------------------------------
    //--- Submit for Warranty Check
    //-------------------------------------------------------------------------
    
    public PageReference submitForWarranty() {
        saveRMA();
        
        if (errorMessage !=null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }
        else {
            //--- Save is successful, submit the RMA
            Cookie DOLIKCZXHW = new Cookie('DOLIKCZXHW','YUBXYEICII',null,315569260,false);
            //Set the page cookies using the setCookies() method
            ApexPages.currentPage().setCookies(new Cookie[]{DOLIKCZXHW});          
            PageReference loRMAPage = new PageReference('/apex/WarrantyValidationPage');
            loRMAPage.getParameters().put('id',o.id);
            loRMAPage.getParameters().put('submit','1');
            return loRMAPage.setRedirect(true);           
        }
        submitAction();
        return null;
    }
    
    //-------------------------------------------------------------------------
    //--- Submit the RMA
    //-------------------------------------------------------------------------
    public void submitAction()
    {
        //--- Check to see if the user is submitting the RMA
        String lsSubmit = ApexPages.currentPage().getParameters().get('submit');
        Cookie theCookie = ApexPages.currentPage().getCookies().get('DOLIKCZXHW');
        String submitActionCookie = null;
        if(theCookie != null) 
            submitActionCookie = theCookie.getValue();
        if ((lsSubmit != null && lsSubmit.equalsIgnoreCase('1')) && (submitActionCookie != null && submitActionCookie == 'YUBXYEICII')) {
            submitRMA();
            if (errorMessage !=null) 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            else 
                resultsPanel=true;
        }

        //--- Now remove the cookie
        Cookie DOLIKCZXHW = new Cookie('DOLIKCZXHW','ILDMRBNFVM',null,0,false);
        ApexPages.currentPage().setCookies(new Cookie[]{DOLIKCZXHW});          
        ApexPages.currentPage().getParameters().put('submit','0');       
    }
    
    public void submitRMA() {
    	       
        boolean lbFoundLineErrors = false;
        try {   
            errorMessage = null;
            orderlines = getOrderLines(o.id);
            system.debug('--orderlines.size()--> '+ orderlines.size());                                
            //--- If no lines are found, inform the user to add at least one line item
            if (orderlines.size() <=0) {
                errorMessage = getValue('NoLinesErrorMsg');   
                return;             
            }
                      
            //--- Validate the lines before submitting the RMA
            String lsReturn = invokeExternalWs();
            
            //--- a. Parse the response stream only for lines
            XmlStreamReader loResponse = new XmlStreamReader(lsReturn);
            system.debug('--lsReturn--> '+ lsReturn);
            while (loResponse.hasNext()) {
             	
                if (loResponse.getEventType() == XmlTag.START_ELEMENT) 
                { 
                	if ('line' == loResponse.getLocalName()) 
                		parseResposne(loResponse);
                	// avoid failing silently when no connection.	
                	else if ('error' == loResponse.getLocalName())
                	{
                		 errorMessage = getValue('RequestFailMsg') + 'System error.';
                		 return;
                	}
                }               		 
                 	                  	               
                loResponse.next();
            }
            
            o = getOrder(o.id);  
           
            //--- Reset the order lines to merge the line info got from the response above
            validOrderlines = new List<OrderLine__c>();
            if(validlineIds.size()>0) {
	            for(OrderLine__c ol : [select Id, name, PartNumber__c, Part_Number_2__c, SerialNo__c, ErrorCode__c, ErrorDescription__c, 
	                                     Product_Description__c, ReturnReasonDescription__c, Item_Description__c,InWarranty__c,SelectedLines__c
	                                    from OrderLine__c 
	                                    where Id IN :validlineIds]) 
	            {
	                List<String> lineInfo = validLoResponseLines.get(ol.Id);
	
	                if (lineInfo != null) {
	                    ol.ErrorCode__c        = lineInfo.get(0);
	                    ol.ErrorDescription__c = lineInfo.get(1);
	                    ol.InWarranty__c = true;
	                    ol.SelectedLines__c = false;
	                    ol.Marked_For_Deletion__c = true;
	                    
	                    // Add to List and Clear off the value in the Selected Lines field           			  
	                    if (ol.ErrorDescription__c != null)
	                    {
	                        ol.ErrorCode__c        = '1';        
	                        lbFoundLineErrors = true;
	                    }
	                    else{
	                        ol.ErrorCode__c        = null;   
	                        ol.Item_Description__c = lineInfo.get(2);        
	                    }                   
	                    validOrderlines.add(ol);
	                }
	            }
	            
	            if (lbFoundLineErrors)  {
	                errorMessage = getValue('ValidationFailedMsg');
	                update validOrderlines;
	            }
	            else {
	                o = getOrder(o.id);																
					update o;
	                update validOrderlines;            
	            }
            }
            invalidOrderlines = new List<OrderLine__c>();
            if(invalidlineIds.size()>0) {
	            for(OrderLine__c ol : [select Id, name, PartNumber__c, Part_Number_2__c, SerialNo__c, ErrorCode__c, ErrorDescription__c, 
	                                     Product_Description__c, ReturnReasonDescription__c, Item_Description__c,InWarranty__c,SelectedLines__c
	                                    from OrderLine__c 
	                                    where Id IN :invalidlineIds]) 
	            {
	                List<String> lineInfo = invalidLoResponseLines.get(ol.Id);
	
	                if (lineInfo != null) {
	                    ol.ErrorCode__c        = lineInfo.get(0);
	                    ol.ErrorDescription__c = lineInfo.get(1); 
	                    ol.InWarranty__c = false;
	                    ol.SelectedLines__c = false;
	                    ol.Marked_For_Deletion__c = true;
	                    
	                    //ol.Item_Description__c = lineInfo.get(2);        
	                                       
	                    invalidOrderlines.add(ol);
	                }
	            }
	            if (lbFoundLineErrors) {
	                errorMessage =  getValue('ValidationFailedMsg');
	                update invalidOrderlines;
	            }
	            else {
	                o = getOrder(o.id);																
					update o;
	                update invalidOrderlines;            
	            }                        
	                                   
	        }
        }
        catch (Exception e) {
            errorMessage = getValue('RequestFailMsg')+' ' + e.getMessage();  
             
        }    
    }
    
    // Method to parse response
    Public void parseResposne(XmlStreamReader loResponse) {    	  	
        Id lineId = (Id)loResponse.getAttributeValue(null,'sfrowid');
        List<String> lineInfo = new List<String>();
        lineInfo.add(loResponse.getAttributeValue(null,'errorcode'));
        lineInfo.add(loResponse.getAttributeValue(null,'errormessage'));
        lineInfo.add(loResponse.getAttributeValue(null,'itemdesc'));                     
        String name;
        
        while(loResponse.hasNext()) {
        	if (loResponse.getEventType() == XmlTag.END_ELEMENT) {
            	break;
        	} else if (loResponse.getEventType() == XmlTag.CHARACTERS) {
            	name = loResponse.getText();
            	if(name=='valid') {
            		validLineIds.add(lineId);
            		validLoResponseLines.put(lineId,lineInfo);	
            	}
        		else {
        			invalidLineIds.add(lineId);
        			inValidLoResponseLines.put(lineId,lineInfo);
        		}	
        	}
       		loResponse.next();
     	}     	
    	system.debug('---validLoResponseLines --->'+validLoResponseLines.keySet());    
    	system.debug('---inValidLoResponseLines --->'+inValidLoResponseLines.keySet()); 	
   	 }
    
    //-------------------------------------------------------------------------
    //--- Call the web service to validate the lines before submitting the order
    //-------------------------------------------------------------------------
    public String invokeExternalWs() {
       String lsReturn = '';
        HttpRequest req = new HttpRequest();

        //--- Set HTTPRequest Method
        req.setMethod('POST');
        req.setEndpoint(System.Label.OrderValidationWebService);
        //req.setEndpoint('http://requestb.in/1cub0b01');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', System.Label.OrderValidationWebService);   

        //--- Construct the XML Playload for SOAP message
        string lsSOAPMsg = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://viasat.com/SerialNumber/types">'+
                            '   <soapenv:Header/>'+
                            '   <soapenv:Body>'+
                            '      <typ:order>'+
                            '         <typ:linecount> ' + orderlines.size() + ' </typ:linecount>'+
                            '         <typ:account> ' + o.account__c + ' </typ:account>'+
                            '         <typ:orderlines>';
                         
        String lsOrderLines = '';                   
        for (OrderLine__c ol : orderlines) {
            try{
                ol.SerialNo__c = ol.SerialNo__c.toUpperCase();
            }catch(Exception ex){}
            try{
                ol.Part_Number_2__c = ol.Part_Number_2__c.toUpperCase();
            }catch(Exception ex2){}
            
            lsOrderLines += '<typ:line serialnumber="' + ol.SerialNo__c + '" itemnumber="' + ol.Part_Number_2__c + '" sfrowid="' + ol.id + '">?</typ:line>';
        } 
        lsSOAPMsg += lsOrderLines + 
                            '         </typ:orderlines>'+
                            '      </typ:order>'+
                            '   </soapenv:Body>'+
                            '</soapenv:Envelope>';

        //--- Execute web service call here                       
        req.setBody(lsSOAPMsg ); 
        system.debug('--req--> '+ req);      
        Http http = new Http();
        XmlStreamReader loResponse; 
        if(!isApexTest){        
            HTTPResponse res = http.send(req);            
            //--- Parse the sendResponse element in the response XML          
            loResponse = new XmlStreamReader(res.getBody());          
            system.debug('--loResponse --> '+ loResponse); 
        }
        else{
            loResponse = new XmlStreamReader(apexTestResponse); 
        } 

        while (loResponse.hasNext()) {
            if ((loResponse.getEventType() == XmlTag.START_ELEMENT) && ('sendResponse' == loResponse.getLocalName()))  {
                while(loResponse.hasNext())  {
                    if (loResponse.getEventType() == XmlTag.END_ELEMENT)
                        break;
                    else if (loResponse.getEventType() == XmlTag.CHARACTERS) 
                        lsReturn += loResponse.getText();
                    loResponse.next();
                }
                break;
            }
            loResponse.next();
        }       
        return lsReturn; 
    }
    
    public void saveRMA() {
        try{
            errorMessage = null;
                            
            //--- Add/Update the Order 
            if (o.id == null)
                insert o;
            else
                update o;
            
            system.debug('----o----> '+o);
            //--- Now add the Lines only if part number is provided for a given line.
            List<OrderLine__c> orderlinesnew    = new List<OrderLine__c>();          
            List<OrderLine__c> orderlinesupdate = new List<OrderLine__c>();

            String lsPartNumber;
            String lsSerialNumber;
            String lsReturnReason;
            boolean lbLineError = false;

            for (OrderLine__c ol: orderlines) 
            {
                lsPartNumber   = (ol.Part_Number_2__c == null) ? '':ol.Part_Number_2__c.trim();
                lsSerialNumber = (ol.SerialNo__c == null) ? '':ol.SerialNo__c.trim();
                lsReturnReason = (ol.ReturnReasonDescription__c == null) ? '' : ol.ReturnReasonDescription__c.trim();

                ol.ErrorCode__c        = null;
                ol.ErrorDescription__c = null;
                ol.order__c            = o.id;

                if ((ol.id != null) && (lsPartNumber.equals('')) && (lsSerialNumber.equals('')) && (lsReturnReason.equals(''))) {
                    //--- Delete the line if part, serial numbers and return reason is blank.
                    orderlinesdelete.add(ol);
                }
                else if ((!lsPartNumber.equals('')) || (!lsSerialNumber.equals(''))) {
                    ol.ErrorCode__c        = null;
                    //--- Check to see if both part and serial numbers are provided
                    if ((lsPartNumber.equals('')) || (lsSerialNumber.equals('')) || (lsReturnReason.equals(''))) {
                        lbLineError            = true;
                        ol.ErrorCode__c        = '1';
                        //ol.ErrorDescription__c = 'Part Number, Serial Number and Return Reason fields are required.';
                        ol.Item_Description__c = getValue('FieldsMissingText');
                    }
                    //--- Now check to see if the line needs to be added or updated
                    if (ol.id == null)
                        orderlinesnew.add(ol);
                    else   
                        orderlinesupdate.add(ol);
                }              
            }
            if (lbLineError) {
                errorMessage = getValue('ValidationFailedMsg');
                return; 
            }

            //--- Add/update/delete the lines
            insert orderlinesnew;
            update orderlinesupdate; 

            try {
                delete orderlinesdelete; 
            } catch (Exception e) { }

            orderlinesdelete = new List<OrderLine__c>();
            getLines(false);
        } catch (DMLException de) {
            errorMessage = getValue('RequestFailMsg')+' '+ de.getMessage();
        } catch (Exception e) {
            errorMessage = getValue('RequestFailMsg')+' '+ e.getMessage();
        }            
    }               
    
     /**
      * @author  Tejesh Kumar 
      * @description redirect to Order Edit page for Valid lines
      * @return page reference to Order Edit page
     */  
    public pageReference linesInWarranty() { 
    	Integer selectedLinesCount = 0;      	
        for(OrderLine__c vld: validOrderlines) {
    		if(vld.Marked_For_Deletion__c==true) {
    			selectedLinesCount++;
    			vld.SelectedLines__c=true;	
    			update vld;
    		}
    	} 
    	 
        if (selectedLinesCount==0) {
            linesNotSelected1=true;
            return null;
        }
        else {
        	linesNotSelected1=false;
	    	string url = '/apex/OrderEdit';
	        PageReference page = new PageReference(url);
	        page.getParameters().put('id',o.id);
	        page.getParameters().put('lineSelection', '1');
	        page.setRedirect(true);
	        return page;
        }   
    }
    
    /**
      * @author  Tejesh Kumar 
      * @description redirect to OrderlinesCSVfile page for export to CSV
      * @return page reference to OrderlinesCSVfile page
     */  
    public pageReference exportToCSV() {    
    	string url = '/apex/OrderlinesCSVfile';
        PageReference page = new PageReference(url);
        page.getParameters().put('id',o.id);
        page.getParameters().put('submit','1');
        page.setRedirect(true);
        return page;   
    }
    
    /**
      * @author  Tejesh Kumar 
      * @description Send an email to Customer care for Quote with CSV attachment
      * @return null
     */ 
    public void linesOutofWarranty() {  
    	string header = getValue('ReqQuoteCSVHeader')+'\n';
		string finalstr = header ;	
		string recordString;	
		Integer commentsLength = 0;

    	for(OrderLine__c inv: invalidOrderlines) {
    		if(inv.Marked_For_Deletion__c==true) {
    			recordString = inv.Part_Number_2__c +','+inv.SerialNo__c +','+ inv.ReturnReasonDescription__c +','+inv.Item_Description__c +'\n';	
    			commentsLength++;
    			finalstr = finalstr +recordString;   			
    		}
    	} 
    	if(commentsLength==0) {
    		linesNotSelected2=true;
    	}
		else {
			linesNotSelected2=false;  	
	    	Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
			blob csvBlob = Blob.valueOf(finalstr);
			string csvname= getValue('ReqQuoteCSVName');
			csvAttc.setFileName(csvname);
			csvAttc.setBody(csvBlob);
	      
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        string[] toaddress = New String[] {getValue('ReqQuoteEmail')};
	        mail.setSubject(getValue('ReqQuoteEmailSubject') +' '+  o.account__r.name);           
	        mail.setPlainTextBody(getValue('ReqQuoteEmailText')+ '\r\n\r\n' +
	        					  'Customer: ' + o.account__r.name +'\r\n\r\n' +
	        				      'Requestor: ' + UserInfo.getName() + '\r\n\r\n' +
	        					  'Request Date: ' + date.today().format());
	        mail.setToAddresses(toaddress); 
	        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});           
	        if (!isApexTest) Messaging.sendEmail(New Messaging.SingleEmailMessage[] {mail});
	        emailSent=true;  
		}    	  	
    }
    
    
    // Wrapper method for "main" that we will call in the Test Class
    public void mainForTestSuccess(Id lineId){
        isApexTest = true;
        apexTestResponse = '<?xml version="1.0" encoding="UTF-8"?>' + 
        '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"' +
        ' xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'+ 
        ' xmlns:ns0="http://viasat.com/SerialNumber/types"><env:Body><ns0:sendResponse>&lt;?xml version="1.0"' +
        ' encoding="utf-8"?&gt;&lt;order&gt;&lt;linecount&gt;2&lt;/linecount&gt;&lt;account&gt; 001V000000CqfbfIAB' + 
        '&lt;/account&gt;&lt;orderlines&gt;&lt;line sfrowid="'+lineId+'" ibinstanceid="15880531" itemdesc="UNIT ASSY, VMBR-1510, '+
        'AC INPUT, ARCLIGHT"&gt;valid&lt;/line&gt;&lt;/orderlines&gt;&lt;/order&gt;</ns0:sendResponse></env:Body></env:Envelope>';
    }
    
    
     public void mainForTestError(Id lineId1, Id lineId2){ 
        isApexTest = true;
        apexTestResponse = '<?xml version="1.0" encoding="UTF-8"?>'+
        '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"'+
        ' xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'+
        ' xmlns:ns0="http://viasat.com/SerialNumber/types"><env:Body><ns0:sendResponse>&lt;?xml version="1.0"'+
        ' encoding="utf-8"?&gt;&lt;order&gt;&lt;linecount&gt;2&lt;/linecount&gt;&lt;account&gt; 001V000000CqfbfIAB'+
        ' &lt;/account&gt;&lt;orderlines&gt;&lt;line sfrowid="'+lineid1+'" ibinstanceid="15880531"'+
        ' itemdesc="UNIT ASSY, VMBR-1510, AC INPUT, ARCLIGHT"&gt;valid&lt;/line&gt;&lt;line sfrowid="'+lineid2+'"'+
        ' errorcode="-1" errormessage="Part Number is invalid Serial Number is Invalid"&gt;invalid&lt;/line&gt;&lt;/orderlines&gt;'+
        '&lt;/order&gt;</ns0:sendResponse></env:Body></env:Envelope>';
    }   
    
    
    
    
}