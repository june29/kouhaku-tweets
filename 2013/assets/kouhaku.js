$(function() {
  var categories = ["all", "goldenbomber", "jaeger", "funassyi", "ika", "momoclo", "perfume", "ayaseharuka", "arashi", "akb", "sub"];

  $.each(categories, function() {
    var category = this.toString();
    $("<div/>").addClass("chart").attr({id: category}).appendTo($("#charts"));

    $.getJSON("jsons/" + category + ".json", function(data) {
      new Highcharts.Chart({
        chart: {
          renderTo: category,
          type: "area"
        },
        title: {
          text: data.title
        },
        xAxis: {
          type: "datetime"
        },
        yAxis: {
          max: category == "all" ? 3500 : 3000,
          title: {
            text: "Number of tweets"
          }
        },
        series: [data.series]
      });
    });
  });
});
