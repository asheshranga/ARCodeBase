/*********************************************************************************
Name         : AtlasBillingHistoryPaginationController
Created By   : Edwin Raymond
Modified BY  : Edwin Raymond
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 22 October 2013
Usages       : Controller for VisualForce Component: AtlasBillHistoryPageBillingHistory
*********************************************************************************/
public with sharing class AtlasBillingHistoryPaginationController extends AtlasDataManager{
    // Get the mainDTO object which has all data.
    Public AtlasMainDTO mainDTO{get;set;} 
    // Instantiate the generic Pagination controller
    public AtlasGenericPaginationController paginater{get;set;}
    // Create Lists to hold the data to be be displayed in tables
    public List<AtlasBillingHistoryDTO.billingHistoryLineItem> billList{get;set;}
    public List<List<AtlasBillingHistoryDTO.billingHistoryLineItem>> allBillList{get;set;}
    // Create a boolean variable to show/hide invoice details section
    public boolean isInvoiceDetailsVisible{get;set;} 
    // Create a variable to hold the current Invoice number
    public String invoiceReference{get;set;}
    public string styleBlueOrange{get;set;}     
    public String bottomBorderColor{get;set;}
    public String borderleftOrRightcolor{get;set;}
    public boolean bnExede{get;set;}
    public boolean bnWildblue{get;set;}
    // Variables used in AtlasBillHistoryPageBillingHistory.Component
    public string StatementDateLabel{get{return AtlasConstants.StatementDateLabel;}set;}
    public string InvoiceNumberLabel{get{return AtlasConstants.InvoiceNumberLabel;}set;}
    public string InvoiceTotalLabel{get{return AtlasConstants.InvoiceTotalLabel;}set;}   
    public Boolean showDisclaimerText2{get{if(AtlasUtility.getMapValue(AtlasConstants.SHOW_DISCLAIMER_2).equalsIgnoreCase('false')) {return false;} else {return true;}}set;}
    // Create a variable to store the selected invoice detail
    Public AtlasCurrentBillDTO selectedBillData{get;set;}
    
        public string subFooterText1 { get {
            return AtlasUtility.getMapValue(AtlasConstants.Atlas_Current_Bill_SubFooter_Msg1);
        }
            private set;
        }
        public string exedeCustomerSupportUrl { get {
            return AtlasUtility.getUrl(AtlasConstants.EXEDE_CUSTOMER_SUPPORT_URL);
        }
            private set;
        }
        public string exedeCustomerSupportHyperlinkText { get {
            return AtlasUtility.getHyperLinkText(AtlasConstants.EXEDE_CUSTOMER_SUPPORT_URL);
        }
            private set;
        }
        public string subFooterText2 { get {
            return AtlasUtility.getMapValue(AtlasConstants.Atlas_Current_Bill_SubFooter_Msg2);
        }
            private set;
        }
        
    /**
    * @author Raghuprasad Halakere
    * @description - zero parmater AtlasBillingHistoryPaginationController constructor
    * @input param  - null
    * @return null
    */
    Public AtlasBillingHistoryPaginationController()
    {
        isInvoiceDetailsVisible=false;
        
    }
    /**
    * @author Raghuprasad Halakere
    * @description - method to call on component load to organize the list
    * @input param  - null
    * @return String
    */     
    Public String getLoadFunctionsOnComponentLoad()
    {
        //Get the data we need to paginate
        List<AtlasBillingHistoryDTO.billingHistoryLineItem> resultsList=getBillingHistoryList();
        
        //Set the page size
        Integer pageSize=5;
        
        //Create a new instance of AtlasGenericPaginationController passing in the overall size of
        //the list of data and the page size you want
        if(resultsList != null)
            this.paginater=new AtlasGenericPaginationController(resultsList.size(),pageSize);
        else
            this.paginater=new AtlasGenericPaginationController(0, pageSize);
        //These lists hold the data
        this.allBillList=new List<List<AtlasBillingHistoryDTO.billingHistoryLineItem>>();
        this.billList=new List<AtlasBillingHistoryDTO.billingHistoryLineItem>();
        
        //Break out the full list into a list of lists
        if(resultsList != null)
        if(resultsList.size() > 0){
            List<AtlasBillingHistoryDTO.billingHistoryLineItem> tempCC=new List<AtlasBillingHistoryDTO.billingHistoryLineItem>();        
            Integer i=0;
            for(AtlasBillingHistoryDTO.billingHistoryLineItem cc : resultsList){
                tempCC.add(cc);
                i++;
                if(i == pageSize){
                    this.allBillList.add(tempCC);
                    tempCC=new List<AtlasBillingHistoryDTO.billingHistoryLineItem>();
                    i=0;
                }
            }
            if(!tempCC.isEmpty()){
                this.allBillList.add(tempCC);
            }
             
            //Gets the correct list of data to show on the page
            this.billList=this.allBillList.get(this.paginater.index);
        }
        return null;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - getBillingHistoryList for AtlasBillingHistoryPaginationController
    * @input param  - null
    * @return mainDTO.billhistoryDTOObj.billHistory
    */
    public List<AtlasBillingHistoryDTO.billingHistoryLineItem> getBillingHistoryList()
    {
        if (mainDTO.billhistoryDTOObj!=null)
            return mainDTO.billhistoryDTOObj.billHistory;
        else
            return null;    
    }
    /**
    * @author Raghuprasad Halakere
    * @description - previousPage for AtlasBillingHistoryPaginationController
    * @input param  - null
    * @return PageReference
    */
    /************ Pagination Methods ***************************/
    public PageReference previousPage(){
        this.paginater.decrement();
        return changeData();
    }
    /**
    * @author Raghuprasad Halakere
    * @description - nextPage for AtlasBillingHistoryPaginationController
    * @input param  - null
    * @return PageReference
    */
    public PageReference nextPage(){
        this.paginater.increment();
        return changeData();
    }
    /**
    * @author Raghuprasad Halakere
    * @description - updatePage for AtlasBillingHistoryPaginationController
    * @input param  - null
    * @return PageReference
    */
    public PageReference updatePage(){
        this.paginater.updateNumbers();
        return changeData();
    }
    /**
    * @author Raghuprasad Halakere
    * @description - changeData on clicking previous/next page for AtlasBillingHistoryPaginationController
    * @input param  - null
    * @return PageReference
    */
    public PageReference changeData(){
        if(allBillList.size() > 0)
          this.billList=this.allBillList.get(this.paginater.index);
        return null;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - viewInvoiceDetails for AtlasBillingHistoryPaginationController
    * @input param  - null
    * @return PageReference
    */
    public pageReference viewInvoiceDetails()
    {
        String invoiceRef=Apexpages.currentPage().getParameters().get(AtlasConstants.PARAMETER_VARIABLE); 
        invoiceReference=invoiceRef;
        selectedBillData=populateCurrentBillData(invoiceRef);
        isInvoiceDetailsVisible=true;
        return null;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - Prints the selected invoice for AtlasBillingHistoryPaginationController
    * @input param  - null
    * @return PageReference
    */ 
    public pageReference printInvoice()
    {
        AtlasBillingHistoryController.printInvoiceBillDTOObj=this.selectedBillData;
        AtlasBillingHistoryController.printInvoiceReference=this.invoiceReference;
        Pagereference p=Page.AtlasBillingHistoryPrintInvoice;
        p.setRedirect(false);
        return p;
    }
    /**
    * @author Raghuprasad Halakere
    * @description - Gives Back PageReference of Billing History screen from Invoice details screen
    * @input param  - null
    * @return PageReference
    */      
    public pageReference gotoBillingHistory()
    {  
        isInvoiceDetailsVisible=false;
        return null;
    } 
    
}