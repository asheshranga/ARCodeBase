global with sharing class NumberUtils {

    global static final Integer MAX_INTEGER = 2147483647;
    global static final Integer MIN_INTEGER = -2147483647;

    global static Integer parseInt(String str, Integer radix){
        return parseLong(str,radix).intValue();
    }
    
    global static Long parseLong(String str, Integer radix){
        str = StringUtils.upperCase(StringUtils.trim(str));
        if(StringUtils.isBlank(str)){
            throw new NumberFormatException();
        }
        if(radix < 2 || radix > 36){
            throw new IllegalArgumentException('invalid radix parameter: ' + radix + '; radix must be >= 2 and <= 36');
        }
        Boolean isNegative = false;
        if(StringUtils.startsWith(str, '-')){
            isNegative = true;
            str = StringUtils.removeStart(str, '-');
        }
        String validChars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(0,radix);
        if(!StringUtils.containsOnly(str,validChars)){
            throw new NumberFormatException('Invalid characters found in number: ' + str + ', with radix = ' + radix);
        }
        final Integer LENGTH = StringUtils.length(str);
        Long returnValue = 0;
        for(Integer i = 0; i < LENGTH; i++){
            returnValue +=
                (validChars.indexOf(str.substring(LENGTH-i-1,LENGTH-i))
                * Math.pow(radix,i)).longValue();
        }
        if(isNegative){
            returnValue = -returnValue;
        }
        return returnValue;
    }
    
    global static String toHexString(Integer i){
        return toString(i,16);
    }

    global static String toString(Integer i, Integer radix){
        if(i == null){
            return null;
        }
        return toString((Long)i,radix);
    }
    
    global static String toHexString(Long l){
        return toString(l,16);
    }
    
    global static String toString(Long l, Integer radix){
        if(l == null){
            return null;
        }
        if(radix < 2 || radix > 36){
            throw new IllegalArgumentException('invalid radix parameter: ' + radix + '; radix must be >= 2 and <= 36');
        }
        return (l<0 ? '-' : '') + toStringPrivate(Math.abs(l),radix,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(0,radix));
    }
    
    private static String toStringPrivate(Long l, Integer radix, String validChars){
        Integer r = Math.mod(l,radix).intValue();
        String result;
        if(l-r == 0){ 
            result = StringUtils.charAt(validChars,r);
        }else{ 
            result = toStringPrivate(((l-r)/radix),radix,validChars) + StringUtils.charAt(validChars,r);
        }
        return result;
        
    }
    
}