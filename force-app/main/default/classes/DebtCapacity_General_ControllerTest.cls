/**
 * @description       : Test Class for General Debt Capacity Input Controller
 * @author            : Tawanda M.
 * @group             :
 * @last modified on  : 09-28-2021
 * @last modified by  : Tawanda M.
 **/
@isTest
public class DebtCapacity_General_ControllerTest {
  /**
   * @description Test Data Setup
   * @author Tawanda M. | 08-16-2021
   **/
  @testSetup
  public static void setUpTestData() {
    Account accountRecord = new Account();
    accountRecord.Name = 'Test Account';
    insert accountRecord;

    Opportunity testOpp = new Opportunity();
    testOpp.Name = 'Test Opp Onboarding 1';
    testOpp.CloseDate = Date.today();
    testOpp.StageName = 'New';
    testOpp.AccountId = accountRecord.Id;
    testOpp.DC_General_Calculator_Request__c = '';
    testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
      .get('Complex Credit Onboarding')
      .getRecordTypeId();
    insert testOpp;
  }

  @isTest
  public static void testgetNewData() {
    Test.startTest();
    Id opportunityId = [SELECT id FROM Opportunity LIMIT 1].id;
    DebtCapacity_General_Controller.GeneralDataStructure data = DebtCapacity_General_Controller.getNewData();
    DebtCapacity_General_Controller.LoanBucket loanData = DebtCapacity_General_Controller.getEmptyLoanData();
    String jsonData = JSON.serialize(data);
    DebtCapacity_General_Controller.saveNewData(jsonData, opportunityId);
    DebtCapacity_General_Controller.ReturnedGeneralData getTableble = DebtCapacity_General_Controller.getTableData(
      opportunityId
    );
    System.assert(data != null);
    Test.stopTest();
  }

  @isTest
    public static void testSaveLoan(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Complex Credit Opportunity';
        opp.AccountId = acc.Id;
        opp.StageName = 'Confirm Client Eligibility';
        opp.CloseDate = Date.today().addMonths(2);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId();
        Insert opp;

        DebtCapacity_General_Controller.LoanBucket loanData = DebtCapacity_General_Controller.getEmptyLoanData();
        DebtCapacity_General_Controller.saveLoan(JSON.serialize(loanData), opp.Id);
        System.assert(loanData != null);
        Test.stopTest();
        
    }
}