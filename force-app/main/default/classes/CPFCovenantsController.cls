/**
 * @description       :Controller for CPFCovenants Component
 * @author            :Rajesh/Anka
 * @last modified on  : 2021-06-14
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-06-07      Initial Version
**/
public class CPFCovenantsController {

/**
* @description
* @author  | 2021-06-07
* @param recId
* @param OtherCoperateList
* @return list<Application_Contract_Clause__c>
**/
@AuraEnabled
public static list<Application_Contract_Clause__c> insertOtherCorporateCovenants(Id recId,List<Application_Contract_Clause__c> OtherCoperateList) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){

            List<Application_Contract_Clause__c> dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Other Corporate Covenants');

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            for(Application_Contract_Clause__c otherTransObj : OtherCoperateList) {
                otherTransObj.Application_Product_CPF__c=appPrdctCpf.Id;
                otherTransObj.Category__c='CPF Application';
                otherTransObj.Type__c='Other Corporate Covenants';
            }
            insert OtherCoperateList;

        }
        return OtherCoperateList;
    }catch(Exception e){
        system.debug(e.getMessage());
        return null;
    }
}

/**
* @description
* @author  | 2021-06-07
* @param recId
* @param OtherTransList
* @return list<Application_Contract_Clause__c>
**/
@AuraEnabled
public static list<Application_Contract_Clause__c> insertOtherTransactions(Id recId,List<Application_Contract_Clause__c> OtherTransList) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){

            List<Application_Contract_Clause__c> dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Other Transactional Covenants');

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            for(Application_Contract_Clause__c otherTransObj : OtherTransList) {
                otherTransObj.Application_Product_CPF__c=appPrdctCpf.Id;
                otherTransObj.Category__c='CPF Application';
                otherTransObj.Type__c='Other Transactional Covenants';
            }
            insert OtherTransList;

        }
        return OtherTransList;
    }catch(Exception e){
        system.debug(e.getMessage());
        return null;
    }
}

/**
* @description
* @author  | 2021-06-07
* @param recId
* @param OtherLoanList
* @param indebtedness
* @param loanToValueCovenant
* @param propertyValueNTE
* @param period
* @return list<Application_Contract_Clause__c>
**/
@AuraEnabled
public static list<Application_Contract_Clause__c> insertOtherLoanValue(Id recId,List<Application_Contract_Clause__c> OtherLoanList,String indebtedness,String loanToValueCovenant,Decimal propertyValueNTE,String period) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){

            appPrdctCpf.Indebtedness__c = indebtedness;
            appPrdctCpf.Loan_To_Value_Covenant__c = loanToValueCovenant;
            appPrdctCpf.Property_value_to_not_be_exceeded__c = propertyValueNTE;
            appPrdctCpf.Period__c = period;
            List<Application_Contract_Clause__c> dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Loan and Value Covenants');

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            for(Application_Contract_Clause__c otherLoanObj : OtherLoanList) {
                otherLoanObj.Application_Product_CPF__c=appPrdctCpf.Id;
                otherLoanObj.Category__c='CPF Application';
                otherLoanObj.Type__c='Loan and Value Covenants';
            }
            update appPrdctCpf;
            insert OtherLoanList;

        }
        return OtherLoanList;
    }catch(Exception e){
        system.debug(e.getMessage());
        return null;
    }
}
/**
* @description
* @author  | 2021-06-07
* @param recId
* @param vacancyCoverRatio
**/
@AuraEnabled
public static void insertVacancyCoverValue(Id recId,String vacancyCoverRatio) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){
            appPrdctCpf.Vacancy_cover_ratio__c = vacancyCoverRatio;
            update appPrdctCpf;
        }
    }catch(Exception e){
        system.debug(e.getMessage());

    }
}
/**
* @description
* @author  | 2021-06-07
* @param recId
* @param DebitCoverList
* @param debtServiceCoverRatio
* @param debtservicecvrration
* @return list<Application_Contract_Clause__c>
**/
@AuraEnabled
public static list<Application_Contract_Clause__c> insertDebitCoverList(Id recId,List<Application_Contract_Clause__c> DebitCoverList,String debtServiceCoverRatio,String debtservicecvrration) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){
            appPrdctCpf.Debt_service_cover_ratio2__c = debtServiceCoverRatio;
            appPrdctCpf.Debt_service_cover_ratio__c = debtservicecvrration;
            List<Application_Contract_Clause__c> dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Debit Service Cover Ratio');

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            for(Application_Contract_Clause__c DebitCover : DebitCoverList) {
                DebitCover.Application_Product_CPF__c=appPrdctCpf.Id;
                DebitCover.Category__c='CPF Application';
                DebitCover.Type__c='Debit Service Cover Ratio';
            }
            update appPrdctCpf;
            insert DebitCoverList;

        }
        return DebitCoverList;
    }catch(Exception e){
        system.debug(e.getMessage());
        return null;
    }
}
    /**
 * @description 
 * @author  | 2021-06-07 
 * @param recId 
 * @param InterestCoverList 
 * @param interestServiceCoverRatio 
 * @param interestervicecvrration 
 * @return list<Application_Contract_Clause__c> 
 **/
    @AuraEnabled
public static list<Application_Contract_Clause__c> insertInterestCoverList(Id recId,List<Application_Contract_Clause__c> InterestCoverList,String interestServiceCoverRatio,String interestervicecvrration) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){
            appPrdctCpf.Interest_Service_Cover_Ratio__c = interestServiceCoverRatio;
            appPrdctCpf.Interest_Cover_Ratio__c = interestervicecvrration;
            List<Application_Contract_Clause__c> dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Debit Service Cover Ratio');

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            for(Application_Contract_Clause__c InterestCover : InterestCoverList) {
                InterestCover.Application_Product_CPF__c=appPrdctCpf.Id;
                InterestCover.Category__c='CPF Application';
                InterestCover.Type__c='Interest Service Cover Ratio';
            }
            update appPrdctCpf;
            insert InterestCoverList;

        }
        system.debug('InterestCoverList'+InterestCoverList);
        return InterestCoverList;
    }catch(Exception e){
        system.debug(e.getMessage());
        return null;
    }
}
/**
* @description
* @author  | 2021-06-07
* @param recId
* @param OtherEntityList
* @param applicableToTheBorrower
* @param applicable_to_the_Parent
* @param applicable_to_the_Guarantor
* @param applicable_to_the_Security_Pro
* @param otherentity
* @return list<Application_Contract_Clause__c>
**/
@AuraEnabled
public static list<Application_Contract_Clause__c> insertOtherEntityList(Id recId,List<Application_Contract_Clause__c> OtherEntityList,String applicableToTheBorrower,String applicable_to_the_Parent,String applicable_to_the_Guarantor,String applicable_to_the_Security_Pro,String otherentity) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){

            appPrdctCpf.Covenants_applicable_to_the_Borrower__c = applicableToTheBorrower;
            appPrdctCpf.Covenants_applicable_to_the_Parent__c = applicable_to_the_Parent;
            appPrdctCpf.Covenants_applicable_to_the_Guarantor_s__c = applicable_to_the_Guarantor;
            appPrdctCpf.Covenants_applicable_to_the_Security_Pro__c = applicable_to_the_Security_Pro;
            appPrdctCpf.Other_Entity__c = otherentity;

            List<Application_Contract_Clause__c> dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Other Entity');

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            for(Application_Contract_Clause__c OtherEntity2 : OtherEntityList) {
                OtherEntity2.Application_Product_CPF__c=appPrdctCpf.Id;
                OtherEntity2.Category__c='CPF Application';
                OtherEntity2.Type__c='Other Entity';
            }
            update appPrdctCpf;
            insert OtherEntityList;

        }
        return OtherEntityList;
    }catch(Exception e){
        system.debug(e.getMessage());
        return null;
    }
}
/**
* @description
* @author  | 2021-06-07
* @param oppId
* @param type
* @return List<Application_Contract_Clause__c>
**/
@AuraEnabled
public static List<Application_Contract_Clause__c> getApplicationConClause(Id oppId,string type) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    List<Application_Contract_Clause__c> Appconclause = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application',type);
    return Appconclause;

}
/**
* @description
* @author  | 2021-06-07
* @param oppId
* @return Map<Object, Object>
**/
@AuraEnabled
public static Map<Object,Object> getLoanConData(Id oppId) {
    Map<Object,Object> dataMap = new Map<Object,Object>();
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    dataMap.put('Indebtedness', appPrdctCpf.Indebtedness__c);
    dataMap.put('loanToValueCovenant', appPrdctCpf.Loan_To_Value_Covenant__c);
    dataMap.put('propertyValueNTE', appPrdctCpf.Property_value_to_not_be_exceeded__c);
    dataMap.put('period', appPrdctCpf.Period__c);
    dataMap.put('vacancyCoverRatio', appPrdctCpf.Vacancy_cover_ratio__c);
    dataMap.put('measurementPeriod', appPrdctCpf.Measurement_period__c);
    dataMap.put('financialYear', appPrdctCpf.Financial_year_of__c);
    dataMap.put('financialCovRef', appPrdctCpf.Financial_covenants_by_reference__c);
    dataMap.put('consecutivePeriod', appPrdctCpf.Consecutive_period_of_months__c);
    dataMap.put('financialConvenantApplicable', appPrdctCpf.Financial_covenants_applicable__c);
    dataMap.put('transactionalConvenantApplicable', appPrdctCpf.Transactional_covenants_applicable__c);
    dataMap.put('appPrdctCpf', appPrdctCpf);
    List<Application_Contract_Clause__c> Appconclause = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Loan and Value Covenants');
    List<Application_Contract_Clause__c> debitClauseList = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Debit Service Cover Ratio');
    List<Application_Contract_Clause__c> InterestClauseList = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Interest Service Cover Ratio');
    List<Application_Contract_Clause__c> otherEntityClauseList = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','Other Entity');
    dataMap.put('LoanData', Appconclause);
    dataMap.put('DebitClaseList', debitClauseList);
    dataMap.put('InterestCoverList', InterestClauseList);
    dataMap.put('OtherEntityClauseList', otherEntityClauseList);
    return dataMap;

}

/**
* @description
* @author  | 2021-06-07
* @param oppId
* @return Application_Product_CPF__c
**/
@AuraEnabled
public static Application_Product_CPF__c getApplicationProductCPF(Id oppId) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    return appPrdctCpf;
}
/**
* @description
* @author  | 2021-06-07
* @param recId
* @param financialYear
* @param measurementPeriod
* @param consecutivePeriod
* @param financialCovRef
* @param transactionalConvenantApplicable
* @param financialConvenantApplicable
**/
@AuraEnabled
public static void insertFgc(Id recId,String financialYear,String measurementPeriod,String consecutivePeriod,String financialCovRef,String transactionalConvenantApplicable,String financialConvenantApplicable) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){

            appPrdctCpf.Measurement_period__c = measurementPeriod;
            appPrdctCpf.Financial_year_of__c = financialYear;
            appPrdctCpf.Consecutive_period_of_months__c = consecutivePeriod;
            appPrdctCpf.Financial_covenants_by_reference__c = financialCovRef;
            appPrdctCpf.Transactional_covenants_applicable__c = transactionalConvenantApplicable;
            appPrdctCpf.Financial_covenants_applicable__c = financialConvenantApplicable;
            update appPrdctCpf;

        }

    }catch(Exception e){
        system.debug(e.getMessage());

    }
}
/**
* @description
* @author  | 2021-06-07
* @param oppId
* @return List<OpportunityLineItem>
**/
@AuraEnabled
public static List<OpportunityLineItem> getprodName(Id oppId) {
    List<OpportunityLineItem> opplineitemlst =new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
    return opplineitemlst;
}
/**
* @description
* @author  | 2021-06-07
* @param oppId
* @param corporateintrest
* @param gearingratio
* @param assestType
* @param leverageratio
* @param cashflowcover
* @param dividendcover
* @param miniNTAType
* @param miniNTARatio
* @param carporateConvenantApplicable
**/
@AuraEnabled
public static void updateAppProdDetails(Id oppId,Decimal corporateintrest,Decimal gearingratio,String assestType,Decimal leverageratio,
                                        Decimal cashflowcover,Decimal dividendcover,String miniNTAType,Decimal miniNTARatio,String carporateConvenantApplicable) {
                                            List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
                                            Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
                                            try{
                                                if(appPrdctCpf!=null){

                                                    appPrdctCpf.Corporate_Interest_Cover_Ratio__c = corporateintrest;
                                                    appPrdctCpf.Gearing_Ratio__c = gearingratio;
                                                    appPrdctCpf.Asset_Type__c = assestType;
                                                    appPrdctCpf.Leverage_Ratio__c = leverageratio;
                                                    appPrdctCpf.Cash_Flow_Cover_Ratio__c = cashflowcover;
                                                    appPrdctCpf.Dividend_Cover_Ratio__c = dividendcover;
                                                    appPrdctCpf.Minimum_NTA_Type__c=miniNTAType;
                                                    appPrdctCpf.Minimum_NTA_Ratio__c=miniNTARatio;
                                                    appPrdctCpf.Corporate_covenants_applicable__c=carporateConvenantApplicable;
                                                    update appPrdctCpf;

                                                }

                                            }catch(Exception e){
                                                system.debug(e.getMessage());

                                            }
                                        }

/**
* @description
* @author  | 2021-06-07
* @param recId
* @param loantocostpicklist
* @param loantocost
**/
@AuraEnabled
public static void insertloantocostvalue(Id recId,String loantocostpicklist,Decimal loantocost) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
        if(appPrdctCpf!=null){

            appPrdctCpf.Loan_To_Cost_Picklist__c = loantocostpicklist;
            appPrdctCpf.Loan_To_Cost__c = loantocost;
            appPrdctCpf.Id = appPrdctCpf.Id;
            update appPrdctCpf;
        }

    }catch(Exception e){
        system.debug(e.getMessage());

    }
}



}