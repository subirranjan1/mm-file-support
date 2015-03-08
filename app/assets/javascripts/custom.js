$(document).ready(function () {
	$('.panel-collapse').on('show.bs.collapse', function(){
		$(this).parent().find("i").toggleClass('glyphicon-collapse-down glyphicon-collapse-up');
	});  
	$('.panel-collapse').on('hide.bs.collapse', function(){
		$(this).parent().find("i").toggleClass('glyphicon-collapse-down glyphicon-collapse-up');
	});
	$('#mytracks').dataTable({
	  // ajax: ...,
	  // autoWidth: false,
	  // pagingType: 'full_numbers',
	  // processing: true,
	  // serverSide: true,

	  // Optional, if you want full pagination controls.
	  // Check dataTables documentation to learn more about available options.
	  // http://datatables.net/reference/option/pagingType
	});
	// $('#tracks-table').dataTable({
	//   // ajax: ...,
	//   // autoWidth: false,
	//   // pagingType: 'full_numbers',
	//   // processing: true,
	//   // serverSide: true,
	// 	// "processing": true,
	// 	"ajax": {
	// 		"url": '/data_tracks/index_data_tables?basic=false',	
	// 		"dataSrc": ""
	// 	}
	// 	// "deferRender": true
	//   // Optional, if you want full pagination controls.
	//   // Check dataTables documentation to learn more about available options.
	//   // http://datatables.net/reference/option/pagingType
	// });
});