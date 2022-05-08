@isTest
public class MerchantMATCHInquiryControllerTest {
    
    private static final String POSITIVE_RESPONSE_BODY = '{"TerminationInquiry":{"PageOffset":0,"Ref":"https://sandbox.api.mastercard.com/fraud/merchant/v3/termination-inquiry/19962020060501422","TransactionReferenceNumber":"","PossibleMerchantMatches":[{"TotalLength":1,"TerminatedMerchant":[{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","AddedByAcquirerID":"1996","AddedOnDate":"06/05/2020","PhoneNumber":"590595045","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"Principal":[{"FirstName":"LOUBSER","LastName":"ROELOF STEPHANUS","PhoneNumber":"49305934","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}],"TerminationReasonCode":"13"},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}}]}],"PossibleInquiryMatches":[{"TotalLength":8,"InquiredMerchant":[{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"Principal":[{"FirstName":"MOSO MOSHE","LastName":"BOLOFO","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"ROELOF STEPHANUS","LastName":"LOUBSER","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"TRACY","LastName":"DE BRUIN","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}]},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}},{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"Principal":[{"FirstName":"MOSO MOSHE","LastName":"BOLOFO","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"ROELOF STEPHANUS","LastName":"LOUBSER","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"TRACY","LastName":"DE BRUIN","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}]},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}},{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"Principal":[{"FirstName":"MOSO MOSHE","LastName":"BOLOFO","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"ROELOF STEPHANUS","LastName":"LOUBSER","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"TRACY","LastName":"DE BRUIN","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}]},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}},{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"Principal":[{"FirstName":"MOSO MOSHE","LastName":"BOLOFO","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"ROELOF STEPHANUS","LastName":"LOUBSER","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"TRACY","LastName":"DE BRUIN","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}]},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}},{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"Principal":[{"FirstName":"MOSO MOSHE","LastName":"BOLOFO","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"ROELOF STEPHANUS","LastName":"LOUBSER","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"TRACY","LastName":"DE BRUIN","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}]},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}},{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"Principal":[{"FirstName":"MOSO MOSHE","LastName":"BOLOFO","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"ROELOF STEPHANUS","LastName":"LOUBSER","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"TRACY","LastName":"DE BRUIN","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}]},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}},{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"Principal":[{"FirstName":"MOSO MOSHE","LastName":"BOLOFO","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"ROELOF STEPHANUS","LastName":"LOUBSER","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"TRACY","LastName":"DE BRUIN","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}]},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}},{"Merchant":{"Name":"SOUTH AFRICAN COMPENSATORS (PTY) LTD","PhoneNumber":"1234567654","AltPhoneNumber":"67899875","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"NationalTaxId":"*****","Principal":[{"FirstName":"MOSO MOSHE","LastName":"BOLOFO","NationalId":"*****","PhoneNumber":"12345432234","AltPhoneNumber":"12345432","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"ROELOF STEPHANUS","LastName":"LOUBSER","NationalId":"*****","PhoneNumber":"1234567654","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}},{"FirstName":"TRACY","LastName":"DE BRUIN","NationalId":"*****","PhoneNumber":"1234532","Address":{"Line1":"5 ALBERT STREET","Line2":"HEIDELBERG","City":"GAUTENG","PostalCode":"1441","Country":"ZAF"},"DriversLicense":{}}]},"MerchantMatch":{"Name":"M01","DoingBusinessAsName":"M00","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","CountrySubdivisionTaxId":"M00","NationalTaxId":"M00","ServiceProvLegal":"M00","ServiceProvDBA":"M00","PrincipalMatch":[{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"},{"Name":"M01","Address":"M01","PhoneNumber":"M00","AltPhoneNumber":"M00","NationalId":"M00","DriversLicense":"M00"}]}}]}]}}';
    public static Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    
     @TestSetup
    static void createTestData(){
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MatchTerminationInquiry_IH_v1.INTEGRATION_SERVICE_NAME});

        //WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
         Account testAccount = new Account();
        testAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testAccount.Name = 'Test Account';
        insert testAccount;

        //Create Principal records  
        Account testJointAccount = new Account();
        testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testJointAccount.Name = 'Mr Jack Stut';
        testJointAccount.Client_Type__c = 'Joint & Several';
        testJointAccount.CASA_Reference_Number__c = '1712994';
        testJointAccount.CASA_Risk_Status__c = 'Low';
        testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testJointAccount.CASA_Screening_Status__c = 'Approved';
        testJointAccount.CASA_Analyst_Comments__c = '30406';
        testJointAccount.Country_of_Registration__c='South Africa';
        testJointAccount.CIF__c = 'Jck+001';
        insert testJointAccount;
        
        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.AccountId = testAccount.id;         
        insert testContact;
        
        //Create Address
        Address__c testAddress = new Address__c();
        testAddress.Address_Type__c = 'Business Address';
        testAddress.Account__c = testJointAccount.id;
        testAddress.Address1__c = 'Test';
        testAddress.Address2__c = 'Test 123';
        insert testAddress;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = testJointAccount.id;
        acr.ContactId = testContact.Id;
        insert acr;    
        
         Opportunity testOpp2 = new Opportunity();
        testOpp2.Name = 'Test Opp Onboarding 2';
        testOpp2.CloseDate = Date.today();
        testOpp2.StageName = 'New';
        testOpp2.AccountId=testJointAccount.Id;
        insert testOpp2;
        
    }

    @isTest
    private static void testMatchInquiry() {
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        //Get Opportunity
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        System.assertNotEquals(null, testOpportunity);
        List<Merchant_Risk_Check__c> matchRecords = MerchantMATCHInquiryController.getMerchantRiskCheckRecords(testOpportunity.id);
        // Opportunity oppRec = MerchantMATCHInquiryController.getOpportunityRecord(testOpportunity.id);
        
        try {
            System.assertEquals(matchRecords, null);
            MerchantMATCHInquiryController.callMatchTerminationService(testOpportunity.id, matchRecords); 
            
        } catch (Exception ex) {
            
        }
        
        Test.stopTest();
    }

}