/**
 * @description Test class for AbsaLifeMemberMaintenance
 * @author  Koketso Mpshane
 * @since   2021-06-29
 */
@isTest
public class AbsaLifeMemberMaintenanceTest {

    @testSetup
	static void dataCreation() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ PolicyLoadByRefNo_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ContractDeleteComponent_IH_v1.INTEGRATION_SERVICE_NAME });
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ContractLapse_IH_v1.INTEGRATION_SERVICE_NAME });
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ContractCancel_IH_v1.INTEGRATION_SERVICE_NAME });
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ClientSearch_IH_v1.INTEGRATION_SERVICE_NAME });
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ContractGetComponent_IH_v1.INTEGRATION_SERVICE_NAME });
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ContractAddComponent_IH_v1.INTEGRATION_SERVICE_NAME });
        
        Integration_Translation__c intTransCancel = new Integration_Translation__c();
		intTransCancel.Name = 'Test cancel reason';
		intTransCancel.Internal_Value__c = 'Test cancel reason';
		intTransCancel.External_Value__c = '1';
		intTransCancel.System_Name__c = 'Exergy';
		intTransCancel.Value_Type__c = 'Cancel Reason';
		intTransCancel.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		insert intTransCancel;

        
        Integration_Translation__c intTransLapse = new Integration_Translation__c();
		intTransLapse.Name = 'Test lapse reason';
		intTransLapse.Internal_Value__c = 'Test lapse reason';
		intTransLapse.External_Value__c = '1';
		intTransLapse.System_Name__c = 'Exergy';
		intTransLapse.Value_Type__c = 'Lapse Reason';
		intTransLapse.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
		insert intTransLapse;
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
		String response = AbsaLifeMemberMaintenance.fetchPolicyDetails('6635630335');
		Test.stopTest();

        System.assert(response.StartsWith('{'), 'Assert Failed');
	}

	@isTest
	static void testDeleteMemberDetailsPositive() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ContractDeleteComponent_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String lifeAssuredGid = 'DC79225A-B80C-4296-9E90-ACD4015315C5';
        String productId = '230140000';

        String response = AbsaLifeMemberMaintenance.deleteMemberDetails(contractGid, lifeAssuredGid, productId);
        Test.stopTest();

        System.assertEquals('1', response, 'Assert Failed');
    }

    @isTest
	static void testDeleteMemberDetailsNegative() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                'Mock_Negative_contractDeleteComponent_v1')
		);

        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String lifeAssuredGid = 'DC79225A-B80C-4296-9E90-ACD4015315C5';
        String productId = '2300';

        String response = AbsaLifeMemberMaintenance.deleteMemberDetails(contractGid, lifeAssuredGid, productId);
        Test.stopTest();

        System.assert(response.startsWith('Error:'), 'Assert Failed');
    }
    
    @isTest
	static void testContractCancelPolicyPositive() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ContractCancel_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String cancelRequestDate = '20210101';
        String decisionReason = 'Test cancel reason';
        String decisionNote = 'Test';

        String response = AbsaLifeMemberMaintenance.contractCancelPolicy(contractGid, cancelRequestDate, decisionReason, decisionNote);
        Test.stopTest();

        System.assertEquals('1', response, 'Assert Failed');
    }

    @isTest
	static void testContractCancelPolicyNegative() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                'Mock_Negative_ContractCancel_v1')
		);

        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String cancelRequestDate = '20210101';
        String decisionReason = 'Test cancel reason';
        String decisionNote = 'Test';

        String response = AbsaLifeMemberMaintenance.contractCancelPolicy(contractGid, cancelRequestDate, decisionReason, decisionNote);
        Test.stopTest();

        System.assert(response.startsWith('Error:'), 'Assert Failed');
    }
    
    @isTest
	static void testContractLapsePolicyPositive() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ContractLapse_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String movementDate = '20210101';
        String decisionReason = 'Test lapse reason';
        String decisionNote = 'Test';
        
        String response = AbsaLifeMemberMaintenance.contractLapsePolicy(contractGid, movementDate, decisionReason, decisionNote);
        Test.stopTest();

        System.assertEquals('Successful', response, 'Assert Failed');
    }

    @isTest
	static void testContractLapsePolicyNegative() {

		Test.startTest();
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                'Mock_Negative_ContractLapse_v1')
		);

        String contractGid = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
        String movementDate = '20210101';
        String decisionReason = 'Test lapse reason';
        String decisionNote = 'Test';

        String response = AbsaLifeMemberMaintenance.contractLapsePolicy(contractGid, movementDate, decisionReason, decisionNote);
        Test.stopTest();

        System.assert(response.startsWith('Error:'), 'Assert Failed');
    }
    
    @isTest
	static void testGetReasons() {

		Test.startTest();
        List<String> response = AbsaLifeMemberMaintenance.getReasons('Cancel Reason');
        Test.stopTest();

        System.assert(response.size() > 0, 'Assert Failed');
    }

    @isTest
	static void testGetExergyLookupValuesMapping() {

		Test.startTest();
		
        String response = AbsaLifeMemberMaintenance.getExergyLookupValuesMapping();
        Test.stopTest();

         System.assert(response.StartsWith('{'), 'Assert Failed');
    }
    
    @isTest
	static void testSearchMemberDetails() {

		Test.startTest();
        
        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                'Mock_Positive_ClientSearch_v1')
		);
		
        String response = AbsaLifeMemberMaintenance.searchMemberDetails(1, '9101160730088');
        Test.stopTest();
        
        System.assert(response.StartsWith('{'), 'Assert Failed');
    }
    
    @isTest
	static void testGetBenefitTypeDetails() {

		Test.startTest();
		
        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                'Mock_Positive_ContractGetComponents_v1')
		);
        
        String response = AbsaLifeMemberMaintenance.getBenefitTypeDetails('240100000');
        Test.stopTest();
        
        System.assertNotEquals(null, response, 'Assert Failed');
    } 
        
    @isTest
	static void testAddMemberDetailsPositive() {
        
        Map<String, String> memberData = new Map<String, String>();
        memberData.put('contractGID', '72F2E717-3766-4A1D-9EBB-ACBD01049750');
        memberData.put('clientGID', '');
        memberData.put('cover', '15000');
        memberData.put('cellphone', '7800000000');
        memberData.put('dateOfBirth', '19881023');
        memberData.put('addressLine1', '');
        memberData.put('addressLine2', '');
        memberData.put('addressTypeID', '1');
        memberData.put('countryID', '191');
        memberData.put('emailAddress', '');
        memberData.put('firstName', 'Ayanda');
        memberData.put('genderID', '1');
        memberData.put('idDescription', '8907319835081');
        memberData.put('idTypeID', '1');
        memberData.put('surname', 'Man');
        memberData.put('titleID', '1');
        memberData.put('productID', '230140000');
        memberData.put('relationshipToMainMember', '6');

		Test.startTest();
        
        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                'Mock_Positive_ContractAddComponent_v1')
		);
		
        String response = AbsaLifeMemberMaintenance.addMemberDetails(memberData);
        Test.stopTest();
		
        System.assert(response.StartsWith('{'), 'Assert Failed');
    }

    @isTest
	static void testAddMemberDetailsNegative() {
        
        Map<String, String> memberData = new Map<String, String>();
        memberData.put('contractGID', '');
        memberData.put('clientGID', '');
        memberData.put('cover', '15000');
        memberData.put('cellphone', '7800000000');
        memberData.put('dateOfBirth', '19881023');
        memberData.put('addressLine1', '');
        memberData.put('addressLine2', '');
        memberData.put('addressTypeID', '1');
        memberData.put('countryID', '191');
        memberData.put('emailAddress', '');
        memberData.put('firstName', 'Ayanda');
        memberData.put('genderID', '1');
        memberData.put('idDescription', '8907319835081');
        memberData.put('idTypeID', '1');
        memberData.put('surname', 'Man');
        memberData.put('titleID', '1');
        memberData.put('productID', '230140000');
        memberData.put('relationshipToMainMember', '6');

		Test.startTest();
        
        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                'Mock_Negative_ContractAddComponent_v1')
		);
		
        String response = AbsaLifeMemberMaintenance.addMemberDetails(memberData);
        Test.stopTest();
        
		System.assert(response.StartsWith('Error:'), 'Assert Failed');
    }  

}