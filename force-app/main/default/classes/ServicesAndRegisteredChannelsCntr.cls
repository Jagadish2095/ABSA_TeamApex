/**
 * @description Value Services And Registered Channels Controller
 * @author Humbelani Denge
 * @created 2020-11-03
 * @updated Danie Booysen. 2021-04-26
 */
public class ServicesAndRegisteredChannelsCntr {
    /**
	 * @author
	 * @description Retrieves client details from CIF
	 * @param  clientCodeP
	 * @param  accNumberP
	 * @param  siteCodeP
	 * @return Map<String, Boolean>: Key as indicator string, Value as indicator boolean
	 */
    @AuraEnabled
    public static Map<String, Boolean> getClientDetails(String clientCodeP, String accNumberP, String siteCodeP) {
        GetClientDetailsCIF_Resp_IB_v1 responseBean = GetClientDetailsCIF_IH_v1.getClientDetails(clientCodeP, accNumberP, siteCodeP);
        Map<String, boolean> response = new Map<String, Boolean>{
            'isResponseSuccess' => responseBean.statusCode == 200 ? true : false,
            'notifyMeFlag' =>  Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.notifyMeIndicator,'Inbound')=='true' ? true :false,
            'internetBankingFlag' => Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.internetBankinInd,'Inbound')=='true' ? true :false,
            'absaRewardFlag' => Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.absaRewardIndctor,'Inbound')=='true' ? true :false,
            'telebankingFlag' => Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.telebankIndicator,'Inbound')=='true' ? true :false,
            'cellphoneBankingFlag' => Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.cellphoneBankInd,'Inbound') =='true' ? true :false,
			'pingItWalletFlag' => Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.pingitWallet,'Inbound') =='true' ? true :false,
			'pingitReceiveFlag' => Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.pingitReceive,'Inbound') =='true' ? true :false,
			'unclaimedFundsFlag' => Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.unclaimedFundsInd,'Inbound') =='true' ? true :false,
			'securityIndicatorFlag' => Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Boolean Value',responseBean.securityIndicator,'Inbound') =='true' ? true :false
        };
        return response;
    }
}