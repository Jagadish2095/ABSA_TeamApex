/**
* @description Integartion handler for BAPI_SF_AccountFinInfo_IH_v1 class
* @author Bhanumurty Rayala
* @created 2021-06-08
*/
public class BAPI_SF_AccountFinInfo_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'BAPI SF Account Financial Information';
    /**
* @description 
* @param accountNumber String
* @param abNumber String
* @return responseBean object
*/
    public static BAPI_SF_AccountFinInfo_Resp_IB_v1 accountFinancialInformation(String accountNumber, String abNumber){
        BAPI_SF_AccountFinInfo_Req_IB_v1 requestBean = BAPI_SF_AccountFinInfo_IU_v1.mapRequestFields(accountNumber, abNumber);
        BAPI_SF_AccountFinInfo_Resp_IB_v1 responseBean = (BAPI_SF_AccountFinInfo_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, BAPI_SF_AccountFinInfo_Resp_IB_v1.class);
        return responseBean;
    }
}