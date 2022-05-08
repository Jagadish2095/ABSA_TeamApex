/**
 * @description       : 
 * @author            : 
 * @last modified on  : 2021-06-07
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2021-06-07      Initial Version
**/
@isTest
public class ApplicationTeamMembersSelectorTest {
@isTest
public static void insertOtherTransactions(){
Account account = new Account(Name = 'Test Account');
account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
account.Country_of_Incorporation__c='South Africa';
account.Client_Group__c = 'Non Individual';
account.CASA_Reference_Number__c = '12233';
account.CASA_Screening_Status__c = 'Cancelled';
account.CIF__c = '';
account.Countries_Traded_With__c = 'South Africa';
account.Source_of_Income__c = 'Donation';
insert account;

Opportunity testOpp = new Opportunity();
testOpp.Name = 'Test Opp';
testOpp.CloseDate = Date.today();
testOpp.StageName = 'Drafting';
testOpp.accountId = account.Id;
insert testOpp;

Application__c app= new Application__c();
app.Opportunity__c = testOpp.Id;
app.Account_Number__c = '123456789';
insert app;

Application_Product_CPF__c appPrdctcpf=new Application_Product_CPF__c();
appPrdctcpf.Application__c=app.Id;
insert appPrdctcpf;

Application_Fees__c appFees = new Application_Fees__c();
appFees.Application_Product_CPF__c = appPrdctcpf.Id;
//insert clause;

test.startTest();
ApplicationTeamMembersSelector appTeamSelector = new ApplicationTeamMembersSelector();
appTeamSelector.getSObjectType();
appTeamSelector.getSObjectFieldList();
List<Application_Team_Member__c> appTeamlst=appTeamSelector.selectteamMemberwithtypeandCategory(appPrdctcpf.Id,'Profession','CPF');
system.assertNotEquals(null, appTeamlst);
test.stopTest();
}

}