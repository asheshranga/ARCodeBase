public with sharing class DealerDisclosuresCompController {
    
    public DealerComponenttoController componentToPage{get; set;}
    
    public string disclosuresChkboxText {get {return DealerUtility.getMapValue(DealerConstants.DisclosuresChkboxText);} set;} //Displays text next to disclosures checkbox
    public string disclosuresPrintText {get {return DealerUtility.getMapValue(DealerConstants.DisclosuresPrintText);} set;} //Displays text for Print Disclosures hyperlink
    
    public DealerDisclosuresCompController() {
        componentToPage = new DealerComponenttoController();
    }

    
    public string textFromLegalDisclosures {
    	get {
    		StaticResource sr = [
    		select Body
    		from StaticResource
    		where Name = 'DealerLegalDisclosures' 
    		];
    	return sr.Body.toString();
    	}
    }
}