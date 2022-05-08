/**
 * @description       : Utility class for GetProductExposure service
 * @author            : Gopi
 * @last modified on  : 2021-06-11

**/

public class GetProductExposureAggre_IU_v1 {

    /**
    * @description :Method to map request fields
    * @author Gopi | 2021-06-11 
    * @param applicationExposures 
    * @param newAppProfList 
    * @return GetProductExposureAggre_Req_IB_v1 
    **/
    public static GetProductExposureAggre_Req_IB_v1 mapRequestFields(List<Application_Exposure__c> applicationExposures, List<Application_Profile__c> newAppProfList) {
        GetProductExposureAggre_Req_IB_v1 reqBean = new GetProductExposureAggre_Req_IB_v1();
        List<GetProductExposureAggre_Req_IB_v1.Client> clientsList = new List<GetProductExposureAggre_Req_IB_v1.Client>();
        List<GetProductExposureAggre_Req_IB_v1.ClientProfile> clientProfilesList = new List<GetProductExposureAggre_Req_IB_v1.ClientProfile>();
        List<GetProductExposureAggre_Req_IB_v1.Product> productsList = new List<GetProductExposureAggre_Req_IB_v1.Product>();
        GetProductExposureAggre_Req_IB_v1.Client client = new GetProductExposureAggre_Req_IB_v1.Client();
        GetProductExposureAggre_Req_IB_v1.ClientProfile clientProfile = new GetProductExposureAggre_Req_IB_v1.ClientProfile();
        GetProductExposureAggre_Req_IB_v1.Product product = new GetProductExposureAggre_Req_IB_v1.Product();
        GetProductExposureAggre_Req_IB_v1.Aggregation aggregation = new GetProductExposureAggre_Req_IB_v1.Aggregation();

        String clientName = '', prevIdRegNumer = null, clientCode = null;

        for(Application_Profile__c appProfile : newAppProfList) {

            if((prevIdRegNumer  != null) && prevIdRegNumer != appProfile.Related_to_Client_ID_or_Reg_Number__c) {
                System.debug('prevIdRegNumer:::: ' + prevIdRegNumer + ' currIdRegNumer::: ' + appProfile.Related_to_Client_ID_or_Reg_Number__c);
                if(clientName != '' && clientProfilesList.size() > 0) {
                    System.debug('clientName:::: ' + clientName);
                    client.clientProfile = clientProfilesList;
                    client.name = clientName;
                    clientsList.add(client);

                    clientProfilesList = new List<GetProductExposureAggre_Req_IB_v1.ClientProfile>();
                    client = new GetProductExposureAggre_Req_IB_v1.Client();
                }
            }

            if(appProfile.Applicant_Type__c == 'Main Applicant') {
                clientName = appProfile.Client_Name__c;
                prevIdRegNumer = appProfile.Related_to_Client_ID_or_Reg_Number__c;
            }

            if(appProfile.Applicant_Type__c == 'Principal') {
                clientName = appProfile.Client_Name__c;
                prevIdRegNumer = appProfile.Related_to_Client_ID_or_Reg_Number__c;
            }
            
            if(appProfile.Applicant_Type__c == 'Spouse') {
                clientName = appProfile.Client_Name__c;
                prevIdRegNumer = appProfile.Related_to_Client_ID_or_Reg_Number__c;
            }


            productsList = new List<GetProductExposureAggre_Req_IB_v1.Product>();

            for(Application_Exposure__c applicationExposure : applicationExposures) {
                if(applicationExposure.Client_Code__c == appProfile.Client_CIF_Code__c) {
                    if(applicationExposure.exposure_data_type__c == StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT) {
                        product = new GetProductExposureAggre_Req_IB_v1.Product();
                        product.arrears = Long.valueOf(applicationExposure.Arrears__c);
                        product.excess = Long.valueOf(applicationExposure.Excess__c);
                        product.exposure = Long.valueOf(applicationExposure.Exposure__c);
                        product.installment = Long.valueOf(applicationExposure.Installment__c);
                        product.liability = Long.valueOf(applicationExposure.Liability__c);
                        product.limit_z = Long.valueOf(applicationExposure.Limit__c);
                        product.subIndicator = (applicationExposure.subIndicator__c == null ? '' : applicationExposure.subIndicator__c);
                        product.productCode = applicationExposure.Product__c;
                        productsList.add(product);
                    }
                }
            }

            if(productsList.size() > 0) {
                System.debug('Client_CIF_Code__c:::: ' + appProfile.Client_CIF_Code__c + ' clientCode::: ' + clientCode + ' productsList size:::: ' + productsList.size());
                clientProfile.clientCode = appProfile.Client_CIF_Code__c;
                aggregation.type_z = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_ORDINARY_CREDIT_TOTAL;
                clientProfile.aggregation = aggregation;
                clientProfile.product = productsList;
                clientProfilesList.add(clientProfile);
                clientCode =  clientProfile.clientCode;

                aggregation = new GetProductExposureAggre_Req_IB_v1.Aggregation();
                productsList = new List<GetProductExposureAggre_Req_IB_v1.Product>();
                clientProfile = new GetProductExposureAggre_Req_IB_v1.ClientProfile();
            }
        }

        if(clientName != '') {
            System.debug('clientName:::: ' + clientName);
            client.clientProfile = clientProfilesList;
            client.name = clientName;
            clientsList.add(client);
        }

        reqBean.client = clientsList;
        System.debug('mapRequestFields reqBean :::: ' + JSON.serializePretty(reqBean));
        return reqBean;
    }
}