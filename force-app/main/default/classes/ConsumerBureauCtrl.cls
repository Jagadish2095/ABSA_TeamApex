/**
 * @description       : Controller class for ConsumerBureau aura component
 * @author            : Gulafsha
 * @last modified on  : 2021-07-16
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-07-16   Gulafsha   Initial Version
**/


public class ConsumerBureauCtrl {
    
    /**
    * @description Get Application_Profile__c records related to an opportunity
    * @author Gulafsha | 2021-07-16 
    * @param opportunityId 
    * @return List<Map<String, Object>> 
    **/
	@AuraEnabled(Cacheable=false)
    public static List<Map<String,Object>> getApplicationProfiles(Id opportunityId){
    	List<Map<String,Object>> bureauData = new List<Map<String,Object>>();
        ApplicationProfileSelector applicationProfileSelector = new ApplicationProfileSelector();
		List<Application_Profile__c> applicationProfiles = applicationProfileSelector.getAppProfileBureauData(opportunityId);

        if(applicationProfiles != null && applicationProfiles.size() > 0){
            List<Application_Profile__c> appProfilesConsumer = new List<Application_Profile__c>();

            Boolean isNullBureau = false;

            for(Application_Profile__c applicationProfile : applicationProfiles){
                if(applicationProfile.Bureau_JSON_Response__c == null && applicationProfile.PCCE_Id__c != null && checkIfCompany(applicationProfile.Account__r.Client_Type__c)){
                    isNullBureau = true;
                    appProfilesConsumer.add(applicationProfile);
                } else if(applicationProfile.Bureau_JSON_Response__c != null && applicationProfile.PCCE_Id__c != null && checkIfCompany(applicationProfile.Account__r.Client_Type__c)){
                    appProfilesConsumer.add(applicationProfile);
                } else if(applicationProfile.Bureau_JSON_Response__c == null && applicationProfile.PCCE_Id__c == null && checkIfCompany(applicationProfile.Account__r.Client_Type__c) && applicationProfile.Bureau_Report_1__c != null){
                    appProfilesConsumer.add(applicationProfile);
                }
            }

            PowerCurveController.setValidationFields(opportunityId, 'Consumer_Bureau_Captured', true);

            if(isNullBureau){
                List<Application_Profile__c> updatedAppProfiles = getBureauData(appProfilesConsumer);

                if(updatedAppProfiles != null){
                    bureauData = changeBureauData(updatedAppProfiles);
                    return bureauData;
                }
            } else {
                bureauData = changeBureauData(appProfilesConsumer);
            	return bureauData;
            }
        }
        return null;
    }

    /**
    * @description Web service call to get bureau data for Application Profiles
    * @author Gulafsha | 2021-07-16 
    * @param applicationProfiles 
    * @return List<Application_Profile__c> 
    **/
    public static List<Application_Profile__c> getBureauData(List<Application_Profile__c> applicationProfiles){
        if(applicationProfiles != null && applicationProfiles.size() > 0){

            for(Application_Profile__c applicationProfile : applicationProfiles){
                if(applicationProfile.Bureau_JSON_Response__c == null && applicationProfile.PCCE_Id__c != null && checkIfCompany(applicationProfile.Account__r.Client_Type__c)){
                    ConsumerBureauEnquiry_Resp_IB_v1 responseBean = ConsumerBureauEnquiry_IH_v1.consumerBureauEnquiry(applicationProfile.PCCE_Id__c);

                    if(responseBean.statusCode == 200 && responseBean != null){
                        if(responseBean.Response != null){
                            if(responseBean.Response.ApplicationDV != null){
                                if(responseBean.Response.ApplicationDV.CONS != null){
                                    applicationProfile.Bureau_JSON_Response__c = JSON.serialize(responseBean);
                                }
                            }
                        }
                    }
                }
            }

            saveBureauData(applicationProfiles);
        }

        return applicationProfiles;
    }



    /**
    * @description Method to save Bureau data to Application Profile
    * @author Gulafsha | 2021-07-16 
    * @param applicationProfiles 
    **/
    private static void saveBureauData(List<Application_Profile__c> applicationProfiles){
        try{
            update applicationProfiles;
        } catch(Exception ex) {

            throw new AuraException('Update Application Profiles failed: ' + ex.getMessage() + ' ' + ex.getStackTraceString());  
        }
    }


    /**
    * @description Method to check whether account is warm body or not
    * @author Gulafsha | 2021-07-16 
    * @param entityType 
    * @return Boolean 
    **/
    private static Boolean checkIfCompany(String entityType){
        if(entityType != null){
            if(entityType.equalsIgnoreCase('STAFF') || entityType.equalsIgnoreCase('SOLE TRADER') || entityType.equalsIgnoreCase('INDIVIDUAL')){
                return true;
            }
        }

        return false;
    }


    /**
    * @description Method to change JSON response to a Map that is easily usable on the front end
    * @author Gulafsha | 2021-07-16 
    * @param applicationProfiles 
    * @return List<Map<String, Object>> 
    **/
    private static List<Map<String,Object>> changeBureauData(List<Application_Profile__c> applicationProfiles){
        List<Map<String,Object>> bureauData = new List<Map<String,Object>>();

        for(Application_Profile__c applicationProfile : applicationProfiles){
            if(applicationProfile.Bureau_JSON_Response__c != null){
                ConsumerBureauEnquiry_Resp_IB_v1 responseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(applicationProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);
                ConsumerBureauEnquiry_Resp_IB_v1.cls_Response response = responseBean.Response;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ApplicationDV applicationDv = response.ApplicationDV;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_CONS CONS = applicationDv.CONS;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ECONSRETURNDATA ECONSRETURNDATA = CONS.ECONSRETURNDATA;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRSUM EENRSUM = CONS.EENRSUM;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMADVCPA ESUMADVCPA = CONS.ESUMADVCPA;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMADVNLR ESUMADVNLR = CONS.ESUMADVNLR;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMCOL ESUMCOL = CONS.ESUMCOL;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMENQCPAALL ESUMENQCPAALL = CONS.ESUMENQCPAALL;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMENQCPAOTH ESUMENQCPAOTH = CONS.ESUMENQCPAOTH;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMENQCPAOWN ESUMENQCPAOWN = CONS.ESUMENQCPAOWN;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMENQNLRALL ESUMENQNLRALL = CONS.ESUMENQNLRALL;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMENQNLROTH ESUMENQNLROTH = CONS.ESUMENQNLROTH;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMENQNLROWN ESUMENQNLROWN = CONS.ESUMENQNLROWN;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMJUD ESUMJUD = CONS.ESUMJUD;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMNEG ESUMNEG = CONS.ESUMNEG;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMNOT ESUMNOT = CONS.ESUMNOT;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMTRA ESUMTRA = CONS.ESUMTRA;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMPPCPAALL ESUMPPCPAALL = CONS.ESUMPPCPAALL;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_ESUMPPNLRALL ESUMPPNLRALL = CONS.ESUMPPNLRALL;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_TCONSRETURNDATA TCONSRETURNDATA = CONS.TCONSRETURNDATA;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_TSUMAGG TSUMAGG = CONS.TSUMAGG;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_TSUMBCC TSUMBCC = CONS.TSUMBCC;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRSUM TENRSUM = CONS.TENRSUM;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_TSUMNLRCOUNT TSUMNLRCOUNT = CONS.TSUMNLRCOUNT;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_TSUMPPSCPA TSUMPPSCPA = CONS.TSUMPPSCPA;
                ConsumerBureauEnquiry_Resp_IB_v1.cls_TSUMPPSNLR TSUMPPSNLR = CONS.TSUMPPSNLR;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETCOL> EDETCOL = CONS.EDETCOL;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETENQCPAOTH> EDETENQCPAOTH = CONS.EDETENQCPAOTH;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETENQCPAOWN> EDETENQCPAOWN = CONS.EDETENQCPAOWN;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETENQNLROTH> EDETENQNLROTH = CONS.EDETENQNLROTH;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETENQNLROWN> EDETENQNLROWN = CONS.EDETENQNLROWN;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETJUD> EDETJUD = CONS.EDETJUD;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETNOT> EDETNOT = CONS.EDETNOT;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETSHW> EDETSHW = CONS.EDETSHW;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSASSETFIN> EENRDETPPSASSETFIN = CONS.EENRDETPPSASSETFIN;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSBONDMRTG> EENRDETPPSBONDMRTG = CONS.EENRDETPPSBONDMRTG;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSCREDITCARD> EENRDETPPSCREDITCARD = CONS.EENRDETPPSCREDITCARD;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSEDUCATION> EENRDETPPSEDUCATION = CONS.EENRDETPPSEDUCATION;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSINSURANCE> EENRDETPPSINSURANCE = CONS.EENRDETPPSINSURANCE;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSLOANOVDRT> EENRDETPPSLOANOVDRT = CONS.EENRDETPPSLOANOVDRT;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSOTHDEBTREPAY> EENRDETPPSOTHDEBTREPAY = CONS.EENRDETPPSOTHDEBTREPAY;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSRETACCOUNTS> EENRDETPPSRETACCOUNTS = CONS.EENRDETPPSRETACCOUNTS;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSSECURITY> EENRDETPPSSECURITY = CONS.EENRDETPPSSECURITY;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSTELECOMM> EENRDETPPSTELECOMM = CONS.EENRDETPPSTELECOMM;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSENTERTAINMENT> EENRDETPPSENTERTAINMENT = CONS.EENRDETPPSENTERTAINMENT;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETENQCPAALL> TDETENQCPAALL = CONS.TDETENQCPAALL;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETENQNLRALL> TDETENQNLRALL = CONS.TDETENQNLRALL;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETJUD> TDETJUD = CONS.TDETJUD;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETNOT> TDETNOT = CONS.TDETNOT;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETTRA> TDETTRA = CONS.TDETTRA;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETFPS> TDETFPS = CONS.TDETFPS;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSASSETFIN> TENRDETPPSASSETFIN = CONS.TENRDETPPSASSETFIN;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSBONDMRTG> TENRDETPPSBONDMRTG = CONS.TENRDETPPSBONDMRTG;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSCREDITCARD> TENRDETPPSCREDITCARD = CONS.TENRDETPPSCREDITCARD;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSEDUCATION> TENRDETPPSEDUCATION = CONS.TENRDETPPSEDUCATION;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSINSURANCE> TENRDETPPSINSURANCE = CONS.TENRDETPPSINSURANCE;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSLOANOVDRT> TENRDETPPSLOANOVDRT = CONS.TENRDETPPSLOANOVDRT;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSOTHDEBTREPAY> TENRDETPPSOTHDEBTREPAY = CONS.TENRDETPPSOTHDEBTREPAY;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSRETACCOUNTS> TENRDETPPSRETACCOUNTS = CONS.TENRDETPPSRETACCOUNTS;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSSECURITY> TENRDETPPSSECURITY = CONS.TENRDETPPSSECURITY;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSTELECOMM> TENRDETPPSTELECOMM = CONS.TENRDETPPSTELECOMM;
                List<ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSENTERTAINMENT> TENRDETPPSENTERTAINMENT = CONS.TENRDETPPSENTERTAINMENT;

                List<Map<String,Object>> edetcolData = new List<Map<String,Object>>();
                List<Map<String,Object>> edetenqcpaothData = new List<Map<String,Object>>();
                List<Map<String,Object>> edetenqcpaownData = new List<Map<String,Object>>();
                List<Map<String,Object>> edetenqnlrothData = new List<Map<String,Object>>();
                List<Map<String,Object>> edetenqnlrownData = new List<Map<String,Object>>();
                List<Map<String,Object>> edetjudData = new List<Map<String,Object>>();
                List<Map<String,Object>> edetnotData = new List<Map<String,Object>>();
                List<Map<String,Object>> edetshwData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppsassetfinData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppsbondmrtgData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppscreditcardData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppseducationData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppsinsuranceData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppsloanovdrtData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppsothdebtrepayData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppsretaccountsData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppssecurityData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppstelecommData = new List<Map<String,Object>>();
                List<Map<String,Object>> eenrdetppsentertainmentData = new List<Map<String,Object>>();
                List<Map<String,Object>> tdetenqcpaallData = new List<Map<String,Object>>();
                List<Map<String,Object>> tdetenqnlrallData = new List<Map<String,Object>>();
                List<Map<String,Object>> tdetjudData = new List<Map<String,Object>>();
                List<Map<String,Object>> tdetnotData = new List<Map<String,Object>>();
                List<Map<String,Object>> tdettraData = new List<Map<String,Object>>();
                List<Map<String,Object>> tdetfpsData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppsassetfinData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppsbondmrtgData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppscreditcardData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppseducationData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppsinsuranceData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppsloanovdrtData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppsothdebtrepayData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppsretaccountsData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppssecurityData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppstelecommData = new List<Map<String,Object>>();
                List<Map<String,Object>> tenrdetppsentertainmentData = new List<Map<String,Object>>();

                if(CONS.EDETCOL != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETCOL record : CONS.EDETCOL){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONDETCOLSUBNAME',record.BURECONDETCOLSUBNAME);
                        mapObj.put('BURECONDETCOLACCNO',record.BURECONDETCOLACCNO);
                        mapObj.put('BURECONDETCOLACCTYPE',record.BURECONDETCOLACCTYPE);
                        mapObj.put('BURECONDETCOLACCTYPECODE',record.BURECONDETCOLACCTYPECODE);
                        mapObj.put('BURECONDETCOLSTSCDE',record.BURECONDETCOLSTSCDE);
                        mapObj.put('BURECONDETCOLSTSDATE',record.BURECONDETCOLSTSDATE);
                        mapObj.put('BURECONDETCOLOPDATE',record.BURECONDETCOLOPDATE);
                        mapObj.put('BURECONDETCOLSTATUS',record.BURECONDETCOLSTATUS);
                        mapObj.put('BURECONDETCOLTELNO',record.BURECONDETCOLTELNO);
                        mapObj.put('BURECONDETCOLOPENBAL',record.BURECONDETCOLOPENBAL);
                        mapObj.put('BURECONDETCOLCREDITLIMIT',record.BURECONDETCOLCREDITLIMIT);
                        mapObj.put('BURECONDETCOLHIGHLIMIT',record.BURECONDETCOLHIGHLIMIT);
                        mapObj.put('BURECONDETCOLCURRENTBAL',record.BURECONDETCOLCURRENTBAL);
                        mapObj.put('BURECONDETCOLBALDATE',record.BURECONDETCOLBALDATE);
                        mapObj.put('BURECONDETCOLLASTPAYM',record.BURECONDETCOLLASTPAYM);
                        mapObj.put('BURECONDETCOLLASTPAYMDATE',record.BURECONDETCOLLASTPAYMDATE);
                        mapObj.put('BURECONDETCOLINSTL',record.BURECONDETCOLINSTL);
                        mapObj.put('BURECONDETCOLPAYMSTATUS',record.BURECONDETCOLPAYMSTATUS);
                        mapObj.put('BURECONDETCOLOVRDUEBAL',record.BURECONDETCOLOVRDUEBAL);
                        mapObj.put('BURECONDETCOLDEBTTYPE',record.BURECONDETCOLDEBTTYPE);

                        edetcolData.add(mapObj);
                    }
                }

                if(CONS.EDETENQCPAOTH != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETENQCPAOTH record : CONS.EDETENQCPAOTH){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONDETENQCPAOTHENQUIRYDATE', record.BURECONDETENQCPAOTHENQUIRYDATE);
                        mapObj.put('BURECONDETENQCPAOTHSUBNAME', record.BURECONDETENQCPAOTHSUBNAME);
                        mapObj.put('BURECONDETENQCPAOTHSUBID', record.BURECONDETENQCPAOTHSUBID);
                        mapObj.put('BURECONDETENQCPAOTHSUBTEL', record.BURECONDETENQCPAOTHSUBTEL);

                        edetenqcpaothData.add(mapObj);
                    }
                }

                if(CONS.EDETENQCPAOWN != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETENQCPAOWN record : CONS.EDETENQCPAOWN){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONDETENQCPAOWNENQUIRYDATE', record.BURECONDETENQCPAOWNENQUIRYDATE);
                        mapObj.put('BURECONDETENQCPAOWNSUBNAME', record.BURECONDETENQCPAOWNSUBNAME);
                        mapObj.put('BURECONDETENQCPAOWNSUBID', record.BURECONDETENQCPAOWNSUBID);
                        mapObj.put('BURECONDETENQCPAOWNSUBTEL', record.BURECONDETENQCPAOWNSUBTEL);

                        edetenqcpaownData.add(mapObj);
                    }
                }

                if(CONS.EDETENQNLROTH != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETENQNLROTH record : CONS.EDETENQNLROTH){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONDETENQNLROTHDATE', record.BURECONDETENQNLROTHDATE);
                        mapObj.put('BURECONDETENQNLROTHSUBNAME', record.BURECONDETENQNLROTHSUBNAME);
                        mapObj.put('BURECONDETENQNLROTHSUBID', record.BURECONDETENQNLROTHSUBID);
                        mapObj.put('BURECONDETENQNLROTHSUBTEL', record.BURECONDETENQNLROTHSUBTEL);
                        mapObj.put('BURECONDETENQNLROTHSTATUS', record.BURECONDETENQNLROTHSTATUS);
                        mapObj.put('BURECONDETENQNLROTHREASON', record.BURECONDETENQNLROTHREASON);
                        mapObj.put('BURECONDETENQNLROTHREFNUM', record.BURECONDETENQNLROTHREFNUM);
                        mapObj.put('BURECONDETENQNLROTHLOANAMT', record.BURECONDETENQNLROTHLOANAMT);
                        mapObj.put('BURECONDETENQNLROTHINSTLAMT', record.BURECONDETENQNLROTHINSTLAMT);
                        mapObj.put('BURECONDETENQNLROTHMONTHLYSAL', record.BURECONDETENQNLROTHMONTHLYSAL);
                        mapObj.put('BURECONDETENQNLROTHREPAYPERIOD', record.BURECONDETENQNLROTHREPAYPERIOD);

                        edetenqnlrothData.add(mapObj);
                    }
                }

                if(CONS.EDETENQNLROWN != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETENQNLROWN record : CONS.EDETENQNLROWN){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONDETENQNLROWNDATE', record.BURECONDETENQNLROWNDATE);
                        mapObj.put('BURECONDETENQNLROWNSUBNAME', record.BURECONDETENQNLROWNSUBNAME);
                        mapObj.put('BURECONDETENQNLROWNSUBID', record.BURECONDETENQNLROWNSUBID);
                        mapObj.put('BURECONDETENQNLROWNSUBTEL', record.BURECONDETENQNLROWNSUBTEL);
                        mapObj.put('BURECONDETENQNLROWNSTATUS', record.BURECONDETENQNLROWNSTATUS);
                        mapObj.put('BURECONDETENQNLROWNREASON', record.BURECONDETENQNLROWNREASON);
                        mapObj.put('BURECONDETENQNLROWNREFNUM', record.BURECONDETENQNLROWNREFNUM);
                        mapObj.put('BURECONDETENQNLROWNLOANAMT', record.BURECONDETENQNLROWNLOANAMT);
                        mapObj.put('BURECONDETENQNLROWNINSTLAMT', record.BURECONDETENQNLROWNINSTLAMT);
                        mapObj.put('BURECONDETENQNLROWNMONTHLYSAL', record.BURECONDETENQNLROWNMONTHLYSAL);
                        mapObj.put('BURECONDETENQNLROWNREPAYPERIOD', record.BURECONDETENQNLROWNREPAYPERIOD);

                        edetenqnlrownData.add(mapObj);
                    }
                }

                if(CONS.EDETJUD != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETJUD record : CONS.EDETJUD){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONDETJUDDATE', record.BURECONDETJUDDATE);
                        mapObj.put('BURECONDETJUDAMT', record.BURECONDETJUDAMT);
                        mapObj.put('BURECONDETJUDPLAINTIFF', record.BURECONDETJUDPLAINTIFF);
                        mapObj.put('BURECONDETJUDTYPCRT', record.BURECONDETJUDTYPCRT);
                        mapObj.put('BURECONDETJUDREASON', record.BURECONDETJUDREASON);
                        mapObj.put('BURECONDETJUDCRTNAME', record.BURECONDETJUDCRTNAME);
                        mapObj.put('BURECONDETJUDCASENUM', record.BURECONDETJUDCASENUM);
                        mapObj.put('BURECONDETJUDPUBDATCATCDE', record.BURECONDETJUDPUBDATCATCDE);
                        mapObj.put('BURECONDETJUDPUBDATCATDES', record.BURECONDETJUDPUBDATCATDES);

                        edetjudData.add(mapObj);
                    }
                }

                if(CONS.EDETNOT != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETNOT record : CONS.EDETNOT){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONDETNOTDATE', record.BURECONDETNOTDATE);
                        mapObj.put('BURECONDETNOTAMT', record.BURECONDETNOTAMT);
                        mapObj.put('BURECONDETNOTPLAINTIFF', record.BURECONDETNOTPLAINTIFF);
                        mapObj.put('BURECONDETNOTREAS', record.BURECONDETNOTREAS);
                        mapObj.put('BURECONDETNOTCRT', record.BURECONDETNOTCRT);
                        mapObj.put('BURECONDETNOTCRTID', record.BURECONDETNOTCRTID);
                        mapObj.put('BURECONDETNOTCRTNME', record.BURECONDETNOTCRTNME);
                        mapObj.put('BURECONDETNOTCSENUM', record.BURECONDETNOTCSENUM);
                        mapObj.put('BURECONDETNOTPUBDATCATCDE', record.BURECONDETNOTPUBDATCATCDE);
                        mapObj.put('BURECONDETNOTPUBDATCATDES', record.BURECONDETNOTPUBDATCATDES);

                        edetnotData.add(mapObj);
                    }
                }

                if(CONS.EDETSHW != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EDETSHW record : CONS.EDETSHW){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONDETSHWREF', record.BURECONDETSHWREF);
                        mapObj.put('BURECONDETSHWORIGREFNUM', record.BURECONDETSHWORIGREFNUM);
                        mapObj.put('BURECONDETSHWMEMNAME', record.BURECONDETSHWMEMNAME);
                        mapObj.put('BURECONDETSHWCONTEL', record.BURECONDETSHWCONTEL);
                        mapObj.put('BURECONDETSHWEMAIL', record.BURECONDETSHWEMAIL);
                        mapObj.put('BURECONDETSHWFRDCAT', record.BURECONDETSHWFRDCAT);
                        mapObj.put('BURECONDETSHWNMEDATORIG', record.BURECONDETSHWNMEDATORIG);

                        edetshwData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSASSETFIN != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSASSETFIN record : CONS.EENRDETPPSASSETFIN){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETVAFPPSOTHSUBNAME', record.BURECONENRDETVAFPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETVAFPPSOTHACCNUM', record.BURECONENRDETVAFPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETVAFPPSOTHCREDITLIMIT', record.BURECONENRDETVAFPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETVAFPPSOTHOPDATE', record.BURECONENRDETVAFPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETVAFPPSOTHOPBAL', record.BURECONENRDETVAFPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETVAFPPSOTHINST', record.BURECONENRDETVAFPPSOTHINST);
                        mapObj.put('BURECONENRDETVAFPPSOTHCURBAL', record.BURECONENRDETVAFPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETVAFPPSOTHOVDAMT', record.BURECONENRDETVAFPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETVAFPPSOTHLSTPAYMENT', record.BURECONENRDETVAFPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETVAFPPSOTHPAYMNTSTATUS', record.BURECONENRDETVAFPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETVAFPPSOTHREPPAY', record.BURECONENRDETVAFPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETVAFPPSOTHLSTPAYDATE', record.BURECONENRDETVAFPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETVAFPPSOTHMRCHISTL12M', record.BURECONENRDETVAFPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETVAFPPSOTHACCTYPCDE', record.BURECONENRDETVAFPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETVAFPPSOTHINDSTRCDE', record.BURECONENRDETVAFPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETVAFPPSOTHNOPRTJNTLN', record.BURECONENRDETVAFPPSOTHNOPRTJNTLN);

                        eenrdetppsassetfinData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSBONDMRTG != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSBONDMRTG record : CONS.EENRDETPPSBONDMRTG){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETBNDPPSOTHSUBNAME', record.BURECONENRDETBNDPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETBNDPPSOTHACCNUM', record.BURECONENRDETBNDPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETBNDPPSOTHCREDITLIMIT', record.BURECONENRDETBNDPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETBNDPPSOTHOPDATE', record.BURECONENRDETBNDPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETBNDPPSOTHOPBAL', record.BURECONENRDETBNDPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETBNDPPSOTHINST', record.BURECONENRDETBNDPPSOTHINST);
                        mapObj.put('BURECONENRDETBNDPPSOTHCURBAL', record.BURECONENRDETBNDPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETBNDPPSOTHOVDAMT', record.BURECONENRDETBNDPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETBNDPPSOTHLSTPAYMENT', record.BURECONENRDETBNDPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETBNDPPSOTHPAYMNTSTATUS', record.BURECONENRDETBNDPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETBNDPPSOTHREPPAY', record.BURECONENRDETBNDPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETBNDPPSOTHLSTPAYDATE', record.BURECONENRDETBNDPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETBNDPPSOTHMRCHISTL12M', record.BURECONENRDETBNDPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETBNDPPSOTHACCTYPCDE', record.BURECONENRDETBNDPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETBNDPPSOTHINDSTRCDE', record.BURECONENRDETBNDPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETBNDPPSOTHNOPRTJNTLN', record.BURECONENRDETBNDPPSOTHNOPRTJNTLN);

                        eenrdetppsbondmrtgData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSCREDITCARD != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSCREDITCARD record : CONS.EENRDETPPSCREDITCARD){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETCCPPSOTHSUBNAME', record.BURECONENRDETCCPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETCCPPSOTHACCNUM', record.BURECONENRDETCCPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETCCPPSOTHCREDITLIMIT', record.BURECONENRDETCCPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETCCPPSOTHOPDATE', record.BURECONENRDETCCPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETCCPPSOTHOPBAL', record.BURECONENRDETCCPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETCCPPSOTHINST', record.BURECONENRDETCCPPSOTHINST);
                        mapObj.put('BURECONENRDETCCPPSOTHCURBAL', record.BURECONENRDETCCPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETCCPPSOTHOVDAMT', record.BURECONENRDETCCPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETCCPPSOTHLSTPAYMENT', record.BURECONENRDETCCPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETCCPPSOTHPAYMNTSTATUS', record.BURECONENRDETCCPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETCCPPSOTHREPPAY', record.BURECONENRDETCCPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETCCPPSOTHLSTPAYDATE', record.BURECONENRDETCCPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETCCPPSOTHMRCHISTL12M', record.BURECONENRDETCCPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETCCPPSOTHACCTYPCDE', record.BURECONENRDETCCPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETCCPPSOTHINDSTRCDE', record.BURECONENRDETCCPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETCCPPSOTHNOPRTJNTLN', record.BURECONENRDETCCPPSOTHNOPRTJNTLN);

                        eenrdetppscreditcardData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSEDUCATION != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSEDUCATION record : CONS.EENRDETPPSEDUCATION){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETEDUPPSOTHSUBNAME', record.BURECONENRDETEDUPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETEDUPPSOTHACCNUM', record.BURECONENRDETEDUPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETEDUPPSOTHCREDITLIMIT', record.BURECONENRDETEDUPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETEDUPPSOTHOPDATE', record.BURECONENRDETEDUPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETEDUPPSOTHOPBAL', record.BURECONENRDETEDUPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETEDUPPSOTHINST', record.BURECONENRDETEDUPPSOTHINST);
                        mapObj.put('BURECONENRDETEDUPPSOTHCURBAL', record.BURECONENRDETEDUPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETEDUPPSOTHOVDAMT', record.BURECONENRDETEDUPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETEDUPPSOTHLSTPAYMENT', record.BURECONENRDETEDUPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETEDUPPSOTHPAYMNTSTATUS', record.BURECONENRDETEDUPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETEDUPPSOTHREPPAY', record.BURECONENRDETEDUPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETEDUPPSOTHLSTPAYDATE', record.BURECONENRDETEDUPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETEDUPPSOTHMRCHISTL12M', record.BURECONENRDETEDUPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETEDUPPSOTHACCTYPCDE', record.BURECONENRDETEDUPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETEDUPPSOTHINDSTRCDE', record.BURECONENRDETEDUPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETEDUPPSOTHNOPRTJNTLN', record.BURECONENRDETEDUPPSOTHNOPRTJNTLN);

                        eenrdetppseducationData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSINSURANCE != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSINSURANCE record : CONS.EENRDETPPSINSURANCE){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETINSPPSOTHSUBNAME', record.BURECONENRDETINSPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETINSPPSOTHACCNUM', record.BURECONENRDETINSPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETINSPPSOTHCREDITLIMIT', record.BURECONENRDETINSPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETINSPPSOTHOPDATE', record.BURECONENRDETINSPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETINSPPSOTHOPBAL', record.BURECONENRDETINSPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETINSPPSOTHINST', record.BURECONENRDETINSPPSOTHINST);
                        mapObj.put('BURECONENRDETINSPPSOTHCURBAL', record.BURECONENRDETINSPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETINSPPSOTHOVDAMT', record.BURECONENRDETINSPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETINSPPSOTHLSTPAYMENT', record.BURECONENRDETINSPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETINSPPSOTHPAYMNTSTATUS', record.BURECONENRDETINSPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETINSPPSOTHREPPAY', record.BURECONENRDETINSPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETINSPPSOTHLSTPAYDATE', record.BURECONENRDETINSPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETINSPPSOTHMRCHISTL12M', record.BURECONENRDETINSPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETINSPPSOTHACCTYPCDE', record.BURECONENRDETINSPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETINSPPSOTHINDSTRCDE', record.BURECONENRDETINSPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETINSPPSOTHNOPRTJNTLN', record.BURECONENRDETINSPPSOTHNOPRTJNTLN);

                        eenrdetppsinsuranceData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSLOANOVDRT != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSLOANOVDRT record : CONS.EENRDETPPSLOANOVDRT){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETODLPPSOTHSUBNAME', record.BURECONENRDETODLPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETODLPPSOTHACCNUM', record.BURECONENRDETODLPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETODLPPSOTHCREDITLIMIT', record.BURECONENRDETODLPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETODLPPSOTHOPDATE', record.BURECONENRDETODLPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETODLPPSOTHOPBAL', record.BURECONENRDETODLPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETODLPPSOTHINST', record.BURECONENRDETODLPPSOTHINST);
                        mapObj.put('BURECONENRDETODLPPSOTHCURBAL', record.BURECONENRDETODLPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETODLPPSOTHOVDAMT', record.BURECONENRDETODLPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETODLPPSOTHLSTPAYMENT', record.BURECONENRDETODLPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETODLPPSOTHPAYMNTSTATUS', record.BURECONENRDETODLPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETODLPPSOTHREPPAY', record.BURECONENRDETODLPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETODLPPSOTHLSTPAYDATE', record.BURECONENRDETODLPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETODLPPSOTHMRCHISTL12M', record.BURECONENRDETODLPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETODLPPSOTHBALTRANSFIND', record.BURECONENRDETODLPPSOTHBALTRANSFIND);
                        mapObj.put('BURECONENRDETODLPPSOTHACCTYPCDE', record.BURECONENRDETODLPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETODLPPSOTHINDSTRCDE', record.BURECONENRDETODLPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETODLPPSOTHNOPRTJNTLN', record.BURECONENRDETODLPPSOTHNOPRTJNTLN);

                        eenrdetppsloanovdrtData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSOTHDEBTREPAY != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSOTHDEBTREPAY record : CONS.EENRDETPPSOTHDEBTREPAY){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETODBTPPSOTHSUBNAME', record.BURECONENRDETODBTPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETODBTPPSOTHACCNUM', record.BURECONENRDETODBTPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETODBTPPSOTHCREDITLIMIT', record.BURECONENRDETODBTPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETODBTPPSOTHOPDATE', record.BURECONENRDETODBTPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETODBTPPSOTHOPBAL', record.BURECONENRDETODBTPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETODBTPPSOTHINST', record.BURECONENRDETODBTPPSOTHINST);
                        mapObj.put('BURECONENRDETODBTPPSOTHCURBAL', record.BURECONENRDETODBTPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETODBTPPSOTHOVDAMT', record.BURECONENRDETODBTPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETODBTPPSOTHLSTPAYMENT', record.BURECONENRDETODBTPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETODBTPPSOTHPAYMNTSTATUS', record.BURECONENRDETODBTPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETODBTPPSOTHREPPAY', record.BURECONENRDETODBTPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETODBTPPSOTHLSTPAYDATE', record.BURECONENRDETODBTPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETODBTPPSOTHMRCHISTL12M', record.BURECONENRDETODBTPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETODBTPPSOTHACCTYPCDE', record.BURECONENRDETODBTPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETODBTPPSOTHINDSTRCDE', record.BURECONENRDETODBTPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETODBTPPSOTHNOPRTJNTLN', record.BURECONENRDETODBTPPSOTHNOPRTJNTLN);

                        eenrdetppsothdebtrepayData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSRETACCOUNTS != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSRETACCOUNTS record : CONS.EENRDETPPSRETACCOUNTS){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETRETPPSOTHSUBNAME', record.BURECONENRDETRETPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETRETPPSOTHACCNUM', record.BURECONENRDETRETPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETRETPPSOTHCREDITLIMIT', record.BURECONENRDETRETPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETRETPPSOTHOPDATE', record.BURECONENRDETRETPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETRETPPSOTHOPBAL', record.BURECONENRDETRETPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETRETPPSOTHINST', record.BURECONENRDETRETPPSOTHINST);
                        mapObj.put('BURECONENRDETRETPPSOTHCURBAL', record.BURECONENRDETRETPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETRETPPSOTHOVDAMT', record.BURECONENRDETRETPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETRETPPSOTHLSTPAYMENT', record.BURECONENRDETRETPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETRETPPSOTHPAYMNTSTATUS', record.BURECONENRDETRETPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETRETPPSOTHREPPAY', record.BURECONENRDETRETPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETRETPPSOTHLSTPAYDATE', record.BURECONENRDETRETPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETRETPPSOTHMRCHISTL12M', record.BURECONENRDETRETPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETRETPPSOTHACCTYPCDE', record.BURECONENRDETRETPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETRETPPSOTHINDSTRCDE', record.BURECONENRDETRETPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETRETPPSOTHNOPRTJNTLN', record.BURECONENRDETRETPPSOTHNOPRTJNTLN);

                        eenrdetppsretaccountsData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSSECURITY != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSSECURITY record : CONS.EENRDETPPSSECURITY){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETSECPPSOTHSUBNAME', record.BURECONENRDETSECPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETSECPPSOTHACCNUM', record.BURECONENRDETSECPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETSECPPSOTHCREDITLIMIT', record.BURECONENRDETSECPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETSECPPSOTHOPDATE', record.BURECONENRDETSECPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETSECPPSOTHOPBAL', record.BURECONENRDETSECPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETSECPPSOTHINST', record.BURECONENRDETSECPPSOTHINST);
                        mapObj.put('BURECONENRDETSECPPSOTHCURBAL', record.BURECONENRDETSECPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETSECPPSOTHOVDAMT', record.BURECONENRDETSECPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETSECPPSOTHLSTPAYMENT', record.BURECONENRDETSECPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETSECPPSOTHPAYMNTSTATUS', record.BURECONENRDETSECPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETSECPPSOTHREPPAY', record.BURECONENRDETSECPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETSECPPSOTHLSTPAYDATE', record.BURECONENRDETSECPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETSECPPSOTHMRCHISTL12M', record.BURECONENRDETSECPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETSECPPSOTHACCTYPCDE', record.BURECONENRDETSECPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETSECPPSOTHINDSTRCDE', record.BURECONENRDETSECPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETSECPPSOTHNOPRTJNTLN', record.BURECONENRDETSECPPSOTHNOPRTJNTLN);

                        eenrdetppssecurityData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSTELECOMM != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSTELECOMM record : CONS.EENRDETPPSTELECOMM){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETTELPPSOTHSUBNAME', record.BURECONENRDETTELPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETTELPPSOTHACCNUM', record.BURECONENRDETTELPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETTELPPSOTHCREDITLIMIT', record.BURECONENRDETTELPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETTELPPSOTHOPDATE', record.BURECONENRDETTELPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETTELPPSOTHOPBAL', record.BURECONENRDETTELPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETTELPPSOTHINST', record.BURECONENRDETTELPPSOTHINST);
                        mapObj.put('BURECONENRDETTELPPSOTHCURBAL', record.BURECONENRDETTELPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETTELPPSOTHOVDAMT', record.BURECONENRDETTELPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETTELPPSOTHLSTPAYMENT', record.BURECONENRDETTELPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETTELPPSOTHPAYMNTSTATUS', record.BURECONENRDETTELPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETTELPPSOTHREPPAY', record.BURECONENRDETTELPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETTELPPSOTHLSTPAYDATE', record.BURECONENRDETTELPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETTELPPSOTHMRCHISTL12M', record.BURECONENRDETTELPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETTELPPSOTHACCTYPCDE', record.BURECONENRDETTELPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETTELPPSOTHINDSTRCDE', record.BURECONENRDETTELPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETTELPPSOTHNOPRTJNTLN', record.BURECONENRDETTELPPSOTHNOPRTJNTLN);

                        eenrdetppstelecommData.add(mapObj);
                    }
                }

                if(CONS.EENRDETPPSENTERTAINMENT != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_EENRDETPPSENTERTAINMENT record : CONS.EENRDETPPSENTERTAINMENT){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURECONENRDETENTPPSOTHSUBNAME', record.BURECONENRDETENTPPSOTHSUBNAME);
                        mapObj.put('BURECONENRDETENTPPSOTHACCNUM', record.BURECONENRDETENTPPSOTHACCNUM);
                        mapObj.put('BURECONENRDETENTPPSOTHCREDITLIMIT', record.BURECONENRDETENTPPSOTHCREDITLIMIT);
                        mapObj.put('BURECONENRDETENTPPSOTHOPDATE', record.BURECONENRDETENTPPSOTHOPDATE);
                        mapObj.put('BURECONENRDETENTPPSOTHOPBAL', record.BURECONENRDETENTPPSOTHOPBAL);
                        mapObj.put('BURECONENRDETENTPPSOTHINST', record.BURECONENRDETENTPPSOTHINST);
                        mapObj.put('BURECONENRDETENTPPSOTHCURBAL', record.BURECONENRDETENTPPSOTHCURBAL);
                        mapObj.put('BURECONENRDETENTPPSOTHOVDAMT', record.BURECONENRDETENTPPSOTHOVDAMT);
                        mapObj.put('BURECONENRDETENTPPSOTHLSTPAYMENT', record.BURECONENRDETENTPPSOTHLSTPAYMENT);
                        mapObj.put('BURECONENRDETENTPPSOTHPAYMNTSTATUS', record.BURECONENRDETENTPPSOTHPAYMNTSTATUS);
                        mapObj.put('BURECONENRDETENTPPSOTHREPPAY', record.BURECONENRDETENTPPSOTHREPPAY);
                        mapObj.put('BURECONENRDETENTPPSOTHLSTPAYDATE', record.BURECONENRDETENTPPSOTHLSTPAYDATE);
                        mapObj.put('BURECONENRDETENTPPSOTHMRCHISTL12M', record.BURECONENRDETENTPPSOTHMRCHISTL12M);
                        mapObj.put('BURECONENRDETENTPPSOTHACCTYPCDE', record.BURECONENRDETENTPPSOTHACCTYPCDE);
                        mapObj.put('BURECONENRDETENTPPSOTHINDSTRCDE', record.BURECONENRDETENTPPSOTHINDSTRCDE);
                        mapObj.put('BURECONENRDETENTPPSOTHNOPRTJNTLN', record.BURECONENRDETENTPPSOTHNOPRTJNTLN);

                        eenrdetppsentertainmentData.add(mapObj);
                    }
                }

                if(CONS.TDETENQCPAALL != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETENQCPAALL record : CONS.TDETENQCPAALL){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONDETENQCPAALLDATE', record.BURTCONDETENQCPAALLDATE);
                        mapObj.put('BURTCONDETENQCPAALLSUBNAME', record.BURTCONDETENQCPAALLSUBNAME);
                        mapObj.put('BURTCONDETENQCPAALLCONTACT', record.BURTCONDETENQCPAALLCONTACT);
                        mapObj.put('BURTCONDETENQCPAALLTYPECODE', record.BURTCONDETENQCPAALLTYPECODE);
                        mapObj.put('BURTCONDETENQCPAALLTYPEDESC', record.BURTCONDETENQCPAALLTYPEDESC);
                        mapObj.put('BURTCONDETENQCPAALLOWNACC', record.BURTCONDETENQCPAALLOWNACC);

                        tdetenqcpaallData.add(mapObj);
                    }
                }

                if(CONS.TDETENQNLRALL != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETENQNLRALL record : CONS.TDETENQNLRALL){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONDETENQNLRALLDATE', record.BURTCONDETENQNLRALLDATE);
                        mapObj.put('BURTCONDETENQNLRALLSUBNAME', record.BURTCONDETENQNLRALLSUBNAME);
                        mapObj.put('BURTCONDETENQNLRALLCONTACT', record.BURTCONDETENQNLRALLCONTACT);
                        mapObj.put('BURTCONDETENQNLRALLTYPE', record.BURTCONDETENQNLRALLTYPE);
                        mapObj.put('BURTCONDETENQNLRALLREFNUM', record.BURTCONDETENQNLRALLREFNUM);
                        mapObj.put('BURTCONDETENQNLRALLSTATUS', record.BURTCONDETENQNLRALLSTATUS);

                        tdetenqnlrallData.add(mapObj);
                    }
                }

                if(CONS.TDETJUD != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETJUD record : CONS.TDETJUD){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONDETJDGDATE', record.BURTCONDETJDGDATE);
                        mapObj.put('BURTCONDETJDGAMT', record.BURTCONDETJDGAMT);
                        mapObj.put('BURTCONDETJDGPLAINTIFF', record.BURTCONDETJDGPLAINTIFF);
                        mapObj.put('BURTCONDETJDGTYPECODE', record.BURTCONDETJDGTYPECODE);
                        mapObj.put('BURTCONDETJDGTYPEDESC', record.BURTCONDETJDGTYPEDESC);
                        mapObj.put('BURTCONDETJDGCRTTYPECODE', record.BURTCONDETJDGCRTTYPECODE);
                        mapObj.put('BURTCONDETJDGCRTTYPE', record.BURTCONDETJDGCRTTYPE);
                        mapObj.put('BURTCONDETJDGCRTNAMECODE', record.BURTCONDETJDGCRTNAMECODE);
                        mapObj.put('BURTCONDETJDGCRTNAME', record.BURTCONDETJDGCRTNAME);
                        mapObj.put('BURTCONDETJDGCASENUM', record.BURTCONDETJDGCASENUM);
                        mapObj.put('BURTCONDETJDGNATUREDEBTCODE', record.BURTCONDETJDGNATUREDEBTCODE);
                        mapObj.put('BURTCONDETJDGNATUREDEBT', record.BURTCONDETJDGNATUREDEBT);

                        tdetjudData.add(mapObj);
                    }
                }

                if(CONS.TDETNOT != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETNOT record : CONS.TDETNOT){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONDETNOTDATE', record.BURTCONDETNOTDATE);
                        mapObj.put('BURTCONDETNOTAMT', record.BURTCONDETNOTAMT);
                        mapObj.put('BURTCONDETNOTAPPLICANT', record.BURTCONDETNOTAPPLICANT);
                        mapObj.put('BURTCONDETNOTTYPECODE', record.BURTCONDETNOTTYPECODE);
                        mapObj.put('BURTCONDETNOTTYPE', record.BURTCONDETNOTTYPE);
                        mapObj.put('BURTCONDETNOTCAPTDATE', record.BURTCONDETNOTCAPTDATE);
                        mapObj.put('BURTCONDETNOTCRTTYPECODE', record.BURTCONDETNOTCRTTYPECODE);
                        mapObj.put('BURTCONDETNOTCRTTYPE', record.BURTCONDETNOTCRTTYPE);
                        mapObj.put('BURTCONDETNOTCRTNAMECODE', record.BURTCONDETNOTCRTNAMECODE);
                        mapObj.put('BURTCONDETNOTCRTNAME', record.BURTCONDETNOTCRTNAME);
                        mapObj.put('BURTCONDETNOTCSENUM', record.BURTCONDETNOTCSENUM);

                        tdetnotData.add(mapObj);
                    }
                }

                if(CONS.TDETTRA != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETTRA record : CONS.TDETTRA){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONDETTRATYPECDE', record.BURTCONDETTRATYPECDE);
                        mapObj.put('BURTCONDETTRATYPE', record.BURTCONDETTRATYPE);
                        mapObj.put('BURTCONDETTRASUBNAME', record.BURTCONDETTRASUBNAME);

                        tdettraData.add(mapObj);
                    }
                }

                if(CONS.TDETFPS != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TDETFPS record : CONS.TDETFPS){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONDETFPSREFNUM', record.BURTCONDETFPSREFNUM);
                        mapObj.put('BURTCONDETFPSORIGREFNUM', record.BURTCONDETFPSORIGREFNUM);
                        mapObj.put('BURTCONDETFPSMEMREGNUM', record.BURTCONDETFPSMEMREGNUM);
                        mapObj.put('BURTCONDETFPSMEMNAME', record.BURTCONDETFPSMEMNAME);
                        mapObj.put('BURTCONDETFPSCONTELCODE', record.BURTCONDETFPSCONTELCODE);
                        mapObj.put('BURTCONDETFPSCONTEL', record.BURTCONDETFPSCONTEL);
                        mapObj.put('BURTCONDETFPSCONEMAIL', record.BURTCONDETFPSCONEMAIL);
                        mapObj.put('BURTCONDETFPSFRDCAT', record.BURTCONDETFPSFRDCAT);
                        mapObj.put('BURTCONDETFPSNMEDATORIG', record.BURTCONDETFPSNMEDATORIG);
                        mapObj.put('BURTCONDETFPSFRDCASEDATE', record.BURTCONDETFPSFRDCASEDATE);

                        tdetfpsData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSASSETFIN != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSASSETFIN record : CONS.TENRDETPPSASSETFIN){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETVAFPPSOTHSUPPLNAME', record.BURTCONENRDETVAFPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETVAFPPSOTHACCTYPCDE', record.BURTCONENRDETVAFPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETVAFPPSOTHINST', record.BURTCONENRDETVAFPPSOTHINST);
                        mapObj.put('BURTCONENRDETVAFPPSOTHCURBAL', record.BURTCONENRDETVAFPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETVAFPPSOTHNOPRTJNTLN', record.BURTCONENRDETVAFPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETVAFPPSOTHINDSTRCDE', record.BURTCONENRDETVAFPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETVAFPPSOTHACCNUM', record.BURTCONENRDETVAFPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETVAFPPSOTHOPDATE', record.BURTCONENRDETVAFPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETVAFPPSOTHOPBAL', record.BURTCONENRDETVAFPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETVAFPPSOTHOVDAMT', record.BURTCONENRDETVAFPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETVAFPPSOTHREPPAY', record.BURTCONENRDETVAFPPSOTHREPPAY);

                        tenrdetppsassetfinData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSBONDMRTG != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSBONDMRTG record : CONS.TENRDETPPSBONDMRTG){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETBNDPPSOTHSUPPLNAME', record.BURTCONENRDETBNDPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETBNDPPSOTHACCTYPCDE', record.BURTCONENRDETBNDPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETBNDPPSOTHINST', record.BURTCONENRDETBNDPPSOTHINST);
                        mapObj.put('BURTCONENRDETBNDPPSOTHCURBAL', record.BURTCONENRDETBNDPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETBNDPPSOTHNOPRTJNTLN', record.BURTCONENRDETBNDPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETBNDPPSOTHINDSTRCDE', record.BURTCONENRDETBNDPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETBNDPPSOTHACCNUM', record.BURTCONENRDETBNDPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETBNDPPSOTHOPDATE', record.BURTCONENRDETBNDPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETBNDPPSOTHOPBAL', record.BURTCONENRDETBNDPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETBNDPPSOTHOVDAMT', record.BURTCONENRDETBNDPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETBNDPPSOTHREPPAY', record.BURTCONENRDETBNDPPSOTHREPPAY);

                        tenrdetppsbondmrtgData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSCREDITCARD != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSCREDITCARD record : CONS.TENRDETPPSCREDITCARD){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETCCPPSOTHSUPPLNAME', record.BURTCONENRDETCCPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETCCPPSOTHACCTYPCDE', record.BURTCONENRDETCCPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETCCPPSOTHINST', record.BURTCONENRDETCCPPSOTHINST);
                        mapObj.put('BURTCONENRDETCCPPSOTHCURBAL', record.BURTCONENRDETCCPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETCCPPSOTHNOPRTJNTLN', record.BURTCONENRDETCCPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETCCPPSOTHINDSTRCDE', record.BURTCONENRDETCCPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETCCPPSOTHACCNUM', record.BURTCONENRDETCCPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETCCPPSOTHOPDATE', record.BURTCONENRDETCCPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETCCPPSOTHOPBAL', record.BURTCONENRDETCCPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETCCPPSOTHOVDAMT', record.BURTCONENRDETCCPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETCCPPSOTHREPPAY', record.BURTCONENRDETCCPPSOTHREPPAY);

                        tenrdetppscreditcardData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSEDUCATION != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSEDUCATION record : CONS.TENRDETPPSEDUCATION){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETEDUPPSOTHSUPPLNAME', record.BURTCONENRDETEDUPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETEDUPPSOTHACCTYPCDE', record.BURTCONENRDETEDUPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETEDUPPSOTHINST', record.BURTCONENRDETEDUPPSOTHINST);
                        mapObj.put('BURTCONENRDETEDUPPSOTHCURBAL', record.BURTCONENRDETEDUPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETEDUPPSOTHNOPRTJNTLN', record.BURTCONENRDETEDUPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETEDUPPSOTHINDSTRCDE', record.BURTCONENRDETEDUPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETEDUPPSOTHACCNUM', record.BURTCONENRDETEDUPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETEDUPPSOTHOPDATE', record.BURTCONENRDETEDUPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETEDUPPSOTHOPBAL', record.BURTCONENRDETEDUPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETEDUPPSOTHOVDAMT', record.BURTCONENRDETEDUPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETEDUPPSOTHREPPAY', record.BURTCONENRDETEDUPPSOTHREPPAY);

                        tenrdetppseducationData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSINSURANCE != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSINSURANCE record : CONS.TENRDETPPSINSURANCE){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETINSPPSOTHSUPPLNAME', record.BURTCONENRDETINSPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETINSPPSOTHACCTYPCDE', record.BURTCONENRDETINSPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETINSPPSOTHINST', record.BURTCONENRDETINSPPSOTHINST);
                        mapObj.put('BURTCONENRDETINSPPSOTHCURBAL', record.BURTCONENRDETINSPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETINSPPSOTHNOPRTJNTLN', record.BURTCONENRDETINSPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETINSPPSOTHINDSTRCDE', record.BURTCONENRDETINSPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETINSPPSOTHACCNUM', record.BURTCONENRDETINSPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETINSPPSOTHOPDATE', record.BURTCONENRDETINSPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETINSPPSOTHOPBAL', record.BURTCONENRDETINSPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETINSPPSOTHOVDAMT', record.BURTCONENRDETINSPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETINSPPSOTHREPPAY', record.BURTCONENRDETINSPPSOTHREPPAY);

                        tenrdetppsinsuranceData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSLOANOVDRT != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSLOANOVDRT record : CONS.TENRDETPPSLOANOVDRT){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETODLPPSOTHSUPPLNAME', record.BURTCONENRDETODLPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETODLPPSOTHACCTYPCDE', record.BURTCONENRDETODLPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETODLPPSOTHINST', record.BURTCONENRDETODLPPSOTHINST);
                        mapObj.put('BURTCONENRDETODLPPSOTHCURBAL', record.BURTCONENRDETODLPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETODLPPSOTHNOPRTJNTLN', record.BURTCONENRDETODLPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETODLPPSOTHINDSTRCDE', record.BURTCONENRDETODLPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETODLPPSOTHBALTRANSFIND', record.BURTCONENRDETODLPPSOTHBALTRANSFIND);
                        mapObj.put('BURTCONENRDETODLPPSOTHACCNUM', record.BURTCONENRDETODLPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETODLPPSOTHOPDATE', record.BURTCONENRDETODLPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETODLPPSOTHOPBAL', record.BURTCONENRDETODLPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETODLPPSOTHOVDAMT', record.BURTCONENRDETODLPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETODLPPSOTHREPPAY', record.BURTCONENRDETODLPPSOTHREPPAY);

                        tenrdetppsloanovdrtData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSOTHDEBTREPAY != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSOTHDEBTREPAY record : CONS.TENRDETPPSOTHDEBTREPAY){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETODBTPPSOTHSUPPLNAME', record.BURTCONENRDETODBTPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETODBTPPSOTHACCTYPCDE', record.BURTCONENRDETODBTPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETODBTPPSOTHINST', record.BURTCONENRDETODBTPPSOTHINST);
                        mapObj.put('BURTCONENRDETODBTPPSOTHCURBAL', record.BURTCONENRDETODBTPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETODBTPPSOTHNOPRTJNTLN', record.BURTCONENRDETODBTPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETODBTPPSOTHINDSTRCDE', record.BURTCONENRDETODBTPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETODBTPPSOTHACCNUM', record.BURTCONENRDETODBTPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETODBTPPSOTHOPDATE', record.BURTCONENRDETODBTPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETODBTPPSOTHOPBAL', record.BURTCONENRDETODBTPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETODBTPPSOTHOVDAMT', record.BURTCONENRDETODBTPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETODBTPPSOTHREPPAY', record.BURTCONENRDETODBTPPSOTHREPPAY);

                        tenrdetppsothdebtrepayData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSRETACCOUNTS != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSRETACCOUNTS record : CONS.TENRDETPPSRETACCOUNTS){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETRETPPSOTHSUPPLNAME', record.BURTCONENRDETRETPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETRETPPSOTHACCTYPCDE', record.BURTCONENRDETRETPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETRETPPSOTHINST', record.BURTCONENRDETRETPPSOTHINST);
                        mapObj.put('BURTCONENRDETRETPPSOTHCURBAL', record.BURTCONENRDETRETPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETRETPPSOTHNOPRTJNTLN', record.BURTCONENRDETRETPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETRETPPSOTHINDSTRCDE', record.BURTCONENRDETRETPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETRETPPSOTHACCNUM', record.BURTCONENRDETRETPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETRETPPSOTHOPDATE', record.BURTCONENRDETRETPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETRETPPSOTHOPBAL', record.BURTCONENRDETRETPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETRETPPSOTHOVDAMT', record.BURTCONENRDETRETPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETRETPPSOTHREPPAY', record.BURTCONENRDETRETPPSOTHREPPAY);

                        tenrdetppsretaccountsData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSSECURITY != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSSECURITY record : CONS.TENRDETPPSSECURITY){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETSECPPSOTHSUPPLNAME', record.BURTCONENRDETSECPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETSECPPSOTHACCTYPCDE', record.BURTCONENRDETSECPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETSECPPSOTHINST', record.BURTCONENRDETSECPPSOTHINST);
                        mapObj.put('BURTCONENRDETSECPPSOTHCURBAL', record.BURTCONENRDETSECPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETSECPPSOTHNOPRTJNTLN', record.BURTCONENRDETSECPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETSECPPSOTHINDSTRCDE', record.BURTCONENRDETSECPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETSECPPSOTHACCNUM', record.BURTCONENRDETSECPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETSECPPSOTHOPDATE', record.BURTCONENRDETSECPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETSECPPSOTHOPBAL', record.BURTCONENRDETSECPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETSECPPSOTHOVDAMT', record.BURTCONENRDETSECPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETSECPPSOTHREPPAY', record.BURTCONENRDETSECPPSOTHREPPAY);

                        tenrdetppssecurityData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSTELECOMM != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSTELECOMM record : CONS.TENRDETPPSTELECOMM){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETTELPPSOTHSUPPLNAME', record.BURTCONENRDETTELPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETTELPPSOTHACCTYPCDE', record.BURTCONENRDETTELPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETTELPPSOTHINST', record.BURTCONENRDETTELPPSOTHINST);
                        mapObj.put('BURTCONENRDETTELPPSOTHCURBAL', record.BURTCONENRDETTELPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETTELPPSOTHNOPRTJNTLN', record.BURTCONENRDETTELPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETTELPPSOTHINDSTRCDE', record.BURTCONENRDETTELPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETTELPPSOTHACCNUM', record.BURTCONENRDETTELPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETTELPPSOTHOPDATE', record.BURTCONENRDETTELPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETTELPPSOTHOPBAL', record.BURTCONENRDETTELPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETTELPPSOTHOVDAMT', record.BURTCONENRDETTELPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETTELPPSOTHREPPAY', record.BURTCONENRDETTELPPSOTHREPPAY);

                        tenrdetppstelecommData.add(mapObj);
                    }
                }

                if(CONS.TENRDETPPSENTERTAINMENT != null){
                    for(ConsumerBureauEnquiry_Resp_IB_v1.cls_TENRDETPPSENTERTAINMENT record : CONS.TENRDETPPSENTERTAINMENT){
                        Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('BURTCONENRDETENTPPSOTHSUPPLNAME', record.BURTCONENRDETENTPPSOTHSUPPLNAME);
                        mapObj.put('BURTCONENRDETENTPPSOTHACCTYPCDE', record.BURTCONENRDETENTPPSOTHACCTYPCDE);
                        mapObj.put('BURTCONENRDETENTPPSOTHINST', record.BURTCONENRDETENTPPSOTHINST);
                        mapObj.put('BURTCONENRDETENTPPSOTHCURBAL', record.BURTCONENRDETENTPPSOTHCURBAL);
                        mapObj.put('BURTCONENRDETENTPPSOTHNOPRTJNTLN', record.BURTCONENRDETENTPPSOTHNOPRTJNTLN);
                        mapObj.put('BURTCONENRDETENTPPSOTHINDSTRCDE', record.BURTCONENRDETENTPPSOTHINDSTRCDE);
                        mapObj.put('BURTCONENRDETENTPPSOTHACCNUM', record.BURTCONENRDETENTPPSOTHACCNUM);
                        mapObj.put('BURTCONENRDETENTPPSOTHOPDATE', record.BURTCONENRDETENTPPSOTHOPDATE);
                        mapObj.put('BURTCONENRDETENTPPSOTHOPBAL', record.BURTCONENRDETENTPPSOTHOPBAL);
                        mapObj.put('BURTCONENRDETENTPPSOTHOVDAMT', record.BURTCONENRDETENTPPSOTHOVDAMT);
                        mapObj.put('BURTCONENRDETENTPPSOTHREPPAY', record.BURTCONENRDETENTPPSOTHREPPAY);

                        tenrdetppsentertainmentData.add(mapObj);
                    }
                }

                Map<String,Object> mapObj = new Map<String,Object>();

                mapObj.put('CIFCODE', applicationProfile.Client_CIF_Code__c);
                mapObj.put('BUREAUREPORT1', applicationProfile.Bureau_Report_1__c);
                mapObj.put('BUREAUREPORT2', applicationProfile.Bureau_Report_2__c);
                mapObj.put('WORSTREPORT', applicationProfile.Bureau_Worst_Report__c);
                mapObj.put('CALLTYPE', 'TU');

                if(applicationDv != null){
                    mapObj.put('APPPCCEID', applicationDv.APPPCCEID);
                    mapObj.put('APPDATE', applicationDv.APPDATE);
                    mapObj.put('APPTIME', applicationDv.APPTIME);
                    mapObj.put('DERBUR1LOOKUPDATAUSEDFLAG', applicationDv.DERBUR1LOOKUPDATAUSEDFLAG);
                    mapObj.put('DERBUR2LOOKUPDATAUSEDFLAG', applicationDv.DERBUR2LOOKUPDATAUSEDFLAG);
                    mapObj.put('DERBUR3LOOKUPDATAUSEDFLAG', applicationDv.DERBUR3LOOKUPDATAUSEDFLAG);
                    mapObj.put('DERBUR4LOOKUPDATAUSEDFLAG', applicationDv.DERBUR4LOOKUPDATAUSEDFLAG);
                }

                if(ECONSRETURNDATA != null){
                    mapObj.put('BURECONMATCHDATE', ECONSRETURNDATA.BURECONMATCHDATE);
                    mapObj.put('BURECONMATCHSESSID', ECONSRETURNDATA.BURECONMATCHSESSID);
                    mapObj.put('BURECONMATCHTIME', ECONSRETURNDATA.BURECONMATCHTIME);
                    mapObj.put('BURECONMATCHNAME', ECONSRETURNDATA.BURECONMATCHNAME);
                    mapObj.put('BURECONMATCHSURNAME', ECONSRETURNDATA.BURECONMATCHSURNAME);
                    mapObj.put('BURECONMATCHID', ECONSRETURNDATA.BURECONMATCHID);
                    mapObj.put('BURECONMATCHDOB', ECONSRETURNDATA.BURECONMATCHDOB);
                }

                if(EENRSUM != null){
                    mapObj.put('BURECONENRSUMENQALLTOTEVER', EENRSUM.BURECONENRSUMENQALLTOTEVER);
                    mapObj.put('BURECONENRSUMENQALLTOTL90D', EENRSUM.BURECONENRSUMENQALLTOTL90D);
                    mapObj.put('BURECONENRSUMENQALLTOTL180D', EENRSUM.BURECONENRSUMENQALLTOTL180D);
                    mapObj.put('BURECONENRSUMENQALLTOTL1Y', EENRSUM.BURECONENRSUMENQALLTOTL1Y);
                    mapObj.put('BURECONENRSUMENQALLTOTL2Y', EENRSUM.BURECONENRSUMENQALLTOTL2Y);
                    mapObj.put('BURECONENRSUMENQALLMNTHSMOSTREC', EENRSUM.BURECONENRSUMENQALLMNTHSMOSTREC);
                    mapObj.put('BURECONENRSUMENQALLDAYSMOSTREC', EENRSUM.BURECONENRSUMENQALLDAYSMOSTREC);
                    mapObj.put('BURECONENRSUMADVALLTOTEVER', EENRSUM.BURECONENRSUMADVALLTOTEVER);
                    mapObj.put('BURECONENRSUMADVALLTOTL90D', EENRSUM.BURECONENRSUMADVALLTOTL90D);
                    mapObj.put('BURECONENRSUMADVALLTOTL180D', EENRSUM.BURECONENRSUMADVALLTOTL180D);
                    mapObj.put('BURECONENRSUMADVALLTOTL1Y', EENRSUM.BURECONENRSUMADVALLTOTL1Y);
                    mapObj.put('BURECONENRSUMADVALLTOTL2Y', EENRSUM.BURECONENRSUMADVALLTOTL2Y);
                    mapObj.put('BURECONENRSUMADVALLTOTVAL', EENRSUM.BURECONENRSUMADVALLTOTVAL);
                    mapObj.put('BURECONENRSUMADVALLHIGHVAL', EENRSUM.BURECONENRSUMADVALLHIGHVAL);
                    mapObj.put('BURECONENRSUMADVALLMONTHHIGH', EENRSUM.BURECONENRSUMADVALLMONTHHIGH);
                    mapObj.put('BURECONENRSUMADVALLMONTHMRC', EENRSUM.BURECONENRSUMADVALLMONTHMRC);
                    mapObj.put('BURECONENRSUMADVALLVALMRC', EENRSUM.BURECONENRSUMADVALLVALMRC);
                    mapObj.put('BURECONENRSUMPPSBANKWSTSTOPENPPMORE12ML180D', EENRSUM.BURECONENRSUMPPSBANKWSTSTOPENPPMORE12ML180D);
                    mapObj.put('BURECONENRSUMPPSBANKWSTSTOPENPP412ML180D', EENRSUM.BURECONENRSUMPPSBANKWSTSTOPENPP412ML180D);
                    mapObj.put('BURECONENRSUMPPSRETWSTSTOPENPPMORE12ML180D', EENRSUM.BURECONENRSUMPPSRETWSTSTOPENPPMORE12ML180D);
                    mapObj.put('BURECONENRSUMPPSRETWSTSTOPENPP412ML180D', EENRSUM.BURECONENRSUMPPSRETWSTSTOPENPP412ML180D);
                    mapObj.put('BURECONENRSUMPPSOWNCURRBAL', EENRSUM.BURECONENRSUMPPSOWNCURRBAL);
                    mapObj.put('BURECONENRSUMPPSOWNMNTHINSTVALCURROPEN', EENRSUM.BURECONENRSUMPPSOWNMNTHINSTVALCURROPEN);
                    mapObj.put('BURECONENRSUMPPSOTHCURRBAL', EENRSUM.BURECONENRSUMPPSOTHCURRBAL);
                    mapObj.put('BURECONENRSUMPPSOTHMNTHINSTVALCURROPEN', EENRSUM.BURECONENRSUMPPSOTHMNTHINSTVALCURROPEN);
                    mapObj.put('BURECONENRSUMPPSALLOVERDUEBAL', EENRSUM.BURECONENRSUMPPSALLOVERDUEBAL);
                    mapObj.put('BURECONENRSUMPPSALLNUMPOSACC12M', EENRSUM.BURECONENRSUMPPSALLNUMPOSACC12M);
                    mapObj.put('BURECONENRSUMPPSALLNUMPOSACC24M', EENRSUM.BURECONENRSUMPPSALLNUMPOSACC24M);
                    mapObj.put('BURECONENRSUMPPSALLNUMPOSACC36M', EENRSUM.BURECONENRSUMPPSALLNUMPOSACC36M);
                    mapObj.put('BURECONENRSUMPPSALLWSTARRACC24M', EENRSUM.BURECONENRSUMPPSALLWSTARRACC24M);
                    mapObj.put('BURECONENRSUMPPSALLWSTARRACC36M', EENRSUM.BURECONENRSUMPPSALLWSTARRACC36M);
                    mapObj.put('BURECONENRSUMPPSALLNUMPPSEVER', EENRSUM.BURECONENRSUMPPSALLNUMPPSEVER);
                    mapObj.put('BURECONENRSUMPPSALLCURROPENPPS', EENRSUM.BURECONENRSUMPPSALLCURROPENPPS);
                    mapObj.put('BURECONENRSUMPPSALLCURRBALPPS', EENRSUM.BURECONENRSUMPPSALLCURRBALPPS);
                    mapObj.put('BURECONENRSUMPPSALLOUTBALEXCLHL', EENRSUM.BURECONENRSUMPPSALLOUTBALEXCLHL);
                    mapObj.put('BURECONENRSUMPPSALLOUTBALHLACC', EENRSUM.BURECONENRSUMPPSALLOUTBALHLACC);
                    mapObj.put('BURECONENRSUMPPSALLNUMACTVACC', EENRSUM.BURECONENRSUMPPSALLNUMACTVACC);
                    mapObj.put('BURECONENRSUMPPSALLACOP12M', EENRSUM.BURECONENRSUMPPSALLACOP12M);
                    mapObj.put('BURECONENRSUMPPSALLACNDOPL6M', EENRSUM.BURECONENRSUMPPSALLACNDOPL6M);
                    mapObj.put('BURECONENRSUMPPSALLDLNQEVER', EENRSUM.BURECONENRSUMPPSALLDLNQEVER);
                    mapObj.put('BURECONENRSUMPPSALLCLSPPS', EENRSUM.BURECONENRSUMPPSALLCLSPPS);
                    mapObj.put('BURECONENRSUMPPSALLNUMWOFFPPS', EENRSUM.BURECONENRSUMPPSALLNUMWOFFPPS);
                    mapObj.put('BURECONENRSUMPPSALLCMLTVINSTVAL', EENRSUM.BURECONENRSUMPPSALLCMLTVINSTVAL);
                    mapObj.put('BURECONENRSUMPPSALLNUMHABSLOWPPS', EENRSUM.BURECONENRSUMPPSALLNUMHABSLOWPPS);
                    mapObj.put('BURECONENRSUMPPSALLMSMROPPPS', EENRSUM.BURECONENRSUMPPSALLMSMROPPPS);
                    mapObj.put('BURECONENRSUMPPSALLDAYSSMRDLNQACC', EENRSUM.BURECONENRSUMPPSALLDAYSSMRDLNQACC);
                    mapObj.put('BURECONENRSUMPPSALLTOTOBACTVACC', EENRSUM.BURECONENRSUMPPSALLTOTOBACTVACC);
                    mapObj.put('BURECONENRSUMPPSALLMNTHLYINSTCURROPEN', EENRSUM.BURECONENRSUMPPSALLMNTHLYINSTCURROPEN);
                    mapObj.put('BURECONENRSUMPPSALLWSTARREVER', EENRSUM.BURECONENRSUMPPSALLWSTARREVER);
                    mapObj.put('BURECONENRSUMPPSALLWSTARRL90D', EENRSUM.BURECONENRSUMPPSALLWSTARRL90D);
                    mapObj.put('BURECONENRSUMPPSALLWSTARRL180', EENRSUM.BURECONENRSUMPPSALLWSTARRL180);
                    mapObj.put('BURECONENRSUMPPSALLWSTARRL1Y', EENRSUM.BURECONENRSUMPPSALLWSTARRL1Y);
                    mapObj.put('BURECONENRSUMPPSALLWSTARRCLEVER', EENRSUM.BURECONENRSUMPPSALLWSTARRCLEVER);
                    mapObj.put('BURECONENRSUMPPSALLWSTARROPEVER', EENRSUM.BURECONENRSUMPPSALLWSTARROPEVER);
                    mapObj.put('BURECONENRSUMPPSALLWSTARRLEVLMRCOPEN', EENRSUM.BURECONENRSUMPPSALLWSTARRLEVLMRCOPEN);
                    mapObj.put('BURECONENRSUMPPSALLNUM3PARRL3M', EENRSUM.BURECONENRSUMPPSALLNUM3PARRL3M);
                    mapObj.put('BURECONENRSUMPPSALLNUM3PARRL12M', EENRSUM.BURECONENRSUMPPSALLNUM3PARRL12M);
                    mapObj.put('BURECONENRSUMPPSALLNUM3PARRL24M', EENRSUM.BURECONENRSUMPPSALLNUM3PARRL24M);
                    mapObj.put('BURECONENRSUMNOTWRSTTYPE', EENRSUM.BURECONENRSUMNOTWRSTTYPE);
                    mapObj.put('BURECONENRSUMNOTMNTHSWRSTTYPE', EENRSUM.BURECONENRSUMNOTMNTHSWRSTTYPE);
                    mapObj.put('BURECONENRSUMNOTMRECTYPE', EENRSUM.BURECONENRSUMNOTMRECTYPE);
                    mapObj.put('BURECONENRSUMNOTMNTHSMRECTYPE', EENRSUM.BURECONENRSUMNOTMNTHSMRECTYPE);
                    mapObj.put('BURECONENRSUMMNTHSSNCEREHAB', EENRSUM.BURECONENRSUMMNTHSSNCEREHAB);
                    mapObj.put('BURECONENRSUMEVERINSOLVENT', EENRSUM.BURECONENRSUMEVERINSOLVENT);
                    mapObj.put('BURECONENRSUMPPSALLVALWOFFPPS', EENRSUM.BURECONENRSUMPPSALLVALWOFFPPS);
                    mapObj.put('BURECONENRSUMPPSALLNUMMRECWOFFPPS', EENRSUM.BURECONENRSUMPPSALLNUMMRECWOFFPPS);
                    mapObj.put('BURECONENRSUMPPSALLVALMRECWOFFPPS', EENRSUM.BURECONENRSUMPPSALLVALMRECWOFFPPS);
                    mapObj.put('BURECONENRSUMPPSALLNUMHIGHWOFFPPS', EENRSUM.BURECONENRSUMPPSALLNUMHIGHWOFFPPS);
                    mapObj.put('BURECONENRSUMPPSALLVALHIGHWOFFPPS', EENRSUM.BURECONENRSUMPPSALLVALHIGHWOFFPPS);
                    mapObj.put('BURECONENRSUMPPSALLDAYSMRECOPPPS', EENRSUM.BURECONENRSUMPPSALLDAYSMRECOPPPS);
                    mapObj.put('BURECONENRTOTPPSALLASSETFININSTL', EENRSUM.BURECONENRTOTPPSALLASSETFININSTL);
                    mapObj.put('BURECONENRTOTPPSALLBONDMRTGINSTL', EENRSUM.BURECONENRTOTPPSALLBONDMRTGINSTL);
                    mapObj.put('BURECONENRTOTPPSALLCREDITCARDINSTL', EENRSUM.BURECONENRTOTPPSALLCREDITCARDINSTL);
                    mapObj.put('BURECONENRTOTPPSALLEDUCATIONINSTL', EENRSUM.BURECONENRTOTPPSALLEDUCATIONINSTL);
                    mapObj.put('BURECONENRTOTPPSALLINSURANCEINSTL', EENRSUM.BURECONENRTOTPPSALLINSURANCEINSTL);
                    mapObj.put('BURECONENRTOTPPSALLLOANOVDRTINSTL', EENRSUM.BURECONENRTOTPPSALLLOANOVDRTINSTL);
                    mapObj.put('BURECONENRTOTPPSALLOTHDEBTREPAYINSTL', EENRSUM.BURECONENRTOTPPSALLOTHDEBTREPAYINSTL);
                    mapObj.put('BURECONENRTOTPPSALLRETAILINSTL', EENRSUM.BURECONENRTOTPPSALLRETAILINSTL);
                    mapObj.put('BURECONENRTOTPPSALLSECURITYINSTL', EENRSUM.BURECONENRTOTPPSALLSECURITYINSTL);
                    mapObj.put('BURECONENRTOTPPSALLTELECOMMINSTL', EENRSUM.BURECONENRTOTPPSALLTELECOMMINSTL);
                    mapObj.put('BURECONENRTOTPPSALLENTERTAINMENTINSTL', EENRSUM.BURECONENRTOTPPSALLENTERTAINMENTINSTL);
                    mapObj.put('BURECONENRTOTLIVINGEXPENSES', EENRSUM.BURECONENRTOTLIVINGEXPENSES);
                    mapObj.put('BURECONENRTOTCREDITCOMMITMENTS', EENRSUM.BURECONENRTOTCREDITCOMMITMENTS);
                    mapObj.put('BURECONENRSUMPPSALLMSO', EENRSUM.BURECONENRSUMPPSALLMSO);
                    mapObj.put('BURECONENRSUMPPSALLNUM0PARRL24M', EENRSUM.BURECONENRSUMPPSALLNUM0PARRL24M);
                    mapObj.put('BURECONENRSUMPPSALLTOTNOL3M', EENRSUM.BURECONENRSUMPPSALLTOTNOL3M);
                    mapObj.put('BURECONENRSUMPPSALLNUM0PARRL6M', EENRSUM.BURECONENRSUMPPSALLNUM0PARRL6M);
                    mapObj.put('BURECONENRSUMPPSALLNUM2PARRL6M', EENRSUM.BURECONENRSUMPPSALLNUM2PARRL6M);
                    mapObj.put('BURECONENRSUMPPSALLTOTCREDITLIMITOFREV', EENRSUM.BURECONENRSUMPPSALLTOTCREDITLIMITOFREV);
                    mapObj.put('BURECONENRSUMPPSALLNUM1PARRL3M', EENRSUM.BURECONENRSUMPPSALLNUM1PARRL3M);
                    mapObj.put('BURECONENRSUMPPSOTHMSOOP', EENRSUM.BURECONENRSUMPPSOTHMSOOP);
                    mapObj.put('BURECONENRSUMENQALLMSO', EENRSUM.BURECONENRSUMENQALLMSO);
                    mapObj.put('BURECONENRSUMPPSALLTOTNOL1Y', EENRSUM.BURECONENRSUMPPSALLTOTNOL1Y);
                    mapObj.put('BURECONENRSUMPPSALLTOTNOL2Y', EENRSUM.BURECONENRSUMPPSALLTOTNOL2Y);
                    mapObj.put('BURECONENRSUMPPSALLTOTNOL180D', EENRSUM.BURECONENRSUMPPSALLTOTNOL180D);
                    mapObj.put('BURECONENRSUMPPSALLWSTSTATUSL6MACCOPENED4TO12M', EENRSUM.BURECONENRSUMPPSALLWSTSTATUSL6MACCOPENED4TO12M);
                    mapObj.put('BURECONENRSUMPPSALLNUM3PARRL6M', EENRSUM.BURECONENRSUMPPSALLNUM3PARRL6M);
                    mapObj.put('BURECONENRSUMPPSALLNOOPREV', EENRSUM.BURECONENRSUMPPSALLNOOPREV);
                    mapObj.put('BURECONENRSUMPPSALLTOTOUTBAL', EENRSUM.BURECONENRSUMPPSALLTOTOUTBAL);
                }

                if(ESUMADVCPA != null){
                    mapObj.put('BURECONSUMADVCPATOTEVER', ESUMADVCPA.BURECONSUMADVCPATOTEVER);
                    mapObj.put('BURECONSUMADVCPATOTL180D', ESUMADVCPA.BURECONSUMADVCPATOTL180D);
                    mapObj.put('BURECONSUMADVCPATOTL1Y', ESUMADVCPA.BURECONSUMADVCPATOTL1Y);
                    mapObj.put('BURECONSUMADVCPATOTL2Y', ESUMADVCPA.BURECONSUMADVCPATOTL2Y);
                    mapObj.put('BURECONSUMADVCPATOTVAL', ESUMADVCPA.BURECONSUMADVCPATOTVAL);
                    mapObj.put('BURECONSUMADVCPAHIGHVAL', ESUMADVCPA.BURECONSUMADVCPAHIGHVAL);
                    mapObj.put('BURECONSUMADVCPAVALMRC', ESUMADVCPA.BURECONSUMADVCPAVALMRC);
                    mapObj.put('BURECONSUMADVCPAMSMR', ESUMADVCPA.BURECONSUMADVCPAMSMR);
                }

                if(ESUMADVNLR != null){
                    mapObj.put('BURECONSUMADVNLRTOTEVER', ESUMADVNLR.BURECONSUMADVNLRTOTEVER);
                    mapObj.put('BURECONSUMADVNLRTOTL180D', ESUMADVNLR.BURECONSUMADVNLRTOTL180D);
                    mapObj.put('BURECONSUMADVNLRTOTL1Y', ESUMADVNLR.BURECONSUMADVNLRTOTL1Y);
                    mapObj.put('BURECONSUMADVNLRTOTL2Y', ESUMADVNLR.BURECONSUMADVNLRTOTL2Y);
                    mapObj.put('BURECONSUMADVNLRTOTVAL', ESUMADVNLR.BURECONSUMADVNLRTOTVAL);
                    mapObj.put('BURECONSUMADVNLRHIGHVAL', ESUMADVNLR.BURECONSUMADVNLRHIGHVAL);
                    mapObj.put('BURECONSUMADVNLRVALMRC', ESUMADVNLR.BURECONSUMADVNLRVALMRC);
                    mapObj.put('BURECONSUMADVNLRMSMR', ESUMADVNLR.BURECONSUMADVNLRMSMR);
                }

                if(ESUMCOL != null){
                    mapObj.put('BURECONSUMCOLDATEMRC', ESUMCOL.BURECONSUMCOLDATEMRC);
                    mapObj.put('BURECONSUMCOLTOTEVER', ESUMCOL.BURECONSUMCOLTOTEVER);
                    mapObj.put('BURECONSUMCOLTOTL90D', ESUMCOL.BURECONSUMCOLTOTL90D);
                    mapObj.put('BURECONSUMCOLTOTL180D', ESUMCOL.BURECONSUMCOLTOTL180D);
                    mapObj.put('BURECONSUMCOLTOTL1Y', ESUMCOL.BURECONSUMCOLTOTL1Y);
                    mapObj.put('BURECONSUMCOLTOTL2Y', ESUMCOL.BURECONSUMCOLTOTL2Y);
                    mapObj.put('BURECONSUMCOLTOTCAPVAL', ESUMCOL.BURECONSUMCOLTOTCAPVAL);
                    mapObj.put('BURECONSUMCOLTOTAMTOPL12M', ESUMCOL.BURECONSUMCOLTOTAMTOPL12M);
                    mapObj.put('BURECONSUMCOLHIGHVAL', ESUMCOL.BURECONSUMCOLHIGHVAL);
                    mapObj.put('BURECONSUMCOLVALMRC', ESUMCOL.BURECONSUMCOLVALMRC);
                    mapObj.put('BURECONSUMCOLMSMR', ESUMCOL.BURECONSUMCOLMSMR);
                    mapObj.put('BURECONSUMCOLMTHHIGH', ESUMCOL.BURECONSUMCOLMTHHIGH);
                }

                if(ESUMENQCPAALL != null){
                    mapObj.put('BURECONSUMENQCPAALLTOTL90D', ESUMENQCPAALL.BURECONSUMENQCPAALLTOTL90D);
                    mapObj.put('BURECONSUMENQCPAALLTOTL180D', ESUMENQCPAALL.BURECONSUMENQCPAALLTOTL180D);
                    mapObj.put('BURECONSUMENQCPAALLMSO', ESUMENQCPAALL.BURECONSUMENQCPAALLMSO);
                    mapObj.put('BURECONSUMENQCPAALLTOTL1Y', ESUMENQCPAALL.BURECONSUMENQCPAALLTOTL1Y);
                }

                if(ESUMENQCPAOTH != null){
                    mapObj.put('BURECONSUMENQCPAOTHTOTEVER', ESUMENQCPAOTH.BURECONSUMENQCPAOTHTOTEVER);
                    mapObj.put('BURECONSUMENQCPAOTHTOTL30D', ESUMENQCPAOTH.BURECONSUMENQCPAOTHTOTL30D);
                    mapObj.put('BURECONSUMENQCPAOTHTOTL90D', ESUMENQCPAOTH.BURECONSUMENQCPAOTHTOTL90D);
                    mapObj.put('BURECONSUMENQCPAOTHTOTL180D', ESUMENQCPAOTH.BURECONSUMENQCPAOTHTOTL180D);
                    mapObj.put('BURECONSUMENQCPAOTHTOTL1Y', ESUMENQCPAOTH.BURECONSUMENQCPAOTHTOTL1Y);
                    mapObj.put('BURECONSUMENQCPAOTHMONTHMRC', ESUMENQCPAOTH.BURECONSUMENQCPAOTHMONTHMRC);
                }

                if(ESUMENQCPAOWN != null){
                    mapObj.put('BURECONSUMENQCPAOWNTOTEVER', ESUMENQCPAOWN.BURECONSUMENQCPAOWNTOTEVER);
                    mapObj.put('BURECONSUMENQCPAOWNTOTL30D', ESUMENQCPAOWN.BURECONSUMENQCPAOWNTOTL30D);
                    mapObj.put('BURECONSUMENQCPAOWNTOTL90D', ESUMENQCPAOWN.BURECONSUMENQCPAOWNTOTL90D);
                    mapObj.put('BURECONSUMENQCPAOWNTOTL180D', ESUMENQCPAOWN.BURECONSUMENQCPAOWNTOTL180D);
                    mapObj.put('BURECONSUMENQCPAOWNTOTL1Y', ESUMENQCPAOWN.BURECONSUMENQCPAOWNTOTL1Y);
                    mapObj.put('BURECONSUMENQCPAOWNMONTHMRC', ESUMENQCPAOWN.BURECONSUMENQCPAOWNMONTHMRC);
                }

                if(ESUMENQNLRALL != null){
                    mapObj.put('BURECONSUMENQNLRALLTOTL90D', ESUMENQNLRALL.BURECONSUMENQNLRALLTOTL90D);
                    mapObj.put('BURECONSUMENQNLRALLTOTL1Y', ESUMENQNLRALL.BURECONSUMENQNLRALLTOTL1Y);
                }

                if(ESUMENQNLROTH != null){
                    mapObj.put('BURECONSUMENQNLROTHTOTEVER', ESUMENQNLROTH.BURECONSUMENQNLROTHTOTEVER);
                    mapObj.put('BURECONSUMENQNLROTHTOTL30D', ESUMENQNLROTH.BURECONSUMENQNLROTHTOTL30D);
                    mapObj.put('BURECONSUMENQNLROTHTOTL90D', ESUMENQNLROTH.BURECONSUMENQNLROTHTOTL90D);
                    mapObj.put('BURECONSUMENQNLROTHTOTL180D', ESUMENQNLROTH.BURECONSUMENQNLROTHTOTL180D);
                    mapObj.put('BURECONSUMENQNLROTHTOTL1Y', ESUMENQNLROTH.BURECONSUMENQNLROTHTOTL1Y);
                    mapObj.put('BURECONSUMENQNLROTHMONTHMRC', ESUMENQNLROTH.BURECONSUMENQNLROTHMONTHMRC);
                }

                if(ESUMENQNLROWN != null){
                    mapObj.put('BURECONSUMENQNLROWNTOTEVER', ESUMENQNLROWN.BURECONSUMENQNLROWNTOTEVER);
                    mapObj.put('BURECONSUMENQNLROWNTOTL30D', ESUMENQNLROWN.BURECONSUMENQNLROWNTOTL30D);
                    mapObj.put('BURECONSUMENQNLROWNTOTL90D', ESUMENQNLROWN.BURECONSUMENQNLROWNTOTL90D);
                    mapObj.put('BURECONSUMENQNLROWNTOTL180D', ESUMENQNLROWN.BURECONSUMENQNLROWNTOTL180D);
                    mapObj.put('BURECONSUMENQNLROWNTOTL1Y', ESUMENQNLROWN.BURECONSUMENQNLROWNTOTL1Y);
                    mapObj.put('BURECONSUMENQNLROWNMONTHMRC', ESUMENQNLROWN.BURECONSUMENQNLROWNMONTHMRC);
                }

                if(ESUMJUD != null){
                    mapObj.put('BURECONSUMJUDTOTEVER', ESUMJUD.BURECONSUMJUDTOTEVER);
                    mapObj.put('BURECONSUMJUDTOTL90D', ESUMJUD.BURECONSUMJUDTOTL90D);
                    mapObj.put('BURECONSUMJUDTOTL180D', ESUMJUD.BURECONSUMJUDTOTL180D);
                    mapObj.put('BURECONSUMJUDTOTL1Y', ESUMJUD.BURECONSUMJUDTOTL1Y);
                    mapObj.put('BURECONSUMJUDTOTL2Y', ESUMJUD.BURECONSUMJUDTOTL2Y);
                    mapObj.put('BURECONSUMJUDTOTVAL', ESUMJUD.BURECONSUMJUDTOTVAL);
                    mapObj.put('BURECONSUMJUDHIGHVAL', ESUMJUD.BURECONSUMJUDHIGHVAL);
                    mapObj.put('BURECONSUMJUDVALMRC', ESUMJUD.BURECONSUMJUDVALMRC);
                    mapObj.put('BURECONSUMJUDMSMR', ESUMJUD.BURECONSUMJUDMSMR);
                    mapObj.put('BURECONSUMJUDMTHHIGH', ESUMJUD.BURECONSUMJUDMTHHIGH);
                    mapObj.put('BURECONSUMJUDDATEMRC', ESUMJUD.BURECONSUMJUDDATEMRC);
                }

                if(ESUMNEG != null){
                    mapObj.put('BURECONSUMNEGALLTOTEVER', ESUMNEG.BURECONSUMNEGALLTOTEVER);
                    mapObj.put('BURECONSUMNEGALLTOTL90D', ESUMNEG.BURECONSUMNEGALLTOTL90D);
                    mapObj.put('BURECONSUMNEGALLTOTL180D', ESUMNEG.BURECONSUMNEGALLTOTL180D);
                    mapObj.put('BURECONSUMNEGALLTOTL1Y', ESUMNEG.BURECONSUMNEGALLTOTL1Y);
                    mapObj.put('BURECONSUMNEGALLTOTL2Y', ESUMNEG.BURECONSUMNEGALLTOTL2Y);
                    mapObj.put('BURECONSUMNEGALLTOTL5Y', ESUMNEG.BURECONSUMNEGALLTOTL5Y);
                    mapObj.put('BURECONSUMNEGALLHIGHVAL', ESUMNEG.BURECONSUMNEGALLHIGHVAL);
                    mapObj.put('BURECONSUMNEGALLMTHHIGH', ESUMNEG.BURECONSUMNEGALLMTHHIGH);
                    mapObj.put('BURECONSUMNEGALLVALMRC', ESUMNEG.BURECONSUMNEGALLVALMRC);
                    mapObj.put('BURECONSUMNEGALLMSMR', ESUMNEG.BURECONSUMNEGALLMSMR);
                }

                if(ESUMNOT != null){
                    mapObj.put('BURECONSUMNOTMOSTRECDATE', ESUMNOT.BURECONSUMNOTMOSTRECDATE);
                    mapObj.put('BURECONSUMNOTMOSTRECAMT', ESUMNOT.BURECONSUMNOTMOSTRECAMT);
                    mapObj.put('BURECONSUMNOTNUMEVER', ESUMNOT.BURECONSUMNOTNUMEVER);
                    mapObj.put('BURECONSUMNOTNUML90D', ESUMNOT.BURECONSUMNOTNUML90D);
                    mapObj.put('BURECONSUMNOTNUML180D', ESUMNOT.BURECONSUMNOTNUML180D);
                    mapObj.put('BURECONSUMNOTNUML1Y', ESUMNOT.BURECONSUMNOTNUML1Y);
                    mapObj.put('BURECONSUMNOTNUML2Y', ESUMNOT.BURECONSUMNOTNUML2Y);
                }

                if(ESUMTRA != null){
                    mapObj.put('BURECONSUMTRATOTEVER', ESUMTRA.BURECONSUMTRATOTEVER);
                    mapObj.put('BURECONSUMTRATOT90D', ESUMTRA.BURECONSUMTRATOT90D);
                    mapObj.put('BURECONSUMTRATOTL180D', ESUMTRA.BURECONSUMTRATOTL180D);
                    mapObj.put('BURECONSUMTRATOTL1Y', ESUMTRA.BURECONSUMTRATOTL1Y);
                }

                if(ESUMPPCPAALL != null){
                    mapObj.put('BURECONSUMPPSCPAALLWSTARREVER', ESUMPPCPAALL.BURECONSUMPPSCPAALLWSTARREVER);
                    mapObj.put('BURECONSUMPPSCPAALLWSTARRL90D', ESUMPPCPAALL.BURECONSUMPPSCPAALLWSTARRL90D);
                    mapObj.put('BURECONSUMPPSCPAALLWSTARRL180D', ESUMPPCPAALL.BURECONSUMPPSCPAALLWSTARRL180D);
                    mapObj.put('BURECONSUMPPSCPAALLWSTARRL1Y', ESUMPPCPAALL.BURECONSUMPPSCPAALLWSTARRL1Y);
                    mapObj.put('BURECONSUMPPSCPAALLWSTARRCLEVER', ESUMPPCPAALL.BURECONSUMPPSCPAALLWSTARRCLEVER);
                    mapObj.put('BURECONSUMPPSCPAALLWSTARROPEVER', ESUMPPCPAALL.BURECONSUMPPSCPAALLWSTARROPEVER);
                    mapObj.put('BURECONSUMPPSCPAALLWSTARRLEVLMRCOPEN', ESUMPPCPAALL.BURECONSUMPPSCPAALLWSTARRLEVLMRCOPEN);
                    mapObj.put('BURECONSUMPPSCPAALLNUM3PARRL3M', ESUMPPCPAALL.BURECONSUMPPSCPAALLNUM3PARRL3M);
                    mapObj.put('BURECONSUMPPSCPAALLNUM3PARRL12M', ESUMPPCPAALL.BURECONSUMPPSCPAALLNUM3PARRL12M);
                    mapObj.put('BURECONSUMPPSCPAALLNUM3PARRL24M', ESUMPPCPAALL.BURECONSUMPPSCPAALLNUM3PARRL24M);
                    mapObj.put('BURECONSUMPPSCPAALLMSO', ESUMPPCPAALL.BURECONSUMPPSCPAALLMSO);
                    mapObj.put('BURECONSUMPPSCPAALLTOTNOL180D', ESUMPPCPAALL.BURECONSUMPPSCPAALLTOTNOL180D);
                    mapObj.put('BURECONSUMPPSCPAALLTOTNOL2Y', ESUMPPCPAALL.BURECONSUMPPSCPAALLTOTNOL2Y);
                    mapObj.put('BURECONSUMPPSCPAALLTOTNOL1Y', ESUMPPCPAALL.BURECONSUMPPSCPAALLTOTNOL1Y);
                    mapObj.put('BURECONSUMPPSCPAALLNOCURROP', ESUMPPCPAALL.BURECONSUMPPSCPAALLNOCURROP);
                    mapObj.put('BURECONSUMPPSCPAALLNUM0PARRL24M', ESUMPPCPAALL.BURECONSUMPPSCPAALLNUM0PARRL24M);
                    mapObj.put('BURECONSUMPPSCPAALLNUM1PARRL3M', ESUMPPCPAALL.BURECONSUMPPSCPAALLNUM1PARRL3M);
                    mapObj.put('BURECONSUMPPSCPAALLNUM2PARRL3M', ESUMPPCPAALL.BURECONSUMPPSCPAALLNUM2PARRL3M);
                    mapObj.put('BURECONSUMPPSCPAALLNUM2PARRL6M', ESUMPPCPAALL.BURECONSUMPPSCPAALLNUM2PARRL6M);
                    mapObj.put('BURECONSUMPPSCPAALLNUM3PARRL6M', ESUMPPCPAALL.BURECONSUMPPSCPAALLNUM3PARRL6M);
                    mapObj.put('BURECONSUMPPSCPAALLTOTCREDITLIMITOFREV', ESUMPPCPAALL.BURECONSUMPPSCPAALLTOTCREDITLIMITOFREV);
                    mapObj.put('BURECONSUMPPSCPAALLTOTMONTHLYINSTL', ESUMPPCPAALL.BURECONSUMPPSCPAALLTOTMONTHLYINSTL);
                    mapObj.put('BURECONSUMPPSCPAALLTOTOUTBAL', ESUMPPCPAALL.BURECONSUMPPSCPAALLTOTOUTBAL);
                    mapObj.put('BURECONSUMPPSCPAALLMNTHSMOSTRECOP', ESUMPPCPAALL.BURECONSUMPPSCPAALLMNTHSMOSTRECOP);
                }

                if(ESUMPPNLRALL != null){
                    mapObj.put('BURECONSUMPPSNLRALLWSTARREVER', ESUMPPNLRALL.BURECONSUMPPSNLRALLWSTARREVER);
                    mapObj.put('BURECONSUMPPSNLRALLWSTARRL90D', ESUMPPNLRALL.BURECONSUMPPSNLRALLWSTARRL90D);
                    mapObj.put('BURECONSUMPPSNLRALLWSTARRL180D', ESUMPPNLRALL.BURECONSUMPPSNLRALLWSTARRL180D);
                    mapObj.put('BURECONSUMPPSNLRALLWSTARRL1Y', ESUMPPNLRALL.BURECONSUMPPSNLRALLWSTARRL1Y);
                    mapObj.put('BURECONSUMPPSNLRALLWSTARRCLEVER', ESUMPPNLRALL.BURECONSUMPPSNLRALLWSTARRCLEVER);
                    mapObj.put('BURECONSUMPPSNLRALLWSTARROPEVER', ESUMPPNLRALL.BURECONSUMPPSNLRALLWSTARROPEVER);
                    mapObj.put('BURECONSUMPPSNLRALLWSTARRLEVLMRCOPEN', ESUMPPNLRALL.BURECONSUMPPSNLRALLWSTARRLEVLMRCOPEN);
                    mapObj.put('BURECONSUMPPSNLRALLNUM3PARRL3M', ESUMPPNLRALL.BURECONSUMPPSNLRALLNUM3PARRL3M);
                    mapObj.put('BURECONSUMPPSNLRALLNUM3PARRL12M', ESUMPPNLRALL.BURECONSUMPPSNLRALLNUM3PARRL12M);
                    mapObj.put('BURECONSUMPPSNLRALLNUM3PARRL24M', ESUMPPNLRALL.BURECONSUMPPSNLRALLNUM3PARRL24M);
                    mapObj.put('BURECONSUMPPSNLRALLTOTEVER', ESUMPPNLRALL.BURECONSUMPPSNLRALLTOTEVER);
                    mapObj.put('BURECONSUMPPSNLRALLMSO', ESUMPPNLRALL.BURECONSUMPPSNLRALLMSO);
                    mapObj.put('BURECONSUMPPSNLRALLNUM2PARRL24M', ESUMPPNLRALL.BURECONSUMPPSNLRALLNUM2PARRL24M);
                    mapObj.put('BURECONSUMPPSNLRALLNUM0PARRL3M', ESUMPPNLRALL.BURECONSUMPPSNLRALLNUM0PARRL3M);
                    mapObj.put('BURECONSUMPPSNLRALLNUM0PARRL6M', ESUMPPNLRALL.BURECONSUMPPSNLRALLNUM0PARRL6M);
                    mapObj.put('BURECONSUMPPSNLRALLNUM0PARRL12M', ESUMPPNLRALL.BURECONSUMPPSNLRALLNUM0PARRL12M);
                    mapObj.put('BURECONSUMPPSNLRALLNOALLL180D', ESUMPPNLRALL.BURECONSUMPPSNLRALLNOALLL180D);
                    mapObj.put('BURECONSUMPPSNLRALLL1Y', ESUMPPNLRALL.BURECONSUMPPSNLRALLL1Y);
                    mapObj.put('BURECONSUMPPSNLRALLNOCURROPEN', ESUMPPNLRALL.BURECONSUMPPSNLRALLNOCURROPEN);
                    mapObj.put('BURECONSUMPPSNLRALLTOTMONTHLYINSTL', ESUMPPNLRALL.BURECONSUMPPSNLRALLTOTMONTHLYINSTL);
                }

                if(TCONSRETURNDATA != null){
                    mapObj.put('BURTCONDETINFSURNAME', TCONSRETURNDATA.BURTCONDETINFSURNAME);
                    mapObj.put('BURTCONDETINFFNAME1', TCONSRETURNDATA.BURTCONDETINFFNAME1);
                    mapObj.put('BURTCONDETINFDOB', TCONSRETURNDATA.BURTCONDETINFDOB);
                    mapObj.put('BURTCONDETINFID1', TCONSRETURNDATA.BURTCONDETINFID1);
                    mapObj.put('BURTCONDETIDVDECEASEIND', TCONSRETURNDATA.BURTCONDETIDVDECEASEIND);
                    mapObj.put('BURTCONDETDBTREVEWIND', TCONSRETURNDATA.BURTCONDETDBTREVEWIND);
                    mapObj.put('BURTCONDETDSPDISPUTEIND', TCONSRETURNDATA.BURTCONDETDSPDISPUTEIND);
                    mapObj.put('BURTCONDETIDVIDVERIFIEDIND', TCONSRETURNDATA.BURTCONDETIDVIDVERIFIEDIND);
                }

                if(TSUMAGG != null){
                    mapObj.put('BURTCONSUMNBTOTNUM', TSUMAGG.BURTCONSUMNBTOTNUM);
                    mapObj.put('BURTCONSUMNBTOTVAL', TSUMAGG.BURTCONSUMNBTOTVAL);
                    mapObj.put('BURTCONSUMNBDATEMREC', TSUMAGG.BURTCONSUMNBDATEMREC);
                    mapObj.put('BURTCONSUMNOTMRECAMT', TSUMAGG.BURTCONSUMNOTMRECAMT);
                    mapObj.put('BURTCONSUMNOTNUMREHABTYPE', TSUMAGG.BURTCONSUMNOTNUMREHABTYPE);
                    mapObj.put('BURTCONSUMNOTNUMADMORDTYPE', TSUMAGG.BURTCONSUMNOTNUMADMORDTYPE);
                    mapObj.put('BURTCONSUMNOTNUMADMORDABANDTYPE', TSUMAGG.BURTCONSUMNOTNUMADMORDABANDTYPE);
                    mapObj.put('BURTCONSUMNOTNUMINTENTSURRENDTYPE', TSUMAGG.BURTCONSUMNOTNUMINTENTSURRENDTYPE);
                    mapObj.put('BURTCONSUMNOTNUMFINALSEQUESTRTYPE', TSUMAGG.BURTCONSUMNOTNUMFINALSEQUESTRTYPE);
                    mapObj.put('BURTCONSUMNOTNUMPROVISIONALSEQUESTRTYPE', TSUMAGG.BURTCONSUMNOTNUMPROVISIONALSEQUESTRTYPE);
                    mapObj.put('BURTCONSUMNOTTOTEVER', TSUMAGG.BURTCONSUMNOTTOTEVER);
                    mapObj.put('BURTCONSUMJUDTOTEVER', TSUMAGG.BURTCONSUMJUDTOTEVER);
                    mapObj.put('BURTCONSUMJUDTOTL90D', TSUMAGG.BURTCONSUMJUDTOTL90D);
                    mapObj.put('BURTCONSUMJUDTOTL180D', TSUMAGG.BURTCONSUMJUDTOTL180D);
                    mapObj.put('BURTCONSUMJUDTOTL1Y', TSUMAGG.BURTCONSUMJUDTOTL1Y);
                    mapObj.put('BURTCONSUMJUDTOTL2Y', TSUMAGG.BURTCONSUMJUDTOTL2Y);
                    mapObj.put('BURTCONSUMJUDTOTL3Y', TSUMAGG.BURTCONSUMJUDTOTL3Y);
                    mapObj.put('BURTCONSUMJUDTOTL4Y', TSUMAGG.BURTCONSUMJUDTOTL4Y);
                    mapObj.put('BURTCONSUMJUDTOTL5Y', TSUMAGG.BURTCONSUMJUDTOTL5Y);
                    mapObj.put('BURTCONSUMJUDTOTVAL', TSUMAGG.BURTCONSUMJUDTOTVAL);
                    mapObj.put('BURTCONSUMJUDHIGHESTVAL', TSUMAGG.BURTCONSUMJUDHIGHESTVAL);
                    mapObj.put('BURTCONSUMJUDDATEHIGHEST', TSUMAGG.BURTCONSUMJUDDATEHIGHEST);
                    mapObj.put('BURTCONSUMJUDVALMREC', TSUMAGG.BURTCONSUMJUDVALMREC);
                    mapObj.put('BURTCONSUMJUDMNTHSMREC', TSUMAGG.BURTCONSUMJUDMNTHSMREC);
                    mapObj.put('BURTCONSUMJUDMNTHSHIGHEST', TSUMAGG.BURTCONSUMJUDMNTHSHIGHEST);
                    mapObj.put('BURTCONSUMJUDDATEMREC', TSUMAGG.BURTCONSUMJUDDATEMREC);
                    mapObj.put('BURTCONSUMENQCPAALLTOTEVER', TSUMAGG.BURTCONSUMENQCPAALLTOTEVER);
                    mapObj.put('BURTCONSUMENQCPAALLL90D', TSUMAGG.BURTCONSUMENQCPAALLL90D);
                    mapObj.put('BURTCONSUMENQCPAALLL180D', TSUMAGG.BURTCONSUMENQCPAALLL180D);
                    mapObj.put('BURTCONSUMENQCPAALLL1Y', TSUMAGG.BURTCONSUMENQCPAALLL1Y);
                    mapObj.put('BURTCONSUMENQCPAALLL2Y', TSUMAGG.BURTCONSUMENQCPAALLL2Y);
                    mapObj.put('BURTCONSUMENQNLRALLTOTEVER', TSUMAGG.BURTCONSUMENQNLRALLTOTEVER);
                    mapObj.put('BURTCONSUMENQNLRALLL90D', TSUMAGG.BURTCONSUMENQNLRALLL90D);
                    mapObj.put('BURTCONSUMENQNLRALLL180D', TSUMAGG.BURTCONSUMENQNLRALLL180D);
                    mapObj.put('BURTCONSUMENQNLRALLL1Y', TSUMAGG.BURTCONSUMENQNLRALLL1Y);
                    mapObj.put('BURTCONSUMENQNLRALLL2Y', TSUMAGG.BURTCONSUMENQNLRALLL2Y);
                    mapObj.put('BURTCONSUMNEGTOTEVER', TSUMAGG.BURTCONSUMNEGTOTEVER);
                    mapObj.put('BURTCONSUMNEGTOTL90D', TSUMAGG.BURTCONSUMNEGTOTL90D);
                    mapObj.put('BURTCONSUMNEGTOTL180D', TSUMAGG.BURTCONSUMNEGTOTL180D);
                    mapObj.put('BURTCONSUMNEGTOTL1Y', TSUMAGG.BURTCONSUMNEGTOTL1Y);
                    mapObj.put('BURTCONSUMNEGTOTL2Y', TSUMAGG.BURTCONSUMNEGTOTL2Y);
                    mapObj.put('BURTCONSUMNEGTOTL5Y', TSUMAGG.BURTCONSUMNEGTOTL5Y);
                    mapObj.put('BURTCONSUMNEGDATEMREC', TSUMAGG.BURTCONSUMNEGDATEMREC);
                    mapObj.put('BURTCONSUMNEGDATEHIGHEST', TSUMAGG.BURTCONSUMNEGDATEHIGHEST);
                    mapObj.put('BURTCONSUMNEGTOTVAL', TSUMAGG.BURTCONSUMNEGTOTVAL);
                    mapObj.put('BURTCONSUMNEGHIGHESTVAL', TSUMAGG.BURTCONSUMNEGHIGHESTVAL);
                    mapObj.put('BURTCONSUMNEGMNTHSHIGHEST', TSUMAGG.BURTCONSUMNEGMNTHSHIGHEST);
                    mapObj.put('BURTCONSUMNEGVALMREC', TSUMAGG.BURTCONSUMNEGVALMREC);
                    mapObj.put('BURTCONSUMNEGMNTHSMREC', TSUMAGG.BURTCONSUMNEGMNTHSMREC);
                    mapObj.put('BURTCONSUMNEGDAYSMREC', TSUMAGG.BURTCONSUMNEGDAYSMREC);
                    mapObj.put('BURTCONSUMTRATOTEVER', TSUMAGG.BURTCONSUMTRATOTEVER);
                    mapObj.put('BURTCONSUMTRATOTL90D', TSUMAGG.BURTCONSUMTRATOTL90D);
                    mapObj.put('BURTCONSUMTRATOTL180D', TSUMAGG.BURTCONSUMTRATOTL180D);
                    mapObj.put('BURTCONSUMTRAALLL1Y', TSUMAGG.BURTCONSUMTRAALLL1Y);
                    mapObj.put('BURTCONSUMTRAALLL2Y', TSUMAGG.BURTCONSUMTRAALLL2Y);
                    mapObj.put('BURTCONSUMADVTOTEVER', TSUMAGG.BURTCONSUMADVTOTEVER);
                    mapObj.put('BURTCONSUMADVTOTVAL', TSUMAGG.BURTCONSUMADVTOTVAL);
                    mapObj.put('BURTCONSUMADVDATEHIGHEST', TSUMAGG.BURTCONSUMADVDATEHIGHEST);
                    mapObj.put('BURTCONSUMADVMNTHSHIGHEST', TSUMAGG.BURTCONSUMADVMNTHSHIGHEST);
                    mapObj.put('BURTCONSUMADVDATEMREC', TSUMAGG.BURTCONSUMADVDATEMREC);
                    mapObj.put('BURTCONSUMADVMNTHSMREC', TSUMAGG.BURTCONSUMADVMNTHSMREC);
                    mapObj.put('BURTCONSUMADVALLL1Y', TSUMAGG.BURTCONSUMADVALLL1Y);
                    mapObj.put('BURTCONSUMADVALLL2Y', TSUMAGG.BURTCONSUMADVALLL2Y);
                    mapObj.put('BURTCONSUMADVVALMREC', TSUMAGG.BURTCONSUMADVVALMREC);
                    mapObj.put('BURTCONSUMADVHIGHESTVAL', TSUMAGG.BURTCONSUMADVHIGHESTVAL);
                    mapObj.put('BURTCONSUMPPSCPAOWNCURBALACTIVE', TSUMAGG.BURTCONSUMPPSCPAOWNCURBALACTIVE);
                    mapObj.put('BURTCONSUMPPSCPAOWNVALINSTAL', TSUMAGG.BURTCONSUMPPSCPAOWNVALINSTAL);
                    mapObj.put('BURTCONSUMPPSCPAOWNNUMMRECSTATUSWROFF', TSUMAGG.BURTCONSUMPPSCPAOWNNUMMRECSTATUSWROFF);
                    mapObj.put('BURTCONSUMPPSCPAOTHCURBALACTIVE', TSUMAGG.BURTCONSUMPPSCPAOTHCURBALACTIVE);
                    mapObj.put('BURTCONSUMPPSCPAOTHVALINSTAL', TSUMAGG.BURTCONSUMPPSCPAOTHVALINSTAL);
                    mapObj.put('BURTCONSUMPPSCPAOTHNUMMRECSTATUSWROFF', TSUMAGG.BURTCONSUMPPSCPAOTHNUMMRECSTATUSWROFF);
                    mapObj.put('BURTCONSUMPPSCPAOTHWSTARRSTATUSL30D', TSUMAGG.BURTCONSUMPPSCPAOTHWSTARRSTATUSL30D);
                    mapObj.put('BURTCONSUMPPSCPAALLNUMEVER', TSUMAGG.BURTCONSUMPPSCPAALLNUMEVER);
                    mapObj.put('BURTCONSUMPPSCPAALLCURROPEN', TSUMAGG.BURTCONSUMPPSCPAALLCURROPEN);
                    mapObj.put('BURTCONSUMPPSCPAALLCURBALACTIVE', TSUMAGG.BURTCONSUMPPSCPAALLCURBALACTIVE);
                    mapObj.put('BURTCONSUMPPSCPAALLNUMOPL180D', TSUMAGG.BURTCONSUMPPSCPAALLNUMOPL180D);
                    mapObj.put('BURTCONSUMPPSCPAALLNUMOPL1Y', TSUMAGG.BURTCONSUMPPSCPAALLNUMOPL1Y);
                    mapObj.put('BURTCONSUMPPSCPAALLVALINSTAL', TSUMAGG.BURTCONSUMPPSCPAALLVALINSTAL);
                    mapObj.put('BURTCONSUMPPSCPAALLMNTHSSINCEMRECARRWRS', TSUMAGG.BURTCONSUMPPSCPAALLMNTHSSINCEMRECARRWRS);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARREVER', TSUMAGG.BURTCONSUMPPSCPAALLWSTARREVER);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARROPEVER', TSUMAGG.BURTCONSUMPPSCPAALLWSTARROPEVER);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRCLSDEVER', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRCLSDEVER);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRLEVLMRECOP', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRLEVLMRECOP);
                    mapObj.put('BURTCONSUMPPSCPAALLNUMPAYMNTTYPEUNDERADMINISTR', TSUMAGG.BURTCONSUMPPSCPAALLNUMPAYMNTTYPEUNDERADMINISTR);
                    mapObj.put('BURTCONSUMPPSCPAALLNUMPAYMNTTYPEJUDGRANTED', TSUMAGG.BURTCONSUMPPSCPAALLNUMPAYMNTTYPEJUDGRANTED);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTSTATUSACTVACCL180D', TSUMAGG.BURTCONSUMPPSCPAALLWSTSTATUSACTVACCL180D);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTSTATUSACTVACCL1Y', TSUMAGG.BURTCONSUMPPSCPAALLWSTSTATUSACTVACCL1Y);
                    mapObj.put('BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEW', TSUMAGG.BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEW);
                    mapObj.put('BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEI', TSUMAGG.BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEI);
                    mapObj.put('BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEJ', TSUMAGG.BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEJ);
                    mapObj.put('BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEL', TSUMAGG.BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEL);
                    mapObj.put('BURTCONSUMPPSCPAALLTOTVALCURBALACTVARR3MP', TSUMAGG.BURTCONSUMPPSCPAALLTOTVALCURBALACTVARR3MP);
                    mapObj.put('BURTCONSUMPPSCPAALLTOTVALCURBALACTVARR6MP', TSUMAGG.BURTCONSUMPPSCPAALLTOTVALCURBALACTVARR6MP);
                    mapObj.put('BURTCONSUMPPSCPAALLTOTVALCURBALACTVARR9MP', TSUMAGG.BURTCONSUMPPSCPAALLTOTVALCURBALACTVARR9MP);
                    mapObj.put('BURTCONSUMPPSCPAALLSTATUSMRECOP', TSUMAGG.BURTCONSUMPPSCPAALLSTATUSMRECOP);
                    mapObj.put('BURTCONSUMPPSCPAALLNUMMRECSTATUSC', TSUMAGG.BURTCONSUMPPSCPAALLNUMMRECSTATUSC);
                    mapObj.put('BURTCONSUMPPSCPAALLMNTHSMRECOP', TSUMAGG.BURTCONSUMPPSCPAALLMNTHSMRECOP);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTSTATUSACTVL90D', TSUMAGG.BURTCONSUMPPSCPAALLWSTSTATUSACTVL90D);
                    mapObj.put('BURTCONSUMPPSCPAALLPERC3PARRL2Y', TSUMAGG.BURTCONSUMPPSCPAALLPERC3PARRL2Y);
                    mapObj.put('BURTCONSUMPPSCPAALLNOTIMES3SARRL2Y', TSUMAGG.BURTCONSUMPPSCPAALLNOTIMES3SARRL2Y);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRLVLL90D', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRLVLL90D);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRLVLL180D', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRLVLL180D);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRLVLL1Y', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRLVLL1Y);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRLVLL30D', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRLVLL30D);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRLVLL60D', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRLVLL60D);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRLVLL120D', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRLVLL120D);
                    mapObj.put('BURTCONSUMPPSCPAALLWSTARRLVLL2Y', TSUMAGG.BURTCONSUMPPSCPAALLWSTARRLVLL2Y);
                    mapObj.put('BURTCONSUMPPSNLROWNCURBALACTIVE', TSUMAGG.BURTCONSUMPPSNLROWNCURBALACTIVE);
                    mapObj.put('BURTCONSUMPPSNLROWNVALINSTAL', TSUMAGG.BURTCONSUMPPSNLROWNVALINSTAL);
                    mapObj.put('BURTCONSUMPPSNLROWNNUMPPSMRECSTATUSWROFF', TSUMAGG.BURTCONSUMPPSNLROWNNUMPPSMRECSTATUSWROFF);
                    mapObj.put('BURTCONSUMPPSNLROTHCURBALACTIVE', TSUMAGG.BURTCONSUMPPSNLROTHCURBALACTIVE);
                    mapObj.put('BURTCONSUMPPSNLROTHVALINSTAL', TSUMAGG.BURTCONSUMPPSNLROTHVALINSTAL);
                    mapObj.put('BURTCONSUMPPSNLROTHNOTIMES2PARRL2Y', TSUMAGG.BURTCONSUMPPSNLROTHNOTIMES2PARRL2Y);
                    mapObj.put('BURTCONSUMPPSNLROTHNUMMRECSTATUSWROFF', TSUMAGG.BURTCONSUMPPSNLROTHNUMMRECSTATUSWROFF);
                    mapObj.put('BURTCONSUMPPSNLROTHWSTARRLVLL180D', TSUMAGG.BURTCONSUMPPSNLROTHWSTARRLVLL180D);
                    mapObj.put('BURTCONSUMPPSNLRALLNUMEVER', TSUMAGG.BURTCONSUMPPSNLRALLNUMEVER);
                    mapObj.put('BURTCONSUMPPSNLRALLCURBALACTIVE', TSUMAGG.BURTCONSUMPPSNLRALLCURBALACTIVE);
                    mapObj.put('BURTCONSUMPPSNLRALLNUMOPL180D', TSUMAGG.BURTCONSUMPPSNLRALLNUMOPL180D);
                    mapObj.put('BURTCONSUMPPSNLRALLNUMOPL1Y', TSUMAGG.BURTCONSUMPPSNLRALLNUMOPL1Y);
                    mapObj.put('BURTCONSUMPPSNLRALLVALINSTAL', TSUMAGG.BURTCONSUMPPSNLRALLVALINSTAL);
                    mapObj.put('BURTCONSUMPPSNLRALLMNTHSMRECARRWRS', TSUMAGG.BURTCONSUMPPSNLRALLMNTHSMRECARRWRS);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARREVER', TSUMAGG.BURTCONSUMPPSNLRALLWSTARREVER);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARROPEVER', TSUMAGG.BURTCONSUMPPSNLRALLWSTARROPEVER);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRCLSDEVER', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRCLSDEVER);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRLVLMRCOP', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRLVLMRCOP);
                    mapObj.put('BURTCONSUMPPSNLRALLNUMPAYMNTTYPEUNDERADMINISTR', TSUMAGG.BURTCONSUMPPSNLRALLNUMPAYMNTTYPEUNDERADMINISTR);
                    mapObj.put('BURTCONSUMPPSNLRALLNUMPAYMNTTYPEJUDGRANTED', TSUMAGG.BURTCONSUMPPSNLRALLNUMPAYMNTTYPEJUDGRANTED);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTSTATUSACTVACCL180D', TSUMAGG.BURTCONSUMPPSNLRALLWSTSTATUSACTVACCL180D);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTSTATUSACTVACCL1Y', TSUMAGG.BURTCONSUMPPSNLRALLWSTSTATUSACTVACCL1Y);
                    mapObj.put('BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEW', TSUMAGG.BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEW);
                    mapObj.put('BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEI', TSUMAGG.BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEI);
                    mapObj.put('BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEJ', TSUMAGG.BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEJ);
                    mapObj.put('BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEL', TSUMAGG.BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEL);
                    mapObj.put('BURTCONSUMPPSNLRALLTOTVALCURBALACTVARR3MP', TSUMAGG.BURTCONSUMPPSNLRALLTOTVALCURBALACTVARR3MP);
                    mapObj.put('BURTCONSUMPPSNLRALLTOTVALCURBALACTVARR6MP', TSUMAGG.BURTCONSUMPPSNLRALLTOTVALCURBALACTVARR6MP);
                    mapObj.put('BURTCONSUMPPSNLRALLTOTVALCURBALACTVARR9MP', TSUMAGG.BURTCONSUMPPSNLRALLTOTVALCURBALACTVARR9MP);
                    mapObj.put('BURTCONSUMPPSNLRALLSTATUSMRECOP', TSUMAGG.BURTCONSUMPPSNLRALLSTATUSMRECOP);
                    mapObj.put('BURTCONSUMPPSNLRALLNUMMRECSTATUSC', TSUMAGG.BURTCONSUMPPSNLRALLNUMMRECSTATUSC);
                    mapObj.put('BURTCONSUMPPSNLRALLMNTHSMRECOP', TSUMAGG.BURTCONSUMPPSNLRALLMNTHSMRECOP);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTSTATUSACTVL90D', TSUMAGG.BURTCONSUMPPSNLRALLWSTSTATUSACTVL90D);
                    mapObj.put('BURTCONSUMPPSNLRALLPERC3PARRL2Y', TSUMAGG.BURTCONSUMPPSNLRALLPERC3PARRL2Y);
                    mapObj.put('BURTCONSUMPPSNLRALLNOTIMES3PARRL2Y', TSUMAGG.BURTCONSUMPPSNLRALLNOTIMES3PARRL2Y);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRLVLL90D', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRLVLL90D);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRLVLL180D', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRLVLL180D);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRLVLL1Y', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRLVLL1Y);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRSTATUSL30D', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRSTATUSL30D);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRSTATUSL60D', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRSTATUSL60D);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRSTATUSL120D', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRSTATUSL120D);
                    mapObj.put('BURTCONSUMPPSNLRALLWSTARRSTATUSL2Y', TSUMAGG.BURTCONSUMPPSNLRALLWSTARRSTATUSL2Y);
                    mapObj.put('BURTCONSUMENQCPAL30D', TSUMAGG.BURTCONSUMENQCPAL30D);
                    mapObj.put('BURTCONSUMENQCPADSMR', TSUMAGG.BURTCONSUMENQCPADSMR);
                    mapObj.put('BURTCONSUMENQCPAMSMR', TSUMAGG.BURTCONSUMENQCPAMSMR);
                    mapObj.put('BURTCONSUMENQCPAMSO', TSUMAGG.BURTCONSUMENQCPAMSO);
                    mapObj.put('BURTCONSUMENQCPADATEMOSTREC', TSUMAGG.BURTCONSUMENQCPADATEMOSTREC);
                    mapObj.put('BURTCONSUMENQNLRL7D', TSUMAGG.BURTCONSUMENQNLRL7D);
                    mapObj.put('BURTCONSUMENQNLRL30D', TSUMAGG.BURTCONSUMENQNLRL30D);
                    mapObj.put('BURTCONSUMENQNLRDSMR', TSUMAGG.BURTCONSUMENQNLRDSMR);
                    mapObj.put('BURTCONSUMENQNLRMSMR', TSUMAGG.BURTCONSUMENQNLRMSMR);
                    mapObj.put('BURTCONSUMENQNLRMSO', TSUMAGG.BURTCONSUMENQNLRMSO);
                    mapObj.put('BURTCONSUMENQNLRDATEMOSTREC', TSUMAGG.BURTCONSUMENQNLRDATEMOSTREC);
                    mapObj.put('BURTCONSUMADVTOTCURR1Y', TSUMAGG.BURTCONSUMADVTOTCURR1Y);
                    mapObj.put('BURTCONSUMADVTOTEXCLCURRYEAR', TSUMAGG.BURTCONSUMADVTOTEXCLCURRYEAR);
                    mapObj.put('BURTCONSUMADVTOTL30D', TSUMAGG.BURTCONSUMADVTOTL30D);
                    mapObj.put('BURTCONSUMADVTOTL90D', TSUMAGG.BURTCONSUMADVTOTL90D);
                    mapObj.put('BURTCONSUMADVTOTL180D', TSUMAGG.BURTCONSUMADVTOTL180D);
                    mapObj.put('BURTCONSUMADVTOTPREV6M', TSUMAGG.BURTCONSUMADVTOTPREV6M);
                    mapObj.put('BURTCONSUMADVTOT6TO18M', TSUMAGG.BURTCONSUMADVTOT6TO18M);
                    mapObj.put('BURTCONSUMADVTOT18TO24M', TSUMAGG.BURTCONSUMADVTOT18TO24M);
                    mapObj.put('BURTCONSUMJUDTOTCURR1Y', TSUMAGG.BURTCONSUMJUDTOTCURR1Y);
                    mapObj.put('BURTCONSUMJUDTOTEXCLCURRYEAR', TSUMAGG.BURTCONSUMJUDTOTEXCLCURRYEAR);
                    mapObj.put('BURTCONSUMJUDTOTL30D', TSUMAGG.BURTCONSUMJUDTOTL30D);
                    mapObj.put('BURTCONSUMJUDTOTPREV6M', TSUMAGG.BURTCONSUMJUDTOTPREV6M);
                    mapObj.put('BURTCONSUMJUDTOT6TO18M', TSUMAGG.BURTCONSUMJUDTOT6TO18M);
                    mapObj.put('BURTCONSUMJUDTOT18TO24M', TSUMAGG.BURTCONSUMJUDTOT18TO24M);
                    mapObj.put('BURTCONSUMJUDTOT18TO36M', TSUMAGG.BURTCONSUMJUDTOT18TO36M);
                    mapObj.put('BURTCONSUMJUDTOT24TO36M', TSUMAGG.BURTCONSUMJUDTOT24TO36M);
                    mapObj.put('BURTCONSUMJUDTOTGT36M', TSUMAGG.BURTCONSUMJUDTOTGT36M);
                    mapObj.put('BURTCONSUMNOTTOTDSMR', TSUMAGG.BURTCONSUMNOTTOTDSMR);
                    mapObj.put('BURTCONSUMNOTTOT30D', TSUMAGG.BURTCONSUMNOTTOT30D);
                    mapObj.put('BURTCONSUMNOTTOT90D', TSUMAGG.BURTCONSUMNOTTOT90D);
                    mapObj.put('BURTCONSUMNOTTOT180D', TSUMAGG.BURTCONSUMNOTTOT180D);
                    mapObj.put('BURTCONSUMNOTTOTL1Y', TSUMAGG.BURTCONSUMNOTTOTL1Y);
                    mapObj.put('BURTCONSUMNOTTOTL2Y', TSUMAGG.BURTCONSUMNOTTOTL2Y);
                    mapObj.put('BURTCONSUMNOTTOTL3Y', TSUMAGG.BURTCONSUMNOTTOTL3Y);
                    mapObj.put('BURTCONSUMNOTTOTL4Y', TSUMAGG.BURTCONSUMNOTTOTL4Y);
                    mapObj.put('BURTCONSUMNOTTOTL5Y', TSUMAGG.BURTCONSUMNOTTOTL5Y);
                    mapObj.put('BURTCONSUMTRATOTL30D', TSUMAGG.BURTCONSUMTRATOTL30D);
                    mapObj.put('BURTCONSUMTRATOTL60D', TSUMAGG.BURTCONSUMTRATOTL60D);
                    mapObj.put('BURTCONSUMPPSCPADATEMRPP', TSUMAGG.BURTCONSUMPPSCPADATEMRPP);
                    mapObj.put('BURTCONSUMPPSTOTREVACC', TSUMAGG.BURTCONSUMPPSTOTREVACC);
                    mapObj.put('BURTCONSUMPPSTOTREVACCOWN', TSUMAGG.BURTCONSUMPPSTOTREVACCOWN);
                    mapObj.put('BURTCONSUMPPSTOTREVACCOTH', TSUMAGG.BURTCONSUMPPSTOTREVACCOTH);
                    mapObj.put('BURTCONSUMPPSTOTINSTLACCALL', TSUMAGG.BURTCONSUMPPSTOTINSTLACCALL);
                    mapObj.put('BURTCONSUMPPSTOTINSTLACCACTV', TSUMAGG.BURTCONSUMPPSTOTINSTLACCACTV);
                    mapObj.put('BURTCONSUMPPSTOTOPACCALL', TSUMAGG.BURTCONSUMPPSTOTOPACCALL);
                    mapObj.put('BURTCONSUMPPSTOTOPACCACTV', TSUMAGG.BURTCONSUMPPSTOTOPACCACTV);
                    mapObj.put('BURTCONSUMPPSJOINTLOANALL', TSUMAGG.BURTCONSUMPPSJOINTLOANALL);
                    mapObj.put('BURTCONSUMPPSJOINTLOANOWN', TSUMAGG.BURTCONSUMPPSJOINTLOANOWN);
                    mapObj.put('BURTCONSUMPPSJOINTLOANOTH', TSUMAGG.BURTCONSUMPPSJOINTLOANOTH);
                    mapObj.put('BURTCONSUMPPSNLRTOTACTACC', TSUMAGG.BURTCONSUMPPSNLRTOTACTACC);
                    mapObj.put('BURTCONSUMPPSNLRTOTOPL30D', TSUMAGG.BURTCONSUMPPSNLRTOTOPL30D);
                    mapObj.put('BURTCONSUMPPSNLRTOTOPL60D', TSUMAGG.BURTCONSUMPPSNLRTOTOPL60D);
                    mapObj.put('BURTCONSUMPPSNLRTOTOPL90D', TSUMAGG.BURTCONSUMPPSNLRTOTOPL90D);
                    mapObj.put('BURTCONSUMPPSNLRDATEMRPP', TSUMAGG.BURTCONSUMPPSNLRDATEMRPP);
                    mapObj.put('BURTCONSUMPPSTOTNOACTVREVACC', TSUMAGG.BURTCONSUMPPSTOTNOACTVREVACC);
                    mapObj.put('BURTCONSUMPPSTOTBALACTVREVACC', TSUMAGG.BURTCONSUMPPSTOTBALACTVREVACC);
                }

                if(TSUMBCC != null){
                    mapObj.put('BURTCONSUMTRDNUMAL', TSUMBCC.BURTCONSUMTRDNUMAL);
                    mapObj.put('BURTCONSUMTRDNUMCC', TSUMBCC.BURTCONSUMTRDNUMCC);
                    mapObj.put('BURTCONSUMTRDNUMSL', TSUMBCC.BURTCONSUMTRDNUMSL);
                    mapObj.put('BURTCONSUMTRDNUMACTVAL', TSUMBCC.BURTCONSUMTRDNUMACTVAL);
                    mapObj.put('BURTCONSUMTRDNUMACTVLN', TSUMBCC.BURTCONSUMTRDNUMACTVLN);
                    mapObj.put('BURTCONSUMTRDNUMOPASAT3MAGO', TSUMBCC.BURTCONSUMTRDNUMOPASAT3MAGO);
                    mapObj.put('BURTCONSUMTRDNUMOPASAT6MAGO', TSUMBCC.BURTCONSUMTRDNUMOPASAT6MAGO);
                    mapObj.put('BURTCONSUMTRDNUMOPASAT12MAGO', TSUMBCC.BURTCONSUMTRDNUMOPASAT12MAGO);
                    mapObj.put('BURTCONSUMTRDNUMOPASAT18MAGO', TSUMBCC.BURTCONSUMTRDNUMOPASAT18MAGO);
                    mapObj.put('BURTCONSUMTRDNUMOPL12M', TSUMBCC.BURTCONSUMTRDNUMOPL12M);
                    mapObj.put('BURTCONSUMTRDNUMOPL18M', TSUMBCC.BURTCONSUMTRDNUMOPL18M);
                    mapObj.put('BURTCONSUMTRDNUMOPL24MLB', TSUMBCC.BURTCONSUMTRDNUMOPL24MLB);
                    mapObj.put('BURTCONSUMTRDNUMOPL24MLN', TSUMBCC.BURTCONSUMTRDNUMOPL24MLN);
                    mapObj.put('BURTCONSUMTRDNUMOPL24MAL', TSUMBCC.BURTCONSUMTRDNUMOPL24MAL);
                    mapObj.put('BURTCONSUMTRDNUMOPUTILIZED75PERC', TSUMBCC.BURTCONSUMTRDNUMOPUTILIZED75PERC);
                    mapObj.put('BURTCONSUMTRDNUMOPUTILIZED100PERC', TSUMBCC.BURTCONSUMTRDNUMOPUTILIZED100PERC);
                    mapObj.put('BURTCONSUMTRDNUM2MPASTDUE', TSUMBCC.BURTCONSUMTRDNUM2MPASTDUE);
                    mapObj.put('BURTCONSUMTRDNUM1MPASTDUE', TSUMBCC.BURTCONSUMTRDNUM1MPASTDUE);
                    mapObj.put('BURTCONSUMTRDNUM3MPASTDUEAL', TSUMBCC.BURTCONSUMTRDNUM3MPASTDUEAL);
                    mapObj.put('BURTCONSUMTRDNUM3MPASTDUEVF', TSUMBCC.BURTCONSUMTRDNUM3MPASTDUEVF);
                    mapObj.put('BURTCONSUMTRDNUM5MPASTDUE', TSUMBCC.BURTCONSUMTRDNUM5MPASTDUE);
                    mapObj.put('BURTCONSUMTRDNUMATMOST1MARRL3M', TSUMBCC.BURTCONSUMTRDNUMATMOST1MARRL3M);
                    mapObj.put('BURTCONSUMTRDNUMATMOST4MARRL3M', TSUMBCC.BURTCONSUMTRDNUMATMOST4MARRL3M);
                    mapObj.put('BURTCONSUMTRDNUMATMOST5MPARRL3MAL', TSUMBCC.BURTCONSUMTRDNUMATMOST5MPARRL3MAL);
                    mapObj.put('BURTCONSUMTRDNUMATMOST5MPARRL3MCL', TSUMBCC.BURTCONSUMTRDNUMATMOST5MPARRL3MCL);
                    mapObj.put('BURTCONSUMTRDNUMATMOST1MARRL6M', TSUMBCC.BURTCONSUMTRDNUMATMOST1MARRL6M);
                    mapObj.put('BURTCONSUMTRDNUMATMOST5MPARRL6M', TSUMBCC.BURTCONSUMTRDNUMATMOST5MPARRL6M);
                    mapObj.put('BURTCONSUMTRDNUMATMOST5MPARRL12M', TSUMBCC.BURTCONSUMTRDNUMATMOST5MPARRL12M);
                    mapObj.put('BURTCONSUMWSTSTATUSASATLASTUPD', TSUMBCC.BURTCONSUMWSTSTATUSASATLASTUPD);
                    mapObj.put('BURTCONSUMWSTSTATUSL3M', TSUMBCC.BURTCONSUMWSTSTATUSL3M);
                    mapObj.put('BURTCONSUMWSTSTATUSL12M', TSUMBCC.BURTCONSUMWSTSTATUSL12M);
                    mapObj.put('BURTCONSUMWSTSTATUSL24M', TSUMBCC.BURTCONSUMWSTSTATUSL24M);
                    mapObj.put('BURTCONSUMTRDWSTSTSATLASTUPDOPVF', TSUMBCC.BURTCONSUMTRDWSTSTSATLASTUPDOPVF);
                    mapObj.put('BURTCONSUMTRDWSTSTSATLASTUPDOPAL', TSUMBCC.BURTCONSUMTRDWSTSTSATLASTUPDOPAL);
                    mapObj.put('BURTCONSUMTRDWSTSTATUSCURROPL6M', TSUMBCC.BURTCONSUMTRDWSTSTATUSCURROPL6M);
                    mapObj.put('BURTCONSUMTRDWSTSTATUSCURROPL12M', TSUMBCC.BURTCONSUMTRDWSTSTATUSCURROPL12M);
                    mapObj.put('BURTCONSUMTRDWSTSTATUSOPENEDL3M', TSUMBCC.BURTCONSUMTRDWSTSTATUSOPENEDL3M);
                    mapObj.put('BURTCONSUMTRDWSTSTATUSOPENEDL6M', TSUMBCC.BURTCONSUMTRDWSTSTATUSOPENEDL6M);
                    mapObj.put('BURTCONSUMTRDWSTSTATUSOPENEDL12M', TSUMBCC.BURTCONSUMTRDWSTSTATUSOPENEDL12M);
                    mapObj.put('BURTCONSUMTRDWSTSTATUSOPENEDL24M', TSUMBCC.BURTCONSUMTRDWSTSTATUSOPENEDL24M);
                    mapObj.put('BURTCONSUMTRDAGEOLDESTAL', TSUMBCC.BURTCONSUMTRDAGEOLDESTAL);
                    mapObj.put('BURTCONSUMTRDAGEOLDESTVF', TSUMBCC.BURTCONSUMTRDAGEOLDESTVF);
                    mapObj.put('BURTCONSUMTRDDAYSYOUNGEST', TSUMBCC.BURTCONSUMTRDDAYSYOUNGEST);
                    mapObj.put('BURTCONSUMTRDDAYSYOUNGESTOPAL', TSUMBCC.BURTCONSUMTRDDAYSYOUNGESTOPAL);
                    mapObj.put('BURTCONSUMTRDDAYSYOUNGESTOPFO', TSUMBCC.BURTCONSUMTRDDAYSYOUNGESTOPFO);
                    mapObj.put('BURTCONSUMTRDDAYSYOUNGESTOPLB', TSUMBCC.BURTCONSUMTRDDAYSYOUNGESTOPLB);
                    mapObj.put('BURTCONSUMTRDDAYSYOUNGESTOPLN', TSUMBCC.BURTCONSUMTRDDAYSYOUNGESTOPLN);
                    mapObj.put('BURTCONSUMTRDDAYSYOUNGESTOPLO', TSUMBCC.BURTCONSUMTRDDAYSYOUNGESTOPLO);
                    mapObj.put('BURTCONSUMTRDAVGMNTHSONFILEAL', TSUMBCC.BURTCONSUMTRDAVGMNTHSONFILEAL);
                    mapObj.put('BURTCONSUMTRDAVGMNTHSONFILECC', TSUMBCC.BURTCONSUMTRDAVGMNTHSONFILECC);
                    mapObj.put('BURTCONSUMTRDAGEOLDESTOPSATISFACTORY', TSUMBCC.BURTCONSUMTRDAGEOLDESTOPSATISFACTORY);
                    mapObj.put('BURTCONSUMTRDAVGAGEOPENSATISFACTORYMB', TSUMBCC.BURTCONSUMTRDAVGAGEOPENSATISFACTORYMB);
                    mapObj.put('BURTCONSUMTRDAVGAGEOPENSATISFACTORYAL', TSUMBCC.BURTCONSUMTRDAVGAGEOPENSATISFACTORYAL);
                    mapObj.put('BURTCONSUMMNTHSMREC1MARRAL', TSUMBCC.BURTCONSUMMNTHSMREC1MARRAL);
                    mapObj.put('BURTCONSUMMNTHSMREC1MARRCC', TSUMBCC.BURTCONSUMMNTHSMREC1MARRCC);
                    mapObj.put('BURTCONSUMMNTHSMREC1MARRTE', TSUMBCC.BURTCONSUMMNTHSMREC1MARRTE);
                    mapObj.put('BURTCONSUMMNTHSMREC2MARRAL', TSUMBCC.BURTCONSUMMNTHSMREC2MARRAL);
                    mapObj.put('BURTCONSUMMNTHSMREC2MARRVF', TSUMBCC.BURTCONSUMMNTHSMREC2MARRVF);
                    mapObj.put('BURTCONSUMMNTHSMREC2MARRCC', TSUMBCC.BURTCONSUMMNTHSMREC2MARRCC);
                    mapObj.put('BURTCONSUMMNTHSMREC3MARRVF', TSUMBCC.BURTCONSUMMNTHSMREC3MARRVF);
                    mapObj.put('BURTCONSUMMNTHSMREC3MARRAL', TSUMBCC.BURTCONSUMMNTHSMREC3MARRAL);
                    mapObj.put('BURTCONSUMMNTHSMREC4MARRVF', TSUMBCC.BURTCONSUMMNTHSMREC4MARRVF);
                    mapObj.put('BURTCONSUMMNTHSMREC4MARRAL', TSUMBCC.BURTCONSUMMNTHSMREC4MARRAL);
                    mapObj.put('BURTCONSUMMNTHSMREC5MPLUSARRVF', TSUMBCC.BURTCONSUMMNTHSMREC5MPLUSARRVF);
                    mapObj.put('BURTCONSUMMNTHSMREC5MPLUSARRAL', TSUMBCC.BURTCONSUMMNTHSMREC5MPLUSARRAL);
                    mapObj.put('BURTCONSUMTRDAGEMRECLAPSED', TSUMBCC.BURTCONSUMTRDAGEMRECLAPSED);
                    mapObj.put('BURTCONSUMAGEMRECREVOKEDFACILITY', TSUMBCC.BURTCONSUMAGEMRECREVOKEDFACILITY);
                    mapObj.put('BURTCONSUMAGEMRECLEGALACTION', TSUMBCC.BURTCONSUMAGEMRECLEGALACTION);
                    mapObj.put('BURTCONSUMAGEMRECWOFFORREPOS', TSUMBCC.BURTCONSUMAGEMRECWOFFORREPOS);
                    mapObj.put('BURTCONSUMTRDAGEMRECADVPAIDUP', TSUMBCC.BURTCONSUMTRDAGEMRECADVPAIDUP);
                    mapObj.put('BURTCONSUMTRDTOTAMNTOFOP12MAGO', TSUMBCC.BURTCONSUMTRDTOTAMNTOFOP12MAGO);
                    mapObj.put('BURTCONSUMTRDAVGAMNTOFOPL6M', TSUMBCC.BURTCONSUMTRDAVGAMNTOFOPL6M);
                    mapObj.put('BURTCONSUMTRDAVGAMNTOFOPL12M', TSUMBCC.BURTCONSUMTRDAVGAMNTOFOPL12M);
                    mapObj.put('BURTCONSUMTRDTOTAMNT1MPASTDUELASTUPD', TSUMBCC.BURTCONSUMTRDTOTAMNT1MPASTDUELASTUPD);
                    mapObj.put('BURTCONSUMTRDTOTOUTBALOFOP', TSUMBCC.BURTCONSUMTRDTOTOUTBALOFOP);
                    mapObj.put('BURTCONSUMTRDTOTOUTBALOFOP3MAGO', TSUMBCC.BURTCONSUMTRDTOTOUTBALOFOP3MAGO);
                    mapObj.put('BURTCONSUMTRDTOTOUTBALOFOP12MAGO', TSUMBCC.BURTCONSUMTRDTOTOUTBALOFOP12MAGO);
                    mapObj.put('BURTCONSUMTRDTOTOUTBALOFOPL6MAL', TSUMBCC.BURTCONSUMTRDTOTOUTBALOFOPL6MAL);
                    mapObj.put('BURTCONSUMTRDTOTOUTBALOFOPL6MCL', TSUMBCC.BURTCONSUMTRDTOTOUTBALOFOPL6MCL);
                    mapObj.put('BURTCONSUMTRDTOTOUTBALOFOPL6MLN', TSUMBCC.BURTCONSUMTRDTOTOUTBALOFOPL6MLN);
                    mapObj.put('BURTCONSUMTRDTOTOUTBALOFOPL12M', TSUMBCC.BURTCONSUMTRDTOTOUTBALOFOPL12M);
                    mapObj.put('BURTCONSUMTRDAVGOUTBALOFOPL3M', TSUMBCC.BURTCONSUMTRDAVGOUTBALOFOPL3M);
                    mapObj.put('BURTCONSUMTRDAVGOUTBALOFOPL6M', TSUMBCC.BURTCONSUMTRDAVGOUTBALOFOPL6M);
                    mapObj.put('BURTCONSUMTRDAVGOUTBALOFOPL12M', TSUMBCC.BURTCONSUMTRDAVGOUTBALOFOPL12M);
                    mapObj.put('BURTCONSUMTRDTOTOUTBAL1MPASTDUELASTUPD', TSUMBCC.BURTCONSUMTRDTOTOUTBAL1MPASTDUELASTUPD);
                    mapObj.put('BURTCONSUMTRDTOTOUTBAL6MPPASTDUELASTUPD', TSUMBCC.BURTCONSUMTRDTOTOUTBAL6MPPASTDUELASTUPD);
                    mapObj.put('BURTCONSUMTRDTOTMNTHINSTDUEONOP', TSUMBCC.BURTCONSUMTRDTOTMNTHINSTDUEONOP);
                    mapObj.put('BURTCONSUMTRDTOTMNTHINSTDUEONOP12MAGO', TSUMBCC.BURTCONSUMTRDTOTMNTHINSTDUEONOP12MAGO);
                    mapObj.put('BURTCONSUMTRDTOTMNTHINSTDUEONOPL12M', TSUMBCC.BURTCONSUMTRDTOTMNTHINSTDUEONOPL12M);
                    mapObj.put('BURTCONSUMTRDTOTMNTHINSTDUEONSATISFOP', TSUMBCC.BURTCONSUMTRDTOTMNTHINSTDUEONSATISFOP);
                    mapObj.put('BURTCONSUMTRDAVGMNTHINSTDUEONOPL6M', TSUMBCC.BURTCONSUMTRDAVGMNTHINSTDUEONOPL6M);
                    mapObj.put('BURTCONSUMTRDAVGMNTHINSTDUEONOPL12M', TSUMBCC.BURTCONSUMTRDAVGMNTHINSTDUEONOPL12M);
                    mapObj.put('BURTCONSUMTRDTOTMNTHINSTDUEON1MPASTDUELUPD', TSUMBCC.BURTCONSUMTRDTOTMNTHINSTDUEON1MPASTDUELUPD);
                    mapObj.put('BURTCONSUMTRDTOTAMNTARROFOPLASTUPD', TSUMBCC.BURTCONSUMTRDTOTAMNTARROFOPLASTUPD);
                    mapObj.put('BURTCONSUMTRDTOTAMNTARROFOP3MAGO', TSUMBCC.BURTCONSUMTRDTOTAMNTARROFOP3MAGO);
                    mapObj.put('BURTCONSUMTRDTOTAMNTARROFOP6MAGO', TSUMBCC.BURTCONSUMTRDTOTAMNTARROFOP6MAGO);
                    mapObj.put('BURTCONSUMTRDTOTAMNTARROFOP12MAGO', TSUMBCC.BURTCONSUMTRDTOTAMNTARROFOP12MAGO);
                    mapObj.put('BURTCONSUMTRDTOTAMNTARR1MPASTDUELASTUPD', TSUMBCC.BURTCONSUMTRDTOTAMNTARR1MPASTDUELASTUPD);
                    mapObj.put('BURTCONSUMTRDTOTAMNTARR3MPASTDUELASTUPD', TSUMBCC.BURTCONSUMTRDTOTAMNTARR3MPASTDUELASTUPD);
                    mapObj.put('BURTCONSUMTRDTOTAMNTARR6MPPASTDUELASTUPD', TSUMBCC.BURTCONSUMTRDTOTAMNTARR6MPPASTDUELASTUPD);
                    mapObj.put('BURTCONSUMTOTAMNTOFLEGALACTIONS', TSUMBCC.BURTCONSUMTOTAMNTOFLEGALACTIONS);
                    mapObj.put('BURTCONSUMTOTAMNTOFWOFFSORREPOS', TSUMBCC.BURTCONSUMTOTAMNTOFWOFFSORREPOS);
                    mapObj.put('BURTCONSUMTRDUTILISATIONOPENLB', TSUMBCC.BURTCONSUMTRDUTILISATIONOPENLB);
                    mapObj.put('BURTCONSUMTRDUTILISATIONOPENAL', TSUMBCC.BURTCONSUMTRDUTILISATIONOPENAL);
                    mapObj.put('BURTCONSUMTRDUTILOPASAT3MAGO', TSUMBCC.BURTCONSUMTRDUTILOPASAT3MAGO);
                    mapObj.put('BURTCONSUMTRDUTILOPASAT6MAGO', TSUMBCC.BURTCONSUMTRDUTILOPASAT6MAGO);
                    mapObj.put('BURTCONSUMTRDUTILOPASAT12MAGO', TSUMBCC.BURTCONSUMTRDUTILOPASAT12MAGO);
                    mapObj.put('BURTCONSUMTRDUTILOPRECSATISFCC', TSUMBCC.BURTCONSUMTRDUTILOPRECSATISFCC);
                    mapObj.put('BURTCONSUMTRDUTILOPRECSATISFAL', TSUMBCC.BURTCONSUMTRDUTILOPRECSATISFAL);
                    mapObj.put('BURTCONSUMTRDAVGUTILOPFORP3M', TSUMBCC.BURTCONSUMTRDAVGUTILOPFORP3M);
                    mapObj.put('BURTCONSUMTRDAVGUTILOPFORP6MCC', TSUMBCC.BURTCONSUMTRDAVGUTILOPFORP6MCC);
                    mapObj.put('BURTCONSUMTRDAVGUTILOPFORP6MAL', TSUMBCC.BURTCONSUMTRDAVGUTILOPFORP6MAL);
                    mapObj.put('BURTCONSUMTRDAVGUTILOPFORP12MCC', TSUMBCC.BURTCONSUMTRDAVGUTILOPFORP12MCC);
                    mapObj.put('BURTCONSUMTRDAVGUTILOPFORP12MAL', TSUMBCC.BURTCONSUMTRDAVGUTILOPFORP12MAL);
                    mapObj.put('BURTCONSUMENQNUM', TSUMBCC.BURTCONSUMENQNUM);
                    mapObj.put('BURTCONSUMENQNUML14D', TSUMBCC.BURTCONSUMENQNUML14D);
                    mapObj.put('BURTCONSUMENQNUML1M', TSUMBCC.BURTCONSUMENQNUML1M);
                    mapObj.put('BURTCONSUMENQNUML12M', TSUMBCC.BURTCONSUMENQNUML12M);
                    mapObj.put('BURTCONSUMENQNUMDEDUP', TSUMBCC.BURTCONSUMENQNUMDEDUP);
                    mapObj.put('BURTCONSUMENQNUMDEDUPL14DAL', TSUMBCC.BURTCONSUMENQNUMDEDUPL14DAL);
                    mapObj.put('BURTCONSUMENQNUMDEDUPL14DFL', TSUMBCC.BURTCONSUMENQNUMDEDUPL14DFL);
                    mapObj.put('BURTCONSUMENQNUMDEDUPL1MAL', TSUMBCC.BURTCONSUMENQNUMDEDUPL1MAL);
                    mapObj.put('BURTCONSUMENQNUMDEDUPL1MPL', TSUMBCC.BURTCONSUMENQNUMDEDUPL1MPL);
                    mapObj.put('BURTCONSUMENQNUMDEDUPL1MFL', TSUMBCC.BURTCONSUMENQNUMDEDUPL1MFL);
                    mapObj.put('BURTCONSUMENQNUMDEDUPL3MAL', TSUMBCC.BURTCONSUMENQNUMDEDUPL3MAL);
                    mapObj.put('BURTCONSUMENQNUMDEDUPL3MFL', TSUMBCC.BURTCONSUMENQNUMDEDUPL3MFL);
                    mapObj.put('BURTCONSUMENQNUMDEDUPL6M', TSUMBCC.BURTCONSUMENQNUMDEDUPL6M);
                    mapObj.put('BURTCONSUMENQAGEOLDESTAL', TSUMBCC.BURTCONSUMENQAGEOLDESTAL);
                    mapObj.put('BURTCONSUMENQAGEOLDESTCL', TSUMBCC.BURTCONSUMENQAGEOLDESTCL);
                    mapObj.put('BURTCONSUMENQDAYSYOUNGESTAL', TSUMBCC.BURTCONSUMENQDAYSYOUNGESTAL);
                    mapObj.put('BURTCONSUMENQDAYSYOUNGESTPL', TSUMBCC.BURTCONSUMENQDAYSYOUNGESTPL);
                    mapObj.put('BURTCONSUMDMGRAGE', TSUMBCC.BURTCONSUMDMGRAGE);
                    mapObj.put('BURTCONSUMDMGRGENDER', TSUMBCC.BURTCONSUMDMGRGENDER);
                    mapObj.put('BURTCONSUMDMGRMARITALSTATUS', TSUMBCC.BURTCONSUMDMGRMARITALSTATUS);
                    mapObj.put('BURTCONSUMDMGROWNERTENANT', TSUMBCC.BURTCONSUMDMGROWNERTENANT);
                    mapObj.put('BURTCONSUMDMGRNUMDEPENDANTS', TSUMBCC.BURTCONSUMDMGRNUMDEPENDANTS);
                    mapObj.put('BURTCONSUMDMGRDECEASEDIND', TSUMBCC.BURTCONSUMDMGRDECEASEDIND);
                    mapObj.put('BURTCONSUMDMGRRSACITIZENIND', TSUMBCC.BURTCONSUMDMGRRSACITIZENIND);
                    mapObj.put('BURTCONSUMDMGRRSAIDLOGICCHECK', TSUMBCC.BURTCONSUMDMGRRSAIDLOGICCHECK);
                    mapObj.put('BURTCONSUMDMGRDEBTREVIEWIND', TSUMBCC.BURTCONSUMDMGRDEBTREVIEWIND);
                    mapObj.put('BURTCONSUMDMGRDISPUTEIND', TSUMBCC.BURTCONSUMDMGRDISPUTEIND);
                    mapObj.put('BURTCONSUMADVTOTAMNT', TSUMBCC.BURTCONSUMADVTOTAMNT);
                    mapObj.put('BURTCONSUMADVTOTAMNTFROMWOFFREPOS', TSUMBCC.BURTCONSUMADVTOTAMNTFROMWOFFREPOS);
                    mapObj.put('BURTCONSUMJUDTOTAMNT', TSUMBCC.BURTCONSUMJUDTOTAMNT);
                    mapObj.put('BURTCONSUMNOTAGEYOUNGESTFINALSEQSTR', TSUMBCC.BURTCONSUMNOTAGEYOUNGESTFINALSEQSTR);
                    mapObj.put('BURTCONSUMDEFPAYMNTSNUM', TSUMBCC.BURTCONSUMDEFPAYMNTSNUM);
                    mapObj.put('BURTCONSUMDEFPAYMNTSNUMCUROPACCS', TSUMBCC.BURTCONSUMDEFPAYMNTSNUMCUROPACCS);
                    mapObj.put('BURTCONSUMTRDWSTSTSDEFERREDLASTUPD', TSUMBCC.BURTCONSUMTRDWSTSTSDEFERREDLASTUPD);
                    mapObj.put('BURTCONSUMTRDNUMBERJOINT', TSUMBCC.BURTCONSUMTRDNUMBERJOINT);
                    mapObj.put('BURTCONSUMTRDNUMBEROPJOINT', TSUMBCC.BURTCONSUMTRDNUMBEROPJOINT);
                    mapObj.put('BURTCONSUMTRDNUMJOINT1MPLUSPASTDUE', TSUMBCC.BURTCONSUMTRDNUMJOINT1MPLUSPASTDUE);
                    mapObj.put('BURTCONSUMTRDNUMJOINT2MPLUSPASTDUE', TSUMBCC.BURTCONSUMTRDNUMJOINT2MPLUSPASTDUE);
                    mapObj.put('BURTCONSUMTRDNUMJOINT3MPLUSPASTDUE', TSUMBCC.BURTCONSUMTRDNUMJOINT3MPLUSPASTDUE);
                    mapObj.put('BURTCONSUMTRDWSTSTATUSJOINTLASTUPD', TSUMBCC.BURTCONSUMTRDWSTSTATUSJOINTLASTUPD);
                    mapObj.put('BURTCONSUMSOLEPROPNUMTRADES', TSUMBCC.BURTCONSUMSOLEPROPNUMTRADES);
                    mapObj.put('BURTCONSUMSOLEPROPNUMOPTRADES', TSUMBCC.BURTCONSUMSOLEPROPNUMOPTRADES);
                    mapObj.put('BURTCONSUMSOLEPROPWSTSTSTRADESLASTUPD', TSUMBCC.BURTCONSUMSOLEPROPWSTSTSTRADESLASTUPD);
                }

                if(TENRSUM != null){
                    mapObj.put('BURTCONENRSUMNOTWRSTTYPE', TENRSUM.BURTCONENRSUMNOTWRSTTYPE);
                    mapObj.put('BURTCONENRSUMMNTHSWRSTTYPE', TENRSUM.BURTCONENRSUMMNTHSWRSTTYPE);
                    mapObj.put('BURTCONENRSUMNOTMRECTYPE', TENRSUM.BURTCONENRSUMNOTMRECTYPE);
                    mapObj.put('BURTCONENRSUMMNTHSMRECTYPE', TENRSUM.BURTCONENRSUMMNTHSMRECTYPE);
                    mapObj.put('BURTCONENRSUMMNTHSSNCEREHAB', TENRSUM.BURTCONENRSUMMNTHSSNCEREHAB);
                    mapObj.put('BURTCONENRSUMEVERINSOLVENT', TENRSUM.BURTCONENRSUMEVERINSOLVENT);
                    mapObj.put('BURTCONENRSUMENQALLTOTEVER', TENRSUM.BURTCONENRSUMENQALLTOTEVER);
                    mapObj.put('BURTCONENRSUMENQALLL90D', TENRSUM.BURTCONENRSUMENQALLL90D);
                    mapObj.put('BURTCONENRSUMENQALLL180D', TENRSUM.BURTCONENRSUMENQALLL180D);
                    mapObj.put('BURTCONENRSUMENQALLL1Y', TENRSUM.BURTCONENRSUMENQALLL1Y);
                    mapObj.put('BURTCONENRSUMENQALLL2Y', TENRSUM.BURTCONENRSUMENQALLL2Y);
                    mapObj.put('BURTCONENRSUMPPSALLOWNCURBALACTIVE', TENRSUM.BURTCONENRSUMPPSALLOWNCURBALACTIVE);
                    mapObj.put('BURTCONENRSUMPPSALLOWNVALINSTALMENTS', TENRSUM.BURTCONENRSUMPPSALLOWNVALINSTALMENTS);
                    mapObj.put('BURTCONENRSUMPPSALLOTHCURBALACTIVE', TENRSUM.BURTCONENRSUMPPSALLOTHCURBALACTIVE);
                    mapObj.put('BURTCONENRSUMPPSALLOTHVALINSTALMENTS', TENRSUM.BURTCONENRSUMPPSALLOTHVALINSTALMENTS);
                    mapObj.put('BURTCONENRSUMPPSALLCURBALACTIVE', TENRSUM.BURTCONENRSUMPPSALLCURBALACTIVE);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARREVER', TENRSUM.BURTCONENRSUMPPSALLWSTARREVER);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARROPEVER', TENRSUM.BURTCONENRSUMPPSALLWSTARROPEVER);
                    mapObj.put('BURTCONENRSUMPPSALLDAYSSINCEMOSTRECOP', TENRSUM.BURTCONENRSUMPPSALLDAYSSINCEMOSTRECOP);
                    mapObj.put('BURTCONENRSUMPPSALLCLSPPS', TENRSUM.BURTCONENRSUMPPSALLCLSPPS);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARRLEVELL90D', TENRSUM.BURTCONENRSUMPPSALLWSTARRLEVELL90D);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARRLEVELL180D', TENRSUM.BURTCONENRSUMPPSALLWSTARRLEVELL180D);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARRLEVELL1Y', TENRSUM.BURTCONENRSUMPPSALLWSTARRLEVELL1Y);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARRSTATUSL30D', TENRSUM.BURTCONENRSUMPPSALLWSTARRSTATUSL30D);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARRSTATUSL60D', TENRSUM.BURTCONENRSUMPPSALLWSTARRSTATUSL60D);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARRSTATUSL120D', TENRSUM.BURTCONENRSUMPPSALLWSTARRSTATUSL120D);
                    mapObj.put('BURTCONENRSUMPPSALLWSTARRSTATUSL2Y', TENRSUM.BURTCONENRSUMPPSALLWSTARRSTATUSL2Y);
                    mapObj.put('BURTCONENRSUMPPSALLNUMWOFF', TENRSUM.BURTCONENRSUMPPSALLNUMWOFF);
                    mapObj.put('BURTCONENRSUMPPSALLVALWOFF', TENRSUM.BURTCONENRSUMPPSALLVALWOFF);
                    mapObj.put('BURTCONENRSUMPPSALLNUMMRECWOFF', TENRSUM.BURTCONENRSUMPPSALLNUMMRECWOFF);
                    mapObj.put('BURTCONENRSUMPPSALLVALMRECWOFF', TENRSUM.BURTCONENRSUMPPSALLVALMRECWOFF);
                    mapObj.put('BURTCONENRSUMPPSALLNUMHIGHWOFF', TENRSUM.BURTCONENRSUMPPSALLNUMHIGHWOFF);
                    mapObj.put('BURTCONENRSUMPPSALLVALHIGHWOFF', TENRSUM.BURTCONENRSUMPPSALLVALHIGHWOFF);
                    mapObj.put('BURTCONENRSUMPPSALLTOTVAFINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTBNDINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTCCINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTEDUINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTINSINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTODLINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTODBTINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTRETINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTRETINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTSECINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTTELINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTENTINSTL', TENRSUM.BURTCONENRSUMPPSALLTOTENTINSTL);
                    mapObj.put('BURTCONENRSUMPPSALLTOTLIVINGEXPENSES', TENRSUM.BURTCONENRSUMPPSALLTOTLIVINGEXPENSES);
                    mapObj.put('BURTCONENRSUMPPSALLTOTCREDITCOMMITMENTS', TENRSUM.BURTCONENRSUMPPSALLTOTCREDITCOMMITMENTS);
                    mapObj.put('BURTCONENRSUMJUDMNTHSMREC', TENRSUM.BURTCONENRSUMJUDMNTHSMREC);
                    mapObj.put('BURTCONENRSUMADVMONTHSMOSTRECENT',TENRSUM.BURTCONENRSUMADVMONTHSMOSTRECENT);
                }

                if(TSUMNLRCOUNT != null){
                    mapObj.put('BURTCONSUMNLRCMLTVINSTALVAL', TSUMNLRCOUNT.BURTCONSUMNLRCMLTVINSTALVAL);
                    mapObj.put('BURTCONSUMNLRCMLTVOUTSTBAL', TSUMNLRCOUNT.BURTCONSUMNLRCMLTVOUTSTBAL);
                    mapObj.put('BURTCONSUMNLRWRSTMNTHARREVER', TSUMNLRCOUNT.BURTCONSUMNLRWRSTMNTHARREVER);
                }

                if(TSUMPPSCPA != null){
                    mapObj.put('BURTCONSUMPPSCPATOTACTVACCS', TSUMPPSCPA.BURTCONSUMPPSCPATOTACTVACCS);
                    mapObj.put('BURTCONSUMPPSCPATOTCLSACCSL24M', TSUMPPSCPA.BURTCONSUMPPSCPATOTCLSACCSL24M);
                    mapObj.put('BURTCONSUMPPSCPATOTADVACCSL24M', TSUMPPSCPA.BURTCONSUMPPSCPATOTADVACCSL24M);
                    mapObj.put('BURTCONSUMPPSCPAHIGHMNTHARRL24M', TSUMPPSCPA.BURTCONSUMPPSCPAHIGHMNTHARRL24M);
                    mapObj.put('BURTCONSUMPPSCPANOCURRREVACCS', TSUMPPSCPA.BURTCONSUMPPSCPANOCURRREVACCS);
                    mapObj.put('BURTCONSUMPPSCPANOCURRINSTACCS', TSUMPPSCPA.BURTCONSUMPPSCPANOCURRINSTACCS);
                    mapObj.put('BURTCONSUMPPSCPANOCURROPACCS', TSUMPPSCPA.BURTCONSUMPPSCPANOCURROPACCS);
                    mapObj.put('BURTCONSUMPPSCPACURRBAL', TSUMPPSCPA.BURTCONSUMPPSCPACURRBAL);
                    mapObj.put('BURTCONSUMPPSCPACURRBALINDDC', TSUMPPSCPA.BURTCONSUMPPSCPACURRBALINDDC);
                    mapObj.put('BURTCONSUMPPSCPACURRMNTHINSTAL', TSUMPPSCPA.BURTCONSUMPPSCPACURRMNTHINSTAL);
                    mapObj.put('BURTCONSUMPPSCPACURRMNTHINSTALBALINDDC', TSUMPPSCPA.BURTCONSUMPPSCPACURRMNTHINSTALBALINDDC);
                    mapObj.put('BURTCONSUMPPSCPACMLTVARRAMNT', TSUMPPSCPA.BURTCONSUMPPSCPACMLTVARRAMNT);
                    mapObj.put('BURTCONSUMPPSCPACMLTVARRAMNTBALINDDC', TSUMPPSCPA.BURTCONSUMPPSCPACMLTVARRAMNTBALINDDC);
                }

                if(TSUMPPSNLR != null){
                    mapObj.put('BURTCONSUMPPSNLRTOTACTVACCS', TSUMPPSNLR.BURTCONSUMPPSNLRTOTACTVACCS);
                    mapObj.put('BURTCONSUMPPSNLRTOTCLSACCSL24M', TSUMPPSNLR.BURTCONSUMPPSNLRTOTCLSACCSL24M);
                    mapObj.put('BURTCONSUMPPSNLRTOTADVACCSL24M', TSUMPPSNLR.BURTCONSUMPPSNLRTOTADVACCSL24M);
                    mapObj.put('BURTCONSUMPPSNLRHIGHMNTHARRL24M', TSUMPPSNLR.BURTCONSUMPPSNLRHIGHMNTHARRL24M);
                    mapObj.put('BURTCONSUMPPSNLRNOCURRREVACCS', TSUMPPSNLR.BURTCONSUMPPSNLRNOCURRREVACCS);
                    mapObj.put('BURTCONSUMPPSNLRNOCURRINSTACCS', TSUMPPSNLR.BURTCONSUMPPSNLRNOCURRINSTACCS);
                    mapObj.put('BURTCONSUMPPSNLRNOCURROPACCS', TSUMPPSNLR.BURTCONSUMPPSNLRNOCURROPACCS);
                    mapObj.put('BURTCONSUMPPSNLRCURRBAL', TSUMPPSNLR.BURTCONSUMPPSNLRCURRBAL);
                    mapObj.put('BURTCONSUMPPSNLRCURRBALINDDC', TSUMPPSNLR.BURTCONSUMPPSNLRCURRBALINDDC);
                    mapObj.put('BURTCONSUMPPSNLRCURRMNTHINSTAL', TSUMPPSNLR.BURTCONSUMPPSNLRCURRMNTHINSTAL);
                    mapObj.put('BURTCONSUMPPSNLRCURRMNTHINSTALBALINDDC', TSUMPPSNLR.BURTCONSUMPPSNLRCURRMNTHINSTALBALINDDC);
                    mapObj.put('BURTCONSUMPPSNLRCMLTVARRAMNT', TSUMPPSNLR.BURTCONSUMPPSNLRCMLTVARRAMNT);
                    mapObj.put('BURTCONSUMPPSNLRCMLTVARRAMNTBALINDDC', TSUMPPSNLR.BURTCONSUMPPSNLRCMLTVARRAMNTBALINDDC);
                }

                mapObj.put('EDETCOL',edetcolData);
                mapObj.put('EDETENQCPAOTH',edetenqcpaothData);
                mapObj.put('EDETENQCPAOWN',edetenqcpaownData);
                mapObj.put('EDETENQNLROTH',edetenqnlrothData);
                mapObj.put('EDETENQNLROWN',edetenqnlrownData);
                mapObj.put('EDETJUD',edetjudData);
                mapObj.put('EDETNOT',edetnotData);
                mapObj.put('EDETSHW',edetshwData);
                mapObj.put('EENRDETPPSASSETFIN',eenrdetppsassetfinData);
                mapObj.put('EENRDETPPSBONDMRTG',eenrdetppsbondmrtgData);
                mapObj.put('EENRDETPPSCREDITCARD',eenrdetppscreditcardData);
                mapObj.put('EENRDETPPSEDUCATION',eenrdetppseducationData);
                mapObj.put('EENRDETPPSINSURANCE',eenrdetppsinsuranceData);
                mapObj.put('EENRDETPPSLOANOVDRT',eenrdetppsloanovdrtData);
                mapObj.put('EENRDETPPSOTHDEBTREPAY',eenrdetppsothdebtrepayData);
                mapObj.put('EENRDETPPSRETACCOUNTS',eenrdetppsretaccountsData);
                mapObj.put('EENRDETPPSSECURITY',eenrdetppssecurityData);
                mapObj.put('EENRDETPPSTELECOMM',eenrdetppstelecommData);
                mapObj.put('EENRDETPPSENTERTAINMENT',eenrdetppsentertainmentData);
                mapObj.put('TDETENQCPAALL',tdetenqcpaallData);
                mapObj.put('TDETENQNLRALL',tdetenqnlrallData);
                mapObj.put('TDETJUD',tdetjudData);
                mapObj.put('TDETNOT',tdetnotData);
                mapObj.put('TDETTRA',tdettraData);
                mapObj.put('TDETFPS',tdetfpsData);
                mapObj.put('TENRDETPPSASSETFIN',tenrdetppsassetfinData);
                mapObj.put('TENRDETPPSBONDMRTG',tenrdetppsbondmrtgData);
                mapObj.put('TENRDETPPSCREDITCARD',tenrdetppscreditcardData);
                mapObj.put('TENRDETPPSEDUCATION',tenrdetppseducationData);
                mapObj.put('TENRDETPPSINSURANCE',tenrdetppsinsuranceData);
                mapObj.put('TENRDETPPSLOANOVDRT',tenrdetppsloanovdrtData);
                mapObj.put('TENRDETPPSOTHDEBTREPAY',tenrdetppsothdebtrepayData);
                mapObj.put('TENRDETPPSRETACCOUNTS',tenrdetppsretaccountsData);
                mapObj.put('TENRDETPPSSECURITY',tenrdetppssecurityData);
                mapObj.put('TENRDETPPSTELECOMM',tenrdetppstelecommData);
                mapObj.put('TENRDETPPSENTERTAINMENT',tenrdetppsentertainmentData);

            	bureauData.add(mapObj);
            } else {
                Map<String,Object> mapObj = new Map<String,Object>();
                mapObj.put('CLIENTNAME', applicationProfile.Client_Name__c);
                mapObj.put('CIFCODE', applicationProfile.Client_CIF_Code__c);
                mapObj.put('BUREAUREPORT1', applicationProfile.Bureau_Report_1__c);
                mapObj.put('BUREAUREPORT2', applicationProfile.Bureau_Report_2__c);
                mapObj.put('WORSTREPORT', applicationProfile.Bureau_Worst_Report__c);
                mapObj.put('CALLTYPE', 'TU');
            	bureauData.add(mapObj);
            }
        }

        return bureauData;
    }
}