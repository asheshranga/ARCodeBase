global class WispCustomerInfoUsernameController extends AtlasDataManager{
    public string uNameText{get{return Atlasconstants.UserNameLabel;}set;}
    public boolean isVisibleExceptionMessage{get;set;}
    public boolean isVisibleSuccessAlert{get;set;}
    public string exceptionString{get;set;}
    public string uNameLimit{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_NEW_USER_UNAME_VALIDATION);}set;}
    public string validemail{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_PLS_EMAIL_VALID);}set;}
    public string unamereqd{get{return AtlasUtility.getMapWispValue(Atlasconstants.WISP_LOGIN_UNAME_REQD);}set;}
    public string loginPblmText{get{return Atlasconstants.LOGIN_PROBLEM_TEXT;}set;}
    public string WispUnameHelpText{get{return AtlasUtility.getMapWispValue(AtlasConstants.Wisp_UNAME_NEWUSR_HLP_TEXT);}set;}
    public string oldStrUsername{get;set;}
    public string strUsername{get;set;}
    public String exceptionDivStyle{get;set;}
    public string profileId {get;set;}   
    
    /**
    * @author Shiva Shankar
    * @description - Constructor for WispCustomerInfoUserNameController
    * @input param  - null
    * @return null
    */
        public WispCustomerInfoUsernameController()
        {
            isVisibleExceptionMessage = false;
            isVisibleSuccessAlert = false; 
            exceptionString = '';
            populateWispDashboardData();
			system.debug('---------'+mainDTOObj);
            fillCustomerUpdateForFromDTO();           
        }
    
    /**
    * @author Srikanth Kudumula
    * @description - saveUsername for WispCustomerInfoUserNameController
    * @input param  - null
    * @return param null
    */ 
        public PageReference saveUsername()
        {   
            oldStrUsername =mainDTOObj.federationId;    
            try{
                //system.debug(strConfirmUsername + '------------------strUsername-------' + strUsername);
                if((AtlasUtility.isEmpty(strUsername))) {
                    isVisibleExceptionMessage = true;
                    isVisibleSuccessAlert = false;
                    exceptionString = 'Please fill up required fields.';
                    return null;
                }
                List<User> userObj = [select Id from User where FederationIdentifier =: strUsername limit 1];               
                if(AtlasUtility.isEmpty(userObj)){       
                    AtlasSSOWS.changeLoginUserNameResponse_element result;
                    if (!Test.isRunningTest()) 
                        result= AtlasIntegrationUtility.changeLoginUserName(oldStrUsername ,strUsername);
                    else
                    result=(AtlasSSOWS.changeLoginUserNameResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('changeUserNameResponse'),AtlasSSOWS.changeLoginUserNameResponse_element.class);                         
                    if(oldStrUsername == result.loginusername){
                       oldStrUsername = strUsername;
                       exceptionString = '';
                       isVisibleSuccessAlert=true;
                       isVisibleExceptionMessage = false;
                       mainDTOObj.accountDTOObj.username=strUsername;
                       mainDTOObj.federationId=oldStrUsername;                 
                       persistViewState();                      
                    }else{
                       isVisibleExceptionMessage = true;
                       isVisibleSuccessAlert=false;
                       exceptionString = 'Username is not available';
                       exceptionDivStyle='';                        
                    } 
                }
                else {
                    isVisibleExceptionMessage=true;
                    isVisibleSuccessAlert=false;
                    exceptionString= 'Duplicate Username.';
                    exceptionDivStyle='';       
                }
            }catch(AtlasException e)
            {
                system.debug('saveCustomerInfo catch: ' + e.errorMessage);
                isVisibleExceptionMessage=true;
                isVisibleSuccessAlert=false;
                exceptionString= e.errorMessage ;
                exceptionDivStyle='';                   
            }
            return  null;               
        }
    
    /**
    * @author Srikanth Kudumula
    * @description - cancelException for WispCustomerInfoUserNameController
    * @input param  - null
    * @return param null
    */     
    public PageReference cancelException()
    {
    	system.debug('@@@---Profile Id---->'+profileId);
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
    
    
    public void fillCustomerUpdateForFromDTO()
    {
        isVisibleExceptionMessage = false;
        isVisibleSuccessAlert=false;
        exceptionString = '';
        exceptionDivStyle='';                   
        strUsername = '';
        system.debug('main DTO------>'+mainDTOOBJ);                                                                                                                                      
        if(mainDTOObj.accountDTOObj != null){
            oldStrUsername =mainDTOObj.federationId;                           
        }
    }
}