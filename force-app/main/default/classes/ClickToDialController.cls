/**
 * @description       : ClickToDialController
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-24
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public class ClickToDialController {
    /**
	 * @description check user access for Opportunity
	 * @param  recordId
     * @param  commaSeperatedFields
	 * @return Map<String,Boolean>
	 */
    @AuraEnabled
    public static Object getClickToDialInfo(Id recordId, String commaSeperatedFields){
        DescribeSObjectResult objectDSR = recordId.getSobjectType().getDescribe();
        String objectName = objectDSR.getName();
        commaSeperatedFields = String.isBlank(commaSeperatedFields) ? '' : commaSeperatedFields;
        commaSeperatedFields = commaSeperatedFields.replaceAll('\\s+', '');
        List<String> fields = commaSeperatedFields.split(',');
        String Search = 'SELECT '+String.join(fields, ', ')+ ' FROM ' + objectName+ ' WHERE Id =:recordId';
        sObject record = Database.query(search);
        Map<String, Schema.SObjectField> fieldMap = objectDSR.fields.getMap();
        List<Object> result = new List<Object>();
        for(String field : fields){
            if(fieldMap.containsKey(field)){
                Map<String, Object> clickToDialInfo = new Map<String, Object>();
                clickToDialInfo.put('label', fieldMap.get(field).getDescribe().getLabel());
                clickToDialInfo.put('value', record.get(field));
                result.add(clickToDialInfo);
            }
        }
        return result;
    }
}