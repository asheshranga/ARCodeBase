/*********************************************************************************
Name         : DealerCPSelectPlanController (Dealer Change Plan Select Plan Controller)
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 10/26/2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerCPSelectPlanController
*********************************************************************************/
public with sharing class DealerCPSelectPlanController extends AtlasDataManager {
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string availablePlansLabel {get {return DealerUtility.getMapValue(DealerConstants.AvailablePlans);} set;} //displays "Available Plans"(h4)
    public string buttonOrderNowLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonOrderNow);} set;} //displays "Order Now"
    public string cpSelectPlanAlertBoxHeader {get {return DealerUtility.getMapValue(DealerConstants.CPSelectPlanAlertBoxHeader);} set;} //displays header for blue alert box at bottom of page(h4)
    public string cpSelectPlanAlertBoxMsg1 {get {return DealerUtility.getMapValue(DealerConstants.CPSelectPlanAlertBoxMsg1);} set;} //displays 1st msg in blue alert box at bottom of page
    public string cpSelectPlanAlertBoxMsg2 {get {return DealerUtility.getMapValue(DealerConstants.CPSelectPlanAlertBoxMsg2);} set;} //displays 2nd msg in blue alert box at bottom of page
    public string cpSelectPlanMsgLabel {get {return DealerUtility.getMapValue(DealerConstants.CPSelectPlanMsg);} set;} //displays message that appears above plan selections
    public string GBLabel {get {return DealerUtility.getMapValue(DealerConstants.GB);} set;} //displays "GB"
    public string howFastLabel {get {return DealerUtility.getMapValue(DealerConstants.HowFast);} set;} //displays "How Fast"
    public string howMuchLabel {get {return DealerUtility.getMapValue(DealerConstants.HowMuch);} set;} //displays "How Much"
    public string myCurrentPlanLabel {get {return DealerUtility.getMapValue(DealerConstants.MyCurrentPlan);} set;} //displays "My Current Plan"(h4)
    public string plansLoading{get{return DealerUtility.getMapValue(DealerConstants.PlansLoading);}set;} //displays msg that plans are loading
    public string promotionsLabel{get{return DealerUtility.getMapValue(DealerConstants.Promotions);}set;} //displays "Promotions"
    public string selectNewPlanLabel {get {return DealerUtility.getMapValue(DealerConstants.SelectNewPlan);} set;} //displays "Select a New Plan"(h1)
    
    // Initializing the Change Plan DTO object   
    public DealerChangePlanDTO changePlanDTOObj{get;set;}
    //public AtlasChangePlanDTO changePlanDTOObj{get;set;}//for testing only
    
    public string selectedPlanName{get;set;}
    
    // Initializing Main DTO 
    public DealerMainDTO mainDTO{get;set;}
    
    // Initializing Account DTO    
    public AtlasAccountDTO accountDTO{get;set;} 
    
    public  AtlasPlan__c myPlan{get{
        String serviceLevel;
        if(!Test.isRunningTest())
            serviceLevel=accountDTO.serviceLevel;
        else
            serviceLevel='FREEDOM';
        //query to return plan attributes from Atlas Plan object
        List<AtlasPlan__c> myPlanList = [SELECT datacapgb__c, downloadspeed__c, downloadspeedunit__c, freezonetype__c, bonusfeature1__c, bonusfeature2__c, bonusfeature3__c,BonusFeature4__c,BonusFeature5__c
        FROM AtlasPlan__c
        WHERE PlanAPIName__c =: serviceLevel LIMIT 1]; 
        system.debug('--myPlanList --> '+myPlanList );
        if(myPlanList.size()>0)
            return myPlanList[0]; 
        else
            return null;
    }  
    set;} 
    
    public integer intDataCap{get {
        decimal d = Decimal.valueOf(myDataCapacity);
        return d.intValue();
     } set;} 
    
    public string myDataCapacity{get {
        if(myPlan!=null) {
            return myPlan.DataCapGB__c;
        }
        else
            return null;
    } set;} 
    
    public string myDownloadSpeed{get {     
        if(myPlan!=null)
            return myPlan.DownloadSpeed__c;
        else
            return null;    
    } set;}  
    
    public List<AtlasPlanAttributes__c> myBonusFeatures{get {
        return null;
    }set;} 
        
    /**TBD if used for Dealer Portal
       public List<String> mybfList{get {
        List<string> dummyList = new List<string>();
        Set<string> bonusFeatSet= new Set<string>();
        List<String> bfList=new List<String>();
        if(myPlan!=null) {                       
            Map<String,String> bonusFeaturesMap = new Map<String,String>(); 
            List<AtlasPlanAttributes__c> apaList = [select AttributeValue__c, SelfcareText__c from AtlasPlanAttributes__c];
            for(AtlasPlanAttributes__c apa : apaList){
                bonusFeaturesMap.put(apa.AttributeValue__c,apa.SelfcareText__c);
            }
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature1__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature1__c));      
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature2__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature2__c)); 
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature3__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature3__c)); 
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature4__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature4__c)); 
            if(!AtlasUtility.isEmpty(myPlan.bonusfeature5__c)) bonusFeatSet.add(bonusFeaturesMap.get(myPlan.bonusfeature5__c)); 
            
            bfList.addAll(bonusFeatSet);  
            system.debug('---bfList---> '+bfList);
            
            return bfList;
        }       
        else
            return null;    
    }set;}   */  
    
    /**
    * @author Jim Tunney
    * @description - Method for first component's 'Order Now' button. Sets booleans so that the second component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference orderNow(){
        componentToPage.clickedStep = 1;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = true;
        componentToPage.CPStep2 = false;
        return null;
    }
}