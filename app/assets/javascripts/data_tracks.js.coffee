$ ->
  $('#tracks-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#tracks-table').data('source')
    pagingType: 'full_numbers'
    columnDefs: [{
        "bSortable": false,
        "aTargets": ['nosort']
    		}]