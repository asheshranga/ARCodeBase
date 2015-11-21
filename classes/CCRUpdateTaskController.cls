public with sharing class CCRUpdateTaskController extends PageControllerBase
{
    public Task myTask  { get; set;}
    ApexPages.standardController scon = null; 
    
    //Variable to hold Type
    public String selectedType {get; set;}
    //get all Type picklist values
    public List<SelectOption> getTypes(){ 
        list<SelectOption> typeOptions = new list<SelectOption>();
        Schema.DescribeFieldResult typeFieldDescription = Task.Type.getDescribe();
        for (Schema.Picklistentry picklistEntry : typeFieldDescription.getPicklistValues())
        {
            typeOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return typeOptions;
    }
    
    //Variable to hold Status
    public String selectedStatus {get; set;}
    //get all Status picklist values
    public List<SelectOption> getStatus(){ 
        list<SelectOption> statusOptions = new list<SelectOption>();
        Schema.DescribeFieldResult typeFieldDescription = Task.Status.getDescribe();
        for (Schema.Picklistentry picklistEntry : typeFieldDescription.getPicklistValues())
        {
            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return statusOptions;
    }
    
    //Variable to hold Priority
    public String selectedPriority {get; set;}
    //get all Priority picklist values
    public List<SelectOption> getPriorities(){ 
        list<SelectOption> priorityOptions = new list<SelectOption>();
        Schema.DescribeFieldResult typeFieldDescription = Task.Priority.getDescribe();
        for (Schema.Picklistentry picklistEntry : typeFieldDescription.getPicklistValues())
        {
            priorityOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return priorityOptions;
    }
    
    //Variable to hold Due Date
    public String dueDate {get; set;}
    
    //Variable to hold Areas to be Reviewed
    public SelectOption[] areastobeReviewed{get;set;}
    public SelectOption[] selectedAreastobeReviewed{get;set;}
    public List<String> areastobeReviewedChoice{get; set;}
    //get all Areas to be Reviewed picklist values
    /*public List<SelectOption> getAreastobeReviewed(){  
        list<SelectOption> areaOptions = new list<SelectOption>();
        Schema.DescribeFieldResult typeFieldDescription = Task.Area_s_To_Be_Reviewed__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : typeFieldDescription.getPicklistValues())
        {
            areaOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        system.debug('@@@ area options--->'+areaOptions);
        return areaOptions;
    }*/
    
    //Variable to hold Subject 
    public String selectedSubject {get; set;}
    //Variable to hold Subject- Other
    public String selectedSubjectOther {get; set;}
    //get all Subject picklist values
    public List<SelectOption> getSubject(){ 
        list<SelectOption> subjectOptions = new list<SelectOption>();
        Schema.DescribeFieldResult typeFieldDescription = Task.Subject.getDescribe();
        for (Schema.Picklistentry picklistEntry : typeFieldDescription.getPicklistValues())
        {
            subjectOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return subjectOptions;
    }
    
    public String comments {get; set;}
    
    //Constructor       
    public CCRUpdateTaskController (ApexPages.StandardController controller) {
        scon = controller;
        //get the task record
        myTask = (Task) controller.getrecord(); 
        System.Debug('MyTask: ' + myTask);
        
        //make sure the task records is available 
        if (myTask==null)
            addMessage('No task found');
        else if (!UpdateTaskAllowed) //make sure task owner is same as logged in user
        {
            addMessage('You are not authorized to update this task');             
        }
        else
        {
            //Assign VF page values with selected task values
            set<String> selectedvalues =new Set<String>();
            selectedType=myTask.type;
            selectedStatus=myTask.status;
            selectedPriority=myTask.priority;
            if(myTask.activitydate != null)
                dueDate=myTask.activitydate.format();
            system.debug('@@@ Due Date--->'+dueDate);
            system.debug('@@@---------> my task ares'+myTask.Area_s_To_Be_Reviewed__c);
            selectedAreastobeReviewed = new list<SelectOption>();
            
            if(myTask.Area_s_To_Be_Reviewed__c != null){
                List<String> tmpString = myTask.Area_s_To_Be_Reviewed__c.split(';');              
                for(String str : tmpString){
                    selectedAreastobeReviewed.add(new SelectOption(str,str));
                    selectedvalues.add(str);
                }
            }
            areastobeReviewed = new list<SelectOption>();
            Schema.DescribeFieldResult typeFieldDescription = Task.Area_s_To_Be_Reviewed__c.getDescribe();
            for (Schema.Picklistentry picklistEntry : typeFieldDescription.getPicklistValues())
            {
                if(!selectedvalues.contains(pickListEntry.getValue()))
                    areastobeReviewed.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            } 

            /* 
            //--- Checking whether the Subject is in picklist values or not, displaying Subject-Other field if it is not in picklist                       
            List<SelectOption> subjectOptions = new List<SelectOption>();
            Set<string> subjectOptionsStrings = new set<string>();
            Schema.DescribeFieldResult typeFieldDescription1 = Task.Subject.getDescribe();
            for (Schema.Picklistentry picklistEntry : typeFieldDescription1.getPicklistValues()) {
                subjectOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            }
            for(SelectOption s: subjectOptions) {
                subjectOptionsStrings.add(s.getValue());
            }
            if(!subjectOptionsStrings.contains(myTask.subject)) {
                selectedSubject='Other';
                selectedSubjectOther=myTask.subject;
            }
            else
                selectedSubject=myTask.subject;
            */
            selectedSubject=myTask.subject;    // Reverting back to old as per the case 00499138       
            comments=myTask.description; 
         
        }              
    }      
    
    // Variable to hold UpdateTaskAllowed - returns true if task owner and logged in user are same    
    public  Boolean UpdateTaskAllowed {
        get
        {
            return myTask.ownerid == UserInfo.getUserId();      
        }  
    }  
    
    private void addMessage(String message){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, message);  
        ApexPages.addmessage(myMsg); 
    }
     
    public PageReference UpdateTask() {
      
        // get the fields to update. 
        myTask.Type = selectedType;  
        myTask.Status = selectedStatus;
        myTask.Priority = selectedPriority;
        system.debug('@@@ Due Date Update --->'+dueDate);
        if(duedate != null && dueDate != '')
            myTask.ActivityDate = date.Parse(dueDate);
        String selectedAreas = '';
        for(selectOption so : selectedAreastobeReviewed){
                selectedAreas += so.getValue() + ';' ;
        }
        myTask.Area_s_To_Be_Reviewed__c = selectedAreas;
        
        /*--
        //--- Checking whether Subject-other field is empty or not
        if(selectedSubjectOther!=null && selectedSubjectOther!='' && selectedSubject=='Other')
            myTask.Subject = selectedSubjectOther;
        else
            myTask.Subject = selectedSubject;
        */
        myTask.Subject = selectedSubject;   // Reverting back to old as per the case 00499138   
        myTask.description= comments;       
        
        System.debug('myTask:'+ myTask);
        
        try{
            update myTask;
            System.debug('myTask saved');
        }
        catch(Exception e){
            System.debug('myTask not saved: '+ e.getMessage());
            addMessage(e.getMessage());
            return null; // stay on page
        }
        
        pagereference pr = new pagereference('/'+myTask.id);
        pr.setredirect(true);
        return pr;
    }
    
    public PageReference Cancel() {      
        return scon.cancel();
    }
}