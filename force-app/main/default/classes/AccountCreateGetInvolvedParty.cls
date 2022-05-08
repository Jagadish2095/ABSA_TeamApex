/**
* A reusable class that provides a static method that calls the get involved party service that gets account information 
* and then creates that account
*
* @author  Kyle Alexander 
* @since   2019-02-05
*/

public without sharing class AccountCreateGetInvolvedParty {
    
    /* Method that creates the account, both individual and joint accounts from data retrieved from the get involved party service
    * 
    * @param queryTypeP: Type of query, valids ones are: CIF, SAID
    * @param regIdP: ID number, CIF number etc depending on the query type   
    * @return String: Validity message
    */   
    public static GIPResponse createAccount(String queryTypeP, String regIdP) {
        
        RegSer_InvolvedParties_Resp_IB_v1 involvedParties = RegSer_InvolvedParties_IH_v1.getInvolvedParties(queryTypeP, regIdP, false);
        
        if(involvedParties.statusCode == 200 && involvedParties.content.identifications != null){
            try{
                String cifNumber;
                String idNumber;

                for(RegSer_InvolvedParties_Resp_IB_v1.cls_identifications identification : involvedParties.content.identifications){
                    if(identification.type.description == 'CIF Code' && identification.numbers.length() <= 10){
                        cifNumber = identification.numbers;
                    }
                    if(identification.type.description == 'ID Number'){
                        idNumber = identification.numbers;
                    }
                }

                Account account = new Account();
                
                //Individual or Staff

                if (involvedParties.content.individual != null &&
                    (
                        involvedParties.content.individual.clientClassification.description == 'Private Individual' ||
                        involvedParties.content.individual.clientClassification.description == 'Staff'
                    )
                ) {
                    account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
                    account.Client_Type__c = 'Individual';
                    account.LastName = involvedParties.content.individual.surname;
                    account.FirstName = involvedParties.content.individual.name;
                    account.Person_Informal_Name__pc = involvedParties.content.individual.knownAs;
                    account.Initials__pc = involvedParties.content.individual.initials;
                    if(involvedParties.content.individual.salutation != null){
                        account.PersonTitle = involvedParties.content.individual.salutation.description;
                    } 
                    
                    if(involvedParties.content.individual.gender != null){
                        account.Gender__pc = involvedParties.content.individual.gender.description;
                    }
                    
                    //ToDo remove hardcoded value as soon as we get mapping
                    account.ID_Type__pc = 'SA Identity Document';
                    account.ID_Number__pc = idNumber;
                    account.CIF__c = cifNumber;
                    
                    account.PersonBirthdate = Date.parse(involvedParties.content.individual.dateofBirth.replace('-', '/'));
                    
                    if(involvedParties.content.individual.maritalContractType != null){
                        account.Marital_Contract_Type__pc = involvedParties.content.individual.maritalContractType.description;
                    }
                    
                    //account.Occupation__pc = involvedParties.content.individual.occupation;
                    
                    if(involvedParties.content.sourcesOfIncome.size() != 0){
                        account.Income_Source__pc = involvedParties.content.sourcesOfIncome.get(0).description;
                    }
                    
                    //account.Occupation_Status__pc = involvedParties.content.individual.occupationStatus;
                    
                    //Requires translation		
                    if(involvedParties.content.individual.maritalStatus != null){		
                    	account.Marital_Status__pc = involvedParties.content.individual.maritalStatus.description;		
                    }		
                    		
                    for(RegSer_InvolvedParties_Resp_IB_v1.cls_addresses_telephonicAddress num : involvedParties.content.addresses.telephonicAddress){		
                        if(num.context != null){		
                            if(num.context.description == 'MainCellPhone'){		
                            	//account.PersonMobilePhone = num.countryCode + num.diallingCode + num.numbers;	
                            	account.PersonMobilePhone = num.diallingCode + num.numbers;			
                            }		
                            if(num.context.description == 'MainWorkPhone'){		
                                //account.Phone = num.countryCode + num.diallingCode + num.numbers;		
                                account.Phone = num.diallingCode + num.numbers;		
                            }		
                            if(num.context.description == 'MainHomePhone'){		
                                //account.PersonHomePhone = num.countryCode + num.diallingCode + num.numbers;	
                                account.PersonHomePhone = num.diallingCode + num.numbers;			
                            }		
                        }		
                    }		
                    		
                    for(RegSer_InvolvedParties_Resp_IB_v1.cls_addresses_addresses address : involvedParties.content.addresses.addresses){		
                        if(address.context != null){		
                            if(address.context.description == 'Residential'){		
                            	account.ShippingCity = address.cityName;		
                                account.ShippingCountry = address.countryName;	
                                account.ShippingStreet = address.addressName1 + '\r\n' + address.addressName2;	
                                account.ShippingPostalCode = address.postalCode;		
                            }		
                            if(address.context.description == 'Postal'){		
                                account.BillingCity = address.cityName;		
                                account.BillingCountry = address.countryName;	
                                account.BillingStreet = address.addressName1 + '\r\n' + address.addressName2;	
                                account.BillingPostalCode = address.postalCode;		
                            }		
                        }		
                    }
                    
                    //Marketing Indicators 
                    /*
                    String marketingPreferences = '';
                    for(RegSer_InvolvedParties_Resp_IB_v1.cls_flags flag : involvedParties.content.flags){
                        if(flag.type.description.contains('Marketing Preference')){
                            if((flag.type.description.substring(flag.type.description.lastIndexOf(':') + 1).replaceAll('\\s+','')) == 'Call' && flag.yesNoFlag == true){
                                marketingPreferences += 'Call;';
                            }
                            else if((flag.type.description.substring(flag.type.description.lastIndexOf(':') + 1).replaceAll('\\s+','')) == 'Email' && flag.yesNoFlag == true){
                                marketingPreferences += 'Email;';
                            }
                            else if((flag.type.description.substring(flag.type.description.lastIndexOf(':') + 1).replaceAll('\\s+','')) == 'Mail' && flag.yesNoFlag == true){
                                marketingPreferences += 'Mail;';
                            }
                            else if((flag.type.description.substring(flag.type.description.lastIndexOf(':') + 1).replaceAll('\\s+','')) == 'SMS' && flag.yesNoFlag == true){
                                marketingPreferences += 'SMS;';
                            }
                        }
                    }
                    account.Non_Credit_Marketing_Indicator__pc = marketingPreferences;
					*/
                    
                    account.Risk_Rating__c = involvedParties.content.riskRating;
                    
                    List<Account> cifAccount = new AccountsSelector().selectByCIF(cifNumber, 1);
                    List<Account> idAccount = new AccountsSelector().selectByIdNumber(idNumber, 1);
                    
                    System.debug(cifAccount.size() + ' ' + idAccount.size());
                    //Create new account
                    if(cifAccount.size() == 0 && idAccount.size() == 0){
                        insert account;
                        
                        System.debug('account ' + account);
                        
                        GIPResponse resp = new GIPResponse();
                        resp.response = 'Success';
                        resp.accountId = account.Id;
                        
                        System.debug('GIPResponse ' + resp);
                        
                        return resp;
                    }
                    //Update account
                    else if(cifAccount.size() > 0){
                        Account updatedAccount = cifAccount.get(0);
                        updatedAccount = account;
                        updatedAccount.Id = cifAccount.get(0).Id;
                        update updatedAccount;
                        
                        System.debug('updatedAccount ' + updatedAccount);
                        
                        GIPResponse resp = new GIPResponse();
                        resp.response = 'Success';
                        resp.accountId = updatedAccount.Id;
                        
                        System.debug('GIPResponse ' + resp);
                        
                        return resp;
                    }
                    //Update account
                    else if(idAccount.size() > 0){
                        Account updatedAccount = idAccount.get(0);
                        updatedAccount = account;
                        updatedAccount.Id = idAccount.get(0).Id;
                        update updatedAccount;
                        
                        System.debug('updatedAccount ' + updatedAccount);
                        
                        GIPResponse resp = new GIPResponse();
                        resp.response = 'Success';
                        resp.accountId = updatedAccount.Id;
                        
                        System.debug('GIPResponse ' + resp);
                        
                        return resp;
                    }
                } 
                //Joint Account
                //else if (involvedParties.content.informalOrganisation.type.description == 'Joint & several') {
                else if (involvedParties.content.informalOrganisation.type.description.toLowerCase().contains('joint')) {
                    account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
                    
                    account.Client_Type__c = 'Joint & Several';
                    account.Name = involvedParties.content.name;
                    
                    account.CIF__c = cifNumber;
                    if(involvedParties.content.addresses.addresses.size() > 1){
                        account.Country_of_Registration__c = involvedParties.content.addresses.addresses.get(0).countryName;
                    }
                    
                    account.Risk_Rating__c = involvedParties.content.riskRating;
                    
                    List<Account> cifAccount = new AccountsSelector().selectByCIF(cifNumber, 1);
                    
                    //Create new account
                    if(cifAccount.size() == 0){                        
                        //Create contacts for account off participants
                        Id accId = createParticipants(cifNumber, account, 'Insert');
                        
                        GIPResponse resp = new GIPResponse();
                        resp.response = 'Success';
                        resp.accountId = accId;
                        
                        System.debug('GIPResponse ' + resp);
                            
                        return resp;
                    }
                    //Update account
                    else if(cifAccount.size() > 0){
                        Account updatedAccount = cifAccount.get(0);
                        updatedAccount = account;
                        updatedAccount.Id = cifAccount.get(0).Id;
                        
                        //Create contacts for account off participants
                        Id accId = createParticipants(cifNumber, updatedAccount, 'Update');
                        
                        GIPResponse resp = new GIPResponse();
                        resp.response = 'Success';
                        resp.accountId = accId;
                        
                        System.debug('GIPResponse ' + resp);
                        
                        return resp;
                    }
                }
            }
            catch(Exception ex){
                GIPResponse resp = new GIPResponse();
                resp.response = 'Exception: ' + ex.getMessage();
                return resp;
            }
        }
        else if(involvedParties.statusCode == 400){
            GIPResponse resp = new GIPResponse();
            resp.response = 'Invalid data was passed to the api';
            return resp;
        }
        else if(involvedParties.statusCode == 401){
            GIPResponse resp = new GIPResponse();
            resp.response = 'Unathorized';
            return resp;
        }
        else if(involvedParties.statusCode == 403){
            GIPResponse resp = new GIPResponse();
            resp.response = 'Forbidden';
            return resp;
        }
        else if(involvedParties.statusCode == 404){
            GIPResponse resp = new GIPResponse();
            resp.response = 'Party was not found and Error message returned';
            return resp;
        }
        else if(involvedParties.statusCode == 500){
            GIPResponse resp = new GIPResponse();
            resp.response = 'System error occurred calling the api';
            return resp;
        }
        else{
            GIPResponse resp = new GIPResponse();
            resp.response = 'An unknow error has occured, please contact a system administrator';
            return resp;
        }
        
        GIPResponse resp = new GIPResponse();
        resp.response = 'An unknow error has occured, please contact a system administrator';
        return resp;
    }
     
    /* Method that creates the participants for a joint account
    * 
    * @param cifNumber: CIF number for the joint account
    * @param account: The joint account
    * @param insertOrUpdate: If the participant should be inserted or updated
    */ 
    public static Id createParticipants(String cifNumber, Account account, String insertOrUpdate){
        
        GetJointParticipant_Resp_IB_v1 clientParticipantsBean = GetJointParticipant_IH_v1.getJointParticipant(cifNumber, false);
        
        List<Account> prospectAccountUpdateList = new List<Account>();
        List<Account> prospectAccountInsertList = new List<Account>();
        
        Set<String> idNumberSet = new Set<String>();
        String docType;
        Map<String, RegSer_InvolvedParties_Resp_IB_v1> invPartiesMap = new Map<String, RegSer_InvolvedParties_Resp_IB_v1>();

        for(GetJointParticipant_Resp_IB_v1.cls_JntEntry part : clientParticipantsBean.jntEntry){
            //Is SAID
            if(part.idDocType == '1'){
                docType = 'SAID';
            }
            //Is Passport
            if(part.idDocType == '3'){
                docType = 'Passport';
            }
            
            idNumberSet.add(part.idNumber);
            try{
                RegSer_InvolvedParties_Resp_IB_v1 involvedParties = RegSer_InvolvedParties_IH_v1.getInvolvedParties(docType, part.idNumber, false);
                invPartiesMap.put(part.idNumber, involvedParties);
            }
            catch(Exception ex){
                System.debug(LoggingLevel.ERROR, 'ERROR' + ex.getMessage() + ex.getCause() + ex.getLineNumber());
            }
        }
        
        Map<String, Account> accountProspectMap = new Map<String, Account>();
        for(Account a : [Select Id, Name, PersonEmail, ID_Number__pc From Account WHERE ID_Number__pc in :idNumberSet]){
            accountProspectMap.put(a.ID_Number__pc, a);
        }
        
        //Insert Account
        if(insertOrUpdate == 'Insert'){
            insert account;
        }
        //Update Account
        else if(insertOrUpdate == 'Update'){
            update account;
        }
                
        for(GetJointParticipant_Resp_IB_v1.cls_JntEntry part : clientParticipantsBean.jntEntry){
            //Is SAID
            if(part.idDocType == '1'){
                docType = 'SAID';
            }
            //Is Passport
            if(part.idDocType == '3'){
                docType = 'Passport';
            }
            
            if(invPartiesMap.containsKey(part.idNumber)){
                
                RegSer_InvolvedParties_Resp_IB_v1 involvedParties = invPartiesMap.get(part.idNumber);
                if(involvedParties.statusCode == 200 && involvedParties.content.identifications != null){
                    try{
                        
                        String cifNum;
                        String idNumber;
                        
                        Boolean isAddedAlready = false;
                        
                        for(RegSer_InvolvedParties_Resp_IB_v1.cls_identifications identification : involvedParties.content.identifications){
                            if(cifNum == identification.numbers){
                                isAddedAlready = true;
                            }
                            System.debug('Here123' + identification.type.description);
                            if(identification.type.description == 'CIF Code'){
                                cifNum = identification.numbers;
                            }
                            if(identification.type.description == 'ID Number' || identification.type.description == 'Passport'){
                                idNumber = identification.numbers;
                            }
                        }
                        
                        if(isAddedAlready){
                            cifNum = null;
                        }
                        
                        //Individual
                        if(involvedParties.content.individual != null) {
                            Account prospectAccount = new Account();
                            
                            prospectAccount.LastName = involvedParties.content.individual.surname;
                            prospectAccount.FirstName = involvedParties.content.individual.name;
                            prospectAccount.Person_Informal_Name__pc = involvedParties.content.individual.knownAs;
                            prospectAccount.Initials__pc = involvedParties.content.individual.initials;
                            if(involvedParties.content.individual.salutation != null){
                                prospectAccount.PersonTitle = involvedParties.content.individual.salutation.description;
                            }
                            
                            if(involvedParties.content.individual.gender != null){
                                prospectAccount.Gender__pc = involvedParties.content.individual.gender.description;
                            }
                            
                            //ToDo remove hardcoded value as soon as we get mapping
                            if(docType == 'SAID'){
                                prospectAccount.ID_Type__pc = 'SA Identity Document'; 
                            }
                            else if(docType == 'Passport'){
                                prospectAccount.ID_Type__pc = 'Passport'; 
                            }
                            prospectAccount.ID_Number__pc = idNumber;
                            
                            prospectAccount.PersonBirthdate = Date.parse(involvedParties.content.individual.dateofBirth.replace('-', '/'));
                            
                            if(involvedParties.content.individual.maritalContractType != null){
                                prospectAccount.Marital_Contract_Type__pc = involvedParties.content.individual.maritalContractType.description;
                            }
                            
                            prospectAccount.Occupation__pc = involvedParties.content.individual.occupation;
                            
                            if(involvedParties.content.sourcesOfIncome.size() != 0){
                                prospectAccount.Income_Source__pc = involvedParties.content.sourcesOfIncome.get(0).description;
                            }
                            
                            prospectAccount.Occupation_Status__pc = involvedParties.content.individual.occupationStatus;
                            
                            prospectAccount.Risk_Rating__pc = involvedParties.content.riskRating;

                            List<Account> prospectAccounts = new List<Account>();
                            if(accountProspectMap.containsKey(part.idNumber)){
                                prospectAccounts.add(accountProspectMap.get(part.idNumber));
                            } 
                            
                            //Set record type
                            if(cifNum != null && cifNum.length() <= 10){
                                prospectAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
                                prospectAccount.CIF__c = cifNum;
                            }
                            else{
                                prospectAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
                            }
                            
                            //Update account prospect
                            if(prospectAccounts.size() > 0){
                                prospectAccount.Id = prospectAccounts.get(0).Id;

                                prospectAccountUpdateList.add(prospectAccount);  
                            }
                            //Create account prospect
                            else{
                                prospectAccountInsertList.add(prospectAccount); 
                            }
                        }
                    }
                    catch(Exception ex){
                        System.debug(LoggingLevel.ERROR, 'ERROR' + ex.getMessage() + ex.getCause() + ex.getLineNumber());
                    }
                }
            }
        }
        
        if(prospectAccountUpdateList.size() > 0){
            System.debug('prospectAccountUpdateList: ' + prospectAccountUpdateList);
            update prospectAccountUpdateList;
            //update accountUpdateList;
            
            Map<Id, Id> accountIdMap = new Map<Id, Id>();
            for(Account a : [SELECT id, PersonContactId FROM Account WHERE id in :prospectAccountUpdateList]){
                accountIdMap.put(a.Id, a.PersonContactId);
            }
            
            for(Account a : prospectAccountUpdateList){
                System.debug(account.id + ' ' + accountIdMap.get(a.Id));
                try{
                    AccountContactRelation acr = new AccountContactRelation(); 
                    acr.AccountId = account.id;
                    acr.ContactId = accountIdMap.get(a.Id);
                    insert acr;
                }
                catch(Exception e){
                    System.debug(e);
                }
            }
        }
        if(prospectAccountInsertList.size() > 0){
            System.debug('prospectAccountInsertList: ' + prospectAccountInsertList);
            insert prospectAccountInsertList;
            //insert accountInsertList;
            
            Map<Id, Id> accountIdMap = new Map<Id, Id>();
            for(Account a : [SELECT id, PersonContactId FROM Account WHERE id in :prospectAccountInsertList]){
                accountIdMap.put(a.Id, a.PersonContactId);
            }
            
            for(Account a : prospectAccountInsertList){
                System.debug(account.id + ' ' + accountIdMap.get(a.Id));
                try{
                    AccountContactRelation acr = new AccountContactRelation(); 
                    acr.AccountId = account.id;
                    acr.ContactId = accountIdMap.get(a.Id);
                    insert acr;
                }
                catch(Exception e){
                    System.debug(e);
                }
            }
        }
        
        return account.Id;
    }
    
    /* Method that maps a contact to a person account
    * 
    * @param cifNumber: CIF number for the joint account
    * @param contact: The contact that will be mapped to an account
    * @return Account: The mapped account
    */ 
    /*private static Account mapContactToAccount(Contact contact, String cif){
        Account account = new Account();
        account.CIF__c = cif;
        account.ID_Number__pc = contact.ID_Number__c;
        account.Initials__pc = contact.Initials__c;
        account.LastName = contact.LastName;
        account.ShippingStreet = contact.OtherStreet;
        account.ShippingCity = contact.OtherCity;
        account.FirstName = contact.FirstName;
        account.PersonHomePhone = contact.HomePhone;
        account.Phone = contact.Phone;
        account.PersonMobilePhone  = contact.MobilePhone;
        account.PersonBirthdate = contact.Birthdate;
        account.Income_Source__pc = contact.Income_Source__c;
        account.Income_Tax_Number__pc = contact.Income_Tax_Number__c;
        account.Nationality__pc = contact.Nationality__c;
        account.Country_of_Residence__pc = contact.Country_of_Residence__c;
        account.Country_of_Birth__pc = contact.Country_of_Birth__c;
        account.Occupation_Status__pc = contact.Occupation_Status__c;
        account.Occupation__pc = contact.Occupation__c; 
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        
        return account;
    }*/
    
    public class GIPResponse {
        public String response;
        public Id accountId;
    }
}