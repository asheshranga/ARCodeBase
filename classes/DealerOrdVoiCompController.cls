public with sharing class DealerOrdVoiCompController {
/*********************************************************************************
    Name         : DealerOrdVoiCompController (Dealer Order Voice Component Controller)
    Created By   : Jim Tunney
    Company Name : ViaSat, Inc.
    Project      : Dealer Pages
    Created Date : 14 Oct 2015
    *********************************************************************************/
    
    /***** Note: all variables' values contained in the DealerKeyValueStore Custom Settings *****/
    public string areaCodeLabel{get {return DealerUtility.getMapValue(Dealerconstants.AreaCode);} set;} //displays "Area Code (Region)"   
    public string callIDChkbxLabel {get {return DealerUtility.getMapValue(DealerConstants.VoiceCallerIDCheckbox);} set;} //displays text for Caller ID checkbox    
    public string chooseNumLabel{get {return DealerUtility.getMapValue(Dealerconstants.ChooseANumber);} set;} //displays "Choose A Number"
    public string chooseStateLabel{get {return DealerUtility.getMapValue(Dealerconstants.ChooseState);} set;} //displays "Choose State"
    public string chooseStateHelpBlockLabel{get {return DealerUtility.getMapValue(Dealerconstants.VoiceChooseStateHelpBlock);} set;} //displays label for Choose State Help Block    
    public string confPWLabel{get {return DealerUtility.getMapValue(DealerConstants.ConfirmPassword);} set;} //displays "Confirm Password"
    public string cityLabel{get {return DealerUtility.getMapValue(Dealerconstants.City);} set;} //displays "City"    
    public string dirListChkbxLabel {get {return DealerUtility.getMapValue(DealerConstants.VoiceDirectoryListCheckbox);} set;} //displays text for Directory Listing checkbox        
    public string firstNameLabel {get {return DealerUtility.getMapValue(DealerConstants.FirstName);} set;} //displays "First Name"
    public string lastNameLabel {get {return DealerUtility.getMapValue(DealerConstants.LastName);} set;} //displays "Last Name"    
    public string leftButtonLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonBack);} set;} //displays text for left button ("Back")    
    public string optionalLabel{get {return DealerUtility.getMapValue(DealerConstants.Optional);} set;} //displays "Optional"  
    public string phoneEligToolLabel{get {return DealerUtility.getMapValue(DealerConstants.VoicePhoneNumEligibilityLink);} set;} //displays "Password"    
    public string pwLabel{get {return DealerUtility.getMapValue(DealerConstants.Password);} set;} //displays "Password"
    public string pwHelpBlockLabel{get {return DealerUtility.getMapValue(DealerConstants.VoicePasswordHelpBlock);} set;} //displays label for Password Help Block    
    public string preDirLabel{get {return DealerUtility.getMapValue(DealerConstants.PreDirectory);} set;} //displays "Pre-Dir"    
    public string rateCentLabel{get {return DealerUtility.getMapValue(DealerConstants.RateCenter);} set;} //displays "Rate Center"
   // public string rightButtonLabel {get {return DealerUtility.getMapValue(DealerConstants.ButtonOrderVoiceRt);} set;} //displays text for right button     
    public string stateLabel{get {return DealerUtility.getMapValue(Dealerconstants.State);} set;} //displays "State"    
    public string streetNameLabel{get {return DealerUtility.getMapValue(DealerConstants.StreetName);} set;} //displays "Street Name"    
    public string streetNumLabel{get {return DealerUtility.getMapValue(DealerConstants.StreetNumber);} set;} //displays "Street Number"
    public string suffixLabel{get {return DealerUtility.getMapValue(DealerConstants.Suffix);} set;} //displays "Suffix"
    public string typeLabel{get {return DealerUtility.getMapValue(Dealerconstants.Type);} set;} //displays "Type"    
    public string unitNumLabel{get {return DealerUtility.getMapValue(DealerConstants.UnitNumber);} set;} //displays "Unit Number"        
    public string unitTypeLabel{get {return DealerUtility.getMapValue(DealerConstants.UnitType);} set;} //displays "Unit Type"  
    public string usernameLabel{get {return DealerUtility.getMapValue(DealerConstants.Username);} set;} //displays "Username"    
    public string whatIsRCLabel {get {return DealerUtility.getMapValue(DealerConstants.VoiceRateCenterHelpBlock);} set;} //displays label for Rate Center Help Block 
    public string zipLabel{get {return DealerUtility.getMapValue(Dealerconstants.Zip);} set;} //displays "Zip"
    
    
    //**********var and methods for state dropdown below
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
    //*****var and methods for state dropdown above
    
    
    //**********var and methods for Area Code(Region) dropdown below
    public String[] regions = new String[]{};
    
    public List<SelectOption> getRegionList() {
        List<SelectOption> regionOptions = new List<SelectOption>();
        regionOptions.add(new SelectOption('default','select an option'));
        regionOptions.add(new SelectOption('1st','Region 1'));
        regionOptions.add(new SelectOption('2nd','Region 2'));
        /** regionOptions.add(new SelectOption('AZ','AZ'));
        regionOptions.add(new SelectOption('CA','CA'));
        regionOptions.add(new SelectOption('CO','CO')); */
        return regionOptions;
    }
    
    public String[] getRegions() {
        return regions;
    }
    
    public void setRegions(String[] regions) {
        this.regions = regions;
    }
    //*****var and methods for Area Code(Region) dropdown above
    
    
    //**********var and methods for Rate Center dropdown below
    public String[] rateCenters = new String[]{};
    
    public List<SelectOption> getRCList() {
        List<SelectOption> rcOptions = new List<SelectOption>();
        rcOptions.add(new SelectOption('default','select an option'));
        rcOptions.add(new SelectOption('1st','RC 1'));
        rcOptions.add(new SelectOption('2nd','RC 2'));
        /** rcOptions.add(new SelectOption('AZ','AZ'));
        rcOptions.add(new SelectOption('CA','CA'));
        rcOptions.add(new SelectOption('CO','CO')); */
        return rcOptions;
    }
    
    public String[] getRateCenters() {
        return rateCenters;
    }
    
    public void setRateCenters(String[] rateCenters) {
        this.rateCenters = rateCenters;
    }
    //*****var and methods for Rate Center dropdown above
    
    
    //**********var and methods for Choose A Number dropdown below
    public String[] numbers = new String[]{};
    
    public List<SelectOption> getNumberList() {
        List<SelectOption> numberOptions = new List<SelectOption>();
        numberOptions.add(new SelectOption('default','select an option'));
        numberOptions.add(new SelectOption('1st','Number 1'));
        numberOptions.add(new SelectOption('2nd','Number 2'));
        /** numberOptions.add(new SelectOption('AZ','AZ'));
        numberOptions.add(new SelectOption('CA','CA'));
        numberOptions.add(new SelectOption('CO','CO')); */
        return numberOptions;
    }
    
    public String[] getNumbers() {
        return numbers;
    }
    
    public void setNumbers(String[] numbers) {
        this.numbers = numbers;
    }
    //*****var and methods for Choose A Number dropdown above
    
    
    //**********var and methods for Pre-Dir dropdown below
    public String[] preDir = new String[]{};
    
    public List<SelectOption> getPreDirList() {
        List<SelectOption> preDirOptions = new List<SelectOption>();
        preDirOptions.add(new SelectOption('default','select an option'));
        preDirOptions.add(new SelectOption('1st','Pre-Dir 1'));
        preDirOptions.add(new SelectOption('2nd','Pre-Dir 2'));
        /** preDirOptions.add(new SelectOption('AZ','AZ'));
        preDirOptions.add(new SelectOption('CA','CA'));
        preDirOptions.add(new SelectOption('CO','CO')); */
        return preDirOptions;
    }
    
    public String[] getPreDir() {
        return preDir;
    }
    
    public void setPreDir(String[] preDir) {
        this.preDir = preDir;
    }
    //*****var and methods for Pre-Dir dropdown above
    
    
    //**********var and methods for Unit Type dropdown below
    public String[] unitTypes = new String[]{};
    
    public List<SelectOption> getUnitTypeList() {
        List<SelectOption> unitTypeOptions = new List<SelectOption>();
        unitTypeOptions.add(new SelectOption('default','select an option'));
        unitTypeOptions.add(new SelectOption('1st','Unit Type 1'));
        unitTypeOptions.add(new SelectOption('2nd','Unit Type 2'));
        /** unitTypeOptions.add(new SelectOption('AZ','AZ'));
        unitTypeOptions.add(new SelectOption('CA','CA'));
        unitTypeOptions.add(new SelectOption('CO','CO')); */
        return unitTypeOptions;
    }
    
    public String[] getUnitTypes() {
        return unitTypes;
    }
    
    public void setUnitTypes(String[] unitTypes) {
        this.unitTypes = unitTypes;
    }
    //*****var and methods for Unit Type dropdown above
    
    
    //**********var and methods for Type (Directory Listing) dropdown below
    public String[] types = new String[]{};
    
    public List<SelectOption> getTypesList() {
        List<SelectOption> typeOptions = new List<SelectOption>();
        typeOptions.add(new SelectOption('default','select an option'));
        typeOptions.add(new SelectOption('1st','Type 1'));
        typeOptions.add(new SelectOption('2nd','Type 2'));
        /** typeOptions.add(new SelectOption('AZ','AZ'));
        typeOptions.add(new SelectOption('CA','CA'));
        typeOptions.add(new SelectOption('CO','CO')); */
        return typeOptions;
    }
    
    public String[] getTypes() {
        return types;
    }
    
    public void setTypes(String[] types) {
        this.types = types;
    }
    //*****var and methods for Type (Directory Listing) dropdown above
}