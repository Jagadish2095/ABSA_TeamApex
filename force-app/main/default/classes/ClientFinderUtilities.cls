/**
* Apex utilities class for Client Finder.
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2019-01-30
*
**/
public class ClientFinderUtilities {
    /*
    * Get Account Id if already in SF, else create Client and return the Client Record
    * 
    * @param clientRecord Account
    * @return relatedClient Account
    */
    public static Account findOrCreateClient(Account clientRecord)
    {
        Account relatedClient = new Account();
        map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        //Create Client (if not in Salesforce)
        if(clientRecord != null) {
            if(clientRecord.id == null) {
                //Query to see if Client already exist in Salesforce
                List<Account> relatedAcc = new AccountsSelector().selectByCIF(clientRecord.CIF__c,1);
                
                if(relatedAcc.size() > 0 && relatedAcc.size() < 2) {
                    //Use client found in Salesforce
                    relatedClient = relatedAcc[0];
                } else if (relatedAcc.size() > 1) {
                    System.debug('Duplicate CIF number found - ' + relatedClient.CIF__c);
                    throw new AuraHandledException('Duplicate CIF number found - ' + relatedClient.CIF__c); 
                }
                //Create new Client
                else {
                    if(clientRecord.FirstName != null) {
                        relatedClient.Salutation = clientRecord.Salutation;
                        relatedClient.FirstName = clientRecord.FirstName;
                        relatedClient.LastName = clientRecord.LastName;
                        relatedClient.ID_Number__pc = clientRecord.ID_Number__pc;
                        relatedClient.PersonMobilePhone = clientRecord.PersonMobilePhone;
                        relatedClient.PersonHomePhone = clientRecord.PersonHomePhone;
                        relatedClient.Phone = clientRecord.Phone;
                        relatedClient.PersonEmail = clientRecord.PersonEmail;
                        relatedClient.recordTypeId = accountRecordTypeMap.get('Individual_Client').getRecordTypeId();
                    }
                    //Business Client
                    else {
                        relatedClient.Name = clientRecord.Name;
                        relatedClient.Phone = relatedClient.Phone;
                        relatedClient.recordTypeId = accountRecordTypeMap.get('Client').getRecordTypeId();
                    }
                    
                    relatedClient.CIF__c = clientRecord.CIF__c;
                    relatedClient.Client_Type__c = clientRecord.Client_Type__c;
                    relatedClient.Communication_Method__c = clientRecord.Communication_Method__c;
                    relatedClient.ShippingStreet = clientRecord.ShippingStreet;
                    relatedClient.ShippingCity = clientRecord.ShippingCity;
                    relatedClient.ShippingPostalCode = clientRecord.ShippingPostalCode;
                    relatedClient.ShippingState = clientRecord.ShippingState;
                    relatedClient.BillingStreet = clientRecord.BillingStreet;
                    relatedClient.BillingCity = clientRecord.BillingCity;
                    relatedClient.BillingPostalCode = clientRecord.BillingPostalCode;
                    relatedClient.BillingState = clientRecord.BillingState;
                    
                    insert relatedClient;
                }
                
                //Query account to get more information
                Set<Id> accountIdSet = new Set<Id>();
                accountIdSet.add(relatedClient.id);
                List<Account> relatedAccInserted = new AccountsSelector().selectById(accountIdSet,1);
                relatedClient = relatedAccInserted[0];
                
            }
            else if(clientRecord.id != null) {
                Set<Id> accountIdSet = new Set<Id>();
                accountIdSet.add(clientRecord.id);
                List<Account> relatedAcc = new AccountsSelector().selectById(accountIdSet,1);
                if(relatedAcc.size() > 0) {
                    //Use client found in Salesforce
                    relatedClient = relatedAcc[0];
                }
            }
        }
        
        return relatedClient;
    }
}