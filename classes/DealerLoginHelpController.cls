/*********************************************************************************
Name         : DealerLoginHelpController
Created By   : Srikanth Kudumula
Modified BY  : 
Company Name : NTT Data
Project      : Dealer Portal
Created Date : 10/19/2015
Modified Date: 
Usages       : Controller for VisualForce Page: DealerLoginHelpPage
*********************************************************************************/
public with sharing class DealerLoginHelpController {
	public DealerComponenttoController componentToPage {get; private set;}//Apex class is used to find the steps(1,2,3,4..)

	 /**
    * @author Srikanth Kudumula
    * @description - Constructor for DealerLoginHelpController
    * @input param  - null
    * @return null
    */ 
    public DealerLoginHelpController()
    {
        //This code has been written for IE8 Browser Compatibility Issues. 
        Apexpages.currentPage().getHeaders().put(AtlasConstants.X_UA_COMPATIBLE,AtlasConstants.IE_8);
        componentToPage = new DealerComponenttoController();
        componentToPage.LHStep1=true;
        componentToPage.LHStep2=false;
        componentToPage.LHStep3=false;
        componentToPage.LHStep4=false;
        
    }
   
}