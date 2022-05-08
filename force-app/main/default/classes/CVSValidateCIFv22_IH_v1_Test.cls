/**
* @description Integration Handler for CVSValidateCIFv22 Service
* @author  Paul John du Randt : ABSA (IQ Business)
* @version v1.0
* @since   2020-09-18
*/

@isTest
public class CVSValidateCIFv22_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"CVSValidateCIFv22Response":{"msgNo": 200,"msg":""}}';

    @TestSetup
    static void makeData(){
        String userName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String email = 'UserAdmin@testorg.com';
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
        User au = new User(
            Alias = 'standt',
            Email = email,
            EmailEncodingKey = 'UTF-8',
            LastName = 'UserAdmin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ap.Id,
            TimeZoneSidKey = 'Africa/Johannesburg',
            UserName = userName,
            MobilePhone = '0823389021',
            Advisor_Code__c = '112233'
        );
        insert au;
        System.runAs(au) {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CVSValidateCIFv22_IH_v1.INTEGRATION_SERVICE_NAME});
        }
    }

    @isTest static void testPositive(){
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            Test.startTest();
            CVSValidateCIFv22_Resp_IB_v1 responseBean = callHandlerMethod();
            System.assert(responseBean != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest static void getemptybean(){
        Test.startTest();
        CVSValidateCIFv22_Req_IB_v1 reqBean = new CVSValidateCIFv22_Req_IB_v1();
        reqBean = CVSValidateCIFv22_Req_IB_v1.GetEmptyBean(reqBean);
        System.assert(reqBean != null, 'Test Working');
        Test.stopTest();
    }

    private static CVSValidateCIFv22_Resp_IB_v1 callHandlerMethod() {
        CVSValidateCIFv22_Req_IB_v1 dummyBean = CVSValidateCIFv22_Req_IB_v1.createDummyRequest();
        CVSValidateCIFv22_Resp_IB_v1 responseBean = CVSValidateCIFv22_IH_v1.CVSValidateCIFv22(dummyBean);
        return responseBean;
    }
}