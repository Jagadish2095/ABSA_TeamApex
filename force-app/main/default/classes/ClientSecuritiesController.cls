/* 
* Controller for ClientPrductView Component
*  @author Muvhuso Nekhubvi:Absa
*  @since  27/02/2020
* 
*/
public class ClientSecuritiesController {
    
    /*
    * Return the client product view 
    * based on client CIF number 
    * 
    * @param String accountId
    * @return String
    */
    @AuraEnabled
    public static String getSuretyships(String accountId){
        String clientCode;
        String errorMessage = '';
        List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable> bondsWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
        
        if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvSuretyshipsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSuretyshipsV1_IH_v1.sMgetAsvSuretyshipsV1(accounts[0].CIF__c);
                
                sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSuretyshipsV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvSuretyshipsV1_Resp_IB_v1.SMgetASVSuretyshipsV1Response wrapper = responseBean.SMgetASVSuretyshipsV1Response;
                    
                    List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable> cls_smn152i = wrapper.Smn152o.suretyTable;
                    
                    System.debug(LoggingLevel.FINE,'Surety Types' + cls_smn152i);
                    
                    bondsWrapperList = new  List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable>();
                    
                    for(sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable suretyWrObj : cls_smn152i){
                        
                        bondsWrapperList.add(suretyWrObj);
                    }
                    
                    return JSON.serialize(bondsWrapperList);	
                }
             }
            }
            
        return null;
     
    }
    
    @AuraEnabled
    public static string getSecurityBonds(String accountId){
        
        String clientCode;
        String errorMessage = '';
        List<sMgetAsVbondsV1_Resp_IB_v1.BondTable> bondsWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
        
        if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsVbondsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsVbondsV1_IH_v1.sMgetAsVbondsV1(accounts[0].CIF__c);
                
                sMgetAsVbondsV1_Resp_IB_v1 responseBean = (new List<sMgetAsVbondsV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsVbondsV1_Resp_IB_v1.sMgetAsVbondsV1Response wrapper = responseBean.sMgetAsVbondsV1Response;
                    List<sMgetAsVbondsV1_Resp_IB_v1.BondTable> cls_Smn145o = wrapper.Smn145o.bondTable;
                    
                    System.debug(LoggingLevel.FINE,'Bonds Types' + cls_Smn145o);
                    
                    bondsWrapperList = new  List<sMgetAsVbondsV1_Resp_IB_v1.BondTable>();
                    
                    for(sMgetAsVbondsV1_Resp_IB_v1.BondTable bondsWrObj : cls_Smn145o){
                        bondsWrapperList.add(bondsWrObj);
                    }
                    
                    return JSON.serialize(bondsWrapperList);	
                }
            }
        }    
        
        return null;
    }
    
    
    @AuraEnabled
     public static String getCreditLifePolicy(String accountId){
        String clientCode;
        String errorMessage = '';
        List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable> bondsWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCreditLifePolicyV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCreditLifePolicyV1_IH_v1.sMgetAsvCreditLifePolicyV1(accounts[0].CIF__c);
                
                sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCreditLifePolicyV1_Resp_IB_v1.SMgetASVcreditLifePoliciesV1Response wrapper = responseBean.SMgetASVcreditLifePoliciesV1Response;
                    
                    List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable> cls_smn151o = wrapper.Smn151o.ClTable;
                    
                    System.debug(LoggingLevel.FINE,'Policy Types' + cls_smn151o);
                    
                    bondsWrapperList = new  List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable>();
                    
                    for(sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable creditLifeWrObj : cls_smn151o){
                        
                        bondsWrapperList.add(creditLifeWrObj);
                    }
                    
                    return JSON.serialize(bondsWrapperList);
                    
                }
            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getCessionofLinkLifePolicy(String accountId){
        String clientCode;
        String errorMessage = '';
        List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table> cessionsWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPLinkedV1_IH_v1.sMgetAsvCessionOfLPLinkedV1(accounts[0].CIF__c);
               
                sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.SMgetASVCessionOfLifePoliciesLinkedV1Response wrapper = responseBean.SMgetASVCessionOfLifePoliciesLinkedV1Response;
                    
                    List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table> cls_smp232eo = wrapper.smp332eo.Table;
                    
                    System.debug(LoggingLevel.FINE,'Policy Types' + cls_smp232eo);
                    
                    cessionsWrapperList = new  List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table>();
                    
                    for(sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table cessionOfPolicyLinkedWrObj : cls_smp232eo){
                        
                        cessionsWrapperList.add(cessionOfPolicyLinkedWrObj);
                    }
                    
                    return JSON.serialize(cessionsWrapperList);
                    
                }
            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getCessionofNoLinkLifePolicy(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table> cessionsNoLinkWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPNoLinkV1_IH_v1.sMgetAsvCessionOfLPNoLinkV1(accounts[0].CIF__c);
               
                sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.SMgetASVCessionOfLifePoliciesNonLinkV1Response wrapper = responseBean.SMgetASVCessionOfLifePoliciesNonLinkV1Response;
                    
                    List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table> cls_smp232eo = wrapper.smp232eo.Table;
                    
                    System.debug(LoggingLevel.FINE,'Policy Types' + cls_smp232eo);
                    
                    cessionsNoLinkWrapperList = new  List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table>();
                    
                    for(sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table cessionOfPolicyLinkedWrObj : cls_smp232eo){
                        
                        cessionsNoLinkWrapperList.add(cessionOfPolicyLinkedWrObj);
                    }
                    
                    return JSON.serialize(cessionsNoLinkWrapperList);
                    
                }
            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getCessionofDebtors(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table> cessionofDebtorsWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfDebtorsV1_IH_v1.sMgetAsvCessionOfDebtorsV1(accounts[0].CIF__c);
               
                sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.SMgetASVCessionOfDebtorsV1Response wrapper = responseBean.SMgetASVCessionOfDebtorsV1Response;
                    
                    List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table> cls_smp170eo = wrapper.smp170eo.Table; 
                    
                    System.debug(LoggingLevel.FINE,'Cession Debtors Types' + cls_smp170eo);
                     
                    cessionofDebtorsWrapperList = new  List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table>();
                    
                    for(sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table cessionofDebtorsWrObj : cls_smp170eo){
                        
                        cessionofDebtorsWrapperList.add(cessionofDebtorsWrObj);
                    }
                    
                    return JSON.serialize(cessionofDebtorsWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getCessionofGeneralpledges(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table> cessionOfPledgeaWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfPledgesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfPledgesV1_IH_v1.sMgetAsvCessionOfPledgesV1(accounts[0].CIF__c);
               
                sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfPledgesV1_Resp_IB_v1.SMgetASVCessionOfGeneralPledgesV1Response wrapper = responseBean.SMgetASVCessionOfGeneralPledgesV1Response;
                    
                    List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table> cls_smp149eo = wrapper.Smp149eo.table; 
                    
                    System.debug(LoggingLevel.FINE,'Cession Debtors Types' + cls_smp149eo);
                     
                    cessionOfPledgeaWrapperList = new  List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table>();
                    
                    for(sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table cessionofPledgesWrObj : cls_smp149eo){
                        
                        cessionOfPledgeaWrapperList.add(cessionofPledgesWrObj);
                    }
                    
                    return JSON.serialize(cessionOfPledgeaWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getCessionofInternalInvestments(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable> cessionOfInternalInvestmentWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfInvstmntV1_IH_v1.sMgetAsvCessionOfInvstmntV1(accounts[0].CIF__c);
               
                sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.SMgetASVCessionOfInternalInvestmentsV1Response wrapper = responseBean.SMgetASVCessionOfInternalInvestmentsV1Response;
                    
                    List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable> cls_smn146o = wrapper.Smn146o.Smn146oTable; 
                    
                    System.debug(LoggingLevel.FINE,'Cession Debtors Types' + cls_smn146o);
                     
                    cessionOfInternalInvestmentWrapperList = new  List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable>();
                    
                    for(sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable cessionofInternalInvestmentWrObj : cls_smn146o){
                        
                        cessionOfInternalInvestmentWrapperList.add(cessionofInternalInvestmentWrObj);
                    }
                    
                    return JSON.serialize(cessionOfInternalInvestmentWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getCessionOfSchemes(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table> cessionOfSchemesWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSchemesV1_IH_v1.sMgetAsvCessionOfSchemesV1(accounts[0].CIF__c);
               
                sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfSchemesV1_Resp_IB_v1.SMgetASVCessionOfSchemesV1Response wrapper = responseBean.SMgetASVCessionOfSchemesV1Response;
                    
                    List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table> cls_smp135eo = wrapper.Smp135eo.Table; 
                    
                    System.debug(LoggingLevel.FINE,'Cession Debtors Types' + cls_smp135eo);
                     
                    cessionOfSchemesWrapperList = new  List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table>();
                    
                    for(sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table cessionOfSchemesWrapperObj : cls_smp135eo){
                        
                        cessionOfSchemesWrapperList.add(cessionOfSchemesWrapperObj);
                    }
                    
                    return JSON.serialize(cessionOfSchemesWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getDematShares(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl> dematSharesWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvDematSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvDematSharesV1_IH_v1.sMgetAsvDematSharesV1(accounts[0].CIF__c);
               
                sMgetAsvDematSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvDematSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvDematSharesV1_Resp_IB_v1.SMgetASVDematerializedSharesV1Response wrapper = responseBean.SMgetASVDematerializedSharesV1Response;
                    
                    List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl> cls_smn336o = wrapper.Smn336o.OutputTbl; 
                    
                    System.debug(LoggingLevel.FINE,'Demat Share Types' + cls_smn336o);
                     
                    dematSharesWrapperList = new  List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl>();
                    
                    for(sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl dematSharesWrapperObj : cls_smn336o){
                        
                        dematSharesWrapperList.add(dematSharesWrapperObj);
                    }
                    
                    return JSON.serialize(dematSharesWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getAsvLettersV1(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable> lettesTableWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvLettersV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvLettersV1_IH_v1.sMgetAsvLettersV1(accounts[0].CIF__c);
               
                sMgetAsvLettersV1_Resp_IB_v1 responseBean = (new List<sMgetAsvLettersV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvLettersV1_Resp_IB_v1.SMgetASVLettersV1Response wrapper = responseBean.SMgetASVLettersV1Response;
                    
                    List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable> cls_smn140o = wrapper.Smn140o.LettersTable; 
                    
                    System.debug(LoggingLevel.FINE,'Letters Types' + cls_smn140o);
                     
                    lettesTableWrapperList = new  List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable>();
                    
                    for(sMgetAsvLettersV1_Resp_IB_v1.LettersTable lettersTableWrapperObj : cls_smn140o){
                        
                        lettesTableWrapperList.add(lettersTableWrapperObj);
                    }
                    
                    return JSON.serialize(lettesTableWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getAsvSecurityAndHolds(String accountId){
        String clientCode;
        String errorMessage = '';
        
        sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.smp155eo cls_smp155eo = new sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.smp155eo();
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSecurityAndHoldsV1_IH_v1.sMgetAsvSecurityAndHoldsV1(accounts[0].CIF__c);
               
                sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.SMgetASVOutstandingSecurityAndHoldsV1Response wrapper = responseBean.SMgetASVOutstandingSecurityAndHoldsV1Response;
                    
                    cls_smp155eo = wrapper.smp155eo;
                    
                    System.debug(LoggingLevel.FINE,'Holds' + cls_smp155eo);
                    
                    return JSON.serialize(cls_smp155eo);
                 
                    
                }

            }
         }
         
        return null;
     }
    
    @AuraEnabled
     public static String getAsvCessionOfShares(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> cessionOfSharesWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSharesV1_IH_v1.sMgetAsvCessionOfSharesV1(accounts[0].CIF__c);
               
                sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfSharesV1_Resp_IB_v1.SMgetASVCessionOfSharesV1Response wrapper = responseBean.SMgetASVCessionOfSharesV1Response;
                    
                    List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> cls_smn136o = wrapper.smn136o.OutputTbl; 
                    
                    System.debug(LoggingLevel.FINE,'Cession of Shares Types' + cls_smn136o);
                     
                    cessionOfSharesWrapperList = new  List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl>();
                    
                    for(sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl cessionofShareWrapperObj : cls_smn136o){
                        
                        cessionOfSharesWrapperList.add(cessionofShareWrapperObj);
                    }
                    
                    return JSON.serialize(cessionOfSharesWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
     @AuraEnabled
     public static String getAsvCessionOfPledges(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> cessionOfSharesWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSharesV1_IH_v1.sMgetAsvCessionOfSharesV1(accounts[0].CIF__c);
               
                sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfSharesV1_Resp_IB_v1.SMgetASVCessionOfSharesV1Response wrapper = responseBean.SMgetASVCessionOfSharesV1Response;
                    
                    List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> cls_smn136o = wrapper.smn136o.OutputTbl; 
                    
                    System.debug(LoggingLevel.FINE,'Cession of Shares Types' + cls_smn136o);
                     
                    cessionOfSharesWrapperList = new  List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl>();
                    
                    for(sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl cessionofShareWrapperObj : cls_smn136o){
                        
                        cessionOfSharesWrapperList.add(cessionofShareWrapperObj);
                    }
                    
                    return JSON.serialize(cessionOfSharesWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
     @AuraEnabled
     public static String getASVCessionOfExternalInvestmentsV1(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table> cessionOfOfExtInvWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfExtInv_IH_v1.getAsvCessionOfExtInvestment(accounts[0].CIF__c);
               
                sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfExtInv_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvCessionOfExtInv_Resp_IB_v1.SMgetASVCessionOfExternalInvestmentsV1Response wrapper = responseBean.SMgetASVCessionOfExternalInvestmentsV1Response;
                    
                    List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table> cls_smp147eo = wrapper.Smp147eo.Table; 
                    
                    System.debug(LoggingLevel.FINE,'Cession of External Investments' + cls_smp147eo);
                     
                    cessionOfOfExtInvWrapperList = new  List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table>();
                    
                    for(sMgetAsvCessionOfExtInv_Resp_IB_v1.Table cessionoFExternalInvestWrapperObj : cls_smp147eo){
                        
                        cessionOfOfExtInvWrapperList.add(cessionoFExternalInvestWrapperObj);
                    }
                    
                    return JSON.serialize(cessionOfOfExtInvWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
     @AuraEnabled
     public static String getASVGeneralCessionsV1(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable> cessionOfGeneralCessionsWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<sMgetAsvGeneralCessionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvGeneralCessionsV1_IH_v1.sMgetAsvGeneralCessionsV1(accounts[0].CIF__c);
               
                sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvGeneralCessionsV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    sMgetAsvGeneralCessionsV1_Resp_IB_v1.SMgetASVGeneralCessionsV1Response wrapper = responseBean.SMgetASVGeneralCessionsV1Response;
                    
                    List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable> cls_sms148o = wrapper.Sms148o.GcessTable; 
                    
                    System.debug(LoggingLevel.FINE,'General Cession' + cls_sms148o);
                     
                    cessionOfGeneralCessionsWrapperList = new  List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable>();
                    
                    for(sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable cessionofGeneralCessionsWrapperObj : cls_sms148o){
                        
                        cessionOfGeneralCessionsWrapperList.add(cessionofGeneralCessionsWrapperObj);
                    }
                    
                    return JSON.serialize(cessionOfGeneralCessionsWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
     @AuraEnabled
     public static String getASVCessionOfFireShortTermInsuranceV1(String accountId){
        String clientCode;
        String errorMessage = '';
        
        List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table> cessionOfFireShortWrapperList;
        
        //call to webservice by account's CIF Number 
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
         
         if(accounts.size() > 0){
        
            if( String.isNotBlank(accounts[0].CIF__c) ){
                
                Map<SMgetASVCessionOfFireShortV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfFireShortV1_IH_v1.getASVCessionOfFireShortV1(accounts[0].CIF__c);
               
                SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfFireShortV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                    
                    SMgetASVCessionOfFireShortV1_Resp_IB_v1.SMgetASVCessionOfFireShortTermInsuranceV1Response wrapper = responseBean.SMgetASVCessionOfFireShortTermInsuranceV1Response;
                    
                    List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table> cls_smp132eo = wrapper.smp132eo.Table; 
                    
                    System.debug(LoggingLevel.FINE,'Cession of fire short' + cls_smp132eo);
                     
                    cessionOfFireShortWrapperList = new  List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table>();
                    
                    for(SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table cessionofFireShortWrapperObj : cls_smp132eo){
                        
                        cessionOfFireShortWrapperList.add(cessionofFireShortWrapperObj);
                    }
                    
                    return JSON.serialize(cessionOfFireShortWrapperList);
                 
                    
                }

            }
         }
         
        return null;
     }
    
    
}