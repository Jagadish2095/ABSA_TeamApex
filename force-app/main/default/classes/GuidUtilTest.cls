@isTest
public class GuidUtilTest {
    
    @isTest
    public static void generateGuid(){
        String guid = GuidUtil.NewGuid();
        System.assertNotEquals(guid, '','Guid should not be empty');
 
    }

}