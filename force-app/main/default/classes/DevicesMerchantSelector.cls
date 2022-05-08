/*@ Author: Danie Booysen
**@ Date: 19/05/2020
**@ Description: Selector class for the Device_Merchant__c object */
public with sharing class DevicesMerchantSelector {

    /**
    * @Author: Danie Booysen
    * @Date: 19/05/2020
    *
    * Returns a List of Device - Merchant with all the fields on the object
    *
    * @param appProductMerchantIdP     The Application Product - Merchant Id
    * @return deviceList               List<Device_Merchant__c>
    */
    public List<Device_Merchant__c> selectByAppProdMerchId(Id appProductMerchantIdP) {

        List<Device_Merchant__c> devicesList = new List<Device_Merchant__c>();

        String query = ' SELECT ';
        String field_name = null;
        Map< String, Schema.SObjectField > field_oject_map = Schema.getGlobalDescribe().get('Device_Merchant__c').getDescribe().Fields.getMap();
        List<Schema.SObjectField> field_object_values_map = field_oject_map.values();
        for( Schema.SObjectField s : field_object_values_map ){
            field_name = s.getDescribe().getName();
            query += field_name + ', ';
        }
        query = query.subStringBeforeLast(',');
        query += ' FROM Device_Merchant__c WHERE Application_Product_Merchant__c =  \'' + appProductMerchantIdP + '\'';
        devicesList = (List<Device_Merchant__c>)Database.query( query );
        System.debug('devicesList: ' + devicesList);

        return devicesList;

    }

}