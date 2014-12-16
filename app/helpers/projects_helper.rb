module ProjectsHelper
  def most_data_tracks
    current_most = 0
    @projects.each do |project|
      project.movement_groups.each do |group|
        if group.data_tracks.size > current_most
          current_most = group.data_tracks.size 
        end
      end
    end
    current_most
  end
  
  def group_link_or_name(take)
    if take.is_accessible_by?(@current_user) or take.public?
      link_to(truncate(take.name, length: 20), movement_group_path(take)) 
    else
      truncate(take.name, length: 20)
    end
  end
  
  def mova_url
    #"http://www.sfu.ca/~oalemi/movan/"
    #"http://142.58.181.193:8080/index.php"
    #"http://142.58.181.193/MovAn/movan/index.php"
    "http://209.87.60.87/Mova/index.php?"
  end
  
end
