$(function() {
  var categories = ["all", "goldenbomber", "momoclo", "nana", "arashi", "akb", "perfume", "pamyu", "sub"];

  $.each(categories, function(index, category) {
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
          max: category == "all" ? 3000 : 1000,
          title: {
            text: "Number of tweets"
          }
        },
        series: [data.series]
      });
    });
  });
});
