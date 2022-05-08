/**
 * Integration Utility for BusinessTrace Service
 * @author Englarmerdge Mongwe
 * @created 2021-01-08
 */
public class BusinessTrace_IU_v1 {
   /** 
     * Creates a request bean
     * @param: businessName
     * @param: searchWord1
     * @param: searchWord2
     * @param: searchWord3
     * @return: BusinessTrace_Req_IB_v1 bean object
     */
    public static BusinessTrace_Req_IB_v1 mapRequestFields(String businessName, String searchWord1, String searchWord2, String searchWord3) {

        BusinessTrace_Req_IB_v1 requestBean = new BusinessTrace_Req_IB_v1();
        requestBean.BusinessTrace = new BusinessTrace_Req_IB_v1.BusinessTrace();

		requestBean.BusinessTrace.Username = 'ABSACOMMTEST';
		requestBean.BusinessTrace.Password = 'no5@8FV';
		requestBean.BusinessTrace.BusinessName = businessName;
		requestBean.BusinessTrace.SearchByIndicator = ' ';
		requestBean.BusinessTrace.SearchByValue = ' ';
		requestBean.BusinessTrace.SearchWord1 = searchWord1;
		requestBean.BusinessTrace.SearchWord2 = searchWord2;
		requestBean.BusinessTrace.SearchWord3 = searchWord3;
		requestBean.BusinessTrace.SearchSubsidiaryFile = '0';
		requestBean.BusinessTrace.TimeoutLimit = '0';
		requestBean.BusinessTrace.CustomerReference = 'ABSA TRACE';

        System.debug('BusinessTrace Request Bean: ' + requestBean);
        return requestBean;
    }
}