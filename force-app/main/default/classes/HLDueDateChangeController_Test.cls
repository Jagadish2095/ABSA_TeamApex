/** 
 * @description Test HLDueDateChangeController
 * @author Simangaliso Mathenjwa.
 * @since 26 May 2021
 */
@IsTest
public  class HLDueDateChangeController_Test {

    @IsTest
	static void testGetAccountData() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLgetAcctInfoforCUS1V1Service';
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ MLgetAcctInfoCUS1V1_IH_v1.INTEGRATION_SERVICE_NAME }
		);

        Integration_Translation__c SchemaCodeTranslation = new Integration_Translation__c();
        SchemaCodeTranslation.Name = 'Test Schema';
        SchemaCodeTranslation.Internal_Value__c = 'MURRAY & ROBERTS LIMITED';
        SchemaCodeTranslation.External_Value__c = '6630';
        SchemaCodeTranslation.System_Name__c = 'EOML';
        SchemaCodeTranslation.Value_Type__c = 'Schema Code';
        SchemaCodeTranslation.Direction__c = StringConstants.INBOUND_RECORD_TYPE ;
        insert SchemaCodeTranslation;

        Integration_Translation__c InteresetRateTranslation = new Integration_Translation__c();
        InteresetRateTranslation.Name = 'Test Interest Rate Translation';
        InteresetRateTranslation.Internal_Value__c = 'FIXED RATE';
        InteresetRateTranslation.External_Value__c = 'FXR';
        InteresetRateTranslation.System_Name__c = 'EOML';
        InteresetRateTranslation.Value_Type__c = 'Interest Rate Type';
        InteresetRateTranslation.Direction__c = StringConstants.INBOUND_RECORD_TYPE ;
        insert InteresetRateTranslation;
        
        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        //Test.setMock(HttpCalloutMock.class, new MLgetAcctInfoCUS1V1_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        Test.startTest();
		MLgetAcctInfoCUS1V1_Resp_IB_v1 testResponse = HLDueDateChangeController.getAccountData('8050306640');
		System.assertEquals(200, testResponse.statusCode, 'Assert Failed');
		Test.stopTest();
    }

    @IsTest
	static void testUpdateDueDate() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLupdAcctInfoforCUS1V1Service';
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ MLupdAcctInfoCUS1V1_IH_v1.INTEGRATION_SERVICE_NAME }
		);

        Integration_Translation__c InteresetRateTranslation = new Integration_Translation__c();
        InteresetRateTranslation.Name = 'Test Error Code Translation';
        InteresetRateTranslation.Internal_Value__c = '00001 APPLICATION NUMBER NOT ENTERED';
        InteresetRateTranslation.External_Value__c = '1';
        InteresetRateTranslation.System_Name__c = 'EOML';
        InteresetRateTranslation.Value_Type__c = 'HL Error Code';
        InteresetRateTranslation.Direction__c = StringConstants.INBOUND_RECORD_TYPE ;
        insert InteresetRateTranslation;
        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        Test.startTest();
		MLupdAcctInfoCUS1V1_Resp_IB_v1 testResponse = HLDueDateChangeController.updateDueDate('8050306640', 'P001', 25, 12, double.valueOf(1.2));
		System.assertEquals(200, testResponse.statusCode, 'Assert Failed');
		Test.stopTest();
    }
    
}