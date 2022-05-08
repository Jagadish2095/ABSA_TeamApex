/**@description test Class for ContentVersionTriggerTest
* @author  Prasanth
* @since 2021-06-12
* **/
@isTest 
public class ContentVersionTriggerTest {
    @isTest
    public static void insertContentDocument(){
        String caserecordTypeId  = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='6211275132089';
        accountList[0].AccountNumber ='6211275132089';
        accountList[0].Country_of_Citizenship__c =  'South Africa';
        accountList[0].PersonBirthdate = Date.valueOf('1962-11-27');
        accountList[0].Gender__pc = 'Male';
        insert accountList;
        list<case> testcase=TestDataFactory.getCases('FIC_Case',1);        
        testcase[0].RecordtypeId=caserecordTypeId;
        testcase[0].AccountId=accountList[0].id;
        insert testcase[0];
        system.debug('testcase[0]>>'+testcase[0].RecordtypeId);
        ContentVersion contVerFile = new ContentVersion();
        ContVerFile.VersionData = Blob.valueOf('testsjdaru893pdf'); 
        ContVerFile.VersionData =EncodingUtil.base64Decode('testkdsjfkdaji84pdf');
        ContVerFile.Title = 'DHACert'; 
        ContVerFile.PathOnClient = 'DHA.pdf';
        ContVerFile.ContentLocation= 's';
        Test.startTest(); 
        insert contVerFile; 
        System.assert(ContVerFile.id!= null,false);
        
        //Get Content Documents
        Id conDoc;  
        if(contVerFile!=null){
            conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ContVerFile.Id].ContentDocumentId;
        }
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = testcase[0].id;
        cDe.ShareType = 'I';
        cDe.Visibility = 'AllUsers';
        
        insert cDe;
        System.assert(cDe.id!= null,false);
        
        map<id,ContentVersion> docIdContentVersionMap=new map<id,ContentVersion>();
        docIdContentVersionMap.put(conDoc,contVerFile);
        ContentVersionTriggerHandler.getContentDocumentLink(docIdContentVersionMap);
       
        Test.stopTest(); 
        
    }
}