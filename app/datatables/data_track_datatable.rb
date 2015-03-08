class DataTrackDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari
  def_delegators :@view, :link_to, :sensor_type_path, :mover_path
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['DataTrack.name', 'Take.name', 'SensorType.name', 'Mover.name', 'DataTrack.technician', 'DataTrack.recorded_on']
  end
  #name, take, project, sensors, movers, technician, recording data, tags
  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['DataTrack.name', 'Take.name', 'SensorType.name', 'Mover.name', 'DataTrack.technician', 'DataTrack.recorded_on']
  end
# project.name, taglist
  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name, record.take.name, record.sensor_types.map{|type| link_to(type.name, sensor_type_path(type)) }.join(", "), record.movers.map{|mover| link_to(mover.name, mover_path(mover)) }.join(", "),
          record.technician, record.recorded_on, record.take.movement_group.project.name, record.tag_list        
      ]
    end
  end

  def get_raw_records
    # update later to include filtering
    DataTrack.includes(:take, :sensor_types, :movers).references(:take, :sensor_types, :movers).distinct
    # if @current_user
    #   @data_tracks.select! { |data_track| data_track.public? or data_track.is_accessible_by?(@current_user)  }
    # else
    #   @data_tracks.select! { |data_track| data_track.public? }
    # end
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
