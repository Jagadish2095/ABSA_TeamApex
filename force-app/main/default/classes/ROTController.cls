/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-07-27
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
public class ROTController {  
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupId 
    * @param description 
    * @param caseId 
    * @param accountId 
    * @return String 
    **/
    @AuraEnabled
    public static String createNewGroupRestrictionObject(String groupId ,String description , string caseId , String accountId) {
        String restrictionId;
        List<RestrictionGroup__c> currentRestriction = [select Name from RestrictionGroup__c where Name != null order by Name Desc Limit 1];
        
        String tempValue = currentRestriction[0].Name;
        List<String> arrayValue = tempValue.split('R');
        Integer lastNumber = integer.valueOf(arrayValue[1]) + 1;
        String incrementedValue = formatNumber(String.valueOf(lastNumber));
        restrictionId = arrayValue[0] + 'R' + incrementedValue +'-'+ groupId;
        System.debug('Restriction Id ---> ' + restrictionId);
        System.debug('GROUP ID---> ' + groupId);
        
        ROTCreateGroupRestriction_Req_IB_v1 requestBean = new ROTCreateGroupRestriction_Req_IB_v1();
        requestBean.CreateGroupRestriction = new ROTCreateGroupRestriction_Req_IB_v1.CreateGroupRestriction();
        requestBean.CreateGroupRestriction.groupRestriction = new ROTCreateGroupRestriction_Req_IB_v1.GroupRestriction(); 
        requestBean.CreateGroupRestriction.groupRestriction.ClusterID = 'ABS';
        requestBean.CreateGroupRestriction.groupRestriction.Description = description;
        requestBean.CreateGroupRestriction.groupRestriction.ObjectID = restrictionId;
        requestBean.CreateGroupRestriction.user = 'SALESFORCE';
        
        ROTCreateGroupRestriction_Resp_IB_v1 responseBean = ROTCreateGroupRestriction_IH_v1.CreateGroupRestriction(requestBean);
        
        if(responseBean != null){
            if(responseBean.CreateGroupRestrictionResponse != null){
                if(responseBean.CreateGroupRestrictionResponse.CreateGroupRestrictionResult != null){
                    if(responseBean.CreateGroupRestrictionResponse.CreateGroupRestrictionResult.HasErrors == 'false'){
                         RestrictionGroup__c restrictionGroup = new RestrictionGroup__c();
        				 restrictionGroup.GroupID__c = groupId;
        				 restrictionGroup.Description__c = description;
                         restrictionGroup.Restriction_ID__c = restrictionId;
                         restrictionGroup.Case__c = caseId;
                         restrictionGroup.Status__c = 'Added';
                         restrictionGroup.Account_Name__c = accountId;
        				 insert restrictionGroup;
                         return JSON.serialize(responseBean);
                    } else{
                         return JSON.serialize(responseBean);
                    }
                }
            }
        }
        return null;
    }
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param value 
    * @return String 
    **/
    public static String formatNumber(String value){
            if(value.length() == 1){
            	return '000'+ value;
        	}else if(value.length() == 2){
            	return '00'+ value;
        	}else if(value.length() == 3){
            	return '0'+ value;
        	}else{
            	return value;
        	}
        
    } 

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param description 
    * @param ObjectID 
    * @return String 
    **/
     @AuraEnabled
    public static String updateGroupRestriction(String groupRestrictionId ,String description , string ObjectID) {
       
        ROTUpdateGroupRestriction_IB_Req_v1 response = new ROTUpdateGroupRestriction_IB_Req_v1();
		response.UpdateGroupRestriction = new ROTUpdateGroupRestriction_IB_Req_v1.UpdateGroupRestriction();
        response.UpdateGroupRestriction.groupRestriction = new ROTUpdateGroupRestriction_IB_Req_v1.GroupRestriction();
        response.UpdateGroupRestriction.groupRestriction.ClusterID = 'ABS';
        response.UpdateGroupRestriction.groupRestriction.Description = description;
        response.UpdateGroupRestriction.groupRestriction.ObjectID = ObjectID;
        response.UpdateGroupRestriction.user = 'SALESFORCE';
        
        ROTUpdateGroupRestriction_IB_Resp_v1 responseBean = ROTUpdateGroupRestriction_IH_v1.UpdateGroupRestriction(response);
        
        if(responseBean != null){
            if(responseBean.UpdateGroupRestrictionResponse != null){
                
                if(responseBean.UpdateGroupRestrictionResponse.UpdateGroupRestrictionResult != null){
                    if(responseBean.UpdateGroupRestrictionResponse.UpdateGroupRestrictionResult.HasErrors == 'false'){
                        
                         RestrictionGroup__c restrictionGroup = new RestrictionGroup__c(Id=groupRestrictionId);
        				 restrictionGroup.Description__c = description;
                         restrictionGroup.Status__c = 'Updated';
        				 update restrictionGroup;
                         
                         return JSON.serialize(responseBean);
                    } else{
                         return JSON.serialize(responseBean);
                    }
                }
              
            }
        } 
        return null;
    }    
    
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param restrictionId 
    * @return String 
    **/
    @AuraEnabled
    public static String removeGroupRestriction(String groupRestrictionId ,String restrictionId) {  
        System.debug('Delete Group Restriction id --> ' + groupRestrictionId);
        
        ROTDeleteGroupRestriction_IB_Req_v1 requestBean = new ROTDeleteGroupRestriction_IB_Req_v1(); 
        requestBean.DeleteGroupRestriction = new ROTDeleteGroupRestriction_IB_Req_v1.DeleteGroupRestriction();
        requestBean.DeleteGroupRestriction.groupRestriction = new ROTDeleteGroupRestriction_IB_Req_v1.groupRestriction();
        requestBean.DeleteGroupRestriction.groupRestriction.ObjectID = restrictionId;
        requestBean.DeleteGroupRestriction.groupRestriction.ClusterID = 'ABS';
        requestBean.DeleteGroupRestriction.user = 'SALESFORCE';
        
        ROTDeleteGroupRestriction_IB_Resp_v1 responseBean = ROTDeleteGroupRestriction_IH_v1.DeleteGroupRestriction(requestBean);
        System.debug('Service Response =' + responseBean);
        if(responseBean != null){
            if(responseBean.DeleteGroupRestrictionResponse != null){
                if(responseBean.DeleteGroupRestrictionResponse.DeleteGroupRestrictionResult.HasErrors == 'false'){
                     RestrictionGroup__c restrictionGroup = new RestrictionGroup__c(Id=groupRestrictionId);
                     restrictionGroup.Status__c = 'Deleted';
                     try {
        			   update restrictionGroup;
                     } catch(DmlException e) {
    					System.debug('An unexpected error has occurred: ' + e.getMessage());
					 }
                      
                     return JSON.serialize(responseBean);
                }else{
                    return JSON.serialize(responseBean);
                }
            }
        }
        return null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param caseId 
    * @return List<RestrictionGroup__c> 
    **/
    @AuraEnabled
    public static List<RestrictionGroup__c> getGroupRestrictions(String caseId)
    {
        List<RestrictionGroup__c> restrictionGroupList = new List<RestrictionGroup__c>();
        
        restrictionGroupList = [SELECT Id,GroupID__c,Restriction_ID__c,Case__c,Description__c,EffectiveStartDate__c,EffectiveEndDate__c,Status__c FROM RestrictionGroup__c where Case__c =: caseId and Status__c != 'Deleted'];
        
        return restrictionGroupList;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param restrictionGroupId 
    * @return List<RestrictionGroupAccount__c> 
    **/
     @AuraEnabled
    public static List<RestrictionGroupAccount__c> getGroupAccounts(String restrictionGroupId)
    {
        List<RestrictionGroupAccount__c> restrictionGroupAccountList = new List<RestrictionGroupAccount__c>();
        
        restrictionGroupAccountList = [SELECT Id,AccountNumber__c, SchemeNodeID__c ,RestrictionGroupId__c ,Description__c,EffectiveStartDate__c,EffectiveEndDate__c,Status__c FROM RestrictionGroupAccount__c where RestrictionGroupId__c =: restrictionGroupId and Status__c != 'Deleted' and Excluded_Account__c= false];
        
        return restrictionGroupAccountList;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param description 
    * @param effectiveEndDate 
    * @param effectiveStartDate 
    * @param groupRestrictionObjectID 
    * @param AccountNumber 
    * @param isInfinity 
    * @return String 
    **/
    @AuraEnabled
    public static String createAccountNode(String groupRestrictionId , String description , String effectiveEndDate , String effectiveStartDate, String groupRestrictionObjectID , String AccountNumber ,String isInfinity){
        
        ROTAddAccount_Req_IB_v1 requestBean = new ROTAddAccount_Req_IB_v1();
        requestBean.AddAccount = new ROTAddAccount_Req_IB_v1.AddAccount();
        requestBean.AddAccount.account = new ROTAddAccount_Req_IB_v1.Account();
        requestBean.AddAccount.account.Description = description;
        requestBean.AddAccount.account.EffectiveEndDate = effectiveEndDate.replace('/','-');
        requestBean.AddAccount.account.EffectiveStartDate = effectiveStartDate.replace('/','-');
        requestBean.AddAccount.account.GroupRestrictionClusterID = 'ABS';
        requestBean.AddAccount.account.GroupRestrictionObjectID = groupRestrictionObjectID;
        requestBean.AddAccount.account.IsEffectiveEndDateInfinity = isInfinity;
        requestBean.AddAccount.account.AccountNumber = AccountNumber;
        requestBean.AddAccount.user = 'SALESFORCE';
        ROTAddAccount_Resp_IB_v1 responseBean = ROTAddAccount_IH_v1.AddAccount(requestBean);
        System.debug('Service Response Muvhuso ---->' + JSON.serialize(responseBean));
        if(responseBean != null){
            System.debug('Inside Muvhuso Test ---->');
            if(responseBean.AddAccountResponse != null){
                if(responseBean.AddAccountResponse.AddAccountResult != null){
                    if(responseBean.AddAccountResponse.AddAccountResult.HasErrors == 'false'){
                       RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        			   groupRestrictionAccount.Description__c = description;
                       groupRestrictionAccount.EffectiveStartDate__c = Date.parse(effectiveStartDate.replace('-','/'));
                       groupRestrictionAccount.EffectiveEndDate__c = Date.parse(isInfinity == 'true' ? '4000/12/31' : effectiveEndDate.replace('-','/'));
                       groupRestrictionAccount.AccountNumber__c = responseBean.AddAccountResponse.AddAccountResult.AccountNumber;
                       groupRestrictionAccount.RestrictionGroupId__c = groupRestrictionId;
                       groupRestrictionAccount.ParentSchemeNodeID__c = responseBean.AddAccountResponse.AddAccountResult.Result.ParentSchemeNodeID;
                       groupRestrictionAccount.SchemeNodeID__c = responseBean.AddAccountResponse.AddAccountResult.Result.SchemeNodeID;
                       groupRestrictionAccount.ObjectID__c = responseBean.AddAccountResponse.AddAccountResult.Result.ObjectID;
                	   groupRestrictionAccount.GroupRestrictionClusterID__c = responseBean.AddAccountResponse.AddAccountResult.GroupRestrictionClusterID;
                	   groupRestrictionAccount.GroupRestrictionObjectID__c = responseBean.AddAccountResponse.AddAccountResult.GroupRestrictionObjectID;
                	   groupRestrictionAccount.IsEffectiveEndDateInfinity__c = isInfinity;
                	   groupRestrictionAccount.Excluded_Account__c = false;
                	   groupRestrictionAccount.Status__c = 'Added';
                       insert groupRestrictionAccount;
                       System.debug('Group Account Id ---->' + groupRestrictionAccount.Id);
                       return JSON.serialize(responseBean);
                    }else{
                       System.debug('Has Error');
                       System.debug('Service Response Muvhuso Has Errors ---->' + JSON.serialize(responseBean));
                       return JSON.serialize(responseBean);        
                    } 
                }
            }
        }
        
        return null;
    }
    
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param accountId 
    * @param accountNumber 
    * @param description 
    * @param startDate 
    * @param endDate 
    * @param groupRestrictionObjectId 
    * @param originalEffectiveStartDate 
    * @return String 
    **/
    @AuraEnabled
    public static String updateAccountNode(string accountId ,  String accountNumber, String description , string startDate , String endDate , String groupRestrictionObjectId ,String originalEffectiveStartDate){
        ROTUpdateAccount_Req_IB_v1 requestBean = new ROTUpdateAccount_Req_IB_v1(); 
        requestBean.UpdateAccount = new ROTUpdateAccount_Req_IB_v1.UpdateAccount();
        requestBean.UpdateAccount.account = new ROTUpdateAccount_Req_IB_v1.Account();
        requestBean.UpdateAccount.account.Description = description;
        requestBean.UpdateAccount.account.EffectiveEndDate = endDate;
        requestBean.UpdateAccount.account.EffectiveStartDate = startDate;
        requestBean.UpdateAccount.account.GroupRestrictionClusterID = 'ABS';
        requestBean.UpdateAccount.account.GroupRestrictionObjectID = groupRestrictionObjectId;
        requestBean.UpdateAccount.account.IsEffectiveEndDateInfinity = 'true';
        requestBean.UpdateAccount.account.AccountNumber = accountNumber;
        requestBean.UpdateAccount.account.OriginalEffectiveStartDate = originalEffectiveStartDate;
        requestBean.UpdateAccount.user = 'SALESFORCE';
        
        ROTUpdateAccount_Resp_IB_v1 responseBean = ROTUpdateAccount_IH_v1.UpdateAccount(requestBean);
        if(responseBean != null){
            if(responseBean.UpdateAccountResponse.UpdateAccountResult != null){
                if(responseBean.UpdateAccountResponse.UpdateAccountResult.HasErrors == 'false'){
                    RestrictionGroupAccount__c groupAccount = new RestrictionGroupAccount__c(Id = accountId);
                    groupAccount.AccountNumber__c = accountNumber;
                    groupAccount.Description__c = description;
                    groupAccount.EffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                    groupAccount.EffectiveEndDate__c = Date.parse(endDate.replace('-', '/'));
                    groupAccount.OriginalEffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                    groupAccount.Status__c = 'Updated';
                    update groupAccount;
                    return JSON.serialize(responseBean);
                }else{
                    return JSON.serialize(responseBean);
                }
            }
        }
        return null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param accountId 
    * @param EffectiveStartDate 
    * @param GroupRestrictionObjectID 
    * @param AccountNumber 
    * @return String 
    **/
    @AuraEnabled
    public static String deleteAccountNode(String accountId , String EffectiveStartDate , String GroupRestrictionObjectID , String AccountNumber){
        ROTDeleteAccount_IB_Req_v1 requestBean = new ROTDeleteAccount_IB_Req_v1();
        requestBean.DeleteAccount = new ROTDeleteAccount_IB_Req_v1.DeleteAccount();
        requestBean.DeleteAccount.account = new ROTDeleteAccount_IB_Req_v1.Account();
        requestBean.DeleteAccount.account.EffectiveStartDate = EffectiveStartDate;
        requestBean.DeleteAccount.account.GroupRestrictionClusterID = 'ABS';
        requestBean.DeleteAccount.account.GroupRestrictionObjectID = GroupRestrictionObjectID;
        requestBean.DeleteAccount.account.AccountNumber = AccountNumber;
        requestBean.DeleteAccount.user = 'SALESFORCE';
        
        ROTDeleteAccount_IB_Resp_v1 responseBean = ROTDeleteAccount_IH_v1.DeleteAccount(requestBean);
        if(responseBean != null){
            if(responseBean.DeleteAccountResponse.DeleteAccountResult.HasErrors != null){
                if(responseBean.DeleteAccountResponse.DeleteAccountResult.HasErrors == 'false'){
                    RestrictionGroupAccount__c groupAccount = new RestrictionGroupAccount__c(Id = accountId);
                    groupAccount.Status__c = 'Deleted';
                    update groupAccount;
                    return JSON.serialize(responseBean);
                }else{
                    return JSON.serialize(responseBean);
                }
            }
        }
        
        return null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param accountList 
    * @param groupRestrictionId 
    * @param startDate 
    * @param endDate 
    * @param groupRestrictionObjectID 
    * @param isInfinity 
    * @return String 
    **/
    @AuraEnabled
    public static String createAccountsNode(String accountList , String groupRestrictionId ,String startDate, String endDate, String groupRestrictionObjectID, String isInfinity){
           Type idArrType = Type.forName('List<string>');
           List<string> wrapperList = (List<string>) JSON.deserialize(accountList, idArrType);
           Integer count = 0;
           integer accountCount = wrapperList.size();
           System.debug('Account Number Test ------------> ' + wrapperList[0]);
           System.debug('Effective End Date ------------> ' + endDate);
        
           List<ROTAddaccounts_IB_Req_v1.AddAccountModel> addAccountList = new List<ROTAddaccounts_IB_Req_v1.AddAccountModel>();
           
           for(integer i = 0 ; i < wrapperList.size(); i++){
               
               ROTAddaccounts_IB_Req_v1.AddAccountModel accountModel = new ROTAddaccounts_IB_Req_v1.AddAccountModel();
               accountModel.Description = 'Cheque Account';
               accountModel.EffectiveEndDate = endDate;
               accountModel.EffectiveStartDate = startDate;
               accountModel.GroupRestrictionClusterID = 'ABS';
               accountModel.GroupRestrictionObjectID = groupRestrictionObjectID;
               accountModel.IsEffectiveEndDateInfinity = isInfinity;
               accountModel.AccountNumber = wrapperList[i];
               addAccountList.add(accountModel);
           }
           	           
           ROTAddaccounts_IB_Req_v1 requestBean = new ROTAddaccounts_IB_Req_v1();
           requestBean.AddAccounts = new ROTAddaccounts_IB_Req_v1.AddAccounts();
           requestBean.AddAccounts.accounts = new ROTAddaccounts_IB_Req_v1.Accounts();
           requestBean.AddAccounts.accounts.AddAccountModel = addAccountList;
           requestBean.AddAccounts.user = 'SALESFORCE';
         
        	ROTAddaccounts_IB_Resp_v1 responseBean = ROTAddaccounts_IH_v1.addaccounts(requestBean);
        	System.debug('Service Response Muvhuso ---->' + JSON.serialize(responseBean));
            List<RestrictionGroupAccount__c> restrictionAccountTemp = new List<RestrictionGroupAccount__c>();
        	if(responseBean != null){
                for(integer key = 0 ; key < responseBean.AddAccountsResponse.AddAccountsResult.AccountActionDataResponse.size(); key++){
                    if(responseBean.AddAccountsResponse.AddAccountsResult.AccountActionDataResponse[key].HasErrors == 'false'){
                        count++;
                        RestrictionGroupAccount__c groupRestrictionAccount = new RestrictionGroupAccount__c();
        			   	groupRestrictionAccount.Description__c = 'Cheque Account';
                      	groupRestrictionAccount.EffectiveStartDate__c = Date.parse(startDate.replace('-','/'));
                      	groupRestrictionAccount.EffectiveEndDate__c = Date.parse(isInfinity == 'true' ? '4000/12/31' : endDate.replace('-','/'));
        			  	groupRestrictionAccount.AccountNumber__c = responseBean.AddAccountsResponse.AddAccountsResult.AccountActionDataResponse[key].AccountNumber;
                        groupRestrictionAccount.RestrictionGroupId__c = groupRestrictionId;
                        groupRestrictionAccount.ParentSchemeNodeID__c = responseBean.AddAccountsResponse.AddAccountsResult.AccountActionDataResponse[key].Result.ParentSchemeNodeID;
                        groupRestrictionAccount.SchemeNodeID__c = responseBean.AddAccountsResponse.AddAccountsResult.AccountActionDataResponse[key].Result.SchemeNodeID;
                        groupRestrictionAccount.ObjectID__c = responseBean.AddAccountsResponse.AddAccountsResult.AccountActionDataResponse[key].Result.ObjectID;
                	    groupRestrictionAccount.GroupRestrictionClusterID__c = responseBean.AddAccountsResponse.AddAccountsResult.AccountActionDataResponse[key].GroupRestrictionClusterID;
                	    groupRestrictionAccount.GroupRestrictionObjectID__c = responseBean.AddAccountsResponse.AddAccountsResult.AccountActionDataResponse[key].GroupRestrictionObjectID;
                	    groupRestrictionAccount.IsEffectiveEndDateInfinity__c = isInfinity;
                	    groupRestrictionAccount.Excluded_Account__c = false;
                	    groupRestrictionAccount.Status__c = 'Added';
                        restrictionAccountTemp.add(groupRestrictionAccount);
                       	//return JSON.serialize(responseBean);  
                      }
                   }
                   if(restrictionAccountTemp.size() > 0){
                     insert restrictionAccountTemp;
                   }
            }  
        	
        if(count == 0){
            return null;
        }else if(count == accountCount){
            return JSON.serialize('All Accounts Inserted Successfully');
        }else{
            return JSON.serialize('Out of '+ accountCount + ' Accounts ' + count + ' were created');
        }
       
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param clientAccountId 
    * @return String 
    **/
     @AuraEnabled
    public static String getAccountDetails(String clientAccountId){
        system.debug('----clientAccountId----'+clientAccountId);
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
        List<RestrictionAccount> accountRestrictionWrapperList;
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        system.debug('----accountList----'+accountList[0].CIF__c);
        CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING,accountList[0].CIF__c);
        
        if(response.statusCode == 200){
            CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;
        
            List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;
            System.debug('---accTypes------'+accTypes);
            accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();
            accountRestrictionWrapperList = new List<RestrictionAccount>();
            
            for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accTypes){
                if(accWrObj.productType == 'CQ'){
                    RestrictionAccount request = new RestrictionAccount();
                    request.accountNumber = accWrObj.oaccntnbr.substring(7,17);
                    accountRestrictionWrapperList.add(request);
                    
                }
                
            }
            return JSON.serialize(accountRestrictionWrapperList);
        }
        
        return null;
        
    }
    /**
    *@description 
    */

    public class RestrictionAccount{
       public string accountNumber;
       
    }
    
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param restrictionGroupId 
    * @return List<RestrictionGroupAccount__c> 
    **/
    @AuraEnabled
    public static List<RestrictionGroupAccount__c> getExcludedAccountNodes(String restrictionGroupId)
    {
        List<RestrictionGroupAccount__c> restrictionExcludedAccountList = new List<RestrictionGroupAccount__c>();
        restrictionExcludedAccountList = [SELECT Id, Name, AccountNumber__c, SchemeNodeID__c ,Description__c, EffectiveEndDate__c, OriginalEffectiveStartDate__c, EffectiveStartDate__c	, GroupRestrictionClusterID__c	, GroupRestrictionObjectID__c, IsEffectiveEndDateInfinity__c,Status__c, RestrictionGroupId__c  
                                          FROM RestrictionGroupAccount__c 
                                          where RestrictionGroupId__c =: restrictionGroupId and Status__c != 'Deleted' and Excluded_Account__c = true];
        return restrictionExcludedAccountList;
    }
    
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param groupRestrictionName 
    * @param clusterId 
    * @param accountNumber 
    * @param accountDescription 
    * @param accountEffectiveStartDate 
    * @param accountEffectiveEndDate 
    * @param isInfinity 
    * @return String 
    **/
     @AuraEnabled
    public static String createExcludedAccountNode(String groupRestrictionId ,String groupRestrictionName, String clusterId, String accountNumber, String accountDescription, String accountEffectiveStartDate, String accountEffectiveEndDate, String isInfinity){
        ROTAddExcludedAccount_Req_IB_v1 requestBean = new ROTAddExcludedAccount_Req_IB_v1();
        requestBean.AddExcludedAccount = new ROTAddExcludedAccount_Req_IB_v1.AddExcludedAccount();
        requestBean.AddExcludedAccount.excludedAccount = new ROTAddExcludedAccount_Req_IB_v1.excludedAccount();
        requestBean.AddExcludedAccount.excludedAccount.Description = accountDescription;
        requestBean.AddExcludedAccount.excludedAccount.EffectiveEndDate = isInfinity.toLowerCase() == 'true'? '9999-12-31' :accountEffectiveEndDate;
        requestBean.AddExcludedAccount.excludedAccount.EffectiveStartDate = accountEffectiveStartDate;
        requestBean.AddExcludedAccount.excludedAccount.GroupRestrictionClusterID = 'ABS';
        requestBean.AddExcludedAccount.excludedAccount.GroupRestrictionObjectID = groupRestrictionName;
        requestBean.AddExcludedAccount.excludedAccount.IsEffectiveEndDateInfinity = isInfinity;
        requestBean.AddExcludedAccount.excludedAccount.AccountNumber = accountNumber;
        requestBean.AddExcludedAccount.user = 'SALESFORCE';
        
        ROTAddExcludedAccount_Resp_IB_v1 responseBean = ROTAddExcludedAccount_IH_v1.AddExcludedAccount(requestBean);
        System.debug('Service Response  ---->' + JSON.serialize(responseBean));
        List<RestrictionGroupAccount__c> restrictionGroupTemp = new List<RestrictionGroupAccount__c>();
        if(responseBean != null){
            if(responseBean.AddExcludedAccountResponse.AddExcludedAccountResult.HasErrors == 'false'){
            for(integer key = 0 ; key < responseBean.AddExcludedAccountResponse.AddExcludedAccountResult.Information.ServiceInformationResult.size(); key++){
                	RestrictionGroupAccount__c excludedAcccount = new RestrictionGroupAccount__c();
                    excludedAcccount.Description__c = accountDescription;
                    excludedAcccount.EffectiveStartDate__c = Date.parse(accountEffectiveStartDate.replace('-','/'));
                    excludedAcccount.EffectiveEndDate__c = isInfinity.toLowerCase() == 'true' ? Date.valueOf('4000-12-31') : Date.parse(accountEffectiveEndDate.replace('-','/'));
                	excludedAcccount.OriginalEffectiveStartDate__c =  Date.parse(accountEffectiveStartDate.replace('-','/'));
                    excludedAcccount.AccountNumber__c = responseBean.AddExcludedAccountResponse.AddExcludedAccountResult.AccountNumber;
                    excludedAcccount.RestrictionGroupId__c = groupRestrictionId;//'a469E000000BBlJQAW';
                    excludedAcccount.ParentSchemeNodeID__c = responseBean.AddExcludedAccountResponse.AddExcludedAccountResult.Result.ParentSchemeNodeID;
                    excludedAcccount.SchemeNodeID__c = responseBean.AddExcludedAccountResponse.AddExcludedAccountResult.Result.SchemeNodeID;
                    excludedAcccount.ObjectID__c = responseBean.AddExcludedAccountResponse.AddExcludedAccountResult.Result.ObjectID;
                	excludedAcccount.GroupRestrictionClusterID__c = responseBean.AddExcludedAccountResponse.AddExcludedAccountResult.GroupRestrictionClusterID;
                	excludedAcccount.GroupRestrictionObjectID__c = responseBean.AddExcludedAccountResponse.AddExcludedAccountResult.GroupRestrictionObjectID;
                	excludedAcccount.IsEffectiveEndDateInfinity__c = isInfinity;
                	excludedAcccount.Excluded_Account__c = true;
                	excludedAcccount.Status__c = 'Added';
                    restrictionGroupTemp.add(excludedAcccount);
                    return JSON.serialize(responseBean);
                }
                if(restrictionGroupTemp.size() > 0){
                    insert restrictionGroupTemp;
                }
            }
                else{
                    return JSON.serialize(responseBean);
                }
            
        }
        return  null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param groupRestrictionName 
    * @param accounts 
    * @param startDate 
    * @param endDate 
    * @param isInfinite 
    * @return String 
    **/
    @AuraEnabled
    public static String createExcludedAccountNodes(String groupRestrictionId ,String groupRestrictionName, String accounts, String startDate, String endDate, String isInfinite){
        Integer count = 0;
        List<Object> excludedAccounts = (List<Object>)Json.deserializeUntyped(accounts);
        Integer accountCount = excludedAccounts.size();
        ROTAddExcludedAccounts_Req_IB_v1 requestBean = new ROTAddExcludedAccounts_Req_IB_v1();
        requestBean.AddExcludedAccounts = new ROTAddExcludedAccounts_Req_IB_v1.AddExcludedAccounts();
        requestBean.AddExcludedAccounts.excludedAccounts = new ROTAddExcludedAccounts_Req_IB_v1.ExcludedAccounts();        
        requestBean.AddExcludedAccounts.excludedAccounts.AddExcludedAccountModel  = new List<ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel>();        
        List<ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel> excludedAccountModelList = new List<ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel>();
        requestBean.AddExcludedAccounts.user = 'SALESFORCE';
        for(Object excludedAccount : excludedAccounts){
            system.debug('excludedAccount' + excludedAccount);
            Map<String,Object> excludedAccountMap = (Map<string,Object>)excludedAccount;
            ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel excludedAccountModel= new ROTAddExcludedAccounts_Req_IB_v1.Cls_AddExcludedAccountModel();
            
            excludedAccountModel.Description = '';
            excludedAccountModel.IsEffectiveEndDateInfinity = isInfinite;
            excludedAccountModel.GroupRestrictionClusterID = 'ABS';
            excludedAccountModel.EffectiveStartDate = startDate;//startDate.replace('/', '-');
            excludedAccountModel.GroupRestrictionObjectID = groupRestrictionName;//'CQGR0002-JUAT';
            excludedAccountModel.EffectiveEndDate = isInfinite.toLowerCase() == 'true' ? '9999-12-31' : endDate;// endDate.replace('/', '-');
            excludedAccountModel.AccountNumber = (String)excludedAccountMap.get('accountNumber');
            
            excludedAccountModelList.add(excludedAccountModel);  
        }		
        requestBean.AddExcludedAccounts.excludedAccounts.AddExcludedAccountModel  = excludedAccountModelList;
        ROTAddExcludedAccounts_Resp_IB_v1 responseBean = ROTAddExcludedAccounts_IH_v1.addExcludedAccounts(requestBean);
        System.debug('Service Response  ---->' + JSON.serialize(responseBean));
        List<RestrictionGroupAccount__c> restrictionGrpExcludedAccounts = new List<RestrictionGroupAccount__c>();
        if(responseBean != null){
            for(integer key = 0 ; key < responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse.size(); key++){
                if(responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].HasErrors == 'false'){
                    count++;
                    String isInfinity = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.IsEffectiveEndDateInfinity;
                    RestrictionGroupAccount__c excludedAcccount = new RestrictionGroupAccount__c();
                    excludedAcccount.Description__c = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.Description;
                    excludedAcccount.EffectiveStartDate__c = Date.valueOf(responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.EffectiveStartDate);
                    excludedAcccount.EffectiveEndDate__c = isInfinity.toLowerCase() == 'true' ? Date.valueOf('4000-12-31'): Date.valueOf(responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.EffectiveEndDate);
                    excludedAcccount.AccountNumber__c = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].accountNumber;
                    excludedAcccount.RestrictionGroupId__c = groupRestrictionId;
                    excludedAcccount.SchemeNodeID__c = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.SchemeNodeID;
                    excludedAcccount.IsEffectiveEndDateInfinity__c = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.IsEffectiveEndDateInfinity;
                    excludedAcccount.GroupRestrictionClusterID__c = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].GroupRestrictionClusterID;
                    excludedAcccount.GroupRestrictionObjectID__c = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].GroupRestrictionObjectID;
                    excludedAcccount.OriginalEffectiveStartDate__c = Date.valueOf(responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.EffectiveStartDate);
                    excludedAcccount.ParentSchemeNodeID__c = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.ParentSchemeNodeID;
                    excludedAcccount.SchemeNodeID__c = responseBean.AddExcludedAccountsResponse.AddExcludedAccountsResult.ExcludedAccountActionDataResponse[key].Result.SchemeNodeID;
                   	excludedAcccount.Excluded_Account__c = true;
                    excludedAcccount.Status__c = 'Added';
                    restrictionGrpExcludedAccounts.add(excludedAcccount);
                }
            }
            
            if(restrictionGrpExcludedAccounts.size() > 0){
                insert restrictionGrpExcludedAccounts;
            }
        }
        
        if(count == accountCount){
            return JSON.serialize('All Accounts Inserted Successfully');
        }else{
            return JSON.serialize('Out of '+ accountCount + ' Accounts ' + count + ' were created');
        }
        
        //return  null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param groupRestrictionName 
    * @param ClusterId 
    * @param excludedAccountId 
    * @param accountNumber 
    * @param accountDescription 
    * @param accountEffectiveStartDate 
    * @param accountEffectiveEndDate 
    * @param isInfinity 
    * @param originalEffectiveStartDate 
    * @return String 
    **/
    @AuraEnabled
    public static String updateExcludedAccountNode(String groupRestrictionId ,String groupRestrictionName, String ClusterId, String excludedAccountId, String accountNumber, String accountDescription, String accountEffectiveStartDate, String accountEffectiveEndDate, String isInfinity, String originalEffectiveStartDate){
        ROTUpdateExcludedAccount_Req_IB_V1 requestBean = new ROTUpdateExcludedAccount_Req_IB_V1();
        requestBean.UpdateExcludedAccount = new ROTUpdateExcludedAccount_Req_IB_V1.UpdateExcludedAccount();
        requestBean.UpdateExcludedAccount.excludedAccount = new ROTUpdateExcludedAccount_Req_IB_V1.excludedAccount();
        requestBean.UpdateExcludedAccount.excludedAccount.AccountNumber = accountNumber;
        requestBean.UpdateExcludedAccount.excludedAccount.Description = accountDescription;
        requestBean.UpdateExcludedAccount.excludedAccount.EffectiveEndDate = isInfinity.toLowerCase() == 'true' ? '9999-12-31': accountEffectiveEndDate;
        requestBean.UpdateExcludedAccount.excludedAccount.EffectiveStartDate = accountEffectiveStartDate;
        requestBean.UpdateExcludedAccount.excludedAccount.GroupRestrictionClusterID = 'ABS';
        requestBean.UpdateExcludedAccount.excludedAccount.GroupRestrictionObjectID = groupRestrictionName;
        requestBean.UpdateExcludedAccount.excludedAccount.IsEffectiveEndDateInfinity = isInfinity;
        requestBean.UpdateExcludedAccount.excludedAccount.OriginalEffectiveStartDate = originalEffectiveStartDate;
        requestBean.UpdateExcludedAccount.user = 'SALESFORCE';
        
        ROTUpdateExcludedAccount_Resp_IB_V1 responseBean = ROTUpdateExcludedAccount_IH_V1.updateExcludedAccount(requestBean);
        System.debug('Service Response  ---->' + JSON.serialize(responseBean));
        List<RestrictionGroupAccount__c> restrictionAccountTemp = new List<RestrictionGroupAccount__c>();
        if(responseBean != null){
            if(responseBean.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.HasErrors == 'false'){
                for(integer key = 0 ; key < responseBean.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.Information.ServiceInformationResult.size(); key++){
                    RestrictionGroupAccount__c excludedAcccount = new RestrictionGroupAccount__c(Id = excludedAccountId);
                    excludedAcccount.Description__c =  accountDescription;
                    excludedAcccount.EffectiveStartDate__c = Date.parse(accountEffectiveStartDate.replace('-','/'));
                    excludedAcccount.EffectiveEndDate__c = isInfinity.toLowerCase() == 'true' ? Date.valueOf('4000-12-31') : Date.parse(accountEffectiveEndDate.replace('-','/'));
                    excludedAcccount.OriginalEffectiveStartDate__c = Date.parse(accountEffectiveStartDate.replace('-','/'));
                    excludedAcccount.AccountNumber__c = accountNumber;
                    excludedAcccount.Status__c = 'Updated';                    
                    excludedAcccount.IsEffectiveEndDateInfinity__c = isInfinity; 
                    excludedAcccount.ParentSchemeNodeID__c = responseBean.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.Result.ParentSchemeNodeID;
                    excludedAcccount.SchemeNodeID__c = responseBean.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.Result.SchemeNodeID;
                    restrictionAccountTemp.add(excludedAcccount);
                   
                    return JSON.serialize(responseBean);
                }
                if(restrictionAccountTemp.size() > 0){
                    update restrictionAccountTemp;
                }
            }
            else{
                return JSON.serialize(responseBean);
            }
            
        }
        return  null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param groupRestrictionName 
    * @param ClusterId 
    * @param excludedAccountId 
    * @param accountNumber 
    * @param accountEffectiveStartDate 
    * @return String 
    **/
    @AuraEnabled
    public static String deleteExcludedAccountNode(String groupRestrictionId ,String groupRestrictionName, String ClusterId, String excludedAccountId, String accountNumber,  String accountEffectiveStartDate){
        ROTDeleteExcludedAccount_Req_IB_v1 requestBean = new ROTDeleteExcludedAccount_Req_IB_v1(); 
        requestBean.DeleteExcludedAccount = new ROTDeleteExcludedAccount_Req_IB_v1.DeleteExcludedAccount();
        requestBean.DeleteExcludedAccount.excludedAccount = new ROTDeleteExcludedAccount_Req_IB_v1.excludedAccount();
        requestBean.DeleteExcludedAccount.excludedAccount.AccountNumber =accountNumber; 
        requestBean.DeleteExcludedAccount.excludedAccount.GroupRestrictionObjectID = groupRestrictionName; 
        requestBean.DeleteExcludedAccount.excludedAccount.GroupRestrictionClusterID = 'ABS';
        requestBean.DeleteExcludedAccount.excludedAccount.EffectiveStartDate = accountEffectiveStartDate;
        requestBean.DeleteExcludedAccount.user = 'SALESFORCE';
        
        ROTDeleteExcludedAccount_Resp_IB_v1 responseBean = ROTDeleteExcludedAccount_IH_v1.ExcludeAccount(requestBean);
        System.debug('Service Response  ---->' + JSON.serialize(responseBean));
        
        if(responseBean != null){
            if(responseBean.DeleteExcludedAccountResponse.DeleteExcludedAccountResult.HasErrors == 'false'){
                RestrictionGroupAccount__c excludedAcccount = new RestrictionGroupAccount__c(Id = excludedAccountId);
                excludedAcccount.Status__c = 'Deleted';
                update excludedAcccount;
                return JSON.serialize(responseBean);
            }
            else{
                return JSON.serialize(responseBean);
            }
            
        }
        return  null;
    }
    
    //ADD CUSTOMER START HERE
            
/* 
* Method to create customer node
*/  
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param customerKey 
    * @param description 
    * @param effectiveStartDate 
    * @param effectiveEndDate 
    * @param groupRestrictionObjectID 
    * @param isInfinity 
    * @return String 
    **/
    @AuraEnabled
    public static String createCustomerNode(String groupRestrictionId , String customerKey , String description , String effectiveStartDate, String effectiveEndDate, String groupRestrictionObjectID ,String isInfinity){
        
        ROTAddCustomer_Req_IB_v1 requestBean = new ROTAddCustomer_Req_IB_v1();
        requestBean.AddCustomer = new ROTAddCustomer_Req_IB_v1.AddCustomer();
        requestBean.AddCustomer.customer = new ROTAddCustomer_Req_IB_v1.customer();
        requestBean.AddCustomer.customer.Description = description;
        
         String effectDate = effectiveEndDate;               
        effectDate = effectDate.replace('4000', '9999');
        requestBean.AddCustomer.customer.EffectiveEndDate = effectDate;
        //requestBean.AddCustomer.customer.EffectiveEndDate = effectiveEndDate;
        
        requestBean.AddCustomer.customer.EffectiveStartDate = effectiveStartDate;
        requestBean.AddCustomer.customer.GroupRestrictionClusterID = 'ABS';
        requestBean.AddCustomer.customer.GroupRestrictionObjectID = groupRestrictionObjectID;
        requestBean.AddCustomer.customer.IsEffectiveEndDateInfinity = isInfinity;
        requestBean.AddCustomer.customer.CustomerKey = customerKey;
        requestBean.AddCustomer.user = 'SALESFORCE';
        ROTAddCustomer_Resp_IB_v1 responseBean = ROTAddCustomer_IH_v1.AddCustomer(requestBean);
        System.debug('Service Response ---->' + JSON.serialize(responseBean));
        
        if(responseBean != null){
            System.debug('Response');
            if(responseBean.AddCustomerResponse != null){
                if(responseBean.AddCustomerResponse.AddCustomerResult != null){
                    if(responseBean.AddCustomerResponse.AddCustomerResult.HasErrors == 'false'){
                        RestrictionGroupCustomer__c groupRestrictionCustomer = new RestrictionGroupCustomer__c();
                        groupRestrictionCustomer.Description__c = description;
                        groupRestrictionCustomer.EffectiveStartDate__c = Date.parse(effectiveStartDate.replace('-','/'));
                        groupRestrictionCustomer.EffectiveEndDate__c = Date.parse(effectiveEndDate.replace('-','/'));
                        groupRestrictionCustomer.OriginalEffectiveStartDate__c =  Date.parse(effectiveStartDate.replace('-','/'));
                        groupRestrictionCustomer.CustomerKey__c = responseBean.AddCustomerResponse.AddCustomerResult.CustomerKey;//customerKey;
                        groupRestrictionCustomer.RestrictionGroupId__c = groupRestrictionId;
                        groupRestrictionCustomer.ParentSchemeNodeID__c = responseBean.AddCustomerResponse.AddCustomerResult.Result.ParentSchemeNodeID;
                        groupRestrictionCustomer.SchemeNodeID__c = responseBean.AddCustomerResponse.AddCustomerResult.Result.SchemeNodeID;
                        groupRestrictionCustomer.ObjectID__c = responseBean.AddCustomerResponse.AddCustomerResult.Result.ObjectID;
                        groupRestrictionCustomer.GroupRestrictionClusterID__c = responseBean.AddCustomerResponse.AddCustomerResult.GroupRestrictionClusterID;
                        groupRestrictionCustomer.GroupRestrictionObjectID__c = responseBean.AddCustomerResponse.AddCustomerResult.GroupRestrictionObjectID;
                        groupRestrictionCustomer.IsEffectiveEndDateInfinity__c = isInfinity;
                        groupRestrictionCustomer.Status__c = 'Added';   
                        insert groupRestrictionCustomer;
                        System.debug('Group Account Id ---->' + groupRestrictionCustomer.Id);
                        return JSON.serialize(responseBean);
                    }else{
                        System.debug('Has Error');
                        System.debug('Service Response Muvhuso Has Errors ---->' + JSON.serialize(responseBean));
                        return JSON.serialize(responseBean);        
                    } 
                }
            }
        }
        
        return null;
    }
    
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param customerAccountId 
    * @param customerKey 
    * @param description 
    * @param startDate 
    * @param endDate 
    * @param groupRestrictionObjectId 
    * @param originalEffectiveStartDate 
    * @param isInfinity 
    * @return String 
    **/
    @AuraEnabled
    public static String updateCustomerNode(string customerAccountId ,  String customerKey, String description , string startDate , String endDate , String groupRestrictionObjectId ,String originalEffectiveStartDate,String isInfinity){
        
        ROTUpdateCustomer_Req_IB_v1 requestBean = new ROTUpdateCustomer_Req_IB_v1(); 
        requestBean.UpdateCustomer = new ROTUpdateCustomer_Req_IB_v1.UpdateCustomer();
        requestBean.UpdateCustomer.Customer = new ROTUpdateCustomer_Req_IB_v1.Customer();
        requestBean.UpdateCustomer.Customer.Description = description;
        
        String effectDate = endDate;               
        effectDate = effectDate.replace('4000', '9999');
        requestBean.UpdateCustomer.Customer.EffectiveEndDate = effectDate;
        //requestBean.UpdateCustomer.Customer.EffectiveEndDate = endDate;
        
        requestBean.UpdateCustomer.Customer.EffectiveStartDate = startDate;
        requestBean.UpdateCustomer.Customer.GroupRestrictionClusterID = 'ABS';
        requestBean.UpdateCustomer.Customer.GroupRestrictionObjectID = groupRestrictionObjectId;
        requestBean.UpdateCustomer.Customer.IsEffectiveEndDateInfinity = isInfinity;
        requestBean.UpdateCustomer.Customer.CustomerKey = customerKey;
        requestBean.UpdateCustomer.Customer.OriginalEffectiveStartDate = originalEffectiveStartDate;
        requestBean.UpdateCustomer.user = 'SALESFORCE';
        
        ROTUpdateCustomer_Resp_IB_v1 responseBean = ROTUpdateCustomer_IH_v1.updateCustomer(requestBean);
        if(responseBean != null){
            if(responseBean.UpdateCustomerResponse.UpdateCustomerResult != null){
                if(responseBean.UpdateCustomerResponse.UpdateCustomerResult.HasErrors == 'false'){
                    RestrictionGroupCustomer__c groupRestrictionCustomer = new RestrictionGroupCustomer__c(Id = customerAccountId);           
                    groupRestrictionCustomer.CustomerKey__c = customerKey;
                    groupRestrictionCustomer.Description__c = description;
                    groupRestrictionCustomer.EffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                    groupRestrictionCustomer.EffectiveEndDate__c = Date.parse(endDate.replace('-', '/'));
                    groupRestrictionCustomer.OriginalEffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                    groupRestrictionCustomer.Status__c = 'Updated';
                    update groupRestrictionCustomer;
                    return JSON.serialize(responseBean);
                    
                }else{
                    return JSON.serialize(responseBean);
                }
            }
        }
        return null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param groupRestrictionObjectID 
    * @param customerId 
    * @param customerKey 
    * @param customerEffectiveStartDate 
    * @return String 
    **/
      @AuraEnabled
    public static String deleteCustomer(String groupRestrictionId ,String groupRestrictionObjectID,String customerId, String customerKey,  String customerEffectiveStartDate){
        ROTDeleteCustomer_Req_IB_v1 requestBean = new ROTDeleteCustomer_Req_IB_v1(); 
        requestBean.DeleteCustomer= new ROTDeleteCustomer_Req_IB_v1.DeleteCustomer();
        requestBean.DeleteCustomer.customer = new ROTDeleteCustomer_Req_IB_v1.customer();
        requestBean.DeleteCustomer.customer.customerKey =customerKey; 
        requestBean.DeleteCustomer.customer.GroupRestrictionObjectID = groupRestrictionObjectID; 
        requestBean.DeleteCustomer.customer.GroupRestrictionClusterID = 'ABS';
        requestBean.DeleteCustomer.customer.EffectiveStartDate = customerEffectiveStartDate;
        requestBean.DeleteCustomer.user = 'SALESFORCE';
        
        ROTDeleteCustomer_Resp_IB_v1 responseBean = ROTDeleteCustomer_IH_v1.DeleteCustomer(requestBean);
        System.debug('Service Response  ---->' + JSON.serialize(responseBean));
        
        if(responseBean != null){
          if(responseBean.DeleteCustomerResponse != null){
            if(responseBean.DeleteCustomerResponse.DeleteCustomerResult.HasErrors == 'false'){
                RestrictionGroupCustomer__c customer = new RestrictionGroupCustomer__c(Id = customerId);
                customer.Status__c = 'Deleted';
                update customer;
                return JSON.serialize(responseBean);
            }
            else{
                return JSON.serialize(responseBean);
            }
          }
        }
        return  null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param restrictionGroupId 
    * @return List<RestrictionGroupCustomer__c> 
    **/
    @AuraEnabled
    public static List<RestrictionGroupCustomer__c> getGroupCustomer(String restrictionGroupId)
    {
        List<RestrictionGroupCustomer__c> restrictionGroupCustomerList = new List<RestrictionGroupCustomer__c>();
        
        restrictionGroupCustomerList = [SELECT Id,CustomerKey__c ,SchemeNodeID__c,RestrictionGroupId__c,OriginalEffectiveStartDate__c,Status__c,Description__c,EffectiveStartDate__c,EffectiveEndDate__c FROM RestrictionGroupCustomer__c where RestrictionGroupId__c =: restrictionGroupId and Status__c != 'Deleted'];
        system.debug('restrictionGroupCustomerList ' + restrictionGroupCustomerList);
        return restrictionGroupCustomerList; 
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param clientAccountId 
    * @return String 
    **/
    @AuraEnabled
    public static String getClientCIF(String clientAccountId){
        String cifKey; 
        if(clientAccountId != null){
            Set<Id> accIdSet = new Set<Id>();
            accIdSet.add(clientAccountId);
            List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
            cifKey = accountList[0].CIF__c;   
        } 
        
        system.debug('Id: ' + cifKey); 
        return cifKey;
    }
    
    
     /**
     * @description Method to fetch the data for the ROTAddTransactionType component
     * Author: Bhanumurty
     * Created by: 2021/1/21
	 */
    
    /**
    * @description Method to fetch the data for the ROTAddTransactionType component
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @return String 
    */
    @AuraEnabled
    public static String getTransactionType(){
       
        DateTime myDateTime = DateTime.newInstance(date.today().year(), date.today().month(), date.today().day(), 0, 0, 0);
		String formatted = myDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
		system.debug(formatted);
       
        ROTGetGovernanceModel_Req_IB_v1 requestBean = new ROTGetGovernanceModel_Req_IB_v1();
        
        requestBean.GetGovernanceModel = new ROTGetGovernanceModel_Req_IB_v1.GetGovernanceModel();
        requestBean.GetGovernanceModel.date1 = formatted;
        
        ROTGetGovernanceModel_Resp_IB_v1 responseBean = ROTGetGovernanceModel_IH_v1.getGovernanceModel(requestBean);
        system.debug('ResponseBean::::>>>>>>' +responseBean);
        
        if(responseBean != NULL){
            return JSON.serialize(responseBean);
        }
        return null;
    }

    /**
     * @description Method to use the ADDTRANSACTIONTYPES service to pass the params and 
     * load the data in Transaction Type sObjects from the component
     * Author: Bhanumurty
     * Created by: 2021/1/27
	*/
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @param groupRestrictionObjectID 
    * @param startdate 
    * @param enddate 
    * @param isinfinity 
    * @param transactionTypeList 
    * @return String 
    **/
    @AuraEnabled
    public static String addTransactionTypesNode(String groupRestrictionId, String groupRestrictionObjectID, String startdate, String enddate, String isinfinity, String transactionTypeList){
        Integer count = 0;
        List<Object> transactionTypeRecords = (List<Object>)Json.deserializeUntyped(transactionTypeList);
        Integer totalCount =transactionTypeRecords.size();
        ROTAddTransactionTypes_Req_IB_v1 requestBean = new ROTAddTransactionTypes_Req_IB_v1();
        requestBean.AddTransactionTypes = new ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypes();
        requestBean.AddTransactionTypes.accounts = new ROTAddTransactionTypes_Req_IB_v1.accounts();
        requestBean.AddTransactionTypes.accounts.AddTransactionTypeModel = new List<ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel>();
        List<ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel>  requests= new List<ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel>();
        for(Object transactionType : transactionTypeRecords){    
            Map<String,Object> transactionMap = (Map<string,Object>)transactionType;
            ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel request= new ROTAddTransactionTypes_Req_IB_v1.AddTransactionTypeModel();
            system.debug('Inside child Request:::::::::::::::::::');
            request.Code = (String)transactionMap.get('ObjectID');
            request.Description = (String)transactionMap.get('Description');
            //request.EffectiveEndDate = enddate;
            request.EffectiveEndDate = isinfinity.toLowerCase() == 'true' ? '9999-12-31': enddate;
            request.EffectiveStartDate = startdate;
            request.GroupRestrictionClusterID = 'ABS';            
            request.GroupRestrictionObjectID = groupRestrictionObjectID;
            request.IsEffectiveEndDateInfinity = true;
            requestBean.AddTransactionTypes.accounts.AddTransactionTypeModel.add(request);
        }
        requestBean.AddTransactionTypes.user = 'SALESFORCE';
        
        ROTAddTransactionTypes_Resp_IB_v1 responseBean = ROTAddTransactionTypes_IH_v1.addTransactionTypes(requestBean);
        List<RestrictionGroupTransactionType__c> trnasactionsList = new List<RestrictionGroupTransactionType__c>();
        system.debug('Add Transaction Type>>>>>>>>>>>>>>>>>' +responseBean);
        
        if(responseBean != null){
            System.debug('Inside Response Bean ---->');
            if(responseBean.AddTransactionTypesResponse != null){
                if(responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse != null){
                    for(Integer i=0; i<responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse.size() ; i++){
                        system.debug('responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse[i].HasErrors '+responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse[i].HasErrors);
                        if(responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse[i].HasErrors == 'false'){
                            count++;
                            RestrictionGroupTransactionType__c transctionTypes = new RestrictionGroupTransactionType__c();
                            transctionTypes.Name = responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse[i].Result.ObjectID;
                            transctionTypes.Description__c = responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse[i].Result.Description; 
                            //transctionTypes.Effective_End_Date__c = Date.parse(enddate.replaceAll('-', '/'));
                            transctionTypes.Effective_End_Date__c = isinfinity.toLowerCase() == 'true' ? Date.valueOf('4000-12-31') : Date.parse(enddate.replaceAll('-', '/'));
                            //system.debug('Date after parsing::::::::' +enddate);
                            transctionTypes.Effective_Start_Date__c = Date.parse(startdate.replaceAll('-', '/'));
                            transctionTypes.IsEffective_End_Date_Infinity__c = true;
                            transctionTypes.Restriction_Group_ID__c = groupRestrictionId;
                            transctionTypes.Status__c = 'Added';
                            transctionTypes.Original_Effective_Start_Date__c = Date.parse(startdate.replaceAll('-', '/'));
                            transctionTypes.SchemeNodeID__c = responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse[i].Result.SchemeNodeID; 
                            transctionTypes.ParentSchemeNodeID__c = responseBean.AddTransactionTypesResponse.AddTransactionTypesResult.TransactionTypeActionDataResponse[i].Result.ParentSchemeNodeID; 
                            trnasactionsList.add(transctionTypes);
                            
                            system.debug('Sucessfully Inserted Transaction Type::::::::::>>>' +transctionTypes.Id);
                            
                            //return JSON.serialize(responseBean);
                        }else{
                            System.debug('Has Error');
                            //System.debug('Service Response Has Errors ---->' + JSON.serialize(responseBean));
                            //return JSON.serialize(responseBean);        
                        } 
                    }
                }
            }
        }
        if(trnasactionsList.size() > 0){
            insert trnasactionsList;
        }
        if(count == totalCount){
            return JSON.serialize('All Transaction Types Inserted Successfully');
        }else{
            return JSON.serialize('Out of '+ totalCount + ' Transaciton Types ' + count + ' were Inserted');
        }
    }
   
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param groupRestrictionId 
    * @return List<RestrictionGroupTransactionType__c> 
    **/

     @AuraEnabled
    public static List<RestrictionGroupTransactionType__c> fetchTransactionTypesMain(String groupRestrictionId){
        
        system.debug('Param Restriction ID$$$$$$$$$$$$$$$$$$$$$$' +groupRestrictionId);
        
        //RestrictionGroupTransactionType__c rt = new RestrictionGroupTransactionType__c();
                
        List<RestrictionGroupTransactionType__c> transTypeList = new List<RestrictionGroupTransactionType__c>();
        transTypeList = [select Id, Name, Description__c, Effective_Start_Date__c, Effective_End_Date__c, Status__c,
                         Original_Effective_Start_Date__c, SchemeNodeID__c, ParentSchemeNodeID__c from RestrictionGroupTransactionType__c
                        where Restriction_Group_ID__c =: groupRestrictionId and (NOT Status__c like 'Deleted')];
						
        system.debug('Transaction Type records to return to the component:::::::::' +transTypeList);
       
        return transTypeList;
    }
     
   /**
    * @description 
    */
     public class RestrictionDetails{
        @AuraEnabled public List<RestrictionGroupCustomer__c> customers;
        @AuraEnabled public List<RestrictionGroupAccount__c> excludedAccounts;
        @AuraEnabled public List<RestrictionGroupAccount__c> accounts; 
        @AuraEnabled public List<RestrictionGroupTransactionType__c> transactions;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param restrictionGrpId 
    * @return RestrictionDetails 
    **/
    @AuraEnabled
    public static RestrictionDetails restrictionGrpRelatedInfo(String restrictionGrpId){
        system.debug('restrictionGrpId '+restrictionGrpId);
        RestrictionDetails restrictionDetailsWrap = new RestrictionDetails();
        restrictionDetailsWrap.customers = getCustomers(restrictionGrpId);
        restrictionDetailsWrap.excludedAccounts = getExcludedAccounts(restrictionGrpId);
        restrictionDetailsWrap.accounts = getAccounts(restrictionGrpId);
        restrictionDetailsWrap.transactions = getTransactions(restrictionGrpId);
        system.debug('restrictionDetailsWrap '+restrictionDetailsWrap);
        return restrictionDetailsWrap;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param restrictionGrpId 
    * @return List<RestrictionGroupCustomer__c> 
    **/
    @AuraEnabled
    public static List<RestrictionGroupCustomer__c> getCustomers(String restrictionGrpId){
        List<RestrictionGroupCustomer__c> restrictionGrpcustomers = new List<RestrictionGroupCustomer__c>();
        restrictionGrpcustomers =  [SELECT Id, Name,SchemeNodeID__c, Description__c, CustomerKey__c, EffectiveStartDate__c, EffectiveEndDate__c, Status__c, RestrictionGroupId__c 
                      FROM RestrictionGroupCustomer__c 
                      WHERE RestrictionGroupId__c =: restrictionGrpId and Status__c != 'Deleted'];
        return restrictionGrpcustomers;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param restrictionGrpId 
    * @return List<RestrictionGroupAccount__c> 
    **/
    @AuraEnabled
    public static List<RestrictionGroupAccount__c> getExcludedAccounts(String restrictionGrpId)
    {
        List<RestrictionGroupAccount__c> restrictionGrpExcludedAccounts = new List<RestrictionGroupAccount__c>();
        restrictionGrpExcludedAccounts = [SELECT Id, Name, SchemeNodeID__c,AccountNumber__c, Description__c, EffectiveEndDate__c, OriginalEffectiveStartDate__c, EffectiveStartDate__c	, GroupRestrictionClusterID__c	, GroupRestrictionObjectID__c, IsEffectiveEndDateInfinity__c, Status__c, RestrictionGroupId__c, Excluded_Account__c   
                                          FROM RestrictionGroupAccount__c 
                                          WHERE RestrictionGroupId__c =: restrictionGrpId and Excluded_Account__c = true and Status__c !='Deleted'];
        return restrictionGrpExcludedAccounts;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param restrictionGrpId 
    * @return List<RestrictionGroupAccount__c> 
    **/
    @AuraEnabled
    public static List<RestrictionGroupAccount__c> getAccounts(String restrictionGrpId)
    {
        List<RestrictionGroupAccount__c> restrictionGrpAccounts = new List<RestrictionGroupAccount__c>();
        restrictionGrpAccounts = [SELECT Id, Name, AccountNumber__c,SchemeNodeID__c, Description__c, EffectiveEndDate__c, OriginalEffectiveStartDate__c, EffectiveStartDate__c	, GroupRestrictionClusterID__c	, GroupRestrictionObjectID__c, IsEffectiveEndDateInfinity__c,Status__c, RestrictionGroupId__c , Excluded_Account__c  
                                          FROM RestrictionGroupAccount__c 
                                          WHERE RestrictionGroupId__c =: restrictionGrpId and Excluded_Account__c = false and Status__c !='Deleted'];
        return restrictionGrpAccounts;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param restrictionGrpId 
    * @return List<RestrictionGroupTransactionType__c> 
    **/
    @AuraEnabled
    public static List<RestrictionGroupTransactionType__c> getTransactions(String restrictionGrpId)
    {
        List<RestrictionGroupTransactionType__c> restrictionGrpTransactions = new List<RestrictionGroupTransactionType__c>();
        restrictionGrpTransactions = [SELECT Id, Name,Description__c,SchemeNodeID__c, Effective_End_Date__c, IsEffective_End_Date_Infinity__c, Effective_Start_Date__c	, Restriction_Group_ID__c	, Status__c 
                                          FROM RestrictionGroupTransactionType__c 
                                          WHERE Restriction_Group_ID__c =: restrictionGrpId and Status__c !='Deleted'];
        return restrictionGrpTransactions;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param startDate 
    * @param endDate 
    * @param isInfinity 
    * @param objectId 
    * @param records 
    * @return String 
    **/
    @AuraEnabled
    public Static String bulkUpdateDates(String startDate, String endDate, String isInfinity, String objectId, String records){
        List<Object> selectedRecords = (List<Object>)JSON.deserializeUntyped(records);
        Map<String, String> recordsIdsMap = new Map<String, String>(); 
        Integer recordsCount = selectedRecords.size();
        Integer count = 0;
        List<RestrictionGroupAccount__c> accounts = new List<RestrictionGroupAccount__c>();
        List<RestrictionGroupCustomer__c> customers = new List<RestrictionGroupCustomer__c>();
        List<RestrictionGroupTransactionType__c> transactionTypes = new List<RestrictionGroupTransactionType__c>();
        ROTDateAdjustSchemeNodes_Req_IB_v1 requestBean = new ROTDateAdjustSchemeNodes_Req_IB_v1(); 
        requestBean.DateAdjustSchemeNodes= new ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustSchemeNodes();
        requestBean.DateAdjustSchemeNodes.nodes = new ROTDateAdjustSchemeNodes_Req_IB_v1.nodes();
        requestBean.DateAdjustSchemeNodes.user = 'SALESFORCE';
        List<ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustmentNodeModel> requests = new List<ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustmentNodeModel>();
        for(Object record : selectedRecords){
            system.debug('record' + record);
            Map<String,Object> recordMap = (Map<string,Object>)record;
            ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustmentNodeModel request  = new ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustmentNodeModel();
            request.NewEffectiveStartDate  = startDate;
            request.GroupRestrictionObjectID  = objectId;
            request.IsEffectiveEndDateInfinity  = isInfinity;
            request.GroupRestrictionClusterID  = 'ABS';
            request.NewEffectiveEndDate  = endDate;
            Id recordId = Id.valueOf((String)recordMap.get('Id'));
            if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupAccount__c'){
                Boolean isExcludedAccount = (Boolean)recordMap.get('Excluded_Account__c');
                if(isExcludedAccount == true){
                    request.EntityType  = 'ExcludedAccount';
                }
                else{
                   request.EntityType  = 'Account' ;
                }
                request.ObjectID  = (String)recordMap.get('AccountNumber__c');
                request.EffectiveStartDate  = (String)recordMap.get('EffectiveStartDate__c');
                recordsIdsMap.put((String)recordMap.get('AccountNumber__c')+startDate+endDate, recordId);
            }
            else if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupCustomer__c'){
                request.EntityType  = 'Customer' ;
                request.EffectiveStartDate  = (String)recordMap.get('EffectiveStartDate__c');
                recordsIdsMap.put((String)recordMap.get('Name')+startDate+endDate, recordId);
                request.ObjectID  = (String)recordMap.get('Name');
            }
            else if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupTransactionType__c'){
                request.EntityType  = 'TransactionType' ;
                request.EffectiveStartDate  = (String)recordMap.get('Effective_Start_Date__c');
                request.ObjectID  = (String)recordMap.get('Name');
                recordsIdsMap.put((String)recordMap.get('Name')+startDate+endDate, recordId);
            }
            requests.add(request);
        }
        requestBean.DateAdjustSchemeNodes.nodes.DateAdjustmentNodeModel = requests;
        ROTDateAdjustSchemeNodes_Resp_IB_v1 responseBean = ROTDateAdjustSchemeNodes_IH_v1.AdjustSchemeNodes(requestBean);
        if(responseBean != null){
            if(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.HasErrors == 'false'){
                if(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records != null ){
                    for(Integer i=0; i<responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult.size(); i++ ){
                        if(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].Success == 'true'){
                            count++;
                            if(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].EntityType == 'Account'){
                                RestrictionGroupAccount__c account = new RestrictionGroupAccount__c();
                                account.Id = recordsIdsMap.get(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].ObjectID+startDate+endDate);
                                account.EffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                                account.EffectiveEndDate__c = Date.parse(endDate.replace('-', '/'));
                                account.Status__c = 'Updated';
                                account.OriginalEffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                                account.SchemeNodeID__c = responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].SchemeNodeID;
                                accounts.add(account);
                            }
                            else if(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].EntityType == 'ExcludedAccount'){
                                RestrictionGroupAccount__c account = new RestrictionGroupAccount__c();
                                account.Id = recordsIdsMap.get(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].ObjectID+startDate+endDate);
                                account.EffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                                account.EffectiveEndDate__c = Date.parse(endDate.replace('-', '/'));
                                account.OriginalEffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                                account.Status__c = 'Updated';
                                account.SchemeNodeID__c = responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].SchemeNodeID;
                                accounts.add(account);
                            }
                            else if(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].EntityType == 'Customer'){
                                RestrictionGroupCustomer__c customer = new RestrictionGroupCustomer__c();
                                customer.Id = recordsIdsMap.get(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].ObjectID+startDate+endDate);
                            	customer.EffectiveEndDate__c = Date.parse(endDate.replace('-', '/'));
                                customer.EffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                                customer.Status__c = 'Updated';
                                customer.OriginalEffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                                customer.SchemeNodeID__c = responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].SchemeNodeID;
                                
                                customers.add(customer);
                            }
                           		else if(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].EntityType == 'TransactionType'){
                                RestrictionGroupTransactionType__c transactionType = new RestrictionGroupTransactionType__c();
                                transactionType.Id = recordsIdsMap.get(responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].ObjectID+startDate+endDate);
                            	transactionType.Effective_End_Date__c = Date.parse(endDate.replace('-', '/'));
                                transactionType.Effective_Start_Date__c = Date.parse(startDate.replace('-', '/'));
                                transactionType.Status__c = 'Updated';
                                transactionType.SchemeNodeID__c = responseBean.DateAdjustSchemeNodesResponse.DateAdjustSchemeNodesResult.Records.SchemeNodeDateAdjustmentResult[i].SchemeNodeID;
                                transactionType.Original_Effective_Start_Date__c = Date.parse(startDate.replace('-', '/'));
                                transactionTypes.add(transactionType);
                            }
                        }
                    }
                }
                
                if(customers.size() > 0){
                    update customers;
                }
                if(accounts.size() > 0){
                    update accounts;
                }
                if(transactionTypes.size() > 0){
                    update transactionTypes;
                }
                
                if(count == recordsCount){
                    return JSON.serialize('All Records Updated Successfully');
                }else{
                    return JSON.serialize('Out of '+ recordsCount + ' Records ' + count + ' were Updated Successfully');
                }
            }
            else{
                return null;
            }
            
        }
        system.debug('requestBean'+requestBean);
        system.debug('recordsIdsMap '+recordsIdsMap);
        return null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param objectId 
    * @param records 
    * @return String 
    **/
    @AuraEnabled
    public Static String bulkDeleteNodes(String objectId, String records){
        List<Object> selectedRecords = (List<Object>)JSON.deserializeUntyped(records);
        Map<String, String> recordsIdsMap = new Map<String, String>(); 
        Integer recordsCount = selectedRecords.size();
        Integer count = 0;
        List<RestrictionGroupAccount__c> accounts = new List<RestrictionGroupAccount__c>();
        List<RestrictionGroupCustomer__c> customers = new List<RestrictionGroupCustomer__c>();
        List<RestrictionGroupTransactionType__c> transactionTypes = new List<RestrictionGroupTransactionType__c>();
        
        ROTDeleteSchemeNodes_Req_IB_v1 requestBean = new ROTDeleteSchemeNodes_Req_IB_v1(); 
        requestBean.DeleteSchemeNodes = new ROTDeleteSchemeNodes_Req_IB_v1.DeleteSchemeNodes();
         
        requestBean.DeleteSchemeNodes.nodes = new ROTDeleteSchemeNodes_Req_IB_v1.nodes();
        requestBean.DeleteSchemeNodes.nodes.DeleteSchemeNodeModel = new List<ROTDeleteSchemeNodes_Req_IB_v1.DeleteSchemeNodeModel>();
        
        for(Object record : selectedRecords){
            system.debug('record' + record);
            Map<String,Object> recordMap = (Map<string,Object>)record;
            ROTDeleteSchemeNodes_Req_IB_v1.DeleteSchemeNodeModel request  = new ROTDeleteSchemeNodes_Req_IB_v1.DeleteSchemeNodeModel();
            request.ObjectID  = 'ABS';
            request.GroupRestrictionObjectID = objectId;
            request.GroupRestrictionClusterID = 'ABS';
             
            Id recordId = Id.valueOf((String)recordMap.get('Id'));
            if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupAccount__c'){
                Boolean isExcludedAccount = (Boolean)recordMap.get('Excluded_Account__c');
                if(isExcludedAccount == true){
                    request.EntityType  = 'ExcludedAccount';
                }
                else{
                   request.EntityType  = 'Account' ;
                }
                request.EffectiveStartDate  = (String)recordMap.get('EffectiveStartDate__c');
                request.ObjectID  = (String)recordMap.get('AccountNumber__c');
                recordsIdsMap.put((String)recordMap.get('AccountNumber__c')+(String)recordMap.get('EffectiveStartDate__c')+'T00:00:00' , recordId);

            }
            else if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupCustomer__c'){
                request.EntityType  = 'Customer' ;
                request.EffectiveStartDate  = (String)recordMap.get('EffectiveStartDate__c');
                request.ObjectID  = (String)recordMap.get('Name');
                recordsIdsMap.put((String)recordMap.get('Name')+(String)recordMap.get('EffectiveStartDate__c')+'T00:00:00' , recordId);
            }
            else if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupTransactionType__c'){
                request.EntityType  = 'TransactionType' ;
                request.ObjectID  = (String)recordMap.get('Name');
                request.EffectiveStartDate  = (String)recordMap.get('Effective_Start_Date__c');
                recordsIdsMap.put((String)recordMap.get('Name')+(String)recordMap.get('EffectiveStartDate__c')+'T00:00:00' , recordId);
            }
            requestBean.DeleteSchemeNodes.nodes.DeleteSchemeNodeModel.add(request);
        }       
        requestBean.DeleteSchemeNodes.user ='SALESFORCE';
        
        ROTDeleteSchemeNodes_Resp_IB_v1 responseBean = ROTDeleteSchemeNodes_IH_v1.DeleteschemeNodes(requestBean);
        if(responseBean != null){
            if(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.HasErrors == 'false'){
                if(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records != null ){
                    
                    for(Integer i=0; i<responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult.size(); i++ ){
                        if(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].Success == 'true'){
                            count++;
                            if(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].EntityType == 'Account' || responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].EntityType == 'ExcludedAccount'){
                                String accountId = recordsIdsMap.get(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].ObjectID+responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].EffectiveStartDate);
                                System.debug('Account Id ---> ' +  accountId);
                                //account.Id =  recordsIdsMap.get(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].SchemeNodeID);
                                RestrictionGroupAccount__c account = new RestrictionGroupAccount__c(Id = accountId);
                                account.Status__c = 'Deleted';
                                accounts.add(account);
                            }
                            else if(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].EntityType == 'Customer'){
                                String customerId = recordsIdsMap.get(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].ObjectID+responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].EffectiveStartDate);
                                 System.debug('Customer Id ---> ' +  customerId);
                                RestrictionGroupCustomer__c customer = new RestrictionGroupCustomer__c(Id=customerId);
                                //customer.Id = recordsIdsMap.get(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].SchemeNodeID);
                                customer.Status__c = 'Deleted';
                                customers.add(customer);
                            }
                           else if(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].EntityType == 'TransactionType'){
                                String transactionTypeId = recordsIdsMap.get(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].ObjectID+responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].EffectiveStartDate);
                                System.debug('transactionTypeId Id ---> ' +  transactionTypeId);
                                RestrictionGroupTransactionType__c transactionType = new RestrictionGroupTransactionType__c(Id=transactionTypeId);
                                //transactionType.Id = recordsIdsMap.get(responseBean.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.Records.SchemeNodeOperationResult[i].SchemeNodeID);
                                transactionType.Status__c = 'Deleted';
                                transactionTypes.add(transactionType);
                            }
                        }
                    }
                }
                
                if(customers.size() > 0){
                    update customers;
                }
                if(accounts.size() > 0){
                    update accounts;
                }
                if(transactionTypes.size() > 0){
                    update transactionTypes;
                }
                
                if(count == recordsCount){
                    return JSON.serialize(responseBean);
                   // return JSON.serialize('All Records Deleted Successfully');
                }else{
                    return JSON.serialize(responseBean);
                    //return JSON.serialize('Out of '+ recordsCount + ' Records ' + count + ' were Deleted Successfully');
                }
            }
            else{
                return JSON.serialize(responseBean);
            }
        }
           return null;
        }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param objectID 
    * @param groupRestrictionId 
    * @param groupRestrictionObjectID 
    * @param startdate 
    * @param enddate 
    * @param isinfinity 
    * @param decsription 
    * @param ttorigeffdate 
    * @param recordId 
    * @return String 
    **/
    @AuraEnabled
    public static String updateTransactionTypesNode(String objectID, String groupRestrictionId, String groupRestrictionObjectID, String startdate, 
                                                    String enddate, String isinfinity, String decsription, String ttorigeffdate, String recordId){
        
		/*system.debug('objectID' +objectID);	
		system.debug('startdate' +startdate);		
		system.debug('enddate' +enddate);
		system.debug('groupRestrictionId' +groupRestrictionId);
		system.debug('isinfinity' +isinfinity);
		system.debug('decsription' +decsription);
		system.debug('groupRestrictionObjectID' +groupRestrictionObjectID);
		system.debug('ttorigeffdate' +ttorigeffdate);*/
                                                        
        ROTUpdateTransactionType_Req_IB_v1 requestBean = new ROTUpdateTransactionType_Req_IB_v1(); 
        requestBean.UpdateTransactionType = new ROTUpdateTransactionType_Req_IB_v1.UpdateTransactionType();
        requestBean.UpdateTransactionType.account = new ROTUpdateTransactionType_Req_IB_v1.account();
        requestBean.UpdateTransactionType.account.Description = decsription;
        //requestBean.UpdateTransactionType.account.EffectiveEndDate = enddate;
		requestBean.UpdateTransactionType.account.EffectiveEndDate = isinfinity.toLowerCase() == 'true' ? '9999-12-31': enddate;
        requestBean.UpdateTransactionType.account.EffectiveStartDate = startdate;
        requestBean.UpdateTransactionType.account.GroupRestrictionClusterID = 'ABS';
        requestBean.UpdateTransactionType.account.GroupRestrictionObjectID = groupRestrictionObjectID;
        requestBean.UpdateTransactionType.account.IsEffectiveEndDateInfinity = isinfinity;
        requestBean.UpdateTransactionType.account.Code = objectID;
        requestBean.UpdateTransactionType.account.OriginalEffectiveStartDate = ttorigeffdate;
        requestBean.UpdateTransactionType.user ='SALESFORCE';
        
        ROTUpdateTransactionType_Resp_IB_v1 responseBean = ROTUpdateTransactionType_IH_v1.UpdateTransactionType(requestBean);
        system.debug('Update Transaction Type response bean   >>>>>>>>>>>>>>>>' +JSON.serialize(responseBean));
        
        if(responseBean != null){
            if(responseBean.UpdateTransactionTypeResponse.UpdateTransactionTypeResult.HasErrors == 'false'){
                RestrictionGroupTransactionType__c upTT = new RestrictionGroupTransactionType__c(Id = recordId);
               // upTT.Restriction_Group_ID__c = groupRestrictionId;
                //upTT.Name = objectID;
                //upTT.Description__c = decsription;
                upTT.Effective_Start_Date__c = Date.parse(startdate.replaceAll('-', '/'));
                //upTT.Effective_End_Date__c = Date.parse(enddate.replaceAll('-', '/'));
                upTT.Effective_End_Date__c = isinfinity.toLowerCase() == 'true' ? Date.valueOf('4000-12-31') : Date.parse(enddate.replaceAll('-', '/'));
                upTT.Status__c = 'Updated';
                upTT.Original_Effective_Start_Date__c = Date.parse(startdate.replaceAll('-', '/'));
                update upTT;
                return JSON.serialize(responseBean);
            }else{
                return JSON.serialize(responseBean);
            }
        }
        return null;	
    } 
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param objectID 
    * @param groupRestrictionId 
    * @param groupRestrictionObjectID 
    * @param startdate 
    * @param recordId 
    * @return String 
    **/
     @AuraEnabled
    public static String deleteTransactionTypesNode(String objectID, String groupRestrictionId, String groupRestrictionObjectID, String startdate, String recordId){
        
        
        /*system.debug('objectID:::::::::::::::::::' +objectID);
        system.debug('groupRestrictionId:::::::::::::::::::' +groupRestrictionId);
        system.debug('groupRestrictionObjectID:::::::::::::::::::' +groupRestrictionObjectID);
        system.debug('startdate:::::::::::::::::::' +startdate);*/
        
        ROTDeleteTransactionType_Req_IB_v1 requestBean = new ROTDeleteTransactionType_Req_IB_v1();
        requestBean.DeleteTransactionType =  new ROTDeleteTransactionType_Req_IB_v1.DeleteTransactionType();
        requestBean.DeleteTransactionType.account = new ROTDeleteTransactionType_Req_IB_v1.Account();
        requestBean.DeleteTransactionType.account.Code = objectID;
        requestBean.DeleteTransactionType.account.GroupRestrictionClusterID = 'ABS';
        requestBean.DeleteTransactionType.account.GroupRestrictionObjectID = groupRestrictionObjectID;
        requestBean.DeleteTransactionType.account.EffectiveStartDate = startdate;
        requestBean.DeleteTransactionType.user = 'SALESFORCE';
        
        ROTDeleteTransactionType_Resp_IB_v1 responseBean = ROTDeleteTransactionType_IH_v1.deleteTransactionType(requestBean);
        
        system.debug('Delete Transaction Type response bean   >>>>>>>>>>>>>>>>' +JSON.serialize(responseBean));
        
        if(responseBean != null){
            if(responseBean.DeleteTransactionTypeResponse.DeleteTransactionTypeResult.HasErrors == 'false'){
                RestrictionGroupTransactionType__c rTT = new RestrictionGroupTransactionType__c(Id = recordId);
               // upTT.Restriction_Group_ID__c = groupRestrictionId;
                //upTT.Name = objectID;
                //upTT.Description__c = decsription;
                //rTT.Effective_Start_Date__c = Date.parse(startdate.replaceAll('-', '/'));
                //upTT.Effective_End_Date__c = Date.parse(enddate.replaceAll('-', '/'));
                rTT.Status__c = 'Deleted';
                update rTT;
                return JSON.serialize(responseBean);
            }else{
                System.debug('Has Error');
                System.debug('Service Response Has Errors ---->' + JSON.serialize(responseBean));
                return JSON.serialize(responseBean);
            }
        }
        return null;	
    } 
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param accountId 
    * @param accountNumber 
    * @param description 
    * @param startDate 
    * @param endDate 
    * @param groupRestrictionObjectId 
    * @return String 
    **/
    @AuraEnabled
    public static String expireAccountNode(string accountId ,  String accountNumber, String description , string startDate , String endDate , String groupRestrictionObjectId){
        ROTExpireSchemeNode_Req_IB_V1 request = new ROTExpireSchemeNode_Req_IB_V1();
        request.ExpireSchemeNode = new ROTExpireSchemeNode_Req_IB_V1.ExpireSchemeNode();
        request.ExpireSchemeNode.expiryModel = new ROTExpireSchemeNode_Req_IB_V1.expiryModel();
        request.ExpireSchemeNode.expiryModel.EffectiveStartDate = startDate;
        request.ExpireSchemeNode.expiryModel.EntityType = 'Account';
        request.ExpireSchemeNode.expiryModel.ExpiryDate = endDate;
        request.ExpireSchemeNode.expiryModel.GroupRestrictionClusterID = 'ABS';
        request.ExpireSchemeNode.expiryModel.GroupRestrictionObjectID = groupRestrictionObjectId;
        request.ExpireSchemeNode.user =  'SALESFORCE';
        request.ExpireSchemeNode.expiryModel.ObjectID = accountNumber;
      
        ROTExpireSchemeNode_Resp_IB_V1 responseBean = ROTExpireSchemeNode_IH_V1.getExpireSchemeNode(request);
        if(responseBean != null){
            if(responseBean.ExpireSchemeNodeResponse.ExpireSchemeNodeResult != null){
                if(responseBean.ExpireSchemeNodeResponse!=null && responseBean.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.HasErrors == 'false'){
                    RestrictionGroupAccount__c groupAccount = new RestrictionGroupAccount__c(Id = accountId);
                    groupAccount.AccountNumber__c = accountNumber;
                    groupAccount.Description__c = description;
                    groupAccount.EffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                    groupAccount.EffectiveEndDate__c = Date.parse(endDate.replace('-', '/'));
                    groupAccount.Status__c = 'Expire';
                    update groupAccount;
                    return JSON.serialize(responseBean);
                }else{
                    return JSON.serialize(responseBean);
                }
            }
        }
        return null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param accountId 
    * @param accountNumber 
    * @param description 
    * @param startDate 
    * @param endDate 
    * @param groupRestrictionObjectId 
    * @return String 
    **/
       @AuraEnabled
    public static String expireExcludedAccount(string accountId ,  String accountNumber, String description , string startDate , String endDate , String groupRestrictionObjectId){
        ROTExpireSchemeNode_Req_IB_V1 request = new ROTExpireSchemeNode_Req_IB_V1();
        request.ExpireSchemeNode = new ROTExpireSchemeNode_Req_IB_V1.ExpireSchemeNode();
        request.ExpireSchemeNode.expiryModel = new ROTExpireSchemeNode_Req_IB_V1.expiryModel();
        request.ExpireSchemeNode.expiryModel.EffectiveStartDate = startDate;
        request.ExpireSchemeNode.expiryModel.EntityType = 'ExcludedAccount';
        request.ExpireSchemeNode.expiryModel.ExpiryDate = endDate;
        request.ExpireSchemeNode.expiryModel.GroupRestrictionClusterID = 'ABS';
        request.ExpireSchemeNode.expiryModel.GroupRestrictionObjectID = groupRestrictionObjectId;
        request.ExpireSchemeNode.user =  'SALESFORCE';
        request.ExpireSchemeNode.expiryModel.ObjectID = accountNumber;
      
        ROTExpireSchemeNode_Resp_IB_V1 responseBean = ROTExpireSchemeNode_IH_V1.getExpireSchemeNode(request);
        if(responseBean != null){
            if(responseBean.ExpireSchemeNodeResponse.ExpireSchemeNodeResult != null){
                if(responseBean.ExpireSchemeNodeResponse!=null && responseBean.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.HasErrors == 'false'){
                    RestrictionGroupAccount__c groupAccount = new RestrictionGroupAccount__c(Id = accountId);
                    groupAccount.AccountNumber__c = accountNumber;
                    groupAccount.Description__c = description;
                    groupAccount.EffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                    groupAccount.EffectiveEndDate__c = Date.parse(endDate.replace('-', '/'));
                    groupAccount.Status__c = 'Expire';
                    update groupAccount;
                    return JSON.serialize(responseBean);
                }else{
                    return JSON.serialize(responseBean);
                }
            }
        }
        return null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param customerId 
    * @param customerKey 
    * @param description 
    * @param startDate 
    * @param endDate 
    * @param groupRestrictionObjectId 
    * @return String 
    **/
       @AuraEnabled
    public static String expireCustomerNode(string customerId ,  String customerKey, String description , string startDate , String endDate , String groupRestrictionObjectId){
        ROTExpireSchemeNode_Req_IB_V1 request = new ROTExpireSchemeNode_Req_IB_V1();
        request.ExpireSchemeNode = new ROTExpireSchemeNode_Req_IB_V1.ExpireSchemeNode();
        request.ExpireSchemeNode.expiryModel = new ROTExpireSchemeNode_Req_IB_V1.expiryModel();
        request.ExpireSchemeNode.expiryModel.EffectiveStartDate = startDate;
        request.ExpireSchemeNode.expiryModel.EntityType = 'Customer';
        request.ExpireSchemeNode.expiryModel.ExpiryDate = endDate;
        request.ExpireSchemeNode.expiryModel.GroupRestrictionClusterID = 'ABS';
        request.ExpireSchemeNode.expiryModel.GroupRestrictionObjectID = groupRestrictionObjectId;
        request.ExpireSchemeNode.user =  'SALESFORCE';
      request.ExpireSchemeNode.expiryModel.ObjectID = customerKey;
        
        ROTExpireSchemeNode_Resp_IB_V1 responseBean = ROTExpireSchemeNode_IH_V1.getExpireSchemeNode(request);
        if(responseBean != null){
            if(responseBean.ExpireSchemeNodeResponse!=null  && responseBean.ExpireSchemeNodeResponse.ExpireSchemeNodeResult != null){
                if(responseBean.ExpireSchemeNodeResponse!=null && responseBean.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.HasErrors == 'false'){
                    RestrictionGroupCustomer__c groupRestrictionCustomer = new RestrictionGroupCustomer__c(Id = customerId);           
                    groupRestrictionCustomer.CustomerKey__c = customerKey;
                    groupRestrictionCustomer.Description__c = description;
                    groupRestrictionCustomer.EffectiveStartDate__c = Date.parse(startDate.replace('-', '/'));
                    groupRestrictionCustomer.EffectiveEndDate__c = Date.parse(endDate.replace('-', '/'));
                    groupRestrictionCustomer.Status__c = 'Expire';
                    update groupRestrictionCustomer;
                    return JSON.serialize(responseBean);
                }else{
                    return JSON.serialize(responseBean);
                }
            }
        }
        return null;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param objectID 
    * @param groupRestrictionId 
    * @param groupRestrictionObjectID 
    * @param startdate 
    * @param enddate 
    * @param recID 
    * @return String 
    **/
    @AuraEnabled
    public static String expireTransactionTypesNode(String objectID, String groupRestrictionId, String groupRestrictionObjectID, String startdate, 
                                                    String enddate, String recID){
                                                        
		system.debug('ObjectID..............' +objectID);
		system.debug('groupRestrictionId..............' +groupRestrictionId);
		system.debug('groupRestrictionObjectID..............' +groupRestrictionObjectID);
		system.debug('startdate..............' +startdate);
		system.debug('enddate..............' +enddate);
		system.debug('recID..............' +recID);
        
        ROTExpireSchemeNode_Req_IB_V1 request = new ROTExpireSchemeNode_Req_IB_V1();
        request.ExpireSchemeNode = new ROTExpireSchemeNode_Req_IB_V1.ExpireSchemeNode();
        request.ExpireSchemeNode.expiryModel = new ROTExpireSchemeNode_Req_IB_V1.expiryModel();
        request.ExpireSchemeNode.expiryModel.EffectiveStartDate = startdate;
        request.ExpireSchemeNode.expiryModel.EntityType = 'TransactionType';
        request.ExpireSchemeNode.expiryModel.ExpiryDate = enddate;
        request.ExpireSchemeNode.expiryModel.GroupRestrictionClusterID = 'ABS';
        request.ExpireSchemeNode.expiryModel.GroupRestrictionObjectID = groupRestrictionObjectID;
        request.ExpireSchemeNode.expiryModel.ObjectID = objectID;
        request.ExpireSchemeNode.user =  'SALESFORCE';
		
		ROTExpireSchemeNode_Resp_IB_V1 responseBean = ROTExpireSchemeNode_IH_V1.getExpireSchemeNode(request);
		system.debug('Expire node responseBean >>>>>>>>>>>>' +responseBean);
                                                        
		if(responseBean != null){
            if(responseBean.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.HasErrors == 'false'){
                RestrictionGroupTransactionType__c exTT = new RestrictionGroupTransactionType__c(Id = recID);
                exTT.Effective_End_Date__c = Date.parse(enddate.replaceAll('-', '/'));
                exTT.Status__c = 'Expire';
                update exTT;
                return JSON.serialize(responseBean);
            }else {
                System.debug('Service Response Has Errors ---->' + JSON.serialize(responseBean));
                return JSON.serialize(responseBean);
            }
        }
        
        return null;	
    } 
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-26 
    * @param objectId 
    * @param records 
    * @param expiryDate 
    * @return String 
    **/
    @AuraEnabled
    public Static String bulkExpireGroupNodes(String objectId, String records , String expiryDate){
        List<Object> selectedRecords = (List<Object>)JSON.deserializeUntyped(records);
        Map<String, String> recordsIdsMap = new Map<String, String>(); 
        Integer recordsCount = selectedRecords.size();
        Integer count = 0;
        List<RestrictionGroupAccount__c> accounts = new List<RestrictionGroupAccount__c>();
        List<RestrictionGroupCustomer__c> customers = new List<RestrictionGroupCustomer__c>();
        List<RestrictionGroupTransactionType__c> transactionTypes = new List<RestrictionGroupTransactionType__c>();
        
        ROTExpireSchemeNodes_Req_IB_v1 requestBean = new ROTExpireSchemeNodes_Req_IB_v1();
        requestBean.ExpireSchemeNodes = new ROTExpireSchemeNodes_Req_IB_v1.ExpireSchemeNodes();
        
        requestBean.ExpireSchemeNodes.nodes = new ROTExpireSchemeNodes_Req_IB_v1.nodes();
        requestBean.ExpireSchemeNodes.nodes.ExpireNodeModel = new List<ROTExpireSchemeNodes_Req_IB_v1.ExpireNodeModel>();
        
        for(Object record : selectedRecords){
            system.debug('record' + record);
            Map<String,Object> recordMap = (Map<string,Object>)record;
            ROTExpireSchemeNodes_Req_IB_v1.ExpireNodeModel request  = new ROTExpireSchemeNodes_Req_IB_v1.ExpireNodeModel();
            
            request.GroupRestrictionObjectID = objectId;
            request.GroupRestrictionClusterID = 'ABS';
            request.ExpiryDate = expiryDate;
            
            
            Id recordId = Id.valueOf((String)recordMap.get('Id'));
            if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupAccount__c'){
                Boolean isExcludedAccount = (Boolean)recordMap.get('Excluded_Account__c');
                if(isExcludedAccount == true){
                    request.EntityType  = 'ExcludedAccount';
                    request.ObjectID  = (String)recordMap.get('AccountNumber__c');
                    request.EffectiveStartDate = (String)recordMap.get('EffectiveStartDate__c');
                }
                else{
                    request.EntityType  = 'Account' ;
                    request.ObjectID  = (String)recordMap.get('AccountNumber__c');
                    request.EffectiveStartDate = (String)recordMap.get('EffectiveStartDate__c');
                }
                //request.EffectiveStartDate  = (String)recordMap.get('EffectiveStartDate__c');
                //recordsIdsMap.put((String)recordMap.get('SchemeNodeID__c') , recordId);
                recordsIdsMap.put((String)recordMap.get('AccountNumber__c')+(String)recordMap.get('EffectiveStartDate__c')+'T00:00:00' , recordId);
                
            }
            else if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupCustomer__c'){
                request.ObjectID  = (String)recordMap.get('Name');
                request.EntityType  = 'Customer' ;
                request.EffectiveStartDate  = (String)recordMap.get('EffectiveStartDate__c');
                recordsIdsMap.put((String)recordMap.get('Name')+(String)recordMap.get('EffectiveStartDate__c')+'T00:00:00' , recordId);
                //recordsIdsMap.put((String)recordMap.get('SchemeNodeID__c') , recordId);
            }
            else if(recordId.getSObjectType().getDescribe().getName() == 'RestrictionGroupTransactionType__c'){
                request.EntityType  = 'TransactionType' ;
                request.EffectiveStartDate  = (String)recordMap.get('Effective_Start_Date__c');
                request.ObjectID  = (String)recordMap.get('Name');
                recordsIdsMap.put((String)recordMap.get('Name')+(String)recordMap.get('Effective_Start_Date__c')+'T00:00:00' , recordId);
                //recordsIdsMap.put((String)recordMap.get('SchemeNodeID__c') , recordId);
            }
            requestBean.ExpireSchemeNodes.nodes.ExpireNodeModel.add(request);
        }       
        requestBean.ExpireSchemeNodes.user ='SALESFORCE';
        system.debug('recordsIdsMap' +recordsIdsMap);
        ROTExpireSchemeNodes_Resp_IB_v1 responseBean = ROTExpireSchemeNodes_IH_v1.getExpireSchemeNodes(requestBean);
        if(responseBean != null){
            if(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.HasErrors == 'false'){
                if(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records != null ){
                    
                    for(Integer i=0; i<responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult.size(); i++ ){
                        if(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].Success == 'true'){
                            count++;
                            if(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].EntityType == 'Account' || responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].EntityType == 'ExcludedAccount'){
                                String accountId = recordsIdsMap.get(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].ObjectID+responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].EffectiveStartDate);
                                RestrictionGroupAccount__c account = new RestrictionGroupAccount__c(Id = accountId);
                                account.Status__c = 'Expire';
                                account.EffectiveEndDate__c = Date.parse(expiryDate.replace('-', '/'));
                                accounts.add(account);
                            }else if(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].EntityType == 'Customer'){
                                String customerId = recordsIdsMap.get(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].ObjectID+responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].EffectiveStartDate);
                                RestrictionGroupCustomer__c customer = new RestrictionGroupCustomer__c(Id=customerId);
                                customer.Status__c = 'Expire';
                                customer.EffectiveEndDate__c = Date.parse(expiryDate.replace('-', '/'));
                                customers.add(customer);
                            }
                            else if(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].EntityType == 'TransactionType'){
                                String transactionTypeId = recordsIdsMap.get(responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].ObjectID+responseBean.ExpireSchemeNodesResponse.ExpireSchemeNodesResult.Records.SchemeNodeOperationResult[i].EffectiveStartDate);
                                RestrictionGroupTransactionType__c transactionType = new RestrictionGroupTransactionType__c(Id=transactionTypeId);
                                transactionType.Status__c = 'Expire';
                                transactionType.Effective_End_Date__c = Date.parse(expiryDate.replace('-', '/'));
                                transactionTypes.add(transactionType);
                            }
                        }
                    }
                    
                }
                
                if(customers.size() > 0){
                    update customers;
                }
                if(accounts.size() > 0){
                    update accounts;
                }
                if(transactionTypes.size() > 0){
                    update transactionTypes;
                }
                
                if(count == recordsCount){
                    //return JSON.serialize(responseBean);
                    return JSON.serialize('All Records Expired Successfully');
                }else{
                    //return JSON.serialize(responseBean);
                    return JSON.serialize('Out of '+ recordsCount + ' Records ' + count + ' were Expired Successfully');
                }
            }
            else{
                return null;
            }
        }
        return null;
    }
    
}