/*
Author: Rajesh
Project: Viasat NBNCo Customer Portal
Date: Oct 2013
Purpose: For Clock displaying in Case section.
*/

public with sharing class ViasatSupportClockTimer
{
   Public Case c {get; set;}
   Public String strInitialResponseClockTime {get; set;}
   Public String strInterimResolutionClockTime {get; set;}
   Public String strFinalResolutionClockTime {get; set;}
   Public String strInitialResponseClockState {get; set;}
   Public String strInterimResolutionClockState {get; set;}
   Public String strFinalResolutionClockState {get; set;}
   Public Decimal hiddenInitialResponseTotalseconds{get; set;}
   Public Decimal hiddenInterimResolutionTotalseconds{get; set;}
   Public Decimal hiddenFinalResolutionTotalseconds{get; set;}
   Public String strNotApplicableSection {get;set;}
   Public list<Case> updCase = new list<case>();
   
    public ViasatSupportClockTimer(ApexPages.StandardController controller) {
      c = [select id, LastmodifiedDate,Type,PrioritybasedonType__c, CreatedDate,EstimatedInitialResponseTime__c,EstimatedResolutionTime__c,EstimatedWorkaroundTime__c,InitialResponseStateModifiedDate__c,FinalResolutionStateModifiedDate__c,InterimResolutionStateModifiedDate__c, InitialResponseTotalInSeconds__c, FinalResolutionTotalInSeconds__c, InterimResolutionTotalInSeconds__c, InitialResponseClockTime__c, InitialResponseClockState__c, InterimResolutionClockTime__c, InterimResolutionClockState__c, FinalResolutionClockTime__c, FinalResolutionClockState__c,status from Case where id = :ApexPages.currentPage().getParameters().get('id')];
      strInitialResponseClockTime = c.InitialResponseClockTime__c;
      strInterimResolutionClockTime = c.InterimResolutionClockTime__c;
      strFinalResolutionClockTime = c.FinalResolutionClockTime__c;
      strInitialResponseClockState = c.InitialResponseClockState__c;
      strInterimResolutionClockState = c.InterimResolutionClockState__c;
      strFinalResolutionClockState = c.FinalResolutionClockState__c;
      strNotApplicableSection = 'True';
      if(c.Type == 'Technical Inquiry' && c.PrioritybasedonType__c == '4 - Normal')
       strNotApplicableSection = 'False';
      //hiddenInitialResponseTotalseconds = c.InitialResponseTotalInSeconds__c;
      //hiddenInterimResolutionTotalseconds = c.InterimResolutionTotalInSeconds__c;
      //hiddenFinalResolutionTotalseconds = c.FinalResolutionTotalInSeconds__c;
    }

   Public void updateRunningstate()
   {
     try{   
         if(c.InitialResponseClockState__c == 'Running' || c.InitialResponseClockState__c == 'Start')
          {
            Decimal totalInitialResponse = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c,System.now());
            hiddenInitialResponseTotalseconds = totalInitialResponse;
            System.debug('1Test'+ c.InitialResponseTotalInSeconds__c + ' diff :' + ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),c.EstimatedInitialResponseTime__c));
            System.debug('1st Test:' + totalInitialResponse);
            //c.InitialResponseTotalInSeconds__c = totalInitialResponse;
            c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(totalInitialResponse);
            //updCase.add(c);
          } 
          if(c.InterimResolutionClockState__c == 'Running' || c.InterimResolutionClockState__c == 'Start')
          { 
            Decimal totalInterimResolution = c.InterimResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());        
            hiddenInterimResolutionTotalseconds = totalInterimResolution;
            //System.debug('2Test'+ c.InterimResolutionTotalInSeconds__c + ' diff :' + ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),c.EstimatedWorkaroundTime__c));
            System.debug('2nd Test:' + totalInterimResolution);
            //c.InterimResolutionTotalInSeconds__c = totalInterimResolution; 
            c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(totalInterimResolution);
            //updCase.add(c);     
          }
          if(c.FinalResolutionClockState__c == 'Running' || c.FinalResolutionClockState__c == 'Start')
          {   
            Decimal totalFinalResolution = c.FinalResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c,System.now());
            hiddenFinalResolutionTotalseconds = totalFinalResolution;
            System.debug('3rd Test:' + totalFinalResolution);
            //c.FinalResolutionTotalInSeconds__c = totalFinalResolution;
            c.FinalResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(totalFinalResolution);      
            //updCase.add(c);        
          }
          if(c.status!='Closed')     
          update c;
         }
         Catch(Exception ex)
         {
           ApexPages.addMessages(ex);
         } 
   }
   
  
}