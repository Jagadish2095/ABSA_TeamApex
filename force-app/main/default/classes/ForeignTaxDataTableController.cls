/**
 * @description Controller class for ForeignTaxDataTable components
 * @author  Clifford Willers
 * @created 2021-10-29
 */
public without sharing class ForeignTaxDataTableController {
    /**
    * @description newTaxDocument
    * @return IdentityDocument
    * @param recordId
    * @param recordType
    */
    @AuraEnabled
    public static IdentityDocument newTaxDocument(string recordId, String recordType)
    {
        IdentityDocument taxDocument = new IdentityDocument(
            RelatedLegalEntityId=recordId,
            Name=recordId,
        	IdDocumentType=recordType,
            Issuing_Country__c='',
            Document_Data__c='',
        	Reason_Not_Provided__c=''
        );
        return taxDocument;
    }
    /**
    * @description getTaxDocument
    * @return List<IdentityDocument>
    * @param recordId
    * @param recordType
    */
    @AuraEnabled
    public static List<IdentityDocument> getTaxDocuments(String recordId, String recordType)
    {
        List<IdentityDocument> taxDocuments = [SELECT Id, Name, IdDocumentType, Issuing_Country__c, Document_Data__c, Reason_Not_Provided__c
        FROM IdentityDocument WHERE RelatedLegalEntityId = :recordId AND IdDocumentType = :recordType];
        return taxDocuments;
    }
    /**
    * @description deleteTaxDocuments
    * @param jsonString
    */
    @AuraEnabled
    public static void deleteTaxDocuments(String jsonString)
    {
        try{
            List<IdentityDocument> taxDocuments = (List<IdentityDocument>) JSON.deserialize(jsonString, List<IdentityDocument>.class);
            delete taxDocuments;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description updateTaxDocuments
    * @param jsonString
    */
    @AuraEnabled
    public static void updateTaxDocuments(String jsonString)
    {
        try{
            List<IdentityDocument> taxDocuments = (List<IdentityDocument>) JSON.deserialize(jsonString, List<IdentityDocument>.class);
            upsert taxDocuments;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description getForeignTaxCVSData
    * @return String
    * @param jsonString
    */
    @AuraEnabled
    public static String getForeignTaxCVSData(String jsonString)
    {
        List<IdentityDocument> taxDocuments = (List<IdentityDocument>) JSON.deserialize(jsonString, List<IdentityDocument>.class);
        List<CVSValidateCIFv22_Req_IB_v1.ForeignTaxDataTable> foreignTaxDataList = new List<CVSValidateCIFv22_Req_IB_v1.ForeignTaxDataTable>();
        String systemName = 'CIFCodesList';
        for (IdentityDocument taxDoc : taxDocuments) {
            string foreignTaxCountryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
                systemName,
                'Casa Country',
                taxDoc.Issuing_Country__c,
                StringConstants.OUTBOUND_RECORD_TYPE
            );
            string reasonFtaxNotGivenCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
                systemName,
                'ReasonSATaxNotGiven',
                taxDoc.Reason_Not_Provided__c,
                StringConstants.OUTBOUND_RECORD_TYPE
            );
            CVSValidateCIFv22_Req_IB_v1.ForeignTaxDataTable foreignTaxData = new CVSValidateCIFv22_Req_IB_v1.ForeignTaxDataTable();
            foreignTaxData.foreignTaxCountryCode = foreignTaxCountryCode == null ? '' : foreignTaxCountryCode;
            foreignTaxData.foreignTaxNumber = taxDoc.Document_Data__c == null ? '' : taxDoc.Document_Data__c;
            foreignTaxData.reasonFtaxNotGivenCode = reasonFtaxNotGivenCode == null ? '' : reasonFtaxNotGivenCode;
            foreignTaxDataList.add(foreignTaxData);
        }

        return JSON.serialize(foreignTaxDataList);
    }
}