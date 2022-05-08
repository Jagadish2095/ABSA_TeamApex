/*
 * Response Integration Bean for AvafDebitOrderDetails Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
public class AvafGetDebitOrderDetails_Resp_IB_v1 extends Base_IB{

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public BAPI_SF_DO_DETAILS[] BAPI_SF_DO_DETAILS;
    @AuraEnabled public String E_RESPONSE;
    @AuraEnabled public String E_RESPONSE_DESC;

    public class BAPI_SF_DO_DETAILS{
        @AuraEnabled public String ZDEBIT_ORDER;
        @AuraEnabled public String ZCOLDAY;
        @AuraEnabled public String ZCOLSTARTDATE;
        @AuraEnabled public String ZCOLENDDATE;
        @AuraEnabled public String ZCOLAMOUNT;
        @AuraEnabled public String ZCOLBANKID;
        @AuraEnabled public String ZBANKACC;
        @AuraEnabled public String ZSTATUS;
    }

    public override void setFieldNameSubstitutions(){
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('ZCOLBANKID___', 'ZCOLBANKID');
        fieldNameSubstitutionMap.put('ZBANK_ACC_', 'ZBANKACC');
        fieldNameSubstitutionMap.put('ZSTATUS______', 'ZSTATUS');
    }

    public override void setIntegrationTranslations(){

        integrationTranslationsMap = new Map<String,String>();
        integrationTranslationsMap.put('BAPI_SF_DO_DETAILS.ZDEBIT_ORDER', 'SAP;Debit Order Type');
    }
}