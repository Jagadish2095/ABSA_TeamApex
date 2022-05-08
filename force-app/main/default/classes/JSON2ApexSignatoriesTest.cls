/**
* Test Class for JSON2ApexSignatories
*
* @author Vladimir Panajic
* @since 2019-10-21
*
**/
@isTest
public class JSON2ApexSignatoriesTest {
	
    static testMethod void JSON2ApexSignatories() {
        test.startTest();
        String ss = '[{"Id":"0033O00000G5BCUQA3","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"tinashem@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';
        List<JSON2ApexSignatories> signatoryList = JSON2ApexSignatories.parse(ss);
        test.stopTest();
    }
}