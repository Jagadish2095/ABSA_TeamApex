/**
 * @description       : Controller class for CommercialBureau aura component
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 06-29-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
 **/

public class CommercialBureauCtrl {
	/**
	 * @description Get Application_Profile__c records related to an opportunity
	 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-09
	 * @param opportunityId
	 * @return List<Map<String, Object>>
	 **/
	@AuraEnabled(Cacheable=false)
	public static List<Map<String, Object>> getApplicationProfiles(Id opportunityId) {
		List<Map<String, Object>> bureauData = new List<Map<String, Object>>();
		ApplicationProfileSelector applicationProfileSelector = new ApplicationProfileSelector();
		List<Application_Profile__c> applicationProfiles = applicationProfileSelector.getAppProfileBureauData(opportunityId);

		if (applicationProfiles != null && applicationProfiles.size() > 0) {
			List<Application_Profile__c> appProfilesCommercial = new List<Application_Profile__c>();

			Boolean isNullBureau = false;

			for (Application_Profile__c applicationProfile : applicationProfiles) {
				if (
					applicationProfile.Bureau_JSON_Response__c == null &&
					applicationProfile.PCCE_Id__c != null &&
					!checkIfCompany(applicationProfile.Account__r.Client_Type__c) &&
					applicationProfile.Account__r.Client_Type__c != null
				) {
					isNullBureau = true;
					appProfilesCommercial.add(applicationProfile);
				} else if (
					applicationProfile.Bureau_JSON_Response__c != null &&
					applicationProfile.PCCE_Id__c != null &&
					!checkIfCompany(applicationProfile.Account__r.Client_Type__c) &&
					applicationProfile.Account__r.Client_Type__c != null
				) {
					appProfilesCommercial.add(applicationProfile);
				} else if (
					applicationProfile.Bureau_JSON_Response__c == null &&
					applicationProfile.PCCE_Id__c == null &&
					!checkIfCompany(applicationProfile.Account__r.Client_Type__c) &&
					applicationProfile.Bureau_Report_1__c != null
				) {
					appProfilesCommercial.add(applicationProfile);
				}
			}

            PowerCurveController.setValidationFields(opportunityId, 'Commercial_Bureau_Captured', true);

			if (isNullBureau) {
				List<Application_Profile__c> updatedAppProfiles = getBureauData(appProfilesCommercial);

				if (updatedAppProfiles != null) {
					bureauData = changeBureauData(updatedAppProfiles);
					return bureauData;
				}
			} else {
				bureauData = changeBureauData(appProfilesCommercial);
				return bureauData;
			}
		}

		return null;
	}

	/**
	 * @description Web service call to get bureau data for Application Profiles
	 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-09
	 * @param applicationProfiles
	 * @return List<Application_Profile__c>
	 **/
	public static List<Application_Profile__c> getBureauData(List<Application_Profile__c> applicationProfiles) {
		if (applicationProfiles != null && applicationProfiles.size() > 0) {
			for (Application_Profile__c applicationProfile : applicationProfiles) {
				if (
					applicationProfile.Bureau_JSON_Response__c == null &&
					applicationProfile.PCCE_Id__c != null &&
					!checkIfCompany(applicationProfile.Account__r.Client_Type__c) &&
					applicationProfile.Account__r.Client_Type__c != null
				) {
					CommercialBureauEnquiry_Resp_IB_v1 responseBean = CommercialBureauEnquiry_IH_v1.commercialBureauEnquiry(applicationProfile.PCCE_Id__c);

					if (responseBean.statusCode == 200 && responseBean != null) {
						if (responseBean.Response != null) {
							if (responseBean.Response.ApplicationDV != null) {
								if (responseBean.Response.ApplicationDV.COMM != null) {
									applicationProfile.Bureau_JSON_Response__c = JSON.serialize(responseBean);
								}
							}
						}
					}
				}
			}

			saveBureauData(applicationProfiles);
		}

		return applicationProfiles;
	}

	/**
	 * @description Method to save Bureau data to Application Profile
	 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)| 2021-06-09
	 * @param applicationProfiles
	 **/
	private static void saveBureauData(List<Application_Profile__c> applicationProfiles) {
		try {
			update applicationProfiles;
		} catch (Exception exc) {
			system.debug('exception---' + exc.getLineNumber());
		}
	}

	/**
	 * @description Method to check whether account is warm body or not
	 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)| 2021-06-09
	 * @param entityType
	 * @return Boolean
	 **/
	private static Boolean checkIfCompany(String entityType) {
		if (entityType != null) {
			if (entityType.equalsIgnoreCase('STAFF') || entityType.equalsIgnoreCase('SOLE TRADER') || entityType.equalsIgnoreCase('INDIVIDUAL')) {
				return true;
			}
		}

		return false;
	}

	/**
	 * @description Method to change JSON response to a Map that is easily usable on the front end
	 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)| 2021-06-09
	 * @param applicationProfiles
	 * @return List<Map<String, Object>>
	 **/
	private static List<Map<String, Object>> changeBureauData(List<Application_Profile__c> applicationProfiles) {
		List<Map<String, Object>> bureauData = new List<Map<String, Object>>();

		for (Application_Profile__c applicationProfile : applicationProfiles) {
			if (applicationProfile.Bureau_JSON_Response__c != null) {
				CommercialBureauEnquiry_Resp_IB_v1 responseBean = (CommercialBureauEnquiry_Resp_IB_v1) JSON.deserialize(
					applicationProfile.Bureau_JSON_Response__c,
					CommercialBureauEnquiry_Resp_IB_v1.class
				);
				CommercialBureauEnquiry_Resp_IB_v1.cls_Response response = responseBean.Response;
				CommercialBureauEnquiry_Resp_IB_v1.cls_ApplicationDV applicationDv = response.ApplicationDV;
				CommercialBureauEnquiry_Resp_IB_v1.cls_COMM comm = applicationDv.COMM;
				CommercialBureauEnquiry_Resp_IB_v1.cls_ECOMDET ecomdet = comm.ECOMDET;
				List<CommercialBureauEnquiry_Resp_IB_v1.cls_ECOMDETJUD> ecomdetJud = comm.ECOMDETJUD;

				List<Map<String, Object>> judgementData = new List<Map<String, Object>>();

				if (ecomdetJud != null) {
					for (CommercialBureauEnquiry_Resp_IB_v1.cls_ECOMDETJUD judgement : ecomdetJud) {
						Map<String, Object> mapObj = new Map<String, Object>();
						mapObj.put('BURECOMDETJUDPLAINTIFF', judgement.BURECOMDETJUDPLAINTIFF);
						mapObj.put('BURECOMDETJUDCASENUMBER', judgement.BURECOMDETJUDCASENUMBER);
						mapObj.put('BURECOMDETJUDAMOUNT', judgement.BURECOMDETJUDAMOUNT);
						mapObj.put('BURECOMDETJUDDATE', judgement.BURECOMDETJUDDATE);
						mapObj.put('BURECOMDETJUDCOURT', judgement.BURECOMDETJUDCOURT);

						judgementData.add(mapObj);
					}
				}

				Map<String, Object> mapObj = new Map<String, Object>();

				mapObj.put('APPPCCEID', applicationDv.APPPCCEID);
				mapObj.put('CIFCODE', applicationProfile.Client_CIF_Code__c);
				mapObj.put('BUREAUREPORT', applicationProfile.Bureau_Report_1__c);
				mapObj.put('CALLTYPE', 'Experian');
				mapObj.put('BURCOMMINPKIMNUMBER', comm.BURCOMMINPKIMNUMBER);
				mapObj.put('BURCOMMINPBUSNAME', comm.BURCOMMINPBUSNAME);
				mapObj.put('BURCOMMINPREGNUMBER', comm.BURCOMMINPREGNUMBER);
				mapObj.put('BURCOMMINPVATNUMBER', comm.BURCOMMINPVATNUMBER);
				mapObj.put('BURECOMDATECALLED', ecomdet.BURECOMDATECALLED);
				mapObj.put('BURECOMOFFLINE', ecomdet.BURECOMOFFLINE);
				mapObj.put('BURECOMONREC', ecomdet.BURECOMONREC);
				mapObj.put('BURECOMSEARCHED', ecomdet.BURECOMSEARCHED);
				mapObj.put('BURECOMCOMPDETBUSNSTARTDATE', ecomdet.BURECOMCOMPDETBUSNSTARTDATE);
				mapObj.put('BURECOMCOMPDETTRADINGNAME', ecomdet.BURECOMCOMPDETTRADINGNAME);
				mapObj.put('BURECOMCOMPDETSTATUS', ecomdet.BURECOMCOMPDETSTATUS);
				mapObj.put('BURECOMCOMPDETMTHSINCEBUSSTARTDATE', ecomdet.BURECOMCOMPDETMTHSINCEBUSSTARTDATE);
				mapObj.put('BURECOMENRSUMJUDTOTL12M', ecomdet.BURECOMENRSUMJUDTOTL12M);
				mapObj.put('BURECOMENRSUMJUDHIGHAMNT', ecomdet.BURECOMENRSUMJUDHIGHAMNT);
				mapObj.put('BURECOMENRSUMJUDTOTVAL', ecomdet.BURECOMENRSUMJUDTOTVAL);
				mapObj.put('BURECOMENRSUMJUDVALL12M', ecomdet.BURECOMENRSUMJUDVALL12M);
				mapObj.put('BURECOMENRSUMJUDMTHSNCHIGH', ecomdet.BURECOMENRSUMJUDMTHSNCHIGH);
				mapObj.put('BURECOMENRSUMJUDLASTDATE', ecomdet.BURECOMENRSUMJUDLASTDATE);
				mapObj.put('BURECOMENRSUMJUDHIGHDATE', ecomdet.BURECOMENRSUMJUDHIGHDATE);
				mapObj.put('BURECOMENRSUMJUDMTHSNCLAST', ecomdet.BURECOMENRSUMJUDMTHSNCLAST);
				mapObj.put('BURECOMENRSUMJUDTOTEVER', ecomdet.BURECOMENRSUMJUDTOTEVER);
				mapObj.put('BURECOMENRSUMJUDPRESENT', ecomdet.BURECOMENRSUMJUDPRESENT);
				mapObj.put('BURECOMENRSUMNOTRBNDSTOTAL', ecomdet.BURECOMENRSUMNOTRBNDSTOTAL);
				mapObj.put('BURECOMENRSUMNOTRBNDSTOTVAL', ecomdet.BURECOMENRSUMNOTRBNDSTOTVAL);
				mapObj.put('BURECOMENRSUMNOTRBNDSDATESINCEHIGHAMNT', ecomdet.BURECOMENRSUMNOTRBNDSDATESINCEHIGHAMNT);
				mapObj.put('BURECOMENRSUMNOTRBNDSMNTHSINCEHIGHAMNT', ecomdet.BURECOMENRSUMNOTRBNDSMNTHSINCEHIGHAMNT);
				mapObj.put('BURECOMENRSUMNOTRBNDSDATEMRECHIGHAMNT', ecomdet.BURECOMENRSUMNOTRBNDSDATEMRECHIGHAMNT);
				mapObj.put('BURECOMENRSUMNOTRBNDSMNTHMRECHIGHAMNT', ecomdet.BURECOMENRSUMNOTRBNDSMNTHMRECHIGHAMNT);
				mapObj.put('BURECOMENRSUMNBONDPRESENT', ecomdet.BURECOMENRSUMNBONDPRESENT);
				mapObj.put('BURECOMDETKISAMNTOUTSTCURR', ecomdet.BURECOMDETKISAMNTOUTSTCURR);
				mapObj.put('BURECOMDETKISAMNTOUTST30D', ecomdet.BURECOMDETKISAMNTOUTST30D);
				mapObj.put('BURECOMDETKISAMNTOUTST60D', ecomdet.BURECOMDETKISAMNTOUTST60D);
				mapObj.put('BURECOMDETKISAMNTOUTST90D', ecomdet.BURECOMDETKISAMNTOUTST90D);
				mapObj.put('BURECOMDETKISAMNTOUTST120D', ecomdet.BURECOMDETKISAMNTOUTST120D);
				mapObj.put('BURECOMDETKISAMNTOUTST150D', ecomdet.BURECOMDETKISAMNTOUTST150D);
				mapObj.put('BURECOMDETKISTOTODAMNT', ecomdet.BURECOMDETKISTOTODAMNT);
				mapObj.put('BURECOMDETKISTRANSACTPERIOD', ecomdet.BURECOMDETKISTRANSACTPERIOD);
				mapObj.put('BURECOMDETKISNODEBTORS', ecomdet.BURECOMDETKISNODEBTORS);
				mapObj.put('BURECOMDETKISNOOVERDUE', ecomdet.BURECOMDETKISNOOVERDUE);
				mapObj.put('BURECOMDETKISTOTPERCENTAGE', ecomdet.BURECOMDETKISTOTPERCENTAGE);
				mapObj.put('BURECOMENRKISTOTWITHINTERMS', ecomdet.BURECOMENRKISTOTWITHINTERMS);
				mapObj.put('BURECOMDETBANKBANKERS', ecomdet.BURECOMDETBANKBANKERS);
				mapObj.put('BURECOMDETBANKCODE', ecomdet.BURECOMDETBANKCODE);
				mapObj.put('BURECOMDETBANKCODEDESC', ecomdet.BURECOMDETBANKCODEDESC);
				mapObj.put('BURECOMDETBANKDATECODE', ecomdet.BURECOMDETBANKDATECODE);
				mapObj.put('BURECOMDETBANKDATELASTRD', ecomdet.BURECOMDETBANKDATELASTRD);
				mapObj.put('BURECOMDETBANKAMNTLASTRD', ecomdet.BURECOMDETBANKAMNTLASTRD);
				mapObj.put('BURECOMDETBANKACCDATE', ecomdet.BURECOMDETBANKACCDATE);
				mapObj.put('BURECOMDETBANKMNTHSINCELASTRD', ecomdet.BURECOMDETBANKMNTHSINCELASTRD);
				mapObj.put('BURECOMDETAUDNAME', ecomdet.BURECOMDETAUDNAME);
				mapObj.put('BURECOMDETAUDTYPE', ecomdet.BURECOMDETAUDTYPE);
				mapObj.put('BURECOMDETAUDSTATUS', ecomdet.BURECOMDETAUDSTATUS);
				mapObj.put('BURECOMSUMNORDS', ecomdet.BURECOMSUMNORDS);
				mapObj.put('BURECOMSUMLATESTBNKCDE', ecomdet.BURECOMSUMLATESTBNKCDE);

				mapObj.put('ECOMDETJUD', judgementData);

				bureauData.add(mapObj);
			} else {
				Map<String, Object> mapObj = new Map<String, Object>();

				mapObj.put('BURCOMMINPBUSNAME', applicationProfile.Client_Name__c);
				mapObj.put('CIFCODE', applicationProfile.Client_CIF_Code__c);
				mapObj.put('BUREAUREPORT', applicationProfile.Bureau_Report_1__c);
				mapObj.put('CALLTYPE', 'Experian');
				bureauData.add(mapObj);
			}
		}

		return bureauData;
	}
}