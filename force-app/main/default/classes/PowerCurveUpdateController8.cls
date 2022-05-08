/**
 * @description       : Power curve update controller class
 * @author            : Almas.Aleem@absa.africa
 * @last modified on  : 2021-06-18
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-06-18    Almas.Aleem@absa.africa   Initial Version
**/
public class PowerCurveUpdateController8 {

    /**
     * @description method to update stage 8 PCO response
     * @author  Almas.Aleem@absa.africa | 2021-06-18
     * @param requestBean
     * @param oppId
     * @param stage
     * @return PowerCurveUpdateApplication_Req_IB_v1
    **/
    public static PowerCurveUpdateApplication_Req_IB_v1 mapPowerCureveUpdateRequest(PowerCurveUpdateApplication_Req_IB_v1 requestBean, Id oppId, Integer stage){

        system.debug('requestBean from previous stage---'+json.serializePretty(requestBean));
        if(stage >= 8){
            requestBean = mapStage8Fields(requestBean,oppId);
        }

        return requestBean;
    }

    /**
     * @description method to map stage 8 fields to PCO
     * @author  Almas.Aleem@absa.africa | 2021-06-18
     * @param requestBean
     * @param oppId
     * @return PowerCurveUpdateApplication_Req_IB_v1
    **/
    public static PowerCurveUpdateApplication_Req_IB_v1 mapStage8Fields(PowerCurveUpdateApplication_Req_IB_v1 requestBean,Id oppId){
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId); //select by opp
        Opportunity opp  = new OpportunitiesSelector().selectByOppId(oppId);

        Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestBean, true));
        Map<String, Object> Request = (Map<String, Object>)untypedMap.get('Request');
        Map<String, Object> ApplicationDV = (Map<String, Object>)Request.get('ApplicationDV');


        List<Application_Product__c> reqProds =[Select id, Name ,Product_Name__c,Account_Number__c,Product_State__c,Limit_Type__c,Product_Status__c,Final_Decision_Date_Time__c,
                                                (Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c,Adjusted_by_Sanctioner_Picklist__c,Requested_Picklist__c,Requested_Frequency_Picklist__c,
                                                 Adjusted_by_Sanctioner__c,Comments__c,Existing_Account__c,Final_Offered__c,Adjusted_By_Sanctioner_Frequency__c,
                                                 Offered_by_Powercurve__c,Requested_Amount__c,Existing_Account_Number__c,Final_Offered_Number__c,
                                                 PowerCurve_Offered_Number__c,Adjusted_Number__c,Adjusted_Date__c,Existing_Account_Date__c,Final_Offered_Date__c,
                                                 PowerCurve_Offered_Date__c,
                                                 Requested_Number__c,Requested_Date__c from Terms_Of_Business__r ) from Application_Product__c Where Opportunity__c =:oppId AND Application_Product_Parent__c=null AND Product_State__c='new' ];




        List<Application_Product__c> existingProds = [Select id, Name ,Product_Name__c,Account_Number__c,Product_State__c,Limit_Type__c,Product_Status__c,Final_Decision_Date_Time__c,
                                                      (Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c,Adjusted_by_Sanctioner_Picklist__c,Requested_Picklist__c,Requested_Frequency_Picklist__c,
                                                       Adjusted_by_Sanctioner__c,Comments__c,Existing_Account__c,Final_Offered__c,Adjusted_By_Sanctioner_Frequency__c,
                                                       Offered_by_Powercurve__c,Requested_Amount__c,Existing_Account_Number__c,Final_Offered_Number__c,
                                                       PowerCurve_Offered_Number__c,Adjusted_Number__c,Adjusted_Date__c,Existing_Account_Date__c,Final_Offered_Date__c,
                                                       PowerCurve_Offered_Date__c,
                                                       Requested_Number__c,Requested_Date__c from Terms_Of_Business__r ) from Application_Product__c Where Opportunity__c =:oppId AND Application_Product_Parent__c=null AND Product_State__c='existing' ];


        for(integer i=1;i<=30;i++){
            string getprod ;

            if(i<=9){getprod = 'RequestedProducts'+'0'+i;}else{getprod = 'RequestedProducts'+i;}
            Map<String, Object> RequestProducts = (Map<String, Object>)ApplicationDV.get(getprod);


            //system.debug('RequestProducts'+i+'----'+RequestProducts);ACCOUNTNUMBER
            if(RequestProducts !=null){
                system.debug('RequestProducts'+i+'----'+RequestProducts.get('DERPRDNEWF'));
                system.debug('RequestProducts'+i+'----'+RequestProducts.get('APPPRDNEWF'));
                if(RequestProducts.get('APPPRDNEWF') !=null  ){
                    PowerCurveUpdateApplication_Req_IB_v1.APPPRDNEWF APPPRDNEWF = (PowerCurveUpdateApplication_Req_IB_v1.APPPRDNEWF)JSON.deserialize(Json.serialize(RequestProducts.get('APPPRDNEWF'),true),PowerCurveUpdateApplication_Req_IB_v1.APPPRDNEWF.class);
                    for(Application_Product__c appProd:reqProds){
                        String prodStatus;

                        if(appprod.Product_Status__c !=null){
                            if(appprod.Product_Status__c =='Accepted'){

                                prodStatus ='A';
                            } else if(appprod.Product_Status__c =='Declined'){
                                //FinalDecision='Declined';
                                prodStatus = 'D';
                            }else if(appprod.Product_Status__c == 'Pending'){
                                prodStatus ='P';
                            }
                        }
                        if(APPPRDNEWF.UNIQUEPRODID == appProd.Name ){

                            if(RequestProducts.get('DERPRDNEWF') ==null){
                                PowerCurveUpdateApplication_Req_IB_v1.DERPRDNEWF  DERPRDNEWF = new PowerCurveUpdateApplication_Req_IB_v1.DERPRDNEWF();
                              //(PowerCurveUpdateApplication_Req_IB_v1.DERPRDNEWF)JSON.deserialize(Json.serialize(RequestProducts.get('DERPRDNEWF'),true),PowerCurveUpdateApplication_Req_IB_v1.DERPRDNEWF.class);
                                //new PowerCurveUpdateApplication_Req_IB_v1.DERPRDNEWF();
                                //(PowerCurveUpdateApplication_Req_IB_v1.DERPRDNEWF)RequestProducts.get('DERPRDNEWF');
                                if(! appProd.Terms_Of_Business__r.isEmpty()){
                                    for(Terms_Of_Business__c tob : appProd.Terms_Of_Business__r){
                                        if(tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit')){ // not sure need to check which exact field need to be mapped
                                            DERPRDNEWF.FINALTOTALAMNT=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);
                                            APPPRDNEWF.REQLIMIT = tob.Requested_Number__c == null ?'':''+Integer.valueOf(tob.Requested_Number__c);
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')){
                                            DERPRDNEWF.FINALREDUCTIONAMNT=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);  //reduction amount
                                            APPPRDNEWF.REQREDUCTIONAMNT=tob.Requested_Number__c == null ?'':''+Integer.valueOf(tob.Requested_Number__c);
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Frequency')){
                                            DERPRDNEWF.FINALREDUCTIONFREQ=tob.Adjusted_By_Sanctioner_Frequency__c == null ? '':''+tob.Adjusted_By_Sanctioner_Frequency__c; //Regular Reduction Frequency
                                            APPPRDNEWF.REQREDUCTIONFREQ = tob.Requested_Frequency_Picklist__c ==null ?'':''+tob.Requested_Frequency_Picklist__c;
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Limit Review Period')){  //not sure need to check which to map exact
                                            DERPRDNEWF.FINALREDUCTIONPERIOD=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);  //Regular Reduction Period

                                        } if(tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')){
                                            DERPRDNEWF.FINALONCEOFFREDUCTIONAMNT=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);  //once off reduction
                                            APPPRDNEWF.REQONCEOFFFREQAMNT = tob.Requested_Number__c   == null ? '':''+Integer.valueOf(tob.Requested_Number__c );
                                        } if(tob.Tob_Description__c.equalsIgnoreCase('Monthly Service Fee')){
                                            DERPRDNEWF.FINALSERVICEFEE=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);   //service fee from pricing
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit Type')){
                                            if(tob.Adjusted_by_Sanctioner_Picklist__c !=null && (tob.Adjusted_by_Sanctioner_Picklist__c.equalsIgnoreCase('Reducing - Recurring Only') || tob.Adjusted_by_Sanctioner_Picklist__c.equalsIgnoreCase('Reducing - Once Off And Recurring'))  ){
                                                DERPRDNEWF.FINALODLIMITTYPE ='3';
                                            }else{
                                                DERPRDNEWF.FINALODLIMITTYPE=tob.Adjusted_by_Sanctioner_Picklist__c == null ?'':''+tob.Adjusted_by_Sanctioner_Picklist__c;  //over draft limit
                                            }
                                            if(tob.Requested_Picklist__c!=null && (tob.Requested_Picklist__c.equalsIgnoreCase('	Reducing - Once Off And Recurring') || tob.Requested_Picklist__c.equalsIgnoreCase('Reducing - Recurring Only') )  ){
                                                APPPRDNEWF.REQODLIMITTYPE ='3';
                                            }else{
                                                APPPRDNEWF.REQODLIMITTYPE=tob.Requested_Picklist__c == null ?'':''+tob.Requested_Picklist__c;
                                            }
                                        }
                                        if(tob.Tob_Description__c.equalsIgnoreCase('Initiation Fee')){
                                            DERPRDNEWF.FINALINITFEEAMOUNT=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);   //Initiation Fee
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Prime + %')){
                                            DERPRDNEWF.FINALINTRATEPRIMEPLUS=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);   //Prime Plus Factor
                                        }
                                    }

                                    DERPRDNEWF.FINALDECISION =''+prodStatus;

                                    DERPRDNEWF.FINALDECDATE=  appProd.Final_Decision_Date_Time__c == null ?'' :String.valueOf(appProd.Final_Decision_Date_Time__c.format('YYYY-MM-dd')) ; //product final date

                                    DERPRDNEWF.FINALDECTIME= appProd.Final_Decision_Date_Time__c == null ?'' :String.valueOf(appProd.Final_Decision_Date_Time__c.format('HHMMss')) ; //product final date

                                }

                                RequestProducts.put('DERPRDNEWF',DERPRDNEWF);
                            }
                        }
                    }
                    RequestProducts.put('APPPRDNEWF',APPPRDNEWF);

                }
            }
        }


        for(integer i=1;i<=30;i++){
            string getprod;
            if(i<=9){getprod = 'ExistingProducts'+'0'+i;}else{getprod = 'ExistingProducts'+i;}
            // getprod = 'ExistingProducts'+'0'+i;
            Map<String, Object> existingProducts = (Map<String, Object>)ApplicationDV.get(getprod);
            //ACCOUNTNUMBER
            if(existingProducts != null){
                if(existingProducts.get('INTPRDEXST') !=null ){
                    PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST INTPRDEXST = (PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST)JSON.deserialize(Json.serialize(existingProducts.get('INTPRDEXST'),true),PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST.class);


                    //(PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST) existingProducts.get('INTPRDEXST');
                    for(Application_Product__c appProd: existingProds){
                        String prodStatus;

                        if(appprod.Product_Status__c !=null){
                            if(appprod.Product_Status__c =='Accepted'){

                                prodStatus ='A';
                            } else if(appprod.Product_Status__c =='Declined'){
                                //FinalDecision='Declined';
                                prodStatus = 'D';
                            }else if(appprod.Product_Status__c == 'Pending'){
                                prodStatus ='P';
                            }
                        }
                        if(INTPRDEXST.ACCOUNTNUMBER.equalsIgnoreCase(String.valueOf(appProd.Account_Number__c))){
                            if(existingProducts.get('DERPRDEXST') == null){
                                PowerCurveUpdateApplication_Req_IB_v1.DERPRDEXST DERPRDEXST = new  PowerCurveUpdateApplication_Req_IB_v1.DERPRDEXST();
                                    //(PowerCurveUpdateApplication_Req_IB_v1.DERPRDEXST)JSON.deserialize(Json.serialize(existingProducts.get('DERPRDEXST'),true),PowerCurveUpdateApplication_Req_IB_v1.DERPRDEXST.class);
                                   // new  PowerCurveUpdateApplication_Req_IB_v1.DERPRDEXST();
                                //(PowerCurveUpdateApplication_Req_IB_v1.DERPRDEXST) existingProducts.get('DERPRDEXST');

                                if(! appProd.Terms_Of_Business__r.isEmpty()){
                                    for(Terms_Of_Business__c tob : appProd.Terms_Of_Business__r){
                                        if(tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit')){ // not sure need to check which exact field need to be mapped
                                            DERPRDEXST.FINALTOTALAMNT=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);
                                            INTPRDEXST.CURRLIMIT =tob.Existing_Account_Number__c == null ?'':''+Integer.valueOf(tob.Existing_Account_Number__c);
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')){
                                            DERPRDEXST.FINALREDUCTIONAMNT=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);  //reduction amount
                                            INTPRDEXST.CURRREDUCTIONAMNT =tob.Existing_Account_Number__c == null ?'':''+Integer.valueOf(tob.Existing_Account_Number__c);
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Frequency')){
                                            DERPRDEXST.FINALREDUCTIONFREQ=tob.Adjusted_By_Sanctioner_Frequency__c ==null ?'':''+tob.Adjusted_By_Sanctioner_Frequency__c; //Regular Reduction Frequency
                                            // ExistingProductObj.INTPRDEXST.CURRREDUCTIONFREQ =''+tob.Existing_Account__c;
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Limit Review Period')){  //not sure need to check which to map exact
                                            DERPRDEXST.FINALREDUCTIONPERIOD=tob.Adjusted_by_Sanctioner__c == null ?'':''+tob.Adjusted_by_Sanctioner__c; //Regular Reduction Period
                                            //ExistingProductObj.INTPRDEXST.CURRLIMIT =''+tob.Adjusted_Number__c;
                                        } if(tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')){
                                            DERPRDEXST.FINALONCEOFFREDUCTIONAMNT=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);  //Regular Reduction Period
                                            INTPRDEXST.CURRONCEOFFREDUCTION =tob.Existing_Account_Number__c == null ?'':''+Integer.valueOf(tob.Existing_Account_Number__c);
                                        } if(tob.Tob_Description__c.equalsIgnoreCase('Monthly Service Fee')){
                                            DERPRDEXST.FINALSERVICEFEE=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);   //service fee from pricing

                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit Type')){
                                           if(tob.Adjusted_by_Sanctioner_Picklist__c !=null && (tob.Adjusted_by_Sanctioner_Picklist__c.equalsIgnoreCase('Reducing - Recurring Only') || tob.Adjusted_by_Sanctioner_Picklist__c.equalsIgnoreCase('Reducing - Once Off And Recurring') ) ){
                                                        DERPRDEXST.FINALODLIMITTYPE ='3';
                                            }else{
                                                DERPRDEXST.FINALODLIMITTYPE=tob.Adjusted_by_Sanctioner_Picklist__c == null ?'':''+tob.Adjusted_by_Sanctioner_Picklist__c;  //over draft limit
                                            }
                                            // ExistingProductObj.INTPRDEXST.//over draft limit
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Initiation Fee')){
                                            DERPRDEXST.FINALINITFEEAMOUNT=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);  //Initiation Fee
                                        }if(tob.Tob_Description__c.equalsIgnoreCase('Prime + %')){
                                            DERPRDEXST.FINALINTRATEPRIMEPLUS=tob.Final_Offered_Number__c == null ? '':''+Integer.valueOf(tob.Final_Offered_Number__c);  //Prime Plus Factor
                                        }/*if(tob.Tob_Description__c.equalsIgnoreCase('Unutilized Facility Fee')){ //need to check
                                        ExistingProductObj.DERPRDEXST.FINALFACILITYFEE=''+tob.Final_Offered_Number__c;  // Unutilized Facility Fee
                                        }*/
                                    }
                                }
                                DERPRDEXST.FINALDECISION = ''+prodStatus;
                                DERPRDEXST.FINALDECDATE= appProd.Final_Decision_Date_Time__c == null ?'' :String.valueOf(appProd.Final_Decision_Date_Time__c.format('YYYY-MM-dd')) ; //product final date
                                DERPRDEXST.FINALDECTIME= appProd.Final_Decision_Date_Time__c == null ?'' :String.valueOf(appProd.Final_Decision_Date_Time__c.format('HHmmss')) ; //product final time;
                              existingProducts.put('DERPRDEXST',DERPRDEXST)  ;
                            }

                        }
                    }
                   existingProducts.put('INTPRDEXST',INTPRDEXST)  ;
                }

            }
        }

        requestBean = (PowerCurveUpdateApplication_Req_IB_v1)JSON.deserialize(JSON.serialize(untypedMap, true), PowerCurveUpdateApplication_Req_IB_v1.class);
        //put time and date
        DateTime dt;
        DateTime dt2;
        String appreferTime ;
        if(app.Credit_App_Status_Change_Date__c !=null){
            dt = DateTime.newInstance(app.Credit_App_Status_Change_Date__c.year(),app.Credit_App_Status_Change_Date__c.month(),app.Credit_App_Status_Change_Date__c.day());
        }
        if(app.Credit_App_Status_Change_Time__c  !=null){
            dt2 = DateTime.newInstance(app.Credit_App_Status_Change_Time__c.millisecond());
            appreferTime = ''+app.Credit_App_Status_Change_Time__c.hour()+''+app.Credit_App_Status_Change_Time__c.minute()+''+app.Credit_App_Status_Change_Time__c.second()+'00';
        }

        requestBean.Request.ApplicationDV.APPAPPCREDITREFERDATE =  app.Credit_App_Status_Change_Date__c == null ? '' : ''+ String.valueOf(dt.format('YYYY-MM-dd')); //system decision refer date
        requestBean.Request.ApplicationDV.APPAPPCREDITREFERTIME=  app.Credit_App_Status_Change_Time__c == null ? '' : ''+appreferTime ;  //     system decision refer time
        requestBean.Request.ApplicationDV.APPAPPPRICINGREFERDATE = opp.Pricing_Refer_DateTime__c == null ?'' : ''+String.valueOf(opp.Pricing_Refer_DateTime__c.format('YYYY-MM-dd')) ;//pricing refer date;
        requestBean.Request.ApplicationDV.APPAPPPRICINGREFERTIME = opp.Pricing_Refer_DateTime__c == null ? '' : ''+ String.valueOf(opp.Pricing_Refer_DateTime__c.format('HHmmss')) ;   //pricing refer time

        requestBean.Request.ApplicationDV.APPAPPSTAGEID ='08' ;
        return requestBean;
    }
}