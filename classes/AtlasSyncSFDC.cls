/*
 * @created by - Tejesh Mandapati
 * @description - Sync phone, email to SFDC Contact when updatecustomerinfo is success.
 * @input param  - AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj
 */  

public class AtlasSyncSFDC {
	
    public pagereference syncContacts(AtlasTransactionDTO.UpdateCustomerInfoTxDTO custInfoObj) {
        /*
        List<Contact> conList = [Select Id,phone,Email,ExternalAccountReference__c from Contact where externalAccountReference__c =: custInfoObj.externalAccountReference ];
        if(conList != null && !conList.isEmpty()) {
            for(Contact con: conList) {
                con.phone = custInfoObj.phone;
                con.email = custInfoObj.email;                    
            }
            update conList;
        }
        */  
        system.debug('External Account--->'+custInfoObj.externalAccountReference);  
        if(custInfoObj.externalAccountReference != null && custInfoObj.externalAccountReference != '' ) {
        	try {
	            Contact con = [Select Id,phone,Email,ExternalAccountReference__c from Contact where externalAccountReference__c =: custInfoObj.externalAccountReference LIMIT 1];
	            if(!AtlasUtility.isEmpty(con))
	            { 
		            con.phone = custInfoObj.phone; 
		            con.email = custInfoObj.email;              
	            	update con;
	            }
        	} Catch(Exception ex){   
        		System.debug('Excception--->'+ex);
        	}
        }
            
        /*
        List<User> usrList = [Select Id,phone,Email,ExternalAccountReference__c from User where externalAccountReference__c =: custInfoObj.externalAccountReference ];
        if(usrList != null && !usrList.isEmpty()) {
            for(User usr: usrList) {
                usr.phone = custInfoObj.phone; 
                usr.email = custInfoObj.email;                   
            }
            update usrList;
        }
        */
        return null;
      }
      
       public void syncUsername(String oldUserName, String newUserName) {
       		if(oldUserName != null) {
	            User[] users = [Select Id,FederationIdentifier,ExternalAccountReference__c from User where FederationIdentifier =: oldUserName LIMIT 1];
	            if (users.size() == 1) {
	               User usr = users[0];
	               usr.FederationIdentifier = newUserName;                     
	               update usr;
	            }
	        }              
      }
      
	  /**
 	   * @author 		Sujit Kumar
 	   * @date 			06/10/2014
 	   * @param			external account reference number of the customer
 	   * @description	Customer Care user syncs SFDC account number from backend systems
 	   * @return		true if successful, false otherwise
 	   */
      public Boolean syncUserAndContact(String internalAccountReferenceNumber) {
      		Boolean isSuccess = false;
      		if (AtlasUtility.isEmpty(internalAccountReferenceNumber)) {
      			return isSuccess;
      		}
      		
	      	AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse response;
	      	try {
	      		response = AtlasIntegrationUtility.findSubscribersBySearchCriteria(internalAccountReferenceNumber);
	      	}
	      	catch(AtlasException.InvalidDataException invalidEx) {
	      		System.debug(loggingLevel.ERROR, 'AtlasSyncSFDC::syncUserAndContact InvalidDataException error message: ' + invalidEx.errorMessage);
	      		return isSuccess;
	      	}
	      	catch(AtlasException.CalloutException calloutEx) {
	      		System.debug(loggingLevel.ERROR, 'AtlasSyncSFDC::syncUserAndContact CalloutException error message: ' + calloutEx.errorMessage);
	      		return isSuccess;
	      	}

			return syncUserAndContact(response, internalAccountReferenceNumber, null, true);
      }
      
	  /**
 	   * @author 		Sujit Kumar
 	   * @date 			06/10/2014
 	   * @param			external account reference number of the customer
 	   * @description	Customer Care user changes the plan of a customer while on the phone.
 	   *                This will change the customer account number.
 	   * @return		true if successful, false otherwise
 	   */
      public Boolean moveInternalAccountNumber(String internalAccountReferenceNumber, String oldInternalAccountNumber) {
      	    AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse response = null;
      		response = retrieveAccountDetailsFromBackend(internalAccountReferenceNumber);
      		if (response != null) {
			    return syncUserAndContact(response, internalAccountReferenceNumber, oldInternalAccountNumber, false);
      		} else {
      			return false;
      		}
      }  
      
      public AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse retrieveAccountDetailsFromBackend(String internalAccountReferenceNumber) {
            if (AtlasUtility.isEmpty(internalAccountReferenceNumber)) {
      			return null;
      		}
      		
	      	AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse response;
	      	try {
	      	   String internalRefType = 'ACCOUNT';
               response = AtlasIntegrationUtility.findSubscribersBySearchCriteriaGeneric(NULL, NULL, internalRefType, internalAccountReferenceNumber,
         										                       NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
	      	}
	      	catch(AtlasException.InvalidDataException invalidEx) {
	      		System.debug(loggingLevel.ERROR, 'AtlasSyncSFDC::syncUserAndContact InvalidDataException error message: ' + invalidEx.errorMessage);
	      		return null;
	      	}
	      	catch(AtlasException.CalloutException calloutEx) {
	      		System.debug(loggingLevel.ERROR, 'AtlasSyncSFDC::syncUserAndContact CalloutException error message: ' + calloutEx.errorMessage);
	      		return null;
	      	}
      	    return response;
      }   
      
	  /**
 	   * @author 		Sujit Kumar
 	   * @date 			06/25/2014
 	   * @param			accountNumber current account number of the customer
 	   * @param			oldAccountNumber previous account number of the customer, used only for move and not for sync.
 	   * @param         isExternal flag for external account number
 	   * @description	used both for syncUserAndContact and moveInternalAccount
 	   * @return		true if successful, false otherwise
 	   */
      private Boolean syncUserAndContact(AtlasPublicWebServiceSearchServiceStub.findSubscribersBySearchCriteriaResponse response, 
      									String accountNumber, String oldAccountNumber, 
      									Boolean isExternal) {
      		String accountNumberType = isExternal ? 'external' : 'internal';
            Boolean isSuccess = false;
	      	AtlasPublicWebServiceSearchServiceStub.Subscriber[] subscribers = response.subscriber;
			if (subscribers != null && subscribers.size() > 0) {
		      	AtlasPublicWebServiceSearchServiceStub.Subscriber foundSubscriber = subscribers[0];
	
				User[] users = null;
				if (isExternal) {
					users = getUsersWithGivenExternalAccountNumber(accountNumber);
				} else {
					users = getUsersWithGivenInternalAccountNumber(oldAccountNumber);
				}
								
				if (users.size() > 0) {
					User usrObj = users[0];
					
					Contact[] contacts = [select Id, Account_Number__c, ExternalAccountReference__c, Email, Phone
				                          from Contact 
				                          where Id = :usrObj.ContactId];
				    
				    Contact contactObj = null;
				    if (contacts.size() > 0) {
				    	contactObj = contacts[0];
				    } else {
				    	String noContactMesg = 'No contact found for user with existing ' + accountNumberType + ' account number: ';
				    	if (isExternal) noContactMesg += accountNumber; else noContactMesg += oldAccountNumber; 
				    	System.debug(loggingLevel.WARN, noContactMesg);
				    }
				                      
					if (foundSubscriber.account != null) {
						// System.debug('Setting user account to: ' + foundSubscriber.account.internalAccountReference);
						usrObj.Account_Number__c = foundSubscriber.account.internalAccountReference;
						if (!isExternal) usrObj.ExternalAccountReference__c = foundSubscriber.account.externalAccountReference;
						if (contactObj != null) {
							contactObj.Account_Number__c = foundSubscriber.account.internalAccountReference;
							if (!isExternal) contactObj.ExternalAccountReference__c = foundSubscriber.account.externalAccountReference;
						}
					}
					if (foundSubscriber.contact != null) {
						// System.debug('Setting contact email to: ' + foundSubscriber.contact.emailAddress);
						// System.debug('Setting contact phone to: ' + foundSubscriber.contact.primaryPhoneNumber);
						if (contactObj != null) {
							contactObj.email = foundSubscriber.contact.emailAddress;
							contactObj.phone = foundSubscriber.contact.primaryPhoneNumber;
						}
						usrObj.phone = foundSubscriber.contact.primaryPhoneNumber;
					}
					try {
						update usrObj;
						if (contactObj != null) {
							update contactObj;
						}
						isSuccess = true;
					} catch (DMLException dmlEx) {
						System.debug(loggingLevel.ERROR, 'AtlasSyncSFDC::syncUserAndContact failed, error message: ' + dmlEx.getMessage());
					}
				} else {
					String cannotFindUserMesg = 'AtlasSyncSFDC::syncUserAndContact failed, cannot find user for ' + accountNumberType + ' existing account number: ';
				    if (isExternal) cannotFindUserMesg += accountNumber; else cannotFindUserMesg += oldAccountNumber; 
					System.debug(loggingLevel.WARN, cannotFindUserMesg);
				}
			} else {
				String noSubscriberMesg = 'AtlasSyncSFDC::syncUserAndContact failed, no subscribers for ' + accountNumberType + ' account number: ';
				if (isExternal) noSubscriberMesg += accountNumber; else noSubscriberMesg += oldAccountNumber; 
				System.debug(loggingLevel.WARN,  noSubscriberMesg);
			}
			return isSuccess;
      }
      
      private User[] getUsersWithGivenExternalAccountNumber(String externalAccountNumber) {
         User[] users = [Select Id, 
								Account_Number__c, 
								ExternalAccountReference__c, 
								Contact.Account_Number__c, 
								Contact.email, 
								phone, 
								contact.phone 
						from User 
						where ExternalAccountReference__c = :externalAccountNumber LIMIT 1];
         return users;
      }
      
      private User[] getUsersWithGivenInternalAccountNumber(String internalAccountNumber) {
         User[] users = [Select Id, 
								Account_Number__c, 
								ExternalAccountReference__c, 
								Contact.Account_Number__c, 
								Contact.email, 
								phone, 
								contact.phone 
						from User 
						where Account_Number__c = :internalAccountNumber LIMIT 1];
         return users;
      }      
}