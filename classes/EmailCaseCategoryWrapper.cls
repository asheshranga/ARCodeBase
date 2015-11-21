global class EmailCaseCategoryWrapper implements Comparable {

    public PassengerCareEmailCaseCategory__c PCEmailCaseCategory;
    
    // Constructor
    public EmailCaseCategoryWrapper(PassengerCareEmailCaseCategory__c objPcecc) {
        PCEmailCaseCategory = ObjPcecc;
    }   
    
    
    //-- Compare Categories based on the Sequence Number
    global Integer compareTo(Object compareTo) {
        // Cast argument to CaseWrapper
        EmailCaseCategoryWrapper compareToCase = (EmailCaseCategoryWrapper) compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (Integer.ValueOf(PCEmailCaseCategory.SequenceNumber__c)  > Integer.ValueOf(compareToCase.PCEmailCaseCategory.SequenceNumber__c)) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (Integer.ValueOf(PCEmailCaseCategory.SequenceNumber__c)  < Integer.ValueOf(compareToCase.PCEmailCaseCategory.SequenceNumber__c)) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}