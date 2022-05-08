/*
* Service implemention for idNumber for package linking
* @author Satya Boyenepalli
* @created 2021-02-26
*/
public class idNumber_IH_v1 {
 public static final String INTEGRATION_SERVICE_NAME = 'idNumber';
     public static idNumber_Resp_IB_v1 GetLinkProductsByIdnumber(idNumber_Req_IB_v1 requestBean) {
        idNumber_Resp_IB_v1 responseBean = (idNumber_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, idNumber_Resp_IB_v1.class);
        System.debug('Satya package product respone:' +  JSON.serializePretty(responseBean));
         return responseBean;
    }

}