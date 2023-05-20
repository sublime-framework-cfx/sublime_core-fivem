return {
    home = [==[{
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "type": "AdaptiveCard",
        "version": "1.4",
        "body": [
            {
                "type": "TextBlock",
                "text": "Server connection",
                "weight": "Bolder",
                "size": "Large"
            },
            {
                "type": "TextBlock",
                "text": "Welcome to the server, please login or create a new account!",
                "wrap": true
            },
            {
                "type": "Input.Text",
                "id": "username",
                "placeholder": "Username",
                "isVisible": true
            },
            {
                "type": "Input.Text",
                "id": "password",
                "placeholder": "Password",
                "isPassword": true,
                "isVisible": true
            }
        ],
        "actions": [
            {
                "id": "login",
                "type": "Action.Submit",
                "title": "Login"
            },
            {
                "id": "register",
                "type": "Action.Submit",
                "title": "Register"
            },
            {
                "id": "quit",
                "type": "Action.Submit",
                "title": "Quit"
            }
        ]
    }]==],
    register = [==[{
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "type": "AdaptiveCard",
        "version": "1.4",
        "body": [
            {
                "type": "TextBlock",
                "text": "Register",
                "weight": "Bolder",
                "size": "Large"
            },
            {
                "type": "TextBlock",
                "text": "Please enter your login information or create a new account!",
                "wrap": true
            },
            {
                "type": "Input.Text",
                "id": "username",
                "placeholder": "Username",
                "isVisible": true
            },
            {
                "type": "Input.Text",
                "id": "password",
                "placeholder": "Password",
                "isPassword": true,
                "isVisible": true
            },
            {
                "type": "Input.Text",
                "id": "confirm_password",
                "placeholder": "Confirm password",
                "isPassword": true,
                "isVisible": true
            }
        ],
        "actions": [
            {
                "type": "Action.Submit",
                "title": "Register",
                "data": {
                    "submit_type": "register"
                }
            },
            {
                "type": "Action.Submit",
                "title": "Cancel",
                "data": {
                    "submit_type": "cancel"
                }
            }
        ]
    }]==]
}