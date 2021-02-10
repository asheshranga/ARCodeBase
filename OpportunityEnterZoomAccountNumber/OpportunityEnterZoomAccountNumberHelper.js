({
    showToastMessage : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(params);
        toastEvent.fire();
    },
})