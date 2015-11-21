public with sharing class DealerCPProgBarController {
/*********************************************************************************
    Name         : DealerCPProgBarController (Dealer Change Plan Progress Bar Component Controller)
    Created By   : Jim Tunney
    Company Name : ViaSat, Inc.
    Project      : Dealer Pages
    Created Date : 21 Oct 2015
    *********************************************************************************/	
    
    
    /***** Note: all variables' values contained in the DealerKeyValueStore Custom Settings *****/
    //public string bcChgLabel {get {return DealerUtility.getMapValue(DealerConstants.BreadCrumbChange);} set;} //comma-separated list containing names of bread crumb steps
    public string installLabel {get {return DealerUtility.getMapValue(DealerConstants.Installation);} set;} 
    public string plansLabel {get {return DealerUtility.getMapValue(DealerConstants.Plans);} set;}
    public string planOptionsLabel {get {return DealerUtility.getMapValue(DealerConstants.PlanOptions);} set;} 

    
    public string bcChgSize {get {return DealerUtility.getMapValue(DealerConstants.BreadCrumbChgSize);} set;}
    //public List<String> bcList = new String[Integer.valueOf(bcChgSize)];
    
    
    
    
    
    public integer clickedStep = 2;
    
    public integer getClickedStep() {
        return clickedStep;
    }
    
    public List<String> bcList = new List<String>();
    
    public List<String> getBCList() {
        String s = DealerUtility.getMapValue('BreadCrumbChange');
        String[] sList = s.split(',');
        
        for(integer i = 0; i < sList.size(); i++){
            bcList.add(sList[i]);
        }
        
        return bcList;
    }
    
    
    
    
    
}