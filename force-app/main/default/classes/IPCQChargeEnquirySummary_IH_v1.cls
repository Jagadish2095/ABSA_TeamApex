/**
* @description IH class for IPCQChargeEnquirySummary
* @author  Taras Kuliievych
* @since 2021-07-14
**/
public with sharing class IPCQChargeEnquirySummary_IH_v1 {
    //Integration service name.
    public static final String INTEGRATION_SERVICE_NAME = 'IPCQChargeEnquirySummary';

    /**
    * @description
    * @author Taras Kuliievych | 08-31-2021
    * @param accountNumber
    * @param firstDate
    * @param lastDate
    * @param currencyCode
    * @param accountType
    * @param clientName
    * @return String
    **/
    public static String callToIPCQChargeEnquirySummary(String accountNumber, String firstDate, String lastDate, String currencyCode, String accountType,String clientName) {
        Map<String, String> bodyChanges = new Map<String, String>{
            '"IPCQChargeEnquirySummaryResponse":{' => '"accountNumber":"' + accountNumber+ '","firstDate":"' + firstDate
            + '","lastDate":"' + lastDate + '","currencyCode":"' + currencyCode + '","accountType":"' + accountType + '","clientName":"'
            + clientName + '","IPCQChargeEnquirySummaryResponse":{'
        };

        firstDate = firstDate.replace('-','');
		lastDate = lastDate.replace('-','');

        IPCQChargeEnquirySummary_Req_IB_v1 requestBean = IPCQChargeEnquirySummary_IU_v1.mapRequestFields(accountNumber, firstDate, lastDate);

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean,
            null,
            null,
            INTEGRATION_SERVICE_NAME,
            IPCQChargeEnquirySummary_Resp_IB_v1.class,
            bodyChanges);

        String responseBean = integrationUtility.serializedIntegrationServiceCall();

        return responseBean;
    }
}