/********************************************************************************************************
Name         : DealerLongBreadCrumbController 
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 27 Oct 2015
Modified Date: 
Usages       : Controller for VisualForce Component: DealerLongBreadCrumbComponent (New Orders and Moves)
*********************************************************************************************************/  
public with sharing class DealerLongBreadCrumbController {
    
    public DealerComponenttoController componentToPage{get; set;}
    
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
     * @description - getter for bcList. Clears list first to avoid concatenating the list with itself on each rendering of the breadcrumb component.
     * @input param  - none
     * @return bcList - List of Strings containing the breadcrumbs
    */ 
    public List<String> getBCList(){
        bcList.clear();
        String s = DealerUtility.getMapValue('BreadCrumbOrder');
        String[] sList = s.split(',');
        
        for(integer i = 0; i < sList.size(); i++){
            bcList.add(sList[i]);
        }
        
        return bcList;
    }
    
     /**
     * @author Jim Tunney
     * @description - Uses zero-based indexing. Toggles booleans to display corresponding component and hide the rest.
     * @input param  - none
     * @return null
    */ 
     public pageReference step0(){
        componentToPage.clickedStep = 0;
        componentToPage.OrderStep0 = true;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        
        return null; 
    }
    
     //same as step0 above
     public pageReference step1(){
        componentToPage.clickedStep = 1;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = true;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
         
        return null;
    }
    
    //same as step0 above
    public pageReference step2(){
        componentToPage.clickedStep = 2;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = true;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        
        return null;
    }
    
    //same as step0 above
    public pageReference step3(){
        componentToPage.clickedStep = 3;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = true;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        
        return null;
    }

    //same as step0 above   
    public pageReference step4(){
        componentToPage.clickedStep = 4;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = true;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        
        return null;
    }
    
    //same as step0 above
    public pageReference step5(){
        componentToPage.clickedStep = 5;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = true;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = false;
        
        return null;
    }
    
    //same as step0 above
    public pageReference step6(){
        componentToPage.clickedStep = 6;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = true;
        componentToPage.OrderStep7 = false;
        
        return null;
    }
    
    //same as step0 above
    public pageReference step7(){
        componentToPage.clickedStep = 7;
        componentToPage.OrderStep0 = false;
        componentToPage.OrderStep1 = false;
        componentToPage.OrderStep2 = false;
        componentToPage.OrderStep3 = false;
        componentToPage.OrderStep4 = false;
        componentToPage.OrderStep5 = false;
        componentToPage.OrderStep6 = false;
        componentToPage.OrderStep7 = true;
        
        return null;
    }
}