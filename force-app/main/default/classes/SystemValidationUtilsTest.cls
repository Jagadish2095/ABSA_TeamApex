/**
* Test class for the SystemValidationUtils class.
*
* @author   Peter Guest
* @since    2019-03-07
**/
@IsTest
private class SystemValidationUtilsTest {

    /**
    * Test for the rsaIdNumber method in the SystemValidationUtils class. 
    * 
    **/
    @IsTest
    public static void testRsaIdNumber() {

        //Valid - String
        String validIdNumber1 = '8503265339080';      
        System.assertEquals(true, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, validIdNumber1));

        //Valid - Long
        Long validIdNumber2 = 8503265339080L;     
        System.assertEquals(true, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, validIdNumber2));

        //Valid - String
        String validIdNumber3 = '8801270002085';     
        System.assertEquals(true, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, validIdNumber3));

        //Invalid - Month
        String invalidIdNumber1 = '8532265339080';     
        System.assertEquals(false, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, invalidIdNumber1));

        //Invalid - Day
        String invalidIdNumber5 = '8503415339080';     
        System.assertEquals(false, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, invalidIdNumber5)); 

        //Invalid - Numeric
        String invalidIdNumber2 = '8503265A39080';     
        System.assertEquals(false, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, invalidIdNumber2));

        //Invalid - Empty
        String invalidIdNumber3 = '';     
        System.assertEquals(false, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, invalidIdNumber3));

        //Invalid - Null
        String invalidIdNumber4 = null;     
        System.assertEquals(false, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, invalidIdNumber4)); 

        //Invalid - Length
        String invalidIdNumber6 = '0123';     
        System.assertEquals(false, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, invalidIdNumber6));

        //Invalid - Citizenship
        String invalidIdNumber7 = '8503265339280';     
        System.assertEquals(false, SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, invalidIdNumber7));    
    }
}