public with sharing class SNGTerminalHelpText 
{
    public String statusHelpText {
        get {
            return Terminal__c.Status__c.getDescribe().getInlineHelpText();
        }
    }
    
    public String onlineTimeHelpText {
        get {
            return Terminal__c.OnlineTime__c.getDescribe().getInlineHelpText();
        }
    }
    
    public String billingCycleHelpText {
        get {
            return 'Select the billing cycle for which you would like to view usage details.';
        }
    }
    
    public String bytesDownloadedHelpText {
        get {
            return 'Bytes downloaded during the selected billing cycle.';
        }
    }
    
    public String bytesUploadedHelpText {
        get {
            return 'Bytes uploaded during the selected billing cycle.';
        }
    }
    
    public String billingCycleStartDateHelpText {
        get {
            return 'Start date of selected billing cycle.';
        }
    }
    
    public String dataAsOfHelpText {
        get {
            return 'The date/time the usage data was last updated.';
        }
    }
    
    public String chartHelpText {
        get {
            return 'Use cursor to zoom plot. Double-click on plot to restore.';
        }
    }
    
    public String networkHelpText {
        get {
        	// NOTE: The call to SNG_TerminalQuery was needed here to get the current value of the traffic light
        	//       because it may have been updated since our terminal object was instantiated.
            transient String pHelpText = '';
            transient SNGTerminalStatusLight.DotColor dot = getDotColor(SNG_TerminalQuery.getNetworkTrafficLight(terminal.Id));
            if (SNGTerminalStatusLight.DotColor.GREEN == dot) {
                pHelpText = 'The network is up.';
            } else if (SNGTerminalStatusLight.DotColor.RED == dot) {
                pHelpText = 'We are currently experiencing a network outage in your terminal’s region.';
            }
            return pHelpText;
        }
    }
    
    public String weatherHelpText {
        get {
        	// NOTE: The call to SNG_TerminalQuery was needed here to get the current value of the traffic light
        	//       because it may have been updated since our terminal object was instantiated.
            transient String pHelpText = '';
            transient SNGTerminalStatusLight.DotColor dot = getDotColor(SNG_TerminalQuery.getWeatherTrafficLight(terminal.Id));
            if (SNGTerminalStatusLight.DotColor.GREEN == dot) {
                pHelpText = 'No weather related effects detected.';
            } else if (SNGTerminalStatusLight.DotColor.YELLOW == dot) {
                pHelpText = 'A minor weather related performance degradation is suspected. If the condition persists or you have verified that there isn’t inclement weather at this time, please contact your service provider.';
            } else if (SNGTerminalStatusLight.DotColor.RED == dot) {
                pHelpText = 'A severe weather related performance degradation is suspected. If the condition persists or you have verified that there isn’t inclement weather at this time, please contact your service provider.';
            }
            return pHelpText;
        }
    }
    
    public String performanceHelpText {
        get {
        	// NOTE: The call to SNG_TerminalQuery was needed here to get the current value of the traffic light
        	//       because it may have been updated since our terminal object was instantiated.
            transient String pHelpText = '';
            transient SNGTerminalStatusLight.DotColor dot = getDotColor(SNG_TerminalQuery.getPerformanceTrafficLight(terminal.Id));
            if (SNGTerminalStatusLight.DotColor.GRAY == dot) {
                pHelpText = 'Terminal is offline.';
            } else if (SNGTerminalStatusLight.DotColor.GREEN == dot) {
                pHelpText = 'Terminal is performing as expected.';
            } else if (SNGTerminalStatusLight.DotColor.RED == dot) {
                pHelpText = 'Terminal is experiencing degraded performance, please contact your service provider.';
            } else if (SNGTerminalStatusLight.DotColor.YELLOW == dot) {
                pHelpText = 'Terminal is experiencing some performance degradation.';
            }
            return pHelpText;
        }
    }
    
    public String pointingHelpText {
        get {
        	// NOTE: The call to SNG_TerminalQuery was needed here to get the current value of the traffic light
        	//       because it may have been updated since our terminal object was instantiated.
            transient String pHelpText = '';
            transient SNGTerminalStatusLight.DotColor dot = getDotColor(SNG_TerminalQuery.getPointingTrafficLight(terminal.Id));
            if (SNGTerminalStatusLight.DotColor.GREEN == dot) {
                pHelpText = 'Terminal is pointed correctly.';
            } else if (SNGTerminalStatusLight.DotColor.YELLOW == dot) {
                pHelpText = 'Terminal may be slightly mispointed. If condition persists and performance is unsatisfactory, contact your service provider.';
            } else if (SNGTerminalStatusLight.DotColor.RED == dot) {
                pHelpText = 'Terminal may be mispointed. If condition persists, contact your service provider.';
            } else if (SNGTerminalStatusLight.DotColor.GRAY == dot) {
                pHelpText = 'Terminal is offline.';
            }
            return pHelpText;
        }
    }
    
    private Terminal__c terminal;
    
    
    /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
    public SNGTerminalHelpText(ApexPages.StandardController controller)
    {
        terminal = (Terminal__c)controller.getRecord();
    }

    public static SNGTerminalStatusLight.DotColor getDotColor(String fieldValue) {
        
        return SNGTerminalStatusLight.getDotColor(fieldValue);
    }
}