/**
 * @description       : Reponse class for Product Type Exposures
 * @author            : Gopi
 * @last modified on  : 2021-06-11
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-11   Englarmerdge Mongwe   Initial Version
**/
public class GetProductExposureAggre_Resp_IB_v1 extends Base_IB{

	public List<Client> client;
    /**
 * @description       : Inner class client with params aggregation and clientcode
 * @author            : Gopi
 **/
	public class Client {
		public List<ClientProfile> clientProfile;
		public List<Aggregation> aggregation;
		public String name;
	}
    /**
 * @description       : Inner class ClientProfile with params aggregation and clientcode
 * @author            : Gopi
 **/
    public class ClientProfile {
		public List<Aggregation> aggregation;
		public String clientCode;
	}
    /**
 * @description       : Inner class with Exposure params
 * @author            : Gopi
 **/
	public class Aggregation {
		public String type_z;
		public Decimal installment;
		public Decimal liability;
		public Decimal arrears;
        public Decimal exposure;
		public Decimal limit_z;
        public Decimal excess;
	}

    /**
    * @description : Method to set Field names
    * @author Gopi| 2021-06-11 
    **/
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"limit":', '"limit_z":');
        fieldNameSubstitutionMap.put('"type":', '"type_z":');
    }
}