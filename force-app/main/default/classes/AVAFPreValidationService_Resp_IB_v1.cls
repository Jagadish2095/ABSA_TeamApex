/*
 * Request Integration Bean for preValidationServiceRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @version v2.0
 * @created 2020-11-02
 */
public class AVAFPreValidationService_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public Documents documents;
    @AuraEnabled public Integer accountNumber;

    public class Documents {
        @AuraEnabled public List<Document> document;
    }

    public class Document {
        @AuraEnabled public String message;
        @AuraEnabled public String indicator;
        @AuraEnabled public String name;
    }
}