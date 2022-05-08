/**
* Apex Enterprise Design Patterns
* @description Selector Layer for Contact objects
*
* should go
* @author       Kyle Alexander (CloudSmiths), Tracy de Bruin (CloudSmiths), Nelson Chisoko (Dariel) , Muvhuso Nekhubvi(Absa)
* @since        2018-07-17
* @modified     2019/07/17
*/
public class ContactsSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
    /**
     * @description getSObjectType description
     *
     * @return Schema.SObjectType: Return description
     */
    public Schema.SObjectType getSObjectType() {
        return Contact.sObjectType;
    }

    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Contact.LastName,
                Contact.Id,
                Contact.FirstName,
                Contact.Name,
                Contact.Email,
                Contact.MobilePhone,
                Contact.AccountId
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    /**
     * @description selectByName description
     *
     * @param names (Set<String>): names
     * @return List<Contact>: Return description
     */
    public List<Contact> selectByName( Set<String> names ){
        fflib_QueryFactory query = newQueryFactory();
        query.setCondition('Name IN :names');
        return (List<Contact>) Database.query( query.toSOQL() );
    }

    /**
     * @description selectById description
     *
     * @param idSet (Set<Id>): idSet
     * @return List<Contact>: Return description
     */
    public List<Contact> selectById(Set<Id> idSet) {
        return (List<Contact>) selectSObjectsById(idSet);
    }

    //Override default sort order i.e. CreatedDate
    /**
     * @description getOrderBy description
     *
     * @return overrideString: Return description
     */
    public override String getOrderBy(){
        return 'Name';
    }
    //INHERIT FROM BASE CLASS - STOP

    //CUSTOM SELECTORS - START

    /**
     * @description Method that gets a single contact from an Account's Person ID
     * @param personId
     * @param recordLimit
     * @return Contact - single contact with ID and email address
     */
    public Contact selectByPersonId(Id personId, Integer recordLimit) {
        return Database.query(
                newQueryFactory().
                        selectField('MobilePhone').
                        selectField('Name').
            			selectField('Account.Client_Type__c').
                        setCondition('id = :personId').
                        setLimit(recordLimit).
                        toSOQL()
        );
    }


    /**
     * @description Method that takes a set of contact ID's
     * @param contactIds
     * @return List<Contact> - returns a list of contacts
     */
    public List<Contact> selectByListContactIds(Set<Id> contactIds) {
        return Database.query(
            newQueryFactory().
            selectField('Account.Client_Type__c').
            selectField('ID_Number__c').
            selectField('Account.CIF__c').
            selectField('ID_Number__c').
            setCondition('Id in :contactIds').
            toSOQL()
        );
    }

    /**
     * @description Method that takes a set of contact ID's
     * @param idNumber
     * @return List<Contact> - returns a list of contacts
     */
    public List<Contact> selectByIdNumber(String idNumber) {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Account.Client_Type__c').
            selectField('ID_Number__c').
            selectField('Account.CIF__c').
            setCondition('ID_Number__c = :part.idNumber').
            toSOQL()
        );
    }

    /**
     * @description Method that takes an account ID and returns all CIF related fields
     * @param accId
     * @return List<Contact> - returns a list of contacts
     */
    public List<Contact> selectCifFieldsByAccountId(Id accId) {
        return Database.query(
                newQueryFactory().
                        selectField('Id').
                        selectField('Initials__c').
                        selectField('FirstName').
                        selectField('LastName').
                        selectField('Birthdate').
                        selectField('ID_Number__c').
                        selectField('Income_Source__c').
                        selectField('Nationality__c').
                        selectField('Country_of_Birth__c').
                        selectField('Date_Issued__c').
                        selectField('Gender__c').
                        selectField('Id_Type__c').
                        selectField('Communication_Language__c').
                        selectField('Marital_Contract_Type__c').
                        selectField('Marital_Status__c').
                        selectField('Non_Credit_Marketing_Consent__c').
                        selectField('Occupation_Category__c').
                        selectField('Occupation_Status__c').
                        selectField('HomePhone').
                        selectField('MobilePhone').
                        selectField('Phone').
                        selectField('Email').
                        selectField('Non_Credit_Marketing_Indicator__c').
                        selectField('Employer_Name__c').
                        selectField('Title').
                        selectField('Name').
                        selectField('MailingAddress').
                        selectField('MailingCity').
                        selectField('MailingStreet').
                        selectField('MailingPostalCode').
                        selectField('MailingCountry').
                        selectField('Preferred_Communication_Method__c').
                        selectField('Country_of_Origin__c').
                        selectField('Country_of_Residence__c').
                        selectField('MiddleName').
                        selectField('Income_Tax_Number__c').
                        selectField('CountryPassport__c').
                        setCondition('accountId = :accId').
                        toSOQL()
        );
    }

    /**
     * @description Method that takes an account ID and returns all CIF related fields
     * @param conIds
     * @return List<Contact> - returns a list of contacts
     */
    public List<Contact> selectAccountIdBySetIds(Set<Id> conIds) {
        return Database.query(
                newQueryFactory().
                        selectField('Id').
            			selectField('Communication_Language__c').
            			selectField('AccountId').
                        setCondition('Id IN :conIds').
                        toSOQL()
        );
    }

    /**
     * @description Method that takes an account ID and returns all CIF related fields
     * @param conIds
     * @return List<Contact> - returns a list of contacts
     */
    public List<Contact> selectCifFieldsBySetContactIds(Set<Id> conIds) {
        return Database.query(
                newQueryFactory().
                        selectField('Id').
                        selectField('Initials__c').
                        selectField('FirstName').
                        selectField('LastName').
                        selectField('Birthdate').
                        selectField('ID_Number__c').
            			selectField('ID_Type__c').
                        selectField('Income_Source__c').
                        selectField('Nationality__c').
                        selectField('Country_of_Birth__c').
                        selectField('Occupation__c').
                        selectField('CASA_Reference_Number__c').
                        selectField('Date_Issued__c').
                        selectField('Gender__c').
                        selectField('Id_Type__c').
                        selectField('Communication_Language__c').
                        selectField('Marital_Contract_Type__c').
                        selectField('Marital_Status__c').
                        selectField('Non_Credit_Marketing_Consent__c').
                        selectField('Occupation_Category__c').
                        selectField('Occupation_Status__c').
                        selectField('HomePhone').
                        selectField('MobilePhone').
                        selectField('Phone').
                        selectField('Email').
                        selectField('Non_Credit_Marketing_Indicator__c').
                        selectField('Employer_Name__c').
                        selectField('Title').
                        selectField('Name').
                        selectField('MailingAddress').
                        selectField('MailingCity').
                        selectField('MailingStreet').
                        selectField('MailingPostalCode').
                        selectField('MailingCountry').
                        selectField('Preferred_Communication_Method__c').
                        selectField('Country_of_Origin__c').
                        selectField('Country_of_Residence__c').
                        selectField('MiddleName').
                        selectField('Income_Tax_Number__c').
                        selectField('CountryPassport__c').
                        setCondition('Id IN :conIds').
                        toSOQL()
        );
    }

    /**
     * @description selectCifFieldsByContactId description
     *
     * @param conId (Id): conId
     * @return Contact: Return description
     */
    public Contact selectCifFieldsByContactId(Id conId) {
        return Database.query(
                newQueryFactory().
                        selectField('Id').
                        selectField('Initials__c').
                        selectField('FirstName').
                        selectField('LastName').
                        selectField('Birthdate').
                        selectField('ID_Number__c').
            			selectField('ID_Type__c').
                        selectField('Income_Source__c').
                        selectField('Nationality__c').
                        selectField('Country_of_Birth__c').
                        selectField('Occupation__c').
                        selectField('CASA_Reference_Number__c').
                        selectField('Date_Issued__c').
                        selectField('Gender__c').
                        selectField('Id_Type__c').
                        selectField('Communication_Language__c').
                        selectField('Marital_Contract_Type__c').
                        selectField('Marital_Status__c').
                        selectField('Non_Credit_Marketing_Consent__c').
                        selectField('Occupation_Category__c').
                        selectField('Occupation_Status__c').
                        selectField('HomePhone').
                        selectField('MobilePhone').
                        selectField('Phone').
                        selectField('Email').
                        selectField('Non_Credit_Marketing_Indicator__c').
                        selectField('Employer_Name__c').
                        selectField('Title').
                        selectField('Name').
                        selectField('MailingAddress').
                        selectField('MailingCity').
                        selectField('MailingStreet').
                        selectField('MailingPostalCode').
                        selectField('MailingCountry').
                        selectField('Preferred_Communication_Method__c').
                        selectField('Country_of_Origin__c').
                        selectField('Country_of_Residence__c').
                        selectField('MiddleName').
                        selectField('Income_Tax_Number__c').
                        selectField('CountryPassport__c').
                        setCondition('Id = :conId').
                        toSOQL()
        );
    }

    /**
    * @description Return Contacts by Account Id's
    *
    * @param accountId
    *
    * @return List<Contact>
    */
    public List<Contact> selectByAccountId(Set<Id> accountId) {

        return Database.query(
                newQueryFactory(true).
                        setCondition('AccountId IN :accountId').
                        toSOQL()
        );
    }

    /**
   * @description Return Contacts
   *
   * @param recLimit Integer
   * @return List<Contact>
   */
    public List<Contact> selectRandomContacts(Integer recLimit) {
       return Database.query(
      		newQueryFactory(false).
            setLimit(recLimit).
            toSOQL()
   		);
   }

    /**
    * @description Return Contacts
    *
    * @param emailAddress String
    * @param recordLimit Integer
    * @return List<Contact>
    */
    public List<Contact> selectByEmail(Set<String> emailAddress, Integer recordLimit) {

        return Database.query(
                newQueryFactory().
                        setCondition('Email IN :emailAddress').
                        setLimit(recordLimit).
                        toSOQL()
        );
    }

    /**
    * @description Return Contacts
    *
    * @param emailAddress String
    * @return List<Contact>
    */
    public List<Contact> selectByEmails(Set<String> emailAddress) {

        return Database.query(
                newQueryFactory().
            			selectField('IsPersonAccount').
                        setCondition('Email IN :emailAddress AND IsPersonAccount = false').
                        toSOQL()
        );
    }

    /**
     * @description selectRelatedPartiesByAddressType description
     *
     * @param ids (Set<Id>): ids
     * @param accountId (Id): accountId
     * @return List<Contact>: Return description
     */
    public List<Contact> selectRelatedPartiesByAddressType(Set<Id> ids, Id accountId) {
        return [Select Id, AccountId, ID_Number__c, ID_Type__c, Name, Title, FirstName, LastName, Gender__c, Initials__c, Email, HomePhone, MobilePhone, Phone, Occupation_Status__c,Account.Communication_Language__pc,
        Occupation__c, Occupation_Category__c, Insolvent_Debit_Review__c, Nationality__c, CountryPassport__c, Communication_Language__c, Country_of_Birth__c,Account.Country_of_Citizenship__c,
         Country_of_Residence__c, Country_Passport_Issued__c,Birthdate,Date_Issued__c,Passport_Date_of_Issue__c, FinServ__ContactPreference__c, Fax,Account.Operating_Roles__c,Account.Type_of_Instruction__c,Account.Instruction_Method__c,Account.Account_Applicable__c,
         (
            Select Id, Share_Percentage__c, Controlling_Percentage__c, Roles, Designation__c, Account.ID_Number__pc, Account.Name, Account.PersonTitle,Primary_Entity_Id__c ,
            Account.FirstName, Account.LastName, Account.Gender__pc, Account.Initials__pc, Account.PersonEmail, Account.PersonHomePhone, Account.PersonMobilePhone, Account.Phone, Account.Occupation_Status__pc,
            Account.Occupation__pc, Account.Occupation_Category__pc, Account.Insolvent_Debit_Review__pc, Account.Nationality__pc, Account.CountryPassport__pc, Account.Communication_Language__pc, Account.Country_of_Birth__pc,Account.Language__c,
            Account.Country_of_Residence__pc, Account.Country_Passport_Issued__pc, Account.ID_Type__c, Account.ID_Type__pc, Account.PersonBirthdate, Account.Date_Issued__pc, Account.Passport_Date_of_Issue__pc, Account.Country_of_Citizenship__c
            ,Account.FinServ__ContactPreference__pc, IsActive, Compulsory_Signature__c, Group_No__c, Tax_Residency__c, Tax_Number__c, Account.Fax, Contact.Account.Operating_Roles__c, Contact.Account.Type_of_Instruction__c, Contact.Account.Instruction_Method__c
            FROM AccountContactRelations
            WHERE AccountId = : accountId), (
            Select Id, Client_Entity_Type__c,Address_Type__c, Shipping_State_Province__c, Shipping_Street__c, Shipping_Street_2__c, Shipping_Zip_Postal_Code__c, Shipping_Suburb__c,
            Shipping_City__c, Shipping_Country__c
            FROM Addresses__r
            WHERE Address_Type__c = 'Residential' OR Address_Type__c = 'Physical Address' LIMIT 1)
            FROM Contact
            WHERE Id IN :ids];
    }

        /**
     * @description Method that takes an account ID and returns all CIF related fields
     * @param conIds
     * @param mainPartyId
     * @param clientTypes
     * @return List<Contact> - returns a list of contacts
     */
    public List<Contact> selectMaritalDeclarationList(List<Id> conIds, Id mainPartyId, Set<String> clientTypes) {
        return [SELECT Id, Name ,ID_Number__c, Marital_Status__c, Marital_Contract_Type__c, Marital_Contract_Subtype__c, Married_Since__c,AccountId, Account.Client_Type__c
                FROM Contact
                WHERE (Id IN :conIds AND Account.PersonContactId = null)
                 OR (Id IN :conIds AND Account.PersonContactId != null AND Account.Client_Type__c IN :clientTypes)
                 OR (Account.Client_Type__c IN :clientTypes AND AccountId = :mainPartyId)
                 ];
    }
    /**
     * @description selectRelatedPartiesByAddressType
     * @param ids 
     * @param accountId 
     * @return List<Contact>
     */
    public List<Contact> selectRelatedPartiesByConIds(Set<Id> ids, Set<Id> accountId) {
        return [Select Id, AccountId, ID_Number__c, ID_Type__c, Name, Title, FirstName, LastName, Gender__c, Initials__c, Email, HomePhone, MobilePhone, Phone, Occupation_Status__c,Account.Communication_Language__pc,
        Occupation__c, Occupation_Category__c, Insolvent_Debit_Review__c, Nationality__c, CountryPassport__c, Communication_Language__c, Country_of_Birth__c,Account.Country_of_Citizenship__c,
         Country_of_Residence__c, Country_Passport_Issued__c,Birthdate,Date_Issued__c,Passport_Date_of_Issue__c, FinServ__ContactPreference__c, Fax,Account.Operating_Roles__c,Account.Type_of_Instruction__c,Account.Instruction_Method__c,Account.Account_Applicable__c,
         (
            Select Id, Share_Percentage__c, Controlling_Percentage__c, Roles, Designation__c, Account.ID_Number__pc, Account.Name, Account.PersonTitle,Primary_Entity_Id__c ,
            Account.FirstName, Account.LastName, Account.Gender__pc, Account.Initials__pc, Account.PersonEmail, Account.PersonHomePhone, Account.PersonMobilePhone, Account.Phone, Account.Occupation_Status__pc,
            Account.Occupation__pc, Account.Occupation_Category__pc, Account.Insolvent_Debit_Review__pc, Account.Nationality__pc, Account.CountryPassport__pc, Account.Communication_Language__pc, Account.Country_of_Birth__pc,Account.Language__c,
            Account.Country_of_Residence__pc, Account.Country_Passport_Issued__pc, Account.ID_Type__c, Account.ID_Type__pc, Account.PersonBirthdate, Account.Date_Issued__pc, Account.Passport_Date_of_Issue__pc, Account.Country_of_Citizenship__c
            ,Account.FinServ__ContactPreference__pc, IsActive, Compulsory_Signature__c, Group_No__c, Tax_Residency__c, Tax_Number__c, Account.Fax, Contact.Account.Operating_Roles__c, Contact.Account.Type_of_Instruction__c, Contact.Account.Instruction_Method__c
            FROM AccountContactRelations WHERE Primary_Entity_Id__c IN : accountId), (
            Select Id, Client_Entity_Type__c,Address_Type__c, Shipping_State_Province__c, Shipping_Street__c, Shipping_Street_2__c, Shipping_Zip_Postal_Code__c, Shipping_Suburb__c,
            Shipping_City__c, Shipping_Country__c
            FROM Addresses__r
            WHERE Address_Type__c = 'Residential' OR Address_Type__c = 'Physical Address' LIMIT 1)
            FROM Contact
            WHERE Id IN :ids];
    }
    //CUSTOM SELECTORS - END
}