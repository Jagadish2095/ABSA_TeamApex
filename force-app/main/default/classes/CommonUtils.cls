/**
* @Description: Common Utils has generic methods can be re-used by everyone
* @Test Classes: CommonUtilsTest
* @Author: Rakesh Byri(Absa)
* @Create date: 2019-03-04
**/
public class CommonUtils {
	 /*
	 * Method to fetch the recordTypeId by record type developer name
	 * @Param - String - sObject Name
	 * @Param - String - record type develoer name
	 * */
    public static Map<String,Schema.RecordTypeInfo> getRecordTypesForsObject(String sObjectName){
        Map<String,Schema.RecordTypeInfo> rtInfo = Schema.getGlobalDescribe().
            								get(sObjectName).
            								getDescribe().
            								getRecordTypeInfosByDeveloperName();
        //String recordTypeId = rtInfo.get(recordTypeDevName).getRecordTypeId();
        return rtInfo;
    }
}