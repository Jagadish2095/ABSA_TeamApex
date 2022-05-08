/**
 * @description Extension Controller for CPF Pre sales  Component for CPF Onboarding
 * @author  Haritha P : Absa
 * @version v1.0
 * @since   2021-05-25
 * @Testclass : CPFPresalescntrlrTest
 * @param cpfpresales
 * @return Pre-sales
 */
public class CPFPresalescntrlr {
/**
 * @description get all Application Product records
 * @param oppId
 * @return Application_Product_CPF__c
 */
@AuraEnabled
public static Application_Product_CPF__c getAppProdctCpfRec(Id oppId) {
List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
system.debug('app' + app);
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
system.debug('appPrdctCpf' + appPrdctCpf);
return appPrdctCpf;
}
/**
 * @description get all Application contract clause records
 * @param oppId
 * @param type
 * @return LIST<Application_Contract_Clause__c>
 */
@AuraEnabled
public static LIST<Application_Contract_Clause__c> getAppContractClauseRec(Id oppId, string type) {
List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Contract_Clause__c> appConClausecList = new ApplicationContractClauseCPFSelector()
.selectByAppPrdctId(appPrdctCpf.Id, 'CPF Application', type);
return appConClausecList;
}
/**
 * @description get all Application Phase CPF records
 * @param oppId
 * @param type
 * @return LIST<Application_Phase_CPF__c>
 */
@AuraEnabled
public static LIST<Application_Phase_CPF__c> getAppPhaseCPFRec(Id oppId, string type) {
List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
LIST<Application_Phase_CPF__c> appPhasecpfList = new ApplicationPhasesCPFSelector().selectByAppPhasewithtype(appPrdctCpf.Id, 'Per Phase');
return appPhasecpfList;
}
/**
 * @description get all Application Phase CPF records
 * @param recId
 * @param newOtherDrawDownConditions
 * @param newOtherFinalDrawDownConditions
 * @param approvedsectitleplans
 * @param uponcompofdev
 * @param finaldatefordrawdown
 * @return LIST<Application_Contract_Clause__c>
 */
@AuraEnabled
public static list<Application_Contract_Clause__c> insertOtherDrawDownConditions(
Id recId,
List<Application_Contract_Clause__c> newOtherDrawDownConditions,
List<Application_Contract_Clause__c> newOtherFinalDrawDownConditions,
string approvedsectitleplans,
string uponcompofdev,
date finaldatefordrawdown
) {
List<Application_Contract_Clause__c> appConlst = new List<Application_Contract_Clause__c>();
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectById(recId);

try {
if (recId != null) {
appPrdctCpf.Is_Sectional_Title_Plan_Approved__c = approvedsectitleplans;
appPrdctCpf.Is_Upon_Completion_Of_Development__c = uponcompofdev;
appPrdctCpf.Final_date_for_drawdown_Date__c = finaldatefordrawdown;
update appPrdctCpf;
List<Application_Contract_Clause__c> dellistotherdrawdown = new ApplicationContractClauseCPFSelector()
	.selectByAppPrdctwithtypecategory(recId, 'CPF Application', 'Other Drawdown conditions');
if (!dellistotherdrawdown.isEmpty()) {
	delete dellistotherdrawdown;
}
for (Application_Contract_Clause__c otherdrawdown : newOtherDrawDownConditions) {
	otherdrawdown.Id = null;
	otherdrawdown.Application_Product_CPF__c = recId;
	otherdrawdown.Type__c = 'Other Drawdown conditions';
	otherdrawdown.Category__c = 'CPF Application';
}
insert newOtherDrawDownConditions;
appConlst.addAll(newOtherDrawDownConditions);

List<Application_Contract_Clause__c> dellistotherfinaldrawdown = new ApplicationContractClauseCPFSelector()
	.selectByAppPrdctwithtypecategory(recId, 'CPF Application', 'Other Final Drawdown Conditions');
if (!dellistotherfinaldrawdown.isEmpty()) {
	delete dellistotherfinaldrawdown;
}
for (Application_Contract_Clause__c otherfinaldrawdown : newOtherFinalDrawDownConditions) {
	otherfinaldrawdown.Id = null;
	otherfinaldrawdown.Application_Product_CPF__c = recId;
	otherfinaldrawdown.Type__c = 'Other Final Drawdown Conditions';
	otherfinaldrawdown.Category__c = 'CPF Application';
}
insert newOtherFinalDrawDownConditions;
appConlst.addAll(newOtherFinalDrawDownConditions);
}

return appConlst;
} catch (Exception e) {
throw new AuraHandledException('Other DrawDown Condition cannot be inserted error occurred' + e.getMessage());
}
}
/**
 * @description get all Application Phase CPF records
 * @param recId
 * @param newOtherprelodgmentConditions
 * @return LIST<Application_Contract_Clause__c>
 */
@AuraEnabled
public static list<Application_Contract_Clause__c> insertPreLodgmentConditions(
Id recId,
List<Application_Contract_Clause__c> newOtherprelodgmentConditions
) {
List<Application_Contract_Clause__c> appConlst = new List<Application_Contract_Clause__c>();
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectById(recId);

try {
if (recId != null) {
List<Application_Contract_Clause__c> dellistotherprelodgment = new ApplicationContractClauseCPFSelector()
	.selectByAppPrdctwithtypecategory(recId, 'CPF Application', 'Other Pre-Lodgement Conditions');
if (!dellistotherprelodgment.isEmpty()) {
	delete dellistotherprelodgment;
}
for (Application_Contract_Clause__c otherprelodgments : newOtherprelodgmentConditions) {
	otherprelodgments.Id = null;
	otherprelodgments.Application_Product_CPF__c = recId;
	otherprelodgments.Type__c = 'Other Pre-Lodgement Conditions';
	otherprelodgments.Category__c = 'CPF Application';
}
insert newOtherprelodgmentConditions;
appConlst.addAll(newOtherprelodgmentConditions);
}

return appConlst;
} catch (Exception e) {
throw new AuraHandledException('Other Pre-Lodgment Condition cannot be inserted error occurred' + e.getMessage());
}
}
/**
 * @description get all Application Phase CPF records
 * @param recId
 * @param newOtherpredisbursementConditions
 * @return LIST<Application_Contract_Clause__c>
 */
@AuraEnabled
public static list<Application_Contract_Clause__c> insertpredisbursement(Id recId, List<Application_Contract_Clause__c> newOtherpredisbursementConditions) {
List<Application_Contract_Clause__c> appConlst = new List<Application_Contract_Clause__c>();
Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectById(recId);

try {
if (recId != null) {
List<Application_Contract_Clause__c> dellistotherprelodgment = new ApplicationContractClauseCPFSelector()
	.selectByAppPrdctwithtypecategory(recId, 'CPF Application', 'Other Pre-Disbursement Conditions');
if (!dellistotherprelodgment.isEmpty()) {
	delete dellistotherprelodgment;
}
for (Application_Contract_Clause__c otherpredisbursement : newOtherpredisbursementConditions) {
	otherpredisbursement.Id = null;
	otherpredisbursement.Application_Product_CPF__c = recId;
	otherpredisbursement.Type__c = 'Other Pre-Disbursement Conditions';
	otherpredisbursement.Category__c = 'CPF Application';
}
insert newOtherpredisbursementConditions;
appConlst.addAll(newOtherpredisbursementConditions);
}

return appConlst;
} catch (Exception e) {
throw new AuraHandledException('Other Pre-Disbursement Condition cannot be inserted error occurred' + e.getMessage());
}
}
/**
 * @description get all Application Phase CPF records
 * @param recId
 * @param objData
 * @return Application_Product_CPF__c
 */
@AuraEnabled
public static Application_Product_CPF__c updateAppPrdctcpf(Id recId, String objData) {
preSaleswrapper responseBean = new preSaleswrapper();
responseBean = (preSaleswrapper) JSON.deserialize(objData, preSaleswrapper.class);

Application_Product_CPF__c appPrdctCpf = new Application_Product_CPF__c();

if (appPrdctCpf != null) {
appPrdctCpf.Id = recId;
appPrdctCpf.Pre_sales__c = responseBean.presalesvalue;
appPrdctCpf.Non_refundable_deposit__c = responseBean.nonrefundabledepositvalue;
appPrdctCpf.Non_refundable_deposit_amount__c = responseBean.nonrefundabledepositamount;
appPrdctCpf.Non_refundable_deposit_percentage__c = responseBean.nonrefundabledepositpercentage;
appPrdctCpf.Multiple_purchase__c = responseBean.multiplepurchasesvalue;
appPrdctCpf.Multiple_purchase_deposit_amount__c = responseBean.multiplepurchaseamount;
appPrdctCpf.Multiple_purchase_Deposit_percentage__c = responseBean.multipurposepercentage;
appPrdctCpf.Proof_of_Pre_sales__c = responseBean.proofofprevalue;
appPrdctCpf.Number_of_pre_sales__c = responseBean.numberofpresales;
appPrdctCpf.Aggregate_price__c = responseBean.aggregateprice;
appPrdctCpf.Schedule_of_net_sale__c = responseBean.schedulenetsalevalue;
appPrdctCpf.Schedule_of_sales__c = responseBean.scheduleofsalevalue;
appPrdctCpf.Max_by_single_investor__c = responseBean.maxbysingleinvestor;
appPrdctCpf.Copy_of_standard_sales_agreement__c = responseBean.copyofstandardsalesvalue;
appPrdctCpf.Copies_of_all_sale_agreements__c = responseBean.copiesofallsalesaggrementsvalue;

List<Application_Phase_CPF__c> dellistPerphase = new ApplicationPhasesCPFSelector().selectByAppPhasewithtype(recId, 'Per Phase');
if (!dellistPerphase.isEmpty()) {
delete dellistPerphase;
}
for (Application_Phase_CPF__c PerphaseItem : responseBean.newperphase) {
PerphaseItem.Id = null;
PerphaseItem.Application_Product_CPF__c = recId;
PerphaseItem.Type__c = 'Per Phase';
}
insert responseBean.newperphase;
}
update appPrdctCpf;
system.debug('appPrdctCpf---' + appPrdctCpf);
system.debug('responseBean.newperphase---' + responseBean.newperphase);
return appPrdctCpf;
}
/** @description Wrapper Class To Map the response from json
 */
public class preSaleswrapper {
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public String presalesvalue { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public String nonrefundabledepositvalue { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public Decimal nonrefundabledepositamount { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public Decimal nonrefundabledepositpercentage { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public String multiplepurchasesvalue { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public Decimal multiplepurchaseamount { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public Decimal multipurposepercentage { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public String proofofprevalue { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public Decimal numberofpresales { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public Decimal aggregateprice { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public List<Application_Phase_CPF__c> newperphase { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public String schedulenetsalevalue { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public String scheduleofsalevalue { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public Decimal maxbysingleinvestor { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public String copyofstandardsalesvalue { get; set; }
/** @description Wrapper Class To Map the field value from App Phase Rec
 */
@auraEnabled
public String copiesofallsalesaggrementsvalue { get; set; }
}
}