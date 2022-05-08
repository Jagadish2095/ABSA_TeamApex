/**
* Controller for CASA Screening Lightning component
* @author  Kyle Alexander
* @created 2018-09-26
*/
public class CasaScreeningController {

    private static Map <String, Schema.RecordTypeInfo> opportunityRecordTypesMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();

    /**
     * Method that gets a an account from an opportunity
     *
     * @param oppId - opportunity Id  
     * @return Account - specific account related to opportunity
     */
    @AuraEnabled
    public static Account getAccountData(Id oppId) {
        System.debug('** getAccountData method');
        Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        String recordType = getAccountRecordType(oppId);
        
        List<Account> accounts;
        if(recordType == 'Business Client' || recordType == 'Business Prospect'){
        	accounts = new AccountsSelector().selectCasaFieldsJointAccountById(opportunity.AccountId, 1);
        }
        else if(recordType == 'Individual Client' || recordType == 'Individual Prospect'){
        	accounts = new AccountsSelector().selectCasaFieldsById(opportunity.AccountId, 1);
        }
        
        return accounts.get(0);
    }
    
     /**
     * Method that gets the related party accounts from an account for the opportunity
     *
     * @param oppId - opportunity Id  
     * @return List of Accounts - specific accounts related to the main joit account of the opportunity
     */
    @AuraEnabled
    public static List<Account> getPartcicpantAccountData(Id oppId) {
        System.debug('** getPartcicpantAccountData method');
        Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        String recordType = getAccountRecordType(oppId);
        
        List<AccountContactRelation> acrList = [SELECT AccountId, ContactId FROM AccountContactRelation WHERE AccountId =: opportunity.AccountId];
        System.debug('** acrList: ' + acrList.size());
        
        Set<Id> relatedPartIdSet = new Set<Id>();
        for(AccountContactRelation acr : acrList){
            relatedPartIdSet.add(acr.ContactId);
        }
        
        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
        System.debug('** rpAccounts: ' + rpAccounts.size());
    
        return rpAccounts;
    }
    
    /**
     * Method that checks if CASA has been done on init
     *
     * @param oppId - opportunity Id
     * @return String - the risk status i.e. valid, invalid etc.
     */
    @AuraEnabled
    public static String checkInitValidity(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        return opportunities.get(0).CASA_Status__c;
    }
    
    /**
     * Method that checks what the CASA status is and if Pending then show refresh button
     *
     * @param oppId - opportunity Id
     * @return String - the risk status i.e. valid, invalid etc.
     */
    @AuraEnabled
    public static String getCasaStatus(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        
        if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
            return accounts.get(0).CASA_Screening_Status__c;
        }
        else{
            return accounts.get(0).CASA_Screening_Status__pc;
        }
    }
    
    /**
     * Method that calls the refresh casa status service if the previous status was pending approval
     *
     * @param oppId - opportunity Id
     * @return String - the risk status i.e. valid, invalid etc.
     */
    @AuraEnabled
    public static String refreshCasaStatus(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        
        if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
            
            List<Account> participants = new AccountContactRelationSelector().selectListByAccId(opportunities.get(0).AccountId);
            List<String> participantStatuses = new List<String>();
            
            for(Account participant : participants){
                GetCasaDetailsByRef_Resp_IB_v1 resp = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef(participant.CASA_Reference_Number__pc, '', false);
                if(resp.statusCode == 200 && resp.msgNo == '0'){
                	participant.CASA_Screening_Status__pc = resp.casaStatus;
                    participantStatuses.add(resp.casaStatus);
                }
                else{
                    if(resp.message != null || resp.message != ''){
                        return 'Error: ' + resp.message;
                    }
                    else{
                        return 'Error: An unknown error has occured please contact a system administrator';
                    }
                } 
            }
            update participants;
            
            String relPartyStatus = 'Approved';
            for(String status : participantStatuses){
                if(status != 'Approved'){
                    relPartyStatus = status;
                    break;
                }
            }
            
            accounts.get(0).CASA_Screening_Status__c = relPartyStatus;
            update accounts;
            
            return 'Success';
        }
        else{
            GetCasaDetailsByRef_Resp_IB_v1 resp = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef(accounts.get(0).CASA_Reference_Number__pc, '');
            if(resp.statusCode == 200 && resp.msgNo == '0'){
                accounts.get(0).CASA_Screening_Status__pc = resp.casaStatus;
                
                update accounts.get(0);
                
                return 'Success';
            }
            else{
                if(resp.message != null || resp.message != ''){
                    return 'Error: ' + resp.message;
                }
                else{
                    return 'Error: An unknown error has occured please contact a system administrator';
                }
            } 
        }
    }
    
    /**
     * Method that checks what the Account record type is
     *
     * @param oppId - opportunity Id
     * @return String - account record type i.e. Individual/Business client
     */
    @AuraEnabled
    public static String getAccountRecordType(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        if(accounts.get(0).RecordType.Name != null){
            return accounts.get(0).RecordType.Name;
        }
        
        return null;
    }
    
     /**
     * Method that updates the account and does callout to CASA service 
     *
     * @param oppId - opportunity Id
     * @return Account - updated account
     */
    @AuraEnabled
    public static String updateAccountAndDoCasaScreening(Id oppId, Account updatedAccount) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
        
        //sbu: '102 - Wills; '061 - EPP'     
        //branch: '3232' - Wills; '7128' - EPP;
        String sbu = '102'; 
        String branch = '3232';
        if(opportunities.get(0).RecordType.Name == 'Virtual Advisor'){
            sbu = '061';
            branch = '7128';
        }
        else if(opportunities.get(0).RecordType.Name == 'Wills'){
            sbu = '102';
            branch = '3232';
        }
        
        List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        System.debug(accounts.get(0).RecordType.Name);
        
        //Get CASA version 
        String version = getCasaVersion();
            
        if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
            
            //List<Contact> contacts = [SELECT FirstName, LastName, ID_Type__c, ID_Number__c, Birthdate, Nationality__c, Country_of_Residence__c, Country_of_Birth__c FROM Contact WHERE AccountId = :accounts.get(0).Id];
           	//List<Contact> contacts = new AccountContactRelationSelector().selectListByAccId(accounts.get(0).Id);
            List<Account> participantAccounts = new AccountContactRelationSelector().selectListByAccId(accounts.get(0).Id);
            
            if(participantAccounts.size() < 1){
                return 'Error: There are no related contacts added for this Joint Account - please amend before continuing!';
            }
            
            String errorMessage = 'The following related contacts have missing data required for CASA Screening!';
            Boolean isMissingData = false;
            for(Account a : participantAccounts){
                errorMessage += '\r\n' + a.FirstName + ' ' + a.LastName + ':';
                if(a.FirstName == null){
                    isMissingData = true;
                    errorMessage += 'First Name;';
                }
                if(a.LastName == null){
                    isMissingData = true;
                    errorMessage += 'Last Name;';
                }
                if(a.ID_Type__pc == null){
                    isMissingData = true;
                    errorMessage += 'ID Type;';
                }
                if(a.ID_Number__pc == null){
                    isMissingData = true;
                    errorMessage += 'ID Number;';
                }
                if(a.PersonBirthdate == null){
                    isMissingData = true;
                    errorMessage += 'Birth Date;';
                }
                if(a.Nationality__pc == null){
                    isMissingData = true;
                    errorMessage += 'Nationality;';
                }
                if(a.Country_of_Residence__pc == null){
                    isMissingData = true;
                    errorMessage += 'Country of Residence;';
                } 
                if(a.Country_of_Birth__pc == null){
                    isMissingData = true;
                    errorMessage += 'Country of Birth;';
                }
            }
            
            if(!isMissingData){  
                
                if(version == 'Version 7'){
                    CASAPrimaryClientScreening_IH_v2.cls_jointScreening casaScreening = new CASAPrimaryClientScreening_IH_v2.cls_jointScreening();
                    casaScreening = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreeningJointClient(updatedAccount, participantAccounts, users.get(0).Id, 'F2F3', sbu, branch); 
                    System.debug(casaScreening);
                    if(casaScreening.primaryScreening.statusCode == 200 && casaScreening.primaryScreening.msgNo == '0'){
                        
                        List<Account> relatedAccountsForUpdate = new List<Account>();
                        List<String> casaStatuses = new List<String>();
                        
                        String relPartyStatus = 'Approved';
                        
                        if(casaScreening.relatedPartyScreening != null){
                            
                            //For each related party
                            for(CASAScreenRelatedParty_Resp_IB_v1 rp : casaScreening.relatedPartyScreening){
                                System.debug('rp:' + rp);
                                if(rp.statusCode == 200 && rp.msgNo == '0'){
                                    Account a = new Account();
                                    a.CASA_Reference_Number__pc = rp.refNo;
                                    a.CASA_Screening_Date__pc = Date.today();
                                    a.CASA_Screening_Status__pc = rp.respStatus;
                                    a.Id = rp.relatedPartySfId;
                                    relatedAccountsForUpdate.add(a);
                                    casaStatuses.add(rp.respStatus);
                                }
                                else{
                                    if(rp.msg != null){
                                        return 'Error - Contact: ' + rp.relatedPartyName + ' - ' + rp.msg;
                                    }
                                    else if(rp.Fault != null){
                                        return 'Error - Contact:' + rp.relatedPartyName + ' - ' + rp.Fault.faultstring;
                                    }
                                    else{
                                        return 'Error: An unknow error has occured';
                                    }
                                } 
                            }
                            
                            for(String status : casaStatuses){
                                if(status != 'Approved'){
                                    relPartyStatus = status;
                                    break;
                                }
                            }
                        }
                        else{
                            relPartyStatus = casaScreening.primaryScreening.casaStatus;
                        }
                        
                        //Update Joint Account
                        updatedAccount.CASA_Reference_Number__c = casaScreening.primaryScreening.refNo;
                        updatedAccount.CASA_Screening_Date__c = Date.today();
                        updatedAccount.CASA_Screening_Status__c = relPartyStatus;
                        //updatedAccount.CASA_Screening_Status__c = casaScreening.primaryScreening.casaStatus;
                        
                        update updatedAccount;
                        
                        opportunities.get(0).CASA_Status__c = 'Valid';
                        if (opportunities.get(0).RecordTypeId != opportunityRecordTypesMap.get('Wills').getRecordTypeId()) {
                            opportunities.get(0).StageName = 'Proposal';
                        }
                        
                        update opportunities;
                        
                        //Update Participants(Contacts)
                        update relatedAccountsForUpdate;
                        
                        return 'Success';
                    }
                    else{
                        if(casaScreening.primaryScreening.msg != null){
                            return 'Error: ' + casaScreening.primaryScreening.msg;
                        }
                        else if(casaScreening.primaryScreening.Fault != null){
                            return 'Error: ' + casaScreening.primaryScreening.Fault.faultstring;
                        }
                        else if(casaScreening.primaryScreening.message != ''){
                            return 'Error: ' + casaScreening.primaryScreening.message;
                        }
                        else{
                            return 'Error: An unknow error has occured';
                        }
                    } 
                }
                else if(version == 'Version 6'){
                    CASAPrimaryClientScreening_IH_v1.cls_jointScreening casaScreening = new CASAPrimaryClientScreening_IH_v1.cls_jointScreening();
                    casaScreening = CASAPrimaryClientScreening_IH_v1.casaPrimaryClientScreeningJointClient(updatedAccount, participantAccounts, users.get(0).Id);
                   
                    if(casaScreening.primaryScreening.statusCode == 200 && casaScreening.primaryScreening.msgNo == '0'){
                        
                        List<Account> relatedAccountsForUpdate = new List<Account>();
                        if(casaScreening.relatedPartyScreening != null){
                            //For each related party
                            for(CASAScreenRelatedParty_Resp_IB_v2 rp : casaScreening.relatedPartyScreening){
                                System.debug('rp:' + rp);
                                if(rp.statusCode == 200 && rp.msgNo == '0'){
                                    Account a = new Account();
                                    a.CASA_Reference_Number__pc = rp.refNo;
                                    a.CASA_Screening_Date__pc = Date.today();
                                    a.CASA_Screening_Status__pc = rp.respStatus;
                                    a.Id = rp.relatedPartySfId;
                                    relatedAccountsForUpdate.add(a);
                                }
                                else{
                                    if(rp.msg != null){
                                        return 'Error - Contact: ' + rp.relatedPartyName + ' - ' + rp.msg;
                                    }
                                    else if(rp.Fault != null){
                                        return 'Error - Contact:' + rp.relatedPartyName + ' - ' + rp.Fault.faultstring;
                                    }
                                    else{
                                        return 'Error: An unknown error has occured';
                                    }
                                } 
                            }
                        }
                        
                        //Update Joint Account
                        updatedAccount.CASA_Reference_Number__c = casaScreening.primaryScreening.refNo;
                        updatedAccount.CASA_Screening_Date__c = Date.today();
                        updatedAccount.CASA_Screening_Status__c = casaScreening.primaryScreening.status;
                        
                        update updatedAccount;
                        
                        opportunities.get(0).CASA_Status__c = 'Valid';
                        if (opportunities.get(0).RecordTypeId != opportunityRecordTypesMap.get('Wills').getRecordTypeId()) {
                            opportunities.get(0).StageName = 'Proposal';
                        }
                        
                        update opportunities;
                        
                        //Update Participants(Contacts)
                        update relatedAccountsForUpdate;
                        
                        return 'Success';
                    }
                    else{
                        if(casaScreening.primaryScreening.msg != null){
                            return 'Error: ' + casaScreening.primaryScreening.msg;
                        }
                        else if(casaScreening.primaryScreening.Fault != null){
                            return 'Error: ' + casaScreening.primaryScreening.Fault.faultstring;
                        }
                        else{
                            return 'Error: An unknown error has occured';
                        }
                    } 
                }
            }
            else{
                return 'Error: ' + errorMessage;
            }
        }
        else if(accounts.get(0).RecordType.Name == 'Individual Client' || accounts.get(0).RecordType.Name == 'Individual Prospect'){
            
            if(version == 'Version 7'){
                CASAPrimaryClientScreening_Resp_IB_v2 casaScreening = new CASAPrimaryClientScreening_Resp_IB_v2();
                casaScreening = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreening(updatedAccount, users.get(0).Id, 'F2F3', sbu, branch);
                
                System.debug(casaScreening);
                
                if(casaScreening.statusCode == 200 && casaScreening.msgNo == '0'){
                    updatedAccount.CASA_Reference_Number__pc = casaScreening.refNo;
                    updatedAccount.CASA_Screening_Date__pc = Date.today();
                    updatedAccount.CASA_Screening_Status__pc = casaScreening.casaStatus;
                    
                    update updatedAccount;
                    
                    opportunities.get(0).CASA_Status__c = 'Valid';
                    if (opportunities.get(0).RecordTypeId != opportunityRecordTypesMap.get('Wills').getRecordTypeId()) {
                        opportunities.get(0).StageName = 'Proposal';
                    }
                    
                    update opportunities;
                    
                    return 'Success';
                }
                else{
                    if(casaScreening.msg != null){
                        return 'Error: ' + casaScreening.msg;
                    }
                    else if(casaScreening.Fault != null){
                        return 'Error: ' + casaScreening.Fault.faultstring;
                    }
                    else if(casaScreening.message != ''){
                        return 'Error: ' + casaScreening.message;
                    }
                    else{
                        return 'Error: An unknown error has occured';
                    }
                } 
            }
            else if(version == 'Version 6'){
                CASAPrimaryClientScreening_Resp_IB_v1 casaScreening = new CASAPrimaryClientScreening_Resp_IB_v1();
                casaScreening = CASAPrimaryClientScreening_IH_v1.casaPrimaryClientScreening(updatedAccount, users.get(0).Id);
                
                System.debug(casaScreening);
                
                if(casaScreening.statusCode == 200 && casaScreening.msgNo == '0'){
                    updatedAccount.CASA_Reference_Number__pc = casaScreening.refNo;
                    updatedAccount.CASA_Screening_Date__pc = Date.today();
                    updatedAccount.CASA_Screening_Status__pc = casaScreening.status;
                    
                    update updatedAccount;
                    
                    opportunities.get(0).CASA_Status__c = 'Valid';
                    if (opportunities.get(0).RecordTypeId != opportunityRecordTypesMap.get('Wills').getRecordTypeId()) {
                        opportunities.get(0).StageName = 'Proposal';
                    }
                    
                    update opportunities;
                    
                    return 'Success';
                }
                else{
                    if(casaScreening.msg != null){
                        return 'Error: ' + casaScreening.msg;
                    }
                    else if(casaScreening.Fault != null){
                        return 'Error: ' + casaScreening.Fault.faultstring;
                    }
                    else{
                        return 'Error: An unknown error has occured';
                    }
                } 
            }
        }
        return null;
    }
    
    /**
     * Method that checks if all CASA fields are valid does callout to CASA service 
     * This can be done as soon as Siebel creates an opportunity
     *
     * @param oppId - opportunity Id
     * @return Account - updated account
     */
    public static Boolean checkCasaFieldsAndDoCasaScreening(Id oppId){
        
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);

        //sbu: '102 - Wills; '061 - EPP'     
        //branch: '3232' - Wills; '7128' - EPP;
        String sbu = '102'; 
        String branch = '3232';
        if(opportunities.get(0).RecordType.Name == 'Virtual Advisor'){
            sbu = '061';
            branch = '7128';
        }
        else if(opportunities.get(0).RecordType.Name == 'Wills'){
            sbu = '102';
            branch = '3232';
        }
        
        if(!opportunities.isEmpty()){
            List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
            
            //Check that all required CASA fields are retrieved and do CASA screening
            if(accounts.get(0).FirstName != null && accounts.get(0).LastName != null && accounts.get(0).ID_Type__pc != null && 
               accounts.get(0).ID_Number__pc != null && accounts.get(0).Client_Type__c != null && accounts.get(0).PersonBirthdate != null && 
               accounts.get(0).Nationality__pc != null && accounts.get(0).Country_of_Residence__pc != null && accounts.get(0).Country_of_Birth__pc != null){
                   
                   //Get CASA version 
                   String version = getCasaVersion();
                   if(version == 'Version 7'){
                       CASAPrimaryClientScreening_Resp_IB_v2 casaScreening = new CASAPrimaryClientScreening_Resp_IB_v2();
                       casaScreening = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreening(accounts.get(0), users.get(0).Id, 'F2F3', sbu, branch);
                       
                       System.debug('checkCasaFieldsAndDoCasaScreening' + casaScreening);
                       
                       if(casaScreening.statusCode == 200 && casaScreening.msgNo == '0'){
                           accounts.get(0).CASA_Reference_Number__pc = casaScreening.refNo;
                           accounts.get(0).CASA_Screening_Date__pc = Date.today();
                           accounts.get(0).CASA_Screening_Status__pc = casaScreening.casaStatus;
                           
                           update accounts;
                           
                           opportunities.get(0).CASA_Status__c = 'Valid';
                           if (opportunities.get(0).RecordTypeId != opportunityRecordTypesMap.get('Wills').getRecordTypeId()) {
                               opportunities.get(0).StageName = 'Proposal';
                           }
                           
                           update opportunities;
                           
                           return true;
                       }
                   }
                   else if(version == 'Version 6'){
                       CASAPrimaryClientScreening_Resp_IB_v1 casaScreening = new CASAPrimaryClientScreening_Resp_IB_v1();
                       casaScreening = CASAPrimaryClientScreening_IH_v1.casaPrimaryClientScreening(accounts.get(0), users.get(0).Id);
                       
                       System.debug('checkCasaFieldsAndDoCasaScreening' + casaScreening);
                       
                       if(casaScreening.statusCode == 200 && casaScreening.msgNo == '0'){
                           accounts.get(0).CASA_Reference_Number__pc = casaScreening.refNo;
                           accounts.get(0).CASA_Screening_Date__pc = Date.today();
                           accounts.get(0).CASA_Screening_Status__pc = casaScreening.status;
                           
                           update accounts;
                           
                           opportunities.get(0).CASA_Status__c = 'Valid';
                           if (opportunities.get(0).RecordTypeId != opportunityRecordTypesMap.get('Wills').getRecordTypeId()) {
                               opportunities.get(0).StageName = 'Proposal';
                           }
                           
                           update opportunities;
                           
                           return true;
                       }
                   }
               }
        }
        return false;
    }
    
    /**
     * Method that gets all picklist data
     *
     * @param objObject - Id of the specific opportunity party being removed
     * @param fld - field name i.e. Clause_Name__c
     */
    @AuraEnabled 
    public static List <String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String> ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        //allOpts.sort();
        return allOpts;
    }
    
    private static String getCasaVersion() {   
        //Get Vesrion from Custom Setting
        CASA_Version__c casaVersion = CASA_Version__c.getOrgDefaults();
        String version = 'Version 7';
        if(casaVersion.Value__c != null) {
            version = casaVersion.Value__c;
        }

        return version;
    } 
    
}