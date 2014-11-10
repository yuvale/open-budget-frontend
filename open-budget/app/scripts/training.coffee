class TrainingView extends Backbone.View

    initialize: ->
        @loadTour()

    events:
        "click": "onTrainingButtonClick"

    loadTour: ->
        $.get("training_steps.html", (data) =>
            steps = @html_to_steps(data)
            @initTour(steps)
        )

    initTour: (steps) ->
        tour = new Tour(
            steps: steps
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

    html_to_steps: (html_text) ->
        div = $('<div></div>').html(html_text)
        rows = div.find('tbody tr')

        # Row 0 is the header row.
        header_row = $(rows[0])
        field_names = ($(td).text() for td in header_row.find('td'))

        # Row 1 is the separator, skip it.
        rows = rows[2..]

        row_to_step = (row) ->
            values = ($.trim(td.innerHTML) for td in $(row).find('td'))
            values = ((if v is '' then undefined else v) for v in values)

            dict = {}
            for value, i in values
                field_name = field_names[i]
                dict[field_name] = value

            if not dict.path?
                return null

            step =
                title: dict.title
                content: dict.content
                path: dict.path
                element: dict.element_selector
                orphan: if not dict.element_selector? then true else undefined
                placement: dict.tooltip_placement
                duration: if dict.duration_ms? then parseInt(dict.duration_ms, 10) else undefined
                backdrop: dict.disable_backdrop != 'true'

        steps = []
        for row in rows
            step = row_to_step(row)
            steps.push(step) if step != null
        return steps

    onTrainingButtonClick: (event) ->
        event.preventDefault()
        @tour.restart()

$( ->
        console.log "initializing the training view"
        window.trainingView = new TrainingView({el: $("#intro-link"), model: window.pageModel})
)
