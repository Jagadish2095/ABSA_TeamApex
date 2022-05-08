/**
* @Description: Test Class for CommonUtils generic method
* @Test Classes: CommonUtilsTest
* @Author: Rakesh Byri(Absa)
* @Create date: 2019-04-04
**/
@isTest
public class CommonUtilsTest {
	@isTest
    static void getRecordTypesForsObjectTest(){
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
    }
}