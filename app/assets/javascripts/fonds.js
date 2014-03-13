$(document).ready(function() {

  $.jstree._themes = '/assets/jsTree/themes/';

  function reprocessWidths() {
    var width = $('#fonds-tree-wrapper').width();
    $('#fonds-tree-wrapper').css('height', 'auto');
    $('#main').css('left', width + 'px');
    $('#main-form-controls').css('left', width + 1 + 'px');
  }

  function cleanClassInfo() {
    $('tr.info').each(function() {
      $(this).removeClass('info');
    });
  }

  function disable_units_link(units) {
    if (units === 0) {
      $("#tab-units").parent().addClass('disabled');
      $("#tab-units").attr('href', '#');
    } else {
      $("#tab-units").parent().removeClass('disabled');
    }
  }

  var suffix = (location.pathname.split("/").length > 3) ? 'units' : 'fond',
  initial_node_id = location.pathname.split("/").slice(2, 3).pop(),
  initial_unit_id = location.pathname.split("/").slice(4, 5).pop(),
  tree_width = parseInt(localStorage.getItem('tree_width')) || 280;

  $('#fonds-tree-wrapper').css('width', tree_width);
  reprocessWidths();

  $("#fonds-tree").jstree({
    core: {
      initially_open: ["node-" + initial_node_id],
      strings: {
        loading: "Caricamento..."
      }
    },
    plugins: ["themes", "ui", "json_data"],
    themes: {
      theme: "apple",
      dots: false,
      icons: true
    },
    ui: {
      initially_select: ["#node-" + initial_node_id],
      "select_limit": 1
    },
    json_data: {
      ajax: {
        dataType: "json",
        url: '/fonds/' + initial_node_id + "/tree.json"
      }
    }
  }).bind("loaded.jstree", function() {
    $(this).find('a.changeable').each(function() {
      $(this).addClass('load-' + suffix);
      if (suffix === 'units') {
        $(this).attr("href", $(this).attr("href") + '/' + suffix);
      }

      var units_count = $(this).parent("li").data('units');
      if (units_count !== 0) {
        $(this).append(' <em>(' + units_count + ')</em>');
      }
    });

    units = $("#node-" + initial_node_id).data('units');
    disable_units_link(units);

  });

  /* Scroll to selected unit on page load */
  if (suffix === 'units' && initial_unit_id !== undefined) {
    $("#units-tree-wrapper").scrollTo($("#unit-" + initial_unit_id).parents('tr'), 800, {
      axis: 'y'
    });
  }

  /* Highlight current unit and scroll to it */
  $("#units-tree").on("click", ".load-unit", function() {
    cleanClassInfo();
    $(this).parents('tr').addClass('info');
    $("#units-tree-wrapper").scrollTo($(this).parents('tr'), 800, {
      axis: 'y'
    });
  });

  /* Update tabs links */
  $("#fonds-tree").on("click", ".load-fond", function() {
    href = $(this).attr('href');
    $('#tab-fonds').attr('href', href);
    $('#tab-units').attr('href', href + '/units');
  });

  $("#fonds-tree").on("click", ".load-units", function() {
    href = $(this).attr('href');
    tokens = href.split("/");
    tokens.pop();
    $('#tab-fonds').attr('href', tokens.join('/'));
    $('#tab-units').attr('href', href);
  });

  /* Disable tab-units if there is nothing */
  $("#fonds-tree").on("click", ".changeable", function() {
    units = $(this).parent().data('units');
    disable_units_link(units);
  });

  /* Load description of the first unit in the list */
  $('#units-tree').on('pjax:end', function() {
    $that = $('#units-tree').find('a.load-unit').first();
    if ($that.length !== 0) {
      $.pjax({
        url: '/fonds/' + $that.data('fond-id') + '/units/' + $that.data('id'),
        container: '#units-wrapper'
      });
      $("#units-tree-wrapper").scrollTo($("#unit-" + $that.data('id')).parents('tr'), 800, {
        axis: 'y'
      });
    } else {
      $("#units-wrapper").html('');
    }
  });

  /* Remember tree size */
  $("#fonds-tree-wrapper").resizable({
    handles: {
      'e': "#handle"
    },
    minWidth: 280,
    maxWidth: 760,
    resize: function() {
      reprocessWidths();
    },
    stop: function(event, ui) {
      localStorage.setItem('tree_width', ui.size.width);
    }
  });

  /* Re-select the tree node when pressing back button */
  /* TODO: fatto parzialmente. C'è da fixare back su units */
  $(window).on('pjax:popstate', function(event) {
    // Debug
    // console.log(event.state);

    fond = location.pathname.split("/").slice(2, 3).pop();
    $("#fonds-tree").jstree("deselect_all");
    $("#fonds-tree").jstree("select_node", "#node-" + fond);

    if (location.pathname.split("/").length > 4) {
      unit = location.pathname.split("/").slice(4, 5).pop();
      cleanClassInfo();
      $('#unit-' + unit).parents('tr').addClass('info');
      $("#units-tree-wrapper").scrollTo($("#unit-" + unit).parents('tr'), 800, {
        axis: 'y'
      });
    }
  });

});
