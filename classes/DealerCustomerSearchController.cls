/*********************************************************************************
Name         : DealerCustomerSearchController
Created By   : Srikanth Kudumula
Created Date : 10/29/2015
Project      : Dealer Portal 
Usages       :Class for Dealer Customer Search
Change Log   :
<Date>      <Modified By>   <Change Description>
*********************************************************************************/
public with sharing class DealerCustomerSearchController extends DealerDataManagerAsync{
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
	public string phoneNumber{get;set;}//variable to hold phone number
	public string emailAddress{get;set;}//variable to hold email address
	public string systemval{get;set;}//variable to hold system value
	public string firstName{get;set;}//variable to hold first name
	public string lastName{get;set;}//variable to hold last name
	public string accountNumber{get;set;}//variable to hold account number
	public string streetAddress{get;set;}//variable to hold street address
	public string city{get;set;}//variable to hold city
	public string businessName{get;set;}//variable to hold business name
	public string state{get;set;}//variable to hold state
	public string Zip{get;set;}//variable to hold zip
	public string serialNumber{get;set;}//variable to hold serial number
	public string MACAddress{get;set;}//variable to hold MAC address
	public string ticketNumber{get;set;}//variable to hold ticket number
	public boolean reqFieldsMissing{get;set;}//varible to show fields required error message
	public boolean resultsfound{get;set;}//varible to display results
	public list<usrList> results{get;set;}//list to hold the response
	public Integer offset { get; set; }//variable used for pagination
    public DealerSearchDTO mdto;
    public DealerMainDTO mainDTO{get;set;}
    public string selectedAccount{get;set;}
    public DealerCustomerInfoDTO selectedcusInfoDTO{get;set;}
    public boolean searchSection{get;set;}//boolean variable to display search section
    public boolean displayDashboard{get;set;}

	
	public List<SelectOption> getsystemList(){
		List<SelectOption> options=new List<SelectOption>();
		options.add(new SelectOption('select an option','select an option'));             
		DealerKeyValueStore__c DealerKVS = DealerKeyValueStore__c.getValues('SystemValue');
		String vals = DealerKVS.Value__c;
		String[] sArray = vals.split(';');
		system.debug('---sArray---> '+sArray);
		for(String str:sArray){
		    options.add(new SelectOption(str,str));
		}             
		return options;
	}
	
    public List<SelectOption> getstateList(){
		List<SelectOption> options=new List<SelectOption>();
		options.add(new SelectOption('select an option','select an option'));             
		DealerKeyValueStore__c DealerKVS = DealerKeyValueStore__c.getValues('States');
		String vals = DealerKVS.Value__c;
		String[] sArray = vals.split(';');
		system.debug('---sArray---> '+sArray);
		for(String str:sArray){
		    options.add(new SelectOption(str,str));
		}             
		return options;
	}

	
	public class usrList{
		public string accountNumber{get;set;}
		public string device{get;set;}
		public string agreeNumber{get;set;}
		public string status{get;set;}
		public string partAccount{get;set;}
		public string phone{get;set;}
		public string firstName{get;set;}
		public string lastName{get;set;}
		public string businessName{get;set;}
		public string address{get;set;}
		public string salesChannel{get;set;}	
	}
	
	//constructor
	public DealerCustomerSearchController(){
		searchSection = true;
		reqFieldsMissing = false;
		resultsfound = false;
		displayDashboard = false;
        mdto = null;
        offset = 0;
	}
	
	//Method for search
	public void search(){
		results = new list<usrList>();
		mainDTO = new DealerMainDTO();
		mainDTO.cusInfoDTOList  = new list<DealerCustomerInfoDTO>();
		if(!AtlasUtility.isEmpty(firstName) || !AtlasUtility.isEmpty(lastName))
		{
			if(atlasUtility.isEmpty(firstName) || AtlasUtility.isEmpty(lastName)){
				reqFieldsMissing = true;
			}
		}
		
		if(!AtlasUtility.isEmpty(streetAddress) || !AtlasUtility.isEmpty(city) || !AtlasUtility.isEmpty(state) || !AtlasUtility.isEmpty(Zip))
		{
			if((AtlasUtility.isEmpty(streetAddress) || AtlasUtility.isEmpty(city) || AtlasUtility.isEmpty(state) || AtlasUtility.isEmpty(Zip)) && state != 'select an option')
			{
				reqFieldsMissing = true;
			}
		}
		
		if(!AtlasUtility.isEmpty(accountNumber))
		{
			if(AtlasUtility.isEmpty(systemval) || systemval == 'select an option')
			{
				reqFieldsMissing = true;
			}
		}
		try{
			map<String,String> mapList = new Map<String,String>();
            mdto = new DealerSearchDTO();
            if(!AtlasUtility.isEmpty(accountNumber) || !AtlasUtility.isEmpty(firstName) || !AtlasUtility.isEmpty(lastName))
            {
                mdto.internalReference = accountNumber;
                mdto.internalReferenceType = 'ACCOUNT';
                mdto.firstName = firstName;
                mdto.lastName = lastName;
                mdto.emailAddress = emailAddress;
                mdto.maxresults = '10';
                // TO DO List Need to change the callout
                mapList = AtlasIntegrationUtility.findSubscriberBySearchCriteriaV2(mdto);
                system.debug('@@@ map list --->'+mapList);
                // TO DO List need to run a for loop on results
                DealerCustomerInfoDTO cus = new DealerCustomerInfoDTO();
                usrList u = new usrList();
                mainDTO.externalAccountReference = mapList.get('externalAccountReference');
                mainDTO.externalSystemName = mapList.get('externalSystemName');
                cus.accountNumber = mapList.get('internalAccountReference');
                cus.device = mapList.get('internalAccountReference');
                cus.agreement = mapList.get('internalServiceAgreementReference');
                cus.status = mapList.get('provisioningStatus');
                cus.partAccount = mapList.get('partnerName');
                cus.emailAddress = mapList.get('emailAddress');
                cus.primaryPhone = mapList.get('primaryPhoneNumber');
                if (mapList.containsKey('firstName'))
                	cus.firstName = mapList.get('firstName');
                if (mapList.containsKey('lastName'))
                	cus.lastName = mapList.get('lastName');
                if (mapList.containsKey('businessName'))                      
                	cus.businessName=mapList.get('businessName');
                if (mapList.containsKey('addressLine'))
                	cus.street1=mapList.get('addressLine');
                if (mapList.containsKey('municipality'))
                    cus.city = mapList.get('municipality');
                if (mapList.containsKey('region'))
                    cus.state = mapList.get('region');
                if (mapList.containsKey('postalCode'))
                    cus.zip = mapList.get('postalCode');
                cus.MACAddress = mapList.get('macAddress');
                u.accountNumber = mapList.get('internalAccountReference');
                u.status = mapList.get('provisioningStatus');
                u.device = mapList.get('deviceProtocol');
                u.agreeNumber = mapList.get('internalServiceAgreementReference');
                u.partAccount = mapList.get('externalSystemName');
                mainDTO.cusInfoDTOList.add(cus);
            }
		}
		catch(exception e){
			
		}
		if(mainDTO.cusInfoDTOList.size()>0)
			resultsfound = true;
	}
	
	//Method to display Dashboard Page
	public pageReference displayDashboard(){
		mainDTO.cusInfoDTO = new DealerCustomerInfoDTO();
		searchSection = false;
		reqFieldsMissing = false;
		resultsfound = false;
		for(DealerCustomerInfoDTO cus : mainDTO.cusInfoDTOList){
			if(cus.accountNumber == selectedAccount)
				mainDTO.cusInfoDTO = cus;
		}
		getAllAccountServices();
		if(!AtlasUtility.isEmpty(mainDTO.accServDTO))
			displayDashboard = true;
		return null;
	}
	
	//Method for Clear button
	public pagereference clear(){
		system.debug('I am in Clear');
		reqFieldsMissing = false;
		phoneNumber='';
		firstName='';
		this.emailAddress='';
		return null;
	}
   //method for Next button 
   public void nextPage() {
       offset = Math.min(offset + 5, results.size() - 5);
   }
   //method for previous button
   public void previousPage() {
       offset = Math.max(0, offset - 5);
   }
   //method for last button
   public void lastPage() {
       offset = results.size() - 5;
   }
   //method for first button 
   public void firstPage() {
       offset = 0;
   }
   
   //method for call All Account Services
   public void getAllAccountServices(){
   		getAllAccountServices(mainDTO);
   }
}