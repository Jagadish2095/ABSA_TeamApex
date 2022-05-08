@isTest
public class DataStagingProcessBatchTest {
    
    @isTest
    public static void testDataStagingBatch(){
        
        //Create test Users
        List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        insert usersList;
  
        //Record Types
        Map<String, Schema.RecordTypeInfo> dataStagingRecordTypeMap = Data_Staging__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id businessBankerRecordTypeId = dataStagingRecordTypeMap.get('Business_Banker_Change').getRecordTypeId();
        Id privateBankerRecordTypeId = dataStagingRecordTypeMap.get('Private_Banker_Change').getRecordTypeId();
        Id dormantAccountRecordTypeId = dataStagingRecordTypeMap.get('Dormant_Account').getRecordTypeId();
        Id inactiveAccountRecordTypeId = dataStagingRecordTypeMap.get('Inactive_Account').getRecordTypeId();
        
        //Data Staging Settings
        List<Data_Staging_Setting__mdt> dataStagingSettingList = new List<Data_Staging_Setting__mdt>();
        Data_Staging_Setting__mdt dormantDataStagingSetting = new Data_Staging_Setting__mdt();
        dormantDataStagingSetting.DeveloperName = 'Dormant_Account';
        dormantDataStagingSetting.MasterLabel = 'Dormant Account';
        dormantDataStagingSetting.Label = 'Dormant Account';
        dormantDataStagingSetting.QualifiedApiName = 'Dormant_Account';
        dormantDataStagingSetting.Action_Plan_Name__c = 'Dormant Account';
        dormantDataStagingSetting.CC_Banker_in_Emails__c = true;
        dataStagingSettingList.add(dormantDataStagingSetting);
        
        //Action Plan Template
        List<ActionPlanTemplate> actionTemplateList = new List<ActionPlanTemplate>();
        List<ActionPlanTemplateVersion> actionPlanTemplateVersionList = new List<ActionPlanTemplateVersion>();
        
        //Dormant Action Plan Template
        ActionPlanTemplate dormantActionTemplate = new ActionPlanTemplate();
        dormantActionTemplate.Name = 'Dormant Account';
        dormantActionTemplate.ActionPlanType = 'Industries';
        dormantActionTemplate.TargetEntityType = 'Lead';
        actionTemplateList.add(dormantActionTemplate);
        
        //Private Banker Action Plan Template
        ActionPlanTemplate privateBankerActionTemplate = new ActionPlanTemplate();
        privateBankerActionTemplate.Name = 'Private Banker Change';
        privateBankerActionTemplate.ActionPlanType = 'Industries';
        privateBankerActionTemplate.TargetEntityType = 'Account';
        actionTemplateList.add(privateBankerActionTemplate);
        
        insert actionTemplateList;
        
        //Create Action Plan Items
        List<ActionPlanTemplateItem> actionPlanTemplateItemList = new List<ActionPlanTemplateItem>();
        
        ActionPlanTemplateVersion tempActionPlanTemplateVersion = new ActionPlanTemplateVersion();
        ActionPlanTemplateItem tempActionPlanTemplateItem = new ActionPlanTemplateItem();
        for(ActionPlanTemplateVersion eachVersion : [SELECT Id, Name, Status FROM ActionPlanTemplateVersion]) {
            tempActionPlanTemplateVersion = eachVersion;
            //tempActionPlanTemplateVersion.Status = 'Final';
            actionPlanTemplateVersionList.add(tempActionPlanTemplateVersion);            
            //Create Action Plan Template Items
            tempActionPlanTemplateItem = new ActionPlanTemplateItem();
            tempActionPlanTemplateItem.Name = 'Call Test - ' + eachVersion.Name;
            tempActionPlanTemplateItem.ActionPlanTemplateVersionId  = eachVersion.id;
            tempActionPlanTemplateItem.ItemEntityType = 'Task';
            tempActionPlanTemplateItem.IsRequired = true;
            actionPlanTemplateItemList.add(tempActionPlanTemplateItem);
        }      
        //insert actionPlanTemplateItemList;
        
        //Action Plan Template Version
        ActionPlanTemplateVersion dormantActionPlanTemplateVersion = new ActionPlanTemplateVersion();
        dormantActionPlanTemplateVersion.Name = 'Dormant Account';    
        dormantActionPlanTemplateVersion.ActionPlanTemplateId = actionTemplateList[0].Id; 
        dormantActionPlanTemplateVersion.Version =1;
        dormantActionPlanTemplateVersion.Status = 'Final';
        dormantActionPlanTemplateVersion.ActivationDateTime = System.now();
        actionPlanTemplateVersionList.add(dormantActionPlanTemplateVersion);
        
        //Action Plan Template Version
        ActionPlanTemplateVersion privateBankerActionPlanTemplateVersion = new ActionPlanTemplateVersion();
        privateBankerActionPlanTemplateVersion.Name = 'Private Banker Change';    
        privateBankerActionPlanTemplateVersion.ActionPlanTemplateId = actionTemplateList[1].Id; 
        privateBankerActionPlanTemplateVersion.Version =1;
        privateBankerActionPlanTemplateVersion.Status = 'Final';
        privateBankerActionPlanTemplateVersion.ActivationDateTime = System.now();
        actionPlanTemplateVersionList.add(privateBankerActionPlanTemplateVersion);
        
        Data_Staging__c dataStagingDormant = new Data_Staging__c();
        Data_Staging__c dataStagingInactive = new Data_Staging__c();
        Data_Staging__c dataStagingPrivateBanker = new Data_Staging__c();
        Data_Staging__c dataStagingBusinessBanker = new Data_Staging__c();
        List<Data_Staging__c> dataStagingList = new List<Data_Staging__c>();
        
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
        dataStagingList.add(dataStagingDormant);
        
        //Private Test
        dataStagingPrivateBanker.recordTypeId = privateBankerRecordTypeId;
        dataStagingPrivateBanker.Banker_Name__c = 'Test Private User';
        dataStagingPrivateBanker.Banker_Email__c = usersList[0].Email;
        dataStagingPrivateBanker.Banker_BRID__c = usersList[0].BRID__c;
        dataStagingPrivateBanker.Data_Type__c = 'Private Banker Change';
        dataStagingPrivateBanker.CIF_Key__c = 'ABDTYTR011';
        dataStagingPrivateBanker.Client_Name__c = 'Test Private Account Name';
        dataStagingPrivateBanker.Client_Initials__c = 'FMA';
        dataStagingPrivateBanker.Client_Title__c = 'Mr.';
        dataStagingPrivateBanker.Client_Surname__c = 'Private';
        dataStagingPrivateBanker.Client_First_Name__c = 'Test';
        dataStagingPrivateBanker.Client_Email__c = 'testclient@Private.com';
        dataStagingPrivateBanker.Process_Status__c = 'New';
        dataStagingPrivateBanker.Process_Status_Description__c = '';
        dataStagingList.add(dataStagingPrivateBanker);
        
        //Business Test
        dataStagingBusinessBanker.recordTypeId = businessBankerRecordTypeId;
        dataStagingBusinessBanker.Banker_Name__c = 'Test Business User';
        dataStagingBusinessBanker.Banker_Email__c = usersList[0].Email;
        dataStagingBusinessBanker.Banker_BRID__c = usersList[0].BRID__c;
        dataStagingBusinessBanker.Data_Type__c = 'Business Banker Change';
        dataStagingBusinessBanker.CIF_Key__c = 'ABDISTR221';
        dataStagingBusinessBanker.Client_Name__c = 'Test Business Account Name';
        dataStagingBusinessBanker.Contact_Person_Name__c = 'Test Business Contact';
        dataStagingBusinessBanker.Client_Email__c = 'testclient@Business.com';
        dataStagingBusinessBanker.Process_Status__c = 'New';
        dataStagingBusinessBanker.Process_Status_Description__c = '';
        dataStagingList.add(dataStagingBusinessBanker);
        
        Test.startTest();
        
        try {
            insert dataStagingList;
            
            
            List<Data_Staging__c> dataStagingListUpdate = new List<Data_Staging__c>();
            for(Data_Staging__c eachDataStaging : dataStagingList) {
                eachDataStaging.Process_Status__c = 'New';
                dataStagingListUpdate.add(eachDataStaging);
            }
            
            update dataStagingListUpdate;
            
            //Schedule Batch
            DataStagingProcessSchedulable sh1 = new DataStagingProcessSchedulable();
            String sch = '0 0 23 * * ?'; system.schedule('Test DataStagingProcessSchedulable', sch, sh1); 
            
        } catch (Exception ex) {
            System.debug('Testing Exception : ' + ex);
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void testDataStagingBatchSchedule(){
        //Create test Users
        List<User> usersList = TestDataFactory.getTestUsers('System Administrator', 1);
        insert usersList;
        
        //Record Type
        Map<String, Schema.RecordTypeInfo> dataStagingRecordTypeMap = Data_Staging__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id businessBankerRecordTypeId = dataStagingRecordTypeMap.get('Business_Banker_Change').getRecordTypeId();
        Id privateBankerRecordTypeId = dataStagingRecordTypeMap.get('Private_Banker_Change').getRecordTypeId();
        Id dormantAccountRecordTypeId = dataStagingRecordTypeMap.get('Dormant_Account').getRecordTypeId();
        Id inactiveAccountRecordTypeId = dataStagingRecordTypeMap.get('Inactive_Account').getRecordTypeId();
        
        //Data Staging Settings
        List<Data_Staging_Setting__mdt> dataStagingSettingList = new List<Data_Staging_Setting__mdt>();
        Data_Staging_Setting__mdt dormantDataStagingSetting = new Data_Staging_Setting__mdt();
        dormantDataStagingSetting.DeveloperName = 'Dormant_Account';
        dormantDataStagingSetting.MasterLabel = 'Dormant Account';
        dormantDataStagingSetting.Label = 'Dormant Account';
        dormantDataStagingSetting.QualifiedApiName = 'Dormant_Account';
        dormantDataStagingSetting.Action_Plan_Name__c = 'Dormant Account';
        dormantDataStagingSetting.CC_Banker_in_Emails__c = true;
        dataStagingSettingList.add(dormantDataStagingSetting);
        
        //Action Plan Template
        List<ActionPlanTemplate> actionTemplateList = new List<ActionPlanTemplate>();
        List<ActionPlanTemplateVersion> actionPlanTemplateVersionList = new List<ActionPlanTemplateVersion>();
        
        //Dormant Action Plan Template
        ActionPlanTemplate dormantActionTemplate = new ActionPlanTemplate();
        dormantActionTemplate.Name = 'Dormant Account';
        dormantActionTemplate.ActionPlanType = 'Industries';
        dormantActionTemplate.TargetEntityType = 'Lead';
        actionTemplateList.add(dormantActionTemplate);
        
        //Private Banker Action Plan Template
        ActionPlanTemplate privateBankerActionTemplate = new ActionPlanTemplate();
        privateBankerActionTemplate.Name = 'Private Banker Change';
        privateBankerActionTemplate.ActionPlanType = 'Industries';
        privateBankerActionTemplate.TargetEntityType = 'Account';
        actionTemplateList.add(privateBankerActionTemplate);
        
        insert actionTemplateList;
        
        //Create Action Plan Items
        List<ActionPlanTemplateItem> actionPlanTemplateItemList = new List<ActionPlanTemplateItem>();
        
        ActionPlanTemplateVersion tempActionPlanTemplateVersion = new ActionPlanTemplateVersion();
        ActionPlanTemplateItem tempActionPlanTemplateItem = new ActionPlanTemplateItem();
        for(ActionPlanTemplateVersion eachVersion : [SELECT Id, Name, Status FROM ActionPlanTemplateVersion]) {
            tempActionPlanTemplateVersion = eachVersion;
            //tempActionPlanTemplateVersion.Status = 'Final';
            actionPlanTemplateVersionList.add(tempActionPlanTemplateVersion);            
            //Create Action Plan Template Items
            tempActionPlanTemplateItem = new ActionPlanTemplateItem();
            tempActionPlanTemplateItem.Name = 'Call Test - ' + eachVersion.Name;
            tempActionPlanTemplateItem.ActionPlanTemplateVersionId  = eachVersion.id;
            tempActionPlanTemplateItem.ItemEntityType = 'Task';
            tempActionPlanTemplateItem.IsRequired = true;
            actionPlanTemplateItemList.add(tempActionPlanTemplateItem);
        }     
        //insert actionPlanTemplateItemList;        
        //update tempActionPlanTemplateVersion;
        
        //Action Plan Template Version
        ActionPlanTemplateVersion dormantActionPlanTemplateVersion = new ActionPlanTemplateVersion();
        dormantActionPlanTemplateVersion.Name = 'Dormant Account';    
        dormantActionPlanTemplateVersion.ActionPlanTemplateId = actionTemplateList[0].Id; 
        dormantActionPlanTemplateVersion.Version =1;
        dormantActionPlanTemplateVersion.Status = 'Final';
        dormantActionPlanTemplateVersion.ActivationDateTime = System.now();
        actionPlanTemplateVersionList.add(dormantActionPlanTemplateVersion);
        
        //Action Plan Template Version
        ActionPlanTemplateVersion privateBankerActionPlanTemplateVersion = new ActionPlanTemplateVersion();
        privateBankerActionPlanTemplateVersion.Name = 'Private Banker Change';    
        privateBankerActionPlanTemplateVersion.ActionPlanTemplateId = actionTemplateList[1].Id; 
        privateBankerActionPlanTemplateVersion.Version =1;
        privateBankerActionPlanTemplateVersion.Status = 'Final';
        privateBankerActionPlanTemplateVersion.ActivationDateTime = System.now();
        actionPlanTemplateVersionList.add(privateBankerActionPlanTemplateVersion);        
        
        Data_Staging__c dataStagingDormant = new Data_Staging__c();
        Data_Staging__c dataStagingInactive = new Data_Staging__c();
        Data_Staging__c dataStagingPrivateBanker = new Data_Staging__c();
        Data_Staging__c dataStagingBusinessBanker = new Data_Staging__c();
        List<Data_Staging__c> dataStagingList = new List<Data_Staging__c>();
        
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
        dataStagingList.add(dataStagingDormant);
        
        //Private Test
        dataStagingPrivateBanker.recordTypeId = privateBankerRecordTypeId;
        dataStagingPrivateBanker.Banker_Name__c = 'Test Private User';
        dataStagingPrivateBanker.Banker_Email__c = usersList[0].Email;
        dataStagingPrivateBanker.Banker_BRID__c = usersList[0].BRID__c;
        dataStagingPrivateBanker.Data_Type__c = 'Private Banker Change';
        dataStagingPrivateBanker.CIF_Key__c = 'ABDTYTR011';
        dataStagingPrivateBanker.Client_Name__c = 'Test Private Account Name';
        dataStagingPrivateBanker.Client_Initials__c = 'FMA';
        dataStagingPrivateBanker.Client_Title__c = 'Mr.';
        dataStagingPrivateBanker.Client_Surname__c = 'Private';
        dataStagingPrivateBanker.Client_First_Name__c = 'Test';
        dataStagingPrivateBanker.Client_Email__c = 'testclient@Private.com';
        dataStagingPrivateBanker.Process_Status__c = 'New';
        dataStagingPrivateBanker.Process_Status_Description__c = '';
        dataStagingList.add(dataStagingPrivateBanker);
        
        //Business Test
        dataStagingBusinessBanker.recordTypeId = businessBankerRecordTypeId;
        dataStagingBusinessBanker.Banker_Name__c = 'Test Business User';
        dataStagingBusinessBanker.Banker_Email__c = usersList[0].Email;
        dataStagingBusinessBanker.Banker_BRID__c = usersList[0].BRID__c;
        dataStagingBusinessBanker.Data_Type__c = 'Business Banker Change';
        dataStagingBusinessBanker.CIF_Key__c = 'ABDISTR221';
        dataStagingBusinessBanker.Client_Name__c = 'Test Business Account Name';
        dataStagingBusinessBanker.Contact_Person_Name__c = 'Test Business Contact';
        dataStagingBusinessBanker.Client_Email__c = 'testclient@Business.com';
        dataStagingBusinessBanker.Process_Status__c = 'New';
        dataStagingBusinessBanker.Process_Status_Description__c = '';
        dataStagingList.add(dataStagingBusinessBanker);
        
        Test.startTest();
        
        //Schedule Batch
        DataStagingProcessSchedulable sh1 = new DataStagingProcessSchedulable();
        String sch = '0 0 23 * * ?'; system.schedule('Test DataStagingProcessSchedulable', sch, sh1); 
        
        Test.stopTest();
    }
}