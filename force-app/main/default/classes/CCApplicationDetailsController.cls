/**
* @description Controller for Creating and Updating CC Application Details
* @Author : Manish :Absa
* @since   2021-04-16
**/
public without sharing class CCApplicationDetailsController {
    /**
     * @description Method to get the Application Details
     * @Author : Manish :Absa
     * @param  applicationProductId - ApplicationProduct Id
     * @return String - CCApplicationDetailsWrapper JSON
    **/
    @AuraEnabled
    public static String getApplicationDetails(Id applicationProductId){
        CCApplicationDetailsWrapper applicationDetails = new CCApplicationDetailsWrapper();
        if(applicationProductId != null){
            ApplicationProductSelector appProductSelector = new ApplicationProductSelector();
            List<Application_Product__c> applicationProducts = appProductSelector.selectforCase(String.valueOf(applicationProductId));
            String ccApplicationDetails = applicationProducts[0].CCApplicationDetails__c ;
            applicationDetails.nameOfBusiness = applicationProducts[0].Account_Name__c ;
            applicationDetails.existingBusinessCardNumber = String.valueOf(applicationProducts[0].Account_Number__c) ;
            if(!String.isBlank(ccApplicationDetails)){
                applicationDetails = (CCApplicationDetailsWrapper)JSON.deserialize(ccApplicationDetails, CCApplicationDetailsWrapper.class);
                return JSON.serialize(applicationDetails);
            }
        }
        return JSON.serialize(applicationDetails);
    }

    /**
     * @description Method to save the application  details
     * @Author : Manish :Absa
     * @param  applicationDetails - ApplicationDetails JSON
     * @param applicationProductId - Applicaiton Product Id
    **/
    @AuraEnabled
    public static void saveApplicationDetails(String applicationDetails, Id applicationProductId){
        CCApplicationDetailsWrapper applicationDetailsWrapper = new CCApplicationDetailsWrapper();
        Application_Product__c appProduct= new Application_Product__c();
        appProduct.Id =  applicationProductId;
        appProduct.CCApplicationDetails__c = applicationDetails;
        update appProduct;
    }

    /**
     * @description Wrapper class for Application Details
    **/
    public class CCApplicationDetailsWrapper{
        public Date applicationDate;
        //public String applicantReference;
        public String campaignIfApplicable;
        public String creditCardProductType;
        public String doesClientOptForLuminance;
        public String newBusinessCard;
        public String aviationCard;
        public String linkedGarageCard;
        public String standaloneGarageCard;
        public String additionalCardUser;
        public String existingBusinessCardNumber;
        public String nameOfBusiness;
        public String directorsPartnersMembers;
        public String existingBusinessCtrlAccLimit;
        public String newBusinessCtrlAccLimit;
        public String allAssociatedConditionsMet;
        public String ifNoSpecify;
        public String marketersCode;
        //public String ldgEadRefNumber;
        //public String ldgEadStatusNumber;
        public String bank;
        public String branchName;
        public String clearingCode;
        public String accountNumber;
        public String overdraftFacilityAccountnumber;
        public String revolvingFacilityAccountnumber;
        public List<SourceOfFunds> sourceOfFundsList;
        public String doNotIncreaseCreditLimitsOnceaYear;
        public String doNotIncreaseCreditLimitsOnceaYearSubjectToCreditAssessment;
        public String noticeOfDefault;
        public String signedAt;
        public String signedOn;
        public String firstName;
        public String surName;
        public String identificationPassportNumberForeignID;
        public String witness1Intials;
        public String witness1SurName;
        public String witness2Intials;
        public String witness2SurrName;
    }

    /**
     * @description Wrapper class for SourceOfFunds Details
    **/
    public class SourceOfFunds{
        public String accountNumber;
        public String accountType;
        public String sourceOfFunds;
        public String wasExplanationSatisfactory;
        public String comments;
    }
}