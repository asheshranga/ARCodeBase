/*************************************************************************************************************************************************************************************
Created By    : Nazeer Ahamed
Use of Class  : 
Company Name  : NTT DATA,Inc. 
Modified By   : Rajesh Kaliyaperumal
**************************************************************************************************************************************************************************************/

public with sharing class ToowayOrderAdminController
{
    public boolean TerminalSave=false;  
    public boolean restrictSelectedSave = true;
    public boolean stopper = true;
    @testvisible private String errorMessage; 
    public boolean Nospares{get;set;}
    public boolean chkCustomerPO{get;set;}   
    public boolean SparesQtyCheck{get;set;}
    public boolean TerminalsQtyCheck{get;set;}
    public boolean viewmode{get;set;}
    public Order__c order {get; set;}    
    public boolean selected{get;set;}
    public Map<String, Map<Decimal, list<string>>> objectMap {get; set;}
    public Map<Decimal,list<string>> terminalmap{get;set;}
    public List<neworderlist> oderlinelist{get; set;}
    public List<neworderlist> orderTerminal{get; set;}    
    public String addressLookupKeyPrefix {get;set;}
    public String addressLookupKeyPrefix2 {get;set;}
    public String addressLookupKeyPrefix3 {get;set;}
    public boolean OrderStatus{get;set;}
    public String OrderStatusOutputField{get;set;}
    public boolean OtherStatus{get;set;}
    public boolean profiledetail{get;set;}
    public boolean Discount{get;set;}
    public boolean CancelOrder{get;set;}
    //public boolean shippingsection{get;set;}
    public boolean DiscountSection{get;set;}
    public String profiledetailOutputField{get;set;}
    public boolean submitHelpTxt{get;set;}
    public boolean checkcontract{get;set;}
    public boolean CAuser{get;set;}
    //public Decimal Sparesqntyupd{get;set;}
    public string quantity{get;set;}
    public string spares{get;set;}
    public string fees{get;set;}
    public Decimal subtotal{get;set;}
    public Decimal subtotalTerminals{get;set;}
    public Decimal ProcessFeePrice{get;set;}
    public Decimal ProcessFeeLinePrice{get;set;} 
    public Decimal ProcessFeeTotal{get;set;}        
    Public String listDesctest1{get; set;}
    Public String listDesctest2{get; set;}
    public Decimal ShippingCost{get;set;}
    public Decimal Totalcost{get;set;}           
    public String orderId;    
//    public Id orderRecordType;
    public boolean TerminalsQty{get;set;}
    public Date ocDate{get;set;}
    public String accountId {get;set;}
    public String addressId {get; set;}
    public Map<id,OrderPrice__c> mapOrderprice;
   
    List<Contact> shiptoadd = new List<Contact>();
    List<Contact> billtoadd = new List<Contact>();
    List<OrderLine__c> SparesOLsavelist = new List<OrderLine__c>();
    List<Contact> contactList = new List<Contact>();
    User usr = new User();
    string sfURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
    string userId;
    string email; 
    public boolean isTermandCondition{get;set;}
    public boolean isTandCURL{get;set;}
    public string URLText{get;set;}
    public string labelText{get;set;}
    
    // case 316272
    public string shippingCostLabel {get; set;}
    public Boolean shippingCostVisible {get {return shippingCostLabel != null && shippingCostLabel.length() > 0;}} 
    public Boolean terminalPriceListVisible {get; set;}
    public Boolean sparePriceListVisible {get; set;}
    public Boolean deliveryMethodRequired {get; set;}
    public Boolean requestedDeliveryDateRequired {get; set;}
    
    public Integer currentRow {get; set;}
    //---To determine portal/internal user
    public boolean isPortalUser{get;set;}
       
    // This is to check availability for respective account
    public pageReference checkcontract()
    {
        list<contract> tempcontract= new list<contract>();
        string temp =apexpages.currentpage().getparameters().get('id');
        if(temp !='' && temp!=null)
        {           
            order__c o = [select id,Contract__c from order__c where id=:apexpages.currentpage().getparameters().get('id')];
            tempcontract = [select id,AccountId,Spares_Quantity__c,TermsCondition__c,TermsCondition_label__c,StartDate,EndDate from contract where ContractNumber=:o.Contract__c];
            if(tempcontract.size()==0)
            {
                checkcontract=true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contract associated with this order is no longer valid, Please contact ViaSat.'));
                return null;
            }
            else
            {
                checkcontract=false;
                for(contract cont:tempcontract) {
                    if(cont.AccountId != null  && cont.TermsCondition__c == null && cont.TermsCondition_label__c != null
                    && system.today() > cont.StartDate && system.today() < cont.EndDate )                
                    {
                        system.debug('--- isTandCURL is true---');
                        isTandCURL=true;                        
                        labelText = cont.TermsCondition_label__c;
                    }  
                }
               /* for(contract cnt : tempcontract)
                    Sparesqntyupd = cnt.Spares_Quantity__c;*/
            }
        }
        
        return null;
        
             
    }
        
    public PageReference cancel() 
    {
        pagereference pag= new pagereference('/apex/Tooway_OrderHome_CustomerPortal');
        pag.setredirect(true);
        return pag;
    }
 
    public PageReference ContactyourSalesRepresentative()
    {       
      //*****************************************************************
        Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.Order__c;
        Map<String,Schema.RecordTypeInfo> ORDRectype = Orderobj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderRecByName = ORDRectype.get('Order');
        ID ORDRecTypeID= orderRecByName.getRecordTypeId();
       
            checkCustomerPO(order.Account__c,order.CustomerPO__c);
            if(chkCustomerPO == true)
                return null;
            
            checkcontract();
            if(checkcontract==true)
                return null;

            if (orderId != null && orderId != '')
            {
                if (order.AgreetoTermsConditions__c!=true) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the terms and conditions'));
                    return null;      
                }
               /* else if (order.Requested_Delivery_Datepl__c=='Delivered By' && order.Requested_Delivery_Date__c==null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Requested Delivery Date'));
                    return null;      
                } */
                else if(order.Contract__c == '' || order.Contract__c == null) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Contract associated with the Account/Order, Contact ViaSat for more information'));   
                    return null;
                }

                update order;                
                restrictSelectedSave = false; // This restricts Selectedsave() without executing on click of order Save() THis should be declared before calling SaveTerminal()
                SaveTerminal();
                if(TerminalsQtyCheck==true)
                    return null;
                    
                restrictSelectedSave = true;
                
                selectedsave();
                if(SparesQtyCheck==true || Nospares == true)
                    return null;                
              
            }
            else if (orderId == null || orderId == '')
            {
                if (order.AgreetoTermsConditions__c != true) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the terms and conditions'));
                    return null;
                }
               /* else if(order.Requested_Delivery_Datepl__c=='Delivered By' && order.Requested_Delivery_Date__c==null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Requested Delivery Date'));
                    return null;      
                } */
                else if(order.Contract__c == '' || order.Contract__c == null) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Contract associated with the Account/Order, Contact ViaSat for more information'));   
                    return null;
                }
                else
                {
                    order.RecordTypeId=ORDRecTypeID;     
                    insert order;                    
                }
            }
      //******************************************************************
       pagereference pag= new pagereference('/apex/ToowayOrderNotes?id='+Order.id);
       pag.setredirect(true);
       return pag;
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
        List<Attachment> listattachments = [Select CreatedBy.Name,Id,LastModifiedDate,Name,ParentId from Attachment where parentid =: order.id]; 
        return listattachments;
    }

    // This Method will be called from ToowayOrderAdminpage, when user selects 'Account Name' for Order Object
    // and boolean variable will be set on the basis of Terms and Conditions .
    public void ContractFields()
    {
        string temp=apexpages.currentpage().getparameters().get('idparam');
        order.Contract_Exp_Date__c = null;
        order.Contract__c = '';
        order.Delivery_Method__c = '';
        order.Payment_Terms__c = '';
       
        for(Contract con : [select Payment_Terms__c,Delivery_Method__c, ContractNumber, EndDate, TermsCondition__c, TermsCondition_label__c, AccountId, StartDate, ShippingCostLabel__c, Spares_Price_List__c, Order_Price_List__c, Display_Requested_Delivery_Date__c  
                  from contract where   Business_Type__c='Tooway' AND (AccountId=: accountId)])    
                  
        {   
            // case 316272
            ShippingCostLabel=con.ShippingCostLabel__c;
            sparePriceListVisible=(con.Spares_Price_List__c == null)?false:true;
            terminalPriceListVisible=(con.Order_Price_List__c == null)?false:true;
            deliveryMethodRequired=(con.Delivery_Method__c == 'Do Not Display')?false:true; 
            requestedDeliveryDateRequired=con.Display_Requested_Delivery_Date__c; 
            if (!requestedDeliveryDateRequired) 
             order.Requested_Delivery_Date__c=null;                      
            
                                 
            order.Contract_Exp_Date__c=con.EndDate;
            order.Contract__c=con.ContractNumber;
            order.Delivery_Method__c =(con.Delivery_Method__c != 'Do Not Display')? con.Delivery_Method__c:''; // case 316272 
            order.Payment_Terms__c=con.Payment_Terms__c;
                       
            if(con.AccountId != null  && con.TermsCondition__c != null && con.TermsCondition_label__c != null 
               && system.today() > con.StartDate && system.today() < con.EndDate )
            {
                isTermandCondition=true;
                if(con.TermsCondition__c.contains(Label.http)) 
                {
                    con.TermsCondition__c = con.TermsCondition__c.substringAfter(Label.Colon_Slash);
                    con.TermsCondition__c = con.TermsCondition__c.trim();
                }               
                URLText= +URL.getSalesforceBaseUrl().getProtocol()+Label.Colon_Slash+con.TermsCondition__c;  
                labelText = con.TermsCondition_label__c;
            } 
            // Updating T & C, when Url is Specified 
            else if(con.AccountId != null  && con.TermsCondition__c != null && con.TermsCondition_label__c == null 
              && system.today() > con.StartDate && system.today() < con.EndDate )
            {
                isTermandCondition=true;
                if(con.TermsCondition__c.contains(Label.http)) 
                {
                    con.TermsCondition__c = con.TermsCondition__c.substringAfter(Label.Colon_Slash);
                    con.TermsCondition__c = con.TermsCondition__c.trim();
                }               
                URLText= +URL.getSalesforceBaseUrl().getProtocol()+Label.Colon_Slash+con.TermsCondition__c;  
                 
            } 
              // Updating T & C, when Label is Specified          
            else if(con.AccountId != null  && con.TermsCondition__c == null && con.TermsCondition_label__c != null
                && system.today() > con.StartDate && system.today() < con.EndDate )                
            {
                system.debug('--- isTandCURL is true---');
                isTandCURL=true;                        
                labelText = con.TermsCondition_label__c;
            }             
        } 
        defaultAddresses();
    }
    
    // These Method will be called in constructor for profile 'Order Customer Portal Users'
    // with order Id null and order Id not equals null
    
    //This method is used to set boolean variable on the basis of Terms and Conditions.
    public void contForPorUser(){
        
        // For customer portal page, contact Id will be present and checked the condition with contact Id.
            userId=UserInfo.GetUserId();
            if(userId != '')
            {
                usr=[select name,contactid from User where id = :userId];
                if (usr.contactid != null) 
                {
                    Contact con = new Contact();
                    con = [select Id, AccountId from Contact where Id =: usr.contactid];
                    list<contract> CPcontract= new list<contract>();
                      // case 316272
                    // get the shipping cost label, price lists... from the contract   
                    CPcontract=[select Payment_Terms__c, Delivery_Method__c, ContractNumber, EndDate, TermsCondition__c, TermsCondition_label__c, AccountId, StartDate, ShippingCostLabel__c, Spares_Price_List__c, Order_Price_List__c, Display_Requested_Delivery_Date__c from contract where AccountId =: con.AccountId and Business_Type__c='Tooway' limit 1];
                   
                    if(CPcontract.size() > 0)
                    {
                        for(Contract cont : CPcontract)
                        {
                            // case 316272
                            ShippingCostLabel=cont.ShippingCostLabel__c;
                            sparePriceListVisible=(cont.Spares_Price_List__c == null)?false:true;
                            terminalPriceListVisible=(cont.Order_Price_List__c == null)?false:true;
                            deliveryMethodRequired=(cont.Delivery_Method__c == 'Do Not Display')?false:true; 
                            requestedDeliveryDateRequired=cont.Display_Requested_Delivery_Date__c;  
                            if (!requestedDeliveryDateRequired) 
                                order.Requested_Delivery_Date__c=null;                          
                            order.Delivery_Method__c =(cont.Delivery_Method__c != 'Do Not Display')? cont.Delivery_Method__c:'';                           
                                                                                                            
                            order.Contract_Exp_Date__c=cont.EndDate;
                            order.Contract__c=cont.ContractNumber;
                            order.Payment_Terms__c=cont.Payment_Terms__c;
                                                      
                            if(cont.AccountId != null  && cont.TermsCondition__c != null && cont.TermsCondition_label__c != null 
                                && system.today() > cont.StartDate && system.today()< cont.EndDate)
                            {
                                isTermandCondition=true;
                                if(cont.TermsCondition__c.contains(Label.http)) 
                                {
                                    cont.TermsCondition__c = cont.TermsCondition__c.substringAfter(Label.Colon_Slash);
                                    cont.TermsCondition__c = cont.TermsCondition__c.trim();
                                }               
                                URLText= +URL.getSalesforceBaseUrl().getProtocol()+Label.Colon_Slash+cont.TermsCondition__c;  
                                labelText = cont.TermsCondition_label__c;
                           } 
                          // Updating T & C, when Url is Specified 
                           else if(cont.AccountId != null  && cont.TermsCondition__c != null && cont.TermsCondition_label__c == null 
                             && system.today() > cont.StartDate && system.today() < cont.EndDate )
                            {
                                isTermandCondition=true;
                                if(cont.TermsCondition__c.contains(Label.http)) 
                                {
                                    cont.TermsCondition__c = cont.TermsCondition__c.substringAfter(Label.Colon_Slash);
                                    cont.TermsCondition__c = cont.TermsCondition__c.trim();
                                }               
                                URLText= +URL.getSalesforceBaseUrl().getProtocol()+Label.Colon_Slash+cont.TermsCondition__c;  
                                  
                            } 
                        // Updating T & C, when Label is Specified 
                            else if(cont.AccountId != null  && cont.TermsCondition__c == null && cont.TermsCondition_label__c != null
                               && system.today() > cont.StartDate && system.today() < cont.EndDate )
                            {
                                system.debug('--- isTandCURL is true---');
                                isTandCURL=true;
                                labelText = cont.TermsCondition_label__c;  
                            }   
                        }
                    }
                }
           }  
    }
    
    // This Method will be called in constructor for 'Order Contract Administrator' profile.
    public void contForAdmin() 
    {
        userId=UserInfo.GetUserId();
    
        if(userId != '')
        {
        
            usr=[select name,contactid from User where id = :userId];
        
            // For Salesforce Instance page(i.e;) order object does not have contact Id, checked the condition with contact Id null.
            if(usr.contactid == null)
            {
                if(order.Account__c!=null)
                {
                    list<Contract> CPcontract= new list<Contract>();
                    
                    // case 316272
                    // get the shipping cost label, price lists... from the contract                    
                    CPcontract=[select Payment_Terms__c, Delivery_Method__c,ContractNumber, EndDate, TermsCondition__c, TermsCondition_label__c, AccountId, StartDate, ShippingCostLabel__c, Spares_Price_List__c, Order_Price_List__c, Display_Requested_Delivery_Date__c from contract where AccountId =: order.Account__c and Business_Type__c='Tooway' limit 1];
                    if(CPcontract.size() > 0)
                    {
                        for(Contract cont : CPcontract)
                        {  
                            // case 316272
                            ShippingCostLabel=cont.ShippingCostLabel__c;
                            sparePriceListVisible=(cont.Spares_Price_List__c == null)?false:true;
                            terminalPriceListVisible=(cont.Order_Price_List__c == null)?false:true;
                            deliveryMethodRequired=(cont.Delivery_Method__c == 'Do Not Display')?false:true; 
                            requestedDeliveryDateRequired=cont.Display_Requested_Delivery_Date__c;  
                            if (!requestedDeliveryDateRequired) 
                                order.Requested_Delivery_Date__c=null;  
                            order.Delivery_Method__c =(cont.Delivery_Method__c != 'Do Not Display')? cont.Delivery_Method__c:'';                        
                                                        
                             
                            order.Contract_Exp_Date__c=cont.EndDate;
                            order.Contract__c=cont.ContractNumber;
                            order.Payment_Terms__c=cont.Payment_Terms__c;
                                                  
                            
                            if(cont.AccountId != null && cont.TermsCondition__c != null  && cont.TermsCondition_label__c != null
                                &&  system.today() > cont.StartDate  && system.today()< cont.EndDate)
                            {
                                isTermandCondition=true;
                                if(cont.TermsCondition__c.contains(Label.http)) 
                                {
                                    cont.TermsCondition__c = cont.TermsCondition__c.substringAfter(Label.Colon_Slash);
                                    cont.TermsCondition__c = cont.TermsCondition__c.trim();
                                }               
                                URLText= +URL.getSalesforceBaseUrl().getProtocol()+Label.Colon_Slash+cont.TermsCondition__c;  
                                labelText = cont.TermsCondition_label__c;
                           }
                           
                            // Updating T & C, when Url is Specified 
                           else if(cont.AccountId != null  && cont.TermsCondition__c != null && cont.TermsCondition_label__c == null 
                            && system.today() > cont.StartDate && system.today() < cont.EndDate )
                            {
                                isTermandCondition=true;
                                if(cont.TermsCondition__c.contains(Label.http)) 
                                {
                                    cont.TermsCondition__c = cont.TermsCondition__c.substringAfter(Label.Colon_Slash);
                                    cont.TermsCondition__c = cont.TermsCondition__c.trim();
                                }               
                                URLText= +URL.getSalesforceBaseUrl().getProtocol()+Label.Colon_Slash+cont.TermsCondition__c;  
                                  
                            } 
                            
                           // Updating T & C, when Label is Specified 
                           else if(cont.AccountId != null  && cont.TermsCondition__c == null && cont.TermsCondition_label__c != null 
                              && system.today() > cont.StartDate && system.today() < cont.EndDate )
                           {
                                system.debug('--- isTandCURL is true---');
                                isTandCURL=true;                          
                                labelText = cont.TermsCondition_label__c; 
                           }
                                           
                         
                        }
                    }     
                }
            }
        }
    }
    
    public void defaultAddresses()
    {
        defaultAddressInfo(true);
    }
    
    private void defaultAddressInfo(boolean abIgnoreExistingAddress) 
    {      
        if(abIgnoreExistingAddress==true)
        {
            order.shiptoaddress__c = null;
            order.billtoaddress__c = null;
        }
        if(order.shiptoaddress__c == null) 
        {
            
            List<address__c> shiptoadd = [select id, End_Date__c, type__c,name from address__c where account__c=:accountId  and type__c = 'Ship To' and default__c = true and (End_Date__c >= today or End_Date__c = null) LIMIT 1];
            if(shiptoadd.size() > 0)
            {
                for(address__c ship : shiptoadd)
                {
                    order.shiptoaddress__c = ship.id;
                    addressid = ship.id;
                    order.account__c = accountId;
                }
            }
        }   

      //--- c. Default bill to address
        if (order.billtoaddress__c == null) 
        {
            List<address__c> billtoadd = [select id, name from address__c where account__c=:accountId  and type__c = 'Bill To' and default__c = true and (End_Date__c >= today or End_Date__c = null) LIMIT 1];
            if(billtoadd.size() > 0)
            {
                for(address__c bill : billtoadd)
                {
                    order.billtoaddress__c = bill.id;
                    order.account__c = accountId;
                } 
            }
        }
    }
        
    //*********************************************************************************************Constructor for class ****************************************************************// 
    public ToowayOrderAdminController(){}   
    public ToowayOrderAdminController(ApexPages.StandardController controller) 
    {        
        orderId = ApexPages.currentPage().getParameters().get('id');
        if(ApexPages.currentPage().getParameters().get('viewmode')!=null)
           viewmode=boolean.valueof(ApexPages.currentPage().getParameters().get('viewmode'));
           
        
        Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.Order__c;
        Map<String,Schema.RecordTypeInfo> ORDRectype = Orderobj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderRecByName = ORDRectype.get('Order');
        ID ORDRecTypeID= orderRecByName.getRecordTypeId();  
        
        addressLookupKeyPrefix = Contact.SObjectType.getDescribe().getKeyPrefix();
        addressLookupKeyPrefix2 = OrderPrice__c.SObjectType.getDescribe().getKeyPrefix();
        addressLookupKeyPrefix3 = Address__c.SObjectType.getDescribe().getKeyPrefix();

        order= new order__c();
        User user=new User();   
        String uid=UserInfo.getProfileId();

        TerminalSave = false;
        OtherStatus=False;
        profiledetail=True;
        Discount=true;
        SparesQtyCheck=false;
        TerminalsQtyCheck=false;
        CancelOrder=false;
        submitHelpTxt = false;
        Nospares = false;
        CAuser = false;
        isTermandCondition=false; 
        isTandCURL=false;  
        isPortalUser=false;   
        
        // case 316272
        sparePriceListVisible=false;
        terminalPriceListVisible=false;
        subtotalTerminals=0.0;
        deliveryMethodRequired=true;
        requestedDeliveryDateRequired=true;
        
        //--- To identify Portal/Internal User
        NBNCoKeyvalueStore__c KVS;
        if(!Test.isRunningTest()) {
            KVS = NBNCoKeyvalueStore__c.getValues('NBNOrderPortalProfileId');
            if(KVS.Value__c!=null && KVS.Value__c!='') {
                String kvsValue= KVS.Value__c;
                isPortalUser = kvsValue.contains(UserInfo.getProfileId().left(15));
                system.debug('---portal profiles kvsValue---> '+kvsValue + '---UserInfo.getProfileId()---> '+UserInfo.getProfileId());
                system.debug('---isPortalUser ---> '+isPortalUser);
            }
        }
                         
        Profile prof=[SELECT Name FROM Profile where id =: uid];
        if(orderId != null && orderId != '')
        {
            order = [select ID, Name, Ship_Date__c,Ship_to_Address_formula__c,Bill_to_Address_formula__c,Status__c, Contract_Exp_Date__c,Delivery_Method__c,Account__c, AccountName__c,Discount__c,Discount_Description__c, CustomerPO__c, Requestor__c, VAT_Number__c,VAT__c,Payment_Terms__c,Requested_Delivery_Date__c,Requestor_Name__c,
            ShipToAddress__c, BillToAddress__c,Forecast_Delivery_Date__c, AgreetoTermsConditions__c, NotesComments__c,Contract__c,Task__c,Project__c ,Total_Cost__c,Terminals_Total_Line_Price__c, Spares_Total_Line_Price__c,Shipping_Cost__c, ProcessingFees__c,Unit_Price__c from Order__c where id =: orderId ];
            
            // case 316272
            // get the shipping cost label, price lists, delivery method from the contract           
            if (order.Contract__c != null)
            {
                contract tempcontract = [select id,ShippingCostLabel__c, Spares_Price_List__c, Order_Price_List__c, Delivery_Method__c, Display_Requested_Delivery_Date__c from contract where ContractNumber=:order.Contract__c limit 1];
                            
                ShippingCostLabel=tempcontract.ShippingCostLabel__c;
                sparePriceListVisible=(tempcontract.Spares_Price_List__c == null)?false:true;
                terminalPriceListVisible=(tempcontract.Order_Price_List__c == null)?false:true;
                deliveryMethodRequired=(tempcontract.Delivery_Method__c == 'Do Not Display')?false:true;
                requestedDeliveryDateRequired=tempcontract.Display_Requested_Delivery_Date__c;                              
            }
             
            if(order.Status__c!='Cancelled')
                CancelOrder=true;
            else
                CancelOrder=false;
            
           /* Modified for MR1- 43
            if(order.Delivery_Method__c=='ViaSat direct ship (cost + 15%)')                
                shippingsection=true;                
            else
                shippingsection=false;*/
            
            if(order.Discount__c!=0.00 && order.Discount__c!=null)                
                DiscountSection=true;                
            else
                DiscountSection=false;
               
            //if(prof.name == 'Order Customer Portal Users')
            if(UserInfo.getUserType() != 'Standard')
            {
                contForPorUser();
                Discount=false;
                CAuser = false;
                if(order.Status__c == 'Submitted')
                { 
                    profiledetail=false;
                    OrderStatus=false;
                    OtherStatus=false;
                    CancelOrder=false;
                }
                else if(order.Status__c == 'Pending Submission')
                {  
                    profiledetail=true;
                    OrderStatus=true;
                    OtherStatus=false;
                    submitHelpTxt = true;
                    CancelOrder=true;                                        
                }
                else if(order.Status__c == 'Cancelled')
                {  
                    profiledetail=false;
                    OrderStatus=false;
                    OtherStatus=false;
                    CancelOrder=false;                                                            
                }
                else if(order.Status__c != 'Pending Submission' && order.Status__c != 'Submitted' && order.Status__c != 'Cancelled' && order.Status__c!='')
                {
                    profiledetail=false;
                    OrderStatus=false;
                    Otherstatus=false;
                    CancelOrder=false;
                } 
            }
            else if(prof.name=='Order Contract Administrator')
            {
                contForAdmin();
                CAuser = true;
                Discount=true;
                if(order.Status__c == 'Submitted')
                {
                    profiledetail=true;
                    OrderStatus=false;
                    OtherStatus=false;
                    CancelOrder=false; 
                }
                else if(order.Status__c == 'Pending Submission')
                {
                    profiledetail=true;
                    OrderStatus=true;
                    OtherStatus=false;
                    submitHelpTxt = true;
                    CancelOrder=true;
                }
                else if(order.Status__c == 'Cancelled')
                {  
                    profiledetail=true;
                    OrderStatus=false;
                    OtherStatus=false;
                    CancelOrder=false;                                                            
                }
                else if(order.Status__c != 'Pending Submission' && order.Status__c != 'Submitted' && order.Status__c != 'Cancelled' && order.Status__c!='')
                {
                    profiledetail=true;
                    OrderStatus=false;
                    Otherstatus=false;
                    CancelOrder=false;
                } 
                        
            }
            else
            {
                profiledetail=true;
                OtherStatus=false;
                CAuser = true;
                if(order.Status__c == 'Pending Submission')
                {
                    submitHelpTxt = true;
                    OrderStatus=true;
                }
            }
                         
        }
        if(orderId == null || orderId == '')
        {
            //if(prof.name=='Order Customer Portal Users')    
            if(UserInfo.getUserType() != 'Standard')
            {    
                contForPorUser();  
                Discount=false;
                CAuser = false;
            }    
            else
            {
                Discount=true;
                CAuser = true;
             }   
            
            userId=UserInfo.GetUserId();
            if(userId != '')
            {
                usr=[select name,contactid from User where id = :userId];
                
                if (usr.contactid != null) 
                {
                    order.requestor__c = usr.contactid ;
                    Contact con = new Contact();
                    con = [select Id, AccountId from Contact where Id =: usr.contactid];
                    order.Account__c= con.AccountId;
                    Account acc = new Account();
                
                    List<Address__c> addrList= new List<Address__c>();
                    addrList = [Select Id, Name, VAT__c,Type__c from Address__c where Default__c = true and Account__c =: con.AccountId and (End_Date__c >= today or End_Date__c = null)];
                   
                    if (addrList.size() > 0) 
                    {
                        for (Address__c ad : addrList)
                        {
                            if(ad.Type__c=='Bill To')
                                order.BillToAddress__c=ad.Id;
                            else if(ad.type__c=='Ship To')
                                order.ShipToAddress__c=ad.Id;
                        }
                        if(con != null && con.AccountId != null)
                            order.Account__c= con.AccountId;
                        Totalcost = order.Total_Cost__c;
                    }
                   
                                    
                    if(con.AccountId!=null)
                        AccountId=con.AccountId;
                }
            }
        }
        //--- Default addresses
        defaultAddressInfo(false);
    }
 


    public list<antennarela> antenna{get;set;}
    public list<antennarela> gettotalantenna()
    {
        Map<Decimal,list<string>> namemap =new map<Decimal,list<string>>();
        map<Decimal,orderline__c> singlerecordmap = new map<Decimal,orderline__c>();
        map<Decimal,decimal> pricemap=new map<Decimal,decimal>();
        map<Decimal,map<string,decimal>>unitpricemap=new map<Decimal,map<string,decimal>>();
        map<Decimal,map<string,decimal>>linepricemap=new map<Decimal,map<string,decimal>>();
        
        if(antenna==null)
        {
            antenna= new list<antennarela>();
            decimal totalprice=0;
            for(orderline__c ol: [select id,Name, LinePrice__c, Random_Number__c,Is_Spares__c, PartNumber__c, Part_Number_2__c,Quantity__c, Order_Price__c,Order_Price__r.Price__c,order__c,ShipToAddress__c,
                                    Unit_Price__c,Spares_formula__c,Order_Price__r.Product__r.Product_Category__c,Order_Price__r.ProductDescription__c,ShipToAddressDetails__c,Related_Antenna__c,Spares__c, 
                                    status__c,Spares__r.ProductDescription__c,Order_Price__r.Product_Category__c,Order_Price__r.SparesBlockSize__c,Order_Price__r.product__r.ProductExpirationDate__c, 
                                    Order_Price__r.product__r.name from orderline__c where order__c=:orderId and Is_Spares__c=false ORDER BY Product_Category__c]) 
            {

                // Random_Number__c is the unique identifier of a terminal.  For each terminal there will be multiple order lines with the same Random_Number__c, representing each part of the terminal
                // pricemap is a map of the total cost of each terminal in the order, added up as we work our way through the order lines, keyed by Random_Number_c
                if(pricemap.containskey(ol.Random_Number__c))
                    totalprice=pricemap.get(ol.Random_Number__c);
                else
                    totalprice=0;
                
                if(ol.Quantity__c!=null && ol.Unit_Price__c!=null)
                    totalprice=(ol.Unit_Price__c*ol.Quantity__c)+totalprice;

                pricemap.put(ol.Random_Number__c,totalprice);
                
                
                list<orderline__c>templist= new list<orderline__c>();
                list<string>tempname=new list<string>();
                map<string,decimal>tempmap=new map<string,decimal>();
                map<string,decimal>tempmap2=new map<string,decimal>();

                if(ol.Order_Price__r.Product__r.Product_Category__c=='Antenna' && ol.Is_Spares__c == false)
                    singlerecordmap.put(ol.Random_Number__c,ol);
                if(unitpricemap.containskey(ol.Random_Number__c))
                    tempmap=unitpricemap.get(ol.Random_Number__c);
                if(linepricemap.containskey(ol.Random_Number__c))
                    tempmap2=linepricemap.get(ol.Random_Number__c);    
                
                if(ol.Unit_Price__c==null)
                    ol.Unit_Price__c=0.00;
                
                    
                tempmap.put(ol.Order_Price__r.ProductDescription__c,ol.Unit_Price__c);
                tempmap2.put(ol.Order_Price__r.ProductDescription__c, ol.LinePrice__c);
                
                unitpricemap.put(ol.Random_Number__c,tempmap);
                linepricemap.put(ol.Random_Number__c,tempmap2);

                if(ol.Order_Price__r.Product__r.Product_Category__c!='Warranty')
                {
                    if(namemap.containskey(ol.Random_Number__c))
                        tempname=namemap.get(ol.Random_Number__c);
                    tempname.add(ol.Order_Price__r.ProductDescription__c);
                    namemap.put(ol.Random_Number__c,tempname);
                }       
            }
            for(orderline__c ol: [select id,Name, LinePrice__c, Random_Number__c,Is_Spares__c, PartNumber__c, Part_Number_2__c,Quantity__c, Order_Price__c,Order_Price__r.Price__c,order__c,ShipToAddress__c,Order_Price__r.product__r.ProductExpirationDate__c, Order_Price__r.product__r.name,
                                Unit_Price__c,status__c,Spares_formula__c,Order_Price__r.Product__r.Product_Category__c,Order_Price__r.ProductDescription__c,ShipToAddressDetails__c,Related_Antenna__c, Spares__c,Spares__r.ProductDescription__c from orderline__c where order__c=:orderId]) 
            {
                if(ol.Order_Price__r.Product__r.Product_Category__c=='Antenna' && ol.Is_Spares__c == false)
                    antenna.add(new antennarela(singlerecordmap.get(ol.Random_Number__c), String.valueof('TERM'+ol.Random_Number__c),namemap.get(ol.Random_Number__c),pricemap.get(ol.Random_Number__c), unitpricemap.get(ol.Random_Number__c), linepricemap.get(ol.Random_Number__c))); 
            } 

        //Start of Terminals Subtotal
            Decimal temp2=0.0;
            subtotalTerminals=0.0;
            for(antennarela ant : antenna)
                temp2 = temp2 + ant.pricesum;

            subtotalTerminals=temp2;
        //End of Terminals Subtotal    
        }
        return antenna;
    }

    /*antennarela for Removed Extended Warranty*/
    public class antennarela 
    {
        public Boolean selected {get; set;}
        public String Terminalname {get; set;}
        public list<string>concardname{get;set;}
        public decimal pricesum{get;set;}
        public orderline__c orderobj{get;set;}        
        public map <string,decimal>priceunitmap{get;set;} 
        public map <string,decimal>linepricemap{get;set;}      
         
        public antennarela(orderline__c o,String termname, list<string> name,decimal price,map<string,decimal> unitmap, map<string,decimal> pricemap)
        {
            orderobj = o;
            Terminalname = termname;
            pricesum=price;
            selected = false;
            concardname=name;
            priceunitmap=unitmap;
            linepricemap=pricemap;
        }
    }
    
    public list<String> gettemp()//this is no longer used functionality wise but it should be here for shipping cost showing up in vf page.
    {
        list<String> templist = new list<String>();
        templist.add('temp');
        return templist;
    }

    public List<neworderlist> gettotaloderlist() 
    {
        if(oderlinelist == null) 
        {
            //transient list<neworderlist> oderlinelist;
            oderlinelist = new list<neworderlist>();
            
            for(orderline__c  o: [select id,Name,Is_Spares__c,Unit_Price__c,Order__c,Product_Description__c,
                                 Order_Price__r.ProductDescription__c,Order_Price__r.SparesBlockSize__c,Spares_formula__c, Part_Description__c,order__r.Discount__c,
                                 Order_Price__r.product__r.ProductExpirationDate__c,Order_Price__r.product__r.name,order_price__r.name ,
                                 Part_Number_2__c, Quantity__c,Related_Antenna__c , Order_Price__r.Price__c, ShipToAddressDetails__c, 
                                 ShipToAddress__c,Spares__r.SparesBlockSize__c,Spares__c,Spares__r.ProductDescription__c, status__c from orderline__c where order__c=:orderId and Is_spares__c = true])
            {
                if(o.Quantity__c!=null && o.Unit_Price__c!=null) 
                {
                    decimal SparesUnitPrice=o.Unit_Price__c;
                    decimal price =o.Unit_Price__c*o.Quantity__c;
                    oderlinelist.add(new neworderlist(o,o.Order_Price__r.product__r.name,price,SparesUnitPrice));
                }
            }
            if(orderId != '' && orderId != null)
            {
                if(apexpages.currentpage().getparameters().get('createnewline')!=null && apexpages.currentpage().getparameters().get('createnewline')=='true')
                {
                    orderline__c ol =new orderline__c(); 
                    if(ol.Order_Price__r.product__r.name!=null)
                    {
                        oderlinelist.add(new neworderlist(ol,ol.Order_Price__r.product__r.name,0.0,0.0));                        
                    }
                    else 
                    {
                        string tempvar='';
                        ol.Quantity__c = 0;
                        oderlinelist.add(new neworderlist(ol,tempvar,0.0,0.0));
                    }
                   
                }
            //Start of Spares Subtotal 
                Decimal temp = 0.0;
                ShippingCost = 0.0;
                ProcessFeeTotal = 0.0;
                Totalcost = 0.0;

                for(neworderlist obj : oderlinelist)
                    temp = temp + obj.linespareprice;
                
                subtotal = temp;
                listDesctest1='Processing Fees';
                listDesctest2='Shipping Cost';
                ProcessFeePrice = order.Unit_Price__c;
                ProcessFeeLinePrice = order.ProcessingFees__c;
            //End of Spares Subtotal
      
            //Start of shipping Cost - This section hidden for MR1-43
                /*Order__c shipmtd = new Order__c();          
                listdesctest2='Shipping Cost';
                shipmtd=[select Delivery_Method__c,Discount__c from Order__c where id =: orderId];
                          
                if(shipmtd.Delivery_Method__c == 'ViaSat direct ship (cost + 15%)')
                    ShippingCost=(((subtotal+subtotalTerminals)*15)/100).setScale(2);                    
                else
                    ShippingCost=0.00;*/
            //End of shipping Cost

            //Start of Processing Fees Subtotal
                ProcessFeeTotal=ShippingCost;
            //End of Processing Fees Subtotal

            //Start of Total Cost
                if(order.Discount__c !=null)
                    Totalcost=((ProcessFeeTotal+subtotal+subtotalTerminals)-(order.Discount__c));
                else
                    Totalcost=ProcessFeeTotal+subtotal+subtotalTerminals;
            //End of Total Cost
            }
        }
        return oderlinelist;
    }

    public class neworderlist
    {
        public orderline__c ol{get; set;}
        public Boolean selected {get; set;}
        public string Spares{get;set;}
        public decimal linespareprice{get;set;}
        public decimal SUP{get;set;}
       
        public neworderlist(orderline__c  o, string pricename, decimal totalspareprice,decimal SparesUnitPrice) 
        {
            ol= o;
            linespareprice=totalspareprice;
            spares=pricename;
            SUP=SparesUnitPrice;
            selected = false;
        }
    }
    
    public List<neworderlist> getTerminals()
    {
        if(orderTerminal== null) 
        {
            terminalmap=new map<Decimal,list<string>>();
            orderTerminal= new list<neworderlist>();
            for(orderline__c  o: [select id,Name,Random_Number__c,Is_spares__c, PartNumber__c,Order__c, Part_Number_2__c,Quantity__c, Order_Price__c,Order_Price__r.Price__c,Order_Price__r.name,
                                Spares_formula__c,Order_Price__r.product__r.name,Order_Price__r.ProductDescription__c,ShipToAddressDetails__c,Related_Antenna__c,Spares__c, status__c,Spares__r.ProductDescription__c, 
                                Order_Price__r.product__r.ProductExpirationDate__c from orderline__c where order__c=:orderId and Is_spares__c=false])
            {
                decimal price =o.Order_Price__r.Price__c*o.Quantity__c;
                decimal SparesUnitPrice=o.Order_Price__r.Price__c;
                orderTerminal.add(new neworderlist(o,o.Order_Price__r.product__r.name,price,SparesUnitPrice));
                list<string>templist= new list<string>();
                
                if(terminalmap.containsKey(o.Random_Number__c))
                    templist=terminalmap.get(o.Random_Number__c);
                templist.add(o.Order_Price__r.ProductDescription__c);
                terminalmap.put(o.Random_Number__c,templist);
                objectMap = new  Map<String, Map<Decimal, list<string>>>();
                objectMap.put(o.id,terminalmap);
            }
        }
        return orderTerminal;
    }

    public PageReference createnew() 
    {
        pagereference pag= new pagereference('/apex/ToowayOrderAdmin');
        pag.setredirect(true);
        return pag;
    }
     
        // Edit order
    public PageReference edit()
    {
        if (orderId != null && orderId != '')
        {
            pagereference pag = new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&viewmode=false');
            pag.setredirect(true);
            return pag;
        }
        else
            return null;
    }    
    
    public PageReference AddTerminal()
    {
        Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.Order__c;
        Map<String,Schema.RecordTypeInfo> ORDRectype = Orderobj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderRecByName = ORDRectype.get('Order');
        ID ORDRecTypeID= orderRecByName.getRecordTypeId();
        try  
        {
            checkCustomerPO(order.Account__c,order.CustomerPO__c);
            if(chkCustomerPO == true)
                return null;
            checkcontract();
            if(checkcontract==true)
                return null;

            if(orderid == '' || orderid == null ) 
            {
                if (order.AgreetoTermsConditions__c!=true) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the terms and conditions'));
                    return null; 
                }
                
               /* 12/5/2014 - RichW:  The Requested_Delivery_Datepl field has been removed from the entry form, so now the user just needs
                to select a Requested_Delivery_Date.  Removing this functionality and just making Requested_Delivery_Date__c a required field.
                if (order.Requested_Delivery_Datepl__c=='Delivered By' && order.Requested_Delivery_Date__c==null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Requested Delivery Date'));
                    return null;      
                }
                else
                { */
                    order.RecordTypeId=ORDRecTypeID;
                    insert order;
                    
                    SaveTerminal();
                    PageReference pageRef = new PageReference('/apex/ToowayAddTerminal?id='+order.id);
                    pageRef.setredirect(true);
                    return pageRef;
               // }
            }
            else
            {
                update order;
                
                selectedsave();
                if(SparesQtyCheck==true || Nospares == true)
                    return null;
                else
                {
                    SaveTerminal();
                    if(TerminalsQtyCheck==true)
                        return null;

                    PageReference pageRef = new PageReference('/apex/ToowayAddTerminal?id='+orderid);
                    pageRef.setredirect(true);
                    return pageRef; 
                }
            }
        }catch(dmlexception e){                
            for (Integer i = 0; i < e.getNumDml(); i++) 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! ' + e.getDMLMessage(i)));
            return null; 
        }
    }
    
        // Edit Selected Terminal
    public PageReference EditTerminal()
    {
        checkcontract();
        if(checkcontract==true)
            return null;
                
        List<orderline__c> selectedol = new List<orderline__c>();
        for(antennarela selectedantenna: gettotalantenna())
        {
            if(selectedantenna.selected == true) 
                selectedol .add(selectedantenna.orderobj);
        }
        if(selectedol.size()>1)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a single terminal for editing.'));
            return null;
        }
        else if(selectedol.size()<=0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a single terminal for editing'));
            return null;
        }
        else
        {
            selectedsave();
            if(SparesQtyCheck==true || Nospares == true || TerminalsQtyCheck==true)
            return null;
            
            PageReference pageRef = new PageReference('/apex/ToowayAddTerminal?id='+selectedol[0].order__c+'&productid='+selectedol[0].Random_Number__c);
            pageRef.setredirect(true);
            return pageRef;
        }
    }
 
        //Delete Selected Terminal 
    public PageReference DeleteTerminal()
    {       
       
        checkcontract();
        if(checkcontract==true)
            return null;
        List<orderline__c> selectedol = new List<orderline__c>();
        set<Decimal> relatedantennaid =new set<Decimal>();
        
        for(antennarela selectedantenna: gettotalantenna())
        {
            if(selectedantenna.selected ) 
            {
                selectedol .add(selectedantenna.orderobj);
                relatedantennaid.add(selectedantenna.orderobj.Random_Number__c);
            }
        }
        if(selectedol.size()<=0) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one terminal to delete.'));
            return null;
        }
        else
        {
            list<orderline__c> allselected= new list<orderline__c>();
            allselected=[select id from orderline__c where Random_Number__c in :relatedantennaid and order__c=:orderId];

            delete allselected;            
            restrictSelectedSave = false;    // This restricts Selectedsave() without executing on click of order Save() THis should be declared before calling SaveTerminal()               
            saveTerminal(); // Newly added for Maintanence Release:224 
            antenna=null;
        }         
        return null;
    }
        // Order save method
    public PageReference save()
    {
        Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.Order__c;
        Map<String,Schema.RecordTypeInfo> ORDRectype = Orderobj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderRecByName = ORDRectype.get('Order');
        ID ORDRecTypeID= orderRecByName.getRecordTypeId();
        try
        {
            checkCustomerPO(order.Account__c,order.CustomerPO__c);
            if(chkCustomerPO == true)
                return null;
            
            checkcontract();
            if(checkcontract==true)
                return null;

            if (orderId != null && orderId != '')
            {
                if (order.AgreetoTermsConditions__c!=true) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the terms and conditions'));
                    return null;      
                }
                /*else if (order.Requested_Delivery_Datepl__c=='Delivered By' && order.Requested_Delivery_Date__c==null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Requested Delivery Date'));
                    return null;      
                }*/
                else if(order.Contract__c == '' || order.Contract__c == null) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Contract associated with the Account/Order, Contact ViaSat for more information'));   
                    return null;
                }

                update order;
                
                restrictSelectedSave = false; // This restricts Selectedsave() without executing on click of order Save() THis should be declared before calling SaveTerminal()              
                
                SaveTerminal();
                if(TerminalsQtyCheck==true)
                    return null;
                    
                restrictSelectedSave = true;
                
                selectedsave();
                if(SparesQtyCheck==true || Nospares == true)
                    return null;
                  
                if (order.status__c == 'Pending Submission' || order.status__c == 'Submitted')
                {     
                    pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&viewmode=false');
                    pag.setredirect(true);
                    return pag;
                }
                else
                {
                    pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&viewmode=true');
                    pag.setredirect(true);
                    return pag;
                }
            }
            else if (orderId == null || orderId == '')
            {
                if (order.AgreetoTermsConditions__c != true) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the terms and conditions'));
                    return null;
                }
               /* else if(order.Requested_Delivery_Datepl__c=='Delivered By' && order.Requested_Delivery_Date__c==null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Requested Delivery Date'));
                    return null;      
                } */
                else if(order.Contract__c == '' || order.Contract__c == null) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Contract associated with the Account/Order, Contact ViaSat for more information'));   
                    return null;
                }
                else
                {
                    order.RecordTypeId=ORDRecTypeID;     
                    insert order;             
                }      
                pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&viewmode=false');
                pag.setredirect(true);
                return pag;
            }
        }catch(exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! ' + e.getDmlMessage(0)));return null;
        }
        return null;   
    }   
        // Terminal section Save
    public PageReference SaveTerminal()
    {
        try
        {
            Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.Order__c;
            Map<String,Schema.RecordTypeInfo> ORDRectype = Orderobj.getRecordTypeInfosByName();
            Schema.RecordTypeInfo orderRecByName = ORDRectype.get('Order');
            ID ORDRecTypeID= orderRecByName.getRecordTypeId();
            
            checkCustomerPO(order.Account__c,order.CustomerPO__c);
            if(chkCustomerPO == true)
                return null;
            
            checkcontract();
            if(checkcontract==true)
                return null;
                
            List<orderline__c> selectedol = new List<orderline__c>();
            list<orderline__c>ol=new list<orderline__c>();
            set<id>selctolid= new set<id>();
            set<id>ordersetid=new set<id>();
            map<id,id> shipmap=new map<id,id>();
            map<decimal,decimal>qtymap=new map<decimal,decimal>();   
            map<decimal,decimal> Terminalblocksiz = new map<decimal,decimal>(); 
            set<id>relatedantennaid=new set<id>();
            set<decimal>randomnumberset=new set<decimal>();
            OrderLine__c insWarrInfo = new OrderLine__c();
            TerminalsQtyCheck=false;
        
            for(antennarela selectedantenna: gettotalantenna())
            {
                selectedol.add(selectedantenna.orderobj);
                shipmap.put(selectedantenna.orderobj.id,selectedantenna.orderobj.ShipToAddress__c);
                qtymap.put(selectedantenna.orderobj.Random_Number__c,selectedantenna.orderobj.Quantity__c);
            }

            list<orderline__c> orderline=new list<orderline__c>();
            if (orderId == null || orderId == '')
            {
                order.RecordTypeId=ORDRecTypeID;
                insert order;
                orderId = order.id;
            }
            else
            {
                for(orderline__c ool:selectedol)
                {
                    randomnumberset.add(ool.Random_Number__c);
                    ordersetid.add(ool.order__c);
                }
                Contract c;
                if(order.Contract__c == '' || order.Contract__c == null) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Contract associated with the Account/Order, Contact ViaSat for more information'));   
                    return null;
                }
                else
                    c=[select Terminals_Quantity__c from Contract where ContractNumber=:order.Contract__c];

                orderline=[select id,Random_Number__c,name,order__c,Order_Price__r.Product_Category__c, Quantity__c,Order_Price__c,Order_Price__r.Price__c,Order_Price__r.ProductDescription__c,Related_Antenna__c,Order_Price__r.product__r.ProductExpirationDate__c, Order_Price__r.product__r.name from orderline__c where random_number__c in: randomnumberset and order__c in:ordersetid];
                Double quantityFromantenna =0;

                for(orderline__c o:orderline)
                {
                    if (qtymap.get(o.Random_Number__c) != null)
                    {
                        quantityFromantenna=qtymap.get(o.Random_Number__c);
                        break;
                    }  
                }
                
        //#####################dded for MR1-246 : Block size implementation####################
                List<OrderTerminalBlockConfiguration__c> listTerminalBlockConfig = [Select Antenna__c, Modem__c, TRIA__c, Blocksize__c from OrderTerminalBlockConfiguration__c];
                map<Decimal, list<orderline__c>> mapRandomNumbers = new map<Decimal, list<orderline__c>>();
                
                for(orderline__c ol1:orderline)
                {
                 if(ol1.Random_Number__c <> null)
                 {
                     list<orderline__c> templist= new list<orderline__c>();
                     if(mapRandomNumbers.containskey(ol1.Random_Number__c))
                     {
                       Templist= mapRandomNumbers.get(ol1.Random_Number__c);
                       Templist.add(ol1);
                       mapRandomNumbers.put(ol1.Random_Number__c,templist);
                     }  
                     else
                     {
                       templist.add(ol1);
                       mapRandomNumbers.put(ol1.Random_Number__c,templist); 
                     }  
                  }  
                }
                
                Map<decimal,decimal> randomNumberQuantity = new map<decimal,decimal>();
                Map<decimal,Boolean> randomNumberCheck = new map<decimal,Boolean>();
                Boolean terminalcheck = false;
                Boolean modemcheck = false;
                Boolean triacheck = false;
                Boolean check = false;
                
                for(Decimal rand: mapRandomNumbers.keyset())
                {
                  List<Orderline__c> templstOrderline = mapRandomNumbers.get(rand);               
                  Map<decimal,Boolean> AntennaChecking = new map<decimal,Boolean>();
                  Map<decimal,Boolean> ModemChecking = new map<decimal,Boolean>();
                  Map<decimal,Boolean> TriaChecking = new map<decimal,Boolean>();
                  for(OrderTerminalBlockConfiguration__c otb : listTerminalBlockConfig)
                  {
                       terminalcheck = false;
                       modemcheck = false;
                       triacheck = false;                      
                    for(Orderline__c ol2: templstOrderline)
                    {                     
                      if(otb.Antenna__c == ol2.Order_Price__c)
                        terminalcheck = true;                       
                      if(otb.Modem__c == ol2.Order_Price__c)
                        modemcheck = true;                      
                      if(otb.TRIA__c == ol2.Order_Price__c)     
                        triacheck = true;                       
                    }                   
                    if(terminalcheck == true && modemcheck == true && triacheck == true)
                    {                          
                       randomNumberQuantity.put(rand,otb.Blocksize__c);                   
                       randomNumberCheck.put(rand,true);
                    }   
                  }               
                }   
                
                for(orderline__c o:orderline)
                {
                  if(randomNumberCheck.get(o.Random_Number__c) ==  true)
                  {                       
                      o.Quantity__c = qtymap.get(o.Random_Number__c);
                      if(math.mod(Integer.Valueof(o.Quantity__c),Integer.Valueof(randomNumberQuantity.get(o.Random_Number__c))) <> 0 || o.Quantity__c == 0)
                      {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' Terminals TERM'+ o.Random_Number__c +' Quantity should be multiples of '+ randomNumberQuantity.get(o.Random_Number__c)));
                            TerminalsQtyCheck=true;
                            return null;
                      } 
                  } 
                  else
                  {
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please contact viasat team for Terminal Configuration.'));
                      return null;
                  }
                }
                //###########################################                
                
                //Added for MR1-246 : Block size implementation
               /* for(orderline__c o:orderline)
                {
                    o.Quantity__c = qtymap.get(o.Random_Number__c);
                    if(o.Order_Price__r.Product_Category__c == 'Antenna')
                    {                       
                        if(math.mod(Integer.Valueof(o.Quantity__c),Integer.Valueof(Terminalblocksiz.get(o.Random_Number__c))) <> 0 || o.Quantity__c == 0)
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' Terminals '+ o.Order_Price__r.ProductDescription__c +' Quantity should be multiples of '+ Terminalblocksiz.get(o.Random_Number__c)));
                            TerminalsQtyCheck=true;
                            return null;
                        }
                    }   
                }*/
                //End---- for MR1-246 : Block size implementation       
                
                //Commented below lines for MR1 - 246       
                for(orderline__c o:orderline)
                {
                    o.Quantity__c = qtymap.get(o.Random_Number__c);
                   /* if(math.mod(Integer.Valueof(o.Quantity__c),Integer.Valueof(c.Terminals_Quantity__c)) <> 0 || o.Quantity__c == 0)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Terminals Quantity should be multiples of '+c.Terminals_Quantity__c));
                        TerminalsQtyCheck=true;
                        return null;
                    }
                    else*/
                        ol.add(o); 
                }
               
                update order;
            }   
            if(ol.size() > 0)                   
                update ol;
            
            antenna=null;

            if(restrictSelectedSave == true )
                selectedsave();
            if(SparesQtyCheck==true || Nospares == true)
                return null;
            else
            {
                TerminalSave = true;
                pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&viewmode=false');
                pag.setredirect(true);
                return pag;
            }
        }catch(exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! ' + e.getDmlMessage(0)));return null;}   
    }
  
        // Submit order
    public PageReference submit()
    {
        checkCustomerPO(order.Account__c,order.CustomerPO__c);
        if(chkCustomerPO == true)
            return null;
        checkcontract();
        if(checkcontract==true)
            return null;
        if(orderId != null && orderId != '')
        {
            list<orderline__c> oll= [select id,Order_Price__r.product__r.name,Order_Price__r.product__r.ProductExpirationDate__c from orderline__c where order__c=:orderId];

            if(oll.size()==0) 
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Order can not be submitted without Terminal or Spares information'));
                return null;
            }
            list<string> expProduct= new list<string>();
            for(orderline__c  ol : oll)
            {
                if(ol.Order_Price__r.product__r.ProductExpirationDate__c < system.today())
                    expProduct.add(ol.Order_Price__r.product__r.name);
            }
            if(expProduct.size() > 0) 
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Selected Product(s) '+expProduct+' has expired, Please contact ViaSat'));            
                return null;
            }
            update oll; 
        }
        order.Status__c = 'Submitted';
        order.orderdate__c = system.today();
        update order;

        pagereference pag= new pagereference('/apex/Tooway_Thankyou?id='+order.id+'&viewmode=true');
        pag.setredirect(true);
        return pag;
    }   
    
        // review order - Saves is also invoked
    public PageReference reviewnsubmit()
    {
        Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.Order__c;
        Map<String,Schema.RecordTypeInfo> ORDRectype = Orderobj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderRecByName = ORDRectype.get('Order');
        ID ORDRecTypeID= orderRecByName.getRecordTypeId();
        try
        {
            checkCustomerPO(order.Account__c,order.CustomerPO__c);
            if(chkCustomerPO == true)
                return null;
            checkcontract();
            if(checkcontract==true)
                return null;
            else if(orderId != null && orderId != '')
            {
                if (order.AgreetoTermsConditions__c!=true)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the terms and conditions'));
                    return null;
                }
                /*else if (order.Requested_Delivery_Datepl__c=='Delivered By' && order.Requested_Delivery_Date__c==null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Requested Delivery Date'));
                    return null;      
                } */
                
                update order;
                
                SaveTerminal();
                if(TerminalsQtyCheck==true)
                    return null;
                
                selectedsave();
                if(SparesQtyCheck==true || Nospares == true || TerminalsQtyCheck==true)
                    return null;
                
                list<orderline__c> oll= [select id,Order_Price__r.product__r.name,Order_Price__r.product__r.ProductExpirationDate__c from orderline__c where order__c=:orderId];
                list<string> expProduct= new list<string>();    
                for(orderline__c  ol : oll) 
                {
                    if(ol.Order_Price__r.product__r.ProductExpirationDate__c < system.today())
                        expProduct.add(ol.Order_Price__r.product__r.name);
                }
                if (oll.size()==0) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add Terminals and / or Spares to proceed..'));
                    return null;
                }
                else if(expProduct.size() > 0) 
                {               
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Selected Product(s) '+expProduct+' has expired, Please contact ViaSat'));                
                    return null;
                }
                else
                {
                    pagereference pag= new pagereference('/apex/TooWayOrderReview?id='+order.id+'&viewmode=true');
                    pag.setredirect(true);
                    return pag;
                }          
            }
            else
                return null;
        }catch(exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! ' + e.getDmlMessage(0)));return null;} 
    }
    
        // Create orderline for Spares section
    public pagereference createorderline()
    {
        Schema.DescribeSObjectResult orderline = Schema.SObjectType.OrderLine__c;
        Map<String,Schema.RecordTypeInfo> olRectype = orderline.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderlineRecByName = olRectype.get('Order');
        ID olRecTypeID= orderlineRecByName.getRecordTypeId();
        
        Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.Order__c;
        Map<String,Schema.RecordTypeInfo> ORDRectype = Orderobj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderRecByName = ORDRectype.get('Order');
        ID ORDRecTypeID= orderRecByName.getRecordTypeId();
        
        try
        {
            checkCustomerPO(order.Account__c,order.CustomerPO__c);
            if(chkCustomerPO == true)
                return null;
            checkcontract();
            if(checkcontract==true)
                return null;
            if(orderid == '' || orderid == null)   
            {     
                if (order.AgreetoTermsConditions__c!=true) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the terms and conditions'));
                    return null; 
                }
                /* else if (order.Requested_Delivery_Datepl__c=='Delivered By' && order.Requested_Delivery_Date__c==null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Requested Delivery Date'));
                    return null;      
                } */
                else 
                {
                    order.RecordTypeId=ORDRecTypeID;
                    insert order;
                    orderid = order.id;
                }
            }
            if(orderid != '' && orderid != null)
            {
                if(order.Contract__c == '' || order.Contract__c == null) 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Contract associated with the Account/Order, Contact ViaSat for more information'));   
                else 
                {
                    update order;
                    
                    selectedsave();
                    
                    if(Nospares == true || SparesQtyCheck == true || TerminalsQtyCheck == true)
                        return null;
                    else
                    {
                        pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&viewmode=false&createnewline=true');
                        pag.setredirect(true);
                        return pag;
                    }
                }
            }
            return null;
        }catch(exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! ' + e.getDmlMessage(0)));
            return null;
        } 
    }      
    
       // Save selected OrderLine from Spare Section - button Save Line
    public Pagereference selectedsave() 
    {
        Nospares = false;
        SparesQtyCheck=false;
        Contract c;
        
        Schema.DescribeSObjectResult Orderobj = Schema.SObjectType.Order__c;
        Map<String,Schema.RecordTypeInfo> ORDRectype = Orderobj.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderRecByName = ORDRectype.get('Order');
        ID ORDRecTypeID= orderRecByName.getRecordTypeId();        
        
        checkCustomerPO(order.Account__c,order.CustomerPO__c);
        if(chkCustomerPO == true)
            return null;
        checkcontract();
        if(checkcontract==true)
            return null;
        if(order.Contract__c == '' || order.Contract__c == null) 
        {                
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Contract associated with the Account/ Order, Contact ViaSat for more information'));  
            return null; 
        }
        else
            c=[select Spares_Quantity__c,Spares_Price_List__c,Order_Price_List__c from Contract where ContractNumber=:order.Contract__c];

        try 
        {
            if(orderid == '' || orderid == null) 
            {
                if (order.AgreetoTermsConditions__c!=true) 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please accept the terms and conditions'));
                
                order.RecordTypeId=ORDRecTypeID;
                insert order;
                orderid = order.id;
            }
               
            List<orderline__c> selectedol = new List<orderline__c>();
            Set<id> olOrderprice = new set<id>();
            for(neworderlist ol: gettotaloderlist()) 
            {
                selectedol.add(ol.ol);
                olOrderprice.add(ol.ol.Spares__c);
            }
            Map<id,OrderPrice__c>  maporderprice = new Map<id,OrderPrice__c>([select id,SparesBlockSize__c,ProductDescription__c,Product_Name__c from OrderPrice__c where id in: olOrderprice]); 
            for(orderline__c ol: selectedol)
            {
                if(ol.order__c == null && orderId != '') 
                    ol.order__c = orderId;
                if (c.Spares_Price_List__c != null)
                    ol.OrderPriceList__c = c.Spares_Price_List__c;
                ol.order_price__c = ol.Spares__c;
                ol.Is_spares__c = true;             
                
                if(ol.Spares__c == null)  
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a spare part'));
                    Nospares = true;
                    return null;
                }                
                else if(math.mod(Integer.Valueof(ol.Quantity__c),Integer.Valueof(mapOrderprice.get(ol.Spares__c).SparesBlockSize__c)) <> 0 || ol.Quantity__c == 0)              
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Spares '+ mapOrderprice.get(ol.Spares__c).Product_Name__c +' Quantity should be multiples of '+ mapOrderprice.get(ol.Spares__c).SparesBlockSize__c));                                                      
                    SparesQtyCheck=true;
                    return null;
                }
            }
            if(orderid != null)
                update order;
            if(selectedol.size() > 0)
                upsert selectedol;
                
            if(TerminalSave == false)
            {
                TerminalSave = true;
                restrictSelectedSave = false;   // This restricts Selectedsave() without executing on click of order Save() This should be declared before calling SaveTerminal()              
               
                SaveTerminal();
                if(TerminalsQtyCheck == true)
                {
                    TerminalSave = false;
                    return null;
                }
                else
                {
                    pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&viewmode=false');
                    pag.setredirect(true);
                    return pag;
                }
            }
            else
                return null;
        }catch(exception e){for (Integer i = 0; i < e.getNumDml(); i++){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! ' + e.getDMLMessage(i)));return null;}  
        }
        return null;
    }
    
    // Delete Selected OrderLine from Spare Section - button Delete Line
    public PageReference selecteddelete() 
    {
        checkcontract();      
        if(checkcontract==true)
            return null;      

        List<orderline__c> selectedlist = new List<orderline__c>();
        List<orderline__c> checklist = new List<orderline__c>();       
        List<orderline__c> selectedsaved = new List<orderline__c>();
        List<orderline__c> selectedunsaved = new List<orderline__c>();
        for(neworderlist ol: gettotaloderlist()) 
        {   
            if(ol.selected == true)
                selectedlist.add(ol.ol);         
            if(ol.selected == false && ol.linespareprice == 0.0)
                checklist.add(ol.ol);
            if(ol.selected == true && ol.linespareprice != 0.0)            
                selectedsaved.add(ol.ol);
            if(ol.selected == true && ol.linespareprice == 0.0)            
                selectedunsaved.add(ol.ol);
        }
        if(selectedlist.size()<=0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one spare part to delete.'));
            return null;
        }
        
        Boolean temp = false;
        list<Contract> lstcon =[select Spares_Price_List__c,Order_Price_List__c from Contract where ContractNumber=:order.Contract__c];        

        for(orderline__c ol: checklist)
        {  
            if(ol.order__c==null && orderId != '') 
                ol.order__c=orderId;
            if(lstcon.size()>0)
                if(lstcon[0].Spares_Price_List__c != null)             
                    ol.OrderPriceList__c = lstcon[0].Spares_Price_List__c;
            ol.order_price__c=ol.Spares__c;
            ol.Is_spares__c = true;
            if(ol.Spares__c != null)  
                temp = true;               
        }
        if(temp == true)
            upsert checklist;
        
        try
        {
            if(selectedsaved.size()>0)
                delete selectedsaved;
            if(selectedsaved.size()>0 && selectedunsaved.size()==0)
            {
                pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id);
                pag.setredirect(true);
                return pag;
            }
            if(selectedunsaved.size()>0)
            {
                pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&createnewline=false');
                pag.setredirect(true);
                return pag;
            }
        } catch(Exception e){
             pagereference pag= new pagereference('/apex/ToowayOrderAdmin?id='+order.id+'&createnewline=false');
             pag.setredirect(true);
             return pag;
        } 
        oderlinelist=null;
        return null;             
    }
    
    public PageReference myorders()
    {
        pagereference pag= new pagereference('/apex/Tooway_OrderHome_CustomerPortal?sfdc.tabName=01rS0000000DDGZ');
        pag.setredirect(true);
        return pag;
    }
    public PageReference cancel2()
    {
        pagereference pag= new pagereference(sfURL+'a0a/o');
        return pag;
    }
        // Cancel an order
    public PageReference cancelorder()
    {
        try
        {
            if(orderId != null && orderId != '')
            {
                order.Status__c = 'Cancelled';
                update order;
            }
            pagereference pag= new pagereference('/apex/ToowayOrderReview?id='+order.id);
            pag.setredirect(true);
            return pag;
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! ' + e.getDmlMessage(0)));
            return null;
        } 
    }

    public void savedoc()
    {
        save();
        string orderId=order.id;
       
        if (errorMessage !=null) 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
        else if(myfile.name!=null)
        {
            Transient attachment a = new attachment(parentId = orderId, name=myfile.name, body = myfile.body);  
            try
            {
                insert a; 
            }catch (DMLException e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Error uploading attachment, Please check the file size'));
            }
        }
        else if(myfile.name==null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please Browse and select a file to Attach'));
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Browse and select a file to Attach'));
    }
    public PageReference viewAttachment()
    {
        string attid=apexpages.currentpage().getparameters().get('attachmentid');
        pagereference pag= new pagereference('/servlet/servlet.FileDownload?file='+attid);       
        return pag;
    }
    public PageReference editAttachment()
    {
        string attid1=apexpages.currentpage().getparameters().get('attachmentid');
        pagereference pag= new pagereference('/'+attid1+'/e?retURL=%2F'+order.id);
        pag.setredirect(true);
        return pag;
    } 
    public void delAttachment()
    {
        string attid=apexpages.currentpage().getparameters().get('attachmentid');
        attachment tempAttachment = new attachment();
        tempAttachment =[select Id from Attachment where id =:attid]; 
        try
        {
            delete tempAttachment;
        }catch (System.DmlException e){
        for (Integer i = 0; i < e.getNumDml(); i++)
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, + 'You do not have permission to change this attachment. Please contact your administrator'));
        }
    }
    public Order__c getprofee()
    {
        return null;
    }  
    
    public void checkCustomerPO(id orderacc,string customerPO)
    {
        list<order__c> lstorder = [Select id from order__c where Account__c =:orderacc and CustomerPO__c =: customerPO and id !=: orderid];
        if(lstorder.size()>0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter unique Customer PO for given account.'));
            chkCustomerPO = true;
        }
        else
            chkCustomerPO = false;
    }   
    
    
    // Update Spare Quantity if not set - case 316272
    public pageReference updateQuantity()
    {      
                            
        System.debug('currentRow:' + currentRow);
                        
        // set default quantity (if no quantity)
        neworderlist nol = gettotaloderlist()[currentRow];  
        
        System.debug('nol:' + nol);
            
        if (nol.ol.Quantity__c == null || nol.ol.Quantity__c == 0)
        {
            try
            {
                OrderPrice__c op = [select id,SparesBlockSize__c,ProductDescription__c,Product_Name__c from OrderPrice__c where id = :nol.ol.Spares__c]; 
                if (op != null)
                    nol.ol.Quantity__c= op.SparesBlockSize__c;
            }
            catch (Exception e)
            {
                
            } 
        }
                                                
        return null;
    }    
    
    
}