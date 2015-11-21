/*********************************************************************************
Name         : AtlasUsagePageBuyMoreController 
Created By   : Shiva Shankr N
Modified BY  : Sujit Kumar
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 8 November 2013
Modified Date : 30 October 2014
Usages       : Used in AtlasUsagePageBuyMore Component
*********************************************************************************/
public with sharing  class AtlasUsagePageBuyMoreController 
{ 
    
    // Global variables for maintainig the data 
    public string strBuyMore{get{return AtlasConstants.STR_BUYMORE;}set;}
    public string strData{get{return AtlasConstants.STR_DATA;}set;}
    public string strNoThanks{get{return AtlasConstants.STR_NO_THANKS;}set;}
    public string strPurchase{get{return AtlasConstants.STR_PURCHASE;}set;}
    public string strNote{get{return AtlasConstants.STR_NOTE;}set;}
    public string strPoint1{get{return AtlasUtility.getMapValue(AtlasConstants.STR_POINT1);}set;}
    public string strPoint2{get{return AtlasUtility.getMapValue(AtlasConstants.STR_POINT2);}set;}
    public string strPoint3{get{return AtlasUtility.getMapValue(AtlasConstants.STR_POINT3);}set;}
    public string strReadDetails{get{return AtlasUtility.getMapValue(AtlasConstants.STR_READ_DETAILS);}set;}
    public string strBuyMoreDetails{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BUYMORE_DETAILS);}set;} 
    public string strBadge1{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BADGE1);}set;}
    public string strBadge2{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BADGE2);}set;}
    public string strBadge3{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BADGE3);}set;}
    public string strBadge4{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BADGE4);}set;}
    public string strBadge5{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BADGE5);}set;}
    public string strBadge6{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BADGE6);}set;}
    public string strBadge7{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BADGE7a) + ' ' + AtlasUtility.getMapValue(AtlasConstants.STR_BADGE7b);}set;}
    public string strBadge8{get{return AtlasUtility.getMapValue(AtlasConstants.STR_BADGE8a) + ' ' + AtlasUtility.getMapValue(AtlasConstants.STR_BADGE8b) + ' ' + AtlasUtility.getMapValue(AtlasConstants.STR_BADGE8c);}set;}
    public string strClose{get{return AtlasConstants.STR_CLOSE;}set;}
    public boolean isVisibleExceptionMessage{get;set;}
    public string exceptionString{get;set;}
    public string exceptionStringSmall{get;set;}
    public boolean isVisibleSuccessAlert{get;set;}
    public string loadingBuyMore{get{return AtlasConstants.LOADING_BUYMORE;}set;}
    public string buyMoreGB{get{return AtlasConstants.BUYMORE_GB;}set;}
    public string buyMoreADd{get{return AtlasConstants.ADD_BUYMORE;}set;}
    public string purchasedData{get;set;}
    public string youString{get{return AtlasConstants.YOU;}set;}
    public string viewMore{get{return AtlasConstants.VIEW_MORE;}set;}
    public string buyMore1GB{get{return AtlasConstants.BUY_MORE_1GB;}set;}
    public string buyMore2GB{get{return AtlasConstants.BUY_MORE_2GB;}set;}
    public string buyMore3GB{get{return AtlasConstants.BUY_MORE_3GB;}set;}
    public string buyMore10GB{get{return AtlasConstants.BUY_MORE_10GB;}set;}
    public string styleClass{get;set;}
    public string errormsgForSuspenedAccount{get{return AtlasUtility.getMapValue(AtlasConstants.ERROR_MSG_SUSPENDED_ACCOUNT);}set;}
    public string errormsgForVacationAccount{get{return AtlasUtility.getMapValue(AtlasConstants.ERROR_MSG_VACATION_ACCOUNT);}set;}
    public string privisonStatus{get{return AtlasUtility.getMapValue(AtlasConstants.Buy_More_Valid_Status);}set;}
    public string BuymorePriceNull{get{return AtlasUtility.getMapValue(AtlasConstants.BuymorePriceNullValue);}set;}
    public integer intvalue{get{return integer.valueof(BuymorePriceNull);}set;}
    public  AtlasMainDTO mainDTOObj{get;set;}   
    public string atlasBuyMorePollerCount{get{return AtlasUtility.getMapValue(AtlasConstants.AtlasBuyMorePollerCount);}set;}
    public integer maxCount{get{return integer.valueof(atlasBuyMorePollerCount);}set;}
    public decimal thresholdGB;   
    public AtlasComponenttoController componentToPage{get; set;}
    
    /**
    * @author Shiva Shankar N
    * @description - Constructor for AtlasUsagePageBuyMoreController
    * @input param  - null
    * @return param null
    */  
    public AtlasUsagePageBuyMoreController()
    {   
        isVisibleExceptionMessage=false;
        isVisibleSuccessAlert=false;
        purchasedData='';
        styleClass=AtlasConstants.STYLE_CLASS_ENABLED;
        componentToPage = new AtlasComponenttoController();  
        componentToPage.PollerCount = 1; 
    }
    
    /**
    * @author Sujit Kumar
    * @description - addUsageQuotaForOneGB for AtlasUsagePageBuyMoreController
    * @input param  - null
    * @return param null
    */
    public PageReference addUsageQuotaForOneGB()
    { 
        componentToPage.requestedGB=1;
        thresholdGB=double.valueOf(mainDTOObj.cduDTOObj.threshold)/1024/1024/1024;
        componentToPage.oldGB = thresholdGB.setScale(1);
        componentToPage.newGB = componentToPage.oldGB + 1;
        return addUsageQuota(AtlasConstants.PURCHASED_DATA_1GB, AtlasConstants.buyMoreOneGB); 
    }
    /**
    * @author Sujit Kumar
    * @description - addUsageQuotaforTwoGB for AtlasUsagePageBuyMoreController
    * @input param  - null
    * @return param null
    */
    public PageReference addUsageQuotaforTwoGB()
    {  
        componentToPage.requestedGB=2;
        thresholdGB=double.valueOf(mainDTOObj.cduDTOObj.threshold)/1024/1024/1024;
        componentToPage.oldGB = thresholdGB.setScale(1);
        componentToPage.newGB = componentToPage.oldGB + 2;
        return addUsageQuota(AtlasConstants.PURCHASED_DATA_2GB, AtlasConstants.buyMoreTwoGB);
    }
    
    /**
    * @author Sujit Kumar
    * @description - addUsageQuotaForThreeGB for AtlasUsagePageBuyMoreController
    * @input param  - null
    * @return param null
    */
    public PageReference addUsageQuotaForThreeGB()
    {  
        componentToPage.requestedGB=3;
        thresholdGB=double.valueOf(mainDTOObj.cduDTOObj.threshold)/1024/1024/1024;
        componentToPage.oldGB = thresholdGB.setScale(1);
        componentToPage.newGB = componentToPage.oldGB + 3; 
        return addUsageQuota(AtlasConstants.PURCHASED_DATA_3GB, AtlasConstants.buyMoreThreeGB);
    }   
    
    /**
     * @author Sujit Kumar
     * @description - addUsageQuota for AtlasUsagePageBuyMoreController
     * @input param - purchasedDataMessage
     * @input param - buyMoreQuantity
     * @return param null
     */
    public PageReference addUsageQuota(String purchasedDataMessage, String buyMoreQuantity)
    {  
            try{    
                    componentToPage.UsageGBInCorrect=true;
                    mainDTOObj.cduDTOObj.refreshNow = true;
                    mainDTOObj.cduDTOObj.isPopulated = false;
                    AtlasDataDispatcher.addUsageQuota(mainDTOObj, buyMoreQuantity);
                    AtlasDatabaseManager.persistViewState(mainDTOObj);
                    purchasedData=purchasedDataMessage;
                    isVisibleSuccessAlert=true;
                    isVisibleExceptionMessage=false;
                    exceptionString='';
                    styleClass=AtlasConstants.STYLE_CLASS_DISABLED;
            }catch(AtlasException e)
            {
                purchasedData=' ';
                isVisibleSuccessAlert=false;
                isVisibleExceptionMessage=true;
                exceptionString=/*e.errorCode+' : '+ This code has been commented as per client requrirement */e.errorMessage;
                mainDTOObj.cduDTOObj.refreshNow = false;
                mainDTOObj.cduDTOObj.isPopulated = true;
                styleClass=AtlasConstants.STYLE_CLASS_ENABLED;
                return null;
            }
        return  null;
    }
    
    /**
    * @author Tejesh Kumar
    * @description - Action Poller method for Usage Refresh
    * @input param  - null
    * @return param null
    */
    public PageReference actionPoller()
    {                    
        componentToPage.PollerCount++;
        If(componentToPage.requestedGB!=null && (componentToPage.newGB != componentToPage.oldGB)) 
        {                                 
            try {
                if(!AtlasUtility.isEmpty(mainDTOObj.cduDTOObj.threshold)) {               	
					//mainDTOObj.cduDTOObj.refreshNow=true;
                    thresholdGB=double.valueOf(mainDTOObj.cduDTOObj.threshold)/1024/1024/1024;
                    componentToPage.oldGB = thresholdGB.setScale(1); 
                    componentToPage.UsageGBInCorrect=true;  
                } 
            }
            catch(exception e){
                system.debug('--exception in poller--> '+e.getmessage());
            }
        }
        else If(componentToPage.requestedGB!=null && (componentToPage.newGB == componentToPage.oldGB)){
            componentToPage.UsageGBInCorrect=false;
        }
        return null;
    } 
}