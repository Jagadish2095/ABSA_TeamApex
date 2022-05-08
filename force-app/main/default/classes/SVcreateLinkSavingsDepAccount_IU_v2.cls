public class SVcreateLinkSavingsDepAccount_IU_v2 {
    
    public static SVcreateLinkSavingsDepAccount_Req_IB_v2 mapRequestdFields(String oppId, String oppProductId, String srcOfFnds1, String srcOfFnds2, String srcOfFnds3, String srcOfFnds4, String srcOfFnds5, String rbaEddRating){ //Case casemap,User usermap,String accNum,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){
                                                                                
        User currentUser = [SELECT Id,SiteCode__c, Teller_Operator_Code__c,Supervisor__c,EmployeeNumber FROM USER WHERE Id =: Userinfo.getUserId()];
        Opportunity opp = [SELECT Id,Site__r.Site_Code__c, Account.CIF__c, (select Id,Product2.ProductCode from OpportunitylineItems Where Id=: oppProductId) FROM Opportunity Where Id=: oppId];
        OpportunitylineItem oli= [select Id,Product2.ProductCode from OpportunitylineItem Where Id=: oppProductId] ;
        SVcreateLinkSavingsDepAccount_Req_IB_v2 requestBean = new SVcreateLinkSavingsDepAccount_Req_IB_v2();
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsapdpi nbsapdpi = new SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsapdpi();
        nbsapdpi.application = 'BDP';
        nbsapdpi.channel = 'BDP';
        nbsapdpi.trace = 'N';
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.finalMsgId msgIdClsObj = new SVcreateLinkSavingsDepAccount_Req_IB_v2.finalMsgId();
        msgIdClsObj.finalMsgClass = '';
        msgIdClsObj.finalMsgCode = '';
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsmsgi nbsmsgi = new SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsmsgi();
        nbsmsgi.finalMsgId = msgIdClsObj;
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'BDP';
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.svpp15i svpp15i = new SVcreateLinkSavingsDepAccount_Req_IB_v2.svpp15i();
        svpp15i.marketersCode = currentUser.EmployeeNumber;//'9117669'
        svpp15i.agencyCode = '0';
        svpp15i.effectiveDate = (''+system.today()).substring(0,10).replace('-','');
        svpp15i.tellerCode = currentUser.Teller_Operator_Code__c;//'878'
        svpp15i.versionNbr = '0';
        svpp15i.supervisorCode =currentUser.Supervisor__c;//'0'; 
        svpp15i.productCode = oli.Product2.ProductCode;//'09060'
        svpp15i.noticePeriod = '24';
        svpp15i.brandCode = 'ABS';
        svpp15i.withdrwlPerc = '10';
        svpp15i.tranSiteType = '034';
        svpp15i.channelInd = 'B';
        svpp15i.tranSiteCode = System.Label.ElectronicSiteForAccount;//'878'
        svpp15i.srcOfFnds1 = srcOfFnds1;//'20'
        svpp15i.acctSiteType = '034';
        svpp15i.srcOfFnds2 = srcOfFnds2;//''
        svpp15i.acctSiteCode = System.Label.ElectronicSiteForAccount;//'8474'
        svpp15i.srcOfFnds3 = srcOfFnds3;//;
        svpp15i.clientCode = opp.Account.CIF__c;//'PAULAJ 001'
        svpp15i.srcOfFnds4 = srcOfFnds4;//;
        svpp15i.rateOption = '';
        svpp15i.crpCode = '';
        svpp15i.investTerm = '10';
        svpp15i.freqCode = '0';
        svpp15i.investAmount = '10000';
        svpp15i.rbaEddRating = rbaEddRating;//'L'
        svpp15i.srcOfFnds5 = srcOfFnds5;
        
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.SVcreateLinkSavingsNoticeDepAccountV6 v6Obj = new SVcreateLinkSavingsDepAccount_Req_IB_v2.SVcreateLinkSavingsNoticeDepAccountV6();
        v6Obj.nbsapdpi = nbsapdpi;
        v6Obj.nbsmsgi = nbsmsgi;
        v6Obj.svpp15i = svpp15i;
        
        
        requestBean.SVcreateLinkSavingsNoticeDepAccountV6 = v6Obj;
        return requestBean;
                                                                            }
}