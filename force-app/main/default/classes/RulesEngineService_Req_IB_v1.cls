/**
 *  @description Req Bean for RulesEngine Service
 * @author Saurabh Pandey
 * @created 2020-05-26
 */

public class RulesEngineService_Req_IB_v1 extends Base_IB {
	
    public String bankingSector;
	public String businessArea;
	public String businessSegment;
	public String businessSubSegments;
	public String clientType;
	public String clientTypeGroup;
	public String sic;
    
    
    //Saurabh : 2021/02/09 Modifying as per the new service structure
    public String model_namespace;
	public String model_name;
	public List<Decision_name> decision_name ;
	public List<Decision_name> decision_id ; 
	public Dmn_context dmn_context ;
    
     /**
    * @description 
    * @author 
    * */
    public class Dmn_context {
        public String ClientTypeGroup;
		public String ClientType;
		public String BusinessSegments;
		public String BankingSector; 
		public String Sic; 
		public String BusinessSubSegment; 
		public String BusinessArea; 
    }
     /**
    * @description 
    * @author 
    * */
    public class decision_name {
    }
     /**
    * @description 
    * @author 
    * */
    public class decision_id{
        
    }
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"decision-name":', '"decision_name":');
        fieldNameSubstitutionMap.put('"decision-id":', '"decision_id":');
        fieldNameSubstitutionMap.put('"Dmn-context":', '"Dmn_context":');
        fieldNameSubstitutionMap.put('"model-name":', '"model_name":');
        fieldNameSubstitutionMap.put('"model-namespace":', '"model_namespace":');
    }
     /**
    * @description 
    * @author 
    * @return RulesEngineService_Req_IB_v1
    * */
    public static RulesEngineService_Req_IB_v1 createDummyRequest() {
        RulesEngineService_Req_IB_v1 requestBean = new RulesEngineService_Req_IB_v1();
        requestBean.bankingSector = '01';
	    requestBean.businessArea = 'H';
        requestBean.businessSegment = '';
	    requestBean.businessSubSegments = '';
	    requestBean.clientType = '02301';
	    requestBean.clientTypeGroup = 'N';
	    requestBean.sic = '41300';
        return requestBean;
        
    }
}