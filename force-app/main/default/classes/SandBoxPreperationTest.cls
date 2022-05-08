@isTest
class SandBoxPreperationTest {

    @isTest
    static void testMySandboxPrep() {
        Test.startTest();
        Test.testSandboxPostCopyScript( new SandBoxPreperation(), UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), UserInfo.getOrganizationName());
        Test.stopTest();
    }
}