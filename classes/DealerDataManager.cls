/*********************************************************************************
Name         : DealerDataManager 
Created By   : Jim Tunney
Modified By  : 
Company Name : 
Project      : Dealer Portal
Created Date : 3 Nov 2015
Usages       : Parent Class for all Page Controllers for VisualForce Page
*********************************************************************************/

public virtual with sharing class DealerDataManager {
    
	public DealerMainDTO mainDTOObj{get;set;}
	
	public static boolean sessionMgmt {get{
    		return (Label.ATLAS_Session_Management==AtlasConstants.TRUE_VALUE);
            }set;}
    
    public DealerDataManager()
    {
        mainDTOObj=new DealerMainDTO();
    }
    
    /** 
    * @author Srikanth Kudumula
    * @description getTransitionPackages
    * @Across Change Plan
    * @param none
    * @return void
    */  
    public void getTransitionPackages()
    {
    	//System.debug('--------------------@@@@------------------------>marker: DataMgr --> getTransitionPackages()');
        populateViewState();
        DealerIntegrationServiceManager.getTransitionPackages(mainDTOObj);
        persistViewState();
    }
    
     /** 
    * @author Tejesh M
    * @description getPackages
    * @Across Change Plan
    * @param none
    * @return void
    */  
    public void getPackages()
    {
        populateViewState();
        DealerIntegrationServiceManager.getPackages(mainDTOObj);
        persistViewState();
    }
    
    /**
    * @author Jim Tunney
    * @description populateDealerDashboardData
    * @Across Dealer Dashboard Screen
    * @param none
    * @return void
    */  
    public void populateDealerDashboardData()
    {
        populateViewState(); 
        getDashboardData(mainDTOObj);
        persistViewState();
    }
    
    public static DealerMainDTO getDashboardData(DealerMainDTO mainDTO)
    {
    	//System.debug('--------------------@@@@------------------------>first sessionMgmt= '+sessionMgmt);
    	//System.debug('--------------------@@@@------------------------>first If stmt: isEmpty(mainDTO.accountKey)= '+AtlasUtility.isEmpty(mainDTO.accountKey));
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt){
        //System.assert(false,'assert failure: DlrDataMgr --> getDashboardData() FIRST IF STMT');//works
        //System.debug('--------------------@@@@------------------------>marker: getDboardData() first if stmt');
        DealerIntegrationServiceManager.searchCustomerDetails(mainDTO);
        //System.assert(false,'assert failure: DlrDataMgr --> getDashboardData() FIRST IF STMT');//works
        }
        //System.debug('--------------------@@@@------------------------>second IF stmt: isEmpty(mainDTO.accountKey)= '+AtlasUtility.isEmpty(mainDTO.accountKey));
        //System.debug('--------------------@@@@------------------------>second sessionMgmt= '+sessionMgmt);
        if(AtlasUtility.isEmpty(mainDTO.accountKey)||!sessionMgmt){
        //System.assert(false,'assert failure: DlrDataMgr --> getDashboardData() SECOND IF STMT');//does not work
        DealerIntegrationServiceManager.getAccountServiceAgreementsAndServices(mainDTO);
        }
        //System.debug('--------------------@@@@------------------------>mainDTO= '+mainDTO);
        return mainDTO; 
    }
    
    /**
    * @author Gaurav Gathania 
    * @description populateViewState for Session Management 
    * @param none
    * @return void
    */  
    private void populateViewState()
    {   
        mainDTOObj=DealerDatabaseManager.populateViewState(mainDTOObj);
        //System.assert(false,'assert failure: DlrDataMgr --> populateViewState()');//works
    }
    
    /**
    * @author Gaurav Gathania 
    * @description persist view state for Session Management 
    * @Across Dealer Screens 
    * @param none
    * @return void
    */  
    public void persistViewState()
    {
        DealerDatabaseManager.persistViewState(mainDTOObj);
        //System.assert(false,'assert failure: DlrDataMgr --> persistViewState()');//works
    }
    
    /** 
    * @author Srikanth Kudumula
    * @description getAllAccountServices
    * @Across Dealer Dashboard
    * @param DealerManinDTO
    * @return void
    */  
    public static DealerMainDTO getAllAccountServices(DealerMainDTO mainDTO)
    {
    	//System.debug('--------------------@@@@------------------------>marker: DataMgr --> getTransitionPackages()');
        //populateViewState();
        DealerIntegrationServiceManager.getAllAccountServices(mainDTO);
        //persistViewState();
        return mainDTO;
    }
}