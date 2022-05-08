/**
 * @description Integration Handler for getPostalCode Service
 * @author  Paul John du Randt : ABSA (IQ Business)
 * @created 2020-11-03
 */
public without sharing class CIgetPostalCodeHelper {
    /**
    * @description getPostalCodeDetails
    * @return List<Map<String,Object>>
    * @param area
    */
    @AuraEnabled
    public static List<Map<String, Object>> getPostalCodeDetails(string area)
    {
        List<Map<String,Object>> returnList = new List<Map<String,Object>>();
        CIgetPostalCodeV1_Req_IB_v1 requestBean = getNewResponseBean();
        requestBean = SetEnvironmentVariables(requestBean);
        requestBean.CIgetPostalCodeV1.cib603di.area = area;
        CIgetPostalCodeV1_Resp_IB_v1 responsegetSuburbDetails = CIgetPostalCodeV1_IH_v1.CIgetPostalCodeV1(requestBean);
        if (responsegetSuburbDetails.CIgetPostalCodeV1Response != null) {
            if(responsegetSuburbDetails.CIgetPostalCodeV1Response.cib603do.tableEntry != null) {
                for(CIgetPostalCodeV1_Resp_IB_v1.TableEntry obj: responsegetSuburbDetails.CIgetPostalCodeV1Response.cib603do.tableEntry)
                {
                    Map<String,Object> mapObj = new Map<String,Object>();
                    mapObj.put('suburbName', obj.suburbName);
                    mapObj.put('townOrCityName', obj.townOrCityName);
                    mapObj.put('streetPostCode', obj.streetPostCode);
                    mapObj.put('provinceName', obj.provinceName);
                    returnList.add(mapObj);
                }
            }
        }
        return returnList;
    }
    /**
    * @description getNewResponseBean
    * @return CIgetPostalCodeV1_Req_IB_v1
    */
    public static CIgetPostalCodeV1_Req_IB_v1 getNewResponseBean()
    {
        CIgetPostalCodeV1_Req_IB_v1 requestBean = new CIgetPostalCodeV1_Req_IB_v1();
        requestBean.CIgetPostalCodeV1 = new CIgetPostalCodeV1_Req_IB_v1.CIgetPostalCodeV1();
        requestBean.CIgetPostalCodeV1.cib603di = new CIgetPostalCodeV1_Req_IB_v1.Cib603di();
        requestBean.CIgetPostalCodeV1.nbsapli = new CIgetPostalCodeV1_Req_IB_v1.Nbsapli();
        requestBean.CIgetPostalCodeV1.nbsmsgi = new CIgetPostalCodeV1_Req_IB_v1.Nbsmsgi();
        return requestBean;
    }
    /**
    * @description setEnvironmentVariables
    * @return CIgetPostalCodeV1_Req_IB_v1
    * @param requestBean
    */
    public static CIgetPostalCodeV1_Req_IB_v1 setEnvironmentVariables(CIgetPostalCodeV1_Req_IB_v1 requestBean)
    {
        requestBean.CIgetPostalCodeV1.nbsapli.channel = 'BRANCH';
        requestBean.CIgetPostalCodeV1.nbsapli.application = 'BDP';
        requestBean.CIgetPostalCodeV1.nbsapli.trace = 'N';
        requestBean.CIgetPostalCodeV1.Nbsmsgi.msgLanguage = 'E';
        requestBean.CIgetPostalCodeV1.Nbsmsgi.msgTarget = 'STD';
        requestBean.CIgetPostalCodeV1.Nbsmsgi.finalMsgClass='';
        requestBean.CIgetPostalCodeV1.Nbsmsgi.finalMsgCode='';
        requestBean.CIgetPostalCodeV1.cib603di.postalCode='';
        requestBean.CIgetPostalCodeV1.cib603di.maxRecsToRtrv = '100';
        requestBean.CIgetPostalCodeV1.cib603di.startAfterSrchPos='';
        requestBean.CIgetPostalCodeV1.cib603di.languageInd='E';
        return requestBean;
    }
}