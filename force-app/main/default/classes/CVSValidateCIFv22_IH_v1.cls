/**
* @description CVSValidateCIFv22_IH_v1 Service
* @author  Paul John du Randt : ABSA (IQ Business)
* @version v1.0
* @since 2020-09-18
* @edit 2021-05-20
*/
public without sharing class CVSValidateCIFv22_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'CVSValidateCIFv22';
    /**
    * @description CVSCreateCIFv22 Validate CIF
    * @author Paul John du Randt | 2020-09-18
    * @param requestBean
    * @return CVSValidateCIFv22_Resp_IB_v1
    **/
    public static CVSValidateCIFv22_Resp_IB_v1 CVSValidateCIFv22(CVSValidateCIFv22_Req_IB_v1 requestBean) {
        return CVSValidateCIFv22(requestBean,'individual');
    }

     /**
    * @description CVSCreateCIFv22 Validate CIF overload method that accepts clientGroup
    * @author Paul John du Randt | 2020-05-20
    * @param requestBean
    * @param clientGroup
    * @return CVSValidateCIFv22_Resp_IB_v1
    **/
    public static CVSValidateCIFv22_Resp_IB_v1 CVSValidateCIFv22(CVSValidateCIFv22_Req_IB_v1 requestBean,string clientGroup) {
        string usr = System.UserInfo.getUserId();
        User userInfo = [SELECT Teller_Operator_Code__c, SiteCode__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];
        Map<String,String> headers = new Map<String,String>();
        headers.put('applicationId','Salesforce');
        headers.put('canary','always');
        headers.put('tellerId',String.valueOf(userInfo.Teller_Operator_Code__c));
        headers.put('clientGroup',clientGroup);
        headers.put('branch',String.valueOf(userInfo.SiteCode__c));
        CVSValidateCIFv22_Resp_IB_v1 responseBean = (CVSValidateCIFv22_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, headers, INTEGRATION_SERVICE_NAME, CVSValidateCIFv22_Resp_IB_v1.class);
        return responseBean;
    }
}