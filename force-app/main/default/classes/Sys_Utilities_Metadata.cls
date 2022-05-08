/*Class Containing general methods related to Metadata
*
* @author  Prashant Jain / Jason Quevauvilliers / Danie Booysen
*/
public class Sys_Utilities_Metadata {

    public static Integration_Settings__mdt getIntegrationSettingsMetadata(String systemNameP, String environmentP){

        String metadataObjectName = StringConstants.INTEGRATION_SETTINGS_MDT;
        String whereClause = ' FROM ' + metadataObjectName + ' WHERE ' +
            StringConstants.SYSTEM_NAME_EQUALS + systemNameP + '\''  + ' AND ' +
            StringConstants.ENVIRONMENT_EQUALS + environmentP + '\'';

        return (Integration_Settings__mdt)getQueryResultForMetadata(metadataObjectName, whereClause);
    }

    public static List<General_Virtual_Advisor_Rules__mdt> getGeneralVirtualAdvisorRuleMetadata(){

        String metadataObjectName = StringConstants.GENERAL_VIRTUAL_ADVISOR_RULE_MDT;
        String whereClause = ' FROM ' + metadataObjectName;

        return getQueryListResultsForMetadata(metadataObjectName, whereClause);//(General_Virtual_Advisor_Rules__mdt)
    }

    /*
    * JQUEV 20200713
    * Method to return Field_Visibility_Per_Product__mdt Per product name per component.
    */
    public static List<Field_Visibility_Per_Product__mdt> getFieldVisibilityMetadataByProductName(String componentNameP, String productNameP){

        String metadataObjectName = StringConstants.FIELD_VISIBILITY_PER_PRODUCT_MDT;
        String whereClause = ' FROM ' + metadataObjectName + ' WHERE ' +
            'Is_Active__c = true AND ' +
            'Component_Name__c = \'' + componentNameP + '\''  + ' AND ' +
            'Product_Name__c = \'' + productNameP + '\' ORDER BY Order__c ASC';

        return (List<Field_Visibility_Per_Product__mdt>)getQueryListResultsForMetadata(metadataObjectName, whereClause);
    }

    /*
    * JQUEV 20200717
    * Method to return Field_Visibility_Per_Product__mdt Per product family per component.
    */
    public static List<Field_Visibility_Per_Product__mdt> getFieldVisibilityMetadataByProductFamily(String componentNameP, String productFamilyP){

        String metadataObjectName = StringConstants.FIELD_VISIBILITY_PER_PRODUCT_MDT;
        String whereClause = ' FROM ' + metadataObjectName + ' WHERE ' +
            'Is_Active__c = true AND ' +
            'Component_Name__c = \'' + componentNameP + '\''  + ' AND ' +
            'Product_Family__c = \'' + productFamilyP + '\' ORDER BY Order__c ASC';

        return (List<Field_Visibility_Per_Product__mdt>)getQueryListResultsForMetadata(metadataObjectName, whereClause);
    }

    /*
    * JQUEV 20200717
    * Method to return Field_Visibility_Per_Product__mdt for the Product Family... tbc
    */
    public static List<Field_Visibility_Per_Product__mdt> getFieldVisibilityMetadataByProductNameAndFamily(String componentNameP, String productNameP, String productFamilyP){

        Map<String,Field_Visibility_Per_Product__mdt> mdtMap = new Map<String,Field_Visibility_Per_Product__mdt>();

        //Query Metadata for that Product Family
        List<Field_Visibility_Per_Product__mdt> productFamilyMdtList = getFieldVisibilityMetadataByProductFamily(componentNameP, productFamilyP);

        //Add all the Product Family Mdt to the map
        for(Field_Visibility_Per_Product__mdt productFamilyMdt : productFamilyMdtList){
            mdtMap.put(productFamilyMdt.Component_Name__c + '_' + productFamilyMdt.Object_Name__c + '_' + productFamilyMdt.Field_Name__c, productFamilyMdt);
        }

        //Query Metadata for the Product Name
        List<Field_Visibility_Per_Product__mdt> productNameMdtList = getFieldVisibilityMetadataByProductName(componentNameP, productNameP);

        //If the map contains the key same key (ComponentName_ObjName_FieldName) replace it with the Product Name Mdt
        for(Field_Visibility_Per_Product__mdt productNameMdt : productNameMdtList){
            String mapKey = productNameMdt.Component_Name__c + '_' + productNameMdt.Object_Name__c + '_' + productNameMdt.Field_Name__c;
            if(mdtMap.containsKey(mapKey)){
                //mdtMap.remove(mapKey);
                mdtMap.put(mapKey, productNameMdt);
            }
        }
        return mdtMap.values();
    }

    //Start Changes done By Himani #W-005298
    public static List<Mandatory_Doc__mdt> getMandatoryDocs(String entityType, String processName, String productName){
        String metadataObjectName = StringConstants.MANDATORY_DOC_MDT;
        String whereClause = ' FROM ' + metadataObjectName + ' WHERE ' +
            'Entity_Type__c = \'' + entityType + '\''  + ' AND ' +
            'Process_Name__c = \'' + processName + '\'' + ' AND ' +
            'Product_Names_List__c LIKE \'' +'%'+productName+'%' + '\'';
        return (List<Mandatory_Doc__mdt>)getQueryListResultsForMetadata(metadataObjectName, whereClause);
    }
    //End Changes done By Himani #W-005298
    //
    
    //Added By Himani 03-09-2020
    public static List<High_Risk_MCC__mdt> getHighRiskMCC(){
        String metadataObjectName = StringConstants.HIGH_RISK_MCC_MDT;
        String whereClause = ' FROM ' + metadataObjectName;
        return (List<High_Risk_MCC__mdt>)getQueryListResultsForMetadata(metadataObjectName, whereClause);
    }

    private static sObject getQueryResultForMetadata(String metadataObjectNameP, String whereClauseP){

        String query = ' SELECT ';
        String field_name = null;
        Map< String, Schema.SObjectField > field_object_map = Schema.getGlobalDescribe().get(metadataObjectNameP).getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_object_map.values();
        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }
        query = query.subStringBeforeLast(',');
        query += whereClauseP;
        List<sObject> queryResultList = Database.query( query );

        if(queryResultList.size() == 1){

            return queryResultList[0];
        }else{
            return null;
        }
    }

    private static List<sObject> getQueryListResultsForMetadata(String metadataObjectNameP, String whereClauseP){

        String query = ' SELECT ';
        String field_name = null;
        Map< String, Schema.SObjectField > field_object_map = Schema.getGlobalDescribe().get(metadataObjectNameP).getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_object_map.values();
        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }
        query = query.subStringBeforeLast(',');
        query += whereClauseP;
        List<sObject> queryResultList = Database.query( query );

        return queryResultList;

    }
}