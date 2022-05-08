/*
* Response Integration Bean for AvafAddBankDetails Service
* @author Humbelani Denge
* @created 2020-11-19
*/
public class AvafAddBankDetails_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public BAPI_BUPA_BANKDETAIL_ADD BAPI_SF_DO_BUPA_BANKDETAIL_ADD;

    public class BAPI_BUPA_BANKDETAIL_ADD {
        @AuraEnabled public String BANKDETAILIDOUT;
        @AuraEnabled public List<RETURN_z> RETURN_z;
    }

    public class RETURN_z {
        @AuraEnabled public String TYPE_z;
        @AuraEnabled public String ID_z;
        @AuraEnabled public String NUMBER_z;
        @AuraEnabled public String MESSAGE;
    }

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map <String,String>();
        fieldNameSubstitutionMap.put('TYPE','TYPE_z');
        fieldNameSubstitutionMap.put('"ID"','"ID_z"');
        fieldNameSubstitutionMap.put('RETURN','RETURN_z');
    }
}