/**
* Probability calculator for all calls and marks whether an opportunity should be QA'ed
* @author  Kyle Alexander
* @created 2018-07-24
*/

public with sharing class QualityAssuranceProbabilityCalculator {

    public static Virtual_Advisor_QA_Percentage__mdt advisorQaPercentage;

    /**
     * Method that determines if a opportunity must be randomly marked for QA
     * It calculates a pseudo random number and checks if it is within the percentage set in the custom metadata object
     *
     * @param opportunity current opportunity object
     * @param advisor advisor's user details used to match business area to the one in the custom metadata object
     * @param status status of the opportunity i.e. successful or unsuccessful
     */
    public static void calculateIfQaSet(Opportunity opportunity, User advisor, String status){
        if(advisor.Business_Area__c != null){
            Boolean isBusinessAreaFound = setCustomMetadataRecord(advisor);

            if(isBusinessAreaFound){
                RandomNumberGenerator randomNumberGenerator = new RandomNumberGenerator();
                Integer randomNumber = randomNumberGenerator.nextIntegerInRange(0, 100);
                if(status == 'Successful'){
                    if(randomNumber < advisorQaPercentage.Successful_Calls_Percentage__c){
                        System.debug('In range for successful: ' + randomNumber);
                        opportunity.Requires_QA__c = true;
                    }
                }
                else if(status == 'Unsuccessful'){
                    if(randomNumber < advisorQaPercentage.Unsuccessful_Calls_Percentage__c){
                        System.debug('In range for unsuccessful: ' + randomNumber);
                        opportunity.Requires_QA__c = true;
                    }
                }
            }
            else{
                opportunity.addError('Business Area on user record does not match any Business Areas on the Custom Metadata Object records. Please contact a system administrator to rectify this.');
            }
        }
        else{
            opportunity.addError('No Business Area on user record was found. Please contact a system administrator to rectify this.');
        }
    }

    /**
     * Method that sets up the custom metadata record by getting the instance by appropriate date
     *
     * @param user Advisor user record
     *
     * @return whether or not a custom metadata record for that business area was found
     */
    public static Boolean setCustomMetadataRecord(User user){
        //Metadata class - get latest version of values
        List<Virtual_Advisor_QA_Percentage__mdt> advPercentage =
            [SELECT
                    Business_Area__c,
                    Effective_Date__c,
                    Successful_Calls_Percentage__c,
                    Unsuccessful_Calls_Percentage__c
            FROM
                    Virtual_Advisor_QA_Percentage__mdt
            WHERE
                    Business_Area__c = :user.Business_Area__c
            ORDER BY
                    Effective_Date__c DESC];

        if(!advPercentage.isEmpty()){
            advisorQaPercentage = new Virtual_Advisor_QA_Percentage__mdt();
            //Check if the effective date is less than or equal to today's date otherwise find the next valid date and set it to that
            for(Virtual_Advisor_QA_Percentage__mdt percCalc : advPercentage){
                if(percCalc.Effective_Date__c <= Date.today()){
                    advisorQaPercentage = percCalc;
                    return true;
                }
            }
        }
        return false;
    }
}