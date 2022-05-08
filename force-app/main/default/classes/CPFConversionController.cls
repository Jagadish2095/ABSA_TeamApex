/**
 * @description       :Controller Class for CPFConversionSection Component
 * @author            :Diksha Wasekar
 * @last modified on  : 2021-06-30
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2021-06-17      Initial Version
**/
public class CPFConversionController {
    /**
    * @description Method to get AppProdctCpfRec
    * @author  | 2021-06-17
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
    * @description Method to get AppContractClauseRec
    * @author  | 2021-06-17
    * @param oppId
    * @param type
    * @return LIST<Application_Contract_Clause__c>
    **/
    @AuraEnabled
    public static LIST<Application_Contract_Clause__c> getAppContractClauseRec(Id oppId, string type) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        LIST<Application_Contract_Clause__c> appConClausecList = new ApplicationContractClauseCPFSelector().selectByAppPrdctId(appPrdctCpf.Id,'CPF Application',type);
        return appConClausecList;
    }

    /**
    * @description Method to get ApplicationFeesRec
    * @author  | 2021-06-17
    * @param oppId
    * @return List<Application_Fees__c>
    **/
    @AuraEnabled
    public static List<Application_Fees__c> getApplicationFeesRec(Id oppId) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        List<Application_Fees__c> AppFeeslist = new ApplicationFeesSelector().selectByAppFeeswithtype(appPrdctCpf.Id,'Conversion');
        return AppFeeslist;

    }


    /**
    * @description Method to update App Product CPF Rec
    * @author  | 2021-06-17
    * @param recId
    * @param objData
    * @return Application_Product_CPF__c
    **/
    @AuraEnabled
    public static Application_Product_CPF__c updateAppPrdctcpf(Id recId,String objData
                                                              ) {
                                                                  system.debug('recId'+recId);
                                                                  system.debug('objData'+objData);
                                                                  appProductcpf responseBean=new appProductcpf ();
                                                                  responseBean= (appProductcpf)JSON.deserialize(objData,appProductcpf.class);

                                                                  Application_Product_CPF__c appPrdctCpf= new Application_Product_CPF__c();

                                                                  if(appPrdctCpf!=null){
                                                                      appPrdctCpf.Id =recId;
                                                                      appPrdctCpf.Conversion_options__c = responseBean.conversion;
                                                                      appPrdctCpf.Total_facility_limit_on_amendment_date__c = responseBean.totalfacilimitonamenddate;
                                                                      appPrdctCpf.Final_repayment_date_after_conversion__c = responseBean.finalrepaydateafterconversion;
                                                                      appPrdctCpf.Number_of_periods__c = responseBean.numofperiods;
                                                                      appPrdctCpf.Term__c = responseBean.term;
                                                                      appPrdctCpf.Interest_payment_day__c = responseBean.interestpayday;
                                                                      appPrdctCpf.Interest_rate_basis__c = responseBean.interestbasis;
                                                                      appPrdctCpf.Net_margin__c = responseBean.netmargin;
                                                                      appPrdctCpf.All_in_risk_margin__c = responseBean.allinriskmargin;
                                                                      appPrdctCpf.Fixed_rate_period__c = responseBean.fixedrateperiod;
                                                                      appPrdctCpf.Prime_rate_margin__c = responseBean.primeratemargin;
                                                                      appPrdctCpf.Margin__c = responseBean.margin;
                                                                      appPrdctCpf.Flexi_fee__c = responseBean.flexifee;
                                                                      appPrdctCpf.Gap_insurance__c = responseBean.gapinsurance;
                                                                      appPrdctCpf.Early_termination_fee__c = responseBean.EarlyTerminationFee;
                                                                      appPrdctCpf.Early_termination_fee_year_1__c = responseBean.earlyTermFeeYr1;
                                                                      appPrdctCpf.Early_termination_fee_year_2__c = responseBean.earlyTermFeeYr2;
                                                                      appPrdctCpf.Early_termination_fee_year_3__c = responseBean.earlyTermFeeYr3;
                                                                      appPrdctCpf.Early_termination_fee_further_years__c = responseBean.earlyTermFeeFurtherYrs;
                                                                      appPrdctCpf.Repayment_options__c = responseBean.repaymentoptions;
                                                                      appPrdctCpf.Instalment_periods__c = responseBean.instalmentperiods;
                                                                      appPrdctCpf.Interest_service_frequency__c = responseBean.interestservicefreq;
                                                                      appPrdctCpf.Instalment_amount__c = responseBean.instalamt;
                                                                      appPrdctCpf.Interest_Only_Period__c = responseBean.interestonlyperiods;
                                                                      appPrdctCpf.Starting_Stepped_Instalment__c = responseBean.startingsteppedinstal;
                                                                      appPrdctCpf.Escalating_Perc__c = responseBean.escalatingper;
                                                                      appPrdctCpf.Number_of_periods_after_first_drawdown__c = responseBean.numberofperiods;
                                                                      appPrdctCpf.Final_Instalment_Amount__c = responseBean.finalinstalamt;
                                                                      appPrdctCpf.Equal_Instalments__c = responseBean.equalinstalments;

                                                                      List<Application_Fees__c> dellist = new  List<Application_Fees__c>();
                                                                      dellist =  new ApplicationFeesSelector().selectByAppFeeswithtype(recId,'Conversion');
                                                                      if(!dellist.isEmpty() && !dellist.isEmpty() && dellist.size()>0) {
                                                                          delete dellist;
                                                                      }
                                                                      for(Application_Fees__c otherfeesobj : responseBean.newFeesAfterConnversion) {
                                                                          otherfeesobj.Id= null;
                                                                          otherfeesobj.Application_Product_CPF__c=recId;
                                                                          otherfeesobj.Type__c='Conversion';
                                                                      }
                                                                      insert responseBean.newFeesAfterConnversion;

                                                                      List<Application_Contract_Clause__c> dellistotherdrawdown = new ApplicationContractClauseCPFSelector().selectByAppPrdctwithtypecategory(recId ,'CPF Application','Conversion');
                                                                      if(!dellistotherdrawdown.isEmpty()) {
                                                                          delete dellistotherdrawdown;
                                                                      }
                                                                      for(Application_Contract_Clause__c otherdrawdown : responseBean.newConditionsAfterConnversion) {
                                                                          otherdrawdown.Id= null;
                                                                          otherdrawdown.Application_Product_CPF__c=recId;
                                                                          otherdrawdown.Type__c='Conversion';
                                                                          otherdrawdown.Category__c='CPF Application';
                                                                      }
                                                                      insert responseBean.newConditionsAfterConnversion;


                                                                  }
                                                                  update appPrdctCpf;
                                                                  return appPrdctCpf;

                                                              }

    /**@description Wrapper Class To Map the response from json
*
*
*/
    public class appProductcpf{
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String conversion {get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal totalfacilimitonamenddate{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String finalrepaydateafterconversion{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal numofperiods{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal term{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal interestpayday{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String interestbasis{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal netmargin{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal allinriskmargin{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal fixedrateperiod{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String primeratemargin{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal margin{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal flexifee{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String gapinsurance{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public List<Application_Fees__c> newFeesAfterConnversion{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public List<Application_Contract_Clause__c> newConditionsAfterConnversion{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String EarlyTerminationFee{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal earlyTermFeeYr1{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal earlyTermFeeYr2{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal earlyTermFeeYr3{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String earlyTermFeeFurtherYrs{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String repaymentoptions{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String instalmentperiods{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public String interestservicefreq{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal instalamt{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal interestonlyperiods{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal startingsteppedinstal{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal escalatingper{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal numberofperiods{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal finalinstalamt{get;set;}
        /** @description Wrapper Class To Map the field value in Application Product CPF Rec
*/
        @auraEnabled public Decimal equalinstalments{get;set;}
    }


}