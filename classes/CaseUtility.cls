/*****************************************************************
Name          : CaseUtility
Created By    : P. Labaye
Company Name  : ViaSat
Project       : case 381724
Created Date  : April 2015
Modified Date : 
******************************************************************/


public with sharing class CaseUtility {

// case 381724
    private static final Integer MAX_NOTIF_EMAIL = 10; // the code works for any number of fields - increase this value if more than 10 fields are needed.
    private static final String CASE_NOTIF_FLD = 'notificationemail';
    


    // Clear all notification emails
    public static void clearCaseNotificationEmails(Case c)
    {   
        try             
        { 
            for (integer index=1; index <= MAX_NOTIF_EMAIL; index++)
            {
                String fldName = CASE_NOTIF_FLD + index + '__c';
                c.put(fldName, null);  
                System.debug('fldName:' + fldName + ' set to null');        
            }
        }
        catch (Exception e)
        {
            // expected exception (stop when out of fields)
            System.debug('exception:' + e);     
        }

        
    }
    
    // Add notification Email Address
    public static void addCaseNotificationEmail(Case c, string email)
    {
            
        try             
        { 
            for (integer index=1; index <= MAX_NOTIF_EMAIL; index++)
            {
                String fldName = CASE_NOTIF_FLD + index + '__c';
                String currentEmail = (String)c.get(fldName);
                if (currentEmail == null)
                {                   
                    c.put(fldName, email);
                    System.debug('fldName:' + fldName + ' set to: ' + email);
                    // done
                    break;          
                }           
                else if (currentEmail == email)
                {
                    // user already in the list of approvers
                    break;
                }
            }
        }
        catch (Exception e)
        {
            c.adderror('Unable to add email notification('+ email + ')' );
        }   
        
    }
        
    
    
    
 
    
    
    

}