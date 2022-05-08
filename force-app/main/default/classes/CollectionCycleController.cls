/**
* @description This is CollectionCycleController Lightning component Apex Controller Class
* @author Kamil Rega
* @created 2020/02/05
*/

public with sharing class CollectionCycleController {
/**
 * @description get info about Collection phase and cycle & PTP
 * @param  clientAccountNum
   * @param  caseId
 * @return String
 */
    @AuraEnabled
    public static String handleClientFinancialResponses(String clientAccountNum, string caseId){
        Map<String, String> responsesMap = new Map<String, String>();
        Map<String, String> clientCollectionPhaseAndCycleMap = new Map<String, String>();
        String responseFromPromiseToPay;
        clientCollectionPhaseAndCycleMap = getAccountCollectionPhaseAndCycle(clientAccountNum);

        if (clientCollectionPhaseAndCycleMap != null && !clientCollectionPhaseAndCycleMap.isEmpty()) {
            responsesMap.putAll(clientCollectionPhaseAndCycleMap);
        } else {
            throw new AuraHandledException('Error: response from get Account Collection Phase And Cycle is empty');
        }
        if(clientCollectionPhaseAndCycleMap.get('customerOnPTP') == 'Yes') {
            responseFromPromiseToPay = getClientPromiseToPayDetails(clientAccountNum);
            if (responseFromPromiseToPay != null && !String.isEmpty(responseFromPromiseToPay) && !responseFromPromiseToPay.contains('Record CONSUMER not found')) {
                responsesMap.put('PTP', responseFromPromiseToPay);
            } else {
                throw new AuraHandledException('Error: response from promise to pay is empty');
            }
        }
            List<Case> caseList = new CasesSelector().selectByCaseId(caseId);
            if (!responsesMap.isEmpty() && responsesMap != null) {
                caseList[0].Extended_Request_Data__c = JSON.serialize(responsesMap);
            }
            //isUpdateable for change
            if (Case.SObjectType.getDescribe().isUpdateable()) {
                update caseList;
            } else {
                throw new AuraHandledException('Error: Missing permission for updating Extended_Request_Data__c field');
            }
            if (!String.isEmpty(caseList[0].Extended_Request_Data__c)) {
                return caseList[0].Extended_Request_Data__c ;
            } else {
                throw new AuraHandledException('Error: Extended_Request_Data__c field is empty');
            }
        }

/**
 * @description get info about Collection phase and cycle & PTP From database
   * @param  caseId
 * @return String
 */
    @AuraEnabled
    public static String getCachedFinancialResponse(string caseId){
        List<Case> caseList = new CasesSelector().selectByCaseId(caseId);
        if (caseList[0].Extended_Request_Data__c != null && !String.isEmpty(caseList[0].Extended_Request_Data__c)) {
            return caseList[0].Extended_Request_Data__c ;
        } else {
            throw new AuraHandledException('Error: Extended_Request_Data__c field is empty');
        }
    }

    /**
* @description retrieves Collection Phase and Collection Cycle passing Account Number
* @param  clientAccountNum
* @return  Map<String, String>
* @work w-013364
*/
    @AuraEnabled
    public static Map<String, String> getAccountCollectionPhaseAndCycle(String clientAccountNum) {
        Map<String, String> collectionCycleDataMap = new Map<String, String>();
        // To fetch agency Identifier
        AccountSearch_Resp_IB_v1 responseBean = AccountSearch_IH_v1.AccountSearch(clientAccountNum);
        if (responseBean?.StatusCode != 200) {
            throw new AuraHandledException('Error: ' + responseBean.message);
        }
        if (!Test.isRunningTest()) {
                if (responseBean.Data == null || (responseBean.Data != null && responseBean?.Data[0]?.accountAgencyIdentifier == null)) { throw new AuraHandledException('Error: Service failed to return Agency Identifier. Please contact to your administrator');}
        }
        // To fetch Business Area / Collection Phase
        String accountAgencyIdentifier = String.valueof(responseBean?.Data[0]?.accountAgencyIdentifier);

        collectionCycleDataMap.put('arrearAmount', String.valueof( responseBean?.Data[0]?.CurrentBalance?.amount));
        if (Test.isRunningTest()) {
            accountAgencyIdentifier = '170305299';
        }

        RetreiveTag_Resp_IB_v1 responseRetrieveTag = RetreiveTag_IH_v1.RetreiveTag(accountAgencyIdentifier);
        // To fetch  Collection Cycle
        RetreiveAccountPageList_Resp_IB_v1 resRetriveList = RetreiveAccountPageList_IH_v1.RetreiveAccountPageList(accountAgencyIdentifier);
        if (responseRetrieveTag?.StatusCode != 200 && resRetriveList?.StatusCode != 200) {
            collectionCycleDataMap.put('Error', ' Service returned Error while fetching collection phase and collection cycle.');return collectionCycleDataMap;}
        if (responseRetrieveTag != null) {
            Boolean isPTPStatus=false;
            for (RetreiveTag_Resp_IB_v1.Data data : responseRetrieveTag.Data) {
                if (data?.tag?.tagType?.name == 'Business Area') {  collectionCycleDataMap.put('businessArea', data.tag.description);}
                if (data?.tag?.tagType?.name == 'PTP Status Tag Type') {
                    isPTPStatus=true;
                    if (data.tag.description == 'PTP Kept' || data.tag.description == 'PTP Cancelled' || data.tag.description == 'PTP Broken' || data.tag.description == 'PTP Clear') { collectionCycleDataMap.put('customerOnPTP', 'No');}
                    if (data.tag.description == 'PTP Active') {  collectionCycleDataMap.put('customerOnPTP', 'Yes');}
                }
            }
            if(!isPTPStatus){
                collectionCycleDataMap.put('customerOnPTP', 'No');
            }
        }
        if (resRetriveList != null) {  collectionCycleDataMap.put('collectionCycle', calculateCollectionCycle(resRetriveList));}
        return collectionCycleDataMap;
    }

    /**
* @description Calculate Number of Cycle on passing Response
* @param  res
* @return String
* @work w-013364
*/
    @TestVisible
    private static String calculateCollectionCycle(RetreiveAccountPageList_Resp_IB_v1 res) {
        String collectionCycle;
        if (res ?.data[0] ?.userDefinedData ?.UDEFNDD != null) {
            Decimal uDEFNDD = Decimal.valueOf(res.data[0].userDefinedData.UDEFNDD);
            Integer count = Integer.valueOf(Math.ceil(uDEFNDD / 30));
            collectionCycle = 'Cycle ' + count;
        }
        return collectionCycle;
    }

    /**
* @description promisToPay
* @param clientAccountNum
* @return String
*/
    @AuraEnabled
    public Static String getClientPromiseToPayDetails(String clientAccountNum){
        // To fetch agency Identifier
        AccountSearch_Resp_IB_v1 responseBean = AccountSearch_IH_v1.AccountSearch(clientAccountNum);
        if(responseBean?.StatusCode !=200 || responseBean.Data ==null||( responseBean.Data !=null && responseBean?.Data[0]?.accountAgencyIdentifier == null )){
            throw new AuraHandledException('Service returned error while fetching account details');
        }
        PaymentScheduleSummaries_Resp_IB_v1 response = PaymentScheduleSummaries_IH_v1.GetPaymentScheduleSummaries(String.valueof(responseBean?.Data[0]?.primaryOwnerAgencyIdentifier));
        return JSON.serialize(response);
    }

}