/**
 * @description securitiesOfferedSelector Description
 *
 */
public class securitiesOfferedSelector extends fflib_SObjectSelector {
    /**
     * @description getSObjectType description
     *
     * @return Schema.SObjectType: Return description
     */
    public Schema.SObjectType getSObjectType() {
        return Security_Offered__c.sObjectType;
    }

    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Security_Offered__c.Id
        };
    }

    /**
     * @description selectByApplicationId description
     *
     * @param applicationid (Id): applicationid
     * @return List<Security_Offered__c>: Return description
     */
    public List<Security_Offered__c> selectByApplicationId(Id applicationid) {
        List<Security_Offered__c> secsOff = new List<Security_Offered__c>();
        String query = ' SELECT ';
        String field_name = null;
        Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Security_Offered__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_oject_map.values();

        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }

        query += 'Contact__r.Name, Account__r.Name, Account__r.Registration_Number__c, Account__r.ID_Number__pc, Contact__r.ID_Number__c, ';
        query += 'Contact__r.Email, Account__r.PersonEmail, Account__r.Active_Email__c, Contact__r.Account.Client_Type__c, ';
       
        query = query.subStringBeforeLast(',');
        query += ' FROM Security_Offered__c WHERE Application__c =  \'' + applicationid + '\'';

        secsOff = (List<Security_Offered__c>)Database.query( query );
        return secsOff;
    }

    /**
     * @description selectByApplicationIdCOG description
     *
     * @param applicationid (Id): applicationid
     * @param SecurityType (String): SecurityType
     * @param Bondtype (List<String>): Bondtype
     * @return List<Security_Offered__c>: Return description
     */
   public List<Security_Offered__c> selectByApplicationIdCOG(Id applicationid,String SecurityType,List<String> Bondtype) {
   return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Name').
            selectField('Account__c').
            selectField('Account__r.Name').
            selectField('Client_Name__c').
            selectField('Contact__r.Name').
            selectField('Bond_type__c').
            selectField('Other_Securities__c').
            setCondition('Application__c =: applicationid AND Security_Type__c=:SecurityType AND Bond_type__c IN:Bondtype').
            setLimit(50000).
            toSOQL()
        );
    }

    /**
     * @description selectByAccountId description
     *
     * @param accountId (Id): accountId
     * @return List<Security_Offered__c>: Return description
     */
    public List<Security_Offered__c> selectByAccountId(Id accountId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Name').
            selectField('Account__c').
            selectField('Contact__c').
            selectField('Account__r.Name').
            selectField('Contact__r.Name').
            selectField('Security_Type__c').
            selectField('Security_Description__c').
            selectField('Property_description__c').
            selectField('Security_Amount__c').
            selectField('Reference_Account_Number__c').
            selectField('Nominal_Value__c').
            selectField('Approved_Security_Value_Percentage_ASV__c').
            selectField('ASV_approved_by_Credit__c').
            selectField('Specific_Account__c').
            selectField('Approved_Security_Value_ASV__c').
            selectField('Approved_security_value__c').
            selectField('ASV_as_approved_by_Credit__c').
            selectField('Description_of_Letter_of_Undertaking__c').
            selectField('Specific_Security__c').
            selectField('Securities_Offered_for_Facility__c').
            selectField('External_Entity_Linked__c').
            selectField('Unique_Identifier__c').
            setCondition('Account__c =: accountId ').
            setLimit(50000).
            toSOQL()
        );
    }

    /**
     * @description selectByContactId description
     *
     * @param contactId (Id): contactId
     * @return List<Security_Offered__c>: Return description
     */
    public List<Security_Offered__c> selectByContactId(Id contactId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Name').
            selectField('Account__c').
            selectField('Contact__c').
            selectField('Account__r.Name').
            selectField('Contact__r.Name').
            selectField('Security_Type__c').
            selectField('Security_Description__c').
            selectField('Property_description__c').
            selectField('Security_Amount__c').
            selectField('Reference_Account_Number__c').
            selectField('Nominal_Value__c').
            selectField('Approved_Security_Value_Percentage_ASV__c').
            selectField('ASV_approved_by_Credit__c').
            selectField('Specific_Account__c').
            selectField('Approved_Security_Value_ASV__c').
            selectField('Approved_security_value__c').
            selectField('ASV_as_approved_by_Credit__c').
            selectField('Description_of_Letter_of_Undertaking__c').
            selectField('Specific_Security__c').
            selectField('Securities_Offered_for_Facility__c').
            selectField('External_Entity_Linked__c').
            selectField('Unique_Identifier__c').
            setCondition('Contact__c =: contactId').
            setLimit(50000).
            toSOQL()
        );
    }

    /**
     * @description Added By Himani Joshi for loading Security Offered Account
     *
     * @param securityOfferedId (String): securityOfferedId
     * @return List<Security_Offered__c>: Return description
     */
    public List<Security_Offered__c> selectById(String securityOfferedId) {
        List<Security_Offered__c> secsOff = new List<Security_Offered__c>();
        String query = ' SELECT ';
        String field_name = null;
        Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Security_Offered__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_oject_map.values();

        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }
        query += 'Contact__r.Name, Contact__r.ID_Number__c, Account__r.Name, Account__r.Registration_Number__c, Account__r.ID_Number__pc, Account__r.Active_Email__c, ';
        query = query.subStringBeforeLast(',');
        query += ' FROM Security_Offered__c WHERE Id =  \'' + securityOfferedId + '\'';

        secsOff = (List<Security_Offered__c>)Database.query( query );
        return secsOff;
    }

    /**
     * @description selectByAppIdAndContactId description
     *
     * @param appId (Id): appId
     * @param contactId (Id): contactId
     * @return List<Security_Offered__c>: Return description
     */
    public List<Security_Offered__c> selectByAppIdAndContactId(Id appId, Id contactId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Name').
            selectField('Account__c').
            selectField('Contact__c').
            selectField('Account__r.Name').
            selectField('Contact__r.Name').
            selectField('Security_Type__c').
            selectField('Security_Description__c').
            selectField('Property_description__c').
            selectField('Security_Amount__c').
            selectField('Bond_amount_registered_offered__c').
            selectField('Amount_ceded__c').
            selectField('Pledge_amount__c').
            selectField('Excon_Approved_Amount__c').
            selectField('Cession_Amount__c').
            selectField('Policy_amount__c').
            selectField('Nominal_Value__c').
            selectField('Approved_Security_Value_Percentage_ASV__c').
            selectField('ASV_approved_by_Credit__c').
            selectField('Specific_Account__c').
            selectField('Reference_Account_Number__c').
            selectField('Approved_Security_Value_ASV__c').
            selectField('Approved_security_value__c').
            selectField('ASV_as_approved_by_Credit__c').
            selectField('Description_of_Letter_of_Undertaking__c').
            selectField('Specific_Security__c').
            selectField('Securities_Offered_for_Facility__c').
            selectField('External_Entity_Linked__c').
            selectField('Unique_Identifier__c').
            setCondition('Application__c =: appId AND Contact__c =: contactId').
            setLimit(50000).
            toSOQL()
        );
    }

    /**
     * @description selectByAppIdAndAccountId description
     *
     * @param appId (Id): appId
     * @param accountId (Id): accountId
     * @return List<Security_Offered__c>: Return description
     */
    public List<Security_Offered__c> selectByAppIdAndAccountId(Id appId, Id accountId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Name').
            selectField('Account__c').
            selectField('Contact__c').
            selectField('Account__r.Name').
            selectField('Contact__r.Name').
            selectField('Security_Type__c').
            selectField('Security_Description__c').
            selectField('Property_description__c').
            selectField('Security_Amount__c').
            selectField('Bond_amount_registered_offered__c').
            selectField('Amount_ceded__c').
            selectField('Pledge_amount__c').
            selectField('Excon_Approved_Amount__c').
            selectField('Cession_Amount__c').
            selectField('Policy_amount__c').
            selectField('Nominal_Value__c').
            selectField('Approved_Security_Value_Percentage_ASV__c').
            selectField('ASV_approved_by_Credit__c').
            selectField('Specific_Account__c').
            selectField('Reference_Account_Number__c').
            selectField('Approved_Security_Value_ASV__c').
            selectField('Approved_security_value__c').
            selectField('ASV_as_approved_by_Credit__c').
            selectField('Description_of_Letter_of_Undertaking__c').
            selectField('Specific_Security__c').
            selectField('Securities_Offered_for_Facility__c').
            selectField('External_Entity_Linked__c').
            selectField('Unique_Identifier__c').
            setCondition('Application__c =: appId AND Account__c =: accountId AND Contact__c = null AND External_Entity_Linked__c = true').
            setLimit(50000).
            toSOQL()
        );
    }

    /**
     * @description selectByAppIdAndRefNum description
     *
     * @param appId (Id): appId
     * @param refNum (string): refNum
     * @return List<Security_Offered__c>: Return description
     */
    public List<Security_Offered__c> selectByAppIdAndRefNum(Id appId, string refNum) {
        String refNumber =  '%'+refNum+'%';
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Name').
            selectField('Account__c').
            selectField('Contact__c').
            selectField('Account__r.Name').
            selectField('Contact__r.Name').
            selectField('Security_Type__c').
            selectField('Security_Description__c').
            selectField('Property_description__c').
            selectField('Security_Amount__c').
            selectField('Bond_amount_registered_offered__c').
            selectField('Amount_ceded__c').
            selectField('Pledge_amount__c').
            selectField('Excon_Approved_Amount__c').
            selectField('Cession_Amount__c').
            selectField('Policy_amount__c').
            selectField('Nominal_Value__c').
            selectField('Approved_Security_Value_Percentage_ASV__c').
            selectField('ASV_approved_by_Credit__c').
            selectField('Specific_Account__c').
            selectField('Reference_Account_Number__c').
            selectField('Approved_Security_Value_ASV__c').
            selectField('Approved_security_value__c').
            selectField('ASV_as_approved_by_Credit__c').
            selectField('Description_of_Letter_of_Undertaking__c').
            selectField('Specific_Security__c').
            selectField('Securities_Offered_for_Facility__c').
            selectField('External_Entity_Linked__c').
            selectField('Unique_Identifier__c').
            selectField('Client_Name__c').
            setCondition('Application__c =: appId AND (Unique_Identifier__c =: refNum OR Reference_Account_Number__c =: refNum)').
            //updated by Manish for W-011371
           	//setCondition('Application__c =: appId AND (Unique_Identifier__c LIKE : refNumber OR Reference_Account_Number__c LIKE: refNumber)').
            setLimit(50000).
            toSOQL()
        );
    }

    /**
     * @description selectExternalSecuritiesOffered description
     *
     * @param appId (Id): appId
     * @return List<Security_Offered__c>: Return description
     */
    public List<Security_Offered__c> selectExternalSecuritiesOffered(Id appId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Application__c').
            selectField('Name').
            selectField('Account__c').
            selectField('Contact__c').
            selectField('Account__r.Name').
            selectField('Contact__r.Name').
            selectField('Security_Type__c').
            selectField('Security_Description__c').
            selectField('Property_description__c').
            selectField('Security_Amount__c').
            selectField('Bond_amount_registered_offered__c').
            selectField('Amount_ceded__c').
            selectField('Pledge_amount__c').
            selectField('Excon_Approved_Amount__c').
            selectField('Cession_Amount__c').
            selectField('Policy_amount__c').
            selectField('Nominal_Value__c').
            selectField('Approved_Security_Value_Percentage_ASV__c').
            selectField('ASV_approved_by_Credit__c').
            selectField('Specific_Account__c').
            selectField('Reference_Account_Number__c').
            selectField('Approved_Security_Value_ASV__c').
            selectField('Approved_security_value__c').
            selectField('ASV_as_approved_by_Credit__c').
            selectField('Description_of_Letter_of_Undertaking__c').
            selectField('Specific_Security__c').
            selectField('Securities_Offered_for_Facility__c').
            selectField('External_Entity_Linked__c').
            selectField('Unique_Identifier__c').
            selectField('Client_Name__c').
            setCondition('Application__c =: appId AND External_Entity_Linked__c = false').
            setLimit(50000).
            toSOQL()
        );
    }
}