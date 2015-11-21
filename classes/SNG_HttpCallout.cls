/**
 * This class is used to perform HTTP requests.
 */
public with sharing class SNG_HttpCallout {

	/**
	 * The default timeout used in constructing HTTP requests
	 */
	public static final transient integer DEFAULT_TIMEOUT = 3000;
	
	/**
	 * The header to store the cookie in the request to the web service protected
	 * by OpenAM
	 */
	@TestVisible
	private static final transient String COOKIE_HEADER_KEY = 'Cookie';
	
	/**
	 * The OpenAM Base URL
	 */
	private static final transient URL OPENAM_BASE_URL = new URL(SNGHttpUtilities.OPENAM_LOGIN.URL__c);
	
	/**
	 * The OpenAM Username
	 */
	private static final transient String OPENAM_USERNAME = SNGHttpUtilities.OPENAM_LOGIN.Username__c;
	
	/**
	 * The OpenAM Password
	 */
	private static final transient String OPENAM_PASSWORD = SNGHttpUtilities.OPENAM_LOGIN.Password__c;
	
	/**
	 * Array containing all of the URLs which require OpenAM authentication
	 */
	private static final transient URL[] URLS_REQUIRING_AUTH = new URL[] { 
		new URL(SNGHttpUtilities.TOMCAT_SERVER.Url__c) 
	};
	
	/**
	 * The name of the cookie used for OpenAM login
	 */
	@TestVisible
	private static final transient String OPENAM_COOKIE_NAME = 'iPlanetDirectoryPro';
	
	/**
	 * The name of the cookie for the load balancer
	 */
	@TestVisible 
	private static final transient String LB_COOKIE_NAME = 'amlbcookie';
	
	/**
	 * The list of cookies that should be cached
	 */
	private static final transient String[] COOKIES_TO_CACHE = new String[] {
		OPENAM_COOKIE_NAME,
		LB_COOKIE_NAME
	};
	
	/**
	 * The delimiter between the cookie name and value in the HTTP header
	 */
	@TestVisible
	private static final transient String COOKIE_NAME_VALUE_DELIM = '=';
	
	/**
	 * The delimiter between different cookies in the HTTP header
	 */
	@TestVisible 
	private static final transient String COOKIE_DELIM = ';';
	
	/**
	 * The name of the Location Http header (used in HTTP status code 302 - redirects)
	 */
	@TestVisible
	private static final transient String LOCATION_HEADER_KEY = 'Location';
	
	/**
	 * Default string representation to use for an empty cookie
	 */
	@TestVisible 
	private static final transient String COOKIE_EMPTY_STRING = '';
	
	public static final transient String CONTENT_TYPE_URL_ENCODED = 'application/x-www-form-urlencoded';
	
	public static final transient String CONTENT_TYPE_JSON = 'application/json';
	
	/**
	 * This class is for holding a single cookie's data fields
	 */
	@TestVisible
	private class SNG_Cookie {
		
		/**
		 * Cookie name field
		 */
		private transient String name { get; private set; }
		
		/**
		 * Cookie value field
		 */
		private transient String value { get; private set; }
		
		/**
		 * Cookie domain field
		 */
		private transient String domain { get; private set; }
		
		/**
		 * Cookie path field
		 */
		private transient String path { get; private set; }
		
		/**
		 * Cookie expiration DateTime field
		 */
		private transient DateTime expires { get; private set; }
		
		/**
		 * Cookie http field
		 */
		private transient boolean http { get; private set; }
		
		/**
		 * Cookie secure field
		 */
		private transient boolean secure { get; private set; }
		
		/**
		 * Returns the string representation of the cookie
		 *
		 * @return		String representation of the cookie
		 */
		public override String toString() {
			String stringifiedCookie = COOKIE_EMPTY_STRING;
			if (null != name && null != value) {
				stringifiedCookie = name + COOKIE_NAME_VALUE_DELIM + value;
			}
			return stringifiedCookie;
		}
		
	}
		   
    /**
     * Sends an HTTP GET request to the provided URL using the DEFAULT_TIMEOUT
     *
     * @param   url                 	URL to send the HTTP GET request to
     * @throws	SNG_CalloutException	If the specified url is null
     * @throws	CalloutException    	If the send failed for any other reason
     * @return                      	The received HTTP response
     */
    public static HttpResponse sendHttpGetRequest(String url)
    {
        return sendHttpGetRequest(url, DEFAULT_TIMEOUT, true);
    }
	
	/**
     * Sends an HTTP GET request to the provided URL using the provided timeout
     *
     * @param   url                 	URL to send the HTTP GET request to
     * @param   timeout             	The timeout to use in the HTTP GET request
     * @throws	SNG_CalloutException	If the specified url is null
     * @throws	CalloutException    	If the send failed for any other reason
     * @return                      	The received HTTP response
     */
    public static HttpResponse sendHttpGetRequest(String url, integer timeout, boolean cacheCookie)
    {
        HttpRequest httpRequest = constructHttpRequest(url, 'GET', timeout, null, CONTENT_TYPE_URL_ENCODED, false);
		HttpResponse response = sendHttpRequest(httpRequest);
		
		// retry if needed
		if (shouldForceLoginAndRetry(httpRequest, response)) {
			httpRequest = constructHttpRequest(url, 'GET', timeout, null, CONTENT_TYPE_URL_ENCODED, true);
			response = sendHttpRequest(httpRequest);
		}
		
		if (cacheCookie && isAuthRequired(httpRequest.getEndpoint())) {
    		handleCookieCaching(httpRequest.getHeader(COOKIE_HEADER_KEY));
    	}
		
		return response;
    }
	
	/**
	 * Sends an HTTP POST request to the provided URL using the DEFAULT_TIMEOUT with no body.
	 *
	 * @param 	url	                    URL to send the HTTP POST request to
	 * @throws	SNG_CalloutException	If the specified url is null
	 * @throws	CalloutException    	If the send failed for any other reason
	 * @return	   	                    The received HTTP response
	 */
	public static HttpResponse sendHttpPostRequest(String url)
	{
		return sendHttpPostRequest(url, DEFAULT_TIMEOUT);
	}
	
	/**
     * Sends an HTTP POST request to the provided URL using the DEFAULT_TIMEOUT with the specified body
     * This method invocation is for standard HTTP callouts without the 
     * need to self-authenticate.
     *
     * @param   url                     URL to send the HTTP POST request to
     * @param   body                    The request body
     * @throws	SNG_CalloutException	If the specified url is null
     * @throws	CalloutException    	If the send failed for any other reason
     * @return                          The received HTTP response
     */
    public static HttpResponse sendHttpPostRequest(String url, String body, String contentType)
    {
        return sendHttpPostRequest(url, DEFAULT_TIMEOUT, body, contentType, true);
    }
    
    /**
     * Sends an HTTP POST request to the provided URL using the specified timeout with no body.
     * This method invocation is for standard HTTP callouts without the 
     * need to self-authenticate.
     *
     * @param   url                     URL to send the HTTP POST request to
     * @param   timeout                 The timeout to use in the HTTP POST request
     * @throws	SNG_CalloutException	If the specified url is null
     * @throws	CalloutException    	If the send failed for any other reason
     * @return                          The received HTTP response
     */
    public static HttpResponse sendHttpPostRequest(String url, integer timeout)
    {
        return sendHttpPostRequest(url, timeout, null, CONTENT_TYPE_URL_ENCODED, true);
    }
    
    /**
     * Sends an HTTP POST request to the provided URL using the specified timeout and body.
     * This method invocation is for standard HTTP callouts without the 
     * need to self-authenticate.
     *
     * @param   url                     URL to send the HTTP POST request to
     * @param   timeout                 The timeout to use in the HTTP POST request
     * @param   body                    The request body
     * @throws	SNG_CalloutException	If the specified url is null
     * @throws	CalloutException    	If the send failed for any other reason
     * @return                          The received HTTP response
     */
    public static HttpResponse sendHttpPostRequest(String url, integer timeout, String body, String contentType, boolean cacheCookie)
    {
		HttpRequest httpRequest = constructHttpRequest(url, 'POST', timeout, body, contentType, false);
		HttpResponse response = sendHttpRequest(httpRequest);
		
		// retry if needed
		if (shouldForceLoginAndRetry(httpRequest, response)) {
			httpRequest = constructHttpRequest(url, 'POST', timeout, body, contentType, true);
			response = sendHttpRequest(httpRequest);
		}
		
		if (cacheCookie && isAuthRequired(httpRequest.getEndpoint())) {
    		handleCookieCaching(httpRequest.getHeader(COOKIE_HEADER_KEY));
    	}
		
		return response;
    }
	
	/**
	 * Sends out the provided HTTP request and returns the response
	 *
	 * @param 	httpRequest         	HTTP request to send
	 * @throws	CalloutException	    If there is a read timeout, or if the send() method encounters any other error.
	 * @return	                    	The received HTTP response
	 */
	private static HttpResponse sendHttpRequest(HttpRequest httpRequest)
	{
		Http h = new Http();
    	HttpResponse response = h.send(httpRequest);
    	System.debug('HttpRequest: ' + httpRequest);
    	System.debug('HttpRequest.getBody(): ' + httpRequest.getBody());
    	System.debug('response: ' + response);
    	System.debug('response.getBody(): ' + response.getBody());
    	return response;
	}
	
	/**
	 * Constructs an HTTP request with the given URL, method, timeout, and body (if the body is not null)
	 *
	 * @param 	url                 	Endpoint URL to use for the HTTP request
	 * @param 	method              	HTTP request method (ie. GET, POST)
	 * @param 	timeout             	HTTP timeout
	 * @param   body                    The request body
	 * @throws	SNG_CalloutException	If the specified url is null
	 * @return	                    	The constructed HTTP request
	 */
	private static HttpRequest constructHttpRequest(String url, 
													String method, 
													integer timeout, 
													String body, 
													String contentType, 
													final boolean forceLogin)
	{
		if (null == url) {
			// URL is null
			throw new SNG_CalloutException('Specified endpoint (URL) is null');
		} else {
			HttpRequest httpRequest = new HttpRequest();
			httpRequest.setHeader('Content-type', contentType);
			httpRequest.setHeader('Content-length', '0');
			httpRequest.setEndpoint(url);
			httpRequest.setMethod(method);
			httpRequest.setTimeout(timeout);
			
			if (null != body) {
				httpRequest.setBody(body);
			}
			
			if (isAuthRequired(url)) {
				httpRequest = handleLogin(httpRequest, forceLogin);
			}
			
			return httpRequest;
		}
	}
    
    /**
     * Copies cookie from SET-COOKIE header in HttpResponse to Cookie header in HttpRequest
     *
     * @param 	copyFrom	HttpResponse to copy cookie from
     * @param 	copyTo  	HttpRequest to copy cookie to
     * @return	        	Returns copyTo, the HttpRequest with the cookie copied into it
     */
     private static HttpRequest copyCookie(String cookieStr, HttpRequest copyTo) {
		copyTo.setHeader(COOKIE_HEADER_KEY, cookieStr);
		return copyTo;
     }
     
     /**
      * Checks if the given URL String requires an OpenAM authentication cookie
      *
      * @param 	url	The URL String to check
      * @return	   	Whether the URL requires authentication
      */
      private static boolean isAuthRequired(final String url) {
      	return isAuthRequired(new URL(url));
      }
      
      /**
      * Checks if the given URL requires an OpenAM authentication cookie
      *
      * @param  url The URL to check
      * @return     Whether the URL requires authentication
      */
      private static boolean isAuthRequired(final URL url) {
      	boolean authRequired = false;
        
        final String urlHost = url.getHost();
        for (URL u : URLS_REQUIRING_AUTH) {
            if (u.getHost() == urlHost) {
                authRequired = true;
                break;
            }
        }
        
        return authRequired;
      }
      
      /**
       * Handles doing OpenAM login if we don't already have a cookie, and copying the cookie
       * into the given HttpRequest
       *
       * @param 	httpRequest	The HttpRequest to add the cookie to
       * @return	           	The HttpRequest with the cookie added
       */
      @TestVisible
      private static HttpRequest handleLogin(HttpRequest httpRequest, final boolean forceLogin) {
      	try {
      		String cookieStr = SNGWebService__c.getValues(Label.SNGOpenAMLogin).AuthCookieCache__c;
	        Map<String, SNG_Cookie> cachedCookies = parseCookies(cookieStr);
	        if (forceLogin || !isCookieValid(cachedCookies.get(OPENAM_COOKIE_NAME))) {
	            final String authToken = OpenAMAuthService.getAuthToken(OPENAM_BASE_URL.toExternalForm(), OPENAM_USERNAME, OPENAM_PASSWORD);
	            if (null != authToken) {
	                cookieStr = OPENAM_COOKIE_NAME + COOKIE_NAME_VALUE_DELIM + authToken;
	            } else {
	                throw new SNG_CalloutException('Authentication Error - Null Auth Token');
	            }
	        }
	        
	        return copyCookie(cookieStr, httpRequest);
      	} catch (OpenAMAuthService.OpenAMAuthServiceException e) {
      		throw new SNG_CalloutException('Authentication Error - ' + e.getMessage());
      	}
      }
      
      /**
       * Handles caching of the cookie(s)
       *
       * @param 	cookiesStr	Cookies string to cache
       * @throws	Exception 	If caching failed
       */
      @TestVisible 
      @future
      private static void handleCookieCaching(final String cookiesStr) {

      	try {
      		Map<String, SNG_Cookie> cookies = parseCookies(cookiesStr);
	      	String cookiesToCacheStr = '';
	      	boolean cachingAtLeastOneCookie = false;
	      	for (String cookie : COOKIES_TO_CACHE) {
	      		SNG_Cookie cookieToCache = cookies.get(cookie);
	      		if (shouldCookieBeCached(cookieToCache)) {
		      		if (cachingAtLeastOneCookie) {
		      			cookiesToCacheStr += COOKIE_DELIM + ' ';
		      		}
		      		
		      		cookiesToCacheStr += cookieToCache;
		      		cachingAtLeastOneCookie = true;
	      		}
	      	}
	      	
	      	if (cachingAtLeastOneCookie) {
	      		SNGWebService__c openamWebService = [SELECT AuthCookieCache__c FROM SNGWebService__c WHERE Name = :Label.SNGOpenAMLogin FOR UPDATE];
	      		openamWebService.AuthCookieCache__c = cookiesToCacheStr;
	      		update openamWebService;
	      	}
      	} catch (Exception e) {
      		// Caching failed. Don't need to notify the user since we always try to cache.
      		// TODO Notify developer? Just throwing the exception for now to notify the developer.
      		//      Since this is a @future method it shouldn't cause any other code to not execute.
      		System.debug(LoggingLevel.ERROR, 'Caught Exception when attempting to cache cookie. ' + e.getMessage() + '\n' + e.getStackTraceString());
      		throw e;
      	}
      }
      
      /**
       * Parses the cookies string into a map with each cookie name matched to a corresponding
       * SNG_Cookie object
       *
       * @param 	cookies  	The String containing all cookie data (straight from the HTTP header)
       * @return	cookieMap	The map from cookie name to SNG_Cookie object
       */
      private static Map<String, SNG_Cookie> parseCookies(String cookies) {
      	Map<String, SNG_Cookie> cookieMap = new Map<String, SNG_Cookie>();
      	
      	if (null != cookies) {
      		String[] cookieStrArray = cookies.split(COOKIE_DELIM);
	      	for (String cookieStr : cookieStrArray) {
	      		SNG_Cookie cookie = parseCookie(cookieStr);
	      		cookieMap.put(cookie.name, cookie);
	      	}
      	}
      	
      	return cookieMap;
      }
      
      /**
       * Determines whether cookie should be cached or not
       *
       * @param 	cookie	Cookie
       * @return	      	Whether or not the cookie should be cached
       */
      private static boolean shouldCookieBeCached(SNG_Cookie cookie) {
      	boolean result = false;
      	
      	if (null != cookie && null != cookie.name && null != cookie.value) {
      		for (String cookieName : COOKIES_TO_CACHE) {
	      		if (cookie.name == cookieName) {
	      			result = true;
	      			break;
	      		}
	      	}
      	}
      	
      	return result;
      }
      
      /**
       * Parses a single cookie String into a SNG_Cookie object
       *
       * @param 	cookieStr	Cookie string
       * @return	         	SNG_Cookie object corresponding with the given cookie string
       */
      private static SNG_Cookie parseCookie(String cookieStr) {      	
      	SNG_Cookie cookie = new SNG_Cookie();
      	String[] cookieParts = cookieStr.split(COOKIE_NAME_VALUE_DELIM);
      	cookie.name = cookieParts[0];
      	
      	// looks like some cookies only have a name? ie. secure
      	if (cookieParts.size() > 1) {
      		cookie.value = cookieParts[1];
      		// TODO Somehow parse other parts of cookie if possible?
      	}
      	
      	return cookie;
      }
      
      /**
       * Determines whether or not the cookie is valid
       *
       * @param 	cookie	Cookie
       * @return	      	True if valid, otherwise false
       */
      private static boolean isCookieValid(SNG_Cookie cookie) {
      	return (null != cookie && (null == cookie.expires || cookie.expires > System.now()));
      }
      
      /**
       * Determines whether a login should be forced and the httpRequest should be retried
       *
       * @param 	httpRequest	The HTTP request
       * @param 	response   	The response to the HTTP request which needs to be evaluated
       * @return	           	True if a login should be forced and the httpRequest should be retried, otherwise false
       */
      private static boolean shouldForceLoginAndRetry(final HttpRequest httpRequest, final HttpResponse response) {
      	boolean result = false;
      	// make sure the request was not initially to the LOGIN_URL
      	final URL requestUrl = new URL(httpRequest.getEndpoint());
      	if (requestUrl.getHost() != OPENAM_BASE_URL.getHost()) {
      		// if redirect - found status
	      	if (SNGHttpUtilities.STATUS_CODE.FOUND == response.getStatusCode()) {
	      		// get the location header
	      		String location = response.getHeader(LOCATION_HEADER_KEY);
	      		if (null != location) {
	      			final URL locationUrl = new URL(location);
	      			if (locationUrl.getHost() == OPENAM_BASE_URL.getHost()) {
	      				System.debug('OpenAM token must have expired. Need to force login and retry.');
	      				result = true;
	      			}
	      		}
	      	}
      	}
      	
      	return result;
      }
}