/**
 * This utility class is used to help facilitate HTML-related operations such as constructing
 * HTML hyperlinks.
 */
public with sharing class SNG_HtmlUtilities {
	
	/**
	 * Constructs an HTML error message in centered, bold, red font.
	 *
	 * @param   errorMessage  The error message to be formatted.
	 * @return                The error message formatted for HTML to center, bold, and red font.
	 */
	public static String getHtmlMessageCenteredBoldRedFontFormat(String errorMessage)
	{
		return '<center>' + getHtmlMessageBoldRedFontFormat(errorMessage) + '</center>';
	}
	
	/**
	 * Constructs an HTML error message in bold, red font.
	 *
	 * @param   errorMessage  The error message to be formatted.
	 * @return                The error message formatted for HTML to bold and red font.
	 */
	public static String getHtmlMessageBoldRedFontFormat(String errorMessage)
	{
		return '<font color="red"><b>' + errorMessage + '</b></font>';
	}
	
		
    /**
	 * Constructs a single HTML hyperlink based on a provided record.
	 *
	 * @param   record        A Salesforce object to create a hyperlink to.
	 * @return                An HTML hyperlink that references the desired record.
	 */
	public static String getHtmlSalesforceRecordLinkString(SObject record) {
		return getHtmlSalesforceRecordLinkString(getRecordId(record), getRecordName(record));
	}
	
	
	/**
	 * Constructs an HTML hyperlink based on the specific record ID and record name.
	 *
	 * @param  recId          The record ID to use when constructing the HTML hyperlink.
	 * @param  recName        The text to display when displaying the HTML hyperlink. 
	 * @return                An HTML hyperlink using the record ID and the display text.
	 */
	public static String getHtmlSalesforceRecordLinkString(Id recId, String recName) {
		return '<a href=\'' + URL.getSalesforceBaseUrl().getPath()  + '/' + recId + '\'><font color="blue">' + recName + '</font></a>';
	}
	
	
    /**
	 * Constructs a comma-separated list of HTML hyperlinks based on a list of records.
	 *
	 * @param   record        A list of records to create a list of HTML hyperlinks.
	 * @return                A comma-separated text of HTML hyperlinks that references the desired records.
	 */
	public static String getHtmlSalesforceRecordLinkListString(List<SObject> records) {
		Map<Id, String> recIdsNames = new Map<Id, String>();
		for (SObject rec : records) {
			recIdsNames.put(getRecordId(rec), getRecordName(rec));
		}
		return getHtmlSalesforceRecordLinkListString(recIdsNames);
	}
	
	
	/**
	 * Constructs a comma-separated list of HTML hyperlinks based on record ID and record name provided.
	 *
	 * @param   recIdsName     A mapping between the record ID and the record name
	 * @return                 A comma-separated text of HTML hyperlinks that references the desired records.
	 */
	public static String getHtmlSalesforceRecordLinkListString(Map<Id, String> recIdsNames) {
		List<String> links = getHtmlSalesforceRecordLinkList(recIdsNames);
		String retval = '';
		String delimit = '';

		final integer MAX_SIZE = 10;
		final integer iterCount = Math.min(links.size(), MAX_SIZE);
		integer i = 0;
		integer extraItemsNotCaptured = links.size() - MAX_SIZE;
		
		while (i < iterCount)
		{	
			retval += delimit + links[i];
			delimit = ', ';
			++i;
		}
		
		if (extraItemsNotCaptured > 0)
		{
			retVal += '<br /> ... (' + extraItemsNotCaptured + ' more)';
		}	
		
		return retval;
	}
	
	
    /**
	 * Constructs an list of HTML addresses to access teh specified record ID.
	 *
	 * @param   recIdsNames    A mapping between the record ID and the record name.
	 * @return                 The name of the Salesforce object.
	 */
	private static List<String> getHtmlSalesforceRecordLinkList(Map<Id, String> recIdsNames) {
		List<String> links = new List<String>();
		
		for (Id recId : recIdsNames.keySet()) {
			links.add(getHtmlSalesforceRecordLinkString(recId, recIdsNames.get(recId)));
		}
		
		return links;
	}
	
	
	/**
	 * Returns the record ID from a Salesforce Object.
	 *
	 * @param   record         The Salesforce object to retrieve the record ID from
	 * @return                 The ID of the Salesforce object.
	 */
	private static Id getRecordId(SObject record) {
		return (Id) record.get('Id');
	}
	
	
	/**
	 * Returns the record name from a Salesforce Object.
	 *
	 * @param   record         The Salesforce object to retrieve the record name from
	 * @return                 The name of the Salesforce object.
	 */
	private static String getRecordName(SObject record) {
		return (String) record.get('Name');
	}
}