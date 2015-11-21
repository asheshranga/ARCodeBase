public with sharing class AtlasTransactionModel {
	
    private String transactionDescription;
	private String transactionModule;
	private String transactionType;
	private String internalServiceAgreementId;
	private String externalAccountReference;
	private datetime startTime;
	private datetime endTime;
	
	public AtlasTransactionModel (	String transactionDescription, 
									String transactionModule,
									String transactionType,
									String internalServiceAgreementId,
									String externalAccountReference,
									datetime startTime,
									datetime endTime) {
																				
		this.transactionDescription = transactionDescription;
		this.transactionModule = transactionModule;
		this.transactionType = transactionType;
		this.internalServiceAgreementId = internalServiceAgreementId;
		this.externalAccountReference = externalAccountReference;
		this.startTime = startTime;
		this.endTime = endTime;				
	}
	
	public String getTransactionDescription(){
		return transactionDescription;
	}
	
	public String getTransactionModule(){
		return transactionModule;
	}

	public String getTransactionType(){
		return transactionType;
	}

	public String getInternalServiceAgreementId(){
		return internalServiceAgreementId;
	}

	public String getExternalAccountReference(){
		return externalAccountReference;
	}

	public dateTime getStartTime(){
		return startTime;
	}

	public datetime getEndTime(){
		return EndTime;
	}
	
	public static List<AtlasTransactionModel> getAtlasTransactionModelList(AtlasMainDTO mainDTO)
    {
        if (mainDTO.atlasTransactionModelList != null)
            return mainDTO.atlasTransactionModelList;
        else
            return new List<AtlasTransactionModel>();    
    }  
}