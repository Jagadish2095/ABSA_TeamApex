/**
 * @description       :
 * @author            : muvhuso.nekhubvi@absa.africa
 * @group             :
 * @last modified on  : 2021-11-04
 * @last modified by  : sive.kula@absa.africa
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   05-15-2021   muvhuso.nekhubvi@absa.africa   Initial Version
 * 1.0   2021-07-23   PaulJohn.duRand@absa.africa    Added SearchTypeFilter
 * 1.0   2021-10-4    Gupta.Amit@absa.africa         Added Get Record Type By Service Type Method
**/

/**
/**
* @description Apex extension class for the lightning Client Finder
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2018-08-07
*
**/
public class ClientFinderExt extends ClientFinderBase {

    public static List<Account> accountsList = new List<Account>();

/**
* @description Set values used for search type
*
* @param  serviceTypeName
* @return List<String>
*/
    @AuraEnabled
    public static List<String> loadSearchOptions(string serviceTypeName)
    {
        List<String> options = new  List<String>();
        String searchLabel = 'Search Salesforce';

        //Get Salesforce Search Label from Custom Setting
        Client_Finder_Search_Attempts__c salesforceSearch = Client_Finder_Search_Attempts__c.getOrgDefaults();

        //Get Salesforce Search Label based on logged in User Profile
        Client_Finder_Search_Attempts__c salesforceSearchForProfile = Client_Finder_Search_Attempts__c.getInstance(userinfo.getProfileId());

        //Check to see if there is a limit based on Profile, then take that label, else take the org default label
        if(salesforceSearchForProfile.Salesforce_Search_Label__c != null) {
            searchLabel = salesforceSearchForProfile.Salesforce_Search_Label__c;
        }else if(salesforceSearch.Salesforce_Search_Label__c != null) {
            searchLabel = salesforceSearch.Salesforce_Search_Label__c;
        }
        options.add(searchLabel);
        List<String> arrSearchTypes = new List<String>();
        List <Client_Finder_Search_Types__mdt> mdt = [ Select  Search_Types__c From Client_Finder_Search_Types__mdt where Label  = :serviceTypeName];
        if(mdt.size() > 0){
           String strSearchTypes = mdt[0].Search_Types__c;
           arrSearchTypes = strSearchTypes.split(';');
           options.addAll(arrSearchTypes);
        }
        else{
        options.add('CIF No');
        options.add('Account Number');
        options.add('Reg. No / Passport');
        options.add('ID Number');
        options.add('Name');
    }

        return options;
    }

/**
* @description Get Client record type by Name
*
* @param  recordTypeName
* @return String
*/
    @AuraEnabled
    public static String getClientRecordTypeByName(String recordTypeName){

        String accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        return accountRecordTypeId;
    }

/**
* @description Search Client in Salesforce based on Name
*
* @param  searchType
* @param  searchValue
* @param  newAccountId
* @param  clientAdapt360BeanText
* @param  clientMDMBeanText
* @return List<Account>
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<Account> searchClientLogic(String searchType, String searchValue, String newAccountId, String clientAdapt360BeanText, String clientMDMBeanText) {

        //Generate adapt360 Bean and popluate adapt360ClientList
        List<Account> adapt360ClientList = new List<Account>();
        Account mdmClient = new Account();
        System.debug('PJAIN: 1: ' + clientAdapt360BeanText);
        System.debug('PJAIN: 2: ' + clientMDMBeanText);
        System.debug(LoggingLevel.Finest,'####searchType : ' + searchType);
        System.debug(LoggingLevel.Finest,'####searchValue : ' + searchValue);

        List<Account> sfAccountsList = new List<Account>();
        String searchTypeForCIF;
        Set<Id> accountIds = new Set<Id>();
        Set<String> cifNoSet = new Set<String>();

        Map<String, Account> cifAndSfAccountsMap = new Map<String, Account>();

        String searchLabel = 'Search Salesforce';

        //Get Salesforce Search Label from Custom Setting
        Client_Finder_Search_Attempts__c salesforceSearch = Client_Finder_Search_Attempts__c.getOrgDefaults();

        //Get Salesforce Search Label based on logged in User Profile
        Client_Finder_Search_Attempts__c salesforceSearchForProfile = Client_Finder_Search_Attempts__c.getInstance(userinfo.getProfileId());

        //Check to see if there is a limit based on Profile, then take that label, else take the org default label
        if(salesforceSearchForProfile.Salesforce_Search_Label__c != null) {
            searchLabel = salesforceSearchForProfile.Salesforce_Search_Label__c;
        }else if(salesforceSearch.Salesforce_Search_Label__c != null) {
            searchLabel = salesforceSearch.Salesforce_Search_Label__c;
        }

        if(searchType != null && newAccountId == null) {
            if(searchType == searchLabel){
                //Salesforce only search
                accountsList = searchSalesforceAccountsByValue(searchValue);

                for(Account eachClient : accountsList) {
                    eachClient.Source__c = 'SF';
                }

            } else {
                //Call method to get Client from MDM
                if (clientMDMBeanText != null) {
                    mdmClient = generateMDMClientInfo(clientMDMBeanText);
                }


                //Loop over CIF Client List and add to Map
                if (clientAdapt360BeanText != null) {
                    adapt360ClientList = generateBeanClientAccountInfo(clientAdapt360BeanText);
                }

                if(adapt360ClientList != null && adapt360ClientList.size() > 0) {
                    for(Account eachCifClient :  adapt360ClientList) {
                        //Add CIF number to Set
                        cifNoSet.add(eachCifClient.CIF__c);

                        //Check if Client exist in MDM
                        if(mdmClient != null && mdmClient.CIF__c != null && mdmClient.CIF__c == eachCifClient.CIF__c) {
                            eachCifClient = mdmClient;
                            eachCifClient.Source__c = 'CIF + MDM';
                        }
                        //If not in MDM set source as CIF
                        else {
                            eachCifClient.Source__c = 'CIF';
                        }

                        cifAndSfAccountsMap.put(searchValue + '###' + eachCifClient.CIF__c, eachCifClient);
                    }
                }
                //Client found in MDM but not in CIF
                else {
                    if(mdmClient != null && mdmClient.CIF__c != null) {
                        cifAndSfAccountsMap.put(searchValue + '###' + mdmClient.CIF__c, mdmClient);
                    }
                }

                //Search in SF if Client exist based on CIF
                if (cifNoSet.size() > 0) {
                    sfAccountsList = new AccountsSelector().selectByCIF(cifNoSet, 1000);
                }

                //Loop over Salesforce Account list to set Source
                System.debug(LoggingLevel.Finest,'###sfAccountsList : ' + sfAccountsList);
                if(sfAccountsList.size() > 0) {
                    for(Account eachSfClient :  sfAccountsList) {
                        if(cifAndSfAccountsMap.containskey(searchValue + '###' + eachSfClient.CIF__c)) {
                            String sourchIndicator = cifAndSfAccountsMap.get(searchValue + '###' + eachSfClient.CIF__c).Source__c;
                            cifAndSfAccountsMap.get(searchValue + '###' + eachSfClient.CIF__c).Source__c = sourchIndicator + ' + SF';
                            cifAndSfAccountsMap.get(searchValue + '###' + eachSfClient.CIF__c).Id = eachSfClient.Id;
                        }
                        //Set source indicator as SF for Salesforce
                        else
                        {
                            cifAndSfAccountsMap.put(searchValue + '###' + eachSfClient.CIF__c, eachSfClient);
                            cifAndSfAccountsMap.get(searchValue + '###' + eachSfClient.CIF__c).Source__c = 'SF';
                        }
                    }
                }

                //Loop over Map and add Accounts to List
                for(String eachKey : cifAndSfAccountsMap.keySet()) {
                    accountsList.add(cifAndSfAccountsMap.get(eachKey));
                }

            }
        }else if (newAccountId != null) {
            accountIds.add(newAccountId);
            accountsList = new AccountsSelector().selectById(accountIds, 1);
        }

        if(accountsList != null && !accountsList.isEmpty()) {
            System.debug(LoggingLevel.Finest,'###accountsList : ' + accountsList);
            return accountsList;
        }
        else {
            return null;
        }
    }

    /**
* @@description Create new Client in Salesforce
*
* @param  newAccountRecord
* @param  isIndividualProspect
* @param  isRelatedParty
* @param  addressRec
* @return String
*/
@SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String createNewClient(Account newAccountRecord, Boolean isIndividualProspect, Boolean isRelatedParty, Address__c addressRec){
        map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        String accountId = null;

        try{
            if(newAccountRecord != null){
                //Assign recordType as Prospect
                //Set RecordType as Individual Prospect
                if(isIndividualProspect == true || isRelatedParty == true) {
                    newAccountRecord.RecordTypeId = accountRecordTypeMap.get('Individual_Prospect').getRecordTypeId();
                    newAccountRecord.Client_Group__c = 'Individual';
                    newAccountRecord.Client_Type__c = 'Individual';
                    //newAccountRecord.Client_Type__c = 'Private Individual';
                }
                //Set Record Type as Business Prospect
                else
                {
                    newAccountRecord.RecordTypeId = accountRecordTypeMap.get('Prospect').getRecordTypeId();
                    //newAccountRecord.Client_Type__c = 'Business';
                }

                newAccountRecord.Source__c = 'SF';

                if(addressRec != null) {
                    newAccountRecord.BillingStreet = addressRec.Shipping_Street__c;
                    newAccountRecord.BillingCity = addressRec.Shipping_City__c;
                    newAccountRecord.BillingState = addressRec.Shipping_Suburb__c;
                    newAccountRecord.BillingCountry = addressRec.Shipping_Country__c;
                    newAccountRecord.BillingPostalCode = addressRec.Shipping_Zip_Postal_Code__c;
                }

                //Create Client
                insert newAccountRecord;

                accountId =  newAccountRecord.id;

                //Created Address related record
                if(addressRec != null) {
                    addressRec.Address1__c = addressRec.Shipping_Street__c;
                    addressRec.Address2__c = addressRec.Shipping_Street_2__c;
                    addressRec.Address3__c = addressRec.Shipping_Suburb__c;
                    addressRec.Address4__c = addressRec.Shipping_City__c;
                    addressRec.Address5__c = addressRec.Shipping_Zip_Postal_Code__c;
                    addressRec.Address_Type__c = 'Residential';
                    addressRec.Account__c = accountId;

                    if(isIndividualProspect == true || isRelatedParty == true) {
                        Set<Id> accIds = new Set<Id>();
                        accIds.add(accountId);
                        List<Account> personAccount = new AccountsSelector().selectById(accIds, 1);
                        addressRec.Contact__c = personAccount[0].PersonContactId;
                    }

                    upsert addressRec;
                }
            }
            return accountId;

        }catch(DmlException ex){
            System.debug('Exception : ClientFinderExt : createNewClient - ' + ex.getMessage() + EX.getLineNumber());

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
            System.debug('Exception : ClientFinderExt : createNewClient - ' + ex.getMessage() + ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
* @description Increment Client search number to determine when to display the create new Client links
*
* @param  counter
* @return Integer
*/
    @AuraEnabled
    public static Integer incrementCount(Integer counter) {
        return counter;
    }

    /**
* @description Get the Client search limit from the custom setting
*
* @param  counter
* @return Integer
*/
    @AuraEnabled
    public static Integer getSearchLimit(Integer counter) {
        //Get Search limit from Custom Setting
        Client_Finder_Search_Attempts__c searchAttempts = Client_Finder_Search_Attempts__c.getOrgDefaults();

        //Get Serach Limit based on logged in User Profile
        Client_Finder_Search_Attempts__c searchAttemptsForProfile = Client_Finder_Search_Attempts__c.getInstance(userinfo.getProfileId());
        Integer searchLimitInt = 1;

        //Check to see if there is a limit based on Profile, then take that limit, else take the org default limit
        if(searchAttemptsForProfile.Limit__c != null) {
            Decimal searchLimit = searchAttemptsForProfile.Limit__c;
            searchLimitInt = searchLimit.intValue();
        }else if(searchAttempts.Limit__c != null) {
            Decimal searchLimit = searchAttempts.Limit__c;
            searchLimitInt = searchLimit.intValue();
        }

        return searchLimitInt;
    }

    /**
* @description Get all Cases linked to Client in Salesforce
*
* @param  newAccountId
* @return List<Case>
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<Case> getCasesLinkedToClient(String newAccountId){

        System.debug(LoggingLevel.Finest,'####newAccountId : ' + newAccountId);

        List<Case> relatedCases = new List<Case>();

        List<Account> accountsList = new List<Account>();
        String searchTypeForCIF;
        Set<Id> accountIds = new Set<Id>();


        if(newAccountId != null) {
            accountIds.add(newAccountId);
            relatedCases = new casesSelector().selectByAccountId(accountIds,5);
        }
        System.debug(LoggingLevel.Finest,'####relatedCases : ' + relatedCases);

        return relatedCases;
    }

    
    /**
    * @description Get all Account linked to Client in Salesforce
    * Added by : Mariyappan to get the accounts
    * @param  accountId
    * @return List<Account>
    */
    @AuraEnabled
    public static List<Account> retriveAccountsById(String accountId) {
        return new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
    }

    /**
    * @description Get all Account linked to Client in Salesforce
    * Added by : Mariyappan to get the accounts
    * @param  accountId
    * @return List<Account>
    */
    @AuraEnabled
    public static List<Account> getGIResponseAccount(String cifKey, String accountIdNumber) {
        // List<Account> adapt360ClientList =  new List<Account>();
        // if (clientAdapt360BeanText != null) {
        //     adapt360ClientList =  generateJointParticipantBean(clientAdapt360BeanText);
        //     //adapt360ClientList = generateBeanClientAccountInfo(clientAdapt360BeanText);
        // }
        List<User> loggedInUserInfo = new UsersSelector().selectById( new Set<Id>{UserInfo.getUserId()});
        AccountCreate_CIF_MDM.GIPResponse resp = AccountCreate_CIF_MDM.createAccountFromCIF(cifKey, accountIdNumber, loggedInUserInfo[0].SiteCode__c);
        System.debug('**resp-'+resp);
        // return new AccountsSelector().selectById(new Set<Id>{resp.accountId}, 1);
        return new AccountsSelector().selectCasaFieldsJointAccountById(resp.accountId, 1);
    }

    /**
* @description Get all Contacts linked to Client in Salesforce
*
* @param  newAccountId
* @return List<Contact>
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<Contact> getContactsLinkedToClient(String newAccountId){

        System.debug(LoggingLevel.Finest,'####newAccountId : ' + newAccountId);

        List<Contact> relatedContacts = new List<Contact>();

        List<Account> accountsList = new List<Account>();
        String searchTypeForCIF;
        Set<Id> accountIds = new Set<Id>();


        if(newAccountId != null) {
            accountIds.add(newAccountId);
            relatedContacts = new contactsSelector().selectByAccountId(accountIds);
        }
        System.debug(LoggingLevel.Finest,'####relatedContacts : ' + relatedContacts);

        return relatedContacts;
    }

    /**
* @description newAccountId Get all Leads linked to Client in Salesforce
*
* @param  newAccountId
* @return List<Lead>
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<Lead> getLeadsLinkedToClient(String newAccountId){

        System.debug(LoggingLevel.Finest,'####newAccountId : ' + newAccountId);

        List<Lead> relatedLeads = new List<Lead>();

        List<Account> accountsList = new List<Account>();
        String searchTypeForCIF;
        Set<Id> accountIds = new Set<Id>();


        if(newAccountId != null) {
            accountIds.add(newAccountId);
            relatedLeads = new LeadsSelector().selectByAccountId(accountIds,5);
        }
        System.debug(LoggingLevel.Finest,'####relatedLeads : ' + relatedLeads);

        return relatedLeads;
    }

    /**
* @description Create new Account in Salesforce
*
* @param  newClientRecord
* @return Account
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static Account CreateNewBusinessClient(Account newClientRecord){
        Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        String accountId = null;
        System.debug(LoggingLevel.Finest,'###newClientRecord : ' + newClientRecord);

        try{
            if(newClientRecord != null){
                //Assign recordType as Client
                newClientRecord.recordTypeId = accountRecordTypeMap.get('Client').getRecordTypeId();


                if(newClientRecord.id == null) {
                    //Query to see if Client already exist in Salesforce
                    List<Account> relatedAcc = new AccountsSelector().selectByCIF(newClientRecord.CIF__c,1);

                    if(relatedAcc.size() > 0 && relatedAcc.size() < 2) {
                        //Use client found in Salesforce
                        newClientRecord = relatedAcc[0];
                    }
                    else if (relatedAcc.size() > 1)
                    {
                        System.debug(LoggingLevel.Finest,'Duplicate CIF number found - ' + newClientRecord.CIF__c);
                        throw new AuraHandledException('Duplicate CIF number found - ' + newClientRecord.CIF__c);
                    }
                }

                //Create Client
                upsert newClientRecord;

                accountId =  newClientRecord.id;
            }
            return newClientRecord;

        }catch(DmlException ex){
            System.debug(LoggingLevel.Finest,'Exception : ClientFinderExt : CreateNewBusinessClient - ' + ex.getMessage());

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
            System.debug(LoggingLevel.Finest,'Exception : ClientFinderExt : CreateNewBusinessClient - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }


    /**
* @description Create new Contact in Salesforce
*
* @param  newContactRecord
* @return Contact
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static Contact createNewBusinessContact(Contact newContactRecord){
        Map<String, Schema.RecordTypeInfo> contactRecordTypeMap = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        String contactId = null;

        System.debug(LoggingLevel.Finest,'###newContactRecord : ' + newContactRecord);

        try{
            if(newContactRecord != null){
                //Assign recordType as Contact
                newContactRecord.RecordTypeId = contactRecordTypeMap.get('Contact').getRecordTypeId();

                //Create Contact
                insert newContactRecord;

                contactId =  newContactRecord.id;
            }
            return newContactRecord;

        }catch(DmlException ex){
            System.debug(LoggingLevel.Finest,'Exception : ClientFinderExt : CreateNewBusinessContact - ' + ex.getMessage());

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
            System.debug(LoggingLevel.Finest,'Exception : ClientFinderExt : CreateNewBusinessContact - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /*Create custom SelectOption as the standard one is not supported with @AuraEnabled
*
* @param  Contact
* @return Contact Id
*/
    /*public class SelectOption {
public SelectOption(String value, String label) {
this.value = value;
this.label = label;
this.disabled = false;
this.escapeItem = false;
}

public SelectOption(String value, String label, Boolean isDisabled) {
this.value = value;
this.label = label;
this.disabled = isDisabled;
this.escapeItem = false;
}

@AuraEnabled
public String label { get;set; }
@AuraEnabled
public String value { get;set; }
@AuraEnabled
public Boolean disabled { get;set; }
@AuraEnabled
public Boolean escapeItem { get;set; }

}*/

    /**
* @description Method to get all the Fields in FieldSet to use as columns in DataTable
*
* @param  strObjectName
* @param  strFieldSetName
* @return List<DataTableColumns>
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<DataTableColumns> getClientResultTableFields(String strObjectName, String strFieldSetName){

        //Get the fields from FieldSet
        Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get(strObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(strFieldSetName);

        //To hold the table hearders
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();

        //Field to be queried - fetched from fieldset
        List<String> lstFieldsToQuery = new List<String>();

        for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() ){
            String dataType = String.valueOf(eachFieldSetMember.getType()).toLowerCase();
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning:datatable component structure
            if(dataType == 'datetime'){
                dataType = 'date';
            }
            //Create a wrapper instance and store label, fieldname and type.
            DataTableColumns datacolumns = new DataTableColumns( String.valueOf(eachFieldSetMember.getLabel()) ,
                                                                String.valueOf(eachFieldSetMember.getFieldPath()),
                                                                String.valueOf(eachFieldSetMember.getType()).toLowerCase()
                                                               );
            lstDataColumns.add(datacolumns);
            lstFieldsToQuery.add(String.valueOf(eachFieldSetMember.getFieldPath()));
        }
        System.debug(LoggingLevel.Finest,'###lstDataColumns' + lstDataColumns);

        return lstDataColumns;
    }

    //Wrapper class to hold Columns with headers
       /**
* @description Wrapper class to hold Columns with headers
*
*/
    public class DataTableColumns {
         /**
* @description Wrapper class to hold Columns with headers
*
*/
        @AuraEnabled
        public String label {get;set;}
         /**
* @description Wrapper class to hold Columns with headers
*
*/
        @AuraEnabled
        public String fieldName {get;set;}
        @AuraEnabled

         /**
* @description Wrapper class to hold Columns with headers
*
*/
        public String type {get;set;}

        //Create and set three variables label, fieldname and type as required by the lightning:datatable
         /**
* @description Wrapper class to hold Columns with headers
* @param label
* @param fieldName
* @param type
*/
        public DataTableColumns(String label, String fieldName, String type){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
        }
    }

    /**
* @description This is a method to retrieve a serialized Adapt360 Client Profile Bean
*
* @param   searchType      The given search type
* @param   searchValue     The search input by the user
*
* @return  String          The serialized Client Profile Bean
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String getClientDetailsBean(String searchType, String searchValue) {

        String clientProfilesBean;
        String searchTypeForCIF;

        //Set search type
        if(searchType == 'CIF No') {
            searchTypeForCIF = 'cif';
        }  else if(searchType == 'Account Number') {
            searchTypeForCIF = 'accountNumber';
        }else if(searchType == 'Reg. No / Passport') {
            searchTypeForCIF = 'passport';
        } else if(searchType == 'ID Number') {
            searchTypeForCIF = 'identityDocument';
        }

        //get client and products from Adapt360
        clientProfilesBean = getAdapt360ClientBean(searchTypeForCIF,searchValue);

        System.debug(LoggingLevel.Finest,'###getClientDetailsBean - clientProfilesBean: ' + clientProfilesBean);

        if (clientProfilesBean != null) {
            return clientProfilesBean;
        } else {
            return null;
        }
    }

    /**
* @description This is a method to convert the Adapt360 client profiles bean text JSON to a list of account records
*
* @param clientProfilesBeanText
*
* @return  List<Account>   A list of account records
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<Account> generateBeanClientAccountInfo(String clientProfilesBeanText) {

        List<Account> accountListReturned = new List<Account>();
        accountListReturned = generateAdapt360ClientBean(clientProfilesBeanText);
        System.debug(LoggingLevel.Finest,'###accountListReturned : ' + accountListReturned);

        return accountListReturned;
    }

    /**
* @description This is a method to retrieve a serialized Client Participants Bean for Joint & Several Client Account Types
*
* @param   cifNumber      The given joint & several client account cif number
*
* @return  String          The serialized Client Participants Bean
*/
@SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String getParticipantsBean(String cifNumber) {

        String participantBean;

        try {

            participantBean = getJointParticipantsBean(cifNumber);

            if(participantBean != null) {
                return participantBean;
            } else {
                return null;
            }

        }catch(Exception ex){
            System.debug(LoggingLevel.Finest,'Exception : ClientFinderExt : getParticipantsBean - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
* @description This is a method to convert the client participants bean text JSON to a list of account records
*
* @param clientParticipantsBeanText
*
* @return  List<Account>   A list of account records
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<Account> generateBeanClientParticipantInfo(String clientParticipantsBeanText) {

        List<Account> participantListReturned = new List<Account>();
        List<Account> participantPartiesListReturned = new List<Account>();
        String involvedPartiesJSON ;

        participantListReturned = generateJointParticipantBean(clientParticipantsBeanText);

        for(Account eachParticipant : participantListReturned) {
            //Call getInvolvedParties to get additional information on Participant
            if(eachParticipant.ID_Number__pc != null) {
                involvedPartiesJSON = getInvolvedPartyClientBean('SAID', eachParticipant.ID_Number__pc);

                if(involvedPartiesJSON != null) {
                    Account accountReturned = new Account();
                    accountReturned = generateInvolvedPartyClientBean(involvedPartiesJSON);
                    accountReturned.Source__c = eachParticipant.Source__c + ' + ' + accountReturned.Source__c;

                    if(accountReturned != null) {
                        participantPartiesListReturned.add(accountReturned);
                    }
                }
                else {
                    participantPartiesListReturned.add(eachParticipant);
                }
            }
        }

        if(participantPartiesListReturned != null && participantPartiesListReturned.size() > 0) {
            System.debug(LoggingLevel.Finest,'###participantPartiesListReturned : ' + participantPartiesListReturned);
            return participantPartiesListReturned;
        } else {
            System.debug(LoggingLevel.Finest,'###participantListReturned : ' + participantListReturned);
            return participantListReturned;
        }
    }

    /**
* @description This is a method to convert the client profiles bean text JSON to a list of account records
*
* @param clientProfilesBeanText
*
* @return  Account  AccountRecord
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static Account generateMDMClientInfo(String clientProfilesBeanText) {

        Account accountReturned = new Account();
        accountReturned = generateInvolvedPartyClientBean(clientProfilesBeanText);
        System.debug(LoggingLevel.Finest,'###getMDMClientDetailsBean - MDM Client : ' + accountReturned);

        return accountReturned;
    }

    /**
* @description This is a method to retrieve a serialized MDM Client Profile Bean
*
* @param   searchType      The given search type
* @param   searchValue     The search input by the user
*
* @return  String          The serialized Client Profile Bean
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String getMDMClientDetailsBean(String searchType, String searchValue) {

        String clientProfilesBean;
        String searchTypeForCIF;

        //Set search type
        if(searchType == 'CIF No') {
            searchTypeForCIF = 'CIF';
        } else if(searchType == 'ID Number') {
            searchTypeForCIF = 'SAID';
        }

        if(searchTypeForCIF != null) {
            //Get client from MDM
            clientProfilesBean = getInvolvedPartyClientBean(searchTypeForCIF,searchValue);

            System.debug(LoggingLevel.Finest,'###getMDMClientDetailsBean - clientProfilesBean: ' + clientProfilesBean);
        }

        if (clientProfilesBean != null) {
            return clientProfilesBean;
        } else {
            return null;
        }
    }

    //Use @AuraEnabled to enable client- and server-side access to the method
    //create case
      /**
* @description Use @AuraEnabled to enable client- and server-side access to the method
*
* @param   accountId      The given search type
*
*
* @return  String          The serialized Client Profile Bean
*/
    @AuraEnabled
    public static String createCase(String accountId) {
        Case theCase = new Case();

        return null;
    }

	/**
	* @description Method to return the Record Type Id from the Record Type specified on the Service Type
	* @author Amit G. | 2021-10-04 
	* @param recordTypeName 
	* @param sobjectName 
	* @return String 
	**/
	@AuraEnabled
	public static String getRecordTypeIdFromServiceType(String recordTypeName, String sobjectName) {
	  String recordTypeId = '';
	  List<RecordType> newRecordTpeList = [SELECT Id, Name, DeveloperName, SobjectType
										   FROM RecordType
										   WHERE Name = :recordTypeName AND SobjectType = :sobjectName];
	  if (!newRecordTpeList.isEmpty()) {
		recordTypeId = newRecordTpeList[0].Id;
	  }
	  return recordTypeId;
	}
    
      /**
* @description Use @AuraEnabled to enable client- and server-side access to the method
*
* @param   developerName      The given search type
* @param   sobjectName
*
* @return  String          The serialized Client Profile Bean
*/
    @AuraEnabled
    public static String getRecordTypeId(String developerName, String sobjectName){
        String recordTypeId = '';
        List<RecordType> newRecordTpeList= [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE DeveloperName =: developerName AND SobjectType =: sobjectName];
        if(!newRecordTpeList.isEmpty()){
            recordTypeId = newRecordTpeList[0].Id;
        }
        return recordTypeId;
    }

    /**
* @description Creates the Account Contact relationship
* @param relAccId
* @param parentAccId
* @param roles
* @param sharePercentage
* @param designation
* @param ubo
* @param primaryEntityId
* @param parentRelationshipId
*
* */
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static void createRelationship(string relAccId, string parentAccId, string roles, decimal sharePercentage,string designation,String ubo,
                                          String primaryEntityId, String parentRelationshipId) {
        Type rolesList = Type.forName('List<string>');
        List<string> wrapperList = (List<string>) JSON.deserialize(roles, rolesList);
        List<Account> accnList = new AccountsSelector().selectCasaFieldsById(relAccId, 1);
        List<Account> parentAcc = new AccountsSelector().selectCasaFieldsById(parentAccId, 1);
        system.debug('accnList'+accnList);
        if(!accnList.isEmpty()) {
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = parentAccId;
            acr.ContactId = accnList.get(0).PersonContactId;
            string rolesInsert = '';
            for(string r : wrapperList) {
                rolesInsert = rolesInsert + r + ';';
            }

            rolesInsert = rolesInsert.substring(0, rolesInsert.length() - 1);
            acr.Roles = rolesInsert;
            // if(decimal.valueOf(sharePercentage) > 0) {
            acr.Share_Percentage__c = sharePercentage; //decimal.valueOf(sharePercentage);
            //} else {
            //  acr.Share_Percentage__c = 0;
            //}
            acr.Designation__c =designation;
            acr.Primary_Entity_Id__c = primaryEntityId;//Added by chandra against W-004945 dated 12/07/2020
            //acr.UBO__c = ubo; //commented by chandra since ubo decide on the basis of controlling percentage
            acr.ParentRelationshipId__c = parentRelationshipId;

            try {
                upsert acr;
                system.debug('acr'+acr);
                update parentAcc.get(0);
                system.debug('parentAcc.get(0)'+parentAcc.get(0));
               // AccountContactRelationController.calculateControllingPercentageVal(acr);//Added by chandra against W-004945 dated 15/07/2020
                //insert acr; //Commented by chandra against W-004945 dated 15/07/2020
                // OnboardingUBOListViewController.calculateControllingInterestAdditionAccCon(acr, null, primaryEntityId);
                //
                AccountContactRelationController.calculateControllingPercentageVal2(acr,primaryEntityId);

            }

            catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
    }

    /**
* @description Makes the callout to Hanis service
* @param idNumber
* @return String
* */
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String callHanisService(String idNumber){
        try{
            Map<HanisValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = HanisValidate_IH_v1.HanisValidate(idNumber);
            HanisValidate_Resp_IB_v1 responseBean = (new List<HanisValidate_Resp_IB_v1>(responseMap.keySet()))[0];
            List<Sys_Log_Integration__c> hanisLogs = responseMap.values()[0];
            System.debug('#####' + responseBean.serialize(responseBean) + '#####');
            if(hanisLogs!=null && !hanisLogs.isEmpty()){
                Insert hanisLogs;
            }
            return responseBean.serialize(responseBean);
        } catch(Exception exc){
            System.debug('Exception Occured'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ exc.getMessage());
            //return null;
        }
    }

    /**
* @description Makes the callout to CPB service
* @param idNumber
* @param lastName
* @return String
* */
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String callCPBService(String idNumber, String lastName){
        try{
            Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate(idNumber, lastName);
            CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
            List<Sys_Log_Integration__c> cpbLogs = responseMap.values()[0];
            System.debug('#####' + responseBean.serialize(responseBean) + '#####');
            if(cpbLogs!=null && !cpbLogs.isEmpty()){
                Insert cpbLogs;
            }
            return responseBean.serialize(responseBean);
        } catch(Exception exc){
            System.debug('Exception Occured'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ exc.getMessage());
            //return null;
        }
    }

    /**
* @description Method that gets all picklist data
*
* @param objObject - Id of the specific opportunity party being removed
* @param fld
* @return List <String> fld - field name i.e. Clause_Name__c
*/
    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String>();
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

      /**
* @description Method that gets all picklist data
*
*
* @param newAcc
* @return String
*/

    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String createCIFClientInSF(Account newAcc) {
        //System.debug('Client Type : ' + newAcc.Client_Type__C);
        //System.debug('newAcc ' + newAcc.RecordTypeId);
        String accountId;
        Account personAcc = new Account();
        map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        String siteCode;
        Set<Id> userIds = new Set<Id>();
        userIds.add(UserInfo.getUserId());
        List<User> loggedInUserInfo = new UsersSelector().selectById(userIds);
        siteCode = loggedInUserInfo[0].SiteCode__c;

        //TdB - Call CIGetClientDetailsCIF Service to populate fields for Onboarding Form
        AccountCreate_CIF_MDM.GIPResponse createdAccount = AccountCreate_CIF_MDM.createRBBAccountFromCIF(newAcc.CIF__c, '0', siteCode);
        System.debug('##createdAccount : ' + createdAccount);

        if(createdAccount.accountId != null) {
            accountId = 'Success:' + createdAccount.accountId;
        } else {
            accountId = 'Error: ' + createdAccount.response;
        }

        return accountId;
    }

    /**
* @description Method to Create Credit Product Opportunity
*
* @param accRecord
* @return String
*/
	@AuraEnabled
	public static String createNewCreditOpportunity(Account accRecord) {
	  String accountId = null;
		  String returnMessage = '';

	  //Create Client if Account Id is null
	  if (accRecord != null && accRecord.id == null) {
		accountId = createCIFClientInSF(accRecord).substring(8, 26);
	  }
	  else {
		accountId = accRecord.id;
	  }

	  if (accountId != null) {
		Date todaysDate = System.today();
		Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		User userRec = new UsersSelector().selectById(UserInfo.getUserId());
		List<Site__c> sitecodes;
		if (userRec.SiteCode__c != null) {
		  sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
		}
		else {
		  sitecodes = new List<Site__c>();
		}

		//Get Standard Pricebook Id
		PriceBook2 priceBookItem = new PriceBook2();
			  priceBookItem = [SELECT id FROM priceBook2 WHERE name = 'Standard Price Book'];

		//Saurabh : W:3780 Business Rules Validations
		//check for Business Rules before creating credit Opportunity and update Business_Rules_Decision__c
		string rulesEngineResult = businessRulesEngineHandler(accountId); // Saurabh : 20210103 unCommenting as the service is fine now

		//check for Client Type and Block it if its individual
			  Account accountRecord = [SELECT Id, Client_Type__c FROM Account WHERE id = :accountId];
		if (accountRecord ?.Client_Type__c == 'Individual') {
		  throw new AuraHandledException('Credit Opportunity can not be created for Individual Client Type');
		}
        //Saurabh : 20210414 adding a salesProcess linking to opp
        // with next enhancement we would use request name as a param from cmp and then we can create a common method to create all type of opp
        List<Sales_Process_Type__c> salesProcessList = new SalesProcessTypesSelector().selectByRequestName('New Credit Product (Business Banking)');
        if(!salesProcessList.isEmpty()){
        //Create Opportunity
		Opportunity onboardOpportunity = new Opportunity();
		onboardOpportunity.Name = 'Credit Onboarding';
		onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('Credit_Onboarding').getRecordTypeId();
		onboardOpportunity.AccountId = accountId;
		onboardOpportunity.StageName = 'Confirm Client Eligibility';
		onboardOpportunity.closeDate = todaysDate.addDays(7);
		onboardOpportunity.priceBook2Id = priceBookItem.id;
		onboardOpportunity.Business_Rules_Decision__c = rulesEngineResult;
        onboardOpportunity.Sales_Process_Type__c = salesProcessList[0].id; //Saurabh added lookup to Sales Process Type

        //Capturing Sitecode of loggedin User while creating opportunity if user has site code
		if (!sitecodes.isEmpty()) {
		  onboardOpportunity.Site__c = sitecodes[0].Id;
		}
		insert onboardOpportunity;
        //Creating Application Record
        Application__c application = new Application__c();
		application.Opportunity__c = onboardOpportunity.Id;
		INSERT application;
		returnMessage = onboardOpportunity.id;

		if(onboardOpportunity.Id!=Null){
			   AllocateStockNumberController.getEDFservice(returnMessage);//added by Gulafsha for Credit Onboarding
		 }}
          else{
           throw new AuraHandledException('Credit Opportunity can not be created as Sales Process Type is not defined ');
          }

		//return onboardOpportunity.id;

		/**
		 * E. MONGWE
		 * @date 2021-02-11
		 * UserStoty W-007585
		 */
		//HistoricalFinancialDataController.getHistoricalFianancialData(returnMessage);
        //Commenting this line since HistoricalFinancialDataController userstory is not complete
		return returnMessage;
	  }
	  else {
		return null;
	  }
	}

    /* Create Complex Credit Opportuinity */

    /**
	 * @description Method to Create Credit Product Opportunity
	 *
	 * @param accRecord
     * @return String
	 */
    @AuraEnabled
	public static String createNewComplexCreditOpportunity(Account accRecord) {
	  String accountId = null;
      String returnMessage = '';

	  //Create Client if Account Id is null
      if(accRecord != null && accRecord.id != null){
        accountId = accRecord.id;
      }
	  /* if (accRecord != null && accRecord.id == null) {
		//accountId = createCIFClientInSF(accRecord).substring(8, 26);
	  }
	  else {
		accountId = accRecord.id;
	  } */

	  if (accountId != null) {
		Date todaysDate = System.today();
		Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		User userRec = new UsersSelector().selectById(UserInfo.getUserId());
		List<Site__c> sitecodes;
		if (userRec.SiteCode__c != null) {
		  sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
		}
		else {
		  sitecodes = new List<Site__c>();
		}

		//Get Standard Pricebook Id
		PriceBook2 priceBookItem = new PriceBook2();
			  priceBookItem = [SELECT id FROM priceBook2 WHERE name = 'Standard Price Book'];

		//Saurabh : W:3780 Business Rules Validations
		//check for Business Rules before creating credit Opportunity and update Business_Rules_Decision__c
		string rulesEngineResult = businessRulesEngineHandler(accountId); // Saurabh : 20210103 unCommenting as the service is fine now

		//check for Client Type and Block it if its individual
	//		  Account accountRecord = [SELECT Id, Client_Type__c FROM Account WHERE id = :accountId];
	//	if (accountRecord ?.Client_Type__c == 'Individual') {
	//	  throw new AuraHandledException('Credit Opportunity can not be created for Individual Client Type');
	//	}
        //Saurabh : 20210414 adding a salesProcess linking to opp
        // with next enhancement we would use request name as a param from cmp and then we can create a common method to create all type of opp
        List<Sales_Process_Type__c> salesProcessList = new SalesProcessTypesSelector().selectByRequestName('Complex Credit (Business Banking)');
        if(!salesProcessList.isEmpty()){
        //Create Opportunity
		Opportunity onboardOpportunity = new Opportunity();
		onboardOpportunity.Name = 'Complex Credit Onboarding';
		onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('Complex_Credit_Onboarding').getRecordTypeId();
		onboardOpportunity.AccountId = accountId;
		onboardOpportunity.StageName = 'Confirm Client Eligibility';
		onboardOpportunity.closeDate = todaysDate.addDays(7);
		onboardOpportunity.priceBook2Id = priceBookItem.id;
		onboardOpportunity.Business_Rules_Decision__c = rulesEngineResult;
        onboardOpportunity.Sales_Process_Type__c = salesProcessList[0].id; //Saurabh added lookup to Sales Process Type

        //Capturing Sitecode of loggedin User while creating opportunity if user has site code
		if (!sitecodes.isEmpty()) {
		  onboardOpportunity.Site__c = sitecodes[0].Id;
		}
		insert onboardOpportunity;
        //Creating Application Record
        Application__c application = new Application__c();
		application.Opportunity__c = onboardOpportunity.Id;
		INSERT application;
		returnMessage = onboardOpportunity.id;

		if(onboardOpportunity.Id!=Null){
			   AllocateStockNumberController.getEDFservice(returnMessage);//added by Gulafsha for Credit Onboarding
		 }}
          else{
           throw new AuraHandledException('Credit Opportunity can not be created as Sales Process Type is not defined ');
          }

		//return onboardOpportunity.id;

		/**
		 * E. MONGWE
		 * @date 2021-02-11
		 * UserStoty W-007585
		 */
		HistoricalFinancialDataController.getHistoricalFianancialData(returnMessage);
		return returnMessage;
	  }
	  else {
		return null;
	  }
	}

 /**
     * @description Method to Create Credit Covid 19 Product Opportunity
     *
     * @param accRecord
     * Added by Almas Aleem
     * W-07393
     * @return String
     */
    @AuraEnabled
    public static String createNewCovidOpportunity(Account accRecord) {

        String accountId = null;
        String returnMessage = '';
        //Create Client if Account Id is null
        if(accRecord != null && accRecord.id == null) {
            accountId = createCIFClientInSF(accRecord).substring(8, 26);
        } else {
            accountId = accRecord.id;
        }

        if(accountId !=null){
            Date todaysDate = System.today();
            Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            User userRec =  new UsersSelector().selectById(UserInfo.getUserId());
            List<Site__c> sitecodes;
            if(userRec.SiteCode__c!=null){
                sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
            } else{
                sitecodes = new List<Site__c>();
            }

            //Get Standard Pricebook Id
            PriceBook2 priceBookItem = new PriceBook2();
            priceBookItem = [select id from priceBook2 where name = 'Standard Price Book'];

            //Saurabh : W:3780 Business Rules Validations
            //check for Business Rules before creating credit Opportunity and update Business_Rules_Decision__c
           // string rulesEngineResult = businessRulesEngineHandler(accountId);

            //check for Client Type and Block it if its individual
            /*Account accountRecord =   [SELECT Id, Client_Type__c FROM Account where id =: accountId ];
            if (accountRecord?.Client_Type__c == 'Individual'){
                throw new AuraHandledException('Credit Covid-19 Opportunity can not be created for Individual Client Type');
            }*/
            //Create Opportunity
            Opportunity onboardOpportunity = new Opportunity();
            onboardOpportunity.Name = 'Credit Onboarding';
            onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('Credit_Maintenance').getRecordTypeId();
            onboardOpportunity.AccountId = accountId;
            onboardOpportunity.StageName = 'Confirm Client Eligibility';
            onboardOpportunity.closeDate = todaysDate.addDays(7);
            onboardOpportunity.priceBook2Id = priceBookItem.id;
          //  onboardOpportunity.Business_Rules_Decision__c = rulesEngineResult;
            //Capturing Sitecode of loggedin User while creating opportunity if user has site code
            if(!sitecodes.isEmpty()){
                onboardOpportunity.Site__c= sitecodes[0].Id;
            }
            insert onboardOpportunity;
            returnMessage = onboardOpportunity.id;


            return returnMessage;
        } else {
            return null; //need to do some more handling here
        }
    }

   /**
* @description Method to Create CPF Product Opportunity
*
* @param accRecord
* @return String
*/
    @AuraEnabled
    public static String createNewCPFOpportunity(Account accRecord) {

        String accountId = null;

        //Create Client if Account Id is null
        if(accRecord != null && accRecord.id == null) {
            accountId = createCIFClientInSF(accRecord).substring(8, 26);
        } else {
            accountId = accRecord.id;
        }

        if(accountId !=null){
            Date todaysDate = System.today();
            Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            User userRec =  new UsersSelector().selectById(UserInfo.getUserId());
            List<Site__c> sitecodes;
            if(userRec.SiteCode__c!=null){
                sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
            } else{
                sitecodes = new List<Site__c>();
            }

            //Get Standard Pricebook Id
            PriceBook2 priceBookItem = new PriceBook2();
            priceBookItem = [select id from priceBook2 where name = 'Standard Price Book'];

            //Create Opportunity
            Opportunity onboardOpportunity = new Opportunity();
            onboardOpportunity.Name = 'CPF Onboarding';
            onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('CPF_Onboarding').getRecordTypeId();
            onboardOpportunity.AccountId = accountId;
            onboardOpportunity.StageName = 'Confirm Client Eligibility';
            onboardOpportunity.closeDate = todaysDate.addDays(7);
            onboardOpportunity.priceBook2Id = priceBookItem.id;
            //Capturing Sitecode of loggedin User while creating opportunity if user has site code
            if(!sitecodes.isEmpty()){
                onboardOpportunity.Site__c= sitecodes[0].Id;
            }

            insert onboardOpportunity;

            return onboardOpportunity.id;
        } else {
            return null;
        }
    }

     /**
* @description Method to Create CPF Product Opportunity
*
*
* @return List<SelectOptionCls>
*/
    @AuraEnabled
    public static List<SelectOptionCls> getPickListValues(){

        List<SelectOptionCls> options = new List<SelectOptionCls>();

        Schema.DescribeFieldResult fieldResult = Contact.Country_of_Birth__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry f : ple)
        {
            SelectOptionCls opt = new SelectOptionCls();
            opt.label = f.getLabel();
            opt.value = f.getValue();
            options.add(opt);
        }
        return options;
    }

    /**
* @description Method
*
*
*
*/
    public class SelectOptionCls{

    /**
* @description Method
*
*
*
*/
        @AuraEnabled public String label{get;set;}

    /**
* @description Method
*
*
*
*/
        @AuraEnabled public String value{get;set;}

    }

    /**
* @description TdB - This is a method to Search by Name in CIF
* @param   searchValue     The search input by the user
* @return  String          List of Accounts
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<Account> callCIFSearchByName(String searchValue) {

        System.debug('searchValue : ' + searchValue);

        //Set to store CIF Numbers
        List<Account> accountsReturned = new List<Account>();
        map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

        //Set default values
        String cifInitials = '';
        String clntGroup = '';
        String clntGender = '';
        String clntBirthDate = '';
        String maxRecsToRtrv = '15';
        String startAfterSearchPos = '';
        String siteCode;
        String clntTitle = '';

        //Get Site Code from logged in User
        User loggedInUser = new UsersSelector().selectById(UserInfo.getUserId());
        siteCode = loggedInUser.SiteCode__c;

        try{

            if(String.isEmpty(searchValue) != null) {
                Map<CIgetClientDetailsByNameV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetClientDetailsByNameV2_IH_v1.CIgetClientDetailsByNameV2(searchValue.toUpperCase(),
                                                                                                                                                                   cifInitials,
                                                                                                                                                                   clntGroup,
                                                                                                                                                                   clntGender,
                                                                                                                                                                   clntBirthDate,
                                                                                                                                                                   maxRecsToRtrv,
                                                                                                                                                                   startAfterSearchPos,
                                                                                                                                                                   siteCode,
                                                                                                                                                                   clntTitle);

                CIgetClientDetailsByNameV2_Resp_IB_v1 responseBean = (new List<CIgetClientDetailsByNameV2_Resp_IB_v1>(responseMap.keySet()))[0];
                System.debug('##### CIF Search by Name' + responseBean.serialize(responseBean) + '#####');

                if (responseBean != null && responseBean.CIgetClientDetailsByNameV2Response != null && responseBean.CIgetClientDetailsByNameV2Response.Cip602o != null) {

                    if(responseBean.CIgetClientDetailsByNameV2Response.Cip602o.tblEntry != null) {
                        for(CIgetClientDetailsByNameV2_Resp_IB_v1.tblEntry eachEntry : responseBean.CIgetClientDetailsByNameV2Response.Cip602o.tblEntry) {
                            Account eachAccount = new Account();
                            eachAccount.CIF__c = eachEntry.cifKey;
                            eachAccount.Name = eachEntry.cifSurname;
                            eachAccount.Registration_Number__c = eachEntry.idNbr;

                            //Add CIF to List
                            accountsReturned.add(eachAccount);
                        }
                        return accountsReturned;
                    } else {
                        return null;
                    }
                } else {
                    return null;
                }
            } else {
                return null;
            }

        }catch(Exception ex){
            System.debug(LoggingLevel.Finest,'Exception : ClientFinderBase : getAdapt360ClientBean - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }

    }
    /**
* @description TdB - This is a method to Search by Name in CIF
* @param   accId     The search input by the user
* @return  Account          List of Accounts
*/
@SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static Account fetchPersonAccDetails(String accId) {
        System.debug('accId '+accId);
        Account acc = new AccountsSelector().selectPersonAccountById(accId);
        return acc;
    }
     /**
* @description TdB - This is a method to Search by Name in CIF
* @param   account     The search input by the user
* @param   parentId
* @param   roles
* @param   sharePercentage
* @param   primaryEntityId
* @param   parentRelationshipId
*
*
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static void updateAccAndCreateAccConReln(Account account, String parentId,List<String> roles,String sharePercentage,
                                                    String primaryEntityId, String parentRelationshipId) {
        update account;
        List<Account> accnList = new AccountsSelector().selectCasaFieldsById(account.Id, 1);

        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = parentId;
        acr.ContactId = accnList.get(0).PersonContactId;
        acr.Primary_Entity_Id__c = primaryEntityId;//Added by chandra dated 02/08/2020
        acr.ParentRelationshipId__c =  parentRelationshipId;
        if(roles != null){
            acr.Roles = String.join(roles,';');
        }
        //conditional if added by chandra date 08/10/2020
        if(sharePercentage!=''){
            acr.Share_Percentage__c = Decimal.valueOf(sharePercentage);
        } else{
            acr.Share_Percentage__c = 0.0;
        }

        try {
           // AccountContactRelationController.calculateControllingPercentageVal(acr);//Added by chandra against W-004945 dated 15/07/2020
            system.debug('In Try If');
            AccountContactRelationController.calculateControllingPercentageVal2(acr,primaryEntityId);
        }
        catch(DmlException e) {
            System.debug(e.getLineNumber() + 'An unexpected error has occurred: ' + e.getMessage());
        }
    }

    //Added by chandra against W-006169
    /**
* @description TdB - This is a method to Search by Name in CIF
* @param   idNumber     The search input by the user
* @param   idType
*
* @return Account
*/
    @AuraEnabled
    public static Account validateExitedAccount(String idNumber, String idType) {
        Account acc = new Account();
        try{
            acc = [Select Id,ID_Number__pc,ID_Type__pc From Account Where ID_Number__pc =:idNumber AND ID_Type__pc =:idType LIMIT 1];
        }
        catch (Exception e) {
            acc = null;
        }
        return acc;
    }

    //Added by chandra against W-006169
    /**
* @description TdB - This is a method to Search by Name in CIF
* @param   account     The search input by the user
* @param   parentId
* @param   primaryEntityId
* @return AccountContactRelation
*/
    @AuraEnabled
    public static AccountContactRelation validateExitedAccountRealionship(Account account, String parentId, String primaryEntityId) {
        List<Account> accnList = new AccountsSelector().selectCasaFieldsById(account.Id, 1);
        AccountContactRelation acr = new AccountContactRelation();
        try{
            acr = [Select Id,AccountId,ContactId,Primary_Entity_Id__c From AccountContactRelation
                   Where AccountId =:parentId AND ContactId =:accnList.get(0).PersonContactId AND Primary_Entity_Id__c =:primaryEntityId LIMIT 1];
        }
        catch (Exception e) {
            acr = null;
        }
        return acr;
    }

    /**
     *
* @description This Method Calls Rules Engine Service and Validates Client details
* @param AccountId
* @return string
*/
@SuppressWarnings('PMD.AvoidDebugStatements')
@AuraEnabled
public static string businessRulesEngineHandler(string AccountId) {
        //get the account Details
        Account accRecord = new AccountsSelector().selectFieldsforRulesEnginebyId(AccountId);
        Map<string, string> translationMap = new Map<string, string>();
        string rulesEngineDecision = '';
        string businessSegmentfromCMS = '';
        string businesSubSegmentfromCMS = '';
        String franchisecode = '';
        String Franchisename = '';
        if (accRecord != Null) {
            //Loading translation map from Integration Translation for translating the values
            //mapping is done as per the docs received from SA, We may need to revisit
            List<Integration_Translation__c> integrationValueList = [SELECT Id, OwnerId, IsDeleted, Name, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c
																 FROM Integration_Translation__c
																 where (System_Name__c = 'CIF' or System_Name__c = 'CMS') and Direction__c = 'Outbound' And (Value_Type__c = 'Standard Industry SIC Code' or Value_Type__c = 'Client Type Group' or Value_Type__c = 'Client Type' or Value_Type__c = 'Client Type' or Value_Type__c = 'Business Segment Indicator' or Value_Type__c = 'Banking Sector')];
		for (Integration_Translation__c ict : integrationValueList) {
		  translationMap.put(ict.Internal_Value__c, ict.External_Value__c);
		}
            }
        //calling the GBGetContBranchDetV1_Req_IB_v1 service to get the Business Segment and Subsegment as a work Around,
        // later we may store them on Account object
        if (!Test.isRunningTest()) {
        GBGetContBranchDetV1_Req_IB_v1 requestBean = new GBGetContBranchDetV1_Req_IB_v1();
        requestbean.NBSAPDPI = new GBGetContBranchDetV1_Req_IB_v1.NBSAPDPI();
        requestbean.NBSMSGI = new GBGetContBranchDetV1_Req_IB_v1.NBSMSGI_Z();
        requestbean.NBSMSGI.NBSMSGI = new GBGetContBranchDetV1_Req_IB_v1.NBSMSGI();
        requestbean.GSB021I = new GBGetContBranchDetV1_Req_IB_v1.GSB021I_Z();
        requestbean.GSB021I.GSB021I = new GBGetContBranchDetV1_Req_IB_v1.GSB021I();
        requestbean.NBSAPDPI.NBSAPLI = new GBGetContBranchDetV1_Req_IB_v1.NBSAPLI();
        requestbean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        requestbean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';
        requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'ukzoloircer';
        requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'natogehoc';
        requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'i';
        requestbean.GSB021I.GSB021I.GSB021I_CLIENT_CODE = accRecord.CIF__c;   //'pojorej'//for light onboarding clients we are expecting it to fail
        GBGetContBranchDetV1_Resp_IB_v1 cmsResponseBean = GBGetContBranchDetV1_IH_v1.GBGetContBranchDetV1(requestbean);
        System.debug('GBGetContBranchDetV1_Resp_IB_v1 Response Bean ' + cmsResponseBean.serialize(cmsResponseBean));
		if (cmsResponseBean.statusCode == 200) {
            businesSubSegmentfromCMS = cmsResponseBean.GSB021O.GSB021O.GSB021O_BUSINESS_SUB_SEG; // SA is yet to confirm if this needs translation
            businessSegmentfromCMS = cmsResponseBean.GSB021O.GSB021O.GSB021O_BUSINESS_SEG;
            franchisecode = cmsResponseBean.GSB021O.GSB021O.GSB021O_FRANCHISOR_CODE != Null ? String.valueOf(cmsResponseBean.GSB021O.GSB021O.GSB021O_FRANCHISOR_CODE) : '';//Change by gulafsha for CreditOnboarding
            Franchisename = cmsResponseBean.GSB021O.GSB021O.GSB021O_FRANCH_CODE_DESC != Null ? String.valueOf(cmsResponseBean.GSB021O.GSB021O.GSB021O_FRANCH_CODE_DESC) : '';//Change by gulafsha for CreditOnboarding
            //if (franchisecode != Null && franchisecode != '' && Franchisename != Null && Franchisename != '') {
              //Change by gulafsha for CreditOnboarding
              //AllocateStockNumberController.updateFranchiseDetailsOnaAcc(franchisecode, Franchisename, accRecord.Id);
            //}
          }
        }
        //taking the values from CMS and Calling Rules Engine Service
        RulesEngineService_Req_IB_v1 rulesEngineRequestBean = new RulesEngineService_Req_IB_v1();
        rulesEngineRequestBean.clientTypeGroup = translationMap.get(accRecord.Client_Group__c);
	  rulesEngineRequestBean.clientType = translationMap.get(accRecord.Client_Type__c);
	  rulesEngineRequestBean.BusinessSegment = businessSegmentfromCMS;
	  rulesEngineRequestBean.BankingSector = '01';//translationMap.get(accRecord.Banking_Sector__c); adding as a work around till translation is sorted
	  rulesEngineRequestBean.sic = translationMap.get(accRecord.Standard_Industry_SIC_Code__c);
	  rulesEngineRequestBean.BusinessArea = accRecord.SBU_Segment__c != null ? accRecord.SBU_Segment__c : 'H';
	  rulesEngineRequestBean.BusinessSubSegments = businesSubSegmentfromCMS;
        RulesEngineService_Resp_IB_v1 responseBean = RulesEngineService_IH_v1.RulesEngineService(rulesEngineRequestBean);
        System.debug('Business Rules Engine Response Bean ' + responseBean.serialize(responseBean));
	  if (responseBean.statusCode == 200) {
		for (RulesEngineService_Resp_IB_v1.body rulesEngineResult : responseBean.body)
                //still not decided for which client we need to stop onboarding so we are just storing the results
                if (rulesEngineResult.result.containsIgnoreCase('FAIL')) {
                    rulesEngineDecision += rulesEngineResult.result;
                  throw new AuraHandledException('This is a Scoring Exclusion. Please verify if Business Segment/Business Sub-segment/Client Type/SIC Code is correct.');
                }
            else {
                rulesEngineDecision += rulesEngineResult.result;
            }
        }
        return rulesEngineDecision;
    }


    // Added by Diksha for SPM 9/22/2020
    /**
     *
    * @description This Method Calls Rules Engine Service and Validates Client details
    *
    * @return List<User>
    */
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<User> getPortfolioManagerlist(){

        List<User>   pmuserList=[select id,Name,Advisor_Code__c,Profile.Name from User  WHERE Id =: UserInfo.getUserId() OR Profile.Name='Stock Broker Portfolio Manager'];
        System.debug('pmuserList++'+pmuserList);
        return pmuserList;
    }
     // Added by Diksha for SPM 9/22/2020
    /**
     *
* @description This Method Calls Rules Engine Service and Validates Client details
*
* @return string
*/
@SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static string getloggedinUserProfileName(){

        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        return  profileName;
    }

    /**
* @description Method to Create SPM Product Opportunity
* @param accRecord
* @param selectedPm
* @return String
*/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String createNewSPMOpportunity(Account accRecord , string selectedPm) {
        String userRecId=null;
        String accountId = null;
        //Create Client if Account Id is null
        if(accRecord != null && accRecord.id == null) {
            accountId = createCIFClientInSF(accRecord).substring(8, 26);
        } else {
            accountId = accRecord.id;
        }

        if(accountId !=null){
            Date todaysDate = System.today();
            Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            User userRec =  new UsersSelector().selectById(UserInfo.getUserId());
            system.debug('userRec'+userRec);
            List<Site__c> sitecodes;
            if(userRec.SiteCode__c!=null){
                sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
            } else{
                sitecodes = new List<Site__c>();
            }
            if(selectedPm !=null && selectedPm!='' ){
                User userdetail =[select id ,name from user where name=:selectedPm ];
                userRecId=userdetail.id;
            }
            else{
                userRecId= userRec.id;
            }

            //Get Standard Pricebook Id
            PriceBook2 priceBookItem = new PriceBook2();
            priceBookItem = [select id from priceBook2 where name = 'Standard Price Book'];

            //Create Opportunity
            Opportunity onboardOpportunity = new Opportunity();
            onboardOpportunity.Name = 'SPM Onboarding';
            onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('SPM_Onboarding').getRecordTypeId();
            onboardOpportunity.AccountId = accountId;
            onboardOpportunity.StageName = 'Confirm Client Eligibility';
            onboardOpportunity.closeDate = todaysDate.addDays(7);
            onboardOpportunity.priceBook2Id = priceBookItem.id;
            onboardOpportunity.OwnerId =userRecId;

            //Capturing Sitecode of loggedin User while creating opportunity if user has site code
            if(!sitecodes.isEmpty()){
                onboardOpportunity.Site__c= sitecodes[0].Id;
            }

            insert onboardOpportunity;
            Product2 selectedProduct = new ProductsSelector().selectByName('SPM Equity Product');
            System.debug('=======selectedProduct====>'+selectedProduct);
            Application__c   application = new Application__c();
            application.Opportunity__c = onboardOpportunity.Id;
            INSERT application;
            System.debug('=======createSPMOnboardingapplication====>'+application);
            OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
            opportunityLineItem.OpportunityId = onboardOpportunity.Id;
            opportunityLineItem.Quantity=1;
            opportunityLineItem.TotalPrice = 0;
            opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(selectedProduct.Id);
            opportunityLineItem.Product2Id = selectedProduct.Id;
            INSERT opportunityLineItem;
            System.debug('=======createSPMOnboardingopportunityLineItem====>'+opportunityLineItem);
           	Application_Product__c  applicationProduct = new Application_Product__c();
           	applicationProduct.Opportunity_Product_Id__c  =  opportunityLineItem.Id;
            applicationProduct.Application__c = application.Id;
            applicationProduct.Opportunity__c=onboardOpportunity.Id;
            INSERT applicationProduct;
            System.debug('=======createSPMOnboardingapplicationProduct====>'+applicationProduct);
			Account accounts = new AccountsSelector().selectByOpportunityId(onboardOpportunity.Id);
            List<Payment_Plan__c> paymentPlansList = [select id, Account__c, Account_Number__c, Account_Type__c,Bank_Name__c,Branch_Code__c,Branch_Name__c,Type__c,Name,BIC_Code__c,Account_Name__c from Payment_Plan__c where Account__c=:accounts.Id AND Type__c='SPM Product' ];

            if(paymentPlansList!=null && !paymentPlansList.isEmpty()){
                System.debug('=======paymentPlansList====>' + paymentPlansList);
                Payment_Plan__c paymentRec=new Payment_Plan__c();
                paymentRec.Account__c=accounts.Id;
                paymentRec.Account_Number__c = paymentPlansList[0].Account_Number__c;
                paymentRec.Account_Type__c = paymentPlansList[0].Account_Type__c;
                paymentRec.Bank_Name__c = paymentPlansList[0].Bank_Name__c;
                if (paymentPlansList[0].Branch_Code__c!=null) {
                    paymentRec.Branch_Code__c = paymentPlansList[0].Branch_Code__c;
                }
                paymentRec.Branch_Name__c = paymentPlansList[0].Branch_Name__c;
                paymentRec.Name = paymentPlansList[0].Name;
                paymentRec.Type__c = 'SPM Product';
                paymentRec.Status__c = 'New';
                paymentRec.Method__c = 'Debit Order';
				paymentRec.BIC_Code__c = paymentPlansList[0].BIC_Code__c;
                paymentRec.Account_Name__c = paymentPlansList[0].Account_Name__c;
				paymentRec.Application__c = application.Id;
                paymentRec.Application_Product__c = applicationProduct.Id;
                Insert paymentRec;
                System.debug('=======paymentRec====>' + paymentRec);
            }
            return onboardOpportunity.id;
        } else {
            return null;
        }
    }
       /**
* @description Method to Create SPM Product Opportunity
* @param cifKeyP
*
* @return boolean
*/
@SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static boolean checkCompliant(String cifKeyP){
        boolean complianceStatus = false;
        //List<ESP_Onboarded__c> espList = [SELECT Id,ClientKey__c from ESP_Onboarded__c where ClientKey__c=:cifKeyP];
        List<ESP_Onboarded__c> espList = new ESPOnboardedSelector().selectBycif(cifKeyP);
        if(!espList.isEmpty()){
            complianceStatus = true;
        }
        return complianceStatus;
    }
    /**
* @description Method to Create SPM Product Opportunity
* @param accRecId
* @param CasaRefNumber
* @return String
*/
@SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String getRelatedPartyListByPrimaryRefNo(Id accRecId,String CasaRefNumber) {
        WQgetCASADetailsByRefNoV7_Resp_IB_v1 resp = WQgetCASADetailsByRefNoV7_IH_v1.getRelatedPartyListByPrimaryRefNo(CasaRefNumber);
        WQgetCASADetailsByRefNoV7_Resp_IB_v1.WQgetCASADetailsByRefNoV7Response WQgetCASADetailsByRefNoV7ResponseBean = new WQgetCASADetailsByRefNoV7_Resp_IB_v1.WQgetCASADetailsByRefNoV7Response();
        //WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties RelatedPartiesBean= new WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties();
        List<WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties> RelatedPartiesBeanList= new List<WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties>();

        Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		WQgetCASADetailsByRefNoV7ResponseBean = resp.WQgetCASADetailsByRefNoV7Response;
        List<Account> personalAccountList = new List<Account>();
        if(WQgetCASADetailsByRefNoV7ResponseBean.msgNo == 0){
            RelatedPartiesBeanList = WQgetCASADetailsByRefNoV7ResponseBean.relatedParties;
            System.debug('RelatedPartiesBeanList'+RelatedPartiesBeanList);
            for(WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties relParty:RelatedPartiesBeanList){
                WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties RelatedPartiesBean= new WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties();

                RelatedPartiesBean = relParty;
                System.debug('RelatedPartiesBean'+RelatedPartiesBean.rFirstName);
                //Personal Account
                Account personalAccount = new Account();
                personalAccount.FirstName = RelatedPartiesBean.rFirstName;
                personalAccount.LastName = RelatedPartiesBean.rSurnameComp;
                //personalAccount.PersonTitle = 'Mr.';
                personalAccount.CASA_Reference_Number__pc = String.valueOf(RelatedPartiesBean.rRefNo);
                personalAccount.ID_Number__pc = RelatedPartiesBean.rIdRegNo;
                personalAccount.Country_of_Residence__pc = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, RelatedPartiesBean.rCntryOfRes, StringConstants.OUTBOUND_RECORD_TYPE);
                personalAccount.Country_of_Birth__pc = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, RelatedPartiesBean.rCountryOfBirth, StringConstants.OUTBOUND_RECORD_TYPE);
                personalAccount.Client_Group__c = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, RelatedPartiesBean.rClientTypeGrp, StringConstants.OUTBOUND_RECORD_TYPE);
                personalAccount.CASA_Screening_Status__pc = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, 'eCasa Status By Ref', RelatedPartiesBean.rStatus, StringConstants.INBOUND_RECORD_TYPE);
                //personalAccount.Client_Type__c = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, 'Relationship', RelatedPartiesBean.rRelationship, StringConstants.OUTBOUND_RECORD_TYPE);
                personalAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
                //insert personalAccount;
                personalAccountList.add(personalAccount);
                System.debug('personalAccount'+personalAccount);

            }

            if(personalAccountList.size() >0){
                insert personalAccountList;
            }
            Set<String> perAccIdsSet = new Set<String>();
            if(!personalAccountList.isEmpty() && personalAccountList.size() >0){
               for(Account perAcc:personalAccountList){
                      perAccIdsSet.add(perAcc.Id);
               }

            }
            List<AccountContactRelation> acrList = new List<AccountContactRelation>();
            for(Account personalAccount :[Select Id, PersonContactId FROM Account WHERE Id IN :perAccIdsSet]){
                //Id personalAccountContactId = [Select Id, PersonContactId FROM Account WHERE Id = :personalAccount.Id].PersonContactId;
                //System.debug('personalAccountContactId'+personalAccountContactId);
                AccountContactRelation acr = new AccountContactRelation();
                acr.AccountId = accRecId;
                acr.ContactId = personalAccount.PersonContactId;
                acrList.add(acr);
                System.debug('AccountContactRelation'+acr.Id);
            }
            if(acrList.size() >0){
                insert acrList;
            }

        }
        return 'Success';

    }

    /**
    * @description Function to Sync CIF data with salesforce account
    * Updates account if salesforce exists
    * Creates Account if account does not exists
    * @param accId
    * @param CIFcode
    * @param IdNumber
    * @param contactconsent
    * @author  Paul du Randt
    * @since   2018-10-10
    * @return String
    **/
     @AuraEnabled
    public static String UpdateCreateAccountWithCIF(String accId,String CIFcode,String IdNumber,String contactconsent) {
        String Accountid =  BranchCIFSalesforceSyncHelper.UpdateAccountwithCIF(accId,CIFcode,IdNumber);
        ClientFinderExt.updateContactConsentonAccID(Accountid,contactconsent);
        return Accountid;
    }

    /**
    * @description updateContactConsentonAccID
    * Updates account if salesforce exists
    * Creates Account if account does not exists
    * @param accId
    * @param consent
    *
    **/
    @AuraEnabled
    public static void updateContactConsentonAccID(String accId, String consent) {
         Account account = [SELECT Is_the_Consent_Given__pc FROM Account where ID = :accId LIMIT 1];
         account.Is_the_Consent_Given__pc =  (consent  == 'Yes') ?  true  : false;

         //required for Valid_Update validation rule
         account.Valid_Update_Bypass__c = true;
         
         update account;
    }

    /**
     * @description This is a method to check if Id number is a valid South African Id
     *
     * @param   idNumber      The given idNumber
     *
     * @return  Boolean       Returns if valid or not
     * Author: André Pietersen
     * Work-item: W-006950
     */
    @AuraEnabled
    public static Boolean validateId(String idNumber) {
        return SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, idNumber);
    }

     //TdB - Get Client Type values from Custom Metadata

      /**
     * @description This is a method to check if Id number is a valid South African Id
     *
     * @param   clientGroupSelected      The given idNumber
     *
     * @return  List<SelectOptionCls>       Returns if valid or not
     * Author: André Pietersen
     * Work-item: W-006950
     */
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static List<SelectOptionCls> getClientTypePickListValues(String clientGroupSelected){

        Map<String, String> clientTypeMap = new Map<String, String>();
        Set<String> clientTypeLst = new Set<String>();

        //Get Client Type values from Custom Metadata
        List<Field_Dependency_Setup__mdt> clientGroupValues = [SELECT DeveloperName, Controlling_Field_API_Name__c, Controlling_Field_Value__c, Dependent_Field_API_Name__c, Dependent_Field_Values__c, Object_API_Name__c
                                                               FROM Field_Dependency_Setup__mdt
                                                               WHERE Object_API_Name__c = 'Account' AND Controlling_Field_API_Name__c = 'Client_Group__c' AND Controlling_Field_Value__c = :clientGroupSelected AND Department_Division__c = 'RBB'];

        System.debug('clientGroupValues : ' + clientGroupValues);

        //Add all Client Types a Set to remove duplicates
        for(Field_Dependency_Setup__mdt eachValue : clientGroupValues) {
            String clientTypeValues = eachValue.Dependent_Field_Values__c;
            clientTypeLst.addAll(clientTypeValues.split(';'));
        }
        System.debug('clientTypeLst : ' + clientTypeLst);

        //Add all Client Types to a map
        for(String eachTypeValue : clientTypeLst) {
            clientTypeMap.put(eachTypeValue, eachTypeValue);
        }

        List<SelectOptionCls> options = new List<SelectOptionCls>();

        Schema.DescribeFieldResult fieldResult = Account.Client_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry f : ple)
        {
            if(clientTypeMap.containsKey(f.getValue())) {
                SelectOptionCls opt = new SelectOptionCls();
                opt.label = f.getLabel();
                opt.value = f.getValue();
                options.add(opt);
            }
        }

        return options;
    }

    //TdB - Get Client Group values from Custom Metadata

     /**
     * @description getClientGroupPickListValues
     *
     *
     *
     * @return  List<SelectOptionCls>       Returns if valid or not
     * Author: André Pietersen
     * Work-item: W-006950
     */
    @AuraEnabled
    public static List<SelectOptionCls> getClientGroupPickListValues(){

        //Get Client Group values from Custom Metadata
        Map<String, String> clientGroupMap = new Map<String, String>();
        List<Field_Dependency_Setup__mdt> clientGroupValues = [SELECT DeveloperName, Controlling_Field_API_Name__c, Controlling_Field_Value__c, Dependent_Field_API_Name__c, Dependent_Field_Values__c, Object_API_Name__c
                                                               FROM Field_Dependency_Setup__mdt
                                                               WHERE Object_API_Name__c = 'Account' AND Controlling_Field_API_Name__c = 'Client_Group__c' AND Dependent_Field_API_Name__c = 'Client_Type__c'];

        List<SelectOptionCls> options = new List<SelectOptionCls>();

        Schema.DescribeFieldResult fieldResult = Account.Client_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Field_Dependency_Setup__mdt eachValue : clientGroupValues) {
            clientGroupMap.put(eachValue.Controlling_Field_Value__c, eachValue.Controlling_Field_Value__c);
        }

        for( Schema.PicklistEntry f : ple)
        {
            if(clientGroupMap.containsKey(f.getValue())) {
                SelectOptionCls opt = new SelectOptionCls();
                opt.label = f.getLabel();
                opt.value = f.getValue();
                options.add(opt);
            }
        }

        return options;
    }

    /**
     * @description A method to check FIC refresh Case is Open (W-009646)
     * @param accId Id of Selected Account Record.
     * @return a FIC Case record for this account result.
     **/
    @AuraEnabled
    public static case getFICRefreshCases(string accId){

        List<case> ficCaseList = new List<case>();
        if(string.isNotBlank(accId)){
            //Modified the logic due to defect
            set<string> statusVal = new set<string>();
            statusVal.add('Resolved');
            statusVal.add('Unwanted');
            ficCaseList = new CasesSelector().selectCaseByFICStatusAndSubject(accId,statusVal,'FIC Refresh');
            /*
            ficCaseList = [Select Id,Subject,status,createddate,AccountId from Case
                       where AccountId=:accId and Status != 'closed' and Subject like '%FIC Refresh%'
                       order by createddate desc LIMIT 1];*/
        }
        return !ficCaseList.isEmpty() ? ficCaseList[0]:null;
    }

    /**
     * @description Wrapper Class to sennd both Service Group Type and Case record Td (W-009646)
     */
    Public class FICServiceGroupTypeWrapper{
        /**
     * @description Wrapper Class to sennd both Service Group Type and Case record Td (W-009646)
     */
        @AuraEnabled public Service_Group_Type__c serviceGroupTypeRecord {get;set;}
        /**
     * @description Wrapper Class to sennd both Service Group Type and Case record Td (W-009646)
     */
        @AuraEnabled public string caseRecordTypeId {get;set;}
    }

	  /**
	  * @description
	  * @author
	  * @param accRecordId
	  * @return String
	  **/
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    
	  public static String createStokvelNewOpportunity(String accRecordId) {
		  System.debug('createStokvelNewOpportunity methods start point');
		  try{
			  if(accRecordId !=null){
				  Date todaysDate = System.today();
				  Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
				  User userRec =  new UsersSelector().selectById(UserInfo.getUserId());
				  List<Site__c> sitecodes;
				  if(userRec.SiteCode__c!=null){
					  sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
				  } else{
					  sitecodes = new List<Site__c>();
				  }

				  //Get Standard Pricebook Id
				  PriceBook2 priceBookItem = new PriceBook2();
				  priceBookItem = [select id from priceBook2 where name = 'Standard Price Book'];

				  //Create Opportunity
				  Opportunity onboardOpportunity = new Opportunity();
				  onboardOpportunity.Name = 'Stokvel Onboarding';
				  onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('Stokvel').getRecordTypeId();
				  onboardOpportunity.AccountId = accRecordId;
				  onboardOpportunity.StageName = 'Confirm Stokvel Eligibility';
				  onboardOpportunity.closeDate = todaysDate.addDays(7);
				  onboardOpportunity.priceBook2Id = priceBookItem.id;

				  //Capturing Sitecode of loggedin User while creating opportunity if user has site code
				  if(!sitecodes.isEmpty()){
					  onboardOpportunity.Site__c= sitecodes[0].Id;
				  }

				  insert onboardOpportunity;
				  System.debug('onboardOpportunity.id: ' + onboardOpportunity.id);
				  return onboardOpportunity.id;
			  } else {
				  System.debug('accRecordId is null');
				  return null;
			  }
		  }catch(Exception e){
			  System.debug('Exception: ' + e.getMessage() + '.' + e.getStackTraceString());
			  return null;
		  }
		}

    /**
     * @description A method to check customer is compliant or not. (W-009646)
     * @param accId Id of Account Record.
     * @return a complianceWrap of Complaince Pack Service Request.
     **/
    @AuraEnabled
    public static ComplianceViewDashboardController.complianceData checkComplianceStatus(string accId){

        ComplianceViewDashboardController.complianceData complianceWrap = new ComplianceViewDashboardController.complianceData();
        complianceWrap = ComplianceViewDashboardController.getData(accId);
        return complianceWrap;
    }

    /**
     * @description A method to get send Service Group Type and its Case Record Id in FICServiceGroupTypeWrapper Wrapper. (W-009646)
     * @param groupId Id of Service Group Record.
     * @return a FICServiceGroupTypeWrapper result.
     **/
    @AuraEnabled
    public static FICServiceGroupTypeWrapper getFICRefreshServGrpTypeAndRecordTypeId(string groupId){

        //Getting Service Group Type Record
        Service_Group_Type__c objServiceJob = new ServiceGroupTypesSelector().getFICRefreshGroupTypeByGroupAndServiceType(groupId,'FIC Refresh');
        //Fetching case record type id for that service type
        String recordTypeId = '';
        if(objServiceJob.Service_Type__r != null && objServiceJob.Service_Type__r.Case_Record_Type__c != null){
            string recordTypeName = objServiceJob.Service_Type__r.Case_Record_Type__c;
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            /*
            List<RecordType> newRecordTpeList = [SELECT Id, Name, DeveloperName, SobjectType
                                                 FROM RecordType
                                                 WHERE Name = :objServiceJob.Service_Type__r.Case_Record_Type__c AND SobjectType = :sobjectName];
            if (!newRecordTpeList.isEmpty()) {
                recordTypeId = newRecordTpeList[0].Id;
            }*/
            if(devRecordTypeId != null){
                recordTypeId = Id.valueOf(devRecordTypeId);
            }
        }
        FICServiceGroupTypeWrapper objWrap = new FICServiceGroupTypeWrapper();
        objWrap.serviceGroupTypeRecord = objServiceJob;
        objWrap.caseRecordTypeId = recordTypeId;
        return objWrap;
    }
    
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-08-18 
    * @return boolean 
    **/
    @AuraEnabled
    public static boolean getHomeLoanServiceJobUser(){
        boolean serviceGroup;
        if( ![Select id, Service_Group__r.Active__c from Service_Group_User_Entry__c Where User__c=:UserInfo.getUserId() AND Service_Group__c =: Label.HomeLoansServiceGroup AND Service_Group__r.Active__c=True LIMIT 1].isEmpty()){
                serviceGroup = true;
            }
            else{
                serviceGroup = false;
            }
        return serviceGroup;
    }
 
    /** @description Added by Santosh kumar for create Person Account date 06/June/2021 W-012428
    * @param acc
    * @return Account
    */
    @AuraEnabled
    public Static Account createPersonAccount(Account acc){
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId();
        if(acc != null && personAccountRecordTypeId != null) {
            acc.RecordTypeId = personAccountRecordTypeId;
            insert acc;
        }
        return acc;
    }

    /** @description createOnboardingOpportunity
    *
    * @param accountId
    * @param processType
    * @return String
    */
    @AuraEnabled
	public static String createOnboardingOpportunity(Id accountId, String processType){
        return OnboardingIndividualDetailsController.CreateOnboardingOpportunity(accountId, processType);
    }

    /**
    * @description Get Opportunity record type Id by Name
    * @param  recordTypeName
    * @return String
    */
    @AuraEnabled
    public static String getOpportunityRecordTypeByName(String recordTypeName){

        String opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        return opportunityRecordTypeId;
    }

    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-09-27 
    * @param accId 
    * @return String 
    **/
    @AuraEnabled
    public static String callExperianHandler(Id accId){
        try{
            Account acc = new AccountsSelector().selectAllById(accId);
            String registrationNumber = acc.Registration_Number__c;
            registrationNumber = registrationNumber.replace('/', '');
            ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = ExperianBusinessDetailsGet_IH_v1.ExperianBusinessDetailsGet(registrationNumber);
            return responseBean.serialize(responseBean);
        } catch (Exception exc){
            //System.debug('Exception Occurred' + exc.getMessage()+'At Line number' + exc.getLineNumber());
            throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
        }
    }
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-09-27 
    * @param whatId 
    **/
    @AuraEnabled
    public static void sendTemplatedEmail( Id whatId ) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Id templateId;
        List<String> toRecipients = new List<String>();
        string templateApiName = Label.Deregistered_Email_template;
        string deregisdteredMembers = Label.Deregistered_Email;
        List<Contact> con = new List<contact>();
        Id objectid;
        try {templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;
             con = [SELECT Id, Name FROM Contact where Account.Id =: whatId];
             toRecipients.add(deregisdteredMembers);
             objectid = con[0].Id;
            }
        catch (Exception e) {
            if(!test.isRunningTest()){
            throw new AuraHandledException ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName + 
                                            ' refer to Setup | Communications Templates ' + templateApiName);}
        }
        
        email.setWhatId(whatId);
        email.setToAddresses(toRecipients);
        email.setTemplateId(templateId);
        email.setTargetObjectId(objectid);
        email.setSaveAsActivity(false);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            return;
        }
        catch (EmailException e) {throw new AuraHandledException('[U-02] sendTemplatedEmail error. ' + e.getMessage());}
        
    } 
}