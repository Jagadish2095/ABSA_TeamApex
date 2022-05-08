/**
* A reusable class that creates related parties, i.e. Directors, Shareholders etc...
*
*
* @author Vladimir Panajic
* @since 2020-01-30
*/
public without sharing class RelatedPartiesService {
	/*list of related parties to be created
    * 
    * @param primaryAccountId
    * @param relatedPartiesList
    * @param relatedPartiesType
    */
    public void createRelatedParties(id primaryAccountId, List<ExperianBusinessDetailsGet_Resp_IB_v1.DirectorDetails> relatedPartiesList, string relatedPartiesType) {
        Set<string> relatedParties = new Set<string>();
        Map<string, string> sharePercentageMap = new Map<string, string>();
        for(ExperianBusinessDetailsGet_Resp_IB_v1.DirectorDetails relatedPartiesDetail : relatedPartiesList) {
            if (relatedPartiesDetail.Status.toUpperCase().equals('ACTIVE')) {
                relatedParties.add(relatedPartiesDetail.IDNumber);
                sharePercentageMap.put(relatedPartiesDetail.IDNumber, relatedPartiesDetail.sharePercentage);
            }
		}
        
        Set<string> newRelatedParties = relatedParties; //related parties not in Salesforce
        Set<id> existingRelatedParties = new Set<id>(); //related parties already in Salesforce
        List<Account> accountsList = new AccountsSelector().selectbyIDNumbers(relatedParties);
        if (!accountsList.isEmpty() && accountsList != null) {
            for(Account accnt : accountsList) {
                if(relatedParties.contains(accnt.ID_Number__pc)) {
                    newRelatedParties.remove(accnt.ID_Number__pc);
                    existingRelatedParties.add(accnt.PersonContactId);
                }
            }
        }
        
        //search CIF and add related party, if not in CIF use Experian service data
        List<Account> prospectAccountsList = new List<Account>();
        for(ExperianBusinessDetailsGet_Resp_IB_v1.DirectorDetails relatedPartiesDetail : relatedPartiesList) {
            if(newRelatedParties.contains(relatedPartiesDetail.IDNumber)) {
                Account acctCIF = searchClientFinder('ID Number', relatedPartiesDetail.IDNumber);
                if (acctCIF.ID_Number__pc == '') {
                    prospectAccountsList.add(acctCIF);
                } else {
                    Account prospectAccount = constructRelatedParty(relatedPartiesDetail.IDNumber, 'SA Identity Document', relatedPartiesDetail.FirstNames, relatedPartiesDetail.Surname, relatedPartiesDetail.Initials, relatedPartiesDetail.Title, relatedPartiesDetail.DateOfBirth);  
                    prospectAccountsList.add(prospectAccount);
                }
            }
        }
        
        try {
        	insert prospectAccountsList;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        
        //determine if relationship is required for the parties already found in Salesforce
        List<AccountContactRelation> accountContactRelationList = new AccountContactRelationSelector().selectbyRoles(primaryAccountId, existingRelatedParties, relatedPartiesType);
        Set<id> newRelPartiesRel = existingRelatedParties;
        if (!accountContactRelationList.isEmpty() && accountContactRelationList != null) {
            for(AccountContactRelation accntConRel : accountContactRelationList) {
                if(newRelPartiesRel.contains(accntConRel.ContactId)) {
                    newRelPartiesRel.remove(accntConRel.ContactId);
                }
            }
        }
        
        //set relationship for the related parties not in Salesforce
        Map<string, id> accountIdMap = new Map<string, id>();
        Map<string, id> personContactIdMap = new Map<string, id>();
        Map<string, string> sharePercentageDirMap = new Map<string, string>();
        List<Account> accnNewList = new AccountsSelector().selectbyaccContacts(prospectAccountsList);
        for(Account accn : accnNewList) {
            newRelPartiesRel.add(accn.PersonContactId);
            accountIdMap.put(accn.ID_Number__pc, accn.Id);
            personContactIdMap.put(accn.ID_Number__pc, accn.PersonContactId);
            if (sharePercentageMap.containskey(accn.ID_Number__pc)) {
                sharePercentageDirMap.put(accn.PersonContactId, sharePercentageMap.get(accn.ID_Number__pc));
            }
        }
        
        //create relationships
        linkRelatedParties(primaryAccountId, newRelPartiesRel, relatedPartiesType, sharePercentageDirMap);
        
        //create addresses
        List<Address__c> prospectAddressList = new List<Address__c>();
        for(ExperianBusinessDetailsGet_Resp_IB_v1.DirectorDetails relatedPartiesDetail : relatedPartiesList) {
            if(newRelatedParties.contains(relatedPartiesDetail.IDNumber)) {
               /* if (relatedPartiesDetail.registeredAddress != null) {
                    Address__c prospectRegisteredAddress = constructAddress(accountIdMap, personContactIdMap, relatedPartiesDetail.IDNumber, 'Registered', relatedPartiesDetail.registeredAddress.address1, relatedPartiesDetail.registeredAddress.address2, relatedPartiesDetail.registeredAddress.address3, relatedPartiesDetail.registeredAddress.address4, relatedPartiesDetail.registeredAddress.postCode);
                	prospectAddressList.add(prospectRegisteredAddress);
                } */
                if (relatedPartiesDetail.residentialAddress != null) {
                    Address__c prospectResidentialAddress = constructAddress(accountIdMap, personContactIdMap, relatedPartiesDetail.IDNumber, 'Residential', relatedPartiesDetail.residentialAddress.address1, relatedPartiesDetail.residentialAddress.address2, relatedPartiesDetail.residentialAddress.address3, relatedPartiesDetail.residentialAddress.address4, relatedPartiesDetail.residentialAddress.postCode);
                	prospectAddressList.add(prospectResidentialAddress);
                }
                /*if (relatedPartiesDetail.businessAddress != null) {
                    Address__c prospectBusinessAddress = constructAddress(accountIdMap, personContactIdMap, relatedPartiesDetail.IDNumber, 'Business Physical Address', relatedPartiesDetail.businessAddress.address1, relatedPartiesDetail.businessAddress.address2, relatedPartiesDetail.businessAddress.address3, relatedPartiesDetail.businessAddress.address4, relatedPartiesDetail.businessAddress.postCode);
                	prospectAddressList.add(prospectBusinessAddress);
                }
                if (relatedPartiesDetail.postalAddress != null) {
                    Address__c prospectPostalAddress = constructAddress(accountIdMap, personContactIdMap, relatedPartiesDetail.IDNumber, 'Postal', relatedPartiesDetail.postalAddress.address1, relatedPartiesDetail.postalAddress.address2, relatedPartiesDetail.postalAddress.address3, relatedPartiesDetail.postalAddress.address4, relatedPartiesDetail.postalAddress.postCode);
                	prospectAddressList.add(prospectPostalAddress);
                } */
            }
        }
        try {
        	insert prospectAddressList;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    
    /*construct prospect account (related party)
    * 
    * @param idNumber
    * @param idType
    * @param firstName
    * @param lastName
    * @param initials
    * @param title
    * @param birthDate
    * @return prospectAccount
    */
	@TestVisible private Account constructRelatedParty(string idNumber, string idType, string firstName, string lastName, string initials, string title, string birthDate) {        
        Account prospectAccount = new Account();
        prospectAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        prospectAccount.ID_Number__pc = idNumber;
        prospectAccount.ID_Type__pc = idType;
        prospectAccount.FirstName = firstName;
        prospectAccount.LastName = lastName;
        prospectAccount.Initials__pc = initials;
        prospectAccount.PersonTitle = title;
        prospectAccount.Client_Group__c = 'Individual';
        prospectAccount.Client_Type__c = 'Individual';
        prospectAccount.Communication_Language__pc = 'English';
        if (birthDate != '') {
            prospectAccount.PersonBirthdate = date.parse(birthDate.substring(0, 4) + '/' + birthDate.substring(4, 6) + '/' + birthDate.substring(6, 8));
        }
        prospectAccount.FinServ__PrimaryCitizenship__pc = 'South Africa'; //to be removed once the translations are done
        return prospectAccount;
    }
    
    /*link account(s) (related parties) with role(s) to primary account
    * 
    * @param primaryAccountId
    * @param relatedPartiesPersonContactIds
    * @param personContactRoles (semicolon separated string)
    */
    @TestVisible private void linkRelatedParties(id primaryAccountId, set <id> relatedPartiesPersonContactIds, string personContactRoles, map <string, string> sharePercentageDirMap) {
        List<AccountContactRelation> AccountContactRelationList = new List<AccountContactRelation>();
        for (string personContactId : relatedPartiesPersonContactIds) {
            AccountContactRelation acr = new AccountContactRelation();
            acr.Master_Record_Id__c = string.valueOf(primaryAccountId);
            acr.AccountId = primaryAccountId;
            acr.ContactId = personContactId;
            acr.Roles = personContactRoles;
            acr.Share_Percentage__c = 0.00;
            acr.Primary_Entity_Id__c = primaryAccountId;		//Manoj - To Updated Primary Entity Id
            if (sharePercentageDirMap.get(personContactId) != null && sharePercentageDirMap.get(personContactId) != '' && decimal.valueOf(sharePercentageDirMap.get(personContactId)) > 0) {
                acr.Roles = personContactRoles + ';Shareholder';
                acr.Share_Percentage__c = decimal.valueOf(sharePercentageDirMap.get(personContactId));
            }
            AccountContactRelationList.add(acr);
        }        
        try {
            insert AccountContactRelationList;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    
    /*search client finder
    * 
    * @param IDType
    * @param IDNumber
    */
    @TestVisible private Account searchClientFinder(string IDType, string IDNumber) {
        string adapt360JSONString = ClientFinderExt.getClientDetailsBean(IDType, IDNumber);
        List<Account> accountsCIFList = ClientFinderExt.searchClientLogic(IDType, IDNumber, null, adapt360JSONString, null);
        Account acctCIF = new Account();
        if (accountsCIFList != null) {
            acctCIF = accountsCIFList[0];
        }
        return acctCIF;
    }
    
    /*construct address
    * 
    * @param accountIdMap
    * @param IDNumber
    * @param addressType
    * @param addressLine1
    * @param addressLine2
    * @param addressLine3
    * @param addressLine4
    * @param postCode
    * @return address
    */
    @TestVisible private Address__c constructAddress(map <string, id> accountIdMap, map <string, id> personContactIdMap, string IDNumber, string addressType, string addressLine1, string addressLine2, string addressLine3, string addressLine4, string postCode) {
        Address__c address = new Address__c();
        id accountId = accountIdMap.get(IDNumber);
        address.Account__c = accountIdMap.get(IDNumber);
        address.Contact__c = personContactIdMap.get(IDNumber);
        address.Address_Type__c = addressType;
        address.Address1__c = addressLine1;
        address.Address2__c = addressLine2;
        address.Address3__c = addressLine3;
        address.Address4__c = addressLine4;
        address.Address5__c = postCode;
        address.Shipping_Street__c = addressLine1;
        address.Shipping_Suburb__c = addressLine2;
        address.Shipping_City__c = addressLine3;
        address.Shipping_State_Province__c = addressLine4;
        address.Shipping_Zip_Postal_Code__c = postCode;
        return address;
    }
}