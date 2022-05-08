/* Lightning cmp controller for Register & Maintain Statements
* Author: Lerato Matenzhe
* Date :  21/03/2020 
* Modified by Muvhuso Nekhubvi Date : 08/04/2020
*/
    
    public class RegisterMaintainStatementsController {
    @AuraEnabled
        //Map<String,CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>
        public static String getAccountDetails(String clientAccountId){
            system.debug('----clientAccountId----'+clientAccountId);
            List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
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
        
                for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accTypes){
                    accountWrapperList.add(accWrObj);
                }
                return JSON.serialize(accountWrapperList);
            }
            
            return null;
            
        }
        
         @AuraEnabled
        
        public static String registerMantain(String requests,String accountNumber, String product , String email){
             
            String site, teller;
           
            EImaintainESDDetailsV3_Resp_IB_v1.Eip103o esdWrapperClass;
            
            User currentUser =  new UsersSelector().selectById(Userinfo.getUserId());
            
            system.debug('Current User' + currentUser.SiteCode__c);
            
            if(currentUser != null){
                site = currentUser.SiteCode__c;
                teller = currentUser.Teller_Operator_Code__c;
                
                   
                    Map<EImaintainESDDetailsV3_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = EImaintainESDDetailsV3_IH_v1.sImaintainESDDetailsV3(requests ,site ,teller,accountNumber,product ,email);
                
                    EImaintainESDDetailsV3_Resp_IB_v1 responseBean = (new List<EImaintainESDDetailsV3_Resp_IB_v1>(responseMap.keySet()))[0];
                    
                    if(responseBean != null ){
                       if(responseBean.statusCode == 200){
                          
                          EImaintainESDDetailsV3_Resp_IB_v1.EImaintainESDDetailsV3Response wrapper = responseBean.EImaintainESDDetailsV3Response;
                          if(wrapper != null){
                               if(wrapper.eip103o != null){
                                  esdWrapperClass = wrapper.Eip103o;
                                  system.debug('Service Response ' + esdWrapperClass);
                                  return JSON.serialize(esdWrapperClass);
                                }
                           }
                          	
                       }
                    } 
                
            }
        
            return null;
        }
    
    }