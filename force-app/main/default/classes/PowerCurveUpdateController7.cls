/**
 * @description       : Power curver controller class for stage 7
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-06-18
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-01-12   Himanshu.Nimje@absa.africa   Initial Version
**/
public class PowerCurveUpdateController7 {

    /**
     * @description method to map stage 7 fields to PCO
     * @author Himanshu.Nimje@absa.africa | 2021-01-12
     * @param requestBean
     * @param oppId
     * @param stage
     * @return PowerCurveUpdateApplication_Req_IB_v1
    **/
    public static PowerCurveUpdateApplication_Req_IB_v1 mapPowerCureveUpdateRequest(PowerCurveUpdateApplication_Req_IB_v1 requestBean , Id oppId, Integer stage){

        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
        Account acc = new AccountsSelector().selectByOpportunityId(opp.AccountId, 1);
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(oppId);

        List<Application_Product__c> reqProds =[SELECT   Product_Name__c, Product_Type__c, Temp_Account_Number__c, System_Decision__c, Final_Decision__c,Product_Status__c,
                                                Opportunity__c, Name, Id, Product_State__c,NCA_Appplicable__c,Secured_By_Mortgage_Bond__c,Product_Amount__c,Account_Number__c
                                                FROM Application_Product__c
                                                where Opportunity__c=:oppId and  Product_State__c='new' AND Application_Product_Parent__c=null ];

        List<Application_Product__c> existingProds =[SELECT   Product_Name__c, Product_Type__c, Temp_Account_Number__c, System_Decision__c, Final_Decision__c,Product_Status__c,
                                                     Opportunity__c, Name, Id, Product_State__c,NCA_Appplicable__c,Secured_By_Mortgage_Bond__c,Product_Amount__c,Account_Number__c
                                                     FROM Application_Product__c
                                                     where Opportunity__c=:oppId and  Product_State__c='existing' AND Application_Product_Parent__c=null ];

        system.debug('reqProds : ' +reqProds);
        system.debug('existingProds : ' +existingProds);

        String JURISTICIND ;
        if(acc.Client_Type__c=='Individual' || acc.Client_Type__c=='Sole Trader'  ){
            JURISTICIND='N';
        }else{
            JURISTICIND='Y';
        }

        Map<String,String> mapAppDataReq = new Map<String,String>();

        List<Map<String,Object>> result = GeneralQualitativeInformationController.getQuestionsAndAnswers(oppId,'General Qualitative Information');

        if(result.size() > 0 && result != null){
            for(integer i=0;i<result.size();i++){

                if(result[i].get('Question') =='Key Management Personnel Changes'){
                    mapAppDataReq.put('Key Management Personnel Changes', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Business Direction Changes'){
                    mapAppDataReq.put('Business Direction Changes', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Exposure Increase'){
                    mapAppDataReq.put('Exposure Increase', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Arreas Or Sars'){
                    mapAppDataReq.put('Arreas Or Sars', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Other Financial Institutions'){
                    mapAppDataReq.put('Other Financial Institutions', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Dispute Between Parties'){
                    mapAppDataReq.put('Dispute Between Parties', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Write Off Failure'){
                    mapAppDataReq.put('Write Off Failure', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Other Knowledge'){
                    mapAppDataReq.put('Other Knowledge', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Debtor Book Funding'){
                    mapAppDataReq.put('Debtor Book Funding', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Support Application'){
                    mapAppDataReq.put('Support Application', result[i].get('Answer')=='true'?'Y':'N' );
                } if(result[i].get('Question') =='Borrowing Power Limit'){
                    string borrowingPowerLimit = string.valueOf(result[i].get('Answer'));
                    if (string.isNotBlank(borrowingPowerLimit)) {
                        if (borrowingPowerLimit == 'Limited - Fixed Amount') {
                            mapAppDataReq.put('Borrowing Power Limit', 'F');
                        } else if (borrowingPowerLimit == 'Limited - Other') {
                            mapAppDataReq.put('Borrowing Power Limit', 'O');
                        } else if (borrowingPowerLimit == 'Unlimited') {
                            mapAppDataReq.put('Borrowing Power Limit', 'U');
                        }
                    }
                }
            }
        }
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPQUAL();

        // system.debug('mapAppDataReq' + mapAppDataReq);
        if(!mapAppDataReq.isEmpty()){
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.CHANGEKEYMNGMNTL12M = mapAppDataReq.get('Key Management Personnel Changes');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.CHANGEBUSDIRECTION = mapAppDataReq.get('Business Direction Changes');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.EXPINCREASEL6TO12M = mapAppDataReq.get('Exposure Increase');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.ARREARSSARS = mapAppDataReq.get('Arreas Or Sars');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.ACCOTHERBANK = mapAppDataReq.get('Other Financial Institutions');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.DISPUTEBETWEENPARTIES = mapAppDataReq.get('Dispute Between Parties');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.PREVIOUSWOFFBUSFAILURE = mapAppDataReq.get('Write Off Failure');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.OTHERNEGKNOWLEDGE = mapAppDataReq.get('Other Knowledge');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.DEBTORBOOKFUNDING = mapAppDataReq.get('Debtor Book Funding');
            requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.RESUPPORTAPPLICATION = mapAppDataReq.get('Support Application');
            requestBean.Request.ApplicationDV.AppData.APPAPPBORROWINGPOWERS = mapAppDataReq.get('Borrowing Power Limit');
        }

        Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestBean, true));
        Map<String, Object> Request = (Map<String, Object>)untypedMap.get('Request');
        Map<String, Object> ApplicationDV = (Map<String, Object>)Request.get('ApplicationDV');
        Map<String, Object> AppData = (Map<String, Object>)ApplicationDV.get('AppData');

        //Requested Prod
        for(integer i=1;i<=30;i++){
            string getprod ;
            if(i<10){
                getprod = 'RequestedProducts' + '0' + i;
            }else{
                getprod = 'RequestedProducts'+i;
            }

            Map<String, Object> RequestProducts = (Map<String, Object>)ApplicationDV.get(getprod);

            if(RequestProducts !=null){
                // system.debug('RequestProducts'+i+'----'+RequestProducts.get('APPPRDNEWF'));

                if(RequestProducts.get('APPPRDNEWF') !=null ){
                    PowerCurveUpdateApplication_Req_IB_v1.APPPRDNEWF APPPRDNEWF = (PowerCurveUpdateApplication_Req_IB_v1.APPPRDNEWF)JSON.deserialize(Json.serialize(RequestProducts.get('APPPRDNEWF'),true),PowerCurveUpdateApplication_Req_IB_v1.APPPRDNEWF.class);
                    for(Application_Product__c appProd:reqProds){

                        if(APPPRDNEWF.UNIQUEPRODID == appProd.Name ){
                            APPPRDNEWF.NCAAPPLICABLE = appProd.NCA_Appplicable__c != null && appProd.NCA_Appplicable__c.equalsIgnoreCase('IN NCA')? 'Y' : 'N';

                            if(appProd.Secured_By_Mortgage_Bond__c==true){
                                APPPRDNEWF.NCAAGREEMENTCAT = 'L' ;
                            }else{
                                if(appProd.Product_Amount__c <15000 && appProd.Product_Amount__c>0 ){
                                    APPPRDNEWF.NCAAGREEMENTCAT = 'S' ;
                                }else if(appProd.Product_Amount__c>=15000 && appProd.Product_Amount__c< 250000){
                                    APPPRDNEWF.NCAAGREEMENTCAT = 'I' ;
                                }else if(appProd.Product_Amount__c> =250000 ){
                                    APPPRDNEWF.NCAAGREEMENTCAT = 'L' ;
                                }
                            }
                            APPPRDNEWF.JURISTICIND = JURISTICIND ;
                        }


                    }
                    RequestProducts.put('APPPRDNEWF',APPPRDNEWF);
                }

            }
        }

        //Existing Prod
        for(integer i=1;i<=30;i++){

            string getprod = 'ExistingProducts'+'0'+i;
            Map<String, Object> existingProducts = (Map<String, Object>)ApplicationDV.get(getprod);
            //ACCOUNTNUMBER
            if(existingProducts != null){
                if(existingProducts.get('INTPRDEXST') !=null ){

                    PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST INTPRDEXST = (PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST)JSON.deserialize(Json.serialize(existingProducts.get('INTPRDEXST'),true),PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST.class);
                    for(Application_Product__c appProd: existingProds){

                        if(INTPRDEXST.ACCOUNTNUMBER.equalsIgnoreCase(String.valueOf(appProd.Account_Number__c))){

                            system.debug(' @@@ APPPRDEXST'+'----'+existingProducts.get('APPPRDEXST'));
                             if(existingProducts.get('APPPRDEXST') !=null ){
                            PowerCurveUpdateApplication_Req_IB_v1.APPPRDEXST APPPRDEXST = (PowerCurveUpdateApplication_Req_IB_v1.APPPRDEXST)JSON.deserialize(Json.serialize(existingProducts.get('APPPRDEXST'),true),PowerCurveUpdateApplication_Req_IB_v1.APPPRDEXST.class);
                            //new PowerCurveUpdateApplication_Req_IB_v1.APPPRDEXST();
                             APPPRDEXST.NCAAPPLICABLE = appProd.NCA_Appplicable__c != null && appProd.NCA_Appplicable__c.equalsIgnoreCase('IN NCA')? 'Y' : 'N';

                            if(appProd.Secured_By_Mortgage_Bond__c==true){
                                APPPRDEXST.NCAAGREEMENTCAT = 'L' ;
                            }else{
                                if(appProd.Product_Amount__c <15000 && appProd.Product_Amount__c>0 ){
                                    APPPRDEXST.NCAAGREEMENTCAT = 'S' ;
                                }else if(appProd.Product_Amount__c>=15000 && appProd.Product_Amount__c< 250000){
                                    APPPRDEXST.NCAAGREEMENTCAT = 'I' ;
                                }else if(appProd.Product_Amount__c> =250000 ){
                                    APPPRDEXST.NCAAGREEMENTCAT = 'L' ;
                                }
                            }
                            APPPRDEXST.JURISTICIND = JURISTICIND ;
                            existingProducts.put('APPPRDEXST',APPPRDEXST);
                             }
                        }

                    }
                    existingProducts.put('INTPRDEXST',INTPRDEXST);

                }

            }


        }



        requestBean = (PowerCurveUpdateApplication_Req_IB_v1)JSON.deserialize(JSON.serialize(untypedMap, true), PowerCurveUpdateApplication_Req_IB_v1.class);
        requestBean.Request.ApplicationDV.APPAPPSTAGEID ='07' ;
        return requestBean;
    }
}