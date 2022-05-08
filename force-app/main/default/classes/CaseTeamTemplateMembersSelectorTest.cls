@IsTest
public class CaseTeamTemplateMembersSelectorTest {

     static testMethod void testSelectById() {
        
       WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Set<Id> userIdSet = new Set<Id>();
        userIdSet.add(testDataFactory.testUser.Id);
        
        List<CaseTeamTemplateMember> caseTeamUsers = new CaseTeamTemplateMembersSelector().selectById(userIdSet);
        
    }
    
    static testMethod void testSelectByTemplateNameAndUserId() {
        
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        List<CaseTeamTemplateMember> caseTeamUsers = new CaseTeamTemplateMembersSelector().selectByTemplateNameAndUserId('test', testDataFactory.testUser.Id);
        
    }
    
    static testMethod void testSelectByTemplateId() {
        
       WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Set<Id> userIdSet = new Set<Id>();
        userIdSet.add(testDataFactory.testUser.Id);
        
        List<CaseTeamTemplateMember> caseTeamUsers = new CaseTeamTemplateMembersSelector().selectByTemplateId(userIdSet);
        
    }
}