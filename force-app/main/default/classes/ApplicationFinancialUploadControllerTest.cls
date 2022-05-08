/**
 * Test class for ApplicationFinancialsUploadController
 * @author  Saurabh : Absa
 * @version v1.0
 * @since   2020-09-15
 * @UserStory W:005850
 *
 */
@isTest
public class ApplicationFinancialUploadControllerTest {
    @TestSetup
    static void createData(){
		FinancialInformationTriggerTest.FinancialInfoTriggertest();
    }

	public static testMethod void testCreateTask() {
		Id accId = [SELECT Id, Name FROM Account WHERE Name = 'Test'].Id;
		Test.startTest();
		ApplicationFinancialsUploadController.createCaseforCreditSupportConsultant(accId);
		Test.stopTest();
	}

	public static testMethod void testLoadAccountData() {
		Id oppId = [SELECT Id, Name FROM Opportunity WHERE Name = 'UoW Test Name'].Id;
		PowerCurveController.setValidationFields(oppId, 'Applicant_Financials_Captured', true);
		Test.startTest();
		ApplicationFinancialsUploadController.returnClientDetails(oppId);
		Test.stopTest();
	}
}