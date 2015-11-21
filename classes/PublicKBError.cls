/*
    Controller for the Error page
        
    **********************************************************
    Audit History
    **********************************************************
    5/14/2013    Lucian Ciobanu      Created
    **********************************************************  
*/
public with sharing class PublicKBError {

	public string trackingNumber { get; set; }
	
	// Extracts the error message, combines it with the tracking number and returns it to be displayed
	public string ErrorToDisplay {
		get {
			trackingNumber = ApexPages.currentPage().getParameters().get('trackingNumber');
			string errorMessage = KeyValueStoreHelper.getTextValue('GenericErrorMessageExt');
			return errorMessage.replace('{Tracking Number}', trackingNumber);
		}
	}

}