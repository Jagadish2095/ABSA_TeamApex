/**
 * @description       : Controller for working capital aura component
 * @author            : Amit G.
 * @last modified on  : 2021-07-24
 * @last modified by  : Tawanda M.
**/

public class WorkingCapitalCalController {
    /**
     * @description Defining different methods to make the Rest API Callouts
     * @param jsonData
     * @return String
     */
    @AuraEnabled
    public static List<CalculatorResponse.Response> callRestAPI_ProcessData(String jsonData) {
		
        String requestJSON = '{"data" : { "channelCalculatorDTO" : { "workingCapital": '+ jsonData + '} } }';       
        requestJSON = requestJSON.replaceAll('"dated":', '"date":');        
        String responseJSON = JitterbitAuth_WC_V1.getResponseBody(StringConstants.INTEGRATION_PROCESSDATA_STRING, requestJSON);
        
        Map<String ,Object> mapOfData = (Map<String,Object>)JSON.deserializeUntyped(responseJSON);
        Object lstofData = mapOfData.get('data');
        Map<String ,Object> mapofResponse = (Map<String,Object>)lstofData;
        String responseToString = JSON.serialize(mapofResponse.get('response'));
        List<CalculatorResponse.Response> lstOfResponse = (List<CalculatorResponse.Response>) JSON.deserialize(responseToString, List<CalculatorResponse.Response>.class);
        CalculatorResponse.roundOffAdjustedCalculations(lstOfResponse);
        CalculatorResponse.roundOffCalculations(lstOfResponse);
        return lstOfResponse;
    }

    /**
     * @description Defining different methods to make the Rest API Callouts
     * @param days
     * @param dailyCostOfSales
     * @return Decimal
     */
    @AuraEnabled
    public static Decimal callRestAPI_AdjustedPayablesPaymentPeriod(Decimal days, Decimal dailyCostOfSales) {
        
		String requestJSON = '{ "data":{ "adjustWCNPayablesAvgDTO":{ "days":'+days+', "dailyCostOfSales":'+dailyCostOfSales+' } } } ';       
        String responseJSON = JitterbitAuth_WC_V1.getResponseBody(StringConstants.INTEGRATION_AVGPAYABLEPAYPERIOD_STRING, requestJSON);
        Map<String ,Object> mapOfData = (Map<String,Object>)JSON.deserializeUntyped(responseJSON);
        Object lstofData = mapOfData.get('adjustedResponseDTO');
        Map<String ,Object> mapofResponse = (Map<String,Object>)lstofData;
        Decimal response = Decimal.valueOf(String.valueOf(mapofResponse.get('adjPayablesPaymentPeriod'))).setScale(2);
        
        return response;
    }

    /**
     * @description Defining different methods to make the Rest API Callouts
     * @param days
     * @param dailySales
     * @return Decimal
     */
    @AuraEnabled
    public static Decimal callRestAPI_AdjustedAverageReceivableCollectionPeriod(Decimal days, Decimal dailySales) {
		
        String requestJSON = '{ "data":{ "adjustWCNReceiveAvgDTO":{ "days":'+days+', "dailySales":'+dailySales+' } } } ';       
        String responseJSON = JitterbitAuth_WC_V1.getResponseBody(StringConstants.INTEGRATION_AVGRECCOLLPERIOD_STRING, requestJSON);
        
        Map<String ,Object> mapOfData = (Map<String,Object>)JSON.deserializeUntyped(responseJSON);
        Object lstofData = mapOfData.get('adjustedResponseDTO');
        Map<String ,Object> mapofResponse = (Map<String,Object>)lstofData;
        Decimal response = Decimal.valueOf(String.valueOf(mapofResponse.get('adjAverageReceivableCollectionPeriod'))).setScale(2);
        
        return response;
    }
    
    /**
     * @description Defining different methods to make the Rest API Callouts
     * @param days
     * @param dailyCostOfSales
     * @return String
     */
    @AuraEnabled
    public static Decimal callRestAPI_AdjustedAverageInventoryProcesssingPeriod(Decimal days, Decimal dailyCostOfSales) {
		
        String requestJSON = '{ "data":{ "adjustWCNInventoryAvgDTO":{ "days":'+days+', "dailyCostOfSales":'+dailyCostOfSales+' } } } ';       
        String responseJSON = JitterbitAuth_WC_V1.getResponseBody(StringConstants.INTEGRATION_AVGINVPROCESSPERIOD_STRING, requestJSON);
        
        Map<String ,Object> mapOfData = (Map<String,Object>)JSON.deserializeUntyped(responseJSON);
        Object lstofData = mapOfData.get('adjustedResponseDTO');
        Map<String ,Object> mapofResponse = (Map<String,Object>)lstofData;
        Decimal response = Decimal.valueOf(String.valueOf(mapofResponse.get('adjAverageInventoryProcesssingPeriod'))).setScale(2);
        
        return response;
    }

    /**
     * @description Defining different methods to make the Rest API Callouts
     * @param adjustWCNReceiveAverage
     * @param adjustWCNInventoryAverage
     * @param adjustWCNPayablesAverage
     * @return Decimal
     */
    @AuraEnabled
    public static Decimal callRestAPI_AdjustedWorkingCapitalNeed(Decimal adjustWCNReceiveAverage, Decimal adjustWCNInventoryAverage, Decimal adjustWCNPayablesAverage) {
		
        String requestJSON = '{ "data":{ "adjustWCNDTO":{ "adjustWCNReceiveAverage":'+adjustWCNReceiveAverage+', "adjustWCNInventoryAverage":'+adjustWCNInventoryAverage+', "adjustWCNPayablesAverage":'+adjustWCNPayablesAverage+' } } } ';       
        String responseJSON = JitterbitAuth_WC_V1.getResponseBody(StringConstants.INTEGRATION_ADJWORKINGCAPNEED_STRING, requestJSON);
        
        Map<String ,Object> mapOfData = (Map<String,Object>)JSON.deserializeUntyped(responseJSON);
        Object lstofData = mapOfData.get('adjustedResponseDTO');
        Map<String ,Object> mapofResponse = (Map<String,Object>)lstofData;
        Decimal response = Decimal.valueOf(String.valueOf(mapofResponse.get('adjWorkingCapitalNeed'))).setScale(2);
        
        return response;
    }



}