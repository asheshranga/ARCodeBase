/* ============================================================
 * This code is part of the "apex-lang" open source project avaiable at:
 * 
 *      http://code.google.com/p/apex-lang/
 *
 * This code is licensed under the Apache License, Version 2.0.  You may obtain a 
 * copy of the License at:
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * ============================================================
 */

global with sharing class StringUtils 
{
	global static final String EMPTY = '';
	    
    global static String charAt(String str, Integer index) {
        if(str == null){
            return null;
        }
        if(str.length() <= 0){
            return str;    
        }
        if(index < 0 || index >= str.length()){
            return null;    
        }
        return str.substring(index, index+1);
    }
    
    global static boolean containsOnly(String str, String valid) {
        if ((valid == null) || (str == null)) {
            return false;
        }
        if (str.length() == 0) {
            return true;
        }
        if (valid.length() == 0) {
            return false;
        }
        return indexOfAnyBut(str, valid) == -1;
    }
	
	global static Boolean equals(String str1, String str2) {
        return str1 == null ? str2 == null : str1.equals(str2);
    }
    
    global static Boolean equalsIgnoreCase(String str1, String str2) {
        return str1 == null ? str2 == null : str1.equalsIgnoreCase(str2);
    }   
    
    global static Integer indexOf(String str, String searchStr) {
        if (str == null || searchStr == null) {
            return -1;
        }
        return str.indexOf(searchStr);
    }
    
    global static Integer indexOfAnyBut(String str, String searchChars) {
        if (isEmpty(str) || searchChars == null) {
            return -1;
        }
        for (Integer i = 0; i < str.length(); i++) {
            if(searchChars.contains(charAt(str,i))){
                continue;    
            }
            return i;
        }
        return -1;
    }
    
    global static boolean isBlank(String str) {
        return str == null || str.trim() == null || str.trim().length() == 0;
    }
    
    global static boolean isEmpty(String str) {
        return str == null || str.length() == 0;
    }
	
    global static String joinStrings(List<String> strings, String separator){
        if(strings == null || strings.size() == 0){
            return null;
        }
        Set<String> setToJoin = new Set<String>();
        for(String value : strings){
            setToJoin.add(value);    
        }
        return joinStrings(setToJoin,separator);
    }
	
    global static String joinStrings(Set<String> strings, String separator){
        return joinSet(strings,separator);
    }
    
    global static String joinSet(Set<String> stringSet, String separator){ 
        return joinSet(SetUtils.stringToObject(stringSet),separator);
    }
    
    global static String joinSet(Set<Object> objectSet, String separator){
        if(objectSet == null || objectSet.size() == 0){
            return null;
        }
        Boolean isFirst = true;
        String returnString = '';
        for(Object anObject : objectSet){
            if(StringUtils.isBlank(''+anObject)){
                continue;
            }
            if(isFirst){
                isFirst = false;
            }else{
                if(separator != null){
                    returnString += separator;
                }
            }
            if(anObject instanceof Blob){ returnString += '' + ((Blob)anObject).toString() + '';
            } else if(anObject instanceof Boolean){ returnString += ((Boolean)anObject);
            } else if(anObject instanceof Date){ returnString += '' + ((Date)anObject) + '';
            } else if(anObject instanceof Datetime){ returnString += '' + ((Datetime)anObject) + '';
            } else if(anObject instanceof Integer){ returnString += ((Integer)anObject);
            } else if(anObject instanceof Long){ returnString += ((Long)anObject);
            } else if(anObject instanceof Decimal){ returnString += ((Decimal)anObject);
            //} else if(anObject instanceof Double){ returnString += ((Double)anObject);
            } else if(anObject instanceof String){ returnString += '' + ((String)anObject) + '';
            //} else if(anObject instanceof ID){ returnString += '' + ((ID)anObject) + '';
            //} else if(anObject instanceof Time){ returnString += '' + ((Time)anObject) + '';
            }
        }
        return returnString;    
    }
    
    global static Integer length(String str) {
        return str == null ? 0 : str.length();
    }  
    
    global static boolean regionMatches(String str, boolean ignoreCase,
        Integer toffset, String other, Integer ooffset, Integer len){
        
        str = substring(str,toffset,toffset+len);
        other = substring(other,ooffset,ooffset+len);
        if(ignoreCase){
            return equalsIgnoreCase(str, other);            
        }
        return equals(str, other);                              
    }
    
     global static boolean regionMatches(String str, Integer toffset, String other, Integer ooffset, Integer len){
        return regionMatches(str,false,toffset,other,ooffset,len);
    }
    
    global static boolean regionMatchesIgnoreCase(String str, Integer toffset, String other, Integer ooffset, Integer len){
        return regionMatches(str,true,toffset,other,ooffset,len);
    }
    
        global static String removeStart(String str, String remove) {
        if (isEmpty(str) || isEmpty(remove)) {
            return str;
        }
        if (str.startsWith(remove)){
            if(remove.length() >= str.length()){
                return '';              
            } else {
                return str.substring(remove.length());
            }
        }
        return str;
    }
    
    global static String replaceChars(String str, String searchChars, String replaceChars) {
        if (isEmpty(str) || isEmpty(searchChars)) {
            return str;
        }
        if (replaceChars == null) {
            replaceChars = EMPTY;
        }
        Boolean modified = false;
        Integer replaceCharsLength = replaceChars.length();
        Integer strLength = str.length();
        String buf = '';
        for (Integer i = 0; i < strLength; i++) {
            String ch = charAt(str,i);
            Integer index = indexOf(searchChars,ch);
            if (index >= 0) {
                modified = true;
                if (index < replaceCharsLength) {
                    buf += charAt(replaceChars,index);
                }
            } else {
                buf += ch;
            }
        }
        if (modified) {
            return buf;
        }
        return str;
    }
    
    global static String reverse(String str) {
        if (str == null) {
            return null;
        }
        String returnString = '';
        for(Integer i = (str.length()-1); i >= 0; i--){
            returnString += charAt(str,i);
        }
        return returnString;
    }

    global static String rightPad(String str, Integer size, String padStr) {
        if (str == null) {
            return null;
        }
        if (isEmpty(padStr)) {
            padStr = ' ';
        }
        Integer padLen = padStr.length();
        Integer strLen = str.length();
        Integer padCharCount = size - strLen;
        if (padCharCount <= 0) {
            return str; // returns original String when possible
        }

        if (padCharCount == padLen) {
            return str + padStr;
        } else if (padCharCount < padLen) {
            return str + padStr.substring(0, padCharCount);
        } else {
            String padding = '';
            for (Integer i = 0; i < padCharCount; i++) {
                padding += padStr.substring(Math.mod(i,padLen),Math.mod(i,padLen)+1);
            }
            return str + padding;
        }
    }
    
    global static String substring(String str, Integer startIndex, Integer endIndex) {
        if (str == null) {
            return null;
        }
        // handle negatives
        if (endIndex < 0) {
            endIndex = str.length() + endIndex; // remember endIndex is negative
        }
        if (startIndex < 0) {
            startIndex = str.length() + startIndex; // remember startIndex is negative
        }

        // check length next
        if (endIndex > str.length()) {
            endIndex = str.length();
        }

        // if startIndex is greater than endIndex, return ''
        if (startIndex >= endIndex) {
            return EMPTY;
        }

        if (startIndex < 0) {
            startIndex = 0;
        }
        if (endIndex < 0) {
            endIndex = 0;
        }
        return str.substring(startIndex, endIndex);
    }
     
    global static String[] split(String str) {
        return split(str, null, -1);
    }
 
    global static String[] split(String str, String separatorChars) {
        return splitWorker(str, separatorChars, -1, false);
    }
    
    global static String[] split(String str, String separatorChars, Integer max) {
        return splitWorker(str, separatorChars, max, false);
    }   
    
    global static String[] splitPreserveAllTokens(String str) {
        return splitWorker(str, null, -1, true);
    }

    global static String[] splitPreserveAllTokens(String str, String separatorChars) {
        return splitWorker(str, separatorChars, -1, true);
    }

    global static String[] splitPreserveAllTokens(String str, String separatorChars, Integer max) {
        return splitWorker(str, separatorChars, max, true);
    }        

    private static String[] splitWorker(
        String str, String separatorChars, 
        Integer max, boolean preserveAllTokens) {
            
        //' abc ',null, -1, true

        if (str == null) {return null;}
        Integer len = str.length();
        if (len == 0) { return new String[]{}; }

        List<String> theList = new List<String>();
        Integer sizePlus1 = 1;
        Integer i = 0, start = 0;
        boolean match = false;
        boolean lastMatch = false;
        if (separatorChars == null) {
            // Null separator means use whitespace
            while (i < len) {
            	String charAt = charAt(str,i);
            	
                if (charAt.isWhitespace()) {
                    if (match || preserveAllTokens) {
                        lastMatch = true;
                        if (sizePlus1++ == max) {
                            i = len;
                            lastMatch = false;
                        }
                        if(start == i){
                            theList.add('');
                        } else {
                            theList.add(str.substring(start, i));
                        }
                        match = false;
                    }
                    start = ++i;
                    continue;
                }
                lastMatch = false;
                match = true;
                i++;
            }
        } else if (separatorChars.length() == 1) {
            // Optimise 1 character case
            String sep = charAt(separatorChars,0);
            while (i < len) {
                if (charAt(str,i) == sep) {
                    if (match || preserveAllTokens) {
                        lastMatch = true;
                        if (sizePlus1++ == max) {
                            i = len;
                            lastMatch = false;
                        }
                        if(start == i){
                            theList.add('');
                        } else {
                            theList.add(str.substring(start, i));
                        }
                        match = false;
                    }
                    start = ++i;
                    continue;
                }
                lastMatch = false;
                match = true;
                i++;
            }
        } else {
            // standard case
            while (i < len) {
                if (separatorChars.indexOf(charAt(str,i)) >= 0) {
                    if (match || preserveAllTokens) {
                        lastMatch = true;
                        if (sizePlus1++ == max) {
                            i = len;
                            lastMatch = false;
                        }
                        theList.add(start == i ? '' : str.substring(start, i));
                        match = false;
                    }
                    start = ++i;
                    continue;
                }
                lastMatch = false;
                match = true;
                i++;
            }
        }
        if (match || (preserveAllTokens && lastMatch)) {
            if(start == i){
                theList.add('');
            } else {
                theList.add(str.substring(start, i));
            }
        }
        return theList;
    }    
    
    global static boolean startsWith(String str, String prefix) {
        return startsWith(str, prefix, false);
    }

    private static boolean startsWith(String str, String prefix, boolean ignoreCase) {
        if (str == null || prefix == null) {
            return (str == null && prefix == null);
        }
        if (prefix.length() > str.length()) {
            return false;
        }
        return regionMatches(str, ignoreCase, 0, prefix, 0, prefix.length());
    }  
    
    global static String trim(String str){
        if(str == null){
            return null;
        }
        return str.trim();
    }
    
    global static String upperCase(String str) {
        if (str == null) {
            return null;
        }
        return str.toUpperCase();
    }   
}