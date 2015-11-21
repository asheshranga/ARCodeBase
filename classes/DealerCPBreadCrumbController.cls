/*********************************************************************************
Name         : DealerCPBreadCrumbController (Dealer Change Plan Bread Crumb Component Controller)
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 21 Oct 2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerCPBreadCrumbComponent
*********************************************************************************/  
public with sharing class DealerCPBreadCrumbController {    
    public DealerComponenttoController componentToPage{get; set;}
    
    /***** Note: values contained in the DealerKeyValueStore Custom Settings *****/
    public string installLabel {get {return DealerUtility.getMapValue(DealerConstants.Installation);} set;} 
    public string plansLabel {get {return DealerUtility.getMapValue(DealerConstants.Plans);} set;}
    public string planOptionsLabel {get {return DealerUtility.getMapValue(DealerConstants.PlanOptions);} set;} 
   
   /**
     * @author Jim Tunney
     * @description - Getter for the integer clickedStep (declared in class DealerComponenttoController)
     * @input param  - none
     * @return componentToPage.clickedStep - integer
    */ 
   public integer getClickedStep(){
        return componentToPage.clickedStep;
    }
    
    //list to hold the String values for the breadcrumbs
    public List<String> bcList = new List<String>();
    
    /**
     * @author Jim Tunney
     * @description - Creates a List containing the breadcrumb Strings from the comma-separated list 'BreadCrumbChange' in the DealerKeyValueStore Custom Setting
     * @input param  - none
     * @return bcList - List of Strings
    */ 
    public List<String> getBCList(){
        bcList.clear();
        String s = DealerUtility.getMapValue('BreadCrumbChange');
        String[] sList = s.split(',');
        
        for(integer i = 0; i < sList.size(); i++){
            bcList.add(sList[i]);
        }
        
        return bcList;
    }
    
    /**
    * @author Jim Tunney
    * @description - Sets booleans so that the first step (Plans) component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference step0(){
        componentToPage.clickedStep = 0;
        componentToPage.CPStep0 = true;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = false;
        
        return null; 
    }
    
    /**
    * @author Jim Tunney
    * @description - Sets booleans so that the second step (Plan Options) component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference step1(){
        componentToPage.clickedStep = 1;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = true;
        componentToPage.CPStep2 = false;
         
        return null;
    }
    
    /**
    * @author Jim Tunney
    * @description - Sets booleans so that the third step (Confirmation) component is visible.
    * @input param  - none
    * @return null
    */ 
    public pageReference step2(){
        componentToPage.clickedStep = 2;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = true;
        
        return null;
    }
    
    /**
    * @author Jim Tunney
    * @description - Not used (as of 10/28/15); anticipated future use
    * @input param  - none
    * @return null
    */ 
    public pageReference step4(){
        componentToPage.clickedStep = 3;
        componentToPage.CPStep0 = false;
        componentToPage.CPStep1 = false;
        componentToPage.CPStep2 = true;
        
        return null;
    }
    
}