({
    clickCreateExpense: function(component, event, helper)
    {
        var validExpense = true;
        var nameField = component.find("expname");
        var expname = nameField.get("v.value");
        if($A.util.isEmpty(expname))
        {
            validExpense = false;
            nameField.set("v.errors", [{message:"Expense name can't be blank."}]);
        }
        else
        {
            nameField.set("v.errors", null);
        }
        if(validExpense){
            // Create the new expense
            var newExpense = component.get("v.newExpense");
            console.log("Create expense: " + JSON.stringify(newExpense));
            helper.createExpense(component, newExpense);
        }
    },
    createExpense: function(component, expense)
    {
        var theExpenses = component.get("v.expenses");

        // Copy the expense to a new object
        // THIS IS A DISGUSTING, TEMPORARY HACK
        var newExpense = JSON.parse(JSON.stringify(expense));

        theExpenses.push(newExpense);
        component.set("v.expenses", theExpenses);
    },
// Load expenses from Salesforce
    doInit: function(component, event, helper)
    {

        // Create the action
        var action = component.get("c.getExpenses");

        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.expenses", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });

        // Send action off to be executed
        $A.enqueueAction(action);
    }
});