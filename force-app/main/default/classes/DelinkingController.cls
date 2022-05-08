public class DelinkingController {

    @AuraEnabled
    public static List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable> getChequeAccountNumbers(String clientKey) {

        try {
            String responseBeanString = DisplayAccountController.getAcctLinkedToClientCode(clientKey);
            System.debug('responseBeanString DelinkingController.getAcctLinkedToClientCode ---> ' + responseBeanString);
            String message = 'Unhandled error in getCheckAccountNumbers.';

            Map<String, Object> responseMap =  (Map<String, Object>) JSON.deserializeUntyped(responseBeanString);
            if (responseMap.get('message') != null) {
                message +=  ' The Client Key (CIF) may be incorrect.';
                AuraHandledException e = new AuraHandledException(message);
                e.setMessage(message);

                throw e;
            }
            
            CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = (CIgetAcctLinkedToClientCodeV3_Resp_IB_v1) JSON.deserialize(responseBeanString, CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.class);
                        
            List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable> outputTable = responseBean.cip047o.outputTable;

            if (outputTable == null) {
                
                if (responseBean.nbsmsgo3.msgEntry != null) {
                    message = responseBean.nbsmsgo3.msgEntry[0].msgTxt;
                }
                AuraHandledException e = new AuraHandledException(message);
                e.setMessage(message);

                throw e;
            }

            List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable> responseAccounts = new List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable>();

            //Filter CQ (cheque) accounts from response only
            for (CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable tableItem : outputTable) {
                if (tableItem.productType.equalsIgnoreCase('CQ')) {
                    responseAccounts.add(tableItem);
                }
            }
            //System.debug('responseBeanString----------> ' + responseBeanString);
            system.debug('out---------------> ' + JSON.serialize(outputTable));
            system.debug('responseAccounts---------------> ' + JSON.serialize(responseAccounts));

            return responseAccounts;

        } catch (Exception e) {
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());

            throw ex;
        }
    }

    @AuraEnabled 
    public static List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE> cqGetValueBandleOptions(String clientKey) {
        // List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        
        CQgetValueBundleOptionsV3_Resp_IB_v1 responseBean = CQgetValueBundleOptionsV3_IH_v1.callToCQgetValueBundleOptionsV3(clientKey);
        List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE> schemeCodes = responseBean.CQS044O.CQS044O_OUTPUT_AREA.SCHEME_CODE_TABLE;

        if (schemeCodes == null) {
            String message = 'Unhandled error in cqGetValueBandleOptions';
            if (responseBean.NBSMSGO3.NBSMSGO3 != null) {
                message = responseBean.NBSMSGO3.NBSMSGO3.NBNMSGO3_MSG_ENTRY[0].NBNMSGO3_MSG_TXT;
            }
            AuraHandledException e = new AuraHandledException(message);
            e.setMessage(message);

            throw e;
        }

        return schemeCodes;
    }
    
    @AuraEnabled
    public static CQgetChargesDetailsMaintV9_Resp_IB_v1 cqGetChargesDetails(String accountNumber) {

        try {
            Map<CQgetChargesDetailsMaintV9_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQgetChargesDetailsMaintV9_IH_v1.callToCQgetChargesDetailsMaintV9(accountNumber);

            CQgetChargesDetailsMaintV9_Resp_IB_v1 responseBean = (new List<CQgetChargesDetailsMaintV9_Resp_IB_v1>(responseMap.keySet()))[0];
            System.debug('cqGetChargesDetails-----> ' + JSON.serialize(responseBean));

            return responseBean;

        } catch (Exception e) {
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());

            throw ex;
        }
    }

    @AuraEnabled 
    public static CQupdateChargesDetailsV12_Resp_IB_v1 updateChargesDetails(Map<String, Object> requestFieldsValues) {
        System.debug('requestFieldsValues1111111________> ' + JSON.serialize(requestFieldsValues));
        try {
            System.debug('1111');
            Map<CQupdateChargesDetailsV12_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQupdateChargesDetailsV12_IH_v1.callToCQupdateChargesDetailsV12(requestFieldsValues);
            System.debug('2222');
            CQupdateChargesDetailsV12_Resp_IB_v1 responseBean = (new List<CQupdateChargesDetailsV12_Resp_IB_v1>(responseMap.keySet()))[0];

            return responseBean;            
            
        } catch (Exception e) {
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());

            throw ex;
        }
    }
}