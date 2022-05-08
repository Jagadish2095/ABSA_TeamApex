@isTest
public class ViewDebitOrderController_Test {
     @isTest 
    public static void testdebitorder(){
// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DSretrieveDebitsCredInqV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.DEBIT_RETRI_DETAILS_CARD_V1});

        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='9502212347096';
        accountList[0].AccountNumber ='09050987409';
        
        //Account acc =[select id,AccountNumber from account where ID_Number__pc ='9502212347096'];
        insert accountList;
        system.debug('accountnmbr-----'+accountList[0].AccountNumber);

        Test.startTest();        

       ViewDebitOrderController.viewDebitOrderDetails(accountList[0].AccountNumber,'20180101'); 
      
        Test.stopTest();
}
    @isTest 
    public static void testclosecase(){
        
        Account acc = new Account();
	     acc.name = 'test acc';
	     acc.CIF__c = 'cif007';
	     insert acc;
        
        Contact contact = new Contact(LastName='Test contact',Email = 'test@test.com', AccountId = acc.Id);
        insert contact;

          map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
       Case testCase = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email',
                                AccountId = acc.Id,
                                Email__c = 'test@test.com',
                               	recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                SLA_Pause_Flag__c  = true,
                                Expectation_of_the_Customer__c = 'test',
                                Type__c  = 'typeA',
                               	Incident_Date__c = date.today());
        insert testCase;
        Test.startTest();        

        ViewDebitOrderController.sendEmailOnCaseClose(testCase.Id);
         Test.stopTest();
    }

}