// Dynamic class for reading Picklist values in Salesforce Apex

public class DynamicPicklistValueRenderer {
    
    /*This method takes two parameter, Object and picklist field name. 
*On basis of these two inputs, 
*we can read either Picklist label or Picklist value (API Name) */
    
    @AuraEnabled 
    public static Map<string,string> getpickListValue(String objectName,String fieldName){   
        
        Map<string,string>  pickListValue =new Map<string,string>() ;   
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){


            pickListValue.put(pickListVal.getLabel(),pickListVal.getValue());  
            
        }
        return pickListValue;    
    }
    
}