@isTest
public class DebitOrderStop_ReverseController_Test {

     @isTest 
    public static void testViewDebitOrderDetails(){
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Registration__c='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Country_of_Registration__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
         testAccount.Registration_Number__c = '1223333';
        testAccount.CASA_Screening_Date__c = System.today();
        testAccount.CASA_Risk_Status__c = '';
        testAccount.Client_Type__c = '';
        
        insert testAccount;
        
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
		insert con;
        Case cse = new Case(Communication_Method__c = 'Email',
                            Status = 'New',
                            Origin = 'Email', 
                            AccountId = testAccount.Id,
                            Risk_Management_Centre__c = 'Digital Fraud',
                            Email__c = 'test@test.com',
                            //recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                            Subject = 'test',
                            Type__c = 'test',
                            Out_Of_SLA_Reason__c = 'Account Closed',
                            Out_Of_SLA_Comments__c = 'test',
                            Description = 'test',
                            Expectation_of_the_Customer__c = 'test',
                            Incident_Date__c = date.today());
        insert cse;
        
Test.setMock(HttpCalloutMock.class, new dSretrieveDebitsInqV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.dSretrieveDebitsCreditsInqV2_STRING});
       Test.startTest();
       dSretrieveDebitsCreditsInqV2_Resp_IB_v1.Dsp973o dsp973obean= DebitOrderStop_ReverseController.viewDebitOrderDetails(testAccount.Id,'12233');
     system.debug(dsp973obean);
        DebitOrderStop_ReverseController.sendEmailOnCaseClose(cse.Id);
       
        List<String> selectedValues = new List<String>();
        selectedValues.add('0');
        //.selectedValues.add('test1');
        
        DebitOrderStop_ReverseController.deleteDebitOrderDetails(dsp973obean, selectedValues, '1333', 'StopDebitOrder', '', cse.Id);
        DebitOrderStop_ReverseController.deleteDebitOrderDetails(dsp973obean, selectedValues, '1333', 'ReverseDebitOrder', '', cse.Id);
         Test.stopTest();
    }
      @isTest 
    public static void testViewDebitOrderDetails1(){
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Registration__c='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Country_of_Registration__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
         testAccount.Registration_Number__c = '1223333';
        testAccount.CASA_Screening_Date__c = System.today();
        testAccount.CASA_Risk_Status__c = '';
        testAccount.Client_Type__c = '';
        
        insert testAccount;
        
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
		insert con;
        Case cse = new Case(Communication_Method__c = 'Email',
                            Status = 'New',
                            Origin = 'Email', 
                            AccountId = testAccount.Id,
                            Risk_Management_Centre__c = 'Digital Fraud',
                            Email__c = 'test@test.com',
                            //recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                            Subject = 'test',
                            Type__c = 'test',
                            Out_Of_SLA_Reason__c = 'Account Closed',
                            Out_Of_SLA_Comments__c = 'test',
                            Description = 'test',
                            Expectation_of_the_Customer__c = 'test',
                            Incident_Date__c = date.today());
        insert cse;
        
Test.setMock(HttpCalloutMock.class, new dSaddStopPaymentV2_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.dSretrieveDebitsCreditsInqV2_STRING});
       Test.startTest();
        string responseBean = '{"dsp973o": {"respCode": "0","moreRecsInd": "Y","recsReturnCnt": "50","acno": "-247533897","acHolderName": "UNKNOWN","debitCreditList": [{"trnGrp": "DD","actionDate": "20200128","userCode": "110","userSeq": "7279","nameOfInst": "ABSA CARD","userRef": "FEES/FOOIE 01033844","amount": "196.65","status": "9","tieb": "1343AC025F6F111DBB19","typeInd": "Y","acbRtrnCode": "30","procbInd": "R","ieIndb": "I","effFrmDate": "20200128"},{"trnGrp": "DD","actionDate": "20200226","userCode": "110","userSeq": "7375","nameOfInst": "ABSA CARD","userRef": "FEES/FOOIE 01026343","amount": "393.3","status": "1","tieb": "1343B222A37E4B2A7C2E","typeInd": "Y","acbRtrnCode": "0","procbInd": "Y","ieIndb": "I","effFrmDate": "20200226"}]}}';
       dSretrieveDebitsCreditsInqV2_Resp_IB_v1.Dsp973o dsp973obean= (dSretrieveDebitsCreditsInqV2_Resp_IB_v1.Dsp973o) JSON.deserialize(responseBean, dSretrieveDebitsCreditsInqV2_Resp_IB_v1.Dsp973o.class);  
     system.debug(dsp973obean);
         dSretrieveDebitsCreditsInqV2_Resp_IB_v1.Dsp973o dsp973obean1= DebitOrderStop_ReverseController.viewDebitOrderDetails(testAccount.Id,'12233');

       // DebitOrderStop_ReverseController.sendEmailOnCaseClose(cse.Id);
       
        List<String> selectedValues = new List<String>();
        selectedValues.add('0');
        //.selectedValues.add('test1');
        
       // DebitOrderStop_ReverseController.deleteDebitOrderDetails(dsp973obean, selectedValues, '1333', 'StopDebitOrder');
        //DebitOrderStop_ReverseController.deleteDebitOrderDetails(dsp973obean, selectedValues, '1333', 'ReverseDebitOrder');
         Test.stopTest();
    }
        
}