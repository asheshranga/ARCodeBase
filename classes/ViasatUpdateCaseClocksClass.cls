/*
Author: NTT Data
Project: Viasat NBNCo Customer Portal
Date: Oct 2013
Purpose: This is used to Common Class for ViasatUpdateCaseClocks Trigger.
         Its Controling the three timers based on Case's Status and Status details field changing
         Three timers values maintaining with help of four different fields for each timer.
         i. _____TotalSeconds__c
         ii._____ClockTime__c
         iii.______ClockState__c
         iv.______StatemodifiedDate__c       
*/
global class ViasatUpdateCaseClocksClass
{
	
/*	
	// Obsolete - PL - Case Number - 282319
	
    //It will be working for Before Insertion event of trigger in the case object
    public static void BeforeInsertClock(List<Case> lstcase) 
    {
        for(Case c : lstcase)
        {
            // Three timers going to 'Start' Stage Whenever the case create with Status as 'New'. 
            //  We have to capture current modified time to Each timer State modified Date(ex: InitialResponseStateModifiedDate__c) field
            if(c.Status == 'New')
            {
                c.InitialResponseClockState__c = 'Start';
                c.InitialResponseStateModifiedDate__c = system.now();      
               
                c.InterimResolutionClockState__c = 'Start';
                c.InterimResolutionStateModifiedDate__c = system.now();         
                    
                c.FinalResolutionClockState__c = 'Start'; 
                c.FinalResolutionStateModifiedDate__c = system.now();
            }
            // Three timers will be functioning whenever the case create with Status as 'In Progress' and Status Details as 'Initial Response Provided' 
            // As per requirement at this stage InitialClock will be stopped, Workaround/Interim and Resolution clocks will be running,
            // Three timers four different fields to maintain Each
            if(c.Status == 'In Progress' && c.StatusDetails__c == 'Initial Response Provided')
            {   
                c.ElapsedInitialResponseTotalSeconds__c = c.ElapsedInitialResponseTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());//ElapsedInitialResponseTotalSeconds will be calculated for Displaying the Elapsed Time of Initial Response provided by the Viasat user.                 
                c.InitialResponseTotalInSeconds__c = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());//InitialResponseTotalInseconds field helps to capturing the Total seconds difference between Current time and 'Initial Response timer' last modified date                     
                c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InitialResponseTotalInSeconds__c);//InitialResponseClockTime helps to display time formatting from InitialREsponseTotalInseconds__c                 
                c.InitialResponseClockState__c = 'Stop';//Here we are maintaining the Initial Response timer state                  
                c.InitialResponseStateModifiedDate__c = system.now();//Whenever we change the Initial response Clock state then we should maintain the InitialResponseStateModifiedDate__c also
                    
                c.ElapsedInterimREsolutionTotalSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());  
                c.InterimResolutionTotalInSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());   
                c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InterimResolutionTotalInSeconds__c); 
                c.InterimResolutionClockState__c = 'Running';
                c.InterimResolutionStateModifiedDate__c = system.now();                
                    
                c.ElapsedFinalResolutionTotalSeconds__c = c.ElapsedFinalResolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                c.FinalResolutionTotalInSeconds__c = c.ElapsedFinalResolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                c.FinalResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.FinalResolutionTotalInSeconds__c);      
                c.FinalResolutionClockState__c = 'Running';
                c.FinalResolutionStateModifiedDate__c = system.now();                 
                //Update Elapsed Initial Response provided time text formatting from ElaspedInitialResponseTotalseconds 
                c.ElapsedTimeToInitialResponse__c = ViasatUtilityClass.TimeTextFormatting(c.ElapsedInitialResponseTotalSeconds__c);                     
            }
        }
    }

*/    
    
    //It will be working for After Update event on Case Trigger- It is basically for whenever the Priority or Type changes occuring on case then the Estimated times will be updating for three timers.
    public static void AfterUpdateClock(List<Case> lstcase,Map<id,Case> oldcase) 
    {
        Set<ID> caseids = new Set<ID>();
        List<Case> lstupdcase2 = new List<Case>();
        List<Case> elstcases = new List<Case>();
        for(Case cid:lstcase)
            if(cid.RecordTypeName__c == 'Support Services NBN Co') //Restriction for timers works for only 'Support Services NBN Co' record type     
                caseids.add(cid.id);
          
        if(caseids.size()>0)//Get Estimation times for three timers of Current list of cases    
            elstcases = [Select id, EstimatedInitialResponseTime__c, EstimatedWorkaroundTime__c, EstimatedResolutionTime__c from Case where id in:caseids];  
        
        for(Case c: lstcase)//Looping New version of cases
        {
            if(c.RecordTypeName__c == 'Support Services NBN Co')//Restriction for timers works for only 'Support Services NBN Co' record type
            {
                if(c.PrioritybasedonType__c != oldcase.get(c.id).PrioritybasedonType__c || c.Type != oldcase.get(c.id).Type)
                {
                    for(Case lc : elstcases)//Looping list of Estimated timers list
                    {
                        lc.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),lc.EstimatedInitialResponseTime__c);
                        lc.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(lc.InitialResponseTotalInSeconds__c);
                        lc.InitialResponseStateModifiedDate__c = system.now();
                          
                        if (lc.EstimatedWorkaroundTime__c != null)
                        {
                            lc.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),lc.EstimatedWorkaroundTime__c);
                            lc.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(lc.InterimResolutionTotalInSeconds__c);
                        }
                        lc.InterimResolutionStateModifiedDate__c = system.now();
                          
                        lc.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),lc.EstimatedResolutionTime__c);
                        lc.FinalResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(lc.FinalResolutionTotalInSeconds__c);
                        lc.FinalResolutionStateModifiedDate__c = system.now();
                        lstupdcase2.add(lc);
                    }
                    update lstupdcase2;
                }
            }
        }
    }
    /*It will be working for Before Update event on Case trigger- 
      This method helps to controlling the Clock timers whenever the status and Status detail changed*/ 
    public static void BeforeUpdateClock(List<Case> lstcase, Map<id,Case> oldcase) 
    {
        for(Case c: lstcase)
        {
            if(c.Status != oldcase.get(c.id).Status || c.StatusDetails__c != oldcase.get(c.id).StatusDetails__c)//Control checks for allow only status/status details changes occured
            {   
                if(c.Status == 'In Progress' && (c.StatusDetails__c == 'Initial Response Provided' || c.StatusDetails__c == 'Advance Replacement'))//Update the three timers when user provide the Initial Response
                { 
                        if(c.InitialResponseClockState__c != 'Stop')
                        {           
                            c.ElapsedInitialResponseTotalSeconds__c = c.ElapsedInitialResponseTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                            c.InitialResponseTotalInSeconds__c = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                            c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InitialResponseTotalInSeconds__c);
                            c.InitialResponseClockState__c = 'Stop';
                            c.InitialResponseStateModifiedDate__c = system.now();  
                        }
                        /*Checks for we have to update below fields only the timer state should be 'Start', 
                        If the Timer already on Running means no need to update the below fields only we should update the State and Modified date field*/
                        if(c.InterimResolutionClockState__c == 'Start')
                        {            
                            c.ElapsedInterimREsolutionTotalSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());  
                            c.InterimResolutionTotalInSeconds__c = c.InterimResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());         
                            c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InterimResolutionTotalInSeconds__c); 
                        }
                        c.InterimResolutionClockState__c = 'Running';
                        c.InterimResolutionStateModifiedDate__c = system.now();
                        /*Checks for we have to update below fields only the timer state should be 'Start', 
                        If the Timer already on Running means no need to update the below fields only we should update the State and Modified date field */                     
                        if(c.FinalResolutionClockState__c == 'Start')
                        {            
                            c.ElapsedFinalResolutionTotalSeconds__c = c.ElapsedFinalResolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                            c.FinalResolutionTotalInSeconds__c = c.FinalResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                            c.FinalResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.FinalResolutionTotalInSeconds__c);      
                        } 
                        c.FinalResolutionClockState__c = 'Running';
                        c.FinalResolutionStateModifiedDate__c = system.now();   
                        //Update Elapsed Initial Response provided time text formatting from ElaspedInitialResponseTotalseconds 
                        c.ElapsedTimeToInitialResponse__c = ViasatUtilityClass.TimeTextFormatting(c.ElapsedInitialResponseTotalSeconds__c);         
                    }
                    //Change the timer behaviour if user change the status to 'On Hold'
                    if(c.Status == 'On Hold') 
                    {     
                        if(c.StatusDetails__c == 'Waiting for Information' || c.StatusDetails__c == 'Waiting for Customer Action')//Checks for If Status is 'On Hold' and Status Details is either 'Waiting for Information' or 'Waiting for Customer Action'
                        {
                            if(c.InitialResponseClockState__c != 'Stop')//Checks for Initial Response timer state not in Stop
                            {               
                                c.ElapsedInitialResponseTotalSeconds__c = c.ElapsedInitialResponseTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                                c.InitialResponseTotalInSeconds__c = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                                c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InitialResponseTotalInSeconds__c);
                                c.InitialResponseClockState__c = 'Stop';
                                c.InitialResponseStateModifiedDate__c = system.now(); 
                            }
                            if(c.InterimResolutionClockState__c != 'Stop')//Checks for Interim/Workaround timer state not in Stop
                            {               
                                c.ElapsedInterimREsolutionTotalSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());  
                                c.InterimResolutionTotalInSeconds__c = c.InterimResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c, System.now()); 
                                c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InterimResolutionTotalInSeconds__c); 
                                c.InterimResolutionClockState__c = 'Stop';
                                c.InterimResolutionStateModifiedDate__c = system.now();  
                            }               
                            if(c.FinalResolutionClockState__c != 'Stop')//Checks for Resolution timer state not in Stop
                            {               
                                c.ElapsedFinalResolutionTotalSeconds__c  = c.ElapsedFinalResolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                                c.FinalResolutionTotalInSeconds__c = c.FinalResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                                c.FinalResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.FinalResolutionTotalInSeconds__c);               
                                c.FinalResolutionClockState__c = 'Stop';
                                c.FinalResolutionStateModifiedDate__c = system.now(); 
                            }           
                        }           
                        if(c.StatusDetails__c == 'Management Review workaround')//Checks for if Status details is 'Management Review workaround' means Resolution timer alone should run others should be Stopped
                        {
                            if(c.InitialResponseClockState__c != 'Stop')
                            {                
                                c.ElapsedInitialResponseTotalSeconds__c = c.ElapsedInitialResponseTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                                c.InitialResponseTotalInSeconds__c = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                                c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InitialResponseTotalInSeconds__c);
                                c.InitialResponseClockState__c = 'Stop';
                                c.InitialResponseStateModifiedDate__c = system.now(); 
                            }
                            if(c.InterimResolutionClockState__c != 'Stop')
                            {                
                                c.ElapsedInterimREsolutionTotalSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());  
                                c.InterimResolutionTotalInSeconds__c = c.InterimResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c, System.now());         
                                c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InterimResolutionTotalInSeconds__c); 
                                c.InterimResolutionClockState__c = 'Stop';
                                c.InterimResolutionStateModifiedDate__c = system.now();  
                            } 
                            if(c.FinalResolutionClockState__c == 'Stop' || c.FinalResolutionClockState__c == 'Start')
                            {
                                /*If timer going to running state means No need to update another two fields(TotalInseconds__c,Clocktime__c). 
                                  If only the Stopped state timer should calculate all four fields of respective timer*/    
                                c.FinalResolutionClockState__c = 'Running';
                                c.FinalResolutionStateModifiedDate__c = system.now(); //*********
                            }               
                        }
                        if(c.StatusDetails__c == 'Management Review Final Resolution')//If the Status Details is 'Management Review Final Resolution' means all clocks should stop
                        {
                            if(c.InitialResponseClockState__c != 'Stop')
                            {               
                                c.ElapsedInitialResponseTotalSeconds__c = c.ElapsedInitialResponseTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                                c.InitialResponseTotalInSeconds__c = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                                c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InitialResponseTotalInSeconds__c);
                                c.InitialResponseClockState__c = 'Stop';
                                c.InitialResponseStateModifiedDate__c = system.now(); 
                            }
                            if(c.InterimResolutionClockState__c != 'Stop')
                            {               
                                c.ElapsedInterimREsolutionTotalSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());  
                                c.InterimResolutionTotalInSeconds__c = c.InterimResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c, System.now());         
                                c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InterimResolutionTotalInSeconds__c); 
                                c.InterimResolutionClockState__c = 'Stop';
                                c.InterimResolutionStateModifiedDate__c = system.now();  
                            }               
                            if(c.FinalResolutionClockState__c != 'Stop')
                            {               
                                c.ElapsedFinalResolutionTotalSeconds__c  = c.ElapsedFinalResolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                                c.FinalResolutionTotalInSeconds__c = c.FinalResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                                c.FinalResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.FinalResolutionTotalInSeconds__c);               
                                c.FinalResolutionClockState__c = 'Stop';
                                c.FinalResolutionStateModifiedDate__c = system.now(); 
                            }
                        }
                    }// 'On Hold' behaviour end here
                    
                    /*Here the Timers behaviour change if the Final Resolution is rejected.
                    If Final Resolution rejected means Resolution Clock should run others two are going to stop*/
                    if(c.Status == 'In Progress' && c.StatusDetails__c == 'Final Resolution Rejected') 
                    {
                        if(c.ElapsedTimeToResolution__c == null)
                        {
                            c.StatusDetails__c.addError('Invalid action!');
                        }
                        else if(c.FinalResolutionClockState__c != 'Running')
                        {
                            c.FinalResolutionClockState__c = 'Running';
                            c.FinalResolutionStateModifiedDate__c = system.now();        
                        } 
                    } 
                }
                
                if(c.StatusDetails__c != oldcase.get(c.id).StatusDetails__c)
                {
                    //Timers acting here at the stage of Support user provided the workaround
                    if(c.Status == 'In Progress' && c.StatusDetails__c == 'Workaround Provided') 
                    {
                        if(c.InitialResponseClockState__c != 'Stop')
                        {               
                            c.ElapsedInitialResponseTotalSeconds__c = c.ElapsedInitialResponseTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                            c.InitialResponseTotalInSeconds__c = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());
                            c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InitialResponseTotalInSeconds__c);
                            c.InitialResponseClockState__c = 'Stop';
                            c.InitialResponseStateModifiedDate__c = system.now(); 
                        }
                        if(c.InterimResolutionClockState__c != 'Stop')
                        {             
                            c.ElapsedInterimREsolutionTotalSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());  
                            c.InterimResolutionTotalInSeconds__c = c.InterimResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c, System.now());         
                            c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InterimResolutionTotalInSeconds__c); 
                        }    
                        c.InterimResolutionClockState__c = 'Stop';
                        c.InterimResolutionStateModifiedDate__c = system.now();                     
                        //Update Elapsed Workaround provided time text formatting from ElapsedInterimREsolutionTotalSeconds__c 
                        c.ElapsedTimeToWorkaround__c = ViasatUtilityClass.TimeTextFormatting(c.ElapsedInterimREsolutionTotalSeconds__c);
                        /*Update Elapsed Initial Response provided time text formatting from ElaspedInitialResponseTotalseconds 
                          Actually if user directly provide the workaround means we should update Elapsed Initial response time and Elapsed workaround time, thats why we updating below*/
                        if(c.ElapsedTimeToInitialResponse__c == null)
                            c.ElapsedTimeToInitialResponse__c = ViasatUtilityClass.TimeTextFormatting(c.ElapsedInitialResponseTotalSeconds__c);    
                        //Newly modified on UAT NBNCoPortal 33 & NBNCoPortal 85
                        if(c.FinalResolutionClockState__c == 'Stop' || c.FinalResolutionClockState__c == 'Start')
                        {
                            c.FinalResolutionClockState__c = 'Running';
                            c.FinalResolutionStateModifiedDate__c = system.now(); //********
                        }           
                    }
                    if(c.Status == 'In Progress' && c.StatusDetails__c == 'Workaround Rejected') //Timers acting here at the stage of user reject the Workaround
                    {
                        if(c.ElapsedTimeToWorkaround__c == null) //If user provide workaround rejected having without workaround response means should error throw here.
                        {
                            c.StatusDetails__c.addError('Invalid action!'); 
                        }
                        else
                        {
                            if(c.InterimResolutionClockState__c != 'Running')
                            {
                                c.InterimResolutionClockState__c = 'Running'; 
                                c.InterimResolutionStateModifiedDate__c = system.now(); 
                            }  
                            //Newly modified for Unit testing bug found
                            if(c.FinalResolutionClockState__c == 'Stop')
                            {
                                c.FinalResolutionClockState__c = 'Running';
                                c.FinalResolutionStateModifiedDate__c = system.now(); 
                            }  
                        }   
                    }
                }
                //Clocks updated here if user provide the Final Resolution
                if(c.Status == 'Closed' || c.Status == 'Resolved') 
                {  
                    if(c.InitialResponseClockState__c != 'Stop')
                    {          
                        c.ElapsedInitialResponseTotalSeconds__c = c.ElapsedInitialResponseTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c,System.now());  
                        c.InitialResponseTotalInSeconds__c = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, System.now());         
                        c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InitialResponseTotalInSeconds__c); 
                    } 
                    c.InitialResponseClockState__c = 'Stop'; 
                    c.InitialResponseStateModifiedDate__c = system.now();
                    
                    if(c.InterimResolutionClockState__c != 'Stop')
                    {          
                        c.ElapsedInterimREsolutionTotalSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,System.now());  
                        c.InterimResolutionTotalInSeconds__c = c.InterimResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c, System.now());         
                        c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InterimResolutionTotalInSeconds__c); 
                    } 
                    c.InterimResolutionClockState__c = 'Stop'; 
                    c.InterimResolutionStateModifiedDate__c = system.now();
                    
                    if(c.FinalResolutionClockState__c != 'Stop')
                    {          
                        c.ElapsedFinalResolutionTotalSeconds__c   = c.ElapsedFinalResolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                        c.FinalResolutionTotalInSeconds__c = c.FinalResolutionTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, System.now());
                        c.FinalResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.FinalResolutionTotalInSeconds__c);      
                    } 
                    c.FinalResolutionClockState__c = 'Stop';
                    c.FinalResolutionStateModifiedDate__c = system.now();
                    //Update Elapsed Resolution provided time text formatting from ElapsedFinalResolutionTotalSeconds__c 
                    if(c.Status == 'Resolved')
                        c.ElapsedTimeToResolution__c = ViasatUtilityClass.TimeTextFormatting(c.ElapsedFinalResolutionTotalSeconds__c); 
                    /*Update Elapsed Resolution Response provided time text formatting from ElapsedFinalResolutionTotalSeconds__c 
                    Actually if user directly provide the Resolution means we should update Elapsed Initial response time and Elapsed Resolution time, thats why we updating below*/
                    if(c.ElapsedTimeToInitialResponse__c == null)
                        c.ElapsedTimeToInitialResponse__c = ViasatUtilityClass.TimeTextFormatting(c.ElapsedInitialResponseTotalSeconds__c);         
            }
        }
    }

    // It will be working for Before Insert event on Case trigger- 
    // This method helps to controlling Estimated timing for three clocks with SLA calculation, So whenever the case created the Estimated timings updated based on SLA timing which is fetching from SLA object
    // Input: 
    // lstcase: cases with RecordTypeName__c == 'Support Services NBN Co'
    // lstSLAs: SLA values from SLA object with respective account
/*   
	// obsolete -PL - Case Number - 282319
 
  public static void SetSLATimeFields(list<Case> lstcase, list<SLA__c> lstSLAs, List<BusinessHours> lstBh)
    {
        for(Case ca : lstcase)    
        {
            for(SLA__c sla : lstSLAs)
            {
                if (ca.AccountName__c == sla.AccountName__c || ca.ContactAccountID__c == sla.Account__c)
                {                       
                    if(ca.PrioritybasedonType__c == '1 - Critical')
                    {
                        //SLA timing Calculate if Priority as Critical and Type as Incident/Problem
                        if((ca.Type == 'Incident' || ca.Type == 'Problem') && sla.CaseType__c == 'Incident/Problem' && sla.CasePriority__c == 'Critical')
                        {                 
                            ca.EstimatedInitialResponseTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);               
                            ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c)));                             
                            ca.EstimatedWorkaroundTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);
                            ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c)));
                            ca.EstimatedResolutionTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);
                            ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c)));
                        }
                        //SLA timing Calculate if Priority as Critical and Type as Fault
                        else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault' && sla.CasePriority__c == 'Critical')
                        {
                        ca.EstimatedInitialResponseTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);              
                        ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c)));               
                        ca.EstimatedWorkaroundTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);                 
                        ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c)));                
                        ca.EstimatedResolutionTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);              
                        ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c)));             
                        }
                    }
                    else if(ca.PrioritybasedonType__c == '2 - Major')
                    {
                        //SLA timing Calculate if Priority as Major and Type as Incident/Problem
                        if((ca.Type == 'Incident' || ca.Type == 'Problem') && sla.CaseType__c == 'Incident/Problem' && sla.CasePriority__c == 'Major')
                        {
                        ca.EstimatedInitialResponseTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);           
                        ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c)));                 
                        ca.EstimatedWorkaroundTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);             
                        ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c)));       
                        ca.EstimatedResolutionTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);         
                        ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c)));             
                        }
                        //SLA timing Calculate if Priority as Major and Type as Fault
                        else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault' && sla.CasePriority__c == 'Major')
                        {
                        ca.EstimatedInitialResponseTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);           
                        ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c)));            
                        ca.EstimatedWorkaroundTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);   
                        ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c)));      
                        ca.EstimatedResolutionTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);         
                        ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c)));         
                        }
                    }
                    else if(ca.PrioritybasedonType__c == '3 - Minor')
                    {
                        //SLA timing Calculate if Priority as Minor and Type as Incident/Problem
                        if(ca.Type == 'Problem' && sla.CaseType__c == 'Problem' && sla.CasePriority__c == 'Minor')
                        {                
                        //With Bussiness hours: Convert from days to milliseconds                
                        Decimal milliseconds2 = Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c) * 86400000;                   
                        ca.EstimatedInitialResponseTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);   
                        ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c)));     
                        DateTime CalculateSecond = DateTime.valueOf(ca.EstimatedInitialResponseTime__c);
                        Integer start_second_as_int = CalculateSecond.second();
                        ca.EstimatedWorkaroundTime__c = BusinessHours.add(lstBh[0].id,system.now(),milliseconds2.longValue()); // For Bussiness hours calculation          
                        ca.EstimatedWorkaroundTime__c = ca.EstimatedWorkaroundTime__c.addSeconds(start_second_as_int);     
                        ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),ca.EstimatedWorkaroundTime__c);            
                        ca.EstimatedResolutionTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);               
                        ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c)));             
                        }
                        //SLA timing Calculate if Priority as Minor and Type as Fault
                        else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault' && sla.CasePriority__c == 'Minor')
                        {
                        //With Bussiness hours: Convert from days to milliseconds                
                        Decimal milliseconds2 = Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c) * 86400000;                   
                        ca.EstimatedInitialResponseTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);   
                        ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c)));     
                        DateTime CalculateSecond = DateTime.valueOf(ca.EstimatedInitialResponseTime__c);
                        Integer start_second_as_int = CalculateSecond.second();
                        ca.EstimatedWorkaroundTime__c = BusinessHours.add(lstBh[0].id,system.now(),milliseconds2.longValue()); // For Bussiness hours calculation          
                        ca.EstimatedWorkaroundTime__c = ca.EstimatedWorkaroundTime__c.addSeconds(start_second_as_int);     
                        ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),ca.EstimatedWorkaroundTime__c);            
                     
                        //as per the criteria Estimated Resolution Time = Case Creation + 20 business days 
                       // ca.EstimatedResolutionTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);               
                        ca.EstimatedResolutionTime__c = BusinessHours.add(lstBh[0].id,system.now(),(86400000*Integer.valueOf(Decimal.valueof(sla.ConvertedSLAResolutionTime__c)))); 
                        ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c)));             
                        }
                    }
                    else if(ca.PrioritybasedonType__c == '4 - Normal')
                    {
                        //SLA timing Calculate if Priority as Normal and Type as Technical Inquiry
                        if(ca.Type == 'Technical Inquiry' && sla.CaseType__c == 'Inquiry' && sla.CasePriority__c == 'Low')
                        {
                        ca.EstimatedInitialResponseTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);             
                        ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAInitialResponse__c)));                  
                        //ca.EstimatedWorkaroundTime__c = system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);                 
                        ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c)));               
                     
                        if(ca.SubSystem__c=='GSTB' || ca.SubSystem__c=='Remotes' || ca.SubSystem__c==Null){
                             ca.EstimatedResolutionTime__c = system.now().adddays(Integer.valueOf(Decimal.valueof(sla.ConvertedSLAResolutionTime__c))); }
                         
                        if(ca.SubSystem__c=='GW (Gateway)' || ca.SubSystem__c=='DPC (Data Processing Center)'){
                             ca.EstimatedResolutionTime__c = BusinessHours.add(lstBh[0].id,system.now(),(86400000*Integer.valueOf(Decimal.valueof(sla.ConvertedSLAResolutionTime__c)))); }  
                        
                        ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(System.now(),(system.now() + Decimal.valueof(sla.ConvertedSLAResolutionTime__c)));        
                        }                                       
                    }
                }
            }               
        }
    }

*/    
    
/*
    // It will be working for Before Update event on Case trigger- 
    // This method helps to controlling Estimated timing for three clocks with SLA calculation, So whenever the case created the Estimated timings updated based on SLA timing which is fetching from SLA object
    // Input: 
    // lstcase: cases with RecordTypeName__c == 'Support Services NBN Co'
    // lstSLAs: SLA values from SLA object with respective account  
    public static void UpdateSLATimeFields(list<Case> lstcase, Map<id,Case> oldmap, list<SLA__c> lstSLAs, List<BusinessHours> lstBh)
    {
        for(Case ca : lstcase)    
        {       
          if (ca.PrioritybasedonType__c != oldmap.get(ca.id).PrioritybasedonType__c || ca.Type != oldmap.get(ca.id).Type)
          {                      
            for(SLA__c sla : lstSLAs)
            {              
                if (ca.AccountName__c == sla.AccountName__c || ca.ContactAccountID__c == sla.Account__c)
                {                
                    if(ca.PrioritybasedonType__c == '1 - Critical')
                    {
                        //SLA timing Update if Priority as Critical and Type as Incident/Problem
                        if((ca.Type == 'Incident' || ca.Type == 'Problem') && sla.CaseType__c == 'Incident/Problem' && sla.CasePriority__c == 'Critical')
                        {
                        ca.EstimatedInitialResponseTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);         
                        ca.EstimatedWorkaroundTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);               
                        ca.EstimatedResolutionTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);             
                        }
                        //SLA timing Update if Priority as Critical and Type as Fault
                        else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault' && sla.CasePriority__c == 'Critical')
                        {
                        ca.EstimatedInitialResponseTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);                  
                        ca.EstimatedWorkaroundTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);                
                        ca.EstimatedResolutionTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);                  
                        }
                    }
                    else if(ca.PrioritybasedonType__c == '2 - Major')
                    {
                        //SLA timing Update if Priority as Major and Type as Incident/Problem
                        if((ca.Type == 'Incident' || ca.Type == 'Problem') && sla.CaseType__c == 'Incident/Problem' && sla.CasePriority__c == 'Major')
                        {
                        ca.EstimatedInitialResponseTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);                
                        ca.EstimatedWorkaroundTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);               
                        ca.EstimatedResolutionTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);                 
                        }
                        //SLA timing Update if Priority as Major and Type as Fault
                        else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault' && sla.CasePriority__c == 'Major')
                        {
                        ca.EstimatedInitialResponseTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);                 
                        ca.EstimatedWorkaroundTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);                   
                        ca.EstimatedResolutionTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);                   
                        }
                    }
                    else if(ca.PrioritybasedonType__c == '3 - Minor')
                    {
                        //SLA timing Update if Priority as Minor and Type as Incident/Problem
                        if(ca.Type == 'Problem' && sla.CaseType__c == 'Problem' && sla.CasePriority__c == 'Minor')
                        {
                        //With Bussiness hours: Convert from days to milliseconds                
                        Decimal milliseconds2 = Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c) * 86400000;                    
                        ca.EstimatedInitialResponseTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);                     
                        DateTime CalculateSecond = DateTime.valueOf(ca.EstimatedInitialResponseTime__c);
                        Integer start_second_as_int = CalculateSecond.second();
                        ca.EstimatedWorkaroundTime__c = BusinessHours.add(lstBh[0].id,ca.CreatedDate,milliseconds2.longvalue());// With Bussiness hours calculation
                        ca.EstimatedWorkaroundTime__c = ca.EstimatedWorkaroundTime__c.addSeconds(start_second_as_int);                                    
                        ca.EstimatedResolutionTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);                   
                        }
                        //SLA timing Update if Priority as Minor and Type as Fault
                       else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault' && sla.CasePriority__c == 'Minor')
                       {
                        //With Bussiness hours: Convert from days to milliseconds                
                        Decimal milliseconds2 = Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c) * 86400000;                   
                        ca.EstimatedInitialResponseTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);                  
                        
                        DateTime CalculateSecond = DateTime.valueOf(ca.EstimatedInitialResponseTime__c);
                        Integer start_second_as_int = CalculateSecond.second();
                        ca.EstimatedWorkaroundTime__c = BusinessHours.add(lstBh[0].id,ca.CreatedDate,milliseconds2.longvalue());// With Bussiness hours calculation
                        ca.EstimatedWorkaroundTime__c = ca.EstimatedWorkaroundTime__c.addSeconds(start_second_as_int);                    
                        
                        // TO DO: we should also be adding business hours for ResolutionTime according to ERS Contract. //Estimated Resolution Time? = Case Creation + 20 business days                                      
                        ca.EstimatedResolutionTime__c = BusinessHours.add(lstBh[0].id,system.now()+1,(86400000*20));                  
                      }
                    }
                    else if(ca.PrioritybasedonType__c == '4 - Normal')
                    {
                     system.debug('$$$$$$$$$$$$$3');
                        //SLA timing Update if Priority as Normal and Type as Technical Inquiry
                        if(ca.Type == 'Technical Inquiry' && sla.CaseType__c == 'Inquiry' && sla.CasePriority__c == 'Low')
                        {
                        ca.EstimatedInitialResponseTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAInitialResponse__c);                    
                        ca.EstimatedWorkaroundTime__c = ca.CreatedDate + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);              
                         
                        // TODO: If SubSystem = GSTB or Remotes then We should NOT add Business Hours. 
                        //       Else If SubSystem = GW (Gateway) or DPC (Data Processing Center) We should ADD Business Hours to ResolutionTime                        
                        if(ca.SubSystem__c=='GSTB' || ca.SubSystem__c=='Remotes' || ca.SubSystem__c==Null){
                             ca.EstimatedResolutionTime__c = system.now().adddays(Integer.valueOf(Decimal.valueof(sla.ConvertedSLAResolutionTime__c))); }
                         
                         system.debug('1111'+ca.EstimatedResolutionTime__c);
                        if(ca.SubSystem__c=='GW (Gateway)' || ca.SubSystem__c=='DPC (Data Processing Center)'){                        
                           ca.EstimatedResolutionTime__c = BusinessHours.add(lstBh[0].id,system.now()+1,(86400000*Integer.valueOf(Decimal.valueof(sla.ConvertedSLAResolutionTime__c)))); }  
                                                                             
                        }  
                                     
                    }
                }                  
            }
          }
        }
    }
*/    
   Public static Map<String,NBNCoKeyvalueStore__c> MapKeyValue= NBNCoKeyvalueStore__c.getAll();  
    //It will be working for After Update event on Case Trigger- It is basically for whenever the Status is equals to 'New' ,RMA Request Date\Time Not equals to Null
    //and Case Record Type equals to "support Services NBN Co'.
    //Updating Case Status as In Progress,Initial Response Provided At = RMA Request Date\Time and Steps to Follow = Process RMA based on Spare Details section.
    public static void AfterRMArequested(List<Case> lstcase,Map<id,Case> oldcase) 
    {     
     // the collection of custom setting "NBNCo KeyvalueStore"
     
      for(case ca:lstcase)
      {
        if(oldcase.get(ca.id).Status=='New' && ca.RMARequest__c!=Null)
        {
           ca.Status=MapKeyValue.get('InProgress').Value__c;
           ca.InitialResponseProvidedAt__c=ca.RMARequest__c;
           ca.Steps_to_Follow__c=MapKeyValue.get('StepstoFollow').Value__c;           
        }
      }    
    } 
   
   
   
 //Sneha Chail - created date - 11/19/2014 - Case Number - 282319   
 //Start *************************
 public static void SetSLATimeFields(list<Case> lstcase, list<SLA__c> lstSLAs, List<BusinessHours> lstBh, Boolean useCaseCreatedDate, dateTime inputTime, Boolean updateEstimatedTimes)
  {
            
        // 1 . map case to SLA
        map<case, SLA__c> caseToSLAMap = new map<case, SLA__c>();
        for(Case ca : lstcase)    
        {   
              
        	for(SLA__c sla : lstSLAs)
            {
            	Boolean found =false;	
            	
        		if (ca.AccountName__c == sla.AccountName__c || ca.ContactAccountID__c == sla.Account__c)
        		{
        			// Critical        		
        			if ((ca.PrioritybasedonType__c == '1 - Critical') && (sla.CasePriority__c == 'Critical'))
                    {
                        //SLA timing Calculate if Priority as Critical and Type as Incident/Problem
                        if((ca.Type == 'Incident' || ca.Type == 'Problem') && sla.CaseType__c == 'Incident/Problem')
                        	found=true;	        					
        				else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault')
        					found =true;
                    }
                    // Major
                    else if ((ca.PrioritybasedonType__c == '2 - Major') && (sla.CasePriority__c == 'Major'))
                    {
                    	if((ca.Type == 'Incident' || ca.Type == 'Problem') && sla.CaseType__c == 'Incident/Problem')	
                    		found=true;	
                    	else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault')
        					found =true;
                    }
                    // Minor 
        			else if ((ca.PrioritybasedonType__c == '3 - Minor') && 	(sla.CasePriority__c == 'Minor'))
        			{
        				 if(ca.Type == 'Problem' && sla.CaseType__c == 'Problem')
        				 	found=true;	
        				 else if(ca.Type == 'Fault' && sla.CaseType__c == 'Fault')
        				 	found =true;			        				
        			}
        			// Normal	
        			else if ((ca.PrioritybasedonType__c == '4 - Normal')  && (sla.CasePriority__c == 'Low'))
        			{
        				if(ca.Type == 'Technical Inquiry' && sla.CaseType__c == 'Inquiry')	
        					found =true;
        			}			
        			
        		}
        		
        		if (found == true)
        		{
        			// found a match	
        			caseToSLAMap.put(ca, sla);	
        			break;
        		}
        	
            }
        	
        }  
        
        // 2. Go thru map and update the timers
        for (Case ca : caseToSLAMap.Keyset())
        {
        	SLA__c sla = caseToSLAMap.get(ca);
        	dateTime baseTime=null;
        	if (useCaseCreatedDate)
                baseTime = (ca.createddate == null ? DateTime.now().addSeconds(2) : ca.createddate); // if requesting to use the createddate, the caller should make sure it is valid
            else 
            	// use the input time 
            	baseTime = inputTime;
            	    
                         
            System.assert(baseTime != null);  // baseTime should never be null.	
            
            dateTime EstimatedInitialResponseTime=null;
            dateTime EstimatedWorkaroundTime=null;
            dateTime EstimatedResolutionTime=null;
            
            // common values to all cases
            EstimatedInitialResponseTime = baseTime + Decimal.valueof(sla.ConvertedSLAInitialResponse__c); 
                        
            if (ca.PrioritybasedonType__c == '3 - Minor')
            {
            	// EstimatedWorkaroundTime
            	// EstimatedResolutionTime
            
            /*	
            	Decimal milliseconds2 = Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c) * 86400000; 
            	DateTime CalculateSecond = DateTime.valueOf(EstimatedInitialResponseTime); // !!!! after EstimatedInitialResponseTime
   				Integer start_second_as_int = CalculateSecond.second();
   				
   				EstimatedWorkaroundTime = BusinessHours.add(lstBh[0].id,baseTime,milliseconds2.longValue()); // For Bussiness hours calculation  
   				EstimatedWorkaroundTime = EstimatedWorkaroundTime.addSeconds(start_second_as_int);   
   			*/   				 				
 				EstimatedWorkaroundTime=ViasatUtilityClass.addBusinessDays(lstBh[0].id, baseTime, Integer.valueof(sla.ConvertedSLAWorkaroundTime__c));
 							   				   		    	
            	if (ca.Type == 'Fault')
            	{
                	//as per the criteria Estimated Resolution Time = Case Creation + 20 business days                	                           
                    // EstimatedResolutionTime = BusinessHours.add(lstBh[0].id,baseTime,(86400000*Integer.valueOf(Decimal.valueof(sla.ConvertedSLAResolutionTime__c)))); 
                    EstimatedResolutionTime=ViasatUtilityClass.addBusinessDays(lstBh[0].id, baseTime, Integer.valueof(sla.ConvertedSLAResolutionTime__c));
                    
             		
            	}
            	else 
            	{
            		EstimatedResolutionTime = baseTime + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);    // * default 
            	}   
            	
            	System.debug('EstimatedResolutionTime:' + EstimatedResolutionTime);         
            
          
            }
            else if (ca.PrioritybasedonType__c == '4 - Normal')
            {
            	// EstimatedWorkaroundTime: not calculated
            	// EstimatedResolutionTime
                                
                     
                if(ca.SubSystem__c=='GSTB' || ca.SubSystem__c=='Remotes' || ca.SubSystem__c==Null)
                {
                	EstimatedResolutionTime = baseTime.adddays(Integer.valueOf(Decimal.valueof(sla.ConvertedSLAResolutionTime__c))); 
                }
                         
                if(ca.SubSystem__c=='GW (Gateway)' || ca.SubSystem__c=='DPC (Data Processing Center)')
                {
                	// EstimatedResolutionTime = BusinessHours.add(lstBh[0].id,baseTime,(86400000*Integer.valueOf(Decimal.valueof(sla.ConvertedSLAResolutionTime__c)))); 
                	EstimatedResolutionTime=ViasatUtilityClass.addBusinessDays(lstBh[0].id, baseTime, Integer.valueof(sla.ConvertedSLAResolutionTime__c));
                	
                }  
            	
            } 
            else
			{	
			    // all other cases 
			    // EstimatedWorkaroundTime
            	// EstimatedResolutionTime
			                     	            
             	EstimatedWorkaroundTime = baseTime + Decimal.valueof(sla.ConvertedSLAWorkaroundTime__c);
             	EstimatedResolutionTime = baseTime + Decimal.valueof(sla.ConvertedSLAResolutionTime__c);                        
			}  
			
			
			// Proposed PL (determined the durations from the date-times using ViasatUtilityClass.secondsBetweenTwoDateTimes) 
			if (EstimatedInitialResponseTime != null)
			{
				// ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(baseTime,EstimatedInitialResponseTime);  
				ca.InitialResponseTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(baseTime,EstimatedInitialResponseTime);                				              				
			}	
			if (EstimatedWorkaroundTime != null)
			{	
	        	// ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(baseTime,EstimatedWorkaroundTime);
	        	ca.InterimResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(baseTime,EstimatedWorkaroundTime);
	      
	        	
			}
	        if (EstimatedResolutionTime != null)
	        {  
            	// ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(baseTime,EstimatedResolutionTime);  
            	ca.FinalResolutionTotalInSeconds__c = ViasatUtilityClass.secondsBetweenTwoDateTimes(baseTime,EstimatedResolutionTime);  
            
            	                             
	        }
	        
            if (updateEstimatedTimes)
            {
            	ca.EstimatedInitialResponseTime__c = EstimatedInitialResponseTime;
            	ca.EstimatedWorkaroundTime__c = EstimatedWorkaroundTime;
            	ca.EstimatedResolutionTime__c = EstimatedResolutionTime;            	
            }
            
            
            
        }    
             
        
    }
 //End *************************
 //Sneha Chail - created date - 11/20/2014 - Case Number - 282319   
 //Start *************************
   public static void BeforeInsertClock(List<Case> lstcase,Boolean useCaseCreatedDate, dateTime inputTime) 
   {
             
        for(Case c : lstcase)
        {
            dateTime baseTime=null;
            //if (useCaseCreatedDate && c.createddate == null)
            //	c.createddate = inputTime; // if using the createddate make sure it is not null	  
        	
            // use the createddate if requested (created date can be set thru api load).         
        	if (useCaseCreatedDate)
                baseTime = (c.createddate == null ? DateTime.now().addSeconds(2) : c.createddate); // if requesting to use the createddate, the caller should make sure it is valid
            else 
            	// use the input time 
            	baseTime = inputTime;
	
            System.debug ('baseTime:' + baseTime);
          	System.debug ('c.createddate:' + c.createddate);
            	            	    
                         
            System.assert(baseTime != null);  // baseTime should never be null.
                    
         
            /*Three timers going to 'Start' Stage Whenever the case create with Status as 'New'. 
             We have to capture current modified time to Each timer State modified Date(ex: InitialResponseStateModifiedDate__c) field*/
            if(c.Status == 'New')
            {
                c.InitialResponseClockState__c = 'Start';
                c.InitialResponseStateModifiedDate__c = baseTime;      
               
                c.InterimResolutionClockState__c = 'Start';
                c.InterimResolutionStateModifiedDate__c = baseTime;         
                    
                c.FinalResolutionClockState__c = 'Start'; 
                c.FinalResolutionStateModifiedDate__c = baseTime;
            }
            /*Three timers will be functioning whenever the case create with Status as 'In Progress' and Status Details as 'Initial Response Provided' 
            As per requirement at this stage InitialClock will be stopped, Workaround/Interim and Resolution clocks will be running,
            Three timers four different fields to maintain Each*/
            if(c.Status == 'In Progress' && c.StatusDetails__c == 'Initial Response Provided')
            {   
                c.ElapsedInitialResponseTotalSeconds__c = c.ElapsedInitialResponseTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, baseTime);//ElapsedInitialResponseTotalSeconds will be calculated for Displaying the Elapsed Time of Initial Response provided by the Viasat user.                 
                c.InitialResponseTotalInSeconds__c = c.InitialResponseTotalInSeconds__c - ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InitialResponseStateModifiedDate__c, baseTime);//InitialResponseTotalInseconds field helps to capturing the Total seconds difference between Current time and 'Initial Response timer' last modified date                     
                c.InitialResponseClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InitialResponseTotalInSeconds__c);//InitialResponseClockTime helps to display time formatting from InitialREsponseTotalInseconds__c                 
                c.InitialResponseClockState__c = 'Stop';//Here we are maintaining the Initial Response timer state                  
                c.InitialResponseStateModifiedDate__c = baseTime;//Whenever we change the Initial response Clock state then we should maintain the InitialResponseStateModifiedDate__c also
                    
                c.ElapsedInterimREsolutionTotalSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,baseTime);  
                c.InterimResolutionTotalInSeconds__c = c.ElapsedInterimREsolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.InterimResolutionStateModifiedDate__c,baseTime);   
                c.InterimResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.InterimResolutionTotalInSeconds__c); 
                c.InterimResolutionClockState__c = 'Running';
                c.InterimResolutionStateModifiedDate__c = baseTime;                
                    
                c.ElapsedFinalResolutionTotalSeconds__c = c.ElapsedFinalResolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c, baseTime);
                c.FinalResolutionTotalInSeconds__c = c.ElapsedFinalResolutionTotalSeconds__c + ViasatUtilityClass.secondsBetweenTwoDateTimes(c.FinalResolutionStateModifiedDate__c,baseTime);
                c.FinalResolutionClockTime__c = ViasatUtilityClass.TimeTextFormatting(c.FinalResolutionTotalInSeconds__c);      
                c.FinalResolutionClockState__c = 'Running';
                c.FinalResolutionStateModifiedDate__c = baseTime;                 
                //Update Elapsed Initial Response provided time text formatting from ElaspedInitialResponseTotalseconds 
                c.ElapsedTimeToInitialResponse__c = ViasatUtilityClass.TimeTextFormatting(c.ElapsedInitialResponseTotalSeconds__c);                     
            }
        }
    }
    
  //End *************************// 
    
}