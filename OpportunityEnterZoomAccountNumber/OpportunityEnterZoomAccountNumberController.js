({
    doInit: function(component, event, helper) {
         component.find('callApexMethod')
             .CallApexMethod(component, 
                 'c.check',
                 {
                     'recordId': component.get('v.recordId'),
                 }, 
                 function (component, response) {
                     if (response.success) {
                         component.set('v.zoomAccountNumber', response.result);  
                     } else {
                         helper.showToastMessage({
                             type: "error",
                             message: response.errorMessage
                         });
                         $A.get("e.force:closeQuickAction").fire();
                     }
                 }
             );
     },
     cancel : function(component, event, helper) {
         var closeQuickActionEvt = $A.get("e.force:closeQuickAction");
         closeQuickActionEvt.fire();
     },
     closePage: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            var isconsole = response;
            if(isconsole) {
                workspaceAPI.getFocusedTabInfo().then(function(focusTab) {
                    var nav = $A.get("e.force:navigateToSObject");
                    nav.setParams({
                        "recordId": component.get('v.recordId')
                    });
                    nav.fire();

                    setTimeout(() => {
                        var focusedTabId = focusTab.tabId;
                        workspaceAPI.closeTab({tabId: focusedTabId});
                    }, 100);
                })
                .catch(function(error) {
                    console.log(error);
                });
            } else {
                var nav = $A.get("e.force:navigateToSObject");
                nav.setParams({
                    "recordId": component.get('v.recordId')
                });
                nav.fire();
            }
        })
        .catch(function(error) {
            console.log(error);
        });
    },     
     save : function(component, event, helper) {
         var zoomAccountNumber = component.get('v.zoomAccountNumber');
         if(zoomAccountNumber == null || zoomAccountNumber == '') {
             component.set('v.showError', true);
             component.set('v.errorMessage', 'Zoom Account Number should not be blank.');
             component.set('v.toastType', 'error'); 
             return;
         }
 
         component.find('callApexMethod')
             .CallApexMethod(component, 
                 'c.updateZoomAccountNumber',
                 {
                     'recordId': component.get('v.recordId'),
                     'zoomAccountNumber': zoomAccountNumber
                 }, 
                 function (component, response) {
                     if(response.success) {
                        
                        if(response.errorMessage=='Redirect to ZM'){
                            component.set('v.showZmselection', true);
                            component.set('v.toastType', 'warning');
                            component.set('v.errorMessage', 'A Zm Contract already exists for this Zoom Account Number, please [click here] to select this Zm Contract and associate it to this opportunity.');
                            //

                        } else {
                            component.set('v.showZmselection', false);
                            component.set('v.toastType', 'success');
                            component.set('v.errorMessage', 'Zoom Account Number updated successfully.');
                        }
                        component.set('v.showError', true);
                        component.set('v.isDone', true);
                     } else {
                        component.set('v.showError', true);
                        component.set('v.errorMessage', response.errorMessage);
                        component.set('v.toastType', 'error');  
                     }
                 }
             );
     } 
 })