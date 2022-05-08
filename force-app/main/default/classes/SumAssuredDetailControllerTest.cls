/**
 * @description Test class for SumAssuredDetailController
 * @author Koketso Mpshane
 * @since  2021-06-23
 */
@isTest
public class SumAssuredDetailControllerTest {
    
    @testSetup
	static void dataCreation() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ PolicyLoadByRefNo_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ContractPremiumSumAssured_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ContractAlterSumAssured_IH_v1.INTEGRATION_SERVICE_NAME });
	}

	@isTest
	static void testFetchPolicyDetails() {
		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				PolicyLoadByRefNo_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		String response = SumAssuredDetailController.fetchPolicyDetails('6635630335');
		Test.stopTest();

        System.assert(response.StartsWith('{'), 'Assert Failed');
	}

	@isTest
	static void testGetCalculatedPremiumAmountPositive() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ContractPremiumSumAssured_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
        
        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String lifeAssuredGid = '51295437-5E72-4775-A44E-ACD4015315BB';
        String productId = '230140000';
        String coverAmount = '801000';
        
        String response = SumAssuredDetailController.getCalculatedPremiumAmount(contractGid, lifeAssuredGid, productId, coverAmount);
        Test.stopTest();
         
        System.assertEquals('9810.64', response, 'Assert Failed');
    }
    
    @isTest
	static void testGetCalculatedPremiumAmountNegative() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, 'Mock_Negative_ContractPremiumSumAssured_v1')
		);
        
        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String lifeAssuredGid = '51295437-5E72-4775-A44E-ACD4015315BB';
        String productId = '230140000';
        String coverAmount = '100';
        
        String response = SumAssuredDetailController.getCalculatedPremiumAmount(contractGid, lifeAssuredGid, productId, coverAmount);
        Test.stopTest();
         
        System.assert(response.startsWith('Error:'), 'Assert Failed');
    }

	@isTest
	static void testAlterSumAssuredAmountPositive() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ContractAlterSumAssured_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
        
        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String lifeAssuredGid = '51295437-5E72-4775-A44E-ACD4015315BB';
        String productId = '230140000';
        String coverAmount = '801000';
        
        String response = SumAssuredDetailController.alterSumAssuredAmount(contractGid, lifeAssuredGid, productId, coverAmount);
        Test.stopTest();
         
        System.assertEquals('1', response, 'Assert Failed');
    }
    
    @isTest
	static void testAlterSumAssuredAmountNegative() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, 'Mock_Negative_ContractAlterSumAssured_v1')
		);
        
        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String lifeAssuredGid = '51295437-5E72-4775-A44E-ACD4015315BB';
        String productId = '230140000';
        String coverAmount = '100';
        
        String response = SumAssuredDetailController.alterSumAssuredAmount(contractGid, lifeAssuredGid, productId, coverAmount);
        Test.stopTest();
         
        System.assert(response.startsWith('Error:'), 'Assert Failed');
    }

}