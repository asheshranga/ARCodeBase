public class TestQA1 {
        
    public string UrlExede{get;set;}
    public string UrlVA{get;set;}  
    public string UrlHome{get;set;}  
    public string VA_SerMgmt{get;set;}
    public string Label_Home{get;set;} 
        
    public string searchtext {get;set;}
    public List<wrapperExede> lstExede{get;set;}
    public List<PassengerCareFAQ_VA__kav> lstAllExede{get;set;}
              
    public TestQA1 (){  
            map<string,string> mapPassengerCare = new map<String,string>();
        
  //fetch default values from passenger care custom setting
    for(Passenger_Care__c pc : [select key__c,Value__c from Passenger_Care__c]){
       mapPassengerCare.put(pc.key__c,pc.Value__c);
    }
        
    if(mapPassengerCare.size() > 0 ){
        
        //labels for page.
        if(mapPassengerCare.containsKey('SerMgmt')){VA_SerMgmt = mapPassengerCare.get('SerMgmt');}
        if(mapPassengerCare.containsKey('UrlExede')){UrlExede = mapPassengerCare.get('UrlExede');}
       if(mapPassengerCare.containsKey('UrlVA')){UrlVA = mapPassengerCare.get('UrlVA'); }
        if(mapPassengerCare.containsKey('URLHome')){UrlHome = mapPassengerCare.get('URLHome'); }
        if(mapPassengerCare.containsKey('Home')){Label_Home = mapPassengerCare.get('Home'); }
    }
            lstAllExede = [select Id,Title,Answer__c,Question__c from PassengerCareFAQ_VA__kav where language = 'en_US' and publishstatus = 'Online'];
            lstExede = new List<wrapperExede>();
            for(PassengerCareFAQ_VA__kav f :lstAllExede){
                    lstExede.add(new wrapperExede(false,f.Question__c,f.Answer__c));
            }
            lstExede.sort();
        
        setIds(lstExede);
            
    }     
        
   public void  search() {
          
       lstExede.clear(); // clear out the current results if they exist
       if(searchtext <> null && searchtext.trim() <> ''){
           for(PassengerCareFAQ_VA__kav f :lstAllExede){
               string ques = (f.Question__c).ToLowerCase();
               searchtext = searchtext.trim();
               searchtext = searchtext.ToLowerCase();
                if(ques.contains(searchtext) ){
                    lstExede.add(new wrapperExede(false,f.Question__c,f.Answer__c));
                }
           }
       }
       else{
           for(PassengerCareFAQ_VA__kav f :lstAllExede){
                    lstExede.add(new wrapperExede(false,f.Question__c,f.Answer__c));
            }
       }
       setIds(lstExede);
       lstExede.sort();
   }
        public pagereference onQuestionClick(){
           return null;
       }
        
          
    public void setIds(List<wrapperExede> lstExede){
        Integer i = 1;
        for(wrapperExede f :lstExede){
f.qId = 'wrap-'+(i++);
            }
    }
       public pagereference checkQuestion(){
            String selId = Apexpages.currentPage().getParameters().get('SelId');
            if(selId == null || selId == '')return null;
            for(wrapperExede f :lstExede){
                if(f.qId == selId){
                    f.isChecked = !f.isChecked;
                }
            }
            return null;
        }
        
        public class wrapperExede implements Comparable{
            public boolean isChecked{get;set;}
            public string qId{get;set;}
            public String Question{get;set;}
            public string Answer{get;set;}
            public wrapperExede(boolean isChecked, String Question, string Answer){
                this.isChecked = isChecked;
                this.Question = Question;
                this.Answer = Answer;
                
            }
            public Integer compareTo(Object compareTo) 
    {
        wrapperExede jobsWrapper = (wrapperExede) compareTo;
        if (Question == jobsWrapper.Question) return 0;
        if (Question > jobsWrapper.Question) return 1;
        return -1;        
    }
        }

   }