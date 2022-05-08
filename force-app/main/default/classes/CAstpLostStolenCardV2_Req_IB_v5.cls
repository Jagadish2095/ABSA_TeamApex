/**
* Apex Integration Request Bean class for CAstpLostStolenCardV2 Service
* @author  Madhava Palla : Absa
* @since   2019-09-10
*
**/
public class CAstpLostStolenCardV2_Req_IB_v5 extends Base_IB{
    public String channel;
    public String application;
    public String trace;
    public String msgLanguage;
    public String msgTarget;
    public String plasticNbr;
    public String scnAction;
    public String operatorId;
    public String visaFrdRsn;
    public String mciFrdTyp;
    public String tmsLs;
    public String lsRptdBy;
    public String lsHowRptdCd;
    public String lsRptRsnCd;
    public String lsDt;
    public String lsTmOfLoss;
    public String lsDtLstUsed;
    public String lsPlLstUsed;
    public String phnNbrPer;
    public String phnNbrBus;
    public String lsNbrCrdsMiss;
    public String distSiteCd;
    public String distReasCd;
    public String crdIsSgndInd;
    public String pinIsSafeInd;
    public String advcNoUseInd;
    public String circCd;
    public String whereLs;
    public String howLostLn1;
    public String pxiStatNew;
    public String pxiStatOld;
    public String axiXfrEffDt;
    public String axiXfrRsn;
    public String axiFrdCd;
    public String sof1;
    public String sof2;
    public String sof3;
    public String sof4;
    public String sof5;
    public String crdRep;
    public String siteCd;
    public String abnr;
    public String tellernr;
    
    public static CAstpLostStolenCardV2_Req_IB_v5 createDummyRequest() {
        CAstpLostStolenCardV2_Req_IB_v5 requestBean = new CAstpLostStolenCardV2_Req_IB_v5();
        
        requestBean.channel = 'Salesforce';
        requestBean.application = 'Salesforce';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.plasticNbr = '5544351000291012';
        requestBean.scnAction = 'ADD';
        requestBean.operatorId = 'BDP';
        requestBean.visaFrdRsn = '';
        requestBean.mciFrdTyp = '';
        requestBean.tmsLs = '1';
        requestBean.lsRptdBy = 'CLNT';
        requestBean.lsHowRptdCd = 'PHN';
        requestBean.lsRptRsnCd = 'STL';
        requestBean.lsDt = '20191015';
        requestBean.lsTmOfLoss = '1345';
        requestBean.lsDtLstUsed = '20191015';
        requestBean.lsPlLstUsed = 'PRETORIA';
        requestBean.phnNbrPer = '0829584624';
        requestBean.phnNbrBus = '0829584624';
        requestBean.lsNbrCrdsMiss = '1';
        requestBean.distSiteCd = '8461';
        requestBean.distReasCd = 'CB';
        requestBean.crdIsSgndInd = 'Y';
        requestBean.pinIsSafeInd = 'Y';
        requestBean.advcNoUseInd = 'Y';
        requestBean.circCd = 'SPC';
        requestBean.whereLs = 'PRETORIA';
        requestBean.howLostLn1 = 'SHOPPING';
        requestBean.pxiStatNew = 'L0P';
        requestBean.pxiStatOld = 'AAA';
        requestBean.axiXfrEffDt = '20191015';
        requestBean.axiXfrRsn = 'LST';
        requestBean.axiFrdCd = '0';
        requestBean.sof1 = '20';
        requestBean.sof2 = '';
        requestBean.sof3 = '';
        requestBean.sof4 = '';
        requestBean.sof5 = '';
        requestBean.crdRep = 'Y';
        requestBean.siteCd = '8461';
        requestBean.abnr = 'ABRM646';
        requestBean.tellernr = '999999';
        
        return requestBean;
    }
    
}