$ ->
  $('#tracks-table').dataTable
    ajax: $('#tracks-table').data('source')
    columnDefs: [{
        "bSortable": false,
        "aTargets": ['nosort']
    		}]