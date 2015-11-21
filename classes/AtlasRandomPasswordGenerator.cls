/*********************************************************************************
Name         : AtlasRandomPasswordGenerator
Created By   : Sujit Kumar
Company Name : NTT Data
Project      : ViaSat Atlas
Created Date : 25 May, 2014
Modified Date: 25 May, 2014
Usages       : Utility class to generate a random password. The password generated
               is a strong password, verified password strength on passwordmeter.com
*********************************************************************************/
public class AtlasRandomPasswordGenerator {
    
   public static final String PASSWORD_SPECIAL_CHARS = '~!@#$%^.?*~!@#$%^.?*';
       
   public static String getRandomPassword(Integer maxPasswordLength) {
    Blob blobKey = crypto.generateAesKey(128);
      String key = EncodingUtil.convertToHex(blobKey);
      String newPwd = key.substring(0, maxPasswordLength);
      // System.debug('password generated from crypto: ' + newPwd);
      Integer firstRandom = getRandomPositiveNumberNotGreaterThanGivenNumber(maxPasswordLength);
      Integer secondRandom = getRandomPositiveNumberNotGreaterThanGivenNumber(maxPasswordLength, firstRandom);
      newPwd = insertSpecialCharIntoPassword(newPwd, PASSWORD_SPECIAL_CHARS, firstRandom);
      newPwd = insertSpecialCharIntoPassword(newPwd, PASSWORD_SPECIAL_CHARS, secondRandom);
      return newPwd;
   }
   
   private static Integer getRandomPositiveNumberNotGreaterThanGivenNumber(Integer maxLength, Integer notEqualToThis) {
      Integer genRandom = getRandomPositiveNumberNotGreaterThanGivenNumber(maxLength);
      while (genRandom == notEqualToThis) {
         genRandom = getRandomPositiveNumberNotGreaterThanGivenNumber(maxLength);
      }
      return genRandom;
   }
   
   private static Integer getRandomPositiveNumberNotGreaterThanGivenNumber(Integer maxLength) {
      return Math.mod(Math.abs(Crypto.getRandomInteger()), maxLength);
   }
   
   private static String insertSpecialCharIntoPassword(String pwd, String specialChars, Integer pos) {
    // system.debug('pos: ' + pos);
    // system.debug('pwd: ' + pwd);
    String newPassword = null;
    if (pos == 0) {
        newPassword = specialChars.substring(pos, pos+1);
        newPassword += pwd.substring(pos+1);
    } else if (pos == (pwd.length() - 1)) {
        newPassword = pwd.substring(0, pos);
        newPassword += specialChars.substring(pos, pos+1);
    } else {
        newPassword = pwd.substring(0, pos);
        newPassword += specialChars.substring(pos, pos+1);
        newPassword += pwd.substring(pos+1);
    }
    return newPassword;
   }
}