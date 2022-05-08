/**
* @description       : 
* @author            : Mradul Maheshwari
* @last modified on  : 08-23-2021
* @last modified by  : Mradul Maheshwari
* @Work Id           : W-005674
**/
public with sharing class CalculatorRequest_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'Calculator Request';
    /**
* @description
* @author Mradul Maheshwari | 08-18-202
* @param accountNumber
* @param advanceAmount
* @return CalculatorRequest_Resp_IB_v1
**/
    public static CalculatorRequest_Resp_IB_v1 calculatorRequest(String accountNumber, String advanceAmount){
        CalculatorRequest_Req_IB_v1 requestBean = CalculatorRequest_IU_v1.mapRequestFields(accountNumber, advanceAmount);
        CalculatorRequest_Resp_IB_v1 responseBean = (CalculatorRequest_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
            requestBean,
            INTEGRATION_SERVICE_NAME,
            CalculatorRequest_Resp_IB_v1.class
        );
        
        return responseBean;
    }
}