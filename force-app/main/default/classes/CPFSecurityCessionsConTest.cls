/**
 * @description Test Controller for CPFSecurityCessionscon
 * @author Diksha Wasekar : Absa
 * @version v1.0
 * @since   2021-1-02
 *
 */
@isTest
public class CPFSecurityCessionsConTest {

static testMethod void getCPFSecurityCessionsConTest(){
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
Application_Security_CPF__c secuCession =new Application_Security_CPF__c();
secuCession.Application_Product_CPF__c =appPrdctcpf.Id;
secuCession.Category__c='Security Cession';
secuCession.Type__c='Other';
insert secuCession;
List<Application_Security_CPF__c> lsecOff =new List<Application_Security_CPF__c>();
lsecOff.add(secuCession);

LIST<Application_Security_CPF__c> appsecurity=CPFSecurityCessionsCon.getSecurityofferedRec(testOpp.Id);
system.assertNotEquals(null, appsecurity);
CPFSecurityCessionsCon.InsertNewSecurityCessionsCpfRec(testOpp.Id,lsecOff);
CPFSecurityCessionsCon.getExistingSecurityofferedRec(testOpp.Id);
CPFSecurityCessionsCon.InsertExistingSecurityCessionsCpfRec(testOpp.Id,lsecOff);
}


}