/*
 * Request Integration Bean for MPScreateMASSAccountV2 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MPScreateMASSAccountV2_Req_IB_v1 extends Base_IB {

	public class Zbp004i {
		public String clientCode;
		public String tellerNo;
		public String casaRefNum;
		public String srcOfFnds1;
		public String srcOfFnds2;
		public String srcOfFnds3;
		public String srcOfFnds4;
		public String srcOfFnds5;
		public String refNum;
		public String action;
		public String prinBk;
		public String assocBk;
		public String mrchRelTyp;
		public String ctlAcct;
		public String mrchDescNm;
		public String mrchDescCty;
		public String contactNm;
		public String contactPhNbr;
		public String ddaAcctNbr;
		public String ddaTrNbr;
		public String costCtr;
		public String off;
		public String mrchCatgCd;
		public String mailCd;
		public String lang;
		public String ichgZipCode;
		public String nettSettInd;
		public String pymtDelaySend;
		public String markoffInd;
		public String cspId;
		public String mrchId2;
		public String mrchSurname2;
		public String mrchName2;
		public String mrchMi2;
		public String mrchId3;
		public String mrchSurname3;
		public String mrchName3;
		public String mrchMi3;
		public String feesDda;
		public String brchFee;
		public String adjustmentDda;
		public String brchAdj;
		public String chargebackDda;
		public String brchCgb;
		public String siteCd;
		public String stationFeeCd;
		public String stationWaiveInd;
		public String rtcInd;
		public String lvpInd;
		public String dccInd;
		public String cbInd;
		public String singleCr;
		public String cmbInd;
		public String csInd;
		public String tzpInd;
		public String electCommerceInd;
		public String grossBPerc;
		public String fraudReview;
		public String nonClsInd;
		public String minDisc;
		public String mrchTrade_addr1;
		public String mrchTrade_addr2;
		public String mrchTrade_addr3;
		public String mrchTrade_addr4;
	}

	public MPScreateMASSAccountV2 MPScreateMASSAccountV2;

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class MPScreateMASSAccountV2 {
		public Nbsapdpi nbsapdpi;
		public Zbp004i zbp004i;
	}

    public static MPScreateMASSAccountV2_Req_IB_v1 createDummyRequest() {
        MPScreateMASSAccountV2_Req_IB_v1 requestBean = new MPScreateMASSAccountV2_Req_IB_v1();
		requestBean.MPScreateMASSAccountV2 = new MPScreateMASSAccountV2_Req_IB_v1.MPScreateMASSAccountV2();
		requestBean.MPScreateMASSAccountV2.nbsapdpi = new MPScreateMASSAccountV2_Req_IB_v1.Nbsapdpi();
		requestBean.MPScreateMASSAccountV2.zbp004i = new MPScreateMASSAccountV2_Req_IB_v1.Zbp004i();

		requestBean.MPScreateMASSAccountV2.nbsapdpi.channel = 'mob';
		requestBean.MPScreateMASSAccountV2.nbsapdpi.application = 'mob';
		requestBean.MPScreateMASSAccountV2.nbsapdpi.trace = 'Y';

		requestBean.MPScreateMASSAccountV2.zbp004i.clientCode = 'REKZAG 001';
		requestBean.MPScreateMASSAccountV2.zbp004i.tellerNo = '1234567';
		requestBean.MPScreateMASSAccountV2.zbp004i.casaRefNum = '8888';
		requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds1 = '20';
		requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds2 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds3 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds4 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.srcOfFnds5 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.refNum = 'GN20202010378';
		requestBean.MPScreateMASSAccountV2.zbp004i.action = 'C';
		requestBean.MPScreateMASSAccountV2.zbp004i.prinBk = 'ABSA';
		requestBean.MPScreateMASSAccountV2.zbp004i.assocBk = '07';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchRelTyp = 'M';
		requestBean.MPScreateMASSAccountV2.zbp004i.ctlAcct = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchDescNm = 'Test1';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchDescCty = 'Randburg';
		requestBean.MPScreateMASSAccountV2.zbp004i.contactNm = 'BRAD NEESILY';
		requestBean.MPScreateMASSAccountV2.zbp004i.contactPhNbr = '0834624471';
		requestBean.MPScreateMASSAccountV2.zbp004i.ddaAcctNbr = '4047998101';
		requestBean.MPScreateMASSAccountV2.zbp004i.ddaTrNbr = '0000632005';
		requestBean.MPScreateMASSAccountV2.zbp004i.costCtr = '0000009760';
		requestBean.MPScreateMASSAccountV2.zbp004i.off = 'NGT01';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchCatgCd = '5411';
		requestBean.MPScreateMASSAccountV2.zbp004i.mailCd = 'EML';
		requestBean.MPScreateMASSAccountV2.zbp004i.lang = 'E';
		requestBean.MPScreateMASSAccountV2.zbp004i.ichgZipCode = '2000';
		requestBean.MPScreateMASSAccountV2.zbp004i.nettSettInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.pymtDelaySend = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.markoffInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.cspId = '0';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchId2 = '8009025171086';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchSurname2 = 'SINGH';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchName2 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchMi2 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchId3 = '0';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchSurname3 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchName3 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchMi3 = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.feesDda = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.brchFee = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.adjustmentDda = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.brchAdj = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.chargebackDda = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.brchCgb = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.siteCd = '009760';
		requestBean.MPScreateMASSAccountV2.zbp004i.stationFeeCd = 'TF1';
		requestBean.MPScreateMASSAccountV2.zbp004i.stationWaiveInd = 'Y';
		requestBean.MPScreateMASSAccountV2.zbp004i.rtcInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.lvpInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.dccInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.cbInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.singleCr = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.cmbInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.csInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.tzpInd = 'N';
		requestBean.MPScreateMASSAccountV2.zbp004i.electCommerceInd = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.grossBPerc = '0';
		requestBean.MPScreateMASSAccountV2.zbp004i.fraudReview = 'CRPH';
		requestBean.MPScreateMASSAccountV2.zbp004i.nonClsInd = '';
		requestBean.MPScreateMASSAccountV2.zbp004i.minDisc = '0';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchTrade_addr1 = '270 REPUBLIC ROAD';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchTrade_addr2 = 'RANDBURG';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchTrade_addr3 = 'Johannesburg';
		requestBean.MPScreateMASSAccountV2.zbp004i.mrchTrade_addr4 = 'Randburg';

        return requestBean;
    }
}