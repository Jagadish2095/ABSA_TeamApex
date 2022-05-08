/**
 * @description       : PickListController
 * @author            : Robert McLean
 * @last modified on  : 2021-11-09
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public class PickListController {
    /**
	 * @description check user access for Opportunity
     * @param  objObject
     * @param  fld
	 * @return List < String >
	 */
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();

        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();

        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();

        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    /**
    * @description pass the name of the object and the name of the field.
    * @author Robert McLean.
    * @created 2019-07-26
    * @param objectName name of the object.
    * @param selectedField of the field on the object.
    * @return List<String>
    **/
    @AuraEnabled
    public static List<String> getPickListValuesUsingObjectName(String objectName, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }

    /**
    * @description pass the name of the parent document type document.
    * @author Thulani Maseko.
    * @created 2020-09-17
    * @param documentType parent document type.
    * @return List<String>
    **/
    @AuraEnabled
    public static List<String> getPickListValuesWithParentDocumentName(String documentType){
        List<String> childDocumentPicklistValues = new List<String>();
        List<Document_Template__c> documentTemplates = new  DocumentTemplateSelector().selectTemplateByParentDocumentType(documentType);

        for(Document_Template__c documentTemplate: documentTemplates){
            childDocumentPicklistValues.add(documentTemplate.Name);
        }

        return childDocumentPicklistValues;
    }
}