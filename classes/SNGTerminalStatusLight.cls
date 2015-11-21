public with sharing class SNGTerminalStatusLight 
{
    public static final transient String GREEN_DOT_FILENAME = 'Agdot16.png';
    public static final transient String YELLOW_DOT_FILENAME = 'Bydot16.png';
    public static final transient String RED_DOT_FILENAME = 'Crdot16.png';
    public static final transient String GRAY_DOT_FILENAME = 'Dgreydot16.png';
    
    public enum DotColor { GREEN, YELLOW, RED, GRAY }
    	
    public static DotColor getDotColor(String fieldValue) 
    {
        DotColor dot;
        
        if (null != fieldValue) {
        	if (fieldValue.contains(GREEN_DOT_FILENAME)) {
	            dot = DotColor.GREEN;
	        } else if (fieldValue.contains(YELLOW_DOT_FILENAME)) {
	            dot = DotColor.YELLOW;
	        } else if (fieldValue.contains(RED_DOT_FILENAME)) {
	            dot = DotColor.RED;
	        } else {
	            dot = DotColor.GRAY;
	        }
        } else {
        	dot = DotColor.GRAY;
        }
        
        
        return dot;
    }
 
  
    public static String getPathToStatusImage(DotColor dot) 
    {

         String statusLightFileName = '/resource/SNGDots/SNGDots/';
    
         if (DotColor.GREEN == dot)
             statusLightFileName += GREEN_DOT_FILENAME;
         else if (DotColor.YELLOW == dot)
             statusLightFileName += YELLOW_DOT_FILENAME;
         else if (DotColor.RED == dot)
             statusLightFileName += RED_DOT_FILENAME;
         else 
             statusLightFileName += GRAY_DOT_FILENAME;
     
         return statusLightFileName; 

    }
 
}