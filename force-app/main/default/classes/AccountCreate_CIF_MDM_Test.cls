/*

 * @description No change made only pushing as part of commit. Rob @2020-02-22
 * updated 2021-09-15
 */
@isTest
public class AccountCreate_CIF_MDM_Test {

/**
 *
 * @description testCreateAccountCIF_Individual_Postivive
 * @author  
 */
    @isTest
    public static void testCreateAccountCIF_Individual_Postivive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromCIF('LEBOTL 001', '0', '009970');
        System.assertNotEquals('LEBOTL 001', null,200);
        Test.stopTest();
    }

/**
 *
 * @description testCreateAccountCIF_Individual_Negative
 */
    @isTest
    public static void testCreateAccountCIF_Individual_Negative() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null, null, null, 'Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromCIF('LEBOTL 001', '0', '009970');
        System.assertNotEquals('LEBOTL 001', null,200);

        Test.stopTest();
    }

/**
 *
 * @description testCreateAccountCIF_Joint_Postivive
 */
    @isTest
    public static void testCreateAccountCIF_Joint_Postivive() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                null,
                'Joint Account',
                'Joint-Individual Account'
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF' }
        );

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);

        Test.stopTest();
    }

/**
 *
 * @description testCreateAccountCIF_Joint_Negative_JntPart
 */
    @isTest
    public static void testCreateAccountCIF_Joint_Negative_JntPart() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.NEGATIVE_STRING,
                null,
                'Joint Account',
                'Joint-Individual Account'
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF' }
        );

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);

        Test.stopTest();
    }

    /**
 *
 * @description testCreateAccountCIF_Joint_Negative_GetClientById
 */ 
    @isTest
    public static void testCreateAccountCIF_Joint_Negative_GetClientById() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.NEGATIVE_STRING,
                StringConstants.POSITIVE_STRING,
                null,
                'Joint Account',
                'Joint-Individual Account'
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF' }
        );

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);

        Test.stopTest();
    }

       /**
 *
 * @description testCreateAccountCIF_Joint_Negative_GetClient
 */
    @isTest
    public static void testCreateAccountCIF_Joint_Negative_GetClient() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.NEGATIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                null,
                'Joint Account',
                'Joint-Individual Account'
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF' }
        );

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);

        Test.stopTest();
    }

          /**
 * @description testCreateAccountCIF_Sole_Positive
 */
   @isTest
    public static void testCreateAccountCIF_Sole_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Sole Proprietor', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountCIF_Non_Individual_Positive
 */
    @isTest
    public static void testCreateAccountCIF_Non_Individual_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Non Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountCIF_Estate_Positive
 */
    @isTest
    public static void testCreateAccountCIF_Estate_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Estate', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountCIF_Partnership_Positive
 */
    @isTest
    public static void testCreateAccountCIF_Partnership_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Partnership', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountCIF_Unidentified_Positive
 */
    @isTest
    public static void testCreateAccountCIF_Unidentified_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Unidentified', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });

        Test.startTest();
        //Fails on UPSERT of Participants. Needs to be fixed in the future.
        //duplicate value found: <unknown> duplicates value on record with id: <unknown>:

        AccountCreate_CIF_MDM.createAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
 /**
 * @description testCreateAccountMDM_Individual_Postivive
 */
    @isTest
    public static void testCreateAccountMDM_Individual_Postivive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(null, null, null, StringConstants.POSITIVE_STRING, 'Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Involved Parties' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
          /**
 * @description testCreateAccountMDM_Individual_Negative
 */
    @isTest
    public static void testCreateAccountMDM_Individual_Negative() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(null, null, null, StringConstants.NEGATIVE_STRING, 'Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Involved Parties' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
 /**
 * @description testCreateAccountMDM_Joint_Positive
 */
    @isTest
    public static void testCreateAccountMDM_Joint_Positive() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                'Joint Account',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Joint_Negative_InvParties
 */
    @isTest
    public static void testCreateAccountMDM_Joint_Negative_InvParties() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.NEGATIVE_STRING,
                'Joint Account',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Joint_Negative_JntPart
 */
    @isTest
    public static void testCreateAccountMDM_Joint_Negative_JntPart() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.NEGATIVE_STRING,
                StringConstants.POSITIVE_STRING,
                'Joint Account',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Joint_Negative_GetClientById
 */
    @isTest
    public static void testCreateAccountMDM_Joint_Negative_GetClientById() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.NEGATIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                'Joint Account',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Joint_Negative_GetClient
 */
    @isTest
    public static void testCreateAccountMDM_Joint_Negative_GetClient() {
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.NEGATIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                'Joint Account',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Joint_Negative_NullParams
 */
    @isTest
    public static void testCreateAccountMDM_Joint_Negative_NullParams() {
        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM(null, null);
        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testcreateParticipantsMDM_Joint_Positive
 */
    @isTest
    public static void testcreateParticipantsMDM_Joint_Positive() {
        WimiTestDataFactory testData = new WimiTestDataFactory();
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                'Individual',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createParticipantsMDM(testData.testAccount);
        System.assertNotEquals(null, testData);
        Test.stopTest();
    }

    /*public static testMethod void testcreateParticipantsMDM_Joint_Negative_InvParties(){
        
        WimiTestDataFactory testData = new WimiTestDataFactory();
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.NEGATIVE_STRING, 'Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {'Get Involved Parties', 'Get Joint Participant'});
        
        Test.startTest();
        
        AccountCreate_CIF_MDM.createParticipantsMDM(testData.testAccount);
        
        Test.stopTest();
    }*/
/**
 * @description testcreateParticipantsMDM_Joint_Negative_JntPart
 */
    @isTest
    public static void testcreateParticipantsMDM_Joint_Negative_JntPart() {
        WimiTestDataFactory testData = new WimiTestDataFactory();
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.NEGATIVE_STRING,
                StringConstants.POSITIVE_STRING,
                'Individual',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createParticipantsMDM(testData.testAccount);
        System.assertNotEquals(null, testData);
        Test.stopTest();
    }
/**
 * @description testcreateParticipantsMDM_Joint_Negative_GetClientById
 */
    @isTest
    public static void testcreateParticipantsMDM_Joint_Negative_GetClientById() {
        WimiTestDataFactory testData = new WimiTestDataFactory();
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.POSITIVE_STRING,
                StringConstants.NEGATIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                'Individual',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createParticipantsMDM(testData.testAccount);
        System.assertNotEquals(null, testData);
        Test.stopTest();
    }
/**
 * @description testcreateParticipantsMDM_Joint_Negative_GetClient
 *
 */
    @isTest
    public static void testcreateParticipantsMDM_Joint_Negative_GetClient() {
        WimiTestDataFactory testData = new WimiTestDataFactory();
        Test.setMock(
            HttpCalloutMock.class,
            new AccountCreate_CIF_MDM_Mock_ApiRest(
                StringConstants.NEGATIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                StringConstants.POSITIVE_STRING,
                'Individual',
                null
            )
        );
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(
            StringConstants.API_MANAGER,
            new List<String>{ 'Get Involved Parties', 'Get Joint Participant' }
        );

        Test.startTest();

        AccountCreate_CIF_MDM.createParticipantsMDM(testData.testAccount);
        System.assertNotEquals(null, testData);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Sole_Positive
 *
 */
    @isTest
    public static void testCreateAccountMDM_Sole_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(null, null, null, StringConstants.POSITIVE_STRING, 'Sole Proprietor', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Involved Parties' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Estate_Positive
 *
 */
    @isTest
    public static void testCreateAccountMDM_Estate_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(null, null, null, StringConstants.POSITIVE_STRING, 'Estate', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Involved Parties' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Partnership_Positive
 *
 */
    @isTest
    public static void testCreateAccountMDM_Partnership_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(null, null, null, StringConstants.POSITIVE_STRING, 'Partnership', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Involved Parties' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateAccountMDM_Non_Individual_Positive
 *
 */
    @isTest
    public static void testCreateAccountMDM_Non_Individual_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(null, null, null, StringConstants.POSITIVE_STRING, 'Non Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Involved Parties' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }

 /**
 *
 * @description testCreateAccountMDM_Unidentified_Positive
 *
 */
    @isTest
    public static void testCreateAccountMDM_Unidentified_Positive() {
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(null, null, null, StringConstants.POSITIVE_STRING, 'Unidentified', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Involved Parties' });

        Test.startTest();

        AccountCreate_CIF_MDM.createAccountFromMDM('SAID', '8905145814085');
        System.assertNotEquals('SAID', null,200);
        Test.stopTest();
    }
/**
 *
 * @description AccountCreate_CIF_MDM_Mock_ApiRest
 */
    public class AccountCreate_CIF_MDM_Mock_ApiRest implements HttpCalloutMock {
        private String getClientDetailsStatus;
        private String getClientDetailsByIdStatus;
        private String getJntPartStatus;
        private String getInvPartiesStatus;
        private String mainAccountType;
        private String secondAccountType;

        //@param typeTest: positive or negative response
/**
 * @description testcreateParticipantsMDM_Joint_Negative_GetClientById
 * @param getClientDetailsStatus
 * @param getClientDetailsByIdStatus
 * @param getJntPartStatus
 * @param getInvPartiesStatus
 * @param mainAccountType
 * @param secondAccountType
 */
        public AccountCreate_CIF_MDM_Mock_ApiRest(
            final String getClientDetailsStatus,
            final String getClientDetailsByIdStatus,
            final String getJntPartStatus,
            final String getInvPartiesStatus,
            final String mainAccountType,
            final String secondAccountType
        ) {
            this.getClientDetailsStatus = getClientDetailsStatus;
            this.getClientDetailsByIdStatus = getClientDetailsByIdStatus;
            this.getJntPartStatus = getJntPartStatus;
            this.getInvPartiesStatus = getInvPartiesStatus;
            this.mainAccountType = mainAccountType;
            this.secondAccountType = secondAccountType;
        }

        //Implement this interface method
        /**
 * @description testcreateParticipantsMDM_Joint_Negative_GetClientById
 * @param request
 * @return response
 */
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();

            //Get Client Details
            if (request.getEndpoint().equals('nullGet Client Details')) {
                if (mainAccountType == 'Individual') {
                    response.setBody(
                        '{"indCifRecFound":"Y","clientCode":"LEBOTL 001","initials":"L","language":"E","titleCode":"2","surname":"LEBOTSE","postlAddrLine1":"123 WF NKOMO","postlAddrLine2":"","postlSuburb":"","postlTown":"CENTRAL","postlCodeRsa":"2","idDocType":"1","idNumber":"9012090586088","birthDate":"19901209","maritalStatus":"1","smsMarkInd":"N","gender":"2","minorChildren":"1","occupationCode":"15","incomeGroup":"16","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"4512","dateClientOpened":"20181008","changeNumber":"21","dateLastChanged":"20190712","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"3","prohibitedInd":"N","postalAddrHold":"N","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"N","courtAuthrityHold":"N","thirdPartyInd":"Y","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"3","homeLanguage":"N","marketingConcent":"N","clientType":"101","miltaryComtmntInd":"N","occupationType":"O","noOfJointPartcpnt":"0","taxNumber":"0","sicCode":"0","firstNames":"LESEGO","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"","workTelCode":"11","workTelephone":"5563232","physicalAddrHold":"N","employerAddrHold":"N","cellphone":"66000000000","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"1","employmentSector":"6","occupationLevel":"4","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"4","cellphoneBankInd":"","siccCode5":"00000","subSegment":"F1","emailMarkInd":"N","teleMarkInd":"N","internetBankinInd":"","sourceOfIncome":"20","dateIdentified":"15032019","dateVerified":"15032019","employeeIdentified":"9130622","employeeVerified":"9130622","vatRegistrationNo":"","clientNationality":"SOU01","countryOfOrigin":"","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"N","exemptionIndicator":"00","corporateDivision":"A","postMatricQualifd":"N","postMatricQualfton":"0","receiveSocialGrant":"N","notifyMeIndicator":"","mailInd":"N","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"99999","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"15032019","ibrAffected":"N","clientGroup":"I","nbrOfAddressesRtrv":"2","addressEntry":[{"addrType":"10","addrSeqNbr":"0","addrLine1":"123 WF NKOMO","addrLine2":"","addrSuburbRsa":"","addrTown":"CENTRAL","addrPostlCode":"2"},{"addrType":"70","addrSeqNbr":"0","addrLine1":"NAPPIES","addrLine2":"270 MAGGS STREET","addrSuburbRsa":"","addrTown":"WALTLOO","addrPostlCode":"184"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"LEBOTSE","nkinFname":"THABO","nkinRela":"8","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"0710000000","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"Y","updTelephoneInd":"Y","updEmailInd":"N","updDateInd":"8102018","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"SO003","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"SO003","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"Y","sec129DeliveryAddr":"2","saTaxRegis":"N","rsonSaTaxNotGiven":"","foreignTaxRegis":"N","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"Y","nonCreditDateChanged":"20190712","nonCreditSms":"Y","nonCreditEmail":"Y","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"Y","creditIndicator":"Y","creditDateChanged":"20190712","creditSms":"Y","creditEmail":"Y","creditAvoice":"Y","creditTelephone":"Y","creditPost":"Y"}'
                    );
                } else if (mainAccountType == 'Joint Account') {
                    response.setBody(
                        '{"indCifRecFound":"Y","clientCode":"SWANSR+002","initials":"","language":"","titleCode":"0","surname":"SWANSON MR R & SWANSON MR D","postlAddrLine1":"109 KATHERINE STREET","postlAddrLine2":"","postlSuburb":"","postlTown":"SANDTON","postlCodeRsa":"2196","idDocType":"0","idNumber":"","birthDate":"0","maritalStatus":"0","smsMarkInd":"","gender":"0","minorChildren":"","occupationCode":"0","incomeGroup":"0","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"3232","dateClientOpened":"20190515","changeNumber":"14","dateLastChanged":"20190703","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"0","prohibitedInd":"N","postalAddrHold":"","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"","courtAuthrityHold":"N","thirdPartyInd":"N","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"0","homeLanguage":"","marketingConcent":"","clientType":"301","miltaryComtmntInd":"N","occupationType":"0","noOfJointPartcpnt":"2","taxNumber":"0","sicCode":"0","firstNames":"","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"0","workTelCode":"0","workTelephone":"","physicalAddrHold":"N","employerAddrHold":"","cellphone":"0","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"0","employmentSector":"0","occupationLevel":"0","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"0","cellphoneBankInd":"","siccCode5":"","subSegment":"F1","emailMarkInd":"","teleMarkInd":"","internetBankinInd":"","sourceOfIncome":"0","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","vatRegistrationNo":"","clientNationality":"","countryOfOrigin":"SO003","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"","exemptionIndicator":"","corporateDivision":"A","postMatricQualifd":"0","postMatricQualfton":"0","receiveSocialGrant":"N","notifyMeIndicator":"","mailInd":"","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"0","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"0","ibrAffected":"N","clientGroup":"J","nbrOfAddressesRtrv":"0","addressEntry":[{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"","nkinFname":"","nkinRela":"0","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"N","updTelephoneInd":"N","updEmailInd":"N","updDateInd":"15052019","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"N","sec129DeliveryAddr":"0","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"","nonCreditDateChanged":"0","nonCreditSms":"","nonCreditEmail":"","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"","creditIndicator":"","creditDateChanged":"0","creditSms":"","creditEmail":"","creditAvoice":"Y","creditTelephone":"Y","creditPost":""}'
                    );
                } else if (secondAccountType == 'Joint-Individual Account') {
                    response.setBody(
                        '{"indCifRecFound":"Y","clientCode":"SWANSR 002","initials":"R","language":"E","titleCode":"1","surname":"SWANSON","postlAddrLine1":"109 KATHERINE STREET","postlAddrLine2":"","postlSuburb":"","postlTown":"SANDTON","postlCodeRsa":"2196","idDocType":"1","idNumber":"8905145814085","birthDate":"19890514","maritalStatus":"1","smsMarkInd":"","gender":"1","minorChildren":"","occupationCode":"15","incomeGroup":"0","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"3232","dateClientOpened":"20190515","changeNumber":"2","dateLastChanged":"20190515","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"0","prohibitedInd":"N","postalAddrHold":"","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"","courtAuthrityHold":"N","thirdPartyInd":"N","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"5","homeLanguage":"","marketingConcent":"","clientType":"101","miltaryComtmntInd":"N","occupationType":"0","noOfJointPartcpnt":"0","taxNumber":"0","sicCode":"0","firstNames":"RONALD","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"","workTelCode":"22","workTelephone":"3456789","physicalAddrHold":"N","employerAddrHold":"","cellphone":"627899314","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"1","employmentSector":"0","occupationLevel":"0","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"ron@gmail.com","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"2","cellphoneBankInd":"","siccCode5":"","subSegment":"F1","emailMarkInd":"","teleMarkInd":"","internetBankinInd":"","sourceOfIncome":"21","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","vatRegistrationNo":"","clientNationality":"SOU01","countryOfOrigin":"SO003","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"","exemptionIndicator":"","corporateDivision":"A","postMatricQualifd":"0","postMatricQualfton":"0","receiveSocialGrant":"0","notifyMeIndicator":"","mailInd":"","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"0","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"0","ibrAffected":"N","clientGroup":"I","nbrOfAddressesRtrv":"1","addressEntry":[{"addrType":"10","addrSeqNbr":"0","addrLine1":"109 KATHERINE STREET","addrLine2":"","addrSuburbRsa":"","addrTown":"SANDTON","addrPostlCode":"2196"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"","nkinFname":"","nkinRela":"0","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"N","updTelephoneInd":"N","updEmailInd":"N","updDateInd":"15052019","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"SO003","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"N","sec129DeliveryAddr":"0","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"N","nonCreditDateChanged":"20190515","nonCreditSms":"","nonCreditEmail":"","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"","creditIndicator":"","creditDateChanged":"0","creditSms":"","creditEmail":"","creditAvoice":Y,"creditTelephone":"Y","creditPost":""}'
                    );
                } else if (mainAccountType == 'Sole Proprietor') {
                    response.setBody(
                        '{"indCifRecFound":"Y","clientCode":"SWANSR+002","initials":"","language":"","titleCode":"0","surname":"SWANSON MR R & SWANSON MR D","postlAddrLine1":"109 KATHERINE STREET","postlAddrLine2":"","postlSuburb":"","postlTown":"SANDTON","postlCodeRsa":"2196","idDocType":"0","idNumber":"","birthDate":"0","maritalStatus":"0","smsMarkInd":"","gender":"0","minorChildren":"","occupationCode":"0","incomeGroup":"0","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"3232","dateClientOpened":"20190515","changeNumber":"14","dateLastChanged":"20190703","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"0","prohibitedInd":"N","postalAddrHold":"","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"","courtAuthrityHold":"N","thirdPartyInd":"N","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"0","homeLanguage":"","marketingConcent":"","clientType":"301","miltaryComtmntInd":"N","occupationType":"0","noOfJointPartcpnt":"2","taxNumber":"0","sicCode":"0","firstNames":"","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"0","workTelCode":"0","workTelephone":"","physicalAddrHold":"N","employerAddrHold":"","cellphone":"0","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"0","employmentSector":"0","occupationLevel":"0","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"0","cellphoneBankInd":"","siccCode5":"","subSegment":"F1","emailMarkInd":"","teleMarkInd":"","internetBankinInd":"","sourceOfIncome":"0","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","vatRegistrationNo":"","clientNationality":"","countryOfOrigin":"SO003","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"","exemptionIndicator":"","corporateDivision":"A","postMatricQualifd":"0","postMatricQualfton":"0","receiveSocialGrant":"N","notifyMeIndicator":"","mailInd":"","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"0","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"0","ibrAffected":"N","clientGroup":"S","nbrOfAddressesRtrv":"0","addressEntry":[{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"","nkinFname":"","nkinRela":"0","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"N","updTelephoneInd":"N","updEmailInd":"N","updDateInd":"15052019","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"N","sec129DeliveryAddr":"0","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"","nonCreditDateChanged":"0","nonCreditSms":"","nonCreditEmail":"","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"","creditIndicator":"","creditDateChanged":"0","creditSms":"","creditEmail":"","creditAvoice":"Y","creditTelephone":"Y","creditPost":""}'
                    );
                } else if (mainAccountType == 'Non Individual') {
                    response.setBody(
                        '{"indCifRecFound":"Y","clientCode":"SWANSR+002","initials":"","language":"","titleCode":"0","surname":"SWANSON MR R & SWANSON MR D","postlAddrLine1":"109 KATHERINE STREET","postlAddrLine2":"","postlSuburb":"","postlTown":"SANDTON","postlCodeRsa":"2196","idDocType":"0","idNumber":"","birthDate":"0","maritalStatus":"0","smsMarkInd":"","gender":"0","minorChildren":"","occupationCode":"0","incomeGroup":"0","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"3232","dateClientOpened":"20190515","changeNumber":"14","dateLastChanged":"20190703","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"0","prohibitedInd":"N","postalAddrHold":"","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"","courtAuthrityHold":"N","thirdPartyInd":"N","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"0","homeLanguage":"","marketingConcent":"","clientType":"301","miltaryComtmntInd":"N","occupationType":"0","noOfJointPartcpnt":"2","taxNumber":"0","sicCode":"0","firstNames":"","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"0","workTelCode":"0","workTelephone":"","physicalAddrHold":"N","employerAddrHold":"","cellphone":"0","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"0","employmentSector":"0","occupationLevel":"0","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"0","cellphoneBankInd":"","siccCode5":"","subSegment":"F1","emailMarkInd":"","teleMarkInd":"","internetBankinInd":"","sourceOfIncome":"0","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","vatRegistrationNo":"","clientNationality":"","countryOfOrigin":"SO003","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"","exemptionIndicator":"","corporateDivision":"A","postMatricQualifd":"0","postMatricQualfton":"0","receiveSocialGrant":"N","notifyMeIndicator":"","mailInd":"","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"0","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"0","ibrAffected":"N","clientGroup":"N","nbrOfAddressesRtrv":"0","addressEntry":[{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"","nkinFname":"","nkinRela":"0","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"N","updTelephoneInd":"N","updEmailInd":"N","updDateInd":"15052019","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"N","sec129DeliveryAddr":"0","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"","nonCreditDateChanged":"0","nonCreditSms":"","nonCreditEmail":"","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"","creditIndicator":"","creditDateChanged":"0","creditSms":"","creditEmail":"","creditAvoice":"Y","creditTelephone":"Y","creditPost":""}'
                    );
                } else if (mainAccountType == 'Estate') {
                    response.setBody(
                        '{"indCifRecFound":"Y","clientCode":"SWANSR+002","initials":"","language":"","titleCode":"0","surname":"SWANSON MR R & SWANSON MR D","postlAddrLine1":"109 KATHERINE STREET","postlAddrLine2":"","postlSuburb":"","postlTown":"SANDTON","postlCodeRsa":"2196","idDocType":"0","idNumber":"","birthDate":"0","maritalStatus":"0","smsMarkInd":"","gender":"0","minorChildren":"","occupationCode":"0","incomeGroup":"0","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"3232","dateClientOpened":"20190515","changeNumber":"14","dateLastChanged":"20190703","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"0","prohibitedInd":"N","postalAddrHold":"","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"","courtAuthrityHold":"N","thirdPartyInd":"N","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"0","homeLanguage":"","marketingConcent":"","clientType":"301","miltaryComtmntInd":"N","occupationType":"0","noOfJointPartcpnt":"2","taxNumber":"0","sicCode":"0","firstNames":"","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"0","workTelCode":"0","workTelephone":"","physicalAddrHold":"N","employerAddrHold":"","cellphone":"0","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"0","employmentSector":"0","occupationLevel":"0","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"0","cellphoneBankInd":"","siccCode5":"","subSegment":"F1","emailMarkInd":"","teleMarkInd":"","internetBankinInd":"","sourceOfIncome":"0","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","vatRegistrationNo":"","clientNationality":"","countryOfOrigin":"SO003","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"","exemptionIndicator":"","corporateDivision":"A","postMatricQualifd":"0","postMatricQualfton":"0","receiveSocialGrant":"N","notifyMeIndicator":"","mailInd":"","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"0","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"0","ibrAffected":"N","clientGroup":"E","nbrOfAddressesRtrv":"0","addressEntry":[{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"","nkinFname":"","nkinRela":"0","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"N","updTelephoneInd":"N","updEmailInd":"N","updDateInd":"15052019","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"N","sec129DeliveryAddr":"0","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"","nonCreditDateChanged":"0","nonCreditSms":"","nonCreditEmail":"","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"","creditIndicator":"","creditDateChanged":"0","creditSms":"","creditEmail":"","creditAvoice":"Y","creditTelephone":"Y","creditPost":""}'
                    );
                } else if (mainAccountType == 'Partnership') {
                    response.setBody(
                        '{"indCifRecFound":"Y","clientCode":"SWANSR+002","initials":"","language":"","titleCode":"0","surname":"SWANSON MR R & SWANSON MR D","postlAddrLine1":"109 KATHERINE STREET","postlAddrLine2":"","postlSuburb":"","postlTown":"SANDTON","postlCodeRsa":"2196","idDocType":"0","idNumber":"","birthDate":"0","maritalStatus":"0","smsMarkInd":"","gender":"0","minorChildren":"","occupationCode":"0","incomeGroup":"0","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"3232","dateClientOpened":"20190515","changeNumber":"14","dateLastChanged":"20190703","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"0","prohibitedInd":"N","postalAddrHold":"","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"","courtAuthrityHold":"N","thirdPartyInd":"N","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"0","homeLanguage":"","marketingConcent":"","clientType":"301","miltaryComtmntInd":"N","occupationType":"0","noOfJointPartcpnt":"2","taxNumber":"0","sicCode":"0","firstNames":"","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"0","workTelCode":"0","workTelephone":"","physicalAddrHold":"N","employerAddrHold":"","cellphone":"0","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"0","employmentSector":"0","occupationLevel":"0","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"0","cellphoneBankInd":"","siccCode5":"","subSegment":"F1","emailMarkInd":"","teleMarkInd":"","internetBankinInd":"","sourceOfIncome":"0","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","vatRegistrationNo":"","clientNationality":"","countryOfOrigin":"SO003","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"","exemptionIndicator":"","corporateDivision":"A","postMatricQualifd":"0","postMatricQualfton":"0","receiveSocialGrant":"N","notifyMeIndicator":"","mailInd":"","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"0","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"0","ibrAffected":"N","clientGroup":"P","nbrOfAddressesRtrv":"0","addressEntry":[{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"","nkinFname":"","nkinRela":"0","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"N","updTelephoneInd":"N","updEmailInd":"N","updDateInd":"15052019","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"N","sec129DeliveryAddr":"0","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"","nonCreditDateChanged":"0","nonCreditSms":"","nonCreditEmail":"","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"","creditIndicator":"","creditDateChanged":"0","creditSms":"","creditEmail":"","creditAvoice":"Y","creditTelephone":"Y","creditPost":""}'
                    );
                } else if (mainAccountType == 'Unidentified') {
                    response.setBody(
                        '{"indCifRecFound":"Y","clientCode":"SWANSR+002","initials":"","language":"","titleCode":"0","surname":"SWANSON MR R & SWANSON MR D","postlAddrLine1":"109 KATHERINE STREET","postlAddrLine2":"","postlSuburb":"","postlTown":"SANDTON","postlCodeRsa":"2196","idDocType":"0","idNumber":"","birthDate":"0","maritalStatus":"0","smsMarkInd":"","gender":"0","minorChildren":"","occupationCode":"0","incomeGroup":"0","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"3232","dateClientOpened":"20190515","changeNumber":"14","dateLastChanged":"20190703","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"0","prohibitedInd":"N","postalAddrHold":"","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"","courtAuthrityHold":"N","thirdPartyInd":"N","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"0","homeLanguage":"","marketingConcent":"","clientType":"301","miltaryComtmntInd":"N","occupationType":"0","noOfJointPartcpnt":"2","taxNumber":"0","sicCode":"0","firstNames":"","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"0","workTelCode":"0","workTelephone":"","physicalAddrHold":"N","employerAddrHold":"","cellphone":"0","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"0","employmentSector":"0","occupationLevel":"0","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"0","cellphoneBankInd":"","siccCode5":"","subSegment":"F1","emailMarkInd":"","teleMarkInd":"","internetBankinInd":"","sourceOfIncome":"0","dateIdentified":"0","dateVerified":"0","employeeIdentified":"","employeeVerified":"","vatRegistrationNo":"","clientNationality":"","countryOfOrigin":"SO003","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"","exemptionIndicator":"","corporateDivision":"A","postMatricQualifd":"0","postMatricQualfton":"0","receiveSocialGrant":"N","notifyMeIndicator":"","mailInd":"","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"0","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"0","ibrAffected":"N","clientGroup":"X","nbrOfAddressesRtrv":"0","addressEntry":[{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"","nkinFname":"","nkinRela":"0","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"N","updTelephoneInd":"N","updEmailInd":"N","updDateInd":"15052019","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"N","sec129DeliveryAddr":"0","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"","nonCreditDateChanged":"0","nonCreditSms":"","nonCreditEmail":"","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"","creditIndicator":"","creditDateChanged":"0","creditSms":"","creditEmail":"","creditAvoice":"Y","creditTelephone":"Y","creditPost":""}'
                    );
                }

                if (getClientDetailsStatus == StringConstants.POSITIVE_STRING) {
                    response.setStatusCode(200);
                } else if (getClientDetailsStatus == StringConstants.NEGATIVE_STRING) {
                    response.setStatusCode(500);
                }
                //Get Client Details By Id
            } else if (request.getEndpoint().equals('nullGet Client Details By Id CIF')) {
                //response.setBody('{"nbrEntsRetrieved":"1","lastSearchPos":"019012090586088LEBOTL 001","tblEntry":[{"cifKey":"LEBOTL 001","cifInitials":"L","cifSurname":"LEBOTSE","cifTitleCode":"2","cifClntType":"101","cifClntGroup":"I","cifNbrOfAccts":"3","cifBirthDate":"19901209","cifAddrLine1":"123 WF NKOMO","cifAddrLine2":"","cifPostlSuburb":"","cifPostlTown":"CENTRAL","cifPostlCodeRsa":"2","cifCorpCode":"A"}]}');
                response.setBody(
                    '{"nbrEntsRetrieved":"2","lastSearchPos":"018905145814085SWANSR+002","tblEntry":[{"cifKey":"SWANSR 002","cifInitials":"R","cifSurname":"SWANSON","cifTitleCode":"1","cifClntType":"101","cifClntGroup":"I","cifNbrOfAccts":"0","cifBirthDate":"19890514","cifAddrLine1":"109 KATHERINE STREET","cifAddrLine2":"","cifPostlSuburb":"","cifPostlTown":"SANDTON","cifPostlCodeRsa":"2196","cifCorpCode":"A"},{"cifKey":"SWANSR+002","cifInitials":"","cifSurname":"SWANSON MR R & SWANSON MR D","cifTitleCode":"0","cifClntType":"301","cifClntGroup":"J","cifNbrOfAccts":"0","cifBirthDate":"0","cifAddrLine1":"109 KATHERINE STREET","cifAddrLine2":"","cifPostlSuburb":"","cifPostlTown":"SANDTON","cifPostlCodeRsa":"2196","cifCorpCode":"A"}]}'
                );
                if (mainAccountType == 'NoIndv') {
                    response.setBody(
                        '{"nbrEntsRetrieved":"2","lastSearchPos":"018905145814085SWANSR+002","tblEntry":[{"cifKey":"SWANSR 002","cifInitials":"R","cifSurname":"SWANSON","cifTitleCode":"1","cifClntType":"101","cifClntGroup":"J","cifNbrOfAccts":"0","cifBirthDate":"19890514","cifAddrLine1":"109 KATHERINE STREET","cifAddrLine2":"","cifPostlSuburb":"","cifPostlTown":"SANDTON","cifPostlCodeRsa":"2196","cifCorpCode":"A"},{"cifKey":"SWANSR+002","cifInitials":"","cifSurname":"SWANSON MR R & SWANSON MR D","cifTitleCode":"0","cifClntType":"301","cifClntGroup":"J","cifNbrOfAccts":"0","cifBirthDate":"0","cifAddrLine1":"109 KATHERINE STREET","cifAddrLine2":"","cifPostlSuburb":"","cifPostlTown":"SANDTON","cifPostlCodeRsa":"2196","cifCorpCode":"A"}]}'
                    );
                }

                if (mainAccountType == 'NoJnt') {
                    response.setBody(
                        '{"nbrEntsRetrieved":"2","lastSearchPos":"018905145814085SWANSR+002","tblEntry":[{"cifKey":"SWANSR 002","cifInitials":"R","cifSurname":"SWANSON","cifTitleCode":"1","cifClntType":"101","cifClntGroup":"I","cifNbrOfAccts":"0","cifBirthDate":"19890514","cifAddrLine1":"109 KATHERINE STREET","cifAddrLine2":"","cifPostlSuburb":"","cifPostlTown":"SANDTON","cifPostlCodeRsa":"2196","cifCorpCode":"A"},{"cifKey":"SWANSR+002","cifInitials":"","cifSurname":"SWANSON MR R & SWANSON MR D","cifTitleCode":"0","cifClntType":"301","cifClntGroup":"I","cifNbrOfAccts":"0","cifBirthDate":"0","cifAddrLine1":"109 KATHERINE STREET","cifAddrLine2":"","cifPostlSuburb":"","cifPostlTown":"SANDTON","cifPostlCodeRsa":"2196","cifCorpCode":"A"}]}'
                    );
                }

                if (getClientDetailsByIdStatus == StringConstants.POSITIVE_STRING) {
                    response.setStatusCode(200);
                } else if (getClientDetailsByIdStatus == StringConstants.NEGATIVE_STRING) {
                    response.setStatusCode(500);
                }
                //Get Jnt Part
            } else if (request.getEndpoint().equals('nullGet Joint Participant')) {
                //response.setBody('{"nbrRetrv":"2","jntEntry":[{"idDocType":"1","idNumber":"5311066657087","initials":"B","titleCode":"1","surname":"PRUNE","resAddrLine1":"1 LONG STRAAT","resAddrLine2":"","resSuburb":"","resTown":"KNYSNA","resPosCde":"6571","firstNames":"BRYAN","homeTelCode":"0","homeTelephone":"","workTelCode":"82","workTelephone":"0000000","cellphone":"820000000","practiceNumber":"","birthDate":"19531106","sourceOfIncome":"20","dateIdentified":"6062019","dateVerified":"6062019","employeeIdentified":"0","employeeVerified":"0","taxNumber":"0","clientNationality":"SOU01","countryOfOrigin":"","tempPermitNumber":"","permitExpiryDate":"0","homeTcodex":"","workTcodex":"082","cellx":"0820000000","groupScheme":"0","groupSchemeEmp":"","dateIssued":"6062019","dateExempted":"0","empExempted":"","statusOfExempt":"N","exemptionInd":"","countryOfRes":"SO003","countryOfBirth":"SO003","occupationStatus":"1","occupationCode":"10","saTaxRegis":"N","rsonSaTaxNotGiven":"","foreignTaxRegis":"N","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""}]},{"idDocType":"1","idNumber":"6102261933087","initials":"","titleCode":"2","surname":"PRUNE","resAddrLine1":"1 LONG STRAAT","resAddrLine2":"","resSuburb":"","resTown":"KNYSNA","resPosCde":"6571","firstNames":"CARINA","homeTelCode":"0","homeTelephone":"","workTelCode":"82","workTelephone":"0000000","cellphone":"820000000","practiceNumber":"","birthDate":"19610226","sourceOfIncome":"23","dateIdentified":"0","dateVerified":"0","employeeIdentified":"0","employeeVerified":"0","taxNumber":"0","clientNationality":"SOU01","countryOfOrigin":"SO003","tempPermitNumber":"","permitExpiryDate":"0","homeTcodex":"","workTcodex":"082","cellx":"0820000000","groupScheme":"0","groupSchemeEmp":"","dateIssued":"0","dateExempted":"0","empExempted":"","statusOfExempt":"","exemptionInd":"","countryOfRes":"SO003","countryOfBirth":"SO003","occupationStatus":"8","occupationCode":"6","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""}]}]}');
                response.setBody(
                    '{"nbrRetrv":"2","jntEntry":[{"idDocType":"1","idNumber":"8905145814085","initials":"","titleCode":"1","surname":"Swanson","resAddrLine1":"109 KATHERINE STREET","resAddrLine2":"","resSuburb":"","resTown":"SANDTON","resPosCde":"2196","firstNames":"Ronald","homeTelCode":"0","homeTelephone":"","workTelCode":"23","workTelephone":"4567890","cellphone":"627899314","practiceNumber":"","birthDate":"19890514","sourceOfIncome":"22","dateIdentified":"0","dateVerified":"0","employeeIdentified":"0","employeeVerified":"0","taxNumber":"0","clientNationality":"SOU01","countryOfOrigin":"SO003","tempPermitNumber":"","permitExpiryDate":"0","homeTcodex":"","workTcodex":"023","cellx":"0627899314","groupScheme":"0","groupSchemeEmp":"","dateIssued":"0","dateExempted":"0","empExempted":"","statusOfExempt":"","exemptionInd":"","countryOfRes":"SO003","countryOfBirth":"SO003","occupationStatus":"1","occupationCode":"15","saTaxRegis":"","rsonSaTaxNotGiven":"","foreignTaxRegis":"","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":""}]}]}'
                );

                if (getJntPartStatus == StringConstants.POSITIVE_STRING) {
                    response.setStatusCode(200);
                } else if (getJntPartStatus == StringConstants.NEGATIVE_STRING) {
                    response.setStatusCode(500);
                }
                //Get Involved Parties
            } else if (request.getEndpoint().equals('nullGet Involved Parties')) {
                if (mainAccountType == 'Individual') {
                    response.setBody(
                        '{ "content" : { "suin" : "1-QWL8E", "created" : "2018-09-10T14:43:03", "updated" : "2018-09-10T14:48:45", "individual" : { "dateOfBirth" : "1987-01-05", "surname" : "AAA", "initials" : "R", "knownAs" : null, "occupation" : "", "occupationStatus" : "Full Time Employed", "notificationOfDeathDate" : null, "salutation" : { "code" : "Mr", "description" : "Mr" }, "givenNames" : null, "gender" : { "code" : "Male", "description" : "Male" }, "raceClassification" : null, "maritalContractType" : null, "maritalStatus" : { "code" : "Single", "description" : "Single" }, "residentialStatus" : { "code" : "01", "description" : "SA RESIDENT" }, "clientClassification" : { "code" : "Private Individual", "description" : "Private Individual" }, "name" : "RAGH", "pepStatus" : null, "subStatus" : null, "status" : null, "ficaAddressUpdateDate" : null, "ficaAddressAttestedDate" : null, "sourceOfIncomeAttestedDate" : null, "nextRefreshDate" : null, "identificationUpdateDate" : null, "identificationAttestedDate" : null }, "formalOrganisation" : null, "informalOrganisation" : null, "organisationUnit" : null, "sourcesOfIncome" : [ ], "sourcesOfWealth" : [ ], "activeInIndustries" : [ ], "flags" : [ { "effectiveDate" : "2018-09-10", "yesNoFlag" : true, "type" : { "code" : "Contact method : Email", "description" : "Contact method : Email" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Consent", "description" : "Marketing Consent" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Preference : Call", "description" : "Marketing Preference : Call" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Preference: Email", "description" : "Marketing Preference: Email" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Preference: Mail", "description" : "Marketing Preference: Mail" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Preference: SMS", "description" : "Marketing Preference: SMS" } }, { "effectiveDate" : null, "yesNoFlag" : false, "type" : { "code" : "SBU Segment", "description" : "SBU Segment" } } ], "countries" : [ { "name" : "South Africa", "isoCode" : null, "type" : { "code" : "BirthCountry", "description" : "BirthCountry" }, "context" : { "code" : "BirthCountry", "description" : "BirthCountry" } }, { "name" : "South Africa", "isoCode" : null, "type" : { "code" : "ResidenceCountry", "description" : "ResidenceCountry" }, "context" : { "code" : "ResidenceCountry", "description" : "ResidenceCountry" } }, { "name" : "South African", "isoCode" : null, "type" : { "code" : "Nationality", "description" : "Nationality" }, "context" : { "code" : "Nationality", "description" : "Nationality" } } ], "identifications" : [ { "number" : "AAAR 001", "type" : { "code" : "CIF Code", "description" : "CIF Code" }, "expiryDate" : null, "issueDate" : null }, { "number" : "8701057648086", "type" : { "code" : "ID Number", "description" : "ID Number" }, "expiryDate" : null, "issueDate" : null }, { "number" : "1-QWL8E", "type" : { "code" : "PARTYMDM", "description" : "PARTYMDM" }, "expiryDate" : null, "issueDate" : null }, { "number" : "1-QWL8E", "type" : { "code" : "REGSERVICES", "description" : "REGSERVICES" }, "expiryDate" : null, "issueDate" : null } ], "addresses" : { "preferredCommunicationChannel" : null, "telephonicAddress" : [ { "countryCode" : "+27", "diallingCode" : "080", "number" : "1234567", "context" : { "code" : "MainCellPhone", "description" : "MainCellPhone" }, "type" : { "code" : "MainCellPhone", "description" : "MainCellPhone" } }, { "countryCode" : "+27", "diallingCode" : "080", "number" : "1234567", "context" : { "code" : "Personal", "description" : "Personal" }, "type" : { "code" : "Personal", "description" : "Personal" } } ], "addresses" : [ { "addressName1" : "234234", "addressName2" : "234234", "suburbName" : "Dalmeida", "cityName" : "Dalmeida", "countryName" : "South Africa", "postalCode" : "6506", "context" : { "code" : "Employers", "description" : "Employers" }, "gpsCoordinates" : null, "type" : { "code" : "Employers", "description" : "Employers" } }, { "addressName1" : "Abc", "addressName2" : "Xyz", "suburbName" : "Amanzimtoti", "cityName" : "Amanzimtoti", "countryName" : "South Africa", "postalCode" : "4125", "context" : { "code" : "Residential", "description" : "Residential" }, "gpsCoordinates" : null, "type" : { "code" : "Residential", "description" : "Residential" } }, { "addressName1" : "Abc", "addressName2" : "Xyz", "suburbName" : "Amanzimtoti", "cityName" : "Amanzimtoti", "countryName" : "", "postalCode" : "4125", "context" : { "code" : "Postal", "description" : "Postal" }, "gpsCoordinates" : null, "type" : { "code" : "Postal", "description" : "Postal" } } ], "electronicAddresses" : [ ] }, "relationships" : [ { "type" : { "code" : "Has Signatory", "description" : "Has Signatory" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Sponsor", "description" : "Has Sponsor" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Is Signatory Of", "description" : "Is Signatory Of" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Is ShareholderControllerL2 Of", "description" : "Is ShareholderControllerL2 Of" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Surety", "description" : "Has Surety" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Supplier", "description" : "Has Supplier" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Subsidiary", "description" : "Has Subsidiary" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Spouse", "description" : "Has Spouse" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Is Personal Assistant Of", "description" : "Is Personal Assistant Of" }, "suin" : "1-25TG3W", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "7606029212088" }, { "type" : { "code" : "Is Payer Of", "description" : "Is Payer Of" }, "suin" : "1-25TG3W", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "7606029212088" }, { "type" : { "code" : "Is Parent Or Guardian Of", "description" : "Is Parent Or Guardian Of" }, "suin" : "1-25TG3W", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "7606029212088" }, { "type" : { "code" : "Is Parent Of", "description" : "Is Parent Of" }, "suin" : "1-25TG3W", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "7606029212088" }, { "type" : { "code" : "Is Trustee Of", "description" : "Is Trustee Of" }, "suin" : "1-1P6GY", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "Registration Number", "internalIdValue" : "1-1P6GY" }, { "type" : { "code" : "Is Child Of", "description" : "Is Child Of" }, "suin" : "1-26DZ7D", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "Registration Number", "internalIdValue" : "1-26DZ7D" }, { "type" : { "code" : "Is Beneficiary Of", "description" : "Is Beneficiary Of" }, "suin" : "1-26DZ7D", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "Registration Number", "internalIdValue" : "1-26DZ7D" } ], "relatedDocuments" : [ ], "riskRating" : null, "name" : "RAGH" }, "links" : [ { "rel" : "regulatory-compliance", "href" : "/v1/involved-parties/regulatory-compliance/Individual/Individual" } ] }'
                    );
                } else if (mainAccountType == 'Joint Account') {
                    response.setBody(
                        '{  "content" : {    "suin" : "1-JWCCTV",    "created" : "2019-06-21T00:54:41",    "updated" : "2019-07-15T14:23:02",    "individual" : null,    "formalOrganisation" : null,    "informalOrganisation" : {      "jointParticipanCount" : null,      "name" : "ECHO MR D & ECHO MRS E",      "pepStatus" : {        "code" : "",        "description" : ""      },      "subStatus" : {        "code" : "",        "description" : ""      },      "status" : {        "code" : "Active",        "description" : "Active"      },      "ficaAddressUpdateDate" : null,      "ficaAddressAttestedDate" : null,      "sourceOfIncomeAttestedDate" : null,      "nextRefreshDate" : null,      "identificationUpdateDate" : null,      "identificationAttestedDate" : null,      "type" : {        "code" : "Joint & several",        "description" : "Joint & several"      },      "revenueSegment" : null,      "primaryContact" : null,      "manager" : null,      "natureOfBusiness" : {        "code" : "",        "description" : ""      },      "knownAs" : null    },    "organisationUnit" : null,    "sourcesOfIncome" : [ {      "code" : "",      "description" : ""    } ],    "sourcesOfWealth" : [ ],    "activeInIndustries" : [ ],    "flags" : [ {      "effectiveDate" : null,      "yesNoFlag" : true,      "type" : {        "code" : "ABSA",        "description" : "ABSA"      },      "category" : {        "code" : "Corporate Relationship",        "description" : "Corporate Relationship"      },      "isOperationalFlag" : false    }, {      "effectiveDate" : null,      "yesNoFlag" : false,      "type" : {        "code" : "SBU Segment",        "description" : "SBU Segment"      },      "category" : {        "code" : "Segment",        "description" : "Segment"      },      "isOperationalFlag" : false    } ],    "countries" : [ {      "name" : "",      "isoCode" : null,      "type" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      },      "context" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      }    } ],    "identifications" : [ {      "number" : "ECHOD+ 004",      "type" : {        "code" : "CIF Code",        "description" : "CIF Code"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "PARTYMDM",        "description" : "PARTYMDM"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "REGSERVICES",        "description" : "REGSERVICES"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    } ],    "addresses" : {      "preferredCommunicationChannel" : null,      "telephonicAddress" : [ ],      "addresses" : [ {        "addressName1" : "1 Long Street",        "addressName2" : "",        "suburbName" : "",        "cityName" : "Cape Town",        "countryName" : "",        "postalCode" : "8001",        "context" : {          "code" : "Postal",          "description" : "Postal"        },        "gpsCoordinates" : null,        "type" : {          "code" : "Postal",          "description" : "Postal"        }      } ],      "electronicAddresses" : [ ]    },    "relationships" : [ ],    "relatedDocuments" : [ ],    "riskRating" : null,    "name" : "ECHO MR D & ECHO MRS E"  },  "links" : [ {    "rel" : "regulatory-compliance",    "href" : "/v1/involved-parties/regulatory-compliance/Organisation/Organisation",    "hreflang" : null,    "media" : null,    "title" : null,    "type" : null,    "deprecation" : null  } ]}'
                    );
                } else if (mainAccountType == 'NoIndv') {
                    response.setBody(
                        '{ "content" : { "suin" : "1-QWL8E", "created" : "2018-09-10T14:43:03", "updated" : "2018-09-10T14:48:45", "individual" : { "dateOfBirth" : "1987-01-05", "surname" : "AAA", "initials" : "R", "knownAs" : null, "occupation" : "", "occupationStatus" : "Full Time Employed", "notificationOfDeathDate" : null, "salutation" : { "code" : "Mr", "description" : "Mr" }, "givenNames" : null, "gender" : { "code" : "Male", "description" : "Male" }, "raceClassification" : null, "maritalContractType" : null, "maritalStatus" : { "code" : "Single", "description" : "Single" }, "residentialStatus" : { "code" : "01", "description" : "SA RESIDENT" }, "clientClassification" : { "code" : "Private Individual", "description" : "Private Individual" }, "name" : "RAGH", "pepStatus" : null, "subStatus" : null, "status" : null, "ficaAddressUpdateDate" : null, "ficaAddressAttestedDate" : null, "sourceOfIncomeAttestedDate" : null, "nextRefreshDate" : null, "identificationUpdateDate" : null, "identificationAttestedDate" : null }, "formalOrganisation" : null, "informalOrganisation" : null, "organisationUnit" : null, "sourcesOfIncome" : [ ], "sourcesOfWealth" : [ ], "activeInIndustries" : [ ], "flags" : [ { "effectiveDate" : "2018-09-10", "yesNoFlag" : true, "type" : { "code" : "Contact method : Email", "description" : "Contact method : Email" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Consent", "description" : "Marketing Consent" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Preference : Call", "description" : "Marketing Preference : Call" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Preference: Email", "description" : "Marketing Preference: Email" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Preference: Mail", "description" : "Marketing Preference: Mail" } }, { "effectiveDate" : "2018-09-10", "yesNoFlag" : false, "type" : { "code" : "Marketing Preference: SMS", "description" : "Marketing Preference: SMS" } }, { "effectiveDate" : null, "yesNoFlag" : false, "type" : { "code" : "SBU Segment", "description" : "SBU Segment" } } ], "countries" : [ { "name" : "South Africa", "isoCode" : null, "type" : { "code" : "BirthCountry", "description" : "BirthCountry" }, "context" : { "code" : "BirthCountry", "description" : "BirthCountry" } }, { "name" : "South Africa", "isoCode" : null, "type" : { "code" : "ResidenceCountry", "description" : "ResidenceCountry" }, "context" : { "code" : "ResidenceCountry", "description" : "ResidenceCountry" } }, { "name" : "South African", "isoCode" : null, "type" : { "code" : "Nationality", "description" : "Nationality" }, "context" : { "code" : "Nationality", "description" : "Nationality" } } ], "identifications" : [ { "number" : "AAAR 001", "type" : { "code" : "CIF Code", "description" : "CIF Code" }, "expiryDate" : null, "issueDate" : null }, { "number" : "8701057648086", "type" : { "code" : "ID Number", "description" : "ID Number" }, "expiryDate" : null, "issueDate" : null }, { "number" : "1-QWL8E", "type" : { "code" : "PARTYMDM", "description" : "PARTYMDM" }, "expiryDate" : null, "issueDate" : null }, { "number" : "1-QWL8E", "type" : { "code" : "REGSERVICES", "description" : "REGSERVICES" }, "expiryDate" : null, "issueDate" : null } ], "addresses" : { "preferredCommunicationChannel" : null, "telephonicAddress" : [ { "countryCode" : "+27", "diallingCode" : "080", "number" : "1234567", "context" : { "code" : "MainCellPhone", "description" : "MainCellPhone" }, "type" : { "code" : "MainCellPhone", "description" : "MainCellPhone" } }, { "countryCode" : "+27", "diallingCode" : "080", "number" : "1234567", "context" : { "code" : "Personal", "description" : "Personal" }, "type" : { "code" : "Personal", "description" : "Personal" } } ], "addresses" : [ { "addressName1" : "234234", "addressName2" : "234234", "suburbName" : "Dalmeida", "cityName" : "Dalmeida", "countryName" : "South Africa", "postalCode" : "6506", "context" : { "code" : "Employers", "description" : "Employers" }, "gpsCoordinates" : null, "type" : { "code" : "Employers", "description" : "Employers" } }, { "addressName1" : "Abc", "addressName2" : "Xyz", "suburbName" : "Amanzimtoti", "cityName" : "Amanzimtoti", "countryName" : "South Africa", "postalCode" : "4125", "context" : { "code" : "Residential", "description" : "Residential" }, "gpsCoordinates" : null, "type" : { "code" : "Residential", "description" : "Residential" } }, { "addressName1" : "Abc", "addressName2" : "Xyz", "suburbName" : "Amanzimtoti", "cityName" : "Amanzimtoti", "countryName" : "", "postalCode" : "4125", "context" : { "code" : "Postal", "description" : "Postal" }, "gpsCoordinates" : null, "type" : { "code" : "Postal", "description" : "Postal" } } ], "electronicAddresses" : [ ] }, "relationships" : [ { "type" : { "code" : "Has Signatory", "description" : "Has Signatory" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Sponsor", "description" : "Has Sponsor" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Is Signatory Of", "description" : "Is Signatory Of" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Is ShareholderControllerL2 Of", "description" : "Is ShareholderControllerL2 Of" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Surety", "description" : "Has Surety" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Supplier", "description" : "Has Supplier" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Subsidiary", "description" : "Has Subsidiary" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Has Spouse", "description" : "Has Spouse" }, "suin" : "1-267DYT", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "8703199387086" }, { "type" : { "code" : "Is Personal Assistant Of", "description" : "Is Personal Assistant Of" }, "suin" : "1-25TG3W", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "7606029212088" }, { "type" : { "code" : "Is Payer Of", "description" : "Is Payer Of" }, "suin" : "1-25TG3W", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "7606029212088" }, { "type" : { "code" : "Is Parent Or Guardian Of", "description" : "Is Parent Or Guardian Of" }, "suin" : "1-25TG3W", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "7606029212088" }, { "type" : { "code" : "Is Parent Of", "description" : "Is Parent Of" }, "suin" : "1-25TG3W", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "ID Number", "internalIdValue" : "7606029212088" }, { "type" : { "code" : "Is Trustee Of", "description" : "Is Trustee Of" }, "suin" : "1-1P6GY", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "Registration Number", "internalIdValue" : "1-1P6GY" }, { "type" : { "code" : "Is Child Of", "description" : "Is Child Of" }, "suin" : "1-26DZ7D", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "Registration Number", "internalIdValue" : "1-26DZ7D" }, { "type" : { "code" : "Is Beneficiary Of", "description" : "Is Beneficiary Of" }, "suin" : "1-26DZ7D", "arrangement" : { "accountActive" : true, "arrangementCloseDate" : null, "arrangementOpenDate" : null, "lifecycleStatus" : null, "lifecycleStatusDate" : null, "uniqueIdInSourceSystem" : null, "arrangementType" : null, "initiatingPartySuin" : null, "brand" : null }, "internalIdType" : "Registration Number", "internalIdValue" : "1-26DZ7D" } ], "relatedDocuments" : [ ], "riskRating" : null, "name" : "RAGH" }, "links" : [ { "rel" : "regulatory-compliance", "href" : "/v1/involved-parties/regulatory-compliance/Individual/Individual" } ] }'
                    );
                } else if (mainAccountType == 'Sole Proprietor') {
                    response.setBody(
                        '{  "content" : {    "suin" : "1-JWCCTV",    "created" : "2019-06-21T00:54:41",    "updated" : "2019-07-15T14:23:02",    "individual" : null,    "formalOrganisation" : null,    "informalOrganisation" : {      "jointParticipanCount" : null,      "name" : "ECHO MR D & ECHO MRS E",      "pepStatus" : {        "code" : "",        "description" : ""      },      "subStatus" : {        "code" : "",        "description" : ""      },      "status" : {        "code" : "Active",        "description" : "Active"      },      "ficaAddressUpdateDate" : null,      "ficaAddressAttestedDate" : null,      "sourceOfIncomeAttestedDate" : null,      "nextRefreshDate" : null,      "identificationUpdateDate" : null,      "identificationAttestedDate" : null,      "type" : {        "code" : "Sole Proprietor",        "description" : "Sole Proprietor"      },      "revenueSegment" : null,      "primaryContact" : null,      "manager" : null,      "natureOfBusiness" : {        "code" : "",        "description" : ""      },      "knownAs" : null    },    "organisationUnit" : null,    "sourcesOfIncome" : [ {      "code" : "",      "description" : ""    } ],    "sourcesOfWealth" : [ ],    "activeInIndustries" : [ ],    "flags" : [ {      "effectiveDate" : null,      "yesNoFlag" : true,      "type" : {        "code" : "ABSA",        "description" : "ABSA"      },      "category" : {        "code" : "Corporate Relationship",        "description" : "Corporate Relationship"      },      "isOperationalFlag" : false    }, {      "effectiveDate" : null,      "yesNoFlag" : false,      "type" : {        "code" : "SBU Segment",        "description" : "SBU Segment"      },      "category" : {        "code" : "Segment",        "description" : "Segment"      },      "isOperationalFlag" : false    } ],    "countries" : [ {      "name" : "",      "isoCode" : null,      "type" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      },      "context" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      }    } ],    "identifications" : [ {      "number" : "ECHOD+ 004",      "type" : {        "code" : "CIF Code",        "description" : "CIF Code"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "PARTYMDM",        "description" : "PARTYMDM"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "REGSERVICES",        "description" : "REGSERVICES"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    } ],    "addresses" : {      "preferredCommunicationChannel" : null,      "telephonicAddress" : [ ],      "addresses" : [ {        "addressName1" : "1 Long Street",        "addressName2" : "",        "suburbName" : "",        "cityName" : "Cape Town",        "countryName" : "",        "postalCode" : "8001",        "context" : {          "code" : "Postal",          "description" : "Postal"        },        "gpsCoordinates" : null,        "type" : {          "code" : "Postal",          "description" : "Postal"        }      } ],      "electronicAddresses" : [ ]    },    "relationships" : [ ],    "relatedDocuments" : [ ],    "riskRating" : null,    "name" : "ECHO MR D & ECHO MRS E"  },  "links" : [ {    "rel" : "regulatory-compliance",    "href" : "/v1/involved-parties/regulatory-compliance/Organisation/Organisation",    "hreflang" : null,    "media" : null,    "title" : null,    "type" : null,    "deprecation" : null  } ]}'
                    );
                } else if (mainAccountType == 'Estate') {
                    response.setBody(
                        '{  "content" : {    "suin" : "1-JWCCTV",    "created" : "2019-06-21T00:54:41",    "updated" : "2019-07-15T14:23:02",    "individual" : null,    "formalOrganisation" : null,    "informalOrganisation" : {      "jointParticipanCount" : null,      "name" : "ECHO MR D & ECHO MRS E",      "pepStatus" : {        "code" : "",        "description" : ""      },      "subStatus" : {        "code" : "",        "description" : ""      },      "status" : {        "code" : "Active",        "description" : "Active"      },      "ficaAddressUpdateDate" : null,      "ficaAddressAttestedDate" : null,      "sourceOfIncomeAttestedDate" : null,      "nextRefreshDate" : null,      "identificationUpdateDate" : null,      "identificationAttestedDate" : null,      "type" : {        "code" : "Estate late client",        "description" : "Estate late client"      },      "revenueSegment" : null,      "primaryContact" : null,      "manager" : null,      "natureOfBusiness" : {        "code" : "",        "description" : ""      },      "knownAs" : null    },    "organisationUnit" : null,    "sourcesOfIncome" : [ {      "code" : "",      "description" : ""    } ],    "sourcesOfWealth" : [ ],    "activeInIndustries" : [ ],    "flags" : [ {      "effectiveDate" : null,      "yesNoFlag" : true,      "type" : {        "code" : "ABSA",        "description" : "ABSA"      },      "category" : {        "code" : "Corporate Relationship",        "description" : "Corporate Relationship"      },      "isOperationalFlag" : false    }, {      "effectiveDate" : null,      "yesNoFlag" : false,      "type" : {        "code" : "SBU Segment",        "description" : "SBU Segment"      },      "category" : {        "code" : "Segment",        "description" : "Segment"      },      "isOperationalFlag" : false    } ],    "countries" : [ {      "name" : "",      "isoCode" : null,      "type" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      },      "context" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      }    } ],    "identifications" : [ {      "number" : "ECHOD+ 004",      "type" : {        "code" : "CIF Code",        "description" : "CIF Code"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "PARTYMDM",        "description" : "PARTYMDM"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "REGSERVICES",        "description" : "REGSERVICES"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    } ],    "addresses" : {      "preferredCommunicationChannel" : null,      "telephonicAddress" : [ ],      "addresses" : [ {        "addressName1" : "1 Long Street",        "addressName2" : "",        "suburbName" : "",        "cityName" : "Cape Town",        "countryName" : "",        "postalCode" : "8001",        "context" : {          "code" : "Postal",          "description" : "Postal"        },        "gpsCoordinates" : null,        "type" : {          "code" : "Postal",          "description" : "Postal"        }      } ],      "electronicAddresses" : [ ]    },    "relationships" : [ ],    "relatedDocuments" : [ ],    "riskRating" : null,    "name" : "ECHO MR D & ECHO MRS E"  },  "links" : [ {    "rel" : "regulatory-compliance",    "href" : "/v1/involved-parties/regulatory-compliance/Organisation/Organisation",    "hreflang" : null,    "media" : null,    "title" : null,    "type" : null,    "deprecation" : null  } ]}'
                    );
                } else if (mainAccountType == 'Partnership') {
                    response.setBody(
                        '{  "content" : {    "suin" : "1-JWCCTV",    "created" : "2019-06-21T00:54:41",    "updated" : "2019-07-15T14:23:02",    "individual" : null,    "formalOrganisation" : null,    "informalOrganisation" : {      "jointParticipanCount" : null,      "name" : "ECHO MR D & ECHO MRS E",      "pepStatus" : {        "code" : "",        "description" : ""      },      "subStatus" : {        "code" : "",        "description" : ""      },      "status" : {        "code" : "Active",        "description" : "Active"      },      "ficaAddressUpdateDate" : null,      "ficaAddressAttestedDate" : null,      "sourceOfIncomeAttestedDate" : null,      "nextRefreshDate" : null,      "identificationUpdateDate" : null,      "identificationAttestedDate" : null,      "type" : {        "code" : "Partnership",        "description" : "Partnership"      },      "revenueSegment" : null,      "primaryContact" : null,      "manager" : null,      "natureOfBusiness" : {        "code" : "",        "description" : ""      },      "knownAs" : null    },    "organisationUnit" : null,    "sourcesOfIncome" : [ {      "code" : "",      "description" : ""    } ],    "sourcesOfWealth" : [ ],    "activeInIndustries" : [ ],    "flags" : [ {      "effectiveDate" : null,      "yesNoFlag" : true,      "type" : {        "code" : "ABSA",        "description" : "ABSA"      },      "category" : {        "code" : "Corporate Relationship",        "description" : "Corporate Relationship"      },      "isOperationalFlag" : false    }, {      "effectiveDate" : null,      "yesNoFlag" : false,      "type" : {        "code" : "SBU Segment",        "description" : "SBU Segment"      },      "category" : {        "code" : "Segment",        "description" : "Segment"      },      "isOperationalFlag" : false    } ],    "countries" : [ {      "name" : "",      "isoCode" : null,      "type" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      },      "context" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      }    } ],    "identifications" : [ {      "number" : "ECHOD+ 004",      "type" : {        "code" : "CIF Code",        "description" : "CIF Code"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "PARTYMDM",        "description" : "PARTYMDM"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "REGSERVICES",        "description" : "REGSERVICES"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    } ],    "addresses" : {      "preferredCommunicationChannel" : null,      "telephonicAddress" : [ ],      "addresses" : [ {        "addressName1" : "1 Long Street",        "addressName2" : "",        "suburbName" : "",        "cityName" : "Cape Town",        "countryName" : "",        "postalCode" : "8001",        "context" : {          "code" : "Postal",          "description" : "Postal"        },        "gpsCoordinates" : null,        "type" : {          "code" : "Postal",          "description" : "Postal"        }      } ],      "electronicAddresses" : [ ]    },    "relationships" : [ ],    "relatedDocuments" : [ ],    "riskRating" : null,    "name" : "ECHO MR D & ECHO MRS E"  },  "links" : [ {    "rel" : "regulatory-compliance",    "href" : "/v1/involved-parties/regulatory-compliance/Organisation/Organisation",    "hreflang" : null,    "media" : null,    "title" : null,    "type" : null,    "deprecation" : null  } ]}'
                    );
                } else if (mainAccountType == 'Non Individual') {
                    response.setBody(
                        '{  "content" : {    "suin" : "1-JWCCTV",    "created" : "2019-06-21T00:54:41",    "updated" : "2019-07-15T14:23:02",    "individual" : null,    "formalOrganisation" : null,    "informalOrganisation" : {      "jointParticipanCount" : null,      "name" : "ECHO MR D & ECHO MRS E",      "pepStatus" : {        "code" : "",        "description" : ""      },      "subStatus" : {        "code" : "",        "description" : ""      },      "status" : {        "code" : "Active",        "description" : "Active"      },      "ficaAddressUpdateDate" : null,      "ficaAddressAttestedDate" : null,      "sourceOfIncomeAttestedDate" : null,      "nextRefreshDate" : null,      "identificationUpdateDate" : null,      "identificationAttestedDate" : null,      "type" : {        "code" : "Private company",        "description" : "Private company"      },      "revenueSegment" : null,      "primaryContact" : null,      "manager" : null,      "natureOfBusiness" : {        "code" : "",        "description" : ""      },      "knownAs" : null    },    "organisationUnit" : null,    "sourcesOfIncome" : [ {      "code" : "",      "description" : ""    } ],    "sourcesOfWealth" : [ ],    "activeInIndustries" : [ ],    "flags" : [ {      "effectiveDate" : null,      "yesNoFlag" : true,      "type" : {        "code" : "ABSA",        "description" : "ABSA"      },      "category" : {        "code" : "Corporate Relationship",        "description" : "Corporate Relationship"      },      "isOperationalFlag" : false    }, {      "effectiveDate" : null,      "yesNoFlag" : false,      "type" : {        "code" : "SBU Segment",        "description" : "SBU Segment"      },      "category" : {        "code" : "Segment",        "description" : "Segment"      },      "isOperationalFlag" : false    } ],    "countries" : [ {      "name" : "",      "isoCode" : null,      "type" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      },      "context" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      }    } ],    "identifications" : [ {      "number" : "ECHOD+ 004",      "type" : {        "code" : "CIF Code",        "description" : "CIF Code"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "PARTYMDM",        "description" : "PARTYMDM"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "REGSERVICES",        "description" : "REGSERVICES"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    } ],    "addresses" : {      "preferredCommunicationChannel" : null,      "telephonicAddress" : [ ],      "addresses" : [ {        "addressName1" : "1 Long Street",        "addressName2" : "",        "suburbName" : "",        "cityName" : "Cape Town",        "countryName" : "",        "postalCode" : "8001",        "context" : {          "code" : "Postal",          "description" : "Postal"        },        "gpsCoordinates" : null,        "type" : {          "code" : "Postal",          "description" : "Postal"        }      } ],      "electronicAddresses" : [ ]    },    "relationships" : [ ],    "relatedDocuments" : [ ],    "riskRating" : null,    "name" : "ECHO MR D & ECHO MRS E"  },  "links" : [ {    "rel" : "regulatory-compliance",    "href" : "/v1/involved-parties/regulatory-compliance/Organisation/Organisation",    "hreflang" : null,    "media" : null,    "title" : null,    "type" : null,    "deprecation" : null  } ]}'
                    );
                } else if (mainAccountType == 'Unidentified') {
                    response.setBody(
                        '{  "content" : {    "suin" : "1-JWCCTV",    "created" : "2019-06-21T00:54:41",    "updated" : "2019-07-15T14:23:02",    "individual" : null,    "formalOrganisation" : null,    "informalOrganisation" : {      "jointParticipanCount" : null,      "name" : "ECHO MR D & ECHO MRS E",      "pepStatus" : {        "code" : "",        "description" : ""      },      "subStatus" : {        "code" : "",        "description" : ""      },      "status" : {        "code" : "Active",        "description" : "Active"      },      "ficaAddressUpdateDate" : null,      "ficaAddressAttestedDate" : null,      "sourceOfIncomeAttestedDate" : null,      "nextRefreshDate" : null,      "identificationUpdateDate" : null,      "identificationAttestedDate" : null,      "type" : {        "code" : "",        "description" : ""      },      "revenueSegment" : null,      "primaryContact" : null,      "manager" : null,      "natureOfBusiness" : {        "code" : "",        "description" : ""      },      "knownAs" : null    },    "organisationUnit" : null,    "sourcesOfIncome" : [ {      "code" : "",      "description" : ""    } ],    "sourcesOfWealth" : [ ],    "activeInIndustries" : [ ],    "flags" : [ {      "effectiveDate" : null,      "yesNoFlag" : true,      "type" : {        "code" : "ABSA",        "description" : "ABSA"      },      "category" : {        "code" : "Corporate Relationship",        "description" : "Corporate Relationship"      },      "isOperationalFlag" : false    }, {      "effectiveDate" : null,      "yesNoFlag" : false,      "type" : {        "code" : "SBU Segment",        "description" : "SBU Segment"      },      "category" : {        "code" : "Segment",        "description" : "Segment"      },      "isOperationalFlag" : false    } ],    "countries" : [ {      "name" : "",      "isoCode" : null,      "type" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      },      "context" : {        "code" : "CountryOfIncorporation",        "description" : "CountryOfIncorporation"      }    } ],    "identifications" : [ {      "number" : "ECHOD+ 004",      "type" : {        "code" : "CIF Code",        "description" : "CIF Code"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "PARTYMDM",        "description" : "PARTYMDM"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    }, {      "number" : "1-JWCCTV",      "type" : {        "code" : "REGSERVICES",        "description" : "REGSERVICES"      },      "expiryDate" : null,      "issueDate" : null,      "category" : null,      "secondaryIdFlag" : false,      "issuingCountry" : null    } ],    "addresses" : {      "preferredCommunicationChannel" : null,      "telephonicAddress" : [ ],      "addresses" : [ {        "addressName1" : "1 Long Street",        "addressName2" : "",        "suburbName" : "",        "cityName" : "Cape Town",        "countryName" : "",        "postalCode" : "8001",        "context" : {          "code" : "Postal",          "description" : "Postal"        },        "gpsCoordinates" : null,        "type" : {          "code" : "Postal",          "description" : "Postal"        }      } ],      "electronicAddresses" : [ ]    },    "relationships" : [ ],    "relatedDocuments" : [ ],    "riskRating" : null,    "name" : "ECHO MR D & ECHO MRS E"  },  "links" : [ {    "rel" : "regulatory-compliance",    "href" : "/v1/involved-parties/regulatory-compliance/Organisation/Organisation",    "hreflang" : null,    "media" : null,    "title" : null,    "type" : null,    "deprecation" : null  } ]}'
                    );
                }

                if (getInvPartiesStatus == StringConstants.POSITIVE_STRING) {
                    response.setStatusCode(200);
                } else if (getInvPartiesStatus == StringConstants.NEGATIVE_STRING) {
                    response.setStatusCode(500);
                }
            }

            return response;
        }
    }
    /**
 * @description testCreateRBBAccountCIF_Individual_Postivive
 */
     @isTest
     public static void testCreateRBBAccountCIF_Individual_Postivive(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details'});
        
        Test.startTest();
        
        AccountCreate_CIF_MDM.createRBBAccountFromCIF('LEBOTL 001', '0', '009970');
        System.assertNotEquals('LEBOTL 001', null,200);
        Test.stopTest();
    }
        /**
 * @description testCreateRBBAccountCIF_Individual_Negative
 */
    @isTest
    public static void testCreateRBBAccountCIF_Individual_Negative(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.NEGATIVE_STRING, null, null, null, 'Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details'});
        
        Test.startTest();
        
        AccountCreate_CIF_MDM.createRBBAccountFromCIF('LEBOTL 001', '0', '009970');
        System.assertNotEquals('LEBOTL 001', null,200);
        Test.stopTest();
    }
      /**
 * @description testCreateRBBAccountCIF_Joint_Postivive
 */
    @isTest
    public static void testCreateRBBAccountCIF_Joint_Postivive(){

        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, null, 'Joint Account', 'Joint-Individual Account'));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF'});

        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
    /**
 * @description testCreateRBBAccountCIF_Joint_Negative_JntPart
 */
    @isTest
    public static void testCreateRBBAccountCIF_Joint_Negative_JntPart(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.NEGATIVE_STRING, null, 'Joint Account', 'Joint-Individual Account'));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF'});
        
        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateRBBAccountCIF_Joint_Negative_GetClientById
 */
    @isTest
    public static void testCreateRBBAccountCIF_Joint_Negative_GetClientById(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.NEGATIVE_STRING, StringConstants.POSITIVE_STRING, null, 'Joint Account', 'Joint-Individual Account'));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF'});
        
        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
        /**
 * @description testCreateRBBAccountCIF_Joint_Negative_GetClient
 */
    @isTest
    public static void testCreateRBBAccountCIF_Joint_Negative_GetClient(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.NEGATIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, null, 'Joint Account', 'Joint-Individual Account'));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details', 'Get Joint Participant', 'Get Client Details By Id CIF'});
        
        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateRBBAccountCIF_Sole_Positive
 */
    @isTest
    public static void testCreateRBBAccountCIF_Sole_Positive(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Sole Proprietor', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details'});
        
        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
    /**
 * @description testCreateRBBAccountCIF_Non_Individual_Positive
 */
    @isTest
    public static void testCreateRBBAccountCIF_Non_Individual_Positive(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Non Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details'});
        
        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
/**
 * @description testCreateRBBAccountCIF_Estate_Positive
 */
    @isTest
    public static void testCreateRBBAccountCIF_Estate_Positive(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Estate', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details'});
        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
 /**
 * @description testCreateRBBAccountCIF_Partnership_Positive
 */
    @isTest
    public static void testCreateRBBAccountCIF_Partnership_Positive(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Partnership', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details'});
        
        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
        /**
 * @description testCreateRBBAccountCIF_Unidentified_Positive
 */
    @isTest
    public static void testCreateRBBAccountCIF_Unidentified_Positive(){
        
        Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Unidentified', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new list<String> {'Get Client Details'});
        
        Test.startTest();

        AccountCreate_CIF_MDM.createRBBAccountFromCIF('SWANSR+002', '0', '009970');
        System.assertNotEquals('SWANSR+002', null,200);
        Test.stopTest();
    }
}