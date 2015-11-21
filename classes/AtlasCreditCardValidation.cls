public with sharing class AtlasCreditCardValidation {
    public static Boolean isValid(String CardType,String CardNumber)
    {
        CardNumber=CardNumber.replace(' ','');
        Boolean ret=false;        
        if(CardType=='MASTERCARD')
        {
            ret = true;
            //prefix: 51->55
            ret = ret && (checkPrefix(CardNumber, '51') 
            || checkPrefix(CardNumber, '52')
            || checkPrefix(CardNumber, '53')
            || checkPrefix(CardNumber, '55')
            || checkPrefix(CardNumber, '54'));
            //length: 16
            ret = ret && CardNumber.length()==16;
            //mod 10
            ret = ret && checkMod10(CardNumber);
        }
        if(CardType=='AMERICAN_EXPRESS')
        {
            ret = true;
            //prefix: 34 or 37
            ret = ret && (checkPrefix(CardNumber, '34')
            || checkPrefix(CardNumber, '37'));
            //length: 15
            ret = ret && CardNumber.length()==15;
            //mod 10
            ret = ret && checkMod10(CardNumber);
            
        }
        if(CardType=='Discover')
        {
            ret = true;
            //prefix: 6011
            ret = ret && checkPrefix(CardNumber, '6011');
            //length: 16
            ret = ret && CardNumber.length()==16;
            //mod 10
            ret = ret && checkMod10(CardNumber);
            
        }
        if(CardType=='VISA')
        {
            ret = true;
            //prefix: 4
            ret = ret && checkPrefix(CardNumber, '4');
            //length: 13 or 16
            ret = ret && (CardNumber.length()==16 || CardNumber.length()==13);
            //mod 10
            ret = ret && checkMod10(CardNumber);
            
        }
        return ret;
    }
    private static Boolean checkPrefix(String CardNumber,String Prefix)
    {
        return CardNumber.startsWith(Prefix);
    }
    
    private static Boolean checkMod10(String CardNumber)
    {
        //first check if all digits are numeric
        if(!pattern.matches('[0-9]+',CardNumber)) return false;
        
        String s = '';
        Integer digit = 0;
        for(Integer d=CardNumber.length()-1; d>=0;d--)
        {
            digit++;
            if(Mod(digit,2)==0)
            {
                Integer i = Integer.valueOf(CardNumber.substring(d,d+1))*2;
                s+=i.format();
            }
            else
            {
                Integer i = Integer.valueOf(CardNumber.substring(d,d+1));
                s+=i.format();
            }
        }
        Integer sum=getSum(s);
        
        return Mod(sum,10)==0;
    }
    private static Integer getSum(String s)
    {
        Integer sum = 0;
        for(Integer d=0; d<s.length();d++)
        {
            sum+=Integer.valueOf(s.substring(d,d+1));
        }
        return sum;
    }
    public static Integer Mod(Integer n,Integer div)
    {   
        while(n>=div)
            n-=div;
        return n;
    }
 
}