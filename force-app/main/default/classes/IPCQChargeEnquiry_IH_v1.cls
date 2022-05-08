/**
* @description IPCQChargeEnquiry IH class
* @author  Taras Kuliievych
* @since 2021-07-14
**/
public with sharing class IPCQChargeEnquiry_IH_v1 {

    //Integration service name
    public static final String INTEGRATION_SERVICE_NAME = 'IPCQChargeEnquiry';

    /**
    * @description
    * @author Taras Kuliievych | 09-01-2021
    * @param accountNumber
    * @param firstDate
    * @param lastDate
    * @param currencyCode
    * @param accountType
    * @param accountName
    * @param clientName
    * @return String
    **/
    public static String callToIPCQChargeEnquiry(String accountNumber, String firstDate, String lastDate, String currencyCode, String accountType, String accountName, String clientName) {
        Map<String, String> bodyChanges = new Map<String, String>{
            '"IPCQChargeEnquiryResponse":{' => '"accountNumber":"' + accountNumber+ '","firstDate":"' + firstDate
            + '","accountName":"' + accountName + '","lastDate":"' + lastDate + '","currencyCode":"' + currencyCode + '","accountType":"' + accountType + '","clientName":"'
            + clientName + '","IPCQChargeEnquiryResponse":{'
        };

        firstDate = firstDate.replace('-','');
		lastDate = lastDate.replace('-','');

        IPCQChargeEnquiry_Req_IB_v1 requestBean = IPCQChargeEnquiry_IU_v1.mapRequestFields(accountNumber, firstDate, lastDate);

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean,
            null,
            null,
            INTEGRATION_SERVICE_NAME,
            IPCQChargeEnquiry_Resp_IB_v1.class,
            bodyChanges);

        String responseBean = integrationUtility.serializedIntegrationServiceCall();

        return responseBean;
    }
}