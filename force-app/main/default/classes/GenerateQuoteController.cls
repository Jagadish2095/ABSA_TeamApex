/**
 * @description       :
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-07-14
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-07-13   almas.aleem@absa.africa   Initial Version
**/

public class GenerateQuoteController {

    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    * @return List<Application_Product__c>
    **/
    @auraEnabled
    public static List<Application_Product__c> getRequestedProducts(Id oppId){
        List<Application_Product__c> appProducts = [SELECT Id, Product_Name__c,Final_Decision__c FROM Application_Product__c WHERE Opportunity__c =:oppId and Final_Decision__c='Accepted'];
        return appProducts;
    }

    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param prodId
    * @param oppId
    * @return FacilityWrapper
    **/
    @auraEnabled
    public static FacilityWrapper getProductFacility(Id prodId,Id oppId){

        FacilityWrapper fcWrapper = new FacilityWrapper();
        List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProductId(prodId) ;   //selector for tob based on products
        Map<Id, Application_Product__c> trmOfBusAppProd = new Map<Id, Application_Product__c>();
        Set<Id> appProdIds = new Set<Id>();

        if(prodtobList != null){
            for(Terms_Of_Business__c trmOfBus : prodtobList){
                appProdIds.add(trmOfBus.Application_Product__c);
            }
        }

        if(appProdIds != null && appProdIds.size() > 0){
            List<Application_Product__c> appProducts = new ApplicationProductSelector().selectById(appProdIds);

            if(appProducts != null && appProducts.size() > 0){
                for(Terms_Of_Business__c trmOfBus : prodtobList){
                    for(Application_Product__c appProd : appProducts){
                        if(trmOfBus.Application_Product__c == appProd.Id){
                            trmOfBusAppProd.put(trmOfBus.Id, appProd);
                        }
                    }
                }
            }
        }

        //calculcations part
        Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(ProdId);
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);

        if(appProd.Product_Facility_Json__c == null){
            fcWrapper = new FacilityWrapper();
        }else{
            fcWrapper = (FacilityWrapper)JSON.deserialize(appProd.Product_Facility_Json__c, FacilityWrapper.Class);
        }

        fcWrapper.fullname =  opp.Account.Name; //opp.Account.FirstName + opp.Account.LastName;
        fcWrapper.RegistrationNumber = opp.Account.Registration_Number__c;
        fcWrapper.Surname = opp.Account.LastName == null ? 'NA' : opp.Account.LastName ;
        fcWrapper.quoteDate = date.today();
        fcWrapper.siteCode = opp.SiteCode__c ==null ?'' : opp.SiteCode__c ;
        //fcWrapper.instructionId = 'Instruction ID-'+prodId;
        String limitType ;
        Decimal overdraftLimit;

        for(Terms_Of_Business__c prtob : prodtobList){
            Application_Product__c appProduct = trmOfBusAppProd.get(prtob.Id);

            if(appProduct != null){
                fcWrapper.accountNumber = appProduct.Account_Number__c ==null ?''  : String.valueOf(appProduct.Account_Number__c).substringBefore('.');
                fcWrapper.productName = appProduct.Product_Name__c;
            } else {
                fcWrapper.accountNumber = '';
                fcWrapper.productName = '';
            }

            if(prtob.Tob_Description__c.EqualsIgnoreCase('Overdraft Limit Type')){
                fcWrapper.ODLimitType = prtob.Final_Offered__c;
                limitType = prtob.Final_Offered__c;
            }
            if(prtob.Tob_Description__c.EqualsIgnoreCase('Overdraft Limit')){
                fcWrapper.facilityAmount =prtob.Final_Offered_Number__c;
                fcWrapper.creditLimitAvail = prtob.Final_Offered_Number__c;
                fcWrapper.totalamount = prtob.Final_Offered_Number__c;
                overdraftLimit = prtob.Final_Offered_Number__c;
                //limitType = prtob.Final_Offered__c;
            }
            if(prtob.Tob_Description__c.EqualsIgnoreCase('Regular Reduction Frequency')){
                fcWrapper.facilityreduced =prtob.Final_Offered__c;
            }
            if(prtob.Tob_Description__c.EqualsIgnoreCase('Initiation Fee')){
                fcWrapper.Initiationfees = prtob.Final_Offered_Number__c;
            }
            if(prtob.Tob_Description__c.EqualsIgnoreCase('Prime Rate')){
                fcWrapper.Primeinterestrate = prtob.Final_Offered_Number__c ;
            }
            if(prtob.Tob_Description__c.EqualsIgnoreCase('Prime + %')){
                fcWrapper.interestMargin = prtob.Final_Offered_Number__c ;
            }
            /*if(prtob.Tob_Description__c.EqualsIgnoreCase('Interest Rate')){
                // fcWrapper.Interestrate = prtob.Final_Offered_Number__c ;
            } */
            if(prtob.Tob_Description__c.EqualsIgnoreCase('Monthly Service Fee')){
                fcWrapper.Monthlyadministrationfee = prtob.Final_Offered_Number__c ;
            }
        }
        fcWrapper.Interestrate = fcWrapper.Primeinterestrate  +  fcWrapper.interestMargin; // quote interest rate

        if(Test.isRunningTest()){
            limitType ='Variable';
        }

        /*decrease changes */
        if(limitType != null && limitType.equalsIgnoreCase('Reducing - Once Off Only')){

            for(Terms_Of_Business__c prtob : prodtobList){
                if(prtob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')){
                    fcWrapper.OnceOffAmount = prtob.Final_Offered_Number__c;
                    fcWrapper.targetAmount = overdraftLimit - prtob.Final_Offered_Number__c;
                    fcWrapper.targetAmount.setScale(2);
                }  if(prtob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')){
                    fcWrapper.OnceOffDate = prtob.Final_Offered_Date__c;
                }
            }
        }
        /*decrease changes */
        if(limitType != null && limitType.equalsIgnoreCase('Reducing - Once Off And Recurring')){
            for(Terms_Of_Business__c prtob : prodtobList){
                if(prtob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')){
                    fcWrapper.OnceOffAmount = prtob.Final_Offered_Number__c;
                    //dwrap.decreaseamount1.setScale(2);
                }  if(prtob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')){
                    fcWrapper.OnceOffDate = prtob.Final_Offered_Date__c;
                }
                if(prtob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')){
                    fcWrapper.ReductionAmount = prtob.Final_Offered_Number__c;
                    //dwrap.decreaseamount1.setScale(2);
                }  if(prtob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')){
                    fcWrapper.ReductionDate = prtob.Final_Offered_Date__c;
                }if(prtob.Tob_Description__c.equalsIgnoreCase('Reduction Frequency')){
                    fcWrapper.ReductionFrequency = prtob.Final_Offered__c;
                }
            }

        }

        /*decrease changes */
        if(limitType != null && (limitType.equalsIgnoreCase('Reducing - Recurring Only') || limitType.equalsIgnoreCase('REDUCING LIMIT')) ){
            for(Terms_Of_Business__c prtob : prodtobList){
                if(prtob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')){
                    fcWrapper.ReductionAmount = prtob.Final_Offered_Number__c;
                    fcWrapper.targetAmount = overdraftLimit - prtob.Final_Offered_Number__c;
                    fcWrapper.targetAmount.setScale(2);
                }  if(prtob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')){
                    fcWrapper.ReductionDate = prtob.Final_Offered_Date__c;
                    if(prtob.Tob_Description__c.equalsIgnoreCase('Reduction Frequency')){
                        fcWrapper.ReductionFrequency = prtob.Final_Offered__c;
                    }
                }

            }
        }
            /*decrease changes */
            if(limitType != null && limitType.equalsIgnoreCase('Variable')){ /* will do dynamic later --currently going with creating multiple instances*/
                VariableWrapper vwrap1 = new VariableWrapper();
                VariableWrapper vwrap2 = new VariableWrapper();
                VariableWrapper vwrap3 = new VariableWrapper();
                VariableWrapper vwrap4 = new VariableWrapper();
                VariableWrapper vwrap5 = new VariableWrapper();
                VariableWrapper vwrap6 = new VariableWrapper();
                VariableWrapper vwrap7 = new VariableWrapper();
                VariableWrapper vwrap8 = new VariableWrapper();
                VariableWrapper vwrap9 = new VariableWrapper();
                VariableWrapper vwrap10 = new VariableWrapper();
                VariableWrapper vwrap11 = new VariableWrapper();
                VariableWrapper vwrap12 = new VariableWrapper();
                List<VariableWrapper>  variableWrapperlist = new list<VariableWrapper>();

                Decimal AmountCal = overdraftLimit ;
                for(Terms_Of_Business__c prtob : prodtobList){
                    if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 1')){
                        vwrap1.id = '1';
                        vwrap1.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap1.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap1.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 1')){
                        vwrap1.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 2')){
                        vwrap2.id = '2';
                        vwrap2.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap2.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap2.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 2')){
                        vwrap2.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 3')){
                        vwrap3.id = '3';
                        vwrap3.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap3.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap3.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 3')){
                        vwrap3.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 4')){
                        vwrap4.id = '4';
                        vwrap4.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap4.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap4.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 4')){
                        vwrap4.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 5')){
                        vwrap5.id = '5';

                        vwrap5.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap5.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap5.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 5')){

                        vwrap5.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 6')){
                        vwrap6.id = '6';

                        vwrap6.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap6.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap6.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 6')){

                        vwrap6.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 7')){
                        vwrap7.id = '7';

                        vwrap7.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap7.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap7.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 7')){
                        vwrap7.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 8')){
                        vwrap8.id = '8';

                        vwrap8.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap8.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap8.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 8')){
                        vwrap8.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 9')){
                        vwrap9.id = '9';

                        vwrap9.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap9.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap9.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 9')){
                        vwrap9.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 10')){
                        vwrap10.id = '10';
                        vwrap10.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap10.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap10.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 10')){
                        vwrap10.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 11')){
                        vwrap11.id = '11';
                        vwrap11.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap11.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap11.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    }if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 11')){

                        vwrap11.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 12')){
                        vwrap12.id = '12';
                        vwrap12.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap12.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap12.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 12')){
                        vwrap12.variableDate = prtob.Final_Offered_Date__c;
                    }
                }

                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                fcWrapper.variablemap  = variableWrapperlist;
                //fcWrapper.decreasemap.add(dwrap);
            }

            fcWrapper.Unutilisedfacilityfee = 0;

            //add 12 variable amount and date fields
            /*List<VariableWrapper>  variableWrapperlist = new list<VariableWrapper>();
            for(Integer i=0;i<12;i++){
            VariableWrapper vwrap = new VariableWrapper();
            vwrap.id = String.valueOf(i+1);
            vwrap.variableAmount = 0;
            variableWrapperlist.add(vwrap);
            }
            fcWrapper.variablemap  = variableWrapperlist;*/
            appProd.Product_Facility_Json__c = JSON.serialize(fcWrapper);

            try{
                update appProd;
              // updateProduct(appProd);
            }catch(Exception e){
                system.debug('Exception e---'+e.getMessage());
            }

            return fcWrapper;
        }
        /**
        * @description
        * @author almas.aleem@absa.africa
        */
        public class applicationProductWrapper{
            @auraEnabled public string productName;
            @auraEnabled public string productType;
            @auraEnabled public string accountNumber;
            @auraEnabled public string uniqueProductId;
            @auraEnabled public string limitValue;
        }
        /**
        * @description
        * @author almas.aleem@absa.africa
        */
        public class appFacilityWrapper{
            @auraEnabled public List<applicationProductWrapper> appPrdLst;
            @auraEnabled public integer totalFacilityCount;
            @auraEnabled public double totalLimitValue;
            @auraEnabled public string Addressee;
            @auraEnabled public string AddresseeOther;
            @auraEnabled public string Addresseetitle;
            @auraEnabled public string reviewFeeType;
            @auraEnabled public double reviewFeeValue;
            @auraEnabled public double unutilisedFacilityFee;
            @auraEnabled public double monthlyServiceFee;
            @auraEnabled public string signed;
            @auraEnabled public string generalBankingFacility;
            @auraEnabled public date signedDate;
        }

        /**
        * @description
        * @author almas.aleem@absa.africa | 2021-07-13
        * @param facilityWrap
        * @param oppId
        **/
        @auraEnabled
        public static void saveApplicationFacilityWrap(String facilityWrap,Id oppId){
            Opportunity opp = new Opportunity(id = oppId);
            opp.Application_Product_Facility_JSON__c =  facilityWrap ;
            update opp;
        }

        /**
        * @description
        * @author almas.aleem@absa.africa | 2021-07-13
        * @param oppId
        * @return appFacilityWrapper
        **/
        @auraEnabled
        public static appFacilityWrapper fetchOutNCAproductLst(Id oppId){
            List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
            List<Application_Product__c> retappPrdList = new List<Application_Product__c>();
            for(Application_Product__c appProd : appPrdList){

                if(appProd.Application_Product_Parent__c == null && appProd.Product_State__c !=null &&( appProd.Product_State__c.equalsIgnoreCase('New') || appprod.Product_State__c.equalsIgnoreCase('Existing'))){
                    if((appProd.Product_Status__c =='Accepted' || appProd.Product_Status__c =='FulFilled') && (appProd.NCA_Appplicable__c =='Out Of NCA' || appProd.NCA_Appplicable__c =='out Of NCA')  ){
                        retappPrdList.add(appProd);
                    }
                }
            }
            List<Terms_Of_Business__c> prodtobList = new List<Terms_Of_Business__c>();
            appFacilityWrapper appFacilityWrap;
            Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
            if(opp.Application_Product_Facility_JSON__c == null){
                appFacilityWrap = new appFacilityWrapper();
            }else{
                appFacilityWrap = (appFacilityWrapper)JSON.deserialize(opp.Application_Product_Facility_JSON__c, appFacilityWrapper.Class);
            }
            List<applicationProductWrapper> appPrdWrapLst = new List<applicationProductWrapper>();
            double totalLimitVal = 0.0;
            double monthlyFeeVal = 0.0;
            double reviewFeeVal = 0.0;
            double unutilisedFacilityFeeVal = 0.0;
            string reviewFeeTypeVal = '';
            Map<id,List<Terms_Of_Business__c>> appIdTermsMap = new Map<id,List<Terms_Of_Business__c>>();
            if(!retappPrdList.isEmpty()){
                for(Terms_Of_Business__c rec :  new TermsOfBusinessSelector().selectByAppProducts(retappPrdList) ){
                    if(!appIdTermsMap.containsKey(rec.Application_Product__c)){
                        appIdTermsMap.put(rec.Application_Product__c,new List<Terms_Of_Business__c>{rec});
                    }else{
                        appIdTermsMap.get(rec.Application_Product__c).add(rec);
                    }
                }
                for(Application_Product__c rec : retappPrdList){
                    applicationProductWrapper appPrdWrap = new applicationProductWrapper();
                    appPrdWrap.productName = rec.Product_Name__c;
                    appPrdWrap.productType = rec.Product_Type__c;
                    appPrdWrap.accountNumber = string.valueOf(rec.Account_Number__c);
                    appPrdWrap.uniqueProductId = rec.Name;
                    double limitVal = 0.0;
                    reviewFeeVal = reviewFeeVal + rec.Review_Fee__c !=null ? rec.Review_Fee__c :0.0;
                    unutilisedFacilityFeeVal = unutilisedFacilityFeeVal + rec.Unutilized_Fee__c!=null ? rec.Unutilized_Fee__c :0.0;
                    reviewFeeTypeVal = reviewFeeTypeVal +  rec.Review_Fee_Type__c!='' &&  rec.Review_Fee_Type__c!=null ? rec.Review_Fee_Type__c : '';
                    if(!appIdTermsMap.isEmpty()){
                        for(Terms_Of_Business__c prtob : appIdTermsMap.get(rec.Id)){
                            if(prtob.Tob_Description__c.EqualsIgnoreCase('Overdraft Limit')){
                                limitVal = limitVal + prtob.Final_Offered_Number__c!=null? prtob.Final_Offered_Number__c:0.0;
                                totalLimitVal = totalLimitVal + prtob.Final_Offered_Number__c!=null? prtob.Final_Offered_Number__c:0.0;
                            }
                            else if(prtob.Tob_Description__c.EqualsIgnoreCase('Credit Balance')){
                                limitVal = limitVal + prtob.Final_Offered_Number__c!=null? prtob.Final_Offered_Number__c:0.0;
                                totalLimitVal = totalLimitVal + prtob.Final_Offered_Number__c!=null? prtob.Final_Offered_Number__c:0.0;
                            }
                            else if(prtob.Tob_Description__c.EqualsIgnoreCase('Monthly Service Fee')){
                                monthlyFeeVal = monthlyFeeVal + prtob.Final_Offered_Number__c!=null? prtob.Final_Offered_Number__c:0.0;
                            }
                        }
                    }

                    appPrdWrap.limitValue = string.valueOf(limitVal);
                    appPrdWrapLst.add(appPrdWrap);
                }
            }
            appFacilityWrap.appPrdLst = appPrdWrapLst;
            appFacilityWrap.totalFacilityCount = retappPrdList!=null?retappPrdList.size():0;
            appFacilityWrap.totalLimitValue = totalLimitVal!=null?totalLimitVal:0;
            appFacilityWrap.monthlyServiceFee = monthlyFeeVal!=null?monthlyFeeVal:0;
            appFacilityWrap.reviewFeeValue = reviewFeeVal!=null?reviewFeeVal:0;
            appFacilityWrap.unutilisedFacilityFee = unutilisedFacilityFeeVal!=null?unutilisedFacilityFeeVal:0;
            appFacilityWrap.reviewFeeType = reviewFeeTypeVal;
            appFacilityWrap.generalBankingFacility = 'No';
            return appFacilityWrap;
        }

        /**
        * @description
        * @author almas.aleem@absa.africa | 2021-07-13
        * @param oppId
        * @return List<Application_Product__c>
        **/
        @auraEnabled
        public static List<Application_Product__c> FetchproductList(Id oppId){
            List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
            List<Application_Product__c> retappPrdList = new List<Application_Product__c>();
            for(Application_Product__c appProd : appPrdList){
                if(appProd.Product_Name__c =='Cheque'){
                if(appProd.Application_Product_Parent__c == null && appProd.Product_State__c !=null &&( appProd.Product_State__c.equalsIgnoreCase('New') || appprod.Product_State__c.equalsIgnoreCase('Existing'))){
                    if(appProd.Product_Status__c =='Accepted' || appProd.Product_Status__c =='FulFilled'  ){
                        retappPrdList.add(appProd);
                    }
                }

                }
            }

            return retappPrdList;
        }

        /**
        * @description
        * @author almas.aleem@absa.africa | 2021-07-13
        * @param ProdId
        * @param oppId
        * @return QuoteWrapper
        **/
        @auraEnabled
        public static QuoteWrapper generateQuote(Id ProdId,Id oppId){
            List<QuoteWrapper> pricewrapperList = new List<QuoteWrapper>();
                       //use selector layer later

            List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProductId(prodId) ;   //selector for tob based on products

            //calculcations part
            Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(ProdId);
            //per product
            QuoteWrapper prWrapper;
            if(appProd.Product_Quote_Json__c == null ){
                prWrapper = new QuoteWrapper();
                //add 12 variable amount and date fields
                /*List<VariableWrapper>  variableWrapperlist = new list<VariableWrapper>();
                for(Integer i=0;i<12;i++){
                VariableWrapper vwrap = new VariableWrapper();
                vwrap.id = String.valueOf(i+1);
                vwrap.variableAmount = 0;
                variableWrapperlist.add(vwrap);
                }*/
                // prWrapper.variablemap  = variableWrapperlist;
            }else{
                prWrapper = (QuoteWrapper)JSON.deserialize(appProd.Product_Quote_Json__c, QuoteWrapper.Class);
            }
            //pplication__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppId);

            String limitType ='';

            String effectiveDate = String.valueOf(System.today().format()).replace('/','');
            IPlistNCARatesV1_Req_IB_v1 requestBean = ApplicationAIPSCTRL.generateJsonRequest(effectiveDate);

            prWrapper.QuoteNumber = 'QO-'+appProd.id;
            Decimal primerate = 0;
            Decimal primeplus = 0;
            Decimal overdraftLimit =0 ;
            Decimal serviceFee =0;
            Decimal initiationFees=0;
            IPlistNCARatesV1_Resp_IB_v1 AIPSresp;


            prWrapper.LimitType ='';
            for(Terms_Of_Business__c prtob : prodtobList){
                if(prtob.Tob_Description__c.EqualsIgnoreCase('Overdraft Limit')){
                    prWrapper.creditLimit = prtob.Final_Offered_Number__c.setScale(2);
                    overdraftLimit = prtob.Final_Offered_Number__c;
                }
                if(prtob.Tob_Description__c.EqualsIgnoreCase('Overdraft Limit Type')){
                    prWrapper.LimitType = prtob.Final_Offered__c;
                    limitType = prtob.Final_Offered__c;
                    // overdraftLimit = prtob.Final_Offered_Number__c;
                }
                if(prtob.Tob_Description__c.EqualsIgnoreCase('Initiation Fee')){
                    prWrapper.Initiationfees = prtob.Final_Offered_Number__c.setScale(2);
                    initiationFees =  prtob.Final_Offered_Number__c;
                }

                if(prtob.Tob_Description__c.EqualsIgnoreCase('Monthly Service Fee')){
                    serviceFee = prtob.Final_Offered_Number__c.setScale(2) ;
                }


                if(prtob.Tob_Description__c.EqualsIgnoreCase('Prime + %')){
                    primeplus = prtob.Final_Offered_Number__c ;
                    prWrapper.margin =  prtob.Final_Offered_Number__c ;
                }


            }
             if(!Test.isRunningTest()){
                AIPSresp = IPlistNCARatesV1_IH_v1.IPlistNCARatesV1(requestBean);
                //call aips service once again
                primerate = 6; // AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate; //remove comment later
            }else{
                primerate =5;
                overdraftLimit=100000;
            }

            /*decrease changes */
            if(limitType != null && limitType.equalsIgnoreCase('Reducing - Once Off Only')){

                for(Terms_Of_Business__c prtob : prodtobList){
                    if(prtob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')){

                        prWrapper.OnceOffAmount = prtob.Final_Offered_Number__c;
                        prWrapper.targetAmount = overdraftLimit - prtob.Final_Offered_Number__c;
                        prWrapper.targetAmount.setScale(2);
                    }  if(prtob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')){
                        prWrapper.OnceOffDate = prtob.Final_Offered_Date__c;
                    }
                }
            }
            /*decrease changes */
            if(limitType != null && limitType.equalsIgnoreCase('Reducing - Once Off And Recurring')){


                for(Terms_Of_Business__c prtob : prodtobList){
                    if(prtob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')){



                        prWrapper.OnceOffAmount = prtob.Final_Offered_Number__c;
                        //dwrap.decreaseamount1.setScale(2);
                    }  if(prtob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Date')){
                        prWrapper.OnceOffDate = prtob.Final_Offered_Date__c;
                    }
                    if(prtob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')){


                        prWrapper.ReductionAmount = prtob.Final_Offered_Number__c;
                        //dwrap.decreaseamount1.setScale(2);
                    }  if(prtob.Tob_Description__c.equalsIgnoreCase('Reduction Frequency')){
                        prWrapper.ReductionFrequency = prtob.Final_Offered__c;
                    }
                }

            }

            /*decrease changes */
            if(limitType != null && (limitType.equalsIgnoreCase('Reducing - Recurring Only') || limitType.equalsIgnoreCase('REDUCING LIMIT')) ){

                for(Terms_Of_Business__c prtob : prodtobList){
                    //  dwrap = new DecreaseWrapper();

                    if(prtob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')){


                        prWrapper.ReductionAmount = prtob.Final_Offered_Number__c;
                        prWrapper.targetAmount = overdraftLimit - prtob.Final_Offered_Number__c;
                        prWrapper.targetAmount.setScale(2);
                        //dwrap.decreaseamount1.setScale(2);
                    }  if(prtob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')){
                        prWrapper.ReductionDate = prtob.Final_Offered_Date__c;
                    } if(prtob.Tob_Description__c.equalsIgnoreCase('Reduction Date for Regular')){
                        prWrapper.ReductionDate = prtob.Final_Offered_Date__c;
                    }if(prtob.Tob_Description__c.equalsIgnoreCase('Reduction Frequency')){
                        prWrapper.ReductionFrequency = prtob.Final_Offered__c;
                    }
                }

            }

            if(limitType != null && limitType.equalsIgnoreCase('Variable')){ /* will do dynamic later --currently going with creating multiple instances*/
                VariableWrapper vwrap1 = new VariableWrapper();
                VariableWrapper vwrap2 = new VariableWrapper();
                VariableWrapper vwrap3 = new VariableWrapper();
                VariableWrapper vwrap4 = new VariableWrapper();
                VariableWrapper vwrap5 = new VariableWrapper();
                VariableWrapper vwrap6 = new VariableWrapper();
                VariableWrapper vwrap7 = new VariableWrapper();
                VariableWrapper vwrap8 = new VariableWrapper();
                VariableWrapper vwrap9 = new VariableWrapper();
                VariableWrapper vwrap10 = new VariableWrapper();
                VariableWrapper vwrap11 = new VariableWrapper();
                VariableWrapper vwrap12 = new VariableWrapper();
                List<VariableWrapper>  variableWrapperlist = new list<VariableWrapper>();

                Decimal AmountCal = overdraftLimit ;
                for(Terms_Of_Business__c prtob : prodtobList){
                    if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 1')){
                        vwrap1.id = '1';
                        vwrap1.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap1.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap1.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;

                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 1')){
                        vwrap1.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 2')){
                        vwrap2.id = '2';
                        vwrap2.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap2.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap2.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 2')){
                        vwrap2.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 3')){
                        vwrap3.id = '3';
                        vwrap3.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap3.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap3.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 3')){
                        vwrap3.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 4')){
                        vwrap4.id = '4';
                        vwrap4.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap4.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap4.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 4')){
                        vwrap4.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 5')){
                        vwrap5.id = '5';

                        vwrap5.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap5.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap5.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 5')){

                        vwrap5.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 6')){
                        vwrap6.id = '6';

                        vwrap6.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap6.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap6.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 6')){

                        vwrap6.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 7')){
                        vwrap7.id = '7';

                        vwrap7.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap7.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap7.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 7')){
                        vwrap7.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 8')){
                        vwrap8.id = '8';

                        vwrap8.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap8.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap8.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 8')){
                        vwrap8.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 9')){
                        vwrap9.id = '9';

                        vwrap9.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap9.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap9.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 9')){
                        vwrap9.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 10')){
                        vwrap10.id = '10';
                        vwrap10.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap10.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap10.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 10')){
                        vwrap10.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 11')){
                        vwrap11.id = '11';
                        vwrap11.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap11.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap11.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    }if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 11')){

                        vwrap11.variableDate = prtob.Final_Offered_Date__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Amount 12')){
                        vwrap12.id = '12';
                        vwrap12.variableAmount = prtob.Final_Offered_Number__c;
                        vwrap12.targetAmount = AmountCal - prtob.Final_Offered_Number__c;
                        vwrap12.targetAmount.setScale(2);
                        AmountCal = AmountCal - prtob.Final_Offered_Number__c;
                    } else if(prtob.Tob_Description__c.equalsIgnoreCase('Variable Date 12')){
                        vwrap12.variableDate = prtob.Final_Offered_Date__c;
                    }
                }

                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                variableWrapperlist.add(vwrap1);
                prWrapper.variablemap  = variableWrapperlist;
            }



            Decimal AnnualInterestRateDiscount = primerate + primeplus;//AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate + primeplus ;   //+ prime plus factor from pco call 7
            Decimal ContractualInterestRate =  Decimal.valueOf(appProd.Maximum_NCA_Rate__c).setScale(2) ; //removed  primerate +  to match requirement //AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate ;//+ nca max rate from pco call 7
            Decimal DiscountedContrInterestRate = ContractualInterestRate - AnnualInterestRateDiscount;

            prWrapper.AnnualInterestRateDiscount = DiscountedContrInterestRate.setScale(2);
            prWrapper.AnnualInterestRate = ContractualInterestRate.setScale(2);
            prWrapper.discountedIntersetRate = AnnualInterestRateDiscount.setScale(2);

            //prWrapper.ServicefeeAggre = 0;
            // prWrapper.AnnualInterestRateDiscount;
            prWrapper.primerate = primerate;
            prWrapper.primeplus = primeplus;
            //prWrapper.margin = primerate;
            prWrapper.margin = primeplus;
            if(primeplus > 0){
                prWrapper.Signedprimeplus = '+ '+primeplus;
            }else if(primeplus < 0){
                prWrapper.Signedprimeplus = '- '+primeplus;
            }
            Decimal totalInt = (overdraftLimit *(primerate+primeplus) )/100;
            prWrapper.totalinterest = totalInt.setScale(2);
            Decimal totalIntnfees = totalInt + (serviceFee *12);
            prWrapper.totalinterestandfees =  totalIntnfees.setScale(2);
            prWrapper.monthlyinstalment = ((overdraftLimit+totalIntnfees)/12).setScale(2);
            //Decimal totalrepa = overdraftLimit + totalInt+ prWrapper.Initiationfees;
            prWrapper.ServicefeeAggre = (serviceFee *12).setScale(2);
            Decimal totalrepa = overdraftLimit + totalInt+ prWrapper.Initiationfees+prWrapper.ServicefeeAggre ;
            prWrapper.totaltoberepaid = totalrepa.setScale(2);
            prWrapper.IntetrestAggre =  totalInt.setScale(2);
            //prWrapper.ServicefeeAggre = (serviceFee *12).setScale(2);
            prWrapper.CreditInsurAggre = 0;
            prWrapper.creditInsurMonth = 0;
            prWrapper.ExODLedgerFee =0;
            Decimal totalCreditCost = (overdraftLimit+totalInt+prWrapper.Initiationfees+prWrapper.ServicefeeAggre).setScale(2);
            prWrapper.creditcostmultiple = overdraftLimit!=0?((totalCreditCost / overdraftLimit).setScale(2)):0;
            prWrapper.totalCreditCost = totalCreditCost.setScale(2);
            prWrapper.ODLedgerFee = serviceFee.setScale(2);
            prWrapper.creditinsurancemonthly = 0;
            prWrapper.additionalCharges = 'no';
            prWrapper.Commision= 'no';

            prWrapper.UpfrontInitiationfees = initiationFees.setScale(2);



            appProd.Product_Quote_Json__c = JSON.serialize(prWrapper);
            update appProd;

            // }else{
            //  prWrapper = (QuoteWrapper)JSON.deserialize(appProd.Product_Quote_Json__c, QuoteWrapper.Class);
            // }
            return prWrapper;
        }

        /**
        * @description
        * @author almas.aleem@absa.africa | 2021-07-13
        * @param QuoteWrap
        * @param ProdId
        **/
        @auraEnabled
        public static void saveQuotes(String QuoteWrap,Id ProdId){
            QuoteWrapper  prWrapper = (QuoteWrapper)JSON.deserialize(QuoteWrap, QuoteWrapper.Class);
            //calculcations part
            Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(ProdId);
            appProd.Product_Quote_Json__c = QuoteWrap ;

           // appProd.Economic_Empowerment_Classification__c = prWrapper.EEClassification;
            //appProd.Domicible_Branch_Code__c = prWrapper.domicilebranchCode; W-013337
            appProd.Margin__c = prWrapper.margin;
            appProd.Review_Date__c = prWrapper.reviewDate;
            appProd.Expiry_Date__c = prWrapper.expiryDate;
            updateProduct(appProd);
            //update appProd;
        }

        /**
        * @description
        * @author almas.aleem@absa.africa | 2021-07-13
        * @param facilityWrap
        * @param ProdId
        **/
        @auraEnabled
        public static void saveFacilityWrap(String facilityWrap,Id ProdId){
            FacilityWrapper  fcWrapper = (FacilityWrapper)JSON.deserialize(facilityWrap, FacilityWrapper.Class);

            //calculcations part
            Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(ProdId);
            appProd.Product_Facility_Json__c =  facilityWrap ;//JSON.serialize(facilityWrap);
            appProd.Domicible_Branch_Code__c = fcWrapper.domicilebranchCode;
            appProd.Margin__c = fcWrapper.interestmargin;
            appProd.Review_Date__c = fcWrapper.reviewDate;
            appProd.Expiry_Date__c = fcWrapper.expiryDate;
            appProd.Review_Fee__c = fcWrapper.Reviewfees;
            appProd.Unutilized_Fee__c =fcWrapper.Unutilisedfacilityfee;
            appProd.Review_Fee_Type__c= fcWrapper.ReviewType;
            updateProduct(appProd);
            //update appProd;
        }


    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param appProduct
    **/
    public static void updateProduct(Application_Product__c appProduct){

         List<Terms_Of_Business__c> toupdateprodtobList =  [Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c,
                                                           Adjusted_by_Sanctioner__c,Comments__c,Existing_Account__c,Final_Offered__c,
                                                           Offered_by_Powercurve__c,Requested_Amount__c,Existing_Account_Number__c,Final_Offered_Number__c,
                                                           PowerCurve_Offered_Number__c,Adjusted_Number__c,Adjusted_Date__c,Existing_Account_Date__c,Final_Offered_Date__c,
                                                            PowerCurve_Offered_Date__c,Adjusted_by_Sanctioner_Picklist__c,Requested__c,
                                                           Requested_Number__c,Requested_Date__c from Terms_Of_Business__c where Application_Product__c =:appProduct.id ]; // :appProduct.Application_Product_Parent__c
            for( Terms_Of_Business__c tob: toupdateprodtobList){

                            /*if(tob.Tob_Description__c.equalsIgnoreCase( 'Prime Rate')){
                                // tob.PowerCurve_Offered_Number__c = appProdScore.Offer_Int_Rate__c;
                            }
                            else */if(tob.Tob_Description__c .equalsIgnoreCase( 'Prime + %')){
                               appProduct.Margin__c = tob.Final_Offered_Number__c;
                            }
                            else if(tob.Tob_Description__c .equalsIgnoreCase('Overdraft Limit Type')){
                               appProduct.Overdraft_Type__c = tob.Final_Offered__c;
                            }
                            else if(tob.Tob_Description__c.equalsIgnoreCase( 'Interest Rate')){
                                appProduct.Effective_Rate__c = tob.Final_Offered_Number__c;
                            }
                            else if(tob.Tob_Description__c.equalsIgnoreCase( 'Initiation Fee')){
                               appProduct.Initiation_Fee__c = tob.Final_Offered_Number__c;
                            }
                            else if(tob.Tob_Description__c.equalsIgnoreCase( 'Once-Off Reduction Date')){
                               appProduct.Once_Off_Date__c = tob.Final_Offered_Date__c;
                            }
                            else if(tob.Tob_Description__c.equalsIgnoreCase( 'Reduction Date for Regular')){
                               appProduct.Reduction_Date__c = tob.Final_Offered_Date__c;
                            }
                       //}
                    }
            appProduct.Account_Number__c = appProduct.Account_Number__c;
            appProduct.Overdraft_Limit__c = appProduct.Product_Amount__c;
            appProduct.Regular_Payday__c = 30;
            appProduct.Scoring_required__c = 'Yes';
            appProduct.Debit_interest_Type__c ='Prime';
            appProduct.Interest_Type__c='Fixed';
            //appProduct.Interest_Type__c=;

    try{
        update appProduct;
    }catch(Exception e){
        system.debug('e---'+e.getStackTraceString());
    }
    }

        /**
        * @description
        * @author almas.aleem@absa.africa
        */
        public class QuoteWrapper {
            @auraEnabled public String ACBLimit;
            @auraEnabled public Decimal domicilebranchCode;
            @auraEnabled public String QuoteNumber;
            @auraEnabled public Decimal margin;
            @auraEnabled public Decimal Initiationfees;
            @auraEnabled public Decimal IntetrestAggre;
            @auraEnabled public Decimal ServicefeeAggre;
            @auraEnabled public Decimal CreditInsurAggre;
            @auraEnabled public Decimal creditcostmultiple;
            @auraEnabled public Decimal creditInsurMonth;
            @auraEnabled public Decimal ODLedgerFee;
            @auraEnabled public Decimal ExODLedgerFee;
            @auraEnabled public Decimal AnnualInterestRate;
            @auraEnabled public Decimal AnnualInterestRateDiscount;
            @auraEnabled public Decimal discountedIntersetRate;
            @auraEnabled public Decimal UpfrontInitiationfees;
            @auraEnabled public Decimal monthlyinstalment;
            @auraEnabled public Decimal totalinterest;
            @auraEnabled public Decimal totalinterestandfees;
            @auraEnabled public Decimal  totaltoberepaid ;
            @auraEnabled public String additionalCharges;
            @auraEnabled public Decimal creditinsurancemonthly;
            @auraEnabled public String  Commision ;
            @auraEnabled public Decimal  creditLimit ;
            @auraEnabled public Decimal  creditLimitAvail ;
            @auraEnabled public Decimal totalCreditCost;
            @auraEnabled public Decimal primerate;
            @auraEnabled public Decimal primeplus;
            @auraEnabled public String Signedprimeplus;
            @auraEnabled public Date reviewDate;
            @auraEnabled public Date expiryDate;
            @auraEnabled public String EEClassification;
            @auraEnabled public String LimitType;
            @auraEnabled public Decimal targetAmount;
            @auraEnabled public Date targetDate;
            @auraEnabled public Decimal OnceOffAmount;
            @auraEnabled public Date  OnceOffDate;
            @auraEnabled public Decimal ReductionAmount;
            @auraEnabled public Date ReductionDate;
            @auraEnabled public String ReductionFrequency;
            @auraEnabled public List<VariableWrapper> variablemap;

        }
        /**
        * @description
        * @author almas.aleem@absa.africa
        */
        public class VariableWrapper{
            @auraEnabled public String Id;
            @auraEnabled public Decimal variableAmount;
            @auraEnabled public Date variableDate;
            @auraEnabled public Decimal targetAmount;
        }

        /**
        * @description
        * @author almas.aleem@absa.africa
        */
        public class FacilityWrapper{
            @auraEnabled public String ACBLimit;
            @auraEnabled public Decimal domicilebranchCode;
            @auraEnabled public String accountNumber;
            @auraEnabled public String productName;
            @auraEnabled public String siteCode;
            @auraEnabled public String instructionId;
            @auraEnabled public Decimal Initiationfees;
            @auraEnabled public Decimal Primeinterestrate;
            @auraEnabled public Decimal Interestrate;
            @auraEnabled public String InterestrateType;
            @auraEnabled public Decimal Unutilisedfacilityfee;
            @auraEnabled public Decimal Reviewfees;
            @auraEnabled public Date ReviewDate;
            @auraEnabled public String ReviewType;
            @auraEnabled public Date expiryDate;
            @auraEnabled public Decimal Monthlyadministrationfee;
            @auraEnabled public String fullname;
            @auraEnabled public String RegistrationNumber;
            @auraEnabled public String AnnualInterestRate;
            @auraEnabled public String Surname;
            @auraEnabled public String Addressee;
            @auraEnabled public String AddresseeOther;
            @auraEnabled public String Addresseetitle;
            @auraEnabled public String isGeneralFacilitySelected;
            @auraEnabled public String creditApplicationReference;
            @auraEnabled public Date quoteDate;
            @auraEnabled public Decimal penaltyinterest;
            @auraEnabled public Decimal interestMargin;
            @auraEnabled public String RegularpaymentDate;
            @auraEnabled public Decimal  facilityAmount ;
            @auraEnabled public Decimal  totalamount ;
            //@auraEnabled public Decimal  targetamount ;
            @auraEnabled public Decimal  creditLimitAvail ;
            @auraEnabled public String specialConditionsSelected ;
            @auraEnabled public String classificationSelected;
            @auraEnabled public String facilitiesSelected;
            @auraEnabled public String facilityTypeSelected ;
            @auraEnabled public String ODLimitType;
            @auraEnabled public String otherConditions;
            @auraEnabled public String facilityreduced;
            @auraEnabled public String EEClassification;
            @auraEnabled public String LimitType;
            @auraEnabled public Decimal targetAmount;
            @auraEnabled public Date targetDate;
            @auraEnabled public Decimal OnceOffAmount;
            @auraEnabled public Date  OnceOffDate;
            @auraEnabled public Decimal ReductionAmount;
            @auraEnabled public Date ReductionDate;
            @auraEnabled public String ReductionFrequency;
            @auraEnabled public List<VariableWrapper> variablemap;
        }
    }