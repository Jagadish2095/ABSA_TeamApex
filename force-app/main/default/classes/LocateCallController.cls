/**
 * @description       : Lightning Component Controller for Locate Call
 * @author            : englarmerdge.mongwe@absa.africa
 * @last modified on  : 2021-06-30
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-01-08   englarmerdge.mongwe@absa.africa   Initial Version
**/
public class LocateCallController {
	public static List<String> missingIdRegNameList;

	/**
	 * @description locate call wrapper class
	 */
	public class LocateCall{
		/** @description property KIMNumberOrNoMatch */
		@AuraEnabled public String KIMNumberOrNoMatch {get;set;}
		/** @description property HeadingIndicator */
		@AuraEnabled public String HeadingIndicator {get;set;}
		/** @description property SourceFile */
		@AuraEnabled public String SourceFile {get;set;}
		/** @description property KIInternalNumber */
		@AuraEnabled public String KIInternalNumber {get;set;}
		/** @description property CompanyName */
		@AuraEnabled public String CompanyName {get;set;}
		/** @description property CompanyIndicators */
		@AuraEnabled public String CompanyIndicators {get;set;}
		/** @description property ReportDate */
		@AuraEnabled public String ReportDate {get;set;}
		/** @description property RelatedInfo */
		@AuraEnabled public String RelatedInfo {get;set;}
		/** @description property FileIndicators */
		@AuraEnabled public String FileIndicators {get;set;}
		/** @description property RegistrationNumber */
		@AuraEnabled public String RegistrationNumber {get;set;}
		/** @description property EntityType */
		@AuraEnabled public String EntityType {get;set;}
		/** @description property Status */
		@AuraEnabled public String Status {get;set;}
		/** @description property NJO */
		@AuraEnabled public String NJO {get;set;}
		/** @description property AddInfo */
		@AuraEnabled public String AddInfo {get;set;}
		/** @description property IsSelected */
		@AuraEnabled public Boolean IsSelected {get;set;}

		/**
		 * @description locate call constructor
		 */
		public LocateCall() {
			this.KIMNumberOrNoMatch = 'false';
			this.HeadingIndicator = null;
			this.SourceFile = null;
			this.KIInternalNumber = null;
			this.CompanyName = null;
			this.CompanyIndicators = null;
			this.ReportDate = null;
			this.RelatedInfo = null;
			this.FileIndicators = null;
			this.RegistrationNumber = null;
			this.EntityType = null;
			this.Status = null;
			this.NJO = null;
			this.AddInfo = null;
			this.IsSelected = false;
		}
	}

	/**
	 * @description get business trace data from Business Trace service
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-08
	 * @param oppID
	 * @return List<Map<String, Object>>
	**/
	@AuraEnabled
	public static List<Map<String,Object>> getBusinessTraceData(String oppID) {
		Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(app?.Id);
		List<Map<String,Object>> resultList = new List<Map<String,Object>>();

        String jsonContent = '';
		List<String> businessNames = businessTraceList(oppID);

		for(String businessName : businessNames) {
			BusinessTrace_Resp_IB_v1 respBean = getBusinessTrace(businessName, businessName, '', '');
			jsonContent += xmlToJson(respBean?.BusinessTraceResponse?.BusinessTraceResult) + ',';
		}

		jsonContent = '[' + jsonContent.left(jsonContent.length() - 1) + ']';

		List<Object> objList = (List<Object>)JSON.deserializeUntyped(jsonContent);

		for(Object obj : objList) {
			Map<String,Object> mapExtBankRel = (Map<String,Object>)obj;
			Object resultLine = ((Map<String,Object>)mapExtBankRel?.get('ResultSet'))?.get('ResultLine');
			List<LocateCall> lccList = new List<LocateCall>();

			try{
				lccList = (resultLine != null ? (List<LocateCall>)JSON.deserialize(JSON.serialize(resultLine), LocateCall[].class) : null);
			}
			catch(Exception ex){
				LocateCall lcc = (resultLine != null ? (LocateCall)JSON.deserialize(JSON.serialize(resultLine), LocateCall.class) : null);
				lccList?.add(lcc);
			}

			if (appProfileList?.size() > 0 && lccList?.size() > 0) {
				for(LocateCall locCall : lccList) {
					String kIMNumberOrNoMatch = (locCall.KIMNumberOrNoMatch != null ? locCall.KIMNumberOrNoMatch : '0');
					for(Application_Profile__c appProfile : appProfileList) {
						if(appProfile.Client_Name__c != null && appProfile.Client_Name__c.contains(locCall.CompanyName)
						&& (appProfile.KIMNumber__c == Decimal.valueOf(kIMNumberOrNoMatch) || appProfile.KIM_Number_No_Possible_Match__c)) {
							locCall.IsSelected = (appProfile.KIMNumber__c != null ? true : false);
							locCall.KIMNumberOrNoMatch = String.valueOf(appProfile.KIM_Number_No_Possible_Match__c);
							break;
						}
					}
				}
			}

			resultList.add(new Map<String,List<LocateCall>>{'ResultSet' => lccList});
		}

        return resultList;
    }

	/**
	 * @description save locate call/business trace data for selected clients
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-08
	 * @param oppID
	 * @param objData
	**/
    @AuraEnabled
	public static void saveBusinessTraceData(String oppID, String objData) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(app?.Id);
		List<LocateCall> prodObj = (List<LocateCall>)JSON.deserialize(objData, LocateCall[].class);

		if (appProfileList?.size() > 0 && prodObj?.size() > 0) {
            for(Application_Profile__c appProfile : appProfileList) {
				for(LocateCall locCall : prodObj) {
					String KIMNumberOrNoMatch = (locCall.KIMNumberOrNoMatch != null ? locCall.KIMNumberOrNoMatch : '0');
					if(appProfile.Client_Name__c != null && appProfile.Client_Name__c.contains(locCall.CompanyName)) {
						if(locCall.KIMNumberOrNoMatch != locCall.CompanyName) {
							appProfile.KIMNumber__c = Decimal.valueOf(KIMNumberOrNoMatch);
						}
						else if(locCall.KIMNumberOrNoMatch == locCall.CompanyName) {
							appProfile.KIM_Number_No_Possible_Match__c = (locCall.KIMNumberOrNoMatch != null ? true : false);
						}
					}
				}
            }

            try {
                update appProfileList;
            } catch (Exception ex) {
				throw new AuraException('Profile update failed: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            }
        }
	}

	/**
	 * @description submit request to powercurve for stage 05
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-08
	 * @param oppID
	 * @param stageId
	 * @return String
	**/
	@AuraEnabled
	public static String submitToPowerCurve(String oppID, String stageId) {
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		return PowerCurveController.pcoStageHandler(oppID, stageId, opp?.Illustrative_Decision__c);
	}


	/**
	 * @description check if locate call/business trace is required for client
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-08
	 * @param oppID
	 * @return Boolean
	**/
	public static Boolean isLocateCallRequired(Id oppID) {
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppID);
		Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(opp?.Id);
		List<Application_Principal__c> appPrinList = new ApplicationPrincipalsSelector().selectByApplicationId(app?.Id);

        missingIdRegNameList = new List<String>();
		String registrationNumber = (opp?.Account.Company_Registration_Number__c == null ? opp?.Account.Registration_Number__c : opp?.Account.Company_Registration_Number__c);
        if((registrationNumber == null && (!opp.Account.Client_Type__c.equalsIgnoreCase('SOLE TRADER'))) || (opp.Account.Client_Type__c.equalsIgnoreCase('TRUSTS'))) {//Added changes to enable locate calls for trust client type
			missingIdRegNameList.add(opp.Account.Name);
        }

        for(Application_Principal__c appPrin :appPrinList) {
            if(appPrin.Id_Number__c == null || appPrin.Id_Number__c == '') {
                missingIdRegNameList.add(appPrin.Principal_Shareholder_Name__c);
            }
        }

        if((!opp?.Illustrative_Decision__c || opp?.Illustrative_Decision__c) && missingIdRegNameList?.size() > 0) {
            return true;
        }

        return false;
    }

	/**
	 * @description
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-08
	 * @param oppID
	 * @return List<String>
	**/
	public static List<String> businessTraceList(String oppID) {
		List<String> busiTraceNames = new List<String>();
		Boolean isLocateCall = isLocateCallRequired(oppID);
		if(missingIdRegNameList?.size() > 0) {
			for(String name : missingIdRegNameList) {
				busiTraceNames.add(name);
			}
		}
		return busiTraceNames;
	}

    /**
     * @description Method which is parsing the XML content into JSON
     * @author englarmerdge.mongwe@absa.africa | 2021-06-08
     * @param xml
     * @return String
    **/
    public static String xmlToJson(String xml) {
        // Load the xml in the document
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        Dom.XMLNode root;
        String jsonContent;

        try {
            root = doc.getRootElement().getChildElement('CompanySearch', null).getChildElement('Results', null).getChildElement('ResultSet', null);
        }
        catch (Exception ex) {
			root = null;
		}

        if(root == null) {
            try {
                root = doc.getRootElement().getChildElement('Error', null);
            }
            catch (Exception ex) {
				root = null;
            }

            if(root != null) {
                jsonContent = root.getText();
            }
            else {
                return jsonContent;
            }
        }

		jsonContent = parse(root, false);
        return jsonContent;
    }

    /**
     * @description Method which makes the recursive calls and creates the JSON for
	 * each element, it processes each node and finds the attributes and text content of a node
     * @author englarmerdge.mongwe@absa.africa | 2021-06-08
     * @param node : Dom.XMLNode instance - XML node which will be processed
     * @param isChild : Boolean - To control the structure of JSON, should be true for child element
     * @return String
    **/
    private static String parse(Dom.XMLNode node, Boolean isChild) {
        String json = '';
        Boolean isArray = false;
        String rootElementName;

		if (rootElementName == null) {
			rootElementName = node.getName();
        }

		if (node.getNodeType() == Dom.XmlNodeType.ELEMENT) {
			Map<String, List<String>> mapChildrenJSON = new Map<String, List<String>>();
            List<String> lstJSONForChildren = new List<String>();

			// Check whether node has any child
            List<Dom.XMLNode> children = node.getChildElements();

			if (children.size() > 0) {
				// Process all the children in a row
				for (Dom.XMLNode child : children) {
                    String tmp = parse(child, true).removeStart('{').removeEnd('}');
                    tmp = (tmp.isWhitespace() ? '""' : tmp);

					if (tmp != '') {
						if (!mapChildrenJSON.containsKey(child.getName())) {
							mapChildrenJSON.put(child.getName(), new List<String>());
                        }

						// Add into a map to make a collection for the repeatative child nodes
						mapChildrenJSON.get(child.getName()).add(tmp);
					}
                }

				// Strcuture the JSON based on the repeation
				// Should be treated as an array if there are multiple elements with the same node name
				for (String key : mapChildrenJSON.keySet()) {
					if (mapChildrenJSON.get(key).size() > 1) {

						if (isChild) {
							lstJSONForChildren.add('[' + String.join(mapChildrenJSON.get(key), ', ') + ']');
						}
						else {
							lstJSONForChildren.add('"' + key + '": [' + String.join(mapChildrenJSON.get(key), ', ') + ']');
						}
						isArray = true;
					}
					else {
						lstJSONForChildren.add('"' + key + '": ' + mapChildrenJSON.get(key)[0]);
					}
				}
            }

			// Construc the JSON for all the node attributes
			List<String> lstAttributes = new List<String>(lstJSONForChildren);
			for (Integer i = 0; i < node.getAttributeCount(); i++) {
				String key = node.getAttributeKeyAt(i);
				String value = node.getAttribute(key, '');
				lstAttributes.add('"' + key + '": "' + value + '"');
            }

			// Look for the text content
			String textContent = node.getText();
			if (textContent != null && textContent.trim() != '') {
				textContent = textContent.replace('"', '\\"');
				lstAttributes.add('"ele_text": "' + textContent + '"');
            }

			if (!isChild) {
				if (!isArray) {
					json = '"' + node.getName()+'": {' + String.join(lstAttributes, ', ') + '}';
				}
				else {
					json = ' {' + String.join(lstAttributes, ', ') + '}';
				}
			}
			else {
				if (lstAttributes.size() == 1 && textContent != null && textContent.trim() != '') {
					json = '"' + textContent + '"';
				}
				else {
					if (!isArray) {
						if (lstAttributes.size() > 0) {
							json = '{' + String.join(lstAttributes, ', ') + '}';
						}
					}
					else {
						json = String.join(lstAttributes, ', ');
					}
				}
			}
        }

		if (rootElementName == node.getName()) {
			if (!isArray) {
				json = '{' + json + '}';
			}
			else {
				json = '{"' + node.getName()+'" : ' + json + '}';
			}
		}
		return json;
    }

	/**
	 * @description
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-08
	 * @param businessName
	 * @param searchWord1
	 * @param searchWord2
	 * @param searchWord3
	 * @return BusinessTrace_Resp_IB_v1
	**/
	public static BusinessTrace_Resp_IB_v1 getBusinessTrace(String businessName, String searchWord1, String searchWord2, String searchWord3) {
		if(Test.isRunningTest()) {
			BusinessTrace_IH_v1_Test.businessTraceTestMock();
		}

		BusinessTrace_Resp_IB_v1 respBean = BusinessTrace_IH_v1.BusinessTrace(businessName, searchWord1, searchWord2, searchWord3);
		if(respBean?.statusCode == 200) {
			return respBean;
		}

		return null;
	}
}