@isTest
public class AIC_Case_transferControllerTest {
    @testSetup static void setup() {
        Account indivAccount = new Account();
        indivAccount.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        indivAccount.FirstName = 'Test';
        indivAccount.LastName = 'Individual';
        indivAccount.Communication_Language__pc = 'English';
        indivAccount.PersonTitle = 'Mr.';
        indivAccount.PersonEmail='test@test.com';
        indivAccount.Active_Email__c='test@test.com';
        indivAccount.Initials__pc = 'T';
        indivAccount.Client_Group__c = 'Individual';
        indivAccount.Client_Type__c = 'Private Individual';
        insert indivAccount;
        
        Account bAccount = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
        	Active_Email__c='test@test.com',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',            
			Number_of_Participants__c = 2
		);
		insert bAccount;
        
        Contact con = new Contact(LastName = 'test',email='test@test.com');
        insert con;
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIC').getRecordTypeId();
        Group QueueObj = [Select Id, Name, DeveloperName From Group where Type = 'Queue' and DeveloperName = 'Outbound_AIC'];
        List<Case> lstCase = new List<Case>();
        Case testCase = new Case(RecordTypeId = caseRecordTypeId);
        testCase.AccountId = indivAccount.Id;
        testCase.OwnerId = QueueObj.Id;
        testCase.contactId=con.Id;
        lstCase.add(testCase);
        
         Case testCase1 = new Case(RecordTypeId = caseRecordTypeId);
        testCase1.AccountId = bAccount.Id;
        testCase1.OwnerId = QueueObj.Id;
        testCase1.contactId=con.Id;
        lstCase.add(testCase1);
        
        insert lstCase;
    }
    
	@isTest static void getQueue() {
        String result = AIC_Case_transferController.getSelectListData();
        system.assertNotEquals(null,result);
    }
    
    @isTest static void sendEmailOfDepartment() {
        List<Case> lstCase = [Select Id from Case];
        String result = AIC_Case_transferController.departmentCase('Test','test@test.com','Test', 'Email Body', lstCase[0].id);
        system.assertNotEquals(null,result);
        
        String result1 = AIC_Case_transferController.departmentCase('Test','test@test.com','Test', 'Email Body', lstCase[1].id);
        system.assertNotEquals(null,result1);
    }
    
    @isTest static void transferCase() {
        List<Case> lstCase = [Select Id from Case];
        Group QueueObj = [Select Id, Name, DeveloperName From Group where Type = 'Queue' and DeveloperName = 'Awaiting_Documents_AIC'];
        String result = AIC_Case_transferController.transferCase(QueueObj.Id, 'Test' ,lstCase[0].id);
        system.assertNotEquals(null,result);
        
    }
}