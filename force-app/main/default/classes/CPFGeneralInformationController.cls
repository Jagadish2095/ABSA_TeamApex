/**
 * @description       :
 * @author            :
 * @last modified on  : 2021-07-23
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-06-07      Initial Version
**/
public class CPFGeneralInformationController {

/**
* @description
* @author  | 2021-06-07
* @param oppId
* @return Application_Product_CPF__c
**/
@AuraEnabled
public static Application_Product_CPF__c getAppProdctCpfRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);

return appPrdctCpf;
}

/**
* @description
* @author  | 2021-06-07
* @param oppId
* @return LIST<Application_Portfolio__c>
**/
@AuraEnabled
public static LIST<Application_Portfolio__c> getAppPortfolioRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Portfolio__c> appPortfolioList = [select id,name,Portfolio_Description__c,Application_Product_CPF__c from Application_Portfolio__c where Application_Product_CPF__c =: appPrdctCpf.Id];
return appPortfolioList;
}

/**
* @description
* @author  | 2021-06-07
* @param recId
* @param objData
* @return Application_Product_CPF__c
**/
@AuraEnabled
public static Application_Product_CPF__c updateAppPrdctcpf(Id recId,String objData
                                                        ) {
                                                        appProductcpf responseBean=new appProductcpf ();
                                                        responseBean= (appProductcpf)JSON.deserialize(objData,appProductcpf.class);

                                                        Application_Product_CPF__c appPrdctCpf= new Application_Product_CPF__c(Id = recId);
                                                        //try{
                                                            if(appPrdctCpf!=null){
                                                                appPrdctCpf.Id =recId;
                                                                appPrdctCpf.Amendment_and_restatement_clause_app__c = responseBean.amendmentClause;
                                                                appPrdctCpf.Monthly_charging_date__c = responseBean.chargingDate;
                                                                appPrdctCpf.Withdrawal__c = responseBean.withdrawal;
                                                                appPrdctCpf.Owner_Occupied__c = responseBean.ownerOccupied;
                                                                appPrdctCpf.Equity_contributions__c = responseBean.equityContributions;
                                                                appPrdctCpf.Equity_contribution_amount__c = responseBean.equityContributionsAmt;
                                                                appPrdctCpf.Other_equity_contributions__c = responseBean.otherEquity;
                                                                appPrdctCpf.Litigation_threshold_amount__c = responseBean.litThreshloldAmt;
                                                                appPrdctCpf.Borrower_under_CPA__c = responseBean.bUnderCPA;
                                                                appPrdctCpf.Facility_purpose__c = responseBean.fPurpose;
                                                                appPrdctCpf.Cross_default_threshold_amount__c = responseBean.cdThresholdAmt;
                                                                appPrdctCpf.Further_loan_options__c = responseBean.fLoanOptions;
                                                                appPrdctCpf.Purpose_as_approved_by_credit__c = responseBean.pApprovedByCred;
                                                                appPrdctCpf.Undertakings_threshold__c = responseBean.uThreshold;
                                                                appPrdctCpf.Undertakings_threshold_amount__c =responseBean.thresholdAmount;
                                                                appPrdctCpf.Threshold_periods__c = responseBean.tPeriods;
                                                                appPrdctCpf.Additional_finance_documents__c = responseBean.aFinanceDocsRequired;
                                                                appPrdctCpf.Additional_finance_documents_required__c= responseBean.aFinanceDocsRequired;
                                                                if(responseBean.fPurpose=='To finance in whole or in part the acquisition of the Property'){
                                                                    appPrdctCpf.Property_description_property__c= responseBean.pDescription1;
                                                                }else if(responseBean.fPurpose=='PURPOSE AS APPROVED BY CREDIT'){
                                                                    appPrdctCpf.Property_description_property__c = responseBean.pDescription;}
                                                                appPrdctCpf.Property_selection__c = responseBean.pSelection;
                                                                appPrdctCpf.Property_portfolio_description__c = responseBean.pPortfolioDescription;
                                                                appPrdctCpf.CPF_account_number__c=responseBean.CPFAccNumber ;//Decimal.valueOf(
                                                                //appPrdctCpf.Property_selection__c=responseBean.propertyselval;
                                                                appPrdctCpf.Transactional_banking_accounts__c = responseBean.transactionalBankingAccounts;
                                                                appPrdctCpf.Include_guarantor_s__c = responseBean.includeGuarantors;
                                                                appPrdctCpf.When__c =responseBean.whenValue;
                                                                appPrdctCpf.Development_Facility_purpose__c=responseBean.devfaciPurpose;
                                                                appPrdctCpf.Property_type__c=responseBean.devproptype;
                                                                appPrdctCpf.Other_property_type__c=responseBean.otherproptype;
                                                                appPrdctCpf.Property_description_Dev__c	=responseBean.devpropDescription;
                                                                appPrdctCpf.Development_description__c=responseBean.devDescription;
                                                                appPrdctCpf.Development_loan_Is_VAT_Facility_applica__c=responseBean.devloanisvat;
                                                                appPrdctCpf.Development_loan_VAT_Facility_amount__c=responseBean.devloanvatfaciamt;
                                                                appPrdctCpf.Aggregate_maximum_amount__c=responseBean.aggmaxiamt;
                                                                appPrdctCpf.Amount_outstanding__c=responseBean.amtoutstanding;
                                                                appPrdctCpf.Development_loan_Term__c=responseBean.devloanterm;
                                                                appPrdctCpf.Development_loan_Final_Repayment_Date__c=responseBean.devloanfinalrepaypick;
                                                                appPrdctCpf.Date_of_final_repayment__c=responseBean.dateoffinalrepay;
                                                                appPrdctCpf.Development_loan_Purpose__c=responseBean.devloanpurpose;
                                                                appPrdctCpf.VAT_Facility_Fee__c=responseBean.vatfacifee;
                                                                appPrdctCpf.VAT_Repayment_Options__c=responseBean.vatrepayoptions;
                                                                appPrdctCpf.Interest_service_frequency__c=responseBean.insterestfreq;
                                                                appPrdctCpf.VAT_Facility_Final_instalment_amount__c=responseBean.vatfacifinalinstalamt;

                                                                List<Application_Portfolio__c> dellist = new  List<Application_Portfolio__c>();
                                                                dellist = [select id,name,Portfolio_Description__c,Application_Product_CPF__c from Application_Portfolio__c where Application_Product_CPF__c =: appPrdctCpf.Id];
                                                                if(!dellist.isEmpty()) {
                                                                    delete dellist;
                                                                }
                                                                if(!responseBean.newPortfolios.isEmpty() && responseBean.newPortfolios!= null ){
                                                                for(Application_Portfolio__c finobj : responseBean.newPortfolios) {
                                                                    finobj.Id= null;
                                                                    finobj.Application_Product_CPF__c=appPrdctCpf.Id;
                                                                }
                                                                insert responseBean.newPortfolios;
                                                            }
                                                            }
                                                            update appPrdctCpf;

                                                            system.debug('appPrdctCpf'+appPrdctCpf);
                                                        //    system.debug('portfoliolist'+newPortfolios);
                                                            return appPrdctCpf;
                                                        //}
                                                        /*  catch(Exception e){
                                                            system.debug(e.getMessage());
                                                            return null;
                                                        }*/
                                                    }

//financial insert

/**
* @description
* @author  | 2021-06-07
* @param appPrdId
* @param Parenttoprovidethebankwithfinancia
* @param GuarantortoprovideBankfinancialinfo
* @param amendment
* @param Financialstmtavailablenolater
* @param Borrowerhassubsidiaries
* @param Guarantorshashavesubsidiaries
* @param Unauditedinterimstmtreq
* @param unauditedinterimavailablevalue
* @param Period
* @param Includebalancesheetprofitlossacc
* @param available
* @param Otherfinancialinformation
* @return Application_Product_CPF__c
**/
@AuraEnabled
public static Application_Product_CPF__c addParentAccount(string appPrdId,string Parenttoprovidethebankwithfinancia,string GuarantortoprovideBankfinancialinfo,string amendment,string Financialstmtavailablenolater,string Borrowerhassubsidiaries
                                                    ,string Guarantorshashavesubsidiaries,string Unauditedinterimstmtreq,Decimal unauditedinterimavailablevalue,string Period, string Includebalancesheetprofitlossacc
                                                    ,decimal available, string Otherfinancialinformation)
{
system.debug('appPrdId::'+appPrdId);
try{
Application_Product_CPF__c appPrdctCpf =new Application_Product_CPF__c(Id = appPrdId);

if(appPrdctCpf!=null){
    appPrdctCpf.Parent_to_provide_the_bank_with_financia__c  = Parenttoprovidethebankwithfinancia;
    appPrdctCpf.Guarantor_s_to_provide_the_bank_with_fi__c   = GuarantortoprovideBankfinancialinfo;
    appPrdctCpf.Borrower_has_subsidiaries__c = Borrowerhassubsidiaries;
    appPrdctCpf.Guarantor_s_has_have_subsidiaries__c = Guarantorshashavesubsidiaries;
    appPrdctCpf.Financial_statements_available_no_later__c = Financialstmtavailablenolater;
    appPrdctCpf.Unaudited_interim_statements_required__c = Unauditedinterimstmtreq;
    appPrdctCpf.Include_balance_sheet_profit_loss_acc__c = Includebalancesheetprofitlossacc;
    appPrdctCpf.Available__c = available;
    appPrdctCpf.Period__c = Period;
    appPrdctCpf.Other_financial_information__c = Otherfinancialinformation;
    appPrdctCpf.Financial_information_required__c = amendment;
    appPrdctCpf.Unaudited_interim_statements_available__c = unauditedinterimavailablevalue;
    update appPrdctCpf;
}
return appPrdctCpf;
}
catch(Exception e){
system.debug(e.getMessage());
return null;
}
}

/**
* @description
* @author  | 2021-06-07
* @param appProductCPFId
* @return LIST<Application_Lease_CPF__c>
**/
@AuraEnabled
public static LIST<Application_Lease_CPF__c> getLease(Id appProductCPFId) {
//LIST<Application_Lease_CPF__c> leaseRecordList = [SELECT Id, Name, Tenant_Name__c, Tenant_until_Date__c, Tenant_from_Date__c, Lease_Area__c, Rent_per_Month__c, Rent_Type__c, Tenant_Escalations__c, Type__c, Other_Lease__c FROM Application_Lease_CPF__c WHERE Application_Product_CPF__c =:appProductCPFId ORDER BY Name ASC];
LIST<Application_Lease_CPF__c> leaseRecordList = new ApplicationLeaseCPFSelector().selectByAppId(appProductCPFId); // always use Selectors please
return leaseRecordList;
}

/**
* @description
* @author  | 2021-06-07
* @param leaseRecordList
* @param deletedLeaseRecordList
* @param appProductCPFId
* @param leaseOptionsValue
* @param otherLeasesValue
**/
@AuraEnabled
public static Void synchronizeLeaseRecords(List<Application_Lease_CPF__c> leaseRecordList, List<Application_Lease_CPF__c> deletedLeaseRecordList, String appProductCPFId, String leaseOptionsValue, String otherLeasesValue) {
if (leaseRecordList != null && leaseRecordList.size() > 0) {
upsert leaseRecordList;
}
if (deletedLeaseRecordList != null && deletedLeaseRecordList.size() > 0) {
delete deletedLeaseRecordList;
}

Application_Product_CPF__c appPrdctCpf = new Application_Product_CPF__c(Id = appProductCPFId);
if (String.isNotBlank(leaseOptionsValue)) {
appPrdctCpf.Lease_options__c = leaseOptionsValue;
}
if (String.isNotBlank(otherLeasesValue)) {
appPrdctCpf.Other_Leases__c = otherLeasesValue;
}
update appPrdctCpf;
}

/**
* @description
* @author  | 2021-06-07
* @param recId
* @param furtherlist
* @return Application_Product_CPF__c
**/
@AuraEnabled
public static Application_Product_CPF__c furtherAppPrdctcpfinsertAppContract(Id recId,List<Application_Contract_Clause__c> furtherlist) {
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
try{
if(appPrdctCpf!=null){
    List<Application_Contract_Clause__c> dellist = new  List<Application_Contract_Clause__c>();
    dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'Other Application','Other Condition Precedent');
    if(!dellist.isEmpty()) {
        delete dellist;
    }
    for(Application_Contract_Clause__c finobj : furtherlist) {
        finobj.Id= null;
        finobj.Application_Product_CPF__c=appPrdctCpf.Id;
        finobj.Type__c='Other Condition Precedent';
        finobj.Category__c='Other Application';
    }
    insert furtherlist;
}
return appPrdctCpf;
}catch(Exception e){
system.debug(e.getMessage());
return null;
}
}

/**
* @description
* @author  | 2021-06-07
* @param recId
* @param otherEntitySubsidoriesList
* @param otherEntitiesList
* @param theBankReserveRightTo
* @param alreadyHeld
* @param fstatement
* @param finStmtBorrow
* @param Includingfinstatement
* @param finStmtGurator
* @param finConsolaated
* @return List<Application_Contract_Clause__c>
**/
@AuraEnabled
public static List<Application_Contract_Clause__c> insertFinancialStatement(Id recId,List<Application_Contract_Clause__c> otherEntitySubsidoriesList,
                                                                    List<Application_Contract_Clause__c> otherEntitiesList,
                                                                    string theBankReserveRightTo,string alreadyHeld,string fstatement,Date finStmtBorrow,string Includingfinstatement,Date finStmtGurator,Date finConsolaated) {
                                                                        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
                                                                        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
                                                                        String errorMessage;
                                                                        List<Application_Contract_Clause__c> returnList = new List<Application_Contract_Clause__c>();
                                                                        try{
                                                                            if(appPrdctCpf!=null){
                                                                                appPrdctCpf.The_bank_reserves_the_right_to__c = theBankReserveRightTo;
                                                                                appPrdctCpf.Already_Held__c = alreadyHeld;
                                                                                appPrdctCpf.Financial_statements__c = fstatement;
                                                                                appPrdctCpf.Financial_statements_for_year_ended_bo__c = finStmtBorrow;
                                                                                appPrdctCpf.Including_financial_statements_of_guaran__c = Includingfinstatement;
                                                                                appPrdctCpf.Financial_statements_for_year_ended_gu__c = finStmtGurator;
                                                                                appPrdctCpf.Consolidated_financial_statements_for_y__c = finConsolaated;
                                                                                update appPrdctCpf;
                                                                                List<Application_Contract_Clause__c> dellist = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','other entities and subsidiaries');
                                                                                List<Application_Contract_Clause__c> dellist1 = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','other entities');

                                                                                if(!dellist.isEmpty()) {
                                                                                    delete dellist;
                                                                                }
                                                                                if(!dellist1.isEmpty()) {
                                                                                    delete dellist1;
                                                                                }
                                                                                if(otherEntitySubsidoriesList.size() >0 && !otherEntitySubsidoriesList.isEmpty()){
                                                                                    for(Application_Contract_Clause__c otherEntitySubsidories : otherEntitySubsidoriesList) {
                                                                                        otherEntitySubsidories.Id = null;
                                                                                        otherEntitySubsidories.Application_Product_CPF__c=appPrdctCpf.Id;
                                                                                        otherEntitySubsidories.Category__c='CPF Application';
                                                                                        otherEntitySubsidories.Type__c='other entities and subsidiaries';
                                                                                    }
                                                                                }

                                                                                if(otherEntitiesList.size() >0 && !otherEntitiesList.isEmpty()){
                                                                                    for(Application_Contract_Clause__c otherEntities : otherEntitiesList) {
                                                                                        otherEntities.Id = null;
                                                                                        otherEntities.Application_Product_CPF__c=appPrdctCpf.Id;
                                                                                        otherEntities.Category__c='CPF Application';
                                                                                        otherEntities.Type__c='other entities';
                                                                                    }
                                                                                }
                                                                                // update appPrdctCpf;
                                                                                if(otherEntitySubsidoriesList.size() >0 & !otherEntitySubsidoriesList.isEmpty()){
                                                                                    insert otherEntitySubsidoriesList;
                                                                                    returnList.addAll(otherEntitySubsidoriesList);
                                                                                }
                                                                                if(otherEntitiesList.size() >0 & !otherEntitiesList.isEmpty()){
                                                                                    insert otherEntitiesList;
                                                                                    returnList.addAll(otherEntitiesList);
                                                                                }
                                                                            }

                                                                            return returnList;
                                                                        }catch(Exception e){
                                                                            system.debug('Error Message :' + e.getMessage()+'Error Cause :' + e.getCause()+'Error Where:' + e.getLineNumber());
                                                                            // throw new AuraHandledException('Error: ' + errorMessage);
                                                                            return null;
                                                                        }
                                                                    }
/**
* @description
* @author  | 2021-06-07
* @param oppId
* @return Map<Object, Object>
**/
@AuraEnabled
public static Map<Object,Object> getContractClauseData(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Map<Object,Object> dataMap = new Map<Object,Object>();

Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
dataMap.put('theBankReserveRightTo', appPrdctCpf.The_bank_reserves_the_right_to__c);
dataMap.put('alreadyHeld', appPrdctCpf.Already_Held__c);
dataMap.put('fstatement', appPrdctCpf.Financial_statements__c);
dataMap.put('finStmtBorrow', appPrdctCpf.Financial_statements_for_year_ended_bo__c);
dataMap.put('Includingfinstatement', appPrdctCpf.Including_financial_statements_of_guaran__c);
dataMap.put('finStmtGurator', appPrdctCpf.Financial_statements_for_year_ended_gu__c);
dataMap.put('finConsolaated', appPrdctCpf.Consolidated_financial_statements_for_y__c);
List<Application_Contract_Clause__c> otherEntitiessubsideries = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','other entities and subsidiaries');
List<Application_Contract_Clause__c> otherentites = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application','other entities');
dataMap.put('otherEntitiessubsideries', otherEntitiessubsideries);
dataMap.put('otherentites', otherentites);
return dataMap;
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

/**@description Wrapper Class To Map the response from json
*/
public class appProductcpf{
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String amendmentClause {get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal CPFAccNumber{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String chargingDate{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String withdrawal{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal equityContributionsAmt{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal litThreshloldAmt{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String ownerOccupied{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String equityContributions{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal thresholdAmount{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String otherEquity{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal cdThresholdAmt{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String bUnderCPA{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String fPurpose{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String equity{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String uThreshold{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String tPeriods{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String aFinanceDocs{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String aFinanceDocsRequired{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String fLoanOptions{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String pApprovedByCred{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String pDescription{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String pDescription1{get;set;}
// @auraEnabled public String propertyselval{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String pSelection{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String pPortfolioDescription{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String transactionalBankingAccounts{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String includeGuarantors{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String whenValue{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String devfaciPurpose{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String devproptype{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String otherproptype{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String devpropDescription{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String devDescription{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String devloanvatfaciamt{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal aggmaxiamt{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal amtoutstanding{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal devloanterm{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String devloanfinalrepaypick{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Date dateoffinalrepay{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String devloanpurpose{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal vatfacifee{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String vatrepayoptions{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String insterestfreq{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public Decimal vatfacifinalinstalamt{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public String devloanisvat{get;set;}
/**
* @description Wrapper Class To Map  field value to app product
*/
@auraEnabled public List<Application_Portfolio__c> newPortfolios{get;set;}


}









}