@IsTest
public class MinPaymentDueController_Test {
    @isTest 
    public static void testCIGetAccount(){
// Set mock callout class 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {StringConstants.JITTERBIT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CQ_PAYMENT_DUE_STRING});
        Test.startTest();        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
         mock.setStaticResource('CQgetPaymentDueV1Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');     
        Test.setMock(HttpCalloutMock.class,mock);
           CQgetPaymentDue_Resp_IB_V1.CQgetPaymentDueV1Response wrapper = new CQgetPaymentDue_Resp_IB_V1.CQgetPaymentDueV1Response();
          // CQgetPaymentDue_Resp_IB_V1.Cqh844o cls_Cqh844o =new  wrapper.cqh844o();
            List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='9502212347096';
        accountList[0].AccountNumber ='00000004047451539';
        
        insert accountList;
        system.debug('accountnmbr-----'+accountList[0].AccountNumber);
        MinPaymentDueController.getMinimumPayDueCHQ(accountList[0].AccountNumber);
        Case ca = new Case();
            ca.Email__c = 'test@gmail.com';
            ca.Account=accountList[0];
            insert ca;
           Case caseObj = new Case();
            caseObj.Email__c = 'test@gmail.com';
            caseObj.Account=accountList[0];
            caseObj.Mobile__c = '1234567890';
            caseObj.Communication_Method__c = 'Email';
            caseObj.Bypass_Validation_Rules__c =true;
            caseObj.ParentId = ca.id;
            insert caseObj;
        Contact c=new Contact();
        c.Email='test@gmail.com';
        c.LastName='test';
        insert c;
       MinPaymentDueController.sendEmailNotifications(accountList[0].AccountNumber,'0.00', caseObj.Id,'test@gmail.com','1234567890','Email');
       MinPaymentDueController.sendMailFromFlowforminpay('test@gmail.com','');
        Test.stopTest();
}
}