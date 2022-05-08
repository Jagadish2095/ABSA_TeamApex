/** 
 * @description Test class for for AbsaRewardsCloseOrEscalateCTRL 
 * @author Simangaliso Mathenjwa.
 * @since 29 November 2021.
 */
@IsTest
public  class AbsaRewardsCloseOrEscalateCTRL_Test {
    
    /** 
     * @description Purpose : Method to create test data
     */
    @testSetup
    public static void dataCreation(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    	Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email', 
                                Status = 'New', 
                                Origin = 'Email',
                                Account = account ,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today(),
                                SLA_Extension_Approval__c = 'Pending',
                                Comments ='Testing');
        insert caseRec;
        
        Service_Group__c serviceGroupRecord = new Service_Group__c(Name='SG',Queue__c='Queue',Active__c=true, Assign_Record_Type__c = 'Service Request', Response_Email_Address__c = 'absarewards@absa.co.za');
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name='Type Subtype', Type__c='Type', Subtype__c='Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=serviceGroupRecord.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;

        Voucher__c voucher = new Voucher__c(Name='X.10', Reward_Type__c ='R50 Donation',Amount__c=50,Reward_Status__c='Active',Voucher_Pin__c='****HYAEUKTN',Voucher_Type_Selected__c='Gi394th', Case__c=caseRec.Id, Pin_Claimed_In_Time__c='N/A',Voucher_Expiry_Date__c =Date.newInstance(2022, 11, 29), Voucher_Issue_Date__c= Date.newInstance(2021, 11, 29), Date_of_Purchase__c =Date.newInstance(2021, 11, 29));
        insert voucher;
        
    }
    
    @IsTest
	public static void transferCaseTest() {

        Case caseRec = [SELECT Id, Transfer_Reason__c,sd_Service_Group_Id__c, Comments FROM Case LIMIT 1];
        Id contactId = [Select Id FROM Contact LIMIT 1].Id;
        caseRec.BusinessHoursId = [Select Id From BusinessHours Where isActive = true Limit 1].Id;
        
        update caseRec;

        Service_Group__c serviceGroupRec = [SELECT Id, Name, Response_Email_Address__c FROM Service_Group__c LIMIT 1];
        Service_Type__c serviceTypeRec = [SELECT Id, Name FROM Service_Type__c LIMIT 1];

        Test.startTest();
        AbsaRewardsCloseOrEscalateCTRL.transferCase(serviceGroupRec.Name, serviceTypeRec.Name, caseRec.Id);
        AbsaRewardsCloseOrEscalateCTRL.sendEmail(String.valueOf(caseRec.Id),'test@test.com', 'Digital_Lifestyle_Escalate_to_Stellr', 'Hello test');
        Test.stopTest();

        Case caseAfter = [SELECT Id, sd_Service_Group__c FROM Case LIMIT 1];
        System.assertEquals(caseAfter.sd_Service_Group__c, serviceGroupRec.Name, 'Assert failed');
        System.assertNotEquals(contactId, null, 'Assert failed');
    }

    @IsTest
	public static void getAttachedVoucherTest() {
        Case caseRec = [SELECT Id, Transfer_Reason__c,sd_Service_Group_Id__c, Comments FROM Case LIMIT 1];
        Voucher__c VoucherRec = [SELECT Id FROM Voucher__c LIMIT 1];
        Test.startTest();
        List<Voucher__c> getAttachedVoucherList = AbsaRewardsCloseOrEscalateCTRL.getAttachedVoucher(String.valueOf(caseRec.Id));
        System.assertEquals(VoucherRec.Id, getAttachedVoucherList[0].Id, 'Assert failed');
        Test.stopTest();

    }

    @IsTest
	public static void getAvailableVouchersTest() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetAvailableVouchers';
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ GetAvailableVouchers_IH_IB_v1.INTEGRATION_SERVICE_NAME}
		);

        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        Test.startTest();
		GetAvailableVouchers_Resp_IB_v1 testResponse = AbsaRewardsCloseOrEscalateCTRL.getAvailableVouchers('cb6abacf-bcb6-48ee-af24-15121a72a533');
		System.assertEquals(200, testResponse.statusCode, 'Assert Failed');
		Test.stopTest();
    }

    @IsTest
	public static void reissueVoucherApexTest() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ReIssueVoucher';
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ReIssueVoucher_IH_IB_v1.INTEGRATION_SERVICE_NAME}
		);

        Map<String, String> requestFieldsMap = new Map<String, String>();
		requestFieldsMap.put('txnReference', '344aecf2-95a0-48bc-9e32-504e6fc127ac');
		requestFieldsMap.put('cifKey', 'MADIDNJ001');
		requestFieldsMap.put('idNumber', '9101265784089');
		requestFieldsMap.put('partnerId', 'GI50');
		requestFieldsMap.put('offerTier', 'Bronze');
		requestFieldsMap.put('oldRewardPinVoucher', '****XCMHYADP');
		requestFieldsMap.put('challengeId', 'X.101');

        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        Test.startTest();
		ReIssueVoucher_Resp_IB_v1 testResponse = AbsaRewardsCloseOrEscalateCTRL.reissueVoucherApex(requestFieldsMap);
		System.assertEquals(200, testResponse.statusCode, 'Assert Failed');
		Test.stopTest();
    }

    @IsTest
	public static void scheduleVoucherReissueApexTest() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ReIssueVoucher';
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ReIssueVoucher_IH_IB_v1.INTEGRATION_SERVICE_NAME}
		);

        Map<String, String> requestFieldsMap = new Map<String, String>();
		requestFieldsMap.put('txnReference', '344aecf2-95a0-48bc-9e32-504e6fc127ac');
		requestFieldsMap.put('cifKey', 'MADIDNJ001');
		requestFieldsMap.put('idNumber', '9101265784089');
		requestFieldsMap.put('partnerId', 'GI50');
		requestFieldsMap.put('offerTier', 'Bronze');
		requestFieldsMap.put('oldRewardPinVoucher', '****XCMHYADP');
		requestFieldsMap.put('challengeId', 'X.101');

        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        Test.startTest();
		String testResponse = AbsaRewardsCloseOrEscalateCTRL.scheduleVoucherReissueApex(requestFieldsMap);
		System.assertNotEquals(null, testResponse, 'Assert Failed');
		Test.stopTest();
    }


}