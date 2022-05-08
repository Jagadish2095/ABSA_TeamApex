/*
 * Integration Handler for TransunionProcessRequest41 Service
 * @author Prashant Jain
 * @created 2020-05-20
*--------------------------------------
* @Updated By - Pitso Sekhu
* @Updated Date- 2021-03-18
* @Update Notes - Changes to EnquirerContactPhoneNo & EnquirerContactName from Hard coded value to Custom Label
*--------------------------------------
*/

@isTest
public class MerchantTransUnionCheckControllerTest {

    public static Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static final String POSITIVE_RESPONSE_BODY = '{"Envelope":{"Body":{"ProcessRequestTrans41Response":{"ProcessRequestTrans41Result":{"ResponseStatus":"Success","ProcessingStartDate":"2020-05-20T17:05:42.8270732+02:00","ProcessingTimeSecs":"0.3650208","UniqueRefGuid":"2e840d53-040c-416d-9881-c10c687e1573","AddressNA07":{"AddressNA07":[{}]},"AddressVerificationNR01":{},"AddressVerificationNR02":{},"AffordabilityAF01":{},"AffordStandardBatchCharsXB01":{},"AggregateAG01":{"ConsumerNo":"005645387","Aggregates":{"Aggregate":[{"Name":"EQ002","Value":"+000000011.0"}]}},"AggregateAG02":{},"AggregateNX05":{},"AggregateNX09":{},"AggregateNX33":{"TotalJudgments":"0","TotalNoticesEver":"0","EnquiriesEver":"0","TotalAdverseEver":"0"},"AlertDetailC4":{},"BCCBC01":{},"BCCBC03":{},"BCCBC04":{},"BCCB701":{},"BCCC1":{},"BCCC2":{},"CCASummaryMX01":{},"CCASummaryMX50":{},"ConsEnqTransInfo0102":{"DefiniteMatchCount":"1","PossibleMatchCount":"00","MatchedConsumerNo":"005645387"},"ConsumerCountersNC04":{},"ConsumerCountersNC50":{"ConsumerNo":"005645387","OwnEnquiries1YrBack":"011","OwnEnquiries2YrsBack":"000","OwnEnquiriesMoreThen2YrsBack":"000","OtherEnquiries1YrBack":"000","OtherEnquiries2YrsBack":"000","OtherEnquiriesMoreThen2YrsBack":"000","Judgements1YrBack":"000","Judgements2YrsBack":"000","JudgementsMoreThen2YrsBack":"000","Notices1YrBack":"000","Notices2YrsBack":"000","NoticesMoreThen2YrsBack":"000","Defaults1YrBack":"000","Defaults2YrsBack":"000","DefaultsMoreThen2YrsBack":"000","PaymentProfiles1YrBack":"000","PaymentProfiles2YrsBack":"000","PaymentProfilesMoreThen2YrsBack":"000","TraceAlerts1YrBack":"000","TraceAlerts2YrsBack":"000","TraceAlertsMoreThen2YrsBack":"000"},"ConsumerInfoNO04":{"RecordSeq":"01","Part":"001","PartSeq":"01","ConsumerNo":"005645387","Surname":"NAIDOO","Forename1":"ARMUGAM","Title":"MR","Gender":"M","NameInfoDate":"20151120","DateOfBirth":"19541112","IdentityNo1":"5411129249086","Dependants":"00","DeceasedDate":"00000000"},"ConsumerInfoNO05":{},"ConsumerTelephoneHistoryNW01":{},"CreditVisionVV01":{},"CreditVisionScoreCO01":{},"CreditVisionVX01":{},"DebtCounsellingDC01":{},"DefaultsD701Part1":{"DefaultD701Part1":[{"ContactName":"OLDMUTUALPERSONALLOANS","InformationDate":"20191016","SupplierName":"OLDMUTUALPERSON","AccountNo":"7420507001","DefaultTypeCode":"BDWO","DefaultType":"BadDebtWrittenOff","DefaultAmount":"000017478","Remarks1":"ZA-OM0102-CON-PPMO-100_000000028CreatedDD","Remarks2":null}]},"DisputeIndicatorDI01":{},"EchoData0001":{"SubscriberCode":"90787","ClientReference":"GN201910061","BatchNumber":"8114"},"EmpiricaEM04":{"ConsumerNo":"005645387","EmpiricaScore":"00005","ExpansionScore":"X","ExpansionScoreDescription":"ExpansionScore"},"EmpiricaEM05":{},"EmpiricaEM07":{},"EnquiriesNE50":{"EnquiryNE50":[{"ConsumerNo":"005645387","DateOfEnquiry":"20200520","Subscriber":"AbsaMerchantSer","Contact":"ABSA011146163","EnquiryTypeCode":"45","EnquiryTypeDescription":"OTHER","OwnAccount":"Y"}]},"FSMS201":{},"FraudScoreFS01":{},"FraudScoreFS01Part2":{},"HawkNH05":{},"IdvNI01":{"IDVerifiedCode":"V2","IDVerifiedDesc":"IDneverIssued"},"IdvNI02":{},"IdvNI03":{},"IncomeEstimatorT101":{},"IncomeEstimatorT102":{},"IncomeEstimatorI401":{},"IVSBV01":{},"JudgementsNJ07":{"JudgementsNJ07":[{"JudgmentDate":null,"Amount":null,"Plaintiff":null,"JudgmentTypeCode":null,"JudgmentTypeDesc":null,"CourtTypeCode":null,"CourtTypeDesc":null,"CourtNameCode":null,"CourtNameDesc":null,"CaseNo":null,"NatureOfDebtCode":null,"NatureOfDebtDesc":null,"Remarks":null,"CaptureDate":null}]},"LapseL401":{},"LinkagesLK":{},"NLRConfirmationMR01":{},"NLRConfirmationMZ01":{},"NLRSummaryMY01":{},"NLRSummaryMY50":{},"NoticesNN08":{"NoticesNN08":[{"NoticeDate":null,"Amount":null,"Applicant":null,"NoticeTypeCode":null,"NoticeType":null,"CaptureDate":null,"CourtTypeCode":null,"CourtTypeDesc":null,"CourtNameCode":null,"CourtNameDesc":null,"CaseNo":null}]},"EmployerInformation":{"EmploymentClientDetails":{}},"ScoreCardAC01":{},"ScoreCardBX01":{},"ScoreCardBX03":{},"StandardBatchCharsB101":{},"StandardBatchCharsFA01":{},"StandardBatchCharsFA02":{},"StandardBatchCharsFA03":{},"StandardBatchCharsSB04":{},"StandardBatchCharsSB07":{},"StandardBatchCharsSB13":{},"StandardBatchCharsSB18":{},"StandardBatchCharsSB19":{},"StandardBatchCharsSB25":{},"StandardBatchCharsSB27":{},"StandardBatchCharsSB30":{},"StandardBatchCharsSB33":{},"StandardBatchCharsSB37":{},"StandardBatchCharsSB40":{},"StandardBatchCharsSB99":{},"TraceAlertTL":{},"TicketSuccessConfirmationFR":{},"UniqueITCRef":{},"ClaimantHeaderCH":{},"ClaimantHeaderHC":{},"StrikeDateOutput":{},"LapseOutputV3":{}}}}}}';
    public static final String JUDGEMENT_RESPONSE_BODY = '{"Envelope":{"Body":{"ProcessRequestTrans41Response":{"ProcessRequestTrans41Result":{"ResponseStatus":"Success","ProcessingStartDate":"2020-05-20T17:05:42.8270732+02:00","ProcessingTimeSecs":"0.3650208","UniqueRefGuid":"2e840d53-040c-416d-9881-c10c687e1573","AddressNA07":{"AddressNA07":[{}]},"AddressVerificationNR01":{},"AddressVerificationNR02":{},"AffordabilityAF01":{},"AffordStandardBatchCharsXB01":{},"AggregateAG01":{"ConsumerNo":"005645387","Aggregates":{"Aggregate":[{"Name":"EQ002","Value":"+000000011.0"}]}},"AggregateAG02":{},"AggregateNX05":{},"AggregateNX09":{},"AggregateNX33":{"TotalJudgments":"02","TotalNoticesEver":"0","EnquiriesEver":"0","TotalAdverseEver":"0"},"AlertDetailC4":{},"BCCBC01":{},"BCCBC03":{},"BCCBC04":{},"BCCB701":{},"BCCC1":{},"BCCC2":{},"CCASummaryMX01":{},"CCASummaryMX50":{},"ConsEnqTransInfo0102":{"DefiniteMatchCount":"1","PossibleMatchCount":"00","MatchedConsumerNo":"005645387"},"ConsumerCountersNC04":{},"ConsumerCountersNC50":{"ConsumerNo":"005645387","OwnEnquiries1YrBack":"011","OwnEnquiries2YrsBack":"000","OwnEnquiriesMoreThen2YrsBack":"000","OtherEnquiries1YrBack":"000","OtherEnquiries2YrsBack":"000","OtherEnquiriesMoreThen2YrsBack":"000","Judgements1YrBack":"000","Judgements2YrsBack":"000","JudgementsMoreThen2YrsBack":"000","Notices1YrBack":"000","Notices2YrsBack":"000","NoticesMoreThen2YrsBack":"000","Defaults1YrBack":"000","Defaults2YrsBack":"000","DefaultsMoreThen2YrsBack":"000","PaymentProfiles1YrBack":"000","PaymentProfiles2YrsBack":"000","PaymentProfilesMoreThen2YrsBack":"000","TraceAlerts1YrBack":"000","TraceAlerts2YrsBack":"000","TraceAlertsMoreThen2YrsBack":"000"},"ConsumerInfoNO04":{"RecordSeq":"01","Part":"001","PartSeq":"01","ConsumerNo":"005645387","Surname":"NAIDOO","Forename1":"ARMUGAM","Title":"MR","Gender":"M","NameInfoDate":"20151120","DateOfBirth":"19541112","IdentityNo1":"5411129249086","Dependants":"00","DeceasedDate":"00000000"},"ConsumerInfoNO05":{},"ConsumerTelephoneHistoryNW01":{},"CreditVisionVV01":{},"CreditVisionScoreCO01":{},"CreditVisionVX01":{},"DebtCounsellingDC01":{},"DefaultsD701Part1":{"DefaultD701Part1":[{"ContactName":"OLDMUTUALPERSONALLOANS","InformationDate":"20191016","SupplierName":"OLDMUTUALPERSON","AccountNo":"7420507001","DefaultTypeCode":"BDWO","DefaultType":"BadDebtWrittenOff","DefaultAmount":"000017478","Remarks1":"ZA-OM0102-CON-PPMO-100_000000028CreatedDD","Remarks2":null}]},"DisputeIndicatorDI01":{},"EchoData0001":{"SubscriberCode":"90787","ClientReference":"GN201910061","BatchNumber":"8114"},"EmpiricaEM04":{"ConsumerNo":"005645387","EmpiricaScore":"00005","ExpansionScore":"X","ExpansionScoreDescription":"ExpansionScore"},"EmpiricaEM05":{},"EmpiricaEM07":{},"EnquiriesNE50":{"EnquiryNE50":[{"ConsumerNo":"005645387","DateOfEnquiry":"20200520","Subscriber":"AbsaMerchantSer","Contact":"ABSA011146163","EnquiryTypeCode":"45","EnquiryTypeDescription":"OTHER","OwnAccount":"Y"}]},"FSMS201":{},"FraudScoreFS01":{},"FraudScoreFS01Part2":{},"HawkNH05":{},"IdvNI01":{"IDVerifiedCode":"V2","IDVerifiedDesc":"IDneverIssued"},"IdvNI02":{},"IdvNI03":{},"IncomeEstimatorT101":{},"IncomeEstimatorT102":{},"IncomeEstimatorI401":{},"IVSBV01":{},"JudgementsNJ07":{"JudgementsNJ07":[{"JudgmentDate":null,"Amount":null,"Plaintiff":null,"JudgmentTypeCode":null,"JudgmentTypeDesc":null,"CourtTypeCode":null,"CourtTypeDesc":null,"CourtNameCode":null,"CourtNameDesc":null,"CaseNo":null,"NatureOfDebtCode":null,"NatureOfDebtDesc":null,"Remarks":null,"CaptureDate":null}]},"LapseL401":{},"LinkagesLK":{},"NLRConfirmationMR01":{},"NLRConfirmationMZ01":{},"NLRSummaryMY01":{},"NLRSummaryMY50":{},"NoticesNN08":{"NoticesNN08":[{"NoticeDate":null,"Amount":null,"Applicant":null,"NoticeTypeCode":null,"NoticeType":null,"CaptureDate":null,"CourtTypeCode":null,"CourtTypeDesc":null,"CourtNameCode":null,"CourtNameDesc":null,"CaseNo":null}]},"EmployerInformation":{"EmploymentClientDetails":{}},"ScoreCardAC01":{},"ScoreCardBX01":{},"ScoreCardBX03":{},"StandardBatchCharsB101":{},"StandardBatchCharsFA01":{},"StandardBatchCharsFA02":{},"StandardBatchCharsFA03":{},"StandardBatchCharsSB04":{},"StandardBatchCharsSB07":{},"StandardBatchCharsSB13":{},"StandardBatchCharsSB18":{},"StandardBatchCharsSB19":{},"StandardBatchCharsSB25":{},"StandardBatchCharsSB27":{},"StandardBatchCharsSB30":{},"StandardBatchCharsSB33":{},"StandardBatchCharsSB37":{},"StandardBatchCharsSB40":{},"StandardBatchCharsSB99":{},"TraceAlertTL":{},"TicketSuccessConfirmationFR":{},"UniqueITCRef":{},"ClaimantHeaderCH":{},"ClaimantHeaderHC":{},"StrikeDateOutput":{},"LapseOutputV3":{}}}}}}';

    @isTest
    public static void TransUnionConsumerCheckServiceTest(){

        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        system.debug('testOpportunity'+testOpportunity.id);
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        Map<String,List<SObject>> responseMap = MerchantTransUnionCheckController.callTransUnionConsumerCheckService(testOpportunity.id);
        System.assertNotEquals(null, testOpportunity);

        Test.stopTest();
    }


    @isTest
    public static void TransUnionConsumerCheckServiceTestNegative(){

        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];

        system.debug('testOpportunity'+testOpportunity.id);
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, JUDGEMENT_RESPONSE_BODY));

        Test.startTest();
        Map<String,List<SObject>> responseMap = MerchantTransUnionCheckController.callTransUnionConsumerCheckService(testOpportunity.id);
        System.assertNotEquals(null, testOpportunity);
        Test.stopTest();
    }

    @isTest
    public static void loadExistingTransUnionCheckRecordsTest(){
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Map<String,List<SObject>> responseMap = MerchantTransUnionCheckController.loadExistingTransUnionCheckRecordMap(testOpportunity.id);
        Test.stopTest();

    }

    @TestSetup
    static void createTestData(){

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{TransunionProcessRequest41_IH_v1.INTEGRATION_SERVICE_NAME});

        Account account = new Account(Name = 'Test Account');
        insert account;

        string RSAid='' ;
        Contact con = new Contact();
        con.FirstName='OOSTHUIZEN';
        con.AccountId=account.id;
        con.LastName='CHANEL';
        con.Birthdate=Date.valueOf('1989-03-06');
        con.ID_Number__c='8911270127087';
        con.ID_Type__c='SA Identity Document';
        if(con.ID_Type__c=='SA Identity Document'){
            RSAid='YES' ;
        }
        insert con;

        Contact con1 = new Contact();
        con1.FirstName='test';
        con1.AccountId=account.id;
        con1.LastName='test';
        con1.Birthdate=Date.valueOf('1989-03-07');
        con1.ID_Number__c='8911270127088';
        con1.ID_Type__c='SA Identity Document';
        insert con1;

        //Create Principal records
        Account testJointAccount = new Account();
        testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testJointAccount.Name = 'Mr Jack Stut';
        testJointAccount.Country_of_Registration__c='South Africa';
        testJointAccount.CIF__c = 'Jck+001';
        insert testJointAccount;
        system.debug('testJointAccount'+testJointAccount.id);

        AccountContactRelation acr =new AccountContactRelation();
        acr.AccountId=testJointAccount.id;
        acr.ContactId=con.id;
        acr.Roles='Director';
        insert acr;
        system.debug('acr'+acr.id);

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = testJointAccount.Id;
        insert testOpp;
        system.debug('testOpp'+testOpp.id);

        Address__c testAddress = new Address__c();
        testAddress.Address_Type__c = 'Physical Address';
        testAddress.Contact__c = con.id;
        testAddress.Address1__c = 'Test';
        testAddress.Address2__c = 'Test 123';
        testAddress.Address3__c = 'Test';
        testAddress.Address4__c = 'Test 123';
        insert testAddress;
    }
}