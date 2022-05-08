/**
 * @description Integration response class for LDPgetAccountInfoV2
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date January 2021
 */
public class LDPgetAccountInfoV2_Resp_IB_v1 extends Base_IB {
	public cls_LDPgetAccountInfoV2Response LDPgetAccountInfoV2Response;
    /**
     * @description cls_LDPgetAccountInfoV2Response Description
     *
     */
    public class cls_LDPgetAccountInfoV2Response{
        public cls_ld300a3o ld300a3o;
        public cls_nbsapdpo nbsapdpo;
    }
    /**
     * @description cls_ld300a3o Description
     *
     */
    public class cls_ld300a3o{
        public String accountNumber;
        public Decimal accountTotBalance;
        public String accountTotExpiryDate;
        public Decimal accountTotLimit;
        public String accountTotReviewDate;
        public String clientCode;
        public List<cls_contractData> contractData;
        public String errorLine1;
        public String errorLine2;
        public String errorLine3;
        public String errorNumber;
        public Integer numberOfContracts;
        public String recordId;
        public String recordIde;
        public String recordNumber1;
    }
    /**
     * @description cls_contractData Description
     *
     */
    public class cls_contractData{
        public Decimal contractAmount;
        public Decimal contractBalance;
        public String contractExpiryDate;
        public String contractNumber;
        public String contractProdCode;
        public String contractProdType;
        public String contractSubProduct;
    }
    /**
     * @description cls_nbsapdpo Description
     *
     */
    public class cls_nbsapdpo {
        public String echoKey;
        public Integer reasonCode;
        public Integer returnCode;
        public String serviceVersion;
        public String version;
    }
}