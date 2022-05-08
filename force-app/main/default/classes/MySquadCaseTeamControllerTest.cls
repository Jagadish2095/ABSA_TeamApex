/**
* Test class for MySquadCaseTeamController
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2020-02-11
*
**/

@isTest
public class MySquadCaseTeamControllerTest {

    //Methods to test
    @isTest 
    public static void testgetMyHubDefaultCaseTeam() {
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        //User user = [Select Id From User Where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        System.runAs(testDataFactory.testUser) {
            
            //Create CaseTeamTemplate
            CaseTeamTemplate testCaseTeamTemplate = new CaseTeamTemplate();
            testCaseTeamTemplate.Name = 'Test MyHub';
            insert testCaseTeamTemplate;
                
            //Create CaseTeamRole
            CaseTeamRole testCaseTeamRole = new CaseTeamRole();
            testCaseTeamRole.Name = 'Agent';
            testCaseTeamRole.AccessLevel = 'Edit';
            insert testCaseTeamRole;

            //Create CaseTeamTemplateMember
            CaseTeamTemplateMember testCaseTeamTemplateMember = new CaseTeamTemplateMember();
            testCaseTeamTemplateMember.TeamTemplateId = testCaseTeamTemplate.Id;
            testCaseTeamTemplateMember.MemberId = testDataFactory.testUser.Id;
            testCaseTeamTemplateMember.TeamRoleId = testCaseTeamRole.id;
            insert testCaseTeamTemplateMember;

            Test.startTest();
            List<User> caseTeamUserList = MySquadCaseTeamController.getMyHubDefaultCaseTeam();
            Test.stopTest();
            
        }
    }
}