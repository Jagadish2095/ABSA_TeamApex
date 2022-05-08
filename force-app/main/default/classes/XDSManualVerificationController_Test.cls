@isTest
public class XDSManualVerificationController_Test {

     static testMethod void testInsert() {
        string idNumber = '6804265528082';
        String verifyby = 'VC';
        date XDSdate = Date.newInstance(2020, 12, 9);
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        
         Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;
		Account a = new Account(RecordTypeId=rtId);
		a.FirstName = 'Test';
		a.LastName = 'Test';
         a.Name = 'Test Acc';
		//insert a;
         
         
       	string recordId = [SELECT Id,Name from Account where Id =: account.Id].Id;
        //  Account acc = new Account(name='Test Account');
        //  insert acc;
         
        // String recordId = '0010E00000u5zq6QAA';
       //  List<Opportunity> lstopp =[select id from opportunity where accountid=: acc.id];
        // system.assertEquals(1,lstopp.size());
        // 
        test.startTest();
         XDSManualVerificationController sc = new XDSManualVerificationController();
        XDSManualVerificationController.SaveAccount(verifyby, XDSdate, recordId);
        	//String Account = sc.SaveAccount(verifyby, idNumber, recordId);
        test.stopTest();
     }
}