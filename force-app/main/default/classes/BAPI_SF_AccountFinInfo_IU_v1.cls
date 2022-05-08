/**
* @description Integartion utility for BAPI_SF_AccountFinInfo_IU_v1 class
* @author Bhanumurty Rayala
* @created 2021-06-08
*/
public class BAPI_SF_AccountFinInfo_IU_v1 {
/**
* @description 
* @param accountNumber String
* @param abNumber String
* @return requestBean object
*/
    public static BAPI_SF_AccountFinInfo_Req_IB_v1 mapRequestFields(String accountNumber, String abNumber){
        BAPI_SF_AccountFinInfo_Req_IB_v1 requestBean = new BAPI_SF_AccountFinInfo_Req_IB_v1();
        requestBean.BAPI_SF_IF42 = new BAPI_SF_AccountFinInfo_Req_IB_v1.BAPI_SF_IF42();
        requestBean.BAPI_SF_IF42.I_ACCOUNT = accountNumber.leftPad(11, '0');
        requestBean.BAPI_SF_IF42.I_USER = abNumber;
        return requestBean;
    }
}