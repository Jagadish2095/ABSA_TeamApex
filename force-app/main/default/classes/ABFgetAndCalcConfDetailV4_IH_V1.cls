/*
* Integration Handler for ABFgetAndCalcConfDetailV4 Service 
* @author Himanshu Nimje
* @created 2020-11-28
*/
public class ABFgetAndCalcConfDetailV4_IH_V1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'ABF Get Cal Conf Detail';
    
    public static ABFgetAndCalcConfDetailV4_Resp_IB_V1 ABFgetAndCalcConfDetailV4( ABFgetAndCalcConfDetailV4_Req_IB_V1  requestBeanP){
        ABFgetAndCalcConfDetailV4_Resp_IB_V1 responseBean = (ABFgetAndCalcConfDetailV4_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBeanP, null, INTEGRATION_SERVICE_NAME, ABFgetAndCalcConfDetailV4_Resp_IB_V1.class);
        return responseBean;
        
    }

}