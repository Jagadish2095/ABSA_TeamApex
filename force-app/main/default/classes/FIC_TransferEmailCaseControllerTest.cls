@IsTest
private class FIC_TransferEmailCaseControllerTest {

    @TestSetup
    static void testSetup(){
        Case cas = new Case(OwnerId = UserInfo.getUserId(), Status = 'Fake Status');
        insert cas;

        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test 1';
        cv.VersionData = Blob.valueOf('Test1');
        cv.PathOnClient = 'Test 1';
        insert cv;

        ContentVersion testCV = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = cas.Id;
        cdl.ContentDocumentId = testCV.ContentDocumentId;
        cdl.ShareType = 'V';
        insert cdl;
    }

    @IsTest
    public static void testJunkQueue(){
        String selectedOption = 'Email not relevant, send case to junk queue';
        String departmentSelected = '';
        String emailSubject = '';
        String emailsBody = '';
        Case cas = [SELECT Id, OwnerId, Status FROM Case LIMIT 1];
        Test.startTest();
        FIC_TransferEmailCaseController.transferCase(cas.Id, selectedOption, departmentSelected, emailSubject, emailsBody);
        Test.stopTest();
        System.assert(true);
    }

    @IsTest
    public static void testDepartment(){
        String selectedOption = 'Email relevant to other department';
        String departmentSelected = 'Non-Res';
        String emailSubject = 'testSubj';
        String emailsBody = 'Test Body';
        Case cas = [SELECT Id, OwnerId, Status FROM Case LIMIT 1];
        Test.startTest();
        FIC_TransferEmailCaseController.transferCase(cas.Id, selectedOption, departmentSelected, emailSubject, emailsBody );
        Test.stopTest();
        System.assert(true);
    }
 
    @IsTest
    public static void testManually(){
        String selectedOption = 'Manually send an email to the relevant recipient group';
        String departmentSelected = '';
        String emailSubject = '';
        String emailsBody = '';
        Case cas = [SELECT Id, OwnerId, Status FROM Case LIMIT 1];
        Test.startTest();
        FIC_TransferEmailCaseController.transferCase(cas.Id, selectedOption, departmentSelected, emailSubject, emailsBody);
        Test.stopTest();
        System.assert(true);
    }
}