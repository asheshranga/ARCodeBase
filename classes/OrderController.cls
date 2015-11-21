/*
    Controller to the OrderEdit.page
*/
public with sharing class OrderController
{
    ApexPages.StandardController controller;
       
    //--- Conrtroller objects
    public Order__c o {get;set;}    
    public List<OrderLine__c> orderlines{get;set;}
    public boolean showlabel{get;set;}
    public String label{get;set;}
 
    public void changelabel()
    {
        label='Ship To Address';       
        if(o.Drop_Shipment__c==true)
        {
            showlabel=true;
            label= 'Drop To Address';
            o.ShipToAddress__c=null;
        }
        else if(o.Drop_Shipment__c==false)
        {
            showlabel=false;
            label= 'Ship To Address';
            o.ShipToAddress__c=null;
        }
    }

    // notes and attachments
    Transient Public Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }

    public List<Attachment> getlistattachments()
    {
        List<Attachment> listattachments = [Select CreatedBy.Name,Id,LastModifiedDate,Name,ParentId from Attachment where parentid =: o.id]; 
        return listattachments;
    }
    
    // Static variable that assumes a test is not running
    public static boolean isApexTest = false;
    public static String apexTestResponse = '';
    
    private String errorMessage;   
    public List<OrderLine__c> orderlinesdelete = new List<OrderLine__c>();
    public boolean editRMA {get {return (editRMA == null) ? true:false;} set;}    
    public String accountName {get {return (accountName == null) ? o.account__r.name:accountName;} set;}
    public String accountId {get {return (accountId == null) ? o.account__c:accountId;} set;}
    
    public String sortField{get;set;}    
    public PageReference toggleSort () {return null;}
    public String priorPage {get; set;}
    public boolean test {get; set;}
    public Id oldShipToAddress{get; set;}
    public Id newShipToAddress{get;set;}
   
    public String addressLookupKeyPrefix{get;set;}

    //--- For checkbox selection and remove lines    
    public Boolean lineUnchecked {get {return false;} set;}    
    public String linesSelected {get;set;}
    public string linesUnSelected{get;set;}
    
    public String selectedOrderTypeId {get;set;}
    public String selectedServiceTypeId {get;set;}
    
    
    // --------- Added for Nbnco users creating RMA record through portal
    public Id NbnuserprofileId;
    public Id NbncontactId;
    public string profilename;
    public boolean NbnCoCreateRMA{get;set;}
    public List<Profile> Profilelist = new List<Profile>();
    
    // ---end of------ Added for Nbnco users creating RMA record through portal
    
    // Warranty Check : list of unwanted line for RMA
    private list<OrderLine__c> unwantedListRMA=null;
    
    
    private Order__c getOrder(String asId)
    {
        return [select Id, name, account__c, account__r.name, Requestor__c,
                ShipToAddress__c,ShipToAddress__r.EBSAddressID__c, BillToAddress__c, BillToAddress__r.EBSAddressID__c,
                partialshipment__c, PreferredCarrier__c, CarrierAccount__c, Status__c, OracleOrder__c, CustomerPO__c,
                Drop_Shipment__c,FAA81303Required__c, AgreetoRMAReturnConditions__c, AgreetoTermsConditions__c, NotesComments__c, ComSecDoDAACRequirement__c, ComSecDoDAACRequirementReviewed__c, BypassWarrantyCheck__c, OrderTypeId__c, ServiceTypeId__c,Advance_Replacement_Required__c, case__c 
                , ErrorDescription__c, ErrorCode__c, OrderType__c 
                from order__c
                where Id = :asId];
    }
    
    private List<OrderLine__c> getOrderLines(String asId)
    {
    //------- Added for unchecking checked order line item for deletion
        list<OrderLine__c> delunchecklist= new list<OrderLine__c>();
        list<OrderLine__c> Temp= new list<OrderLine__c>();
        delunchecklist = [Select Id, name, PartNumber__c, Part_Number_2__c, SerialNo__c, ErrorCode__c, ErrorDescription__c, Marked_For_Deletion__c, Status__c, 
                        ShipToAddress__c, ShipToAddress__r.EBSAddressID__c, Product_Description__c, ReturnReasonDescription__c, Item_Description__c, InWarranty__c, SelectedLines__c
                        from OrderLine__c 
                        where order__c = :asId order by CreatedDate];
        for(OrderLine__c ordl : delunchecklist)
        {
            if(ordl.Marked_For_Deletion__c == true)
                ordl.Marked_For_Deletion__c = false;
            Temp.add(ordl);      
        }
        return Temp;
    }
    
    private List<OrderLine__c> getOrderLinesRMA(String asId)
    {
                        
        //------- Added for unchecking checked order line item for deletion
        list<OrderLine__c> delunchecklist= new list<OrderLine__c>();
        list<OrderLine__c> Temp= new list<OrderLine__c>();
        
       
        delunchecklist = [Select Id, name, PartNumber__c, Part_Number_2__c, SerialNo__c, ErrorCode__c, ErrorDescription__c,Marked_For_Deletion__c , 
                        ShipToAddress__c,ShipToAddress__r.EBSAddressID__c, Product_Description__c, ReturnReasonDescription__c, Item_Description__c,InWarranty__c,SelectedLines__c
                        from OrderLine__c 
                        where order__c = :asId AND SelectedLines__c=true AND InWarranty__c=true order by CreatedDate];
                                
                        
        for(OrderLine__c ordl : delunchecklist)
        {
            if(ordl.Marked_For_Deletion__c == true)
                ordl.Marked_For_Deletion__c = false;
            Temp.add(ordl);                
        }
        
        // clear the lines not in Warranty or not selected
        // to avoid keeping unwanted lines
        unwantedListRMA= [Select Id, InWarranty__c from OrderLine__c where order__c = :asId AND (InWarranty__c=false OR SelectedLines__c=false)];
        
                      
        
        return Temp;        
    }
    //-------------------------------------------------------------------------
    //---Initialize the controller    
    //-------------------------------------------------------------------------
    public OrderController(ApexPages.StandardController stdController)
    {
        controller = stdController;        
        priorPage = ApexPages.currentPage().getHeaders().get('Referer');       
        addressLookupKeyPrefix = Address__c.SObjectType.getDescribe().getKeyPrefix();
        
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
            //o.status__c='Cancelled';
        }   
          
        //This is to let admin to to edit page.
        if(!UserInfo.getProfileId().equals(System.Label.RMAAdminProfile))
        {
            //--- Check if customer is allowed to edit the RMA, based on RMA Status    
            if((!UserInfo.getUserType().equalsIgnoreCase('Standard')) && (o.status__c != null) && ((';'+System.Label.RMACustomerEditStatus+';').indexOfIgnoreCase(';'+o.status__c+';') < 0))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You do not have the level of access necessary to edit a Return Request which is in \'' + o.status__c + '\' status.'));
                editRMA = false;
                return;
            }
            //--- Check if RMA can be edited at all, based on RMA Status
            if ((o.status__c != null) && ((';'+System.Label.RMANoEditStatus+';').indexOfIgnoreCase(';'+o.status__c+';') >= 0))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Sorry can\'t edit a Return Request which is in \'' + o.status__c + '\' status.'));
                editRMA = false;
                return;
            }
            if(o.Drop_Shipment__c==true)
                test=true;
            else
                test=false;
        }

        if(o.Drop_Shipment__c==true)
        {
            showlabel=true;
            label= 'Drop To Address';
        }
        else if(o.Drop_Shipment__c==false)
        {
            showlabel=false;
            label= 'Ship To Address';
        }

        //--- Set default values...
        //--- a. Default Account 
        if (o.account__c == null)
        {
            //--- default the account if use has access to only one account
            //--- if rows returned is 1 means user has access to only one account
            //--- we are limiting the rows to 2 for performance (2 or more we can't default the address)
            String excludeList = System.Label.RMAExcludedAccountList;
            String [] excludeListArr = excludeList.split(';');
            List<Account> aa = [select id, name from account where  Name NOT IN :excludeListArr LIMIT 2];
           
            if (aa.size() == 1)
            {
                o.account__c = aa[0].id;
                accountId    = aa[0].id;
                accountName  = aa[0].name;
            }   
        }
            
        //--- d. Default contact
        if (o.requestor__c == null)
        {
            for (user u : [select contactid from user where id = :UserInfo.getUserId()])
            {
                o.requestor__c = u.contactid;
                NbncontactId = u.contactid;
            }   
        }
        
        // --------- Added for Nbnco users creating RMA record through portal
        
        NbnuserprofileId = UserInfo.getProfileId();
        Profilelist = [Select Id, Name from Profile where Id =: NbnuserprofileId];
        
        for(profile prof: Profilelist)
            profilename = prof.Name;
            
        if( System.Label.RMA_Nbnco_User_profile.contains(profilename))
        {
            NbnCoCreateRMA = true;
            for( Contact cont : [Select Id, AccountID from Contact where Id =:NbncontactId])
                o.account__c = cont.AccountID;
        }
        else
            NbnCoCreateRMA = false;
        
        //------- default values when Nbnco profile creates RMA request 
        if(NbnCoCreateRMA == true)
        {
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

        //--- Default addresses
        defaultAddressInfo(false);
            
        //--- Add additional lines for user to enter       
        getLines(false);   

        //--- Save Old value for Header ShipTo
        oldShipToAddress = o.ShipToAddress__c;

        // for attachment
        // att =(Attachment)controller.getRecord();
        // att =[SELECT id,name from Order__c WHERE id=: o.Id];
        //insert ORDId;
        //  List<attachment> attach = new List<attachment>();
        //  attach=[SELECT Name FROM Attachment WHERE];
        //  insert attach;
    }
    
    //-------------------------------------------------------------------------
    //--- Default bill and shipping addresses based on account
    //-------------------------------------------------------------------------
    public void defaultAddresses() {       
        defaultAddressInfo(true);
    }
    
    private void defaultAddressInfo(boolean abIgnoreExistingAddress) {      
        if (abIgnoreExistingAddress==true) {
            o.Requestor__c     = null;
            o.shiptoaddress__c = null;
            o.billtoaddress__c = null;
        }    
        //--- b. Default ship to address
        if (o.shiptoaddress__c == null) {
            for (address__c a : [select id, name from address__c where account__c=:accountId  and type__c = 'Ship To' and default__c = true LIMIT 1])
                o.shiptoaddress__c = a.id;
        }   

        //--- c. Default bill to address
        if (o.billtoaddress__c == null) {
            for (address__c a : [select id, name from address__c where account__c=:accountId  and type__c = 'Bill To' and default__c = true LIMIT 1])
                o.billtoaddress__c = a.id;
        }     
    }
    
    //-------------------------------------------------------------------------
    //--- Get order lines and add more lines
    //-------------------------------------------------------------------------
    public void getLines() {
        getLines(true);
    }
    public void getLines(Boolean abSave)
    {
        if (abSave) 
        {
            saveRMA();
            if (errorMessage != null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
                return;
            }   
        }
      
        //--- Get the order lines...
        Boolean lineSelection = (apexpages.currentpage().getparameters().get('lineSelection')=='1')?true:false;
              
        if(lineSelection)
            orderlines = getOrderLinesRMA(o.id);                                                               
        else
            orderlines = getOrderLines(o.id);               
            
        //--- Now add additional empty lines...
        for (integer j=1;j<=5;j++) {
            OrderLine__c ol = new OrderLine__c();
            ol.recordtype =  [select Id from RecordType where Name = :System.Label.RMALineRecordType and SobjectType = 'OrderLine__c'];                  
            ol.order__c = o.id;
            orderlines.add(ol);
        }    
    }
    
    //-------------------------------------------------------------------------
    //---- Remove selected lines
    //-------------------------------------------------------------------------
   public  PageReference removeLines() 
    {
        try {
            saveRMA();
            list<OrderLine__c> deletelist= new list<OrderLine__c>();
            deletelist=[select id from OrderLine__c where Order__c=:ApexPages.currentPage().getparameters().get('Id') and Marked_For_Deletion__c=:true];
          
            if(deletelist.size()>0)
                delete deletelist;
        }
        catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));      
        }
        //return null;
        PageReference loReadPage = new PageReference('/apex/OrderEdit?scontrolCaching=1&sfdc.override=1&retURL=%2F'+o.id+'&id='+o.id);
            return loReadPage.setRedirect(true);
    }
    
    //-------------------------------------------------------------------------
    //--- Upload lines from a file
    //-------------------------------------------------------------------------
    public PageReference uploadLines()
    {
        //--- Save the RMA before uploading the lines
        saveRMA();
         
        if (errorMessage != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }
        else{
            PageReference loUploadPage = new PageReference('/apex/RMALinesUpload');
            loUploadPage.getParameters().put('rmaid',o.id);
            return loUploadPage.setRedirect(true); 
        }      
    }

    //-------------------------------------------------------------------------
    //--- Save the order and order lines
    //-------------------------------------------------------------------------
    
    public PageReference save() 
    {
        //saveRMA(); - savedoc() method calls saveRMA() as well
        savedoc();
       
        if (errorMessage !=null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        }else{
            //--- Save is successful, take the user to read-only RMA screen
            PageReference loReadPage = new PageReference('/'+o.id);
            return loReadPage.setRedirect(true);           
        }
    }
      
    public void saveRMA()
    {
        try{
            errorMessage = null;

            //--- Need these two validations - since Salesforce doesn't do the required field validation on checkboxes
            //--- Alternately, we can create the validation rule and not have the below two conditional checks code.
            if (o.AgreetoTermsConditions__c==false) {
                errorMessage = 'Please accept the terms and conditions';
                return;      
            }
            if (o.AgreetoRMAReturnConditions__c==false) {
                errorMessage = 'Please accept the Return Request term conditions'+selectedServiceTypeId;
                return;   
            }
            if(o.PreferredCarrier__c != null && o.CarrierAccount__c == ''){
                errorMessage = 'Please enter Carrier Account';
                return;           
            } 
            if(selectedOrderTypeId != null && selectedOrderTypeId != '')
            {
                if((RMAOrderTypeSelectList__c.getInstance(selectedOrderTypeId).OrderTypeCategory__c == 'DRO') && (selectedServiceTypeId == null))
                {
                    errorMessage = 'Please select Service Type from select list';
                    return;
                }
            }

            //Set Order type and Service Type Fields
            if(selectedOrderTypeId != null && selectedOrderTypeId != '')
            {
                o.OrderType__c = RMAOrderTypeSelectList__c.getInstance(selectedOrderTypeId).OrderTypeName__c;
                o.OrderTypeId__c = selectedOrderTypeId;
            }
            else{
                o.OrderType__c = '';
                o.OrderTypeId__c = '';
            }
            if(selectedServiceTypeId != null && selectedServiceTypeId != '')
            {
                o.ServiceType__c = RMAServiceTypeSelectList__c.getInstance(selectedServiceTypeId).ServiceTypeName__c;
                o.ServiceTypeId__c = selectedServiceTypeId;
            }
            else{
                o.ServiceType__c = '';
                o.ServiceTypeId__c = '';
            }

            //--- Add/Update the Order 
            if (o.id == null){
                insert o;
            } else{
                update o;
            }
            
            // Clear the unwanted lines - Warranty Check Update
            if (unwantedListRMA != null && unwantedListRMA.size() > 0  )
            {                        
                delete unwantedListRMA;
                unwantedListRMA=null; 
            }

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
                else if ((!lsPartNumber.equals('')) || (!lsSerialNumber.equals(''))) 
                {
                    ol.ErrorCode__c        = null;
                    //--- Check to see if both part and serial numbers are provided
                    if ((lsPartNumber.equals('')) || (lsSerialNumber.equals('')) || (lsReturnReason.equals(''))) {
                        lbLineError            = true;
                        ol.ErrorCode__c        = '1';
                        //ol.ErrorDescription__c = 'Part Number, Serial Number and Return Reason fields are required.';
                        ol.Item_Description__c = 'Part Number, Serial Number and Return Reason fields are required.';
                    }
                    //--- Now check to see if the line needs to be added or updated
                    if (ol.id == null)
                        orderlinesnew.add(ol);
                    else   
                        orderlinesupdate.add(ol);
                }
               if(o.Status__c != System.Label.RMACustomerEditStatus)
                {                   
                    if(ol.ShipToAddress__c == oldShipToAddress)
                        ol.ShipToAddress__c = o.ShipToAddress__c;
                }
            }
            if (lbLineError) {
                errorMessage = 'Unable to save the Line(s), validation failed. Please review the lines errors.';
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
            errorMessage = 'Unable to save Return Request: ' + de.getMessage();
        } catch (Exception e) {
            errorMessage = 'Unable to save Return Request: ' + e.getMessage();
        }            
    }
     
    //-------------------------------------------------------------------------
    //--- Call the web service to validate the lines before submitting the order
    //-------------------------------------------------------------------------
    public String invokeExternalWs()
    {
        String lsReturn = '';
        HttpRequest req = new HttpRequest();

        //--- Set HTTPRequest Method
        req.setMethod('POST');
        req.setEndpoint(System.Label.OrderValidationWebService);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', System.Label.OrderValidationWebService);   

        //--- Construct the XML Playload for SOAP message
        string lsSOAPMsg = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://viasat.com/SerialNumber/types">'+
                            '   <soapenv:Header/>'+
                            '   <soapenv:Body>'+
                            '      <typ:order>'+
                            '         <typ:linecount> ' + orderlines.size() + ' </typ:linecount>'+
                            '         <typ:account> ' + o.account__c + ' </typ:account>'+
                            '         <typ:orderlines>'+
                            '            <!--Zero or more repetitions:-->';
                         
        String lsOrderLines = '';                   
        for (OrderLine__c ol : orderlines)
        {
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
        Http http = new Http();
        XmlStreamReader loResponse; 
        if(!isApexTest){        
            HTTPResponse res = http.send(req);   
            //--- Parse the sendResponse element in the response XML          
            loResponse = new XmlStreamReader(res.getBody());
        }
        else{
            loResponse = new XmlStreamReader(apexTestResponse); 
        } 

        while (loResponse.hasNext()) 
        {
            if ((loResponse.getEventType() == XmlTag.START_ELEMENT) && ('sendResponse' == loResponse.getLocalName())) 
            {
                while(loResponse.hasNext()) 
                {
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
    
    //-------------------------------------------------------------------------
   //--- Submit the RMA - init Action on OrderEdit.page
    //-------------------------------------------------------------------------
    public void submitAction()
    {
        //--- Check to see if the user is submitting the RMA
        String lsSubmit = ApexPages.currentPage().getParameters().get('submit');
        Cookie theCookie = ApexPages.currentPage().getCookies().get('DOLIKCZXHW');
        String submitActionCookie = null;
        if(theCookie != null) 
            submitActionCookie = theCookie.getValue();
        if (((editRMA == null) || (editRMA == true)) && (lsSubmit != null) && (lsSubmit.equalsIgnoreCase('1')) && submitActionCookie != null && submitActionCookie == 'YUBXYEICII') 
        {
            submitRMA();
            if (errorMessage !=null) 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            else 
            {
                editRMA = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully submitted the Return request.'));
            } 
        }

        //--- Now remove the cookie
        Cookie DOLIKCZXHW = new Cookie('DOLIKCZXHW','ILDMRBNFVM',null,0,false);
        ApexPages.currentPage().setCookies(new Cookie[]{DOLIKCZXHW});          
        ApexPages.currentPage().getParameters().put('submit','0');       
    }
    
    public PageReference submit()
    {
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
            PageReference loRMAPage = new PageReference('/apex/OrderEdit');
            loRMAPage.getParameters().put('id',o.id);
            loRMAPage.getParameters().put('submit','1');
            return loRMAPage.setRedirect(true);           
        }
    }
    
    public void submitRMA() 
    {
        boolean lbFoundLineErrors = false;
        boolean lbNewAddress      = false;
        try 
        {   
            errorMessage = null;
            orderlines = getOrderLines(o.id); 
                                            
            //--- If no lines are found, inform the user to add at least one line item
            if (orderlines.size() <=0) {
                errorMessage = 'Please add atleast one line item to submit the Return request.';   
                return;             
            }
            system.debug('---o.OrderType__c---> '+o.OrderType__c);  
            //--- Skipping Lines validation if order/return type is not null :Case-00538541
            if (o.OrderType__c==null) {    
                //--- Validate the lines before submitting the RMA
                String lsReturn = invokeExternalWs();
    
                //--- Get the line Ids and Info from response object
                Set<Id> lineIds = new Set<Id>();  
                Map<Id,List<String>> loResponseLines = new Map<Id, List<String>>();
    
                //--- a. Parse the response stream only for lines
                XmlStreamReader loResponse = new XmlStreamReader(lsReturn);
                while (loResponse.hasNext())
                {
                    if ((loResponse.getEventType() == XmlTag.START_ELEMENT) && ('line' == loResponse.getLocalName())) 
                    {
                        //--- b. Get the Line element attribute values
                        Id lineId = (Id)loResponse.getAttributeValue(null,'sfrowid');
                        List<String> lineInfo = new List<String>();
                        lineInfo.add(loResponse.getAttributeValue(null,'errorcode'));
                        lineInfo.add(loResponse.getAttributeValue(null,'errormessage'));
                        lineInfo.add(loResponse.getAttributeValue(null,'itemdesc'));
    
                        //--- c. Get Line element value
                        //lineInfo.add(loResponse.getText());
                        
                        //--- d. Add the line info to add it to the actual line object later
                        lineIds.add(lineId);
                        loResponseLines.put(lineId,lineInfo);
                    }
                    loResponse.next();
                }
    
                o = getOrder(o.id);
                 
                //--- Reset the order lines to merge the line info got from the response above
                orderlines = new List<OrderLine__c>();
                for(OrderLine__c ol : [select Id, name, PartNumber__c, Part_Number_2__c, SerialNo__c, ErrorCode__c, ErrorDescription__c, 
                                        ShipToAddress__c, ShipToAddress__r.EBSAddressID__c, Product_Description__c, ReturnReasonDescription__c, Item_Description__c
                                        from OrderLine__c 
                                        where Id IN :lineIds]) 
                {
                    List<String> lineInfo = loResponseLines.get(ol.Id);
    
                    if (lineInfo != null) 
                    {
                        ol.ErrorCode__c        = lineInfo.get(0);
                        ol.Item_Description__c = lineInfo.get(1); 
                        if (ol.Item_Description__c != null)
                        {
                            ol.ErrorCode__c        = '1';        
                            lbFoundLineErrors = true;
                            ol.Status__c = System.Label.RMALineInvalidStatus;
                        }
                        else{
                            ol.ErrorCode__c        = null;   
                            ol.Status__c = System.Label.RMACustomerEditStatus;
                            ol.Item_Description__c = lineInfo.get(2);        
                        }
                        //---Check if the address selected on the line is a new address
                        if ((ol.ShipToAddress__c != null) && ((ol.ShipToAddress__r.EBSAddressID__c == null) || (ol.ShipToAddress__r.EBSAddressID__c.trim().equals('0'))))
                        {    
                            lbNewAddress = true;
                            ol.Status__c = System.Label.RMANewAddressStatus;
                        }
                        if(ol.ShipToAddress__c == null)
                            ol.ShipToAddress__c = o.ShipToAddress__c;
    
                        orderlines.add(ol);
                    }
                }
            }
            
            system.debug('---o.OrderType__c---> '+o.OrderType__c);  
            if (lbFoundLineErrors) 
            {
                errorMessage = 'Unable to submit the Return request, line(s) validation failed. Please review the lines errors.';
                update orderlines;
            }
            else
            {
            // Before updating & re-submitting, check if order had an error during Processing in Oracle
            // If so, then reset all already submitted order items with status == Oracle Processing to Pending Submission 
            boolean gotOracleIssue = false;
system.debug('*** orderlines: ' + orderlines);
            if ( o.ErrorDescription__c != null && o.ErrorDescription__c != '' && o.Status__c == System.Label.RMASubmittedStatus)
            {
                for(OrderLine__c ol : orderlines)
                {
                    if (ol.Status__c == System.Label.RMASubmitStatus || ol.Status__c == System.Label.RMACustomerEditStatus)
                    {
                        gotOracleIssue = true;
                        break;
                    }
                }
            }
            if (gotOracleIssue)
            {
                o.ErrorDescription__c = null;
                o.ErrorCode__c = null;
                o.Status__c = System.Label.RMACustomerEditStatus;  
                for(OrderLine__c ol : orderlines)
                {
                    ol.Status__c = (ol.Status__c == System.Label.RMASubmitStatus ? System.Label.RMACustomerEditStatus : ol.Status__c);
                }
                errorMessage = System.Label.RMAResubmitMessage;
                update o;
                update orderlines;
                editRMA=false;             
            }
            else
            {
                //o = getOrder(o.id); GOT ALREADY
                //--- Check if Compusec DODAAC is set to Yes
                if(o.ComSecDoDAACRequirement__c == 'Yes' && o.ComSecDoDAACRequirementReviewed__c == false)
                    o.Status__c = System.Label.RMAComSecDoDAAc;
                else
                {
                    //--- Check if the address selected is a new address
                    if(lbNewAddress == true)
                        o.status__c = System.Label.RMANewAddressStatus;
                     
                    if ((lbNewAddress == false) && ((o.ShipToAddress__r.EBSAddressID__c == null) || (o.ShipToAddress__r.EBSAddressID__c.trim().equals('0')) ||
                          (o.BillToAddress__r.EBSAddressID__c == null) || (o.BillToAddress__r.EBSAddressID__c.trim().equals('0'))))
                    {
                        lbNewAddress = true;
                        o.status__c = System.Label.RMANewAddressStatus;
                    }
                    if(!lbNewAddress)
                    {  
                        o.status__c = System.Label.RMASubmitStatus;
                        for(OrderLine__c ol : orderlines)
                            ol.Status__c = System.Label.RMASubmitStatus;
                    }
                }
                update o;
                update orderlines;

                editRMA=false;             
                redirectPage(); 
            }
            }             
        }catch (Exception e) {
            errorMessage = 'Unable to submit the Return request - ' + e.getMessage();   
        }    
    }
    
    public PageReference redirectPage()
    {       
        PageReference loRMAPage = new PageReference('/apex/OrderEdit');
        loRMAPage.getParameters().put('id',o.id);
        loRMAPage.getParameters().put('submit','0');
        return loRMAPage.setRedirect(true);           
    }

    public PageReference escalateToCSR()
    {
        saveRMA();     
        if (errorMessage !=null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        } else {
            //--- Save is successful, take the user to read-only RMA screen
            PageReference notePage = new PageReference('/apex/RMANotes');
            notePage.getParameters().put('rmaid',o.id);
            return notePage.setRedirect(true); 
        }       
    }    

    public PageReference deleteRMA()
    {
        if(o.id != null)
        {
            o.Status__c = System.Label.RMACancelStatus;
            update o;
        }
        PageReference loReadPage = new PageReference('/'+o.id);
        return loReadPage.setRedirect(true); 
    }
    
    // Action on commandButton "Attach File"
    public void savedoc()
    {
        saveRMA();
        string orderId=o.id;

        if (errorMessage !=null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            // return null;
        }
        else if(myfile.name!=null){
            Transient attachment a = new attachment(parentId = orderId, name=myfile.name, body = myfile.body);  
            try{       
                insert a; 
            }catch (DMLException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Error uploading attachment, Please check the file size'));
                // return null;
            }
        }
        else if(myfile.name==null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please Browse and select a file to Attach'));
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Browse and select a file to Attach'));

        // PageReference loReadPage = new PageReference('/'+o.id);
        //  return loReadPage.setRedirect(true);
    }
   
    public PageReference viewAttachment() {
        string attid=apexpages.currentpage().getparameters().get('attachmentid');
        pagereference pag= new pagereference('/servlet/servlet.FileDownload?file='+attid);       
        return pag;
    }
    
    public PageReference editAttachment() {
        string attid1=apexpages.currentpage().getparameters().get('attachmentid');
        pagereference pag= new pagereference('/'+attid1+'/e?retURL=%2F'+o.id);
        pag.setredirect(true);
        return pag;
    } 
 
    public void delAttachment() {
        string attid=apexpages.currentpage().getparameters().get('attachmentid');      
        attachment tempAttachment = new attachment();
        tempAttachment =[select Id from Attachment where id =:attid]; 
        delete tempAttachment;
    }
    
    public List<selectOption> orderTypes {
        get {
            List<selectOption> options1 = new List<selectOption>();
            List<selectOption> options2 = new List<selectOption>();
            List<selectOption> options = new List<selectOption>();  
            List<RMAOrderTypeSelectList__c> objlist1 = new List<RMAOrderTypeSelectList__c>();
            List<RMAOrderTypeSelectList__c> objlist2 = new List<RMAOrderTypeSelectList__c>();
            
            objlist1 =[select OrderTypeName__c,Name from RMAOrderTypeSelectList__c where OrderTypeCategory__c='RMA' ORDER BY OrderTypeName__c];
            objlist2 =[select OrderTypeName__c,Name from RMAOrderTypeSelectList__c where OrderTypeCategory__c='DRO' ORDER BY OrderTypeName__c];
            
            for(integer i=0;i<objlist1.size();i++)
                options1.add(new SelectOption(objlist1[i].Name, objlist1[i].OrderTypeName__c));
            
            for(integer j=0;j<objlist2.size();j++)
                options2.add(new SelectOption(objlist2[j].Name, objlist2[j].OrderTypeName__c));

            options.add(new SelectOption('', '--None--'));
            options.addAll(options1);
            options.addAll(options2);       

            return options;
        }
        set;
    }
    
    public List<selectOption> serviceTypes {
        get {
            List<selectOption> options = new List<selectOption>();
            options.add(new SelectOption('', '--None--'));
            for(RMAServiceTypeSelectList__c stype : RMAServiceTypeSelectList__c.getAll().values())
                options.add(new SelectOption(stype.Name, stype.ServiceTypeName__c));
            return options;
        }
        set;
    }
       
    public pageReference redirectToObject() {   
        Schema.DescribeSObjectResult r = Order__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        string url = '/'+keyPrefix+ '/o';
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;   
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
        
    public void mainForTestError(){ 
        isApexTest = true;
        apexTestResponse = '<?xml version="1.0" encoding="UTF-8"?>'+
        '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"'+
        ' xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'+
        ' xmlns:ns0="http://viasat.com/SerialNumber/types"><env:Body><ns0:sendResponse>&lt;?xml version="1.0"'+
        ' encoding="utf-8"?&gt;&lt;order&gt;&lt;linecount&gt;2&lt;/linecount&gt;&lt;account&gt; 001V000000CqfbfIAB'+
        ' &lt;/account&gt;&lt;orderlines&gt;&lt;line sfrowid="a0UV0000001NfAmMAK" ibinstanceid="15880531"'+
        ' itemdesc="UNIT ASSY, VMBR-1510, AC INPUT, ARCLIGHT"&gt;valid&lt;/line&gt;&lt;line sfrowid="a0UV0000001eYDgMAM"'+
        ' errorcode="-1" errormessage="Part Number is invalid Serial Number is Invalid"&gt;invalid&lt;/line&gt;&lt;/orderlines&gt;'+
        '&lt;/order&gt;</ns0:sendResponse></env:Body></env:Envelope>';
    }   

    public void mainForTestError2(){ 
        isApexTest = true;
        apexTestResponse = '<?xml version="1.0" encoding="UTF-8"?>'+
        '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"'+
        ' xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'+
        ' xmlns:ns0="http://viasat.com/SerialNumber/types"><env:Body><ns0:sendResponse>&lt;?xml version="1.0"'+
        ' encoding="utf-8"?&gt;&lt;order&gt;&lt;linecount&gt;2&lt;/linecount&gt;&lt;account&gt; 001V000000CqfbfIAB'+
        ' &lt;/account&gt;&lt;orderlines&gt;&lt;line sfrowid="$$$$$$$$" ibinstanceid="15880531"'+
        ' itemdesc="UNIT ASSY, VMBR-1510, AC INPUT, ARCLIGHT"&gt;valid&lt;/line&gt;&lt;line sfrowid="a0UV0000001eYDgMAM"'+
        ' errorcode="-1" errormessage="Part Number is invalid Serial Number is Invalid"&gt;invalid&lt;/line&gt;&lt;/orderlines&gt;'+
        '&lt;/order&gt;</ns0:sendResponse></env:Body></env:Envelope>';
    }   
}