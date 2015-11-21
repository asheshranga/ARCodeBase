/*********************************************************************************
Name         : AtlasQuestionTipController 
Created By   : Tejesh Kumar
Company Name : CMC Americas
Project      : ViaSat Atlas
Created Date : 18 May 2015
Usages       : Controller for VisualForce Comp: AtlasQuestionTip
08/17/2015   : Modified to support the start date & end date of Question functionality
*********************************************************************************/

public with sharing class  AtlasQuestionTipController extends AtlasDataManager {
    // Initializing the MainDTO object   
    public AtlasMainDTO mainDTOObj{get;set;}    
    List<String> TipsList = new List<String>();
    List<String> QuesList = new List<String>();
    List<String> QuesIdList = new List<String>();
    List<NPSResponse__c> userSkipList = new List<NPSResponse__c>();
    List<NPSResponse__c> userAnsweredQuesList = new List<NPSResponse__c>();
    Map<String,Map<String,String>> TipsLinksMap = new Map<String,Map<String,String>>();
    public boolean showTip{get;set;} 
    public boolean checkExistingAnswers{get;set;}
    public boolean showQues{get;set;}
    public boolean showLink{get;set;}
    public boolean showLoading{get;set;}
    public string tipToDisplay{get;set;}
    public string linkForTip{get;set;}
    public string linkText{get;set;}
    public string question{get;set;}
    public string questionId{get;set;}
    public string low{get;set;}
    public string medium{get;set;}
    public string high{get;set;}
    public string randomQuesId{get;set;}
    public Integer accNo{get;set;}
    public static User userObj{get;set;}   
    public string userId{get;set;}
    public String selectedValue{get; set;}
    
    // Constructor
    public AtlasQuestionTipController() {
        showTip=false;
        checkExistingAnswers=false;
        showQues=false;
        showLink=false;
        showLoading=true;                 
    }
    
    /**
    * @author Tejesh Kumar 
    * @description NPS main loading method to display Question/Tip
    * @param object null
    * @return null
    */  
     public void loadQuestionorTip() {
        /** Code to Support NPS Project **/  
        //system.debug('*** showLoading ' + showLoading + ' mainDTOObj.contactId:' + mainDTOObj.contactId);      
        if(!AtlasUtility.isEmpty(mainDTOObj)) {
            if(!AtlasUtility.isEmpty(mainDTOObj.contactId)) {
            showLoading=false;
            if(Test.isRunningTest()){ checkExistingAnswers=true;} 
            userObj = [Select Id,ContactId,CreatedDate,SkipCount__c,Contact.Account_Number__c,Account_Number__c,Contact.Name,FederationIdentifier from User where ContactId = :mainDTOObj.contactId];        
            userId=userObj.Id;                                               
            if(!AtlasUtility.isEmpty(userObj)) {
                dateTime dT=userObj.CreatedDate;
                Date userCreatedDate = date.newinstance(dT.year(), dT.month(), dT.day());            
                if(AtlasUtility.isEmpty(userObj.SkipCount__c)) {userObj.SkipCount__c=0;}
                if(userObj.SkipCount__c>2  || ((userCreatedDate.daysBetween(System.today()))<=30)) {
                    displayTip();
                }
                else
                    checkExistingAnswers=true;
            }  
                        
            if(checkExistingAnswers) {
                List<NPSResponse__c> npsRespList = [Select Name,CreatedDate,QuestionId__c,ResponseType__c,UserId__c From NPSResponse__c Where UserId__c=:userId.left(15)];
                for(NPSResponse__c resp1 : npsRespList){ 
                    if(resp1.ResponseType__c=='Skip')                  
                        userSkipList.add(resp1);
                    else if(resp1.ResponseType__c=='Answer')
                        userAnsweredQuesList.add(resp1);               
                }
                /*** if user answered ques list is not empty, check for the user answered ques in last 30 days and display tip if exists; 
                if doesnt exist in last 30 days then move all the answered ques to a list Q, display question.***/                          
                if(!AtlasUtility.isEmpty(userAnsweredQuesList)){
                    for(NPSResponse__c resp : npsRespList){
                        dateTime dTime=resp.CreatedDate;
                        Date respCreatedDate = date.newinstance(dTime.year(), dTime.month(), dTime.day());  
                        if(respCreatedDate.daysBetween(System.today())<=30) {
                            system.debug('---enter if ans ques is less than 30 days');
                            displayTip(); 
                            break; 
                        }
                    }
                    if(!showTip) {
                        system.debug('---enter if ans ques is not less than 30 days');                        
                        modFunction();                       
                    }                     
                } 
                
                /*** if user answered Ques list is empty then check the user skipped questions. if user skipped ques list is empty display Question, 
                if user skipped ques list is not empty check for the user skipped in last 30 days and display tip if exists or display question if not. ***/           
                else {                
                    if(!AtlasUtility.isEmpty(userSkipList)) {
                        for(NPSResponse__c respSkip : npsRespList) {
                            dateTime dTime=respSkip.CreatedDate;
                            Date respCreatedDate = date.newinstance(dTime.year(), dTime.month(), dTime.day()); 
                            if(respCreatedDate.daysBetween(System.today())<=30) {
                                displayTip();
                                break;   
                            }                                           
                        }
                        if(!showTip) {
                            modFunction();  
                        }  
                    }               
                    else if(!showTip && AtlasUtility.isEmpty(userSkipList)){  
                        system.debug('---enter if skipped empty');   
                        modFunction();
                    } 
                }                                                                
            }
        }
        }
        
     }
     
    /**
    * @author Tejesh Kumar 
    * @description To display Tip
    * @param object null
    * @return null
    */  
     public void displayTip() {
        List<NPSContent__c> npsContentList = [Select QuestionId__c,Type__c,Text__c,Link__c,LinkText__c,StartDate__c,EndDate__c From NPSContent__c Where Type__c='Tip'];                   
        if(!AtlasUtility.isEmpty(npsContentList)) { 
            for(NPSContent__c rec : npsContentList) {
                TipsList.add(rec.Text__c); 
                if(!AtlasUtility.isEmpty(rec.Link__c)) {
                    Map<String,String> innerMap = new Map<String,String>();
                    innerMap.put(rec.Link__c,rec.LinkText__c);
                    TipsLinksMap.put(rec.Text__c,innerMap);   
                }                                                                 
            }
            Double randomNumber = Math.random(); 
            Integer arrayLength = TipsList.size(); 
            Integer randomIndex = (randomNumber *(arrayLength-1)).intValue();
            tipToDisplay=TipsList[randomIndex];
            
            system.debug('---TipsList--> '+TipsList);
            system.debug('---TipsLinksMap--> '+TipsLinksMap);
            
            if(TipsLinksMap.containsKey(tipToDisplay)) {
                Map<string,string> innerMap2 = TipsLinksMap.get(tipToDisplay);
                for(string strLink: innerMap2.keySet()){
                    linkForTip=strLink;
                    linkText=innerMap2.get(strLink);    
                }
                
                showLink=true;
            }
            showLoading=false; 
            showQues=false;
            showTip=true;                                  
        }   
     }
     
      /**
    * @author Tejesh Kumar 
    * @description To Mod function to display Question
    * @param object null
    * @return null
    */  
    public void modFunction() {
        Date todayDate= Date.today();        
        system.debug('---todayDate ---> '+todayDate); 
        
        //---08/17/2015 - Modified to support the start date & end date of Question functionality
        List<NPSContent__c> npsContentList = [Select Name,QuestionId__c,Type__c,Text__c,Link__c,LinkText__c,HighLabel__c,MediumLabel__c,LowLabel__c,StartDate__c,EndDate__c 
                                              FROM NPSContent__c 
                                              WHERE Type__c='Question' 
                                              AND (StartDate__c<=:todayDate OR StartDate__c=null)  
                                              AND (EndDate__c>=:todayDate OR EndDate__c=null) 
                                              ORDER BY Id ASC];
        system.debug('---npsContentList: active questions ---> '+npsContentList);                                                    
        if(!AtlasUtility.isEmpty(npsContentList)) {   
            if(Test.isRunningTest()) {userObj = [Select Id,Contact.Account_Number__c,Account_Number__c,Contact.Name from User where ContactId = :mainDTOObj.contactId]; }     
            if(!AtlasUtility.isEmpty(userObj.Contact.Account_Number__c)||!AtlasUtility.isEmpty(userObj.Account_Number__c)) {                  
                for(NPSContent__c ques : npsContentList){
                    system.debug('---ques start date---> '+ques.StartDate__c + '---ques end date---> '+ques.EndDate__c); 
                    QuesList.add(ques.Text__c); 
                    QuesIdList.add(ques.Name);                                                                  
                }     
                // MOD function to display Question
                Integer Month = Date.Today().Month();                 
                if(!AtlasUtility.isEmpty(userObj.Contact.Account_Number__c))
                    accNo = integer.valueof(userObj.Contact.Account_Number__c);
                else
                    accNo = integer.valueof(userObj.Account_Number__c);
                Integer randomQuesId = math.mod((accNo+month),QuesList.size());
                system.debug('---randomQuesId--> '+randomQuesId);  
                                                                                      
                question=QuesList[randomQuesId];
                questionId=QuesIdList[randomQuesId];
                for(NPSContent__c nps : npsContentList){
                    if(nps.Text__c==question) {
                        low=nps.LowLabel__c;
                        medium=nps.MediumLabel__c;
                        high=nps.HighLabel__c;
                    }                                                                  
                } 
                system.debug('---question--> '+question);
            }
            showLoading=false;
            showTip=false;
            showQues=true;  
        }
        else {
            displayTip();   
        }
    }
    
    /**
    * @author Tejesh Kumar 
    * @description NPS submit action for saving the data into salesforce
    * @param object null
    * @return null
    */  
     public void submitNPS() {
        try {
             System.debug('---SFDC: ' + selectedValue);
             userObj = [Select Id,ContactId,SkipCount__c,Contact.Name,Contact.Account_Number__c,FederationIdentifier from User where ContactId = :mainDTOObj.contactId];
             userId=userObj.Id;
             
             // To check if already answered - To address the problem of answering in different tabs
             List<NPSResponse__c> answQuesList = [Select Name,CreatedDate,QuestionId__c,ResponseType__c,UserId__c FROM NPSResponse__c 
             WHERE ResponseType__c='Answer' 
             AND UserId__c=:userId.left(15)
             AND CreatedDate = LAST_N_DAYS:30];
             
             if(AtlasUtility.isEmpty(answQuesList)) {
                 // Save the response in NPS Response Object                                        
                 NPSResponse__c npsRes=new NPSResponse__c();
                 npsRes.Name=userObj.Contact.Name;
                 npsRes.AccountNumber__c=userObj.Contact.Account_Number__c;
                 npsRes.UserId__c=userId.left(15);
                 npsRes.ResponseType__c='Answer';
                 if(!AtlasUtility.isEmpty(selectedValue)) { npsRes.ResponseValue__c=selectedValue; }               
                 if(!AtlasUtility.isEmpty(questionId)) { npsRes.QuestionId__c=string.valueof(questionId); }
                 if(!AtlasUtility.isEmpty(mainDTOObj.accountDTOObj.serviceLevel)) { npsRes.AccountPlan__c=mainDTOObj.accountDTOObj.serviceLevel; }
                 if(!AtlasUtility.isEmpty(mainDTOObj.accountDTOObj.provisionStatus)) { npsRes.AccountStatus__c=mainDTOObj.accountDTOObj.provisionStatus; }           
                 insert npsRes;
             } 
            // To hide question and display Tip in other action function
             //showQues=false;
             //displayTip();
        }   
        Catch(Exception e){   
            System.debug('Exception--->'+e);
        }
     }  
     
    /**
    * @author Tejesh Kumar 
    * @description NPS skip action to hide question and display Tip
    * @param object null
    * @return null
    */  
     public void skipNPS() { 
        try {       
            System.debug('mainDTOObj--->'+mainDTOObj);    
            System.debug('---questionId--->' + questionId);                      
            // To increment the SkipCount field in User Object
            userObj = [Select Id,ContactId,SkipCount__c,Contact.Name,Contact.Account_Number__c,FederationIdentifier from User where ContactId = :mainDTOObj.contactId];                         
            if(!AtlasUtility.isEmpty(userObj)) {
                userId=userObj.Id;
                if(AtlasUtility.isEmpty(userObj.SkipCount__c)) {userObj.SkipCount__c=0;} 
                userObj.SkipCount__c++;
                update userObj;
            }
            
             // Save the response in NPS Response Object
            NPSResponse__c npsRes=new NPSResponse__c();
            npsRes.Name=userObj.Contact.Name;
            npsRes.AccountNumber__c=userObj.Contact.Account_Number__c;
            npsRes.UserId__c=userId.left(15);
            npsRes.ResponseType__c='Skip';     
            if(!AtlasUtility.isEmpty(questionId)) { npsRes.QuestionId__c=string.valueof(questionId); }     
            if(!AtlasUtility.isEmpty(mainDTOObj.accountDTOObj.serviceLevel)) { npsRes.AccountPlan__c=mainDTOObj.accountDTOObj.serviceLevel; }
            if(!AtlasUtility.isEmpty(mainDTOObj.accountDTOObj.provisionStatus)) { npsRes.AccountStatus__c=mainDTOObj.accountDTOObj.provisionStatus; }             
            insert npsRes;
             
            // To hide question and display Tip
            showQues=false;
            displayTip();
        }
        Catch(Exception e){   
            System.debug('Exception--->'+e);
        }
    }    
}