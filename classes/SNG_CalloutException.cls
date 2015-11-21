/**
 * This subclass of Exception is used as a superclass for all developer thrown exceptions.
 */
public virtual with sharing class SNG_CalloutException extends SNG_Exception {
	
	public SNG_CalloutException(String externalMessage, String internalMessage)
	{
		super(externalMessage);
	}
}