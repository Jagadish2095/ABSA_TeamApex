/**
 * @description       : Test class for case flow controller that houses Financial Spreading logic
 * @author            : Ravi B, Vara.
 * @group             : 
 * @last modified on  : 09-27-2021
 * @last modified by  : Tawanda M.
**/
@isTest
public class CaseFlowControllerTest {
    /**
    * @description Test Method
    * @author Tawanda M. | 09-27-2021 
    **/
    @isTest
    public static void fetchMainCaseAndSave() {
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Case cs = new Case();
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Financial Spreading Service Request').getRecordTypeId();
        cs.SuppliedName = 'Test Name';
        cs.AccountId = acc.Id;
        Insert cs;

        Test.startTest();
        String jsonString = CaseFlowController.getCaseDetailWrapper(cs.Id);
        CaseFlowController.CaseWrapper wrapper = (CaseFlowController.CaseWrapper) JSON.deserialize(jsonString, CaseFlowController.CaseWrapper.class);
        CaseFlowController.saveCaseObject(JSON.serialize(wrapper.caseObject));
        System.assert(jsonString != null);
        Test.stopTest();
    }
    /**
    * @description Test Method
    * @author Tawanda M. | 09-27-2021 
    **/
    @isTest
    public static void createChildCase() {
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Case cs = new Case();
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Financial Spreading Service Request').getRecordTypeId();
        cs.SuppliedName = 'Test Name';
        cs.AccountId = acc.Id;
        Insert cs;

        Test.startTest();
        String jsonString = CaseFlowController.getCaseDetailWrapper(cs.Id);
        CaseFlowController.CaseWrapper wrapper = (CaseFlowController.CaseWrapper) JSON.deserialize(jsonString, CaseFlowController.CaseWrapper.class);
        String childCaseId = CaseFlowController.createChildCase(JSON.serialize(wrapper.caseObject));
        String childJsonString = CaseFlowController.getCaseDetailWrapper(childCaseId);
        CaseFlowController.CaseWrapper childWrapper = (CaseFlowController.CaseWrapper) JSON.deserialize(childJsonString, CaseFlowController.CaseWrapper.class);
        CaseFlowController.finaliseChildCase(JSON.serialize(childWrapper.caseObject));
        System.assert(childCaseId != null);
        System.assert(childJsonString != null);
        Test.stopTest();
    }

    /**
    * @description Test Method
    * @author Tawanda M. | 09-27-2021 
    **/
    @isTest
    public static void getCaseDocuments() {
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Case cs = new Case();
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Financial Spreading Service Request').getRecordTypeId();
        cs.SuppliedName = 'Test Name';
        cs.AccountId = acc.Id;
        Insert cs;

        Test.startTest();
        List<CaseFlowController.CaseDocuments> docs = CaseFlowController.getCaseDocuments(cs.Id);
        System.assert(docs != null);
        Test.stopTest();
    }
}