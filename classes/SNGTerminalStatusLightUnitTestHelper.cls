/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class SNGTerminalStatusLightUnitTestHelper {
	private static final SNGReturnLinkSymbolRateThresholds__c RL_SYM_RATE_THRESHOLDS;
	private static final SNGForwardLinkSinrThresholds__c FL_SINR_THRESHOLDS;
	
	static {
		SNG_MockCustomSettings.initialize();
    	RL_SYM_RATE_THRESHOLDS = SNGReturnLinkSymbolRateThresholds__c.getOrgDefaults();
    	FL_SINR_THRESHOLDS = SNGForwardLinkSinrThresholds__c.getOrgDefaults();
	}
	
	public static Terminal__c setNetworkGreen(Terminal__c terminal) {
    	terminal.PeersOnlineBackEnd__c = 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.GREEN, SNGTerminalStatusLight.getDotColor(terminal.Network__c));
    	return terminal;
    }
    
    public static Terminal__c setNetworkRed(Terminal__c terminal) {
    	terminal.PeersOnlineBackEnd__c = 0;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.RED, SNGTerminalStatusLight.getDotColor(terminal.Network__c));
    	return terminal;
    }
    
    public static Terminal__c setWeatherGreen(Terminal__c terminal) {
    	terminal.PeersAvgUploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.GoodMinimum__c;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.GREEN, SNGTerminalStatusLight.getDotColor(terminal.WeatherBackEnd__c));
    	return terminal;
    }
    
    public static Terminal__c setWeatherYellow(Terminal__c terminal) {
    	return setWeatherYellowMax(setWeatherYellowMin(terminal));
    }
    
    public static Terminal__c setWeatherYellowMax(Terminal__c terminal) {
    	terminal.PeersAvgUploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.GoodMinimum__c - 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.YELLOW, SNGTerminalStatusLight.getDotColor(terminal.WeatherBackEnd__c));
    	return terminal;
    }
    
    public static Terminal__c setWeatherYellowMin(Terminal__c terminal) {
    	terminal.PeersAvgUploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.BadMaximum__c + 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.YELLOW, SNGTerminalStatusLight.getDotColor(terminal.WeatherBackEnd__c));
    	return terminal;
    }
    
    public static Terminal__c setWeatherRed(Terminal__c terminal) {
    	terminal.PeersAvgUploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.BadMaximum__c;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.RED, SNGTerminalStatusLight.getDotColor(terminal.WeatherBackEnd__c));
    	return terminal;
    }
    
    public static Terminal__c setPerformanceGreen(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.GoodMinimum__c;
    	terminal.DownloadSinrBackEnd__c = FL_SINR_THRESHOLDS.GoodMinimum__c;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.GREEN, SNGTerminalStatusLight.getDotColor(terminal.Performance__c));
    	return terminal;
    }
    
    public static Terminal__c setPerformanceYellow(Terminal__c terminal) {
    	return setPerformanceYellowMax(setPerformanceYellowMin(terminal));
    }
    
    public static Terminal__c setPerformanceYellowMax(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.GoodMinimum__c - 1;
    	terminal.DownloadSinrBackEnd__c = FL_SINR_THRESHOLDS.GoodMinimum__c - 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.YELLOW, SNGTerminalStatusLight.getDotColor(terminal.Performance__c));
    	return terminal;
    }
    
    public static Terminal__c setPerformanceYellowMin(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.BadMaximum__c + 1;
    	terminal.DownloadSinrBackEnd__c = FL_SINR_THRESHOLDS.BadMaximum__c;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.YELLOW, SNGTerminalStatusLight.getDotColor(terminal.Performance__c));
    	return terminal;
    }
    
    public static Terminal__c setPerformanceRed(Terminal__c terminal) {
    	return setPerformanceRedMax(setPerformanceRedMin(terminal));
    }
    
    public static Terminal__c setPerformanceRedMax(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.BadMaximum__c;
    	terminal.DownloadSinrBackEnd__c = FL_SINR_THRESHOLDS.BadMaximum__c - 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.RED, SNGTerminalStatusLight.getDotColor(terminal.Performance__c));
    	return terminal;
    }
    
    public static Terminal__c setPerformanceRedMin(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = 1;
    	terminal.DownloadSinrBackEnd__c = 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.RED, SNGTerminalStatusLight.getDotColor(terminal.Performance__c));
    	return terminal;
    }
    
    public static Terminal__c setPerformanceGray(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = 0;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.GRAY, SNGTerminalStatusLight.getDotColor(terminal.Performance__c));
    	return terminal;
    }
    
    public static Terminal__c setPointingGreen(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.GoodMinimum__c;
    	// OR UploadSymbolRateBackEnd__c >= PeersAvgUploadSymbolRateBackEnd__c.. no need to set that here since it's an OR
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.GREEN, SNGTerminalStatusLight.getDotColor(terminal.Pointing__c));
    	return terminal;
    }
    
    public static Terminal__c setPointingYellow(Terminal__c terminal) {
    	return setPointingYellowMax(setPointingYellowMin(terminal));
    }
    
    public static Terminal__c setPointingYellowMax(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.GoodMinimum__c - 1;
    	terminal.PeersAvgUploadSymbolRateBackEnd__c = terminal.UploadSymbolRateBackEnd__c + 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.YELLOW, SNGTerminalStatusLight.getDotColor(terminal.Pointing__c));
    	return terminal;
    }
    
    public static Terminal__c setPointingYellowMin(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.BadMaximum__c + 1;
    	// AND UploadSymbolRateBackEnd__c < PeersAvgUploadSymbolRateBackEnd__c
    	terminal.PeersAvgUploadSymbolRateBackEnd__c = terminal.UploadSymbolRateBackEnd__c + 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.YELLOW, SNGTerminalStatusLight.getDotColor(terminal.Pointing__c));
    	return terminal;
    }
    
    public static Terminal__c setPointingRed(Terminal__c terminal) {
    	return setPointingRedMax(setPointingRedMin(terminal));
    }
    
    public static Terminal__c setPointingRedMax(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = RL_SYM_RATE_THRESHOLDS.BadMaximum__c;
    	// AND UploadSymbolRateBackEnd__c < PeersAvgUploadSymbolRateBackEnd__c
    	terminal.PeersAvgUploadSymbolRateBackEnd__c = terminal.UploadSymbolRateBackEnd__c + 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.RED, SNGTerminalStatusLight.getDotColor(terminal.Pointing__c));
    	return terminal;
    }
    
    public static Terminal__c setPointingRedMin(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = 1;
    	// AND UploadSymbolRateBackEnd__c < PeersAvgUploadSymbolRateBackEnd__c
    	terminal.PeersAvgUploadSymbolRateBackEnd__c = terminal.UploadSymbolRateBackEnd__c + 1;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.RED, SNGTerminalStatusLight.getDotColor(terminal.Pointing__c));
    	return terminal;
    }
    
    public static Terminal__c setPointingGray(Terminal__c terminal) {
    	terminal.UploadSymbolRateBackEnd__c = 0;
    	terminal = updateTerminalAndQueryAgain(terminal);
    	System.assertEquals(SNGTerminalStatusLight.DotColor.GRAY, SNGTerminalStatusLight.getDotColor(terminal.Pointing__c));
    	return terminal;
    }
    
    public static Terminal__c setTerminalOffline(Terminal__c terminal) {
    	terminal.OnlineTime__c = 'Offline';
    	terminal = updateTerminalAndQueryAgain(terminal);
    	return terminal;
    }
    
    public static Terminal__c setTerminalOnlineTime(Terminal__c terminal, Long secondsOnline) {
    	terminal.OnlineTime__c = SNG_UTPerformanceFromPerf.getTimeString(secondsOnline);
    	terminal = updateTerminalAndQueryAgain(terminal);
    	return terminal;
    }
    
    private static Terminal__c updateTerminalAndQueryAgain(Terminal__c terminal) {
    	update terminal;
    	SNG_SObjectQueryBuilder queryBuilder = new SNG_SObjectQueryBuilder(SNG_SObjectQueryBuilder.TERMINAL_OBJ_NAME);
    	queryBuilder.addAllFields();
    	final String queryString = queryBuilder.constructQuery() + ' WHERE Id = \'' + terminal.Id + '\'';
    	terminal = Database.query(queryString);
    	return terminal;
    }
}