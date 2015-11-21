/*********************************************************************************
Name         : DealerPlanOptionsDTO Controller
Created By   : Tejesh M
Created Date : 11/11/2015
Project      : Dealer Portal 
Usages       :Class for Dealer Plan Options Information
*********************************************************************************/
global with sharing class DealerPlanOptionsDTO {
    //To hold external account type
    global string displayName{get;set;}
    
    //To hold external account number
    global string price{get;set;}
    
    global string priceType{get;set;}
    
    global string voiceDescription{get;set;}
    
    global string voicePrice{get;set;}
    
    global string monthlyPayDesc{get;set;}
    
    global string upFrontPayDesc{get;set;}
    
}