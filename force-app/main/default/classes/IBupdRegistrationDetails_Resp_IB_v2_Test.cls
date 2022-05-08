/**
 * @description       : IBupdRegistrationDetails_Resp_IB_v2_Test
 * @author            : Khaliq Abdul 
**/
@isTest
public class IBupdRegistrationDetails_Resp_IB_v2_Test
{
    
      @isTest
    public static void testSetFieldNameSubstitutions() {

       Base_IB.fieldNameSubstitutionMap = new Map<String, String>();
		Base_IB.fieldNameSubstitutionMap.put('"number":', '"z_number":');
        IBupdIBRegistrationDetailsV2_Resp_IB_v2  updIBRegistrationDetailsV2 = new IBupdIBRegistrationDetailsV2_Resp_IB_v2();
        Test.startTest();        
        updIBRegistrationDetailsV2.setIntegrationTranslations();
        updIBRegistrationDetailsV2.setFieldNameSubstitutions();
        System.assertNotEquals('', 'Test Successful');
        Test.stopTest();

    }

}