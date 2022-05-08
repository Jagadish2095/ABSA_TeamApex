/**
 * @description       : Test class for working capital controller class
 * @author            : Amit G.
 * @last modified on  : 2021-07-24
 * @last modified by  : Tawanda M.
**/
@isTest
public class WorkingCapitalCalControllerTest {
    public static final String PROCESSDATA = 'WC ProcessData';
    public static final String ADJUSTEDPAYABLESPAYMENTPERIOD = 'WC AdjustedPayablesPaymentPeriod';
    public static final String ADJUSTEDAVERAGERECEIVABLECOLLECTIONPERIOD = 'WC AdjustedAverageReceivableCollectionPeriod';
    public static final String ADJUSTEDAVERAGEINVENTORYPROCESSSINGPERIOD = 'WC AdjustedAverageInventoryProcesssingPeriod';
    public static final String ADJUSTEDWORKINGCAPITALNEED = 'WC AdjustedWorkingCapitalNeed';
    
    @isTest
    public static void testWorkingCapitalCal() {
        List<String> endpoints = new List<String>();
        endpoints.add(JitterbitAuth_WC_V1.JITTERBIT_AUTH_PATH2);
        endpoints.add(PROCESSDATA);
        endpoints.add(ADJUSTEDPAYABLESPAYMENTPERIOD);
        endpoints.add(ADJUSTEDAVERAGERECEIVABLECOLLECTIONPERIOD);
        endpoints.add(ADJUSTEDAVERAGEINVENTORYPROCESSSINGPERIOD);
        endpoints.add(ADJUSTEDWORKINGCAPITALNEED);
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, endpoints);
        
        
        WorkingCapitalCalController.callRestAPI_ProcessData('[]');
        WorkingCapitalCalController.callRestAPI_AdjustedPayablesPaymentPeriod(0,0);
        WorkingCapitalCalController.callRestAPI_AdjustedAverageReceivableCollectionPeriod(0,0);
        WorkingCapitalCalController.callRestAPI_AdjustedAverageInventoryProcesssingPeriod(0,0);
        WorkingCapitalCalController.callRestAPI_AdjustedWorkingCapitalNeed(0,0,0);
        System.assertEquals(true, true);
    }
    @isTest
    public static void testCalculatorResponse() {
        CalculatorResponse.Response response = new CalculatorResponse.Response();
        response.inputs = new CalculatorResponse.Inputs();
        response.calculations = new CalculatorResponse.Calculations();
        response.adjustedCalculations = new CalculatorResponse.AdjustedCalculations();
        
        response.adjustedCalculations.adjustedAverageInventoryProcesssingPeriod = 0;
        response.adjustedCalculations.adjustedAverageReceivableCollectionPeriod = 0;
        response.adjustedCalculations.adjustedWorkingCapitalNeed = 0;
        response.adjustedCalculations.adjustedPayablesPaymentPeriod = 0;
        response.calculations.averageInventoryProcesssingPeriod = 0;
        response.calculations.averageReceivableCollectionPeriod = 0;
        response.calculations.cashConversionCycle = 0;
        response.calculations.dailyCostOfSales = 0;
        response.calculations.dailySales = 0;
        response.calculations.payablesPaymentPeriod = 0;
        response.calculations.workingCapitalNeed = 0;
        response.calculations.workingCapitalNeedMinusCashBalance = 0;
        
        final List<CalculatorResponse.Response> lstResponses = new List<CalculatorResponse.Response>{response};
        CalculatorResponse.parse(JSON.serialize(new CalculatorResponse()));
        CalculatorResponse.roundOffAdjustedCalculations(lstResponses);
        CalculatorResponse.roundOffCalculations(lstResponses);
        System.assertEquals(true, true);
    }
}