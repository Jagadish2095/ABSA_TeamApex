/*
* Test Integration Handler for ABF Create and Link Account
* @author Almas Aleem
* @created 2020-12-08
*/
@IsTest
public class ABFCreateAndLinkAccount_IH_v1_Test {
public static final String POSITIVE_RESPONSE_BODY = '{    "nbsapdpo":{       "version":"?",       "returnCode":"?",       "reasonCode":"?",       "serviceVersion":"?",       "echoKey":"?"    },    "nbsmsgo3":{       "version":"?",       "sysErrTxt":"?",       "nbrUserMsgs":"?",       "nbrUserErrs":"?",       "msgEntry":[          {             "msgClass":"?",             "msgCode":"?",             "msgErrInd":"?",             "msgTxt":"?"          }       ]    },    "plpa00o":{       "accountNumber":"?",       "eddRiskHoldInd":"?",       "accOrigChannel":"?"    } }';
 @TestSetup
    static void makeData(){
        insertUser();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFCreateAndLinkAccount_IH_v1.INTEGRATION_SERVICE_NAME});
    }
 
     @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
       ABFCreateAndLinkAccount_Resp_IB_V1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ABFCreateAndLinkAccount_Resp_IB_V1 callHandlerMethod() {
       ABFCreateAndLinkAccount_Req_IB_V1 dummyBean = ABFCreateAndLinkAccount_Req_IB_V1.createDummyRequest();
       
        
        user u= [SELECT Id, SiteCode__c, Supervisor__c, SiteType__c,EmployeeNumber, Teller_Operator_Code__c FROM User LIMIT 1];                                        
         
                     
     ABFCreateAndLinkAccount_Resp_IB_V1 responseBean = ABFCreateAndLinkAccount_IH_v1.createAndLinkAccount(u, 'WCC   451');
        return responseBean;
    }
    
 @future
    private static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Banker%' LIMIT 1];
        UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];
        
        User futureUser = new User(
            ProfileId = p.Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            SiteCode__c = '8198',
            SiteType__c = '034',
            Teller_Operator_Code__c = '12345',
            Supervisor__c = '0',
            Division__c = 'RBB',
            UserRoleId = r.Id
        );
        insert(futureUser);
    }
}