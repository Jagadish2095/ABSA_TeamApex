/*
* Integration Handler for ABFgetQuoteInfoForEspV5 Service to Calculate the Quotes for Term Loan
* @author Himanshu Nimje
* @created 2020-12-02
*/

public class ABFgetQuoteInfoForEspV5_IH_V1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'ABF get Quote Info For ESP';
    

    public static ABFgetQuoteInfoForEspV5_Resp_IB_V1 ABFgetQuoteInfoForEspV5( ABFgetQuoteInfoForEspV5_Req_IB_V1  requestBeanP){
       ABFgetQuoteInfoForEspV5_Resp_IB_V1 responseBean = (ABFgetQuoteInfoForEspV5_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBeanP, null, INTEGRATION_SERVICE_NAME, ABFgetQuoteInfoForEspV5_Resp_IB_V1.class);
    return responseBean;
 
    }

}