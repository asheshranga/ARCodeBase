public with sharing class SNG_TerminalQuery {
	
	/**
     * A constant string to use when updating objects with an UNABLE TO LOAD error.
     */
	public static final String UNABLE_TO_LOAD = 'Unable to load';
	
    private Terminal__c terminal;
        
    /**
     * This constructor is used to create an instance of the object. The constructor is
     * required due to usage by the Visualforce page corresponding to this class.
     *
     * @param  controller       The pre-built Visualforce controller for the terminal object.
     */
    public SNG_TerminalQuery(ApexPages.StandardController controller)
    {
        terminal = (Terminal__c)controller.getRecord();   
    }
    
    // These properties only contain get's. They are used by the SNGTerminalDetail page.
    public String statusTrafficLight { get { return getStatusTrafficLight(terminal.Id); } }
    public String performanceTrafficLight { get { return getPerformanceTrafficLight(terminal.Id); } }
    public String networkTrafficLight { get { return getNetworkTrafficLight(terminal.Id); } }
    public String weatherTrafficLight { get { return getWeatherTrafficLight(terminal.Id); } }
    public String onlineTimeTrafficLight { get { return getOnlineTimeTrafficLight(terminal.Id); } }
    public String pointingTrafficLight { get { return getPointingTrafficLight(terminal.Id); } }
    
    public static String getStatusTrafficLight(Id terminalId)
    {
         try {
         	Terminal__c queriedTerminal = [SELECT Pointing__c, Performance__c, OnlineTime__c FROM Terminal__c WHERE Id = :terminalId];
	     	queriedTerminal = setStatusTrafficLightInTerminal(queriedTerminal);
	     	update queriedTerminal;
	     	return queriedTerminal.StatusBackEnd__c;
         } catch (Exception e) {
         	final String errorMessage = 'Error retrieving Status light value for terminal Id ' + terminalId + '.\n'
         	                          + e.getMessage() + '\n' + e.getStackTraceString();
         	throw new SNG_Exception(errorMessage);
         }
    }
    
    public static Terminal__c setStatusTrafficLightInTerminal(Terminal__c terminal) {
    	 try {
         	String statusLightText = isTerminalOnline(terminal) ? worsePerformingStatusLight(terminal.Pointing__c, terminal.Performance__c) : 
    	 	                                                      getOfflineStatusLightColor(); 
         	
         	terminal.StatusBackEnd__c = statusLightText;
         	return terminal;
         } catch (Exception e) {
         	String errorMessage;
         	
         	if (null != terminal) {
         		errorMessage = 'Error setting Status light value for terminal ' + terminal + '.\n'
         	                 + e.getMessage() + '\n' + e.getStackTraceString();
         	} else {
         		errorMessage = 'Error setting Status light value for null terminal.\n'
         	                 + e.getMessage() + '\n' + e.getStackTraceString();
         	}
         	
         	throw new SNG_Exception(errorMessage);
         }
    }
    
    public static String getPerformanceTrafficLight(Id terminalId) {
         try {
         	Terminal__c queriedTerminal = [SELECT Performance__c, OnlineTime__c FROM Terminal__c WHERE Id = :terminalId];
         	return isTerminalOnline(queriedTerminal) ? getStatusLight(queriedTerminal.Performance__c) : getOfflineStatusLightColor();
         } catch (Exception e) {
         	final String errorMessage = 'Error retrieving Performance light value for terminal Id ' + terminalId + '.\n'
         	                          + e.getMessage() + '\n' + e.getStackTraceString();
         	throw new SNG_Exception(errorMessage);
         }                                           
    }
    
    public static String getNetworkTrafficLight(Id terminalId) {
         try {
         	Terminal__c queriedTerminal = [SELECT Network__c FROM Terminal__c WHERE Id = :terminalId];
         	return queriedTerminal.Network__c;
         } catch (Exception e) {
         	final String errorMessage = 'Error retrieving Network light value for terminal Id ' + terminalId + '.\n'
         	                          + e.getMessage() + '\n' + e.getStackTraceString();
         	throw new SNG_Exception(errorMessage);
         }
    }
    
    public static String getWeatherTrafficLight(Id terminalId) {
         try {
         	Terminal__c queriedTerminal = [SELECT WeatherBackEnd__c FROM Terminal__c WHERE Id = :terminalId];
         	return queriedTerminal.WeatherBackEnd__c;
         } catch (Exception e) {
         	final String errorMessage = 'Error retrieving Weather light value for terminal Id ' + terminalId + '.\n'
         	                          + e.getMessage() + '\n' + e.getStackTraceString();
         	throw new SNG_Exception(errorMessage);
         }
    }
    
    public static String getOnlineTimeTrafficLight(Id terminalId) {
         try {
         	Terminal__c queriedTerminal = [SELECT OnlineTime__c FROM Terminal__c WHERE Id = :terminalId];
         	return queriedTerminal.OnlineTime__c;
         } catch (Exception e) {
         	final String errorMessage = 'Error retrieving Online Time for terminal Id ' + terminalId + '.\n'
         	                          + e.getMessage() + '\n' + e.getStackTraceString();
         	throw new SNG_Exception(errorMessage);
         }
    }
    
    public static String getPointingTrafficLight(Id terminalId) {
         try {
         	Terminal__c queriedTerminal = [SELECT Pointing__c, OnlineTime__c FROM Terminal__c WHERE Id = :terminalId];
         	return isTerminalOnline(queriedTerminal) ? getStatusLight(queriedTerminal.Pointing__c) : getOfflineStatusLightColor();
         } catch (Exception e) {
         	final String errorMessage = 'Error retrieving Pointing light value for terminal Id ' + terminalId + '.\n'
         	                          + e.getMessage() + '\n' + e.getStackTraceString();
         	throw new SNG_Exception(errorMessage);
         }
    }
    
    private static String worsePerformingStatusLight(String pointingLight, String performanceLight)
    {
        SNGTerminalStatusLight.DotColor [] statusLights = 
            new SNGTerminalStatusLight.DotColor[]{ SNGTerminalStatusLight.getDotColor(pointingLight),
                                                   SNGTerminalStatusLight.getDotColor(performanceLight) };  
     
        String lightValue;
        if ( containsColor(SNGTerminalStatusLight.DotColor.GRAY, statusLights))
            lightValue = SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY);
        else if (containsColor(SNGTerminalStatusLight.DotColor.RED, statusLights))
            lightValue = SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.RED);
        else if (containsColor(SNGTerminalStatusLight.DotColor.YELLOW, statusLights))
            lightValue = SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.YELLOW);
        else
            lightValue = SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GREEN);  
        
        return lightValue;
    }
    
    
    private static String getStatusLight(String statusLight)
    {
        String lightValue;
        SNGTerminalStatusLight.DotColor color = SNGTerminalStatusLight.getDotColor(statusLight);
        if ( SNGTerminalStatusLight.DotColor.GRAY == color)
            lightValue = SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY);
        else if (SNGTerminalStatusLight.DotColor.RED == color)
            lightValue = SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.RED);
        else if (SNGTerminalStatusLight.DotColor.YELLOW == color)
            lightValue = SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.YELLOW);
        else
            lightValue = SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GREEN);  
        
        return lightValue;        
    }
    
    private static String getOfflineStatusLightColor()
    {
        return SNGTerminalStatusLight.getPathToStatusImage(SNGTerminalStatusLight.DotColor.GRAY);
    }
    
    private static boolean isTerminalOnline(Terminal__c terminal)
    {
        return !('Offline' == terminal.OnlineTime__c || UNABLE_TO_LOAD == terminal.OnlineTime__c);
    }
    
     
    private static boolean containsColor(SNGTerminalStatusLight.DotColor color, SNGTerminalStatusLight.DotColor[] statusLights)
    {
        boolean notFound = true;
        for(integer i = 0; i < statusLights.size() && notFound; ++i)
        {
            notFound = (color != statusLights[i]);
        }
        return !notFound;
    }
     
}