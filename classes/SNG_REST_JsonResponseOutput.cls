/**
 * This class contains inner classes that populate the output field in the JSON response message
 * when responding from a RESTful request from a client.
 */
public with sharing class SNG_REST_JsonResponseOutput 
{
	/**
	 * An Exception class to be thrown when there is a validation exception in constructing the
	 * inner classes in SNG_REST_JsonResponseOutput
	 */
    public class ValidationException extends SNG_Exception {}
    
}