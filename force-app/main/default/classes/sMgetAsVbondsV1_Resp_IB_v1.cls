/**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 * @author            : Prashant Jain
 * @created 2020-03-03
 **/


public class sMgetAsVbondsV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 **/
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public SMgetASVbondsV1Response SMgetASVbondsV1Response;
    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 **/
	public class SMgetASVbondsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smn145o smn145o;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 **/
	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 **/
	public class Smn145o {
		public String tnomVal;
		public String tsecVal;
		public String tasvVal;
		public String tmasvVal;
		public List<BondTable> bondTable;
	}
    /**
 * @description       : Request Integration Bean for sMgetAsVbondsV1 Service
 **/
	public class BondTable {
		public String specific;
        public String status;
		public String bondHoldCd;
		public String titleDeed;
		public String propdesc;
        public String bondType;
        public String valueBy;
        public String propType;
		public String bondRegnum;
        public String pb1Acc;
		public String seqno;
		public String regDt;
		public String bondRank;
		public String realmv;
		public String nomVal;
		public String secVal;
		public String asecVal;
		public String masecVal;
		public String refNo;
		public String houseSchm;
		public String costClval;
		public String svperc;
		public String asvperc;
        public String ApplicationId;
        public String clcd;
	}
}