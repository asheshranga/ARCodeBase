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
public class SNG_REST_Mock_CollectionHandler implements SNG_REST_ICollection
{
    public enum ResponseEnum { SAMPLE_SINGLE_DATA_COLLECTION_INT, SAMPLE_TWO_DATA_COLLECTION_INT }
    
    public ResponseEnum desiredResponse { get; set; }
    
    public static final integer SINGLE_DATA_RESPONSE_VALUE = 1;
    

    public SNG_REST_Response handleRequest(String[] ids)
    {
    	SNG_REST_Response response = null;
    	
    	if (ResponseEnum.SAMPLE_SINGLE_DATA_COLLECTION_INT == desiredResponse)
    	{
            List<SNG_REST_Mock_CollectionHandler_Output> singleDataResponse = new 
                List<SNG_REST_Mock_CollectionHandler_Output>{ new SNG_REST_Mock_CollectionHandler_Output(SINGLE_DATA_RESPONSE_VALUE) };
            
            SNG_REST_CollectionOutput collectionOutput = new SNG_REST_CollectionOutput(singleDataResponse);
            
            SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
            detail.status = SNGHttpUtilities.Status.OK;
            
            response = new SNG_REST_Response(detail, collectionOutput);  		
    	}
    	else if (ResponseEnum.SAMPLE_TWO_DATA_COLLECTION_INT == desiredResponse)
    	{
    		List<SNG_REST_Mock_CollectionHandler_Output> twoDataResponse = new List<SNG_REST_Mock_CollectionHandler_Output>{ 
    			                             new SNG_REST_Mock_CollectionHandler_Output(1), new SNG_REST_Mock_CollectionHandler_Output(2) };
    		
    		SNG_REST_CollectionOutput collectionOutput = new SNG_REST_CollectionOutput(twoDataResponse);
    		
    		SNG_REST_StatusDetail detail = new SNG_REST_StatusDetail(SNGHttpUtilities.Status.OK, SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR);
    		detail.status = SNGHttpUtilities.Status.OK;
    		
    		response = new SNG_REST_Response(detail, collectionOutput);
    		
    	}
    	
    	return response;
    }
    
    
    
    public class SNG_REST_Mock_CollectionHandler_Output implements SNG_REST_IJsonResponseData
    {
    	public integer value { get; set; }
    	
    	public SNG_REST_Mock_CollectionHandler_Output(integer value)
    	{
    		this.value = value;
    	}
    	
    	public boolean equals(Object obj)
    	{
    		// Compare references
            if (this === obj) return true;
            if (obj == null || !(obj instanceof SNG_REST_Mock_CollectionHandler_Output)) return false;

            SNG_REST_Mock_CollectionHandler_Output other = (SNG_REST_Mock_CollectionHandler_Output) obj;
            return (other.value == value);
    	}
    	
    	public override integer hashCode()
    	{
            final integer prime = 31;
            integer result = 1;
            result = prime * result + (integer)(value ^ (value >>> 32));
            return result;
        }
    }
}