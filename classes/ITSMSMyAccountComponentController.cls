/*************************************************************************************************
 * Class ITSMSMyAccountComponentController
 * 
 * @version 1.0
 * @author  Dianna Guilinger - Slalom  
 *
 *  Usage: included in ITSMSMyAccountComponent for the ITSMSSupportCenterTemplate
 *  Description:  allows the Delegate lookup field from the logged in User record to be referenced.
 **************************************************************************************************
 */

public with sharing class ITSMSMyAccountComponentController {
    public User NewDelegate {get;set;}
    public Boolean ActivePanel {get;set;}
    public String DelegateText {get;set;}
    
    //Query current user delegate lookup field, toggle & delegate text initializers
    public ITSMSMyAccountComponentController () {
        Id CurrUser = UserInfo.getUserId();
        NewDelegate = ITSMSUtilityClass.getUser(CurrUser);
        UpdateDelegateText();
        ActivePanel = true;
    }
    
    //Toggle active panel value
    public void ToggleAccountPanels () {
        ActivePanel = !ActivePanel; 
    }
    
    //Save Button, Update record & Toggle. Conflict with two actions on commandButton
    public void SaveAndToggle () {
        boolean isUpdated = ITSMSUtilityClass.updateDelegate(NewDelegate);
        UpdateDelegateText();       
        ToggleAccountPanels();
    }
    
    //Set Delegate Text
    private void UpdateDelegateText () {
        if (NewDelegate.Delegate__c == null) {
            DelegateText = '--None--';
        } else {
        
            //Grab Names from related record for Delegate Text content
            User ExistingDelegate = ITSMSUtilityClass.getUser(NewDelegate.Delegate__c);
            DelegateText = ExistingDelegate.FirstName + ' ' + ExistingDelegate.LastName;
        }
    }
}