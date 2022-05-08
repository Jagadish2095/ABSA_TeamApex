/* --------------------------------------------------
Strike by Appiphony

Version: 0.10.0
Website: http://www.lightningstrike.io
GitHub: https://github.com/appiphony/Strike-Components
License: BSD 3-Clause License
-------------------------------------------------- */
public with sharing class strike_lookupController {
    
    @AuraEnabled
    public static String getRecentRecords(String jsonString) {
        strike_responseData responseData = new strike_responseData();

        try {

            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
            Map<Id, RecentlyViewed> recentlyViewedMap = new Map<Id, RecentlyViewed>([SELECT Id
                                                                                     FROM RecentlyViewed
                                                                                     WHERE Type = :((String)jsonMap.get('object'))]);
            List<Id> idList = new List<Id>(recentlyViewedMap.keySet());
            
			//TdB - Do not run code for Service Type, there is a junction object between Service Group and Service Type called Service Group Type
            if (idList.size() > 0 && ((String)jsonMap.get('object')) != 'Service_Type__c' && jsonMap.get('filter') != null) {
                String filter = 'Id IN (\'' + String.join(idList, '\',\'') + '\')';

                if (strike_lookupController.fieldNotEmpty(jsonMap, 'filter')) {
                    //TdB - Account Filter on Contact
                    if(((String)jsonMap.get('object')) == 'Contact') {
                        filter += ' AND (AccountId = \'' + jsonMap.get('filter') + '\')';
                    }
                    
                    //The original filter passed through the comp
                    //filter += ' AND (' + jsonMap.get('filter') + ')'; 
                }

                jsonMap.put('filter', filter);

                responseData.results = strike_lookupController.getData(jsonMap);
            } else {
                responseData.results = new Map<String, Object>{
                    'data' => new List<String>(),
                    'searchTerm' => ''
                };
            }
        } catch (Exception e) {
            responseData.addError(e.getMessage());
        }

        return responseData.getJsonString();
    }

    @AuraEnabled
    public static String getRecordLabel(String jsonString) {
        strike_responseData responseData = new strike_responseData();

        try {
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

            String obj = (String)jsonMap.get('object');
            String objectLabel = Schema.describeSObjects(new List<String>{obj})[0].getLabel();

            responseData.results.put('objectLabel', objectLabel);
        } catch (Exception e) {
            responseData.addError(e.getMessage());
        }

        return responseData.getJsonString();
    }

    @AuraEnabled
    public static String getRecords(String jsonString) {
        strike_responseData responseData = new strike_responseData();

        try {
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
            responseData.results = strike_lookupController.getData(jsonMap);
        } catch (Exception e) {
            responseData.addError(e.getMessage());
        }

        return responseData.getJsonString();
    }

    private static Map<String, Object> getData(Map<String, Object> jsonMap) {
        List<Map<String, Object>> data = new List<Map<String, Object>>();

        String objType = String.escapeSingleQuotes((String)jsonMap.get('object'));
        String query = strike_lookupController.getQuery(jsonMap);
        String searchField = String.escapeSingleQuotes((String)jsonMap.get('searchField'));
        String searchTerm = '';
        String subtitleField;

        if (strike_lookupController.fieldNotEmpty(jsonMap, 'subtitleField')) {
            subtitleField = String.escapeSingleQuotes((String)jsonMap.get('subtitleField'));
        }

        if (strike_lookupController.fieldNotEmpty(jsonMap, 'searchTerm')) {
            searchTerm = String.escapeSingleQuotes((String)jsonMap.get('searchTerm'));
        }

        if (String.isEmpty(subtitleField)) {
            for (sObject obj : Database.query(query)) {
                data.add(new Map<String, Object>{
                    'label' => strike_lookupController.getValue(obj, objType, searchField),
                    'value' => obj.get('Id')
                });
            }
        } else {
            for (sObject obj : Database.query(query)) {
                data.add(new Map<String, Object>{
                    'label' => strike_lookupController.getValue(obj, objType, searchField),
                    'sublabel' => strike_lookupController.getValue(obj, objType, subtitleField),
                    'value' => obj.get('Id')
                });
            }
        }

        return new Map<String, Object>{
                   'data' => data,
                   'searchTerm' => searchTerm
        };
    }

    private static String getQuery(Map<String, Object> jsonMap) {

        Set<String> queryFields = new Set<String>{'Id'};
        List<String> filters = new List<String>();
        List<String> orders = new List<String>();

        String query;
        String obj = String.escapeSingleQuotes((String)jsonMap.get('object'));
        String subtitleField;

        if (strike_lookupController.fieldNotEmpty(jsonMap, 'subtitleField')) {
            subtitleField = String.escapeSingleQuotes((String)jsonMap.get('subtitleField'));
            queryFields.add(subtitleField);
        }

        if (strike_lookupController.fieldNotEmpty(jsonMap, 'searchField')) {
            queryFields.add(String.escapeSingleQuotes((String)jsonMap.get('searchField')));

            if (strike_lookupController.fieldNotEmpty(jsonMap, 'searchTerm')) {
                String searchField = String.escapeSingleQuotes((String)jsonMap.get('searchField'));
                String searchTerm = String.escapeSingleQuotes((String)jsonMap.get('searchTerm'));
				
                //if(strike_lookupController.fieldNotEmpty(jsonMap, 'filter')) {
                    filters.add(searchField + ' LIKE \'%' + searchTerm + '%\'');
                //}
                System.debug('RN: ' + filters[0]);
            }
        }

        if (strike_lookupController.fieldNotEmpty(jsonMap, 'filter')) {
            //filters.add('(' + (String)jsonMap.get('filter') + ')');
             filters.add((String)jsonMap.get('filter'));
        }

        if (strike_lookupController.fieldNotEmpty(jsonMap, 'order')) {
            orders.add(String.escapeSingleQuotes((String)jsonMap.get('order')));
        }

        query = 'SELECT ' + String.join(new List<String>(queryFields), ', ');
        query += ' FROM ' + obj;
		System.debug('###filters : ' + filters);
        if (filters.size() > 0) {
            
            Set<String> childIds = new Set<String>();
            Set<String> filterStrings = new Set<String>();
            
            String childIdsString = '';
            
            Set<Id> idSet = new Set<Id>();
            
            if(filters.size() == 2){
                String parentId = String.valueOf( filters[1] );
                
                if(obj == 'Service_Group__c') {
                    filterStrings.add(parentId);
                } else {
                    idSet.add(parentId);
                }

                //Service Type filter
                //RN : Get all service type ids for a specific service group and filter on that as well
                if (obj == 'Service_Type__c') {
                    List<Service_Group_Type__c> sgtList = new ServiceGroupTypesSelector().selectByServiceGroupId(idSet);
                    
                    for(Service_Group_Type__c sgt :sgtList){
                        
                        if(String.isNotBlank(sgt.Service_Type__c)){
                            childIds.add(sgt.Service_Type__c);
                            childIdsString+= '\'' + sgt.Service_Type__c + '\',';
                        }
                    }
                }
                //Contact filter
                //TdB - Get all Contacts for a specific Account
                else if (obj == 'Contact') {
                    List<Contact> contactList = new ContactsSelector().selectByAccountId(idSet);
                    
                    for(Contact eachContact : contactList){
                        childIds.add(eachContact.Id);
                        childIdsString+= '\'' + eachContact.Id + '\',';
                    }
                }
                
                //Tdb - Service Group Filter
                else if (obj == 'Service_Group__c') {
                    List<Service_Group__c> serviceGroupList = new serviceGroupsSelector().selectByAssignedRecordType(filterStrings);
                    for(Service_Group__c eachServiceGroup : serviceGroupList){
                        childIds.add(eachServiceGroup.Id);
                        childIdsString+= '\'' + eachServiceGroup.Id + '\',';
                    }
                }
                //Tdb - Site Filter
                else if (obj == 'Site__c') {
                    List<Site__c> siteList = new sitesSelector().selectByServiceGroup(idSet);
                    for(Site__c eachSite : siteList){
                        childIds.add(eachSite.Id);
                        childIdsString+= '\'' + eachSite.Id + '\',';
                    }
                }
                //Tdb - Site Filter
                else if (obj == 'Lookup__c') {
                    List<Lookup__c> lookupList = new LookupsSelector().selectByBankId(idSet); 
                    for(Lookup__c eachLookup : lookupList){
                        childIds.add(eachLookup.Id);
                        childIdsString+= '\'' + eachLookup.Id + '\',';
                    }
                }
                
                childIdsString = childIdsString.removeEnd(',');
                childIdsString = '(' + childIdsString + ')';
            }

            query += ' WHERE ' + filters[0];
            
            if(childIds.size() > 0){ 
                query += ' AND Id IN ' + childIdsString;
            } else {
                query += ' AND Id = null'; 
            }

            //The original where clause for the filter passed through the comp
            //query += ' WHERE ' + String.join(filters, ' AND ');
        }

        if (orders.size() > 0) {
            query += ' ORDER BY ' + String.join(orders, ', ');
        }
        

        if (strike_lookupController.fieldNotEmpty(jsonMap, 'limit')) {
            query += ' LIMIT ' + String.escapeSingleQuotes((String)jsonMap.get('limit'));
        }
        System.debug('###query: ' + query);
        return query;
    }

    private static Boolean fieldNotEmpty(Map<String, Object> jsonMap, String field) {
        return jsonMap.containsKey(field) && !String.isEmpty((String)jsonMap.get(field));
    }

    private static String getValue(SObject obj, String objectType, String field) {
        List<String> fieldPath = field.split('[.]');
        Object label = strike_utilities.convertObjectToMap(obj);
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectType).getDescribe().fields.getMap();

        for (String fieldName : fieldPath) {
            fieldName = fieldName.replaceAll('__r$', '__c');

            label = ((Map<String, Object>)label).get(fieldName);

            if (label == null) {
                return '';
            }

            if (fieldMap.containsKey(fieldName + 'Id')) {
                fieldName = fieldName + 'Id';
            }

            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
            String fieldType = String.valueOf(fieldDescribe.getType()).toUpperCase();

            if (fieldType == 'REFERENCE') {
                fieldMap = Schema.getGlobalDescribe().get(String.valueOf(fieldDescribe.getReferenceTo().get(0))).getDescribe().fields.getMap();
            } else if (fieldType == 'ADDRESS') {
                List<String> addressComponents = new List<String>();
                Map<String, Object> addr = (Map<String, Object>)label;

                if (addr.containsKey('street') && addr.get('street') != null) {
                    addressComponents.add((String)addr.get('street'));
                }

                if (addr.containsKey('city') && addr.get('city') != null) {
                    addressComponents.add((String)addr.get('city'));
                }

                if (addr.containsKey('state') && addr.get('state') != null) {
                    addressComponents.add((String)addr.get('state'));
                }
 
                if (addr.containsKey('country') && addr.get('country') != null) {
                    addressComponents.add((String)addr.get('country'));
                }

                if (addr.containsKey('postalCode') &&addr.get('postalCode') != null) {
                    addressComponents.add((String)addr.get('postalCode'));
                }

                // change later for user formatting?
                label = String.join(addressComponents, ', ');
            }
        }

        return String.valueOf(label);
    }
}