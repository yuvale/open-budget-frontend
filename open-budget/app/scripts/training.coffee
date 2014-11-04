class TrainingView extends Backbone.View

    START_TRAINING_PARAMETER: 'startTraining=1'

    initialize: ->
        # Check if we have the 'start training' parameter in the URL query part.
        query = window.location.search
        if query[0] == '?'
            query = query.substring(1)
        param_array = query.split('&')
        startTraining = param_array.indexOf(@START_TRAINING_PARAMETER) != -1

        if not startTraining
            return

        # Start the appropriate training according to the hash kind.
        hashKind = @getHashKind()
        if hashKind == "main"
            @startMainPageTraining()
        else if hashKind == "budget"
            @startBudgetPageTraining()

    events:
        "click": "onTrainingButtonClick"

    onTrainingButtonClick: (event) ->
        event.preventDefault()

        # If we're on the main page, start the main page training.
        # Otherwise set the URL to the default page, with a parameter telling
        # to start the training.
        hashKind = @getHashKind()
        if hashKind == "main"
            @startMainPageTraining()
        else
            # TODO: Set to DEFAULT_HOME?
            window.location.hash = ''
            # Stick the parameters before the hash part.
            url = window.location.href
            url_parts = url.split('#', 1)
            if url_parts[1]
                rest = '#' + url_parts[1]
            else
                rest = ''
            new_url = url_parts[0] + '?' + @START_TRAINING_PARAMETER + rest
            window.location = new_url

    getHashKind: ->
        hash = window.location.hash.substring(1)
        kind = hash.split("/",1)[0]
        return kind

    startMainPageTraining: ->

    startBudgetPageTraining: ->
        intro = @createIntroJsObject()
        intro.setOptions(
            steps: [
                {
                    intro: "כאן מתחיל ה-intro"
                }
                {
                    element: document.querySelector("#vis-title")
                    intro: "שינויים בתקציב: תיאור וכו'"
                }
                {
                    element: document.querySelector("#list-title")
                    intro: [
                      "כאן אפשר לראות את רשימת השינויים. משום מה זה לא תמיד מופיע במקום הנכון."
                      "שורה שניה של ההסבר, לראות איך זה מתנהג עם ריבוי שורות."
                      ].join("\n")
                }
                {
                    element: document.querySelectorAll(".transfer-list-explanation-title")[2]
                    intro: "דברי הסבר להעברה"
                }
            ]
        )
        intro.start()

    createIntroJsObject: ->
        intro = introJs()
        intro.setOptions(
            nextLabel: "הבא"
            prevLabel: "הקודם"
            doneLabel: "סיום"
            skipLabel: "יציאה"
        )
        return intro

$( ->
        console.log "initializing the training view"
        window.trainingView = new TrainingView({el: $("#intro-link"), model: window.pageModel});
)
