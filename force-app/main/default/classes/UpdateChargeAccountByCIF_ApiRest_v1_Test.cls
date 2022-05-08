/**
* @description Test class for UpdateChargeAccountByCIF_ApiRest_v1
* @author Koketso Mpshane
* @date 27/08/2021
*/
@isTest
public class UpdateChargeAccountByCIF_ApiRest_v1_Test {
    
    @isTest 
    static void testPositiveUpdateChargeAccount(){
        
        Account acc = new Account(Name = 'test Account', CIF__c = 'JINPIX 001');
        insert acc;
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('sourceSystem', 'IVR');
        gen.writeStringField('cifCode', 'JINPIX 001');
        gen.writeStringField('telebankingChargeAccountNumber', '12589');
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        
        RestRequest request = new RestRequest();
        
        request.requestUri ='/services/apexrest/UpdateChargeAccountByCIF/v01/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonString);
        
        Test.startTest();
        RestContext.request = request;
        UpdateChargeAccountByCIF_ApiRest_v1.ResponseStatus response = UpdateChargeAccountByCIF_ApiRest_v1.updateChargeAccount();
        Test.stopTest();
        
        System.assertEquals(true, response.isSuccess, 'Assert Failed');
        
    }
    
    @isTest 
    static void testNegativeUpdateChargeAccount(){
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('sourceSystem', 'IVR');
        gen.writeStringField('cifCode', 'JINPIX 001');
        gen.writeStringField('telebankingChargeAccountNumber', '12589');
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        
        RestRequest request = new RestRequest();
        
        request.requestUri ='/services/apexrest/UpdateChargeAccountByCIF/v01/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonString);
        
        Test.startTest();
        RestContext.request = request;
        UpdateChargeAccountByCIF_ApiRest_v1.ResponseStatus response = UpdateChargeAccountByCIF_ApiRest_v1.updateChargeAccount();
        Test.stopTest();
        
        System.assertEquals(false, response.isSuccess, 'Assert Failed');
        
    }

}