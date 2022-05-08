/*
* Service implemention for Create for package linking
* @author Satya Boyenepalli
* @created 2021-03-02
*/
public class Create_IH_v1 {
		public static final String INTEGRATION_SERVICE_NAME='PackageCreate';
    public static Create_Resp_IB_v1 CreatePackage(Create_Req_IB_v1 requestBean)
    {
        System.debug('Satya package create request:' +  JSON.serializePretty(requestBean));
        Create_Resp_IB_v1 responseBean = (Create_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, Create_Resp_IB_v1.class);
        return responseBean;
    }
    
}