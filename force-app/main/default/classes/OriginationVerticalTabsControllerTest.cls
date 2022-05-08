/**
 * @description : Test class for Origination Vertical Tabs Controller
 *
 * @author  Englarmerdge Mongwe
 * @version v1.0n
 * @since   2021/03/17
 *
 */
@IsTest
public class OriginationVerticalTabsControllerTest {
    /**
    * @description : Creating data for test
    * @author E. Mongwe | 06-08-2021
    **/
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    /**
    * @description :Test method for controller methods
    * @author Saurabh | 06-08-2021
    **/
    @isTest
    public static  void testAllMethods() {
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Cheque Credit Onboarding' LIMIT 1];
		Test.startTest();
		System.assertNotEquals(null, originationVerticalTabsController.isSoleTraderAccount(opp.Id));
        System.assertNotEquals(null, originationVerticalTabsController.getAppRecords(opp.Id));
        System.assertNotEquals(false, originationVerticalTabsController.getSuperUsersAll());
        System.assertNotEquals(null, originationVerticalTabsController.isLocateCallRequired(opp.Id));
        System.assertNotEquals(null, originationVerticalTabsController.getIllustrativeDecisionFlag(opp.Id));
		Test.stopTest();
	}
    /**
    * @description :Test method for controller methods
    * @author Saurabh | 06-08-2021
    **/
    @isTest
    public static  void testUXEnhancements() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Cheque Credit Onboarding' LIMIT 1];
        opp.Selected_Product_Family__c = 'Credit Card,Cheque & Overdraft';
        update opp;
        Validations__c completedVal = new Validations__c();
        completedVal.Validation_Value__c = True;
        completedVal.Related_to_Object_Api_Name__c = 'Opportunity';
        completedVal.Related_to_Object_Record_Id__c = opp.Id;
        completedVal.Name = 'Cheque_Overdraft_Validated';
        Insert completedVal;
        System.assertNotEquals(null, originationVerticalTabsController.getCompletedTabs(opp.Id));
        System.assertNotEquals(null, originationVerticalTabsController.getSelectedProductFamily(opp.Id));
    }
}