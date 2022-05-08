/**
 * @description
 * @author Taras Kuliievych
 * @since 2021-08-03
**/
public with sharing class Enquiry_CurrentProductsController {
    /**
     * @description
     * @author            : Igor Vasylevskyi
     * @since             : 2021-05-14
     * @param clientKey
     * @return List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable>
    **/
    @AuraEnabled
    public static List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable> getClientAccountNumbers(String clientKey) {

        try {
            String responseBeanString = DisplayAccountController.getAcctLinkedToClientCode(clientKey);

            String message = 'Unhandled error in ClientAccountsTableController.getAcctLinkedToClientCode().\n';

            Map<String, Object> responseMap =  (Map<String, Object>) JSON.deserializeUntyped(responseBeanString);
            if (responseMap.get('message') != null) {
                message += responseMap.get('message');
                AuraHandledException e = new AuraHandledException(message);
                e.setMessage(message);

                throw e;
            }

            CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = (CIgetAcctLinkedToClientCodeV3_Resp_IB_v1) JSON.deserialize(
                                                                                                                                responseBeanString,
                                                                                                                                CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.class);

            List<CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable> outputTable = responseBean.cip047o.outputTable;

            if (outputTable == null) {

                if (responseBean.nbsmsgo3.msgEntry != null) {
                    message = responseBean.nbsmsgo3.msgEntry[0].msgTxt;
                }
                AuraHandledException e = new AuraHandledException(message);
                e.setMessage(message);

                throw e;
            }

            return outputTable;

        } catch (Exception e) {
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());

            throw ex;
        }
    }
}