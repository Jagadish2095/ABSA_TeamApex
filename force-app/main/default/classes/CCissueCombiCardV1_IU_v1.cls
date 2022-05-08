/**
* @description Integration Utility  Bean for CCissueCombiCardV1 Service
* @author Lulu Rankwe
* @created 19-03-2020
*/

public class CCissueCombiCardV1_IU_v1 {

    /**
	 * @description SMath: 06 June 2021: Callout method to issueCombiCard
	 * @param accountNo
     * @param issueBranch
     * @param persInd
     * @param brandNbr
     * @param autoLink
     * @param persName
     * @param persTitl
     * @param persInit
     * @param persSurn
     * @param delvBranch
     * @param tellerCode
     * @param supervisor
     * @param branchCode
     * @param sbuCode
     * @param clntCode
     * @param nomCheq
     * @param nomSavs
     * @param nomCred
     * @param cardNbr
	 * @return CCissueCombiCardV1_Req_IB_v1 
	 */  
    public static CCissueCombiCardV1_Req_IB_v1 mapRequestFields(String accountNo, String issueBranch,String persInd, String brandNbr,
                                                                String autoLink,String persName,String persTitl,String persInit,String persSurn,String delvBranch,
                                                                String tellerCode , String supervisor,String branchCode, String sbuCode,String clntCode, String nomCheq,String nomSavs, String nomCred, String cardNbr){
        CCissueCombiCardV1_Req_IB_v1 reqBean = new CCissueCombiCardV1_Req_IB_v1();
                                                                 
        reqBean.channel = 'BDP';
        reqBean.application = 'BDP';
        reqBean.trace ='Y';
	    reqBean.msgLanguage = 'E';
        reqBean.msgTarget = 'STD';
        reqBean.tellerCode = tellerCode;
        reqBean.workStation = '99';
        reqBean.supervisor = supervisor;
        reqBean.branchCode = branchCode;
        reqBean.consumerId = 'BDP';
        reqBean.cardType = 'C' ;
        reqBean.cardNbr = persInd == 'Y'? '0': accountNo;
        reqBean.clntCode = clntCode;
        reqBean.acctNbr = accountNo;
        reqBean.prodCode = '0';
        reqBean.brandNbr = brandNbr;
        reqBean.issueBranch = issueBranch;
        reqBean.sbuCode = sbuCode;                                                           
        reqBean.persInd = persInd;
        reqBean.persName = persName;
        reqBean.persTitl = persTitl;
        reqBean.persInit = persInit;
        reqBean.persSurn = persSurn;
        reqBean.idType ='0';
        reqBean.idNbr = '';
        reqBean.nomCheq = nomCheq;
        reqBean.nomSavs = nomSavs;
        reqBean.nomCred =  nomCred;
        reqBean.delvMethod = '' ;//'0';
        reqBean.delvBranch = delvBranch;
        reqBean.autoLink= autoLink;
        reqBean.blindInd= '0';
        reqBean.secClntCde ='';
       
        return reqBean;     
    }

}