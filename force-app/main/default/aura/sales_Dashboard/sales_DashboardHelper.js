({
    
    getUserInfor: function(component, event) { 
        
        var client = component.get("v.client");
 		var action = component.get("c.getUserInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
   
            if (component.isValid() && state === "SUCCESS") {

                var userInfo = res.Data.dataMap.user[0]; 
       

                var loggedInUser = {
                    username: userInfo.Username,
                    //ab_number: userInfo.AB_Number__c,
                    ab_number: (userInfo.AB_Number__c).toUpperCase(),
                    fullname: userInfo.Name,
                    email: userInfo.Email,
                    firstname: userInfo.FirstName,
                    lastname: userInfo.LastName,
                    supportValue: userInfo.supportValue,
                    dbs_dashboard_do_not_show: userInfo.DBS_Dashboard_Do_Not_Show__c,
                    last_login_date: userInfo.LastLoginDate,
                    station_id: userInfo.Station_ID__c,
                    consult_emp_no: userInfo.EmployeeNumber,
                    teller_code: userInfo.Teller_Operator_Code__c,
                    agent_id: ''
                };
                
                var supportValue = res.Data.dataMap.support[0];
                if (supportValue == 0) {
                    component.set("v.supportVisible", "slds-show");
                    component.set("v.dashBoardVisible", "slds-hide");
                    component.set("v.searchCardVisible", "slds-hide");
                } else if (supportValue == 1) {
                    component.set("v.supportVisible", "slds-hide");
                    component.set("v.dashBoardVisible", "slds-show");
                    component.set("v.searchCardVisible", "slds-show");
                }
                
       			component.set("v.loggedInUser2", loggedInUser);
               /* var logIntoChewy = component.find('login');
                console.log(JSON.stringify(logIntoChewy)); 

                var cti_component = component.find("login");
                cti_component.loginMethod(loggedInUser); */
                
                //alert("Before:  "+component.get("v.client.teller"));
             

            component.set("v.client.userId", loggedInUser.ab_number);
            component.set("v.client.consult_emp_no", loggedInUser.consult_emp_no); 
            component.set("v.client.teller_code", loggedInUser.teller_code);
            component.set("v.client.employee_name", loggedInUser.fullname);
            component.set("v.client.teller", loggedInUser.ab_number);
                
                //alert("After:  "+component.get("v.client.teller"));
              
            }
        });
        $A.enqueueAction(action);     
        
    },
    //First service and Salesforce query
    fetchClientData: function(component, event) {
        var client = component.get("v.client");
        

        var inputVariable = component.find('IdNumber').getElement().value;
        var inputString = inputVariable.toString();
        inputString = (inputString) ? inputString.trim() : component.get("v.IdNumber");
        
        if (!inputString) {
            this.messageModal(component, true, 'Warning', 'Please enter ID number');
            return;
        }
        
        component.set("v.ctiSpinner", {
            displayCls: '',
            msgDisplayed: 'Loading...'
        });
        client.id_number = inputString;
        var action = component.get("c.ciGetClientDetailsByIDNumber");
        
        let clientData = '{"NBSAPDPI": {"NBSAPLI": {"consumerChannel": "'+client.channel+'","providerApplication": "'+client.application+'","trace": "'+client.trace+'"}},"NBSMSGI": {"NBSMSGI": {"messageLanguage": "'+client.language+'","messageTarget": "'+client.target+'"}},"inputCopybookClssidi": {"inputDetails": {"idNumber": "'+client.id_number+'","idDocumentType": "'+client.id_document_type+'","cifClientGroup": "'+client.cif_client_group+'","cifClientType": "'+client.cif_client_type+'","maxRecordsToRetrieve": "'+client.max_records_to_retrieve+'","restartSearchPosition": "'+client.restart_search_position+'","siteCode": "'+client.site_code+'"}}}';
		console.log("===============fetchClientData= Input=================");
        console.log(clientData);
        console.log("===============fetchClientDataHelper==================");
        action.setParams({
            IdNumber: inputString,
            clientData: clientData
        });
        
        action.setCallback(this, function(response) {
            component.set("v.ctiSpinner", {
                displayCls: 'slds-hide',
                msgDisplayed: 'Loading...'
            });
            component.set("v.searchCardVisible", "slds-hide");
            component.set("v.informationCardVisible", "");
            
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        var getClientByIdApi = JSON.parse(res.Data.dataMap.getBody);
                        console.log("============ciGetClientDetailsByIDNumber Output===============");
                        console.log(JSON.stringify(getClientByIdApi));
                        console.log("===========================");
                        var sfResp = res.Data.dataMap.sfResp.length;
                        if (sfResp > 0) {            
                            this.loadClientObjHelper(component, event, res.Data.dataMap.sfResp[0]);
                        } else {
                            
                        }
                        
                        if (getClientByIdApi) {
                            var obj = getClientByIdApi.CLSSIDO.outputCopybookClssido.outputTableEntries.tableEntry[0];
                            console.log(getClientByIdApi)
                  
                            if (obj.clientCorpCode == "A") {
                                console.log(client.ClientCorpCode);                              
                                client.postal_address_line_1_3 = obj.clientAddressLine1;                              
                                client.client_key = obj.clientKey;                             
                                client.cif_key = obj.clientKey;
                                if (obj.clientGroup == "I"){
                                    let customer_type = (client.customer_type_values.filter(el => el.value == obj.clientGroup));
                                    client.customer_type_label = customer_type.length == 1 ? customer_type[0].label : "";
                                    client.customer_type_value = obj.clientGroup;  
                                }else {
                                    this.messageModal(component, true, 'Business Exception', 'This is not individual accounts');
                                    return;
                                }
                                //console.log(client.town_city_foreign_country);
                            } else {
                                   this.messageModal(component, true, 'Business Exception', 'Client does not bank with Absa');
                                   return;
                            }
                            component.set("v.client", client);
                        }
                        this.getCiClientDetailsHelper(component, event);
                        
                        component.set("v.searchCardVisible", "slds-hide");
                        component.set("v.informationCardVisible", "");
                    } else {
                        if(res.Data.dataMap.getStatusCode != 401){
                            this.errorMessagesHelper(component, event, 'Load client profile exception', res.Data.dataMap.getStatus, 'errors');
                        }else{
                              this.messageModal(component, true, 'Load client profile warning', res.Data.dataMap.getBody);
                        }
                    }
                } else {
                    this.messageModal(component, true, 'Load client profile message', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'Load client profile error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    //Second service
    getCiClientDetailsHelper: function(component, event) {
        
        let client = component.get("v.client");
        var client_key = client.client_key;        
        console.log(client.client_key);
        if (!client.client_key) {
            this.messageModal(component, true, 'Warning', 'No client key found');
            return;
        }
        
        var clientData = '{"messageHeaders":{"inPutMessageHeaders":{"consumerChannel":"'+client.channel+'","providerApplication":"'+client.application+'","traceIndicator":"'+client.trace+'"}},"messageIndicator":{"inPutMessageIndicator":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"CIgetClientDetailsV20":{"CIgetClientDetailsV20Input":{"inpClientCode":"'+client.client_key+'","clntAcctNbr":"'+client.clnt_acct_nbr+'","siteCode":"'+client.site_code+'"}}}';
        console.log("===============getCiClientDetailsHelper= Input=================");
        console.log(clientData);
        console.log("===============getCiClientDetailsHelper==================");
        var action = component.get("c.ciGetClientInfo");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    
                    if (res.Data.dataMap.getStatusCode == 200) {
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        if (obj) {
                            var client = component.get("v.client");
                            var date_clinet_opened = obj.CIgetClientDetailsV20.CIgetClientDetailsV20OutPut.dateClientOpened;
                            var getClientDetails = obj.CIgetClientDetailsV20.CIgetClientDetailsV20OutPut;                           
                            console.log("===============getCiClientDetailsHelper==================");
                            console.log(JSON.stringify(obj));
                            console.log("===============getCiClientDetailsHelper==================");
                            //from Thabo
                            client.credit_email = getClientDetails.CreditEmail;
                            client.credit_post = getClientDetails.CreditPost;
                            client.credit_SMS =  getClientDetails.CreditSMS ;
                            client.credit_tel =  getClientDetails.CreditTel ;
                            //client.non_CR_email = getClientDetails.NonCREmail;
                            //client.non_CR_ind = getClientDetails.NonCRInd ;
                            client.Non_CR_post =  getClientDetails.NonCRPost ;
                            //client.non_CR_SMS = getClientDetails.NonCRSMS ;                           
                            client.affected_person = getClientDetails.affectedPerson;                           
                            client.branch_client_opened = getClientDetails.branchClientOpened;
                            client.cellphone_number_cif = getClientDetails.cellphone;
                            client.client_type = getClientDetails.clientType;
                            client.client_website = getClientDetails.clientWebsite;
                            client.company_year_end = getClientDetails.companyYearEnd;
                            client.contact_person = getClientDetails.contactPerson;
                            client.corporate_division = getClientDetails.corporateDivision;
                            client.country_ho_address = getClientDetails.countryHoAddress;
                            client.country_incorp  = getClientDetails.countryIncorp;
                            client.country_of_origin = getClientDetails.countryOfOrigin;
                            client.country_reg_address = getClientDetails.countryRegAddress;
                            client.cpa_threshold = getClientDetails.cpaThreshold;                            
                            client.employee_identified = getClientDetails.employeeIdentified;
                            client.employee_verified = getClientDetails.employeeVerified;
                            client.excon_expiry_date = getClientDetails.exconExpiryDate;
                            client.exemption_indicator = getClientDetails.exemptionIndicator;                            
                            client.fax_home_code = getClientDetails.faxHomeCode;
                            client.fax_home_number = getClientDetails.faxHomeNumber;                            
                            client.fax_work_code = getClientDetails.faxWorkCode;
                            client.work_tel_code = getClientDetails.workTelCode;
                            client.fax_work_number = getClientDetails.faxWorkNumber;
                            client.work_telephone_number = client.work_tel_code.toString()+getClientDetails.workTelephone.toString();
                            if(client.work_telephone_number.toString().length == 9)
                            {
                                client.work_telephone_number = '0'+client.work_telephone_number
                            }
                            //added by Rakesh and Josh on 09Oct2020
                            else if(client.work_telephone_number = '0')
                            {
                                client.work_telephone_number = '';                                
                            }
                            
                            
                            
                            client.work_fax_number = client.fax_work_code.toString()+client.fax_work_number.toString();
                            
                            if(client.work_fax_number.toString().length==9)
                            {
                                client.work_fax_number = '0'+ client.work_fax_number
                            }
                            else if(client.work_fax_number == '00')
                            {
                                client.work_fax_number = '';
                            }
                            client.home_telephone_number = getClientDetails.homeTelCode.toString()+getClientDetails.homeTelephone.toString();
                            
                            if(client.home_telephone_number.toString().length==9)
                            {
                                client.home_telephone_number = '0'+ client.home_telephone_number
                            }
                            //added by Rakesh and Josh on 09Oct2020
                            else if(client.home_telephone_number = '0')
                            {
                                client.home_telephone_number = '';                                
                            }
                            
                            client.home_fax_number = getClientDetails.faxHomeCode.toString()+getClientDetails.faxHomeNumber.toString();
                            
                            if(client.home_fax_number.toString().length==9)
                            {
                                client.home_fax_number = '0'+ client.home_fax_number
                            }
                            else if(client.home_fax_number == '00')
                            {
                                client.home_fax_number = '';
                            }
                            
                            client.contact_number = getClientDetails.nkinCell.toString();
                            
                            if(client.contact_number.toString().length==9){client.contact_number = '0'+ client.home_fax_number}
                            client.first_names = getClientDetails.firstNames;
                            client.ho_suburb = getClientDetails.hoSuburb;
                            client.hos_town = getClientDetails.hoTown;
                            client.ho_addr_line1 = getClientDetails.hoAddrLine1;                          
                            client.ho_addr_line2 = getClientDetails.hoAddrLine2;
                            client.ho_code_rsa  = getClientDetails.hoCodeRsa;
                            client.group_scheme = getClientDetails.groupScheme;
                            client.group_scheme_emp = getClientDetails.groupSchemeEmp; 
                            //client.non_cr_tel = getClientDetails.NonCRTel;
                            client.id_number = getClientDetails.idNumber;
                            client.income_group = getClientDetails.incomeGroup;
                            client.initials = getClientDetails.initials;
                            client.mail_ind = getClientDetails.mailInd;
                            client.marketing_concent = getClientDetails.marketingConcent;
                            //client.minor_children = getClientDetails.minorChildren;
							client.dependents_value = getClientDetails.minorChildren;
                            client.nca_threshold = getClientDetails.ncaThreshold;
                            client.nkin_cell = getClientDetails.nkinCell;
                            client.nkin_dcdh = getClientDetails.nkinDcdh;
                            client.miltary_comtmnt_ind = getClientDetails.miltaryComtmntInd;
                            client.nkin_dcdw = getClientDetails.nkinDcdw;
                            client.nkin_email = getClientDetails.nkinEmail;                            
                            client.nkin_initials = getClientDetails.nkinInitials;
                            client.nkin_jnt_surname = getClientDetails.nkinJntSurname;
                            client.nkin_relationship = getClientDetails.nkinRela;                            
                            client.nkin_telh = getClientDetails.nkinTelh;
                            client.nkin_telw = getClientDetails.nkinTelw;
                            client.nkin_title = getClientDetails.nkinTitle;                                                       
                            client.permit_exp_dte = getClientDetails.permitExpDte;
                            client.pingit_receive = getClientDetails.pingitReceive;
                            client.pingit_wallet = getClientDetails.pingitWallet;
                            client.postl_addr_line1 = getClientDetails.postlAddrLine1;
                            client.postl_addr_line2 = getClientDetails.postlAddrLine2;
                            client.postl_code_rsa = getClientDetails.postlCodeRsa;
                            if (client.postl_code_rsa == 0 || client.postl_code_rsa == ''){client.postl_code_rsa = '0000';}
                            client.postl_suburb = getClientDetails.postlSuburb;
                            if (client.postl_suburb == 0 || client.postl_suburb == ''){client.postl_suburb = '';}                            
                            client.practice_number = getClientDetails.practiceNumber;                            
                            client.reg_addr_line1 = getClientDetails.regAddrLine1;
                            client.reg_addr_line2 = getClientDetails.regAddrLine2;
                            client.reg_code_rsa = getClientDetails.regCodeRsa;
                            client.reg_suburb = getClientDetails.regSuburb;
                            client.reg_town = getClientDetails.regTown;                            
                            client.regisforTaxinSA = getClientDetails.regisforTaxinSA;                            
                            client.secondary_card = getClientDetails.secondaryCard;
                            client.sicc_code5 = getClientDetails.siccCode5;
                            client.sic_code = getClientDetails.sicCode;                                                 
                            client.sub_class_cde = getClientDetails.subClassCde;                            
                            client.upd_address_ind = getClientDetails.updAddressInd;
                            client.upd_date_ind = getClientDetails.updDateInd;                            
                            client.upd_email_ind = getClientDetails["updEmailInd "];                              
                            client.upd_telephone_ind = getClientDetails.updTelephoneInd;                           
                            client.foreign_tax_no = getClientDetails.foreignTaxDataTable[0].foreignTaxNo;
                            client.foreign_tax_ctry = '';
                            client.exemption_status = getClientDetails.statusOfExemption;
                            client.date_exempted = getClientDetails.dateAClntExempted;
                            client.credit_auto_voice = getClientDetails.CreditAVoice;   
                            
                            client.teller_last_changed = client.teller_code;// fixed in Release 1
                            
                            
                           /* if((!getClientDetails.tellerLastChanged) ||(getClientDetails.tellerLastChanged == 0))
                            {
                                client.teller_last_changed = client.teller_code; //for now we hardcoding the values, as we are not able to get it from the component.
                                //client.teller_last_changed = 2693;
                            }else{
                                client.teller_last_changed = getClientDetails.tellerLastChanged;
                            } */

                            
                            client.mcl_indicator = getClientDetails.mclIndicator;
                            client.miltaryComtmnt_ind = getClientDetails.miltaryComtmntInd;
                            //client.minor_children = getClientDetails.minorChildren;
							client.dependents_value = getClientDetails.minorChildren;
                            client.nbr_of_accounts = getClientDetails.nbrOfAccounts;
                            client.nca_threshold = getClientDetails.ncaThreshold;
                            client.res_permit_number = getClientDetails.resPermitNbr;
                            client.sa_tax_regis = getClientDetails.regisforTaxinSA; //added in the component                           
                            client.sbu_segment = getClientDetails.sbuSegment;                          
                            if((!getClientDetails.siteLastChanged) ||(getClientDetails.siteLastChanged == 0))
                            {
                                client.site_last_changed = client.branch_code;
                            }else{
                                client.site_last_changed = getClientDetails.siteLastChanged;
                            } 
                            client.absa_reward_indctor = getClientDetails.absaRewardIndctor;
                            client.apply_debt_counsel = getClientDetails.applyDebtCounsel;
                            client.change_number = getClientDetails.changeNumber;
                            client.date_bus_rescue_iss = getClientDetails.dateBusRescueIss; 
                            client.date_client_opened = getClientDetails.dateClientOpened;
                            client.date_last_changed = getClientDetails.dateLastChanged;
                            //client.non_credit_marketing_email = getClientDetails.NonCREmail;
                            //client.non_credit_marketing_group_ind = getClientDetails.NonCRInd;
                            client.non_credit_marketing_post = getClientDetails.NonCRPost;
                            //client.non_credit_marketing_sms = getClientDetails.NonCRSMS;
                            //client.non_credit_marketing_telephone = getClientDetails.NonCRTel;
                            client.non_credit_marketing_auto_voice = getClientDetails.NonCRAVoice;
                            
                            //mapping values to UI                              
                            //Persnol detail screen1
                            if(getClientDetails.titleCode){
                                let title = (client.title_values.filter(el => el.value == getClientDetails.titleCode));
                                client.title_label = title.length == 1 ? title[0].label : "";
                                client.title_value = getClientDetails.titleCode;
                            }                           
                            if(getClientDetails.idDocType){
                                let id_type = (client.id_type_values.filter(el => el.value == getClientDetails.idDocType));
                                client.id_type_label = id_type.length == 1 ? id_type[0].label : "";   
                                client.id_type_value = getClientDetails.idDocType;
                            } 
                            //Service:DDMMCCYY 							                            
                            client.id_date_issued = this.dateFormating("Front_End_Format","DDMMCCYY",getClientDetails.dateIssued);
                            
                            if (getClientDetails.countryOfOrigin){
                                let place_of_residence = (client.place_of_residence_values.filter(el => el.value == getClientDetails.countryOfOrigin));
                                client.place_of_residence_label = place_of_residence.length == 1 ? place_of_residence[0].label : "";
                                client.place_of_residence_value = getClientDetails.countryOfOrigin;  
                            }    
                            
                            if (getClientDetails.gender){
                                let gender = (client.gender_values.filter(el => el.value == getClientDetails.gender));
                                client.gender_label = gender.length == 1 ? gender[0].label : "";
                                client.gender_value = getClientDetails.gender;  
                            } 
                            //Service:CCYYMMDD                             
                            client.date_of_birth = this.dateFormating("Front_End_Format","CCYYMMDD",getClientDetails.birthDate);
                            client.date_of_birth_casa_screening = getClientDetails.birthDate;
                            
                            if (getClientDetails.countryOfBirth){
                                let country_of_birth = (client.country_of_birth_values.filter(el => el.value == getClientDetails.countryOfBirth));
                                client.country_of_birth_label = country_of_birth.length == 1 ? country_of_birth[0].label : "";
                                client.country_of_birth_value = getClientDetails.countryOfBirth;  
                            }                           
                            
                            if (getClientDetails.clientNationality){
                                let nationality = (client.nationality_values.filter(el => el.value == getClientDetails.clientNationality));
                                client.nationality_label = nationality.length == 1 ? nationality[0].label : "";
                                client.nationality_value = getClientDetails.clientNationality;  
                            }                             
                            if (getClientDetails.maritalStatus){
                                let marital_status = (client.marital_status_values.filter(el => el.value == getClientDetails.maritalStatus));
                                client.marital_status_label = marital_status.length == 1 ? marital_status[0].label : "";
                                client.marital_status_value = getClientDetails.maritalStatus;  
                            }         
                            if (getClientDetails.mariageContrctType){
                                let marital_contract = (client.marital_contract_values.filter(el => el.value == getClientDetails.mariageContrctType));
                                client.marital_contract_label = marital_contract.length == 1 ? marital_contract[0].label : "";
                                client.marital_contract_value = getClientDetails.mariageContrctType;  
                            }                             
                            if (getClientDetails.homeLanguage){
                                let home_language = (client.home_language_values.filter(el => el.value == getClientDetails.homeLanguage));
                                client.home_language_label = home_language.length == 1 ? home_language[0].label : "";
                                client.home_language_value = getClientDetails.homeLanguage;  
                            } 
                            let dependents = (client.dependents_values.filter(el => el.value == getClientDetails.minorChildren));
                            client.dependents_label = dependents.length == 1 ? dependents[0].label : "";
                            client.dependents_value = getClientDetails.minorChildren;                           
                            client.nkin_first_name = getClientDetails.nkinFname;
                            client.nkin_surname = getClientDetails.nkinSurname;
                            client.no_of_joint_partcpnt = getClientDetails.noOfJointPartcpnt;
                            if (getClientDetails.nkinRela){
                                let relationship = (client.relationship_values.filter(el => el.value == getClientDetails.nkinRela));
                                client.relationship_label = relationship.length == 1 ? relationship[0].label : "";
                                client.relationship_value = getClientDetails.nkinRela;  
                            } 
                            //client.contact_number = getClientDetails.nkinTelw;                           
                            if (getClientDetails.language){
                                let communication_language = (client.communication_language_values.filter(el => el.value == getClientDetails.language));
                                client.communication_language_label = communication_language.length == 1 ? communication_language[0].label : "";
                                client.communication_language_value = getClientDetails.language;  
                            } 
                            if(getClientDetails.insolventIndicator){client.insolvent = getClientDetails.insolventIndicator;}else{client.insolvent = '';}
                            client.insolvent_values = this.setRadioBtnInput(component, client.insolvent, client.insolvent_values);
                            
                            if(getClientDetails.receiveSocialGrant){client.social_grant = getClientDetails.receiveSocialGrant;}else{client.social_grant = '';}
                            client.social_grant_values = this.setRadioBtnInput(component, client.social_grant, client.social_grant_values);
                            
                            if(getClientDetails.applyDebtCounsel){client.debt_counseling = getClientDetails.applyDebtCounsel;}else{client.debt_counseling = '';}
                            client.debt_counseling_values = this.setRadioBtnInput(component, client.debt_counseling, client.debt_counseling_values);
                            
                            if(getClientDetails.postMatricQualifd){client.does_client_havepostmatric_qualification = getClientDetails.postMatricQualifd;}else{client.does_client_havepostmatric_qualification = '';}
                            client.does_client_havepostmatric_qualification_values = this.setRadioBtnInput(component, client.does_client_havepostmatric_qualification, client.does_client_havepostmatric_qualification_values);
                            
                            if (getClientDetails.postMatricQualfton){
                                let post_matric_qualification = (client.post_matric_qualification_values.filter(el => el.value == getClientDetails.postMatricQualfton));
                                client.post_matric_qualification_label = post_matric_qualification.length == 1 ? post_matric_qualification[0].label : "";
                                client.post_matric_qualification_value = getClientDetails.postMatricQualfton;  
                            } 
                            //Service:DDMMCCYY             
                            client.fica_date_identified = this.dateFormating("Front_End_Format","DDMMCCYY",getClientDetails.dateIdentified);
                            //contact details screen2  
                            let arrayOfaddressObjects1 = obj.CIgetClientDetailsV20.CIgetClientDetailsV20OutPut.addressEntryTabel;
                            arrayOfaddressObjects1.forEach(function(obj) {
                                if(obj.addrType == 10){                                   
                                    
                                    let res_Address = obj.addrLine1+obj.addrLine2+obj.addrTown+obj.addrPostlCode;
                                    client.residential_address = res_Address; 
                                    client.addr_seq_nbr = obj.addrSeqNbr; 
                                    //client.physical_add1 = obj.addrLine1;
                                    //client.physical_add2 = obj.addrLine2;
                                    client.postal_address_line_1 = obj.addrLine1;
                                    client.postal_address_line_2 = obj.addrLine2;
                                    client.physical_addr_type= "10";                                   
                                    client.postal_code = obj.addrPostlCode;
                                    client.physical_suburb_rsa = obj.addrSuburbRsa; //addrSuburbRsa                                   
                                    client.town_city_foreign_country = obj.addrTown; 
                                    
                                } 
                            });                                
                            
                            //Service:DDMMCCYY 
                            client.current_address_since = this.dateFormating("Front_End_Format","DDMMCCYY",getClientDetails.dateVerified);
                            if (getClientDetails.countryResAddress){
                                let residential_address_country = (client.residential_address_country_values.filter(el => el.value == getClientDetails.countryResAddress));
                                client.residential_address_country_label = residential_address_country.length == 1 ? residential_address_country[0].label : "";
                                client.residential_address_country_value = getClientDetails.countryResAddress;  
                            }                            
                            if (getClientDetails.occupationType){
                                let residential_status = (client.residential_status_values.filter(el => el.value == getClientDetails.occupationType));
                                client.residential_status_label = residential_status.length == 1 ? residential_status[0].label : "";
                                client.residential_status_value = getClientDetails.occupationType;  
                            } 
                            if (getClientDetails.Sec129NotcDelivAddr){
                                let section_129_notice_delivery_address = (client.section_129_notice_delivery_address_values.filter(el => el.value == getClientDetails.Sec129NotcDelivAddr));
                                client.section_129_notice_delivery_address_label = section_129_notice_delivery_address.length == 1 ? section_129_notice_delivery_address[0].label : "";
                                client.section_129_notice_delivery_address_value = getClientDetails.Sec129NotcDelivAddr;  
                            }                           
                            
                            if (getClientDetails.cellphone){
                                if (getClientDetails.cellphone.toString().length < 10) {
                                    client.cellphone_number = '0' + getClientDetails.cellphone; }
                            }
                            client.email_address = getClientDetails.emailAddress;
                            if (getClientDetails.prefrdCommtionMthd){
                                let preffered_communication_channel = (client.preffered_communication_channel_values.filter(el => el.value == getClientDetails.prefrdCommtionMthd));
                                client.preffered_communication_channel_label = preffered_communication_channel.length == 1 ? preffered_communication_channel[0].label : "";
                                client.preffered_communication_channel_value = getClientDetails.prefrdCommtionMthd;                                 
                            }                           
                            //rakesh 08-sep-2020
                            client.credit_worthiness = getClientDetails.thrdPartyInd == 'N' ? false:true;   
                            client.absa_group_electronic = getClientDetails.NonCRInd == 'N' ? false:true; 
                            
                            client.voice_recording = getClientDetails.NonCRTel == 'N' ? false:true;   
                            client.email = getClientDetails.NonCREmail == 'N' ? false:true;   
                            client.sms = getClientDetails.NonCRSMS == 'N' ? false:true; 
                            
                            client.tele_mark_ind = getClientDetails.teleMarkInd;   
                            client.email_mark_ind = getClientDetails.emailMarkInd;   
                            client.sms_mark_ind = getClientDetails.smsMarkInd;   
                            
                            //employment details  Screen3 
                            if (getClientDetails.occupationStatus){
                                let occupational_status = (client.occupational_status_values.filter(el => el.value == getClientDetails.occupationStatus));
                                client.occupational_status_label = occupational_status.length == 1 ? occupational_status[0].label : "";
                                client.occupational_status_value = getClientDetails.occupationStatus;  
                            }
                            if (getClientDetails.employmentSector){
                                let employment_sector = (client.employment_sector_values.filter(el => el.value == getClientDetails.employmentSector));
                                client.employment_sector_label = employment_sector.length == 1 ? employment_sector[0].label : "";
                                client.employment_sector_value = getClientDetails.employmentSector;  
                            }                             
                            //client.occupation = getClientDetails.designation;   
                                                     
                           if (getClientDetails.designation){
                                let occupation = (client.occupation_values.filter(el => el.value == getClientDetails.designation));
                                client.occupation_label = 'Not applicable';//occupation.length == 1 ? occupation[0].label : "";
                                client.occupation_value = '0';//getClientDetails.designation;  
                            }
                            else{
                                client.occupation_label = 'Not applicable';
                                client.occupation_value = '0';
                            }
                            
                            
                            
                            if (getClientDetails.occupationCode){
                                let occupation_code = (client.occupation_code_values.filter(el => el.value == getClientDetails.occupationCode));
                                client.occupation_code_label = occupation_code.length == 1 ? occupation_code[0].label : "";
                                client.occupation_code_value = getClientDetails.occupationCode;  
                            }                            
                            if (getClientDetails.occupationLevel){
                                let occupation_level = (client.occupation_level_values.filter(el => el.value == getClientDetails.occupationLevel));
                                client.occupation_level_label = occupation_level.length == 1 ? occupation_level[0].label : "";
                                client.occupation_level_value = getClientDetails.occupationLevel;  
                            }                             
                            if (getClientDetails.incomeGroup){
                                let monthly_income = (client.monthly_income_values.filter(el => el.value == getClientDetails.incomeGroup));
                                client.monthly_income_label = monthly_income.length == 1 ? monthly_income[0].label : "";
                                client.monthly_income_value = getClientDetails.incomeGroup;  
                            }                             
                            if (getClientDetails.sourceOfIncome){
                                let source_of_income = (client.source_of_income_values.filter(el => el.value == getClientDetails.sourceOfIncome));
                                client.source_of_income_label = source_of_income.length == 1 ? source_of_income[0].label : "";
                                client.source_of_income_value = getClientDetails.sourceOfIncome;  
                            } 
                            
                             if(getClientDetails.telebankIndicator){client.client_banks_with_absa = getClientDetails.telebankIndicator;}else{client.client_banks_with_absa = '';}
                            client.client_banks_with_absa_values = this.setRadioBtnInput(component, client.client_banks_with_absa, client.client_banks_with_absa_values);
                            
                            let arrayOfaddressObjects = obj.CIgetClientDetailsV20.CIgetClientDetailsV20OutPut.addressEntryTabel;
                            arrayOfaddressObjects.forEach(function(obj) {
                                if(obj.addrType == 70){                                    
                                    client.empl_addr_suburb_rsa = obj.addrSuburbRsa;
                                    client.empl_postal_code = obj.addrPostlCode;                                    
                                    client.empl_postal_address_line_1 = obj.addrLine1;
                                    client.empl_postal_address_line_1_3 = obj.addrLine2;
                                    client.empl_town_city_foreign_country = obj.addrTown; 
                                    client.employer_addr_type = "70";  
                                }
                            });
                            
                            /*if(!client.employer_addr_type){
                                client.employer_addr_type = "0";
                            }*/
                            
                            //Thabo 18Sep2020
                            if(getClientDetails.regisforTaxinSA){client.client_registed_for_income_tax = getClientDetails.regisforTaxinSA;}else{client.client_registed_for_income_tax = '';}
                            client.client_registed_for_income_tax_values = this.setRadioBtnInput(component, client.client_registed_for_income_tax, client.client_registed_for_income_tax_values);
                            if (client.client_registed_for_income_tax == 'N'){
                                client.sa_income_tax_number = '0';
                            } else{
                                client.sa_income_tax_number = getClientDetails.SAtaxNumber;
                                
                                if(client.sa_income_tax_number == "0"){
                                    client.sa_income_tax_number = "";
                                }
                            }    
                            
                             if (getClientDetails.reasonSATaxnotgiven){                               
                                let reason_sa_income_tax_number_not_given = (client.reason_sa_income_tax_num_not_given_values.filter(el => el.value == getClientDetails.reasonSATaxnotgiven));
                                 client.reason_sa_income_tax_number_not_given_label = reason_sa_income_tax_number_not_given.length == 1 ? reason_sa_income_tax_number_not_given[0].label : "";
                                client.reason_sa_income_tax_number_not_given_value = getClientDetails.reasonSATaxnotgiven;  
                            } 
                            
                             if(getClientDetails.foreignTaxregis){client.client_registered_for_foreign_income_tax = getClientDetails.foreignTaxregis;}else{client.client_registered_for_foreign_income_tax = '';}
                            client.client_registered_for_foreign_income_tax_values = this.setRadioBtnInput(component, client.client_registered_for_foreign_income_tax, client.client_registered_for_foreign_income_tax_values);
                            
       						 let arrayOfforeign_income_tax = obj.CIgetClientDetailsV20.CIgetClientDetailsV20OutPut.foreignTaxDataTable[0];
                            client.foreign_income_tax_number = arrayOfforeign_income_tax.foreignTaxNo;                            
                            
                            //added 9/18/2020
                            if (client.client_registered_for_foreign_income_tax == 'N'){client.foreign_income_tax_number = '0';}else{client.foreign_income_tax_number = arrayOfforeign_income_tax.foreignTaxNo;}
                             
                           
                             if (arrayOfforeign_income_tax.reasonForeignTaxnotgiven){
                                let reason_foreign_income_tax_num_not_given = (client.reason_foreign_income_tax_num_not_given_values.filter(el => el.value == arrayOfforeign_income_tax.reasonForeignTaxnotgiven));
                                client.reason_foreign_income_tax_num_not_given_label = reason_foreign_income_tax_num_not_given.length == 1 ? reason_foreign_income_tax_num_not_given[0].label : "";
                                client.reason_foreign_income_tax_num_not_given_value = arrayOfforeign_income_tax.reasonForeignTaxnotgiven;  
                            } 
                            
                            if(client.foreign_income_tax_number){
                                client.reason_foreign_income_tax_num_not_given_value = '';
                            }
                            
                            
                            client.foreign_tax_ctry = arrayOfforeign_income_tax.foreignTaxCtry;
                            
                            //End 18Sep2020
                            
                     
                            client.first_name = getClientDetails.firstNames;
                            client.surname_comp = getClientDetails.surname;                              
                            client.id_reg_no = getClientDetails.idNumber;  
                            client.client_type_grp = getClientDetails.clientGroup;                                                                                                          
                            client.cntry_of_res = getClientDetails.countryResAddress;
                            
                            
                            //   validate ---------------------------------------------
                            client.client_agrmnt_issued = getClientDetails.clntAgrmntIssued;
                            
                            //Below fields required for update service
                            client.cellphone_bank_ind = getClientDetails.cellphoneBankInd;
                            client.court_authrity_hold = getClientDetails.courtAuthrityHold;
                            client.curatorship_hold = getClientDetails.curatorshipHold;
                            client.dte_apply_counsel = getClientDetails.dteApplyCounsel;
                            client.deceased_estate_hld = getClientDetails.deceasedEstateHld;
                            client.deceased_spouse_hld = getClientDetails.deceasedSpouseHld;
                            client.employer_addr_hold = getClientDetails.employerAddrHold;
                            client.exli_policy = getClientDetails.exliPolicy;
                            client.exst_policy = getClientDetails.exstPolicy;
                            client.flexi_funeral_policy = getClientDetails.flexiFuneralPolicy;
                            client.ibr_affected = getClientDetails.ibrAffected;
                            client.id_required_hold = getClientDetails.idRequiredHold;
                            client.in_business_rescue = getClientDetails.inBusinessRescue;
                            client.iniv_policy = getClientDetails.inivPolicy;
                            client.inli_policy = getClientDetails.inliPolicy;
                            client.insolvnt_estate_hld = getClientDetails.insolvntEstateHld;
                            client.insolvent_indicator= getClientDetails.insolvntEstateHld;
                            client.inst_policy = getClientDetails.instPolicy;
                            client.internet_bankin_ind = getClientDetails.internetBankinInd;
                            if(client.internet_bankin_ind == 'Y'){
                                client.internet_bankin_ind = 'Yes';
                            }else{
                                client.internet_bankin_ind = 'No';
                            }
                            
                            client.liability_indicator = getClientDetails.liabilityIndicator;
                            client.mandate_captur_hld = getClientDetails.mandateCaptureHld;
                            client.notify_me_indicator= getClientDetails.notifyMeIndicator;
                            client.physical_address_hold = getClientDetails.physicalAddressHold;
                            client.placed_by = getClientDetails.placedBy;
                            client.postal_addr_hold = getClientDetails.postalAddrHold;
                            client.postl_addr_line1 = getClientDetails.postlAddrLine1;
                            client.postl_addr_line2 = getClientDetails.postlAddrLine2;
                            //client.power_attorny_hold = getClientDetails.powerAttornyHold;
                            client.prohibited_ind = getClientDetails.prohibitedInd;
                            client.savng_statement_hold = getClientDetails.savngStatementHold;
                            client.security_indicator = getClientDetails.securityIndicator;
                            client.sub_segment = getClientDetails.subSegment;
                            client.telebank_indicator = getClientDetails.telebankIndicator;
                            client.unclaimed_funds_ind = getClientDetails.unclaimedFundsInd;
                            client.banking_sector = getClientDetails.bankingSector;
                            //client.percentage = getClientDetails.classPercentageTable[0].percentage; to be verified
                            //
                            client.power_attorny_hold = getClientDetails.powerAttornyHold;
                            if(client.power_attorny_hold)
                            {
                                if(client.power_attorny_hold == 'Y'){
                                     client.power_attorny_hold = 'Yes'; 
                                }else{
                                    client.power_attorny_hold = 'No'; 
                                }
                              
                            }else{
                                 client.power_attorny_hold = 'No'; 
                            }
                            //client.internet_bankin_ind = getClientDetails.internetBankinInd;
                            client.outstanding_bond = client.outstanding_bond;
                            client.realistic_market_value = client.realistic_market_value;                            
                            component.set("v.client", client);    
                              
                            component.set("v.openSecurityQuestions", true);
                            
                            this.getCasaScreeningHelper(component, event);
                        }
                    } else {
                        this.messageModal(component, true, 'Get client info warning', res.Data.dataMap.getBody);
                    }
                } else {
                    this.messageModal(component, true, 'Get client info message', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'Get client info error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    //3rd service
    getCasaScreeningHelper: function(component, event) {
        
        
        let id_number = component.get("v.client.id_number");
        
        if(!id_number){
            return;
        }
        
        var client = component.get("v.client");
                
        
        if (client.first_name && client.surname_comp && client.id_type_value && client.id_reg_no && client.client_type_grp && client.date_of_birth_casa_screening && client.nationality_value && client.cntry_of_res && client.sbu && client.channel && client.teller_code && client.branch_code) {
            var clientData = '{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '","firstName":"' + client.first_name + '","surnameComp":"' + client.surname_comp + '","idType":"' + client.id_type_value+ '","idRegNo":"' + client.id_reg_no + '","clientTypeGrp":"' + client.client_type_grp + '","dob":"' + client.date_of_birth_casa_screening + '","nationality":"' + client.nationality_value+ '","town":"' + client.reg_town + '","territory":"' + client.territory + '","cntryOfRes":"' + client.cntry_of_res + '","cntryOfBirth":"' + client.country_of_birth_value+ '","registerCity":"' + client.reg_town + '","countryPassport":"' + client.country_passport + '","headofficeTown":"' + client.headoffice_town + '","headofficeCntry":"' + client.headoffice_cntry + '","headofficeOtherCntry1":"' + client.headoffice_other_cntry1 + '","headofficeOtherCntry2":"' + client.headoffice_other_cntry2 + '","headofficeOtherCntry3":"' + client.headoffice_other_cntry3 + '","headofficeOtherCntry4":"' + client.headoffice_other_cntry4 + '","headofficeOtherCntry5":"' + client.headoffice_other_cntry5 + '","sbu":"' + client.sbu + '","originatingSys":"' + client.channel + '","branch":"' + client.branch_code + '","teller":"' + client.teller + '"}';
            clientData = clientData.replace(/undefined/g, ''); 
            clientData = clientData.replace(/null/g, '');                     
            console.log('casa requ: '+clientData);
            var action = component.get("c.wqcasascreenprimaryclient");
            
            action.setParams({
                clientData: clientData
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var errors = response.getError();
                var res = response.getReturnValue();
                
                if (component.isValid() && state === "SUCCESS") {
                    if (res.IsSuccess) {
                        if (res.Data.dataMap.getStatusCode == 200) {
                        var getCasaApi = JSON.parse(res.Data.dataMap.getBody);
                            console.log('Res: '+res.Data.dataMap.getBody);
                        
                        if (getCasaApi) {
                            var client = component.get("v.client");
                            client.casa_screen_version = getCasaApi.version;
                            client.casa_screen_returnCode = getCasaApi.returnCode;
                            client.casa_screen_reasonCode = getCasaApi.reasonCode;
                            client.casa_screen_serviceVersion = getCasaApi.serviceVersion;
                            client.casa_screen_echoKey = getCasaApi.echoKey;
                            client.casa_screen_msgNo = getCasaApi.msgNo;                            
                            client.casa_reference = getCasaApi.refNo;
                            client.casa_screen_massage = getCasaApi.msg;
                            client.casa_screen_status = getCasaApi.status;
                            
                            component.set("v.client", client);
                            
                            if (client.casa_screen_status == 'P') {
                                console.log("casa_screen_status == P");
                                this.WQriskProfileClientHelper(component, event);
                                //this.WQgetCASADocumentsByRefNoV1Helper(component, event);  // we need to remove this,WQriskProfileClientHelper was timing out 
                            } else if (client.casa_screen_status == 'M') {
                                console.log("casa_screen_status == M");
                                this.messageModal(component, true, 'CASA screening', 'Verify the customer for Risk');
                                //this.errorMessagesHelper(component, event, 'CASA screening','Verify the customer for Risk','errors');
                                this.WQriskProfileClientHelper(component, event);
                            }else{
                                this.errorMessagesHelper(component, event, 'CASA screening','Verify the customer for Risk','errors');
                            }
                          }
                        }else {
                        //this.messageModal(component, true, 'CASA screening exception', errors);
                        this.errorMessagesHelper(component, event, 'CASA screening exception',errors,'errors');    
                    }
                    } else {
                        //this.messageModal(component, true, 'CASA screening warning', res.Message);
                        this.errorMessagesHelper(component, event, 'CASA screening warning',res.Message,'res');
                    }
                } else {
                    //this.messageModal(component, true, 'CASA screening error', errors[0].message);
                    this.errorMessagesHelper(component, event, 'CASA screening error',errors[0].message,'errors');
                }
            });
            $A.enqueueAction(action);
        } else {
            
            //this.messageModal(component, true, 'Message', 'CASA Screening: Mandatory fields required');
            //return;
            this.errorMessagesHelper(component, event, 'CASA screening message','CASA Screening: Mandatory fields required','errors');
            
        }
    },
    
    /*4th service*/
    WQriskProfileClientHelper: function(component, event) {
        
        let id_number = component.get("v.client.id_number");
        
        if(!id_number){
            return;
        }
        
        let client = component.get("v.client");
        
        var action = component.get("c.wqriskprofileclientv7");
        console.log('==========================================')
        console.log(clientData);
        //var clientData = '{"WQriskProfileClientV7Request":{"customerTypeCode":"' + client.customerTypeCode + '","customerStatusCode":"' + client.customerStatusCode + '","customerSourceUniqueId":"' + client.customerSourceUniqueId + '","companyForm":"' + client.companyForm + '","customerSourceRefID":"' + client.customerSourceRefID + '","primeBranchID":"' + client.primeBranchID + '","channel":"' + client.wqriskprofile_channel + '","sbu":"' + client.sbu + '","originatingsystem":"' + client.originating_system+ '","employmentStatus":"' + client.employmentStatus + '","occupation":"' + client.wqriskprofile_occupation+ '","businessSegment1":"' + client.businessSegment1 + '","cifkey":"' + client.client_key + '","IncorporationCountryCode":"' + client.absaCountriesTradedWith + '","absaCountryTradedWithTable":[{"absaCountriesTradedWith":"'+client.absa_countries_traded_with+'"},{"absaCountriesTradedWith":"'+client.absa_countries_traded_with+'"}],"absaCountryOfOperationTable":[{"absaCountryOfOperation":"'+client.absa_country_of_operation+'"},{"absaCountryOfOperation":"'+client.absa_country_of_operation+'"}],"absaSourceOfIncomeTable":[{"absaSourceOfIncome":"'+client.absa_source_of_income+'"},{"absaSourceOfIncome":"'+client.absa_source_of_income+'"}],"productCodeTable":[{"productCode":"'+client.product_code+'"},{"productCode":"'+client.product_code+'"}],"subProductCodeTable":[{"subProductCode":"'+client.sub_product_code+'"},{"subProductCode":"'+client.sub_product_code+'"}],"userId":"' + client.userId+ '"}}';
        var clientData = '{"WQriskProfileClientV7Request":{"customerTypeCode":"' + client.client_type_grp + '","customerStatusCode":"' + client.customerStatusCode + '","customerSourceUniqueId":"' + client.casa_reference + '","companyForm":"' + client.companyForm + '","customerSourceRefID":"' + client.casa_reference + '","primeBranchID":"' + client.primeBranchID + '","channel":"' + client.wqriskprofile_channel + '","sbu":"' + client.sbu + '","originatingsystem":"' + client.originating_system+ '","employmentStatus":"' + client.occupational_status_value + '","occupation":"' + client.wqriskprofile_occupation+ '","businessSegment1":"' + client.businessSegment1 + '","cifkey":"' + client.client_key + '","IncorporationCountryCode":"' + client.IncorporationCountryCode + '","absaCountryTradedWithTable":[{"absaCountriesTradedWith":"'+client.absa_countries_traded_with+'"},{"absaCountriesTradedWith":"'+client.absa_countries_traded_with+'"}],"absaCountryOfOperationTable":[{"absaCountryOfOperation":"'+client.absa_country_of_operation+'"},{"absaCountryOfOperation":"'+client.absa_country_of_operation+'"}],"absaSourceOfIncomeTable":[{"absaSourceOfIncome":"'+client.source_of_income_value+'"},{"absaSourceOfIncome":"'+client.source_of_income_value+'"}],"productCodeTable":[{"productCode":"'+client.product_code+'"},{"productCode":"'+client.product_code+'"}],"subProductCodeTable":[{"subProductCode":"'+client.sub_product_code+'"},{"subProductCode":"'+client.sub_product_code+'"}],"userId":"' + client.userId+ '"}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        var getRiskProfileClientDetails = obj.WQriskProfileClientV7Response;
                        client.msgNo = getRiskProfileClientDetails.msgNo;
                        client.msg = getRiskProfileClientDetails.msg;
                        client.riskRating = getRiskProfileClientDetails.riskRating;
                        if (getRiskProfileClientDetails.riskRating == 'VL') { 
                            console.log("riskRating == VL");
                        } 
                        else if(getRiskProfileClientDetails.riskRating == 'L') {                            
                          console.log("riskRating == L");
                        }
                        else if(getRiskProfileClientDetails.riskRating == 'M') {                            
                          console.log("riskRating == M");
                        }
                        else if(getRiskProfileClientDetails.riskRating == 'H') {
                            console.log("riskRating == H");
                            this.errorMessagesHelper(component, event, 'Risk profile message','This record is referred for authorisation before continuing with the process. Halt your processing','errors');
                        }
                        else if(getRiskProfileClientDetails.riskRating == 'VH') { 
                            console.log("riskRating == VH");
                            this.errorMessagesHelper(component, event, 'Risk profile message','This record is referred for authorisation before continuing with the process. Halt your processing','errors');
                        }else {
                            this.errorMessagesHelper(component, event, 'Risk profile message',client.msg,'errors');
                        }
                        
                    } else {
                        //this.messageModal(component, true, 'Risk profile client info warning', res.Data.dataMap.getBody);
                        this.errorMessagesHelper(component, event, 'Risk profile client info warning',res.Data.dataMap.getBody,'errors');
                    }
                } else {
                    //this.messageModal(component, true, 'Risk profile client info message', res.Message);
                    this.errorMessagesHelper(component, event, 'Risk profile client info warning',res.Message,'res');
                }
            } else if (errors && errors.length > 0) {
                //this.messageModal(component, true, 'Risk profile client info error', errors[0].message);
                this.errorMessagesHelper(component, event, 'Risk profile client info error',errors[0].message,'errors');
            }
        });
        $A.enqueueAction(action);
    },
    //5rd service
    WQgetCASADocumentsByRefNoV1Helper: function(component, event) {
        
        let id_number = component.get("v.client.id_number");
        
        if(!id_number){
            return;
        }
        
        var client = component.get("v.client");
        var clientData = '{"WQgetCASADocumentsByRefNoV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"wqp103i":{"refNo":"' + client.casa_reference + '","versionI":"' + client.versionI+ '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.wqgetcasadocumentsbyrefnov1");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var client = component.get("v.client");
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        
                        var WQgetCASADocumentsByRefNoV1API = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (WQgetCASADocumentsByRefNoV1API) {
                            var wqp103o = WQgetCASADocumentsByRefNoV1API.WQgetCASADocumentsByRefNoV1Response.wqp103o;
                            
                            client.branch = wqp103o.branch;
                            client.num_docs = wqp103o.numDocs;
                            client.msg_no = wqp103o.msgNo;
                            client.msg = wqp103o.msg;
                            component.set("v.client", client);
                        }
                        this.wqConfirmDocumentReceiptHelper(component, event);
                    } else {
                        this.messageModal(component, true, 'Get casa documents message', res.Data.dataMap.getBody);
                    }
                } else {
                    this.messageModal(component, true, 'Get casa documents warning', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'Get casa documents error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    //service 6
    wqConfirmDocumentReceiptHelper: function(component, event) {
        
        let id_number = component.get("v.client.id_number");
        
        if(!id_number){
            return;
        }
        
        var client = component.get("v.client");
        var action = component.get("c.WQconfirmDocumentReceipt");
        
        //var clientData = '{"WQconfirmDocumentReceiptV2":{"nbsapdpi":{"channel":"ESP","application":"ESP","trace":"Y"},"wqp131i":{"refNo":"1742694","version":"241","branch":"5920","user":"abssac3","docNo":"7","requiredDocs":[{"docCode":"000001","received":"Y","inOrder":"Y","scanYn":"N"},{"docCode":"000004","received":"Y","inOrder":"Y","scanYn":"N"},{"docCode":"000053","received":"Y","inOrder":"Y","scanYn":"N"},{"docCode":"000054","received":"Y","inOrder":"Y","scanYn":"N"},{"docCode":"000055","received":"Y","inOrder":"Y","scanYn":"N"},{"docCode":"000058","received":"Y","inOrder":"Y","scanYn":"N"},{"docCode":"000059","received":"Y","inOrder":"Y","scanYn":"N"}]}}}';
        var clientData = '{"WQconfirmDocumentReceiptV2":{"nbsapdpi":{"channel":"'+client.wqConfirmDocumentReceipt_channel+'","application":"'+client.wqConfirmDocumentReceipt_application+'","trace":"'+client.trace+'"},"wqp131i":{"refNo":"'+client.casa_reference+'","version":"'+client.wqConfirmDocumentReceipt_version+'","branch":"'+client.wqConfirmDocumentReceipt_branch+'","user":"'+client.userId+'","docNo":"'+client.wqConfirmDocumentReceipt_docNo+'","requiredDocs":[{"docCode":"'+client.wqConfirmDocumentReceipt_docCode+'","received":"'+client.wqConfirmDocumentReceipt_received+'","inOrder":"'+client.wqConfirmDocumentReceipt_inOrder+'","scanYn":"'+client.wqConfirmDocumentReceipt_scanYn+'"},{"docCode":"'+client.wqConfirmDocumentReceipt_docCode+'","received":"'+client.wqConfirmDocumentReceipt_received+'","inOrder":"'+client.wqConfirmDocumentReceipt_inOrder+'","scanYn":"'+client.wqConfirmDocumentReceipt_scanYn+'"},{"docCode":"'+client.wqConfirmDocumentReceipt_docCode+'","received":"'+client.wqConfirmDocumentReceipt_received+'","inOrder":"'+client.wqConfirmDocumentReceipt_inOrder+'","scanYn":"'+client.wqConfirmDocumentReceipt_scanYn+'"},{"docCode":"'+client.wqConfirmDocumentReceipt_docCode+'","received":"'+client.wqConfirmDocumentReceipt_received+'","inOrder":"'+client.wqConfirmDocumentReceipt_inOrder+'","scanYn":"'+client.wqConfirmDocumentReceipt_scanYn+'"},{"docCode":"'+client.wqConfirmDocumentReceipt_docCode+'","received":"'+client.wqConfirmDocumentReceipt_received+'","inOrder":"'+client.wqConfirmDocumentReceipt_inOrder+'","scanYn":"'+client.wqConfirmDocumentReceipt_scanYn+'"},{"docCode":"'+client.wqConfirmDocumentReceipt_docCode+'","received":"'+client.wqConfirmDocumentReceipt_received+'","inOrder":"'+client.wqConfirmDocumentReceipt_inOrder+'","scanYn":"'+client.wqConfirmDocumentReceipt_scanYn+'"},{"docCode":"'+client.wqConfirmDocumentReceipt_docCode+'","received":"'+client.wqConfirmDocumentReceipt_received+'","inOrder":"'+client.wqConfirmDocumentReceipt_inOrder+'","scanYn":"'+client.wqConfirmDocumentReceipt_scanYn+'"}]}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('Risk object: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        var getWQConfirmDocumentReceiptDetails = obj.WQconfirmDocumentReceiptV2Response.wqp131o;
                        client.wg_conf_doc_msgNo = getWQConfirmDocumentReceiptDetails.msgNo;
                        client.wg_conf_doc_msg = getWQConfirmDocumentReceiptDetails.msg;
                        
                    } else {
                        this.messageModal(component, true, 'WQ confirm document receipt info warning', res.Data.dataMap.getBody);
                    }
                } else {
                    this.messageModal(component, true, 'WQ confirm document receipt info message', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'WQ confirm document receipt info error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    //service 7 - update CIF service 	
    updateCIFHelper: function(component, event) {
        this.dispaySpinner(component, event, 'Updating client details...');
        var client = component.get("v.client");  
        if(client.marital_status_value){if(client.marital_status_value !="1"){client.marital_contract_value = "0";}}
        if(!client.sa_income_tax_number) {client.sa_income_tax_number = "0";}         

        //Newly added Monday, i
        if (client.work_telephone_number.toString().length == 10)
        {
            var work_tel_num = client.work_telephone_number.substring(3);
            var work_tel_code = client.work_telephone_number.substring(0,3);
        }
        else{
            if (client.work_telephone_number.toString().length == 0)
            {
                var work_tel_num = ''; 
                var work_tel_code='0';}
        }
        
        if (client.home_fax_number.toString().length == 10)
        {
            var home_fax_num = client.home_fax_number.substring(3);
        	var home_fax_code = client.home_fax_number.substring(0,3);
         }
        else{
            if (client.home_fax_number.toString().length == 1 || client.home_fax_number.toString().length == 0)
            {
                var home_fax_num = '0000000'; 
                var home_fax_code = '000';
            }
        }
        
        if (client.work_fax_number.toString().length == 10)
        {
            var work_fax_num = client.work_fax_number.substring(3);
         	var work_fax_code = client.work_fax_number.substring(0,3);
        }
        else{
            if (client.work_fax_number.toString().length == 1 || client.work_fax_number.toString().length == 0)
            {
                var work_fax_num = '0000000';
                var work_fax_code='000';
            }
        }
        
        if (client.home_telephone_number.toString().length == 10){var home_tel_num = client.home_telephone_number.substring(3);var home_tel_code = client.home_telephone_number.substring(0,3);} else{
            if (client.home_telephone_number.toString().length == 1 || client.home_telephone_number.toString().length == 0){var home_tel_num = ''; var home_tel_code='0';}
        }      
        
        if(!client.post_matric_qualification_value){
            client.post_matric_qualification_value = "0";
        }
        
        
        let post = client.postal_code;
         
        //var clientData = '{"CIupdateClientDetailV20":{"CIupdateClientDetailV20Input":{"absaRewardInd":"'+client.absa_reward_indctor+'","affectedPerson":"'+client.affected_person+'","agriClassTabel":[{"agriClass":"'+client.agri_class+'","percentage":"'+client.percentage+'"}],"applyDebtCounselInd":"'+client.debt_counseling+'","bankingSector":"'+client.banking_sector+'","birthDate":"'+client.date_of_birth_value+'","branchClientOpen":"'+client.branch_client_opened+'","businessAdd1":"'+client.business_add1+'","businessAdd2":"'+client.business_add2+'","businessAddrSeqNbr":"'+client.business_addr_seq_nbr+'","businessAddrType":"'+client.business_address_type+'","businessPostal":"'+client.business_postal+'","businessSuburb":"'+client.business_suburb+'","businessTown":"'+client.business_town+'","casaRefNum":"'+client.casa_reference+'","cellphone":"'+client.cellphone_number+'","cellphoneBankInd":"'+client.cellphone_bank_ind+'","changeNumber":"'+client.change_number+'","clientAgrmntIssued":"'+client.client_agrmnt_issued+'","clientCode":"'+client.client_key+'","clientNationality":"'+client.nationality_value+'","clientType":"'+client.client_type+'","clientWebsite":"'+client.client_website+'","companyYearEnd":"'+client.company_year_end+'","contOride":"'+client.cont_oride+'","contactPerson":"'+client.contact_person+'","corporateDivision":"'+client.corporate_division+'","countryHoAddress":"'+client.country_ho_address+'","countryIncorp":"'+client.country_incorp+'","countryOfBirth":"'+client.country_of_birth_value+'","countryOfOrigin":"'+client.country_of_origin+'","countryRegAddress":"'+client.country_reg_address+'","countryResAddress":"'+client.residential_address_country_value+'","courtAuthrityHold":"'+client.court_authrity_hold+'","cpaThreshold":"'+client.cpa_threshold+'","creditMarketingAutoVoice":"'+client.credit_auto_voice+'","creditMarketingEmail":"'+client.credit_email+'","creditMarketingGroupInd":"'+client.credit_marketing_group_ind+'","creditMarketingPost":"'+client.credit_post+'","creditMarketingSms":"'+client.credit_SMS+'","creditMarketingTelephone":"'+client.credit_tel+'","curatorshipHold":"'+client.curatorship_hold+'","dateBusRescueIss":"'+client.date_bus_rescue_iss+'","dateClientOpened":"'+client.date_client_opened+'","dateExempted":"'+client.date_exempted+'","dateIdentified":"'+client.fica_date_identified_value+'","dateIssued":"'+client.id_date_issued_value+'","dateLastChanged":"'+client.date_last_changed+'","dateVerified":"'+client.current_address_since_value+'","debtCounselApplyDate":"'+client.dte_apply_counsel+'","debtCounselOrderIssueDate":"'+client.debt_counsel_order_issue_date+'","debtCounselOrderIssuedInd":"'+client.debt_counsel_order_issued_ind+'","deceasedEstateHld":"'+client.deceased_estate_hld+'","deceasedSpouseHld":"'+client.deceased_spouse_hld+'","designation":"'+client.occupation_value+'","emailAddress":"'+client.email_address+'","emailMarkInd":"'+client.email+'","employeeExempted":"'+client.employee_exempted+'","employeeIdentified":"'+client.employee_identified+'","employeeVerified":"'+client.employee_verified+'","employerAdd1":"'+client.empl_postal_address_line_1+'","employerAdd2":"'+client.empl_postal_address_line_1_3+'","employerAddrHold":"'+client.employer_addr_hold+'","employerAddrSeqNbr":"'+client.employer_addr_seq_nbr+'","employerAddrType":"'+client.employer_addr_type+'","employerPostal":"'+client.empl_postal_code+'","employerSuburb":"'+client.empl_addr_suburb_rsa+'","employerTown":"'+client.empl_town_city_foreign_country+'","employmentSector":"'+client.employment_sector_value+'","entOprtDataTabel":[{"countryEntOprt":"'+client.country_ent_oprt+'"}],"exconExpiryDate":"'+client.excon_expiry_date+'","exemptionIndicator":"'+client.exemption_indicator+'","exemptionStatus":"'+client.exemption_status+'","exliPolicy":"'+client.exli_policy+'","exstPolicy":"'+client.exst_policy+'","faxHomeCode":"'+home_fax_code+'","faxHomeNumber":"'+home_fax_num+'","faxWorkCode":"'+work_fax_code+'","faxWorkNumber":"'+work_fax_num+'","firstNames":"'+client.first_names+'","flexiFuneralPolicy":"'+client.flexi_funeral_policy+'","foreignTaxDataTabel":[{"foreignTaxCtry":"'+client.foreign_tax_ctry+'","foreignTaxNo":"'+client.foreign_income_tax_number+'","rsonFtaxNotRegis":"'+client.reason_foreign_income_tax_num_not_given_value+'"}],"foreignTaxregis":"'+client.client_registered_for_foreign_income_tax+'","gender":"'+client.gender_value+'","groupScheme":"'+client.group_scheme+'","groupSchemeEmp":"'+ client.group_scheme_emp+'","haveQualification":"'+client.does_client_havepostmatric_qualification+'","hoAddrLine1":"'+client.ho_addr_line1+'","hoAddrLine2":"'+client.ho_addr_line2+'","hoCodeRsa":"'+client.ho_code_rsa+'","hoSuburb":"'+client.ho_suburb+'","hoTown":"'+client.hos_town+'","homeLanguage":"'+client.home_language_value+'","homeTelCode":"'+home_tel_code+'","homeTelephone":"'+home_tel_num+'","ibrAffected":"'+client.ibr_affected+'","idDocType":"'+client.id_type_value+'","idNumber":"'+client.id_number+'","idRequiredHold":"'+client.id_required_hold+'","inBusinessRescue":"'+client.in_business_rescue+'","incomeGroup":"'+client.monthly_income_value+'","initials":"'+client.initials+'","inivPolicy":"'+client.iniv_policy+'","inliPolicy":"'+client.inli_policy+'","insolventEstateHld":"'+client.insolvnt_estate_hld+'","insolventIndicator":"'+client.insolvent+'","instPolicy":"'+client.inst_policy+'","internetBankinInd":"'+client.internet_bankin_ind+'","language":"'+client.language+'","liabilityIndicator":"'+client.liability_indicator+'","mailInd":"'+client.mail_ind+'","mandateCaptureHld":"'+client.mandate_captur_hld+'","maritalStatus":"'+client.marital_status_value+'","marketingConcent":"'+client.marketing_concent+'","marriageContractType":"'+client.marital_contract_value+'","mclIndicator":"'+client.mcl_indicator+'","miltaryComtmntInd":"'+client.miltaryComtmnt_ind+'","minorChildren":"'+client.dependents_value+'","nbrOfAccounts":"'+client.nbr_of_accounts+'","ncaThreshold":"'+client.nca_threshold+'","nkinCell":"'+client.nkin_cell+'","nkinDcdh":"'+client.nkin_dcdh+'","nkinDcdw":"'+client.nkin_dcdw+'","nkinEmail":"'+client.nkin_email+'","nkinFname":"'+client.nkin_first_name+'","nkinInitials":"'+client.nkin_initials+'","nkinJntSurname":"'+client.nkin_jnt_surname+'","nkinRela":"'+client.nkin_relationship+'","nkinSurname":"'+client.nkin_surname+'","nkinTelh":"'+client.nkin_telh+'","nkinTelw":"'+client.nkin_telw+'","nkinTitle":"'+client.nkin_title+'","noOfJointPartcpnt":"'+client.no_of_joint_partcpnt+'","nonCreditMarketingAutoVoice":"'+client.non_credit_marketing_auto_voice+'","nonCreditMarketingEmail":"'+client.non_credit_marketing_email+'","nonCreditMarketingGroupInd":"'+client.absa_group_electronic+'","nonCreditMarketingPost":"'+client.non_credit_marketing_post+'","nonCreditMarketingSms":"'+client.non_credit_marketing_sms+'","nonCreditMarketingTelephone":"'+client.non_credit_marketing_telephone+'","notificationInd":"'+client.notify_me_indicator+'","occupancyType":"'+client.residential_status_value+'","occupationCode":"'+client.occupation_code_value+'","occupationLevel":"'+client.occupation_level_value+'","occupationStatus":"'+client.occupational_status_value+'","permitExpDte":"'+client.permit_exp_dte+'","physicalAdd1":"'+client.postal_address_line_1+'","physicalAdd2":"'+client.postal_address_line_2+'","physicalAddrHold":"'+client.physical_address_hold+'","physicalAddrSeqNbr":"'+client.addr_seq_nbr+'","physicalAddrType":"'+client.physical_addr_type+'","physicalPostal":"'+client.postal_code+'","physicalTown":"'+client.town_city_foreign_country+'","physicalSuburb":"'+client.physical_suburb_rsa+'","pingitReceive":"'+client.pingit_receive+'","pingitWallet":"'+client.pingit_wallet+'","placedBy":"'+client.placed_by+'","postalAddrHold":"'+client.postal_addr_hold+'","postlAddrLine1":"'+client.postl_addr_line1+'","postlAddrLine2":"'+client.postl_addr_line2+'","postlCodeRsa":"'+client.postal_code+'","postlSuburb":"'+client.postl_suburb+'","postlTown":"'+client.town_city_foreign_country+'","powerAttornyHold":"'+client.power_attorny_hold+'","practiceNumber":"'+client.practice_number+'","prefrdCommtionMthd":"'+client.preffered_communication_channel_value+'","prohibitedInd":"'+client.prohibited_ind+'","regAddrLine1":"'+client.reg_addr_line1+'","regAddrLine2":"'+client.reg_addr_line2+'","regCodeRsa":"'+client.reg_code_rsa+'","regSuburb":"'+client.reg_suburb+'","regTown":"'+client.reg_town+'","resPermitNbr":"'+client.res_permit_number+'","rsonSaTaxNotregis":"'+client.reason_sa_income_tax_number_not_given_value+'","SAtaxNumber":"'+client.sa_income_tax_number+'","saTaxRegis":"'+client.client_registed_for_income_tax+'","savngStatementHold":"'+client.savng_statement_hold+'","sbuSegment":"'+client.sbu_segment+'","sec129DeliveryAddr":"'+client.section_129_notice_delivery_address_value+'","secondaryCardInd":"'+client.secondary_card+'","securityIndicator":"'+client.security_indicator+'","sicCode":"'+client.sic_code+'","siccCode5":"'+client.sicc_code5+'","siteLastChanged":"'+client.site_last_changed+'","smsMarketInd":"'+client.sms+'","socialGrant":"'+client.social_grant+'","sourceOfIncome":"'+client.source_of_income_value+'","subClassCde":"'+client.sub_class_cde+'","subSegment":"'+client.sub_segment+'","surname":"'+client.surname+'","teleMarkInd":"'+client.voice_recording+'","telebankIndicator":"'+client.client_banks_with_absa+'","tellerLastChanged":"'+client.teller_last_changed+'","thrdPartyInd":"'+client.credit_worthiness+'","titleCode":"'+client.title_value+'","unclaimedFundsInd":"'+client.unclaimed_funds_ind+'","updAddressInd":"'+client.upd_address_ind+'","updDateInd":"'+client.upd_date_ind+'","updEmailInd":"'+client.upd_email_ind+'","updTelephoneInd":"'+client.upd_telephone_ind+'","vatRegistrationNo":"'+client.vat_registration_no+'","whatQualification":"'+client.post_matric_qualification_value+'","workTelcode":"'+work_tel_code+'","workTelephone":"'+work_tel_num+'"}},"inputErrorMessage":{"errorMessageParameters":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"inputHeaders":{"inputPayloadHeaders":{"consumerChannel":"'+client.channel+'","providerApplication":"'+client.application+'","traceIndicator":"'+client.trace+'"}}}';
        //var clientData = '{"CIupdateClientDetailV20":{"CIupdateClientDetailV20Input":{"absaRewardInd":"'+client.absa_reward_indctor+'","affectedPerson":"'+client.affected_person+'","agriClassTabel":[{"agriClass":"'+client.agri_class+'","percentage":"'+client.percentage+'"}],"applyDebtCounselInd":"'+client.debt_counseling+'","bankingSector":"'+client.banking_sector+'","birthDate":"'+client.date_of_birth_value+'","branchClientOpen":"'+client.branch_client_opened+'","businessAdd1":"'+client.business_add1+'","businessAdd2":"'+client.business_add2+'","businessAddrSeqNbr":"'+client.business_addr_seq_nbr+'","businessAddrType":"'+client.business_address_type+'","businessPostal":"'+client.business_postal+'","businessSuburb":"'+client.business_suburb+'","businessTown":"'+client.business_town+'","casaRefNum":"'+client.casa_reference+'","cellphone":"'+client.cellphone_number+'","cellphoneBankInd":"'+client.cellphone_bank_ind+'","changeNumber":"'+client.change_number+'","clientAgrmntIssued":"'+client.client_agrmnt_issued+'","clientCode":"'+client.client_key+'","clientNationality":"'+client.nationality_value+'","clientType":"'+client.client_type+'","clientWebsite":"'+client.client_website+'","companyYearEnd":"'+client.company_year_end+'","contOride":"'+client.cont_oride+'","contactPerson":"'+client.contact_person+'","corporateDivision":"'+client.corporate_division+'","countryHoAddress":"'+client.country_ho_address+'","countryIncorp":"'+client.country_incorp+'","countryOfBirth":"'+client.country_of_birth_value+'","countryOfOrigin":"'+client.country_of_origin+'","countryRegAddress":"'+client.country_reg_address+'","countryResAddress":"'+client.residential_address_country_value+'","courtAuthrityHold":"'+client.court_authrity_hold+'","cpaThreshold":"'+client.cpa_threshold+'","creditMarketingAutoVoice":"'+client.credit_auto_voice+'","creditMarketingEmail":"'+client.credit_email+'","creditMarketingGroupInd":"'+client.credit_marketing_group_ind+'","creditMarketingPost":"'+client.credit_post+'","creditMarketingSms":"'+client.credit_SMS+'","creditMarketingTelephone":"'+client.credit_tel+'","curatorshipHold":"'+client.curatorship_hold+'","dateBusRescueIss":"'+client.date_bus_rescue_iss+'","dateClientOpened":"'+client.date_client_opened+'","dateExempted":"'+client.date_exempted+'","dateIdentified":"'+client.fica_date_identified_value+'","dateIssued":"'+client.id_date_issued_value+'","dateLastChanged":"'+client.date_last_changed+'","dateVerified":"'+client.current_address_since_value+'","debtCounselApplyDate":"'+client.dte_apply_counsel+'","debtCounselOrderIssueDate":"'+client.debt_counsel_order_issue_date+'","debtCounselOrderIssuedInd":"'+client.debt_counsel_order_issued_ind+'","deceasedEstateHld":"'+client.deceased_estate_hld+'","deceasedSpouseHld":"'+client.deceased_spouse_hld+'","designation":"'+client.occupation_value+'","emailAddress":"'+client.email_address+'","emailMarkInd":"'+client.email+'","employeeExempted":"'+client.employee_exempted+'","employeeIdentified":"'+client.employee_identified+'","employeeVerified":"'+client.employee_verified+'","employerAdd1":"'+client.empl_postal_address_line_1+'","employerAdd2":"'+client.empl_postal_address_line_1_3+'","employerAddrHold":"'+client.employer_addr_hold+'","employerAddrSeqNbr":"'+client.employer_addr_seq_nbr+'","employerAddrType":"'+client.employer_addr_type+'","employerPostal":"'+client.empl_postal_code+'","employerSuburb":"'+client.empl_addr_suburb_rsa+'","employerTown":"'+client.empl_town_city_foreign_country+'","employmentSector":"'+client.employment_sector_value+'","entOprtDataTabel":[{"countryEntOprt":"'+client.country_ent_oprt+'"}],"exconExpiryDate":"'+client.excon_expiry_date+'","exemptionIndicator":"'+client.exemption_indicator+'","exemptionStatus":"'+client.exemption_status+'","exliPolicy":"'+client.exli_policy+'","exstPolicy":"'+client.exst_policy+'","faxHomeCode":"'+home_fax_code+'","faxHomeNumber":"'+home_fax_num+'","faxWorkCode":"'+work_fax_code+'","faxWorkNumber":"'+work_fax_num+'","firstNames":"'+client.first_names+'","flexiFuneralPolicy":"'+client.flexi_funeral_policy+'","foreignTaxDataTabel":[{"foreignTaxCtry":"'+client.foreign_tax_ctry+'","foreignTaxNo":"'+client.foreign_income_tax_number+'","rsonFtaxNotRegis":"'+client.reason_foreign_income_tax_num_not_given_value+'"}],"foreignTaxregis":"'+client.client_registered_for_foreign_income_tax+'","gender":"'+client.gender_value+'","groupScheme":"'+client.group_scheme+'","groupSchemeEmp":"'+ client.group_scheme_emp+'","haveQualification":"'+client.does_client_havepostmatric_qualification+'","hoAddrLine1":"'+client.ho_addr_line1+'","hoAddrLine2":"'+client.ho_addr_line2+'","hoCodeRsa":"'+client.ho_code_rsa+'","hoSuburb":"'+client.ho_suburb+'","hoTown":"'+client.hos_town+'","homeLanguage":"'+client.home_language_value+'","homeTelCode":"'+home_tel_code+'","homeTelephone":"'+home_tel_num+'","ibrAffected":"'+client.ibr_affected+'","idDocType":"'+client.id_type_value+'","idNumber":"'+client.id_number+'","idRequiredHold":"'+client.id_required_hold+'","inBusinessRescue":"'+client.in_business_rescue+'","incomeGroup":"'+client.monthly_income_value+'","initials":"'+client.initials+'","inivPolicy":"'+client.iniv_policy+'","inliPolicy":"'+client.inli_policy+'","insolventEstateHld":"'+client.insolvnt_estate_hld+'","insolventIndicator":"'+client.insolvent+'","instPolicy":"'+client.inst_policy+'","internetBankinInd":"'+client.internet_bankin_ind+'","language":"'+client.language+'","liabilityIndicator":"'+client.liability_indicator+'","mailInd":"'+client.mail_ind+'","mandateCaptureHld":"'+client.mandate_captur_hld+'","maritalStatus":"'+client.marital_status_value+'","marketingConcent":"'+client.marketing_concent+'","marriageContractType":"'+client.marital_contract_value+'","mclIndicator":"'+client.mcl_indicator+'","miltaryComtmntInd":"'+client.miltaryComtmnt_ind+'","minorChildren":"'+client.dependents_value+'","nbrOfAccounts":"'+client.nbr_of_accounts+'","ncaThreshold":"'+client.nca_threshold+'","nkinCell":"'+client.nkin_cell+'","nkinDcdh":"'+client.nkin_dcdh+'","nkinDcdw":"'+client.nkin_dcdw+'","nkinEmail":"'+client.nkin_email+'","nkinFname":"'+client.nkin_first_name+'","nkinInitials":"'+client.nkin_initials+'","nkinJntSurname":"'+client.nkin_jnt_surname+'","nkinRela":"'+client.nkin_relationship+'","nkinSurname":"'+client.nkin_surname+'","nkinTelh":"'+client.nkin_telh+'","nkinTelw":"'+client.nkin_telw+'","nkinTitle":"'+client.nkin_title+'","noOfJointPartcpnt":"'+client.no_of_joint_partcpnt+'","nonCreditMarketingAutoVoice":"'+client.non_credit_marketing_auto_voice+'","nonCreditMarketingEmail":"'+client.email+'","nonCreditMarketingGroupInd":"'+client.absa_group_electronic+'","nonCreditMarketingPost":"'+client.non_credit_marketing_post+'","nonCreditMarketingSms":"'+client.sms+'","nonCreditMarketingTelephone":"'+client.voice_recording+'","notificationInd":"'+client.notify_me_indicator+'","occupancyType":"'+client.residential_status_value+'","occupationCode":"'+client.occupation_code_value+'","occupationLevel":"'+client.occupation_level_value+'","occupationStatus":"'+client.occupational_status_value+'","permitExpDte":"'+client.permit_exp_dte+'","physicalAdd1":"'+client.postal_address_line_1+'","physicalAdd2":"'+client.postal_address_line_2+'","physicalAddrHold":"'+client.physical_address_hold+'","physicalAddrSeqNbr":"'+client.addr_seq_nbr+'","physicalAddrType":"'+client.physical_addr_type+'","physicalPostal":"'+client.postal_code+'","physicalTown":"'+client.town_city_foreign_country+'","physicalSuburb":"'+client.physical_suburb_rsa+'","pingitReceive":"'+client.pingit_receive+'","pingitWallet":"'+client.pingit_wallet+'","placedBy":"'+client.placed_by+'","postalAddrHold":"'+client.postal_addr_hold+'","postlAddrLine1":"'+client.postl_addr_line1+'","postlAddrLine2":"'+client.postl_addr_line2+'","postlCodeRsa":"'+client.postal_code+'","postlSuburb":"'+client.postl_suburb+'","postlTown":"'+client.town_city_foreign_country+'","powerAttornyHold":"'+client.power_attorny_hold+'","practiceNumber":"'+client.practice_number+'","prefrdCommtionMthd":"'+client.preffered_communication_channel_value+'","prohibitedInd":"'+client.prohibited_ind+'","regAddrLine1":"'+client.reg_addr_line1+'","regAddrLine2":"'+client.reg_addr_line2+'","regCodeRsa":"'+client.reg_code_rsa+'","regSuburb":"'+client.reg_suburb+'","regTown":"'+client.reg_town+'","resPermitNbr":"'+client.res_permit_number+'","rsonSaTaxNotregis":"'+client.reason_sa_income_tax_number_not_given_value+'","SAtaxNumber":"'+client.sa_income_tax_number+'","saTaxRegis":"'+client.client_registed_for_income_tax+'","savngStatementHold":"'+client.savng_statement_hold+'","sbuSegment":"'+client.sbu_segment+'","sec129DeliveryAddr":"'+client.section_129_notice_delivery_address_value+'","secondaryCardInd":"'+client.secondary_card+'","securityIndicator":"'+client.security_indicator+'","sicCode":"'+client.sic_code+'","siccCode5":"'+client.sicc_code5+'","siteLastChanged":"'+client.site_last_changed+'","smsMarketInd":"'+client.sms+'","socialGrant":"'+client.social_grant+'","sourceOfIncome":"'+client.source_of_income_value+'","subClassCde":"'+client.sub_class_cde+'","subSegment":"'+client.sub_segment+'","surname":"'+client.surname+'","teleMarkInd":"'+client.voice_recording+'","telebankIndicator":"'+client.client_banks_with_absa+'","tellerLastChanged":"'+client.teller_last_changed+'","thrdPartyInd":"'+client.credit_worthiness+'","titleCode":"'+client.title_value+'","unclaimedFundsInd":"'+client.unclaimed_funds_ind+'","updAddressInd":"'+client.upd_address_ind+'","updDateInd":"'+client.upd_date_ind+'","updEmailInd":"'+client.upd_email_ind+'","updTelephoneInd":"'+client.upd_telephone_ind+'","vatRegistrationNo":"'+client.vat_registration_no+'","whatQualification":"'+client.post_matric_qualification_value+'","workTelcode":"'+work_tel_code+'","workTelephone":"'+work_tel_num+'"}},"inputErrorMessage":{"errorMessageParameters":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"inputHeaders":{"inputPayloadHeaders":{"consumerChannel":"'+client.channel+'","providerApplication":"'+client.application+'","traceIndicator":"'+client.trace+'"}}}';
        var clientData = '{"CIupdateClientDetailV20":{"CIupdateClientDetailV20Input":{"absaRewardInd":"'+client.absa_reward_indctor+'","affectedPerson":"'+client.affected_person+'","agriClassTabel":[{"agriClass":"'+client.agri_class+'","percentage":"'+client.percentage+'"}],"applyDebtCounselInd":"'+client.debt_counseling+'","bankingSector":"'+client.banking_sector+'","birthDate":"'+client.date_of_birth_value+'","branchClientOpen":"'+client.branch_client_opened+'","businessAdd1":"'+client.business_add1+'","businessAdd2":"'+client.business_add2+'","businessAddrSeqNbr":"'+client.business_addr_seq_nbr+'","businessAddrType":"'+client.business_address_type+'","businessPostal":"'+client.business_postal+'","businessSuburb":"'+client.business_suburb+'","businessTown":"'+client.business_town+'","casaRefNum":"'+client.casa_reference+'","cellphone":"'+client.cellphone_number+'","cellphoneBankInd":"'+client.cellphone_bank_ind+'","changeNumber":"'+client.change_number+'","clientAgrmntIssued":"'+client.client_agrmnt_issued+'","clientCode":"'+client.client_key+'","clientNationality":"'+client.nationality_value+'","clientType":"'+client.client_type+'","clientWebsite":"'+client.client_website+'","companyYearEnd":"'+client.company_year_end+'","contOride":"'+client.cont_oride+'","contactPerson":"'+client.contact_person+'","corporateDivision":"'+client.corporate_division+'","countryHoAddress":"'+client.country_ho_address+'","countryIncorp":"'+client.country_incorp+'","countryOfBirth":"'+client.country_of_birth_value+'","countryOfOrigin":"'+client.country_of_origin+'","countryRegAddress":"'+client.country_reg_address+'","countryResAddress":"'+client.residential_address_country_value+'","courtAuthrityHold":"'+client.court_authrity_hold+'","cpaThreshold":"'+client.cpa_threshold+'","creditMarketingAutoVoice":"'+client.credit_auto_voice+'","creditMarketingEmail":"'+client.credit_email+'","creditMarketingGroupInd":"'+client.credit_marketing_group_ind+'","creditMarketingPost":"'+client.credit_post+'","creditMarketingSms":"'+client.credit_SMS+'","creditMarketingTelephone":"'+client.credit_tel+'","curatorshipHold":"'+client.curatorship_hold+'","dateBusRescueIss":"'+client.date_bus_rescue_iss+'","dateClientOpened":"'+client.date_client_opened+'","dateExempted":"'+client.date_exempted+'","dateIdentified":"'+client.fica_date_identified_value+'","dateIssued":"'+client.id_date_issued_value+'","dateLastChanged":"'+client.date_last_changed+'","dateVerified":"'+client.current_address_since_value+'","debtCounselApplyDate":"'+client.dte_apply_counsel+'","debtCounselOrderIssueDate":"'+client.debt_counsel_order_issue_date+'","debtCounselOrderIssuedInd":"'+client.debt_counsel_order_issued_ind+'","deceasedEstateHld":"'+client.deceased_estate_hld+'","deceasedSpouseHld":"'+client.deceased_spouse_hld+'","designation":"'+client.occupation_value+'","emailAddress":"'+client.email_address+'","emailMarkInd":"'+client.email_mark_ind+'","employeeExempted":"'+client.employee_exempted+'","employeeIdentified":"'+client.employee_identified+'","employeeVerified":"'+client.employee_verified+'","employerAdd1":"'+client.empl_postal_address_line_1+'","employerAdd2":"'+client.empl_postal_address_line_1_3+'","employerAddrHold":"'+client.employer_addr_hold+'","employerAddrSeqNbr":"'+client.employer_addr_seq_nbr+'","employerAddrType":"'+client.employer_addr_type+'","employerPostal":"'+client.empl_postal_code+'","employerSuburb":"'+client.empl_addr_suburb_rsa+'","employerTown":"'+client.empl_town_city_foreign_country+'","employmentSector":"'+client.employment_sector_value+'","entOprtDataTabel":[{"countryEntOprt":"'+client.country_ent_oprt+'"}],"exconExpiryDate":"'+client.excon_expiry_date+'","exemptionIndicator":"'+client.exemption_indicator+'","exemptionStatus":"'+client.exemption_status+'","exliPolicy":"'+client.exli_policy+'","exstPolicy":"'+client.exst_policy+'","faxHomeCode":"'+home_fax_code+'","faxHomeNumber":"'+home_fax_num+'","faxWorkCode":"'+work_fax_code+'","faxWorkNumber":"'+work_fax_num+'","firstNames":"'+client.first_names+'","flexiFuneralPolicy":"'+client.flexi_funeral_policy+'","foreignTaxDataTabel":[{"foreignTaxCtry":"'+client.foreign_tax_ctry+'","foreignTaxNo":"'+client.foreign_income_tax_number+'","rsonFtaxNotRegis":"'+client.reason_foreign_income_tax_num_not_given_value+'"}],"foreignTaxregis":"'+client.client_registered_for_foreign_income_tax+'","gender":"'+client.gender_value+'","groupScheme":"'+client.group_scheme+'","groupSchemeEmp":"'+ client.group_scheme_emp+'","haveQualification":"'+client.does_client_havepostmatric_qualification+'","hoAddrLine1":"'+client.ho_addr_line1+'","hoAddrLine2":"'+client.ho_addr_line2+'","hoCodeRsa":"'+client.ho_code_rsa+'","hoSuburb":"'+client.ho_suburb+'","hoTown":"'+client.hos_town+'","homeLanguage":"'+client.home_language_value+'","homeTelCode":"'+home_tel_code+'","homeTelephone":"'+home_tel_num+'","ibrAffected":"'+client.ibr_affected+'","idDocType":"'+client.id_type_value+'","idNumber":"'+client.id_number+'","idRequiredHold":"'+client.id_required_hold+'","inBusinessRescue":"'+client.in_business_rescue+'","incomeGroup":"'+client.monthly_income_value+'","initials":"'+client.initials+'","inivPolicy":"'+client.iniv_policy+'","inliPolicy":"'+client.inli_policy+'","insolventEstateHld":"'+client.insolvnt_estate_hld+'","insolventIndicator":"'+client.insolvent+'","instPolicy":"'+client.inst_policy+'","internetBankinInd":"'+client.internet_bankin_ind+'","language":"'+client.language+'","liabilityIndicator":"'+client.liability_indicator+'","mailInd":"'+client.mail_ind+'","mandateCaptureHld":"'+client.mandate_captur_hld+'","maritalStatus":"'+client.marital_status_value+'","marketingConcent":"'+client.marketing_concent+'","marriageContractType":"'+client.marital_contract_value+'","mclIndicator":"'+client.mcl_indicator+'","miltaryComtmntInd":"'+client.miltaryComtmnt_ind+'","minorChildren":"'+client.dependents_value+'","nbrOfAccounts":"'+client.nbr_of_accounts+'","ncaThreshold":"'+client.nca_threshold+'","nkinCell":"'+client.nkin_cell+'","nkinDcdh":"'+client.nkin_dcdh+'","nkinDcdw":"'+client.nkin_dcdw+'","nkinEmail":"'+client.nkin_email+'","nkinFname":"'+client.nkin_first_name+'","nkinInitials":"'+client.nkin_initials+'","nkinJntSurname":"'+client.nkin_jnt_surname+'","nkinRela":"'+client.nkin_relationship+'","nkinSurname":"'+client.nkin_surname+'","nkinTelh":"'+client.nkin_telh+'","nkinTelw":"'+client.nkin_telw+'","nkinTitle":"'+client.nkin_title+'","noOfJointPartcpnt":"'+client.no_of_joint_partcpnt+'","nonCreditMarketingAutoVoice":"'+client.non_credit_marketing_auto_voice+'","nonCreditMarketingEmail":"'+client.email+'","nonCreditMarketingGroupInd":"'+client.absa_group_electronic+'","nonCreditMarketingPost":"'+client.non_credit_marketing_post+'","nonCreditMarketingSms":"'+client.sms+'","nonCreditMarketingTelephone":"'+client.voice_recording+'","notificationInd":"'+client.notify_me_indicator+'","occupancyType":"'+client.residential_status_value+'","occupationCode":"'+client.occupation_code_value+'","occupationLevel":"'+client.occupation_level_value+'","occupationStatus":"'+client.occupational_status_value+'","permitExpDte":"'+client.permit_exp_dte+'","physicalAdd1":"'+client.postal_address_line_1+'","physicalAdd2":"'+client.postal_address_line_2+'","physicalAddrHold":"'+client.physical_address_hold+'","physicalAddrSeqNbr":"'+client.addr_seq_nbr+'","physicalAddrType":"'+client.physical_addr_type+'","physicalPostal":"'+client.postal_code+'","physicalTown":"'+client.town_city_foreign_country+'","physicalSuburb":"'+client.physical_suburb_rsa+'","pingitReceive":"'+client.pingit_receive+'","pingitWallet":"'+client.pingit_wallet+'","placedBy":"'+client.placed_by+'","postalAddrHold":"'+client.postal_addr_hold+'","postlAddrLine1":"'+client.postl_addr_line1+'","postlAddrLine2":"'+client.postl_addr_line2+'","postlCodeRsa":"'+client.postal_code+'","postlSuburb":"'+client.postl_suburb+'","postlTown":"'+client.town_city_foreign_country+'","powerAttornyHold":"'+client.power_attorny_hold+'","practiceNumber":"'+client.practice_number+'","prefrdCommtionMthd":"'+client.preffered_communication_channel_value+'","prohibitedInd":"'+client.prohibited_ind+'","regAddrLine1":"'+client.reg_addr_line1+'","regAddrLine2":"'+client.reg_addr_line2+'","regCodeRsa":"'+client.reg_code_rsa+'","regSuburb":"'+client.reg_suburb+'","regTown":"'+client.reg_town+'","resPermitNbr":"'+client.res_permit_number+'","rsonSaTaxNotregis":"'+client.reason_sa_income_tax_number_not_given_value+'","SAtaxNumber":"'+client.sa_income_tax_number+'","saTaxRegis":"'+client.client_registed_for_income_tax+'","savngStatementHold":"'+client.savng_statement_hold+'","sbuSegment":"'+client.sbu_segment+'","sec129DeliveryAddr":"'+client.section_129_notice_delivery_address_value+'","secondaryCardInd":"'+client.secondary_card+'","securityIndicator":"'+client.security_indicator+'","sicCode":"'+client.sic_code+'","siccCode5":"'+client.sicc_code5+'","siteLastChanged":"'+client.site_last_changed+'","smsMarketInd":"'+client.sms_mark_ind+'","socialGrant":"'+client.social_grant+'","sourceOfIncome":"'+client.source_of_income_value+'","subClassCde":"'+client.sub_class_cde+'","subSegment":"'+client.sub_segment+'","surname":"'+client.surname+'","teleMarkInd":"'+client.tele_mark_ind+'","telebankIndicator":"'+client.client_banks_with_absa+'","tellerLastChanged":"'+client.teller_last_changed+'","thrdPartyInd":"'+client.credit_worthiness+'","titleCode":"'+client.title_value+'","unclaimedFundsInd":"'+client.unclaimed_funds_ind+'","updAddressInd":"'+client.upd_address_ind+'","updDateInd":"'+client.upd_date_ind+'","updEmailInd":"'+client.upd_email_ind+'","updTelephoneInd":"'+client.upd_telephone_ind+'","vatRegistrationNo":"'+client.vat_registration_no+'","whatQualification":"'+client.post_matric_qualification_value+'","workTelcode":"'+work_tel_code+'","workTelephone":"'+work_tel_num+'"}},"inputErrorMessage":{"errorMessageParameters":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"inputHeaders":{"inputPayloadHeaders":{"consumerChannel":"'+client.channel+'","providerApplication":"'+client.application+'","traceIndicator":"'+client.trace+'"}}}';
        console.log("=============updateCIFHelper========Input===============");
        console.log(clientData);
        console.log("=====================Input===============");
        
        var action = component.get("c.updateCIF");
        action.setParams({
            clientData: clientData
        }); 
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            
            if (component.isValid() && state === "SUCCESS") {
                
                if (res.IsSuccess) {
                    
                    if (res.Data.dataMap.getStatusCode == 200) { 
                        
                        let obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        console.log("Res: "+res.Data.dataMap.getBody);
                                                
                        let messageErros = obj.body.outputErrorMessage.errorMessageParameters.messageEntryTable[0];
                        
                        let messageErrorInd = messageErros.messageErrorInd;
                        let messagetext = messageErros.messagetext;
                        
                        if(messageErrorInd || messagetext){
                            this.stopSpinner(component, event);
                            //this.messageModal(component, true, 'CIF Update exception', messagetext);
                            this.errorMessagesHelper(component, event, 'CIF Update exception', messagetext, 'errors');
                        }else{  
                            component.set('v.validate_update_obj','');
                            this.saveApplicationHelper(component, event);
                            this.stopSpinner(component, event);
                        }
                        this.generatePDFHelper(component, event); 
                        
                    } else {
                        if(res.Data.dataMap.getStatusCode == 401){
                            this.errorMessagesHelper(component, event, 'CIF Update exception', res.Data.dataMap.getStatus, 'errors');
                        }else if(res.Data.dataMap.getStatusCode == 500){
                              this.errorMessagesHelper(component, event, 'CIF Update exception', res.Data.dataMap.error, 'errors');
                        }else{
                            let obj = JSON.parse(res.Data.dataMap.getBody);  
                            this.errorMessagesHelper(component, event, 'CIF Update exception', obj, 'obj');
                        }                        
                         
                    }
                } else {  
                     this.errorMessagesHelper(component, event, 'CIF Update warning', res.Message, 'res'); 
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'CIF Update error',errors[0].message, 'errors');
            }
        });
        $A.enqueueAction(action);     
        
    },    
    //service 8 - validate CIF service 
    validateClientDetailsAPIHelper: function(component, event) {
       this.dispaySpinner(component, event, 'Validating client details...');
        var client = component.get("v.client"); 
        if(!(client.credit_worthiness == 'Y') && !(client.credit_worthiness == 'N')){
            client.credit_worthiness = client.credit_worthiness == true ? 'Y':'N'; 
        }       
        if(!(client.absa_group_electronic == 'Y') && !(client.absa_group_electronic == 'N')){
             client.absa_group_electronic = client.absa_group_electronic == true ? 'Y':'N';    
        }
        if(!(client.voice_recording == 'Y') && !(client.voice_recording == 'N')){
            client.voice_recording = client.voice_recording == true ? 'Y':'N'; 
        }
        if(!(client.email == 'Y') && !(client.email == 'N')){
            client.email = client.email == true ? 'Y':'N';  
        }
        if(!(client.sms == 'Y') && !(client.sms == 'N')){
             client.sms = client.sms == true ? 'Y':'N';  
        }
        
                
            
            
           
        
        if (client.employment_sector_value)
        {
            if(client.employment_sector_value.toString().length == 1)
            {
                client.employment_sector_value="0"+client.employment_sector_value.toString();
            }
        }
        else{
            client.employment_sector_value = "0";
        }
        //Service format :CCYYMMDD 
        if(client.id_date_issued.includes("/")){    
            client.id_date_issued_value = this.dateFormating("Validate_And_Update","DD/MM/YYYY",client.id_date_issued);
        }
        //Service expecting: Format: CCYYMMDD //19930611  
        if(client.date_of_birth.includes("/")){      
            client.date_of_birth_value = this.dateFormating("Validate_And_Update","DD/MM/YYYY",client.date_of_birth);
        }
        //Service: CCYYMMDD
        if(client.fica_date_identified.includes("/")){  
            client.fica_date_identified_value = this.dateFormating("Validate_And_Update","DD/MM/YYYY",client.fica_date_identified);
        }
        //Service: CCYYMMDD 19930611
        if(client.current_address_since.includes("/")){
            client.current_address_since_value = this.dateFormating("Validate_And_Update","DD/MM/YYYY",client.current_address_since);
        }
        
        if (client.client_type.toString().length < 5){
            var zeros =  '0'.repeat((5 -client.client_type.toString().length));
            client.client_type = zeros + client.client_type.toString();  
        }
        
        if (client.date_exempted == ''){client.date_exempted = 0} 
        if (client.home_tel_code == ''){client.home_tel_code = 0}
        if (client.occupation_value == 0){client.occupation_value = 0} 
        if(!client.marital_contract_value){client.marital_contract_value="0";}       
        if (client.excon_expiry_date.toString().length == 0){client.excon_expiry_date = '0'}
        if (client.group_scheme.toString().length == 0){client.group_scheme='0'} 
        if (client.id_type_value.toString().length == 1){client.id_type_value='0'+client.id_type_value.toString()}
        if (client.dependents_value.toString().length == 0){client.dependents_value='0'}
        if (client.nca_threshold.toString().length == 0){client.nca_threshold='0'}
        
        
        if (client.dependents_value.toString().length == 0){client.dependents_value='0'}
        if(!client.dependents_value){client.dependents_value = "0"}
        if (client.nkin_title.toString().length == ''){client.nkin_title='00'}
        if (client.permit_exp_dte.toString().length == 0){client.permit_exp_dte = '0'}
        if (client.pingit_receive.toString().length == 0){client.pingit_receive='0'}
        if (client.postl_addr_line1 == ''){client.postl_addr_line1 = '0'}
        if (client.reg_code_rsa == ''){client.reg_code_rsa = '0'}
        if (client.sec129DeliveryAddr == ''){client.sec129DeliveryAddr = '0'}
        
        if(!client.casa_reference){client.casa_reference= "0";}   //  Casa reference screening comes after
        if(!client.cellphone_number){client.cellphone_number= "0";}else{if(client.cellphone_number.length<10){client.cellphone_number="0"+client.cellphone_number;}}
        if(!client.residential_address_country){client.residential_address_country="0";} 
        //Commented by Rakesh and Josh on 09Oct2020
        //if (client.work_tel_code){if(client.work_tel_code.toString().length == 2){client.work_tel_code="0"+client.work_tel_code.toString();}}   
        if(client.exemption_status){if(client.exemption_status=="N"){client.exemption_indicator="";}}
        
        if(client.marital_status_value){if(client.marital_status_value !="1"){client.marital_contract_value = "0";}}
        
        client.business_add1 = "";
        client.business_add2 = "";
        client.upd_email_ind = "N";
        
        
        if (!client.nkin_dcdh){client.nkin_telh=''}
        if(!client.employment_sector){client.employment_sector="0";} 
      
        if (client.client_registered_for_foreign_income_tax == 'N'){client.foreign_income_tax_number = ''; client.foreign_tax_ctry=''; client.reason_foreign_income_tax_num_not_given_value = '';}
		if(!client.post_matric_qualification_value)
        {
            client.post_matric_qualification_value="0";
        }else if(client.post_matric_qualification_value.toString().length < 2){
            if(client.post_matric_qualification_value!="0"){
                client.post_matric_qualification_value = "0" + client.post_matric_qualification_value;
            }           
        }
        //
        if(!client.occupation_code_value)
        {
            client.occupation_code_value = "0";           
        }else if(client.occupation_code_value.toString().length < 2){
       
            if(client.occupation_code_value!="0")
           {
            client.occupation_code_value = "0" + client.occupation_code_value;
           } 
        }
        
        //
        if (client.preffered_communication_channel_value.toString().length < 2){client.preffered_communication_channel_value='0'+client.preffered_communication_channel_value.toString()}        
        if (client.title_value.toString().length < 2 ){client.title_value = '0' + client.title_value}
        if (client.occupational_status_value.toString().length < 2 ){client.occupational_status_value = '0' + client.occupational_status_value}
        
        if(client.occupation_level_value){
            if (client.occupation_level_value.toString().length < 2 && client.occupation_level_value != '0')
            {
                client.occupation_level_value = '0' + client.occupation_level_value;
            }
        }        
        else{
            if(!client.occupation_level_value){client.occupation_level_value="0";}
        } 
        
        if ((client.occupational_status_value.toString() == "04") || (client.occupational_status_value.toString() == "05") || (client.occupational_status_value.toString() == "06") || (client.occupational_status_value.toString() == "07") || (client.occupational_status_value.toString() == "10")){
            client.occupation_level_value = "0";
            client.occupation_code_value = "0";
        }
        
        //client.non_cr_tel= "";        
        client.non_crvr= "";         
        client.business_add1= ""; 
        client.res_permit_number= "";      
        client.credit_marketing_group_ind = "N";
        client.debt_counsel_order_issued_ind =  "N";
        client.employer_addr_seq_nbr =  "0";
        client.business_addr_seq_nbr = "0";
        client.contOride = "";     
        client.business_add2 = "";      
        client.employer_add2 = "";
        client.sicc_code5 = "0";   // To be removed when we run businness accounts
        client.cont_oride = "0";
        client.upd_date_ind = "0"; //we get from client details but it doesnt accept it, It needs to be confirmed
        client.cr_ind="N";
        

        if(!client.sa_income_tax_number) {client.sa_income_tax_number = "0";} 
       
        
       
        if(client.physical_suburb_rsa == '' || client.physical_suburb_rsa == null || client.physical_suburb_rsa == 'UNDEFINED')
        {
            client.physical_suburb_rsa = "";
        }
        
        if (client.work_telephone_number.toString().length == 10)
        {
            var work_tel_num = client.work_telephone_number.substring(3);
            var work_tel_code = client.work_telephone_number.substring(0,3);
        }
        else
        {
            if (client.work_telephone_number.toString().length == 0)
            {
                var work_tel_num = '';
                var work_tel_code='0';
            }
        }
        if (client.home_fax_number.toString().length == 10)
        {
            var home_fax_num = client.home_fax_number.substring(3);
            var home_fax_code = client.home_fax_number.substring(0,3);
        }
        else{
            if (client.home_fax_number.toString().length == 0)
            {
                var home_fax_num = '0000000';
                var home_fax_code='000';
            }
        }
        if (client.work_fax_number.toString().length == 10)
        {
            var work_fax_num = client.work_fax_number.substring(3);
            var work_fax_code = client.work_fax_number.substring(0,3);
        } 
        else{
            if (client.work_fax_number.toString().length == 1 || client.work_fax_number.toString().length == 0)
            {
                var work_fax_num = '0000000'; 
                var work_fax_code='000';
            }
        }
        if (client.home_telephone_number.toString().length == 10)
        {
            var home_tel_num = client.home_telephone_number.substring(3);
            var home_tel_code = client.home_telephone_number.substring(0,3);
        } 
        else{
            if (client.home_telephone_number.toString().length == 1 || client.home_telephone_number.toString().length == 0){var home_tel_num = ''; var home_tel_code='0';}
        } 
        if(client.sa_income_tax_number.toString().length > 1){
            client.sa_tax_regis = 'Y';
        }else{
            client.sa_tax_regis = 'N';
            client.sa_income_tax_number = '0';
        } 
        
        //9/21/2020   
        if(client.client_registered_for_foreign_income_tax == 'Y'){
            if (!client.foreign_tax_ctry){               
            client.foreign_tax_ctry = client.country_of_origin;
            }
            if(!client.foreign_tax_ctry)
            {
               client.foreign_tax_ctry = client.country_of_birth_value;  
            }
        }  
        
        //  Convertion from Update start
        
        if (client.nkin_cell.toString().length == 9){client.nkin_cell='0'+ client.nkin_cell}
        if (client.nkinRelationship == ''){client.nkinRelationship= 0}
        if (client.nkin_telw.toString().length == 0){client.nkin_telw='0'} 
        if (client.no_of_joint_partcpnt.toString().length == 0){client.no_of_joint_partcpnt='0'}
        
        if (!client.business_address_seqnbr){client.business_address_seqnbr='0'}
        if (!client.business_address_type){client.business_address_type='0'}
        if (!client.business_postal){client.business_postal='0'}
        if (!client.changeNumber){client.changeNumber='0'}        
        if (!client.date_bus_rescue_iss){client.date_bus_rescue_iss='0'}
        if (!client.company_year_end){client.company_year_end='0'}
        
        if (!client.percentage){client.percentage='0'}
        if (!client.nkin_dcdh){client.nkin_dcdh='0'}
        if (!client.nkin_telh){client.nkin_telh='0'}
        
        
      
        if(!client.nkin_dcdw){client.nkin_telw="";}
        
        if(client.internet_bankin_ind == 'Yes'){            
            client.internet_bankin_ind = 'Y';            
        }else{            
            client.internet_bankin_ind = 'N';            
        }
        
        if(client.power_attorny_hold)
        {
            if(client.power_attorny_hold = 'Yes'){
                client.power_attorny_hold = 'Y'; 
            }else{
                client.power_attorny_hold = 'N'; 
            }            
        } 
        
        if((!client.current_address_since_value) && (client.current_address_since == "0" || !client.current_address_since)){
            client.current_address_since_value = "0";
        }
        
        if(client.empl_postal_address_line_1){            
              client.employer_addr_type = "70";        
        }
        
        //var clientData = '{"CIcreateClientV20":{"CIcreateClientV20Input":{"CRInd":"'+client.cr_ind+'","ClientAgrmntIssued":"'+client.client_agrmnt_issued+'","CreditAutoVoice":"'+client.credit_auto_voice+'","CreditEmail":"'+client.credit_email+'","CreditPost":"'+client.credit_post+'","CreditSMS":"'+client.credit_SMS+'","CreditTel":"'+client.credit_tel+'","NonCREmail":"'+client.non_CR_email+'","NonCRInd":"'+client.absa_group_electronic+'","NonCRPost":"'+client.Non_CR_post+'","NonCRSMS":"'+client.non_CR_SMS+'","NonCRTel":"'+client.non_cr_tel+'","NonCRVR":"'+client.non_crvr+'","SAtaxNumber":"'+client.sa_income_tax_number+'","affectedPerson":"'+client.affected_person+'","ageiculturalDataTable":[{"agriClass":"'+client.agri_class+'","percentage":"'+client.percentage+'"}],"birthDate":"'+client.date_of_birth_value+'","branchClientOpen":"'+client.branch_client_opened+'","businessAdd1":"'+client.business_add1+'","businessAdd2":"'+client.business_add2+'","businessAddrType":"'+client.business_address_type+'","businessPostal":"'+client.business_postal+'","businessSuburb":"'+client.business_suburb+'","businessTown":"'+client.business_town+'","casaRefNum":"'+client.casa_reference+'","cellphone":"'+client.cellphone_number+'","clientNationality":"'+client.nationality_value+'","clientType":"'+client.client_type+'","clientWebsite":"'+client.client_website+'","companyYearEnd":"'+client.company_year_end+'","contOride":"'+client.cont_oride+'","contactPerson":"'+client.contact_person+'","corporateDivision":"'+client.corporate_division+'","countryEntityOperatesTable":[{"countryEntOprt":"'+client.country_ent_oprt+'"}],"countryHoAddress":"'+client.country_ho_address+'","countryIncorp":"'+client.country_incorp+'","countryOfBirth":"'+client.country_of_birth_value+'","countryOfOrigin":"'+client.country_of_origin+'","countryRegAddress":"'+client.country_reg_address+'","countryResAddress":"'+client.residential_address_country_value+'","cpaThreshold":"'+client.cpa_threshold+'","dateExempted":"'+client.date_exempted+'","dateIdentified":"'+client.fica_date_identified_value+'","dateIssued":"'+client.id_date_issued_value+'","dateVerified":"'+client.current_address_since_value+'","designation":"'+client.occupation_value+'","emailAddress":"'+client.email_address+'","emailMarkInd":"'+client.email+'","employeeExempted":"'+client.employee_exempted+'","employeeIdentified":"'+client.employee_identified+'","employeeVerified":"'+client.employee_verified+'","employerAdd1":"'+client.empl_postal_address_line_1+'","employerAdd2":"'+client.empl_postal_address_line_1_3+'","employerAddrType":"'+client.employer_addr_type+'","employerPostal":"'+client.empl_postal_code+'","employerSuburb":"'+client.empl_addr_suburb_rsa+'","employerTown":"'+client.empl_town_city_foreign_country+'","employmentSector":"'+client.employment_sector_value+'","exconExpiryDate":"'+client.excon_expiry_date+'","exemptionIndicator":"'+client.exemption_indicator+'","exemptionStatus":"'+client.exemption_status+'","faxHomeCode":"'+home_fax_code+'","faxHomeNumber":"'+home_fax_num+'","faxWorkCode":"'+work_fax_code+'","faxWorkNumber":"'+work_fax_num+'","firstNames":"'+client.first_names+'","foreignTaxDATATable":[{"foreignTaxCtry":"'+client.foreign_tax_ctry+'","foreignTaxNo":"'+client.foreign_income_tax_number+'","rsonFtaxNotRegis":"'+client.reason_foreign_income_tax_num_not_given_value+'"}],"foreignTaxRegis":"'+client.client_registered_for_foreign_income_tax+'","gender":"'+client.gender_value+'","groupScheme":"'+client.group_scheme+'","groupSchemeEmp":"'+client.group_scheme_emp+'","haveQualification":"'+client.does_client_havepostmatric_qualification+'","hoAddrLine1":"'+client.ho_addr_line1+'","hoAddrLine2":"'+client.ho_addr_line2+'","hoCodeRsa":"'+client.ho_code_rsa+'","hoSuburb":"'+client.ho_suburb+'","hoTown":"'+client.hos_town+'","homeLanguage":"'+client.home_language_value+'","homeTelCode":"'+client.home_tel_code+'","homeTelephone":"'+client.home_telephone+'","idNumber":"'+client.id_number+'","idType":"'+client.id_type_value+'","incomeGroup":"'+client.monthly_income_value+'","initials":"'+client.initials+'","language":"'+client.language+'","mailInd":"'+client.mail_ind+'","mariageCntrctType":"'+client.marital_contract_value+'","maritalStatus":"'+client.marital_status_value+'","marketingConcent":"'+client.marketing_concent+'","militaryComtmntInd":"'+client.miltary_comtmnt_ind+'","minorChildren":"'+client.dependents_value+'","ncaThreshold":"'+client.nca_threshold+'","nkinCell":"'+client.contact_number+'","nkinDcdh":"'+client.nkin_dcdh+'","nkinDcdw":"'+client.nkin_dcdw+'","nkinEmail":"'+client.nkin_email+'","nkinFname":"'+client.nkin_first_name+'","nkinInitials":"'+client.nkin_initials+'","nkinJntSurname":"'+client.nkin_jnt_surname+'","nkinRelationship":"'+client.nkin_relationship+'","nkinSurname":"'+client.nkin_surname+'","nkinTelh":"'+client.nkin_telh+'","nkinTelw":"'+client.nkin_telw+'","nkinTitle":"'+client.nkin_title+'","noOfJointPartcpnt":"'+client.no_of_joint_partcpnt+'","occupancyType":"'+client.residential_status_value+'","occupationCode":"'+client.occupation_code_value+'","occupationLevel":"'+client.occupation_level_value+'","occupationStatus":"'+client.occupational_status_value+'","permitExpDte":"'+client.permit_exp_dte+'","physicalTown":"'+client.town_city_foreign_country+'","physicalAdd1":"'+client.postal_address_line_1+'","physicalAdd2":"'+client.postal_address_line_2+'","physicalAddrType":"'+client.physical_addr_type+'","physicalPostal":"'+client.postal_code+'","physicalSuburb":"'+client.physical_suburb_rsa+'","pingitReceive":"'+client.pingit_receive+'","pingitWallet":"'+client.pingit_wallet+'","postlAddrLine1":"'+client.postl_addr_line1+'","postlAddrLine2":"'+client.postl_addr_line2+'","postlCodeRsa":"'+client.postal_code+'","postlSuburb":"'+client.postl_suburb+'","postlTown":"'+client.town_city_foreign_country+'","practiceNumber":"'+client.practice_number+'","prefrdCommtionMthd":"'+client.preffered_communication_channel_value+'","regAddrLine1":"'+client.reg_addr_line1+'","regAddrLine2":"'+client.reg_addr_line2+'","regCodeRsa":"'+client.reg_code_rsa+'","regSuburb":"'+client.reg_suburb+'","regTown":"'+client.reg_town+'","resPermitNumber":"'+client.res_permit_number+'","rsonSaTaxNotGiven":"'+client.reason_sa_income_tax_number_not_given_value+'","saTaxRegis":"'+client.client_registed_for_income_tax+'","sec129DeliveryAddr":"'+client.section_129_notice_delivery_address_value+'","secondaryCard":"'+client.secondary_card+'","siccCode5":"'+client.sicc_code5+'","smsMarketInd":"'+client.sms+'","socialGrant":"'+client.social_grant+'","sourceOfIncome":"'+client.source_of_income_value+'","subClassCde":"'+client.sub_class_cde+'","surname":"'+client.surname_comp+'","teleMarkInd":"'+client.voice_recording+'","tellerLastChanged":"'+client.teller_last_changed+'","thrdPartyInd":"'+client.credit_worthiness+'","titleCode":"'+client.title_value+'","updAddressInd":"'+client.upd_address_ind+'","updDateInd":"'+client.upd_date_ind+'","updEmailInd":"'+client.upd_email_ind+'","updTelephoneInd":"'+client.upd_telephone_ind+'","vatRegistrationNo":"'+client.vat_registration_no+'","whatQualification":"'+client.post_matric_qualification_value+'","workTelcode":"'+work_tel_code+'","workTelephone":"'+work_tel_num+'"}},"inputErrorMessage":{"errorMessageParameters":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"inputHeaders":{"inputPayloadHeaders":{"consumerChannel":"'+client.channel+'","providerApplication":"'+client.application+'","traceIndicator":"'+client.trace+'"}}}';
        //var clientData = '{"CIcreateClientV20":{"CIcreateClientV20Input":{"CRInd":"'+client.cr_ind+'","ClientAgrmntIssued":"'+client.client_agrmnt_issued+'","CreditAutoVoice":"'+client.credit_auto_voice+'","CreditEmail":"'+client.credit_email+'","CreditPost":"'+client.credit_post+'","CreditSMS":"'+client.credit_SMS+'","CreditTel":"'+client.credit_tel+'","NonCREmail":"'+client.email+'","NonCRInd":"'+client.absa_group_electronic+'","NonCRPost":"'+client.Non_CR_post+'","NonCRSMS":"'+client.sms+'","NonCRTel":"'+client.voice_recording+'","NonCRVR":"'+client.non_crvr+'","SAtaxNumber":"'+client.sa_income_tax_number+'","affectedPerson":"'+client.affected_person+'","ageiculturalDataTable":[{"agriClass":"'+client.agri_class+'","percentage":"'+client.percentage+'"}],"birthDate":"'+client.date_of_birth_value+'","branchClientOpen":"'+client.branch_client_opened+'","businessAdd1":"'+client.business_add1+'","businessAdd2":"'+client.business_add2+'","businessAddrType":"'+client.business_address_type+'","businessPostal":"'+client.business_postal+'","businessSuburb":"'+client.business_suburb+'","businessTown":"'+client.business_town+'","casaRefNum":"'+client.casa_reference+'","cellphone":"'+client.cellphone_number+'","clientNationality":"'+client.nationality_value+'","clientType":"'+client.client_type+'","clientWebsite":"'+client.client_website+'","companyYearEnd":"'+client.company_year_end+'","contOride":"'+client.cont_oride+'","contactPerson":"'+client.contact_person+'","corporateDivision":"'+client.corporate_division+'","countryEntityOperatesTable":[{"countryEntOprt":"'+client.country_ent_oprt+'"}],"countryHoAddress":"'+client.country_ho_address+'","countryIncorp":"'+client.country_incorp+'","countryOfBirth":"'+client.country_of_birth_value+'","countryOfOrigin":"'+client.country_of_origin+'","countryRegAddress":"'+client.country_reg_address+'","countryResAddress":"'+client.residential_address_country_value+'","cpaThreshold":"'+client.cpa_threshold+'","dateExempted":"'+client.date_exempted+'","dateIdentified":"'+client.fica_date_identified_value+'","dateIssued":"'+client.id_date_issued_value+'","dateVerified":"'+client.current_address_since_value+'","designation":"'+client.occupation_value+'","emailAddress":"'+client.email_address+'","emailMarkInd":"'+client.email+'","employeeExempted":"'+client.employee_exempted+'","employeeIdentified":"'+client.employee_identified+'","employeeVerified":"'+client.employee_verified+'","employerAdd1":"'+client.empl_postal_address_line_1+'","employerAdd2":"'+client.empl_postal_address_line_1_3+'","employerAddrType":"'+client.employer_addr_type+'","employerPostal":"'+client.empl_postal_code+'","employerSuburb":"'+client.empl_addr_suburb_rsa+'","employerTown":"'+client.empl_town_city_foreign_country+'","employmentSector":"'+client.employment_sector_value+'","exconExpiryDate":"'+client.excon_expiry_date+'","exemptionIndicator":"'+client.exemption_indicator+'","exemptionStatus":"'+client.exemption_status+'","faxHomeCode":"'+home_fax_code+'","faxHomeNumber":"'+home_fax_num+'","faxWorkCode":"'+work_fax_code+'","faxWorkNumber":"'+work_fax_num+'","firstNames":"'+client.first_names+'","foreignTaxDATATable":[{"foreignTaxCtry":"'+client.foreign_tax_ctry+'","foreignTaxNo":"'+client.foreign_income_tax_number+'","rsonFtaxNotRegis":"'+client.reason_foreign_income_tax_num_not_given_value+'"}],"foreignTaxRegis":"'+client.client_registered_for_foreign_income_tax+'","gender":"'+client.gender_value+'","groupScheme":"'+client.group_scheme+'","groupSchemeEmp":"'+client.group_scheme_emp+'","haveQualification":"'+client.does_client_havepostmatric_qualification+'","hoAddrLine1":"'+client.ho_addr_line1+'","hoAddrLine2":"'+client.ho_addr_line2+'","hoCodeRsa":"'+client.ho_code_rsa+'","hoSuburb":"'+client.ho_suburb+'","hoTown":"'+client.hos_town+'","homeLanguage":"'+client.home_language_value+'","homeTelCode":"'+client.home_tel_code+'","homeTelephone":"'+client.home_telephone+'","idNumber":"'+client.id_number+'","idType":"'+client.id_type_value+'","incomeGroup":"'+client.monthly_income_value+'","initials":"'+client.initials+'","language":"'+client.language+'","mailInd":"'+client.mail_ind+'","mariageCntrctType":"'+client.marital_contract_value+'","maritalStatus":"'+client.marital_status_value+'","marketingConcent":"'+client.marketing_concent+'","militaryComtmntInd":"'+client.miltary_comtmnt_ind+'","minorChildren":"'+client.dependents_value+'","ncaThreshold":"'+client.nca_threshold+'","nkinCell":"'+client.contact_number+'","nkinDcdh":"'+client.nkin_dcdh+'","nkinDcdw":"'+client.nkin_dcdw+'","nkinEmail":"'+client.nkin_email+'","nkinFname":"'+client.nkin_first_name+'","nkinInitials":"'+client.nkin_initials+'","nkinJntSurname":"'+client.nkin_jnt_surname+'","nkinRelationship":"'+client.nkin_relationship+'","nkinSurname":"'+client.nkin_surname+'","nkinTelh":"'+client.nkin_telh+'","nkinTelw":"'+client.nkin_telw+'","nkinTitle":"'+client.nkin_title+'","noOfJointPartcpnt":"'+client.no_of_joint_partcpnt+'","occupancyType":"'+client.residential_status_value+'","occupationCode":"'+client.occupation_code_value+'","occupationLevel":"'+client.occupation_level_value+'","occupationStatus":"'+client.occupational_status_value+'","permitExpDte":"'+client.permit_exp_dte+'","physicalTown":"'+client.town_city_foreign_country+'","physicalAdd1":"'+client.postal_address_line_1+'","physicalAdd2":"'+client.postal_address_line_2+'","physicalAddrType":"'+client.physical_addr_type+'","physicalPostal":"'+client.postal_code+'","physicalSuburb":"'+client.physical_suburb_rsa+'","pingitReceive":"'+client.pingit_receive+'","pingitWallet":"'+client.pingit_wallet+'","postlAddrLine1":"'+client.postl_addr_line1+'","postlAddrLine2":"'+client.postl_addr_line2+'","postlCodeRsa":"'+client.postal_code+'","postlSuburb":"'+client.postl_suburb+'","postlTown":"'+client.town_city_foreign_country+'","practiceNumber":"'+client.practice_number+'","prefrdCommtionMthd":"'+client.preffered_communication_channel_value+'","regAddrLine1":"'+client.reg_addr_line1+'","regAddrLine2":"'+client.reg_addr_line2+'","regCodeRsa":"'+client.reg_code_rsa+'","regSuburb":"'+client.reg_suburb+'","regTown":"'+client.reg_town+'","resPermitNumber":"'+client.res_permit_number+'","rsonSaTaxNotGiven":"'+client.reason_sa_income_tax_number_not_given_value+'","saTaxRegis":"'+client.client_registed_for_income_tax+'","sec129DeliveryAddr":"'+client.section_129_notice_delivery_address_value+'","secondaryCard":"'+client.secondary_card+'","siccCode5":"'+client.sicc_code5+'","smsMarketInd":"'+client.sms+'","socialGrant":"'+client.social_grant+'","sourceOfIncome":"'+client.source_of_income_value+'","subClassCde":"'+client.sub_class_cde+'","surname":"'+client.surname_comp+'","teleMarkInd":"'+client.voice_recording+'","tellerLastChanged":"'+client.teller_last_changed+'","thrdPartyInd":"'+client.credit_worthiness+'","titleCode":"'+client.title_value+'","updAddressInd":"'+client.upd_address_ind+'","updDateInd":"'+client.upd_date_ind+'","updEmailInd":"'+client.upd_email_ind+'","updTelephoneInd":"'+client.upd_telephone_ind+'","vatRegistrationNo":"'+client.vat_registration_no+'","whatQualification":"'+client.post_matric_qualification_value+'","workTelcode":"'+work_tel_code+'","workTelephone":"'+work_tel_num+'"}},"inputErrorMessage":{"errorMessageParameters":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"inputHeaders":{"inputPayloadHeaders":{"consumerChannel":"'+client.channel+'","providerApplication":"'+client.application+'","traceIndicator":"'+client.trace+'"}}}';
        var clientData = '{"CIcreateClientV20":{"CIcreateClientV20Input":{"CRInd":"'+client.cr_ind+'","ClientAgrmntIssued":"'+client.client_agrmnt_issued+'","CreditAutoVoice":"'+client.credit_auto_voice+'","CreditEmail":"'+client.credit_email+'","CreditPost":"'+client.credit_post+'","CreditSMS":"'+client.credit_SMS+'","CreditTel":"'+client.credit_tel+'","NonCREmail":"'+client.email+'","NonCRInd":"'+client.absa_group_electronic+'","NonCRPost":"'+client.Non_CR_post+'","NonCRSMS":"'+client.sms+'","NonCRTel":"'+client.voice_recording+'","NonCRVR":"'+client.non_crvr+'","SAtaxNumber":"'+client.sa_income_tax_number+'","affectedPerson":"'+client.affected_person+'","ageiculturalDataTable":[{"agriClass":"'+client.agri_class+'","percentage":"'+client.percentage+'"}],"birthDate":"'+client.date_of_birth_value+'","branchClientOpen":"'+client.branch_client_opened+'","businessAdd1":"'+client.business_add1+'","businessAdd2":"'+client.business_add2+'","businessAddrType":"'+client.business_address_type+'","businessPostal":"'+client.business_postal+'","businessSuburb":"'+client.business_suburb+'","businessTown":"'+client.business_town+'","casaRefNum":"'+client.casa_reference+'","cellphone":"'+client.cellphone_number+'","clientNationality":"'+client.nationality_value+'","clientType":"'+client.client_type+'","clientWebsite":"'+client.client_website+'","companyYearEnd":"'+client.company_year_end+'","contOride":"'+client.cont_oride+'","contactPerson":"'+client.contact_person+'","corporateDivision":"'+client.corporate_division+'","countryEntityOperatesTable":[{"countryEntOprt":"'+client.country_ent_oprt+'"}],"countryHoAddress":"'+client.country_ho_address+'","countryIncorp":"'+client.country_incorp+'","countryOfBirth":"'+client.country_of_birth_value+'","countryOfOrigin":"'+client.country_of_origin+'","countryRegAddress":"'+client.country_reg_address+'","countryResAddress":"'+client.residential_address_country_value+'","cpaThreshold":"'+client.cpa_threshold+'","dateExempted":"'+client.date_exempted+'","dateIdentified":"'+client.fica_date_identified_value+'","dateIssued":"'+client.id_date_issued_value+'","dateVerified":"'+client.current_address_since_value+'","designation":"'+client.occupation_value+'","emailAddress":"'+client.email_address+'","emailMarkInd":"'+client.email_mark_ind+'","employeeExempted":"'+client.employee_exempted+'","employeeIdentified":"'+client.employee_identified+'","employeeVerified":"'+client.employee_verified+'","employerAdd1":"'+client.empl_postal_address_line_1+'","employerAdd2":"'+client.empl_postal_address_line_1_3+'","employerAddrType":"'+client.employer_addr_type+'","employerPostal":"'+client.empl_postal_code+'","employerSuburb":"'+client.empl_addr_suburb_rsa+'","employerTown":"'+client.empl_town_city_foreign_country+'","employmentSector":"'+client.employment_sector_value+'","exconExpiryDate":"'+client.excon_expiry_date+'","exemptionIndicator":"'+client.exemption_indicator+'","exemptionStatus":"'+client.exemption_status+'","faxHomeCode":"'+home_fax_code+'","faxHomeNumber":"'+home_fax_num+'","faxWorkCode":"'+work_fax_code+'","faxWorkNumber":"'+work_fax_num+'","firstNames":"'+client.first_names+'","foreignTaxDATATable":[{"foreignTaxCtry":"'+client.foreign_tax_ctry+'","foreignTaxNo":"'+client.foreign_income_tax_number+'","rsonFtaxNotRegis":"'+client.reason_foreign_income_tax_num_not_given_value+'"}],"foreignTaxRegis":"'+client.client_registered_for_foreign_income_tax+'","gender":"'+client.gender_value+'","groupScheme":"'+client.group_scheme+'","groupSchemeEmp":"'+client.group_scheme_emp+'","haveQualification":"'+client.does_client_havepostmatric_qualification+'","hoAddrLine1":"'+client.ho_addr_line1+'","hoAddrLine2":"'+client.ho_addr_line2+'","hoCodeRsa":"'+client.ho_code_rsa+'","hoSuburb":"'+client.ho_suburb+'","hoTown":"'+client.hos_town+'","homeLanguage":"'+client.home_language_value+'","homeTelCode":"'+client.home_tel_code+'","homeTelephone":"'+client.home_telephone+'","idNumber":"'+client.id_number+'","idType":"'+client.id_type_value+'","incomeGroup":"'+client.monthly_income_value+'","initials":"'+client.initials+'","language":"'+client.language+'","mailInd":"'+client.mail_ind+'","mariageCntrctType":"'+client.marital_contract_value+'","maritalStatus":"'+client.marital_status_value+'","marketingConcent":"'+client.marketing_concent+'","militaryComtmntInd":"'+client.miltary_comtmnt_ind+'","minorChildren":"'+client.dependents_value+'","ncaThreshold":"'+client.nca_threshold+'","nkinCell":"'+client.contact_number+'","nkinDcdh":"'+client.nkin_dcdh+'","nkinDcdw":"'+client.nkin_dcdw+'","nkinEmail":"'+client.nkin_email+'","nkinFname":"'+client.nkin_first_name+'","nkinInitials":"'+client.nkin_initials+'","nkinJntSurname":"'+client.nkin_jnt_surname+'","nkinRelationship":"'+client.nkin_relationship+'","nkinSurname":"'+client.nkin_surname+'","nkinTelh":"'+client.nkin_telh+'","nkinTelw":"'+client.nkin_telw+'","nkinTitle":"'+client.nkin_title+'","noOfJointPartcpnt":"'+client.no_of_joint_partcpnt+'","occupancyType":"'+client.residential_status_value+'","occupationCode":"'+client.occupation_code_value+'","occupationLevel":"'+client.occupation_level_value+'","occupationStatus":"'+client.occupational_status_value+'","permitExpDte":"'+client.permit_exp_dte+'","physicalTown":"'+client.town_city_foreign_country+'","physicalAdd1":"'+client.postal_address_line_1+'","physicalAdd2":"'+client.postal_address_line_2+'","physicalAddrType":"'+client.physical_addr_type+'","physicalPostal":"'+client.postal_code+'","physicalSuburb":"'+client.physical_suburb_rsa+'","pingitReceive":"'+client.pingit_receive+'","pingitWallet":"'+client.pingit_wallet+'","postlAddrLine1":"'+client.postl_addr_line1+'","postlAddrLine2":"'+client.postl_addr_line2+'","postlCodeRsa":"'+client.postal_code+'","postlSuburb":"'+client.postl_suburb+'","postlTown":"'+client.town_city_foreign_country+'","practiceNumber":"'+client.practice_number+'","prefrdCommtionMthd":"'+client.preffered_communication_channel_value+'","regAddrLine1":"'+client.reg_addr_line1+'","regAddrLine2":"'+client.reg_addr_line2+'","regCodeRsa":"'+client.reg_code_rsa+'","regSuburb":"'+client.reg_suburb+'","regTown":"'+client.reg_town+'","resPermitNumber":"'+client.res_permit_number+'","rsonSaTaxNotGiven":"'+client.reason_sa_income_tax_number_not_given_value+'","saTaxRegis":"'+client.client_registed_for_income_tax+'","sec129DeliveryAddr":"'+client.section_129_notice_delivery_address_value+'","secondaryCard":"'+client.secondary_card+'","siccCode5":"'+client.sicc_code5+'","smsMarketInd":"'+client.sms_mark_ind+'","socialGrant":"'+client.social_grant+'","sourceOfIncome":"'+client.source_of_income_value+'","subClassCde":"'+client.sub_class_cde+'","surname":"'+client.surname_comp+'","teleMarkInd":"'+client.tele_mark_ind+'","tellerLastChanged":"'+client.teller_last_changed+'","thrdPartyInd":"'+client.credit_worthiness+'","titleCode":"'+client.title_value+'","updAddressInd":"'+client.upd_address_ind+'","updDateInd":"'+client.upd_date_ind+'","updEmailInd":"'+client.upd_email_ind+'","updTelephoneInd":"'+client.upd_telephone_ind+'","vatRegistrationNo":"'+client.vat_registration_no+'","whatQualification":"'+client.post_matric_qualification_value+'","workTelcode":"'+work_tel_code+'","workTelephone":"'+work_tel_num+'"}},"inputErrorMessage":{"errorMessageParameters":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"inputHeaders":{"inputPayloadHeaders":{"consumerChannel":"'+client.channel+'","providerApplication":"'+client.application+'","traceIndicator":"'+client.trace+'"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        //clientData = clientData.replace(/null/g, '');               
        console.log(clientData);
        var action = component.get("c.validateClientDetails");
        
        action.setParams({
            clientData: clientData,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if(res.Data.dataMap.getStatusCode == 200){
                        var validateClientDetailsAPI = JSON.parse(res.Data.dataMap.getBody);                        
                        var objStatusCode = validateClientDetailsAPI.statusCode;
                        var statusMessage = validateClientDetailsAPI.statusMessage;
                        
                        this.updateCIFHelper(component, event);
                        
                    }else{
                       let obj = JSON.parse(res.Data.dataMap.getBody); 
                       this.errorMessagesHelper(component, event,'Validate exception', obj, 'obj');  
                       //this.messageModal(component, true, 'Validation exception', res.Data.dataMap.getBody);
                    }
                    
                } else {                    
                    //this.messageModal(component, true, 'Validate message', res.Message);
                    this.errorMessagesHelper(component, event,'Validate message', res.Message, 'res'); 
                   
                }
            } else if (errors && errors.length > 0) {                            
                this.errorMessagesHelper(component, event,'Validate error', errors[0].message, 'errors'); 
               
            }
        });
        $A.enqueueAction(action);
    },
    /**************************************SCORING*******************************************/
    // 1st service
    SJMgenerateApplicationNumberV2Helper: function(component, event) {
        console.log('scoring service 1');
        let client = component.get("v.client");
        //this.SJMinitiateApplicationV1Helper(component, event); // need to be removed
        if (client.client_key) {
            var clientData = '{"SJMgenerateApplicationNumberV2":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgClass":"'+client.final_msg_class+'","finalMsgCode":"'+client.final_msg_code+'"},"sjp304i":{"origin":"' + client.origin + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '","clientCode":"' + client.client_key + '","prodCde":"' + client.prod_cde + '","consultEmplNo":"' + client.consult_emp_no + '"}}}';
            clientData = clientData.replace(/undefined/g, ''); 
            clientData = clientData.replace(/null/g, '');                     
            console.log(clientData);
            
            var action = component.get("c.getApplicationNum");
            action.setParams({
                clientData: clientData
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var errors = response.getError();
                var res = response.getReturnValue();
                if (component.isValid() && state === "SUCCESS") {

                    if (res.IsSuccess) {
                        if (res.Data.dataMap.getStatusCode == 200) {
                            console.log('Res: '+res.Data.dataMap.getBody);
                            var obj = JSON.parse(res.Data.dataMap.getBody);
                            
                            
						
                            if (obj.SJMgenerateApplicationNumberV2Response.nbsmsgo3.nbrUserMsgs > 0) {
                                
                                if(obj.SJMgenerateApplicationNumberV2Response.nbsmsgo3.msgEntry[0].msgTxt == "USE EXISTING ACSS APPLICATION"){
                                    
                                    if(client.application_number){
                                        this.SJMinitiateApplicationV1Helper(component, event); //second api
                                    }else{
                                        let error_obj = obj.SJMgenerateApplicationNumberV2Response.nbsmsgo3.msgEntry[0].msgTxt;
                                        this.errorMessagesHelper(component, event, 'Generate application message', error_obj, 'scoring_obj'); 
                                        return;
                                    }
                                    
                                }else{
                                        let error_obj = obj.SJMgenerateApplicationNumberV2Response.nbsmsgo3.msgEntry[0].msgTxt;
                                        this.errorMessagesHelper(component, event, 'Generate application message', error_obj, 'scoring_obj'); 
                                        return;
                                }
                                
                            }else if(obj) {
                                let client = component.get("v.client");
                                client.application_number = obj.SJMgenerateApplicationNumberV2Response.sjp304o.applicationNo;
                                
                                if(client.application_number){
                                    this.saveApplicationHelper(component, event);
                                }
                                component.set("v.client", client);
                                this.SJMinitiateApplicationV1Helper(component, event); //second api
                            }
                        } else {
                            let obj = res.Data.dataMap.getBody;
                            this.errorMessagesHelper(component, event, 'Generate application exception', obj, 'scoring_obj'); 
                        }
                    } else {
                        this.errorMessagesHelper(component, event, 'Get application warning', res.Message, 'scoring_obj'); 
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Application error', errors[0].message, 'scoring_obj'); 
                }
            });
            $A.enqueueAction(action);
        } else {
            this.errorMessagesHelper(component, event, 'Missing client code', 'please pass client code', 'scoring_obj');
        } 
    },
    //2nd scoring service 
    SJMinitiateApplicationV1Helper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Initiate application...');
               
        console.log('scoring service 2');
        var client = component.get("v.client");
        
        var clientData = '{"SJMinitiateApplicationV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"'+client.final_msg_class+'","finalMsgCode":"'+client.final_msg_code+'"}},"sjp318i":{"applicationNo":"' + client.application_number + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.initiateApplication");
        action.setParams({
            clientData: clientData,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            console.log(res);
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var initiateAplicationAPI = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (initiateAplicationAPI.SJMinitiateApplicationV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            let error_obj = initiateAplicationAPI.SJMinitiateApplicationV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Initiate application message', error_obj, 'scoring_obj'); 
                            return;
                        }                        
                        
                        client.SJMinitiateApplicationJSON = initiateAplicationAPI;
                        if (initiateAplicationAPI) {
                            var obj = initiateAplicationAPI.SJMinitiateApplicationV1Response.sjp318o;
                            
                            
                            client.market_campgn_id = obj.marketCampgnId;
                            client.grp_scheme_code = obj.grpSchemeCode;
                            client.grp_scheme_type = obj.grpSchemeType; 
                            client.id_pass_no_sp_p = obj.idPassNoSpP;
                            client.id_type_sp = obj.idTypeSp;
                            client.does_client_havepostmatric_qualification = obj.universityDegreeD;
                            component.set("v.client", client);
                            
                            this.submitApplicationHelper(component, event);
                        }
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Initiate application exception', obj, 'scoring_obj'); 
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Initiate application warning', res.Message, 'scoring_obj'); 
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Initiate application error', errors[0].message, 'scoring_obj');
            }
        });
        $A.enqueueAction(action);
    },
    // 3rd scoring service
    submitApplicationHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Submit application...');        
        
        console.log('scoring service 3');
        let client = component.get("v.client");
        var application_number = client.application_number;
        
        console.log(client.SJMinitiateApplicationJSON);
        var initAppl = client.SJMinitiateApplicationJSON;
                
        //var clientData = client_data = '{"channel":"'+client.channel+'", "application":"'+client.application+'","trace":"'+client.trace+'","application_number": "'+client.application_number+'", "client_code": "'+client.client_code+'", "id_pass_no_sp": "'+client.id_pass_no_sp+'", "id_type_sp": "'+client.id_type_sp+'", "grp_scheme_type": "'+client.grp_scheme_type+'", "grp_scheme_code": "'+client.grp_scheme_code+'", "market_campgn_id": "'+client.market_campgn_id+'", "university_degree": "'+client.post_matric_qualification+'", "consult_emp_no": "'+client.consult_emp_no+'", "corp_code": "'+client.corp_code+'", "branch_code": "'+client.branch_code+'", "branch_site_type": "'+client.branch_site_type+'", "agency_code": "'+client.agency_code+'", "agency_site_type": "'+client.agency_site_type+'", "teller_code": "'+client.teller_code+'", "supervisor_code": "'+client.supervisor_code+'", "final_msg_code": "'+client.final_msg_code+'","final_msg_class": "'+client.final_msg_class+'","msg_target": "'+client.target+'", "msg_language": "'+client.language+'"}';
        var clientData = '{"SJMsubmitApplicationV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjp602i":{"applicationNo":"' + client.application_number + '","clientCode":"' + client.client_key + '","idPassNoSp":"' + client.id_pass_no_sp_p + '","idTypeSp":"' + client.id_type_sp + '","grpSchemeType":"' + client.grp_scheme_type + '","grpSchemeCode":"' + client.grp_scheme_code + '","marketCampgnId":"' + client.market_campgn_id + '","universityDegree":"' + client.does_client_havepostmatric_qualification + '","consultEmplNo":"' + client.consult_emp_no + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        
        var action = component.get("c.submitApplication");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMsubmitApplicationV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            let error_obj = obj.SJMsubmitApplicationV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Submit application message', error_obj, 'scoring_obj');
                            return;

                        }                        
                        
                        if (obj) {
                            var nextFunct = obj.SJMsubmitApplicationV1Response.sjp602o.nextFunc;
                            if (nextFunct == 'NAPA'){                           
                                this.getDuplicateApplicationsHelper(component, event);
                            }else{
                                this.errorMessagesHelper(component, event, 'Technical Exception', 'Technical exception has occured in submitapp', 'scoring_obj'); 
                                return;
                            }
                        }
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Submit application exception', obj, 'scoring_obj');
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Submit application warning', res.Message, 'scoring_obj');
                }
            } else {
                this.errorMessagesHelper(component, event, 'Submit application error', errors[0].message, 'scoring_obj');
            }
        });
        $A.enqueueAction(action);
    },
    // 4th scoring service
    getDuplicateApplicationsHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Duplicate application...');
        
        console.log('scoring service 4');
        let client = component.get("v.client");
        
        var clientData = '{"SJMgetDuplicateApplicationsV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"'+client.final_msg_class+'","finalMsgCode":"'+client.final_msg_code+'"}},"sjp327i":{"applicationNo":"' + client.application_number + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');              
        console.log(clientData);
        var action = component.get("c.getDuplicateApplications");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var getDuplicateApplicationsAPI = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (getDuplicateApplicationsAPI.SJMgetDuplicateApplicationsV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            let error_obj = getDuplicateApplicationsAPI.SJMgetDuplicateApplicationsV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Duplicate application message', error_obj, 'scoring_obj');
                            return;

                        }                           
                        if (getDuplicateApplicationsAPI) {
                            var obj = getDuplicateApplicationsAPI.SJMgetDuplicateApplicationsV1Response.sjp327o;
                            client.application_branch = obj.applicationBranch;
                            client.application_date = obj.applicationDate;
                            client.application_time = obj.applicationTime;
                            
                            /* var duplicateApplication = getDuplicateApplicationsAPI.SJMgetDuplicateApplicationsV1Response.sjp327o.duplTable[duplTable.length-1];
                             client.dupl_appl_date = duplicateApplication.duplApplDate;
                             client.dupl_appl_no = duplicateApplication.duplApplNo;
                             client.dupl_branch = duplicateApplication.duplBranch;
                             client.dupl_status = duplicateApplication.duplStatus;
                             client.dupl_amount = duplicateApplication.duplAmount;
                            */
                            component.set("v.client", client);
                        }
                        this.getplsettlementaccountsv2apiHelper(component, event); //5th service
                        
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Duplicate application exception', obj, 'scoring_obj');
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Duplicate application warning', res.Message, 'scoring_obj');
                }
            } else {
                this.errorMessagesHelper(component, event, 'Duplicate application error', errors[0].message, 'scoring_obj');
            }
        });
        $A.enqueueAction(action);
    },
    // 5th scoring service
    getplsettlementaccountsv2apiHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Get pl settlement accounts...');   
        
        let client = component.get("v.client");
                
        if (client.application_number) {
            
            //var clientData = '{"channel": "' + client.channel + '","application":"' + client.application + '","trace": "' + client.trace + '", "msg_language": "' + client.msg_language + '" ,"msg_target": "' + client.msg_target + '" ,"application_number": "' + client.application_number + '" ,"corp_code": "' + client.corp_code + '" , "branch_code": "' + client.branch_code + '", "branch_site_type" : "' + client.branch_site_type + '" , "agency_code": "' + client.agency_code + '" , "agency_site_type": "' + client.agency_site_type + '" , "teller_code": "' + client.teller_code + '" ,"supervisor_code": "' + client.supervisor_code + '","finance_type":"' + client.finance_type + '","loan_amount":"' + client.loan_amount + '"}'
            var clientData = '{"NBSAPDPI":{"NBSAPLI":{"consumerChannel":"' + client.channel + '","providerApplication":"' + client.application + '","traceIndicator":"'+client.trace+'"}},"MSGI":{"NBSMSGI":{"version":"'+client.version+'","messageLanguage":"' + client.language + '","messageTarget":"' + client.target + '"}},"SJMgetPLSettlementAccountsV2":{"SJMgetPLSettlementAccountsV2Input":{"corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '","applicationNo":"'+client.application_number+'","financeType":"'+client.finance_type+'","loanAmount":"'+client.loan_amount+'"}}}';
            var action = component.get("c.getplsettlementaccountsv2api");
            console.log(clientData);
            action.setParams({
                
                clientData: clientData
                
            });
            
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                
                var errors = response.getError();
                
                var res = response.getReturnValue();
                
                if (component.isValid() && state === "SUCCESS") {
                    
                    if (res.IsSuccess) {
                        
                        if (res.Data.dataMap.getStatusCode == 200) {
                            
                            var obj = JSON.parse(res.Data.dataMap.getBody);
                            console.log('Res: '+res.Data.dataMap.getBody);
                            if(obj.MSGO.NBSMSGO3.nbrUserMessages > 0){
                                let error_obj = obj.MSGO.NBSMSGO3.messageEntryTable[0].messageText;
                                this.errorMessagesHelper(component, event, 'Get PL info message', error_obj, 'scoring_obj');
                                return;
                            }
                            
                            this.sjmsubmitsettlementacctsv3Helper(component, event);
                            
                        } else {                                                                                       
                             let obj= res.Data.dataMap.getBody                                
                             this.errorMessagesHelper(component, event, 'Get settlement  message', obj, 'scoring_obj');                            
                        }
                        
                    } else {                        
                        this.errorMessagesHelper(component, event, 'getplsettlementaccountsv2api', res.Message, 'scoring_obj');                        
                    }
                    
                } else {                   
                    this.errorMessagesHelper(component, event, 'getplsettlementaccountsv2api error message', errors[0].message, 'scoring_obj');                    
                }
                
            });
            
            $A.enqueueAction(action);
            
        }
        
    },
    // 6th scoring service
    sjmsubmitsettlementacctsv3Helper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Submit settlement...');
        
        console.log('scoring service 6 - 5 skipped');
        var client = component.get("v.client");
        
        var clientData = '{"SJMsubmitSettlementAcctsV3":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"'+client.final_msg_class+'","finalMsgCode":"'+client.final_msg_code+'"}},"sjp300i":{"applicationNo":"' + client.application_number + '","financeType":"' + client.finance_type + '","settlementAccounts":[{"settAccountNumber":"' + client.sett_account_number + '","settCorp":"' + client.sett_corp + '"},{"settAccountNumber":"' + client.sett_account_number + '","settCorp":"' + client.sett_corp + '"}],"rlAccountNumber":"' + client.rl_account_number + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.sjmsubmitsettlementacctsv3");
        action.setParams({
            clientData: clientData,
        });
        action.setCallback(this, function(response) {
            var client = component.get("v.client");
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var sjmsubmitsettlementacctsv3API = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (sjmsubmitsettlementacctsv3API.SJMsubmitSettlementAcctsV3Response.nbsmsgo.nbrUserMsgs > 0) {
                            let error_obj = sjmsubmitsettlementacctsv3API.SJMsubmitSettlementAcctsV3Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Settlement account message', error_obj, 'scoring_obj'); 
                            return;

                        }                        
                        console.log(JSON.stringify(sjmsubmitsettlementacctsv3API));
                        if (sjmsubmitsettlementacctsv3API) {
                            var nbsapdpo = sjmsubmitsettlementacctsv3API.SJMsubmitSettlementAcctsV3Response.nbsapdpo;
                            var nbsmsgo = sjmsubmitsettlementacctsv3API.SJMsubmitSettlementAcctsV3Response.nbsmsgo;
                            var sjp300o = sjmsubmitsettlementacctsv3API.SJMsubmitSettlementAcctsV3Response.sjp300o;
                            
                            client.version = nbsapdpo.version;
                            client.return_code = nbsapdpo.returnCode;
                            client.reason_code = nbsapdpo.reasonCode;
                            client.service_version = nbsapdpo.serviceVersion;
                            client.echoKey = nbsapdpo.echoKey;
                            client.version = nbsmsgo.version;
                            client.sys_err_txt = nbsmsgo.sysErrTxt;
                            client.nbr_user_msgs = nbsmsgo.nbrUserMsgs;
                            client.nbr_user_errs = nbsmsgo.nbrUserErrs;
                            /*client.msg_class = nbsmsgo.msgEntry[0].msgClass;
                            client.msg_code = nbsmsgo.msgEntry[0].msgCode;
                            client.msg_err_ind = nbsmsgo.msgEntry[0].msgErrInd;
                            client.msg_txt = nbsmsgo.msgEntry[0].msgTxt;*/
                            client.next_func = sjp300o.nextFunc;
                            client.client_name = sjp300o.clientName;
                            //client.cif_key = sjp300o.cifKey;
                            
                            client.purpose_of_loan_rsn = sjp300o.purposeOfLoanRsn;
                            client.addit_loan_amnt = sjp300o.additLoanAmnt;
                            client.loan_exposure5 = sjp300o.loanExposure5;
                            client.loan_settlement_amnt = sjp300o.loanSettlementAmnt;
                            client.total_amount = sjp300o.totalLoanAmount;
                            client.no_of_paymts = sjp300o.noOfPaymts;
                            client.no_of_paymts_p = sjp300o.noOfPaymtsP;
                            client.skip_payment = sjp300o.skipPayment;
                            client.skip_payment_p = sjp300o.skipPaymentP;
                            client.initiation_fee_paym = sjp300o.initiationFeePaym;
                            client.initiation_fee_paym_p = sjp300o.initiationFeePaymP;
                            
                            client.paym_freq = sjp300o.paymFreq;
                            //client.payment_method = sjp300o.paymentMethod;
                            client.payment_method_p = sjp300o.paymentMethodP;
                            client.existing_rl_acno = sjp300o.existingRlAcno;
                            client.exist_rl_limit = sjp300o.existRlLimit;
                            //client.loan_acc_to_settle1
                            //client.loan_sett_corp1
                            client.pre_appr_appl_ind = sjp300o.preApprApplInd;
                            client.credit_life_ind = sjp300o.creditLifeInd;
                            client.credit_life_ind_p = sjp300o.creditLifeIndP;
                            client.rate_type = sjp300o.rateType;
                            client.pre_appr_int_rate = sjp300o.preApprIntRate;
                            client.pre_appr_appl_amnt = sjp300o.preApprApplAmnt;
                            client.plad_operator = sjp300o.pladOperator;
                            //client.finance_type = sjp300o.financeType;
                            client.addit_loan_amnt_p = sjp300o.additLoanAmntP;
                            client.balance_transfer_inst = sjp300o.balanceTransferInst;
                            
                            //client.number_of_payments = sjp300o.noOfPaymts;
                            if (sjp300o.noOfPaymts){
                                let number_of_payments = (client.number_of_payments_values.filter(el => el.value == sjp300o.noOfPaymts));
                                client.number_of_payments_label = number_of_payments.length == 1 ? number_of_payments[0].label : "";
                                client.number_of_payments_value = sjp300o.noOfPaymts;  
                            } 
                            
                            //pick list values start here
                            // sjp300o.purposeOfLoan is coming as one value, so we need to append with 0, because we have two value,  need to be confirmed
                            let purpose_of_loan = client.purpose_of_loan_values.filter(el => el.value == "0"+sjp300o.purposeOfLoan);
                            client.purpose_of_loan_label = purpose_of_loan.length == 1 ? purpose_of_loan[0].label : "";
                            client.purpose_of_loan_value = "0"+sjp300o.purposeOfLoan;
                            
                            
                            let payment_type = client.payment_type_values.filter(el => el.value == sjp300o.paymType);
                            client.payment_type_label = payment_type.length == 1 ? payment_type[0].label : "";
                            client.payment_type_value = sjp300o.paymType;
                           
                            let initiation_fee_payment_method = client.initiation_fee_payment_method_values.filter(el => el.value == sjp300o.initiationFeePaym);
                            client.initiation_fee_payment_method_label = initiation_fee_payment_method.length == 1 ? initiation_fee_payment_method[0].label : "";
                            client.initiation_fee_payment_method_value = sjp300o.initiationFeePaym;
                            
                            client.payment_method_p  = sjp300o.initiationFeePaym;
                            
                            
                            // We need to re-upload the sales_utilities, I did substring to accomodate testing
                            let payment_frequency = client.payment_frequency_values.filter(el => el.value == sjp300o.paymFreq.substring(1));
                            client.payment_frequency_label = payment_frequency.length == 1 ? payment_frequency[0].label : "";
                            client.payment_frequency_value = sjp300o.paymFreq.substring(1);
                            
                            
                            this.stopSpinner(component, event);
                            
                            component.set("v.client", client);
                            
                            
                        }
                        
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Submit settlement account exception', obj, 'scoring_obj'); 
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Submit settlement account warning', res.Message, 'scoring_obj'); 
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Submit settlement account error', errors[0].message, 'scoring_obj');
            }
        });
        $A.enqueueAction(action);
    },
    //7th Scoring service
    submitPLinfo: function(component, event) {
        
        this.dispaySpinner(component, event, 'Submit pl info...');
        
        console.log('scoring service 7');
        var client = component.get("v.client");
        
        if (client.application_number && client.branch_code && client.branch_site_type && client.agency_code && client.agency_site_type && client.teller_code && client.supervisor_code && client.finance_type && client.puporse_of_loan && client.additional_loan_amount && client.loan_exposure5 && client.number_of_payments_value && client.skip_payment && client.balance_transfer_inst) {
            var action = component.get("c.submitPLInfo");//absa_credit_life
            
            var clientData = '{"SJMsubmitPLInfoV4":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"'+client.final_msg_class+'","finalMsgCode":"'+client.final_msg_code+'"}},"sjb301di":{"applicationNo":"' + client.application_number + '","financeType":"' + client.products + '","purposeOfLoan":"' + client.purpose_of_loan_value+ '","purposeOfLoanRsn":"' + client.other + '","additLoanAmnt":"' + client.additional_loan_amount+ '","loanExposure5":"' + client.loan_exposure5 + '","paymType":"' + client.payment_type_value + '","noOfPaymts":"' + client.number_of_payments_value + '","skipPayment":"' + client.skip_payment + '","initiationFeePaym":"' + client.initiation_fee_payment_method_value + '","paymFreq":"' + client.paym_freq+ '","paymentMethod":"' + client.initiation_fee_payment_method_value+ '","creditLifeInd":"' + client.absa_credit_life+ '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '","amlrSelected":"' + client.amlr_selected + '","balanceTransferInst":"' + client.balance_transfer_inst+ '","scndCreditLife":"' + client.scnd_credit_life+ '"}}}';
            clientData = clientData.replace(/undefined/g, ''); 
            clientData = clientData.replace(/null/g, ''); 
            
            console.log(clientData);
            
            action.setParams({
                clientData: clientData
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var errors = response.getError();
                var res = response.getReturnValue();
                
                if (component.isValid() && state === "SUCCESS") {
                    if (res.IsSuccess) {
                        if (res.Data.dataMap.getStatusCode == 200) {
                            console.log('Res: '+res.Data.dataMap.getBody);
                            var obj = JSON.parse(res.Data.dataMap.getBody);
                            
                            if (obj.SJMsubmitPLInfoV4Response.nbsmsgo3.nbrUserMsgs > 0) {
                                let error_obj = obj.SJMsubmitPLInfoV4Response.nbsmsgo3.msgEntry[0].msgTxt;
                                this.errorMessagesHelper(component, event, 'Submit PL info message', error_obj, 'scoring_obj');                            
                                return;
                            }else if(obj.SJMsubmitPLInfoV4Response.sjb301do.nextFunc == null){
                                this.errorMessagesHelper(component, event, 'Submit PL info message', 'Technical Exception has occured in submit personal loan', 'scoring_obj');                            
                                return;
                            }  
                            
                            component.set('v.validate_update_obj','');
                            
                            if(component.get("v.client.absa_credit_life") == "Y"){
                                var submitPLinfo_Opened = obj.SJMsubmitPLInfoV4Response.sjb301do.creditLife;
                                if (submitPLinfo_Opened.length > 0) {
                                    var client = component.get("v.client");
                                    
                                    for(let i=0; i<=submitPLinfo_Opened.length; i++){
                                        
                                        let clSchemeName = (submitPLinfo_Opened[i].clSchemeName).trim();
                                        
                                        if(clSchemeName.trim() == "CONNECTZONE PERSONAL LOANS PLA"){
                                            
                                            // Which credit life should we consider with the credit team
                                            client.cl_prev_selected = submitPLinfo_Opened[i].clPrevSelected;
                                            client.cl_scheme_code = submitPLinfo_Opened[i].clSchemeCode;
                                            client.cl_scheme_name = submitPLinfo_Opened[i].clSchemeName;
                                            client.cl_benefit_decs = submitPLinfo_Opened[i].clBenefitDecs;
                                            client.cl_gross_premium = submitPLinfo_Opened[i].clGrossPremium;
                                            client.cl_nett_premium = submitPLinfo_Opened[i].clNettPremium;
                                            client.cl_commission = submitPLinfo_Opened[i].clCommission;
                                            client.cl_policy_fee = submitPLinfo_Opened[i].clPolicyFee;
                                            
                                            break;
                                            
                                        }
                                    }
                                   
                                    
                                    component.set("v.client", client);
                                }
                            }
                            
                           
                            //Call the next function
                            var nextFunct = obj.SJMsubmitPLInfoV4Response.sjb301do.nextFunc; 
                            if (nextFunct == 'CLIF'){                           
                                this.submitCreditLifePolicyInfoV1Helper(component, event);
                            }
                            else if (nextFunct == 'CMSM'){                        
                                this.sjmgetCMSSMSInfoHelper(component, event);
                            }   
                                else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                    this.submitCMSContinuationProcessHelper(component, event);
                                }   
                                    else if (nextFunct == 'CMST'){                           
                                        this.sjmSaveTriadAgreementHelper(component, event);
                                    } else { 
                                        this.errorMessagesHelper(component, event, 'Technical Exception', 'Technical exception has occured in submitplinfor', 'scoring_obj');                            
                                        return;
                                    }
                        } else {
                            let obj = res.Data.dataMap.getBody;
                            this.errorMessagesHelper(component, event, 'Submit application info exception', obj, 'scoring_obj');                            
                        }
                    } else {
                        this.errorMessagesHelper(component, event, 'Submit application info warning', res.Message, 'scoring_obj');
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Submit application info error', errors[0].message, 'scoring_obj');
                }
            });
            $A.enqueueAction(action);
        } else {
            this.messageModal(component, true, 'Message', 'Submit application info: mandatory fields required');
            this.stopSpinner(component, event);
            return;
        }
    },
    //8th scoring service
    submitCreditLifePolicyInfoV1Helper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Submit credit life policy...');        
        
        console.log('scoring service 8');
        var client = component.get("v.client");
        
        var clientData = '{"SJMsubmitCreditLifePolicyInfoV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgClass":"'+client.final_msg_class+'","finalMsgCode":"'+client.final_msg_code+'"},"sjb309i":{"corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '","applicationNo":"' + client.application_number + '","clSchemeCode":"' + client.cl_scheme_code+ '","clSchemeName":"' + client.cl_scheme_name+ '","clBenefitDecs":"' + client.cl_benefit_decs+ '","clGrossPremium":"' + client.cl_gross_premium+ '","clNettPremium":"' + client.cl_nett_premium+ '","clCommission":"' + client.cl_commission+ '","clPolicyFee":"' + client.cl_policy_fee+ '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.submitCreditLifePolicyInfoV1");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var client = component.get("v.client");
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        console.log(JSON.stringify(obj));
                        
                        if (obj.SJMsubmitCreditLifePolicyInfoV1Response.nbsmsgo3.nbrUserMsgs > 0) {
                            
                            let msgTxt = obj.SJMsubmitCreditLifePolicyInfoV1Response.nbsmsgo3.msgEntry[0].msgTxt;
                            
                            if(msgTxt =="Credit life was not asked for"){
                                
                            }else{
                                let error_obj = obj.SJMsubmitCreditLifePolicyInfoV1Response.nbsmsgo3.msgEntry[0].msgTxt;
                                this.errorMessagesHelper(component, event, 'Submit credit life message', error_obj, 'scoring_obj'); 
                                return;
                            }
                        }                             
                        
                        this.sjmgetCMSSMSInfoHelper(component, event);
                    } else {
                        let obj= res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Credit life policy exception', obj, 'scoring_obj'); 
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Credit life policy warning', res.Message, 'scoring_obj'); 
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Credit life policy error', errors[0].message, 'scoring_obj'); 
            }
        });
        $A.enqueueAction(action);
    },
    //scoring service   -- 9th service in the scoring sequence,  Name: sjmgetCMSSMSInfo    
    sjmgetCMSSMSInfoHelper: function(component, event) {
        
        
        this.dispaySpinner(component, event, 'Get cmssms info...');
        
        var client = component.get("v.client");
        
        var action = component.get("c.sjmgetCMSSMSInfo");
        var clientData = '{"NBSAPDPI":{"NBSAPLI":{"consumerChannel":"' + client.channel + '","providerApplication":"' + client.application + '","traceIndicator":"' + client.trace + '"}},"MSGI":{"NBSMSGI":{"version":"' + client.version + '","messageLanguage":"' + client.language + '","messageTarget":"' + client.target + '"}},"SJMgetCMSSMSInfoV2":{"SJMgetCMSSMSInfoV2Input":{"applicationNo":"' + client.application_number + '","corpCode":"' + client.corp_code + '","branchCode":"'+client.branch_code+'","branchSiteType":"'+client.branch_site_type+'","agencyCode":"'+client.agency_code+'","agencySiteType":"'+client.agency_site_type+'","tellerCode":"'+client.teller_code+'","supervisorCode":"'+ client.supervisor_code +'"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('sjm get CMSSMS Info Helper: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        console.log(JSON.stringify(obj));
                        if (obj.MSGO.NBSMSGO3.nbrUserMessages > 0) {
                            let error_obj = obj.MSGO.NBSMSGO3.messageEntryTable[0].messageText;
                            this.errorMessagesHelper(component, event, 'Get CMS SMS message', error_obj, 'scoring_obj'); 
                            return;
                        }else if(obj.SJMgetCMSSMSInfoV2.SJMgetCMSSMSInfoV2Output.nextFunction == null){
                                this.errorMessagesHelper(component, event, 'Get CMS SMS message', 'Technical Exception has occured in CMSSMS Info', 'scoring_obj');                            
                                return;
                        } 
                        
                        if (obj) {
                            var getCMSSMSInfoHelperResponse = obj.SJMgetCMSSMSInfoV2.SJMgetCMSSMSInfoV2Output;
                            var output_nextFunction = getCMSSMSInfoHelperResponse.nextFunction;
                            var output_currOverdraftLimit = getCMSSMSInfoHelperResponse.currOverdraftLimit;
                            var output_totSystemCalcLimit = getCMSSMSInfoHelperResponse.totSystemCalcLimit;
                            var output_custMaintenace = getCMSSMSInfoHelperResponse.custMaintenace;
                            var output_preApprovedInd = getCMSSMSInfoHelperResponse.preApprovedInd;
                            var output_grossIncome = getCMSSMSInfoHelperResponse.grossIncome;
                            var output_custBuroComm = getCMSSMSInfoHelperResponse.custBuroComm;
                            var output_custDisposableIncome = getCMSSMSInfoHelperResponse.custDisposableIncome;
                            var output_triadMntlyTurnover = getCMSSMSInfoHelperResponse.triadMntlyTurnover;
                            var output_addOverdraftLimit = getCMSSMSInfoHelperResponse.addOverdraftLimit;
                            var output_reqOverdraftLimit = getCMSSMSInfoHelperResponse.reqOverdraftLimit;
                            var output_custLivingExp = getCMSSMSInfoHelperResponse.custLivingExp;
                            var output_cmsmStatus = getCMSSMSInfoHelperResponse.cmsmStatus;
                            var error_msg1 = obj.MSGO.NBSMSGO3.systemErrorText;
                            var error_msg2 = obj.MSGO.NBSMSGO3.messageEntryTable[0];
                            var error_msg2_1 = error_msg2.messageText;
                            
                            if (obj.MSGO.NBSMSGO3.systemErrorText) {
                                alert(error_msg1 + '\n' + error_msg2);
                            }
                            //Call the next function
                            var nextFunct = output_nextFunction; 
                            if (nextFunct == 'CLIF'){                           
                                this.submitCreditLifePolicyInfoV1Helper(component, event);
                            }
                            else if (nextFunct == 'CMSM'){                        
                                this.sjmgetCMSSMSInfoHelper(component, event);
                            }   
                                else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                    this.submitCMSContinuationProcessHelper(component, event);
                                }   
                                    else if (nextFunct == 'CMST'){                           
                                        this.sjmSaveTriadAgreementHelper(component, event);
                                    } else { 
                                        this.errorMessagesHelper(component, event, 'Technical Exception', 'Technical exception has occured in cmssmsinfo', 'scoring_obj');                               
                                        return;
                                    }
                            //this.submitCMSContinuationProcessHelper(component, event);
                            
                        } else {
                            let obj= res.Data.dataMap.getBody;
                            this.errorMessagesHelper(component, event, 'Get CMSSMS info error', obj, 'scoring_obj'); 
                        }
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Get CMSSMS info warning', res.Message, 'scoring_obj'); 
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Get CMSSMS details error', errors[0].message, 'scoring_obj'); 
            }
        });
        $A.enqueueAction(action);
    },
    //10th service   -- 10th service in the scoring sequence,  Name: SJMsubmitCMSContinuationProcessV1    
    submitCMSContinuationProcessHelper: function(component, event) {
        
        
        this.dispaySpinner(component, event, 'Submit cms continuation process...');
        
        console.log('scoring service 10');
        let client = component.get("v.client");
        
        var action = component.get("c.submitCMSContinuationProcess");
        var clientData = '{"messageInterface":{"messageInterfaceRequest":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"nbsMessageInterface":{"nbsMessageInterfaceRequest":{"consumerChannel":"'+client.channel+'","providerApplication":"'+client.application+'","traceIndicator":"'+client.trace+'"}},"SJMsubmitCMSContinuationProcessV1":{"SJMsubmitCMSContinuationProcessV1Input":{"applicationNo":"'+client.application_number+'","continueIndicator":"Y","corpCode":"'+client.corp_code+'","branchCode":"'+client.branch_code+'","branchSiteType":"'+client.branch_site_type+'","agencyCode":"'+client.agency_code+'","angencySiteType":"'+client.agency_site_type+'","tellerCode":"'+client.teller_code+'","supervisorCode":"'+client.supervisor_code+'"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('submitCMSContinuationProcessV1 Helper: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        let message_text = obj.MSGO.NBSMSGO3.messageEntryTable[0].messageText;
                        if (message_text) {
                            this.errorMessagesHelper(component, event, 'Technical Exception', message_text, 'scoring_obj'); 
                            return;
                        }
                        this.sjmSaveTriadAgreementHelper(component, event);
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Submit continuation process exception', obj, 'scoring_obj'); 
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Submit continuation process message', res.Message, 'scoring_obj'); 
                 }
            } else {
                this.errorMessagesHelper(component, event, 'Submit continuation process error', errors[0].message, 'scoring_obj'); 
            }
        });
        $A.enqueueAction(action);
    },
    //service   -- 11th service in the scoring sequence, Name: SJMsaveTRIADAgreementV1    
    sjmSaveTriadAgreementHelper: function(component, event) {
        
        
        this.dispaySpinner(component, event, 'Save triad agreement...');
        
        
        console.log('scoring service 11');
        var client = component.get("v.client");
        var action = component.get("c.saveTRIADAgreement");
        
        var clientData = '{"SJMsaveTRIADAgreementV1":{"nbsapdpi":{"application":"'+ client.channel+'","channel":"'+client.application+'","trace":"'+client.trace+'"},"nbsmsgi":{"finalMsgId":{"finalMsgClass":"'+client.final_msg_class+'","finalMsgCode":"'+client.final_msg_code+'"},"msgLanguage":"'+client.language+'","msgTarget":"'+client.target+'"},"sjb315i":{"agencyCode":"' + client.agency_code+ '","agencySiteType":"'+client.agency_site_type+'","applicationNo":"'+client.application_number +'","branchCode":"'+client.branch_code+'","branchSiteType":"'+client.branch_site_type+'","clientResponse":"'+client.client_response+'","continueIndicator":"'+client.continue_indicator+'","corpCode":"'+client.corp_code+'","supervisorCode":"'+client.supervisor_code+'","tellerCode":"'+client.teller_code+'"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('Rsave TRIAD Agreement object: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMsaveTRIADAgreementV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            let msgTxt =  obj.SJMsaveTRIADAgreementV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            
                            if(msgTxt == "Application is not pre-approved"){
                                
                            }else{
                                let error_obj = msgTxt;
                                this.errorMessagesHelper(component, event, 'Save triad agreement exception', error_obj, 'scoring_obj');
                                return;
                            }
                        }else{
                            
                        }                            
                        /*
                        var getsjmSaveTriadAgreementDetails = obj.SJMsaveTRIADAgreementV1Response.nbsmsgo.msgEntry[0];
                        var getsjmSaveTriadAgreementDetails_msgErrInd = getsjmSaveTriadAgreementDetails.msgErrInd;
                        var getsjmSaveTriadAgreementDetails_msgTxt = getsjmSaveTriadAgreementDetails.msgTxt;
                        this.getclientcreditinfomaint(component, event); */
                        this.getclientcreditinfomaint(component, event);
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Save triad agreement exception', obj, 'scoring_obj'); 
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Save triad agreement warning', res.Message, 'scoring_obj'); 
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Save triad agreement error', errors[0].message, 'scoring_obj'); 
            }
        });
        $A.enqueueAction(action);
    },
    //service   -- 12th service in the scoring sequence, Name: SJMgetClientCreditInfoMaintV2    
    getclientcreditinfomaint: function(component, event) {
        
        this.dispaySpinner(component, event, 'Get client credit info maint...');        
        
        console.log('scoring service 12');
        var client = component.get("v.client");
        
        if (client.application_number && client.branch_code && client.branch_site_type && client.agency_code && client.agency_site_type && client.teller_code && client.supervisor_code) {
            var action = component.get("c.getClientCreditInfomaint");
            var clientData = '{"SJMgetClientCreditInfoMaintV2":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjp329i":{"applicationNo":"' + client.application_number + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
            clientData = clientData.replace(/undefined/g, ''); 
            clientData = clientData.replace(/null/g, '');                     
            console.log('getclientcreditinfomaint object: ' + clientData);
            action.setParams({
                clientData: clientData
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var errors = response.getError();
                var res = response.getReturnValue();
                
                if (component.isValid() && state === "SUCCESS") {
                    if (res.IsSuccess) {
                        if (res.Data.dataMap.getStatusCode == 200) {
                            console.log('Res: '+res.Data.dataMap.getBody);
                            var getclientCreditInfoApi = JSON.parse(res.Data.dataMap.getBody);
                            
                            if (getclientCreditInfoApi.SJMgetClientCreditInfoMaintV2Response.nbsmsgo.nbrUserMsgs > 0) {
                                let error_obj = getclientCreditInfoApi.SJMgetClientCreditInfoMaintV2Response.nbsmsgo.msgEntry[0].msgTxt;
                                this.errorMessagesHelper(component, event, 'Client credit info message', error_obj, 'scoring_obj');                                 
                                return;
                            }   
                            
                            var clientCreditInfoMaint_Opened = getclientCreditInfoApi.SJMgetClientCreditInfoMaintV2Response;
                            if (clientCreditInfoMaint_Opened) {
                                var client = component.get("v.client");
                                
                                client.client_name = clientCreditInfoMaint_Opened.sjp329o.clientName;
                                //client.cif_key = clientCreditInfoMaint_Opened.sjp329o.cifKey;
                                client.absa_staff_mem = clientCreditInfoMaint_Opened.sjp329o.absaStaffMem;
                                client.applcnt_dob = clientCreditInfoMaint_Opened.sjp329o.applcntDob;
                                client.new_exist_client = clientCreditInfoMaint_Opened.sjp329o.newExistClient;
                                client.dte_first_acc_open = clientCreditInfoMaint_Opened.sjp329o.dteFirstAccOpen;
                                client.gender = clientCreditInfoMaint_Opened.sjp329o.gender;
                                client.gender_desc = clientCreditInfoMaint_Opened.sjp329o.genderDesc;
                                client.marital_status = clientCreditInfoMaint_Opened.sjp329o.maritalStatus;
                                client.marital_status_desc = clientCreditInfoMaint_Opened.sjp329o.maritalStatusDesc;
                                client.marital_contract = clientCreditInfoMaint_Opened.sjp329o.maritalContract;
                                client.marital_contract_desc = clientCreditInfoMaint_Opened.sjp329o.maritalContractDesc;
                                client.no_of_depend = clientCreditInfoMaint_Opened.sjp329o.noOfDepend;
                                client.home_lang = clientCreditInfoMaint_Opened.sjp329o.homeLang;
                                client.home_lang_desc = clientCreditInfoMaint_Opened.sjp329o.homeLangDesc;
                                client.sa_citizen = clientCreditInfoMaint_Opened.sjp329o.saCitizen;
                                client.nash141_sa_resident = clientCreditInfoMaint_Opened.sjp329o.nash141SaResident;
                                client.temporary_resident = clientCreditInfoMaint_Opened.sjp329o.temporaryResident;
                                client.everInsol_admin = clientCreditInfoMaint_Opened.sjp329o.everInsolAdmin;
                                client.dte_rehab_Insolv = clientCreditInfoMaint_Opened.sjp329o.dteRehabInsolv;
                                client.solp_agricul_rel = clientCreditInfoMaint_Opened.sjp329o.solpAgriculRel;
                                client.debt_counseling = clientCreditInfoMaint_Opened.sjp329o.debtCounseling;
                                client.app_debt_counseling_ap = clientCreditInfoMaint_Opened.sjp329o.appDebtCounselingAp;
                                client.residen_status = clientCreditInfoMaint_Opened.sjp329o.residenStatus;
                                client.residen_status_desc = clientCreditInfoMaint_Opened.sjp329o.residenStatusDesc;
                                client.res_dte_since = clientCreditInfoMaint_Opened.sjp329o.resDteSince;
                                client.home_tel_suppld = clientCreditInfoMaint_Opened.sjp329o.homeTelSuppld;
                                client.cell_tel_prov = clientCreditInfoMaint_Opened.sjp329o.cellTelProv;
                                client.bond_amt_outst = clientCreditInfoMaint_Opened.sjp329o.bondAmtOutst;
                                client.bond_amt_outstP = clientCreditInfoMaint_Opened.sjp329o.bondAmtOutstP;
                                client.res_mar_ket_val = clientCreditInfoMaint_Opened.sjp329o.resMarketVal;
                                client.res_market_valP = clientCreditInfoMaint_Opened.sjp329o.resMarketValP;
                                client.occupation_code = clientCreditInfoMaint_Opened.sjp329o.occupationCode;
                                client.occupation_code_desc = clientCreditInfoMaint_Opened.sjp329o.occupationCodeDesc;
                                client.actual_occupation = clientCreditInfoMaint_Opened.sjp329o.actualOccupation;
                                client.actual_occupationP = clientCreditInfoMaint_Opened.sjp329o.actualOccupationP;
                                client.employer_name = clientCreditInfoMaint_Opened.sjp329o.employerName;
                                client.dte_pres_employ = clientCreditInfoMaint_Opened.sjp329o.dtePresEmploy;
                                client.dte_pres_employP = clientCreditInfoMaint_Opened.sjp329o.dtePresEmployP;
                                client.business_sect = clientCreditInfoMaint_Opened.sjp329o.businessSect;
                                client.business_sect_desc = clientCreditInfoMaint_Opened.sjp329o.businessSectDesc;
                                client.employ_status_ap = clientCreditInfoMaint_Opened.sjp329o.employStatusAp;
                                client.employ_status_ap_desc = clientCreditInfoMaint_Opened.sjp329o.employStatusApDesc;
                                client.employ_level_ap = clientCreditInfoMaint_Opened.sjp329o.employLevelAp;
                                client.freq_sal_p_payments = clientCreditInfoMaint_Opened.sjp329o.freqSalPayments;
                                client.freq_sal_payments_desc = clientCreditInfoMaint_Opened.sjp329o.freqSalPaymentsDesc;
                                client.work_tel_prov = clientCreditInfoMaint_Opened.sjp329o.workTelProv;
                                client.spouse_details_avail = clientCreditInfoMaint_Opened.sjp329o.spouseDetailsAvail;
                                client.spouse_details_availP = clientCreditInfoMaint_Opened.sjp329o.spouseDetailsAvailP;
                                client.employ_status_sp = clientCreditInfoMaint_Opened.sjp329o.employStatusSp;
                                client.employ_status_sp_desc = clientCreditInfoMaint_Opened.sjp329o.employStatusSpDesc;
                                client.employ_status_spP = clientCreditInfoMaint_Opened.sjp329o.employStatusSpP;
                                client.ccin_operator = clientCreditInfoMaint_Opened.sjp329o.ccinOperator;
                                client.bus_rescue_aff = clientCreditInfoMaint_Opened.sjp329o.busRescueAff;
                                
                                component.set("v.client", client);
                                
                                this.submitClientDetailHelper(component, event);
                            }
                        } else {
                            let obj = res.Data.dataMap.getBody;
                            this.errorMessagesHelper(component, event, 'Client credit info exception', obj, 'scoring_obj');                       
                        }
                    } else {
                        this.errorMessagesHelper(component, event, 'Client credit info message', res.Message, 'scoring_obj');                       
                    }
                   
                } else {
                    this.errorMessagesHelper(component, event, 'Client credit info error', errors[0].message, 'scoring_obj');                        
                } 
            });
            $A.enqueueAction(action);
       
        } else {
            this.errorMessagesHelper(component, event, 'Message', 'Client credit info maint: mandatory fields required', 'scoring_obj');                       
        }
    },
    //service   -- 13th service in the scoring sequence, Name: SJMsubmitClientDetailV1    
    submitClientDetailHelper: function(component, event) {
        
        
        this.dispaySpinner(component, event, 'Submit client details...');
        
        console.log('scoring service 13');
        var client = component.get("v.client");
        var action = component.get("c.submitClientDetail");
        let clientObj ={};
        let current_employment_since = component.get("v.client.current_employment_since");
        if(current_employment_since){
            if(current_employment_since.includes("/")){    
                 current_employment_since = this.dateFormating("Validate_And_Update","DD/MM/YYYY",current_employment_since);
            }
        }else{
            current_employment_since = (current_employment_since) ? this.getFormattedDate(component, current_employment_since) : null;
        }
        let current_address_since = component.get("v.client.current_address_since");
        if(current_address_since){
            if(current_address_since.includes("/")){    
                current_address_since = this.dateFormating("Validate_And_Update","DD/MM/YYYY",current_address_since);
            }
        }else{
           current_address_since = client.dte_pres_employ;
        }
       
          if(client.outstanding_bond){
              client.bond_amt_outst = client.outstanding_bond;
          }  
          if(client.realistic_market_value){
              client.res_mar_ket_val = client.realistic_market_value;
          } 
        
        if(client.occupational_status_value != "01" || client.occupational_status_value != "1" || client.occupational_status_value !="08" || client.occupational_status_value !="8" || client.occupational_status_value !="09" || client.occupational_status_value !="9"){
            client.actual_occupationP = "0";
        }
        
        var clientData = '{"SJMsubmitClientDetailV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjp620i":{"applicationNo":"' + client.application_number + '","saCitizen":"' + client.sa_citizen + '","everInsolAdmin":"' + client.everInsol_admin + '","dteRehabInsolv":"' + client.dte_rehab_Insolv + '","appDebtCounselingAp":"' + client.debt_counseling + '","bondAmtOutst":"' + client.bond_amt_outst + '","resMarketVal":"' + client.res_mar_ket_val + '","resDteSince":"' + current_address_since + '","actualOccupation":"' + client.actual_occupationP + '","dtePresEmploy":"' + current_employment_since+ '","freqSalPayments":"' + client.freq_sal_p_payments + '","spouseDetailsAvail":"' + client.spouse_details_avail + '","employStatusSp":"' + client.employ_status_sp + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('submit Client Detail Helper: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMsubmitClientDetailV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            
                            if(obj.SJMsubmitClientDetailV1Response.nbsmsgo.msgEntry[0].msgTxt=="Current employment status since date invalid"){
                                
                                this.submitClientDetailSecondTimeHelper(component, event);
                            }else{
                                let error_obj = obj.SJMsubmitClientDetailV1Response.nbsmsgo.msgEntry[0].msgTxt;
                                this.errorMessagesHelper(component, event, 'Submit client detail message', error_obj, 'scoring_obj'); 
                                return;
                            }
                            
                        }else{
                            /* client.res_dte_since_o = 
                            client.dte_pres_employ_o = */
                        }
                        
                        this.getclientExpenses(component, event);
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'submit client detail exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Submit client detail info warning', res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'submit client detail error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
        //service   -- 13th service in the scoring sequence, Name: SJMsubmitClientDetailV1    
    submitClientDetailSecondTimeHelper: function(component, event) {
        
        
        this.dispaySpinner(component, event, 'Submit client details...');
        
        console.log('scoring service 13');
        var client = component.get("v.client");
        var action = component.get("c.submitClientDetail");
        let clientObj ={};
        let current_employment_since = "0";
        let current_address_since = component.get("v.client.current_address_since");
        if(current_address_since){
            if(current_address_since.includes("/")){    
                current_address_since = this.dateFormating("Validate_And_Update","DD/MM/YYYY",current_address_since);
            }
        }else{
           current_address_since = client.dte_pres_employ;
        }
       
          let outstanding_bond = component.get("v.client.outstanding_bond");
          if(outstanding_bond){
              client.bond_amt_outst = outstanding_bond;
          }  
          let realistic_market_value = component.get("v.client.realistic_market_value");
          if(realistic_market_value){
              client.res_mar_ket_val = realistic_market_value;
          } 
        
        if(client.occupational_status_value != "01" || client.occupational_status_value != "1" || client.occupational_status_value !="08" || client.occupational_status_value !="8" || client.occupational_status_value !="09" || client.occupational_status_value !="9"){
            client.actual_occupationP = "";
        }
        
        
        
        var clientData = '{"SJMsubmitClientDetailV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjp620i":{"applicationNo":"' + client.application_number + '","saCitizen":"' + client.sa_citizen + '","everInsolAdmin":"' + client.everInsol_admin + '","dteRehabInsolv":"' + client.dte_rehab_Insolv + '","appDebtCounselingAp":"' + client.debt_counseling + '","bondAmtOutst":"' + client.bond_amt_outst + '","resMarketVal":"' + client.res_mar_ket_val + '","resDteSince":"' + current_address_since + '","actualOccupation":"' + client.actual_occupationP + '","dtePresEmploy":"' + current_employment_since+ '","freqSalPayments":"' + client.freq_sal_p_payments + '","spouseDetailsAvail":"' + client.spouse_details_avail + '","employStatusSp":"' + client.employ_status_sp + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('submit Client Detail Helper: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMsubmitClientDetailV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            
                            if(obj.SJMsubmitClientDetailV1Response.nbsmsgo.msgEntry[0].msgTxt=="Current employment status since date invalid"){
                                
                                this.submitClientDetailHelper(component, event);
                            }
                            let error_obj = obj.SJMsubmitClientDetailV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'submit client detail message', error_obj, 'scoring_obj');   
                            return;
                        }else{
                            /* client.res_dte_since_o = 
                            client.dte_pres_employ_o = */
                        }
                        
                        this.getclientExpenses(component, event);
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'submit client detail info exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'submit client detail info warning', res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'submit client detail error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    //service   -- 14th service in the scoring sequence, Name: SJMgetExpensesV6   
    getclientExpenses: function(component, event) {
        
        this.dispaySpinner(component, event, 'Get client expenses...');
       
        
        console.log('scoring service 14');
        let client = component.get("v.client");
        var application_number = client.application_number;
        
        var action = component.get("c.getExpenses");
        var clientData = '{"SJMgetExpensesV6":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjb326i":{"applicationNo":"' + client.application_number + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('get Expenses Detail Helper: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMgetExpensesV6Response.nbsmsgo3.nbrUserMsgs > 0) {
                            let error_obj = obj.SJMgetExpensesV6Response.nbsmsgo3.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Get expense details', error_obj, 'scoring_obj');   
                            return;
                        }
                        
                        var getExpenseResponse = obj.SJMgetExpensesV6Response.sjb326o;
                        //Mapping the values to UI
                        //client.groceries = getExpenseResponse.
                        //
                        //MONTHY LIVING EXPENSE START
                        client.groceries = getExpenseResponse.householdExpenses;
                        client.domestic_garderner_worker_etc = getExpenseResponse.domestic;
                        client.education_school_loan_repayment = getExpenseResponse.schoolUnivFees;
                        client.transport_petrol_excl_vehicle_finance = getExpenseResponse.transport;
                        client.insurance_and_funeral_policies = getExpenseResponse.insurance;
                        client.municipal_levies_rates_taxes_water_light = getExpenseResponse.municipal;
                        client.telephone_cellphone =getExpenseResponse.cell;
                        
                        
                        client.security = getExpenseResponse.security;
                        client.rental = getExpenseResponse.rental;
                        client.maintenance = getExpenseResponse.maintPayment;
                        client.entertainment = getExpenseResponse.entertainment;
                        client.specify_other_expenses =getExpenseResponse.specifyOthExp;
                        client.amount = getExpenseResponse.otherExpenses;
                        
                        client.necessary_expenses = parseFloat(client.groceries)  + parseFloat(client.domestic_garderner_worker_etc)  + parseFloat(client.education_school_loan_repayment)  + parseFloat(client.transport_petrol_excl_vehicle_finance)  + parseFloat(client.insurance_and_funeral_policies)  + parseFloat(client.municipal_levies_rates_taxes_water_light)  + parseFloat(client.telephone_cellphone) + parseFloat(client.security) + parseFloat(client.rental) + parseFloat(client.maintenance) + parseFloat(client.entertainment)  + parseFloat(client.specify_other_expenses) + parseFloat(client.amount);
                        

                        //MONTHY LIVING EXPENSE END
                        
                        //MONTHLY INCOME  START
                        client.gross_income =getExpenseResponse.totGrossIncome;
                        client.salary_deductions =getExpenseResponse.totalSalDed;
                        client.net_salary_income_month_1 =getExpenseResponse.netSalIncMnt1;
                        client.net_salary_income_month_2 =getExpenseResponse.netSalIncMnt2;
                        client.net_salary_income_month_3 =getExpenseResponse.netSalIncMnt3;
                        client.salary_deducted_fixed_debit =getExpenseResponse.salDedFixedDebt;
                        client.rental_income =getExpenseResponse.rentalIncome;
                        client.other_additional_income =getExpenseResponse.otherAddInc;
                        
                        
                        
                        client.bond_mortgage =getExpenseResponse.homeLoanInstal;
                        client.loan_overdraft =getExpenseResponse.loanOverdraft;
                        client.credit_cards =getExpenseResponse.ccRetailInstal;
                        client.retail_accounts =getExpenseResponse.retail;
                        client.other_debt_repayment =getExpenseResponse.otherExpenses;
                        client.surplus_shortage =getExpenseResponse.surplusShortage;
                        client.total_monthly_expenses =getExpenseResponse.totMonthlyExpenses;
                        client.total_dept_repayment =getExpenseResponse.totalDebtRepay;
                        //MONTHLY INCOME  END
                        
                        
                        
                        
                        // Need to be confirmed  --- Removed if not needed start
                        client.total_net_monthly_income =getExpenseResponse.totNetMntInc;
                        client.household_expenses =getExpenseResponse.householdExpenses;
                        client.maint_payment =getExpenseResponse.maintPayment;
                        client.other_expenses =getExpenseResponse.otherExpenses;                        
                        client.loan_overdraft =getExpenseResponse.loanOverdraft;
                        
                        client.isa_instal =getExpenseResponse.isaInstal;
                        client.other_instal =getExpenseResponse.otherInstal;
                        // Need to be confirmed  --- Removed if not needed start
                        
                        
                        
                        component.set("v.client", client);
                        
                         this.stopSpinner(component, event);
                        //this.submitExpense(component, event);
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Get expense details exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Get expense details info warning', res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Get expense detail error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    //service   -- 15th service in the scoring sequence, Name: SJMsubmitExpenseV6   
    submitExpense: function(component, event) {
        
        var client = component.get("v.client");
        
        
        client.gross_income = client.gross_income ? client.gross_income : 0;
        client.net_salary_income_month_1 = client.net_salary_income_month_1 ? client.net_salary_income_month_1 : 0;
        client.net_salary_income_month_2 = client.net_salary_income_month_2 ? client.net_salary_income_month_2 : 0;
        client.net_salary_income_month_3 = client.net_salary_income_month_3 ? client.net_salary_income_month_3 : 0;
        client.salary_deducted_fixed_debit = client.salary_deducted_fixed_debit ? client.salary_deducted_fixed_debit : 0;
        client.rental_income = client.rental_income ? client.rental_income : 0;
        client.other_additional_income = client.other_additional_income ? client.other_additional_income : 0;
        client.groceries = client.groceries ? client.groceries : 0;
        client.municipal_levies_rates_taxes_water_light = client.municipal_levies_rates_taxes_water_light ? client.municipal_levies_rates_taxes_water_light : 0;
        client.domestic_garderner_worker_etc = client.domestic_garderner_worker_etc ? client.domestic_garderner_worker_etc : 0;
        client.telephone_cellphone = client.telephone_cellphone ? client.telephone_cellphone : 0;
        client.education_school_loan_repayment = client.education_school_loan_repayment ? client.education_school_loan_repayment : 0;
        client.transport_petrol_excl_vehicle_finance = client.transport_petrol_excl_vehicle_finance ? client.transport_petrol_excl_vehicle_finance : 0;
        client.insurance_and_funeral_policies = client.insurance_and_funeral_policies ? client.insurance_and_funeral_policies : 0;
        client.entertainment = client.entertainment ? client.entertainment : 0; 
        client.security  = client.security ? client.security : 0; 
        client.rental = client.rental ? client.rental : 0;  
        client.maintenance = client.maintenance ? client.maintenance : 0; 
        client.other_expenses = client.other_expenses ? client.other_expenses : 0; 
        client.specify_oth_exp = client.specify_oth_exp ? client.specify_oth_exp : 0; 
        client.bond_mortgage = client.bond_mortgage ? client.bond_mortgage : 0; 
        client.loan_overdraft = client.loan_overdraft ? client.loan_overdraft : 0; 
        client.credit_cards = client.credit_cards ? client.credit_cards : 0; 
        client.isa_instal = client.isa_instal ? client.isa_instal : 0; 
        client.retail_accounts = client.retail_accounts ? client.retail_accounts : 0; 
        client.other_instal = client.other_instal ? client.other_instal : 0; 
     
        
         this.dispaySpinner(component, event, 'Submit expense...');
        
        console.log('scoring service 15');
        
        
        var clientData = '{"NBSAPDPI":{"inputHeaders":{"channelName":"' + client.channel + '","applicationName":"' + client.application + '","traceIndicator":"' + client.trace + '"}},"NBSMSGI":{"inputErrorMessages":{"errorMessageLanguage":"' + client.language + '","errorMessageTarget":"' + client.target + '"}},"SJB321D":{"inputFields":{"corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '","applicationNumber":"' + client.application_number + '","totalGrossIncome":"' + client.gross_income+ '","netSalaryIncomeMonth1":"' + client.net_salary_income_month_1+ '","netSalaryIncomeMonth2":"' + client.net_salary_income_month_2+ '","netSalaryIncomeMonth3":"' + client.net_salary_income_month_3+ '","salaryDeductionFixedDebt":"' + client.salary_deducted_fixed_debit+ '","retailIncome":"' + client.rental_income+ '","otherAdditionalIncome":"' + client.other_additional_income+ '","householdExpenses":"' + client.groceries+ '","municipal":"' + client.municipal_levies_rates_taxes_water_light+ '","domestic":"' + client.domestic_garderner_worker_etc+ '","cell":"' + client.telephone_cellphone+ '","schoolUniversityFees":"' + client.education_school_loan_repayment+ '","transport":"' + client.transport_petrol_excl_vehicle_finance+ '","insurance":"' + client.insurance_and_funeral_policies+ '","entertainment":"' + client.entertainment+ '","security":"' + client.security + '","rental":"' + client.rental + '","maintenancePayment":"' + client.maintenance+ '","otherExpenses":"' + client.other_expenses+ '","specifyOtherExpenses":"' + client.specify_oth_exp+ '","homeLoanInstallments":"' + client.bond_mortgage+ '","loanOverdraft":"' + client.loan_overdraft+ '","creditCardInstallments":"' + client.credit_cards+ '","ISAInstallments":"' + client.isa_instal+ '","retail":"' + client.retail_accounts+ '","otherInstallments":"' + client.other_instal+ '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('Submit ExpenseV6 Detail Helper: ' + clientData);
        var action = component.get("c.submitExpense");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.NBSMSGO3.outputErrorMessage.numberUserErrors > 0) {
                            let error_obj = obj.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText;
                            this.errorMessagesHelper(component, event, 'Submit expense details message', error_obj, 'scoring_obj');   
                            return;
                        }
                        
                        if (obj.NBSAPDPO) {
                            var client = component.get("v.client");
                            
                            client.service_version = obj.NBSAPDPO.outputHeader.serviceVersion;
                            client.return_code = obj.NBSAPDPO.outputHeader.returnCode;
                            client.echo_key = obj.NBSAPDPO.outputHeader.echoKey;
                            client.reason_code = obj.NBSAPDPO.outputHeader.reasonCode;
                            client.version = obj.NBSAPDPO.outputHeader.version;
                            client.system_error_text = obj.NBSMSGO3.systemErrorText;
                            client.number_user_errors = obj.NBSMSGO3.numberUserErrors;

                            client.number_user_messages = obj.NBSMSGO3.outputErrorMessage.numberUserMessages;
                            
                            component.set("v.client", client);
                            
                            
                            this.sjmgetfinancialdetailsv1Helper(component, event);
                        }
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Submit expense details exception', obj, 'scoring_obj');   
                    }
                } else {
                   this.errorMessagesHelper(component, event, 'Submit details info warning', res.Message, 'scoring_obj');   
                }
            } else {
                this.errorMessagesHelper(component, event, 'Submit expense detail error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    //service   -- 16th service in the scoring sequence, Name: SJMgetFinancialDetailsV1  
    sjmgetfinancialdetailsv1Helper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Get financial details...');        
        
        console.log('scoring service 16');
        var client = component.get("v.client");
        
        var clientData = '{"SJMgetFinancialDetailsV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjp325i":{"applicationNo":"' + client.application_number + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.sjmgetfinancialdetailsv1");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var client = component.get("v.client");
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var sjmgetfinancialdetailsv1API = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (sjmgetfinancialdetailsv1API.SJMgetFinancialDetailsV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            let error_obj = sjmgetfinancialdetailsv1API.SJMgetFinancialDetailsV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Get financial details message', error_obj, 'scoring_obj'); 
                            return;
                        }
                        
                        if (sjmgetfinancialdetailsv1API) {
                            var sjp325o = sjmgetfinancialdetailsv1API.SJMgetFinancialDetailsV1Response.sjp325o;
                            client.client_name = sjp325o.clientName;
                            //client.cif_key = sjp325o.cifKey;
                            client.partner_tab = sjp325o.partnerTab;
                            client.mp_name = sjp325o.mpName;
                            client.mp_name_d = sjp325o.mpNameD;
                            client.mp_cheq_acc_inst = sjp325o.mpCheqAccInst;
                            client.mp_cheq_acc_inst_desc = sjp325o.mpCheqAccInstDesc;
                            client.mp_cheq_acc_desc_d = sjp325o.mpCheqAccDescD;
                            client.mp_ext_cheq_inst = sjp325o.mpExtCheqInst;
                            client.mp_ext_cheq_inst_desc = sjp325o.mpExtCheqInstDesc;
                            client.mp_cc_inst = sjp325o.mpCcInst;
                            client.mp_cc_inst_desc = sjp325o.mpCcInstDesc;
                            client.mp_cc_inst_desc_d = sjp325o.mpCcInstDescD;
                            client.mp_pers_loan_inst = sjp325o.mpPersLoanInst;
                            client.mp_pers_loan_inst_desc = sjp325o.mpPersLoanInstDesc;
                            client.mp_pers_loan_desc_d = sjp325o.mpPersLoanDescD;
                            client.mp_bond_inst = sjp325o.mpBondInst;
                            client.mp_bond_inst_desc = sjp325o.mpBondInstDesc;
                            client.mp_bond_inst_desc_d = sjp325o.mpBondInstDescD;
                            client.mp_sav_acc_inst = sjp325o.mpSavAccInst;
                            client.mp_sav_acc_inst_desc = sjp325o.mpSavAccInstDesc;
                            client.mp_sav_acc_inst_desc_d = sjp325o.mpSavAccInstDescD;
                            client.mp_invest_acc_inst = sjp325o.mpInvestAccInst;
                            client.mp_invest_inst_desc = sjp325o.mpInvestInstDesc;
                            client.mp__invest_inst_desc_d = sjp325o.mpInvestInstDescD;
                            client.sp_name = sjp325o.spName;
                            client.sp_name_d = sjp325o.spNameD;
                            client.sp_cheq_acc_inst = sjp325o.spCheqAccInst;
                            client.sp_cheq_acc_inst_d = sjp325o.spCheqAccInstD;
                            client.sp_ext_cheq_inst = sjp325o.spExtCheqInst;
                            client.sp_ext_cheq_inst_d = sjp325o.spExtCheqInstD;
                            client.sp_ext_cheq_inst_desc = sjp325o.spExtCheqInstDesc;
                            client.sp_ext_cheq_desc_d = sjp325o.spExtCheqDescD;
                            client.sp_cc_inst = sjp325o.spCcInst;
                            client.sp_cc_inst_d = sjp325o.spCcInstD;
                            client.sp_pers_loan_inst = sjp325o.spPersLoanInst;
                            client.sp_pers_loan_inst_d = sjp325o.spPersLoanInstD;
                            client.sp_bond_inst = sjp325o.spBondInst;
                            client.sp_bond_inst_d = sjp325o.spBondInstD;
                            client.sp_sav_acc_inst = sjp325o.spSavAccInst;
                            client.sp_sav_acc_inst_d = sjp325o.spSavAccInstD;
                            client.sp_invest_acc_inst = sjp325o.spInvestAccInst;
                            client.sp_invest_inst_d = sjp325o.spInvestInstD;
                            client.appl_nett_worth = sjp325o.applNettWorth;
                            client.appl_nett_worth_p = sjp325o.applNettWorthP;
                            client.me_appl_nett_worth = sjp325o.meApplNettWorth;
                            client.me_appl_nett_worth_p = sjp325o.meApplNettWorthP;
                            client.nett_worth_site_code = sjp325o.nettWorthSiteCode;
                            client.nett_worth_site_code_p = sjp325o.nettWorthSiteCodeP;
                            client.nett_worth_date_cap = sjp325o.nettWorthDateCap;
                            client.nett_worth_date_cap_p = sjp325o.nettWorthDateCapP;
                            client.mp_dir_ord_cred_exp = sjp325o.mpDirOrdCredExp;
                            client.mp_mort_cpf_exp = sjp325o.mpMortCpfExp;
                            client.mp_mort_agric_exp = sjp325o.mpMortAgricExp;
                            client.mp_tot_ord_cred_exp = sjp325o.mpTotOrdCredExp;
                            client.mp_dir_asset_fin_exp = sjp325o.mpDirAssetFinExp;
                            client.mp_medium_term_exp = sjp325o.mpMediumTermExp;
                            client.mp_mort_res_exp = sjp325o.mpMortResExp;
                            client.mp_sub_tot_dir_exp = sjp325o.mpSubTotDirExp;
                            client.mp_cont_liab_ord_cred = sjp325o.mpContLiabOrdCred;
                            client.mp_ord_cred_comm_absa = sjp325o.mpOrdCredCommAbsa;
                            client.mp_mort_cpf_comm_absa = sjp325o.mpMortCpfCommAbsa;
                            client.mp_mort_agric_com_absa = sjp325o.mpMortAgricComAbsa;
                            client.mp_tot_ord_cred_com = sjp325o.mpTotOrdCredCom;
                            client.mp_asset_fin_comm_absa = sjp325o.mpAssetFinCommAbsa;
                            client.mp_medium_term_com = sjp325o.mpMediumTermCom;
                            client.mp_mort_res_comm_absa = sjp325o.mpMortResCommAbsa;
                            client.mp_sub_tot_dir_comm = sjp325o.mpSubTotDirComm;
                            client.mp_ord_cred_comm_ext = sjp325o.mpOrdCredCommExt;
                            client.mp_asset_fin_comm_ext = sjp325o.mpAssetFinCommExt;
                            client.mp_medium_term_com_ext = sjp325o.mpMediumTermComExt;
                            client.mp_mort_loan_comm_ext = sjp325o.mpMortLoanCommExt;
                            client.mp_sub_tot_dir_com_ext = sjp325o.mpSubTotDirComExt;
                            client.mp_total_exposure = sjp325o.mpTotalExposure;
                            client.mp_total_commitments = sjp325o.mpTotalCommitments;
                            client.mp_tot_asset_ml_fin = sjp325o.mpTotAssetMlFin;
                            client.mp_approved_facilities = sjp325o.mpApprovedFacilities;
                            client.mp_approved_facility_d = sjp325o.mpApprovedFacilityD;
                            client.mp_prorata_joint_exp = sjp325o.mpProrataJointExp;
                            client.mp_prorata_joint_exp_d = sjp325o.mpProrataJointExpD;
                            client.sp_dir_ord_cred_exp = sjp325o.spDirOrdCredExp;
                            client.sp_mort_cpf_exp = sjp325o.spMortCpfExp;
                            client.sp_mort_agric_exp = sjp325o.spMortAgricExp;
                            client.sp_tot_ord_cred_exp = sjp325o.spTotOrdCredExp;
                            client.sp_dir_asset_fin_exp = sjp325o.spDirAssetFinExp;
                            client.sp_medium_term_exp = sjp325o.spMediumTermExp;
                            client.sp_mort_res_exp = sjp325o.spMortResExp;
                            client.sp_sub_tot_dir_exp = sjp325o.spSubTotDirExp;
                            client.sp_cont_liab_ord_cred = sjp325o.spContLiabOrdCred;
                            client.sp_ord_cred_comm_absa = sjp325o.spOrdCredCommAbsa;
                            client.sp_mort_cpf_comm_absa = sjp325o.spMortCpfCommAbsa;
                            client.sp_mort_agric_com_absa = sjp325o.spMortAgricComAbsa;
                            client.sp_tot_ord_cred_com = sjp325o.spTotOrdCredCom;
                            client.sp_asset_fin_comm_absa = sjp325o.spAssetFinCommAbsa;
                            client.sp_medium_term_com = sjp325o.spMediumTermCom;
                            client.sp_mort_res_comm_absa = sjp325o.spMortResCommAbsa;
                            client.sp_sub_tot_dir_comm = sjp325o.spSubTotDirComm;
                            client.sp_ord_cred_comm_ext = sjp325o.spOrdCredCommExt;
                            client.sp_asset_fin_comm_ext = sjp325o.spAssetFinCommExt;
                            client.sp_medium_term_com_ext = sjp325o.spMediumTermComExt;
                            client.sp_mort_loan_comm_ext = sjp325o.spMortLoanCommExt;
                            client.sp_sub_tot_dir_com_ext = sjp325o.spSubTotDirComExt;
                            client.sp_total_exposure = sjp325o.spTotalExposure;
                            client.sp_total_commitments = sjp325o.spTotalCommitments;
                            client.hh_dir_ord_cred_exp = sjp325o.hhDirOrdCredExp;
                            client.hh_mort_cpf_exp = sjp325o.hhMortCpfExp;
                            client.hh_mort_agric_exp = sjp325o.hhMortAgricExp;
                            client.hh_tot_ord_cred_exp = sjp325o.hhTotOrdCredExp;
                            client.hh_dir_asset_fin_exp = sjp325o.hhDirAssetFinExp;
                            client.hh_medium_term_exp = sjp325o.hhMediumTermExp;
                            client.hh_mort_res_exp = sjp325o.hhMortResExp;
                            client.hh_sub_tot_dir_exp = sjp325o.hhSubTotDirExp;
                            client.hh_cont_liab_ord_cred = sjp325o.hhContLiabOrdCred;
                            client.hh_ord_cred_comm_absa = sjp325o.hhOrdCredCommAbsa;
                            client.hh_mort_cpf_comm_absa = sjp325o.hhMortCpfCommAbsa;
                            client.hh_mort_agric_com_absa = sjp325o.hhMortAgricComAbsa;
                            client.hh_tot_ord_cred_com = sjp325o.hhTotOrdCredCom;
                            client.hh_asset_fin_comm_absa = sjp325o.hhAssetFinCommAbsa;
                            client.hh_medium_term_com = sjp325o.hhMediumTermCom;
                            client.hh_mort_res_comm_absa = sjp325o.hhMortResCommAbsa;
                            client.hh_sub_tot_dir_comm = sjp325o.hhSubTotDirComm;
                            client.hh_ord_cred_comm_ext = sjp325o.hhOrdCredCommExt;
                            client.hh_asset_fin_comm_ext = sjp325o.hhAssetFinCommExt;
                            client.hh_medium_term_com_ext = sjp325o.hhMediumTermComExt;
                            client.hh_mort_loan_comm_ext = sjp325o.hhMortLoanCommExt;
                            client.hh_sub_tot_dir_com_ext = sjp325o.hhSubTotDirComExt;
                            client.hh_total_exposure = sjp325o.hhTotalExposure;
                            client.hh_total_commitments = sjp325o.hhTotalCommitments;
                            client.no_assur_policy = sjp325o.noAssurPolicy;
                            client.ccyy_oldest_ass_pol = sjp325o.ccyyOldestAssPol;
                            client.aff_housing_prompt = sjp325o.affHousingPrompt;
                            client.aff_housing_prompt_d = sjp325o.affHousingPromptD;
                            client.aff_housing = sjp325o.affHousing;
                            client.aff_housing_d = sjp325o.affHousingD;
                            client.susp_appl = sjp325o.suspAppl;
                            client.susp_appl_desc = sjp325o.suspApplDesc;
                            client.mp_cc_excess = sjp325o.mpCcExcess;
                            client.mp_cheq_excess = sjp325o.mpCheqExcess;
                            client.mp_other_ord_excess = sjp325o.mpOtherOrdExcess;
                            client.mp_excess_total = sjp325o.mpExcessTotal;
                            client.mp_cc_limit = sjp325o.mpCcLimit;
                            client.mp_cheq_limit = sjp325o.mpCheqLimit;
                            client.mp_other_ord_limit = sjp325o.mpOtherOrdLimit;
                            client.mp_limit_total = sjp325o.mpLimitTotal;
                            client.mp_pl_term_arrears = sjp325o.mpPlTermArrears;
                            client.mp_cc_arrears = sjp325o.mpCcArrears;
                            client.mp_other_ord_arrears = sjp325o.mpOtherOrdArrears;
                            client.mp_asset_fin_arrears = sjp325o.mpAssetFinArrears;
                            client.mp_ml_arrears = sjp325o.mpMlArrears;
                            client.mp_recovery_arrears = sjp325o.mpRecoveryArrears;
                            client.mp_arrears_total = sjp325o.mpArrearsTotal;
                            client.mp_cms_pl_term_instal = sjp325o.mpCmsPlTermInstal;
                            client.mp_cms_cc_instal = sjp325o.mpCmsCcInstal;
                            client.mp_cms_cheq_instal = sjp325o.mpCmsCheqInstal;
                            client.mp_cms_other_instal = sjp325o.mpCmsOtherInstal;
                            client.mp_cms_isa_instal = sjp325o.mpCmsIsaInstal;
                            client.mp_cms_ml_instal = sjp325o.mpCmsMlInstal;
                            client.mp_recovery_instal = sjp325o.mpRecoveryInstal;
                            client.mp_instal_total = sjp325o.mpInstalTotal;
                            client.sp_cc_excess = sjp325o.spCcExcess;
                            client.sp_cc_excess_d = sjp325o.spCcExcessD;
                            client.sp_cheq_excess = sjp325o.spCheqExcess;
                            client.sp_cheq_excess_d = sjp325o.spCheqExcessD;
                            client.sp_other_ord_excess = sjp325o.spOtherOrdExcess;
                            client.sp_other_ord_excess_d = sjp325o.spOtherOrdExcessD;
                            client.sp_excess_total = sjp325o.spExcessTotal;
                            client.sp_excess_total_d = sjp325o.spExcessTotalD;
                            client.sp_cc_limit = sjp325o.spCcLimit;
                            client.sp_cc_limit_d = sjp325o.spCcLimitD;
                            client.sp_cheq_limit = sjp325o.spCheqLimit;
                            client.sp_cheq_limit_d = sjp325o.spCheqLimitD;
                            client.sp_other_ord_limit = sjp325o.spOtherOrdLimit;
                            client.sp_other_ord_limit_d = sjp325o.spOtherOrdLimitD;
                            client.sp_limit_total = sjp325o.spLimitTotal;
                            client.sp_limit_total_d = sjp325o.spLimitTotalD;
                            client.sp_pl_term_arrears = sjp325o.spPlTermArrears;
                            client.sp_pl_term_arrears_d = sjp325o.spPlTermArrearsD;
                            client.sp_cc_arrears = sjp325o.spCcArrears;
                            client.sp_cc_arrears_d = sjp325o.spCcArrearsD;
                            client.sp_other_ord_arrears = sjp325o.spOtherOrdArrears;
                            client.sp_other_ord_arrears_d = sjp325o.spOtherOrdArrearsD;
                            client.sp_asset_fin_arrears = sjp325o.spAssetFinArrears;
                            client.sp_asset_fin_arrears_d = sjp325o.spAssetFinArrearsD;
                            client.sp_ml_arrears = sjp325o.spMlArrears;
                            client.sp_ml_arrears_d = sjp325o.spMlArrearsD;
                            client.sp_recovery_arrears = sjp325o.spRecoveryArrears;
                            client.sp_recovery_arrears_d = sjp325o.spRecoveryArrearsD;
                            client.sp_arrears_total = sjp325o.spArrearsTotal;
                            client.sp_arrears_total_d = sjp325o.spArrearsTotalD;
                            client.sp_cms_pl_term_instal = sjp325o.spCmsPlTermInstal;
                            client.sp_cms_pl_term_inst_d = sjp325o.spCmsPlTermInstD;
                            client.sp_cms_cc_instal = sjp325o.spCmsCcInstal;
                            client.sp_cms_cc_instal_d = sjp325o.spCmsCcInstalD;
                            client.sp_cms_cheq_instal = sjp325o.spCmsCheqInstal;
                            client.sp_cms_cheq_instal_d = sjp325o.spCmsCheqInstalD;
                            client.sp_cms_other_instal = sjp325o.spCmsOtherInstal;
                            client.sp_cms_other_instal_d = sjp325o.spCmsOtherInstalD;
                            client.sp_cms_isa_instal = sjp325o.spCmsIsaInstal;
                            client.sp_cms_isa_instal_d = sjp325o.spCmsIsaInstalD;
                            client.sp_cms_ml_instal = sjp325o.spCmsMlInstal;
                            client.sp_cms_ml_instal_d = sjp325o.spCmsMlInstalD;
                            client.sp_recovery_instal = sjp325o.spRecoveryInstal;
                            client.sp_recovery_instal_d = sjp325o.spRecoveryInstalD;
                            client.sp_instal_total = sjp325o.spInstalTotal;
                            client.sp_instal_total_d = sjp325o.spInstalTotalD;
                            client.mp_surety_absa_client = sjp325o.mpSuretyAbsaClient;
                            client.mp_surety_absa_cl_desc = sjp325o.mpSuretyAbsaClDesc;
                            client.mp_dte_last_loan_paid = sjp325o.mpDteLastLoanPaid;
                            client.mp_collec_risk_type = sjp325o.mpCollecRiskType;
                            client.mp_collec_risk_desc = sjp325o.mpCollecRiskDesc;
                            client.mp_arms_holds = sjp325o.mpArmsHolds;
                            client.mp_arms_holds_desc = sjp325o.mpArmsHoldsDesc;
                            client.sp_approved_facilities = sjp325o.spApprovedFacilities;
                            client.sp_approved_facility_d = sjp325o.spApprovedFacilityD;
                            client.sp_prorata_joint_exp = sjp325o.spProrataJointExp;
                            client.sp_prorata_joint_exp_d = sjp325o.spProrataJointExpD;
                            client.sp_surety_absa_client = sjp325o.spSuretyAbsaClient;
                            client.sp_surety_abs_client_d = sjp325o.spSuretyAbsClientD;
                            client.sp_collec_risk_type = sjp325o.v;
                            client.sp_collec_risk_type_d = sjp325o.spCollecRiskTypeD;
                            client.sp_arms_holds = sjp325o.spArmsHolds;
                            client.sp_arms_holds_d = sjp325o.spArmsHoldsD;
                            client.sp_collec_arms_d = sjp325o.spCollecArmsD;
                            client.find_operator = sjp325o.findOperator;
                            component.set("v.client", client);
                            this.saveFinancialDetailHelper(component, event);
                        }
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Get client financial details exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Get client financial details warning', res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Get client financial details error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    //Scoring service 17 author: Joshua 1
    saveFinancialDetailHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Save finacial detail...');
                
        console.log('scoring service 17');
        var client = component.get("v.client");
        
        var clientData = '{"SJMsaveFinancialDetailsV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjp322i":{"applicationNo":"' + client.application_number + '","mpCheqAccInst":"' + client.mp_cheq_acc_inst + '","mpExtCheqInst":"' + client.mp_ext_cheq_inst + '","mpCcInst":"' + client.mp_cc_inst + '","mpPersLoanInst":"' + client.mp_pers_loan_inst + '","mpBondInst":"' + client.mp_bond_inst + '","mpSavAccInst":"' + client.mp_sav_acc_inst + '","mpInvestAccInst":"' + client.mp_invest_acc_inst + '","spCheqAccInst":"' + client.sp_cheq_acc_inst + '","spExtCheqInst":"' + client.sp_ext_cheq_inst + '","spCcInst":"' + client.sp_cc_inst + '","spPersLoanInst":"' + client.sp_pers_loan_inst + '","spBondInst":"' + client.sp_bond_inst + '","spSavAccInst":"' + client.sp_sav_acc_inst + '","spInvestAccInst":"' + client.sp_invest_acc_inst + '","applNettWorth":"' + client.appl_nett_worth + '","meApplNettWorth":"' + client.me_appl_nett_worth + '","nettWorthSiteCode":"' + client.nett_worth_site_code + '","nettWorthDateCap":"' + client.nett_worth_date_cap + '","mpOrdCredCommExt":"' + client.mp_ord_cred_comm_ext + '","mpAssetFinCommExt":"' + client.mp_asset_fin_comm_ext + '","mpMortLoanCommExt":"' + client.mp_mort_loan_comm_ext + '","spOrdCredCommExt":"' + client.sp_ord_cred_comm_ext + '","spAssetFinCommExt":"' + client.sp_asset_fin_comm_ext + '","spMortLoanCommExt":"' + client.sp_mort_loan_comm_ext + '","noAssurPolicy":"' + client.no_assur_policy + '","ccyyOldestAssPol":"' + client.ccyy_oldest_ass_pol + '","affHousing":"' + client.aff_housing + '","suspAppl":"' + client.susp_appl + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.saveFinancialDetails");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMsaveFinancialDetailsV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            let error_obj = obj.SJMsaveFinancialDetailsV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Save financial details message', error_obj, 'scoring_obj'); 
                            return;
                        }                        
                        
                        let nextFunct = obj.SJMsaveFinancialDetailsV1Response.sjp322o.nextFunc;
                        
                        component.set("v.client", client);
                        
                        if (nextFunct == 'CLIF'){                           
                            this.submitCreditLifePolicyInfoV1Helper(component, event);
                        }
                        else if (nextFunct == 'CMSM'){                        
                            this.sjmgetCMSSMSInfoHelper(component, event);
                        }   
                            else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                this.submitCMSContinuationProcessHelper(component, event);
                            }   
                                else if (nextFunct == 'CMST'){                           
                                    this.sjmSaveTriadAgreementHelper(component, event);
                                }else if (nextFunct == 'BLZE'){                           
                                    this.sjmProcessBlazeAdvisorContinuationFHelper(component, event);
                                }else { 
                                    this.errorMessagesHelper(component, event, 'Technical Exception', 'Technical exception has occured in savefinadetail', 'scoring_obj');   
                                    return;
                                }
                        
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Save financial detail info exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Save financial detail info warning', res.Message, 'scoring_obj');   
                }
            } else {
                this.errorMessagesHelper(component, event, 'Save financial detail info error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    
    //Scoring service 18 author: Joshua 2
    sjmProcessBlazeAdvisorContinuationFHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Process blaze advisor Cont...');
        
        console.log('scoring service 18');
        var client = component.get("v.client");
        
        var clientData = '{ "SJMprocessBlazeAdvisorV2": { "nbsapdpi": { "channel": "'+client.channel+'", "application": "'+client.application+'", "trace": "'+client.trace+'" }, "nbsmsgi": { "msgLanguage": "'+client.language+'", "msgTarget": "'+client.target+'", "finalMsgId": { "finalMsgClass": "'+client.final_msg_class+'", "finalMsgCode": "'+client.final_msg_code+'" } }, "sjp317i": { "applicationNo": "'+client.application_number+'", "continuation": "'+client.blaze_continuation_first+'", "prevFunc": "'+client.prev_func+'", "origin": "'+client.origin+'", "corpCode": "'+client.corp_code+'", "branchCode": "'+client.branch_code+'", "branchSiteType": "'+client.branch_site_type+'", "agencyCode": "'+client.agency_code+'", "agencySiteType": "'+client.agency_site_type+'", "tellerCode": "'+client.teller_code+'", "supervisorCode": "'+client.supervisor_code+'"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.processBlazeAdvisor");
        
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res Wirh Continuation F:  '+res.Data.dataMap.getBody);
                        
                        this.sjmProcessBlazeAdvisorContinuationSHelper(component, event);
                        
                        
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Process blaze advisor info exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Process blaze advisor info warning', res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Process blaze advisor info error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    }, 
    //Scoring service 18 author: Joshua 2
    sjmProcessBlazeAdvisorContinuationSHelper: function(component, event) {
        console.log('scoring service 18');
        var client = component.get("v.client");
        
        var clientData = '{ "SJMprocessBlazeAdvisorV2": { "nbsapdpi": { "channel": "'+client.channel+'", "application": "'+client.application+'", "trace": "'+client.trace+'" }, "nbsmsgi": { "msgLanguage": "'+client.language+'", "msgTarget": "'+client.target+'", "finalMsgId": { "finalMsgClass": "'+client.final_msg_class+'", "finalMsgCode": "'+client.final_msg_code+'" } }, "sjp317i": { "applicationNo": "'+client.application_number+'", "continuation": "'+client.blaze_continuation_second+'", "prevFunc": "'+client.prev_func+'", "origin": "'+client.origin+'", "corpCode": "'+client.corp_code+'", "branchCode": "'+client.branch_code+'", "branchSiteType": "'+client.branch_site_type+'", "agencyCode": "'+client.agency_code+'", "agencySiteType": "'+client.agency_site_type+'", "tellerCode": "'+client.teller_code+'", "supervisorCode": "'+client.supervisor_code+'"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.processBlazeAdvisor");
        
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res Wirh Continuation S:  '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMprocessBlazeAdvisorV2Response.nbsmsgo.nbrUserMsgs > 0) {
                            let error_obj =  obj.SJMprocessBlazeAdvisorV2Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Process blaze advisor message', error_obj, 'scoring_obj');  
                            return;
                        } 
                        
                        if(client.prev_func == "CB03"){
                            
                            let blazeStatus = obj.SJMprocessBlazeAdvisorV2Response.sjp317o.blazeStatus;
                            
                            if(blazeStatus == "Y"){
                                this.sjmProcessBlazeAdvisorContinuationSHelper(component, event);
                            }else if(blazeStatus == "O"){
                                
                                            var nextFunct = obj.SJMprocessBlazeAdvisorV2Response.sjp317o.nextFunc;
                                           
                                            component.set("v.client", client);
                                            
                                            if (nextFunct == 'CLIF'){                           
                                                this.submitCreditLifePolicyInfoV1Helper(component, event);
                                            }
                                            else if (nextFunct == 'CMSM'){                        
                                                this.sjmgetCMSSMSInfoHelper(component, event);
                                            }   
                                                else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                                    this.submitCMSContinuationProcessHelper(component, event);
                                                }   
                                                    else if (nextFunct == 'CMST'){                        
                                                        this.sjmSaveTriadAgreementHelper(component, event);
                                                    }else if (nextFunct == 'BLZE'){                           
                                                        this.sjmProcessBlazeAdvisorHelper(component, event);
                                                    }else if (nextFunct == 'CB01'){                           
                                                        this.getCreditBureauDetailsHelper(component, event);
                                                    }else if (nextFunct == 'CSPG'){                           
                                                        this.getPlScoringResultV1Helper(component, event);
                                                    }else{ 
                                                        this.errorMessagesHelper(component, event, 'Technical Exception', 'Technical exception has occured in processblazeadvisor', 'scoring_obj');   
                                                        return;
                                                    }
                                
                            }else if(blazeStatus == "E"){
                               this.stopSpinner(component, event);
                               this.messageModal(component, true, 'Process blaze advisor message', obj.SJMprocessBlazeAdvisorV2Response.nbsmsgo.msgEntry[0].msgTxt);                               
                               return;
                            }else{
                                alert("Some Went Wrong");
                            }
                       }
                        
                        if(client.prev_func != "CB03"){
                        
                                var nextFunct = obj.SJMprocessBlazeAdvisorV2Response.sjp317o.nextFunc;
                               
                                component.set("v.client", client);
                                
                                if (nextFunct == 'CLIF'){                           
                                    this.submitCreditLifePolicyInfoV1Helper(component, event);
                                }
                                else if (nextFunct == 'CMSM'){                        
                                    this.sjmgetCMSSMSInfoHelper(component, event);
                                }   
                                    else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                        this.submitCMSContinuationProcessHelper(component, event);
                                    }   
                                        else if (nextFunct == 'CMST'){                        
                                            this.sjmSaveTriadAgreementHelper(component, event);
                                        }else if (nextFunct == 'BLZE'){                           
                                            this.sjmProcessBlazeAdvisorHelper(component, event);
                                        }else if (nextFunct == 'CB01'){                           
                                            this.getCreditBureauDetailsHelper(component, event);
                                        }else if (nextFunct == 'CSPG'){                           
                                              this.getPlScoringResultV1Helper(component, event);
                                       }else{ 
                                            this.errorMessagesHelper(component, event, 'Technical Exception', 'Technical exception has occured in processblazeadvisor', 'scoring_obj');   
                                            return;
                                        }
                            
                        }
                        
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Process blaze advisor info exception', obj, 'scoring_obj');  
                    }
                } else {
                     this.errorMessagesHelper(component, event, 'Process blaze advisor info warning', res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
               this.errorMessagesHelper(component, event, 'Process blaze advisor info error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    
    //Scoring service 19 author: Joshua 3 
    getCreditBureauDetailsHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Get credit bureau...');
        
        console.log('scoring service 19');
        var client = component.get("v.client");
                
        var clientData = '{"NBSAPDPI":{"inputHeader":{"channelName":"' + client.channel + '","applicationName":"' + client.application + '","traceIndicator":"' + client.trace + '"}},"NBSMSGI":{"inputErrorMessage":{"errorMessageLanguage":"' + client.language + '","errorMessageTarget":"' + client.target + '"}},"SJB328I":{"inputCopybook":{"applicationNumber":"' + client.application_number + '","participantNumber":"'+client.participant_number+'","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.getCreditBureauDetails");
        
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.NBSMSGO3.outputErrorMessage.numberUserErrors > 0) {
                            let error_obj = obj.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText;
                            this.errorMessagesHelper(component, event, 'Get credit bureau details', error_obj, 'scoring_obj');   
                            return;                  
                        }   
                        
                        let nextFunct = obj.SJB328O.outputCopybook.nextFunction;
                        
                        if (nextFunct == 'CLIF'){                           
                            this.submitCreditLifePolicyInfoV1Helper(component, event);
                        }
                        else if (nextFunct == 'CMSM'){                        
                            this.sjmgetCMSSMSInfoHelper(component, event);
                        }   
                            else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                this.submitCMSContinuationProcessHelper(component, event);
                            }   
                                else if (nextFunct == 'CMST'){                        
                                    this.sjmSaveTriadAgreementHelper(component, event);
                                }else if (nextFunct == 'BLZE'){                           
                                    this.sjmProcessBlazeAdvisorHelper(component, event);
                                }else if(nextFunct == 'CB02'){
                                    this.SJMrelinkCreditBureauDetailsHelper(component, event);
                                }else if (nextFunct == 'CB03'){                           
                                    this.saveCreditBureaDetailsHelper(component, event);
                                }else if (nextFunct == 'CSPG'){                           
                                    this.getPlScoringResultV1Helper(component, event);
                                }else { 
                                    let obj_error = obj.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText;
                                    if(obj_error){
                                         this.errorMessagesHelper(component, event, 'Technical Exception',obj_error, 'scoring_obj');   
                                    }else{
                                         this.errorMessagesHelper(component, event, 'Technical Exception','Technical exception has occured in get credit bureau', 'scoring_obj');   
                                    }
                                    return;
                                }
                        
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Submit client detail info exception',  obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Submit Client detail info warning',  res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Submit client detail error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    }, 
    //Scoring service 20 author: Joshuav4
    saveCreditBureaDetailsHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Save credit bureau...');
        
        console.log('scoring service 20');
        var client = component.get("v.client");
                
        var clientData = '{"NBSAPDPI":{"inputHeaders":{"channelName":"' + client.channel + '","applicationName":"' + client.application + '","traceIndicator":"' + client.trace + '"}},"NBSMSGI":{"inputErrorMessage":{"errorMessageLanguage":"' + client.language + '","errorMessageTarget":"' + client.target + '"}},"SJB323I":{"inputCopybook":{"applicationNumber":"' + client.application_number + '","participantNumber":"'+client.participant_number+'","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.saveCreditBureaDetails");
        
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);                        
                        
                        if (obj.NBSMSGO3.outputErrorMessage.numberUserErrors > 0) {
                            let error_obj = obj.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText;
                            this.errorMessagesHelper(component, event, 'Save credit bureau details message', error_obj, 'scoring_obj');   
                            return;
                        }else if(obj.SJB323O.outputCopybook.nextFunction == null){
                                this.errorMessagesHelper(component, event, 'Save credit bureau details message', 'Technical Exception has occured in save credit bureau', 'scoring_obj');                            
                                return;
                        }    
                        
                        client.dispute_date = obj.SJB323O.outputCopybook.disputeDate;
                        client.mostRecent_notice_description = obj.SJB323O.outputCopybook.mostRecentNoticeDescription;
                        client.total_amount_bank_write_offs = obj.SJB323O.outputCopybook.totalAmountBankWriteOffs;
                        client.credit_bureau_date_last_write_off = obj.SJB323O.outputCopybook.creditBureauDateLastWriteOff;
                        client.date_most_recent_absa_record = obj.SJB323O.outputCopybook.dateMostRecentAbsaRecord;
                        client.participant = obj.SJB323O.outputCopybook.participant;
                        client.participant_d = obj.SJB323O.outputCopybook.participantD;
                        client.total_other_banks_registered_records = obj.SJB323O.outputCopybook.totalOtherBanksRegisteredRecords;
                        client.credit_bureau_trace_alert = obj.SJB323O.outputCopybook.creditBureauTraceAlert;
                        client.credit_bureau_writeOff_amount = obj.SJB323O.outputCopybook.creditBureauWriteOffAmount;
                        client.dispute_indicator = obj.SJB323O.outputCopybook.disputeIndicator;
                        client.worst_notice_date = obj.SJB323O.outputCopybook.worstNoticeDate;
                        client.number_non_absa_enq_lst12 = obj.SJB323O.outputCopybook.numberNonAbsaEnqLst12;
                        client.worst_notice_type = obj.SJB323O.outputCopybook.worstNoticeType;
                        client.fraud_fields_required = obj.SJB323O.outputCopybook.fraudFieldsRequired;
                        client.date_most_recent_other_record = obj.SJB323O.outputCopybook.dateMostRecentOtherRecord;
                        client.number_non_absa_enq_lst6 = obj.SJB323O.outputCopybook.numberNonAbsaEnqLst6;
                        client.credit_bureau_ever_insolvent = obj.SJB323O.outputCopybook.creditBureauEverInsolvent;
                        client.number_non_absa_enq_lst3 = obj.SJB323O.outputCopybook.numberNonAbsaEnqLst3;
                        client.most_recent_type_notice = obj.SJB323O.outputCopybook.mostRecentTypeNotice;
                        client.debt_counselling_code = obj.SJB323O.outputCopybook.debtCounsellingCode;
                        client.last_operator_id = obj.SJB323O.outputCopybook.lastOperatorId;
                        client.date_most_recent_bank_write_off = obj.SJB323O.outputCopybook.dateMostRecentBankWriteOff;
                        client.most_recent_absa_record_description = obj.SJB323O.outputCopybook.mostRecentAbsaRecordDescription;
                        client.number_bank_write_offs = obj.SJB323O.outputCopybook.numberBankWriteOffs;
                        client.credit_bureau_number_of_judgements = obj.SJB323O.outputCopybook.creditBureauNumberOfJudgements;
                        //client.credit_bureau_value_judgments = obj.SJB323O.outputCopybook.creditBureauValueJudgments;
                        client.id_fraud_flag5 = obj.SJB323O.outputCopybook.idFraudFlag5;
                        client.worst_notice_description = obj.SJB323O.outputCopybook.worstNoticeDescription;
                        client.relink_p = obj.SJB323O.outputCopybook.relinkP;
                        client.id_fraud_flag2 = obj.SJB323O.outputCopybook.idFraudFlag2;
                        //client.number_adv_recs_reg = obj.SJB323O.outputCopybook.numberAdvRecsReg;
                        client.id_fraud_flag1 = obj.SJB323O.outputCopybook.idFraudFlag1;
                        client.sa_fraud_prevent = obj.SJB323O.outputCopybook.saFraudPrevent;
                        client.id_fraud_flag4 = obj.SJB323O.outputCopybook.idFraudFlag4;
                        //client.next_function = obj.SJB323O.outputCopybook.nextFunction;
                        client.id_fraud_flag3 = obj.SJB323O.outputCopybook.idFraudFlag3;
                        client.client_name = obj.SJB323O.outputCopybook.clientName;
                        client.total_absa_bank_registered_records = obj.SJB323O.outputCopybook.totalAbsaBankRegisteredRecords;
                        client.status_most_recent_absaRecord = obj.SJB323O.outputCopybook.statusMostRecentAbsaRecord;
                        client.credit_bureau_number_of_write_offs = obj.SJB323O.outputCopybook.creditBureauNumberOfWriteOffs;
                        client.override_required = obj.SJB323O.outputCopybook.overrideRequired;
                        client.debt_counselling_description = obj.SJB323O.outputCopybook.debtCounsellingDescription;
                        client.number_absa_enq_ever = obj.SJB323O.outputCopybook.numberAbsaEnqEver;
                        client.credit_bureau_identifier = obj.SJB323O.outputCopybook.creditBureauIdentifier;
                        client.total_adv_recs_reg = obj.SJB323O.outputCopybook.totalAdvRecsReg;
                        client.credit_bureau_date_high_judgement = obj.SJB323O.outputCopybook.creditBureauDateHighJudgement;
                        client.status_most_recent_otherRecord = obj.SJB323O.outputCopybook.statusMostRecentOtherRecord;
                        client.most_recent_other_record_description = obj.SJB323O.outputCopybook.mostRecentOtherRecordDescription;
                        client.credit_bureau_high_judgement_amount = obj.SJB323O.outputCopybook.creditBureauHighJudgementAmount;
                        client.relink = obj.SJB323O.outputCopybook.relink;
                        client.date_most_recent_advRecord = obj.SJB323O.outputCopybook.dateMostRecentAdvRecord;
                        client.id_verify_flag = obj.SJB323O.outputCopybook.idVerifyFlag;
                        client.number_absa_enq_lst3 = obj.SJB323O.outputCopybook.numberAbsaEnqLst3;
                        client.number_non_absa_enq_ever = obj.SJB323O.outputCopybook.numberNonAbsaEnqEver;
                        client.number_absa_enq_lst12 = obj.SJB323O.outputCopybook.numberAbsaEnqLst12;
                        client.credit_bureau_date_rehab = obj.SJB323O.outputCopybook.creditBureauDateRehab;
                        client.date_most_recent_notice = obj.SJB323O.outputCopybook.dateMostRecentNotice;
                        client.client_code = obj.SJB323O.outputCopybook.clientCode;
                        client.credit_bureau_dateLast_judgement = obj.SJB323O.outputCopybook.creditBureauDateLastJudgement;
                        client.on_record_at_credit_bureau = obj.SJB323O.outputCopybook.onRecordAtCreditBureau;
                        client.number_absa_enq_lst6 = obj.SJB323O.outputCopybook.numberAbsaEnqLst6;
                        
                        component.set("v.client", client);
                        
                        
                        let nextFunct = obj.SJB323O.outputCopybook.nextFunction;
                        
                        if (nextFunct == 'CLIF'){                           
                            this.submitCreditLifePolicyInfoV1Helper(component, event);
                        }
                        else if (nextFunct == 'CMSM'){                        
                            this.sjmgetCMSSMSInfoHelper(component, event);
                        }else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                this.submitCMSContinuationProcessHelper(component, event);
                            }else if (nextFunct == 'CMST'){                        
                                    this.sjmSaveTriadAgreementHelper(component, event);
                                }else if (nextFunct == 'BLZE'){                           
                                    this.sjmProcessBlazeAdvisorContinuationFHelper(component, event);
                                }else if(nextFunct == 'CB02'){
                                    this.SJMrelinkCreditBureauDetailsHelper(component, event);
                                }else if (nextFunct == 'CB03'){
                                    component.set("v.client.prev_func","CB03");
                                    this.saveCreditBureaDetailsHelper(component, event);
                                }else if (nextFunct == 'CSPG'){                           
                                    this.getPlScoringResultV1Helper(component, event);
                                }else { 
                                    let obj_error = obj.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText;
                                    if(obj_error){
                                         this.errorMessagesHelper(component, event, 'Technical Exception',obj_error, 'scoring_obj');   
                                    }else{
                                         this.errorMessagesHelper(component, event, 'Technical Exception','Technical exception has occured in save credit bureau', 'scoring_obj');   
                                    }
                                    return;
                                }
                                                
                    } else {
                        let obj= res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Save credit bureau details exception', obj, 'scoring_obj');                
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Save credit bureau details warning', res.Message, 'scoring_obj'); 
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Save credit bureau details error', errors[0].message, 'scoring_obj');   
            }
            
        });
        $A.enqueueAction(action);
    },
    //Scoring service 18 author: Joshua 2
    SJMrelinkCreditBureauDetailsHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Relink Credit Bureau...');
                
        console.log('scoring service 18');
        var client = component.get("v.client");
        
        var clientData = '{"NBSAPDPI":{"NBSAPLI":{"consumerChannel":"'+client.channel+'","providerAppliaction":"'+client.application+'","traceIndictaor":"'+client.trace+'"}},"MSGI":{"NBSMSGI":{"messageLanguage":"'+client.language+'","messageTarget":"'+client.target+'"}},"SJMrelinkCreditBureauDetailsV1":{"SJMrelinkCreditBureauDetailsV1Input":{"applicationNo":"'+client.application_number+'","relink":"'+client.relink+'","corpCode":"'+client.corp_code+'","branchCode":"'+client.branch_code+'","branchSiteType":"'+client.branch_site_type+'","agencyCode":"'+client.agency_code+'","angencySiteType":"'+client.agency_site_type+'","tellerCode":"'+client.teller_code+'","supervisorCode":"'+client.supervisor_code+'"}}}';

        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.relinkCreditBureauDetails");
        
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res Wirh Re link Credit Burea:  '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.MSGO.NBSMSGO3.nbrUserErrors > 0) {
                            let error_obj =  obj.MSGO.NBSMSGO3.messageEntryTable[0].messageText;
                            this.errorMessagesHelper(component, event, 'Relink Credit Bureau message', error_obj, 'scoring_obj');
                            return;
                        }else if(obj.MSGO.NBSMSGO3.nbrUserMessages > 0){
                            let error_obj_message =  obj.MSGO.NBSMSGO3.messageEntryTable[0].messageText;
                            
                            if(error_obj_message =="Override need to do a Re-link transaction"){
                                this.errorMessagesHelper(component, event, 'Relink Credit Bureau message', error_obj_message, 'scoring_obj');
                                return;
                            }
                            
                        }  
                        
                        
                        var nextFunct = obj.SJMrelinkCreditBureauDetailsV1.SJMrelinkCreditBureauDetailsV1Output.nextFunction;
                        
                        component.set("v.client", client);
                        
                        if (nextFunct == 'CLIF'){                           
                            this.submitCreditLifePolicyInfoV1Helper(component, event);
                        }
                        else if (nextFunct == 'CMSM'){                        
                            this.sjmgetCMSSMSInfoHelper(component, event);
                        }   
                            else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                this.submitCMSContinuationProcessHelper(component, event);
                            }   
                                else if (nextFunct == 'CMST'){                        
                                    this.sjmSaveTriadAgreementHelper(component, event);
                                }else if (nextFunct == 'BLZE'){                           
                                    this.sjmProcessBlazeAdvisorContinuationFHelper(component, event);
                                }else if(nextFunct == 'CB02'){
                                    this.SJMrelinkCreditBureauDetailsHelper(component, event);
                                }else if (nextFunct == 'CB03'){                           
                                    this.saveCreditBureaDetailsHelper(component, event);
                                    //this.getPlScoringResultV1Helper(component, event);
                                }else if (nextFunct == 'CSPG'){                           
                                    this.getPlScoringResultV1Helper(component, event);
                                }else{ 
                                    this.errorMessagesHelper(component, event, 'Relink credit bureau details exception', 'Technical exception has occured in r linking', 'scoring_obj');   
                                    return;
                                }
                        
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Relink credit bureau details exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Relink credit bureau details warning', errors[0].message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Relink credit bureau details error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },

    //Scoring service 21 author: Joshua 5
    getPlScoringResultV1Helper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Get pl scoring...');
        
        console.log('scoring service 21');
        var client = component.get("v.client");
        
        var clientData = '{"SJMgetPLScoringResultV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjp312i":{"corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '","applicationNo":"' + client.application_number + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.getPLScoringResult");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var client = component.get("v.client");
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMgetPLScoringResultV1Response.nbsmsgo.nbrUserMsgs > 0) {
                            let error_obj =  obj.SJMgetPLScoringResultV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Get PL scoring result message', error_obj, 'scoring_obj');
                            return;
                        }                           
                        
                        if (obj) {
                            
                            let sjp312o = obj.SJMgetPLScoringResultV1Response.sjp312o;
                     
                            client.print_scor_decision = sjp312o.printScorDecision;
                            client.control_branch = sjp312o.controlBranch;
                            client.control_branch_info = sjp312o.controlBranchInfo;
                            client.system_decis = sjp312o.systemDecis;
                            client.decis_overr_allowable = sjp312o.decisOverrAllowable;
                            client.system_decis_date = sjp312o.systemDecisDate;
                            client.system_decis_time = sjp312o.systemDecisTime;
                            client.applicant_risk = sjp312o.applicantRisk;
                            client.applicant_risk_desc = sjp312o.applicantRiskDesc;
                            client.loan_amnt_req = sjp312o.loanAmntReq;
                            client.rate_type = sjp312o.rateType;
                            client.base_rate = sjp312o.baseRate;
                            client.rate_adjustment = sjp312o.rateAdjustment;
                            client.interest_rate_recomm = sjp312o.interestRateRecomm;
                            client.documentation_fee = sjp312o.documentationFee;
                            client.initiation_fee = sjp312o.initiationFee;
                            client.pl_offer_amnt = sjp312o.plOfferAmnt;
                            client.int_rate_not_reduced = sjp312o.intRateNotReduced;
                            client.final_loan_amount = sjp312o.finalPlAmnt;
                            client.final_pl_amnt_p = sjp312o.finalPlAmntP;
                            client.approval_empl_no = sjp312o.approvalEmplNo;
                            client.csrd_operator = sjp312o.csrdOperator;
                            //client.system_result = sjp312o.systemResult;
                            client.final_decision = sjp312o.systemResult;
                            client.decline_message1 = sjp312o.declineMessage1;
                            client.decline_message2 = sjp312o.declineMessage2;
                            
                            client.decision_reason = sjp312o.decisionReason;
                            
                            console.log("==============decision_reason=================");
                            console.log(client.decision_reason);
                            console.log("===============================");
                            
                      /*  if (nextFunct == 'CLIF'){                           
                            this.submitCreditLifePolicyInfoV1Helper(component, event);
                        }
                        else if (nextFunct == 'CMSM'){                        
                            this.sjmgetCMSSMSInfoHelper(component, event);
                        }   
                            else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                                this.submitCMSContinuationProcessHelper(component, event);
                            }   
                                else if (nextFunct == 'CMST'){                        
                                    this.sjmSaveTriadAgreementHelper(component, event);
                                }else if (nextFunct == 'BLZE'){                           
                                    this.sjmProcessBlazeAdvisorContinuationFHelper(component, event);
                                }else if(nextFunct == 'CB02'){
                                    this.SJMrelinkCreditBureauDetailsHelper(component, event);
                                }else if (nextFunct == 'CB03'){                           
                                    this.saveCreditBureaDetailsHelper(component, event);
                                    //this.getPlScoringResultV1Helper(component, event);
                                }else if (nextFunct == 'CSPG'){                           
                                    this.getPlScoringResultV1Helper(component, event);
                                }else{ 
                                    this.messageModal(component, true, 'Technical Exception', 'Pl scoring result');
                                    return;
                                } */
                            
                            
                            this.savePLScoringResultHelper(component, event);
                            
                            component.set("v.client", client);
                            
                           
                        }
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Get pl scoring result exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Get pl scoring result warning', res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Get pl scoring result error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    //Scoring service 22 author: Joshua 6
    savePLScoringResultHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Save pl scoring...');
        
        console.log('scoring service 22');
        let client = component.get("v.client");
        
        var clientData = '{"SJMsavePLScoringResultV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjp337i":{"applicationNo":"' + client.application_number + '","finalPlAmnt":"' + client.final_loan_amount + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.savePLScoringResult");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMsavePLScoringResultV1Response.nbsmsgo.nbrUserErrs > 0) {
                            let error_obj = obj.SJMsavePLScoringResultV1Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Save pl scoring result message',error_obj, 'scoring_obj'); 
                            return;
                        }    
                        
                        this.stopSpinner(component, event);
                                                                           
                        component.set("v.client", client);
                        
                       
                    } else {
                        let obj = res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Save pl scoring result exception',obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Save pl scoring result warning',res.Message, 'scoring_obj');   
                }
            } else {
                this.errorMessagesHelper(component, event, 'Save pl scoring result error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    //Scoring service 23 author: Joshua 7
    getQuoteDetailHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Get quote details...');       
        
        console.log('scoring service 23');
        var client = component.get("v.client");
                
        var clientData = '{"NBSAPDPI":{"inputHeader":{"channelName":"' + client.channel + '","applicationName":"' + client.application + '","traceIndicator":"' + client.trace + '"}},"NBSMSGI":{"inputErrorMessage":{"inputErrorMessageLanguage":"' + client.language + '","inputErrorMessageTarget":"' + client.target + '"}},"SJB332I":{"inputCopybookLayout":{"applicationNumber":"' + client.application_number + '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.getQuoteDetail");
        
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.NBSMSGO3.outputErrorMessage.numberUserErrors > 0) {
                            let error_obj =  obj.NBSMSGO3.outputErrorMessage.errorMessageTable[0].errorMessageText;
                            this.errorMessagesHelper(component, event, 'Get quote detail message', error_obj, 'scoring_obj');
                            return;
                        }      
                        
                        client.quote_reference_number = obj.SJB332O.outputCopybook.quoteReferenceNumber;
                        client.get_quote_client_name = obj.SJB332O.outputCopybook.clientName;
                        client.get_quote_account_type = obj.SJB332O.outputCopybook.accountType;
                        //client.get_quote_cif_key = obj.SJB332O.outputCopybook.cifKey;
                        client.get_quote_final_decision = obj.SJB332O.outputCopybook.finalDecision;
                        client.get_quote_quote_required = obj.SJB332O.outputCopybook.quoteRequired;
                        client.get_quote_new_limit = obj.SJB332O.outputCopybook.newLimit;
                        client.get_quote_quote_status = obj.SJB332O.outputCopybook.quoteStatus;
                        
                        component.set("v.client", client);
                        
                        this.submitQuoteDetailHelper(component, event);
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Get quote detail exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Get quote detail warning', res.Message, 'scoring_obj');   
                }
            } else if (errors && errors.length > 0) {
                this.errorMessagesHelper(component, event, 'Get quote detail error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    //Scoring service 24 author: Joshua 8
    submitQuoteDetailHelper: function(component, event) {
        
        this.dispaySpinner(component, event, 'Submit quote details...');
        
        console.log('scoring service 24');
        let client = component.get("v.client");
        
        if(client.first_payment_date){
            if(client.first_payment_date.includes("/")){    
                client.first_payment_date  = this.dateFormating("Validate_And_Update","DD/MM/YYYY",client.first_payment_date);
            }
        }else{
            client.first_payment_date  = (client.first_payment_date) ? this.getFormattedDate(component, client.first_payment_date) : '';
        }
        
        client.get_quote_client_name = client.get_quote_client_name ? client.get_quote_client_name : '0';
      client.student_name  = client.student_name ? client.student_name : '0';
     client.st_id_typ  = client.st_id_typ ? client.st_id_typ : '0';
      client.st_id_passpor  = client.st_id_passpor ? client.st_id_passpor : '0';
     client.institution_code  = client.institution_code ? client.institution_code : '0';
      client.institution_amount  = client.institution_amount ? client.institution_amount : '0';
     client.accommodation  = client.accommodation ? client.accommodation : '0';
      client.accommodation_amount   = client.accommodation_amount ? client.accommodation_amount : '0';
      client.equipment   = client.equipment ? client.equipment : '0';
      client.equipment_amount   = client.equipment_amount ? client.equipment_amount : '0';
     client.course_duration   = client.course_duration ? client.course_duration : '0';
     client.course_year   = client.course_year ? client.course_year : '0';
     client.payment   = client.payment ? client.payment : '0';
        
        var clientData = '{"SJMsubmitQuoteDetailV2":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nbsmsgi":{"msgLanguage":"' + client.language + '","msgTarget":"' + client.target + '","finalMsgId":{"finalMsgClass":"' + client.final_msg_class + '","finalMsgCode":"' + client.final_msg_code + '"}},"sjb373i":{"applicationNo":"' + client.application_number + '","firstPaymentDate":"' + client.first_payment_date + '","issueQuote":"' + client.request_a_quote_to_be_issued+ '","corpCode":"' + client.corp_code + '","branchCode":"' + client.branch_code + '","branchSiteType":"' + client.branch_site_type + '","agencyCode":"' + client.agency_code + '","agencySiteType":"' + client.agency_site_type + '","tellerCode":"' + client.teller_code + '","supervisorCode":"' + client.supervisor_code + '","clientName":"' + client.get_quote_client_name+ '","studentName":"' + client.student_name + '","stIdType":"' + client.st_id_typ + '","stIdPassport":"' + client.st_id_passpor + '","institutionCode":"' + client.institution_code + '","institutionAmount":"' + client.institution_amount + '","accommodation":"' + client.accommodation + '","accommodationAmount":"' + client.accommodation_amount + '","equipment":"' + client.equipment + '","equipmentAmount":"' + client.equipment_amount + '","courseDuration":"' + client.course_duration + '","courseYear":"' + client.course_year + '","payment":"' + client.payment + '"}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.submitQuoteDetail");
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            console.log(res);
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        console.log('Res: '+res.Data.dataMap.getBody);
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (obj.SJMsubmitQuoteDetailV2Response.nbsmsgo.nbrUserErrs > 0) {
                            let error_obj =  obj.SJMsubmitQuoteDetailV2Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.errorMessagesHelper(component, event, 'Submit quote detail message', error_obj, 'scoring_obj');
                            return;
                        }else if(client.request_a_quote_to_be_issued == "N"){
                            this.saveApplicationHelper(component, event);
                        }else if(client.request_a_quote_to_be_issued == "Y"){
                            
                            let quote_reference_no = obj.SJMsubmitQuoteDetailV2Response.sjb373o.quoteReferenceNo;
                            client.request_a_quote_to_be_issued = quote_reference_no;
                            
                            component.set("v.client", client);
                            
                            let msg_txt = obj.SJMsubmitQuoteDetailV2Response.nbsmsgo.msgEntry[0].msgTxt;
                            this.messageModal(component, true, 'Success Message', msg_txt);
                            
                            this.saveApplicationHelper(component, event);
                             
                            
                        }   
                        
                                                
                       this.stopSpinner(component, event);
                                 
                        
                       /* if (obj){
                            var quoteDetailResponse = obj.SJMsubmitQuoteDetailV2Response.nbsmsgo.msgEntry[0];
                            
                            client.submit_quote_detail_msg_class = quoteDetailResponse.msgClass;
                            client.submit_quote_detail_msg_code = quoteDetailResponse.msgCode;
                            client.submit_quote_detail_msg_err_ind = quoteDetailResponse.errInd;
                            client.submit_quote_detail_msg_txt = quoteDetailResponse.msgTxt;
                            component.set("v.client", client);
                            alert('last');
                        }*/
                    } else {
                        let obj =  res.Data.dataMap.getBody;
                        this.errorMessagesHelper(component, event, 'Submit quote exception', obj, 'scoring_obj');   
                    }
                } else {
                    this.errorMessagesHelper(component, event, 'Submit quote detail warning', res.Message, 'scoring_obj');   
                }
            } else {
                this.errorMessagesHelper(component, event, 'Submit quote detail error', errors[0].message, 'scoring_obj');   
            }
        });
        $A.enqueueAction(action);
    },
    finalizeApplication: function(component, event){
        
        let final_decision = component.get("v.client.final_decision");
        
        if(final_decision == "ACCEPT"){
             this.getQuoteDetailHelper(component, event);
        }else if(!final_decision){
            component.set("v.client.final_decision","Application Cancelled");
            this.saveApplicationHelper(component, event);
        }else{
            this.saveApplicationHelper(component, event);
        }
                        
    },
    
    NHlistAcctsLinkedToAClientV1Helper: function(component, event) {
        var client = component.get("v.client");
        var clientData = '{"NHlistAcctsLinkedToAClientV1":{"nbsapdpi":{"channel":"' + client.channel + '","application":"' + client.application + '","trace":"' + client.trace + '"},"nhc041i":{"log":"' + client.log + '","authenticate":"' + client.authenticate + '","accessNumber":"' + client.access_number + '","user":"' + client.user + '","division":"' + client.division + '","device":"' + client.device + '","origAddress":"' + client.orig_address + '","combiNumber":"' + client.combi_number + '","language":"' + client.language + '","cifkey":"' + client.cif_key + '","nbrOfRecsToRtrv":"' + client.nbr_of_recs_to_rtrv + '","pagingKey":"' + client.paging_key + '"}}}';
        // var clientData = '{"NHlistAcctsLinkedToAClientV1":{"nbsapdpi":{"channel":"Salesforce","application":"DIVE","trace":"Y"},"nhc041i":{"log":"Y","authenticate":"Y","accessNumber":"","user":"1","division":"","device":"","origAddress":"","combiNumber":"11","language":"","cifkey":"BAILVP 001","nbrOfRecsToRtrv":"?","pagingKey":""}}}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log(clientData);
        var action = component.get("c.NHlistAcctsLinkedToAClientV1");
        action.setParams({
            clientData: clientData
        });
        
        action.setCallback(this, function(response) {
            var client = component.get("v.client");
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        var NHlistAcctsLinkedToAClientV1API = JSON.parse(res.Data.dataMap.getBody);
                        
                        if (NHlistAcctsLinkedToAClientV1API) {
                            /*  var nhc041i = NHlistAcctsLinkedToAClientV1API.NHlistAcctsLinkedToAClientV1.nhc041i;
                            client.rcde = nhc041i.rcde;
                            client.rcde_type = nhc041i.rcdeType;
                            client.rcde_source = nhc041i.rcdeSource;
                            client.rcde_reason = nhc041i.rcdeReason;
                            client.rdesc = nhc041i.rdesc;
                            client.more_to_come = nhc041i.moreToCome;
                            client.return_code = nhc041i.returnCode;
                            client.reason_code = nhc041i.reasonCode;
                            client.service_version = nhc041i.serviceVersion;
                            client.echo_key = nhc041i.echoKey;*/
                        }
                    } else {
                        this.messageModal(component, true, 'Submit application warning', res.Data.dataMap.getBody);
                    }
                } else {
                    this.messageModal(component, true, 'Submit application message', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'Submit application error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    /* Navigation*/
    activateTab: function(component, clickedTab) {
        var tabId = component.find(clickedTab);
        var tab_div = component.find(clickedTab + "Div");
        $A.util.addClass(tabId, 'slds-active');
        $A.util.addClass(tab_div, 'slds-show');
        $A.util.removeClass(tab_div, 'slds-hide');
    },
    deActivateTab: function(component, previousTab) {
        var tabId = component.find(previousTab);
        var tab_div = component.find(previousTab + "Div");
        $A.util.removeClass(tabId, 'slds-active');
        $A.util.removeClass(tab_div, 'slds-show');
        $A.util.addClass(tab_div, 'slds-hide');
    },
    /* navigationHelper: function(component, event, navigation) {
        var clickedTab;
        if (navigation) {
            clickedTab = navigation;
        } else {
            clickedTab = event.currentTarget.id;
        }
        component.set("v.selTabId", clickedTab);
        var currentTab = component.get("v.currentTab");

        var isTabValid = component.get("v.isTabValid");
        
        //First tab
        if(currentTab == 'clientProfile'){
		   component.set("v.client_validation_check", false);                 
           this.validateMandatoryClientDetails(component, event);
           if(component.get("v.client_validation_check")){
              component.set("v.isTabValid.clientProfile", false);
               //deactivate all tabs
              return;   
           }else{
               //enable
               component.set("v.isTabVisited.clientProfile", true);
               component.set("v.isTabValid.clientProfile", true);
           } 
         }   
        if(currentTab == 'contactDetails'){            
             component.set("v.client_validation_check", false); 
             this.validateMandatoryContactDetails(component, event);
             var clientCheck = component.get("v.client_validation_check");
             if(component.get("v.client_validation_check")){   
                  component.set("v.isTabValid.contactDetails", false);                 
                  return;   
             } else{  
               component.set("v.isTabVisited.contactDetails", true);
               component.set("v.isTabValid.contactDetails", true);
             }
         }         
        
        if(currentTab == 'employmentDetails'){            
             component.set("v.client_validation_check", false); 
             this.validateMandatoryEmploymentDetails(component, event);
             var clientCheck = component.get("v.client_validation_check");
             if(component.get("v.client_validation_check")){ 
                  component.set("v.isTabValid.employmentDetails", false);                 
                  return;   
             } else{
                this.validateClientDetailsAPIHelper(component,event);    
               component.set("v.isTabVisited.employmentDetails", true);
               component.set("v.isTabValid.employmentDetails", true);
                
             }
         }     
                
        if(currentTab == 'productSelection'){            
             component.set("v.client_validation_check", false);
            
             this.validateMandatoryproductSelectionDetails(component, event);            
             var clientCheck = component.get("v.client_validation_check");
                        
             if(component.get("v.client_validation_check")){ 
                  component.set("v.isTabValid.productSelection", false);                 
                  return;   
             } else{
               component.set("v.isTabVisited.productSelection", true);
               component.set("v.isTabValid.productSelection", true);
             }
            //Current tab is product selection, We move to Personal loan application tab
            if(component.get("v.selTabId") == 'loanApplication'){  
                component.set("v.ctiSpinner", {
                    displayCls: '',
                    msgDisplayed: 'Generating application number...'
                });
                this.SJMgenerateApplicationNumberV2Helper(component, event);                                
            }
         }         
        
        if(currentTab == 'loanApplication'){
             component.set("v.client_validation_check", false); 
             this.validateMandatoryloanApplicationDetails(component, event);
             if(component.get("v.client_validation_check")){ 
                  isTabValid.loanApplication = false; 
                  component.set("v.isTabValid.loanApplication", false);                 
                  return;   
             } else{
               component.set("v.isTabVisited.loanApplication", true);
               component.set("v.isTabValid.loanApplication", true);
             }    
            
            //Current tab is Personal loan application, We move to living expense tab
            if(component.get("v.selTabId") == 'livingExpenses'){  
                
                let nextFunct = component.get("v.client.next_func");

                if (nextFunct == 'PL03'){                        
                    this.submitPLinfo(component, event);    
                }else if (nextFunct == 'CLIF'){                           
                    this.submitCreditLifePolicyInfoV1Helper(component, event);
                }
                    else if (nextFunct == 'CMSM'){                        
                        this.sjmgetCMSSMSInfoHelper(component, event);
                    }   
                        else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                            this.submitCMSContinuationProcessHelper(component, event);
                        }   
                            else if (nextFunct == 'CMST'){                           
                                this.sjmSaveTriadAgreementHelper(component, event);
                            }else if (nextFunct == 'BLZE'){                           
                                this.sjmProcessBlazeAdvisorHelper(component, event);
                            }else { 
                                this.messageModal(component, true, 'Technical Exception', 'Technical exception has occured in savefinadetai');
                                return;
                            }                                
            }
            
            
        }  
         
         if(currentTab == 'livingExpenses'){  
             component.set("v.isTabVisited.livingExpenses", true);
             component.set("v.isTabValid.livingExpenses", true);
         }  
         if(currentTab == 'incomeAndExpenses'){
             component.set("v.isTabVisited.incomeAndExpenses", true);
             component.set("v.isTabValid.incomeAndExpenses", true);
             // this.saveApplicationHelper(component,event); 
         }  
        if(currentTab == 'outcome'){
        	component.set("v.isTabVisited.outcome", true);   
            component.set("v.isTabValid.outcome", true);
        }                

        var tabs = document.getElementsByClassName('slds-tabs--default__link');
        var tabMap = component.get("v.tabMap");

        if (clickedTab != currentTab) {
            
			var allValid = this.enableTabsController(component, event);
            if(!allValid){
                return;
            }            
 
            if (clickedTab == 'clientProfile') {
                component.set("v.backBtn", true);
            } else {
                component.set("v.backBtn", false);
            }
            if (clickedTab == 'outcome') {
                component.set("v.nextBtn", true);
            } else {
                component.set("v.nextBtn", false);
            }

            var deActivateTab = currentTab;

            component.set("v.currentTab", clickedTab);

            var priorTabIndex = tabMap[deActivateTab];
            tabs[priorTabIndex - 1].setAttribute('data-visited', 'true');

            component.set("v.priorTabId", deActivateTab);
            this.activateTab(component, clickedTab);
            this.deActivateTab(component, deActivateTab);
        }
    },*/
    //rakesh changes on 16Sep2020
    navigationHelper: function(component, event, navigation) {
        var clickedTab;
        if (navigation) {
            clickedTab = navigation;
        } else {
            clickedTab = event.currentTarget.id;
        }
        component.set("v.selTabId", clickedTab);
        var currentTab = component.get("v.currentTab");
        
        var isTabValid = component.get("v.isTabValid");
        
        //First tab
        if(currentTab == 'clientProfile'){
            component.set("v.client_validation_check", false); 
            if(clickedTab == 'contactDetails'){
                this.validateMandatoryClientDetails(component, event);
            }
            if(component.get("v.client_validation_check")){
                component.set("v.isTabValid.clientProfile", false);
                //deactivate all tabs
                return;   
            }else{
                //enable
                component.set("v.isTabVisited.clientProfile", true);
                component.set("v.isTabValid.clientProfile", true);
            } 
        }   
        if(currentTab == 'contactDetails'){            
            component.set("v.client_validation_check", false); 
            if(clickedTab == 'employmentDetails'){
                this.validateMandatoryContactDetails(component, event);
            }
            var clientCheck = component.get("v.client_validation_check");
            if(component.get("v.client_validation_check")){   
                component.set("v.isTabValid.contactDetails", false);                 
                return;   
            } else{  
                component.set("v.isTabVisited.contactDetails", true);
                component.set("v.isTabValid.contactDetails", true);
            }
        }         
        
        if(currentTab == 'employmentDetails'){            
            component.set("v.client_validation_check", false);
            if(clickedTab == 'productSelection'){
                this.validateMandatoryEmploymentDetails(component, event);
            }
            var clientCheck = component.get("v.client_validation_check");
            if(component.get("v.client_validation_check")){ 
                component.set("v.isTabValid.employmentDetails", false);                 
                return;   
            } else{
                //this.validateClientDetailsAPIHelper(component,event);    
                component.set("v.isTabVisited.employmentDetails", true);
                component.set("v.isTabValid.employmentDetails", true);                
            }
            if((currentTab == 'employmentDetails') && (clickedTab == 'productSelection')){
                // if(component.get("!v.client_validation_check"))
                var empManCheck = component.get("v.client_validation_check")
                if(!empManCheck){
                    this.validateClientDetailsAPIHelper(component,event);                  
                }
            }
        }     
        
        if(currentTab == 'productSelection'){  
            
           
            component.set("v.client_validation_check", false); 
            if(clickedTab == 'loanApplication'){
                this.validateMandatoryproductSelectionDetails(component, event); 
            }
            var clientCheck = component.get("v.client_validation_check");
            
            if(component.get("v.client_validation_check")){ 
                component.set("v.isTabValid.productSelection", false);                 
                return;   
            } else{
                component.set("v.isTabVisited.productSelection", true);
                component.set("v.isTabValid.productSelection", true);
            }
            
            //Current tab is product selection, We move to Personal loan application tab
            if(component.get("v.selTabId") == 'loanApplication'){
                
                var client = component.get("v.client"); 
                
                if(client.market_campgn_id || client.grp_scheme_code || client.grp_scheme_type || client.id_pass_no_sp_p || client.id_type_sp){
                    
                }else{
                    this.dispaySpinner(component, event, 'Generating application...');
                    this.SJMgenerateApplicationNumberV2Helper(component, event); 
                }
                          
            }
        }         
        
        if(currentTab == 'loanApplication'){
            component.set("v.client_validation_check", false);
            if(clickedTab == 'livingExpenses'){
                this.validateMandatoryloanApplicationDetails(component, event);
            }
            if(component.get("v.client_validation_check")){ 
                isTabValid.loanApplication = false; 
                component.set("v.isTabValid.loanApplication", false);                 
                return;   
            } else{
                component.set("v.isTabVisited.loanApplication", true);
                component.set("v.isTabValid.loanApplication", true);
            }
            
            //Current tab is Personal loan application, We move to living expense tab
            if(component.get("v.selTabId") == 'livingExpenses'){  
                
                let nextFunct = component.get("v.client.next_func");
                
                if (nextFunct == 'PL03'){                        
                    this.submitPLinfo(component, event);    
                }else if (nextFunct == 'CLIF'){                           
                    this.submitCreditLifePolicyInfoV1Helper(component, event);
                }
                    else if (nextFunct == 'CMSM'){                        
                        this.sjmgetCMSSMSInfoHelper(component, event);
                    }   
                        else  if (nextFunct == 'CMSC/N' || nextFunct == 'CMSC'){                             
                            this.submitCMSContinuationProcessHelper(component, event);
                        }   
                            else if (nextFunct == 'CMST'){                           
                                this.sjmSaveTriadAgreementHelper(component, event);
                            }else if (nextFunct == 'BLZE'){                           
                                this.sjmProcessBlazeAdvisorHelper(component, event);
                            }else { 
                                this.messageModal(component, true, 'Technical Exception', 'Technical exception has occured in savefinadetai');
                                return;
                            }                                
            }
        }  
        
        if(currentTab == 'livingExpenses'){ 
            
          let necessary_expenses = component.get("v.client.necessary_expenses");  
            
         let bond_mortgage = component.get("v.client.bond_mortgage");
        let loan_overdraft = component.get("v.client.loan_overdraft");
        let credit_cards = component.get("v.client.credit_cards");
        let asset_and_finance_repayment = component.get("v.client.asset_and_finance_repayment");
        let retail_accounts = component.get("v.client.retail_accounts");
        let other_debt_repayment = component.get("v.client.other_debt_repayment");  
            
         let necessary_expenses_addition = (bond_mortgage? parseFloat(bond_mortgage):0) + (loan_overdraft? parseFloat(loan_overdraft):0) + (credit_cards? parseFloat(credit_cards):0) + (asset_and_finance_repayment? parseFloat(asset_and_finance_repayment):0)  + (retail_accounts? parseFloat(retail_accounts):0) + (other_debt_repayment? parseFloat(other_debt_repayment):0) + (necessary_expenses? parseFloat(necessary_expenses):0);

            
          component.set("v.client.total_monthly_expenses",necessary_expenses_addition);

            
            component.set("v.client_validation_check", false); 
            if(clickedTab == 'incomeAndExpenses'){
                this.validateMandatoryLivingExpenses(component, event);
            }
            if(component.get("v.client_validation_check")){
                component.set("v.isTabValid.livingExpenses", false);
                //deactivate all tabs
                return;   
            }else{
                //enable
                component.set("v.isTabVisited.livingExpenses", true);
                component.set("v.isTabValid.livingExpenses", true);
            } 
            
        }  
        if(currentTab == 'incomeAndExpenses'){
            
            component.set("v.client_validation_check", false); 
            if(clickedTab == 'outcome'){
                this.validateMandatoryIncomeAndExpenses(component, event);
            }
            if(component.get("v.client_validation_check")){
                component.set("v.isTabValid.incomeAndExpenses", false);
                //deactivate all tabs
                return;   
            }else{
                //enable
                component.set("v.isTabVisited.incomeAndExpenses", true);
                component.set("v.isTabValid.incomeAndExpenses", true);
            } 
            
            // this.saveApplicationHelper(component,event); 
            //Current tab is Income And Expenses, We move to Outcome
            
            if(component.get("v.selTabId") == 'outcome'){  
                component.set("v.ctiSpinner", {
                    displayCls: '',
                    msgDisplayed: 'Submitting expenses...'
                });
                this.submitExpense(component, event);
                
            }
            
        }  
        if(currentTab == 'outcome'){
            component.set("v.isTabVisited.outcome", true);   
            component.set("v.isTabValid.outcome", true);
        }                
        
        var tabs = document.getElementsByClassName('slds-tabs--default__link');
        var tabMap = component.get("v.tabMap");
        
        if (clickedTab != currentTab) {
            
            var allValid = this.enableTabsController(component, event);
            if(!allValid){
                return;
            }            
            
            if (clickedTab == 'clientProfile') {
                component.set("v.backBtn", true);
            } else {
                component.set("v.backBtn", false);
            }
            if (clickedTab == 'outcome') {
                component.set("v.nextBtn", true);
            } else {
                component.set("v.nextBtn", false);
            }
            
            var deActivateTab = currentTab;
            
            component.set("v.currentTab", clickedTab);
            
            var priorTabIndex = tabMap[deActivateTab];
            tabs[priorTabIndex - 1].setAttribute('data-visited', 'true');
            
            component.set("v.priorTabId", deActivateTab);
            this.activateTab(component, clickedTab);
            this.deActivateTab(component, deActivateTab);
        }
    },
    dispaySpinner: function(component, event, message){
                component.set("v.ctiSpinner", {
                    displayCls: '',
                    msgDisplayed: message
                });
    },
    stopSpinner: function(component, event){
        component.set("v.ctiSpinner", {
            displayCls: 'slds-hide',
            msgDisplayed: 'Loading...'
        });
        component.set("v.searchCardVisible", "slds-hide");
        component.set("v.informationCardVisible", "");
    },  
    enableTabsController: function(component, event) {
        var isAllValid = true;
        var clickedTab = component.get("v.selTabId");
        var currentTab =  component.get("v.currentTab");
        var isTabVisited = component.get("v.isTabVisited");
        
        if(clickedTab == 'contactDetails'){
            if(!isTabVisited.clientProfile){
                isAllValid = false;
            }            
        }
        console.log(isTabVisited.contactDetails+' -- '+isTabVisited.clientProfile);
        if(clickedTab == 'employmentDetails'){
            if(!isTabVisited.contactDetails || !isTabVisited.clientProfile){
                isAllValid = false;
            } 
            
        }     
        
        if(clickedTab == 'productSelection'){
            if(!isTabVisited.clientProfile || !isTabVisited.contactDetails || !isTabVisited.employmentDetails){
                isAllValid = false;
            }            
        }
        
        if(clickedTab == 'loanApplication'){
            if(!isTabVisited.clientProfile || !isTabVisited.contactDetails || !isTabVisited.employmentDetails || !isTabVisited.productSelection){
                isAllValid = false;
            }            
        }     
        
        if(clickedTab == 'livingExpenses'){
            if(!isTabVisited.clientProfile || !isTabVisited.contactDetails || !isTabVisited.employmentDetails || !isTabVisited.productSelection || !isTabVisited.loanApplication){
                isAllValid = false;
            }            
        }  
        
        if(clickedTab == 'incomeAndExpenses'){
            if(!isTabVisited.clientProfile || !isTabVisited.contactDetails || !isTabVisited.employmentDetails || !isTabVisited.productSelection || !isTabVisited.loanApplication || !isTabVisited.livingExpenses){
                isAllValid = false;
            }            
        }   
        
        if(clickedTab == 'outcome'){
            if(!isTabVisited.clientProfile || !isTabVisited.contactDetails || !isTabVisited.employmentDetails || !isTabVisited.productSelection || !isTabVisited.loanApplication || !isTabVisited.livingExpenses || !isTabVisited.incomeAndExpenses){
                isAllValid = false;
            }            
        }          
        
        return isAllValid;
        
        //{'clientProfile':true,'contactDetails':false,'employmentDetails':false,'productSelection':false,'loanApplication':false,'livingExpenses':false,'incomeAndExpenses':false,'outcome':false}"/>     
        
        //var isTabValid = component.get("v.isTabValid");
        
        //{,'employmentDetails':false,'productSelection':false,'loanApplication':false,'livingExpenses':false,'incomeAndExpenses':false,'outcome':false
        
        /*var profile = component.find("profile");
        var contact = component.find("contact");
        var employment = component.find("employment");
        
        if(isTabValid.clientProfile){
            $A.util.addClass(profile, 'link-cls');            
        }else{
            $A.util.removeClass(profile, 'link-cls');
        }
        
        if(isTabValid.contactDetails){
            $A.util.addClass(contact, 'link-cls');            
        }else{
            $A.util.removeClass(contact, 'link-cls');
        }        
        
        if(isTabValid.employmentDetails){
            $A.util.addClass(employment, 'link-cls');            
        }else{
            $A.util.removeClass(employment, 'link-cls');
        }    */     
        
    },        
    /* end navigation */
    
    saveApplicationHelper: function(component, event) {
        var client = component.get("v.client");  
        
        let clientObj = {};
        //  START       
        clientObj['profile_record_id'] = client.profile_record_id.toString();
        clientObj['applcation_record_id'] = client.applcation_record_id.toString();
        clientObj['id_number'] =  client.id_number.toString();
        // Screen 1
        clientObj['title_value'] = client.title_value ? client.title_value.toString() : '';
        clientObj['id_type_value'] = client.id_type_value ? client.id_type_value.toString() : '';
        if(client.id_date_issued.includes("/")){    
            clientObj['id_date_issued'] = this.dateFormating("Save_To_Object","DD/MM/YYYY",client.id_date_issued);
        }
        clientObj['place_of_residence'] = client.place_of_residence_value ? client.place_of_residence_value.toString() : '';
        clientObj['customer_type'] = client.customer_type_value ? client.customer_type_value.toString() : '';
        clientObj['gender'] = client.gender_value ? client.gender_value.toString() : '';
        if(client.date_of_birth.includes("/")){    
            clientObj['date_of_birth'] = this.dateFormating("Save_To_Object","DD/MM/YYYY",client.date_of_birth);
        }
        clientObj['country_of_birth'] = client.country_of_birth_value ? client.country_of_birth_value.toString() : '';
        clientObj['nationality'] = client.nationality_value ? client.nationality_value.toString() : '';
        clientObj['marital_status'] = client.marital_status_value ? client.marital_status_value.toString() : '';
        clientObj['marital_contract'] = client.marital_contract_value ? client.marital_contract_value.toString() : '';
        clientObj['home_language'] = client.home_language_value ? client.home_language_value.toString() : '';
        clientObj['dependents'] = client.dependents_value ? client.dependents_value.toString() : '';
        //clientObj['full_name'] = client.full_name ? client.full_name.toString() : '';
        clientObj['relationship'] = client.relationship_value ? client.relationship_value.toString() : '';
        clientObj['contact_number'] = client.contact_number ? client.contact_number.toString() : '';
        clientObj['communication_language'] = client.communication_language_value ? client.communication_language_value.toString() : '';
        clientObj['insolvent'] = client.insolvent ? client.insolvent.toString() : '';
        clientObj['social_grant'] = client.social_grant ? client.social_grant.toString() : '';
        clientObj['debt_counseling'] = client.debt_counseling ? client.debt_counseling.toString() : '';
        clientObj['does_client_havepostmatric_qualification'] = client.does_client_havepostmatric_qualification ? client.does_client_havepostmatric_qualification.toString() : '';
        clientObj['insolvent_text'] = client.insolvent == "Y" ? 'Yes':'No'; 
        clientObj['social_grant_text'] =client.social_grant == "Y" ? 'Yes':'No'; 
        clientObj['debt_counseling_text'] = client.debt_counseling == "Y" ? 'Yes':'No'; 
        clientObj['does_client_havepostmatric_qualification_text'] = client.does_client_havepostmatric_qualification == "Y" ? 'Yes':'No'; 
       
        
        clientObj['post_matric_qualification'] = client.post_matric_qualification_value ? client.post_matric_qualification_value.toString() : '';
        if(client.fica_date_identified.includes("/")){    
            clientObj['fica_date_identified'] = this.dateFormating("Save_To_Object","DD/MM/YYYY",client.fica_date_identified);
        }
        clientObj['verify_client'] = client.verify_client ? client.verify_client.toString() : '';
        
        //Screen 2
        clientObj['residential_address'] = client.residential_address ? client.residential_address.toString() : '';
        if(client.current_address_since){
            if(client.current_address_since.includes("/")){    
                clientObj['current_address_since'] = this.dateFormating("Save_To_Object","DD/MM/YYYY",client.current_address_since);
            }
        }else{
            clientObj['current_address_since'] = (client.current_address_since) ? this.getFormattedDate(component, client.current_address_since) : null;
        }
        clientObj['residential_address_country'] = client.residential_address_country_value ? client.residential_address_country_value.toString() : '';
        clientObj['residential_status'] = client.residential_status_value ? client.residential_status_value.toString() : '';
        clientObj['outstanding_bond'] = parseFloat(client.outstanding_bond, 10);
        clientObj['realistic_market_value'] = parseFloat(client.realistic_market_value, 10);
        clientObj['section_129_notice_delivery_address'] = client.section_129_notice_delivery_address_value ? client.section_129_notice_delivery_address_value.toString() : '';
        clientObj['postal_address_line_1_3'] = client.postal_address_line_1_3 ? client.postal_address_line_1_3.toString() : '';
        clientObj['town_city_foreign_country'] = client.town_city_foreign_country ? client.town_city_foreign_country.toString() : '';
        clientObj['postal_code'] = client.postal_code ? client.postal_code.toString() : '';
        clientObj['work_telephone'] = client.work_telephone_number ? client.work_telephone_number.toString() : '';
        clientObj['home_telephone'] = client.home_telephone_number ? client.home_telephone_number.toString() : '';
        clientObj['work_fax_number'] = client.work_fax_number ? client.work_fax_number.toString() : '';
        clientObj['home_fax_number'] = client.home_fax_number ? client.home_fax_number.toString() : '';
        clientObj['cellphone_number'] = client.cellphone_number ? client.cellphone_number.toString() : '';
        clientObj['email_address'] = client.email_address ?client.email_address.toString() : '';
        clientObj['preffered_communication_channel'] = client.preffered_communication_channel_value ? client.preffered_communication_channel_value.toString() : '';
        clientObj['credit_worthiness'] = Boolean(client.credit_worthiness);
        clientObj['absa_group_electronic'] = Boolean(client.absa_group_electronic);
        clientObj['voice_recording'] = Boolean(client.voice_recording);
        clientObj['email'] = Boolean(client.email); 
        clientObj['sms'] = Boolean(client.sms); 
        clientObj['credit_worthiness_text'] = client.credit_worthiness == "Y" ? 'Yes':'No'; 
        clientObj['absa_group_electronic_text'] = client.credit_worthiness == "Y" ? 'Yes':'No'; 
        clientObj['voice_recording_text'] = client.credit_worthiness == "Y" ? 'Yes':'No'; 
        clientObj['email_text'] = client.credit_worthiness == "Y" ? 'Yes':'No'; 
        clientObj['sms_text'] = client.credit_worthiness == "Y" ? 'Yes':'No'; 
        
        //Screen 3
        clientObj['occupational_status'] = client.occupational_status_value ? client.occupational_status_value.toString() : '';
        clientObj['employment_sector'] = client.employment_sector_value ? client.employment_sector_value.toString() : '';
        clientObj['occupation'] = client.occupation_value ?  client.occupation_value.toString() : '';
        clientObj['occupation_code'] = client.occupation_code_value ? client.occupation_code_value.toString() : '';
        clientObj['occupation_level'] = client.occupation_level_value ? client.occupation_level_value.toString() : '';
        clientObj['monthly_income'] = client.monthly_income_value ? client.monthly_income_value.toString() : '';
        clientObj['source_of_income'] = client.source_of_income_value ? client.source_of_income_value.toString() : '';
        clientObj['frequency_of_income'] = client.frequency_of_income_value ? client.frequency_of_income_value.toString() : '';
        if(client.current_employment_since){
            if(client.current_employment_since.includes("/")){    
                clientObj['current_employment_since'] = this.dateFormating("Save_To_Object","DD/MM/YYYY",client.current_employment_since);
            }
        }else{
            clientObj['current_employment_since'] = (client.current_employment_since) ? this.getFormattedDate(component, client.current_employment_since) : null;
        }
        clientObj['client_banks_with_absa'] = client.client_banks_with_absa ? client.client_banks_with_absa.toString() : '';
        clientObj['employers_name'] = client.employers_name ? client.employers_name.toString() : '';
        clientObj['empl_postal_address_line_1_3'] = client.empl_postal_address_line_1_3 ? client.empl_postal_address_line_1_3.toString() : '';
        clientObj['empl_town_city_foreign_country'] = client.empl_town_city_foreign_country ? client.empl_town_city_foreign_country.toString() : '';
        clientObj['empl_postal_code'] = client.empl_postal_code ? client.empl_postal_code.toString() : '';
        clientObj['client_registed_for_income_tax'] = client.client_registed_for_income_tax ? client.client_registed_for_income_tax.toString() : '';
        clientObj['sa_income_tax_number'] = client.sa_income_tax_number ? client.sa_income_tax_number.toString() : '';
        clientObj['reason_sa_income_tax_number_not_given'] = client.reason_sa_income_tax_number_not_given ? client.reason_sa_income_tax_number_not_given.toString() : '';
        clientObj['client_registered_for_foreign_income_tax'] = client.client_registered_for_foreign_income_tax ? client.client_registered_for_foreign_income_tax.toString() : '';
        clientObj['foreign_income_tax_number'] = client.foreign_income_tax_number ? client.foreign_income_tax_number.toString() : '';
        clientObj['reason_foreign_income_tax_num_not_given'] = client.reason_foreign_income_tax_num_not_given ? client.reason_foreign_income_tax_num_not_given.toString() : '';
        
        //Screen 4
        clientObj['products'] = client.products ? client.products.toString() : '';
        clientObj['i_accept_terms_and_conditions'] = Boolean(client.i_accept_terms_and_conditions);
        
        //Screen 5
        clientObj['application_number'] = client.application_number ? client.application_number.toString() : '';
        clientObj['purpose_of_loan'] = client.purpose_of_loan_value ? client.purpose_of_loan_value.toString() :'';
        clientObj['other'] = client.other ? client.other.toString() : '';
        clientObj['race_indicator'] = client.race_indicator_value ?  client.race_indicator_value.toString() : '';
        clientObj['number_of_payments'] = parseFloat(client.number_of_payments, 10);
        clientObj['initiation_fee_payment_method'] = client.initiation_fee_payment_method_value ? client.initiation_fee_payment_method_value.toString() : '';
        clientObj['additional_loan_amount'] = parseFloat(client.additional_loan_amount, 10);
        clientObj['settlement_other_products'] = client.settlement_other_products ? client.settlement_other_products.toString() : '';
        clientObj['total_amount'] = parseFloat(client.total_amount, 10);
        clientObj['payment_type'] = client.payment_type_value ? client.payment_type_value.toString() : '';
        clientObj['payment_frequency'] = client.payment_frequency_value ? client.payment_frequency_value.toString() : '';
        clientObj['absa_credit_life'] = client.absa_credit_life ? client.absa_credit_life.toString() : '';
        
        //Screen 6
        clientObj['groceries'] = parseFloat(client.groceries, 10);
        clientObj['domestic_garderner_worker_etc'] = parseFloat(client.domestic_garderner_worker_etc, 10);
        clientObj['telephone_cellphone'] = parseFloat(client.telephone_cellphone, 10);
        clientObj['education_school_loan_repayment'] = parseFloat(client.education_school_loan_repayment, 10);
        clientObj['transport_petrol_excl_vehicle_finance'] = parseFloat(client.transport_petrol_excl_vehicle_finance, 10);
        clientObj['insurance_and_funeral_policies'] = parseFloat(client.insurance_and_funeral_policies, 10);
        clientObj['municipal_levies_rates_taxes_water_light'] = parseFloat(client.municipal_levies_rates_taxes_water_light, 10);
        clientObj['security'] = parseFloat(client.security, 10);
        clientObj['rental'] = parseFloat(client.rental, 10);
        clientObj['maintenance'] = parseFloat(client.maintenance, 10);
        clientObj['entertainment'] = parseFloat(client.entertainment, 10);
        clientObj['specify_other_expenses'] = client.specify_other_expenses ? client.specify_other_expenses.toString() : '';
        clientObj['amount'] = parseFloat(client.amount, 10);
        clientObj['necessary_expenses'] = parseFloat(client.necessary_expenses, 10);
        
        //Screen 7
        clientObj['gross_income'] = parseFloat(client.gross_income, 10);
        clientObj['salary_deductions'] = parseFloat(client.salary_deductions, 10);
        clientObj['net_salary_income_month_1'] = parseFloat(client.net_salary_income_month_1, 10);
        clientObj['net_salary_income_month_2'] = parseFloat(client.net_salary_income_month_2, 10);
        clientObj['net_salary_income_month_3'] = parseFloat(client.net_salary_income_month_3, 10);
        clientObj['salary_deducted_fixed_debit'] = parseFloat(client.salary_deducted_fixed_debit, 10);
        clientObj['rental_income'] = parseFloat(client.rental_income, 10);
        clientObj['other_additional_income'] = parseFloat(client.other_additional_income, 10);
        clientObj['total_net_monthly_income'] = parseFloat(client.total_net_monthly_income, 10);
        clientObj['bond_mortgage'] = parseFloat(client.bond_mortgage, 10);
        clientObj['loan_overdraft'] = parseFloat(client.loan_overdraft, 10);
        clientObj['credit_cards'] = parseFloat(client.credit_cards, 10);
        clientObj['asset_and_finance_repayment'] = parseFloat(client.asset_and_finance_repayment, 10);
        clientObj['retail_accounts'] = parseFloat(client.retail_accounts, 10);
        clientObj['other_debt_repayment'] = parseFloat(client.other_debt_repayment, 10);
        clientObj['total_monthly_expenses'] = parseFloat(client.total_monthly_expenses, 10);
        clientObj['surplus_shortage'] = parseFloat(client.surplus_shortage, 10);
        
        
        //Screen 8
        clientObj['casa_reference'] = client.casa_reference ? client.casa_reference.toString() : '';  //final_pl_amnt
        clientObj['final_loan_amount'] = parseFloat(client.final_loan_amount, 10);
        clientObj['final_decision'] = client.final_decision ? client.final_decision.toString() : '';
        clientObj['reason'] = client.reason ? client.reason.toString() : '';
        if(client.first_payment_date){
            if(client.first_payment_date.includes("/")){    
                clientObj['first_payment_date'] = this.dateFormating("Save_To_Object","DD/MM/YYYY",client.first_payment_date);
            }
        }else{
            clientObj['first_payment_date'] = (client.first_payment_date) ? this.getFormattedDate(component, client.first_payment_date) : null;
        }
        clientObj['request_a_quote_to_be_issued'] = client.request_a_quote_to_be_issued ? client.request_a_quote_to_be_issued.toString() : '';
        
        // END
        //PDF text values
        clientObj['title_label'] = client.title_label ? client.title_label.toString() : '';
        clientObj['initials'] = client.initials ? client.initials.toString() : '';
        clientObj['first_names'] = client.first_names ? client.first_names.toString() : '';
        clientObj['surname_comp'] = client.surname_comp ? client.surname_comp.toString() : '';        
        clientObj['id_type_label'] = client.id_type_label ? client.id_type_label.toString() : '';
        clientObj['place_of_residence_label'] = client.place_of_residence_label ? client.place_of_residence_label.toString() : '';
        clientObj['country_of_birth_label'] = client.country_of_birth_label ? client.country_of_birth_label.toString() : '';
        clientObj['customer_type_label'] = client.customer_type_label ? client.customer_type_label.toString() : '';
        clientObj['gender_label'] = client.gender_label ? client.gender_label.toString() : '';
        clientObj['nationality_label'] = client.nationality_label ? client.nationality_label.toString() : '';
        clientObj['marital_status_label'] = client.marital_status_label ? client.marital_status_label.toString() : '';
        clientObj['marital_contract_label'] = client.marital_contract_label ? client.marital_contract_label.toString() : '';
        clientObj['home_language_label'] = client.home_language_label ? client.home_language_label.toString() : '';
        clientObj['relationship_label'] = client.relationship_label ? client.relationship_label.toString() : '';
        clientObj['communication_language_label'] = client.communication_language_label ? client.communication_language_label.toString() : '';
        clientObj['post_matric_qualification_label'] = client.post_matric_qualification_label ? client.post_matric_qualification_label.toString() : '';
        clientObj['residential_address_country_label'] = client.residential_address_country_label ? client.residential_address_country_label.toString() : '';
        clientObj['residential_status_label'] = client.residential_status_label ? client.residential_status_label.toString() : '';
        clientObj['section_129_notice_delivery_address_label'] = client.section_129_notice_delivery_address_label ? client.section_129_notice_delivery_address_label.toString() : '';
        clientObj['preffered_communication_channel_label'] = client.preffered_communication_channel_label ? client.preffered_communication_channel_label.toString() : '';
        clientObj['occupational_status_label'] = client.occupational_status_label ? client.occupational_status_label.toString() : '';
        clientObj['employment_sector_label'] = client.employment_sector_label ? client.employment_sector_label.toString() : '';
        clientObj['occupation_code_label'] = client.occupation_code_label ? client.occupation_code_label.toString() : '';
        clientObj['occupation_level_label'] = client.occupation_level_label ? client.occupation_level_label.toString() : '';
        clientObj['monthly_income_label'] = client.monthly_income_label ? client.monthly_income_label.toString() : '';
        clientObj['source_of_income_label'] = client.source_of_income_label ? client.source_of_income_label.toString() : '';
        clientObj['frequency_of_income_label'] = client.frequency_of_income_label ? client.frequency_of_income_label.toString() : '';
        clientObj['nkin_surame_label'] = client.nkin_surname ? client.nkin_surname.toString() : '';
        clientObj['nkin_full_names_label'] = client.nkin_first_name ? client.nkin_first_name.toString() : '';
        clientObj['nkin_email_address_label'] = client.nkin_email ? client.nkin_email.toString() : '';
        clientObj['employee_name'] = client.employee_name ? client.employee_name.toString() : '';
        clientObj['consult_emp_no'] = client.consult_emp_no ? client.consult_emp_no.toString() : '';
        clientObj['transaction_site_code'] = client.transaction_site_code ? client.transaction_site_code.toString() : '';
        clientObj['transaction_site_name'] = client.transaction_site_name ? client.transaction_site_name.toString() : '';
        
        
        var client_json = JSON.stringify(clientObj); 
        
        console.log('save application:: '+client_json);        
        var action = component.get("c.saveApplication");
        action.setParams({
            "clientData": client_json
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) { 
                    
                    // START
                    
                    var res = response.getReturnValue();
                    let appLen = res.Data.dataMap.sfResp.length;
                    let sfResp = res.Data.dataMap.sfResp[0];
                    
                    //console.log(JSON.stringify(JSON.parse(sfResp)));
                    if (sfResp) {
                        client.profile_record_id = sfResp.Id;
                        
                        if (!sfResp.Application_Record_ID__c) {
                            return;
                        }
                        let appLen = sfResp.Application__r.length;
                        if (appLen > 0) {
                            
                            if (!client.applcation_record_id && sfResp.Application_Record_ID__c) {
                                client.applcation_record_id = sfResp.Application_Record_ID__c;
                            }
                            client.applcation_record_id = sfResp.Application__r[0].Id;
                            
                        }  
                    }
                        //END
                        let final_decision = component.get("v.client.final_decision");
                        if(final_decision){
                            this.resetDashboard(component, event);
                        }
                    
                } else {
                    this.messageModal(component, true, 'Salesforce save application exception', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'Save application error', errors[0].message);
            }          
        });
        $A.enqueueAction(action);
    },
    loadClientObjHelper: function(component, event, res, appLen) {
        if (res) {
            
            var client = component.get("v.client");
            client.profile_record_id = res.Id; 
            //screen 1
            let title = (client.title_values.filter(el => el.value == res.Title__c));
            client.title_value = res.Title__c;
            client.title_label = title.length == 1 ? title[0].label : "";
            let id_type = (client.id_type_values.filter(el => el.value == res.ID_Type__c));
            client.id_type_value = res.ID_Type__c;
            client.id_type_label = id_type.length == 1 ? id_type[0].label : "";
            client.id_date_issued = res.ID_Date_Issued__c;
            let place_of_residence = (client.place_of_residence_values.filter(el => el.value == res.Place_Of_Residence__c));
            client.place_of_residence_value = res.Place_Of_Residence__c;
            client.place_of_residence_label = place_of_residence.length == 1 ? place_of_residence[0].label : "";
            let customer_type = (client.customer_type_values.filter(el => el.value == res.Customer_Type__c));
            client.customer_type_value = res.Customer_Type__c;
            client.customer_type_label = customer_type.length == 1 ? customer_type[0].label : "";
            let gender = (client.gender_values.filter(el => el.value == res.Gender__c));
            client.gender_value = res.Gender__c;
            client.gender_label = gender.length == 1 ? gender[0].label : "";
            client.date_of_birth = res.Date_Of_Birth__c;
            let country_of_birth = (client.country_of_birth_values.filter(el => el.value == res.Country_Of_Birth__c));
            client.country_of_birth_value = res.Country_Of_Birth__c;
            client.country_of_birth_label = country_of_birth.length == 1 ? country_of_birth[0].label : "";
            let nationality = (client.nationality_values.filter(el => el.value == res.Nationality__c));
            client.nationality_value = res.Nationality__c;
            client.nationality_label = nationality.length == 1 ? nationality[0].label : "";
            let marital_status = (client.marital_status_values.filter(el => el.value == res.Marital_Status__c));
            client.marital_status_value = res.Marital_Status__c;
            client.marital_status_label = marital_status.length == 1 ? marital_status[0].label : "";
            let marital_contract = (client.marital_contract_values.filter(el => el.value == res.Marital_Contract__c));
            client.marital_contract_value = res.Marital_Contract__c;
            client.marital_contract_label = marital_contract.length == 1 ? marital_contract[0].label : "";
            let home_language = (client.home_language_values.filter(el => el.value == res.Home_Language__c));
            client.home_language_value = res.Home_Language__c;
            client.home_language_label = home_language.length == 1 ? home_language[0].label : "";
            let dependents = (client.dependents_values.filter(el => el.value == res.Dependents__c));
            client.dependents_value = res.Dependents__c;
            client.dependents_label = dependents.length == 1 ? dependents[0].label : "";
            client.full_name = res.Full_Name__c;
            let relationship = (client.relationship_values.filter(el => el.value == res.Relationship__c));
            client.relationship_value = res.Relationship__c;
            client.relationship_label = relationship.length == 1 ? relationship[0].label : "";
            client.contact_number = res.Contact_Number__c;
            let communication_language = (client.communication_language_values.filter(el => el.value == res.Communication_Language__c));
            client.communication_language_value = res.Communication_Language__c;
            client.communication_language_label = communication_language.length == 1 ? communication_language[0].label : "";
            client.insolvent = res.Insolvent__c;
            client.insolvent_values = this.setRadioBtnInput(component, client.insolvent, client.insolvent_values);
            client.social_grant = res.Social_Grant__c;
            client.social_grant_values = this.setRadioBtnInput(component, client.social_grant, client.social_grant_values);
            client.debt_counseling = res.Debt_Counseling__c;
            client.debt_counseling_values = this.setRadioBtnInput(component, client.debt_counseling, client.debt_counseling_values);
            client.does_client_havepostmatric_qualification = res.Does_Client_HavePostMatric_Qualification__c;
            client.does_client_havepostmatric_qualification_values = this.setRadioBtnInput(component, client.does_client_havepostmatric_qualification, client.does_client_havepostmatric_qualification_values);
            let post_matric_qualification = (client.post_matric_qualification_values.filter(el => el.value == res.Post_Matric_Qualification__c));
            client.post_matric_qualification_value = res.Post_Matric_Qualification__c;
            client.post_matric_qualification_label = post_matric_qualification.length == 1 ? post_matric_qualification[0].label : "";
            client.fica_date_identified = res.FICA_Date_Identified__c;
            //client.verify_client = res.Verify_Client__c;
            //client.verify_client_values = this.setRadioBtnInput(component, client.verify_client, client.verify_client_values);
            
            //screen 2
            client.residential_address = res.Residential_Address__c;
            client.current_address_since = res.Current_Address_Since__c;
            let residential_address_country = (client.residential_address_country_values.filter(el => el.value ==  res.Residential_Address_Country__c));
            client.residential_address_country_value = res.Residential_Address_Country__c;
            client.residential_address_country_label = residential_address_country.length == 1 ? residential_address_country[0].label : "";
            let residential_status = (client.residential_status_values.filter(el => el.value == res.Residential_Status__c));
            client.residential_status_value = res.Residential_Status__c;
            client.residential_status_label = residential_status.length == 1 ? residential_status[0].label : "";
            client.outstanding_bond = res.Outstanding_Bond__c;
            client.realistic_market_value = res.Realistic_Market_Value__c;
            let section_129_notice_delivery_address = (client.section_129_notice_delivery_address_values.filter(el => el.value == res.Section_129_Notice_Delivery_Address__c));
            client.section_129_notice_delivery_address_value = res.Section_129_Notice_Delivery_Address__c;
            client.section_129_notice_delivery_address_label = section_129_notice_delivery_address.length == 1 ? section_129_notice_delivery_address[0].label : "";
            client.postal_address_line_1_3 = res.Postal_Address_Line_1_3__c;
            client.town_city_foreign_country = res.Town_City_Foreign_Country__c;
            client.postal_code = res.Postal_Code__c;
            client.work_telephone_number = res.Work_Telephone_Number__c;
            client.home_telephone_number = res.Home_Telephone_Number__c;
            client.work_fax_number = res.Work_Fax_Number__c;
            client.home_fax_number = res.Home_Fax_Number__c;
            client.cellphone_number = res.Cellphone_Number__c;
            client.email_address = res.Email_Address__c;
            let preffered_communication_channel = (client.preffered_communication_channel_values.filter(el => el.value == res.Preffered_Communication_Channel__c));
            client.preffered_communication_channel_value = res.Preffered_Communication_Channel__c;
            client.preffered_communication_channel_label = preffered_communication_channel.length == 1 ? preffered_communication_channel[0].label : "";
            client.credit_worthiness = res.Credit_Worthiness__c;
            client.absa_group_electronic = res.ABSA_Group_Electronic__c;
            client.voice_recording = res.Voice_Recording__c;
            client.email = res.Email__c;
            client.sms = res.SMS__c;
            
            //Screen 3
            let occupational_status = (client.occupational_status_values.filter(el => el.value == res.Occupational_Status__c));
            client.occupational_status_value = res.Occupational_Status__c;
            client.occupational_status_label = occupational_status.length == 1 ? occupational_status[0].label : "";
            let employment_sector = (client.employment_sector_values.filter(el => el.value == res.Employment_Sector__c));
            client.employment_sector_value = res.Employment_Sector__c;
            client.employment_sector_label = employment_sector.length == 1 ? employment_sector[0].label : "";
            
            let occupation = (client.occupation_values.filter(el => el.value == res.Occupation__c));
            client.occupation_value = res.Occupation__c;
            client.occupation_label = occupation.length == 1 ? occupation[0].label : "";
            
            
             //client.occupation = res.Occupation__c;
            let occupation_code = (client.occupation_code_values.filter(el => el.value == res.Occupation_Code__c));
            client.occupation_code_value = res.Occupation_Code__c;
            client.occupation_code_label = occupation_code.length == 1 ? occupation_code[0].label : "";
            let occupation_level = (client.occupation_level_values.filter(el => el.value == res.Occupation_Level__c));
            client.occupation_level_value = res.Occupation_Level__c;
            client.occupation_level_label = occupation_level.length == 1 ? occupation_level[0].label : "";
            let monthly_income = (client.monthly_income_values.filter(el => el.value == res.Monthly_Income__c));
            client.monthly_income_value = res.Monthly_Income__c;
            client.monthly_income_label = monthly_income.length == 1 ? monthly_income[0].label : "";
            let source_of_income = (client.source_of_income_values.filter(el => el.value == res.Source_Of_Income__c));
            client.source_of_income_value = res.Source_Of_Income__c;
            client.source_of_income_label = source_of_income.length == 1 ? source_of_income[0].label : "";
            let frequency_of_income = (client.frequency_of_income_values.filter(el => el.value == res.Frequency_Of_Income__c));
            client.frequency_of_income_label = frequency_of_income.length == 1 ? frequency_of_income[0].label : "";
            client.frequency_of_income_value = res.Frequency_Of_Income__c;
            //client.current_employment_since = res.Current_Employment_Since__c;    
            if(res.Current_Employment_Since__c){ 
                   client.current_employment_since = this.dateFormating("Object_To_Front_End","YYYY-MM-DD",res.Current_Employment_Since__c);
			 }else{
                 client.current_employment_since = '';
             }        
            client.client_banks_with_absa = res.Client_Banks_With_ABSA__c;
            client.client_banks_with_absa_values = this.setRadioBtnInput(component, client.client_banks_with_absa, client.client_banks_with_absa_values);
            //client.employers_name = res.Employers_Name__c;
            //client.empl_postal_address_line_1_3 = res.Empl_Postal_Address_Line_1_3__c;
            client.empl_town_city_foreign_country = res.Empl_Town_City_Foreign_Country__c;
            client.empl_postal_code = res.Empl_Postal_Code__c;            
            client.client_registed_for_income_tax = res.Client_Registed_For_Income_Tax__c;
            client.client_registed_for_income_tax_values = this.setRadioBtnInput(component, client.client_registed_for_income_tax, client.client_registed_for_income_tax_values);
            client.sa_income_tax_number = res.SA_Income_Tax_Number__c;
            client.reason_sa_income_tax_number_not_given = res.Reason_SA_Income_Tax_Number_Not_Given__c;
            client.client_registered_for_foreign_income_tax = res.Client_Registered_For_Foreign_Income_Tax__c;
            client.client_registered_for_foreign_income_tax_values = this.setRadioBtnInput(component, client.client_registered_for_foreign_income_tax, client.client_registered_for_foreign_income_tax_values);
            client.foreign_income_tax_number = res.Foreign_income_Tax_Number__c;
            client.reason_foreign_income_tax_num_not_given = res.Reason_Foreign_Income_Tax_Num_Not_Given__c;
            
            client.id_number = res.ID_Number__c;            
            
            component.set("v.client", client);
            if (!res.Application_Record_ID__c) {
                return;
            }
            let appLen = res.Application__r.length;
            if (appLen > 0) {
                
                if (!client.applcation_record_id && res.Application_Record_ID__c) {
                    client.applcation_record_id = res.Application_Record_ID__c;
                }
                client.applcation_record_id = res.Application__r[0].Id;
                // alert('profile id: '+res.Id+' --- application id: '+ res.Application__r[0].Id);
                
                //Screen 4
                client.products = res.Application__r[0].Products__c;
                client.products_values = this.setRadioBtnInput(component, client.products, client.products_values);
                client.i_accept_terms_and_conditions = res.Application__r[0].I_Accept_Terms_And_Conditions__c;
                
                //Screen 5
                client.application_number = res.Application__r[0].Application_Number__c;      
                let purpose_of_loan = (client.purpose_of_loan_values.filter(el => el.value == res.Application__r[0].Puporse_Of_Loan__c));
                client.purpose_of_loan_value = res.Application__r[0].Puporse_Of_Loan__c;
                client.purpose_of_loan_label = purpose_of_loan.length == 1 ? purpose_of_loan[0].label : "";
                client.other = res.Application__r[0].Other__c;
                let race_indicator = (client.race_indicator_values.filter(el => el.value == res.Application__r[0].Race_Indicator__c));
                client.race_indicator_value = res.Application__r[0].Race_Indicator__c;
                client.race_indicator_label = race_indicator.length == 1 ? race_indicator[0].label : "";
                
                
                
                //client.number_of_payments = res.Application__r[0].Number_Of_Payments__c;
                let number_of_payments = (client.number_of_payments_values.filter(el => el.value == res.Number_Of_Payments__c));
                client.number_of_payments_value = res.Number_Of_Payments__c;
            	client.number_of_payments_label = number_of_payments.length == 1 ? number_of_payments[0].label : "";
                
                
                
                let initiation_fee_payment_method = (client.initiation_fee_payment_method_values.filter(el => el.value == res.Application__r[0].Initiation_Fee_Payment_Method__c));
                client.initiation_fee_payment_method_value = res.Application__r[0].Initiation_Fee_Payment_Method__c;
                client.initiation_fee_payment_method_label = initiation_fee_payment_method.length == 1 ? initiation_fee_payment_method[0].label : "";
                client.additional_loan_amount = res.Application__r[0].Additional_Loan_Amount__c;
                client.settlement_other_products = res.Application__r[0].Settlement_Other_Products__c;
                client.total_amount = res.Application__r[0].Total_Amount__c;
                let payment_type = (client.payment_type_values.filter(el => el.value == res.Application__r[0].Payment_Type__c));
                client.payment_type_value = res.Application__r[0].Payment_Type__c;
                client.payment_type_label = payment_type.length == 1 ? payment_type[0].label : "";
                let payment_frequency = (client.payment_frequency_values.filter(el => el.value == res.Application__r[0].Payment_Frequency__c));
                client.payment_frequency_value = res.Application__r[0].Payment_Frequency__c;
                client.payment_frequency_label = payment_frequency.length == 1 ? payment_frequency[0].label : "";
                client.absa_credit_life = res.Application__r[0].ABSA_Credit_Life__c;
                client.absa_credit_life_values = this.setRadioBtnInput(component, client.absa_credit_life, client.absa_credit_life_values);
                
                //Screen 6
                client.groceries = res.Application__r[0].Groceries__c;
                client.domestic_garderner_worker_etc = res.Application__r[0].Domestic_Garderner_Worker_etc__c;
                client.telephone_cellphone = res.Application__r[0].Telephone_Cellphone__c;
                client.education_school_loan_repayment = res.Application__r[0].Education_School_Loan_Repayment__c;
                client.transport_petrol_excl_vehicle_finance = res.Application__r[0].Transport_Petrol_Excl_Vehicle_Finance__c;
                client.insurance_and_funeral_policies = res.Application__r[0].Insurance_And_Funeral_Policies__c;
                client.municipal_levies_rates_taxes_water_light = res.Application__r[0].Municipal_Levies_Rates_taxes_water_light__c;
                client.security = res.Application__r[0].Security__c;
                client.rental = res.Application__r[0].Rental__c;
                client.maintenance = res.Application__r[0].Maintenance__c;
                client.entertainment = res.Application__r[0].Entertainment__c;
                client.specify_other_expenses = res.Application__r[0].Specify_other_Expenses__c;
                client.amount = res.Application__r[0].Amount__c;
                client.necessary_expenses = res.Application__r[0].Necessary_Expenses__c;
                
                //Screen 7
                client.gross_income = res.Application__r[0].Gross_Income__c;
                client.salary_deductions = res.Application__r[0].Salary_Deductions__c;
                client.net_salary_income_month_1 = res.Application__r[0].Net_Salary_income_Month_1__c;
                client.net_salary_income_month_2 = res.Application__r[0].Net_Salary_income_Month_2__c;
                client.net_salary_income_month_3 = res.Application__r[0].Net_Salary_income_Month_3__c;
                client.salary_deducted_fixed_debit = res.Application__r[0].Salary_Deducted_Fixed_Debit__c;
                client.rental_income = res.Application__r[0].Rental_Income__c;
                client.other_additional_income = res.Application__r[0].Other_Additional_Income__c;
                client.total_net_monthly_income = res.Application__r[0].Total_Net_Monthly_Income__c;
                client.bond_mortgage = res.Application__r[0].Bond_Mortgage__c;
                client.loan_overdraft = res.Application__r[0].Loan_Overdraft__c;
                client.credit_cards = res.Application__r[0].Credit_Cards__c;
                client.asset_and_finance_repayment = res.Application__r[0].Asset_And_Finance_Repayment__c;
                client.retail_accounts = res.Application__r[0].Retail_Accounts__c;
                client.other_debt_repayment = res.Application__r[0].Other_Debt_Repayment__c;
                client.total_dept_repayment = res.Application__r[0].Total_Dept_Repayment__c;
                client.total_monthly_expenses = res.Application__r[0].Total_Monthly_Expenses__c;
                client.surplus_shortage = res.Application__r[0].Surplus_Shortage__c;
                
                //Screen 8
                /*client.application_number = res.Application__r[0].Application_Number__c;
                client.final_loan_amount = res.Application__r[0].Final_Loan_Amount__c;
                client.final_decision = res.Application__r[0].Final_Decision__c;
                client.reason = res.Application__r[0].Reason__c;
                client.first_payment_date = res.Application__r[0].First_Payment_Date__c;
                client.request_a_quote_to_be_issued = res.Application__r[0].Request_A_Quote_To_Be_Issued__c;
                client.request_a_quote_to_be_issued_values = this.setRadioBtnInput(component, client.request_a_quote_to_be_issued, client.request_a_quote_to_be_issued_values);*/
                component.set("v.client", client);
                
            }
            
        }
    },
    getFormattedDate: function(component, input_date) {
        var output_date = new Date(input_date);
        return output_date.getFullYear() + "/" + ("0" + (output_date.getMonth() + 1)).slice(-2) + "/" + ("0" + (output_date.getDate())).slice(-2);
    },
    getFormattedDate2: function(component, input_date, format) {    
        
        //dd/mm/yyyy - ddmmyyyy 1970/01/01
        if(input_date){
            if(format){
                var day = input_date.split(0,1);    
                var year = input_date.split(4,7);
                var month = input_date.split(2,3);  
                
                return  day+'/'+month+'/'+year;
            }else{
                return input_date.replace('/', '');
            }
        }
    },    
    setRadioBtnInput: function(component, input_val, check_list) {
        if(input_val == 'Y'){
            input_val = 'Yes';
        }
        else if(input_val == 'N'){
            input_val = 'No';
        }
        for (let i in check_list) {
            check_list[i].checked = (check_list[i].value == input_val) ? check_list[i].checked = true : check_list[i].checked = false;
        }
        return check_list;
    },
    updateClientDetailsAPIHelper: function(component, event) {
        
        var client = component.get("v.client");
        var action = component.get("c.updateClientInfoAPI");
        action.setParams({
            //clientData: client
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            
            var client = component.get("v.client");
            
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    
                } else {
                    this.messageModal(component, true, 'Update client details info message', res.Message);
                }
                
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'Update client details info error', errors[0].message);
            }
            
        });
        $A.enqueueAction(action);
    },
    /*
    Method does iigetficalistingdetailsv1 -- FICA service
    * @service name: iigetficalistingdetailsv1
    * @author Rakesh
    * @param
    * @return need to update
    */
    iigetFICAListingDetailsHelper: function(component, event, helper) {
        var client = component.get("v.client");
        var action = component.get("c.iigetFICAListingDetails");
        var clientData = '{"iiget_channel": "' + client.iiget_channel + '","iiget_application": "' + client.iiget_application + '","iiget_trace": "' + client.iiget_trace + '","iiget_inputClientCode": "' + client.iiget_inputClientCode + '"}';
        //var clientData = '{"IIgetFICAListingDetailsV1":{"nbsapdpi":{"channel":"Salesforce","application":"DIVE","trace":"Y"},"iip131i":{"inputClientCode":"12344"}}}';
        
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('ii FICA Helper object: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                
                if (res.IsSuccess) {
                    var obj = JSON.parse(res.Data.dataMap.getBody);
                    var getFICAListingDetailsResponse = obj.IIgetFICAListingDetailsV1Response.nbsapdpo;
                    client.iiget_nbsapdpo_returnCode = getFICAListingDetailsResponse.returnCode;
                    var getFICAListingDetailsResponse1 = obj.IIgetFICAListingDetailsV1Response.iip131o;
                    client.iiget_iip131o_returnCode = getFICAListingDetailsResponse1.returnCode;
                } else {
                    this.messageModal(component, true, 'SJM process blaze advisor message', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'SJM process blaze advisor details error', errors[0].message);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    /*Method does NHlistBalForAcctsLinkedToCombiV3 -- Customer Portfolio service
     * @service name: NHlistBalForAcctsLinkedToCombiV3
     * @author Rakesh
     * @param
     * @return need to update
     */
    nhListBalForAcctsLinkedToCombiHelper: function(component, event, helper) {
        
        var client = component.get("v.client");
        var action = component.get("c.nhListBalForAcctsLinkedToCombi");
        var clientData = '{"nh_list_bal_channel": "' + client.nh_list_bal_channel + '","nh_list_bal_application": "' + client.nh_list_bal_application + '","nh_list_bal_trace": "' + client.nh_list_bal_trace + '","nh_list_bal_log": "' + client.nh_list_bal_log + '","nh_list_bal_authenticate": "' + client.nh_list_bal_authenticate + '","nh_list_bal_accessNumber": "' + client.nh_list_bal_accessNumber + '","nh_list_bal_user": "' + client.nh_list_bal_user + '","nh_list_bal_division": "' + client.nh_list_bal_division + '","nh_list_bal_device": "' + client.nh_list_bal_device + '","nh_list_bal_origAddress": "' + client.nh_list_bal_origAddress + '","nh_list_bal_combiNumber": "' + client.nh_list_bal_combiNumber + '","nh_list_bal_language": "' + client.nh_list_bal_language + '","nh_list_bal_nbrOfRecsToRtrv": "' + client.nh_list_bal_nbrOfRecsToRtrv + '","nh_list_bal_pagingKey": "' + client.nh_list_bal_pagingKey + '"}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        
        console.log('nhListBal object: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                
                if (res.IsSuccess) {
                    var obj = JSON.parse(res.Data.dataMap.getBody);
                    var getnhlistBalForAcctsLinkedToCombiResponse = obj.NHlistBalForAcctsLinkedToCombiV3Response.nbsapdpo;
                    client.nh_list_bal_returnCode = getnhlistBalForAcctsLinkedToCombiResponse.returnCode;
                    component.set("v.client", client);
                } else {
                    this.messageModal(component, true, 'SJM save triad agreement details info message', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'SJM Save triad agreement details error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
    Method does NHlistAcctsLinkedToAPortfolioV5 -- Customer Portfolio service
    * @service name: NHlistAcctsLinkedToAPortfolioV5
    * @author Rakesh
    * @param
    * @return need to update
    */
    nhlistAcctsLinkedToAPortfolioHelper: function(component, event, helper) {
        var client = component.get("v.client");
        var action = component.get("c.nhlistAcctsLinkedToAPortfolio");
        var clientData = '{"nh_list_acc_channel": "' + client.nh_list_acc_channel + '","nh_list_acc_application": "' + client.nh_list_acc_application + '","nh_list_acc_trace": "' + client.nh_list_acc_trace + '","nh_list_acc_log": "' + client.nh_list_acc_log + '","nh_list_acc_authenticate": "' + client.nh_list_acc_authenticate + '","nh_list_acc_accessNumber": "' + client.nh_list_acc_accessNumber + '","nh_list_acc_user": "' + client.nh_list_acc_user + '","nh_list_acc_division": "' + client.nh_list_acc_division + '","nh_list_acc_device": "' + client.nh_list_acc_device + '","nh_list_acc_origAddress": "' + client.nh_list_acc_origAddress + '","nh_list_acc_combiNumber": "' + client.nh_list_acc_combiNumber + '","nh_list_acc_language": "' + client.nh_list_acc_language + '","nh_list_acc_operator": "' + client.nh_list_acc_operator + '","nh_list_acc_nbrOfRecsToRtrv": "' + client.nh_list_acc_nbrOfRecsToRtrv + '","nh_list_acc_pagingKey": "' + client.nh_list_acc_pagingKey + '"}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        
        console.log('nhListBal object: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                
                if (res.IsSuccess) {
                    var obj = JSON.parse(res.Data.dataMap.getBody);
                    var getnhListAcctsLinkedToAPortfolioResponse = obj.NHlistAcctsLinkedToAPortfolioV5Response.nbsapdpo;
                    client.nh_list_acc_returnCode = getnhListAcctsLinkedToAPortfolioResponse.returnCode;
                    var getnhListAcctsLinkedToAPortfolioResponse1 = obj.NHlistAcctsLinkedToAPortfolioV5Response.nhp020o;
                    client.nh_list_acc_rdesc = getnhListAcctsLinkedToAPortfolioResponse1.rdesc;
                } else {
                    this.messageModal(component, true, 'NH list accts linked to a portfolio info message', res.Message);
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'NH list accts linked to aPortfolio info details error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },   
    /*
   Method does ABFlistPortfolioAccountBalancesV1 -- Customer Portfolio service
   * @service name: ABFlistPortfolioAccountBalancesV1
   * @author Rakesh
   * @param
   * @return need to update
   */
    abfListPortfolioAccountBalancesHelper: function(component, event, helper) {
        var client = component.get("v.client");
        var action = component.get("c.abfListPortfolioAccountBalances");
        var clientData = '{"abf_consumerChannel": "' + client.abf_consumerChannel + '", "abf_providerApplication": "' + client.abf_providerApplication + '", "abf_traceIndicator": "' + client.abf_traceIndicator + '", "abf_messageLanguage": "' + client.abf_messageLanguage + '", "abf_messageTarget": "' + client.abf_messageTarget + '", "abf_accountNbr": "' + client.abf_accountNbr + '", "abf_clientCode": "' + client.abf_clientCode + '"}';
        clientData = clientData.replace(/undefined/g, ''); 
        clientData = clientData.replace(/null/g, '');                 
        console.log('abf List Portfolio Account Balances Detail Helper: ' + clientData);
        action.setParams({
            clientData: clientData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            var client = component.get("v.client");
            if (component.isValid() && state === "SUCCESS") {
                if (res.IsSuccess) {
                    if (res.Data.dataMap.getStatusCode == 200) {
                        var obj = JSON.parse(res.Data.dataMap.getBody);
                        var abfListPortfolioAccountBalanceResponse = obj.NBSAPDPO.NBSAPLO.serviceVersion;
                        
                    } else {
                        this.messageModal(component, true, 'ABF list portfolio balance response detial warning', res.Data.dataMap.getBody);
                    }
                } else {
                    this.messageModal(component, true, 'ABF list portfolio account balance response detail info message', res.Message);
                    
                }
            } else if (errors && errors.length > 0) {
                this.messageModal(component, true, 'ABF list portfolio account balance response detail error', errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    messageModal: function(component, isOpen, header, body) {
        component.set("v.modalObj", {  isOpen: isOpen,header: header, body: body });
        return;
    },
    
    validateMandatoryClientDetails: function(component, event) {
        var client = component.get("v.client"); 
        const isAlphaNumeric = ch => 
            {   
                return ch.match(/^[a-zA-Z0-9]+$/i) !== null;
            }
        const isNumeric = ch => 
            {   
                return ch.match(/^[0-9]+$/i) !== null;
            }
        if(!client.title_label){               
            component.set("v.client.title_validation", 'Select the Title');               
        }else{                
            component.set("v.client.title_validation", '');
        }
        if(!client.country_of_birth_label){               
            component.set("v.client.country_of_birth_validation", 'Select country of birth');                
        }else{                
            component.set("v.client.country_of_birth_validation", '');
        }
        if(!client.nationality_label){               
            component.set("v.client.nationality_validation", 'Select nationality');               
        }else{                
            component.set("v.client.nationality_validation", '');
        }
        if(!client.marital_status_label){               
            component.set("v.client.marital_status_validation", 'Select marital status');               
        }else{                
            component.set("v.client.marital_status_validation", '');
        }
        if(client.marital_status_label == 'Married'){
            if(!client.marital_contract_label){               
            component.set("v.client.marital_contract_validation", 'Select marital contract');               
        }
        else{                
            component.set("v.client.marital_contract_validation", '');
        }
        }
        
        if(!client.home_language_label){               
            component.set("v.client.home_language_validation", 'Select home language');                
        }else{                
            component.set("v.client.home_language_validation", '');
        }
        if(!client.dependents_label){                     
            component.set("v.client.dependents_validation", 'Select dependents');               
        }else{                
            component.set("v.client.dependents_validation", '');
        }           
        
        if(!client.nkin_first_name){  
            component.set("v.client.nkin_first_name_validation", 'Enter nkin first name');                
        }else{
                component.set("v.client.nkin_first_name_validation", '');
            }
        if(!client.nkin_surname){  
            component.set("v.client.nkin_surname_validation", 'Enter nkin surname');                
        }else{
                component.set("v.client.nkin_surname_validation", '');
            }
        if(!client.relationship_label){               
            component.set("v.client.relationship_validation", 'Select relationship');               
        }else{                
            component.set("v.client.relationship_validation", '');
        }
        if(!client.contact_number){               
            component.set("v.client.contact_number_validation", 'Enter contact number');                
        }else if(!isNumeric(client.contact_number.toString().replace(/\s/g, ''))){
            component.set("v.client.contact_number_validation", 'please enter numeric only'); 
        }
            else if((client.contact_number.toString().replace(/\s/g, '').length > 0) && (client.contact_number.toString().replace(/\s/g, '').length < 10)){
                component.set("v.client.contact_number_validation", 'please enter 10 digits');
            }
                else{                
                    component.set("v.client.contact_number_validation", '');
                }
        
        if(!client.communication_language_label){               
            component.set("v.client.communication_language_validation", 'Select communication language');                
        }else{                
            component.set("v.client.communication_language_validation", '');
        } 
        
        if(!client.insolvent){               
            component.set("v.client.insolvent_validation", 'Select insolvent');                
        }else{                
            component.set("v.client.insolvent_validation", '');
        } 
        if(!client.social_grant){               
            component.set("v.client.social_grant_validation", 'Select social grant');                
        }else{                
            component.set("v.client.social_grant_validation", '');
        } 
        if(!client.debt_counseling){               
            component.set("v.client.debt_counseling_validation", 'Select debt counseling');                
        }else{                
            component.set("v.client.debt_counseling_validation", '');
        } 
        if(!client.does_client_havepostmatric_qualification){               
            component.set("v.client.does_client_havepostmatric_qualification_validation", 'Select qualification');                
        }else{                
            component.set("v.client.does_client_havepostmatric_qualification_validation", '');
        }         
        if((client.does_client_havepostmatric_qualification == 'Y') || (client.does_client_havepostmatric_qualification == 'Yes')){      
            if(!client.post_matric_qualification_label){               
                component.set("v.client.post_matric_qualification_validation", 'Select qualification');                
            }else{                
                component.set("v.client.post_matric_qualification_validation", '');
            } 
        }else{//modified on 16/09/2020 by Thabo
            component.set("v.client.post_matric_qualification_validation", '');
        }
        if(!client.verify_client){               
            component.set("v.client.verify_client_validation", 'Select verify client');                
        }else{                
            component.set("v.client.verify_client_validation", '');
        }  
        //if ((!client.title_label) || (!client.country_of_birth_label) || (!client.nationality_label) || (!client.marital_status_label) || (!client.marital_contract_label) || (!client.home_language_label) || (client.dependents_label=='') || (!client.full_name) || (!client.relationship_label) || (!client.contact_number) || (!client.communication_language_label) || (!client.insolvent) || (!client.social_grant) || (!client.debt_counseling) || (!client.does_client_havepostmatric_qualification) || (!client.verify_client))
        if ((!client.title_label) || (!client.country_of_birth_label) || (!client.nationality_label) || (!client.marital_status_label) || (client.marital_contract_validation) || (!client.home_language_label) || (client.dependents_label=='') || (!client.nkin_first_name) || (!client.nkin_surname) || (!client.relationship_label) || (!client.contact_number) || (client.contact_number_validation) || (!client.communication_language_label) || (!client.insolvent) || (!client.social_grant) || (!client.debt_counseling) || (!client.does_client_havepostmatric_qualification) || (!client.verify_client) || (client.post_matric_qualification_validation))
        { 
            component.set("v.client_validation_check", true); 
        }
        else if((!isAlphaNumeric(client.nkin_first_name.toString().replace(/\s/g, ''))) || (!isAlphaNumeric(client.nkin_surname.toString().replace(/\s/g, ''))) || (!isNumeric(client.contact_number.toString().replace(/\s/g, '')))){
            component.set("v.client_validation_check", true); 
        }
            else{
                
                component.set("v.client_validation_check", false); 
            }
    },
    
    validateMandatoryContactDetails: function(component, event) {
        
        var client = component.get("v.client"); //
        
        const isNumeric = ch => 
            {   
                return ch.match(/^[0-9]+$/i) !== null;
            }
        const emailFormat = ch =>
            {
                return ch.match(/\S+@\S+\.\S+/) !== null;
            } 
        if(client.work_telephone_number){               
            if(!isNumeric(client.work_telephone_number.toString().replace(/\s/g, ''))){
                component.set("v.client.work_telephone_number_validation", 'Please enter 10 digits'); 
            }            
            else if((client.work_telephone_number.toString().replace(/\s/g, '').length > 0) && (client.work_telephone_number.toString().replace(/\s/g, '').length < 10)){
                component.set("v.client.work_telephone_number_validation", 'Please enter 10 digits');
            }
                else{
                    component.set("v.client.work_telephone_number_validation", '');
                } 
        } 
        if (client.work_telephone_number.length == 10){
            if (client.work_telephone_number.substring(0,1) != 0){component.set("v.client.work_telephone_number_validation", 'First number should be 0');}
        }
        
        if(client.home_telephone_number){               
            if(!isNumeric(client.home_telephone_number.toString().replace(/\s/g, ''))){
                component.set("v.client.home_telephone_number_validation", 'Please enter 10 digits'); 
            }            
            else if((client.home_telephone_number.toString().replace(/\s/g, '').length > 0) && (client.home_telephone_number.toString().replace(/\s/g, '').length < 10)){
                component.set("v.client.home_telephone_number_validation", 'Please enter 10 digits');
            }
                else{
                    component.set("v.client.home_telephone_number_validation", '');
                } 
        }  
         if (client.home_telephone_number.length == 10){
            if (client.home_telephone_number.substring(0,1) != 0){component.set("v.client.home_telephone_number_validation", 'First number should be 0');}
        }
        if (client.work_fax_number.length == 10){
            if (client.work_fax_number.substring(0,1) != 0){component.set("v.client.work_fax_number_validation", 'First number should be 0');}
        }
        
        if(client.work_fax_number){               
            if(!isNumeric(client.work_fax_number.toString().replace(/\s/g, ''))){
                component.set("v.client.work_fax_number_validation", 'Please enter 10 digits'); 
            }            
            else if((client.work_fax_number.toString().replace(/\s/g, '').length > 0) && (client.work_fax_number.toString().replace(/\s/g, '').length < 10)){
                component.set("v.client.work_fax_number_validation", 'Please enter 10 digits');
            }
                else{
                    component.set("v.client.work_fax_number_validation", '');
                } 
        } 
         if (client.work_fax_number.length == 10){
            if (client.work_fax_number.substring(0,1) != 0){component.set("v.client.work_fax_number_validation", 'First number should be 0');}
        }
         
        if(client.home_fax_number){               
            if(!isNumeric(client.home_fax_number.toString().replace(/\s/g, ''))){
                component.set("v.client.home_fax_number_validation", 'Please enter 10 digits'); 
            }            
            else if((client.home_fax_number.toString().replace(/\s/g, '').length > 0) && (client.home_fax_number.toString().replace(/\s/g, '').length < 10)){
                component.set("v.client.home_fax_number_validation", 'Please enter 10 digits');
            }
                else{
                    component.set("v.client.home_fax_number_validation", '');
                } 
        }  
          if (client.home_fax_number.length == 10){
            if (client.home_fax_number.substring(0,1) != 0){component.set("v.client.home_fax_number_validation", 'First number should be 0');}
        }
        
        
        if(!client.residential_address_country_label){               
            component.set("v.client.residential_address_country_validation", 'Select residential country'); 
            
        }else{                
            component.set("v.client.residential_address_country_validation", '');
        }        
        if(!client.residential_status_label){               
            component.set("v.client.residential_status_validation", 'Select residential status');  
        }else{                
            component.set("v.client.residential_status_validation", '');
        }
        if(!client.section_129_notice_delivery_address_label){               
            component.set("v.client.section_129_notice_delivery_address_validation", 'Select 129 address');  
        }else{                
            component.set("v.client.section_129_notice_delivery_address_validation", '');
        }
        if(!client.postal_address_line_1){               
            component.set("v.client.postal_address_line_1_validation", 'Enter postal address line 1');   
        }else{                
            component.set("v.client.postal_address_line_1_validation", '');
        }         
        if(!client.town_city_foreign_country){               
            component.set("v.client.town_city_foreign_country_validation", 'Enter town/city_foreign_country');            
        }else{                
            component.set("v.client.town_city_foreign_country_validation", '');
        }
        if(client.email_address){
            if(!emailFormat(client.email_address)){
                component.set("v.client.email_address_validation", 'enter valid email address'); 
            }
            else{
                component.set("v.client.email_address_validation", '');  
            }
        }
        if(!client.preffered_communication_channel_label){               
            component.set("v.client.preffered_communication_channel_validation", 'Select preferred channel'); 
        }else{                
            component.set("v.client.preffered_communication_channel_validation", '');
        }
        if(!client.credit_worthiness){               
            component.set("v.client.credit_worthiness_validation", 'Check Credit worthiness'); 
        }else{                
            component.set("v.client.credit_worthiness_validation", '');
        }
        if(!client.absa_group_electronic){               
            component.set("v.client.absa_group_electronic_validation", 'Check ABSA electronic'); 
        }else{                
            component.set("v.client.absa_group_electronic_validation", '');
        }
        
        if((!client.voice_recording) && (!client.email) && (!client.sms)){
            component.set("v.client.electronic_marketing_validation", 'Select one of the 3'); 
        }else{
            component.set("v.client.electronic_marketing_validation", '');
        }
        
        if((!client.residential_address_country_label)||
           (!client.residential_status_label)||
           (!client.section_129_notice_delivery_address_label)||
           (!client.postal_address_line_1)||
           (!client.town_city_foreign_country)||
           (!client.preffered_communication_channel_label)||
           (!client.credit_worthiness)||
           (!client.absa_group_electronic)||
           (client.email_address_validation)||
           (client.work_telephone_number_validation)||
           (client.home_telephone_number_validation)||
           (client.work_fax_number_validation) ||
           (client.home_fax_number_validation) ||
           (client.postal_address_line_2_validation) ) 
        {      
            component.set("v.client_validation_check", true); 
        }else{
            component.set("v.client_validation_check", false); 
            
            var validationConditions  = [!(client.voice_recording), !(client.email), !(client.sms)];
            if (validationConditions.includes(false)){
                component.set("v.client_validation_check", false);  
            } else{
                component.set("v.client_validation_check", true);  
            }            
        }       
        
    },
    
    validateMandatoryEmploymentDetails: function(component, event) {
        
        const isNumeric = ch => 
            {   
                return ch.match(/^[0-9]+$/i) !== null;
            }
                
        let client = component.get("v.client");
        if(!client.occupational_status_label){               
            component.set("v.client.occupational_status_validation", 'Select occupational status'); 
        }else{                
            component.set("v.client.occupational_status_validation", '');
        }
        if(!client.monthly_income_label){               
            component.set("v.client.monthly_income_validation", 'Select income range'); 
        }else{                
            component.set("v.client.monthly_income_validation", '');
        }
        if(!client.source_of_income_label){               
            component.set("v.client.source_of_income_validation", 'Select source of income'); 
        }else{                
            component.set("v.client.source_of_income_validation", '');
        }
        if(!client.frequency_of_income_label){               
            component.set("v.client.frequency_of_income_validation", 'Select frequency of income'); 
        }else{                
            component.set("v.client.frequency_of_income_validation", '');
        }
        if(!client.client_banks_with_absa){               
            component.set("v.client.client_banks_with_absa_validation", 'Choose client banks with absa'); 
        }else{                
            component.set("v.client.client_banks_with_absa_validation", '');
        }
        if(!client.empl_postal_address_line_1){               
            component.set("v.client.employers_name_validation", 'Enter employers name'); 
        }else{                
            component.set("v.client.employers_name_validation", '');
        }
        if(!client.empl_postal_address_line_1_3){               
            component.set("v.client.empl_postal_address_line_1_3_validation", 'Enter postal address'); 
        }else if((client.empl_postal_address_line_1_3.toUpperCase()).includes("EXT") || (client.empl_postal_address_line_1_3.toUpperCase()).includes("EXTENSION") || (client.empl_postal_address_line_1_3.toUpperCase()).includes("UITBR") || (client.empl_postal_address_line_1_3.toUpperCase()).includes("UITBREIDING")){
             component.set("v.client.empl_postal_address_line_1_3_validation", 'Not contain EXT, EXTENSION, UITBR, UITBREIDING'); 
        }else{                
            component.set("v.client.empl_postal_address_line_1_3_validation", '');
        }
        if(!client.empl_town_city_foreign_country){               
            component.set("v.client.empl_town_city_foreign_country_validation", 'Enter town/city'); 
        }else{                
            component.set("v.client.empl_town_city_foreign_country_validation", '');
        }

        //sa tax	
        if(client.client_registed_for_income_tax == "Y"){
            if((!client.sa_income_tax_number) && (!client.reason_sa_income_tax_number_not_given_value)){
                component.set("v.client.sa_tax_dropdown_validation", 'Provide either tax or reason');  
            } else if(!isNumeric(client.sa_income_tax_number.toString().replace(/\s/g, '')) && client.sa_income_tax_number.toString().length > 0){
                component.set("v.client.sa_tax_dropdown_validation", 'SA tax should be 10 digits'); 
            }else if(client.sa_income_tax_number.toString().length > 0 && client.sa_income_tax_number.toString().length < 10){            
                component.set("v.client.sa_income_tax_number_validation", "SA tax should be 10 digits");               
            }  else {
                component.set("v.client.sa_income_tax_number_validation", '');            
            }
        }else if (client.client_registed_for_income_tax == 'N'){
            component.set("v.client.sa_income_tax_number_validation", '');
            component.set("v.client.sa_tax_dropdown_validation", ''); 
        }else{
            component.set("v.client.client_registed_for_income_tax_validation", "Client registered should be Y/N");                        
        }
                
        if(client.client_registered_for_foreign_income_tax == "Y"){
            if((!client.foreign_income_tax_number) && (!client.reason_foreign_income_tax_num_not_given_value)){
                component.set("v.client.foreign_tax_dropdown_validation", 'Provide either tax or reason');            
            }else if(!isNumeric(client.foreign_income_tax_number.toString().replace(/\s/g, '')) && client.foreign_income_tax_number.toString().length >0){
                component.set("v.client.foreign_tax_dropdown_validation", 'Foreign tax should be 10 digits'); 
            }else if((!client.foreign_income_tax_number) && (!client.reason_foreign_income_tax_num_not_given_value)){
                component.set("v.client.foreign_tax_dropdown_validation", 'Provide either tax or reason');            
            }
                else if(client.foreign_income_tax_number.toString().length >0 && client.foreign_income_tax_number.toString().length <3){            
                    component.set("v.client.foreign_income_tax_number_validation", "At least 3 digits required");            
                }  else {
                    component.set("v.client.foreign_income_tax_number_validation", '');            
                }
        }else if (client.client_registered_for_foreign_income_tax == 'N'){
            component.set("v.client.foreign_income_tax_number_validation", '');
            component.set("v.client.foreign_tax_dropdown_validation", ''); 
        }else{
            component.set("v.client.client_registered_for_foreign_income_tax_validation", 'Foreign registered should be Y/N');                       
        }
        
        
        if (client.occupational_status_label && client.monthly_income_label && client.source_of_income_label && client.frequency_of_income_label && client.client_banks_with_absa && client.empl_postal_address_line_1 && !client.empl_postal_address_line_1_3_validation && client.empl_postal_address_line_1_3 && client.empl_town_city_foreign_country){   
            if(this.tax_validation(component,event,"SA",client.client_registed_for_income_tax)){
                component.set("v.client_validation_check", true);
            }else if(this.tax_validation(component,event,"Foreign",client.client_registered_for_foreign_income_tax)){
                component.set("v.client_validation_check", true);
            }else{
                component.set("v.client_validation_check", false);
            }            
        }else{
            component.set("v.client_validation_check", true); 
        }  
        
        component.set("v.client.products", "");
       
    },
    tax_validation: function(component,event,tax_type, tax_condition) {
        
        let client = component.get("v.client");
        
        const isNumeric = ch => 
            {   
                return ch.match(/^[0-9]+$/i) !== null;
            }
        
        if(tax_type == "SA"){
            
            if(tax_condition == "N"){               
                return false;
            }else if(tax_condition == "Y"){
                
                if(!isNumeric(client.sa_income_tax_number.toString().replace(/\s/g, '')) && client.sa_income_tax_number.toString().length >0){
                    return true; 
                }else if((!client.sa_income_tax_number) && (!client.reason_sa_income_tax_number_not_given_value)){
                    return true;            
                }
                    else if(client.sa_income_tax_number.toString().length > 0 && client.sa_income_tax_number.toString().length < 10){            
                        return true;             
                    }  else {
                        return false;            
                    }
            }else{
                return true; 
            }
            
            
        }else if(tax_type == "Foreign"){
            
            if(tax_condition == "N"){
                return false;
            }else if(tax_condition == "Y"){
                
                if(!isNumeric(client.foreign_income_tax_number.toString().replace(/\s/g, '')) && client.foreign_income_tax_number.toString().length >0){
                    return true; 
                }else if((!client.foreign_income_tax_number) && (!client.reason_foreign_income_tax_num_not_given_value)){
                    return true;             
                }
                    else if(client.foreign_income_tax_number.toString().length >0 && client.foreign_income_tax_number.toString().length <3){            
                        return true;            
                    }  else {
                        return false;           
                    }
                
            }else{
                return true; 
            }
            
        }
    },
    
    validateMandatoryproductSelectionDetails: function(component, event) {
        
        var client = component.get("v.client");
        if(component.get("v.client.products") != "00"){
            component.set("v.client.products_validation","Please select pesornal loan");
        }else{                
            component.set("v.client.products_validation", '');
        }    
        
        if(!client.i_accept_terms_and_conditions){               
            component.set("v.client.i_accept_terms_and_conditions_validation", 'Check accept and conditions'); 
            component.set("v.client.i_accept_terms_and_conditions_conditions", true);                                       
        }else{                
            component.set("v.client.i_accept_terms_and_conditions_validation", '');
            component.set("v.client.i_accept_terms_and_conditions_conditions", false);
        }
        if ((client.products_validation) || (client.i_accept_terms_and_conditions_validation))
        {      
            component.set("v.client_validation_check", true); 
        }else{
            component.set("v.client_validation_check", false); 
        }
    },
    
    validateMandatoryloanApplicationDetails: function(component, event) {
        
        const isNumeric = ch => 
            {   
                return ch.match(/^[0-9]+$/i) !== null;
            }
        
        var client = component.get("v.client");
        if(!client.purpose_of_loan_value){ 
            component.set("v.client.purpose_of_loan_validation", 'Select purpose of loan'); 
        }else{                
            component.set("v.client.purpose_of_loan_validation", '');
        }
        
        if (!client.absa_credit_life){      
            component.set("v.client.absa_credit_life_validation", "Please select absa credit life"); 
        }else{
            component.set("v.client.absa_credit_life_validation", ""); 
        }
        
        if(!client.other){
            component.set("v.client.other_validation", 'Enter other amount'); 
        }else if(!isNumeric(client.other.toString().replace(/\s/g, ''))){
            component.set("v.client.other_validation", 'Please enter amount');
        }else{
            component.set("v.client.other_validation", '');
        }
        let number_of_payments = component.get("v.client.number_of_payments_value");
        if(!number_of_payments){
            component.set("v.client.number_of_payments_validation", 'Enter number of payments'); 
        }else{
            component.set("v.client.number_of_payments_validation", '');
        }
        
        if(!client.initiation_fee_payment_method_label){
            component.set("v.client.initiation_fee_payment_method_validation", 'Please select payment method'); 
        }else{
            component.set("v.client.initiation_fee_payment_method_validation", '');
        }
        
        
        if(!client.additional_loan_amount){
            component.set("v.client.additional_loan_amount_validation", 'Enter additional amount'); 
        }else if(!isNumeric(client.additional_loan_amount.toString().replace(/\s/g, ''))){
            component.set("v.client.additional_loan_amount_validation", 'Please enter amount');
        }else{
            component.set("v.client.additional_loan_amount_validation", '');
        }
        
        if ((!client.purpose_of_loan_label) || 
            (!client.absa_credit_life) ||
            (!client.initiation_fee_payment_method_label) || 
            (!client.additional_loan_amount) || 
            ((client.additional_loan_amount) && 
             (!isNumeric(client.additional_loan_amount.toString().replace(/\s/g, ''))) ) || 
            (!number_of_payments) || (client.other && (!isNumeric(client.other.toString().replace(/\s/g, ''))) ))
        {      
            component.set("v.client_validation_check", true); 
        }else{
            component.set("v.client_validation_check", false); 
        }
    }, 
    
    validateMandatoryLivingExpenses: function(component, event) {
        
        const isNumeric = ch => 
            {   
                return ch.match(/^[0-9]+$/i) !== null;
            }
        
        var client = component.get("v.client");
        
        
        let groceries = component.get("v.client.groceries");
        if(!groceries){
            component.set("v.client.groceries_validation", 'Please enter groceries'); 
        }else if(groceries!=null?!isNumeric(groceries.toString().replace(/\s/g, '')): null){
            component.set("v.client.groceries_validation", 'Please enter number');
        }else{
            component.set("v.client.groceries_validation", '');
        }
        
        if ((!groceries) && (groceries!=null)?(!isNumeric(groceries.toString().replace(/\s/g, ''))): null)
        {      
            component.set("v.client_validation_check", true); 
        }else{
            component.set("v.client_validation_check", false); 
        }
        
    },
    validateMandatoryIncomeAndExpenses: function(component, event) {
        var client = component.get("v.client");
        
        
        let monthly_income_range_validation = component.get("v.client.monthly_income_range_validation");
        
        if (monthly_income_range_validation)
        {      
            component.set("v.client_validation_check", true); 
        }else{
            component.set("v.client_validation_check", false); 
        }
    },
    
    dateFormating: function(the_action,date_format,the_date) {
        if((!the_date) || (the_date == '0')){
            return '';
        }       
        if(the_action == "Front_End_Format"){
            if(date_format == "CCYYMMDD"){           //DD/MM/YYYY                    
                let string_date = the_date.toString();                                                    
                return string_date.substring(6, 8)+"/"+string_date.substring(4, 6)+"/"+string_date.substring(0, 4);
            }else if(date_format == "DDMMCCYY"){  //DD/MM/YYYY                    
                let string_date = the_date.toString();
                if (string_date.length < 8){                                   
                    return "0"+string_date.substring(0, 1)+"/"+string_date.substring(1, 3)+"/"+string_date.substring(3, 7);
                }
                else{                                 
                    return string_date.substring(0, 2)+"/"+string_date.substring(2, 4)+"/"+string_date.substring(4, 8);
                } 
            }else if(date_format == "DDCCYYMM"){  //DD/MM/YYYY
                
                let string_date = the_date.toString();
                if (string_date.length < 8){                                   
                    return "0"+string_date.substring(0, 1)+"/"+string_date.substring(5, 7)+"/"+string_date.substring(1, 5);
                }
                else{                                 
                    return string_date.substring(0, 2)+"/"+string_date.substring(6, 8)+"/"+string_date.substring(2, 6);
                } 
            }
            
        }else if(the_action == "Validate_And_Update"){            
            if(date_format == "DD/MM/YYYY"){    //CCYYMMDD                
                return the_date.substring(6, 10)+the_date.substring(3, 5)+the_date.substring(0, 2);
            }               
        }else if(the_action == "Save_To_Object"){ //YYYY/MM/DD             
            if(date_format == "DD/MM/YYYY"){
                return the_date.substring(6, 10)+"/"+the_date.substring(3, 5)+"/"+the_date.substring(0, 2);
            }
        }else if(the_action == "Object_To_Front_End"){ // YYYY/MM/DD
             if(date_format == "YYYY-MM-DD"){
                 return the_date.substring(8, 10)+"/"+the_date.substring(5, 7)+"/"+the_date.substring(0, 4);
             }

         }
    },
     generatePDFHelper: function(component, event, helper) { 
        var client = component.get("v.client");
        console.log('client id: '+client.profile_record_id);
 		var action = component.get("c.downloadPDF"); 
        action.setParams({
            recordId: client.profile_record_id
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
   
            if (component.isValid() && state === "SUCCESS") {
            	//alert('success1'); 
            }
        });
        $A.enqueueAction(action);     	
    },

    errorMessagesHelper: function(component, event, exceptionAPIName, obj, exceptionType) { 
                
        var client = component.get("v.client");
        
        this.stopSpinner(component, event);     
        this.setValidateErrors(component, event, exceptionAPIName, obj, exceptionType);
        if(exceptionType == 'obj'){
            let errorMessage = '';
           
            for(let i = 0; i < obj.statusMessage.error.length; i++){
                errorMessage = errorMessage + obj.statusMessage.error[i].reason[0] + "<br/>";               
            }
            
            if(errorMessage =="employerAddress fields must be empty if occupationStatus is not (01,02,03,08,09)<br/>"){
               errorMessage = "employerAddress fields must be empty if occupationStatus is not (Full time employed,Self employed professional,Self employed non-professional,Part time/contract worker,Temporary employed)";       
            }
            this.messageModal(component, true, exceptionAPIName, errorMessage);
            
        }else if(exceptionType == 'scoring_obj'){
            this.messageModal(component, true, exceptionAPIName, obj);
        }else if(exceptionType == 'res'){
            this.messageModal(component, true, exceptionAPIName, obj);
        }
         else if(exceptionType == 'errors'){
                this.messageModal(component, true, exceptionAPIName, obj);
         }
    },
    setValidateErrors: function(component, event, exceptionAPIName, obj, exceptionType) {
        component.set('v.exception_API_Name',exceptionAPIName);
        component.set('v.validate_update_obj',obj);
        component.set('v.validate_update_err_exceptionType',exceptionType);
    },
    getClientObject: function(component, event,val){
        
                let utilities = eval(val);
                
                let clientInit = utilities.getClientObj(); 
                
                let client = component.get("v.client"); 
                component.set("v.client", clientInit);
                
                client = component.get("v.client"); 
                client.title_values = utilities.getTitleValues();
                client.country_of_birth_values = utilities.getCountryOfBirthValues();
                client.dependents_values = utilities.getDependentValues();
                client.nationality_values = utilities.getNationalityValues();
                client.marital_status_values = utilities.getMaritalStatusValues();
                client.marital_contract_values = utilities.getMaritalContractValues();
                client.home_language_values = utilities.getHomeLanguageValues();
                client.relationship_values = utilities.getRelationshipValues();
                client.communication_language_values = utilities.getCommunicationLanguageValues();
                client.post_matric_qualification_values = utilities.getPostMatricQualificationValues();
                client.residential_address_country_values = utilities.getResidentialAddressCountryValues();
                client.residential_status_values = utilities.getResidentialStatusValues();
                client.preffered_communication_channel_values = utilities.getPrefferedCommunicationChannelValues();
                client.section_129_notice_delivery_address_values = utilities.getSection129NoticeDeliveryAddressValues();
                client.occupational_status_values = utilities.getOccupationalStatusValues();
                client.employment_sector_values = utilities.getEmploymentSectorValues();
                client.occupation_code_values = utilities.getOccupationCodeValues();
                client.occupation_level_values = utilities.getOccupationLevelValues();        
                client.monthly_income_values = utilities.getMonthlyIncomeValues();
                client.source_of_income_values = utilities.getSourceOfIncomeValues();
                client.frequency_of_income_values = utilities.getFrequencyOfIncomeValues();
                client.purpose_of_loan_values = utilities.getPurposeOfLoanValues();
                client.race_indicator_values = utilities.getRaceIndicatorValues();
                client.initiation_fee_payment_method_values = utilities.getInitiationFeePaymentMethodValues();
                client.reason_sa_income_tax_num_not_given_values = utilities.getReasonSATaxNotGivenValues();
                client.reason_foreign_income_tax_num_not_given_values = utilities.getReasonTaxNotGivenValues();
                client.occupation_values = utilities.getOccupationValues();       
                //
                client.id_type_values = utilities.getIdTypeValues();
                client.place_of_residence_values = utilities.getPlaceOfResidenceValues();
                client.customer_type_values = utilities.getCustomerTypeValues();
                client.gender_values = utilities.getGenderValues();
                client.payment_type_values = utilities.getPaymentTypeValues();
                client.payment_frequency_values = utilities.getPaymentFrequencyValues();
                client.number_of_payments_values = utilities.getNumberOfPaymentsValues();
                
                component.set("v.client", client); 
        
                this.getUserInfor(component, event);
                
        
    },
    afterScriptsLoadedHelper: function(component, event){
           var action = component.get("c.loadStaticResource");

            action.setParams({
                
            });
            action.setCallback(this, function(response) {
                
                
                let val = response.getReturnValue();
                
                this.getClientObject(component, event,val);
                
                component.set('v.validate_update_obj','');
                
                component.set("v.IdNumber","");
                
                component.set("v.IdNumber",null);
                
                component.set("v.searchCardVisible", '');  
                component.set("v.informationCardVisible", 'slds-hide');
                
                let clickedTab = "profile";
                
                let navLink = component.get("v.navLink");    
                let currindex = navLink[clickedTab];
                
                this.navigationHelper(component, event, currindex);  
        
            });
            $A.enqueueAction(action);
         
    },
    resetDashboard: function(component, event){
    
       component.set("v.client.id_number","");
        
       this.afterScriptsLoadedHelper(component, event);
        
    }
  
  
})