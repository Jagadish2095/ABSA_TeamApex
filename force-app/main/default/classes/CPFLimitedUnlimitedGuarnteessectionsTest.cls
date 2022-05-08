@isTest
public class CPFLimitedUnlimitedGuarnteessectionsTest {
static testMethod void getLimitedUnlimitedCPFTest(){
         Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        insert testOpp;
        Application__c app= new Application__c();
        app.Opportunity__c=testOpp.id; 
        insert app;
		Application_Product_CPF__c appPrdctcpf=new Application_Product_CPF__c();
        appPrdctcpf.Application__c=app.Id;
        insert appPrdctcpf;
       Application_Security_CPF__c limsecOff =new Application_Security_CPF__c();
    	limsecOff.Application_Product_CPF__c =appPrdctcpf.Id;
    	limsecOff.Category__c='Limited Guarantee';
    	limsecOff.Type__c='Other';
    	insert limsecOff;
    	List<Application_Security_CPF__c> lsecOff =new List<Application_Security_CPF__c>();
    	lsecOff.add(limsecOff);
    	Application_Security_CPF__c unlimsecOff =new Application_Security_CPF__c();
    	unlimsecOff.Application_Product_CPF__c =appPrdctcpf.Id;
    	unlimsecOff.Category__c='UnLimited Guarantee';
    	unlimsecOff.Type__c='Other';
    	insert unlimsecOff;
    	List<Application_Security_CPF__c> unlsecOff =new List<Application_Security_CPF__c>();
    	unlsecOff.add(unlimsecOff);
        CPFLimitedUnlimitedGuarnteessections.getSecurityofferedRec(testOpp.Id,'New');
        CPFLimitedUnlimitedGuarnteessections.getUnlimitedSecurityofferedRec(testOpp.Id,'New');
        CPFLimitedUnlimitedGuarnteessections.InsertLimitedSecurityOfferedCpfRec(testOpp.Id,lsecOff,'New');
    	CPFLimitedUnlimitedGuarnteessections.InsertUnlimitedSecurityOfferedCpfRec(testOpp.Id,unlsecOff,'New');
        CPFLimitedUnlimitedGuarnteessections.InsertLimitedExistingCpfRec(testOpp.Id,lsecOff,'Existing');
    CPFLimitedUnlimitedGuarnteessections.InsertUnlimitedExistingCpfRec(testOpp.Id,unlsecOff,'Existing');
    }
}