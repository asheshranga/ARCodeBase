public with sharing class SNG_DateChecker implements SNG_IValidator {
	
	/**
	 * An error message to indicate that the start date cannot be more than 60 days old. Performance history is stored only for 60 days.
	 */
	@TestVisible
	private static final String START_DATE_MORE_THAN_60_DAYS = 'Start date cannot be more than 60 days ago from today\'s date';
	
	/**
	 * Verify start and end dates 
	 *
	 * @param	details		The status detailing the response
	 * @param	startDate	The start date
	 * @param	endDate		The end  date
	 * @return				True if dates are valid, false if dates are not valid
	 */
	public boolean validate(SNG_REST_StatusDetail details, String startDate, String endDate) 
	{	
		// set the message to null
		//details.message = null;
		boolean areDatesValid = true;  
		
		// start/end dates are null
		if (startDate == null) {
			details.message = SNG_REST_Error.MISSING_START_DATE;
			areDatesValid = false;
		}
		else if (endDate == null) {
			details.message = SNG_REST_Error.MISSING_END_DATE;
			areDatesValid = false;
		}
		else
		{
			if (isValidFormat(startDate) && isValidFormat(endDate)) 
			{ 
				// CHECK Start Date cannot be in the future
				if (isDateInTheFuture(startDate)) {
					details.message = SNG_REST_Error.START_DATE_IN_FUTURE;
					areDatesValid = false;
				}
				// CHECK end date cannot be before start date
				else if (isEndDateBeforeStartDate(startDate, endDate)) {
					details.message = SNG_REST_Error.END_DATE_BEFORE_START_DATE;
					areDatesValid = false; 
				}		
			}
			else 
			{ 
				details.message = SNG_REST_Error.INVALID_DATE +  ' Dates must be in YYYY-MM-DD format.';
				areDatesValid = false;
			}
		}
		
		// If dates are not valid, set the status and error code
		if (!areDatesValid) 
		{ 
			details.status = SNGHttpUtilities.Status.INPUT_VALIDATION_ERROR;
			details.code = SNG_REST_Error.SubCode.SALESFORCE_GENERATED_ERROR;			
		}
		
		return areDatesValid;
	}
	
	
	/** 
	 * Checks if date format is valid 
	 */ 
	public boolean isValidFormat(String dateToValidate) { 
		try {
			Date dateValue = Date.valueOf(dateToValidate);
		} 
		catch (TypeException te) { 
			return false; 
		}
		
		return true; 
	}
	
	
	/**
	 * Checks that end date does not occur before the start date
	 * 
	 * @param	startDate		The start date
	 * @param	endDate			The end date
	 * @return 					true if end date is before start date, false otherwise 
	 */ 
	public boolean isEndDateBeforeStartDate(final String startDate, final String endDate) {
		Date dateStart = Date.valueOf(startDate);
		Date dateEnd = Date.valueOf(endDate);
		return (dateStart > dateEnd);
	}
	
	/**
	 * Checks if a date is in the future
	 *
	 * @param	dateParam		The date
	 * @return					true if date is in the future
	 * 							false if date is not in the future
	 */
	public boolean isDateInTheFuture(String dateParam) {
		
		Date paramDate = Date.valueOf(dateParam); 
		
		return (paramDate > SNG_DateUtils.todayGmt()); 

	}
	
	/**
	 * Checks if date is older than 60 days
	 * 
	 * @param	dateParam		The date to check
	 * @return					true if date is older than 60 days
	 *							false otherwise
	 */
	public boolean isDateOlderThan60Days(String dateParam) { 
		
		Date paramDate = Date.valueOf(dateParam);
		
		return (paramDate < SNG_DateUtils.todayGmt().addDays(-60)); 
		
	}
}