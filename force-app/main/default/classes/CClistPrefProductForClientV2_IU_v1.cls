/**
* Apex Integration Request Bean class for CClistPrefProductForClientV2 service UI
* @author  Mbuyiseni Mbhokane 
* @since   2020-08-04
*
**/
public class CClistPrefProductForClientV2_IU_v1 {
    public static CClistPrefProductForClientV2_Req_IB_v1 mapRequestFields(String clientCode,String inpAccntNbr, String cardType){
        
        //get current user
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
        
        CClistPrefProductForClientV2_Req_IB_v1 requestBean = new CClistPrefProductForClientV2_Req_IB_v1();
        requestBean.CClistPrefProductsForClientV2 = new CClistPrefProductForClientV2_Req_IB_v1.CClistPrefProductsForClientV2();
        requestBean.CClistPrefProductsForClientV2.nbsapdpi = new CClistPrefProductForClientV2_Req_IB_v1.Nbsapdpi();
        requestBean.CClistPrefProductsForClientV2.nbsmsgi = new CClistPrefProductForClientV2_Req_IB_v1.Nbsmsgi();
        requestBean.CClistPrefProductsForClientV2.ccp317i = new CClistPrefProductForClientV2_Req_IB_v1.Ccp317i();
        
        requestBean.CClistPrefProductsForClientV2.nbsapdpi.channel = '|';
        requestBean.CClistPrefProductsForClientV2.nbsapdpi.trace = 'Y';
        
        requestBean.CClistPrefProductsForClientV2.nbsmsgi.msgLanguage = 'E';
        requestBean.CClistPrefProductsForClientV2.nbsmsgi.msgTarget = 'STD';
        
        requestBean.CClistPrefProductsForClientV2.ccp317i.tellerCode = currentUser.Teller_Operator_Code__c;//tellerCode;
        requestBean.CClistPrefProductsForClientV2.ccp317i.clientCode = clientCode;//CIF Number
        requestBean.CClistPrefProductsForClientV2.ccp317i.inpAccntNbr = inpAccntNbr;//policy number from opportunityLineItem
        requestBean.CClistPrefProductsForClientV2.ccp317i.cardType = cardType;//'C';
        requestBean.CClistPrefProductsForClientV2.ccp317i.functionInd = 'N';//Need to confirm what should passed here?
        
        return requestBean;
    }
}