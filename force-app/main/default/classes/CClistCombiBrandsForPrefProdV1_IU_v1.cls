/**
* @description Apex Integration Request Bean class for CClistCombiBrandsForPreferredProductV1 service UI
* @author  Mbuyiseni Mbhokane 
* @since   2020-08-04
*
**/

public class CClistCombiBrandsForPrefProdV1_IU_v1 {
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-10 
    * @param prodType 
    * @param prodCode 
    * @param cardType 
    * @return CClistCombiBrandsForPrefProdV1_Req_IB_v1 
    **/
    public static CClistCombiBrandsForPrefProdV1_Req_IB_v1 mapRequestFields(String prodType,String prodCode, String cardType){
        
        CClistCombiBrandsForPrefProdV1_Req_IB_v1 requestBean = new CClistCombiBrandsForPrefProdV1_Req_IB_v1();
        requestBean.CClistCombiBrandsForPreferredProductV1 = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.CClistCombiBrandsForPreferredProductV1();
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.Nbsapdpi();
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.Nbsmsgi();
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.CCS306I();
        CClistCombiBrandsForPrefProdV1_Req_IB_v1.FinalMsgId finalMsgIdBean = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.FinalMsgId();
        
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.channel = 'BDP';
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.application = 'BDP';
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.trace = 'Y';
        
        finalMsgIdBean.finalMsgClass = new List<String>();
        finalMsgIdBean.finalMsgCode = new List<String>();

        requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.msgLanguage = 'E';
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.msgTarget = 'STD';
        requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.finalMsgId = finalMsgIdBean;
        
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.prodType = prodType;
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.prodCode = prodCode;
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.nxtBrand = '0';//Need to confirm what should passed here?
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.nbrBrandReq = '10';//Need to confirm what should passed here?
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.cardType = cardType;//'C';
        requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.functionInd = 'R';//Need to confirm what should passed here?
        
        return requestBean;
    }
}