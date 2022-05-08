/**
 * @description       : Integration Response Bean for IPlistNCARatesV1 Service
 * @author            : Saurabh Pandey
 * @last modified on  : 2021-06-12
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Saurabh Pandey   Initial Version
 **/

public class IPlistNCARatesV1_Resp_IB_v1 extends Base_IB {
	public IPlistNCARatesV1Response IPlistNCARatesV1Response;
	/**
	 * @description       : response bean
	 * @author            : Saurabh Pandey
	 **/
	public class Nbsapdpo {
		public Integer reasonCode;
		public Integer returnCode;
		public String serviceVersion;
	}
	/**
	 * @description       : response bean
	 * @author            : Saurabh Pandey
	 **/
	public class IPlistNCARatesV1Response {
		public Ipb100o ipb100o;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
	}
	/**
	 * @description       : response bean
	 * @author            : Saurabh Pandey
	 **/
	public class Nbsmsgo3 {
		public Integer nbrUserErrs;
		public Integer nbrUserMsgs;
		public String version;
	}
	/**
	 * @description       : response bean
	 * @author            : Saurabh Pandey
	 **/
	public class Ipb100o {
		public String ncaMaxfeeCfErr;
		public Integer ncaMaxfeeCfMaxsf;
		public String ncaMaxfeeMaErr;
		public Integer ncaMaxfeeMaMaxsf;
		public String ncaMaxfeeOcaErr;
		public Integer ncaMaxfeeOcaMaxsf;
		public String ncaMaxfeeStctErr;
		public Integer ncaMaxfeeStctMaxsf;
		public String ncaMaxfeeUctErr;
		public Integer ncaMaxfeeUctMaxsf;
		public String ncaMaxifeeCfErr;
		public Double ncaMaxifeeCfFirst;
		public Double ncaMaxifeeCfMax;
		public Double ncaMaxifeeCfNext;
		public Integer ncaMaxifeeCfPerc;
		public String ncaMaxifeeMaErr;
		public Integer ncaMaxifeeMaFirst;
		public Double ncaMaxifeeMaMax;
		public Double ncaMaxifeeMaNext;
		public Integer ncaMaxifeeMaPerc;
		public String ncaMaxifeeOcaErr;
		public Double ncaMaxifeeOcaFirst;
		public Double ncaMaxifeeOcaMax;
		public Double ncaMaxifeeOcaNext;
		public Integer ncaMaxifeeOcaPerc;
		public String ncaMaxifeeStctErr;
		public Double ncaMaxifeeStctFirst;
		public Double ncaMaxifeeStctMax;
		public Double ncaMaxifeeStctNext;
		public Integer ncaMaxifeeStctPerc;
		public String ncaMaxifeeUctErr;
		public Double ncaMaxifeeUctFirst;
		public Double ncaMaxifeeUctMax;
		public Double ncaMaxifeeUctNext;
		public Integer ncaMaxifeeUctPerc;
		public String ncaMaxrateCfErr;
		public Double ncaMaxrateCfMaxdr;
		public String ncaMaxrateMaErr;
		public Integer ncaMaxrateMaMaxdr;
		public String ncaMaxrateOcaErr;
		public Integer ncaMaxrateOcaMaxdr;
		public String ncaMaxrateStctErr;
		public Integer ncaMaxrateStctMaxdr;
		public String ncaMaxrateUctErr;
		public Double ncaMaxrateUctMaxdr;
		public Double primeRate;
		public String primeRateErr;
		public Integer repurchaseRate;
		public String repurchaseRateErr;
	}

	/*
     public static IPlistNCARatesV1_Resp_IB_v1 dummyResponse(){
        
        IPlistNCARatesV1_Resp_IB_v1 responseBean = new IPlistNCARatesV1_Resp_IB_v1();
        IPlistNCARatesV1_Resp_IB_v1.IPlistNCARatesV1Response IPlistNCARatesV1Response = new IPlistNCARatesV1_Resp_IB_v1.IPlistNCARatesV1Response();
        IPlistNCARatesV1_Resp_IB_v1.ipb100o  ipb100o =  new IPlistNCARatesV1_Resp_IB_v1.ipb100o();
        IPlistNCARatesV1_Resp_IB_v1.nbsapdpo  nbsapdpo =  new IPlistNCARatesV1_Resp_IB_v1.nbsapdpo();
        IPlistNCARatesV1_Resp_IB_v1.nbsmsgo3  nbsmsgo3 = new IPlistNCARatesV1_Resp_IB_v1.nbsmsgo3();
        
        responseBean.status ='';
        responseBean.statusCode = 200;
        responseBean.message = '';
        
        nbsapdpo.reasonCode = 0;
        nbsapdpo.returnCode = 0;
        nbsapdpo.serviceVersion = 'BUSO001';
        
        nbsmsgo3.version = 'MSG3001';
        nbsmsgo3.nbrUserErrs = 0;
        nbsmsgo3.nbrUserMsgs = 0;
         
         
         ipb100o.repurchaseRateErr = '0000 - SUCCESS';
         ipb100o.repurchaseRate = 7;
         ipb100o.primeRateErr = '0000 - SUCCESS';
         ipb100o.primeRate = 6.25;
         ipb100o.ncaMaxrateUctMaxdr = 27.75;
         ipb100o.ncaMaxrateUctErr = '0000 - SUCCESS';
         ipb100o.ncaMaxrateStctMaxdr = 60;
         ipb100o.ncaMaxrateStctErr = '0000 - SUCCESS';
         ipb100o.ncaMaxrateOcaMaxdr= 21;
         ipb100o.ncaMaxrateOcaErr = '0000 - SUCCESS';
         ipb100o.ncaMaxrateMaMaxdr = 19;
         ipb100o.ncaMaxrateMaErr = '0000 - SUCCESS';
         ipb100o.ncaMaxrateCfMaxdr = 0.75;
         ipb100o.ncaMaxrateCfErr = '0000 - SUCCESS';
         ipb100o.ncaMaxifeeUctPerc = 1000;
         ipb100o.ncaMaxifeeUctNext = 11.5;
         ipb100o.ncaMaxifeeUctMax = 6040.5;
         ipb100o.ncaMaxifeeUctFirst = 189.75;
         ipb100o.ncaMaxifeeUctErr = '0000 - SUCCESS';
         ipb100o.ncaMaxifeeStctPerc = 1000;
         ipb100o.ncaMaxifeeStctNext = 11.5;
         ipb100o.ncaMaxifeeStctMax = 1207.5;
         ipb100o.ncaMaxifeeStctFirst = 189.75;
         ipb100o.ncaMaxifeeStctErr = '0000 - SUCCESS';
         ipb100o.ncaMaxifeeOcaPerc = 1000;
         ipb100o.ncaMaxifeeOcaNext = 11.5;
         ipb100o.ncaMaxifeeOcaMax =1207.5;
         ipb100o.ncaMaxifeeOcaFirst = 189.75;
         ipb100o.ncaMaxifeeOcaErr = '0000 - SUCCESS';
         ipb100o.ncaMaxifeeMaPerc = 10000;
         ipb100o.ncaMaxifeeMaNext = 11.5;
         ipb100o.ncaMaxifeeMaMax =6037.5;
         ipb100o.ncaMaxifeeMaFirst = 1265;
         ipb100o.ncaMaxifeeMaErr = '0000 - SUCCESS';
         ipb100o.ncaMaxifeeCfPerc = 1000;
         ipb100o.ncaMaxifeeCfNext = 11.5;
         ipb100o.ncaMaxifeeCfMax = 6050.5;
         ipb100o.ncaMaxifeeCfFirst = 189.75;
         ipb100o.ncaMaxifeeCfErr = '0000 - SUCCESS';
         ipb100o.ncaMaxfeeUctMaxsf = 69;
         ipb100o.ncaMaxfeeUctErr = '0000 - SUCCESS';
         ipb100o.ncaMaxfeeStctMaxsf = 69;
         ipb100o.ncaMaxfeeStctErr ='0000 - SUCCESS';
         ipb100o.ncaMaxfeeOcaMaxsf = 69;
         ipb100o.ncaMaxfeeOcaErr = '0000 - SUCCESS';
         ipb100o.ncaMaxfeeMaMaxsf = 69;
         ipb100o.ncaMaxfeeMaErr = '0000 - SUCCESS';
         ipb100o.ncaMaxfeeCfMaxsf = 69;
         ipb100o.ncaMaxfeeCfErr = '0000 - SUCCESS';
         
         IPlistNCARatesV1Response.ipb100o=ipb100o;
         IPlistNCARatesV1Response.nbsapdpo=nbsapdpo;
         IPlistNCARatesV1Response.nbsmsgo3=nbsmsgo3;
         responseBean.IPlistNCARatesV1Response=IPlistNCARatesV1Response;
         
        return responseBean;
    }  
    */
}