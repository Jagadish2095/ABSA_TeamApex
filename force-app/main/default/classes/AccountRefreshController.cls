/*
* Controller class for AccountRefereshFromMDM component
* @author Saurabh Pandey
* @created 2019-08-22
*/

public class AccountRefreshController {
    
    @AuraEnabled
    public static Account getAccount(Id accountId) {
        
        Account acc =  new AccountsSelector().selectforRefreshById(accountId);
        return acc;
    }
    
    
    /* Method to update client details from CIF/MDM
* @Param: Id AccountId
* @Return: String Success/Failure 
* */
    @AuraEnabled
    public static String UpdateAccountsFromMDM(Id accountId){
        string result = '';
        String cmsEmpNo = '';
        String VAPMScore = '';
        Account client =  new AccountsSelector().selectforRefreshById(accountId);
        AccountCreate_CIF_MDM.GIPResponse createdAccount;
        List<Sys_Log_Integration__c> logList =  new List<Sys_Log_Integration__c>(); //created new list for adding all system logs from callouts in one list and inserting at once
        CMSGetBankerInfo_Resp_IB_v1 CMSGetBankerInfo_ResponseBean;
        GetCustomerVAPMSummary_Resp_IB_v1 getCustomerVAPMSummary_ResponseBeam;
        if(client.CIF__c != null){
            
            
            //Get Customer VAPM Score
            Map<GetCustomerVAPMSummary_Resp_IB_v1, List<Sys_Log_Integration__c>> VAPMrespMap = GetCustomerVAPMSummary_IH_v1.getCustomerVapmSummary(String.valueOf(client.CIF__c));
            
            if(VAPMrespMap != null && VAPMrespMap.size() > 0){
                
                getCustomerVAPMSummary_ResponseBeam = (new List<GetCustomerVAPMSummary_Resp_IB_v1>(VAPMrespMap.keySet()))[0];
                
                for(List<Sys_Log_Integration__c> currentLogList: VAPMrespMap.values()) {
                    logList.addAll(currentLogList);
                }
            }
            
            if(getCustomerVAPMSummary_ResponseBeam != null){
                if(getCustomerVAPMSummary_ResponseBeam.getCustomerVapmSummaryResponse != null){
                    
                    if(getCustomerVAPMSummary_ResponseBeam.getCustomerVapmSummaryResponse.getCustomerVapmSummaryResult != null){
                        
                        if(getCustomerVAPMSummary_ResponseBeam.getCustomerVapmSummaryResponse.getCustomerVapmSummaryResult.customerVapmSummary != null){
                            
                            
                            if(getCustomerVAPMSummary_ResponseBeam.getCustomerVapmSummaryResponse.getCustomerVapmSummaryResult.customerVapmSummary.customerVapmSummaryDto != null && getCustomerVAPMSummary_ResponseBeam.getCustomerVapmSummaryResponse.getCustomerVapmSummaryResult.customerVapmSummary.customerVapmSummaryDto.Size() > 0){
                                
                                for(GetCustomerVAPMSummary_Resp_IB_v1.CustomerVapmSummaryDto customerVapmDto : getCustomerVAPMSummary_ResponseBeam.getCustomerVapmSummaryResponse.getCustomerVapmSummaryResult.customerVapmSummary.customerVapmSummaryDto){
                                    
                                    if(customerVapmDto.ItemDesc == StringConstants.VAPM_ITEM_DESCRIPTION){
                                        
                                        VAPMScore = customerVapmDto.CustomerValueLastMonth;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            //Calling CMS service and updating the relationship banker name 
            Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> CMSGetBankerInfo_ResponseMap =CMSGetBankerInfo_IH_v1.getBankerDeatils('SALESFORCE', String.valueOf(client.CIF__c));
            
            if (CMSGetBankerInfo_ResponseMap != null && CMSGetBankerInfo_ResponseMap.size() > 0) {
                CMSGetBankerInfo_ResponseBean = (new List<CMSGetBankerInfo_Resp_IB_v1>(CMSGetBankerInfo_ResponseMap.keySet()))[0];
                
                for(List<Sys_Log_Integration__c> currentLogList: CMSGetBankerInfo_ResponseMap.values()) {
                    logList.addAll(currentLogList);
                }
            }
            
            system.debug('CMSGetBankerInfo_ResponseBean'+CMSGetBankerInfo_ResponseBean);
            //system.debug('CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o.contOffDet'+CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o.contOffDet);
            if(CMSGetBankerInfo_ResponseBean.body!=null){
		 if(CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response!=null){
		 if(CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o!=null){
		 if(CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o.contOffDet!=null && !CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o.contOffDet.isempty())
	 
		 {
                
                for(CMSGetBankerInfo_Resp_IB_v1.ContOffDet contoff:CMSGetBankerInfo_ResponseBean.body.GBlistCmsContOffPerClntV2Response.gsp019o.contOffDet){
                    system.debug('contoff.contOffType'+contoff.contOffType);
                    if(contoff.contOffType.equalsIgnoreCase('BB'))
                    {
                        system.debug('cmsEmpNo'+cmsEmpNo);
                       cmsEmpNo= contoff.coEmployeeNum;
                        break;
                    }
                }
              
            }
		 }
		 }
		 }
            createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(client.CIF__c, '0', '009970'); // Awaiting Mapping
            system.debug('createdAccount'+createdAccount);
            //Updating VAMP and RelationshipBankerName by calling respective services above  
            if(createdAccount.AccountId != null){      
                Account accUpdate = new account(Id=client.id);
                Boolean updateAccountFlag;
                
                if(VAPMScore != Null ){
                    updateAccountFlag = true;
                    accUpdate.VAPM__c = VAPMScore;
                }
                system.debug('cmsEmpNo in user---'+cmsEmpNo);
                if (cmsEmpNo != null && cmsEmpNo!='') {
                    system.debug('cmsEmpNo in user'+cmsEmpNo);
                    List<User> userList = new UsersSelector().userwithEmployeeNumber(cmsEmpNo);
                    system.debug('usr-----debug'+userList );
                    
                    if(userList !=null && !userList.isEmpty() && !String.isEmpty(userList[0].Id)){
                        updateAccountFlag = true;
                        accUpdate.Relationship_Banker_Name__c= string.valueOf(userList[0].Id);
                    } 
                    
                    
                }
                
                if (updateAccountFlag) {
                    update accUpdate;
                }
                
                result = 'Success'; 
            }
            
        }else if(client.ID_Type__pc != null && client.ID_Type__pc == 'SA Identity Document'){
            
            createdAccount = AccountCreate_CIF_MDM.createAccountFromMDM('SAID', client.ID_Number__pc);
            
            if(createdAccount.AccountId != null){
                
                result = 'Success';
            }
            
        }else if(client.ID_Type__pc != null && client.ID_Type__pc == 'Passport'){
            
            createdAccount = AccountCreate_CIF_MDM.createAccountFromMDM('Passport', client.Passport_Number__pc);
            
            If(createdAccount.AccountId != null){
                
                result = 'Success';
            }
            
        }else{
            
            result = 'No ID number, Passport number or CIF number was found';
        }
        
        
        //inserting all the systems log called from all services here   
        if (logList.size() > 0) {
            insert logList;
        }
        
        return result;
        
    }
}