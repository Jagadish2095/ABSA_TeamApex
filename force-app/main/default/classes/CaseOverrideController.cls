/**
 * @description Apex extension class for the lightning CaseOverride
 *
 * @author  Tracy de Bruin : CloudSmiths
 * @since   2018-08-07
 *
 **/
public without sharing class CaseOverrideController {
    /**
     * @description getLoggedInUserCaseRecordType description
     *
     * @return Return List<DisplayRecordTypes>: Return description
     */
    @AuraEnabled
    public static List<DisplayRecordTypes> getLoggedInUserCaseRecordType() {
        List<DisplayRecordTypes> caseRecordTypes = new List<DisplayRecordTypes>();

        for (Schema.RecordTypeInfo rtInfo : Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            String recordTypeName = rtInfo.getDeveloperName();
            if (
                (rtInfo.isActive() == true && rtInfo.isAvailable() == true) &&
                (recordTypeName == 'Compliment' ||
                recordTypeName == 'ATM' ||
                recordTypeName == 'Complaint' ||
                recordTypeName == 'Non_Confidential_Fraud' ||
                recordTypeName == 'Service_Request' ||
                recordTypeName == 'Short_term_Complaint' ||
                 recordTypeName == 'Life_Complaint')) { // Mbuyiseni Mbhokane added short term insurance record type name.
                DisplayRecordTypes caseRecordTypeItem = new DisplayRecordTypes();
                caseRecordTypeItem.recordTypeId = rtInfo.getRecordTypeId();
                caseRecordTypeItem.label = rtInfo.getName();
                caseRecordTypeItem.value = rtInfo.getDeveloperName();
                caseRecordTypeItem.isDefault = rtInfo.isDefaultRecordTypeMapping();
                caseRecordTypes.add(caseRecordTypeItem);
            }
        }
        // System.debug('###caseRecordTypes : ' + caseRecordTypes);

        return caseRecordTypes;
    }

    /**
     * @description getPolicyDetailsById description
     *
     * @param IdType (String): IdType
     * @param IdNumber (String): IdNumber
     * @return  Return List<SiebelGetPolicyDetailsById_Resp_IB_v1.ListOfPolicy>: Return description
     */
    @AuraEnabled
    public static List<SiebelGetPolicyDetailsById_Resp_IB_v1.ListOfPolicy> getPolicyDetailsById(String IdType, String IdNumber) {
        SiebelGetPolicyDetailsById_Resp_IB_v1 policyResponse;
        List<SiebelGetPolicyDetailsById_Resp_IB_v1.ListOfPolicy> allPolicies = new List<SiebelGetPolicyDetailsById_Resp_IB_v1.ListOfPolicy>();

        if (!Test.isRunningTest()) {
            if (String.isBlank(IdNumber) || String.isBlank(IdType)) {
                throw new AuraHandledException('Please enter an ID Type and ID Number');
            }
            policyResponse = SiebelGetPolicyDetailsById_IH_v1.SiebelGetPolicyDetailsById(IdType, IdNumber);

            //policyResponse = SiebelGetPolicyDetailsById_IH_v1.SiebelGetPolicyDetailsById('SAIdentityDocument', '9401060023083');

            if (policyResponse.Response.Result.Status == 'Success') {
                if (policyResponse.Response.Message != null) {
                    allPolicies = policyResponse.Response.Message.GetPoliciesByIDResponse.ListOfPolicy;
                } else
                    throw new AuraHandledException('No policies retrieved for the client.');
            } else {
                throw new AuraHandledException('There was an error trying to connect to the service.');
            }
        }

        return allPolicies;
    }

    /**
     * @description getCurrentUserRole description
     *
     * @return Return List<String>: Return description
     */
    @AuraEnabled
    public static List<String> getCurrentUserRole() {
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        String NBFSQueueMember = 'false';
        String Level1Member = 'false';
        String Level2Member = 'false'; //add by Mbuyiseni Mbhokane for short term insurance requirement
        String Level3Member = 'false'; //add by Mbuyiseni Mbhokane for short term insurance requirement
        List<Id> usersIdsInGroup = new List<Id>();
        List<String> rolesSet = new List<String>();
        List<User> LevelCheck = [SELECT Id, Level_1__c, Level_2__c, Level_3__c FROM User WHERE Id = :UserInfo.getUserId()];

        if (LevelCheck[0].Level_1__c == false && LevelCheck.get(0).Level_2__c == false && LevelCheck.get(0).Level_3__c == false) {
            List<GroupMember> queueGroup = [
                SELECT Id, UserOrGroupId
                FROM GroupMember
                WHERE group.name = 'Advisers, Wealth, Investments and Trust' AND group.type = 'Queue'
            ];
            for (GroupMember gm : queueGroup) {
                String userorgroupId = String.valueof(gm.UserOrGroupId);
                if (userorgroupId.startsWithIgnoreCase(userType)) {
                    usersIdsInGroup.add(gm.UserOrGroupId);
                } else if (userorgroupId.startsWithIgnoreCase(groupType)) {
                    /*This section is to handle the Roles added to the public group. 
                  To get the Role Id added we need to Query the sub group & relatedId gives the Role ID. 
                */
                    //List<Group> groupWithRole=[Select Id, RelatedId From Group where Id=:gm.UserOrGroupId];
                    List<Group> groupWithRole = new GroupsSelector().selectById(gm.UserOrGroupId);

                    if (groupWithRole[0].RelatedId != null) {
                        //List<User> roleUsers= [Select Id from User where UserRole.Id=:groupWithRole[0].RelatedId];
                        List<User> roleUsers = new UsersSelector().selectByroleId(groupWithRole[0].RelatedId);
                        for (User tempUser : roleUsers) {
                            usersIdsInGroup.add(tempUser.ID);
                        }
                    }
                }
            }
            if (usersIdsInGroup.contains(UserInfo.getUserId()))
                NBFSQueueMember = 'true';
        } else if (LevelCheck.get(0).Level_2__c == true) {
            //add by Mbuyiseni Mbhokane for short term insurance requirement
            Level2Member = 'true';
        } else if (LevelCheck.get(0).Level_3__c == false) {
            //add by Mbuyiseni Mbhokane for short term insurance requirement
            Level3Member = 'true';
        } else
            Level1Member = 'true';
        rolesSet.add(NBFSQueueMember);
        rolesSet.add(Level1Member);
        rolesSet.add(Level2Member); //add by Mbuyiseni Mbhokane for short term insurance requirement
        rolesSet.add(Level3Member); //add by Mbuyiseni Mbhokane for short term insurance requirement
        return rolesSet;
    }

    /**
     * @description DisplayRecordTypes Description
     *
     */
    public class DisplayRecordTypes {
        @AuraEnabled
        public boolean isDefault;
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
        @AuraEnabled
        public string recordTypeId;
        /**
         * @description DisplayRecordTypes description
         *
         */
        public DisplayRecordTypes() {
            isDefault = false;
            value = '';
            label = '';
            recordTypeId = '';
        }
    }

    /**
     * @description getComplaintsPermissionSets description
     *
     * @return Return List<String>: Return description
     */
    @AuraEnabled
    public static List<String> getComplaintsPermissionSets() {
        List<String> complaintsPermissionSets = new List<String>();

        Profile loggedInUserProfile = new ProfilesSelector().selectByLoggedInUser();

        List<PermissionSetAssignment> creationPermsionSetAssign = new PermissionSetAssignmentsSelector()
            .selectByNameAndUserId('Complaint_Creation', UserInfo.getUserId());
        List<PermissionSetAssignment> resolutionPermsionSetAssign = new PermissionSetAssignmentsSelector()
            .selectByNameAndUserId('Complaint_Resolution', UserInfo.getUserId());
        //added newly by pranav for STi Case creation check
        List<PermissionSetAssignment> stiCaseCreationPermisionSet = new PermissionSetAssignmentsSelector()
            .selectByNameAndUserId('DD_STI_Case_Creation', UserInfo.getUserId());

        //Ashok added for AIP case creation check
        List<PermissionSetAssignment> aipCaseCreationPermisionSet = new PermissionSetAssignmentsSelector()
            .selectByNameAndUserId('AIP_Case_Creation', UserInfo.getUserId());

        // System.debug('###creationPermsionSetAssign : ' + creationPermsionSetAssign);
        // System.debug('###resolutionPermsionSetAssign : ' + resolutionPermsionSetAssign);

        //added logic for showcomponent for sti case creation which is used in caseoverride component
        if (stiCaseCreationPermisionSet != null && stiCaseCreationPermisionSet.size() > 0) {
            complaintsPermissionSets.add('Yes');
        } else if (aipCaseCreationPermisionSet != null && aipCaseCreationPermisionSet.size() > 0) {
            //added logic for AIP case creation which is used in caseoverride component
            complaintsPermissionSets.add('AIP');
        } else {
            complaintsPermissionSets.add('No');
        }

        //Complaints case button controls
        if (creationPermsionSetAssign != null && creationPermsionSetAssign.size() > 0) {
            complaintsPermissionSets.add('Route');
        }

        if (resolutionPermsionSetAssign != null && resolutionPermsionSetAssign.size() > 0) {
            complaintsPermissionSets.add('FPOC');
            complaintsPermissionSets.add('I will Resolve');
            complaintsPermissionSets.add('Route');
        }

        if (loggedInUserProfile != null) {
            //Contact Center should see I Will Resolve and Route
            if (loggedInUserProfile.Name.contains('Contact Centre')) {
                complaintsPermissionSets.add('I will Resolve');
                complaintsPermissionSets.add('Route');
            } else if (loggedInUserProfile.Name.contains('System Administrator') || loggedInUserProfile.Name.contains('Complaint')) {
                //System Admins and Complaint users will see all
                complaintsPermissionSets.add('FPOC');
                complaintsPermissionSets.add('I will Resolve');
                complaintsPermissionSets.add('Route');
            }
        }

        // System.debug('###complaintsPermissionSets : ' + complaintsPermissionSets);

        return complaintsPermissionSets;
    }

    /**
     * @description createCase description
     *
     * @param caseRecord (Case): caseRecord
     * @param serviceTypeRecord (Service_Type__c): serviceTypeRecord
     * @param serviceGroupRecord (Service_Group__c): serviceGroupRecord
     * @param siteRecord (Site__c): siteRecord
     * @param isRoutingRequired (Boolean): isRoutingRequired
     * @param clientRecord (Account): clientRecord
     * @param caseRecordType (String): caseRecordType
     * @param productAccNo (String): productAccNo
     * @param productName (String): productName
     * @param productStatus (String): productStatus
     * @return Return String: Return description
     */
    @AuraEnabled
    public static String createCase(
        Case caseRecord,
        Service_Type__c serviceTypeRecord,
        Service_Group__c serviceGroupRecord,
        Site__c siteRecord,
        Boolean isRoutingRequired,
        Account clientRecord,
        String caseRecordType,
        String productAccNo,
        String productName,
        String productStatus
    ) {
        //System.debug('###clientSource : ' + clientRecord.Source__c);
        //System.debug('###serviceGroupRecord : ' + serviceGroupRecord);
        Case caseInsert = new Case();
        Account relatedClient = new Account();
        Id caseId;
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(caseRecordType).getRecordTypeId();
        Id caseDDSTIRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DD_STI_Case').getRecordTypeId();
        map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        String queueName;
        String clientSource = clientRecord.Source__c;

        try {
            //Assign Service Type to Case
            caseInsert = caseRecord;
            //Get Service Group
            if (serviceGroupRecord != null) {
                Set<Id> idSet = new Set<Id>();
                idSet.add(serviceGroupRecord.Id);
                List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(idSet);
                //system.debug('serviceGroupTypes : ' + serviceGroupTypes);
                //system.debug('serviceGroupRecord.Id : ' + serviceGroupRecord.Id);
                if (!serviceGroupTypes.isEmpty()) {
                    caseInsert.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
                    caseInsert.sd_Original_Service_Queue__c = serviceGroupTypes[0].Service_Group__r.Queue__c;
                    caseInsert.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
                    caseInsert.sd_Service_Group_Id__c = serviceGroupRecord.id;
                    caseInsert.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
                    caseInsert.sd_Service_Group__c = serviceGroupRecord.Name;
                    caseInsert.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
                    caseInsert.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
                    caseInsert.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
                    caseInsert.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
                    caseInsert.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
                    caseInsert.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;

                    //Auto Route case
                    // system.debug('isRoutingRequired '+isRoutingRequired);
                    if (isRoutingRequired == true) {
                        // system.debug('****InsideisRoutingRequired '+isRoutingRequired);
                        //Route based on ATM Prepaid Type
                        if (caseInsert.ATM_Service_Type__c == 'Prepaid'){
                            if (serviceGroupTypes[0].Service_Group__r.ATM_Prepaid_Queue__c != null) {
                                queueName = serviceGroupTypes[0].Service_Group__r.ATM_Prepaid_Queue__c;
                            }
                        } else if (caseInsert.Deposit_Type__c != null && caseInsert.Deposit_Type__c != '') {
                            //Route based on ATM Deposite Type
                            if (serviceGroupTypes[0].Service_Group__r.ATM_Deposit_Queue__c != null) {
                                queueName = serviceGroupTypes[0].Service_Group__r.ATM_Deposit_Queue__c;
                            }
                        } else {
                            //Route based on Service Group
                            queueName = serviceGroupRecord.Queue__c;
                        }

                        if (queueName != null) {
                            List<Group> caseQueues = new GroupsSelector().selectByNameAndType(queueName, 'Queue');

                            if (!caseQueues.isEmpty()) {
                                caseInsert.OwnerId = caseQueues[0].id;
                            }
                        }
                    }
                }
            }

            //Product selected?

            caseInsert.Account_Product_Name__c = productName;
            if (productAccNo != null && productAccNo != '') {
                caseInsert.Account_Number__c = productAccNo;
            }
            caseInsert.Account_Status__c = productStatus;

            //Create Client (if not in Salesforce)
            if (clientRecord != null) {
                if (clientRecord.id == null) {
                    //Query to see if Client already exist in Salesforce
                    List<Account> relatedAcc = new AccountsSelector().selectByCIF(clientRecord.CIF__c, 1);
                    // System.debug('###relatedAcc : ' + relatedAcc);

                    if (relatedAcc.size() > 0 && relatedAcc.size() < 2) {
                        //Use client found in Salesforce
                        relatedClient = relatedAcc[0];
                    } else if (relatedAcc.size() > 1) {
                        // System.debug('Duplicate CIF number found - ' + relatedClient.CIF__c);
                        throw new AuraHandledException('Duplicate CIF number found - ' + relatedClient.CIF__c);
                    } else {
                        //Create new Client
                        //relatedClient = clientRecord;

                        //Individual Client
                        //18-10-22 DH->TdB I dont think this test is reliable enough.  We need to set a field on the new Account that is passed in here
                        //as a parameter to indicate at source if it is a Person Account or not.
                        if (clientRecord.FirstName != null) {
                            relatedClient.Salutation = clientRecord.Salutation;
                            relatedClient.FirstName = clientRecord.FirstName;
                            relatedClient.LastName = clientRecord.LastName;
                            relatedClient.ID_Number__pc = clientRecord.ID_Number__pc;
                            relatedClient.PersonMobilePhone = clientRecord.PersonMobilePhone;
                            relatedClient.PersonHomePhone = clientRecord.PersonHomePhone;
                            relatedClient.Phone = clientRecord.Phone;
                            relatedClient.PersonEmail = clientRecord.PersonEmail;

                            relatedClient.recordTypeId = accountRecordTypeMap.get('Individual_Client').getRecordTypeId();
                            caseInsert.Email_From_Address__c = clientRecord.PersonEmail;
                            caseInsert.Email_From_Name__c = clientRecord.Name;
                        } else {
                            //Business Client
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

                        // System.debug('###relatedClient : ' + relatedClient);
                    }

                    //Query account to get more information
                    Set<Id> accountIdSet = new Set<Id>();
                    accountIdSet.add(relatedClient.id);
                    List<Account> relatedAccInserted = new AccountsSelector().selectById(accountIdSet, 1);

                    if (!relatedAccInserted.isEmpty()) {
                        relatedClient = relatedAccInserted[0];
                    }

                    //Link Account and Contact to Case
                    if (relatedClient.isPersonAccount == true) {
                        caseInsert.ContactId = relatedClient.PersonContactId;
                        caseInsert.AccountId = relatedClient.Id;
                    } else {
                        caseInsert.AccountId = relatedClient.Id;
                    }

                    caseInsert.AccountId = relatedClient.id;
                } else if (clientRecord.id != null) {
                    Set<Id> accountIdSet = new Set<Id>();
                    accountIdSet.add(clientRecord.id);
                    List<Account> relatedAcc = new AccountsSelector().selectById(accountIdSet, 1);
                    if (relatedAcc.size() > 0) {
                        //Use client found in Salesforce
                        relatedClient = relatedAcc[0];

                        caseInsert.AccountId = relatedClient.id;
                        caseInsert.Email_From_Name__c = relatedClient.Name;
                        if (relatedClient.isPersonAccount == true) {
                            caseInsert.Email_From_Address__c = relatedClient.PersonEmail;
                            caseInsert.ContactId = relatedClient.PersonContactId;
                            caseInsert.Customer_ID__c = relatedClient.ID_Number__pc;

                            caseInsert.Initials__c = relatedClient.Initials__pc;

                            //System.debug('###relatedClient.PersonContactId : ' + relatedClient.PersonContactId);
                        }
                        //System.debug('###caseInsert : ' + caseInsert);
                    }
                }
            }

            //Set Case RecordType
            caseInsert.recordTypeId = caseRecordTypeId;
            // Added for AIP Case record type
            if (caseRecordType.contains('AIP')) {
                caseInsert.status = 'In Progress';
                caseInsert.Bypass_Validation_Rules__c = true;
            }

            if (clientSource.contains('MDM') || clientSource.contains('CIF') || relatedClient.CIF__c != null) {
                caseInsert.Originated_By__c = 'Absa Customer';
            } else {
                caseInsert.Originated_By__c = 'Non-Absa Customer';
            }
            // system.debug('caseInsertowner '+caseInsert.OwnerId);

            //Insert Case
            insert caseInsert;

            //Return Case Id
            caseId = caseInsert.id;

            //call tom integration methods...

            if (caseRecordType == 'ATM') {
                TOMComplaint_IH_v1.callToTOMComplaint(caseId);
            }
            return caseId;
        } catch (DmlException ex) {
            //System.debug('There was an error creating the case - ' + ex.getMessage());

            //Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
            String msg = '';
            //Get All DML Messages
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg = +ex.getDmlMessage(i) + '\n';
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
        } catch (Exception ex) {
            //throw all other exception message
            //System.debug('There was an error creating the case - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
     * Method that gets all picklist data
     *
     * @param objObject - Id of the specific opportunity party being removed
     * @param fld - field name i.e. Clause_Name__c
     * @description
     * @return allOpts
     */
    @AuraEnabled
    public static List<String> getselectOptions(sObject objObject, string fld) {
        List<String> allOpts = new List<String>();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
    }

    /**
     * @description findServiceTypeRecord description
     *
     * @param recId (String): recId
     * @return Return Service_Type__c: Return description
     */
    @AuraEnabled
    public static Service_Type__c findServiceTypeRecord(String recId) {
        //Add Id to a Set
        Set<Id> serviceTypes = new Set<Id>();
        serviceTypes.add(recId);
        list<Service_Type__c> returnRec = new ServiceTypesSelector().selectById(serviceTypes);

        if (returnRec.size() > 0) {
            return returnRec[0];
        } else {
            return null;
        }
    }

    /**
     * @description findServiceGroupRecord description
     *
     * @param serviceGroupId (String): serviceGroupId
     * @return Return Service_Group__c: Return description
     */
    @AuraEnabled
    public static Service_Group__c findServiceGroupRecord(String serviceGroupId) {
        //Add Id to a Set
        Set<Id> serviceGroupTypes = new Set<Id>();
        serviceGroupTypes.add(serviceGroupId);
        list<Service_Group__c> returnRec = new ServiceGroupsSelector().selectById(serviceGroupTypes);
        //System.debug('ServiceGroupRecord : ' + returnRec);
        if (returnRec.size() > 0) {
            return returnRec[0];
        } else {
            return null;
        }
    }

    /**
     * @description getServiceGroupInfo description
     *
     * @param serviceGroupId (String): serviceGroupId
     * @return Return List<String>: Return description
     */
    @AuraEnabled
    public static List<String> getServiceGroupInfo(String serviceGroupId) {
        //Add Id to a Set
        Set<Id> serviceGroupTypes = new Set<Id>();
        serviceGroupTypes.add(serviceGroupId);
        list<Service_Group__c> servicegroupRec = new ServiceGroupsSelector().selectById(serviceGroupTypes);

        //Get all Service Groups that should have NBFS Service Group selection
        List<NBFS_Dispute_Resolution_Configuration__mdt> mdt = [
            SELECT Service_Group__c, Region__c
            FROM NBFS_Dispute_Resolution_Configuration__mdt
            WHERE MasterLabel = 'NBFS Service Groups'
        ];

        List<String> servicegroupInformation = new List<String>();
        String isNBFSServiceGroup = 'False';

        if (servicegroupRec.size() > 0) {
            if (mdt.size() > 0) {
                String strServiceGroups = mdt[0].Service_Group__c;
                List<String> arrServiceGroup = strServiceGroups.split(';');
                for (String eachServiceGroup : arrServiceGroup) {
                    if (servicegroupRec[0].Name == eachServiceGroup) {
                        isNBFSServiceGroup = 'True';
                        servicegroupInformation.add(isNBFSServiceGroup);
                        servicegroupInformation.add(eachServiceGroup);
                        String servicegroupsource = mdt[0].Region__c;
                        servicegroupInformation.add(servicegroupsource);
                        break;
                    }
                }
            }
        }
        return servicegroupInformation;
    }

    /**
     * @description findSiteRecord description
     *
     * @param siteId (String): siteId
     * @return Return Site__c: Return description
     */
    @AuraEnabled
    public static Site__c findSiteRecord(String siteId) {
        //Add Id to a Set
        Set<Id> siteTypes = new Set<Id>();
        siteTypes.add(siteId);
        list<Site__c> returnRec = new SitesSelector().selectById(siteTypes);

        if (returnRec.size() > 0) {
            return returnRec[0];
        } else {
            return null;
        }
    }

    /**
     * @description updateContentDocument description
     *
     * @param caseId (String): caseId
     * @param contentDocumentId (String): contentDocumentId
     * @return Return string: Return description
     */
    @AuraEnabled
    public static string updateContentDocument(String caseId, String contentDocumentId) {
        ContentDocumentLink cdl = [
            SELECT Id, LinkedEntityId, ContentDocumentId, Sharetype
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :contentDocumentId
            LIMIT 1
        ];
        ContentDocumentLink cdl2 = cdl.clone();
        cdl2.LinkedEntityId = caseId;
        cdl2.Sharetype = 'V';
        upsert cdl2;

        return 'success';
    }

    /**
     * @description uploadContentDocuments description
     *
     * @param caseId (String): caseId
     * @param contentDocumentIds (List<String>): contentDocumentIds
     * @return Return String: Return description
     */
    @AuraEnabled
    public static String uploadContentDocuments(String caseId, List<String> contentDocumentIds) {
        //system.debug(LoggingLevel.FINE, '**contentDocumentIds**'+contentDocumentIds);
        String uploadResult;
        List<ContentDocumentLink> docsToUpsert = new List<ContentDocumentLink>();
        try {
            List<ContentDocumentLink> cdlList = [
                SELECT Id, LinkedEntityId, ContentDocumentId, Sharetype
                FROM ContentDocumentLink
                WHERE ContentDocumentId IN :contentDocumentIds
            ];
            if (cdlList.size() > 0) {
                for (ContentDocumentLink cdl : cdlList) {
                    ContentDocumentLink cDoc = cdl.clone();
                    cDoc.LinkedEntityId = caseId;
                    cDoc.Sharetype = 'V';
                    docsToUpsert.add(cDoc);
                }
            }
            if (docsToUpsert.size() > 0) {
                upsert docsToUpsert;
            }

            uploadResult = 'Files successfully uploaded';
        } catch (Exception ex) {
            uploadResult = ex.getMessage();
        }

        //system.debug(LoggingLevel.FINE, '**uploadResult**'+uploadResult);
        return uploadResult;
    }

    /**
     * @description findProductsByServiceGroup description
     *
     * @param serviceGroupId (String): serviceGroupId
     * @return Return List<SelectOptionWrapper>: Return description
     */
    @AuraEnabled
    public static List<SelectOptionWrapper> findProductsByServiceGroup(String serviceGroupId) {
        List<SelectOptionWrapper> selectOptionList = new List<SelectOptionWrapper>();
        List<Service_Group_Type__c> linkedProducts = new ServiceGroupTypesSelector().getProductsByServiceGroupId(serviceGroupId);

        Set<String> productIds = new Set<String>();
        Map<String, String> productIdMap = new Map<String, String>();

        if (linkedProducts.size() > 0) {
            for (Service_Group_Type__c sgt : linkedProducts) {
                productIds.add(sgt.Service_Type__r.Linked_Product__c);
                productIdMap.put(sgt.Service_Type__r.Linked_Product__c, sgt.Service_Type__r.Linked_Product__r.Name);
            }
        }

        if (productIds.size() > 0) {
            for (String pId : productIds) {
                selectOptionList.add(new SelectOptionWrapper(productIdMap.get(pId), pId));
            }
        }

        return selectOptionList;
    }

    /**
     * @description findServiceTypesByProductAndServiceGroup description
     *
     * @param productId (String): productId
     * @param serviceGroupId (String): serviceGroupId
     * @return Return List<SelectOptionWrapper>: Return description
     */
    @AuraEnabled
    public static List<SelectOptionWrapper> findServiceTypesByProductAndServiceGroup(String productId, String serviceGroupId) {
        List<SelectOptionWrapper> selectOptionList = new List<SelectOptionWrapper>();

        List<Service_Group_Type__c> linkedProductServiceTypes = new ServiceGroupTypesSelector().selectByProductIdAndServiceGroup(productId, serviceGroupId);
        //system.debug(LoggingLevel.FINE, 'linkedProductServiceTypes:'+linkedProductServiceTypes);

        for (Service_Group_Type__c sgt : linkedProductServiceTypes) {
            selectOptionList.add(new SelectOptionWrapper(sgt.Service_Type__r.Name, sgt.Service_Type__c));
        }

        return selectOptionList;
    }
    /**
     * @description SelectOptionWrapper Description
     *
     */
    public class SelectOptionWrapper {
        /**
         * @description
         */
        @AuraEnabled
        public String name { get; set; }
        /**
         * @description
         */
        @AuraEnabled
        public String id { get; set; }
        /**
         * @description selectOptionWrapper description
         *
         * @param name (String): name
         * @param id (String): id
         */
        public selectOptionWrapper(String name, String id) {
            this.name = name;
            this.id = id;
        }
    }

    /**
     * @description sendEmailWithAttachments description
     *
     * @param caseId (String): caseId
     * @param responseEmailAddress (String): responseEmailAddress
     * @param uploadedFileIds (List<String>): uploadedFileIds
     * @param serviceGroupEmailTemplate (String): serviceGroupEmailTemplate
     * @param alternateEmailToAddress (String): alternateEmailToAddress
     */
    @AuraEnabled
    public static void sendEmailWithAttachments(
        String caseId,
        String responseEmailAddress,
        List<String> uploadedFileIds,
        String serviceGroupEmailTemplate,
        String alternateEmailToAddress
    ) {
        Set<String> emailTemplateNames = new Set<String>();
        Map<String, EmailTemplate> emailTemplates = new Map<String, EmailTemplate>();
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        List<EmailMessage> emailMessages = new List<EmailMessage>();

        try {
            //Used for SOQL query.
            String directEmailTemplate = 'RBB Contact Centre - Email With Attachments';
            emailTemplateNames.add(directEmailTemplate);

            //Make sure not missing something.
            if (!String.isBlank(serviceGroupEmailTemplate)) {
                emailTemplateNames.add(serviceGroupEmailTemplate);
            }

            //system.debug('serviceGroupEmailTemplate ' + serviceGroupEmailTemplate);

            //Not using FFLIB to bypass CRUD / FLS as email folder is hidden.
            List<EmailTemplate> templates = new List<EmailTemplate>([SELECT Id, DeveloperName, Name FROM EmailTemplate WHERE Name IN :emailTemplateNames]);

            List<String> testTemplate = new List<String>{ 'RBB_Contact_Centre_Email_With_Attachments', 'RBB_Contact_Centre_Auto_Response_on_email_receipt' };
            List<EmailTemplate> templates2 = [SELECT Id, DeveloperName, Name FROM EmailTemplate WHERE DeveloperName IN :testTemplate];
            //Simangaliso Mathenjwa
            //System.debug('EmailTamplate Dev Name ==> '+ templates2);

            //system.debug('templates 4 ' + templates);
            for (EmailTemplate template : templates) {
                emailTemplates.put(template.Name, template);
            }

            //Select random contact for TargetObjectId.

            //List<Contact> contacts = new List<Contact>([
            //SELECT
            //Id
            // FROM Contact
            //WHERE
            // Email != null
            //AND Birthdate != null
            //AND LastModifiedDate = LAST_WEEK
            //LIMIT 1
            //]);

            List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');

            String defaulttargetObjectId = null;

            if (mdt.size() > 0) {
                defaulttargetObjectId = mdt[0].Value__c;
            } else {
                List<Contact> contacts = new List<Contact>(
                    [SELECT Id FROM Contact WHERE Email != NULL AND Birthdate != NULL AND LastModifiedDate = LAST_WEEK LIMIT 1]
                );

                if (contacts.size() > 0) {
                    defaulttargetObjectId = contacts[0].Id;
                }
            }

            //Query case with needed fields.
            List<Case> cases = new CasesSelector().selectById(new Set<Id>{ Id.valueOf(caseId) });

            //Simangaliso Mathenjwa
            //System.debug('Email_From_Address__c ==> ' + cases.get(0).Email_From_Address__c );
            //System.debug('Case Subject ==> ' + cases.get(0).Subject );

            //This should not happen.
            if (cases.isEmpty()) {
                throw new CaseOverrideControllerException('Case record not found.');
            }

            //system.debug('emailTemplateNames name ' + emailTemplateNames);
            //system.debug('emailTemplateNames size ' + emailTemplateNames.size());
            //system.debug('emailTemplates.size() ' + emailTemplates.size());
            //This should match.
            if (emailTemplateNames.size() != emailTemplates.size()) {
                throw new CaseOverrideControllerException('Invalid email template(s) found. : ' + emailTemplates.size());
            }

            //Get org-wide email id based on email address.
            List<OrgWideEmailAddress> orgWideEmailAddresses = new OrgWideEmailAddressesSelector().selectByAddress(new Set<String>{ responseEmailAddress });

            //We should always have 2 templates returned.
            if (orgWideEmailAddresses.isEmpty()) {
                throw new CaseOverrideControllerException('Org wide email address not found.');
            }

            // Start - Simangaliso Mathenjwa
            List<String> toAddressList = new List<String>();

            if (!String.isBlank(alternateEmailToAddress) && cases.get(0).Email_From_Address__c != alternateEmailToAddress) {
                toAddressList.add(alternateEmailToAddress);
            } else {
                if (!String.isBlank(cases.get(0).Email_From_Address__c)) {
                    toAddressList.add(cases.get(0).Email_From_Address__c);
                }
            }
            //End - Simangaliso Mathenjwa

            //Outbound email message.
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setOrgWideEmailAddressId(orgWideEmailAddresses.get(0).Id);
            message.setTemplateId(emailTemplates.get(directEmailTemplate).Id);
            message.setWhatId(cases.get(0).Id);
            message.setTargetObjectId(defaulttargetObjectId);
            //message.setToAddresses(new List<String> { cases.get(0).Email_From_Address__c }); Replaced  by the if statement below by - Simangaliso
            if (!toAddressList.isEmpty()) {
                message.setToAddresses(toAddressList);
            }

            message.setSaveAsActivity(false);
            message.setTreatTargetObjectAsRecipient(false);

            //System.debug('serviceGroupEmailTemplate  ==> ' + serviceGroupEmailTemplate);

            //Only add auto response PDF if servicegroup has one.
            if (!String.isBlank(serviceGroupEmailTemplate)) {
                //System.debug('serviceGroupEmailTemplate Id ==> ' + emailTemplates.get(serviceGroupEmailTemplate).Id);
                //System.debug('serviceGroupEmailTemplate Id ==> ' + emailTemplates.get(serviceGroupEmailTemplate).Name);

                //Build auto response email as PDF.
                PageReference emailRenderer = Page.EmailTemplateRenderer;
                emailRenderer.getParameters().put('whatId', cases.get(0).Id);
                emailRenderer.getParameters().put('templateId', emailTemplates.get(serviceGroupEmailTemplate).Id);
                Blob templateData;

                if (!System.Test.isRunningTest()) {
                    templateData = emailRenderer.getContentAsPDF();
                } else {
                    templateData = Blob.valueOf('TESTDATA');
                }

                //Auto response is always added.
                Messaging.EmailFileAttachment autoResponsePDF = new Messaging.EmailFileAttachment();
                autoResponsePDF.setBody(templateData);
                autoResponsePDF.setFileName('AutoResponse.pdf');
                attachments.add(autoResponsePDF);
            }

            //Fetch upload attachments when case was created.
            if (!uploadedFileIds.isEmpty()) {
                //Fetch attachment data.
                List<ContentVersion> uploadedFiles = new List<ContentVersion>(
                    [
                        SELECT Id, Title, FileType, FileExtension, VersionData, isLatest, ContentDocumentId
                        FROM ContentVersion
                        WHERE isLatest = TRUE AND ContentDocumentId = :uploadedFileIds
                    ]
                );

                //Build attachments list.
                for (ContentVersion uploadedFile : uploadedFiles) {
                    Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                    attachment.setBody(uploadedFile.VersionData);
                    attachment.setFileName(uploadedFile.Title + '.' + uploadedFile.FileExtension);
                    attachments.add(attachment);
                }
            }

            //Add all attachments to email.
            message.setFileAttachments(attachments);

            //Send email(s).
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ message });

            //Insert email message records for history purposes.
            for (Messaging.SendEmailResult sendResult : sendResults) {
                if (sendResult.isSuccess()) {
                    EmailMessage emailMessage = new EmailMessage();
                    emailMessage.ToAddress = cases.get(0).Email_From_Address__c;
                    emailMessage.FromAddress = responseEmailAddress;
                    emailMessage.FromName = orgWideEmailAddresses.get(0).DisplayName;
                    emailMessage.Subject = message.getSubject();
                    emailMessage.HtmlBody = message.getHtmlBody();
                    emailMessage.ParentId = cases.get(0).Id;
                    emailMessage.MessageDate = System.now();
                    emailMessage.Status = '0';
                    emailMessage.Is_Auto_Response__c = true;

                    emailMessages.add(emailMessage);
                } else {
                    //Extract error message for display.
                    for (Messaging.SendEmailError sendError : sendResult.getErrors()) {
                        throw new CaseOverrideControllerException('There was a problem sending email: ' + sendError.getMessage());
                    }
                }
            }

            if (!emailMessages.isEmpty()) {
                insert emailMessages;
            }
        } catch (Exception e) {
            throw new AuraHandledException('AURA: ' + responseEmailAddress + ' ' + e.getMessage());
        }
    }
    /**
     * @description
     */
    public class CaseOverrideControllerException extends Exception {
    }

    /**
     * @description invokeSmsEmailMethod description
     *
     * @param requests (smsEmailRequest[]): requests
     */
    @InvocableMethod(label='Send SMS/Email' description='Which Sends SMs/Email when meets criteria')
    public static void invokeSmsEmailMethod(smsEmailRequest[] requests) {
        sendSmsEmail(
            requests[0].caseId,
            requests[0].preferredCommunicationChannel,
            requests[0].responseEmailAddress,
            requests[0].phoneNumberOverride,
            requests[0].quickText,
            requests[0].emailTemplateName,
            requests[0].ownerEmail,
            requests[0].managerEmail
        );
    }

    /**
     * @description smsEmailRequest Description
     *
     */
    public class smsEmailRequest {
        @InvocableVariable(required=true)
        public String caseId;

        @InvocableVariable
        public String preferredCommunicationChannel;

        @InvocableVariable
        public String responseEmailAddress;

        @InvocableVariable
        public String phoneNumberOverride;

        @InvocableVariable
        public String quickText;

        @InvocableVariable
        public String emailTemplateName;

        @InvocableVariable
        public String ownerEmail = '';

        @InvocableVariable
        public String managerEmail = '';
    }
    /**
     * @description sendSmsEmail description for DD
     *
     * @param caseId (Id): caseId
     * @param preferredCommunicationChannel (string): preferredCommunicationChannel
     * @param responseEmailAddress (String): responseEmailAddress
     * @param phoneNumberOverride (String): phoneNumberOverride
     * @param quickText (String): quickText
     * @param emailTemplateName (string): emailTemplateName
     * @param ownerEmail (string): ownerEmail
     * @param managerEmail (string): managerEmail
     */
    @AuraEnabled
    public static void sendSmsEmail(
        Id caseId,
        string preferredCommunicationChannel,
        String responseEmailAddress,
        String phoneNumberOverride,
        String quickText,
        string emailTemplateName,
        string ownerEmail,
        string managerEmail
    ) {
        if (preferredCommunicationChannel.equalsIgnoreCase('Email') || preferredCommunicationChannel.equalsIgnoreCase('SMS and Email')) {
            sendEmailCase(caseId, responseEmailAddress, emailTemplateName, ownerEmail, managerEmail);
        }
        if (preferredCommunicationChannel.equalsIgnoreCase('SMS') || preferredCommunicationChannel.equalsIgnoreCase('SMS and Email')) {
            // dispatchSMS(Id whoId, Id whatId, String phoneNumberOverride, String recipientNameOverride, String quickTextName, String integrationService, boolean saveAsActivity) {
            dispatchSMS(null, caseId, phoneNumberOverride, '', quickText, StringConstants.EPP_ITOUCH_SMS_INTEGRATION_SERVICE, true);
        }
    }

    /**
     * @description Used for Direct Delivery stream, SMS the client once verbal disclosures have been validated
     * @param whoId Lead or contact
     * @param whatId opportunity
     * @param phoneNumberOverride if phone number needs to be overridden
     * @param recipientNameOverride if the name needs to be overridden
     * @param quickTextName name of quick text that needs to be sent out
     * @param integrationService intergration service to be used
     * @param saveAsActivity save as an activity true or false
     */
    @Future(Callout=true)
    private static void dispatchSMS(
        Id whoId,
        Id whatId,
        String phoneNumberOverride,
        String recipientNameOverride,
        String quickTextName,
        String integrationService,
        boolean saveAsActivity
    ) {
        SMSHandler.sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
    }

    /**
     * @description getServiceGroup description for DD
     *
     * @param recordTypeName (string): recordTypeName
     * @return Return List<Service_Group__c>: Return description
     */
    @AuraEnabled
    public static List<Service_Group__c> getServiceGroup(string recordTypeName) {
        set<string> serviceGroupSet = new Set<string>();
        serviceGroupSet.add(recordTypeName);
        List<Service_Group__c> serviceGroupTypes = new ServiceGroupsSelector().selectByAssignedRecordType(serviceGroupSet);
        if (serviceGroupTypes.size() > 0) {
            return serviceGroupTypes;
        } else {
            return null;
        }
    }

    /**
     * @description sendEmailCase description for DD
     *
     * @param caseId (Id): caseId
     * @param responseEmailAddress (String): responseEmailAddress
     * @param emailTemplateName (string): emailTemplateName
     * @param ownerEmail (string): ownerEmail
     * @param managerEmail (string): managerEmail
     */
    public static void sendEmailCase(Id caseId, String responseEmailAddress, string emailTemplateName, string ownerEmail, string managerEmail) {
        List<EmailMessage> emailMessages = new List<EmailMessage>();
        Set<String> emailTemplateNames = new Set<String>();
        Map<String, EmailTemplate> emailTemplates = new Map<String, EmailTemplate>();
        try {
            //Used for SOQL query.
            //String directEmailTemplate = 'RBB Contact Centre - Email With Attachments';
            if (emailTemplateNames != null) {
                emailTemplateNames.add(emailTemplateName);
            }

            //Not using FFLIB to bypass CRUD / FLS as email folder is hidden.
            List<EmailTemplate> templates = new List<EmailTemplate>([SELECT Id, DeveloperName, Name FROM EmailTemplate WHERE Name = :emailTemplateNames]);

            //System.debug('EmailTamplate Dev Name ==> '+ templates[0].DeveloperName );

            for (EmailTemplate template : templates) {
                emailTemplates.put(template.Name, template);
            }

            //List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');

            String defaulttargetObjectId = null;

            /*  if (mdt.size() > 0 ) {
                defaulttargetObjectId = mdt[0].Value__c;
            }else{
                 */
            /*List<Contact> contacts = new List<Contact>([Select Id
                                                            From Contact 
                                                            Where Email != null 
                                                            AND Birthdate != null 
                                                            AND LastModifiedDate = LAST_WEEK
                                                            LIMIT 1]);
                
                if(contacts.size() > 0){
                    defaulttargetObjectId = contacts[0].Id;
                }*/
            //}
            //Query case with needed fields.
            List<Case> cases = new CasesSelector().selectById(new Set<Id>{ caseId });

            //This should not happen.
            if (cases.isEmpty()) {
                throw new CaseOverrideControllerException('Case record not found.');
            }
            //This should match.
            if (emailTemplateNames.size() != emailTemplates.size()) {
                throw new CaseOverrideControllerException('Invalid email template(s) found. : ' + emailTemplates.size());
            }
            List<String> toAddressList = new List<String>();
            if (ownerEmail != '' && ownerEmail != null) {
                toAddressList.add(ownerEmail);
            }
            if (managerEmail != '' && managerEmail != null) {
                toAddressList.add(managerEmail);
            }
            //system.debug('email recep'+cases.get(0).Email__c);
            //system.debug('email recep'+ownerEmail);
            if (!String.isBlank(cases.get(0).Email__c) && ownerEmail == '') {
                //Email_From_Address__c

                toAddressList.add(cases.get(0).Email__c); //Email_From_Address__c
            }
            //system.debug('trmpid '+emailTemplates.get(emailTemplateName).Id);
            //Outbound email message.
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            // message.setOrgWideEmailAddressId(orgWideEmailAddresses.get(0).Id);
            message.setTemplateId(emailTemplates.get(emailTemplateName).Id);
            message.setWhatId(cases.get(0).Id);
            message.setTargetObjectId(cases.get(0).ContactId);
            //message.setToAddresses(new List<String> { cases.get(0).Email_From_Address__c }); Replaced  by the if statement below by - Simangaliso
            if (!toAddressList.isEmpty()) {
                message.setToAddresses(toAddressList);
            }

            message.setSaveAsActivity(false);
            message.setTreatTargetObjectAsRecipient(false);

            //Send email(s).
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ message });

            //Insert email message records for history purposes.
            for (Messaging.SendEmailResult sendResult : sendResults) {
                if (sendResult.isSuccess()) {
                    EmailMessage emailMessage = new EmailMessage();
                    emailMessage.ToAddress = cases.get(0).Email__c; //Email_From_Address__c
                    emailMessage.FromAddress = responseEmailAddress;
                    // emailMessage.FromName = orgWideEmailAddresses.get(0).DisplayName;
                    emailMessage.Subject = message.getSubject();
                    emailMessage.HtmlBody = message.getHtmlBody();
                    emailMessage.ParentId = cases.get(0).Id;
                    emailMessage.MessageDate = System.now();
                    emailMessage.Status = '0';
                    emailMessage.Is_Auto_Response__c = true;

                    emailMessages.add(emailMessage);
                } else {
                    //Extract error message for display.
                    for (Messaging.SendEmailError sendError : sendResult.getErrors()) {
                        throw new CaseOverrideControllerException('There was a problem sending email: ' + sendError.getMessage());
                    }
                }
            }

            if (!emailMessages.isEmpty()) {
                insert emailMessages;
            }
        } catch (Exception e) {
            throw new AuraHandledException('AURA: ' + responseEmailAddress + ' ' + e.getMessage());
        }
    }
    /**
     * @description assignDirectDeliveryCampaign for DD
     * @param caseRecord case record to be updated
     * @param caseRecordTypeDeveloperName the recordtype to check in the metadata
     *
     * @return case record with campaign
     */
    public static Case assignDirectDeliveryCampaign(Case caseRecord, String caseRecordTypeDeveloperName) {
        List<Direct_Delivery_Service_Setting__mdt> ddServiceSettings = [
            SELECT Id, Inbound_Case_Campaign_Name__c
            FROM Direct_Delivery_Service_Setting__mdt
            WHERE Case_Record_type_name__c = :caseRecordTypeDeveloperName
        ];
        //System.debug('value of ddservice settings >>>' + ddServiceSettings);
        //System.debug('value of caseRecord.RecordType.DeveloperName >>>' + caseRecord.RecordType.DeveloperName);
        if (!ddServiceSettings.isEmpty()) {
            //System.debug('Entered settings');
            List<Campaign> campaigns = [SELECT Id FROM Campaign WHERE Name = :ddServiceSettings[0].Inbound_Case_Campaign_Name__c];
            if (!campaigns.isEmpty()) {
                caseRecord.Direct_Delivery_Campaign__c = campaigns[0].Id;
            }
        }
        return caseRecord;
    }

    /**
     * @description getObjectName description
     *
     * @param recordId (Id): recordId
     * @return Return String: Return description
     */
    @AuraEnabled
    public static String getObjectName(Id recordId) {
        return recordId.getSObjectType().getDescribe().getName();
    }
	
    /**
     * @description getRecordTypeId description
     *
     * @param recordTypeName (Id): recordTypeName
     * @return Return String: Return description
     */
    @AuraEnabled
    public static String getRecordTypeId(String recordTypeName)
    {
        return Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
    }
    
    /**
     * @param recordId
     * @description //Ashok added this method for case details
     * @return caseDetail
     *  */ @AuraEnabled
    public static Case getCaseDetails(Id recordId) {
        //System.debug('recordId :'+recordId);
        if (recordId != null) {
            List<Case> caseDetail = new CasesSelector().selectByIdWithSLAInfo(recordId, 1);
            return caseDetail[0];
        }
        return null;
    }

    /**
     * @description generate Case Document
     *
     * @param recordId (Id): recordId
     * @param templateName (String): templateName
     */
    @AuraEnabled
    public static void generateCaseDocument(Id recordId, String templateName) {
        GenerateDocument.generateDocumentForCase(recordId, templateName);
    }

    /**
     * @description Send as attachment description
     *
     * @param recordId (Id)
     * @description
     */
    @AuraEnabled
    public static void SendMailWithDocument(Id recordId) {
        String emailTemplateName;
        Blob b;
        String fileName;
        list<Messaging.EmailFileAttachment> emailAttchmentLst = new List<Messaging.EmailFileAttachment>();
        List<Document__c> caseDoc = new DocumentsSelector().getDocsRelatedToCase(recordId);
        Case caseRecord = new CasesSelector().selectByCaseId(recordId)[0];
        if (caseRecord.RecordType.Name == 'AIP Case') {
            if (caseDoc.size() > 0) {
                String docGenerated = DocumentManagementControler.getDocumentContent(caseDoc[0].Id);
                b = EncodingUtil.base64Decode(docGenerated);
            }
            fileName = 'Claim Document.pdf';
            emailTemplateName = 'AIP Claim Case Notification';
        }
        OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :system.label.AIPEmailAddLabel];
        EmailTemplate caseEmailTemplates = new EmailTemplatesSelector().selectByName(emailTemplateName)[0];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.addAll(new List<string>{ system.label.AIPBrolinkEmail });
        emailAttchmentLst.clear();
        if (b != null) {
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName(fileName);
            efa1.setBody(b);
            emailAttchmentLst.add(efa1);
        }
        mail.setToAddresses(sendTo);
        mail.setTargetObjectId(caseRecord.Account.PersonContactId);
        mail.setWhatId(caseRecord.id);
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setOrgWideEmailAddressId(owd.Id);
        mail.setSaveAsActivity(true);
        mail.setTemplateId(caseEmailTemplates.id);
        mail.setFileAttachments(emailAttchmentLst);
        mails.add(mail);

        //Send email(s).
        Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    }

    /**
     * @param caseRec
     * @description //Ashok added this method to update AIP case
     *
     *  */
    @AuraEnabled
    public static void updateCaseDetails(string caseRec) {
        Case rec = (Case) JSON.deserialize(caseRec, Case.class);
        update rec;
    }

    /**=================================================================================================================================
     * Created By Prateek 26/03/2021
     * Returns Object Type Case
     * Param 1: recordId is our Parent Case record Id from the Aura Component
     ===================================================================================================================================**/
    /*    @AuraEnabled
    public static Case getCaseDetails(Id recordId)
    {
        System.debug('recordId :'+recordId);
        if(recordId != null)
        {
            Case parentCase = [select id,RecordtypeId,Email__c,Customer_ID__c,Nationality__c,Birth_Date__c,Mobile__c from case where id=:recordId];
            System.debug('Data :'+parentCase);
            return parentCase;
        }
        return null; 
    } */
    /**
     * Author Prateek 26/03/2021
     * @description createServiceRequestCase
     * @param caseRecord (Id) recordId
     * @return String
     */

    @AuraEnabled
    public static String createServiceRequestCase(Case caseRecord) {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Service_Request').getRecordTypeId();
        try {
            Case newCase = new Case();
            newCase.Birth_Date__c = caseRecord.Birth_Date__c;
            newCase.ID_Type__c = caseRecord.ID_Type__c;
            newCase.Customer_ID__c = caseRecord.Customer_ID__c;
            newCase.Initials__c = caseRecord.Initials__c;
            newCase.Mobile__c = caseRecord.Mobile__c;
            newCase.OwnerId = caseRecord.OwnerId;
            newCase.Status = caseRecord.Status;
            newCase.Description = caseRecord.Description;
            newCase.Title__c = caseRecord.Title__c;
            newCase.First_Name__c = caseRecord.First_Name__c;
            newCase.Last_Name__c = caseRecord.Last_Name__c;
            newCase.AccountId = caseRecord.AccountId;
            //newCase.VA_Client_Referral_Type__c =caseRecord.VA_Client_Referral_Type__c;
            newCase.Customer_Type__c = caseRecord.Customer_Type__c;
            newCase.Account_Balance__c = caseRecord.Account_Balance__c;
            newCase.Investment_Amount__c = caseRecord.Investment_Amount__c;
            newCase.Term__c = caseRecord.Term__c;
            newCase.ContactId = caseRecord.ContactId;
            newCase.Origin = caseRecord.Origin;
            newCase.Gender__c = caseRecord.Gender__c;
            newCase.Nationality__c = caseRecord.Nationality__c;
            newCase.CIF_Custom__c = caseRecord.CIF_Custom__c;
            newCase.Alternate_Phone1__c = caseRecord.Alternate_Phone1__c;
            newCase.Alternate_Phone2__c = caseRecord.Alternate_Phone2__c;
            newCase.Alternate_Phone3__c = caseRecord.Alternate_Phone3__c;
            newCase.Alternate_Phone4__c = caseRecord.Alternate_Phone4__c;
            newCase.Alternate_Phone5__c = caseRecord.Alternate_Phone5__c;
            newCase.Alternate_Phone6__c = caseRecord.Alternate_Phone6__c;
            newCase.Alternate_Phone7__c = caseRecord.Alternate_Phone7__c;
            newCase.Home_Phone__c = caseRecord.Home_Phone__c;
            newCase.Work_Phone__c = caseRecord.Work_Phone__c;
            newCase.Phys_Addr_Line1__c = caseRecord.Phys_Addr_Line1__c;
            newCase.Phys_Addr_Line2__c = caseRecord.Phys_Addr_Line2__c;
            newCase.Phys_Addr_Line3__c = caseRecord.Phys_Addr_Line3__c;
            newCase.Phys_Addr_Line4__c = caseRecord.Phys_Addr_Line4__c;
            newCase.Comments__c = caseRecord.Comments__c;
            newCase.Comments = caseRecord.Comments;
            newCase.Email__c = caseRecord.Email__c;
            newCase.ParentId = caseRecord.ParentId;
            newCase.RecordTypeId = caseRecordTypeId;
            newCase.Subject = caseRecord.Subject;
            newCase.Language__c = caseRecord.Language__c;
            newCase.Phys_Addr_Post_Code__c = caseRecord.Phys_Addr_Post_Code__c;
            newCase.Post_Addr_Line1__c = caseRecord.Post_Addr_Line1__c;
            newCase.Post_Addr_Line2__c = caseRecord.Post_Addr_Line2__c;
            newCase.Post_Addr_Line3__c = caseRecord.Post_Addr_Line3__c;
            newCase.Post_Addr_Line4__c = caseRecord.Post_Addr_Line4__c;
            newCase.Post_Addr_Post_Code__c = caseRecord.Post_Addr_Post_Code__c;
            newCase.Customer_Type__c = caseRecord.Customer_Type__c;

            insert newCase;
            return 'Success';
        } catch (exception e) {
            string excepmsg = e.getMessage();
            return excepmsg;
        }
    }
    /**
     * @description getLeadCaseDetails
     * @param  recordId
     * @param  objectName
     * @return SObject
     **/
    @AuraEnabled
    public static SObject getLeadCaseDetails(Id recordId, string objectName) {
        if (recordId != null) {
            if (objectName == 'Case') {
                Case parentCase = [
                    SELECT
                        RecordtypeId,
                        Email__c,
                        Last_Name__c,
                        Customer_Type__c,
                        First_Name__c,
                        Customer_ID__c,
                        Title__c,
                        Nationality__c,
                        Birth_Date__c,
                        Mobile__c,
                        ID_Type__c,
                        CaseNumber,
                        AccountId,
                        Initials__c,
                        Account.Name,
                        ContactId,
                        Origin,
                        Gender__c,
                        CIF_Custom__c,
                        Phys_Addr_Line1__c,
                        Phys_Addr_Line2__c,
                        Phys_Addr_Line3__c,
                        Phys_Addr_Line4__c,
                        Postal_Address__c,
                        Comments,
                        Alternate_Phone1__c,
                        Alternate_Phone2__c,
                        Alternate_Phone3__c,
                        Alternate_Phone4__c,
                        Alternate_Phone5__c,
                        Alternate_Phone6__c,
                        Alternate_Phone7__c,
                        Home_Phone__c,
                        Work_Phone__c,
                        Account_Balance__c,
                        Investment_Amount__c,
                        Term__c,
                        Id,
                        Subject,
                        Description,
                        ID_Number__c,
                        Priority
                    FROM case
                    WHERE id = :recordId
                ];
                return parentCase;
            } else if (objectName == 'Lead') {
                Lead parentLead = [
                    SELECT
                        Id,
                        Description,
                        Parent_Account__r.name,
                        RecordtypeId,
                        Lead_Email__c,
                        Lead_Name__c,
                        Lead_Type__c,
                        ID_Number__c,
                        Nationality__c,
                        DD_Date_of_Birth__c,
                        MobilePhone,
                        ID_Type__c,
                        FinServ__RelatedAccount__c,
                        DD_Initials__c,
                        FinServ__RelatedAccount__r.Name,
                        DD_Gender__c,
                        CIF__c,
                        Address,
                        DD_Additional_Cell_Phone__c,
                        Comments__c,
                        Lead_Phone__c,
                        Title,
                        Alternate_Phone1__c,
                        Alternate_Phone2__c,
                        Alternate_Phone3__c,
                        DD_Work_Phone__c,
                        DD_Home_Phone__c,
                        Outstanding_Term__c,
                        ContactName__c,
                        Deposit_Amount__c
                    FROM Lead
                    WHERE id = :recordId
                ];
                return parentLead;
            }
        }
        return null;
    }
    /**
     * @description getSubject
     * @return List<String>
     **/
    @AuraEnabled
    public static List<String> getSubject() {
        List<String> subjectTexts = new List<String>();
        for (CaseSubject__mdt cs : [SELECT id, MasterLabel FROM CaseSubject__mdt ORDER BY MasterLabel ASC]) {
            subjectTexts.add(cs.MasterLabel);
        }
        if (!subjectTexts.isempty())
            return subjectTexts;
        else
            return null;
    }
}