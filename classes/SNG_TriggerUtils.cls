public class SNG_TriggerUtils {

	/**
     * Adds an error to both the errors Map<Id, errorString> as well as to the record itself
     *
     * @param     errors  Map<Id, errorString> to add the error to
     * @param     record  record to add the error on
     * @param     error   The error message to add
     */
    public static void addError(final Map<Id, String> errors, final sObject record, final String error) {
       // add to map
       errors.put(record.Id, error);

       // add to record
       record.addError(error, false);
    }

    public static boolean containsValidId(final Map<Id, SObject> origSObject, final List<SObject> updatedSObject)
    {
    	boolean isValid = !updatedSObject.isEmpty();
    	for (integer i = 0; i < updatedSObject.size() && isValid; ++i)
    	{
    	    Id updatedSObjectId = updatedSObject.get(i).id;
    		isValid = (null != updatedSObjectId && origSObject.containsKey(updatedSObjectId));
    	}
    	
    	return isValid;
    }

	public static boolean isInsert(final sObject oldSObject, final sObject newSObject) {
    	return isInsertTriggerContext() || isInsertTestContext(oldSObject, newSObject);
    }

    public static boolean isUpdate(final sObject oldSObject, final sObject newSObject) {
    	return isUpdateTriggerContext() || isUpdateTestContext(oldSObject, newSObject);
    }

    public static boolean isDelete(final sObject oldSObject, final sObject newSObject) {
    	return isDeleteTriggerContext() || isDeleteTestContext(oldSObject, newSObject);
    }

	private static boolean isInsertTriggerContext() {
		return (null != Trigger.isInsert) && Trigger.isInsert;
	}

	private static boolean isUpdateTriggerContext() {
		return (null != Trigger.isUpdate) && Trigger.isUpdate;
	}

	private static boolean isDeleteTriggerContext() {
		return (null != Trigger.isDelete) && Trigger.isDelete;
	}

	private static boolean isInsertTestContext(final sObject oldSObject, final sObject newSObject) {
		return Test.isRunningTest() && null == oldSObject && null != newSObject;
	}

	private static boolean isUpdateTestContext(final sObject oldSObject, final sObject newSObject) {
		return Test.isRunningTest() && null != oldSObject && null != newSObject;
	}

	private static boolean isDeleteTestContext(final sObject oldSObject, final sObject newSObject) {
		return Test.isRunningTest() && null != oldSObject && null == newSObject;
	}

}