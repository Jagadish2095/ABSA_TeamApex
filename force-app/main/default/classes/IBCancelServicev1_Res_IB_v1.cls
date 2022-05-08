/*
* Integration Response  Bean for IBCancelServicev1 Service
* @author Lulu Rankwe
* @created 05-05-2020
*/

public class IBCancelServicev1_Res_IB_v1  extends Base_IB{
    
    public String status;
    public Integer statusCode;
    public String message; 

    public class nbsmsgo{
        public String nbrUserMsgs{get;set;}
        public String nbrUserErrs{get;set;}
        public String sysErrTxt{get;set;}
        public msgEntry msgEntry{get;set;}
        public String version{get;set;}
    }
    public class nbsapdpo{
        public String serviceVersion{get;set;}
        public String reasonCode{get;set;}
        public String returnCode{get;set;}
        public String echoKey{get;set;}
        public String version{get;set;}
    }
    public class msgEntry{
        public String msgClass{get;set;}
        public String msgTxt{get;set;}
        public String msgErrInd{get;set;}
        public String msgCode{get;set;}
    }
    public IBcancelServiceV1Response IBcancelServiceV1Response{get;set;}
    public class IBcancelServiceV1Response{
        public nbsmsgo nbsmsgo{get;set;}
        public nbsapdpo nbsapdpo{get;set;}
    }
    
    public IBCancelServicev1_Res_IB_v1 dummyResponse(){
        IBCancelServicev1_Res_IB_v1 respBean = new IBCancelServicev1_Res_IB_v1();
        IBCancelServicev1_Res_IB_v1.nbsapdpo  nbsapdpoBean = new IBCancelServicev1_Res_IB_v1.nbsapdpo();
        IBCancelServicev1_Res_IB_v1.nbsmsgo  nbsmsgoBean = new IBCancelServicev1_Res_IB_v1.nbsmsgo();
        
        respBean.status = 'Ok';
        respBean.statusCode = 200;
        respBean.message = '';
        
        nbsmsgoBean.version = 'MSG3001';
        nbsmsgoBean.sysErrTxt = '';
        nbsmsgoBean.nbrUserErrs = '';
        nbsmsgoBean.nbrUserMsgs = '';
        nbsapdpoBean.version = '';
        nbsapdpoBean.reasonCode = '0';
        nbsapdpoBean.returnCode = '0';
        nbsapdpoBean.serviceVersion = 'BUSO001';
        nbsapdpoBean.echoKey = '';
        
        IBCancelServicev1_Res_IB_v1.IBcancelServiceV1Response IBcancelServiceV1Bean = new IBCancelServicev1_Res_IB_v1.IBcancelServiceV1Response();
        IBcancelServiceV1Bean.nbsapdpo = nbsapdpoBean;
		IBcancelServiceV1Bean.nbsmsgo = nbsmsgoBean;
        
        respBean.IBcancelServiceV1Response = IBcancelServiceV1Bean;
        
        return respBean;
        
        
    }


}