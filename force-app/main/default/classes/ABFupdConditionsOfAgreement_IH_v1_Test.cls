/*
* Test Integration Handler for ABFUpdate Condtions  Service for Term Loan
* @author Almas Aleem
* @created 2020-12-03
*/

@isTest
public class ABFupdConditionsOfAgreement_IH_v1_Test {
public static final String POSITIVE_RESPONSE_BODY ='{     "messageHeaders": {         "outPutMessageHeaders": {             "serviceVersion": "BUSO002",             "returnCode": 0,             "reasonCode": 0         }     },     "messageErrors": {         "outPutMessageErrors": {             "sysErrorText": "",             "nbrUserMessages": 1,             "MessageEntryTabel": [                 {                     "messageText": "Account is already current",                     "messageErrorInd": "E",                     "messageClass": "PLSMGC01",                     "messageCode": "0021"                 },                 {                     "messageText": "",                     "messageErrorInd": "",                     "messageClass": "",                     "messageCode": ""                 },                 {                     "messageText": "",                     "messageErrorInd": "",                     "messageClass": "",                     "messageCode": ""                 },                 {                     "messageText": "",                     "messageErrorInd": "",                     "messageClass": "",                     "messageCode": ""                 },                 {                     "messageText": "",                     "messageErrorInd": "",                     "messageClass": "",                     "messageCode": ""                 }             ],             "nbrUserErrors": 1,             "version": ""         }     } }'; 
    @TestSetup
    static void makeData(){
        insertUser();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFupdConditionsOfAgreement_IH_v1.INTEGRATION_SERVICE_NAME});
    }
 
     @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ABFupdConditionsOfAgreement_Resp_IB_V1 responseBean = callHandlerMethod();
       // System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ABFupdConditionsOfAgreement_Resp_IB_V1 callHandlerMethod() {
       ABFupdConditionsOfAgreement_Req_IB_V1 dummyBean = ABFupdConditionsOfAgreement_Req_IB_V1.createDummyRequest();
       
        
        user u= [SELECT Id, SiteCode__c, Supervisor__c, SiteType__c,EmployeeNumber, Teller_Operator_Code__c FROM User LIMIT 1];                                        
         
      String abfupdateStatusResponse= '{"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": "1","nbrUserErrs": "1","msgEntry": [{"msgClass": "PLSMGC01","msgCode": "0020","msgErrInd": "E","msgTxt": "Account status is invalid"}]},"plpa03o": {"mandateNbr": "0","contractSignedInd":"F","contractSignIndUpdbl": "Y","payMethodReqInd": "F","cessionPledgeInd": "Y","autoSettlementInd": "N","autoSettleIndUpdbl": "F","creditLifeInd": "F","creditLifeIndUpdbl": "Y","landlordWaiverInd": "Y","insuranceInd": "F","elecTransferInd": "F","elecTransferIndUpdbl": "F"}}';
  		ABFupdAccountStatusV1_Resp_IB_V1   ABFresponse = (ABFupdAccountStatusV1_Resp_IB_V1) JSON.deserialize(abfupdateStatusResponse, ABFupdAccountStatusV1_Resp_IB_V1.class);
                      
      ABFupdConditionsOfAgreement_Resp_IB_V1 responseBean = ABFupdConditionsOfAgreement_IH_V1.GetABFupdConditions(u,'305544789',ABFresponse,'F' ,'F', 'F','F',
                                                     21,1818); 
        system.debug('responseBean---in test'+JSON.serializePretty(responseBean));
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