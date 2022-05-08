/* Controller Test Class For Payment Request (Telephonic) based upon payment type
Author: Himanshu Nimje (Mphatek)
Date :  02/10/2020
Modified: Lulu Rankwe
Date: March 2020
*/

@isTest
public class PaymentRequestControllerTest {
    @testSetup
    static void dataCreation() {
        Account account  = AccountTDF.addClient('Individual', 'Test Account');
        account.ID_Type__pc = 'SA Identity Document';
        account.ID_Number__pc = '8505225522085';
        account.CIF__c = 'ARENTAL001';

        Contact contact  = ContactTDF.addContact('Test contact');
        contact.AccountId = account.Id;
        update contact;
    }

       @isTest
    public static void testCIGetAccount() {

        Account account = [Select Id From Account Limit 1];
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
        );

        Test.startTest();
        String responseBean = PaymentRequestController.getAccountDetails(account.Id);
        System.assert(responseBean.startsWith('['));
        Test.stopTest();
    }

    @isTest
    public static void testCIGetAccountNoAccountWithId() {
        Test.startTest();
        String responseBean = PaymentRequestController.getAccountDetails(null);
        System.assert(responseBean.startsWith('Error'));
        Test.stopTest();
    }

    @isTest
    public static void testCIGetAccountNoIntegrationService() {

        Account account = [Select Id From Account Limit 1];
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        Test.startTest();
        String responseBean = PaymentRequestController.getAccountDetails(account.Id);
        System.assert(responseBean.startsWith('Error'));
        Test.stopTest();
    }

    @isTest
    public static void testgetDailyLimits() {
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
        );

        //make dummy response of CI get Acct Linked
        String getLinkedAccountResp = '{ 	"nbsapdpo": { 		"version": "", 		"returnCode": "0", 		"reasonCode": "0", 		"serviceVersion": "BUSO002", 		"echoKey": "" 	}, 	"nbsmsgo3": { 		"version": "MSG3001", 		"sysErrTxt": "", 		"nbrUserMsgs": "0", 		"nbrUserErrs": "0" 	}, 	"cip047o": { 		"counter": "22", 		"orestart": "", 		"outputTable": [{ 			"oaccntnbr": "00000003001390647", 			"product": "PLOAN", 			"productType": "PL", 			"branch": "8007", 			"corp": "ABS", 			"status": "CURRENT", 			"dtclosed  ": "", 			"balance": "-3326.22", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5  ": "" 		}, { 			"oaccntnbr": "00000004047955012", 			"product": "ISLMSAV", 			"productType": "SA", 			"branch": "8198", 			"corp": "ABS", 			"status": "OPEN-POR", 			"dtclosed": "", 			"balance": "6198.63", 			"limit": "+0000000000000  00.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "6148.63", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006440702949", 			"pro  duct": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440702957", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440704488", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440704925", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440738407", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "APR 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440738465", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "APR 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440821789", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "SEP 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440832380", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "IN FORCE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"s  rcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006624841062", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "4550270023487015", 			"product": "DUL", 			"productType": "CA", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "4550270023487015", 			"pro  duct": "", 			"productType": "CA", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006625152115", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "  LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOf  Fnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006626363313", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"  limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntn  br": "00000006627548566", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000  000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006628871544", 			"product": "", 			"productType": "  LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006628882129", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"  dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "  ", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000009051037423", 			"product": "FLEXI", 			"productType": "SA", 			"branch": "8198", 			"corp": "ABS", 			"status": "OPEN", 			"dtclosed": "", 			"balance": "8775.12", 			"limit": "+000000  000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "8725.12", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "0445143000004041  5", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "04483850000071015", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp  ": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"  srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "05359690000019061", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "000000040479550  12", 			"product": "PBANKCQ", 			"productType": "CQ", 			"branch": "8198", 			"corp": "ABS", 			"status": "CLS PORT", 			"dtclosed": "FEB 19", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}] 	} }';
        CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = new CIgetAcctLinkedToClientCode_Resp_IB_v1();
        CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBeanContent = (CIgetAcctLinkedToClientCode_Resp_IB_v1) responseBean.deserialize(
            getLinkedAccountResp,
            CIgetAcctLinkedToClientCode_Resp_IB_v1.class
        );

        responseBeanContent.status = 'OK';
        responseBeanContent.statusCode = 200;
        responseBeanContent.message = '';
        Sys_Log_Integration__c log = new Sys_Log_Integration__c();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        log = SystemLogger.mapResponseFields(log, responseBeanContent.statusCode, responseBeanContent.status, getLinkedAccountResp);
        logList.add(log);

        Map<string, CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accNoMapToReponseWrapper = new Map<string, CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>(); //Store all account details to client
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accDetailsList = responseBeanContent.cip047o.outputTable;
        String combiAccountNumber;
        for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj : accDetailsList) {
            if (accWrObj.productType == 'CO' && accWrObj.status == 'ACTIVE') {
                // ADD CONDITION FOR STATUS
                accNoMapToReponseWrapper.put(accWrObj.oaccntnbr, accWrObj);
                combiAccountNumber = accWrObj.oaccntnbr;
            }
        }
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CCgetDailyLimits_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CC_GET_DAILY_LIMITS });

        Test.startTest();
        String response = PaymentRequestController.getDailyLimits(combiAccountNumber);
        Test.stopTest();
    }

    @isTest
    public static void testintiatePayment() {
        //Insert Integration Settings
        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.MBinitiatePaymentV10_STRING });

        Test.startTest();
        MBinitiatePaymentV10_Resp_IB_v1 response = PaymentRequestController.intiatePayment(
            '11050112',
            '20200129',
            '1',
            '4048017641',
            '02',
            'test',
            '62001847237',
            '632005',
            '02',
            'test2',
            '',
            'test3',
            ''
        );
        system.assertNotEquals(null, response);
        Test.stopTest();
    }
    @isTest
    public static void testIntiateBeneficiaryPayment() {
        Account account = [Select Id, CIF__c From Account Limit 1];
        account.CIF__c = 'ZUMAD 001';
        update account;

        //Insert Integration Settings
        Test.setMock(HttpCalloutMock.class, new MBinitiatePaymentV10_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.MBinitiatePaymentV10_STRING });

        Test.startTest();
        MBinitiatePaymentV10_Resp_IB_v1 resp = PaymentRequestController.payBeneficiary(
            account.Id,
            '11050112',
            '4483850000161519',
            'Lulu text',
            '20200526',
            '1.00',
            '51',
            '4048017641',
            '02',
            '632005',
            'luu',
            '62001847237',
            '250655',
            '02',
            'tere',
            ''
        );
        system.assertNotEquals(null, resp);
        Test.stopTest();
    }

    @isTest
    public static void testIntiatefuturePayment() {
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CREATE_INSTRUCTION });

        Test.startTest();
        String resp = PaymentRequestController.intiatefuturePayment(
            '4048247806',
            '01',
            '2',
            '4047995828',
            '632005',
            'test',
            '01',
            '20200228',
            'payment',
            '4047995828'
        );
        system.assertEquals(null, resp);
        Test.stopTest();
    }

    @isTest
    public static void testCompletePayment() {
        Test.setMock(HttpCalloutMock.class, new MBcomplEpSpaymentV4Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.JITTERBIT_API_RB_STRING,
            new List<String>{ StringConstants.MB_COMPL_EPS_PAYMENT }
        );
        IntegrationTestDataFactory.insertIntegrationTranslations();

        Test.startTest();
        //MBcomplEpSpaymentV4_IH_v1 response = new MBcomplEpSpaymentV4_IH_v1();
        String resp = PaymentRequestController.completePayment('80003705DB');
        //system.assertNotEquals(null, resp);
        Test.stopTest();
    }

    @isTest
    public static void testCompleteBenePayment() {
        Test.setMock(HttpCalloutMock.class, new MBcomplEpSpaymentV4Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.JITTERBIT_API_RB_STRING,
            new List<String>{ StringConstants.MB_COMPL_EPS_PAYMENT }
        );

        Test.startTest();
        MBcomplEpSpaymentV4_IH_v1 response = new MBcomplEpSpaymentV4_IH_v1();
        String resp = PaymentRequestController.completeBeneficiaryPayment('80003705DB', '1');
        system.assertNotEquals(null, resp);
        Test.stopTest();
    }

    @isTest
    public static void testGetBeneficiaries() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, MBlistInstructionsPerSrcAccV1_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.JITTERBIT_API_RB_STRING,
            new List<String>{ MBlistInstructionsPerSrcAccV1_IH_v1.INTEGRATION_SERVICE_NAME }
        );

        Test.startTest();
        MBlistInstructionsPerSrcAccV1_Resp_IB_v1 resp = PaymentRequestController.getBeneficiariesList('CIF001', '4048017641');
        System.assertEquals(200, resp.statusCode);
        Test.stopTest();
    }

    @isTest
    public static void testGetBranch() {
        Test.startTest();
        PaymentRequestController.getBankBranchCode('ABSA BANK');
        PaymentRequestController.getBankBranchCode('BIDVEST BANK LIMITED');
        PaymentRequestController.getBankBranchCode('CAPITEC BANK LIMITED');
        PaymentRequestController.getBankBranchCode('FIRST NATIONAL BANK');
        PaymentRequestController.getBankBranchCode('INVESTEC BANK LIMITED');
        PaymentRequestController.getBankBranchCode('NEDBANK');
        PaymentRequestController.getBankBranchCode('STANDARD BANK SA LTD');
        //system.assertNotEquals(null, resp);
        Test.stopTest();
    }

    @isTest
    public static void testupdateFuturePayment() {
        Account account = [Select Id, CIF__c From Account Limit 1];
        account.CIF__c = 'AFIFTAP001';
        update account;
        
        Test.setMock(HttpCalloutMock.class, new MBupdateInstructionV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT_API_RB_STRING,
            new List<String>{ StringConstants.MB_UPDATE_BENEFICIARIES_V1 }
        );

        Test.startTest();

        try {
            String responseMap = PaymentRequestController.updateFuturePayment(
                account.id,
                '1',
                '1',
                'don',
                '1021871806',
                '02',
                '632005',
                'don',
                '62001847237',
                '02',
                '250655',
                'ton',
                '20201104'
            );
            system.assertNotEquals(null, responseMap);
        } catch (exception ex) {
        }
        Test.stopTest();
    }

    @isTest
    public static void removePayment() {
        Account account = [Select Id, CIF__c From Account Limit 1];
        account.CIF__c = 'ZUMAD 001';
        update account;

        Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT_API_RB_STRING,
            new List<String>{ StringConstants.MB_DELETE_BENEFICIARIES_V2 }
        );

        Test.startTest();
        String responseMap = PaymentRequestController.removePayment(account.Id, '1');
        system.assertNotEquals(null, responseMap);
        Test.stopTest();
    }

    @isTest
    public static void testgetIntsructionList() {
        Account account = [Select Id, CIF__c From Account Limit 1];
        account.CIF__c = 'ZUMAD 001';
        update account;

        Test.setMock(HttpCalloutMock.class, new MBListsourceinstructionsv1_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT_API_RB_STRING,
            new List<String>{ StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1 }
        );

        Test.startTest();
        String responseMap = PaymentRequestController.getIntsructionList(account.Id, '9051254425');
        system.assertNotEquals(null, responseMap);
        Test.stopTest();
    }
}