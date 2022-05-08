/**
* @description Integration Handler for CCGetPortfolioDetailV1 Service
* @author Lulu Rankwe
* @created 2020-03-20
*/
public class StopAndReplaceCombiCardController {
    /**
     * @description  method to get account details
     * @param clientAccountId
     * @return String
     */
    @AuraEnabled
    public static String getAccountDetails(String clientAccountId){
        system.debug('----clientAccountId----'+clientAccountId);
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
         system.debug('----accountList----'+accountList);   
        CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING,accountList[0].CIF__c);
        
        if(response.statusCode == 200){
            CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;
            
            List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;
            accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();
            
            for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accTypes){
                accountWrapperList.add(accWrObj);
                
            }
            system.debug(LoggingLevel.FINE,'outputBean3: ' + accountWrapperList);
            return JSON.serialize(accountWrapperList);
             
        }
        
        return null;
        
    }

     /**
     * @description  method to get portfolio details
     * @param combiNbr
     * @return String
     */
    @AuraEnabled 
    public static String getPortfolioDetails(String combiNbr){
        String result;
        
        Map<CCGetPortfolioDetailV1_Resp_IB_v1, List<Sys_Log_Integration__c>> singleresponse= CCGetPortfolioDetailV1_IH_v1.CCGetPortfolioDetailV1(combiNbr);                                                                                                                                                                                                    
        CCGetPortfolioDetailV1_Resp_IB_v1 portfolioDetails = (new List<CCGetPortfolioDetailV1_Resp_IB_v1>((singleresponse.keySet())))[0]; 
        
        if(portfolioDetails != null){ 
        	if(portfolioDetails.statusCode == 200){
                if(portfolioDetails.CCgetPortfolioDetailV1Response != null){
                    if(portfolioDetails.CCgetPortfolioDetailV1Response.Ccp301o != null){
                         CCGetPortfolioDetailV1_Resp_IB_v1.Ccp301o outputBean = portfolioDetails.CCgetPortfolioDetailV1Response.Ccp301o;
                		 return JSON.serialize(outputBean);
                    }
                }
               
           }  
        }
        return null;
        
    }

    /**
     * @description  method to close combi card
     * @param combiNbr
     * @param reason
     * @param subReason
     * @return String
     */
    @AuraEnabled 
    public static String closeCombicard(String combiNbr,String reason,String subReason){
        String result;

        Map<CCcloseV2_Resp_IB_v1, List<Sys_Log_Integration__c>> singleresponse = CCcloseV2_IH_v1.closeCombiCard(combiNbr,reason,subReason);//reasonTrans,subReasonTrans);                                                                                                                                                                                                   
        CCcloseV2_Resp_IB_v1 outpuList = (new List<CCcloseV2_Resp_IB_v1>((singleresponse.keySet())))[0]; 
        if(outpuList != null){
            if(outpuList.CCcloseV2Response != null){
          		CCcloseV2_Resp_IB_v1.ccp327o outputBean = outpuList.CCcloseV2Response.ccp327o;
        
        
          		if(outpuList.statusCode == 200){ 
            		
            		CCcloseV2_Resp_IB_v1.nbsmsgo msg = outpuList.CCcloseV2Response.nbsmsgo;
            
            		if(outpuList.CCcloseV2Response.ccp327o != null){
                
                		if(outputBean.combiRetrvdInd == 'Y' && outputBean.combiClosedInd == 'Y'){
                    		result = outputBean.combiRetrvdInd;
                			}
                 
            	 }else{ 
                 for(CCcloseV2_Resp_IB_v1.msgEntry msgEntry: msg.msgEntry){
                    result = msgEntry.msgTxt;
                }
                
            }
        }
      }
     }
        return result;
        
    }

    /**
	 * @description SMath: 06 June 2021: method to issue Combi Card
	 * @param accountNo
     * @param issueBranch
     * @param persInd
     * @param brandNbr
     * @param autoLink
     * @param persName
     * @param persTitl
     * @param persInit
     * @param persSurn
     * @param delvBranch
     * @param sbuCode
     * @param clntCode
     * @param nomCheq
     * @param nomSavs
     * @param nomCred
     * @param cardNbr
	 * @return String 
	 */  
    @AuraEnabled 
    public static String issueCombiCard(String accountNo, String issueBranch,String persInd, String brandNbr,
                                                                String autoLink,String persName,String persTitl,String persInit,String persSurn,String delvBranch,
                                                                String sbuCode,String clntCode, String nomCheq, String nomSavs, string nomCred, String cardNbr){
    String result;
        
    User currentUser =  new UsersSelector().selectById(Userinfo.getUserId());
            
    system.debug(LoggingLevel.FINE,'Current User' + currentUser.SiteCode__c);

    if(String.isNotBlank(accountNo) && accountNo.length() >= 17){
            accountNo = accountNo.substring(7, 17);
    } 
    
    if(String.isNotBlank(nomCheq) && nomCheq.length() >= 17){
            nomCheq = nomCheq.substring(7, 17);
    }
    

    CCissueCombiCardV1_Resp_IB_v1 responseBean = CCissueCombiCard_IH_v1.issueCombiCard(accountNo, issueBranch, persInd, brandNbr, autoLink, persName, persTitl, persInit, persSurn, delvBranch,currentUser.Teller_Operator_Code__c, currentUser.Supervisor__c, currentUser.SiteCode__c, sbuCode, clntCode, nomCheq, nomSavs,
    nomCred, cardNbr);  
        if(responseBean != null && responseBean.statusCode == 200){

            CCissueCombiCardV1_Resp_IB_v1.ccp348o ccp348oBean = responseBean.CCissueCombiCardV1Response.ccp348o; 
            CCissueCombiCardV1_Resp_IB_v1.nbsmsgo3 nbsmsgo3Bean = responseBean.CCissueCombiCardV1Response.nbsmsgo3;
                
            if(responseBean.CCissueCombiCardV1Response != null){

                if(responseBean.CCissueCombiCardV1Response.ccp348o != null){
                    return JSON.serialize(responseBean); 
                }      
            }
        }
        
    return null;
    
    }

    /**
     * @description  method to get account record
     * @param clientAccountId
     * @return String
     */
    @AuraEnabled 
    public static String personDetails(String clientAccountId){
        List<Account> beanL ;
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
		system.debug(accountList);
        //return accountList;
         return JSON.serialize(accountList); 
    
        
    }
}