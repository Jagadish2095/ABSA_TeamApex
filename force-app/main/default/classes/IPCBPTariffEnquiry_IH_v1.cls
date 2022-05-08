/**
 * @description       : IPCBPTariffEnquiry_IH_v1
 * @author            : Taras Kuliievych
 * @last modified on  : 2021-10-18
 * @last modified by  : André Pietersen (IQ Business)
**/
public with sharing class IPCBPTariffEnquiry_IH_v1 extends Base_IB {
    //Integration service name.
    public static final String INTEGRATION_SERVICE_NAME = 'IPCBPTariffEnquiry';

    /**
    * @description call to IPCBPTariffEnquiry using Account Number
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @param accountNumber
    * @param staff
    * @param cifKey
    * @param clientName
    * @return String
    **/
    public static String callToIPCBPTariffEnquiryAccountNumber(String accountNumber, String staff, String cifKey, String clientName) {
        IPCBPTariffEnquiry_Req_IB_v1 requestBean = IPCBPTariffEnquiry_IU_v1.mapRequestFields(accountNumber, '');
        Map<String, String> bodyChanges = new Map<String, String>{
            '"IPCBPTariffEnquiryResponse":{' => '"Salesforce":{"staff":"' + staff
            + '","cifKey":"' + cifKey + '","clientName":"'+ clientName + '"},"IPCBPTariffEnquiryResponse":{',
            '"ChargeCode":{' => '"ChargeCode":[{',
            '},"GroupDescription"' => '}],"GroupDescription"',
            '"GroupCode":{' => '"GroupCode":[{',
            '},"accountId"' => '}],"accountId"'
        };

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean,
            null,
            null,
            INTEGRATION_SERVICE_NAME,
            IPCBPTariffEnquiry_Resp_IB_v1.class,
            bodyChanges);

        String responseBean = integrationUtility.serializedIntegrationServiceCall();

        return responseBean;
    }

    /**
    * @description call to IPCBPTariffEnquiry using Pricing Scheme
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @param pricingScheme
    * @param staff
    * @param cifKey
    * @param clientName
    * @return String
    **/
    public static String callToIPCBPTariffEnquiryPricingScheme(String pricingScheme, String staff, String cifKey, String clientName) {
        IPCBPTariffEnquiry_Req_IB_v1 requestBean = IPCBPTariffEnquiry_IU_v1.mapRequestFields(null, pricingScheme);
        Map<String, String> bodyChanges = new Map<String, String>{
            '"IPCBPTariffEnquiryResponse":{' => '"Salesforce":{"staff":"' + staff
            + '","cifKey":"' + cifKey + '","clientName":"' + clientName + '"},"IPCBPTariffEnquiryResponse":{',
            '"ChargeCode":{' => '"ChargeCode":[{',
            '},"GroupDescription"' => '}],"GroupDescription"',
            '"GroupCode":{' => '"GroupCode":[{',
            '},"accountId"' => '}],"accountId"'
        };

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean,
            null,
            null,
            INTEGRATION_SERVICE_NAME,
            IPCBPTariffEnquiry_Resp_IB_v1.class,
            bodyChanges);

        String responseBean = integrationUtility.serializedIntegrationServiceCall();

        return responseBean;
    }

    /**
    * @description call to IPCBPTariffEnquiry using Pricing Scheme
    * @author  Taras Kuliievych
    * @since 2021-07-14
    * @param pricingScheme
    * @param staff
    * @param cifKey
    * @param clientName
    * @return String
    **/
    public static IPCBPTariffEnquiry_Resp_IB_v1 callToIPCBPTariffEnquiryPricingSchemeToListChargeCodes(String pricingScheme, String staff, String cifKey, String clientName) {
        IPCBPTariffEnquiry_Req_IB_v1 requestBean = IPCBPTariffEnquiry_IU_v1.mapRequestFields(null, pricingScheme);
        Map<String, String> bodyChanges = new Map<String, String>{
                '"ChargeCode":[{' => '"ChargeCodesList":[{',
                '"GroupCode":{' => '"GroupCode":[{',
                 '},"accountId"' => '}],"accountId"'
            };

        SMIntegrationUtility integrationUtility = new SMIntegrationUtility(
            requestBean,
            null,
            null,
            INTEGRATION_SERVICE_NAME,
            IPCBPTariffEnquiry_Resp_IB_v1.class,
            bodyChanges);

        IPCBPTariffEnquiry_Resp_IB_v1  responseBean = (IPCBPTariffEnquiry_Resp_IB_v1)integrationUtility.deserializedIntegrationServiceCall();

        return responseBean;
    }
}