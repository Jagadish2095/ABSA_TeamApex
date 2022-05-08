/* Creates a Request Bean from the Account 
    * @param: Account object
    * @return: SVChangeAccountDomcileBranch_Req_IB_v1 bean object
    * */
public class SVChangeAccountDomcileBranch_IU_v1 {
    public static SVChangeAccountDomcileBranch_Req_IB_v1 mapRequestFields(String policyNumber,String branchsitereg){
        SVChangeAccountDomcileBranch_Req_IB_v1 requestbean = new SVChangeAccountDomcileBranch_Req_IB_v1();
                    SVChangeAccountDomcileBranch_Req_IB_v1.Nbsapdpi Nbsapdpibean = new SVChangeAccountDomcileBranch_Req_IB_v1.Nbsapdpi();
                    SVChangeAccountDomcileBranch_Req_IB_v1.Nbsmsgi Nbsmsgibean = new SVChangeAccountDomcileBranch_Req_IB_v1.Nbsmsgi();
                    SVChangeAccountDomcileBranch_Req_IB_v1.FinalMsgId FinalMsgIdbean = new SVChangeAccountDomcileBranch_Req_IB_v1.FinalMsgId();
                    SVChangeAccountDomcileBranch_Req_IB_v1.Svpp44i Svpp44ibean = new SVChangeAccountDomcileBranch_Req_IB_v1.Svpp44i();
                    SVChangeAccountDomcileBranch_Req_IB_v1.SVchangeAccountDomcileBranchV1 SVchangeAccountDomcileBranchV1bean = new SVChangeAccountDomcileBranch_Req_IB_v1.SVchangeAccountDomcileBranchV1();
                    
                    //get the current user
                    User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

                    Nbsapdpibean.channel = 'BDP';
                    Nbsapdpibean.application = 'BDP';
                    Nbsapdpibean.trace = 'Y';
                    
                    FinalMsgIdbean.finalMsgClass = '';
                    FinalMsgIdbean.finalMsgCode = '';
                    Nbsmsgibean.msgLanguage = 'E';
                    Nbsmsgibean.msgTarget = 'STD';
                    Nbsmsgibean.finalMsgId = FinalMsgIdbean;
                    
                    Svpp44ibean.accountNumber = policyNumber;//'9051324101';
                    Svpp44ibean.newSiteCode = branchsitereg;//'8919';   // currentUser.SiteCode__c changing this to CMS branch Region site W-8053 by Diksha 11/30/2020
                    Svpp44ibean.chargeIndicator = 'N';
                    Svpp44ibean.savenotDepInd = 'S';
                    Svpp44ibean.divisionCode = 'ABS';
                    Svpp44ibean.workStation = '99';
                    Svpp44ibean.branchCode = System.Label.ElectronicSiteForAccount;//'8919';
                    Svpp44ibean.agencyCode = '034';
                    Svpp44ibean.agencySiteType = '035';
                    Svpp44ibean.tellerCode = '999999';
                    Svpp44ibean.supervisorCode = '999999';
                    Svpp44ibean.branchSiteType = '034';
                    
                    SVchangeAccountDomcileBranchV1bean.nbsapdpi = nbsapdpibean;
                    SVchangeAccountDomcileBranchV1bean.nbsmsgi = nbsmsgibean;
                    SVchangeAccountDomcileBranchV1bean.svpp44i = svpp44ibean;
                    requestbean.SVchangeAccountDomcileBranchV1 = SVchangeAccountDomcileBranchV1bean;
                    return requestbean;
    }    
}