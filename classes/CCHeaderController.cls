public with sharing class CCHeaderController {
     
    public String userName {get; set;}
     
    public CCHeaderController() {
        userName = UserInfo.getName();  
    }
}