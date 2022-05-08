/**
*  @description Extension Controller for CPFFeeDetails Component
* @author  Haritha P : Absa
* @version v1.0
* @since   2021-1-02
*/
public class CPFFeesDetailsController{

/**
 * @description method to get ApplicationProductCPf rec.
 * @param oppId
 * @return Application_Product_CPF__c
 */
@AuraEnabled
public static Application_Product_CPF__c getAppProdctCpfRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
/*[select id,Name , Cancellation_fee_payable__c , Admin_fee__c, Admin_fee_amount__c, Account_type__c,Restructure_fee__c , Commitment_Fee__c ,Payable__c, Valuation_fee__c,Valuation_fee_amount__c,Include_admin_fee_in_total_facility__c, Flexi_facility__c, Early_termination_fee__c ,
Early_termination_fee_year_1__c , Early_termination_fee_year_2__c, Early_termination_fee_year_3__c , Early_termination_fee_further_years__c,Prepayment_fee__c , Early_prepayment_fee_year_1__c,
Early_prepayment_fee_year_2__c, Early_prepayment_fee_year_3__c ,Early_prepayment_fee_further_years__c, Cancellation_after_acceptance_clause__c,Late_bond_registration_penalty__c
from  Application_Product_CPF__c where Application__r.Id =:app[0].Id];*/
return appPrdctCpf;

}

/**
 * @description method to get ApplicationProductCPf rec.
 * @param recId
 * @param cancelFee
 * @param incAdminFeeTotFacility2
 * @param adminFee
 * @param adminFeeAmt
 * @param payable
 * @param incAdminFee
 * @param accType
 * @param restrucFee
 * @param commitFee
 * @param valFee
 * @param valFeeAmt
 * @param incAdminFeeTotFacility
 * @param flexiFac
 * @param earlyTermFee
 * @param earlyTermFeeY1
 * @param earlyTermFeeY2
 * @param earlyTermFeeY3
 * @param earlyTermFeeFurthrYrs
 * @param prepFee
 * @param cancelAtrAccept
 * @param lateBondPnlty
 * @param earlyPreFeeY1
 * @param earlyPreFeeY2
 * @param earlyPreFeeY3
 * @param earlyPreFeeFurtherYrs
 * @param otherfeesapplicable
 * @return Application_Product_CPF__c
 */
@AuraEnabled
public static Application_Product_CPF__c updateAppPrdctcpf(Id recId,decimal cancelFee ,string incAdminFeeTotFacility2,string adminFee ,decimal adminFeeAmt, string payable , string incAdminFee , string accType ,decimal restrucFee, decimal commitFee, string valFee,decimal valFeeAmt,
                                string incAdminFeeTotFacility,decimal flexiFac, string earlyTermFee, decimal earlyTermFeeY1, decimal earlyTermFeeY2 ,decimal earlyTermFeeY3 ,string earlyTermFeeFurthrYrs,string prepFee,
                                string cancelAtrAccept, string lateBondPnlty,decimal earlyPreFeeY1,decimal earlyPreFeeY2,decimal earlyPreFeeY3,string earlyPreFeeFurtherYrs,string otherfeesapplicable
                                ) {

                                    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
                                    /*[select id,Name , Cancellation_fee_payable__c , Admin_fee__c,Admin_fee_amount__c ,Account_type__c,Payable__c, Restructure_fee__c , Commitment_Fee__c , Valuation_fee__c,Valuation_fee_amount__c,Include_admin_fee_in_total_facility__c,Include_admin_fee_in_total_facility2__c ,Flexi_facility__c, Early_termination_fee__c ,
Early_termination_fee_year_1__c , Early_termination_fee_year_2__c, Early_termination_fee_year_3__c , Early_termination_fee_further_years__c,Prepayment_fee__c , Early_prepayment_fee_year_1__c,
Early_prepayment_fee_year_2__c, Early_prepayment_fee_year_3__c ,Early_prepayment_fee_further_years__c, Cancellation_after_acceptance_clause__c,Late_bond_registration_penalty__c
from Application_Product_CPF__c where Id =:recId]; */


                                    try{
                                        if(appPrdctCpf!=null){

                                            appPrdctCpf.Cancellation_fee_payable__c = cancelFee;
                                            appPrdctCpf.Admin_fee__c = adminFee;
                                            appPrdctCpf.Admin_fee_amount__c= adminFeeAmt;
                                            appPrdctCpf.Account_type__c = accType;
                                            appPrdctCpf.Restructure_fee__c = restrucFee;
                                            appPrdctCpf.Payable__c = payable;
                                            appPrdctCpf.Commitment_Fee__c = commitFee;
                                            appPrdctCpf.Valuation_fee__c = valFee;
                                            appPrdctCpf.Valuation_fee_amount__c = valFeeAmt;
                                            appPrdctCpf.Include_admin_fee_in_total_facility__c = incAdminFeeTotFacility;
                                            appPrdctCpf.Include_admin_fee_in_total_facility2__c = incAdminFeeTotFacility2;
                                            appPrdctCpf.Flexi_facility__c = flexiFac;
                                            appPrdctCpf.Early_termination_fee__c = earlyTermFee;
                                            appPrdctCpf.Early_termination_fee_year_1__c = earlyTermFeeY1;
                                            appPrdctCpf.Early_termination_fee_year_2__c = earlyTermFeeY2;
                                            appPrdctCpf.Early_termination_fee_year_3__c = earlyTermFeeY3;
                                            appPrdctCpf.Early_termination_fee_further_years__c = earlyTermFeeFurthrYrs;
                                            appPrdctCpf.Prepayment_fee__c = prepFee;
                                            appPrdctCpf.Early_prepayment_fee_year_1__c = earlyPreFeeY1;
                                            appPrdctCpf.Early_prepayment_fee_year_2__c = earlyPreFeeY2;
                                            appPrdctCpf.Early_prepayment_fee_year_3__c = earlyPreFeeY3;
                                            appPrdctCpf.Early_prepayment_fee_further_years__c=earlyPreFeeFurtherYrs;
                                            appPrdctCpf.Cancellation_after_acceptance_clause__c = cancelAtrAccept;
                                            appPrdctCpf.Late_bond_registration_penalty__c = lateBondPnlty;
                                            appPrdctCpf.Other_fees_applicable__c= otherfeesapplicable;
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
 *  @description Method to get all the opportunity products
*  @param oppId
*  @return List<OpportunityLineItem>
*/
@AuraEnabled
public static List<OpportunityLineItem> getprodName(Id oppId) {
List<OpportunityLineItem> opplineitemlst =new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
return opplineitemlst;
}

/**
 *  @description Method to insert otherfeesdetaillist of Fees Details Type
*  @param recId
*  @param otherfeesdetaillist
*  @return List<Application_Fees__c>
*/
@AuraEnabled
public static List<Application_Fees__c> OtherFeesDetailUpdate(Id recId,List<Application_Fees__c> otherfeesdetaillist) {
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
try{
if(appPrdctCpf!=null){
List<Application_Fees__c> dellist = new  List<Application_Fees__c>();
dellist =  new ApplicationFeesSelector().selectByAppFeeswithtype(appPrdctCpf.Id,'Fees Details');
//  dellist = [select id,name,Fees_description__c,Application_Product_CPF__c,Fees_value__c from Application_Fees__c where Application_Product_CPF__c =: appPrdctCpf.Id AND Type__c='Fees Details' ORDER BY Name ASC];
if(!dellist.isEmpty() && !dellist.isEmpty() && dellist.size()>0) {
delete dellist;
}
for(Application_Fees__c otherfeesobj : otherfeesdetaillist) {
otherfeesobj.Id= null;
otherfeesobj.Application_Product_CPF__c=appPrdctCpf.Id;
otherfeesobj.Type__c='Fees Details';
}
insert otherfeesdetaillist;
}
return otherfeesdetaillist;
}catch(Exception e){
system.debug(e.getMessage());
return null;
}
}
/**
 *  @description Method to get otherfeesdetaillist of Fees Details Type
*  @param oppId
*  @return List<Application_Fees__c>
*/
@AuraEnabled
public static List<Application_Fees__c> getApplicationFeesRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
List<Application_Fees__c> AppFeeslist = new ApplicationFeesSelector().selectByAppFeeswithtype(appPrdctCpf.Id,'Fees Details');
// [select id,name,Fees_description__c,Application_Product_CPF__c,Fees_value__c from Application_Fees__c where Application_Product_CPF__c =: appPrdctCpf.Id AND Type__c='Fees Details' ORDER BY Name ASC];
return AppFeeslist;

}



}