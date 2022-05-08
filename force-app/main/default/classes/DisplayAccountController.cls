/**
* This is AddBeneficiary Lightning component Apex Controller Class
*
* @author Khaliq Abdul 
* @created 2021/02/25
*/

public class DisplayAccountController {
    
    public static Account acc;
    
    @AuraEnabled
    public static string getAcctLinkedToClientCodeV3(String clientAccountId)
    {       
        //get user Info 
        string responseBeanReturn='';
        User loggedInUserInfo = new UsersSelector().selectById(UserInfo.getUserId());       
        string CIFKey='';
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        if(accountList.size() > 0){
            if(String.isNotBlank(accountList[0].CIF__c)){
                CIFKey= accountList[0].CIF__c;               
                CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean;      
                
                try{
                    CIgetAcctLinkedToClientCodeV3_Req_IB_v1 reqBean = new CIgetAcctLinkedToClientCodeV3_Req_IB_v1();
                    
                    reqBean.channel = 'SALESFORCE';
                    reqBean.application = 'Salesforce';
                    reqBean.trace = 'Y';
                    reqBean.msgLanguage = 'E';
                    reqBean.msgTarget = 'STD';
                    reqBean.finalMsgClass = '';
                    reqBean.finalMsgCode = '';
                    reqBean.clientcd = CIFKey;//'TSHABP 028';//ARENTAL001';//GREENJ 154';;
                    reqBean.accntnbr = '0';
                    reqBean.maxret = '0';
                    reqBean.restart = '';
                    reqBean.siteCode = loggedInUserInfo.SiteCode__c;//'8196';
                    
                    responseBean =  CIgetAcctLinkedToClientCodeV3_IH_v1.CIgetAcctLinkedToClientCode(reqBean);
                    responseBeanReturn =  responseBean.serialize(responseBean);
                    
                } catch(Exception exc){
                    System.debug('Exception Occured'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
                    throw new ApplicationException('Something went wrong: '+ exc.getMessage());            
                }
            }
        }
        
        return responseBeanReturn;       
    }
    
    @AuraEnabled
    public static string getAcctLinkedToClientCode(String clientCode)
    {       
        //get user Info 
        string responseBeanReturn='';
        User loggedInUserInfo = new UsersSelector().selectById(UserInfo.getUserId());  
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean;      
        
        try{
            CIgetAcctLinkedToClientCodeV3_Req_IB_v1 reqBean = new CIgetAcctLinkedToClientCodeV3_Req_IB_v1();
            
            reqBean.channel = 'SALESFORCE';
            reqBean.application = 'Salesforce';
            reqBean.trace = 'Y';
            reqBean.msgLanguage = 'E';
            reqBean.msgTarget = 'STD';
            reqBean.finalMsgClass = '';
            reqBean.finalMsgCode = '';
            reqBean.clientcd = clientCode;
            reqBean.accntnbr = '0';
            reqBean.maxret = '0';
            reqBean.restart = '';
            reqBean.siteCode = loggedInUserInfo.SiteCode__c;         
            responseBean =  CIgetAcctLinkedToClientCodeV3_IH_v1.CIgetAcctLinkedToClientCode(reqBean);                 
            responseBeanReturn =  responseBean.serialize(responseBean);
            
        } catch(Exception exc){
            System.debug('Exception Occured'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
            throw new ApplicationException('Something went wrong: '+ exc.getMessage());            
        }
        
        return responseBeanReturn;       
    }
    private static CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 translateToInternalValues(CIgetAcctLinkedToClientCodeV3_Resp_IB_v1  acctLinkedToClientCode){
        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable OutputTableRequest= new CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable();         
        List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable> OutputTableRequestList = new List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable>();
        OutputTableRequestList = acctLinkedToClientCode.Cip047o.outputTable;
        for (CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable OutputTable : acctLinkedToClientCode.Cip047o.outputTable) {           
            OutputTable.srcOfFnds1 = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Source of Income', OutputTable.srcOfFnds1, StringConstants.INBOUND_RECORD_TYPE);
            
        }        
        return acctLinkedToClientCode;
    }    
}