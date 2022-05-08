/**
 * @description Test class for CaseQAChecklist controller class.
 *
 * @author Jaco de Lange
 * @since 2021-01-25
 **/
@isTest
public class CaseQAChecklistTest{
@isTest
    public static void testCaseChecklist(){

		Id cafRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LDP_Fulfilment').getRecordTypeId();
		Account acc = new Account(Name = 'testaccount', Trust_Number__c = '1', Trust_Number_New_format__c = '1', Client_Type__c = 'Individual');
		insert acc;
		Contact co = new Contact(FirstName = 'contname', LastName = 'contlastName', AccountId = acc.Id);
		insert co;
		system.assertEquals(acc.Name, 'testaccount');
		Opportunity opp = new Opportunity(Name = 'testopp', AccountId = acc.Id, StageName = 'Won', CloseDate = system.today());
		insert opp;
		system.assertEquals(opp.Name, 'testopp');
		Case ca = new Case(RecordTypeId = cafRecordTypeId, Status = 'ValidatePayout', Opportunity__c = opp.Id);
		insert ca;
		system.assertEquals(ca.Opportunity__c, opp.Id);
		Case_Checklist_Template__c cct = new Case_Checklist_Template__c(Checklist_Name__c = 'Guarantee Fulfilment');
		insert cct;
		system.assertEquals(cct.Checklist_Name__c, 'Guarantee Fulfilment');

		Test.startTest();
		CaseQAChecklist.createCaseChecklistrecs(ca.Id);
		CaseQAChecklist.updatecasechecklist(ca.Id, true, true, true, true, true, true, true, true, true, true, true, true);
		Test.stopTest();
	}
}