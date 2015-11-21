public class WispCustomerInfoPasswordController extends AtlasDataManager{
    public string editPWDTEXT{get{return Atlasconstants.EDIT_PWD;}set;}
    public string exceptionString{get;set;}
    public boolean isVisibleExceptionMessage{get;set;}
    public boolean isVisibleSuccessAlert{get;set;}
    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}
    public string PWD{get{return Atlasconstants.PWD;}set;}
    public string rePWD{get{return Atlasconstants.RE_PWD_LABEL;}set;}
    public string oldpassword{get;set;}
    public string oldpasswordReq{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_OPWD_REQ_TEXT);}set;}
    public string password{get;set;}
    public string weak{get{return Atlasconstants.WEAK;}set;}
    public string good{get{return Atlasconstants.GOOD;}set;}
    public string strong{get{return Atlasconstants.STRONG;}set;}
    public string strInvalidPwd{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_PWD_VALIDATION_MSG);}set;}
    public string confirmPwd{get;set;}
    public string cpwdReqd{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_CPWD_REQD);}set;}
    public String exceptionDivStyle{get;set;}
    public string pswdHelpText {get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_PSWD_HELP_TEXT);}set;}
    public string pwdReqd{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_PWD_REQD);}set;}
    public String profileId {get;set;}
    
    public WispCustomerInfoPasswordController(){
        isVisibleExceptionMessage = false;
        isVisibleSuccessAlert = false;
        //populateWispDashboardData();
		//system.debug('---------'+mainDTOObj);
    }
    
     /**
    * @author Srikanth Kudumula
    * @description - savePasswordfor WispCustomerInformationPasswordController
    * @input param  - null
    * @return param null
    */ 
    public PageReference savePassword()
    {    
        try{    
        	populateWispDashboardData();
			system.debug('---------'+mainDTOObj);
            if(AtlasUtility.isEmpty(oldpassword) || AtlasUtility.isEmpty(password) || AtlasUtility.isEmpty(confirmPwd)){
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert = false;
                exceptionString = 'Please fill up required fields.';
                return null;
            }else if(confirmPwd != password){
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert = false;
                exceptionString = 'Password are not matching.';
                return null;
            }else if(password.length() < 8){
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert = false;
                exceptionString = 'Password is invalid.';
                return null;
            }
                                       
            AtlasSSOWS.changePasswordResponse_element resp = AtlasIntegrationUtility.changePassword(mainDTOObj.federationId,oldpassword,password);
            system.debug('--- password response ---' + resp);
            if(mainDTOObj.federationId == resp.loginusername){
            	exceptionString = '';
                isVisibleSuccessAlert=true;
                isVisibleExceptionMessage = false;
            }else{
                isVisibleExceptionMessage = true;
                isVisibleSuccessAlert=false;
                exceptionString = 'Authentication Failed';
                exceptionDivStyle=''; 
                return null;
            }                
            //system.debug('--------pwd--------------' + strUsername );
        }catch(AtlasException e)
        {
            system.debug('saveCustomerInfo catch: ' + e.errorMessage);
            isVisibleExceptionMessage=true;
            isVisibleSuccessAlert=false;
            exceptionString = e.errorMessage ;
            exceptionDivStyle='';                   
        }            
        PageReference page = new PageReference('/'+atlasconstants.STRCUSTOMER_INFO);
        page.setRedirect(false);
        return  null;               
    }
    
    /**
    * @author Srikanth Kudumula
    * @description - cancelException for WispCustomerInfoPasswordController
    * @input param  - null
    * @return param null
    */     
    public PageReference cancelException()
    {
        isVisibleExceptionMessage = false;
        isVisibleSuccessAlert=false;
        
        string url = '/apex/subscriber_dashboard?firstTime=false&Id=' + profileId; 
		string siteURl =site.getBaseUrl();
		if(!AtlasUtility.IsEmpty(siteURl)) {              
			PageReference page = new PageReference(siteURl+'/subscriber_dashboard');
			page.setRedirect(true);
			return page;
		}
		else {
			PageReference page1 = new PageReference(url);
			page1.setRedirect(true);
			return page1;    
		}
    }
    
}