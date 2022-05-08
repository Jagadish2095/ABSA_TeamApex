/*Test Class for Attestation Popup Controller
 * @Saurabh
*/
@isTest
public class CobAttestationPopUpControllerTest {
       /**
       * @description :  //Testing if oppotunity is getting loaded
       * @author Saurabh | 06-09-2021 
       **/
      @isTest
       public static  void loadOppRecord(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity newOpp = testDataFactory.testOpportunity;
        Id oppId = testDataFactory.testOpportunity.id;
        Test.startTest();
        Opportunity opp = CobAttestationPopUpController.loadOppRecord(oppId);
        Test.stopTest();
        system.assertEquals(newOpp.ID, opp.ID);
    }
    
    /**
    * @description : //Testing if oppotunity is getting closed
    * @author Saurabh | 06-09-2021 
    **/
    @isTest
    public static  void closeOppRecord(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity newOpp = testDataFactory.testOpportunity;
        Id oppId = testDataFactory.testOpportunity.id;
        Test.startTest();
        Opportunity opp = CobAttestationPopUpController.closeOppRecord(oppId);
        Test.stopTest();
        system.assertNotEquals(Null, opp.StageName);
    }
        
        /**
        * @description : //Testing if oppotunity is getting closed
        * @author Saurabh | 06-09-2021 
        **/
        @isTest
        public static  void closeOppRecordException(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity newOpp = testDataFactory.testOpportunity;
        newOpp.StageName = 'Closed';
        Test.startTest();
        try {
        Opportunity opp = CobAttestationPopUpController.closeOppRecord(newOpp.Id);
        System.assertNotEquals(null, opp);
        }catch(Exception e) {
        AssertException AE = new  system.AssertException();
        }
        Test.stopTest();

    }
}