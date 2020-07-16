trigger BookingsTrigger on Bookings__c(after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    /*
        Sameera Adusumilli : Release: (Q4FY20 - 2020/01/22) https://zoomvideo.atlassian.net/browse/ZBO-3525 User Attributes population on bookings
        Ashesh Ranga  : Release: (Q3FY20 - 2019/10/22) https://zoomvideo.atlassian.net/browse/ZBO-3557  Add 'Reporting Category' Levels to the Booking Object
        Ashesh Ranga  : Release: (Q2FY20 - 2019/10/25) https://zoomvideo.atlassian.net/browse/ZBO-2705  Government Booking Identification
        Rajeev Pandey : Release: (Q2FY20 - 2019/05/15) https://zoomvideo.atlassian.net/browse/ZBO-2164
        Rajeev Pandey : Release: (Q1FY20 - 2019/04/03) https://zoomvideo.atlassian.net/browse/ZBO-2042
        Rajeev Pandey : Release: (Q1FY20 - 2019/03/06) https://zoomvideo.atlassian.net/browse/ZBO-1720
        
    */

    if (TriggerByPassUtils.isByPassed('bookings__c')) {
        TriggerByPassUtils.UndoByPass('bookings__c');
        return;
    }

    List < Exception__c > lstException = new List < Exception__c > ();
    static String ACTIVE_STATUS = 'Active';
    static Decimal Ceiling_Conversion_Value;
    Id zoomUserId;
    Id mulesoftUserId;
    Id businessServicesProfileId;
    Set < Id > ownerIds = new Set < Id > ();
    map < String, Account > mapAccounts = new Map < String, Account > ();
    List < String > lstCouponCode = new List < String > ();
    map < String, Coupon__c > mapCoupon = new map < String, Coupon__c > ();
    Set < String > setIndirectAccounts = new Set < String > ();
    Set < Id > setSystemAdmins = new Set < Id > ();
    //below list holds all the bookings which need reporting category fields to be updated
    List<Bookings__c> bookingsListForRepCategoryUpdate = new List<Bookings__c>();
    List<Id> bookingIdsForRepCategoryAfterUpdateContext = new List<Id>();

    try {
        try {
            Ceiling_Conversion_Value = Decimal.valueOf(Label.Ceiling_Conversion_Value);
        } catch (Exception ex) {
            Ceiling_Conversion_Value = 16;
        }
        if (trigger.isBefore) {
            zoomUserId = UserUtils.zoomIntegrationUserId;
            mulesoftUserId = UserUtils.mulesoftIntegrationUserId;

            for (Profile p: [Select Id,name From Profile Where Name = 'Business Services Profile'
                    OR Name = 'System Administrator'
                    OR Name = 'Contract Management User'
                ]) {
                if (p != NULL) {
                    setSystemAdmins.add(p.Id);
                }
                if(p.name =='Business Services Profile'){
                    businessServicesProfileId = p.id;
                }
            }

            setIndirectAccounts.add('Reseller'.trim().toUpperCase());
            setIndirectAccounts.add('Indirect'.trim().toUpperCase());
            setIndirectAccounts.add('Sub-Reseller'.trim().toUpperCase());
            setIndirectAccounts.add('Distributor'.trim().toUpperCase());
            setIndirectAccounts.add('OEM'.trim().toUpperCase());

            if (trigger.isInsert || trigger.isUpdate) {
                for (Bookings__c obj: trigger.new) {
                    if (String.isNotBlank(obj.Zoom_Account_Number__c)) {
                        obj.Zoom_Account_Number__c = obj.Zoom_Account_Number__c.replace('.0', '');
                        obj.Zoom_Account_Number__c = obj.Zoom_Account_Number__c.trim();
                    }
                }
            }
            if (trigger.isInsert || trigger.isUpdate) {
                Set < String > setZoomAccountNumber = new Set < String > ();
                for (Bookings__c obj: trigger.new) {
                    obj.CurrencyIsoCode = 'USD';
                    if (String.isNotBlank(obj.Zoom_Account_Number_Formula__c)) {
                        setZoomAccountNumber.add(obj.Zoom_Account_Number_Formula__c);
                    }
                }
                if (setZoomAccountNumber != NULL && setZoomAccountNumber.size() > 0) {
                    for (Account acc: [SELECT Id, Coupon__c, Partner_Reseller_Account__r.Partner_Reseller_Account__c, Partner_Reseller_Account__r.Type,accountsource, Partner_Reseller_Account__c, Channel_Account_Owner__c, Zoom_Cloud__c,
                                                Zoom_Account_Number_Text__c, Company__c, Has_Default_Company__c, Zoom_Account_Number_Formula__c, Sales_Code__c, Owner.Email, Owner.Manager.Email, Type, OwnerId,
                            (Select Id, Coupon__c From Zuora__R00N40000001kyLcEAI__r WHERE Zuora__Status__c = 'Active'
                                AND Id != NULL Order By CreatedDate Limit 1)
                            FROM Account WHERE Zoom_Account_Number_Text__c IN: setZoomAccountNumber AND Zoom_Account_Number_Text__c != NULL
                        ]) {
                        if (String.isNotBlank(acc.Zoom_Account_Number_Text__c)) {
                            mapAccounts.put(acc.Zoom_Account_Number_Text__c, acc);
                        }
                    }
                }

                for (Bookings__c obj: trigger.new) {
                    if (String.isNotBlank(obj.Zoom_Account_Number_Formula__c)) {
                        Account accObj = mapAccounts.get(obj.Zoom_Account_Number_Formula__c);
                        if (accObj != NULL) {
                            obj.Account__c = accObj.Id;
                            obj.Company__c = accObj.Has_Default_Company__c ? NULL : accObj.Company__c;
                            obj.Billing_Account__c = accObj.Zuora__R00N40000001kyLcEAI__r != NULL && accObj.Zuora__R00N40000001kyLcEAI__r.size() > 0 ? accObj.Zuora__R00N40000001kyLcEAI__r.get(0).Id : NULL;
                            obj.Coupon__c = accObj.Zuora__R00N40000001kyLcEAI__r != NULL && accObj.Zuora__R00N40000001kyLcEAI__r.size() > 0 ? accObj.Zuora__R00N40000001kyLcEAI__r.get(0).Coupon__c : NULL;
                            if(trigger.isInsert) obj.Zoom_Cloud__c   = accObj.Zoom_Cloud__c;     //ZBO-2705 assign zoom cloud on booking from account ONLY incase of insert.
                            if (String.isNotBlank(obj.Coupon__c)) {
                                lstCouponCode.add(obj.Coupon__c);
                            }
                        }
                    }
                }

                if (lstCouponCode != NULL && lstCouponCode.size() > 0) {
                    List < Coupon__c > lstCoupon = [SELECT Id, Coupon_Code__c, Sales_Owner__c, Sales_Owner__r.isActive FROM Coupon__c WHERE Coupon_Code__c IN: lstCouponCode];
                    if (lstCoupon != NULL && lstCoupon.size() > 0) {
                        for (Coupon__c coupon: lstCoupon) {
                            if (String.isNotBlank(coupon.Coupon_Code__c)) {
                                String couponCode = coupon.Coupon_Code__c.trim().toUpperCase();
                                mapCoupon.put(couponCode, coupon);
                            }
                        }
                    }
                }
            }

            if (trigger.isInsert) {
                for (Bookings__c obj: trigger.new) {
                    if (String.isBlank(obj.Debug_Log__c)) {
                        obj.Debug_Log__c = '';
                    }
                    if (String.isNotBlank(obj.Zoom_Account_Number_Formula__c)) {
                        Account accObj = mapAccounts.get(obj.Zoom_Account_Number_Formula__c);
                        if (accObj != NULL) {
                            Id AccountOwnerId = accObj.OwnerId;
                            String accType = accObj.Type;
                            String orderType = obj.Order_Type__c;
                            String salesCode = accObj.Sales_Code__c;
                            orderType = String.isNotBlank(orderType) ? orderType.trim() : '';
                            Boolean isNewOrder = ('New Order'.equalsIgnoreCase(orderType) || 'New'.equalsIgnoreCase(orderType)) ? true : false;

                            if (!obj.isSplit__c) {
                                Boolean isOwnerPopulated = false;
                                if (!isOwnerPopulated && String.isNotBlank(obj.Coupon__c)) {
                                    String couponCode = obj.Coupon__c.trim().toUpperCase();
                                    Coupon__c coupon = mapCoupon.get(couponCode);
                                    if (!isOwnerPopulated && coupon != NULL && String.isNotBlank(coupon.Sales_Owner__c) && coupon.Sales_Owner__r.isActive) {
                                        obj.OwnerId = coupon.Sales_Owner__c;
                                        if (isNewOrder) {
                                            obj.Sales_Channel__c = 'Assisted';
                                        } else {
                                            obj.Sales_Channel__c = 'Direct Sales';
                                        }
                                        isOwnerPopulated = true;
                                        obj.Debug_Log__c = obj.Debug_Log__c + 'Assisted-1';
                                    }
                                }

                                if ('Y'.equalsIgnoreCase(obj.bookingexception__c) && String.isNotBlank(AccountOwnerId)) {
                                    obj.OwnerId = AccountOwnerId;
                                    obj.Sales_Channel__c = 'Direct Sales';
                                    isOwnerPopulated = true;
                                    obj.Debug_Log__c = obj.Debug_Log__c + 'Direct Sales-2';
                                }

                                if (!isOwnerPopulated && isNewOrder && String.isNotBlank(AccountOwnerId) && String.isNotBlank(accType) && setIndirectAccounts.contains(accType.trim().toUpperCase())) {
                                    obj.OwnerId = AccountOwnerId;
                                    obj.Sales_Channel__c = 'Indirect Sales';
                                    isOwnerPopulated = true;
                                    obj.Debug_Log__c = obj.Debug_Log__c + 'Indirect Sales-1';
                                }
                                if (!isOwnerPopulated && isNewOrder && obj.Amount__c <= Ceiling_Conversion_Value && String.isNotBlank(zoomUserId)) {
                                    obj.OwnerId = zoomUserId;
                                    obj.Sales_Channel__c = 'Online';
                                    isOwnerPopulated = true;
                                    obj.Debug_Log__c = obj.Debug_Log__c + 'Online-1';
                                }
                                if (!isOwnerPopulated && isNewOrder && obj.Amount__c > Ceiling_Conversion_Value && String.isNotBlank(AccountOwnerId)) {
                                    obj.OwnerId = AccountOwnerId;
                                    obj.Sales_Channel__c = 'Direct Sales';
                                    isOwnerPopulated = true;
                                    obj.Debug_Log__c = obj.Debug_Log__c + 'Direct Sales-3';
                                }
                                if (!isOwnerPopulated && !isNewOrder && String.isNotBlank(AccountOwnerId) && String.isNotBlank(accType) && setIndirectAccounts.contains(accType.trim().toUpperCase())) {
                                    obj.OwnerId = AccountOwnerId;
                                    obj.Sales_Channel__c = 'Indirect Sales';
                                    isOwnerPopulated = true;
                                    obj.Debug_Log__c = obj.Debug_Log__c + 'Indirect Sales-2';
                                }
                                if (!isOwnerPopulated && !isNewOrder && String.isNotBlank(zoomUserId) && zoomUserId.equals(AccountOwnerId)) {
                                    obj.OwnerId = zoomUserId;
                                    obj.Sales_Channel__c = 'Online';
                                    isOwnerPopulated = true;
                                    obj.Debug_Log__c = obj.Debug_Log__c + 'Online-2';
                                }
                                if (!isOwnerPopulated && !isNewOrder && String.isNotBlank(AccountOwnerId) && !AccountOwnerId.equals(zoomUserId)) {
                                    obj.OwnerId = AccountOwnerId;
                                    obj.Sales_Channel__c = 'Direct Sales';
                                    isOwnerPopulated = true;
                                    obj.Debug_Log__c = obj.Debug_Log__c + 'Direct Sales-4';
                                }

                                if (!'Indirect Sales'.equalsIgnoreCase(obj.Sales_Channel__c) && obj.Amount__c < 0) {
                                    obj.Sales_Channel__c = 'Online';
                                }
                            }
                            obj.Account_Owner_Manger_Email__c = accObj.Owner.Manager.Email;
                            obj.Account_Owner_Email__c = accObj.Owner.Email;
                        }
                    }
                }
            }

            if (trigger.isInsert || trigger.isUpdate) {
                for (Bookings__c obj: trigger.new) {
                    if (String.isNotBlank(obj.OwnerId)) {
                        try {
                            ownerIds.add(obj.OwnerId);
                        } catch (Exception ex) {

                        }
                    }

                    if (String.isNotBlank(obj.New_OwnerId__c)) {
                        try {
                            ownerIds.add(obj.New_OwnerId__c);
                        } catch (Exception ex) {

                        }
                    }
                }
            }

            Map < Id, User > mapOwners = new Map < Id, User > ();
            if (String.isNotBlank(zoomUserId)) {
                ownerIds.add(zoomUserId);
            }

            //AR - 07/15/2020 ZBO-6409 User Attributes - Add Fields and Values for Booking Stamp
            for (User u: [SELECT Id, IsActive, UserRole.Name, Email, FirstName,Region__c,Sub_region__c,Territory__c,Line_Size__c,Customer_Type__c,Vertical__c,Quota_Band__c, LastName, Division, Department, Sub_Division__c, ToLabel(Office_Location__c), 
                                    ManagerId, Manager.FirstName, Manager.LastName, Manager.Email, Manager_Manager__c, Manager_Manager__r.FirstName, Manager_Manager__r.LastName, Manager_Manager__r.Email, Function__c, Sales_Position__c, FP_A_Owner_Sub_Division__c
                          FROM User 
                          WHERE Id IN: ownerIds]) {
                mapOwners.put(u.Id, u);
            }

            if (trigger.isInsert) {
                for (Bookings__c obj: trigger.new) {
                    Id ownerId = obj.OwnerId;
                    if (mapOwners != NULL && mapOwners.containsKey(ownerId)) {
                        User u = mapOwners.get(ownerId);
                        if (u.isActive) {
                            String userRole = u.UserRole.Name;
                            userRole = String.isNotBlank(userRole) ? userRole.trim() : '';
                            if (userRole.containsIgnoreCase('Manager')) {
                                //AR - 07/15/2020 ZBO-6409 mapping 3 new fields as part of this ticket
                                obj.Function__c = u.Function__c;
                                obj.Sales_Position__c = u.Sales_Position__c;
                                obj.FP_A_Owner_Sub_Division__c = u.FP_A_Owner_Sub_Division__c;
                                obj.Owner_Division__c = u.Division;
                                obj.Owner_Department__c = u.Department;
                                obj.Owner_Sub_Division__c = u.Sub_Division__c;
                                obj.Owner_Manager__c = (String.isNotBlank(u.FirstName) ? u.FirstName : '') + ' ' + (String.isNotBlank(u.LastName) ? u.LastName : '');
                                obj.Owner_Manager_Id__c = u.Id;
                                obj.Owner_Manager_Email__c = u.Email;
                                obj.Owner_Office_Location__c = u.Office_Location__c;
                                obj.Owner_Manager_Manager__c = (String.isNotBlank(u.Manager.FirstName) ? u.Manager.FirstName : '') + ' ' + (String.isNotBlank(u.Manager.LastName) ? u.Manager.LastName : '');
                                obj.Owner_Manager_Manager_Id__c = u.ManagerId;
                                obj.Owner_Manager_Manager_Email__c = u.Manager.Email;
                                obj.Region__c = u.Region__c;
                                obj.Sub_region__c=u.Sub_region__c;
                                obj.Territory__c=u.Territory__c;
                                obj.Line_Size__c=u.Line_Size__c;
                                obj.Customer_Type__c=u.Customer_Type__c;
                                obj.Vertical__c=u.Vertical__c;
                                obj.Quota_Band__c=u.Quota_Band__c;
                            } else {
                                //AR - 07/15/2020 ZBO-6409 mapping 3 new fields as part of this ticket
                                obj.Function__c = u.Function__c;
                                obj.Sales_Position__c = u.Sales_Position__c;
                                obj.FP_A_Owner_Sub_Division__c = u.FP_A_Owner_Sub_Division__c;
                                obj.Owner_Division__c = u.Division;
                                obj.Owner_Department__c = u.Department;
                                obj.Owner_Sub_Division__c = u.Sub_Division__c;
                                obj.Owner_Manager__c = (String.isNotBlank(u.Manager.FirstName) ? u.Manager.FirstName : '') + ' ' + (String.isNotBlank(u.Manager.LastName) ? u.Manager.LastName : '');
                                obj.Owner_Manager_Id__c = u.ManagerId;
                                obj.Owner_Manager_Email__c = u.Manager.Email;
                                obj.Owner_Office_Location__c = u.Office_Location__c;
                                obj.Owner_Manager_Manager__c = (String.isNotBlank(u.Manager_Manager__r.FirstName) ? u.Manager_Manager__r.FirstName : '') + ' ' + (String.isNotBlank(u.Manager_Manager__r.LastName) ? u.Manager_Manager__r.LastName : '');
                                obj.Owner_Manager_Manager_Id__c = u.Manager_Manager__c;
                                obj.Owner_Manager_Manager_Email__c = u.Manager_Manager__r.Email;
                                obj.Region__c = u.Region__c;
                                obj.Sub_region__c=u.Sub_region__c;
                                obj.Territory__c=u.Territory__c;
                                obj.Line_Size__c=u.Line_Size__c;
                                obj.Customer_Type__c=u.Customer_Type__c;
                                obj.Vertical__c=u.Vertical__c;
                                obj.Quota_Band__c=u.Quota_Band__c;
                            }
                        } else {
                            User zoomUser = mapOwners.get(zoomUserId);
                            if (zoomUser != NULL) {
                                obj.OwnerId = zoomUser.Id;
                                obj.Sales_Channel__c = 'Online';
                                obj.Debug_Log__c = obj.Debug_Log__c + 'Online-3';
                                obj.Owner_Division__c = zoomUser.Division;
                                obj.Owner_Department__c = zoomUser.Department;
                                obj.Owner_Sub_Division__c = zoomUser.Sub_Division__c;
                                obj.Owner_Manager__c = (String.isNotBlank(zoomUser.Manager.FirstName) ? zoomUser.Manager.FirstName : '') + ' ' + (String.isNotBlank(zoomUser.Manager.LastName) ? zoomUser.Manager.LastName : '');
                                obj.Owner_Manager_Id__c = zoomUser.ManagerId;
                                obj.Owner_Manager_Email__c = zoomUser.Manager.Email;
                                obj.Owner_Office_Location__c = zoomUser.Office_Location__c;
                                obj.Owner_Manager_Manager__c = (String.isNotBlank(zoomUser.Manager_Manager__r.FirstName) ? zoomUser.Manager_Manager__r.FirstName : '') + ' ' + (String.isNotBlank(zoomUser.Manager_Manager__r.LastName) ? zoomUser.Manager_Manager__r.LastName : '');
                                obj.Owner_Manager_Manager_Id__c = zoomUser.Manager_Manager__c;
                                obj.Owner_Manager_Manager_Email__c = zoomUser.Manager_Manager__r.Email;
                                obj.Region__c = zoomUser.Region__c;
                                obj.Sub_region__c=zoomUser.Sub_region__c;
                                obj.Territory__c=zoomUser.Territory__c;
                                obj.Line_Size__c=zoomUser.Line_Size__c;
                                obj.Customer_Type__c=zoomUser.Customer_Type__c;
                                obj.Vertical__c=zoomUser.Vertical__c;
                                obj.Quota_Band__c=zoomUser.Quota_Band__c;
                            }
                        }
                    }
                }
            }

            if (trigger.isUpdate) {
                for (Bookings__c obj: trigger.new) {
                    Boolean currentApproved = obj.IsApproved__c;
                    Boolean oldApproved = trigger.oldMap.get(obj.Id).IsApproved__c;
                    if (!oldApproved && obj.IsApproved__c && String.isNotBlank(obj.New_OwnerId__c)) {
                        obj.OwnerId = obj.New_OwnerId__c;
                    }
                    Id ownerId = obj.OwnerId;
                    Id oldOwnerId = trigger.OldMap.get(obj.Id).OwnerId;
                    if (!oldOwnerId.equals(ownerId)) {
                        if (mapOwners != NULL && mapOwners.containsKey(ownerId)) {
                            User u = mapOwners.get(ownerId);
                            if (u.isActive) {
                                String userRole = u.UserRole.Name;
                                userRole = String.isNotBlank(userRole) ? userRole.trim() : '';
                                if (userRole.containsIgnoreCase('Manager')) {
                                    //AR - 07/15/2020 ZBO-6409 mapping 3 new fields as part of this ticket
                                    obj.Function__c = u.Function__c;
                                    obj.Sales_Position__c = u.Sales_Position__c;
                                    obj.FP_A_Owner_Sub_Division__c = u.FP_A_Owner_Sub_Division__c;
                                    obj.Owner_Division__c = u.Division;
                                    obj.Owner_Department__c = u.Department;
                                    obj.Owner_Sub_Division__c = u.Sub_Division__c;
                                    obj.Owner_Manager__c = (String.isNotBlank(u.FirstName) ? u.FirstName : '') + ' ' + (String.isNotBlank(u.LastName) ? u.LastName : '');
                                    obj.Owner_Manager_Id__c = u.Id;
                                    obj.Owner_Manager_Email__c = u.Email;
                                    obj.Owner_Office_Location__c = u.Office_Location__c;
                                    obj.Owner_Manager_Manager__c = (String.isNotBlank(u.Manager.FirstName) ? u.Manager.FirstName : '') + ' ' + (String.isNotBlank(u.Manager.LastName) ? u.Manager.LastName : '');
                                    obj.Owner_Manager_Manager_Id__c = u.ManagerId;
                                    obj.Owner_Manager_Manager_Email__c = u.Manager.Email;
                                    obj.Region__c = u.Region__c;
                                    obj.Sub_region__c=u.Sub_region__c;
                                    obj.Territory__c=u.Territory__c;
                                    obj.Line_Size__c=u.Line_Size__c;
                                    obj.Customer_Type__c=u.Customer_Type__c;
                                    obj.Vertical__c=u.Vertical__c;
                                    obj.Quota_Band__c=u.Quota_Band__c;
                                } else {
                                    //AR - 07/15/2020 ZBO-6409 mapping 3 new fields as part of this ticket
                                    obj.Function__c = u.Function__c;
                                    obj.Sales_Position__c = u.Sales_Position__c;
                                    obj.FP_A_Owner_Sub_Division__c = u.FP_A_Owner_Sub_Division__c;
                                    obj.Owner_Division__c = u.Division;
                                    obj.Owner_Department__c = u.Department;
                                    obj.Owner_Sub_Division__c = u.Sub_Division__c;
                                    obj.Owner_Manager__c = (String.isNotBlank(u.Manager.FirstName) ? u.Manager.FirstName : '') + ' ' + (String.isNotBlank(u.Manager.LastName) ? u.Manager.LastName : '');
                                    obj.Owner_Manager_Id__c = u.ManagerId;
                                    obj.Owner_Manager_Email__c = u.Manager.Email;
                                    obj.Owner_Office_Location__c = u.Office_Location__c;
                                    obj.Owner_Manager_Manager__c = (String.isNotBlank(u.Manager_Manager__r.FirstName) ? u.Manager_Manager__r.FirstName : '') + ' ' + (String.isNotBlank(u.Manager_Manager__r.LastName) ? u.Manager_Manager__r.LastName : '');
                                    obj.Owner_Manager_Manager_Id__c = u.Manager_Manager__c;
                                    obj.Owner_Manager_Manager_Email__c = u.Manager_Manager__r.Email;
                                    system.debug('Region');
                                    obj.Region__c = u.Region__c;
                                    obj.Sub_region__c=u.Sub_region__c;
                                    obj.Territory__c=u.Territory__c;
                                    obj.Line_Size__c=u.Line_Size__c;
                                    obj.Customer_Type__c=u.Customer_Type__c;
                                    obj.Vertical__c=u.Vertical__c;
                                    obj.Quota_Band__c=u.Quota_Band__c;
                                }
                            }
                        }
                    } else {
                        obj.Owner_Division__c = trigger.OldMap.get(obj.Id).Owner_Division__c;
                        obj.Owner_Department__c = trigger.OldMap.get(obj.Id).Owner_Department__c;
                        obj.Owner_Sub_Division__c = trigger.OldMap.get(obj.Id).Owner_Sub_Division__c;
                        obj.Owner_Manager__c = trigger.OldMap.get(obj.Id).Owner_Manager__c;
                        obj.Owner_Manager_Id__c = trigger.OldMap.get(obj.Id).Owner_Manager_Id__c;
                        obj.Owner_Manager_Email__c = trigger.OldMap.get(obj.Id).Owner_Manager_Email__c;
                        obj.Owner_Office_Location__c = trigger.OldMap.get(obj.Id).Owner_Office_Location__c;
                        obj.Region__c = trigger.OldMap.get(obj.Id).Region__c;
                        obj.Sub_region__c=trigger.OldMap.get(obj.Id).Sub_region__c;
                        obj.Territory__c=trigger.OldMap.get(obj.Id).Territory__c;
                        obj.Line_Size__c=trigger.OldMap.get(obj.Id).Line_Size__c;
                        obj.Customer_Type__c=trigger.OldMap.get(obj.Id).Customer_Type__c;
                        obj.Vertical__c=trigger.OldMap.get(obj.Id).Vertical__c;
                        obj.Quota_Band__c=trigger.OldMap.get(obj.Id).Quota_Band__c;
                    }

                    Id loginUserProfileId = UserInfo.getProfileId();
                    if (!setSystemAdmins.contains(loginUserProfileId)) {
                        if (obj.Deal_Registration__c != trigger.oldMap.get(obj.Id).Deal_Registration__c) {
                            obj.Deal_Registration__c = trigger.oldMap.get(obj.Id).Deal_Registration__c;
                        }
                        if (obj.Reseller_Carrier_Account__c != trigger.oldMap.get(obj.Id).Reseller_Carrier_Account__c) {
                            obj.Reseller_Carrier_Account__c = trigger.oldMap.get(obj.Id).Reseller_Carrier_Account__c;
                        }

                        if (obj.Referral_Partner_Account__c != trigger.oldMap.get(obj.Id).Referral_Partner_Account__c) {
                            obj.Referral_Partner_Account__c = trigger.oldMap.get(obj.Id).Referral_Partner_Account__c;
                        }
                        if (obj.Channel_Account_Owner__c != trigger.oldMap.get(obj.Id).Channel_Account_Owner__c) {
                            obj.Channel_Account_Owner__c = trigger.oldMap.get(obj.Id).Channel_Account_Owner__c;
                        }
                        if (obj.Distributor_Account__c != trigger.oldMap.get(obj.Id).Distributor_Account__c) {
                            obj.Distributor_Account__c = trigger.oldMap.get(obj.Id).Distributor_Account__c;
                        }
                        if (obj.Level_2_Referral_Partner_Account__c != trigger.oldMap.get(obj.Id).Level_2_Referral_Partner_Account__c) {
                            obj.Level_2_Referral_Partner_Account__c = trigger.oldMap.get(obj.Id).Level_2_Referral_Partner_Account__c;
                        }
                    }
                }
            }

            Set < Id > setAccountIds = new Set < Id > ();
            if (trigger.isInsert || trigger.isUpdate) {
                for (Bookings__c obj: trigger.new) {
                    obj.Period__c = FunctionsUtils.getQuarterOfYear(obj.booking_date__c);
                    obj.Period_Quarterly__c = FunctionsUtils.getQuarterOfYear(obj.booking_date__c);
                    obj.Period_Yearly__c = FunctionsUtils.getHalfYearlyOfYear(obj.booking_date__c);
                    obj.MapKey__c = obj.MapKey_Formula__c;
                    if (String.isNotBlank(obj.Account__c)) {
                        setAccountIds.add(obj.Account__c);
                    }
                }

                if (setAccountIds != NULL && setAccountIds.size() > 0) {
                    Map < Id, Zuora__Subscription__c > mapActiveSub = new Map < Id, Zuora__Subscription__c > ();
                    for (Account acc: [Select a.Subscription_Status__c, (Select Zuora__Status__c, Zuora__InitialTerm__c, Zuora__RenewalTerm__c From Zuora__Subscriptions__r Where Zuora__Status__c =: ACTIVE_STATUS ORDER BY CreatedDate DESC LIMIT 1) From Account a Where a.Id IN: setAccountIds]) {
                        Id accId = acc.Id;
                        List < Zuora__Subscription__c > lstSubs = acc.Zuora__Subscriptions__r;
                        if (lstSubs != NULL && lstSubs.size() > 0) {
                            mapActiveSub.put(accId, lstSubs.get(0));
                        }
                    }

                    for (Bookings__c obj: trigger.new) {
                        Id accId = obj.Account__c;
                        if (mapActiveSub.containsKey(accId)) {
                            Zuora__Subscription__c sub = mapActiveSub.get(accId);
                            if (sub != NULL) {
                                if (String.isBlank(obj.Initial_Term__c)) {
                                    obj.Initial_Term__c = sub.Zuora__InitialTerm__c;
                                }

                                if (String.isBlank(obj.Renewal_Term__c)) {
                                    obj.Renewal_Term__c = sub.Zuora__RenewalTerm__c;
                                }
                            }
                        }
                    }
                }
            }

            if (trigger.isInsert) {
                for (Bookings__c obj: trigger.new) {
                    if (!obj.isSplit__c) {
                        Account accObj = mapAccounts.get(obj.Zoom_Account_Number_Formula__c);
                        if (accObj != NULL) {
                                                        
                            if ('Reseller'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type) || 'Sub-Reseller'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                obj.Reseller_Carrier_Account__c = accObj.Partner_Reseller_Account__c;
                            } else if ('Carrier'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                obj.Reseller_Carrier_Account__c = accObj.Partner_Reseller_Account__c;
                            }

                            if ('Sub-Reseller'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                obj.Distributor_Account__c = accObj.Partner_Reseller_Account__r.Partner_Reseller_Account__c;
                            } else if ('Distributor'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                obj.Distributor_Account__c = accObj.Partner_Reseller_Account__c;
                            }
                            //Level 1 Field Population Logic
                            if ('Referral Partner'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                obj.Referral_Partner_Account__c = accObj.Partner_Reseller_Account__c;
                            } else if ('Direct'.equalsIgnoreCase(accObj.Type) && 'Reseller'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                obj.Referral_Partner_Account__c = accObj.Partner_Reseller_Account__c;
                            }
                             else if ('Sub-Agent'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                obj.Referral_Partner_Account__c = accObj.Partner_Reseller_Account__c;
                             }
                           
                            else if ('Direct Referral'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                obj.Referral_Partner_Account__c = accObj.Partner_Reseller_Account__c;
                               }
                            
                            
                            else if('Partner Referral Registration'.equalsIgnoreCase(accObj.accountsource) || 'Master Agent Referral Registration'.equalsIgnoreCase(accObj.accountsource) || 'Direct Referral Registration'.equalsIgnoreCase(accObj.accountsource))
                            {
                                obj.Referral_Partner_Account__c = accObj.Partner_Reseller_Account__c;
                            }
                            
                            //Level 2 Field population Logic(Changed as part of Referral Programs Phase 2)
                            if ('Sub-Agent'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type)) {
                                
                                obj.Level_2_Referral_Partner_Account__c=accObj.Partner_Reseller_Account__r.Partner_Reseller_Account__c;
                            
                            }
                            else if ('Sub-Reseller'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type) && 'Master Agent Referral Registration'.equalsIgnoreCase(accObj.accountsource)) {
        
                                obj.Level_2_Referral_Partner_Account__c=accObj.Partner_Reseller_Account__r.Partner_Reseller_Account__c;
                            
                            }
                            //Added by SA.Channel Type modifications(Referral Programs Phase 2 (ZBO-5345)
                                
                             if ('Master Agent Referral Registration'.equalsIgnoreCase(accObj.accountsource))
                              {
                                  obj.Channel_Type__c='Master Agent';
                              }
                            else if ('Direct Referral Registration'.equalsIgnoreCase(accObj.accountsource))
                            {
                                obj.Channel_Type__c='Direct Referral';
                            }
                             else if ('Partner Referral Registration'.equalsIgnoreCase(accObj.accountsource))
                            {
                                obj.Channel_Type__c='Referral';
                            }
                            
                             else if (('Federal Reseller Registration'.equalsIgnoreCase(accObj.accountsource) ||'Partner Resale Registration'.equalsIgnoreCase(accObj.accountsource) ) && String.isNotBlank(obj.Distributor_Account__c) )
                            {
                                obj.Channel_Type__c='Distributor';
                            }
                            else if (('Federal Reseller Registration'.equalsIgnoreCase(accObj.accountsource) ||'Partner Resale Registration'.equalsIgnoreCase(accObj.accountsource) ) && 'Reseller'.equalsIgnoreCase(accObj.Partner_Reseller_Account__r.Type) )
                            {
                                obj.Channel_Type__c='Reseller';
                            }
                            else if (String.isNotBlank(obj.Reseller_Carrier_Account__c) && 'Carrier'.equalsIgnoreCase(obj.Account__r.Partner_Reseller_Account__r.Type) )
                            {
                                obj.Channel_Type__c='Carrier';
                            }
                            else{
                                 obj.Channel_Type__c='None';
                               }
                            obj.Channel_Account_Owner__c = accObj.Channel_Account_Owner__c;
                        }

                        if (obj.OwnerId != zoomUserId && 'SALES'.equalsIgnoreCase(obj.Owner_Department__c) && ('Referral'.equalsIgnoreCase(obj.Channel_Type__c) || 'None'.equalsIgnoreCase(obj.Channel_Type__c)) || 'Direct Referral'.equalsIgnoreCase(obj.Channel_Type__c) || 'Master Agent'.equalsIgnoreCase(obj.Channel_Type__c)) {
                            obj.Sales_Channel_V2__c = 'Direct';
                        } else if (obj.OwnerId == zoomUserId && ('None'.equalsIgnoreCase(obj.Channel_Type__c) || 'Referral'.equalsIgnoreCase(obj.Channel_Type__c) || 'Direct Referral'.equalsIgnoreCase(obj.Channel_Type__c) || 'Master Agent'.equalsIgnoreCase(obj.Channel_Type__c) )) {
                            obj.Sales_Channel_V2__c = 'Online';
                        } else if (obj.OwnerId == zoomUserId && ('Reseller'.equalsIgnoreCase(obj.Channel_Type__c) ||
                                'Carrier'.equalsIgnoreCase(obj.Channel_Type__c) || 'ISV'.equalsIgnoreCase(obj.Channel_Type__c) || 'Distributor'.equalsIgnoreCase(obj.Channel_Type__c))) {
                            obj.Sales_Channel_V2__c = 'Indirect Online';
                        } else if (obj.OwnerId != zoomUserId && 'SALES'.equalsIgnoreCase(obj.Owner_Department__c) && !'Referral'.equalsIgnoreCase(obj.Channel_Type__c) && !'None'.equalsIgnoreCase(obj.Channel_Type__c)) {
                            obj.Sales_Channel_V2__c = 'Overlay';
                        } else {
                            obj.Sales_Channel_V2__c = NULL;
                        }
                        if (String.isBlank(obj.Transaction_Source__c)) {
                            obj.Transaction_Source__c = 'Online';
                        }
                    }
                    if (String.isNotBlank(obj.Channel_Account_Owner__c)) {
                        obj.Channel_Account_Owner_text__c = true;
                    }
                    //04/27/2020 AR: ZBO-6090 trigger reporting category logic in case of split bookings
                    if(obj.isSplit__c || obj.createdby.profileid == businessServicesProfileId) {
                        bookingsListForRepCategoryUpdate.add(obj);
                    }
                }
            }

            if (trigger.isUpdate) {
                for (Bookings__c obj: trigger.new) {
                    if (!obj.isSplit__c) {
                        Id ownerId = obj.OwnerId;
                        Id oldOwnerId = trigger.OldMap.get(obj.Id).OwnerId;
                        if (!oldOwnerId.equals(ownerId)) {
                            if (obj.OwnerId != zoomUserId && 'SALES'.equalsIgnoreCase(obj.Owner_Department__c) && ('Referral'.equalsIgnoreCase(obj.Channel_Type__c) || 'None'.equalsIgnoreCase(obj.Channel_Type__c) || 'Direct Referral'.equalsIgnoreCase(obj.Channel_Type__c) || 'Master Agent'.equalsIgnoreCase(obj.Channel_Type__c) )) {
                                obj.Sales_Channel_V2__c = 'Direct';
                            } else if (obj.OwnerId == zoomUserId && ('None'.equalsIgnoreCase(obj.Channel_Type__c) || 'Referral'.equalsIgnoreCase(obj.Channel_Type__c) ||  'Direct Referral'.equalsIgnoreCase(obj.Channel_Type__c) || 'Master Agent'.equalsIgnoreCase(obj.Channel_Type__c) )) {
                                obj.Sales_Channel_V2__c = 'Online';
                            } else if (obj.OwnerId == zoomUserId && ('Reseller'.equalsIgnoreCase(obj.Channel_Type__c) ||
                                    'Carrier'.equalsIgnoreCase(obj.Channel_Type__c) || 'ISV'.equalsIgnoreCase(obj.Channel_Type__c) || 'Distributor'.equalsIgnoreCase(obj.Channel_Type__c))) {
                                obj.Sales_Channel_V2__c = 'Indirect Online';
                            } else if (obj.OwnerId != zoomUserId && 'SALES'.equalsIgnoreCase(obj.Owner_Department__c) && !'Referral'.equalsIgnoreCase(obj.Channel_Type__c) && !'None'.equalsIgnoreCase(obj.Channel_Type__c)) {
                                obj.Sales_Channel_V2__c = 'Overlay';
                            } else {
                                obj.Sales_Channel_V2__c = NULL;
                            }
                        }
                    }
                    if (String.isNotBlank(obj.Channel_Account_Owner__c)) {
                        obj.Channel_Account_Owner_text__c = true;
                    }
                    //ZBO-3557 - Reporting category levels to booking records [below logic should handle this requirement when owner changes]
                    //04/27/2020 AR: ZBO-6090 trigger reporting category logic in case of account linkage
                    if(obj.OwnerId != trigger.OldMap.get(obj.Id).OwnerId || (obj.account__c !=null && trigger.OldMap.get(obj.Id).account__c == null)) {
                        bookingsListForRepCategoryUpdate.add(obj);
                    }
                    //ZBO-3557 - End
                }
            }
        } //Before trigger logic ends here
        // AR: 03/12/2020 - adding more conditions below so that this logic is not invoked when mulesoft loads bookings every morning.
        if(bookingsListForRepCategoryUpdate.size() > 0 && String.isNotBlank(mulesoftUserId) && mulesoftUserId != UserInfo.getUserId()) {
            BookingsTriggerHandler handler = new BookingsTriggerHandler();
            handler.processBookings(bookingsListForRepCategoryUpdate);
        }

        if(trigger.isAfter){
            if (trigger.isUpdate) {
                for (Bookings__c obj: trigger.new) {
                    if(obj.account__c !=null && trigger.OldMap.get(obj.Id).account__c == null) {
                        bookingIdsForRepCategoryAfterUpdateContext.add(obj.id);
                    }
                }
            }
        }
        //if there are any bookings which are linked to account
        if(bookingIdsForRepCategoryAfterUpdateContext.size() > 0) {
            BookingsReportingCategoryUtils handler = new BookingsReportingCategoryUtils();
            handler.processAfterUpdate(bookingIdsForRepCategoryAfterUpdateContext);
        }

    } catch (Exception ex) {
        lstException.add(new Exception__c(Message__c = FunctionsUtils.getExceptionMessage(ex)));
    }
    FunctionsUtils.insertException(lstException);
}
