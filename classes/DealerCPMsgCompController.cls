public with sharing class DealerCPMsgCompController {
/*********************************************************************************
    Name         : DealerCPMsgCompController (Dealer Change Plan Message Component Controller)
    Created By   : Jim Tunney
    Company Name : ViaSat, Inc.
    Project      : Dealer Pages
    Created Date : 12 Oct 2015
    *********************************************************************************/
    
    /***** Note: all variables' values contained in the DealerKeyValueStore Custom Settings *****/
    public string custCarePhoneLabel {get {return DealerUtility.getMapValue(DealerConstants.CustCarePhone);} set;}
}