public with sharing class SNGEmailGenerator {

    @future
    public static void sendExceptionEmail(String errorMessage, String stackTrace)
	{
		String orgId = URL.getSalesforceBaseUrl().toExternalForm();
		String subject = 'Exception caused in ' + orgId +' by User : '+UserInfo.getUserName();
		String body = errorMessage + '<br>' + stackTrace;

		String[] emailAddrs = getExceptionEmailAddrsFromCustomSetting();
		pSendEmail(emailAddrs, subject, body);
	}

	public static Messaging.SingleEmailMessage createEmail(String[] toAddresses, String subject, String body)
	{
		Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();

		if (null != toAddresses)
		{
			mail.setToAddresses(toAddresses);
		}

		mail.setSubject(subject);
		mail.setPlainTextBody(body);
		mail.setHtmlBody(body);
		mail.setUseSignature(true);
		mail.setSaveAsActivity(false);

		return mail;
	}

    public static void sendEmail(Messaging.SingleEmailMessage mail)
	{
		if(!Test.isRunningTest())	Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
	}

    @future
    public static void sendEmail (String[] toAddresses, String subject, String body)
	{
		pSendEmail(toAddresses, subject, body);
	}
	
	private static void pSendEmail(String[] toAddresses, String subject, String body) {
		sendEmail(createEmail(toAddresses, subject, body));
	}
	
	private static String[] getExceptionEmailAddrsFromCustomSetting() {
		SNGErrorEmailNotification__c customSetting = SNGErrorEmailNotification__c.getInstance(UserInfo.getProfileId());
		return StringUtils.split(StringUtils.trim(customSetting.Emails__c));
	}
	
}