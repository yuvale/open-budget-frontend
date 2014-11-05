class TrainingView extends Backbone.View

    START_TRAINING_PARAMETER: 'startTraining=1'

    initialize: ->
        # Check if we have the 'start training' parameter in the URL query part.
        startTraining = @isParamInUrlQuery(@START_TRAINING_PARAMETER)

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
            newHash = '#'
            window.location = @buildTrainingUrl(newHash)

    isParamInUrlQuery: (param) ->
        query = window.location.search
        if query[0] == '?'
            query = query.substring(1)
        paramArray = query.split('&')
        return paramArray.indexOf(param) != -1

    getHashKind: ->
        hash = window.location.hash.substring(1)
        kind = hash.split("/",1)[0]
        return kind

    buildTrainingUrl: (newHash) ->
        addQueryParam = not @isParamInUrlQuery(@START_TRAINING_PARAMETER)
        url = window.location.href
        urlUpToHash = url.split('#', 1)[0]
        newUrl = urlUpToHash +
                 (if addQueryParam then '?' + @START_TRAINING_PARAMETER else '') +
                 newHash
        return newUrl

    startMainPageTraining: ->
        intro = @createIntroJsObject()
        intro.setOptions(
            steps: [
                {
                    intro: "כאן מתחילה ההדרכה של הדף הראשי."
                }
                {
                    element: document.querySelector('g[data-code="002026"]')
                    intro: "סעיף חינוך יסודי."
                }
            ]
        )
        intro.oncomplete( =>
            window.location = @buildTrainingUrl('#budget/008405/2014')
        )

        intro.start()

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
            nextLabel: "הבא&larr;"
            prevLabel: "הקודם&rarr;"
            doneLabel: "סיום"
            skipLabel: "יציאה"
            exitOnOverlayClick: false
            disableInteraction: false
        )
        return intro

$( ->
        console.log "initializing the training view"
        window.trainingView = new TrainingView({el: $("#intro-link"), model: window.pageModel})
)
