/**
* @description Test class for ContractAddComponent_IH_v1
*
* @author  Koketso Mpshane
* @created 2021-08-17
*/
@isTest
public class ContractAddComponent_IH_v1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ContractAddComponent_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ContractAddComponent_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ContractAddComponent_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static ContractAddComponent_Resp_IB_v1 callHandlerMethod() {
        
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
        
        ContractAddComponent_Resp_IB_v1 responseBean = ContractAddComponent_IH_v1.ContractAddComponent(memberData);
        return responseBean;
    }

}