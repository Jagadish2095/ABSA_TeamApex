/**
* Apex Enterprise Design Patterns
* @description Selector Layer for AccountContactRelation objects
*
* @author       Kyle Alexander (CloudSmiths)
* @since        2019-05-31
*/
public class AccountContactRelationSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
    /**
     * @description getSObjectType description
     *
     * @return Schema.SObjectType: Return description
     */
    public Schema.SObjectType getSObjectType() {
        return AccountContactRelation.sObjectType;
    }

    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            AccountContactRelation.Id,
                AccountContactRelation.ContactId,
                AccountContactRelation.AccountId
                };
                    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START

    /**
     * @description selectById description
     *
     * @param idSet (Set<Id>): idSet
     * @return List<AccountContactRelation>: Return description
     */
    public List<AccountContactRelation> selectById(Set<Id> idSet) {
        return (List<AccountContactRelation>) Database.query(
            newQueryFactory()
            .selectField('Contact.ID_Number__c')
            .selectField('Contact.Name')
            .selectField('Contact.Account.CIF__c')
            .selectField('Account.CIF__c')
            .selectField('Account.Client_Type__c')
            .selectField('Contact.Account.Client_Type__c')
            .selectField('Id')//W-012954
            .selectField('ContactId')
            .selectField('Contact.Title')
            .selectField('Contact.Email')
            .selectField('Contact.Salutation')
            .selectField('Contact.Initials__c')
            .selectField('Contact.LastName')
            .selectField('Contact.MobilePhone')
            .selectField('Primary_Entity_Id__c')
            .selectField('Roles')
            .selectField('Designation__c')
            .selectField('ParentRelationshipId__c')
            .selectField('Contact.FirstName') 
            .selectField('Contact.MiddleName') 
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }

    //INHERIT FROM BASE CLASS - STOP

    //CUSTOM SELECTORS - START

    /**
* @description Method that returns a list of contacts by account Id
* @param accId
* @return List<Contact> - returns a list of contacts
*/
    public List<Account> selectListByAccId(Id accId) {
        List<AccountContactRelation> accConList = Database.query(
            newQueryFactory().
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('AccountId').
            selectField('Account.Name').
            selectField('Primary_Entity_Id__c').
            selectField('Account.pepSts__c').
            selectField('Account.status_pepsts__c').
            selectField('Account.CASA_Reference_Number__pc').
            selectField('Account.CASA_Analyst_Comments__pc').
            selectField('Primary_Entity_Id__c').
            selectField('Account.PEP_Status__pc').
            selectField('Account.PEP_Status__c').
            selectField('ParentRelationshipId__c').
            setCondition('AccountId = :accId OR Primary_Entity_Id__c =: accId').
            toSOQL()
        );

        Set<Id> conId = new Set<Id>();
        for(AccountContactRelation ac : accConList){
            conId.add(ac.ContactId);
        }

        List<Contact> contacts = new ContactsSelector().selectAccountIdBySetIds(conId);
        Set<Id> accountIds = new Set<Id>();
        for(Contact c : contacts){
            accountIds.add(c.AccountId);
        }

        List<Account> accounts = new AccountsSelector().selectCasaFieldsBySetId(accountIds);

        return accounts;
    }

    /**
* @description Method that returns a list of contacts by account Id
* @param accId
* @return List<Contact> - returns a list of contacts
*/
    public List<Contact> selectContactListByAccId(Id accId) {
        List<AccountContactRelation> accConList = Database.query(
            newQueryFactory().
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('AccountId').
            selectField('Account.Name').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('AccountId = :accId').
            toSOQL()
        );
        Set<Id> conId = new Set<Id>();
        for(AccountContactRelation ac : accConList){
            conId.add(ac.ContactId);
        }
        List<Contact> contacts = new ContactsSelector().selectAccountIdBySetIds(conId);
        return contacts;
    }

    /**
* @description Returns Account-Contact Relations
*
* @param accountId
* @param ids
* @param roles
* @return List<AccountContactRelation>
*/
    public List<AccountContactRelation> selectbyRoles(id accountId, set<id> ids, string roles) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('ContactId').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('AccountId =: accountId AND ContactId IN: ids AND Roles INCLUDES (:roles)').
            toSOQL()
        );
    }

    /**
* @description Returns Account-Contact Relations
* @Author - Tinashe M Shoko
* @param accountId
* @return List<AccountContactRelation>
* Tinashe - added Initials__c and LastName for story 4546 - 24-05-2020
*/
    public List<AccountContactRelation> selectRelationByAccountId(id accountId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('ContactId').
            selectField('Contact.Title').
            selectField('Contact.AccountId').
            selectField('Contact.Salutation').
            selectField('Contact.Initials__c').
            selectField('Contact.FirstName').
            selectField('Contact.LastName').
            selectField('Contact.Name').
            selectField('Contact.Email').
            selectField('ParentRelationshipId__c').
            selectField('Contact.MobilePhone').
            selectField('Contact.ID_Number__c').
            selectField('Contact.MiddleName').
            selectField('Account.Name'). //added By Himani
            selectField('Contact.Phone'). //added By Himani
            selectField('Roles').
            selectField('Share_Percentage__c').
            selectField('Account.ID_Number__pc').
            selectField('Account.CIF__c').
            selectField('AccountId').
            selectField('Contact.Account.Gender__pc').
            selectField('Contact.Account.Client_Type__c').
            selectField('ubo__c').
            selectField('Designation__c').
            selectField('Tax_Number__c').
            selectField('Tax_Residency__c').
            selectField('Primary_Entity_Id__c').
            selectField('Contact.ID_Type__c').
            setCondition('AccountId =: accountId AND Primary_Entity_Id__c != NULL').
            toSOQL()
        );
        
    }

    /**
    * @description Returns Account-Contact Relations
    * @Author - JQUEV
    * @param accountIdSet
    * @return List of AccountContactRelation
    */
    public List<AccountContactRelation> selectRelationByAccountIdSet(Set<Id> accountIdSet) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('ContactId').
            selectField('Contact.Title').
            selectField('Contact.AccountId').
            selectField('Contact.Salutation').
            selectField('Contact.Initials__c').
            selectField('Contact.FirstName').
            selectField('Contact.LastName').
            selectField('Contact.Name').
            selectField('Contact.Email').
            selectField('Contact.MobilePhone').
            selectField('Contact.ID_Number__c').
            selectField('Contact.MiddleName').
            selectField('Account.Name').
            selectField('Contact.Phone').
            selectField('Share_Percentage__c').
            selectField('Roles').
            setCondition('AccountId IN : accountIdSet').
            toSOQL()
        );
    }

    /**
     * 
    * @description W-004546 - Tinashe M Shoko
    * @param acrID
    * @return List<AccountContactRelation>
    * Added Salutations, Initials__c and lstname to select query
    * 27-05-2020
     */
    public List<AccountContactRelation> selectRelationById(id acrID) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('ContactId').
            selectField('Contact.Title').
            selectField('Contact.Name').
            selectField('Contact.Email').
            selectField('Contact.Salutation').
            selectField('Contact.Initials__c').
            selectField('Contact.LastName').
            selectField('Contact.MobilePhone').
            selectField('Primary_Entity_Id__c').
            selectField('Roles').
            selectField('Designation__c').
            selectField('ParentRelationshipId__c').
            selectField('Contact.FirstName'). //D Booysen 30-05-2020 W-004160
            selectField('Contact.MiddleName'). //D Booysen 30-05-2020 W-004160
            setCondition('Id =: acrId').
            toSOQL()
        );
    }

/**
 * @description selectRelationByAcctIdAndRoles description
 *
 * @param accountId (id): accountId
 * @param roles (string): roles
 * @return List<AccountContactRelation>: Return description
 */
    public List<AccountContactRelation> selectRelationByAcctIdAndRoles(id accountId, string roles) {
        return [SELECT Id,ContactId,Contact.Title,Contact.Salutation,Contact.Name,Contact.Initials__c,Contact.LastName, Contact.FirstName,
                Contact.Email,Contact.MobilePhone,Roles, Contact.Account.PersonTitle, Contact.Account.Initials__pc, Designation__c
                FROM AccountContactRelation
                WHERE AccountId =: accountId AND Roles INCLUDES ('Managing Director', 'Individual with Authority to Act', 'Shareholder/Controller')];
    }
    //CUSTOM SELECTORS - END

    /**
* @description Returns Account-Contact Relations
*
* @param accountId
* @return List<AccountContactRelation>
*/
    public List<AccountContactRelation> selectbyAccount(id accountId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('Contact.FirstName').
            selectField('Contact.LastName').
            selectField('Contact.Nationality__c').
            selectField('Contact.Birthdate').
            selectField('Contact.Title').
            selectField('Contact.Country_of_Birth__c').
            selectField('Contact.ID_Number__c').
            selectField('Contact.ID_Type__c').
            selectField('Contact.Gender__c').
            selectField('Contact.MobilePhone').
            selectField('Contact.Phone').
            selectField('Contact.Email').
            selectField('Contact.Fax').
            selectField('Contact.Highest_Qualification__c'). //field does not exist
            selectField('Account.CIF__c').
            selectField('Contact.CIF__c'). //Saurabh introduced this new field on Contact
            selectField('Account.Type').
            selectField('Account.Name').
            selectField('Account.Phone').
            selectField('Account.CASA_Screening_Date__c').
            selectField('Account.CASA_Reference_Number__c').
            selectField('Account.CASA_Screening_Status__c').
            selectField('Contact.CASA_Screening_Date__c').
            selectField('Contact.CASA_Reference_Number__c').
            selectField('Contact.CASA_Screening_Status__c').
            selectField('Date_Shareholding_Acquired__c').
            selectField('Roles').
            selectField('Designation__c').
            selectField('Share_Percentage__c').
            selectField('StartDate').
            selectField('Account.AuthMessage__c').
            selectField('Contact.AccountId').
            selectField('Primary_Entity_Id__c').
            selectField('Contact.Account.AuthMessage__c').
            selectField('Contact.Account.Number_Of_YearIn_The_Specific_Industry__c').
            selectField('Contact.Account.Months_Actively_Involved_In_The_Business__c').
            selectField('Account.Registration_Number__c').//Added By Danie Booysen
            selectField('Account.Customer_Compliant__c').//Added By Danie Booysen
            selectField('ParentRelationshipId__c').
            selectField('IsActive').
            selectField('UBO__c').
            setCondition('AccountId =: accountId OR Primary_Entity_Id__c =: accountId').//added by Anka Ganta 2020-08-05
            toSOQL()
        );
    }

    //CUSTOM SELECTORS - END

    //CUSTOM SELECTORS - END

    /**
* @description Returns Account-Contact Relations
*
* @param acrId
* @return AccountContactRelation
*/
    public AccountContactRelation selectbyAccountContactRelationId(id acrId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Contact.FirstName').
            selectField('Contact.LastName').
            selectField('Contact.Name').
            selectField('Contact.Nationality__c').
            selectField('Contact.Birthdate').
            selectField('Contact.Title').
            selectField('Contact.Phone').
            selectField('Contact.HomePhone').
            selectField('Contact.ID_Number__c').
            selectField('Contact.ID_Type__c').
            selectField('Account.CIF__c').
            selectField('Contact.CIF__c'). //Saurabh introduced this new field on Contact
            selectField('Contact.Email'). // added by Masechaba Maseli for document generation
            selectField('Contact.MobilePhone'). // added by Masechaba Maseli for document generation
            selectField('Account.Type').
            selectField('Account.Name').
            selectField('Account.Client_Type__c').
            selectField('Account.CASA_Screening_Date__c').
            selectField('Account.CASA_Reference_Number__c').
            selectField('Account.CASA_Screening_Status__c').
            selectField('Contact.CASA_Screening_Date__c').
            selectField('Contact.CASA_Reference_Number__c').
            selectField('Contact.CASA_Screening_Status__c').
            selectField('Roles').
            selectField('Share_Percentage__c').
            selectField('StartDate').
            selectField('Date_Shareholding_acquired__c').
            selectField('Contact.Gender__c').
            selectField('Contact.Initials__c').
            selectField('Contact.Communication_Language__c').
            selectField('Contact.Country_of_Birth__c').
            selectField('Contact.Country_of_Residence__c').
            selectField('Contact.Country_Passport_Issued__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('Designation__c').
            setCondition('Id =: acrId').
            toSOQL()
        );
    }

    /**
* @description Returns Account-Contact Relations
*
* @param accountId
* @param roles
* @return List<AccountContactRelation>
* D Booysen 10/07/2020
*/
    public List<AccountContactRelation> selectbyAccountIdAndRoles(Id accountId, String roles) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('ContactId').
            selectField('Contact.Title').
            selectField('Contact.Name').
            selectField('Account.Name').
            selectField('Contact.Phone').
            selectField('Contact.MobilePhone').
            selectField('Contact.Salutation').
            selectField('Contact.Initials__c').
            selectField('Contact.LastName').
            //Added by Sandeep Golla for AW 042 EX form
            selectField('Contact.Email').
            selectField('Contact.ID_Number__c').
            selectField('Account.ID_Number__pc').
            selectField('Contact.Passport_Number__c').
            selectField('Account.Passport_Number__pc').
            selectField('Primary_Entity_Id__c').
            selectField('Roles').
            selectField('Designation__c').
            selectField('ParentRelationshipId__c').
            selectField('Contact.Customer_Retention_Banker_Email__c').  // Added by prateek Absa 6261
            setCondition('AccountId =: accountId AND Roles INCLUDES (:roles)').
            toSOQL()
        );
    }

    /**
     * @description selectbyIdSet description
     *
     * @param ids (Set<Id>): ids
     * @return List<AccountContactRelation>: Return description
     */
    public List<AccountContactRelation> selectbyIdSet(Set<Id> ids) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('ContactId').
            selectField('Contact.Title').
            selectField('Contact.Name').
            selectField('Contact.FirstName').
            selectField('Contact.LastName').
            selectField('Account.Name').
            selectField('Contact.Phone').
            selectField('Contact.MobilePhone').
            selectField('Contact.ID_Number__c').
            selectField('Account.ID_Number__pc').
            selectField('Contact.Passport_Number__c').
            selectField('Account.Passport_Number__pc').
            selectField('Primary_Entity_Id__c').
            selectField('Roles').
            selectField('Designation__c').
            selectField('ParentRelationshipId__c').
            setCondition('Id IN :ids').
            toSOQL()
        );
    }

    /**
* @description Returns list of active directors
*
* @param accountId
* @param roles
* @return List<AccountContactRelation>
* D Booysen 10/07/2020
*/
    public List<AccountContactRelation> selectbyActiveDirectors(Id accountId, String roles) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('ContactId').
            selectField('Contact.Title').
            selectField('Contact.Name').
            selectField('Account.Name').
            selectField('Contact.Phone').
            selectField('Contact.MobilePhone').
            selectField('Contact.ID_Number__c').
            selectField('Account.ID_Number__pc').
            selectField('Contact.Passport_Number__c').
            selectField('Account.Passport_Number__pc').
            selectField('Primary_Entity_Id__c').
            selectField('Roles').
            selectField('Designation__c').
            selectField('ParentRelationshipId__c').
            setCondition('AccountId =: accountId AND Roles INCLUDES (:roles) AND IsActive = true').
            toSOQL()
        );
    }

    /**
* @description Returns Account-Contact Relations
* @Owner: Chandra (26/07/2020)
* @param primaryEntityId
* @param contactId
* @return List<AccountContactRelation>
*/
    public List<AccountContactRelation> selectbyPrimaryEntityIdAndContactId(String primaryEntityId, Id contactId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Share_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('Primary_Entity_Id__c =: primaryEntityId AND ContactId =: contactId').
            toSOQL()
        );
    }

    /**
* @description Returns Account-Contact Relations
* @Owner: Chandra (26/07/2020)
* @param accConRelId
* @return AccountContactRelation
*/
    public AccountContactRelation selectbyaccConRelId(Id accConRelId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Share_Percentage__c').
            selectField('Roles').
            selectField('Controlling_Percentage__c').
            selectField('Primary_Entity_Id__c').
            selectField('Tax_Number__c').
            selectField('Tax_Residency__c').
            selectField('ParentRelationshipId__c').
            setCondition('Id =: accConRelId').
            toSOQL()
        );
    }

    /**
* @description Returns Account-Contact Relations
* @Owner: Chandra (26/07/2020)
* @param primaryEntityId
* @return List<AccountContactRelation>
*/
    public List<AccountContactRelation> selectbyPrimaryEntityId(String primaryEntityId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Share_Percentage__c').
            selectField('Roles').
            selectField('Controlling_Percentage__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('Primary_Entity_Id__c =:primaryEntityId').
            toSOQL()
        );
    }

    /**
* @description Returns Account-Contact Relations
* @Owner: Masechaba Maseli
* @param primaryEntityId
* @param UBO
* @return List<AccountContactRelation>
*/
    public List<AccountContactRelation> selectUBOContacts(String primaryEntityId, String UBO) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('Share_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('UBO__c').
            selectField('Roles').//W-005550
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('Primary_Entity_Id__c =: primaryEntityId AND UBO__c =: UBO').
            toSOQL()
        );
    }

    /**
* @description Returns Account-Contact Relations
* @Owner: Tinashe
* @param accountId
* @param UBO
* @return List of AccountContactRelation
*/
    public List<AccountContactRelation> selectUBO(Id accountId, String UBO) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('Share_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('UBO__c').
            selectField('Roles').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('AccountId =: accountId AND UBO__c =: UBO').
            toSOQL()
        );
    }

    /**
     * @description parentIn description
     *
     * @param accountId (List<Id>): accountId
     * @return List<AccountContactRelation>: Return description
     */
    public List<AccountContactRelation> parentIn(List<Id> accountId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Contact.FirstName').
            selectField('Contact.LastName').
            selectField('Contact.Nationality__c').
            selectField('Contact.Birthdate').
            selectField('Contact.Title').
            selectField('Contact.Phone').
            selectField('Contact.HomePhone').
            selectField('Contact.ID_Number__c').
            selectField('Contact.ID_Type__c').
            selectField('Account.CIF__c').
            selectField('Contact.Email'). // added by Masechaba Maseli for document generation
            selectField('Contact.MobilePhone'). // added by Masechaba Maseli for document generation
            selectField('Account.Type').
            selectField('Account.Name').
            selectField('Account.CASA_Screening_Date__c').
            selectField('Account.CASA_Reference_Number__c').
            selectField('Account.CASA_Screening_Status__c').
            selectField('Contact.CASA_Screening_Date__c').
            selectField('Contact.CASA_Reference_Number__c').
            selectField('Contact.CASA_Screening_Status__c').
            selectField('Roles').
            selectField('Share_Percentage__c').
            selectField('StartDate').
            selectField('Contact.Gender__c').
            selectField('Contact.Initials__c').
            selectField('Contact.Communication_Language__c').
            selectField('Contact.Country_of_Birth__c').
            selectField('Contact.Country_of_Residence__c').
            selectField('Contact.Country_Passport_Issued__c').
            selectField('Primary_Entity_Id__c').
            selectField('Contact.Account.Client_Type__c').
            selectField('ParentRelationshipId__c').
            setCondition('Primary_Entity_Id__c in: accountId AND Share_Percentage__c > 0').
            toSOQL()
        );
    }

    /**
* @description Method that returns a list of accounts by account Id W-007512
*
* @param accId
* @param primaryEntityIds
* @return List<Account> - returns a list of accounts
*/
    public List<Account> selectListByAccIdAndPrimaryEntityId(Id accId,Set<Id> primaryEntityIds) {
        List<AccountContactRelation> accConList = Database.query(
            newQueryFactory().
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('AccountId').
            selectField('Account.Name').
            selectField('Primary_Entity_Id__c').
            selectField('Account.pepSts__c').
            selectField('Account.status_pepsts__c').
            selectField('Account.CASA_Reference_Number__pc').
            selectField('Account.CASA_Analyst_Comments__pc').
            selectField('Primary_Entity_Id__c').
            selectField('Account.PEP_Status__pc').
            selectField('Account.PEP_Status__c').
            selectField('ParentRelationshipId__c').
            setCondition('AccountId = :accId OR Primary_Entity_Id__c IN : primaryEntityIds').
            toSOQL()
        );

        Set<Id> conId = new Set<Id>();
        for(AccountContactRelation ac : accConList){
            //System.debug('ContactId' + ac.ContactId);
            //System.debug('Contact.Name' + ac.Contact.Name);
            //System.debug('AccountId' + ac.AccountId);
            //System.debug('Account.Name' + ac.Account.Name);
            conId.add(ac.ContactId);
        }

        List<Contact> contacts = new ContactsSelector().selectAccountIdBySetIds(conId);
        Set<Id> accountIds = new Set<Id>();
        for(Contact c : contacts){
            accountIds.add(c.AccountId);
        }

        List<Account> accounts = new AccountsSelector().selectCasaFieldsBySetId(accountIds);

        return accounts;
    }

            /**
    * @description Returns Account-Contact Relations
    *
    * @param identificationNumber
    * @param accId
    * @return List<AccountContactRelation>
    */
    public List<AccountContactRelation> selectbyIdNumber(string identificationNumber, Id accId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('Account.Name').
            selectField('Contact.ID_Number__c').
            selectField('Account.ID_Number__pc').
            selectField('Contact.Passport_Number__c').
            selectField('Account.Passport_Number__pc').
            selectField('Account.Registration_Number__c').
            selectField('Account.CIF__c').
            setCondition('(Contact.ID_Number__c = :identificationNumber OR Account.ID_Number__pc = :identificationNumber OR Contact.Passport_Number__c = :identificationNumber OR Account.Passport_Number__pc = :identificationNumber OR Account.Registration_Number__c =: identificationNumber) AND AccountId = : accId').
            toSOQL()
        );
    }

        /**
    * @description Returns Account-Contact Relations based on UBO Primaries
    *
    * @param primaryId
    * @param uboPrimaryIds
    * @param ubo
    * @return List<AccountContactRelation>
    */    
    public List<AccountContactRelation> selectbyUboPrimaryIds(Id primaryId, Set<Id> uboPrimaryIds, String ubo) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('Contact.AccountId').
            selectField('Contact.Account.Client_Type__c').
            selectField('Share_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('Roles').
            selectField('Primary_Entity_Id__c').
            selectField('UBO__c').
            setCondition('AccountId = :primaryId OR Primary_Entity_Id__c IN :uboPrimaryIds').
            toSOQL()
        );
    }

    /**
    * @description Returns Account-Contact Relations based on UBO Primaries
    * @param primaryId 
    * @return List<AccountContactRelation> 
    **/
    public List<AccountContactRelation> selectByRelatedPartySection(Id primaryId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('AccountId').
            selectField('ContactId').
            selectField('Contact.Name').
            selectField('Contact.AccountId').
            selectField('Contact.Account.Client_Type__c').
            selectField('Share_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('Roles').
            selectField('Primary_Entity_Id__c').
            selectField('UBO__c').
            setCondition('AccountId = :primaryId AND Share_Percentage__c = 0').
            toSOQL()
        );
    }
    
    //CUSTOM SELECTORS - END
    //
}