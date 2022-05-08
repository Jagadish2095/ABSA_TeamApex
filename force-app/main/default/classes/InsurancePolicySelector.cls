/*
 * Class for policy selection
 * @author Srikanth
 * @created 2020-10-20
 * Version: V1.0
 */

public class InsurancePolicySelector {
    // Not using fflib_SObjectSelector class as the API version of that class is 37.
    // InsurancePolicy Object is not accessible using that API version, hence using direct query.

    public List<InsurancePolicy> getPoliciesByAccountId(Id accountId) {
        return [
            SELECT Id, Name, PolicyName, NameInsuredId, EffectiveDate, ExpirationDate
            FROM InsurancePolicy
            WHERE NameInsuredId = :accountId
        ];
    }

    //Danie Booysen, Paula Kreutzfeldt
    //2020-11-03
    //W-005966
    public List<InsurancePolicy> getPoliciesByPolicyNumber(String policyNum) {
        return [
            SELECT Id, Name, PolicyName, NameInsuredId, EffectiveDate, ExpirationDate
            FROM InsurancePolicy
            WHERE Name = :policyNum
        ];
    }
    
    /* Return All Insurance Policies by Insurance Policy IDs
	* @param Set<String> InsurancePolicyIds
	* @return List<InsurancePolicy>
	*/
    public List<InsurancePolicy> selectByInsurancePolicyIds(Set<String> InsurancePolicyIds) {
        return [
            SELECT Id, Name, PolicyName, NameInsuredId, EffectiveDate, ExpirationDate, NameInsured.Name, NameInsured.ID_Number__pc, NameInsured.PersonBirthdate,  
            NameInsured.Phone, NameInsured.PersonEmail,NameInsured.Business_Address_Line_1__c,Account_Number__c,Branch_Code__c,NameInsured.Business_Address_Line_2__c,
            Broker__r.Name, Broker__r.Broker_Code__c, Broker__r.Phone__c, Broker__r.Email__c,Account_Holder_Name__c,Status, Policy_Action__c,Debit_Order_Start_Date__c, PremiumFrequency, Payment_Method__c,Account_Type__c,Number_of_Rejections__c,
            Fixed_Instruction_Indicator__c,Fixed_Instruction_Date__c, Unpaid_Reason_Code__c,UniversalPolicyNumber,Technician_Code__c,TaxesSurcharges,Substatus,
            SourceSystemIdentifier,SourceSystem,SourceQuoteId,SourceOpportunityId,ServicingOffice,SaleDate,IsRenewedPolicy,RenewalDate,RenewalChannel,Product_Code__c,ProductId,ProducerId,PriorPolicyId,PreviousRenewalDate,PremiumAmount,
            PolicyType,Policy_Number_Internal__c,Policy_Memo__c,PolicyDescription,PlanType,PlanTier,PaymentDueDate,ParentPolicyId,OwnerId,LastModifiedDate,LastModifiedById,ITC_Indicator__c,
            ITC_Date__c,Inception_Date__c,FinServ__Household__c,HasAnyAutoCoverage,GrossWrittenPremium,FnolChannel,FinalRenewalDate,External_Ref_Number__c,IsLoanEligibile,Discount,Debit_Order_Status__c,Date_Last_Rejected__c,CurrencyIsoCode,CreatedDate,CreatedById,CIF_Client_Code__c,
            ChangeType,ChangeSubtype,CashSurrenderValue,CancellationReasonType,CancellationReason,CancellationDate,Broker__c,AuditTerm,IsActive
            FROM InsurancePolicy
            WHERE Id in:InsurancePolicyIds
        ];
        
    } 
}