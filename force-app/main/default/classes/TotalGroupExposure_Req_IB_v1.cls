/**
 * @description       : Request Integration Bean for TotalGroupExposure Service
 * @author            : Thabo Senkomane
 * @last modified on  : 2021-06-11
 * @last modified by  : Thabo Senkomane
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   2021-06-11   Thabo Senkomane   Initial Version
**/

public class TotalGroupExposure_Req_IB_v1  extends Base_IB{
    public List<ClientProfile> clientProfile;
     /**
 * @description       : Inner class with params
 * @author            : Thabo Senkomane
 **/
    public class ClientProfile {
        public String clientCode;
        public String primaryClientCode;
        public String ultimatePrimaryClientCode;
        public Double tgae;
        public Double tgbe;
        public Double tge;
        public Double tgie;
        public Double tgoe;
    }

    /**
    * @description :Method to create dummy request
    * @author Thabo Senkomane | 2021-06-11 
    * @return TotalGroupExposure_Req_IB_v1 
    **/
    public static TotalGroupExposure_Req_IB_v1 createDummyRequest() {
        String jsonString = '{"clientProfile":[{"clientCode":"REBELLO001","primaryClientCode":"REBELLO001","tgae":100,"tgbe":100,"tge":100,"tgie":100,"tgoe":100,"ultimatePrimaryClientCode":"REBELLO001"},{"clientCode":"AAS124","primaryClientCode":"AAS124","tgae":100,"tgbe":100,"tge":100,"tgie":100,"tgoe":100,"ultimatePrimaryClientCode":"AAS124"}]}';
        TotalGroupExposure_Req_IB_v1 requestBean = (TotalGroupExposure_Req_IB_v1)JSON.deserializeStrict(jsonString, TotalGroupExposure_Req_IB_v1.class);

        return requestBean;
    }
}