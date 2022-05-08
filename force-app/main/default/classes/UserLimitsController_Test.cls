/*
* Test Integration Handler for UserLimitsController class
* @author Mashudu Raidimi
* @created 2020-07-26
*/

@isTest
public class UserLimitsController_Test {
    
    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        
        
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                //recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'normal case',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
    }
    
    @isTest 
    public static void testCIGetAccount(){
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        String responseBean = UserLimitsController.getAccountDetails(accountList[0].Id);
        system.assertNotEquals(null, responseBean);
        Test.stopTest();
    }
    
    public static final String POSITIVE_RESPONSE_BODY = '{"VBlistUsersV1Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":null},"nbsmsgo":{"sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}},"vbp451o":{"cifKey":"PIERIDO001","segCode":"B","custId":"000000000365365","custName":"P   ABSA TEST","iplmMax":"4999999","oplmMax":"4999999","ablmMax":"4999999","fdlmMax":"4999999","moreUsers":"Y","numberOcc":"10","users":[{"userNo":"001","userName":null,"userType":"P","userId":null,"userFica":"Y"},{"userNo":"002","userName":null,"userType":"S","userId":null,"userFica":null},{"userNo":"003","userName":"ARNAUD","userType":"S","userId":"1506240039082","userFica":"Y"},{"userNo":"004","userName":"PIETERTJIE","userType":"D","userId":"1506240039082","userFica":"Y"},{"userNo":"005","userName":"DALENE","userType":"M","userId":"1506240039082","userFica":"Y"},{"userNo":"006","userName":"HERBIE","userType":"S","userId":"1506240039082","userFica":"Y"},{"userNo":"008","userName":"ALLAN","userType":"S","userId":"1506240039082","userFica":"Y"},{"userNo":"009","userName":"RICHARD SORRY","userType":"M","userId":"1506240039082","userFica":"Y"},{"userNo":"010","userName":"SHAUN","userType":"S","userId":"1506240039082","userFica":"Y"},{"userNo":"011","userName":"FREDDY","userType":"S","userId":"1506240039082","userFica":"Y"}]}}}';

    @isTest static void testPositive() {
        
        IntegrationTestDataFactory.insertIntegrationSettings(vBlistusersv1_IH_v1.INTEGRATION_API_NAME, new List<String>{vBlistusersv1_IH_v1.INTEGRATION_SERVICE_NAME});
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        
        Test.startTest();
        String responseBean = UserLimitsController.getUserList('1011110050','001','PIERIDO001');
        system.assertNotEquals(null, responseBean);

        Test.stopTest();
    }
    
    public static final String POSITIVE_RESPONSE_BODY2 = '{"getUserLimitResp":{"intAccXfer":"10000","intAccXferUsed":"0","ownDefPaym":"10000","ownDefPaymUsed":"0","billPaym":"10000","billPaymUsed":"0","futDtePaym":"10000","errorCode":"NA","errorMessage":"NA"},"error":false,"errorList":[],"additionalInfo":null}';

    
        
    

    @isTest static void testLimitsPositive() {
        
        IntegrationTestDataFactory.insertIntegrationSettings(getTbUserBasicLimits_IH_v1.INTEGRATION_API_NAME, new List<String>{getTbUserBasicLimits_IH_v1.INTEGRATION_SERVICE_NAME});
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY2));

        Test.startTest();

        String responseBean = UserLimitsController.getAccountLimits('BOUCHI 001','001');
        system.assertNotEquals(null, responseBean);

        Test.stopTest();
    }
    
     static testMethod void getCloseCaseTest(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
   
        Test.startTest();
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        //Account acct = [SELECT ID FROM Account WHERE LastName='SKOSANA' LIMIT 1];
        
        UserLimitsController.caseClose(caseRec.Id);
        Test.stopTest();
        
    } 

}