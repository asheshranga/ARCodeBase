/************************************************************************************************************************************************************
Created By    : Nazeer Ahamed
Use of Class  : 
Company Name  : NTT DATA,Inc. 
Modified By   : Rajesh Kaliyaperumal
*************************************************************************************************************************************************************/

global class ToowayAddTerminalController
{
    public String debugLogs{get;set;} 
    // the soql without the order and limit
    public String soql {get;set;}  
    public Id orderNumber {get; set;} 
    public String orderName {get; set;}
    public String selectedAntenna{get; set;}
    public String selectedModem{get; set;}
    public String selectedTRIA{get; set;}
    public Id currentOrderPriceListId {get; set;}
    public boolean  isPageInEditMode{get; set;}
    public Account orderPriceListForAccount {get; set;} 
    public Contract orderPriceListForContract {get; set;}
    
    public List<String> catList {get;set;}
    public OrderPriceWrapper selectedAntennaOrderPriceWrapper  {get;set;}
    public Map<Id,OrderPriceWrapper> orderPriceWrapperMap {get;set;}
    public Map<Id,ModemTRIAWrapper> modemWrapperMap {get;set;}
    public Map<Id,ModemTRIAWrapper> TRIAWrapperMap {get;set;}
    public List<OrderPriceWrapper> orderPriceWrapperList {get;set;}
    public List<ModemTRIAWrapper> modemWrapperList {get;set;}
    public List<ModemTRIAWrapper> TRIAWrapperList {get;set;}
    public String selectedEditAntennaId{get;set;}
    public String selectedEditModemId{get;set;}
    public String selectedEditTRIAId {get;set;}
    public Decimal editTerminalID  {get;set;}
    public Double editTRIAVal  {get;set;}
    public Double editModemVal {get;set;}
    public Double editAntennaVal {get;set;}
    public ID editAntennaOrderLineSalesforceId {get;set;}
    public ID editModemOrderLineSalesforceId {get;set;}
    public ID editTRIAOrderLineSalesforceId {get;set;}
    List<OrderLine__c> editOrderLineList {get;set;} 
    public double randomnumb;
    public boolean exceptionCaused = false;
    
    /**************************************************************************Constructor for class***************************************************************/
     
    public ToowayAddTerminalController ()
    {
        isPageInEditMode = FALSE;
        Id orderID = Apexpages.currentPage().getParameters().get('id');
        
        if(Apexpages.currentPage().getParameters().get('productId') != null && Apexpages.currentPage().getParameters().get('productId') != '')
        editTerminalID = decimal.valueof(Apexpages.currentPage().getParameters().get('productId'));
        
        randomnumb =Math.round(Math.random()*1000000000);

        if(Test.isRunningtest() || editTerminalID != null)
        {        
            try
            {
                system.debug('!!!!!editTerminalID  '+ editTerminalID );
                editOrderLineList =[select id,Random_Number__c,Order_Price__c,Related_Antenna__c,Order_Price__r.Price__c,Order_Price__r.Product_Category__c from OrderLine__C where Order__c=:orderID and  Random_Number__c =:editTerminalID];
                for(OrderLine__C ol:editOrderLineList)
                {
                    system.debug('!!!!!editTerminalID 2 '+ editTerminalID );
                    system.debug('!!!!!Random Number  '+ ol.Random_Number__c );
                    if(ol.Order_Price__r.Product_Category__c == 'Antenna')
                    {
                        selectedEditAntennaId=ol.Order_Price__c; 
                        editAntennaVal = ol.Order_Price__r.Price__c;
                        selectedAntenna=ol.Order_Price__c;
                        system.debug('selected Antenna '+ selectedAntenna);
                        editAntennaOrderLineSalesforceId =ol.Id;
                    }
                    if(ol.Order_Price__r.Product_Category__c == 'Modem')
                    {
                        selectedEditModemId =ol.Order_Price__c;
                        editModemVal = ol.Order_Price__r.Price__c;
                        selectedModem=ol.Order_Price__c;
                        system.debug('selected Modem '+ selectedModem);
                        editModemOrderLineSalesforceId =ol.Id;
                    }
                    if(ol.Order_Price__r.Product_Category__c == 'TRIA')
                    {
                        selectedEditTRIAId =ol.Order_Price__c;
                        editTRIAVal = ol.Order_Price__r.Price__c;
                        selectedTRIA=ol.Order_Price__c;
                        system.debug('Selected TRIA'+ selectedTRIA);
                        editTRIAOrderLineSalesforceId =ol.Id;
                    }
                }
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() ));
            }
            isPageInEditMode =TRUE;
        }
        orderNumber = orderID;
        Order__c currentOrder = [select Account__c,Contract__c, Name from Order__c where Id = :orderID];
        orderName = currentOrder.Name;
        
        if(currentOrder.Contract__c == '' || currentOrder.Contract__c == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Tooway Contract associated with this Account/Order, Contact ViaSat for more information.'));
        else
        {
            orderPriceListForContract = [Select Id, ContractNumber, Name, Order_Price_List__c From Contract where 
                                         ContractNumber =:currentOrder.Contract__c and Business_Type__c='Tooway'];
            
            if(orderPriceListForContract.Order_Price_List__c == null )
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Order Price List associated with this Contract'));
            else
            {
                currentOrderPriceListId = orderPriceListForContract.Order_Price_List__c;
                
                soql = 'Select Id, Name, Price__c, PriceList__c, Product__r.Name, Product__r.Product_Category__c, Product__r.Product_Short_Description__c, Product__r.ProductGrade__c ' +
                        'From OrderPrice__c where Product__r.Product_Category__c = \'Antenna\' and (product__r.ProductExpirationDate__c = NULL OR product__r.ProductExpirationDate__c >= Today)';             
             
                soql += ' and PriceList__c = \'' + orderPriceListForContract.Order_Price_List__c + '\'';
                system.debug('### - soql'+soql);
                runQuery();     
            }
        }    
    }
    public PageReference addTerminalToOrder()
    {
        exceptionCaused = false;
        
        Schema.DescribeSObjectResult orderline = Schema.SObjectType.OrderLine__c;
        Map<String,Schema.RecordTypeInfo> olRectype = orderline.getRecordTypeInfosByName();
        Schema.RecordTypeInfo orderlineRecByName = olRectype.get('Order');
        ID olRecTypeID= orderlineRecByName.getRecordTypeId();

        if(!isPageInEditMode)
        {
            List<OrderLine__c> associationsToInsert = new List<OrderLine__c>();   
            OrderLine__c tempObj;
            try{
                populate_Radio_Button_Selection();
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Select one part of each category' ));
                exceptionCaused = true;
                return null;
            }
            if(selectedAntennaOrderPriceWrapper != null && !exceptionCaused)
            {                   
                List<OrderTerminalBlockConfiguration__c> listTerminalBlockConfig = [Select Antenna__c, Modem__c, TRIA__c, Blocksize__c from OrderTerminalBlockConfiguration__c where 
                                                                                    Antenna__c =:selectedAntennaOrderPriceWrapper.antenna.Id and 
                                                                                    Modem__c=:selectedAntennaOrderPriceWrapper.selectedModem.modemTRIA.ID and 
                                                                                    TRIA__c =:selectedAntennaOrderPriceWrapper.selectedTRIA.modemTRIA.ID];
                if(listTerminalBlockConfig.size() == 0)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please contact viasat team for Terminal Configuration.'));                
                    return null;
                }
                else
                {
                    tempObj = new OrderLine__c();
                    tempObj.Order__c = orderNumber;
                    tempObj.Related_Antenna__c = selectedAntennaOrderPriceWrapper.antenna.product__c;
                    tempObj.Order_Price__c = selectedAntennaOrderPriceWrapper.antenna.Id;
                    //tempObj.Quantity__c = orderPriceListForContract.Terminals_Quantity__c;                                            
                    tempObj.Quantity__c = listTerminalBlockConfig[0].Blocksize__c;                                            
                    tempObj.RecordTypeId = olRecTypeID;  
                    tempObj.OrderPriceList__c = currentOrderPriceListId;  
                    tempObj.Random_Number__c = randomnumb;                                       

                    associationsToInsert.add(tempObj);
                    
                    tempObj = new OrderLine__c();
                    tempObj.Order__c = orderNumber;
                    tempObj.Related_Antenna__c = selectedAntennaOrderPriceWrapper.antenna.product__c;
                        
                //******************************************************************************Check if tempOrderPrice is not NULL******************************************************************//
                
                    if(selectedAntennaOrderPriceWrapper.selectedModem != null)
                        tempObj.Order_Price__c = selectedAntennaOrderPriceWrapper.selectedModem.modemTRIA.ID;
                    else
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Select one part of each category for modem ' +selectedAntennaOrderPriceWrapper.antenna.Product__r.Name));
                    
                    //tempObj.Quantity__c = orderPriceListForContract.Terminals_Quantity__c;
                    tempObj.Quantity__c = listTerminalBlockConfig[0].Blocksize__c;
                    tempObj.OrderPriceList__c = currentOrderPriceListId;
                    tempObj.RecordTypeId = olRecTypeID;
                    tempObj.Random_Number__c = randomnumb;                
                    associationsToInsert.add(tempObj);

                    tempObj = new OrderLine__c();
                    tempObj.Order__c = orderNumber;
                    tempObj.Related_Antenna__c=selectedAntennaOrderPriceWrapper.antenna.product__c;

                //***********************************************************************************Check if tempOrderPrice is not NULL****************************************************************//
                    
                    if(selectedAntennaOrderPriceWrapper.selectedTRIA != null)
                        tempObj.Order_Price__c = selectedAntennaOrderPriceWrapper.selectedTRIA.modemTRIA.ID;
                    else
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Select one part of each category for TRIA ' +selectedAntennaOrderPriceWrapper.antenna.Product__r.Name));

                    //tempObj.Quantity__c = orderPriceListForContract.Terminals_Quantity__c;
                    tempObj.Quantity__c = listTerminalBlockConfig[0].Blocksize__c;
                    tempObj.OrderPriceList__c = currentOrderPriceListId;
                    tempObj.RecordTypeId = olRecTypeID;
                    tempObj.Random_Number__c = randomnumb;
                    associationsToInsert.add(tempObj);
        
                    System.debug('associationsToInsert :'+associationsToInsert);
                }
                try
                {
                    insert associationsToInsert;
                } 
                catch(System.DmlException e)
                {
                    for (Integer i = 0; i < e.getNumDml(); i++)
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while processing selections - ' + e.getDmlMessage(i)));
                }
            }
            else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Select one part of each category.' ));
    
            if(ApexPages.getMessages().size() > 0)
                return null;
            else 
                return  new PageReference('/apex/ToowayOrderAdmin?id='+orderNumber+'&viewmode=false');
        }
        else 
        {
            populate_Radio_Button_Selection();

            if(editAntennaOrderLineSalesforceId != null)
            {
                system.debug('test inside else editAntennaOrderLineSalesforceId ' + editAntennaOrderLineSalesforceId);
               
                List<OrderLine__c> associationsToUpdate = new List<OrderLine__c>();
                for(OrderLine__c ol:editOrderLineList)                              
                {    
                    if(ol.Order_Price__r.Product_Category__c == 'Modem')
                    {
                        ol.Order_Price__c=selectedAntennaOrderPriceWrapper.selectedModem.modemTRIA.ID;
                        try
                        {
                            if(ol.id==editModemOrderLineSalesforceId && ol.Order_Price__c==selectedModem)
                                associationsToUpdate.add(ol);
                        }
                        catch(Exception e){ }
                    }
                    if(ol.Order_Price__r.Product_Category__c == 'TRIA')
                    {
                        try
                        {
                            ol.Order_Price__c=selectedAntennaOrderPriceWrapper.selectedTRIA.modemTRIA.ID;
                            associationsToUpdate.add(ol);
                        }
                        catch(Exception e){ }
                    }
                }
                if(associationsToUpdate.size()>0)
                    update associationsToUpdate;

                System.debug(associationsToUpdate);
                return  new PageReference('/apex/ToowayOrderAdmin?id='+orderNumber+'&viewmode=false');
            }
        }
        return null;           
    }

    // ApexPages.StandardSetController must be instantiated     
    // for standard list controllers     
    public ApexPages.StandardSetController setCon 
    {
        get 
        {
            if(setCon == null) 
            {
                System.debug('### - SQL Query - '+soql + ' order by ' + sortField + ' ' + sortDir);   
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));
            }
            return setCon;
        }
        set;
    }
  
    //**************************************************************************************** the collection of CCRs to display************************************************************************************//
    
    public List<OrderPrice__c> orderPriceList
    {
        get 
        {  
            return (List<OrderPrice__c>) setCon.getRecords();
        }
        set;
    }
    public void  populate_Radio_Button_Selection_GetSet()
    {
        System.debug('populate_Radio_Button_Selection_GetSet');
    }
    public void  populate_Radio_Button_Selection()
    {
        selectedAntennaOrderPriceWrapper = orderPriceWrapperMap.get(selectedAntenna);
        if(!Test.isRunningTest())
        {
            selectedAntennaOrderPriceWrapper.selectedModem = null;
            selectedAntennaOrderPriceWrapper.selectedTRIA = null;
        }
        debugLogs='\nselectedModem='+selectedModem + '\nselectedTRIA='+selectedTRIA ;
        
        try
        {
            if(selectedModem !=null)
            {               
                selectedAntennaOrderPriceWrapper.selectedModem =modemWrapperMap.get(selectedModem);
            }
            if(selectedTRIA != null)
            {
                selectedAntennaOrderPriceWrapper.selectedTRIA =TRIAWrapperMap.get(selectedTRIA);
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +e.getMessage()));
            exceptionCaused = true;
            return ;   
        }                     
    }
  
    public Integer resultSize 
    {
        get {return orderPriceList.size();}
        set;
    }
  
    //*********************************************************************** the current sort direction. defaults to asc******************************************************************************//
    
    public String sortDir 
    {
        get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
        set;
    }
 
    //************************************************************************* the current field to sort by. defaults to last name********************************************************************//
    
    public String sortField 
    {
        get  { if (sortField == null) {sortField = 'name '; } return sortField;  }
        set;
    }

    //************************************************************************ format the soql for display on the visualforce page*********************************************************************//

    public String debugSoql 
    {
        get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
        set;
    }
  
   //**************************************************************************** toggles the sorting of query from asc<-->desc************************************************************************//
  
    public void toggleSort() 
    {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        runQuery();
    }
    
    Public void populatePartAssociations()
    { 
        String soql = 'Select Id, Name, Price__c, PriceList__c, Product__r.Name, Product__r.Product_Category__c, Product__r.Product_Short_Description__c, Product__r.ProductGrade__c ' +
                        ' From OrderPrice__c where Product__r.Product_Category__c in( \'Modem\',\'TRIA\') and (product__r.ProductExpirationDate__c = NULL OR product__r.ProductExpirationDate__c >= Today)';             
        soql += ' and PriceList__c = \'' + orderPriceListForContract.Order_Price_List__c + '\'';
        //***************************************************************************************
        List<OrderTerminalBlockConfiguration__c> listTerminalBlockConfig = [Select Antenna__c, Modem__c, TRIA__c, Blocksize__c from OrderTerminalBlockConfiguration__c];
        Map<id,list<ID>> ConfigAntennaModem =  new Map<id,list<ID>>();
        Map<id,list<ID>> ConfigAntennaTria = new Map<id,list<ID>>();
        
        for(OrderTerminalBlockConfiguration__c otb : listTerminalBlockConfig)
        {
            list<ID> templist = new list<ID>(); 
            if(ConfigAntennaModem.containskey(otb.Antenna__c))
            {
                templist= ConfigAntennaModem.get(otb.Antenna__c);
                templist.add(otb.Modem__c);
                ConfigAntennaModem.put(otb.Antenna__c,templist);
            }
            else
            {
                templist.add(otb.Modem__c);
                ConfigAntennaModem.put(otb.Antenna__c,templist); 
            }
            
            list<ID> templist1 = new list<ID>(); 
            if(ConfigAntennaTria.containskey(otb.Antenna__c))
            {
                templist1= ConfigAntennaTria.get(otb.Antenna__c);
                templist1.add(otb.TRIA__c);
                ConfigAntennaTria.put(otb.Antenna__c,templist1);
            }
            else
            {
                templist1.add(otb.TRIA__c);
                ConfigAntennaTria.put(otb.Antenna__c,templist1); 
            }           
        }
        
        //***********************************************************************************
        List<OrderPrice__c> orderPriceList2 = Database.query(soql);    
        List<OrderPrice__c> orderPriceModemList = new List<OrderPrice__c>();
        List<OrderPrice__c> orderPriceTRIAList = new List<OrderPrice__c>();
        List<OrderPrice__c> orderPriceAntennaList = new List<OrderPrice__c>();      
        //****************** 
        Map<id,OrderPrice__c> mapOrderPrice = new Map<id,OrderPrice__c>();
        for(OrderPrice__c op : orderPriceList2) 
           mapOrderPrice.put(op.id,op);
        //****************** 
        orderPriceAntennaList=  setCon.getRecords();
        
        for(OrderPrice__c op:orderPriceList2)
        {
            if(op.Product__r.Product_Category__c.trim().equalsIgnoreCase('Modem'))
                orderPriceModemList.add(op);
            else if(op.Product__r.Product_Category__c =='TRIA')
                orderPriceTRIAList.add(op);
        }
        mergeModemTRIAList(orderPriceModemList,orderPriceTRIAList); 
        orderPriceWrapperList = new  List<OrderPriceWrapper>();
        Integer myCounter = 1; 
        
        orderPriceWrapperMap = new Map<Id,OrderPriceWrapper>();
        OrderPriceWrapper oTemp=null;       
        Set<ModemTRIAWrapper> TRIAWrapperList3 = new Set<ModemTRIAWrapper>();
        Set<ModemTRIAWrapper> ModemWrapperList3 = new Set<ModemTRIAWrapper>();
        List<ModemTRIAWrapper> TRIAWrapperList4 = new List<ModemTRIAWrapper>();
        List<ModemTRIAWrapper> ModemWrapperList4 = new List<ModemTRIAWrapper>();
        
        ModemTRIAWrapper mTemp=null;
        
        //Added for MR1-248 : TRIA grouped by Product grade**************
        for(OrderPrice__c opTRIA: orderPriceTRIAList)
        {      
            mTemp =new ModemTRIAWrapper((String)opTRIA.Product__r.Product_Category__c,opTRIA);
            TRIAWrapperList.add(mTemp);
            TRIAWrapperMap.put(opTRIA.id,mTemp);            
        }
        
         for(OrderPrice__c opModem: orderPriceModemList)
        {
            mTemp =new ModemTRIAWrapper((String)opModem.Product__r.Product_Category__c,opModem);
            modemWrapperList.add(mTemp);
            modemWrapperMap.put(opModem.id,mTemp);             
        }
        //*************************************************************
        
        
        for(OrderPrice__c opAntenna : orderPriceAntennaList)
        {           
            if(isPageInEditMode)
            {               
                if(opAntenna.product__c ==editOrderLineList[0].Related_Antenna__c )
                {
                    //Added for MR1-248 : TRIA grouped by Product grade**************
                    TRIAWrapperList3 = new Set<ModemTRIAWrapper>();
                    TRIAWrapperList4 = new List<ModemTRIAWrapper>();
                    list<id> TRIAs = ConfigAntennaTria.get(opAntenna.id);
                    if(TRIAs != null)
                        for(ModemTRIAWrapper w: TRIAWrapperList)
                          for(ID tid : TRIAs)
                            if(w.modemTRIA.id == tid)
                               TRIAWrapperList3.add(w);
                        
                    TRIAWrapperList4.addall(TRIAWrapperList3);
                    
                    ModemWrapperList3 = new Set<ModemTRIAWrapper>(); 
                    ModemWrapperList4 = new List<ModemTRIAWrapper>();                       
                    list<id> Modems = ConfigAntennaModem.get(opAntenna.id);
                    if(Modems != null)
                        for(ModemTRIAWrapper w: modemWrapperList)
                          for(ID mid : Modems)
                            if(w.modemTRIA.id == mid)
                               ModemWrapperList3.add(w);
                    ModemWrapperList4.addall(ModemWrapperList3);          
                    /* for(ModemTRIAWrapper w : TRIAWrapperList)
                        if(opAntenna.Product__r.ProductGrade__c == w.modemTRIA.Product__r.ProductGrade__c)      
                            TRIAWrapperList3.add(w);*/
                    //***************************************************************       
                    oTemp =new OrderPriceWrapper(opAntenna,ModemWrapperList4,TRIAWrapperList4,myCounter++);
                    orderPriceWrapperList.add(oTemp);
                    orderPriceWrapperMap.put(opAntenna.id,oTemp);                    
                }
            }
            else
            {
                //Added for MR1-248 : TRIA grouped by Product grade**************
                TRIAWrapperList4 = new List<ModemTRIAWrapper>();
                TRIAWrapperList3 = new Set<ModemTRIAWrapper>();
                list<id> TRIAs = ConfigAntennaTria.get(opAntenna.id);                   
                if(TRIAs != null)
                {
                    for(ID tid : TRIAs)
                      for(ModemTRIAWrapper w: TRIAWrapperList)
                        if(w.modemTRIA.id == tid)
                           TRIAWrapperList3.add(w);
                }
                TRIAWrapperList4.addall(TRIAWrapperList3);
                
                ModemWrapperList3 = new Set<ModemTRIAWrapper>(); 
                ModemWrapperList4 = new List<ModemTRIAWrapper>();               
                list<id> Modems = ConfigAntennaModem.get(opAntenna.id);
                if(Modems != null)
                    for(ModemTRIAWrapper w: modemWrapperList)
                         for(ID mid : Modems)
                            if(w.modemTRIA.id == mid)
                               ModemWrapperList3.add(w);
                ModemWrapperList4.addall(ModemWrapperList3);                
                /*for(ModemTRIAWrapper w : TRIAWrapperList)
                    if(opAntenna.Product__r.ProductGrade__c == w.modemTRIA.Product__r.ProductGrade__c)      
                        TRIAWrapperList3.add(w);*/
                //***************************************************************   
                oTemp =new OrderPriceWrapper(opAntenna,ModemWrapperList4,TRIAWrapperList4,myCounter++);
                orderPriceWrapperList.add(oTemp);
                orderPriceWrapperMap.put(opAntenna.id,oTemp);
            }
        }
    }//**************************************************************************
    
    
  
    private void mergeModemTRIAList(List<OrderPrice__c> orderPriceModemList,List<OrderPrice__c> orderPriceTRIAList)
    {
        modemWrapperList= new List<ModemTRIAWrapper>();
        TRIAWrapperList = new List<ModemTRIAWrapper>();
        ModemTRIAWrapper mTemp=null;
        modemWrapperMap = new Map<Id,ModemTRIAWrapper>();
        TRIAWrapperMap = new Map<Id,ModemTRIAWrapper>();
        //Removed for MR1-248 : TRIA grouped by Product grade
       /* for(OrderPrice__c opModem: orderPriceModemList)
        {
            mTemp =new ModemTRIAWrapper((String)opModem.Product__r.Product_Category__c,opModem);
            modemWrapperList.add(mTemp);
            modemWrapperMap.put(opModem.id,mTemp); 
            System.debug('ModemTRIAWrapper - opModem '+ opModem.id);
        }*/        
       /* for(OrderPrice__c opTRIA: orderPriceTRIAList)
        {      
            mTemp =new ModemTRIAWrapper((String)opTRIA.Product__r.Product_Category__c,opTRIA);
            TRIAWrapperList.add(mTemp);
            TRIAWrapperMap.put(opTRIA.id,mTemp);
            System.debug('TRIAWrapperMap - opTRIA '+ opTRIA.id);
        }*/
    }
  
    public Boolean hasPrev 
    {
       get {return setCon.getHasPrevious();}
       set;
    }

    public Boolean hasNext 
    {
       get {return setCon.getHasNext();}
       set;
    }

    public String recordInfo 
    { 
        get { return (resultSize == 0) ? '':((setCon.getPageNumber() - 1) * setCon.getPageSize() + 1) + ' - ' + 
                    ((setCon.getPageNumber() * setCon.getPageSize()) < setCon.getResultSize() ? (setCon.getPageNumber() * setCon.getPageSize()) : setCon.getResultSize()) + ' of ' +
                    setCon.getResultSize(); } 
        set;
    }    
    
    public String pageInfo 
    { 
        get { return (resultSize == 0) ? '':'Page ' + setCon.getPageNumber() + ' of ' + 
                    (((setCon.getResultSize()/setCon.getPageSize())*setCon.getPageSize() == setCon.getResultSize()) ? (setCon.getResultSize() / setCon.getPageSize()) : (setCon.getResultSize() / setCon.getPageSize()+1));} 
        set;
    }    
    
    public void next() 
    {
        setCon.next();
    }
    
    public void previous() 
    {
        setCon.previous();
    }
    
    public void first() 
    {
        setCon.first();
    }
    
    public void last() 
    {
        setCon.last();
    }
    
    // runs the actual query
    public void runQuery() 
    {
        try 
        {
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql + ' order by ' + sortField + ' ' + sortDir));
            populatePartAssociations();
        }  
        catch (Exception e) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ' + e.getMessage() + ' SQL - ' + soql + ' order by ' + sortField + ' ' + sortDir));
        }
    }
 
    public List<OrderPrice__c> getCategoriesForAntenna()
    {
        return new List<OrderPrice__c>();
    }

    public PageReference cancelAction()
    {
        PageReference pg = new PageReference('/apex/ToowayOrderAdmin?id='+orderNumber+'&viewmode=true');
        return pg;
    }

    public class applicationException extends Exception {}
    
        //************************************************************************************* Inner Class for maintaining checkboxes********************************************************************************************//
    
    public class OrderPriceWrapper
    {
        public OrderPrice__c antenna {get; set;}
        public List<ModemTRIAWrapper> modemList {get; set;}
        public List<ModemTRIAWrapper> TRIAList {get; set;} 
        public Integer counter = 0; 
        public Boolean checked {get; set;}
        public Integer Quantity;
        public ModemTRIAWrapper selectedModem {get; set;}
        public ModemTRIAWrapper selectedTRIA {get; set;}
        
        public OrderPriceWrapper(OrderPrice__c antennae, List<ModemTRIAWrapper>  modemListIn, List<ModemTRIAWrapper>  TRIAListIn,Integer counterVal )
        {
            antenna = antennae;
            modemList = modemListIn;
            TRIAList = TRIAListIn;
            counter = counterVal;
            checked = false;
            Quantity = 0;
        }   
        public Integer getCounter()
        {
            return counter;
        }
        public Integer getQuantity()
        {
            return Quantity;
        }   
        public void setQuantity(Integer q)
        {
            Quantity = q;
        }
    }  
    
    public class ModemTRIAWrapper
    {
        public String modemTRIAName {get; set;}
        public OrderPrice__c modemTRIA {get; set;}
        public boolean radioChecked {get;set;}
        
        public ModemTRIAWrapper(String namec,OrderPrice__c p)
        {
            modemTRIAName = namec;
            modemTRIA = p;
            radioChecked = false;
        }  
    }
}