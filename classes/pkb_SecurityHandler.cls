public with sharing class pkb_SecurityHandler {

    
    /**
     * @description
     *  Constants
     **/
     public static final String  ERROR_OBJECT_NOT_ACCESSIBLE = 'You do not have access to the following objects: {0}. Please contact your Salesforce Administrator for assistance.';
     public static final String  ERROR_OBJECT_NOT_UPDATEABLE = 'You cannot update the following objects: {0}. Please contact your Salesforce Administrator for assistance.';
     public static final String  ERROR_OBJECT_NOT_CREATEABLE = 'You cannot create the following objects: {0}. Please contact your Salesforce Administrator for assistance.';
     public static final String  ERROR_OBJECT_NOT_DELETABLE = 'You cannot delete the following objects: {0}. Please contact your Salesforce Administrator for assistance.';
     public static final String  ERROR_FIELD_NOT_ACCESSIBLE = 'You do not have access to the following fields: {0} Please contact your Salesforce Administrator for assistance.';
     public static final String  ERROR_FIELD_NOT_UPDATEABLE = 'You cannot update the following fields: {0} Please contact your Salesforce Administrator for assistance.';
     public static final String  ERROR_FIELD_NOT_CREATEABLE = 'You cannot create the following fields: {0} Please contact your Salesforce Administrator for assistance.'; 
     
    
    public static Boolean securityEnabled { get; set; }
    public static Boolean isPrivateSharingEnabled { get; set; }
    
    static {
        securityEnabled = true;
        isPrivateSharingEnabled = true;
    }
     
    public static Boolean isGuestUser(){
        List<UserLicense> up = [select Name from UserLicense Where Id IN ( select UserLicenseId from Profile where Id = :UserInfo.getProfileId() ) LIMIT 1 ];
        return up[0].Name == 'Guest';
    }

    // Batch methods
    
    public static Boolean isAccessible(Schema.SObjectType[] objectTypeList) {
        if (securityEnabled) {
            for (Schema.SObjectType objectType : objectTypeList) {
                if (!objectType.getDescribe().isAccessible()) {
                    return false;
                }
            }
        }
        return true;
    }
    
    public static Boolean isUpdateable(Schema.SObjectType[] objectTypeList) {
        if (securityEnabled) {
            for (Schema.SObjectType objectType : objectTypeList) {
                if (!objectType.getDescribe().isUpdateable()) {
                    return false;
                }
            }
        }
        return true;
    }
    
    public static Boolean isCreateable(Schema.SObjectType[] objectTypeList) {
        if (securityEnabled) {
            for (Schema.SObjectType objectType : objectTypeList) {
                if (!objectType.getDescribe().isCreateable()) {
                    return false;
                }
            }
        }
        return true;
    }
      
    public static Boolean isDeletable(Schema.SObjectType[] objectTypeList) {
        if (securityEnabled) {
            for (Schema.SObjectType objectType : objectTypeList) {
                if (!objectType.getDescribe().isDeletable()) {
                    return false;
                }
            }
        }
        return true;
    }
    
    public static Boolean isAccessible(Schema.SObjectField[] fieldList) {
        if (securityEnabled) {
            for (Schema.SObjectField field : fieldList) {
                if (!field.getDescribe().isAccessible()) {
                    return false;
                }
            }
        }
        return true;
    }
    
    public static Boolean isUpdateable(Schema.SObjectField[] fieldList) {
        if (securityEnabled) {
            for (Schema.SObjectField field : fieldList) {
                if (!field.getDescribe().isUpdateable()) {
                    return false;
                }
            }
        }
        return true;
    }
    
    public static Boolean isCreateable(Schema.SObjectField[] fieldList) {
        if (securityEnabled) {
            for (Schema.SObjectField field : fieldList) {
                if (!field.getDescribe().isCreateable()) {
                    return false;
                }
            }
        }
        return true;
    } 
    
    // single element methods
    
    public static Boolean isAccessible(Schema.SObjectType objectType) {
        return isAccessible(new Schema.SObjectType[] {objectType});
    }
    
    public static Boolean isUpdateable(Schema.SObjectType objectType) {
        return isUpdateable(new Schema.SObjectType[] {objectType});
    }
    
    public static Boolean isCreateable(Schema.SObjectType objectType) {
        return isCreateable(new Schema.SObjectType[] {objectType});
    }
      
    public static Boolean isDeletable(Schema.SObjectType objectType) {
        return isDeletable(new Schema.SObjectType[] {objectType});
    }
    
    public static Boolean isAccessible(Schema.SObjectField field) {
        return isAccessible(new Schema.SObjectField[] {field});
    }
    
    public static Boolean isUpdateable(Schema.SObjectField field) {
        return isUpdateable(new Schema.SObjectField[] {field});
    }
    
    public static Boolean isCreateable(Schema.SObjectField field) {
        return isCreateable(new Schema.SObjectField[] {field});
    }   
    
    // Exception throwers
    
    // Batch methods
    
    public static void canAccess(Schema.SObjectType[] objectTypeList) {
        if (!isAccessible(objectTypeList)) {
            throw new SecurityException(formatReplace(ERROR_OBJECT_NOT_ACCESSIBLE, new String[] {toString(objectTypeList)}));
        }
    }
    
    public static void canUpdate(Schema.SObjectType[] objectTypeList) {
        if (!isUpdateable(objectTypeList)) {
            throw new SecurityException(formatReplace(ERROR_OBJECT_NOT_UPDATEABLE, new String[]{toString(objectTypeList)}));
        }
    }
    
    public static void canCreate(Schema.SObjectType[] objectTypeList) {
        if (!isCreateable(objectTypeList)) {
            throw new SecurityException(formatReplace( ERROR_OBJECT_NOT_CREATEABLE, new String[] {toString(objectTypeList)}));
        }
    }
      
    public static void canDelete(Schema.SObjectType[] objectTypeList) {
        if (!isDeletable(objectTypeList)) {
            throw new SecurityException(formatReplace( ERROR_OBJECT_NOT_DELETABLE, new String[] {toString(objectTypeList)}));
        }
    }
    
    public static void canAccess(Schema.SObjectField[] fieldList) {
        if (!isAccessible(fieldList)) {
            throw new SecurityException(formatReplace( ERROR_FIELD_NOT_ACCESSIBLE, new String[] {toString(fieldList)}));
        }
    }
    
    public static void canUpdate(Schema.SObjectField[] fieldList) {
        if (!isUpdateable(fieldList)) {
            throw new SecurityException(formatReplace( ERROR_FIELD_NOT_UPDATEABLE, new String[] {toString(fieldList)}));
        }
    }
    
    public static void canCreate(Schema.SObjectField[] fieldList) {
        if (!isCreateable(fieldList)) {
            throw new SecurityException(formatReplace( ERROR_FIELD_NOT_CREATEABLE, new String[] {toString(fieldList)}));
        }
    } 
    
    // single element methods
    
    public static void canAccess(Schema.SObjectType objectType) {
        canAccess(new Schema.SObjectType[] {objectType});
    }
    
    public static void canUpdate(Schema.SObjectType objectType) {
        canUpdate(new Schema.SObjectType[] {objectType});
    }
    
    public static void canCreate(Schema.SObjectType objectType) {
        canCreate(new Schema.SObjectType[] {objectType});
    }
      
    public static void canDelete(Schema.SObjectType objectType) {
        canDelete(new Schema.SObjectType[] {objectType});
    }
    
    public static void canAccess(Schema.SObjectField field) {
        canAccess(new Schema.SObjectField[] {field});
    }
    
    public static void canUpdate(Schema.SObjectField field) {
        canUpdate(new Schema.SObjectField[] {field});
    }
    
    public static void canCreate(Schema.SObjectField field) {
        canCreate(new Schema.SObjectField[] {field});
    }   
    
    // output helper functions
    
    public static String toString(Schema.SObjectType[] objectTypeList) {        
        String result = '';
        if (!objectTypeList.isEmpty()) {
            result = objectTypeList[0].getDescribe().getLabel();
            for (Integer i = 1; i < objectTypeList.size(); ++i) {
                result += ', ' + objectTypeList[i].getDescribe().getLabel();
            }
        }
        return result;
    }
    
    public static String toString(Schema.SObjectField[] fieldList) {
        String result = '';
        if (!fieldList.isEmpty()) {
            result = fieldList[0].getDescribe().getLabel();
            for (Integer i = 1; i < fieldList.size(); ++i) {
                result += ', ' + fieldList[i].getDescribe().getLabel();
            }
        }
        return result;
    }
    
    /**
    * Converts the input string to a comma separated, single quote escaped string,
    * surrounded by parenthesis. This format is suitable for dynamic SOQL queries. 
    * @param oList a list of objects
    * @return a string formated for SOQL queries.
    */
    public static String queryFormat(List<Object> oList) {
        List<String> values = new List<String>();
        mapList(oList, values, new EscapeQuotesMapper());
        List<String> quotedValues = new List<String>();
        mapList(values, quotedValues, new QuoteMapper());      
        return '(' + joinList(quotedValues, ',') + ')';
    }
    /**
    * @param oList list of strings to be joined
    * @param separator the string that will separate the items of oList in the joined string
    * @return a string with all the elelments of oList concateneted and separated with separator
    */
    public static String joinList(List<Object> oList, String separator) {
        String result = '';
        Integer iter = 0;
        Integer iterEnd = oList.size();
        if (iter != iterEnd) {
            result += oList[iter++];
            while (iter != iterEnd) {
                result += separator + oList[iter++];
            }
        }
        return result;
    }
    
    public interface Mapper {
        Object mapObject(Object o);
    }   
    public class EscapeQuotesMapper implements Mapper { 
        public Object mapObject(Object o) {
            return String.escapeSingleQuotes(String.valueOf(o));
        }   
    }
    
    public class QuoteMapper implements Mapper {
        public Object mapObject(Object o) {
            return '\'' + o + '\'';
        }
    }
    /**
    * Maps the content of a list to another list using a Mapper object.
    * @param oList input list to map
    * @param output the output list where the result will be added.
    * @param m a Mapper object
    */
    public static void mapList(List<Object> oList, List<Object> output, Mapper m) {
        for (Object o : oList) {
            output.add(m.mapObject(o));
        }
    }
    
    public static String formatReplace(String value, List<String> lstStr){
        
        String res = value;
        
        for( Integer i=0; i<lstStr.size(); i++ ){
            if( String.isNotBlank(lstStr[i]) ) 
                res = res.replaceAll('\\{'+i+'\\}', lstStr[i]);
        }
        return res;
    }
    
    public with sharing class SecurityException extends Exception {}
    
    
    public static Map<String, Boolean> getKAVPermissions() {
        Map<String,Boolean> res = new Map<String,Boolean>();
        Map<String,Schema.SOBjectType> gd = Schema.getGlobalDescribe();

        for (String s : gd.keySet()) {
            if (s.contains('__kav')) {
                res.put(gd.get(s).getDescribe().getName(),gd.get(s).getDescribe().isAccessible() );
            }
        }
        return res ;
    }
}