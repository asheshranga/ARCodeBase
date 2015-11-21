/*
 * Initial Author: Sujit Kumar
 * Test Class for the Apex Class AtlasRandomPasswordGenerator
 */

@isTest
public with sharing class AtlasRandomPasswordGeneratorTest {

   public static testmethod void testGetPassword_checkLengthAndContents_Atleast2SpecialChars() {
   	Integer passwordLength = 10;
      String generatedPassword = AtlasRandomPasswordGenerator.getRandomPassword(passwordLength);
      // Check length of generated password
      System.assertEquals(generatedPassword.length(), passwordLength);
      Integer countOfSpecialChars = 0;
      for (Integer i = 0; i < passwordLength; ++i) {
      	String charAtPos = generatedPassword.substring(i, i+1);
      	if (AtlasRandomPasswordGenerator.PASSWORD_SPECIAL_CHARS.indexOf(charAtPos) > -1) {
      		countOfSpecialChars++;
      	}
      }
      // Check count of special chars
      System.assertEquals(countOfSpecialChars, 2);
   }
}