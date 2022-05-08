/*
 * Response Integration Bean for ABSAOnlineStatementDownload Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

public class ABSAOnlineStatementDownload_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public String timestamp;
    @AuraEnabled public Integer status_Z; // in json: status
    @AuraEnabled public String error;

    @AuraEnabled public String listRef;
    @AuraEnabled public String doc;
    @AuraEnabled public Integer pages;
    @AuraEnabled public Integer size;

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"status":', '"status_Z":');
    }
}