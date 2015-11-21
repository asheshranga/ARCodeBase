public class CaseResolution {
    ApexPages.StandardController controller;

    private final Case c;
    
    public String result {get { return result;} set;}
    public Integer errorCode { get {return (errorCode == null) ? 0:errorCode;} set;} 
           
    public List<Resolution__c> resolutions {get{ return resolutions;}set;}
	private map<decimal,list<resolution__c>> caseProductResolutions;

    private final String userTimeZone;
    
    public String startTimeZone;
    public String getstartTimeZone() {return startTimeZone;}   
    public void setstartTimeZone(String t) {this.startTimeZone= t;}
    
    public String endTimeZone;
    public String getendTimeZone() {return endTimeZone;}   
    public void setendTimeZone(String t) {this.endTimeZone= t;}
    
    public String level1ResCode;    
    public String getlevel1ResCode() {return level1ResCode;}   
    public void setlevel1ResCode(String r) {this.level1ResCode = r;}
    
    public String level2ResCode;
    public String getlevel2ResCode() {return level2ResCode;}   
    public void setlevel2ResCode(String r) {this.level2ResCode = r;}

    public String level3ResCode;
    public String getlevel3ResCode() {return level3ResCode;}   
    public void setlevel3ResCode(String r) {this.level3ResCode = r;}
    
    public String resCode;
    public String getresCode() {return resCode;}   
    public void setresCode(String r) {this.resCode = r;}
    
    public Integer resultSize {get { return resultSize;} set;}
    	
    //---Initialize the controller    
    public CaseResolution (ApexPages.StandardController stdController) 
    {
        controller = stdController;
        c = (Case)controller.getRecord();
        
        if (c.status == 'Resolved' || c.status == 'Closed') 
        {
           errorCode = 1;
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Can\'t resolve the case. Case has been ' + c.status + ' already.'));
        } 
        else 
        {
           c.status = 'Resolved';
           c.statusdetails__c = null;
        
           this.level1ResCode = c.ResolutionCodeLevel1__c;        
           this.level2ResCode = c.ResolutionCodeLevel2__c; 
           this.level3ResCode = c.ResolutionCodeLevel3__c; 
           
           resultSize = 0;
        
           User loUser = [select id, name, TimeZoneSidKey from user where id =:UserInfo.getUserId()];
        
           userTimeZone = loUser.TimeZoneSidKey;

           startTimeZone = userTimeZone;
           endTimeZone   = userTimeZone; 
                      
			getResCodes(); 
       }
    }

    public List<SelectOption> level1ResCodes {
	get {
		if (level1ResCodes == null) {
			level1ResCodes = new List<SelectOption>();
			level1ResCodes.add(new SelectOption('', '--None--'));
system.debug('*** caseProductResolutions.get(1): ' + caseProductResolutions.get(1));
			if (caseProductResolutions.get(1) != null)
				for (Resolution__c r : caseProductResolutions.get(1)){
	           		level1ResCodes.add(new SelectOption(r.id, r.name));
				}
		}
		return level1ResCodes; 
	}
	set;
    }
  
    public List<SelectOption> level2ResCodes {
	get {
       //if (level2ResCodes == null) {
		level2ResCodes = new List<SelectOption>();
		level2ResCodes.add(new SelectOption('', '--None--'));
		list<resolution__c> rss = caseProductResolutions.get(2);
		if (rss != null && level1ResCode != null && level1ResCode != '')
			for (Resolution__c r : rss){ 
				if (r.parent__c != null && r.parent__r.id == level1ResCode)                  
					level2ResCodes.add(new SelectOption(r.id, r.name));
			}
		return level2ResCodes; 
	}
	set;
    }

    public List<SelectOption> level3ResCodes {
	get {
       //if (level3ResCodes == null) {
		level3ResCodes = new List<SelectOption>();
		level3ResCodes.add(new SelectOption('', '--None--'));
		list<resolution__c> rss = caseProductResolutions.get(3);
		if (rss != null && level2ResCode != null && level2ResCode != '')
			for (Resolution__c r : rss){ 
				if (r.parent__c != null && r.parent__r.id == level2ResCode)                  
					level3ResCodes.add(new SelectOption(r.id, r.name));
			}   
		return level3ResCodes; 
	}
	set;
	}
             
    //--- Used for refreshing the Level 2 and Level 3 resolution codes based on level 1 and 2 selection    
    public void refreshResCodes() {
       String level = Apexpages.currentPage().getParameters().get('level');
       if (level=='3') {
         //--- Do Nothing...
         //--- Refresh is called so that controller can set the level3ResCode on user selection
       } else {
         this.level3ResCodes = null;
         this.level3ResCode = '';                 
         if (level=='1') {
           this.level2ResCodes = null;
           this.level2ResCode = '';
         }
       }
    }      

    //--- Used for refreshing the Level 2 and Level 3 resolution codes based on level 1 and 2 selection    
    public void searchResCodes() {
       String lsResCode = '%' + this.resCode + '%';
       resolutions = [select id,name,level__c,product__c,parent__c, parent__r.id, parent__r.name, parent__r.parent__r.id
                        from resolution__c
                       where product__c = :c.productid 
                         and name like :lsResCode
                         and active__c = true
                         and (parent__r.active__c = true
                              or parent__r.id = null)               
                         order by level__c desc];
       resultSize = resolutions.size();
    } 

    public void getResCodes() {
		list<resolution__c> res = [select id, name, level__c, product__c, parent__c, parent__r.id, parent__r.name, parent__r.parent__r.id, parent__r.active__c
                                           from resolution__c
                                          where product__c = :c.productid 
                                            and (parent__r.id = null or parent__r.active__c = true)
                                            and active__c = true order by name];  
			
		caseProductResolutions = new map<decimal,list<resolution__c>>();
		for (resolution__c r : res)
		{
			list<resolution__c> ress = caseProductResolutions.get(r.level__c);
			if (ress == null)
				ress = new list<resolution__c>();
			ress.add(r);
			caseProductResolutions.put(r.level__c, ress);
		}
    }
    
   //--- This method will be used to convert the date entered by the user
   //--- if the time zone selected is different from user time zone
   //--- Time Zone label is of the following format:
   //---   (GMT-07:00) Pacific Daylight Time (America/Los_Angeles)
   //--- We will parse the above label to get the offset in minutes
   //---    In the above case, the value returned will be -420 using the formula -07*60 + 00 
   Private Integer getoffsetMinutes(String asTimeZone) {
      Integer liReturn = 0;
      for (SelectOption s:timeZones) {
         if (s.getValue() == asTimeZone) {
            String lsLabel = s.getLabel();
            lsLabel = lsLabel.substring(lsLabel.indexOf('GMT')+3,lsLabel.indexOf(')'));
            liReturn = integer.valueOf(lsLabel.substring(0,lsLabel.indexOf(':'))) * 60 + integer.valueOf(lsLabel.substring(lsLabel.indexOf(':') + 1,lsLabel.length()));           
         }
      }
      
      return liReturn;
   }
   
   //--- Set the resolution codes, based on selected res code from search results
   public void setResCodes() {
      level1ResCode = '';
      level2ResCode = '';
      level3ResCode = '';
      String lsResCode = Apexpages.currentPage().getParameters().get('selectedResCode');
      for (Resolution__c r:resolutions) {
         if (r.id == lsResCode) {
            if (r.level__c == 1) {
               level1ResCode = r.id;
               level2ResCodes = null;
               level3ResCodes = null;
            } else if (r.level__c == 2) {
               level1ResCode = r.parent__r.id;
               level2ResCode = r.id;
               level3ResCodes = null;
            } else {
               level1ResCode = r.parent__r.parent__r.id;
               level2ResCode = r.parent__r.id;
               level3ResCode = r.id;            
               level2ResCodes = null;
               level3ResCodes = null;
            }
         }
      } 
   }
        
	//---Resolve the case based on the resolution code and Outtage Times provided    
	public PageReference resolveCase() 
	{ 
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Resove Case In Progress...' + this.level3ResCode + ' - ' + this.level2ResCode + ' - ' + this.level1ResCode));

        Map<String,String> req = ApexPages.currentPage().getParameters();
           
        result = '';
        
        //--- Update the non standard field that are part of the page
        //--- Set the resolution codes
        c.ResolutionCodeLevel1__c = null;
        if (this.level1ResCode!=null && this.level1ResCode!='')
           c.ResolutionCodeLevel1__c = this.level1ResCode;
           
		c.ResolutionCodeLevel2__c = null;           
        if (this.level2ResCode!=null && this.level2ResCode!='')   
          c.ResolutionCodeLevel2__c = this.level2ResCode;                    
 
		c.ResolutionCodeLevel3__c = null;
        if (this.level3ResCode!=null && this.level3ResCode!='')    
          c.ResolutionCodeLevel3__c = this.level3ResCode; 
        
        //--- If the Time Zone specified is different from User Time Zone, 
        //--- convert the date entered into User Time Zone by adding the time difference between 2 offsets
        //--- (Offset of User Time Zone) - (Offset of Date Entered Time Zone)
        if (userTimeZone != startTimeZone) 
           c.eventstarttime__c = c.eventstarttime__c.addMinutes(getoffsetMinutes(userTimeZone) - getoffsetMinutes(startTimeZone));
        
        if (userTimeZone != endTimeZone) 
           c.eventendtime__c = c.eventendtime__c.addMinutes(getoffsetMinutes(userTimeZone) - getoffsetMinutes(endTimeZone));        
                             
        try {
           update c;
           //controller.save();
        } catch (DMLException e) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to resolve the case - Error: ' + e.getDMLMessage(0)));
           return null;
        } catch (exception e1) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to resolve the case - Error: ' + e1.getMessage()));
           return null;
        }
         
        errorCode = 0;                  
        result = 'Successfully resolved the case to the following support person.';
        
        PageReference caseURL = new PageReference('/'+c.id);
        return caseURL.setRedirect(true);        
    }
    
    // use apex describe to build the picklist values
    public List<SelectOption> timeZones{
      get {
        if (timeZones== null) {
 
          timeZones = new List<SelectOption>();
          Schema.DescribeFieldResult field = user.TimeZoneSidKey.getDescribe();
 
          for (Schema.PicklistEntry f : field.getPicklistValues())
            timeZones.add(new SelectOption(f.getValue(),f.getLabel()));
        }
        return timeZones;          
      }
      set;
   }
}