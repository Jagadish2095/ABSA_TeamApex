/**
* Utility class to assist with retrieving schema information
* @author  Derek Hughes
* @created 2018-10-02
*/

public class Sys_Utilities_Schema {
    
    /**
    * Get the full list of field results for a single SObject
    *
    * @param Schema.DescribeSObjectResult dsor
    */
    public static Map<String,Schema.DescribeFieldResult> getAllFieldResults (Schema.DescribeSObjectResult dsor) { 
        system.debug('Getting fields for: '+dsor.getName());
        
        Map<String,Schema.DescribeFieldResult> finalMap = new Map<String, Schema.DescribeFieldResult>();
        
        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
        
        for (String  key : objectFields.keySet()) {
            Schema.SObjectField field = objectFields.get(key);
            Schema.DescribeFieldResult dfr = field.getDescribe();
            //system.debug('Field: '+field);
            //system.debug('Field DR: '+dfr);
            
            // add the results to the map to be returned
            finalMap.put(key, dfr); 
        }
        
        system.debug('Number of fields: '+finalMap.size());
        return finalMap;
    }
}