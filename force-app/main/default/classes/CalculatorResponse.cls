/**
 * @description       : Data structures for working capital calculator
 * @author            : Amit G.
 * @last modified on  : 2021-07-09
 * @last modified by  : Tawanda M.
**/

public class CalculatorResponse { 

    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class Response {
        @AuraEnabled public Inputs inputs;
        @AuraEnabled public Calculations calculations;
        @AuraEnabled public AdjustedCalculations adjustedCalculations;
    }

    @AuraEnabled public Data data;
    @AuraEnabled public List<ErrorsObj> errors;

    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class AdjustedCalculations {
        @AuraEnabled public Decimal adjustedAverageInventoryProcesssingPeriod;
        @AuraEnabled public Decimal adjustedAverageReceivableCollectionPeriod;
        @AuraEnabled public Decimal adjustedWorkingCapitalNeed;
        @AuraEnabled public Decimal adjustedPayablesPaymentPeriod;
    }

    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class Calculations {
        @AuraEnabled public Decimal averageInventoryProcesssingPeriod;
        @AuraEnabled public Decimal averageReceivableCollectionPeriod;
        @AuraEnabled public Decimal cashConversionCycle;
        @AuraEnabled public Decimal dailyCostOfSales;
        @AuraEnabled public Decimal dailySales;
        @AuraEnabled public Decimal payablesPaymentPeriod;
        @AuraEnabled public Decimal workingCapitalNeed;
        @AuraEnabled public Decimal workingCapitalNeedMinusCashBalance;
    }

    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class ErrorsObj {
        @AuraEnabled public String details;
        @AuraEnabled public String source;
        @AuraEnabled public String code;
    }

    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class Data {
        @AuraEnabled public List<Response> response;
        @AuraEnabled public List<ErrorsObj> errorsObj;
        @AuraEnabled public String status;
    }

    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class Inputs {
        @AuraEnabled public Integer year;
        @AuraEnabled public String month;
        @AuraEnabled public Decimal turnOver;
        @AuraEnabled public Decimal costOfSales;
        @AuraEnabled public Decimal cash;
        @AuraEnabled public Decimal inventories;
        @AuraEnabled public Decimal receivables;
        @AuraEnabled public Decimal payables;
        @AuraEnabled public Boolean useInCalc;
    }

    /**
     * @description Parse data
     * @param json
     * @return CalculatorResponse
     */
    public static CalculatorResponse parse(String json) {
        return (CalculatorResponse) System.JSON.deserialize(json, CalculatorResponse.class);
    }
    
    /**
     * @description Round off adjusted calcs
     * @param responses
     */
    public static void roundOffAdjustedCalculations(List<Response> responses) {
        for(Response response : responses) {
            response.adjustedCalculations.adjustedAverageInventoryProcesssingPeriod = response.adjustedCalculations.adjustedAverageInventoryProcesssingPeriod.setScale(2);
            response.adjustedCalculations.adjustedAverageReceivableCollectionPeriod = response.adjustedCalculations.adjustedAverageReceivableCollectionPeriod.setScale(2);
            response.adjustedCalculations.adjustedWorkingCapitalNeed = response.adjustedCalculations.adjustedWorkingCapitalNeed.setScale(2);
            response.adjustedCalculations.adjustedPayablesPaymentPeriod = response.adjustedCalculations.adjustedPayablesPaymentPeriod.setScale(2);
        }
    }

    /**
     * @description Round off calcs
     * @param responses
     */
    public static void roundOffCalculations(List<Response> responses) {
        for(Response response : responses) {
            response.calculations.averageInventoryProcesssingPeriod = response.calculations.averageInventoryProcesssingPeriod.setScale(0);
            response.calculations.averageReceivableCollectionPeriod = response.calculations.averageReceivableCollectionPeriod.setScale(0);
            response.calculations.cashConversionCycle = response.calculations.cashConversionCycle.setScale(0);
            response.calculations.dailyCostOfSales = response.calculations.dailyCostOfSales.setScale(2);
            response.calculations.dailySales = response.calculations.dailySales.setScale(2);
            response.calculations.payablesPaymentPeriod = response.calculations.payablesPaymentPeriod.setScale(0);
            response.calculations.workingCapitalNeed = response.calculations.workingCapitalNeed.setScale(2);
            response.calculations.workingCapitalNeedMinusCashBalance = response.calculations.workingCapitalNeedMinusCashBalance.setScale(2);
        }
    }

    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class AdjustWCNPayablesRequest {
        @AuraEnabled public AdjustWCNPayablesJSON data;
    }
    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class AdjustWCNPayablesJSON {
        @AuraEnabled public AdjustWCNAvgDTO adjustWCNPayablesAvgDTO;
    }
    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class AdjustWCNAvgDTO {
        @AuraEnabled public Double days;
        @AuraEnabled public Double dailyCostOfSales;
    }    
    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class AdjustedResponseDTOResponse {
        public AdjustedResponseDTOJSON adjustedResponseDTO;
        public List<ErrorJSON> errors;
    }
    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class AdjustedResponseDTOJSON {
        public Double adjAverageInventoryProcesssingPeriod;
        public Double adjAverageReceivableCollectionPeriod;
        public Double adjWorkingCapitalNeed;
        public Double adjPayablesPaymentPeriod;
    }    
    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class ErrorJSON {
        public String details;
        public String source;
        public String code;
    }    
    /**
     * @description Defining different methods to make the Rest API Callouts
     */
    public class ErrorJSONResponse {
        public String type;
        public String title;
        public String status;
        public String detail;
        public String instance;
    }
}