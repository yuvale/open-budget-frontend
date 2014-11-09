class TrainingView extends Backbone.View

    initialize: ->
        @initTour()

    events:
        "click": "onTrainingButtonClick"

    initTour: ->
        mainPagePath = "#main//2014"

        mainPageSteps = [
            {
                orphan: true
                title: "שלום!"
                content: "כאן מתחילה ההדרכה של הדף הראשי."
            }
            {
                backdrop: false # Couldn't get it to work with svg.
                element: 'circle#bubble_008405'
                placement: "bottom"
                title: "פה יש עיגול"
                content: "סעיף מלוות פנים."
            }
            {
                orphan: true
                content: "כעת נעבור לדף של סעיף תקציבי. אנא המתינו..."
                duration: 2000
            }
        ]
        (step.path = mainPagePath) for step in mainPageSteps

        budgetPageSteps = [
            {
                orphan: true
                title: "שלום!"
                content: "כאן מתחילה ההדרכה של דף סעיף."
            }
            {
                element: "div.trans:eq(2)"
                placement: "bottom"
                title: "העברה"
                content: "טקסט כלשהו."
            }
        ]
        (step.path = "#budget/008405/2014") for step in budgetPageSteps

        lastStep =
            orphan: true
            content: "וזה הכל לבינתיים!"
            path: mainPagePath

        allSteps = [].concat(mainPageSteps, budgetPageSteps, [lastStep])

        tour = new Tour(
            steps: allSteps
            basePath: document.location.pathname
            backdrop: true
            backdropPadding: 5
            template: '<div class="popover" role="tooltip">
              <div class="arrow"></div>
              <h3 class="popover-title"></h3>
              <div class="popover-content"></div>
              <div class="popover-navigation">
                <div class="btn-group">
                  <button class="btn btn-sm btn-default" data-role="prev">&laquo; הקודם</button>
                  <button class="btn btn-sm btn-default" data-role="next">הבא &raquo;</button>
                  <button class="btn btn-sm btn-default"
                          data-role="pause-resume"
                          data-pause-text="Pause"
                          data-resume-text="Resume">Pause</button>
                </div>
                <button class="btn btn-sm btn-default" data-role="end">סיום</button>
              </div>
            </div>'
        )
        tour.init()
        @tour = tour
        return tour

    onTrainingButtonClick: (event) ->
        event.preventDefault()
        @tour.restart()

$( ->
        console.log "initializing the training view"
        window.trainingView = new TrainingView({el: $("#intro-link"), model: window.pageModel})
)
