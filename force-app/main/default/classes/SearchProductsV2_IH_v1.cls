/*
 * Integration Handler for SearchProductsV2 Service
 * @author Jabulani Mashia
 * @created 2020-10-30
 */

public class SearchProductsV2_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'SearchProductsV2';

    public static SearchProductsV2_Resp_IB_v1 SearchProductsV2(SearchProductsV2_Req_IB_v1 requestBean) {
        SearchProductsV2_Resp_IB_v1 responseBean = (SearchProductsV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, SearchProductsV2_Resp_IB_v1.class);
        return responseBean;
    }
}