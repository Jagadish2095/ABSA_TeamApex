/** 
 * @description Test EBStopAndReplaceCreditCardController
 * @author Simangaliso Mathenjwa
 * @since 26 May 2021
 */
@IsTest
public  class EBStopAndReplaceCreditCardControllerTest {
    
    @IsTest
	static void testGetCardDetails() {
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        String responseBean = EBStopAndReplaceCreditCardController.getCardDetails(accountList[0].CIF__c);
        system.assertNotEquals(null, responseBean, 'Assert Failed');
        Test.stopTest();
    }


    @IsTest
	static void testGetCardDetailsNoIntegrationSettings() {
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        String responseBean = EBStopAndReplaceCreditCardController.getCardDetails(accountList[0].CIF__c);
        system.assertEquals(true, responseBean.startsWith('Error:'), 'Assert Failed');
        Test.stopTest();
    }


    @IsTest
	static void testGetPickListValuesListTranslations(){
        //make translations
        List<Integration_Translation__c> itr = new  List<Integration_Translation__c>();
        Integration_Translation__c StopReplaceCard = new Integration_Translation__c();
        StopReplaceCard.System_Name__c='StopReplaceCard';
        StopReplaceCard.Value_Type__c='Reason';
        StopReplaceCard.Internal_Value__c = 'Reason';
        StopReplaceCard.External_Value__c = 'Reason';
        StopReplaceCard.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        itr.add(StopReplaceCard);
        
        Integration_Translation__c StopReplaceCard1 = new Integration_Translation__c();
        StopReplaceCard1.System_Name__c='StopReplaceCard';
        StopReplaceCard1.Value_Type__c='Circumstances';
        StopReplaceCard1.Internal_Value__c = 'Circumstances';
        StopReplaceCard1.External_Value__c = 'Circumstances';
        StopReplaceCard1.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        itr.add(StopReplaceCard1);
        
        Integration_Translation__c StopReplaceCard2 = new Integration_Translation__c();
        StopReplaceCard2.System_Name__c='StopReplaceCard';
        StopReplaceCard2.Value_Type__c='Delivery Method';
        StopReplaceCard2.Internal_Value__c = 'Delivery Method';
        StopReplaceCard2.External_Value__c = 'Delivery Method';
        StopReplaceCard2.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        
        itr.add(StopReplaceCard2);
        
        insert itr;
        Test.startTest();
         List<Integration_Translation__c> Trans = EBStopAndReplaceCreditCardController.getPickListValuesListTranslations();
        system.assertEquals(3, Trans.size(), 'Assert Failed');
        Test.stopTest();
    }

    @IsTest
	static void  testGetTransactions(){

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CAgetAccountDetails_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CA_GET_ACCOUNT_DETAILS
        });

        Test.startTest();
        String Transactions = EBStopAndReplaceCreditCardController.getTransactions(new List<String>{'4028370000342011'});
        System.assertNotEquals(null, Transactions, 'Assert Failed');
        
        Test.stopTest();
    }

    @IsTest
	static void testStopReplaceCreditCard(){
        
        Test.setMock(HttpCalloutMock.class, new CAstpLostStolenCardV2Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CA_STP_LOSTSTOLENCARD_V2});
        
        Map<String, String> cardDetailsMap = new Map<String, String> ();
        cardDetailsMap.put('plasticNbr', '4028370000342011');
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        String Transactions = EBStopAndReplaceCreditCardController.stopReplaceCreditCard(cardDetailsMap);
        System.assertNotEquals(null, Transactions, 'Assert Failed');
        Test.stopTest();
    
    }
}