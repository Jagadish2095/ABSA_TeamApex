/**
 * Controller Class for the Account Wizard Component for the creation of Account records
 *
 * @author  Kyle Alexander 
 * @since   2019-02-05
 */ 

public with sharing class AccountWizardController {
    
    @AuraEnabled
    public static string createAccount(Id oppId, Account accountData) {

        //Create the client record
        Map<String, Object> accountDataMap = accountData.getPopulatedFieldsAsMap();
        Map<String, Object> temp = new Map<String, Object>();
        temp.putAll(accountDataMap);
        temp.remove('Name');
        Account client = (Account)JSON.deserialize(JSON.serialize(temp), Account.class);
        System.debug('client ' + client);
        
        AccountCreate_CIF_MDM.GIPResponse createdAccount;
        System.debug('client.Name: ' + client.Name);
        System.debug('client.ID_Number__pc: ' + client.ID_Number__pc);
        System.debug('client.CIF__c: ' + client.CIF__c);
        
        if(client.CIF__c != null){
            System.debug('CIF Key');
            createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(client.CIF__c, '0', '009970');
            
        }else if(client.ID_Type__pc != null && client.ID_Type__pc == 'SA Identity Document'){
            System.debug('SA Identity Document');
            createdAccount = AccountCreate_CIF_MDM.createAccountFromMDM('SAID', client.ID_Number__pc);
            
        }else if(client.ID_Type__pc != null && client.ID_Type__pc == 'Passport'){
            System.debug('Passport');
            createdAccount = AccountCreate_CIF_MDM.createAccountFromMDM('Passport', client.ID_Number__pc);
            
        }else{
            
            return 'No ID number, Passport number or CIF number was found';
        }
        if(createdAccount.response == 'Success'){
            return createdAccount.response + ':' + createdAccount.accountId;
        }else{
            return createdAccount.response;
        }
    }
}