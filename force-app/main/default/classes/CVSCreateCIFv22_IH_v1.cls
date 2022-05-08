/**
* @description CVSCreateCIFv22_IH_v1 Service
* @author  Paul John du Randt : ABSA (IQ Business)
* @version v1.0
* @since 2020-09-18
* @edit 2021-05-20
*/
public class CVSCreateCIFv22_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'CVSCreateCIFV22';
    /**
    * @description CVSCreateCIFv22 Create CIF
    * @author Paul John du Randt | 2020-09-18
    * @param requestBean
    * @return CVSCreateCIFv22_Resp_IB_v1
    **/
    public static CVSCreateCIFv22_Resp_IB_v1 CVSCreateCIFv22(CVSCreateCIFv22_Req_IB_v1 requestBean) {
       return CVSCreateCIFv22(requestBean,'individual');
    }
    /**
    * @description CVSCreateCIFv22 Create CIF overload method that accepts clientGroup
    * @author Paul John du Randt | 2020-05-20
    * @param requestBean
    * @param clientGroup
    * @return CVSCreateCIFv22_Resp_IB_v1
    **/
    public static CVSCreateCIFv22_Resp_IB_v1 CVSCreateCIFv22(CVSCreateCIFv22_Req_IB_v1 requestBean,string clientGroup) {
        string usr = System.UserInfo.getUserId();
        User userInfo = [SELECT Teller_Operator_Code__c, SiteCode__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];
        Map<String,String> headers = new Map<String,String>();
        headers.put('applicationId','Salesforce');
        headers.put('canary','always');
        headers.put('tellerId',String.valueOf(userInfo.Teller_Operator_Code__c));
        headers.put('clientGroup',clientGroup);
        headers.put('branch',String.valueOf(userInfo.SiteCode__c));
        CVSCreateCIFv22_Resp_IB_v1 responseBean = (CVSCreateCIFv22_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, Headers, INTEGRATION_SERVICE_NAME, CVSCreateCIFv22_Resp_IB_v1.class);
        return responseBean;
    }
}