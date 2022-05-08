/**
 * @description       :
 * @author            : Gulafsha
 * @last modified on  : 2021-06-11
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author    Modification
 * 1.0   2021-06-10   Gulafsha   Initial Version
**/
@isTest
public class MultiProductSelectionControllerTest {

@isTest
public static  void ProductvsProductFamilyCtrTest1() {
        List<User> usersList = new List<User>();
        usersList = TestDataFactory.getTestUsers('System Administrator (Custom)', 2);
        usersList[0].Business_Area__c = 'WIMI';
        usersList[0].SiteCode__c = '8570';
        insert usersList;
		Account ac = new Account();
		ac.Name = 'Test';
		ac.CIF__c = 'CLOSE  001'; //NOZENZO001';
		insert ac;

        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c();
        salesProcessType.Name = 'New Credit Product (Business Banking)';
        salesProcessType.Customer_Onboarding_Mode__c = 'Lite Onboarding';
        salesProcessType.Product_Selector_Mode__c = 'Product Family';
        salesProcessType.Product_Family__c = 'Credit Card;Cheque & Overdraft';
        salesProcessType.Opportunity_Record_Type__c = 'Credit_Onboarding';
        salesProcessType.Request_Name__c = 'New Credit Product (Business Banking)';
        insert salesProcessType;

		Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
		Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		Id onboardingrecId = rtMapByName.get('Credit Onboarding').getrecordtypeId();

		Opportunity opp = new Opportunity();
		opp.Name = 'UoW Test Name';
		opp.StageName = 'Open';
		opp.CloseDate = System.today();
		opp.accountid = ac.id;
		opp.RecordTypeId = onboardingrecId;
        opp.Sales_Process_Type__c = salesProcessType.id;
		insert opp;
        Application__c app = new Application__c();
		app.Opportunity__c = opp.id;
        Insert app;
		system.assertNotEquals(Null,MultiProductSelectionController.getmultiselectpicklistvaluesforproductfamilies('OnboardingSalesProcessType', opp.id));
        system.assertNotEquals(Null,MultiProductSelectionController.fetchLookUpValues('UoW', 'Opportunity', new list<sobject>()));
        system.assertNotEquals(Null,MultiProductSelectionController.getOpportunity(opp.id));
       //running as admin user with site code for future context
        System.runAs(usersList[0]){
        Test.startTest();
        Map<String, String> productMap = MultiProductSelectionController.saveOpportunityproductfamily(opp.id, 'Credit Card', true);
        system.assertNotEquals(null, productMap);
        Test.stopTest();

       }

		}
}