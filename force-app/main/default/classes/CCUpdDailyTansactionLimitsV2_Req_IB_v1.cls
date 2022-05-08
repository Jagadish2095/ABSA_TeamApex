/*
 * Request Integration Bean for CCUpdDailyTansactionLimitsV2 Service
 * @author Willy Zuvana
 * @created 2020-11-11
 */
public class CCUpdDailyTansactionLimitsV2_Req_IB_v1 Extends Base_IB {

    public String channel;
	public String application;
	public String trace;
	public String msgLanguage;
	public String msgTarget;
	public String tellerCode;
	public String workStation;
	public String combiNbr;
	public String supervisor;
	public String branchCode;
	public String cardCshLim;
	public String cardTrfLim;
	public String cardPosLim;
	public String cardCntLim;
	public String cheqNomAcc;
	public String cheqApplNo;
	public String cheqCshLim;
	public String cheqTrfLim;
	public String cheqPosLim;
	public String savsNomAcc;
	public String savsApplNo;
	public String savsCshLim;
	public String savsTrfLim;
	public String savsPosLim;

  
    public static CCUpdDailyTansactionLimitsV2_Req_IB_v1 createDummyRequest(){
        CCUpdDailyTansactionLimitsV2_Req_IB_v1 requestBean = new CCUpdDailyTansactionLimitsV2_Req_IB_v1();
		
		requestBean.channel = 'BDP';
		requestBean.application = 'BDP';
		requestBean.trace = 'Y';
		requestBean.msgLanguage = 'E';
		requestBean.msgTarget = 'STD';
		requestBean.tellerCode = '1';
		requestBean.workStation = '1';
		requestBean.combiNbr = '04451470000037318';
		requestBean.supervisor = '1';
		requestBean.branchCode = '1';
		requestBean.cardCshLim = '1000';
		requestBean.cardTrfLim = '1000';
		requestBean.cardPosLim = '100';
		requestBean.cardCntLim = '100';
		requestBean.cheqNomAcc = '0';
		requestBean.cheqApplNo = '0';
		requestBean.cheqCshLim = '0';
		requestBean.cheqTrfLim = '0';
		requestBean.cheqPosLim = '0';
		requestBean.savsNomAcc = '0';
		requestBean.savsApplNo = '0';
		requestBean.savsCshLim = '0';
		requestBean.savsCshLim = '0';
		requestBean.savsTrfLim = '0';
		requestBean.savsPosLim = '0';

        return requestBean;
    }
}