$ ->
  $('#tracks-table').dataTable
    ajax: $('#tracks-table').data('source')
		"pagingType": "full_numbers"
		iTotalDisplayRecords: data.Count()
    columnDefs: [{
        "bSortable": false,
        "aTargets": ['nosort']
    		}]