/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Service_Group_Type__c objects
 *
 * @author  Rudolf Niehaus - CloudSmiths
 * @since   2018-07-23
 */

public without sharing class ServiceGroupTypesSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    /**
	 * @description MANDATORY ABSTRACT METHODS - START
	 * @return Schema.SObjectType
	 */
    public Schema.SObjectType getSObjectType() {
        return Service_Group_Type__c.sObjectType;
    }
    /**
	 * @description
	 * @return Schema.SObjectType
	 */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Service_Group_Type__c.Id,
            Service_Group_Type__c.Service_Group__c,
            Service_Group_Type__c.Service_Type__c,
            Service_Group_Type__c.Service_Level__c,
            Service_Group_Type__c.sd_Communication_Plan__c,
            Service_Group_Type__c.Financial_Product__c,
            Service_Group_Type__c.Process_Type__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START

    /**
    * @description get Service_Group_Type__c by id's
    * @param idSet
    * @return List<Service_Group_Type__c>
    **/
    public List<Service_Group_Type__c> selectById(Set<Id> idSet) {
        return (List<Service_Group_Type__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END
    //CUSTOM SELECTORS - START

    /**
     * @description Return All Service_Group_Type__c by Service_Type__c ID
     * @param idSet set<Id> Set with Service_Type__c Ids
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceTypeId(Set<Id> idSet) {
        return (List<Service_Group_Type__c>) Database.query(newQueryFactory().setCondition('Service_Type__c IN :idSet').toSOQL());
    }

    /**
     * @description Return All Service_Group_Type__c by Service_Level__c ID
     * @param idSet set<Id> Set with Service_Level__c Ids
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceLevelId(Set<Id> idSet) {
        return (List<Service_Group_Type__c>) Database.query(newQueryFactory().setCondition('Service_Level__c IN :idSet').toSOQL());
    }

    /**
     * @description Return All Service_Group_Type__c With Service_Type__c Parent fields by Service_Type__c ID
     * @param idSet set<Id> Set with Service_Type__c Ids
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceTypeIdWithParentFields(Set<Id> idSet) {
        return (List<Service_Group_Type__c>) Database.query(
            newQueryFactory()
                .selectField('Service_Type__r.Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Name')
                .setCondition('Service_Type__c IN :idSet')
                .toSOQL()
        );
    }

    /**
     * @description Return Service_Group_Type__c with Service Type and SLA Information Custom selector USING the Base class queryFactory
     * @param serviceTypeId Id
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceTypeWithGroupAndServiceInfo(Set<Id> serviceTypeId) {
        return Database.query(
            newQueryFactory(false)
                .selectField('Id')
                .selectField('Service_Level__c')
                .selectField('Service_Level__r.External_SLA__c')
                .selectField('Service_Level__r.External_SLA_Time_Measure__c')
                .selectField('Service_Level__r.External_SLA_Units__c')
                .selectField('Service_Level__r.Max_SLA_Extension__c')
                .selectField('Service_Level__r.Max_SLA_Time_Measure__c')
                .selectField('Service_Level__r.Max_SLA_Units__c')
                .selectField('Service_Level__r.Email_Template_Case_Classification__c')
                .selectField('Service_Level__r.Email_Template_Case_Closure__c')
                .selectField('Service_Level__r.External_SLA_Warning__c')
                .selectField('Service_Level__r.Default_Service_Level__c')
                .selectField('Service_Level__r.External_SLA_Notification_User__c')
                .selectField('Service_Group__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Assign_Record_Type__c')
                .selectField('Service_Group__r.Internal_SLA_Time_Measure__c')
                .selectField('Service_Group__r.Internal_SLA_Units__c')
                .selectField('Service_Group__r.Internal_SLA_Warning__c')
                .selectField('Service_Group__r.Business_Hours__c')
                .selectField('Service_Group__r.Track_Status_Changes__c')
                .selectField('Service_Group__r.Email_Template_Case_Creation__c')
                .selectField('Service_Group__r.Response_Email_Address__c')
                .selectField('Service_Group__r.Internal_SLA_Notification_User__c')
                .selectField('Service_Group__r.Manager__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Service_Type__r.Product__c')
                .selectField('Service_Type__r.FAIS_NCA__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Name')
                .selectField('Service_Group__r.Pause_Statuses__c')
                .selectField('sd_Communication_Plan__c')
                .setCondition('Service_Type__c IN :serviceTypeId')
                .toSOQL()
        );
    }

    /**
     * @description Return Service_Group_Type__c with SLA and Communication Plan Information Custom selector USING the Base class queryFactory
     * @param serviceGroupId Id
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceGroupWithServiceLevelInfo(Set<Id> serviceGroupId) {
        return Database.query(
            newQueryFactory(false)
                .selectField('Id')
                .selectField('Service_Level__c')
                .selectField('Service_Level__r.External_SLA__c')
                .selectField('Service_Level__r.External_SLA_Time_Measure__c')
                .selectField('Service_Level__r.External_SLA_Units__c')
                .selectField('Service_Level__r.Max_SLA_Extension__c')
                .selectField('Service_Level__r.Max_SLA_Time_Measure__c')
                .selectField('Service_Level__r.Max_SLA_Units__c')
                .selectField('Service_Level__r.Email_Template_Case_Classification__c')
                .selectField('Service_Level__r.Email_Template_Case_Closure__c')
                .selectField('Service_Level__r.External_SLA_Warning__c')
                .selectField('Service_Level__r.Default_Service_Level__c')
                .selectField('Service_Level__r.External_SLA_Notification_User__c')
                .selectField('sd_Communication_Plan__c')
                .selectField('sd_Communication_Plan__r.Name')
                .selectField('Service_Group__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Assign_Record_Type__c')
                .selectField('Service_Group__r.Internal_SLA_Notification_User__c')
                .selectField('Service_Group__r.Internal_SLA_Time_Measure__c')
                .selectField('Service_Group__r.Internal_SLA_Units__c')
                .selectField('Service_Group__r.Internal_SLA_Warning__c')
                .selectField('Service_Group__r.Business_Hours__c')
                .selectField('Service_Group__r.Track_Status_Changes__c')
                .selectField('Service_Group__r.Email_Template_Case_Creation__c')
                .selectField('Service_Group__r.Response_Email_Address__c')
                .selectField('Service_Group__r.Pause_Statuses__c')
                .selectField('Service_Group__r.ATM_Deposit_Queue__c')
                .selectField('Service_Group__r.ATM_Prepaid_Queue__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Group__r.Manager__c')
                .selectField('Service_Group__r.Skip_Split_Auto_Response__c')
                .setCondition('Service_Group__c IN :serviceGroupId AND Service_Level__r.Default_Service_Level__c = true')
                .toSOQL()
        );
    }

    /**
     * @description Return Service_Group_Type__c with SLA and Communication Plan Information for Manual Cases Custom selector USING the Base class queryFactory
     * @param serviceGroupId Id
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceGroupWithServiceLevelInfoForManual(Set<Id> serviceGroupId) {
        return Database.query(
            newQueryFactory(false)
                .selectField('Id')
                .selectField('Service_Level__c')
                .selectField('Service_Level__r.External_SLA__c')
                .selectField('Service_Level__r.External_SLA_Time_Measure__c')
                .selectField('Service_Level__r.External_SLA_Units__c')
                .selectField('Service_Level__r.Max_SLA_Extension__c')
                .selectField('Service_Level__r.Max_SLA_Time_Measure__c')
                .selectField('Service_Level__r.Max_SLA_Units__c')
                .selectField('Service_Level__r.Email_Template_Case_Classification__c')
                .selectField('Service_Level__r.Email_Template_Case_Closure__c')
                .selectField('Service_Level__r.External_SLA_Warning__c')
                .selectField('Service_Level__r.Default_Service_Level__c')
                .selectField('Service_Level__r.External_SLA_Notification_User__c')
                .selectField('sd_Communication_Plan__c')
                .selectField('sd_Communication_Plan__r.Name')
                .selectField('Service_Group__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Assign_Record_Type__c')
                .selectField('Service_Group__r.Internal_SLA_Notification_User__c')
                .selectField('Service_Group__r.Internal_SLA_Time_Measure__c')
                .selectField('Service_Group__r.Internal_SLA_Units__c')
                .selectField('Service_Group__r.Internal_SLA_Warning__c')
                .selectField('Service_Group__r.Business_Hours__c')
                .selectField('Service_Group__r.Track_Status_Changes__c')
                .selectField('Service_Group__r.Email_Template_Case_Creation__c')
                .selectField('Service_Group__r.Response_Email_Address__c')
                .selectField('Service_Group__r.Pause_Statuses__c')
                .selectField('Service_Group__r.ATM_Deposit_Queue__c')
                .selectField('Service_Group__r.ATM_Prepaid_Queue__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .setCondition('Service_Group__c IN :serviceGroupId AND Service_Level__r.Default_Service_Level__c = true AND Flow__c = \'XDS_Only\'')
                .toSOQL()
        );
    }

    /**
     * @description Return Service_Group_Type__c with SLA Information Custom selector USING the Base class queryFactory
     * @param serviceGroupId Id
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceGroupWithGroupAndServiceInfo(Set<Id> serviceGroupId) {
        return Database.query(
            newQueryFactory(false)
                .selectField('Id')
                .selectField('Service_Level__c')
                .selectField('Service_Level__r.External_SLA__c')
                .selectField('Service_Level__r.External_SLA_Time_Measure__c')
                .selectField('Service_Level__r.External_SLA_Units__c')
                .selectField('Service_Level__r.Max_SLA_Extension__c')
                .selectField('Service_Level__r.Max_SLA_Time_Measure__c')
                .selectField('Service_Level__r.Max_SLA_Units__c')
                .selectField('Service_Level__r.Email_Template_Case_Classification__c')
                .selectField('Service_Level__r.Email_Template_Case_Closure__c')
                .selectField('Service_Level__r.External_SLA_Warning__c')
                .selectField('Service_Level__r.Default_Service_Level__c')
                .selectField('Service_Level__r.External_SLA_Notification_User__c')
                .selectField('sd_Communication_Plan__c')
                .selectField('sd_Communication_Plan__r.Name')
                .selectField('Service_Group__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Assign_Record_Type__c')
                .selectField('Service_Group__r.Internal_SLA_Time_Measure__c')
                .selectField('Service_Group__r.Internal_SLA_Units__c')
                .selectField('Service_Group__r.Internal_SLA_Warning__c')
                .selectField('Service_Group__r.Business_Hours__c')
                .selectField('Service_Group__r.Track_Status_Changes__c')
                .selectField('Service_Group__r.Email_Template_Case_Creation__c')
                .selectField('Service_Group__r.Response_Email_Address__c')
                .selectField('Service_Group__r.Pause_Statuses__c')
                .selectField('Service_Group__r.Internal_SLA_Notification_User__c')
                .selectField('Service_Group__r.Manager__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Id')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Service_Type__r.Product__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Name')
                .setCondition('Service_Group__c IN :serviceGroupId')
                .toSOQL()
        );
    }

    /**
     * @description Return Service_Group_Type__c with SLA Information Custom selector USING the Base class queryFactory
     * @param productIds Set<String> serviceGroupNames
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByLeadProductBusinessUnitNames(Set<String> productIds) {
        return Database.query(
            newQueryFactory(false)
                .selectField('Id')
                .selectField('Service_Level__c')
                .selectField('Service_Level__r.External_SLA__c')
                .selectField('Service_Level__r.External_SLA_Time_Measure__c')
                .selectField('Service_Level__r.External_SLA_Units__c')
                .selectField('Service_Level__r.Max_SLA_Extension__c')
                .selectField('Service_Level__r.Max_SLA_Time_Measure__c')
                .selectField('Service_Level__r.Max_SLA_Units__c')
                .selectField('Service_Level__r.External_SLA_Warning__c')
                .selectField('Service_Level__r.Default_Service_Level__c')
                .selectField('sd_Communication_Plan__c')
                .selectField('sd_Communication_Plan__r.Name')
                .selectField('Service_Group__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Internal_SLA_Time_Measure__c')
                .selectField('Service_Group__r.Internal_SLA_Units__c')
                .selectField('Service_Group__r.Internal_SLA_Warning__c')
                .selectField('Service_Group__r.Business_Hours__c')
                .selectField('Service_Group__r.Track_Status_Changes__c')
                .selectField('Service_Group__r.Response_Email_Address__c')
                .selectField('Service_Group__r.Manager__c')
                .selectField('Financial_Product__c')
                .selectField('Financial_Product__r.Name')
                .selectField('Financial_Product__r.Business_Unit__c')
                .selectField('Financial_Product__r.Product__c')
                .selectField('Financial_Product__r.Sub_Product__c')
                .selectField('Financial_Product__r.Product_Code__c')
                .selectField('Financial_Product__r.Product_Group_Code__c')
                .selectField('Financial_Product__r.Product_Type__c')
                .selectField('Financial_Product__r.Type__c')
                //setCondition('Financial_Product__r.Business_Unit__c IN :productBusinessUnitNames').
                .setCondition('Financial_Product__c IN :productIds')
                .toSOQL()
        );
    }

    /**
     * @description Return Service_Group_Type__c by Service Group Id
     * @param serviceGroupId Id
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceGroupId(Set<Id> serviceGroupId) {
        return Database.query(newQueryFactory(true).setCondition('Service_Group__c IN :serviceGroupId').toSOQL());
    }

    /**
     * @description Return Service_Group_Type__c with Service Type and SLA Information
     * @param serviceGroupId Id
     * @param serviceTypeId Id
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceTypeAndServiceGroupWithRelatedInfo(Id serviceGroupId, Id serviceTypeId) {
        return Database.query(
            newQueryFactory(false)
                .selectField('Id')
                .selectField('Service_Level__c')
                .selectField('Service_Level__r.External_SLA__c')
                .selectField('Service_Level__r.External_SLA_Time_Measure__c')
                .selectField('Service_Level__r.External_SLA_Units__c')
                .selectField('Service_Level__r.Max_SLA_Extension__c')
                .selectField('Service_Level__r.Max_SLA_Time_Measure__c')
                .selectField('Service_Level__r.Max_SLA_Units__c')
                .selectField('Service_Level__r.Email_Template_Case_Classification__c')
                .selectField('Service_Level__r.Email_Template_Case_Closure__c')
                .selectField('Service_Level__r.External_SLA_Warning__c')
                .selectField('Service_Level__r.Default_Service_Level__c')
                .selectField('Service_Level__r.External_SLA_Notification_User__c')
                .selectField('Service_Group__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Internal_SLA_Time_Measure__c')
                .selectField('Service_Group__r.Internal_SLA_Units__c')
                .selectField('Service_Group__r.Internal_SLA_Warning__c')
                .selectField('Service_Group__r.Business_Hours__c')
                .selectField('Service_Group__r.Track_Status_Changes__c')
                .selectField('Service_Group__r.Email_Template_Case_Creation__c')
                .selectField('Service_Group__r.Response_Email_Address__c')
                .selectField('Service_Group__r.Internal_SLA_Notification_User__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Service_Type__r.Product__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Name')
                .selectField('Service_Group__r.Pause_Statuses__c')
                .setCondition('Service_Group__c = :serviceGroupId AND Service_Type__c = :serviceTypeId')
                .toSOQL()
        );
    }

    /**
    * @description Return Service_Group_Type__c with Service type, Service group, Service Limit Custom selector USING the Base class queryFactory
    * @param autoCaseCreation
    * @param searchKey
    * @param serviceGroups
    * @return List<Service_Group_Type__c>
    **/
    public List<Service_Group_Type__c> getServiceTypeWithServiceGroupAndServiceLimitInfo(
        Boolean autoCaseCreation,
        String searchKey,
        List<String> serviceGroups
    ) {
        return Database.query(
            newQueryFactory(true)
                .selectField('Id')
                .selectField('Name')
                .selectField('sd_Communication_Plan__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Name')
                .selectField('Service_Type__r.Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Product__c')
                .selectField('Service_Group__r.Id')
                .selectField('Service_Group__r.Business_Hours__c')
                .selectField('Service_Group__r.Response_Email_Address__c')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Level__c')
                .setCondition(
                    'Service_Type__r.Name LIKE \'' +
                    searchKey +
                    '\' AND Auto_Case_Creation__c = :autoCaseCreation AND Service_Group__r.Name IN :serviceGroups AND Service_Type__r.Case_Record_Type__c != \'Onboarding\''
                )
                .toSOQL()
        );
    }

    /**
    * @description Return Service_Group_Type__c with Service type, Service group, Service Limit
    * @param autoCaseCreation
    * @param searchKey
    * @param serviceGroups
    * @return List<Service_Group_Type__c>
    */
    public List<Service_Group_Type__c> getServiceTypeWithServiceGroupAndServiceLimitInfoForOnboarding(
        Boolean autoCaseCreation,
        String searchKey,
        List<String> serviceGroups
    ) {
        return Database.query(
            newQueryFactory(true)
                .selectField('Id')
                .selectField('Name')
                .selectField('sd_Communication_Plan__c')
                .selectField('Flow__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Name')
                .selectField('Service_Type__r.Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Product__c')
                .selectField('Service_Group__r.Id')
                .selectField('Service_Group__r.Business_Hours__c')
                .selectField('Service_Group__r.Response_Email_Address__c')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Level__c')
            	.selectField('Process_Type__c')
                .selectField('FIC_Refresh_Required__c')
                .setCondition(
                    'Service_Type__r.Name LIKE \'' +
                    searchKey +
                    '\' AND Auto_Case_Creation__c = :autoCaseCreation AND Service_Group__r.Name IN :serviceGroups'
                )
                .toSOQL()
        );
    }

    /**
     * @description Return Service_Group_Type__c by Service_Group__c Name and Service_Type__c Name
     * @param serviceGroupName string
     * @param serviceTypeName string
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByServiceGroupNameAndServiceTypeName(String serviceGroupName, String serviceTypeName) {
        return Database.query(
            newQueryFactory(true)
                .selectField('Id')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Name')
                .selectField('Service_Type__r.Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Service_Group__r.Id')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Group__r.Internal_SLA_Notification_User__c')
                .selectField('Service_Group__r.Queue__c')
                .selectField('Service_Group__r.Assign_Record_Type__c')
                .selectField('Service_Level__r.External_SLA_Notification_User__c')
                .setCondition('Service_Group__r.Name LIKE \'' + serviceGroupName + '\' AND Service_Type__r.Name LIKE \'' + serviceTypeName + '\'')
                .toSOQL()
        );
    }

    /**
     * @description Return Service_Group_Type__c with Service and SLA Information
     * @param ServiceGroupTypeId Id
     * @return Service_Group_Type__c
     */
    public Service_Group_Type__c selectByServiceGrpTypeId(Id ServiceGroupTypeId) {
        return Database.query(
            newQueryFactory(false)
                .selectField('Id')
                .selectField('Service_Level__c')
                .selectField('Service_Group__c')
                .selectField('Service_Group__r.Name')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Flow__c')
                .setCondition('Id = :ServiceGroupTypeId')
                .toSOQL()
        );
    }

    /**
     * @description Koketso Mpshane - Return All Service Types linked to a selected product by Product ID
     * @param productId String ,
     * @param serviceGroupId String,
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> selectByProductIdAndServiceGroup(String productId, String serviceGroupId) {
        return (List<Service_Group_Type__c>) Database.query(
            newQueryFactory()
                .selectField('Service_Group__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Type__c')
                .selectField('Service_Type__r.Subtype__c')
                .selectField('Service_Type__r.Case_Record_Type__c')
                .selectField('Service_Type__r.Linked_Product__c')
                .selectField('Service_Type__r.Name')
                .setCondition('Service_Type__r.Linked_Product__c =:productId And Service_Group__c =:serviceGroupId')
                .toSOQL()
        );
    }

    /**
     * @description Koketso Mpshane - Return All Service Type with linked products by Service Group Id
     * @param serviceGroupId String
     * @return List<Service_Group_Type__c>
     */
    public List<Service_Group_Type__c> getProductsByServiceGroupId(String serviceGroupId) {
        return (List<Service_Group_Type__c>) Database.query(
            newQueryFactory()
                .selectField('Service_Group__c')
                .selectField('Service_Type__c')
                .selectField('Service_Type__r.Linked_Product__c')
                .selectField('Service_Type__r.Linked_Product__r.Name')
                .setCondition('Service_Group__c =:serviceGroupId')
                .toSOQL()
        );
    }

    /**
    * @description RNIEHAUS : US #W-006746 External Sales requierment
    * @param serviceGroupNames List<String> : Service Group Names
    * @return List<Service_Group_Type__c>
    */
   public List<Service_Group_Type__c> selectByServiceGroupNamesWithServiceTypeAndServiceLevel( Set<String> serviceGroupNames ) {
        return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Service_Level__c').
                selectField('Service_Level__r.External_SLA__c').
                selectField('Service_Level__r.External_SLA_Time_Measure__c').
                selectField('Service_Level__r.External_SLA_Units__c').
                selectField('Service_Level__r.Max_SLA_Extension__c').
                selectField('Service_Level__r.Max_SLA_Time_Measure__c').
                selectField('Service_Level__r.Max_SLA_Units__c').
                selectField('Service_Level__r.External_SLA_Warning__c').
                selectField('Service_Level__r.Default_Service_Level__c').
                selectField('Service_Level__r.External_SLA_Notification_User__c').
                selectField('Service_Group__c').
                selectField('Service_Group__r.Name').
                selectField('Service_Group__r.Queue__c').
                selectField('Service_Group__r.Manager__c').
                selectField('Service_Group__r.Internal_SLA_Time_Measure__c').
                selectField('Service_Group__r.Internal_SLA_Units__c').
                selectField('Service_Group__r.Internal_SLA_Warning__c').
                selectField('Service_Group__r.Business_Hours__c').
                selectField('Service_Group__r.Track_Status_Changes__c').
                selectField('Service_Group__r.Email_Template_Lead_Creation__c').
                selectField('Service_Group__r.Response_Email_Address__c').
                selectField('Service_Group__r.Internal_SLA_Notification_User__c').
                setCondition('Service_Group__r.Name IN :serviceGroupNames AND ' +
                            'Service_Level__r.Default_Service_Level__c = true').
                toSOQL()
            );
    }

    /**
    * @description
    * @param serviceGroupId
    * @param serviceType
    * @return Service_Group_Type__c
    **/
    public Service_Group_Type__c getFICRefreshGroupTypeByGroupAndServiceType(String serviceGroupId,String serviceType){

        return Database.query(
            newQueryFactory(true)
            .selectField('Id')
            .selectField('Name')
            .selectField('sd_Communication_Plan__c')
            .selectField('Service_Type__c')
            .selectField('Service_Type__r.Name')
            .selectField('Service_Type__r.Type__c')
            .selectField('Service_Type__r.Subtype__c')
            .selectField('Service_Type__r.Case_Record_Type__c')
            .selectField('Service_Type__r.Product__c')
            .selectField('Service_Group__r.Id')
            .selectField('Service_Group__r.Business_Hours__c')
            .selectField('Service_Group__r.Response_Email_Address__c')
            .selectField('Service_Group__r.Queue__c')
            .selectField('Service_Group__r.Name')
            .selectField('Service_Level__c')
            .selectField('Process_Type__c')
            .selectField('FIC_Refresh_Required__c')
            .setCondition('Service_Group__c =:serviceGroupId And Service_Type__r.Name =:serviceType')
            .setLimit(1)
            .toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}