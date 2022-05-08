/*
* Response Integration Bean for LAListPolicyDetailsByPolicyV7 Service
* @author Humbelani Denge
* @created 2020-10-09
*/

public class LAListPolicyDetailsByPolicyV7_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    public class La950p3o {
        @AuraEnabled public String accountNumber;
        @AuraEnabled public String accountType;
        @AuraEnabled public String accountholderName;
        @AuraEnabled public String activeIndicator;
        @AuraEnabled public Decimal annualPremiumIncreaseRate;
        @AuraEnabled public String applicationDate;
        @AuraEnabled public Decimal benefitEscalationPercent;
        @AuraEnabled public Integer branchCode;
        @AuraEnabled public String businessSourceIndicator;
        // public Object campCode;
        @AuraEnabled public String captureDate;
        @AuraEnabled public String commencementDate;
        // public Object errorDescription;
        @AuraEnabled public String expiryDate;
        @AuraEnabled public String iDirectIndicator;
        @AuraEnabled public Integer inArrearMonth;
        @AuraEnabled public String investmentTermIndicator;
        @AuraEnabled public Decimal mainIncome;
        @AuraEnabled public String nextPremiumDeductionDate;
        @AuraEnabled public Double outstandingPremium;
        @AuraEnabled public Long policyNumber;
        @AuraEnabled public Double policyPremium;
        @AuraEnabled public String policyStatus;
        @AuraEnabled public Decimal policySumAssured;
        @AuraEnabled public String premiumCollectionDay;
        @AuraEnabled public Integer premiumFrequency;
        @AuraEnabled public String processingType;
        @AuraEnabled public String productCode;
        @AuraEnabled public String productDescriptionAfrikaans;
        @AuraEnabled public String productDescriptionEnglish;
        // public Object qualificationDetails;
        @AuraEnabled public String responseDescription;
        // public Object responseNumber;
        @AuraEnabled public String rolePlayerCount; //Changed from Integer to String by JQUEV (Service returned "NaN" as a value)
        @AuraEnabled public List<RolePlayersDetails> rolePlayersDetails;
        @AuraEnabled public String serviceIntermediaryCode;
        // public Object smokerIndicator;
        @AuraEnabled public Integer sourceOfFund;
        @AuraEnabled public Integer sourceOfIncome;
        @AuraEnabled public Decimal sumAssured;
        @AuraEnabled public Decimal sumassuredEscalationPercent;
        // public Object trackStatus;
        @AuraEnabled public String treatyCode;
        @AuraEnabled public String underChange;
        @AuraEnabled public String underClaim;
        // public Object willNbr;
    }

    public class Nbsapdpo {
        // public Object echoKey;
        @AuraEnabled public Integer reasonCode;
        @AuraEnabled public Integer returnCode;
        // public Object serviceVersion;
        // public Object version;
    }

    public class RolePlayersDetails {
        @AuraEnabled public String addressLine1;
        @AuraEnabled public String addressLine2;
        // public Object ageNextIndicator;
        // public Object basicSupplementaryIndicator;
        @AuraEnabled public String benefitCode; //Changed by JQUEV
        // public Object benefitDescriptionAfrikaans;
        @AuraEnabled public String benefitDescriptionEnglish; //Changed by JQUEV
        @AuraEnabled public Integer benefitNumber;
        @AuraEnabled public Decimal benefitPremium;
        @AuraEnabled public Decimal benefitSumAssured;
        // public Object benefitType;
        @AuraEnabled public Integer casaReferenceNumber;
        @AuraEnabled public String city;
        @AuraEnabled public String clientCode; //Changed by JQUEV
        // public Object contactTelephoneNumber;
        // public Object countryOfResidence;
        @AuraEnabled public String dateOfBirth;
        // public Object emailAddress;
        // public Object escalationRateIndicator;
        @AuraEnabled public String firstName;
        @AuraEnabled public String idNumber;
        @AuraEnabled public String idType;
        @AuraEnabled public String initial;
        @AuraEnabled public String lifeClientCode;
        // public Object nationality;
        @AuraEnabled public Decimal percentSplit;
        @AuraEnabled public Integer postalCode;
        @AuraEnabled public Integer preferredCommunication;
        // public Object premiumEscalationIndicator;
        @AuraEnabled public String relationshipCode;//changed by chandra
        @AuraEnabled  public Integer roleNumber;
        @AuraEnabled public Integer rolePlayerCounter;
        @AuraEnabled public String roleType;
        // public Object sex;
        // public Object subBenefitType;
        @AuraEnabled  public String suburb;
        @AuraEnabled public String surname;
        @AuraEnabled public String titleCode;
        // public Object underwritingIndicator;
    }

    @AuraEnabled public LAlistPolicyDetailsbyPolicyNumberV7Response LAlistPolicyDetailsbyPolicyNumberV7Response;

    public class LAlistPolicyDetailsbyPolicyNumberV7Response {
        @AuraEnabled public La950p3o la950p3o;
        @AuraEnabled public Nbsapdpo nbsapdpo;
    }

    public override void setIntegrationTranslations(){

        integrationTranslationsMap = new Map<String,String>();
        integrationTranslationsMap.put('LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails.relationshipCode', 'CIF;Relationship');
        integrationTranslationsMap.put('LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails.roleType', 'CIF;Role Type');
        integrationTranslationsMap.put('LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.accountType','CIF;Account Type');
        integrationTranslationsMap.put('LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.policyStatus','CIF;Policy Status;Inactive');
        integrationTranslationsMap.put('LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails.idType', 'CIF;Policy ID Type');
        integrationTranslationsMap.put('LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails.titleCode', 'CIF;Title');
    }
}