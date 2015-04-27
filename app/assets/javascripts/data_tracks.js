jQuery(document).ready(function() {
  $('#tracks-table').dataTable({
    "processing": true,
    "serverSide": true,
		"bDeferRender": true,
		"bSortClasses": false,
    "ajax": $('#tracks-table').data('source'),
    "pagingType": "full_numbers",
    "columnDefs": [{
        "bSortable": false,
        "aTargets": ['nosort']
    		}]
  });
});