class TrainingView extends Backbone.View

    initialize: ->

    events:
        "click": "startIntro"

    startIntro: (event) ->
        event.preventDefault()

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

$( ->
        console.log "initializing the training view"
        window.trainingView = new TrainingView({el: $("#intro-link"), model: window.pageModel});
)
