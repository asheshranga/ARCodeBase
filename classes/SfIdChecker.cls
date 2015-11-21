/**
 * This class is used to validate Custom SObject IDs (i.e. Service Plans, Terminals)
 */
public with sharing virtual class SfIdChecker implements SNG_IValidator {

	/**
	 * The prefix of the ID. This is used as part of the regular expression.
	 */
	private String prefixRegex { get; set; }

	/**
	 * Constructor of a SfIdChecker
	 *
	 * @param prefixRegex 	the regular expression corresponding to a prefix of ID to be checked
	 * 							(e.g. '[Ss][Pp][-]' for service plan IDs such as 'SP-0123'
	 */
	public SfIdChecker( String prefixRegex ) {
		this.prefixRegex = prefixRegex;
	}

    /**
	 * Validates if Id input is correct form
	 *
	 * @param	id				the id input
	 * @return 					true if id is valid, false if not
	 */
	public boolean isValidFormat(String id) {
		boolean result = false;

		if (id != null)
		{
			String numberRegex = '([0][0-9]{3}|[1-9][0-9]{3,})';   // if starting with zero, must be exactly 4 digits. If 1-9, must at least have 4 digits.
			Pattern idPattern = Pattern.compile(prefixRegex + numberRegex);
			Matcher idMatcher = idPattern.matcher(id);
			result = idMatcher.matches();
		}

		return result;
	}
}