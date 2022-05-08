/*
 * Request Integration Bean for SearchProductsV2 Service
 * @author Jabulani Mashia
 * @created 2020-10-30
 */

public class SearchProductsV2_Req_IB_v1 extends Base_IB {

        public SearchProductsV2RequestMsg searchProductsV2RequestMsg;

        public class SearchProductsV2RequestMsg {
            public Common common;
            public SearchProductsV2RequestDto searchProductsV2RequestDto;
        }
    
        public class SearchProductsV2RequestDto {
            public CifProductFilter cifProductFilter;
        }
    
        public class UserInfo {
            public String username;
            public String password;
        }
    
        public class CifProductFilter {
            public String productCodes;
            public String showFeatures;
            public String showRules;
        }
    
        public class Common {
            public UserInfo userInfo;
            public String channel;
            public String messageOrigin;
            public String messageLanguage;
        }

        public static SearchProductsV2_Req_IB_v1 createDummyRequest() {
            SearchProductsV2_Req_IB_v1 requestBean = new SearchProductsV2_Req_IB_v1();
            requestBean.SearchProductsV2RequestMsg = new SearchProductsV2_Req_IB_v1.SearchProductsV2RequestMsg();
            requestBean.SearchProductsV2RequestMsg.common = new SearchProductsV2_Req_IB_v1.Common();
            requestBean.SearchProductsV2RequestMsg.searchProductsV2RequestDto = new SearchProductsV2_Req_IB_v1.SearchProductsV2RequestDto();
            requestBean.SearchProductsV2RequestMsg.searchProductsV2RequestDto.cifProductFilter = new SearchProductsV2_Req_IB_v1.CifProductFilter();
            requestBean.SearchProductsV2RequestMsg.common.userInfo = new SearchProductsV2_Req_IB_v1.UserInfo();

            
            requestBean.SearchProductsV2RequestMsg.common.userInfo.username = '?';
            requestBean.SearchProductsV2RequestMsg.common.userInfo.password = '?';

            requestBean.SearchProductsV2RequestMsg.SearchProductsV2RequestDto.cifProductFilter.productCodes = '09010';
            requestBean.SearchProductsV2RequestMsg.SearchProductsV2RequestDto.cifProductFilter.showFeatures = 'true';
            requestBean.SearchProductsV2RequestMsg.SearchProductsV2RequestDto.cifProductFilter.showRules = 'true';

            requestBean.SearchProductsV2RequestMsg.common.channel = 'Branch';
            requestBean.SearchProductsV2RequestMsg.common.messageOrigin = '?';
            requestBean.SearchProductsV2RequestMsg.common.messageLanguage = 'eng';

            return requestBean;
        }
    
}