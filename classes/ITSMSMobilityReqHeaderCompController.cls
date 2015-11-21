public class ITSMSMobilityReqHeaderCompController  extends ITSMSComponentControllerBase {
    public String key{ 
        get;set{
            if(value != null){
                Key = value;
                if(pageController != null)
                    pageController.setComponentControllerMap(Key, this);
            }
        }
    }
    public ITSMSPageControllerBase pageController { 
        get;set
        {
            if (value != null) 
            {
                pageController = value;
                pageController.setComponentController(this);
            }
        }
    }
    public Case caseRec { 
        get;set
        {
            if (value != null) 
            {
                caseRec = value;
            }
        }
    }
    public ITSMSComponentToController componentToPage { 
        get;set
        {
            if (value != null) 
            {
                componentToPage = value;
            }
        }
    }
}