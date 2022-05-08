/*
* Response Bean for NCA Retrive Service
* @author Almas Aleem
* @created 2020-11-26
*/
public class GetNCARetrieve_Resp_IB_v1 extends Base_IB{
    @auraEnabled public String type_Z ; // in json: type
    @auraEnabled public String msg ; 
    @auraEnabled public Result result ; 


 public class Results {
    @auraEnabled public String key ; 
    @auraEnabled public Value value ; 
}

 public class Value {
    @auraEnabled public Za_co_absa_brms_nca_NcaDecision za_co_absa_brms_nca_NcaDecision ; // in json: za.co.absa.brms.nca.NcaDecision
}

 public class Execution_results {
    @auraEnabled public List<Results> results ; 
    @auraEnabled public List<Facts> facts ; 
}

 public class Za_co_absa_brms_nca_NcaDecision {
    @auraEnabled public String result ; 
    @auraEnabled public String juristic ; 
    
}

 public class Facts {
}

public class Result {
    @auraEnabled public Execution_results execution_results ; // in json: execution-results
}
public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"type":', '"type_Z":');
        fieldNameSubstitutionMap.put('"za.co.absa.brms.nca.NcaDecision":', '"za_co_absa_brms_nca_NcaDecision":');
        fieldNameSubstitutionMap.put('"execution-results":', '"execution_results":');
       
	}
}