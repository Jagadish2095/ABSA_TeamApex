/*
 * Integration Handler for ExperianBusinessDetailsGet Service
 * @author Prashant Jain
 * @created 2019-12-05
 * @update 2020-09-10 updated to use new integration framework
 */

public class ExperianBusinessDetailsGet_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'Experian Business Details Get';

    public static ExperianBusinessDetailsGet_Resp_IB_v1 ExperianBusinessDetailsGet(String registrationNumber) {
        String endpointSuffix = '?registrationNumber=' + registrationNumber + '&timeLimit=3';
        ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = (ExperianBusinessDetailsGet_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(null, endpointSuffix, INTEGRATION_SERVICE_NAME, ExperianBusinessDetailsGet_Resp_IB_v1.class);
        return responseBean;
    }
}