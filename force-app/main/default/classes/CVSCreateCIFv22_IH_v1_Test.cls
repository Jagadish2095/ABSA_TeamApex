/**
* @description Test Integration Handler for CVSCreateCIFv22 Service
* @author  Paul John du Randt : ABSA (IQ Business)
* @version v1.0
* @since   2020-09-18
*/

@isTest
public class CVSCreateCIFv22_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"headers":{"X-Backside-Transport":["OK OK"],"Connection":["Keep-Alive"],"Transfer-Encoding":["chunked"],"X-Powered-By":["Servlet/3.1"],"Content-Type":["application/json; charset=UTF-8"],"Content-Language":["en-US"],"Date":["Mon, 07 Dec 2020 10:13:34 GMT"],"Expires":["Thu, 01 Dec 1994 16:00:00 GMT"],"Cache-Control":["no-cache=\"set-cookie, set-cookie2\""],"X-Global-Transaction-ID":["1cf73a895fce004ec67f67ad"],"Access-Control-Expose-Headers":["APIm-Debug-Trans-Id, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-Global-Transaction-ID"],"Access-Control-Allow-Origin":["*"],"Access-Control-Allow-Methods":["POST"],"Set-Cookie":["LtpaToken2=\"\"; Expires=Thu, 01 Dec 1994 16:00:00 GMT; Path=/; Secure; HttpOnly","LtpaToken2=Qq0mFXVDnbh6/7BhhI1hjCV3+KnusyxFT6nT9aNiNwPjXvFB1HEeJTvzVTRRGtOqD4pg1f1xn1eJiWYxrydSiazSk+XWFqmvcCr8xvqefLZMQoxOHYt5dgUVHzo8YnsmiB3hqow3mU5/izpXvJtFzYboBgQVqsj0IUH2jlvPhsNKutTVe1aCuPnHyAIqvsVx0eDEuFpEUxyrFQGGAbrub8cASWpcAllj6vAV/A1FeIA0H6fBxopcWkj97uAodN0BMMtD+GZhCUN7jUaO4pbcVJXtEPhprfJnq8rJm7PzNs2xPwHw8Ah9x3W3JUuD+MuV; Path=/; HttpOnly"],"X-RateLimit-Limit":["name=100 Per Minute,100;"],"X-RateLimit-Remaining":["name=100 Per Minute,99;"]},"body":{"CIB003O":{"CIcreateClientV22Response":{"outputClientKey":""}},"NBSAPDPO":{"nbsapdpo":{"serviceVersion":"BUSO022","returnCode":0,"reasonCode":0,"version":""}},"NBSMSGO3":{"nbsmsgo3":{"sysErrTxt":"","nbrUserErrs":1,"nbrUserMsgs":1,"version":"","msgEntry":[{"msgClass":"","msgTxt":"DUPLICATE PROFILE EXITS","msgErrInd":"Y","msgCode":"0163"},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""}]}}}';
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
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CVSCreateCIFv22_IH_v1.INTEGRATION_SERVICE_NAME});
        }
    }

    @isTest
    public static void testPositive() {
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
        Test.startTest();
        CVSCreateCIFv22_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assert(responseBean != null, 'Test Working');
        Test.stopTest();
        }
    }

    private static CVSCreateCIFv22_Resp_IB_v1 callHandlerMethod() {
        CVSCreateCIFv22_Req_IB_v1 dummyBean = CVSCreateCIFv22_Req_IB_v1.createDummyRequest();
        CVSCreateCIFv22_Resp_IB_v1 responseBean = CVSCreateCIFv22_IH_v1.CVSCreateCIFv22(dummyBean);
        return responseBean;
    }
}