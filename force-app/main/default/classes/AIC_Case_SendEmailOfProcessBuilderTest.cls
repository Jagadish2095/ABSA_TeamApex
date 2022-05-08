/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-10-27
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@isTest
public class AIC_Case_SendEmailOfProcessBuilderTest {
	@isTest static void sendEmailOfPB() {
        
        List<Case> lstCase = new List<Case>();
        List<Id> caseIdlst = new List<Id>();
        
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
            
        Contact con = new Contact(LastName = 'test',email='test@test.com');
        insert con;
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIC').getRecordTypeId();
        for(Integer i=0; i < 4; i++){
            Case testCase = new Case(RecordTypeId = caseRecordTypeId);
            testCase.AccountId = indivAccount.Id;
            switch on i {
                when 1{
                    testCase.status ='Awaiting Documents';
                }
                when 2 {
                    testCase.status ='Uncontactable';
                }
                when 3 {
                    testCase.status ='Escalated';
                }
                when 0{
                    testCase.status ='Pending Call';
                }
            }
            testCase.ContactId = con.id;
        	lstCase.add(testCase);
        }
        insert lstCase;
        integer i=0;
        for(Case caseObj : lstCase){
            caseIdlst.add(caseObj.id);
        }
        
        test.startTest();
		AIC_Case_SendEmailOfProcessBuilder.sendEmailTOCase(caseIdlst);  
        List<EmailMessage> lstEmailMsg = [Select ID from EmailMessage];
        system.assert(true,'Email sent');
        test.stopTest();
    }
    
    @isTest static void sendEmailOfPB1() {
        
        List<Case> lstCase = new List<Case>();
        List<Id> caseIdlst = new List<Id>();

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
        for(Integer i=0; i < 4; i++){
            Case testCase = new Case(RecordTypeId = caseRecordTypeId);
            testCase.AccountId = bAccount.Id;
            switch on i {
                when 1{
                    testCase.status ='Awaiting Documents';
                }
                when 2{
                    testCase.status ='Uncontactable';
                }
                when 3 {
                    testCase.status ='Escalated';
                }
                when 0 {
                    testCase.status ='Pending Call';
                }
            }
            testCase.ContactId = con.id;
        	lstCase.add(testCase);
        }
        insert lstCase;
        integer i=0;
        for(Case caseObj : lstCase){
            caseIdlst.add(caseObj.id);
        }
        
        test.startTest();
		AIC_Case_SendEmailOfProcessBuilder.sendEmailTOCase(caseIdlst);  
        List<EmailMessage> lstEmailMsg = [Select ID from EmailMessage];
        system.assert(true,'Email sent');
        test.stopTest();
    }
}