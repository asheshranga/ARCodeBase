/**
 * This class contains an enum for keeping track of the status light values included as part of the REST responses
 * in the third-party Exede Enterprise Customer Portal REST API.
 */
public with sharing class SNG_REST_StatusLight {
	
	/**
	 * This enum contains the possible values for the status light values included as part of the REST responses
	 * in the third-party Exede Enterprise Customer Portal REST API.
	 * Note: Order matters, and should not be changed, since the ordinal value is used in the REST responses.
	 */
	public enum Status {
		
		/**
		 * 0 - Terminal is experiencing severe issues
		 */
		SEVERE_ISSUES,
		
		/**
		 * 1 - Terminal is functioning as expected
		 */
		NO_ISSUES,
		
		/**
		 * 2 - Terminal is experiencing minor issues
		 */
		MINOR_ISSUES,
		
		/**
		 * 3 - Terminal is offline
		 */
		OFFLINE
	}
	
	/**
	 * Gets the Status enum value for the given Terminal__c field value.
	 *
	 * @param 	fieldValue	The value of the field to get Status for
	 * @return	          	The Status enum value based on the given field value
	 */
	public static Status getStatus(String fieldValue) {
		Status s;
		
		SNGTerminalStatusLight.DotColor dot = SNGTerminalStatusLight.getDotColor(fieldValue);
		
		if (SNGTerminalStatusLight.DotColor.GREEN == dot) {
			s = Status.NO_ISSUES;
		} else if (SNGTerminalStatusLight.DotColor.YELLOW == dot) {
			s = Status.MINOR_ISSUES;
		} else if (SNGTerminalStatusLight.DotColor.RED == dot) {
			s = Status.SEVERE_ISSUES;
		} else {
			s = Status.OFFLINE;
		}
		
		return s;
	}
}