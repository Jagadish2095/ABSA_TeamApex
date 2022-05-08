/** 
* @author   Rudolf Niehaus : CloudSmiths
* @date     2019-06-11
*
* @description  Helper class for the batch process 
* First sync / update records in the stanging object
* with updated CIF and MDM information, then update OR create new accounts
* from the data in the staging object. Modified by Ephetehe Mokgopanyane (Tetrad IT) for W-002653
*
* @modify   Tracy de Bruin
* @desc     Add code logic for - Account Team, Leads, Contact, Individual vs Business, Task Owner, Email sending
*           Data Staging record Types with diffrent file formats for upload
*/
public class DataStagingProcessBatchHelper extends ClientFinderBase{
    
    static final String privateBankerChangeActionPlanName = 'Private_Banker_Change';
    static final String dormantActionPlanName = 'Dormant_Account';
    static final String businessBankerChangeActionPlanName = 'Business_Banker_Change';
    static final String inactiveActionPlanName = 'Inactive_Account';
    
    /*Rudolf Niehaus : CloudSmiths 
* Create actionPlanTemplate for List accounts
* 
* @param accounts List<Data_Staging__c>
* @return void
*/
    public static List<Data_Staging__c> processBatch( List<Data_Staging__c>  newRecords) {
        
        //Data Staging variables 
        Map<String, Schema.RecordTypeInfo> dataStagingRecordTypeMap = Data_Staging__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id businessBankerRecordTypeId = dataStagingRecordTypeMap.get('Business_Banker_Change').getRecordTypeId();
        Id privateBankerRecordTypeId = dataStagingRecordTypeMap.get('Private_Banker_Change').getRecordTypeId();
        Id dormantAccountRecordTypeId = dataStagingRecordTypeMap.get('Dormant_Account').getRecordTypeId();
        Id inactiveAccountRecordTypeId = dataStagingRecordTypeMap.get('Inactive_Account').getRecordTypeId();
        Map<String, Data_Staging__c> cifDataStagingMap = new Map<String, Data_Staging__c>();
        Account accountTemp = new Account();
        Map<String, Id> dataStagingctionPlanMap = new Map<String, Id>();
        Set<String> dataStagingNames = new Set<String>{privateBankerChangeActionPlanName, businessBankerChangeActionPlanName,dormantActionPlanName,inactiveActionPlanName }; 
            Set<Id> newAccIds = new Set<Id>();
        
        //Variables to flag Data Staging Records with Errors
        Map<String,Data_Staging__c> accountDataStagingMap = new  Map<String,Data_Staging__c>();
        Map<String,Data_Staging__c> accountTeamMemberDataStagingMap = new  Map<String,Data_Staging__c>();
        Map<String,Data_Staging__c> leadDataStagingMap = new  Map<String, Data_Staging__c>();
        Map<String,Data_Staging__c> actionPlanDataStagingMap = new  Map<String,Data_Staging__c>();     
        
        //Email Template Variables 
        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
        Id businessBankerChangeAfrTemplate =[Select id from EmailTemplate where DeveloperName=:'Business_Banker_AFR'].id;
        Id businessBankerChangeEngTemplate =[Select id from EmailTemplate where DeveloperName=:'Business_Banker_ENG'].id;
        Id privateBankerChangeAfrTemplate =[Select id from EmailTemplate where DeveloperName=:'Private_Banker_AFR'].id;
        Id privateBankerChangeEngTemplate =[Select id from EmailTemplate where DeveloperName=:'Private_Banker_ENG'].id;
        
        //Account Team Members Variables
        List<AccountTeamMember> insertAccountTeamMember = new List<AccountTeamMember>();
        List<AccountTeamMember> deleteAccountTeamMember = new List<AccountTeamMember>();
        Set<String> roleNames = new Set<String>{'Private Banker', 'Business Banker'}; 
            Map<String,AccountTeamMember> cifAndMemberMap = new Map<String,AccountTeamMember>();
        
        //Action Plan Variables
        Id actionPlanDormanAccounttId = null;
        Id actionPlanBusinessBankerId = null;
        Id actionPlanInactiveAccounttId = null;
        Id actionPlanPrivateBankerId = null;
        String actionPlanDormantAccountName = null;
        String actionPlanPrivateBankerName = null;
        String actionPlanInactiveAccountName = null;
        String actionPlanBusinessBankerName = null;
        List<ActionPlan> insertActionPlan = new List<ActionPlan>();
        Set<String> actionPlanNames = new Set<String>();
        Map<String, Data_Staging_Setting__mdt> dataStagingSettingMap = new Map<String, Data_Staging_Setting__mdt>();
        Set<String> orgWideEmailNames = new Set<String>();
        String orgWideEmailPrivateBankerEmail;
        String orgWideEmailBusinessBankerEmail;
        
        //Lead Variables
        List<Lead> insertLeads = new List<Lead>();
        Map<String, Schema.RecordTypeInfo> leadRecordTypeMap = Lead.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Set<Id> newLeadIds = new Set<Id>();
        Map<String, Lead> accountLeadIdMap = new Map<String, Lead>();
        Map<Id, Lead> leadIdMap = new Map<Id, Lead>();
            
        
        //Account Variables
        Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        List<Account> updateAccountList = new List<Account>();
        List<Account> insertAccountList = new List<Account>();
        Map<String, Account> accountCIFMap = new Map<String, Account>();
        Set<String> cifNumbers = new Set<String>();
        Id businessClientRecordTypeId = accountRecordTypeMap.get('Client').getRecordTypeId();
        Id indvClientRecordTypeId = accountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        Map<String, String> accountContactIdMap = new Map<String, String>();
        
        //Contact variables
        Map<String, Schema.RecordTypeInfo> contactRecordTypeMap = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id contactRecordTypeId = contactRecordTypeMap.get('Contact').getRecordTypeId();
        List<Contact> updateContactList = new List<Contact>();
        List<Contact> insertContactList = new List<Contact>();
        Set<String> contactEmailAddress = new Set<String>();
        Map<String, Contact> emailContactMap = new Map<String, Contact>();
        
        //User/Banker Variables
        Map<String,User> userEmailAndIdMap = new Map<String,User>();
        Map<String,Id> userBridAndIdMap = new Map<String,Id>();
        Set<String> bankerEmails = new Set<String>();
        Set<String> bankerBridId = new Set<String>();
        
        //Product Variables
        Map<String,Id> productCodeIdMap = new Map<String,Id>();
        Set<String> productCodes = new Set<String>(); 
        
        if(newRecords != null && newRecords.size() > 0) {
            
            //Check to see if Action Plan have been mapped in Custom Metadata
            for(Data_Staging_Setting__mdt eachSetting : new DataStagingSettingsSelector().selectByDeveloperName(dataStagingNames)) {
                if(eachSetting.DeveloperName == privateBankerChangeActionPlanName ) {
                    actionPlanPrivateBankerName = eachSetting.Action_Plan_Name__c;
                    orgWideEmailPrivateBankerEmail = eachSetting.From_Email_Address__c;
                    orgWideEmailNames.add(eachSetting.From_Email_Address__c);
                } else if (eachSetting.DeveloperName == businessBankerChangeActionPlanName ) {
                    actionPlanBusinessBankerName = eachSetting.Action_Plan_Name__c;
                    orgWideEmailBusinessBankerEmail = eachSetting.From_Email_Address__c;
                    orgWideEmailNames.add(eachSetting.From_Email_Address__c);
                } else if (eachSetting.DeveloperName == dormantActionPlanName ) {
                    actionPlanDormantAccountName = eachSetting.Action_Plan_Name__c;
                } else if (eachSetting.DeveloperName == inactiveActionPlanName ) {
                    actionPlanInactiveAccountName = eachSetting.Action_Plan_Name__c;
                }
                actionPlanNames.add(eachSetting.Action_Plan_Name__c);
                dataStagingSettingMap.put(eachSetting.DeveloperName, eachSetting);
            }
            
            //Get Action Plan Id's based on Name in Custom Metadata
            for(ActionPlanTemplateVersion eachActionPlanVersion : new actionPlanTemplateVersionSelector().selectByTemplateName(actionPlanNames)) {
                if(eachActionPlanVersion.Name == actionPlanPrivateBankerName) {
                    actionPlanPrivateBankerId = eachActionPlanVersion.id;
                } else if(eachActionPlanVersion.Name == actionPlanBusinessBankerName) {
                    actionPlanBusinessBankerId = eachActionPlanVersion.id;
                } else if (eachActionPlanVersion.Name == actionPlanDormantAccountName) {
                    actionPlanDormanAccounttId = eachActionPlanVersion.id;
                } else if (eachActionPlanVersion.Name == actionPlanInactiveAccountName) {
                    actionPlanInactiveAccounttId = eachActionPlanVersion.id;
                }
            }
            
            //Add all CIF No to a Set
            for(Data_Staging__c data :newRecords){
                cifNumbers.add(data.CIF_Key__c);
                bankerEmails.add(data.Banker_Email__c);
                bankerBridId.add(data.Banker_BRID__c);
                productCodes.add(data.Product_Sub_Code__c);
                if(data.Client_Email__c != null) {
                    contactEmailAddress.add(data.Client_Email__c);
                }
                
            }
            
            //Get all Accounts based on CIF No
            for(Account acc :new AccountsSelector().selectByCIF(cifNumbers,newRecords.size())){
                accountCIFMap.put(acc.CIF__c, acc);
                if(acc.PersonContactId != null) {
                    accountContactIdMap.put(acc.Id, acc.PersonContactId);
                } 
            }
            
            //Get all UserId's based on Banker Email, add to Map
            for(User eachUser : new UsersSelector().selectByEmail(bankerEmails)) {
                userEmailAndIdMap.put(eachUser.Email, eachUser);
            } 
            
            //Get all UserId's based on Brid Id, add to Map
            for(User eachUser : new UsersSelector().selectByBridNumbers(bankerBridId)) {
                userBridAndIdMap.put(eachUser.BRID__c, eachUser.Id);
                if(!userEmailAndIdMap.containsKey(eachUser.Email)) {
                    userEmailAndIdMap.put(eachUser.Email, eachUser);
                }
            } 
            
            //Get all Products based in Product Code
            for(Financial_Product__c eachProduct : new FinancialProductsSelector().selectByProductCode(productCodes)) {
                productCodeIdMap.put(eachProduct.Product_Code__c, eachProduct.Id);
            } 
            
            //#1. Create/Update Account
            for(Data_Staging__c data :newRecords){
                accountTemp = new Account();
                
                if(userEmailAndIdMap.containsKey(data.Banker_Email__c) ||  userBridAndIdMap.containsKey(data.Banker_BRID__c)) {
                    
                    //Make sure that banker exist in Salesforce
                    if(userEmailAndIdMap.containsKey(data.Banker_Email__c) == false && userBridAndIdMap.containsKey(data.Banker_BRID__c) == false) {
                        //Add Error Message to Data Staging Object and flag as Failed
                        data.Process_Status__c = 'Failed';
                        data.Process_Status_Description__c = 'Banker does not exist as a User in Salesforce';
                    } else {
                        
                        //If Account exist add to List for Update
                        if(accountCIFMap.containsKey(data.CIF_Key__c)){
                            
                            accountTemp = accountCIFMap.get(data.CIF_Key__c);
                            
                            if(data.Client_First_Name__c != null) {
                                accountTemp.Last_External_Update_Reference__pc = data.Data_Type__c + '' + data.CIF_Key__c;
                                accountTemp.Last_External_Update_System__pc = data.Data_Type__c;
                                accountTemp.Last_External_Update_Time__pc = System.now();       
                                accountTemp.Last_External_Update_User__pc = UserInfo.getUserName();
                                accountTemp.Customer_Retention_Banker_Email__pc = userEmailAndIdMap.get(data.Banker_Email__c).Email;
                                accountTemp.Customer_Retention_Banker_Name__pc = userEmailAndIdMap.get(data.Banker_Email__c).Name;
                            } else {
                                accountTemp.Last_External_Update_Reference__c = data.Data_Type__c + '' + data.CIF_Key__c;
                                accountTemp.Last_External_Update_System__c = data.Data_Type__c;
                                accountTemp.Last_External_Update_Time__c = System.now();       
                                accountTemp.Last_External_Update_User__c = UserInfo.getUserName();
                            }
                            
                            if(!updateAccountList.contains(accountTemp)) {
                                updateAccountList.add(accountTemp);
                            }
                            
                            
                        } 
                        //Add to List to create new Client
                        else {
                            
                            if(data.Client_First_Name__c != null) {
                                accountTemp.RecordTypeId = indvClientRecordTypeId;
                                accountTemp.Initials__pc  = data.Client_Initials__c;
                                accountTemp.Salutation = data.Client_Title__c;
                                
                                if(data.Client_Surname__c != null) {
                                    accountTemp.FirstName = data.Client_First_Name__c;
                                    accountTemp.LastName = data.Client_Surname__c;
                                } else {
                                    accountTemp.LastName = data.Client_First_Name__c;
                                }
                                
                                accountTemp.PersonEmail = data.Client_Email__c;
                                accountTemp.Last_External_Update_Reference__pc = data.Data_Type__c + '' + data.CIF_Key__c;
                                accountTemp.Last_External_Update_System__pc = data.Data_Type__c;
                                accountTemp.Last_External_Update_Time__pc = System.now();       
                                accountTemp.Last_External_Update_User__pc = UserInfo.getUserName();
                                accountTemp.Customer_Retention_Banker_Email__pc = userEmailAndIdMap.get(data.Banker_Email__c).Email;
                                accountTemp.Customer_Retention_Banker_Name__pc = userEmailAndIdMap.get(data.Banker_Email__c).Name;
                            } else {
                                accountTemp.RecordTypeId = businessClientRecordTypeId;
                                accountTemp.Name = data.Client_Name__c;
                                accountTemp.Last_External_Update_Reference__c = data.Data_Type__c + '' + data.CIF_Key__c;
                                accountTemp.Last_External_Update_System__c = data.Data_Type__c;
                                accountTemp.Last_External_Update_Time__c = System.now();       
                                accountTemp.Last_External_Update_User__c = UserInfo.getUserName();
                            }  
                            
                            accountTemp.CIF__c = data.CIF_Key__c;                            
                            
                            insertAccountList.add(accountTemp);
                        }
                        
                        accountDataStagingMap.put('Account#' + accountTemp.CIF__c, data);
                    }
                } 
                
                //Add CIF No and Data Staging to Map
                cifDataStagingMap.put(data.CIF_Key__c, data);
            }
            
            //Update existing Accounts
            if(updateAccountList != null && updateAccountList.size() > 0) {
                List<Database.SaveResult> results = Database.update(updateAccountList, false);
                
                //Loop over results record and Flag Data Staging Record with Success/Failed based on Result
                for(Integer i=0;i<results.size();i++){
                    if(!results[i].isSuccess()){
                        accountDataStagingMap.get('Account#' + updateAccountList[i].CIF__c).Process_Status__c = 'Failed';
                        accountDataStagingMap.get('Account#' + updateAccountList[i].CIF__c).Process_Status_Description__c = 'Client Update Exception: ' + results[i].getErrors();
                    } else {
                        accountDataStagingMap.get('Account#' + updateAccountList[i].CIF__c).Process_Status__c = 'Success';
                        accountDataStagingMap.get('Account#' + updateAccountList[i].CIF__c).Process_Status_Description__c = 'Client Updated';
                    }
                }
            }
            
            //Insert new Account
            Set<Id> newlyCreatedAccountIds = new Set<Id>();
            if(insertAccountList != null && insertAccountList.size() > 0) {
                List<Database.SaveResult> results = Database.insert(insertAccountList, false);
                
                //Loop over results record and Flag Data Staging Record with Success/Failed based on Result
                for(Integer i=0;i<results.size();i++){
                    if(!results[i].isSuccess()){
                        accountDataStagingMap.get('Account#' + insertAccountList[i].CIF__c).Process_Status__c = 'Failed';
                        accountDataStagingMap.get('Account#' + insertAccountList[i].CIF__c).Process_Status_Description__c = 'Client Creation Exception: ' + results[i].getErrors();
                        System.debug('###Client Creation Exception: ' + results[i].getErrors());
                    } else {
                        accountDataStagingMap.get('Account#' + insertAccountList[i].CIF__c).Process_Status__c = 'Success';
                        accountDataStagingMap.get('Account#' + insertAccountList[i].CIF__c).Process_Status_Description__c = 'Client Created';
                        newlyCreatedAccountIds.add(insertAccountList[i].id);
                    }
                }
            }
            
            //Query to get PersonContactId's for newly created Person Accounts
            for(Account acc :new AccountsSelector().selectById(newlyCreatedAccountIds)){
                accountContactIdMap.put(acc.Id, acc.PersonContactId);
            }
            
            //Add all newly inserted Accounts to List
            updateAccountList.addAll(insertAccountList);
            
            //Get all Contact linked to Accounts based email address
            for(Contact eachContact : new ContactsSelector().selectByEmails(contactEmailAddress)) {
                emailContactMap.put(eachContact.Email, eachContact); 
            }
            
            //Add all AccountId's to Set
            for(Account acc :updateAccountList){
                newAccIds.add(acc.Id);
                accountCIFMap.put(acc.CIF__c, acc);
            }
            
            //Get all AccountTeamMembers with a Banker Role, add to Map
            for(AccountTeamMember eachMember :  new AccountTeamMembersSelector().selectByAccountIdsAndRole(newAccIds, roleNames)) {
                cifAndMemberMap.put(eachMember.Account.CIF__c, eachMember);
            }
            
            //2. Create and/or delete Account Team Members
            //   DORMANT ACCOUNTS - Create a new Lead
            for(Data_Staging__c data :newRecords) {
                String userId = null;
                String accountCIF = data.CIF_Key__c;
                AccountTeamMember accountTeamMemberTemp = new AccountTeamMember();
                Lead leadTemp = new Lead();
                
                if(cifDataStagingMap.get(data.CIF_Key__c).Process_Status__c != 'Failed') {
                    
                    if(userEmailAndIdMap.containsKey(data.Banker_Email__c)) {
                        userId = userEmailAndIdMap.get(data.Banker_Email__c).id;
                    } else if (userBridAndIdMap.containsKey(data.Banker_BRID__c)) {
                        userId = userBridAndIdMap.get(data.Banker_BRID__c);
                    }
                    
                    if(userId != null) {
                        if(data.RecordTypeId == privateBankerRecordTypeId || data.RecordTypeId == businessBankerRecordTypeId) {
                            
                            if(data.RecordTypeId == businessBankerRecordTypeId) {
                                
                                //Check if Contact exist, if no  create contact
                                Contact tempContact = new Contact();
                                
                                if(emailContactMap.containsKey(data.Client_Email__c)) {
                                    tempContact = emailContactMap.get(data.Client_Email__c);
                                    tempContact.Customer_Retention_Banker_Email__c = userEmailAndIdMap.get(data.Banker_Email__c).Email;
                                    tempContact.Customer_Retention_Banker_Name__c = userEmailAndIdMap.get(data.Banker_Email__c).Name;
                                    tempContact.AccountId = accountCIFMap.get(data.CIF_Key__c).Id;
                                    updateContactList.add(tempContact);
                                } else {
                                    tempContact.Customer_Retention_Banker_Email__c = userEmailAndIdMap.get(data.Banker_Email__c).Email;
                                    tempContact.Customer_Retention_Banker_Name__c = userEmailAndIdMap.get(data.Banker_Email__c).Name;
                                    tempContact.AccountId = accountCIFMap.get(data.CIF_Key__c).Id;
                                    tempContact.LastName = data.Contact_Person_Name__c; 
                                    tempContact.Email = data.Client_Email__c;
                                    insertContactList.add(tempContact);
                                }
                            }
                            
                            //Check if there is already a Banker on the Account
                            if(cifAndMemberMap.containsKey(accountCIF)) {
                                if(cifAndMemberMap.get(accountCIF).UserId != userId) {
                                    //Add AccountTeamMember to delete List if UserId not the same (cannot update a UserId on AccountTeamMember)
                                    deleteAccountTeamMember.add(cifAndMemberMap.get(accountCIF));
                                    
                                    //Create new AccountTeamMember and add to Insert List
                                    accountTeamMemberTemp.AccountId = accountCIFMap.get(data.CIF_Key__c).Id;
                                    accountTeamMemberTemp.UserId = userId;
                                    accountTeamMemberTemp.AccountAccessLevel = 'Read';
                                    
                                    if(data.RecordTypeId == privateBankerRecordTypeId) {
                                        accountTeamMemberTemp.TeamMemberRole = 'Private Banker';
                                    } else {
                                        accountTeamMemberTemp.TeamMemberRole = 'Business Banker';
                                    }
                                    
                                    insertAccountTeamMember.add(accountTeamMemberTemp);
                                    
                                    accountTeamMemberDataStagingMap.put('Member#' + accountTeamMemberTemp.AccountId + '#' + accountTeamMemberTemp.UserId, data);
                                    
                                }
                            } 
                            //No Private Banker Team Member - Create AccountTeamMember
                            else {
                                //Create new AccountTeamMember and add to Insert List
                                accountTeamMemberTemp.AccountId = accountCIFMap.get(data.CIF_Key__c).Id;
                                accountTeamMemberTemp.UserId = userId;
                                accountTeamMemberTemp.AccountAccessLevel = 'Read';
                                
                                if(data.RecordTypeId == privateBankerRecordTypeId) {
                                    accountTeamMemberTemp.TeamMemberRole = 'Private Banker';
                                } else {
                                    accountTeamMemberTemp.TeamMemberRole = 'Business Banker';
                                }
                                
                                insertAccountTeamMember.add(accountTeamMemberTemp);
                                
                                accountTeamMemberDataStagingMap.put('Member#' + accountTeamMemberTemp.AccountId + '#' + accountTeamMemberTemp.UserId, data); 
                            }
                            
                            //#2. Dormant Account: Create Lead with Action Plan and Tasks
                        } else if (data.RecordTypeId == dormantAccountRecordTypeId || data.RecordTypeId == inactiveAccountRecordTypeId) {
                            //Link Lead to Account if Account exist in Salesforce
                            if(accountCIFMap.containsKey(data.CIF_Key__c)) {
                                leadTemp.FinServ__RelatedAccount__c = accountCIFMap.get(data.CIF_Key__c).Id;
                            } else {
                                leadTemp.Expressed_Interest_Detail__c = 'Product Code - ' + data.Product_Code__c + ', Product Sub Code - ' + data.Product_Sub_Code__c + ', Account Number - ' + data.Account_Number__c;
                            }
                            
                            leadTemp.OwnerId = userId;
                            leadTemp.LastName = data.Contact_Person_Name__c;
                            leadTemp.Company = data.Client_Name__c;
                            leadTemp.CIF__c = data.CIF_Key__c;
                            
                            if(data.Contact_Person_Mobile__c != null && !data.Contact_Person_Mobile__c.startsWith('0')) {
                                leadTemp.MobilePhone = '0' + data.Contact_Person_Mobile__c;
                            } else {
                                leadTemp.MobilePhone = data.Contact_Person_Mobile__c;
                            }
                            
                            if(data.Contact_Person_Work_Dial_Code__c != null) {
                                leadTemp.Phone = data.Contact_Person_Work_Dial_Code__c + data.Contact_Person_Work_Number__c;
                            } else {
                                leadTemp.Phone = data.Contact_Person_Work_Number__c;
                            }
                            
                            leadTemp.RecordTypeId = leadRecordTypeMap.get('Business_Bank_Lead').getRecordTypeId();
                            
                            //Get Product based on Product Code
                            if(productCodeIdMap.containsKey(data.Product_Sub_Code__c)) {
                                leadTemp.Financial_Product__c = productCodeIdMap.get(data.Product_Sub_Code__c);
                            }
                            
                            //Language
                            if(data.Language__c == 'A') {
                                leadTemp.Language_Preference__c = 'Afrikaans';
                            } else {
                                leadTemp.Language_Preference__c = 'English';
                            }
                            
                            leadTemp.Bypass_Validation_Rules__c = true;
                            
                            insertLeads.add(leadTemp);
                            leadDataStagingMap.put('Lead#' + leadTemp.FinServ__RelatedAccount__c + '#' + leadTemp.OwnerId, data);
                        }
                        
                    } else {
                        //Add Error Message to Data Staging Object and flag as Failed
                        data.Process_Status__c = 'Failed';
                        data.Process_Status_Description__c = 'Banker does not exist as a User in Salesforce';
                    }
                }
            }
            
            //Update Contact
            if(updateContactList != null && updateContactList.size() > 0) {
                List<Database.SaveResult> results = Database.Update(updateContactList, false);
            }
            
            //Insert new Contacts
            if(insertContactList != null && insertContactList.size() > 0) {
                List<Database.SaveResult> results = Database.Insert(insertContactList, false);
            }
            
            //Add all newly inserted Accounts to List
            updateContactList.addAll(insertContactList);
            
            for(Contact eachContact : updateContactList) {
                accountContactIdMap.put(eachContact.AccountId,eachContact.id);
            }
            
            //Delete old AccounTeamMembers
            if(deleteAccountTeamMember != null && deleteAccountTeamMember.size() > 0) {
                List<Database.DeleteResult> results = Database.Delete(deleteAccountTeamMember, false);
            }
            
            //Insert New AccounTeamMembers
            if(insertAccountTeamMember != null && insertAccountTeamMember.size() > 0) {
                List<Database.SaveResult> results = Database.Insert(insertAccountTeamMember, false);
                
                Map<String, Id> orgWideNameAndId = new Map<String, Id>();
                
                //Get Org Wide Emaill address for from email on emails being sent
                for(OrgWideEmailAddress eachEmail : new OrgWideEmailAddressesSelector().selectByAddress(orgWideEmailNames)) {
                    orgWideNameAndId.put(eachEmail.Address, eachEmail.id);
                }
                
                //Loop over results record and Flag Data Staging Record with Success/Failed based on Result
                for(Integer i=0;i<results.size();i++){
                    if(!results[i].isSuccess()){
                        accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Process_Status__c = 'Failed';
                        accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Process_Status_Description__c = 'Account Team Member Creation Exception: ' + results[i].getErrors();
                    } else {
                        
                        accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Process_Status__c = 'Success';
                        accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Process_Status_Description__c = 'Account Team Member Created';
                        
                        //On Success - Notify Customer of Banker Change
                        if( accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Client_Email__c != null) {
                            list<String> toAddress = new list<String> { accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Client_Email__c};
                            list<String> ccAddress = new list<String> { accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Banker_Email__c};
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            
                            mail.setWhatId(insertAccountTeamMember[i].AccountId);
                            mail.setTargetObjectId(accountContactIdMap.get(insertAccountTeamMember[i].AccountId));

                            mail.setTreatTargetObjectAsRecipient(true);
                            mail.setSaveAsActivity(false);
                            mail.setToAddresses(toAddress); 
                            mail.setCcAddresses(ccAddress); 
                            
                            //Business Banker Email Template
                            if(accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).RecordTypeId == businessBankerRecordTypeId) {
                                if(accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Language__c == 'A') {
                                    mail.setTemplateId(businessBankerChangeAfrTemplate);
                                } else {
                                    mail.setTemplateId(businessBankerChangeEngTemplate);
                                }
                                
                                if(orgWideNameAndId.containsKey(orgWideEmailBusinessBankerEmail)) {
                                    mail.setOrgWideEmailAddressId(orgWideNameAndId.get(orgWideEmailBusinessBankerEmail));
                                }
                                
                            } 
                            //Private Banker Afrikaans Email Template
                            else if (accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).RecordTypeId == privateBankerRecordTypeId) {
                                if(accountTeamMemberDataStagingMap.get('Member#' + insertAccountTeamMember[i].AccountId + '#' + insertAccountTeamMember[i].UserId).Language__c == 'A') {
                                    mail.setTemplateId(privateBankerChangeAfrTemplate);
                                } else {
                                    mail.setTemplateId(privateBankerChangeEngTemplate);
                                }
                                
                                if(orgWideNameAndId.containsKey(orgWideEmailPrivateBankerEmail)) {
                                    mail.setOrgWideEmailAddressId(orgWideNameAndId.get(orgWideEmailPrivateBankerEmail));
                                }
                            } 
                            
                            if((dataStagingSettingMap.containsKey('Private_Banker_Change') && dataStagingSettingMap.get('Private_Banker_Change').CC_Banker_in_Emails__c == true ) || 
                               (dataStagingSettingMap.containsKey('Business_Banker_Change') && dataStagingSettingMap.get('Business_Banker_Change').CC_Banker_in_Emails__c == true )) {
                                   emailsOutList.add(mail);
                               }                             
                        } 
                    }
                }
            }   
            
            //Send Change of Banker Emails
            if(emailsOutList != null && emailsOutList.size() > 0 ) {
                try {
                    Messaging.reserveSingleEmailCapacity(emailsOutList.size() * 2);
                    Messaging.sendEmail(emailsOutList);
                } catch (Exception ex) {
                    System.debug('Exception in sending Emails : ' + ex);
                    throw new customException('Exception in sending Emails : ' + ex);
                }
                
            }
            
            //Insert New Leads
            if(insertLeads != null && insertLeads.size() > 0) {
                List<Database.SaveResult> results = Database.Insert(insertLeads, false);
                
                //Loop over results record and Flag Data Staging Record with Success/Failed based on Result
                for(Integer i=0;i<results.size();i++){
                    if(!results[i].isSuccess()){
                        leadDataStagingMap.get('Lead#' + insertLeads[i].FinServ__RelatedAccount__c + '#' + insertLeads[i].OwnerId).Process_Status__c = 'Failed';
                        leadDataStagingMap.get('Lead#' + insertLeads[i].FinServ__RelatedAccount__c + '#' + insertLeads[i].OwnerId).Process_Status_Description__c = 'Lead Creation Exception: ' + results[i].getErrors();
                    } else {
                        leadDataStagingMap.get('Lead#' + insertLeads[i].FinServ__RelatedAccount__c + '#' + insertLeads[i].OwnerId).Process_Status__c = 'Success';
                        leadDataStagingMap.get('Lead#' + insertLeads[i].FinServ__RelatedAccount__c + '#' + insertLeads[i].OwnerId).Process_Status_Description__c = 'Lead Created';
                    }
                }
                
            }   
            
            
            //Add all LeadId's to Set
            for(Lead eachLead :insertLeads){
                newLeadIds.add(eachLead.Id);
                accountLeadIdMap.put(eachLead.FinServ__RelatedAccount__c ,eachLead);
                leadIdMap.put(eachLead.id, eachLead);
            }
            
            //#3. BANKER CHANGE: Create Action Plan and Tasks, linked to Account
            //    DORMANT ACCOUNT: Create Action Plan and Tasks link to Lead
            for(Account acc :new AccountsSelector().selectById(newAccIds)){
                Id userId = null;
                ActionPlan actionPlanTemp = new ActionPlan();
                
                if(cifDataStagingMap.get(acc.CIF__c).Process_Status__c != 'Failed') {
                    
                    if(cifDataStagingMap.containsKey(acc.CIF__c)) {
                        if(userEmailAndIdMap.containsKey(cifDataStagingMap.get(acc.CIF__c).Banker_Email__c)) {
                            userId = userEmailAndIdMap.get(cifDataStagingMap.get(acc.CIF__c).Banker_Email__c).Id;
                        } else if (userBridAndIdMap.containsKey(cifDataStagingMap.get(acc.CIF__c).Banker_BRID__c)) {
                            userId = userBridAndIdMap.get(cifDataStagingMap.get(acc.CIF__c).Banker_BRID__c);
                        }                    
                        
                        if(userId != null) {
                            if(cifDataStagingMap.get(acc.CIF__c).RecordTypeId == privateBankerRecordTypeId || cifDataStagingMap.get(acc.CIF__c).RecordTypeId == businessBankerRecordTypeId) {
                                if(cifDataStagingMap.get(acc.CIF__c).RecordTypeId == privateBankerRecordTypeId) {
                                    actionPlanTemp.ActionPlanTemplateVersionId = actionPlanPrivateBankerId;
                                } else {
                                    actionPlanTemp.ActionPlanTemplateVersionId = actionPlanBusinessBankerId;
                                }
                                
                                actionPlanTemp.TargetId = acc.Id; 
                            }else if (cifDataStagingMap.get(acc.CIF__c).RecordTypeId == dormantAccountRecordTypeId || cifDataStagingMap.get(acc.CIF__c).RecordTypeId == inactiveAccountRecordTypeId) {
                                if(accountLeadIdMap.containsKey(acc.Id)){
                                    if(cifDataStagingMap.get(acc.CIF__c).RecordTypeId == dormantAccountRecordTypeId) {
                                        actionPlanTemp.ActionPlanTemplateVersionId = actionPlanDormanAccounttId;   
                                    } else {
                                        actionPlanTemp.ActionPlanTemplateVersionId = actionPlanInactiveAccounttId; 
                                    }
                                    
                                    actionPlanTemp.TargetId = accountLeadIdMap.get(acc.Id).id; 
                                }                            
                            }
                            
                            actionPlanTemp.OwnerId = userId;
                            actionPlanTemp.Name = cifDataStagingMap.get(acc.CIF__c).Client_Name__c + ' - ' + cifDataStagingMap.get(acc.CIF__c).Data_Type__c;
                            actionPlanTemp.StartDate = System.today();
                            actionPlanTemp.ActionPlanState = 'Not Started';
                            actionPlanTemp.IsUsingHolidayHours = false;
                            actionPlanTemp.ActionPlanType = 'Industries';
                            
                            insertActionPlan.add(actionPlanTemp);
                            
                            actionPlanDataStagingMap.put('ActionPlan#' + actionPlanTemp.TargetId + '#' + actionPlanTemp.OwnerId, cifDataStagingMap.get(acc.CIF__c));
                            
                        } else {
                            //Add Error Message to Data Staging Object and flag as Failed
                            cifDataStagingMap.get(acc.CIF__c).Process_Status__c = 'Failed';
                            cifDataStagingMap.get(acc.CIF__c).Process_Status_Description__c = 'Banker does not exist as a User in Salesforce';
                        }  
                    }
                }
            }          
            
            //Insert Action Plan
            Set<Id> actionPlanIds = new Set<Id>();
            if(insertActionPlan != null && insertActionPlan.size() > 0) {
                System.debug('Action Plan : ' + insertActionPlan);
                List<Database.SaveResult> results = Database.Insert(insertActionPlan, false);
                //Loop over results record and Flag Data Staging Record with Success/Failed based on Result
                for(Integer i=0;i<results.size();i++){
                    if(!results[i].isSuccess()){
                        actionPlanDataStagingMap.get('ActionPlan#' + insertActionPlan[i].TargetId + '#' + insertActionPlan[i].OwnerId).Process_Status__c = 'Failed';
                        actionPlanDataStagingMap.get('ActionPlan#' + insertActionPlan[i].TargetId + '#' + insertActionPlan[i].OwnerId).Process_Status_Description__c = 'Action Plan Creation Exception: ' + results[i].getErrors();
                    } else {
                        actionPlanIds.add(results[i].getId());
                        actionPlanDataStagingMap.get('ActionPlan#' + insertActionPlan[i].TargetId + '#' + insertActionPlan[i].OwnerId).Process_Status__c = 'Success';
                        actionPlanDataStagingMap.get('ActionPlan#' + insertActionPlan[i].TargetId + '#' + insertActionPlan[i].OwnerId).Process_Status_Description__c = 'Action Plan with Tasks (if any) Created';
                    }
                }
            }
            
            //Get ActionPlanItems for Dormant Account Action Plans to update Assigned To. 
            //NB: This is a workarounds due to Action Plan Template for Leads does not support Assigned To to be the Action Plan Owner (only the Creator which is the Batch running User)
            Set<Id> taskIds = new Set<Id>();
            List<Task> updateTasks = new List<Task>();
            
            for(ActionPlanItem eachItem : [SELECT Id, ActionPlanId, ItemId FROM ActionPlanItem where ActionPlanId IN : actionPlanIds]) {
                taskIds.add(eachItem.ItemId);
            }
            
            for(Task eachTask : [SELECT Id, Subject, OwnerId, WhoId FROM Task WHERE Id =: taskIds]) {
                if(leadIdMap.containsKey(eachTask.WhoId)) {
                    eachTask.OwnerId = leadIdMap.get(eachTask.WhoId).OwnerId;
                    updateTasks.add(eachTask);
                } 
            }
            
            //Update Dormant Account Tasks
            if(updateTasks != null && updateTasks.size() > 0) {
                List<Database.SaveResult> results = Database.Update(updateTasks, false);
            }
            
            //Update Data Staging Process fields based on Order of execution
            //1. Accounts
            for(String eachKey : accountDataStagingMap.KeySet()) {
                cifDataStagingMap.get(accountDataStagingMap.get(eachKey).CIF_Key__c).Process_Status__c = accountDataStagingMap.get(eachKey).Process_Status__c;  
                cifDataStagingMap.get(accountDataStagingMap.get(eachKey).CIF_Key__c).Process_Status__c = accountDataStagingMap.get(eachKey).Process_Status__c; 
            }
            //2. Account Team Member
            for(String eachKey : accountTeamMemberDataStagingMap.KeySet()) {
                cifDataStagingMap.get(accountTeamMemberDataStagingMap.get(eachKey).CIF_Key__c).Process_Status__c = accountTeamMemberDataStagingMap.get(eachKey).Process_Status__c;  
                cifDataStagingMap.get(accountTeamMemberDataStagingMap.get(eachKey).CIF_Key__c).Process_Status__c = accountTeamMemberDataStagingMap.get(eachKey).Process_Status__c; 
            }
            //3. Leads
            for(String eachKey : leadDataStagingMap.KeySet()) {
                cifDataStagingMap.get(leadDataStagingMap.get(eachKey).CIF_Key__c).Process_Status__c = leadDataStagingMap.get(eachKey).Process_Status__c;  
                cifDataStagingMap.get(leadDataStagingMap.get(eachKey).CIF_Key__c).Process_Status__c = leadDataStagingMap.get(eachKey).Process_Status__c; 
            }
            //4. Action Plan with Tasks
            for(String eachKey : actionPlanDataStagingMap.KeySet()) {
                cifDataStagingMap.get(actionPlanDataStagingMap.get(eachKey).CIF_Key__c).Process_Status__c = actionPlanDataStagingMap.get(eachKey).Process_Status__c;  
                cifDataStagingMap.get(actionPlanDataStagingMap.get(eachKey).CIF_Key__c).Process_Status__c = actionPlanDataStagingMap.get(eachKey).Process_Status__c; 
            }
            
            return cifDataStagingMap.Values();
            
        } else {
            return null;
        }
        
    }
    
    /* TdB : Not a requirment as yet
     * public class clientCifCallout implements Queueable , Database.AllowsCallouts {
            Set<String> clientCifNos;
            public clientCifCallout(Set<String> clientCifNos){
            this.clientCifNos = clientCifNos;
        }
        public void execute(QueueableContext context) {
            AccountCreate_CIF_MDM.GIPResponse createdAccount;
        
            for(String eachCIF : clientCifNos) {
                System.debug('###eachCIF : ' + eachCIF);
                createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(eachCIF, '0', '009970');  
            }      
        }
    }*/
    
    public class customException extends Exception {}
}