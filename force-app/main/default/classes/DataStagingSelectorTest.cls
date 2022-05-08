@isTest
public class DataStagingSelectorTest {
	
    @isTest
    public static void testSelectNotByProcessStatus(){
        Data_Staging__c dataStagingDormant = new Data_Staging__c();
        Set<Id> idSet = new Set<Id>();
        Map<String, Schema.RecordTypeInfo> dataStagingRecordTypeMap = Data_Staging__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id dormantAccountRecordTypeId = dataStagingRecordTypeMap.get('Dormant_Account').getRecordTypeId();
        
        //Create test Users
        List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        insert usersList;
        
        //Dormant Test
        dataStagingDormant.recordTypeId = dormantAccountRecordTypeId;
        dataStagingDormant.Banker_Name__c = 'Test Dormant User';
        dataStagingDormant.Banker_Email__c = usersList[0].Email;
        dataStagingDormant.Banker_BRID__c = usersList[0].BRID__c;
        dataStagingDormant.Data_Type__c = 'Dormant Account';
        dataStagingDormant.CIF_Key__c = 'ABDIS88911';
        dataStagingDormant.Client_Name__c = 'Test Dormant Account Name';
        dataStagingDormant.Contact_Person_Name__c = 'Test Dormant Contact';
        dataStagingDormant.Contact_Person_Mobile__c = '0762313111';
        dataStagingDormant.Contact_Person_Work_Dial_Code__c = 011;
        dataStagingDormant.Contact_Person_Work_Number__c = '3145212';
        dataStagingDormant.Account_Number__c = '1125548564';
        dataStagingDormant.Product_Code__c = 'S89';
        dataStagingDormant.Product_Sub_Code__c = 'CHEQ';
        dataStagingDormant.Process_Status__c = 'New';
        dataStagingDormant.Process_Status_Description__c = '';
        
        insert dataStagingDormant;
        idSet.add(dataStagingDormant.id);
        
        List<Data_Staging__c> listInsertedRecords = new DataStagingSelector().selectNotByProcessStatus('Success', 150); 
        listInsertedRecords = new DataStagingSelector().selectById(idSet);
        listInsertedRecords = new DataStagingSelector().selectByProcessStatus('New', 1);
        
    }
}