/**
* @description to fetch the transaction history from service 
@author manideep kenche
@created 2021/09/28
*/
public with sharing class CardTransactionHistoryController {
    
    /**
* @description to fetch the transaction history from service 
*@param  policyNumber
*@param  caseId
* 		@return String
*/
    @AuraEnabled
    public static String getTransactionalHistory(String policyNumber,String caseId){
        //policyNumber = policyNumber.leftPad(16,'0');
        // security level handling for queries
        // we need to display aurahandledException on UI
        // review on ERD jobs
        list<Case_Transaction__c> caseTransactionList = new list<Case_Transaction__c>();
       caseTransactionList = [select Id,Amount__c,Balance__c,Reason__c,Transaction_Date__c from Case_Transaction__c where Case__c =:caseId ];
        
        if(caseTransactionList.size() > 0){
            return JSON.serialize(caseTransactionList);
            
        }else {
            if(String.isBlank(policyNumber)){
                 AuraHandledException e = new AuraHandledException('Policy Number Undefined');
                 e.setMessage('No Account Number specified for Transaction History');
                throw e;
            }
            PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(policyNumber);
            if(responseBean == NULL){
                
                AuraHandledException e = new AuraHandledException('No response from service');
                 e.setMessage('Unexpected response from service.Please contact your administrator');
                throw e;
            }
            if(responseBean.StatusCode != 200){
                 AuraHandledException e = new AuraHandledException('Unexpected response from service');
                 e.setMessage(responseBean.Message);
                throw e;
            }
            if(responseBean?.Policy_LoadByRefNoResponse?.Policy_LoadByRefNoResult?.Contracts?.V3_DC2Contract?.FinTransactions?.V3_DC2FinTransaction == null) {
                AuraHandledException e = new AuraHandledException('Missing Transaction Data');
                 e.setMessage('No Transaction History Found.Please contact your administrator');
                throw e;
            }
            
            List<PolicyLoadByRefNo_Resp_IB_v1.V3_DC2FinTransaction> DC2FinTransaction = new List<PolicyLoadByRefNo_Resp_IB_v1.V3_DC2FinTransaction>();
           
            for(PolicyLoadByRefNo_Resp_IB_v1.V3_DC2FinTransaction clientTransaction : responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.FinTransactions.V3_DC2FinTransaction){
                clientTransaction.CreatedDate = clientTransaction.CreatedDate.replace(clientTransaction.CreatedDate, clientTransaction.CreatedDate.left(10));
                
                Case_Transaction__c caseTransactionRecord = new Case_Transaction__c();
                caseTransactionRecord.Case__c = caseId;
                caseTransactionRecord.Amount__c = Decimal.valueOf(clientTransaction.Amount);
                caseTransactionRecord.Balance__c = clientTransaction.Balance;
                caseTransactionRecord.Reason__c = clientTransaction.TransTypeDesc;
                caseTransactionRecord.Transaction_Date__c = Date.valueOf(clientTransaction.CreatedDate);                
                caseTransactionList.add(caseTransactionRecord);
            }
            //create Case_Transaction__c selector class
            insert caseTransactionList;
            return JSON.serialize(caseTransactionList);
            
        }

    }
}