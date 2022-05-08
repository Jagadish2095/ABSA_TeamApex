/**
 * @description Controller class for BranchCustomer components
 * @author  Paul du Randt
 * @created 2020-10-29
 */
public without sharing class BranchCustomerController {
    /**
    * @description Method where a list of fields can be send to be validated by CVS. List<Map<String,String>> The map entry of the must have a ServiceField ,CMPField and Value
    * @return Map<String,String>
    * @param accountID
    * @param fieldsToValidate
    */
    @AuraEnabled
    public static Map<String,String> validateFields(String accountID, List<Map<String,String>> fieldsToValidate)
    {
        Map<String,String> outPut = CVSServicesHelper.validateFields(accountID, fieldsToValidate);
        return outPut;
    }
    /**
    * @description getFieldPickListValues
    * @return List<String>
    * @param objObject
    * @param objField
    */
    @AuraEnabled
    public static List<String> getFieldPickListValues(sObject objObject, string objField)
    {
        return BranchFunctions.getFieldPickListValues(objObject, objField);
    }
    /**
    * @description getTranslationValues
    * @return Map<String,String>
    * @param systemName
    * @param valueType
    * @param direction
    * @param objObject
    * @param objField
    */
    @AuraEnabled
    public static Map<String,String> getTranslationValues(String systemName, String valueType, String direction, sObject objObject, string objField)
    {
        return BranchFunctions.getValidTranslations(systemName, valueType, direction, objObject, objField);
    }
    /**
    * @description getAddress
    * @return Map<String,String>
    * @param recordId
    * @param requestedAddressTypeList
    */
    @AuraEnabled
    public static Map<String, String> getAddress(String recordId, List<String> requestedAddressTypeList)
    {
        return BranchCustomerAddressHelper.getAddresses(recordId, requestedAddressTypeList);
    }
    /**
    * @description createMaintenanceCase
    * @return Case
    * @param recordId
    */
    @AuraEnabled
    public static Case createMaintenanceCase(String recordId)
    {
        String serviceGroupName = 'Retail Banking';
        String serviceGroupTypeName = 'Customer Maintenance';
        return CustomerCaseController.createServiceRequestCase(recordId, serviceGroupName, serviceGroupTypeName);
    }
    /**
    * @description updateMaintenanceCase
    * @return Case
    * @param caseRecord
    * @param caseStatus
    */
    @AuraEnabled
    public static Case updateMaintenanceCase(Case caseRecord, String caseStatus)
    {
        return CustomerCaseController.updateCaseStatus(caseRecord, caseStatus);
    }
    /**
    * @description getForeignTaxData
    * @return List<IdentityDocument>
    * @param recordId
    */
    @AuraEnabled
    public static List<IdentityDocument> getForeignTaxData(String recordId)
    {
        String recordType = 'Foreign Tax';
        return ForeignTaxDataTableController.getTaxDocuments(recordId, recordType);
    }
    /**
    * @description getForeignTaxCVSData
    * @return String
    * @param jsonString
    */
    @AuraEnabled
    public static String getForeignTaxCVSData(String jsonString)
    {
        return ForeignTaxDataTableController.getForeignTaxCVSData(jsonString);
    }
    /**
    * @description updateTaxDocuments
    * @param jsonString
    */
    @AuraEnabled
    public static void updateTaxDocuments(String jsonString)
    {
        ForeignTaxDataTableController.updateTaxDocuments(jsonString);
    }
    /**
    * @description deleteTaxDocuments
    * @param jsonString
    */
    @AuraEnabled
    public static void deleteTaxDocuments(String jsonString)
    {
        ForeignTaxDataTableController.deleteTaxDocuments(jsonString);
    }
    /**
    * @description createOrUpdate
    * @return String
    * @param objId
    */
    @AuraEnabled
    public static String createOrUpdate(String objId)
    {
        return CVSServicesHelper.createOrUpdate(objId);
    }
    /**
     * @description get credit consent labels
     * @return Map<String, String>
     */
    @AuraEnabled
    public static Map<String, String> getCreditConsent(){
        Map<String, String> options = new Map<String, String>();
        //get makertingconsent Industry Field Describe
        Schema.DescribeFieldResult fieldResult = Contact.Credit_Marketing_Indicator__c.getDescribe();
        //get  makertingconsent Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }

    /**
     * @description get non credit consent labels
     * @return Map<String, String>
     */
    @AuraEnabled
    public static Map<String, String> getNonCreditConsent(){
        Map<String, String> options = new Map<String, String>();
        //get Account makertingconsent Field Describe
        Schema.DescribeFieldResult fieldResult = Contact.Non_Credit_Marketing_Indicator__c.getDescribe();
        //get Account makertingconsent Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    /**
    * @description getProcessDetails
    * @return String
    * @param caseRecord
    * @param onboardingMode
    */
    @AuraEnabled
    public static String getProcessDetails(Case caseRecord, String onboardingMode)
    {
        ProductProcess.ProcessDetails processDetail = new ProductProcess.ProcessDetails();
        processDetail.name = '';
        processDetail.flow = 'CustomerMaintenanceKYCFulfilment';
        processDetail.onboardingMode = onboardingMode;
        processDetail.productAccountNumber = '';
        processDetail.productFamily = '';
        processDetail.productSelectorMode = '';
        processDetail.requestName = '';
        processDetail.caseId = caseRecord.Id;
        processDetail.ProcessType = ProductProcess.ProcessType.CustomerMaintenance;
        return JSON.serialize(processDetail);
    }

    /**
    * @description validateId
    * @author PaulJohn.duRand@absa.africa | 2021-11-22
    * @param idNumber
    * @return Boolean
    **/
    @AuraEnabled
    public static Boolean validateId(String idNumber) {
        return SystemValidationUtils.validate(SystemValidationUtils.type.RSA_ID_NUMBER, idNumber);
    }
}