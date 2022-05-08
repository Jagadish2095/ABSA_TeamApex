/**
* Apex controller class for the Aura bundle ClientFinderAction.
* Allow a user to link a Client to the Case
*
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-09-21
* @description
*
**/

public class ClientFinderActionExt {
    
    /** @param leadRecordId
    * @param clientRecord
    * @param leadRecordType
    * @param selectedContactId
    * @param accNumber
    * @param accProduct
    * @param accStatus
    * @description
    * @return leadUpdate.id
    **/
        @AuraEnabled
        public static String linkClientToLead(String leadRecordId, Account clientRecord, String leadRecordType, String selectedContactId, String accNumber, String accProduct, String accStatus){         
            try {
                    Lead leadUpdate = new Lead();
                    Account relatedClient = new Account(); 
                    map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
                    leadUpdate.id = leadRecordId;
                    
                    //Set Contact Id
                    if(selectedContactId != null && selectedContactId != '') {
                        leadUpdate.ContactName__c  = selectedContactId;
                        // find the 
                    } else {
                        leadUpdate.ContactName__c  = null;
                    }
                
                
                 //Create Client (if not in Salesforce)
                if(clientRecord != null) {
                    if(clientRecord.id == null) {
                          //Query to see if Client already exist in Salesforce
                        List<Account> relatedAcc = new AccountsSelector().selectByCIF(clientRecord.CIF__c,1);
    
                        if(relatedAcc.size() > 0 && relatedAcc.size() < 2) {
                            //Use client found in Salesforce
                            relatedClient = relatedAcc[0];
                        } else if (relatedAcc.size() > 1) {
                            throw new AuraHandledException('Duplicate CIF number found - ' + relatedClient.CIF__c); 
                       }else {
                            //Create new Client
                            //relatedClient = clientRecord;
                            
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
                                leadUpdate.Email = clientRecord.PersonEmail;
                               // caseUpdate.Email_From_Name__c = clientRecord.Name;
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
                        
                        //Link Account and Contact to Case
                        if(relatedClient.isPersonAccount == true) {
                            leadUpdate.ContactName__c = relatedClient.PersonContactId;
                            leadUpdate.Parent_Account__c  = relatedClient.Id;
                            leadUpdate.Account__c =  relatedClient.Id;
                        }
                        else {
                            leadUpdate.Parent_Account__c = relatedClient.Id;
                             leadUpdate.Account__c =  relatedClient.Id;
                            leadUpdate.FinServ__RelatedAccount__c  = relatedClient.Id;
                        }
                        
                        leadUpdate.Parent_Account__c = relatedClient.id;
                         leadUpdate.Account__c =  relatedClient.Id;
                        leadUpdate.FinServ__RelatedAccount__c  = relatedClient.Id;
                   }else if(clientRecord.id != null) {
                        Set<Id> accountIdSet = new Set<Id>();
                        accountIdSet.add(clientRecord.id);
                        List<Account> relatedAcc = new AccountsSelector().selectById(accountIdSet,1);
                        if(relatedAcc.size() > 0) {
                            //Use client found in Salesforce
                            relatedClient = relatedAcc[0];
    
                            leadUpdate.Parent_Account__c = relatedClient.id;
                            leadUpdate.FinServ__RelatedAccount__c  = relatedClient.Id;
                            if(relatedClient.isPersonAccount == true) {
                                leadUpdate.ContactName__c = relatedClient.PersonContactId;
                                leadUpdate.FirstName = relatedClient.FirstName;
                                leadUpdate.LastName =  relatedclient.LastName; 
                                leadUpdate.Email = relatedClient.PersonEmail;
                                leadUpdate.Phone = relatedClient.Phone;
                            }
                        }
                     }
                }  
                
                 //Update the Lead
                update leadUpdate;
                
                return leadUpdate.id;
                
            }catch(DmlException ex){
                
                //Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
                String msg = '';
                //Get All DML Messages
                for (Integer i = 0; i < ex.getNumDml(); i++) {
                    //Get Validation Rule & Trigger Error Messages
                    msg =+ ex.getDmlMessage(i) +  '\n' ;
                }
                //throw DML exception message
                throw new AuraHandledException(msg);
            }catch (Exception ex){
                throw new AuraHandledException(ex.getMessage()); 
            }
          
        }   
        
        
        /**=================================================================================================================================
    @description getObjectName
    @param recordId (Id)
    @return String
    
    * Created By Pravin W. 30/07/2021
    * Returns Object Type Name
    * Param 1: recordId is our record Id from the Aura Component
    ===================================================================================================================================**/
        @AuraEnabled
        public static String getObjectName(Id recordId) {
            return recordId.getSObjectType().getDescribe().getName();
        }
        /**
         * @param  caseRecordId
         * @param  clientRecord
         * @param  caseRecordType
         * @param  selectedContactId
         * @param  accNumber
         * @param  accProduct
         * @param  accStatus
         * @return leadIdReturn
         * @description 
     */
        @AuraEnabled
        public static String linkClientToCase(String caseRecordId, Account clientRecord, String caseRecordType, String selectedContactId, String accNumber, String accProduct, String accStatus){         
            String objectType;
            objectType = ClientFinderActionExt.getObjectName(caseRecordId);
            if( objectType == 'Lead' ){
                string leadIdReturn = '';
                leadIdReturn = linkClientToLead( caseRecordId,  clientRecord,  caseRecordType,  selectedContactId,  accNumber,  accProduct,  accStatus);         
                return leadIdReturn;
            }
            Try {
                Case caseUpdate = new Case();
                Account relatedClient = new Account(); 
                map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
                caseUpdate.id = caseRecordId;
                // Added to determine the LinkClient to Case is clicked for NBFS Case
                caseUpdate.ClientFinderAction__c = true;
                
         // Added For AIC by Anu
         // Code commented by client request
         /* 
                String caseRecordTypeName = [Select id, RecordType.Name from Case where Id =:caseRecordId].RecordType.Name;
                if(clientRecord != null && caseRecordTypeName == 'AIC'){
                    Account validateAccount =[Select id,(Select Id,Status,OwnerId from Cases where Status='Awaiting Documents') From Account where Id =: clientRecord.Id];
                    if(validateAccount != null && validateAccount.cases.size() == 0){
                        return 'validateAccountFail';                 
                    }else{
                        caseUpdate.AccountId = validateAccount.id;
                        Case adCase = validateAccount.cases[0];
                        adCase.Status = 'FIC not Verified';
                        Id queueId =  [Select Id from Group where Type = 'Queue'  AND DeveloperName = 'Verification_AIC'].Id;
                        adCase.OwnerId = queueId;
                        update adCase;
                    }
                }
				*/
    //Account Number selected?
                caseUpdate.Account_Product_Name__c = accProduct; 
                caseUpdate.Account_Number__c = accNumber; 
                caseUpdate.Account_Status__c = accStatus;  
                
                //Set Contact Id
                if(selectedContactId != null && selectedContactId != '') {
                    caseUpdate.contactId = selectedContactId;
                } else {
                    caseUpdate.contactId = null;
                }
    
                //Create Client (if not in Salesforce)
                if(clientRecord != null) {
                    if(clientRecord.id == null) {
                        //Query to see if Client already exist in Salesforce
                        List<Account> relatedAcc = new AccountsSelector().selectByCIF(clientRecord.CIF__c,1);
    
                        if(relatedAcc.size() > 0 && relatedAcc.size() < 2) {
                            //Use client found in Salesforce
                            relatedClient = relatedAcc[0];
                        } else if (relatedAcc.size() > 1) {
                            throw new AuraHandledException('Duplicate CIF number found - ' + relatedClient.CIF__c); 
                       }else {
                            //Create new Client
                            //relatedClient = clientRecord;
                            
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
                                caseUpdate.Email_From_Address__c = clientRecord.PersonEmail;
                                caseUpdate.Email_From_Name__c = clientRecord.Name;
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
                        
                        //Link Account and Contact to Case
                        if(relatedClient.isPersonAccount == true) {
                            caseUpdate.ContactId = relatedClient.PersonContactId;
                            caseUpdate.AccountId = relatedClient.Id;
                        }
                        else {
                            caseUpdate.AccountId = relatedClient.Id;
                        }
                        
                        caseUpdate.AccountId = relatedClient.id;
                    }
                    else if(clientRecord.id != null) {
                        Set<Id> accountIdSet = new Set<Id>();
                        accountIdSet.add(clientRecord.id);
                        List<Account> relatedAcc = new AccountsSelector().selectById(accountIdSet,1);
                        if(relatedAcc.size() > 0) {
                            //Use client found in Salesforce
                            relatedClient = relatedAcc[0];
    
                            caseUpdate.AccountId = relatedClient.id;
                            if(relatedClient.isPersonAccount == true) {
                                caseUpdate.ContactId = relatedClient.PersonContactId;
                            }
                        }
                    }
                }
                
                //Update the Case
                update caseUpdate;
                
                return caseUpdate.id;
                
             }catch(DmlException ex){
                
                //Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
                String msg = '';
                //Get All DML Messages
                for (Integer i = 0; i < ex.getNumDml(); i++) {
                    //Get Validation Rule & Trigger Error Messages
                    msg =+ ex.getDmlMessage(i) +  '\n' ;
                }
                //throw DML exception message
                throw new AuraHandledException(msg);     
            } catch (Exception ex){
                throw new AuraHandledException(ex.getMessage()); 
            }
            
        
        }
       
    }