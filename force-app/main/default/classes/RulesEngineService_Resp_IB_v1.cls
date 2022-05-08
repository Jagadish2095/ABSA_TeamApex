/*
 * Resp Bean for RulesEnginePOC Service
 * @author Saurabh Pandey
 * @created 2020-05-26
 */

public class RulesEngineService_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    public List<Body> body;

	public class Body {
		public String decisionId;
		public String decisionName;
		public String result;
		public String evaluationStatus;
	}

/*
	@AuraEnabled public String decisionId;
	@AuraEnabled public String decisionName;
	@AuraEnabled public String result;
	@AuraEnabled public List<Messages> messages;
	@AuraEnabled public String evaluationStatus;
                 public class Messages {
	}
*/
    /*public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"decision-name":', '"decision_name":');
        fieldNameSubstitutionMap.put('"decision-id":', '"decision_id":');
        fieldNameSubstitutionMap.put('"model-name":', '"model_name":');
        fieldNameSubstitutionMap.put('"model-namespace":', '"model_namespace":');
        fieldNameSubstitutionMap.put('"dmn-evaluation-result":', '"dmn_evaluation_result":');
        fieldNameSubstitutionMap.put('"dmn-message-severity":', '"dmn_message_severity":');
        fieldNameSubstitutionMap.put('"message-type":', '"message_type":');
        fieldNameSubstitutionMap.put('"source-id":', '"source_id":');
        fieldNameSubstitutionMap.put('"model-namespace":', '"model_namespace":');
        fieldNameSubstitutionMap.put('"model-name":', '"model-name":');
        fieldNameSubstitutionMap.put('"dmn-context":', '"dmn_context":');
        fieldNameSubstitutionMap.put('"decision-results":', '"decision_results":');

        fieldNameSubstitutionMap.put('"_43E7DD07-6150-419F-8E12-5AC01258C1AA":', '"x_43E7DD07_6150_419F_8E12_5AC01258C1AA":');
        fieldNameSubstitutionMap.put('"_70C97339-8373-4D64-AB61-534E6F5E8C3C":', '"x_70C97339_8373_4D64_AB61_534E6F5E8C3C":');
        fieldNameSubstitutionMap.put('"_8352CC8A-BEAD-493B-8AC4-A0C27C80B117":', '"x_8352CC8A_BEAD_493B_8AC4_A0C27C80B117":');
        fieldNameSubstitutionMap.put('"_E0630042-E9E0-4668-9F97-A83209F0CC8E":', '"x_E0630042_E9E0_4668_9F97_A83209F0CC8E":');
        fieldNameSubstitutionMap.put('"_F8299673-69DE-4B8B-B67F-4A8BBB840D0B":', '"x_F8299673_69DE_4B8B_B67F_4A8BBB840D0B":');
        fieldNameSubstitutionMap.put('"_A3254AF6-49DD-42BC-B8EC-D44AE1F2CD8B":', '"x_A3254AF6_49DD_42BC_B8EC_D44AE1F2CD8B":');
        fieldNameSubstitutionMap.put('"_49C14D30-146F-4F8D-9BD4-6416569CF2E8":', '"x_49C14D30_146F_4F8D_9BD4_6416569CF2E8":');
    } */
}