/**
*  @description Test Controller for CPFLimitedUnlimitedSuretyship class
* @author  Rajesh : Absa
* @version v1.0
* @since   2021-1-02
*/
@IsTest
public class CPFLimitedUnlimitedSuretyshipTest {
@isTest static void testInsertLimitedExistingCpfRec() {
Opportunity opp = new Opportunity();
opp.Name = 'EPP';
opp.StageName = 'Not Interested';
opp.CloseDate = Date.today() + 10;
Insert opp;


Application__c app = new Application__c();
app.Opportunity__c = opp.Id;
insert app;

Application_Product_CPF__c appPrdctcpf=new Application_Product_CPF__c();
appPrdctcpf.Application__c=app.Id;
insert appPrdctcpf;

Application_Security_CPF__c securityobj = new Application_Security_CPF__c(); 
securityobj.Category__c='Limited Suretyship';
test.startTest();
list<Application_Security_CPF__c> appsecurity= CPFLimitedUnlimitedSuretyship.InsertLimitedExistingCpfRec(opp.Id,new List<Application_Security_CPF__c>{securityobj},'Existing');
system.assertNotEquals(null, appsecurity);
CPFLimitedUnlimitedSuretyship.getSecurityofferedRec(opp.Id,'Existing');
CPFLimitedUnlimitedSuretyship.getUnlimitedSecurityofferedRec(opp.Id,'Existing');
CPFLimitedUnlimitedSuretyship.InsertUnlimitedExistingCpfRec(opp.Id,new List<Application_Security_CPF__c>{securityobj},'Existing');
CPFLimitedUnlimitedSuretyship.InsertLimitedNewCpfRec(opp.Id,new List<Application_Security_CPF__c>{securityobj},'New','Yes');
test.stopTest();
}
}