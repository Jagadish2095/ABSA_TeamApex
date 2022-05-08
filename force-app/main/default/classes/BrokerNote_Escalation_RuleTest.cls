/* 
* Test class for - BrokerNote_Escalation_Rule
* @author   Vitthal Jivrag
* @since    2021-01-05
*/

@isTest
private class BrokerNote_Escalation_RuleTest {
    @isTest
    public static void testschedule() {
        Test.StartTest();
        BrokerNote_Escalation_Rule berO = new BrokerNote_Escalation_Rule();
        String sch = '0 0 23 * * ?';
        String jobId = System.schedule('Test',sch,berO);
        Test.stopTest();
    }
    
}