Public class NBNCreateCaseAndRMA
{
/*  
  Public Case caseInput {get;set;}
  Public Id caseID {get;set;}   
  public  boolean setvalue{get;set;} 
  private String queryString;  
  Public String UserName{get;set;}
  private ApexPages.StandardController sController=null;  
    
  Public NBNCreateCaseAndRMA(ApexPages.StandardController controller) {
    // caseInput = (Case)Controller.getRecord(); 
     caseID=ApexPages.currentPage().getParameters().get('id');
     if(caseID==Null)
        {
         caseInput = (Case)Controller.getRecord();  
        }
     else
        {
        caseInput =[select id,CaseNumber,NetworkPicklist__c,SoftwareVersion__c,SubSystem__c,EstimatedInitialResponseTime__c,Steps_to_Follow__c,FirmwareVersion__c,ResolutionDescription__c,Priority,Type,AccountId,Status,ContactId,OwnerId,PrioritybasedonType__c,CustomerTicket__c,Origin,Subject,Description,recordtypeId,StatusDetails__c,AccountName__c,Location__c,ProductType__c,Redundant__c,SentEmail__c,AvailableonSite__c,DeliveryDateTime__c,DispatchTime__c,DispatchMethod__c,DispatchMethodDetails__c,RequestRMARequired__c,RMARequest__c,Comment__c,InitialResponseProvidedAt__c,ElapsedTimeToInitialResponse__c,CalloutStatus__c,CalloutStartTime__c,CalloutEndTime__c,
             Date_Needed_By__c,VisibleToCustomer__c,DeliveryDateTimeNotAvaiable__c,EstimatedWorkaroundTime__c,WorkaroundDescription__c,WorkaroundProvidedAt__c,EntitlementId,ElapsedTimeToWorkaround__c,EstimatedResolutionTime__c,ResolutionProvidedAt__c,ElapsedTimeToResolution__c 
            from Case where id=:caseID];   
        }    
     
     RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and Name='Support Services NBN Co' LIMIT 1];
     caseInput.RecordTypeId=rt.id; 
     UserName=UserInfo.getName();
     sController=controller;     
     }
  
  public void DispatchMethod()
        {           
           Integer year= caseInput.RMARequest__c.year();
           Integer month= caseInput.RMARequest__c.month();
           Integer days= caseInput.RMARequest__c.day(); 
          if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c==Null)
              { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDeliveryDateTime));                       
              } 
          if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c!=Null && caseInput.DispatchTime__c=='0.0 Days')
              {                  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNDeliveryDateTime));                 
              }           
          if(caseInput.DispatchMethod__c==system.label.ViaSatshipstoViaSattechoffsite)
               {
                   caseInput.DispatchMethodDetails__c=system.label.ViaSatTechsendsacknowledge;
               }
          else if(caseInput.DispatchMethod__c==system.label.ViaSatshipstoCustomer)
               {
                   caseInput.DispatchMethodDetails__c=system.label.CustomerTechsendsacknowledge;
               }
          else if(caseInput.DispatchMethod__c==system.label.ViaSatshipstoapickup)
               {
                   caseInput.DispatchMethodDetails__c=system.label.ViaSattechgoestopickup;
               }
          else if(caseInput.DispatchMethod__c==system.label.ViaSatlocationforCustomertech)
               {
                  caseInput.DispatchMethodDetails__c=system.label.Customersendsacknowledgereceipt;
               }
          else if(caseInput.DispatchMethod__c==system.label.ViaSatshipstothesite)
               {
                   caseInput.DispatchMethodDetails__c=system.label.OnSiteTechreceives;
               }
          else {
                    caseInput.DispatchMethodDetails__c='';
               }
        }      
   public void Redundant()
       {
        if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c==Null )
              { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDeliveryDateTime));                       
              } 
         if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c!=Null && caseInput.DispatchTime__c=='0.0 Days')
              {                  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNDeliveryDateTime));                 
              }
       
         if(caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement && caseInput.RequestRMARequired__c==false)
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNPleaseClickRequestRMA));             
            }                                               
       }     
      
   public void AvailableOnSite()
       { 
         caseInput.DispatchTime__c =0.0+' Days';
         
         if(caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement && caseInput.RequestRMARequired__c==false)
              {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNPleaseClickRequestRMA));             
              }                                               
         if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteyes && caseInput.RMARequest__c!=Null)
              {                
                 caseInput.DeliveryDateTime__c=caseInput.RMARequest__c;                                                        
                 Double DispatchTime = Double.valueOf(caseInput.DeliveryDateTime__c.getTime()) - Double.valueOf(caseInput.RMARequest__c.getTime()); 
                 Double DispatchTimedays = DispatchTime  / 1000;
                          DispatchTimedays  /= 60;
                          DispatchTimedays  /= 60;
                          DispatchTimedays  /= 24;
                Double days = Math.Floor(DispatchTimedays);              
                caseInput.DispatchTime__c =days+' Days';
                if(caseInput.DispatchTime__c!=Null)
                    {
                       caseInput.DispatchMethod__c=''; 
                    }
                if(caseInput.DispatchMethodDetails__c!=Null)
                    {
                       caseInput.DispatchMethodDetails__c='';
                    }
                 caseInput.DeliveryDateTimeNotAvaiable__c=Null;
              }
         if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.RMARequest__c!=Null)
             {                                               
              if(caseInput.DeliveryDateTimeNotAvaiable__c!=Null && caseInput.DeliveryDateTimeNotAvaiable__c.date()>caseInput.RMARequest__c.date()){               
                   //Double DispatchTime = Math.Floor((Double.valueOf(caseInput.DeliveryDateTime__c.getTime()) - Double.valueOf(caseInput.RMARequest__c.getTime())) / (1000.0*60.0*60.0));
                     Double DispatchTime = Double.valueOf(caseInput.DeliveryDateTimeNotAvaiable__c.getTime()) - Double.valueOf(caseInput.RMARequest__c.getTime());
                     Double DispatchTimedays = DispatchTime  / 1000;
                          DispatchTimedays  /= 60;
                          DispatchTimedays  /= 60;
                          DispatchTimedays  /= 24;
                     Double days = Math.Floor(DispatchTimedays);              
                     caseInput.DispatchTime__c =days+' Days';                     
                   }                                        
            }                       
       }   
   
   public void AdvanceReplacement()
      {
      try{                           
          if(caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement && caseInput.RequestRMARequired__c==false)
              {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNPleaseClickRequestRMA));             
              }                 
          } 
          
       catch (DMLException e){
                 ApexPages.addMessages(e);                                                   
              }  
        }    
     public PageReference SaveCaseonRequestRMA()
         {
            caseInput.RequestRMARequired__c=true;  
            caseInput.RMARequest__c=system.now(); 
            Integer year= caseInput.RMARequest__c.year();
            Integer month= caseInput.RMARequest__c.month();
            Integer days= caseInput.RMARequest__c.day();                                                       
            caseInput.Comment__c=system.label.NBNRequestforRMA+' '+month+'/'+days+'/'+year+' '+system.label.NBNAdvanceReplacementRMA;            
            try{
                insert caseInput;
                }
            catch(DMLException e)
             {
                ApexPages.addMessages(e);    
             }
            AvailableOnSite();    
            if(caseInput!=Null)
              {
                caseInput =[select id,CaseNumber,NetworkPicklist__c,SoftwareVersion__c,SubSystem__c,EstimatedInitialResponseTime__c,Steps_to_Follow__c,FirmwareVersion__c,ResolutionDescription__c,Priority,Type,AccountId,Status,ContactId,OwnerId,PrioritybasedonType__c,CustomerTicket__c,Origin,Subject,Description,recordtypeId,StatusDetails__c,AccountName__c,Location__c,ProductType__c,Redundant__c,SentEmail__c,AvailableonSite__c,DeliveryDateTime__c,DispatchTime__c,DispatchMethod__c,DispatchMethodDetails__c,RequestRMARequired__c,RMARequest__c,Comment__c,InitialResponseProvidedAt__c,ElapsedTimeToInitialResponse__c,CalloutStatus__c,CalloutStartTime__c,CalloutEndTime__c,
                 Date_Needed_By__c,VisibleToCustomer__c,DeliveryDateTimeNotAvaiable__c,EstimatedWorkaroundTime__c,WorkaroundDescription__c,WorkaroundProvidedAt__c,EntitlementId,ElapsedTimeToWorkaround__c,EstimatedResolutionTime__c,ResolutionProvidedAt__c,ElapsedTimeToResolution__c 
                from Case where id=:caseInput.Id];                  
               PageReference page = new PageReference('/apex/NBNCreateCaseAndRMA?Id='+caseInput.Id);            
               page.setRedirect(true);
            }            
            return null;                 
         }
     
      public PageReference doSendEmail(){     
             SaveCaseonRequestRMA();              
          //  nbndispatchontime?%26RecordType=01270000000Hn6AAAS&id=500S0000004Url4IAC        
            Integer year= caseInput.RMARequest__c.year();
            Integer month= caseInput.RMARequest__c.month();
            Integer days= caseInput.RMARequest__c.day();  
            Messaging.SingleEmailMessage mail =   new Messaging.SingleEmailMessage();   
            String[] toAddresses = new String[] {system.label.NBNCoDispatchMailId,'sneha.chail@nttdata.com'}; 
            //   String[] toAddresses = new String[] {'sneha.chail@nttdata.com'};   
               mail.setToAddresses(toAddresses);         
               mail.setSenderDisplayName(system.label.NBNViaSatTeam);
               string SubSystemandLocation;               
               
             if(caseInput.SubSystem__c!=Null)
                  {
                    SubSystemandLocation='--'+caseInput.SubSystem__c;
                  }                                                                                 
             if(caseInput.Location__c!=Null && SubSystemandLocation!=Null)
                  {
                    SubSystemandLocation=SubSystemandLocation+'--'+caseInput.Location__c;
                  }
                                                        
             if(SubSystemandLocation!=Null)
                  {               
                     mail.setSubject(system.label.NBNSFcase+':'+caseInput.CaseNumber+'–-'+caseInput.AccountName__c+''+SubSystemandLocation+'–-'+caseInput.Subject);
                  }
             else
                  {
                     mail.setSubject(system.label.NBNSFcase+':'+caseInput.CaseNumber+'–-'+caseInput.AccountName__c+'–-'+caseInput.Subject);
                  }
                    mail.setBccSender(false);
                    mail.setUseSignature(false);           
                    mail.setSaveAsActivity(false);
                String body = system.label.NBNRequestRMA+'<br/><br/><br/>';
                      body += system.label.RequestforanAdvance+' '+month+'/'+days+'/'+year+' '+system.label.NBNforSalesForce+'<br/><br/>';
                      body += System.label.NBNCaseDetails+'<br/>'; 
                      body += system.label.NBNCaseNumber+' '+caseInput.CaseNumber+'<br/>';                     
                      body += system.label.NBNAccountName+ ' '+caseInput.AccountName__c+'<br/>';
                     if(caseInput.SubSystem__c!=Null)
                      {
                      body += system.label.NBNSubSystem+' '+caseInput.SubSystem__c+'<br/>';
                      } 
                     else
                     {
                     body += system.label.NBNSubSystem+' '+system.label.NBNNotDefined+'<br/>';
                     }           
                    if(caseInput.Location__c!=Null)
                     {
                      body += System.label.NBNLocation+' '+caseInput.Location__c+'<br/>';  
                     } 
                    else
                     {
                      body += System.label.NBNLocation+' '+system.label.NBNNotDefined+'<br/>';  
                     }  
                      body += system.label.NBNSubject+' '+caseInput.Subject+'<br/><br/><br/>';                       
                      body += System.label.NBNThanks+'<br/>'; 
                      body += System.label.NBNViaSatSupportServices+'<br/>';       
                      mail.setHtmlBody(body);              
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                
            AvailableOnSite();  
            PageReference page = new PageReference('/apex/NBNCreateCaseAndRMA?Id='+caseInput.Id);            
            page.setRedirect(true);
            return page;                  
        }
      
  public PageReference saveCase() {                  
          try{              
              if(caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement && caseInput.RequestRMARequired__c==false)
                 {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNPleaseClickRequestRMA)); 
                   return null;
                 }             
             
             else if(caseInput.AvailableonSite__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                 {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.PleaseSelectAvailableonSite)); 
                   return null;
                 }
             else if(caseInput.Redundant__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                 {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectRedundant));
                    return null;           
                 }
            else if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c==Null)
                  { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDeliveryDateTime)); 
                    return null;          
                  } 
             else if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c!=Null && caseInput.DispatchTime__c=='0.0 Days')
                  {                  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNDeliveryDateTime));                    
                    return null;          
                  }       
             else if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.DispatchMethod__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                  { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDispatchMethod)); 
                    return null;          
                  }   
             else if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.DispatchMethodDetails__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)  
                  { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.DispatchMethodDetailwillbeautomaticallypopulated)); 
                    return null;          
                  } 
                    caseInput.SentEmail__c=true;  
                    if(caseInput!=Null)
                    {
                      Update caseInput; 
                    }
                    else
                    {
                     insert caseInput;
                    } 
                    caseInput =[select id,CaseNumber,NetworkPicklist__c,SoftwareVersion__c,SubSystem__c,EstimatedInitialResponseTime__c,Steps_to_Follow__c,FirmwareVersion__c,ResolutionDescription__c,Priority,Type,AccountId,Status,ContactId,OwnerId,PrioritybasedonType__c,CustomerTicket__c,Origin,Subject,Description,recordtypeId,StatusDetails__c,AccountName__c,Location__c,ProductType__c,Redundant__c,SentEmail__c,AvailableonSite__c,DeliveryDateTime__c,DispatchTime__c,DispatchMethod__c,DispatchMethodDetails__c,RequestRMARequired__c,RMARequest__c,Comment__c,InitialResponseProvidedAt__c,ElapsedTimeToInitialResponse__c,CalloutStatus__c,CalloutStartTime__c,CalloutEndTime__c,
                                Date_Needed_By__c,VisibleToCustomer__c,DeliveryDateTimeNotAvaiable__c,EstimatedWorkaroundTime__c,WorkaroundDescription__c,WorkaroundProvidedAt__c,EntitlementId,ElapsedTimeToWorkaround__c,EstimatedResolutionTime__c,ResolutionProvidedAt__c,ElapsedTimeToResolution__c 
                                from Case where id=:caseInput.Id];                 
                    return (new ApexPages.StandardController(caseInput)).view();                            
             }
           catch (DMLException e){
                 ApexPages.addMessages(e);  
                 return null;                                  
              } 
          }  
    public PageReference saveclose() { 
           try{ 
               if(caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement && caseInput.RequestRMARequired__c==false)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.NBNPleaseClickRequestRMA)); 
                     return null;
                   }      
               if(caseInput.AvailableonSite__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                   {
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectAvailableonSite)); 
                     return null;
                   }
               if(caseInput.Redundant__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                   {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectRedundant));
                    return null;           
                   }
              if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c==Null)
                  { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDeliveryDateTime)); 
                    return null;          
                  } 
              if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c!=Null && caseInput.DispatchTime__c=='0.0 Days')
                  {                  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNDeliveryDateTime));                    
                    return null;          
                  }         
              if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.DispatchMethod__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                   { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDispatchMethod)); 
                    return null;          
                   }   
              if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.DispatchMethodDetails__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)  
                   { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.DispatchMethodDetailwillbeautomaticallypopulated)); 
                    return null;          
                   }  
                    caseInput.SentEmail__c=true;  
              if(caseInput!=Null)
                    {
                      Update caseInput; 
                    }
                    else
                    {
                     insert caseInput;
                    } 
                    caseInput =[select id,CaseNumber,NetworkPicklist__c,SoftwareVersion__c,SubSystem__c,EstimatedInitialResponseTime__c,Steps_to_Follow__c,FirmwareVersion__c,ResolutionDescription__c,Priority,Type,AccountId,Status,ContactId,OwnerId,PrioritybasedonType__c,CustomerTicket__c,Origin,Subject,Description,recordtypeId,StatusDetails__c,AccountName__c,Location__c,ProductType__c,Redundant__c,SentEmail__c,AvailableonSite__c,DeliveryDateTime__c,DispatchTime__c,DispatchMethod__c,DispatchMethodDetails__c,RequestRMARequired__c,RMARequest__c,Comment__c,InitialResponseProvidedAt__c,ElapsedTimeToInitialResponse__c,CalloutStatus__c,CalloutStartTime__c,CalloutEndTime__c,
                                Date_Needed_By__c,VisibleToCustomer__c,DeliveryDateTimeNotAvaiable__c,EstimatedWorkaroundTime__c,WorkaroundDescription__c,WorkaroundProvidedAt__c,EntitlementId,ElapsedTimeToWorkaround__c,EstimatedResolutionTime__c,ResolutionProvidedAt__c,ElapsedTimeToResolution__c 
                                from Case where id=:caseInput.Id];  
                                                  
                    PageReference newPage;
                    newPage = new PageReference('/' +caseInput.Id+'/s?retURL='+caseInput.Id);                   
                    return newPage.setRedirect(true);            
              }
              catch (DMLException e) {  
                 ApexPages.addMessages(e);
                 return null;                                  
                } 
           }    
       public PageReference doSaveAndNew() { 
             try{ 
                 if(caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement && caseInput.RequestRMARequired__c==false)
                     {
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.NBNPleaseClickRequestRMA)); 
                          return null;
                      }            
                 if(caseInput.AvailableonSite__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                     {
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.PleaseSelectAvailableonSite)); 
                         return null;
                     }
                 if(caseInput.Redundant__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                     {
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectRedundant));
                         return null;           
                     }
                if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c==Null)
                  { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDeliveryDateTime)); 
                    return null;          
                  } 
               if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c!=Null && caseInput.DispatchTime__c=='0.0 Days')
                  {                  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNDeliveryDateTime));                    
                    return null;          
                  }           
                 if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.DispatchMethod__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)
                     { 
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDispatchMethod)); 
                         return null;          
                      }   
                 if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.DispatchMethodDetails__c==Null && caseInput.StatusDetails__c==system.label.NbnAdvanceReplacement)  
                      { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.DispatchMethodDetailwillbeautomaticallypopulated)); 
                    return null;          
                      }  
                    caseInput.SentEmail__c=true;                     
                    upsert caseInput;                   
                    caseInput =[select id,CaseNumber,NetworkPicklist__c,SoftwareVersion__c,SubSystem__c,EstimatedInitialResponseTime__c,Steps_to_Follow__c,FirmwareVersion__c,ResolutionDescription__c,Priority,Type,AccountId,Status,ContactId,OwnerId,PrioritybasedonType__c,CustomerTicket__c,Origin,Subject,Description,recordtypeId,StatusDetails__c,AccountName__c,Location__c,ProductType__c,Redundant__c,SentEmail__c,AvailableonSite__c,DeliveryDateTime__c,DispatchTime__c,DispatchMethod__c,DispatchMethodDetails__c,RequestRMARequired__c,RMARequest__c,Comment__c,InitialResponseProvidedAt__c,ElapsedTimeToInitialResponse__c,CalloutStatus__c,CalloutStartTime__c,CalloutEndTime__c,
                                Date_Needed_By__c,VisibleToCustomer__c,DeliveryDateTimeNotAvaiable__c,EstimatedWorkaroundTime__c,WorkaroundDescription__c,WorkaroundProvidedAt__c,EntitlementId,ElapsedTimeToWorkaround__c,EstimatedResolutionTime__c,ResolutionProvidedAt__c,ElapsedTimeToResolution__c 
                                from Case where id=:caseInput.Id];  
                    string saveNew=system.label.NBNCaseCloseUrl+ ('' + caseInput.get('Id')).subString(0, 3) +system.label.NBNSaveNewURL+('' + caseInput.get('Id')).subString(0, 3) +system.label.NBNreURL+('' + caseInput.get('Id')).subString(0, 3) + '/o';
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, saveNew));
                    return new Pagereference(saveNew);                                   
             }
         catch (DMLException e) { 
           ApexPages.addMessages(e); 
           return null;                                  
          } 
     }    
  public PageReference doCancel()
      {
       if(caseInput.RequestRMARequired__c==true && caseInput.Redundant__c==Null && caseInput.Comment__c!=Null && caseInput.SentEmail__c==false)
            {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.NBNCancelRedundant)); 
              return null;
            }  
         else if(caseInput.RequestRMARequired__c==true && caseInput.AvailableonSite__c==Null && caseInput.Comment__c!=Null && caseInput.SentEmail__c==false)
            {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.NBNCancelAvailableOnSite)); 
              return null;
            } 
         else if(caseInput.RequestRMARequired__c==true && caseInput.AvailableonSite__c=='Yes' && caseInput.Comment__c!=Null && caseInput.SentEmail__c==false)
            {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'As Request for RMA was submitted,Please click Save button for further process.')); 
              return null;
            }      
         else if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c==Null)
              { 
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.PleaseSelectDeliveryDateTime)); 
                 return null;          
              } 
         else if(caseInput.AvailableonSite__c ==system.label.NbnAvailablesiteNo && caseInput.status=='Resolved' && caseInput.DeliveryDateTimeNotAvaiable__c!=Null && caseInput.DispatchTime__c=='0.0 Days')
           {                  
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+system.label.NBNDeliveryDateTime));                    
               return null;          
           }            
         else if(caseInput.RequestRMARequired__c==true && caseInput.DispatchMethod__c==Null  && caseInput.Comment__c!=Null && caseInput.SentEmail__c==false)
            {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, +system.label.NBNCancelDispatchMethod)); 
              return null;
            } 
        else if(caseInput.SentEmail__c==false && caseInput.RequestRMARequired__c==true)
            {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'As Request for RMA was submitted,Please click Save button for further process.')); 
              return null;
            }  
            PageReference newPage;
            newPage = new PageReference('/500/o');                   
            return newPage.setRedirect(true);            
          } 
*/              
   }