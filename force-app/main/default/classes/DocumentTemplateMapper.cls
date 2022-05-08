/**
* Mapper that converts an XML with merge fields with the data from records given
* @author  Kyle Alexander
* @created 2019-05-04
*/
public class DocumentTemplateMapper {
    
    private static Map<Id, sObject> objectMap;
    
    /**
     * Method that creates the XML with all merged fields
     *
     * @param objMap - Map of objects in merge fields in format of object ID, object
     * @param xml - XML input (with merge fields)
     * @param lookupMappings - Specifies the lookup api name for that child parent i.e. Quote.QuoteLineItem, QuoteId
     * @return String - completed XML
     */
    public static String createXml(Map<Id, sObject> objMap, String xml, Map<String, String> lookupMappings){
        
        objectMap = objMap;
        
        List<sObject> objectList = new List<sObject>();
        for (Id key : objectMap.keySet()) {
            sObject obj = objectMap.get(key);
            objectList.add(obj);
        }
        
        for(sObject obj : objectList){
            String objName = getStringFromSobject(obj);
            List<Integer> objectIndexes = findMergeFieldIndexes(xml, objName);
            Set<String> objectFieldList = new Set<String>();
            
            for(Integer index : objectIndexes){
                Integer currentIndex = xml.indexOf('.', index);
                objectFieldList.add(xml.substring(currentIndex + 1, xml.IndexOf('}', currentIndex)));
            }
            
            //If no fields found - just use Id
            if(objectFieldList.size() < 1){
                objectFieldList.add('Id');
            }
            
            String soql = constructSoql(objName, objectFieldList, obj.Id);
            System.debug(soql);
            List<sObject> query = Database.query(soql);
            for(String objectField : objectFieldList){
                String replacement = String.valueOf(query.get(0).get(objectField));
                if(replacement == null){
                    replacement = '';
                }
                replacement = formateField(replacement, objName, objectField);
                xml = xml.replace(('{' + objName + '.' + objectField + '}'), replacement);
            }
        }
        
        if(xml.contains('<ListOf')){
            String result = containsList(xml, objectMap, lookupMappings);
            result = xmlFilter(result);
            System.debug(result);
            if(result.contains('{') && result.contains('}')){
                throw new MappingException('Error - XML generation still contains merge fields @' + result.substring(result.indexOf('{') - 1, result.indexOf('}') - 1));
            }
            else{
                Boolean isContinue = true;
                Integer currentSubstring = 0;
                Integer nextSubstring = 200;
                while(isContinue){
                    if(nextSubstring < result.length()){
                        System.debug(result.substring(currentSubstring, nextSubstring));
                        currentSubstring += 200;
                        nextSubstring += 200; 
                    }
                    else{
                        isContinue = false;
                        System.debug(result.substring(currentSubstring, result.length()));
                    }
                    
                }
                
                return result;
            }
        }
        else{
            xml = xmlFilter(xml);
            if(xml.contains('{') && xml.contains('}')){
                throw new MappingException('Error - XML generation still contains merge fields @' + xml.substring(xml.indexOf('{') - 1, xml.indexOf('}') - 1));
            }
            else{
                
                Boolean isContinue = true;
                Integer currentSubstring = 0;
                Integer nextSubstring = 200;
                while(isContinue){
                    if(nextSubstring < xml.length()){
                        System.debug(xml.substring(currentSubstring, nextSubstring));
                        currentSubstring += 200;
                        nextSubstring += 200; 
                    }
                    else{
                        isContinue = false;
                        System.debug(xml.substring(currentSubstring, xml.length()));
                    }
                    
                }
                return xml;
            }
        }    
    }
    
    /**
     * Recursive function that is called that handles lists 
     *
     * @param objMap - Map of objects in merge fields in format of object ID,object
     * @param xml - XML input (with merge fields)
     * @param lookupMappings - Specifies the lookup api name for that child parent i.e. Quote.QuoteLineItem, QuoteId
     * @return String - completed XML
     */
    private static String containsList(String xml, Map<Id, sObject> objectMap, Map<String, String> lookupMappings){
        Integer listFieldIndex = xml.IndexOf('<ListOf');
        String listFields = xml;
        listFields = listFields.substring(listFieldIndex + 1, listFields.indexOf('>', listFieldIndex));
        String replaceAtEnd = listFields;
        List<String> objectFields = listFields.split('\\.');
        String parent = objectFields.get(1);
        String child = objectFields.get(2);
        
        //Get search expression
        System.debug('listFields ' + listFields);
        String additionalFilter = null;
        if(listFields.contains('searchExpr')){
            Integer filterIndex = listFields.indexOf('"');
            System.debug('filterIndex ' + filterIndex);
            additionalFilter = listFields.substring(filterIndex + 1, listFields.indexOf('"', filterIndex + 2));
            System.debug('additionalFilter ' + additionalFilter);
        }
        
        System.debug('parent' + parent);
        System.debug('child' + child);
                        
        //Get the parent Id
        Id parentId;
        List<Id> allObjectIds = new List<Id>();
        for (Id key : objectMap.keySet()) {
            sObject obj = objectMap.get(key);
            String sObjName = getStringFromSobject(obj);
            if(sObjName == parent){
                parentId = key;
                allObjectIds.add(key);
            }
        }
        
        //Get Merge Fields
        List<Integer> objectIndexes = findMergeFieldIndexes(xml, child);   
        Set<String> objectFieldList = new Set<String>();
        
        for(Integer index : objectIndexes){
            Integer currentIndex = xml.indexOf('.', index);
            System.debug('currentIndex ' + currentIndex);
            objectFieldList.add(xml.substring(currentIndex + 1, xml.IndexOf('}', currentIndex)));
            System.debug(xml.substring(currentIndex + 1, xml.IndexOf('}', currentIndex)));
        }
        
        Integer objIdIndex = allObjectIds.size() - 1;        
        for(Id objId : allObjectIds){
            List<sObject> query;
            String soql = constructSoqlWithWhere(child, objectFieldList, allObjectIds.get(objIdIndex), parent, lookupMappings, additionalFilter);
            System.debug('objectFieldList ' + objectFieldList);
            System.debug('soql ' + soql);
            query = Database.query(soql);
            System.debug('query ' + query);
            
            listFields = xml;
            Integer lastIndex = listFields.indexOf('>', (listFieldIndex + 1));
            listFields = listFields.substring((lastIndex + 1), listFields.indexOf('</ListOf.' + parent, (lastIndex + 1)));
            
            //Add extra fields list sections in xml
            Integer i = 0;
            Integer qLen = query.size() - 1;
            
            if(query.size() == 0){
                for(String objectField : objectFieldList){
                    String replacement = '';
                    String pattern = '\\{' + child + '.' + objectField + '\\}';
                    xml = xml.replaceFirst(pattern, replacement);
                    System.debug('replacement: ' + replacement);
                }
            }
            
            for(sObject obj : query){
                //Replace current set with data
                for(String objectField : objectFieldList){
                    
                    String replacement;
                    if(query.get(i).get(objectField) == null){
                        replacement = '';
                    }
                    else{
                        replacement = String.valueOf(query.get((i)).get(objectField));
                    }
                                        
                    String pattern = '\\{' + child + '.' + objectField + '\\}';
                    xml = xml.replaceFirst(pattern, replacement);
                }
                
                //Check if it's last record, then don't add new merge field set
                if(i != (query.size() - 1)){
                    xml = xml.substring(0, (lastIndex + 1)) + listFields + xml.substring((lastIndex + 1), xml.length());
                }
                
                //Add object to map
                Id idObj = Id.valueOf(String.valueOf(query.get(i).get('Id')));
                objectMap.put(idObj, query.get(i));
                
                i++;
            }
            objIdIndex--;
        }            
        
        //Remove List
        xml = xml.replace('<' + replaceAtEnd + '>', '');
        xml = xml.replace('</' + replaceAtEnd + '>', '');
        
        //Recursive function - if there's more List's then call itself else return the xml
        if(xml.contains('<ListOf')){
            System.debug('-----------' + xml);
            Boolean isContinue = true;
            Integer currentSubstring = 0;
            Integer nextSubstring = 200;
            while(isContinue){
                if(nextSubstring < xml.length()){
                    System.debug(xml.substring(currentSubstring, nextSubstring));
                    currentSubstring += 200;
                    nextSubstring += 200; 
                }
                else{
                    isContinue = false;
                    System.debug(xml.substring(currentSubstring, xml.length()));
                }
                
            }
            
            return containsList(xml, objectMap, lookupMappings);
        }
        else{
            return xml;
        }  
    }
    
    //Thulani
    public static String createXmlForAuto(Map<String, String> objMap, String xml) {
        String replacementString;
        for (String field :objMap.keySet()) {
            replacementString = String.valueOf(objMap.get(field));

            // replacementString is null then set it to blank
            if (replacementString == null) {
                replacementString = '';
            }

            xml = xml.replace(('{' + field + '}'), replacementString);
        }
        // PJAIN: 20200811: Filter XML to remove un-substituted fields.
        xml = xmlFilter(xml);
        return xml;
    }
    
    /*
    * Thulani
    */
    private static String xmlFilter(String xml) {
        String newXml = xml;
        String fieldToRemove;
        while (newXml.contains('{') && newXml.contains('}')) {
            fieldToRemove = newXml.substring(newXml.indexOf('{') , newXml.indexOf('}') + 1);
            newXml = newXml.replace(fieldToRemove, '');
        }

        return newXml;
    }
    
    private static String formateField(String replacement, String objectName, String objectField) {
        Map<String, Schema.SObjectField> objectFieldsData = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for(String s : objectFieldsData.keySet()) {
            Schema.DescribeFieldResult lfieldLabel = objectFieldsData.get(s).getDescribe();
            Schema.DisplayType dType = lfieldLabel.getType();
            string fieldType = String.ValueOf(dType);

            if(objectField.toLowerCase() == s.toLowerCase() && fieldType == 'DATE') {
                if(replacement != '') {
                    replacement = Datetime.valueOf(replacement).format('yyyy-MM-dd') + 'T00:00:00';
                }else {
                    replacement = Datetime.now().format('yyyy-MM-dd') + 'T00:00:00';
                }
                break;
            } else if(objectField.toLowerCase() == s.toLowerCase() && fieldType == 'PERCENT' || fieldType == 'CURRENCY' || fieldType == 'Double') {
                if(replacement == '') {
                    replacement = '0.00';
                }
                System.debug('objectField 169 ' + objectField);
                break;
            }
        }
        return replacement;
    }
    
    private static List<Integer> findMergeFieldIndexes(String textString, String word){
        List<Integer> indexes = new List<Integer>();
        String lowerCaseTextString = textString.toLowerCase();
        String lowerCaseWord = '{' + word.toLowerCase() + '.';
        
        Integer index = 0;
        while(index != -1){
            index = lowerCaseTextString.indexOf(lowerCaseWord, index);
            if (index != -1) {
                indexes.add(index);
                index++;
            }
        }
        return indexes;
    }
    
    /**
     * Method that extracts object type from sObject
     *
     * @param o - Generic SalesForce object
     * @return String - Object name as string
     */
    private static String getStringFromSobject(sObject o){
        String strObjType = String.valueOf(o);
        
        Integer posA = strObjType.indexOf(':');
        String obj = strObjType.substring(0, posA);
        
        return obj;
    }
    
    /**
     * Method that constructs a SOQL query from given paramters
     *
     * @param strObjectName - Object querying from
     * @param lstFields - List of fields that need to be fetched
     * @param objId - To get record for that object
     * @return String - constructed Soql string
     */
    private static String constructSoql(String strObjectName, Set<String> lstFields, String objId){
        String soqlTemplate = 'SELECT {0} FROM {1}';
        
        List<String> listStrings = new List<String>(lstFields);
        String soql = String.format(soqlTemplate, new List<String>{String.join(listStrings, ', '), strObjectName});
                
        soql += ' WHERE Id = \'' + objId + '\'';
        return soql;
    }
    
    /**
     * Method that constructs a SOQL query for lists and additional search criteria that gets appended to the where clause
     *
     * @param strObjectName - Object querying from
     * @param lstFields - List of fields that need to be fetched
     * @param parentId - Parent Id of the record being queried
     * @param parent - Parent object name as string
     * @param lookupMappings - Specifies the lookup api name for that child parent i.e. Quote.QuoteLineItem, QuoteId
     * @param additionalFilter - Additional filter criteria that gets appended to the end of the where clause
     * @return String - constructed Soql string
     */
    private static String constructSoqlWithWhere(String strObjectName, Set<String> lstFields, Id parentId, String parent, Map<String, String> lookupMappings, String additionalFilter){  
        if(lookupMappings == null || lookupMappings.isEmpty()){
            throw new MappingException('Lookup Mappings cannot be empty and requires mappings if the XML contains a List');
        }
        else{
            //Get lookup
            String key = parent + '.' + strObjectName;
            String value = lookupMappings.get(key);
            
            if(value == null){
                throw new MappingException('Value for key: ' + parent + '.' + strObjectName + ' was not provided');
            }
            
            String soqlTemplate = 'SELECT {0} FROM {1} WHERE ';
            
            List<String> listStrings = new List<String>(lstFields);
            String soql = String.format(soqlTemplate, new List<String>{String.join(listStrings, ', '), strObjectName});
            
            if(additionalFilter != null){
                soql += value + ' = \'' + parentId + '\' AND ' + additionalFilter;
            }
            else{
                soql += value + ' = \'' + parentId + '\'';
            }
            return soql;
        }
    }
    
    public class MappingException extends Exception {}
}