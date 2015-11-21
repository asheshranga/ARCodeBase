public with sharing class DealerCSCompController {
/*********************************************************************************
    Name         : DealerCSCompController (Dealer Customer Search Component Controller)
    Created By   : Jim Tunney
    Company Name : ViaSat, Inc.
    Project      : Dealer Pages  
    Created Date : 12 Oct 2015
    *********************************************************************************/
    
    /***** Note: all variables' values contained in the DealerKeyValueStore Custom Settings *****/
    public string acctNumLabel {get {return DealerUtility.getMapValue(DealerConstants.AccountNumber);} set;} //displays "Account Number"
    public string busNameLabel {get {return DealerUtility.getMapValue(DealerConstants.BusinessName);} set;} //displays "Business Name"
    public string buttonClearLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonClear);} set;} //displays "Clear"
    public string buttonSearchLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonSearch);} set;} //displays "Search"
    public string cityLabel {get {return DealerUtility.getMapValue(DealerConstants.City);} set;} //displays "City"
    public string dashSearchInstrLabel {get {return DealerUtility.getMapValue(DealerConstants.DashSearchInstruction);} set;} //displays instruction for completing search
    public string emailLabel {get {return DealerUtility.getMapValue(DealerConstants.EmailAddress);} set;} //displays "Email Address"
    public string firstNameLabel {get {return DealerUtility.getMapValue(DealerConstants.FirstName);} set;} //displays "First Name"
    public string lastNameLabel {get {return DealerUtility.getMapValue(DealerConstants.LastName);} set;} //displays "Last Name"
    public string macAddressLabel {get {return DealerUtility.getMapValue(DealerConstants.MACAddress);} set;} //displays "MAC Address"
    public string phoneNumLabel {get {return DealerUtility.getMapValue(DealerConstants.PhoneNumber);} set;} //displays "Phone Number"
    public string serNumLabel {get {return DealerUtility.getMapValue(DealerConstants.SerialNumber);} set;} //displays "Serial Number"
    public string stateLabel {get {return DealerUtility.getMapValue(DealerConstants.State);} set;} //displays "State"
    public string streetAddrLabel {get {return DealerUtility.getMapValue(DealerConstants.StreetAddress);} set;} //dipslays "Street Address"
    public string systemLabel {get {return DealerUtility.getMapValue(DealerConstants.SystemType);} set;} //displays "System"
    public string ticketNumLabel {get {return DealerUtility.getMapValue(DealerConstants.TicketNumber);} set;} //displays "Ticket Number"
    public string zipLabel {get {return DealerUtility.getMapValue(DealerConstants.Zip);} set;} //displays "Zip"
    
    //var and methods for state dropdown below
    public String[] states = new String[]{};
        
    public List<SelectOption> getStateList() {
        List<SelectOption> stateOptions = new List<SelectOption>();
        stateOptions.add(new SelectOption('default','select an option'));
        stateOptions.add(new SelectOption('AL','AL'));
        stateOptions.add(new SelectOption('AK','AK'));
        stateOptions.add(new SelectOption('AZ','AZ'));
        stateOptions.add(new SelectOption('CA','CA'));
        stateOptions.add(new SelectOption('CO','CO'));
        return stateOptions;
    }
    
    public String[] getStates() {
        return states;
    }
    
    public void setStates(String[] states) {
        this.states = states;
    }
    //var and methods for state dropdown above
    
    
    //var and methods for system dropdown below
    public String[] systems = new String[]{};
        
    public List<SelectOption> getSystemList() {
        List<SelectOption> systemOptions = new List<SelectOption>();
        systemOptions.add(new SelectOption('default','select an option'));
        systemOptions.add(new SelectOption('1st','System 1'));
        systemOptions.add(new SelectOption('2nd','System 2'));
        systemOptions.add(new SelectOption('3rd','System 3'));
        systemOptions.add(new SelectOption('4th','System 4'));
        return systemOptions;
    }
    
    public String[] getSystems() {
        return states;
    }
    
    public void setSystems(String[] systems) {
        this.systems = systems;
    }
    //var and methods for state dropdown above
}