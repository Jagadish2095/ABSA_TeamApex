@isTest
public class ClientSecuritiesControllerTest {
	@isTest 
    public static void validatesMgetAsVbondsV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsVbondsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_BONDS_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getSecurityBonds(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    @isTest 
    public static void validatesgetSuretyshipsPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSuretyshipsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SURETYSHIPS_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getSuretyships(ac.Id);
        //system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetCreditLifePolicyPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCreditLifePolicyV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CREDIT_LIFE_POLICY_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getCreditLifePolicy(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetgetCessionofLinkLifePolicyPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPLinkedV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_LINKED_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getCessionofLinkLifePolicy(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
     @isTest
    public static void validatesgetCessionofNoLinkLifePolicyPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfLPNoLinkV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_L_P_NO_LINK_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getCessionofNoLinkLifePolicy(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
     @isTest
    public static void validatesgetCessionofDebtorsPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfDebtorsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_DEBTORS_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getCessionofDebtors(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetCessionofGeneralpledgesPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfPledgesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_PLEDGES_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getCessionofGeneralpledges(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetCessionofInternalInvestmentsPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfInvstmntV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_INVSTMNT_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getCessionofInternalInvestments(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetgetCessionOfSchemesPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSchemesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SCHEMES_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getCessionOfSchemes(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetDematSharesPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvDematSharesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_DEMAT_SHARES_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getDematShares(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetAsvLettersV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvLettersV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_LETTERS_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getAsvLettersV1(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetAsvSecurityAndHoldsPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvSecurityAndHoldsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_SECURITY_AND_HOLDS_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getAsvSecurityAndHolds(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    @isTest
    public static void validatesgetAsvCessionOfSharesPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSharesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_SHARES_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getAsvCessionOfShares(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
    @isTest
    public static void validatesgetAsvCessionOfPledgesPositive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfPledgesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_CESSION_OF_PLEDGES_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getAsvCessionOfPledges(ac.Id);
        //system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
     @isTest
    public static void validatesgetASVCessionOfExternalInvestmentsV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'BABICK 001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfExtInv_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getASVCessionOfExternalInvestmentsV1(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
     @isTest
    public static void validatesgetASVGeneralCessionsV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'CLOSE  001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new sMgetAsvGeneralCessionsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_GENERAL_SESSION_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getASVGeneralCessionsV1(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
     @isTest
    public static void validatesgetASVCessionOfFireShortTermInsuranceV1Positive(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'BABICK 001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SMgetASVCessionOfFireSrtV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.SM_GET_ASV_FIRESHORT_TERMINSURANCE_SESSION_V1
        });

        Test.startTest();
        String respose = ClientSecuritiesController.getASVCessionOfFireShortTermInsuranceV1(ac.Id);
        system.assertNotEquals(null, respose);
        Test.stopTest();
    }
    
}