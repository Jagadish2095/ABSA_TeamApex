/**
* Generic class that is used by process builder to calculate first and second year commission
* @author  Kyle Alexander
* @created 2018-07-09
*/

global class CommissionCalculator {
    /**
    * Method invoked by a process which calculates the first and second year commission and stores them in custom variables on the opportunity
    *
    * @param requests
    */
    @InvocableMethod
    public static void calculateCommission(List<CommissionRequest> requests) {
        //Metadata class - get latest version of values
        List<WIMI_Commission_Calculation__mdt> commCalculation =
        [SELECT
                MaxAge__c,
                MinAge__c,
                MinMaxFactor__c,
                MinVariableFactor__c,
                Policy_fee__c,
                SecondYearFactor__c,
                EffectiveDate__c,
                VAT__c
        FROM
                WIMI_Commission_Calculation__mdt
        ORDER BY
                EffectiveDate__c DESC];

        WIMI_Commission_Calculation__mdt commissionCalculation = new WIMI_Commission_Calculation__mdt();
        //Check if the effective date is less than or equal to today's date otherwise find the next valid date and set it to that
        for(WIMI_Commission_Calculation__mdt comCalc : commCalculation){
            if(comCalc.EffectiveDate__c <= Date.today()){
                commissionCalculation = comCalc;
                break;
            }
        }

        System.debug('Here' + commissionCalculation);

        for(CommissionRequest req : requests){
            //ANB Calculation
            Integer anbCalculationEq1 = anbCalculation1(req);
            Integer anbCalculationEq2 = anbCalculation2(req);

            Integer anb = (req.dateOfCommencement.year() - req.dateOfBirth.year() + 1 + anbCalculationEq1 + anbCalculationEq2);

            //Commission Calculator
            Decimal commissionEq = Math.max(commissionCalculation.MinAge__c, (commissionCalculation.MaxAge__c - anb));
            Decimal commissionFactor = Math.min((commissionCalculation.MinVariableFactor__c * commissionEq), commissionCalculation.MinMaxFactor__c);

            //First Year and Second Year calculations
            if(req.executorFeePremium == null){
                req.executorFeePremium = 0;
            }
            if(req.estateBridgingPremium == null){
                req.estateBridgingPremium = 0;
            }
            if(req.familyFuneralPremium == null){
                req.familyFuneralPremium = 0;
            }
            if(req.policyFee == null){
                req.policyFee = 0;
            }
            Decimal executorFeePremiumFY = calculateFirstYearCommission(commissionFactor, req.executorFeePremium);
            Decimal estateBridgingPremiumFY = calculateFirstYearCommission(commissionFactor, req.estateBridgingPremium);
            Decimal familyFuneralPremiumFY = calculateFirstYearCommission(commissionFactor, req.familyFuneralPremium);
            Decimal policyFeeFY = calculateFirstYearCommission(commissionFactor, req.policyFee);

            Decimal executorFeePremiumSY = calculateSecondYearCommission(executorFeePremiumFY, commissionCalculation.SecondYearFactor__c);
            Decimal estateBridgingPremiumSY = calculateSecondYearCommission(estateBridgingPremiumFY, commissionCalculation.SecondYearFactor__c);
            Decimal familyFuneralPremiumSY = calculateSecondYearCommission(familyFuneralPremiumFY, commissionCalculation.SecondYearFactor__c);
            Decimal policyFeeSY = calculateSecondYearCommission(policyFeeFY, commissionCalculation.SecondYearFactor__c);

            Decimal totalFirstYearCommission = executorFeePremiumFY + estateBridgingPremiumFY + familyFuneralPremiumFY + policyFeeFY;
            Decimal totalSecondYearCommission = executorFeePremiumSY + estateBridgingPremiumSY + familyFuneralPremiumSY + policyFeeSY;

            Decimal vatFY = totalFirstYearCommission * commissionCalculation.VAT__c;
            Decimal vatSY = totalSecondYearCommission * commissionCalculation.VAT__c;

            //Update opportunity with total first and second year commissions
            //List<Opportunity> opportunity = new OpportunitiesSelector().selectByOpportunityIdWithCommission(req.opportunityId, 1);
           
            //if(!opportunity.isEmpty()){
               // opportunity[0].Commission_1st_Year__c = totalFirstYearCommission + vatFY;
            	//opportunity[0].Commission_2nd_Year__c = totalSecondYearCommission + vatSY;
           // }

            //update opportunity;
            
            List<Quote> quotes = [SELECT Id, Commission_1st_Year__c, Commission_2nd_Year__c FROM Quote WHERE Id = :req.quoteId];
            if(!quotes.isEmpty()){
                quotes[0].Commission_1st_Year__c = totalFirstYearCommission + vatFY;
            	quotes[0].Commission_2nd_Year__c = totalSecondYearCommission + vatSY;
            }
            
            update quotes;
        }
    }

    /**
     * Calculation for ANB equation 1 used in anb calculation
     *
     * @param req
     *
     * @return anbCalculationEq1
     */
    public static Integer anbCalculation1(CommissionRequest req){
        if(req.dateOfCommencement.month() == req.dateOfBirth.month()){
            if(req.dateOfCommencement.day() >= req.dateOfBirth.day()){
                return 1;
            }
            else{
                return -1;
            }
        }
        else{
            return 0;
        }
    }

    /**
     * Calculation for ANB equation 2 used in anb calculation
     *
     * @param req
     *
     * @return anbCalculationEq2
     */
    public static Integer anbCalculation2(CommissionRequest req){
        if(req.dateOfCommencement.month() == req.dateOfBirth.month()){
            return 0;
        }
        else{
            if(req.dateOfCommencement.month() > req.dateOfBirth.month()){
                return 0;
            }
            else{
                return -1;
            }
        }
    }

    /**
     * Calculates the first year commission for a given plan type
     *
     * @param commissionFactor
     * @param firstMonthPremium
     *
     * @return First year commission for firstMonthPremium type
     */
    public static Decimal calculateFirstYearCommission(Decimal commissionFactor, Decimal firstMonthPremium){
        return commissionFactor * firstMonthPremium * 12;
    }

    /**
     * Calculates the second year commission by dividing the first year commission by the a particular factor
     *
     * @param firstYearCommission
     * @param secondYearFactor
     *
     * @return Second year commission after first year commission
     */
    public static Decimal calculateSecondYearCommission(Decimal firstYearCommission, Decimal secondYearFactor){
        return firstYearCommission / secondYearFactor;
    }

    global class CommissionRequest {
        @InvocableVariable
        global Id opportunityId;
        
        @InvocableVariable
        global Id quoteId;

        @InvocableVariable
        global Date dateOfBirth;

        @InvocableVariable
        global Date dateOfCommencement;

        @InvocableVariable
        global Decimal executorFeePremium;

        @InvocableVariable
        global Decimal estateBridgingPremium;

        @InvocableVariable
        global Decimal familyFuneralPremium;

        @InvocableVariable
        global Decimal policyFee;
    }
}